package com.ruoyi.ai.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.context.HitlContext;
import com.ruoyi.ai.entity.PendingAction;
import com.ruoyi.ai.mapper.PendingActionMapper;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.lang.reflect.Method;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * P7 HITL 待确认单服务（02 §13.4）。
 * confirm() 四道校验：归属本人 / 状态 PENDING / 未过期 / 工具在 hitl-tools 白名单。
 * 越权一律返回“操作不存在”，故意不泄露该 id 是否存在。
 * 反射重放的可达面只有 hitl-tools 白名单里那几方法，参数类型走静态白名单，不 Class.forName 任意类型。
 */
@Service
@RequiredArgsConstructor
public class PendingActionService {

    private static final Logger log = LoggerFactory.getLogger(PendingActionService.class);
    private static final String STATUS_PENDING = "PENDING";
    private static final int EXPIRE_MINUTES = 10;

    /** 反射重放允许的参数类型静态白名单；没登记的类型直接拒绝 */
    private static final Map<String, Class<?>> ALLOWED_TYPES = Map.ofEntries(
            Map.entry("java.lang.String", String.class),
            Map.entry("java.lang.Long", Long.class),
            Map.entry("java.lang.Integer", Integer.class),
            Map.entry("java.lang.Boolean", Boolean.class),
            Map.entry("java.lang.Short", Short.class),
            Map.entry("java.lang.Byte", Byte.class),
            Map.entry("java.lang.Double", Double.class),
            Map.entry("java.lang.Float", Float.class),
            Map.entry("java.lang.Character", Character.class),
            Map.entry("int", int.class),
            Map.entry("long", long.class),
            Map.entry("boolean", boolean.class),
            Map.entry("short", short.class),
            Map.entry("byte", byte.class),
            Map.entry("double", double.class),
            Map.entry("float", float.class),
            Map.entry("char", char.class));

    private final PendingActionMapper mapper;
    private final ApplicationContext applicationContext;
    private final ObjectMapper objectMapper;
    private final SmartCsProperties props;

    /** 挂起：只接受切面写入的类名/方法名/参数，绝不接受外部输入 */
    public PendingAction create(String toolName, String declaringClassName,
                                Object[] args, Class<?>[] paramTypes) throws Exception {
        PendingAction a = new PendingAction();
        a.setUserId(SecurityUtils.getUserId());
        a.setSessionId(ChatContext.getSessionId());
        a.setToolName(toolName);
        a.setTargetClass(declaringClassName);
        a.setParamTypes(Arrays.stream(paramTypes).map(Class::getName).collect(Collectors.joining(",")));
        a.setArgsJson(objectMapper.writeValueAsString(args == null ? new Object[0] : args));
        a.setSummary(summarize(toolName, args));
        a.setStatus(STATUS_PENDING);
        a.setExpireTime(LocalDateTime.now().plusMinutes(EXPIRE_MINUTES));
        mapper.insert(a);
        log.info("高危操作待确认单已创建 - actionId: {}, tool: {}, sessionId: {}",
                a.getActionId(), toolName, a.getSessionId());
        return a;
    }

    /** 确认：四道校验后反射重放原方法 */
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> confirm(Long actionId) {
        PendingAction a = mapper.selectById(actionId);
        Long currentUserId = SecurityUtils.getUserId();

        if (a == null) {
            throw new ServiceException("操作不存在");
        }
        if (!Objects.equals(a.getUserId(), currentUserId)) {
            log.warn("越权确认被拒 - actionId: {}, owner: {}, requester: {}",
                    actionId, a.getUserId(), currentUserId);
            throw new ServiceException("操作不存在");   // 故意不说“无权限”
        }
        if (!STATUS_PENDING.equals(a.getStatus())) {
            throw new ServiceException("该操作已处理");
        }
        if (a.getExpireTime() == null || a.getExpireTime().isBefore(LocalDateTime.now())) {
            mapper.updateStatus(actionId, "EXPIRED", null);
            throw new ServiceException("该操作已超时，请重新发起");
        }
        // 二次白名单校验：防改库把 tool_name 换成别的方法名来打反射
        if (!props.getAgent().getHitlTools().contains(a.getToolName())) {
            log.warn("白名单二次校验失败 - actionId: {}, tool: {}", actionId, a.getToolName());
            throw new ServiceException("不支持确认该操作");
        }

        try {
            HitlContext.markConfirmedReplay();
            ChatContext.setSessionId(a.getSessionId());   // 工具内部日志/事件仍带会话
            String result = invoke(a);
            mapper.updateStatus(actionId, "CONFIRMED", truncate(result, 2000));
            log.info("高危操作已确认执行 - actionId: {}, tool: {}, userId: {}",
                    actionId, a.getToolName(), currentUserId);
            return buildResult(a, "CONFIRMED", "操作已执行", result);
        } catch (Exception e) {
            log.error("高危操作确认执行失败 - actionId: {}, tool: {}", actionId, a.getToolName(), e);
            mapper.updateStatus(actionId, "FAILED", truncate(e.getMessage(), 2000));
            throw new ServiceException("操作执行失败：" + e.getMessage());
        } finally {
            HitlContext.clear();
            ChatContext.clear();
        }
    }

    /** 取消：不执行，只做归属与状态校验 */
    public Map<String, Object> cancel(Long actionId) {
        PendingAction a = mapper.selectById(actionId);
        Long currentUserId = SecurityUtils.getUserId();
        if (a == null) {
            throw new ServiceException("操作不存在");
        }
        if (!Objects.equals(a.getUserId(), currentUserId)) {
            log.warn("越权取消被拒 - actionId: {}, owner: {}, requester: {}",
                    actionId, a.getUserId(), currentUserId);
            throw new ServiceException("操作不存在");
        }
        if (!STATUS_PENDING.equals(a.getStatus())) {
            throw new ServiceException("该操作已处理");
        }
        if (a.getExpireTime() == null || a.getExpireTime().isBefore(LocalDateTime.now())) {
            mapper.updateStatus(actionId, "EXPIRED", null);
            throw new ServiceException("该操作已超时，请重新发起");
        }
        mapper.updateStatus(actionId, "CANCELLED", "用户取消");
        log.info("高危操作已取消 - actionId: {}, tool: {}, userId: {}", actionId, a.getToolName(), currentUserId);
        return buildResult(a, "CANCELLED", "操作已取消", "用户取消");
    }

    /** 查自己的待确认操作（刷新页面后恢复卡片用） */
    public List<PendingAction> listPending(String status) {
        Long userId = SecurityUtils.getUserId();
        String st = (status == null || status.isBlank()) ? STATUS_PENDING : status.trim();
        LambdaQueryWrapper<PendingAction> qw = new LambdaQueryWrapper<>();
        qw.eq(PendingAction::getUserId, userId)
                .eq(PendingAction::getStatus, st);
        if (STATUS_PENDING.equals(st)) {
            // 列表只回未过期的待确认单，过期卡不再出现在前端（confirm/cancel 仍会翻 EXPIRED）
            qw.gt(PendingAction::getExpireTime, LocalDateTime.now());
        }
        qw.orderByDesc(PendingAction::getActionId)
                .last("LIMIT 50");
        return mapper.selectList(qw);
    }

    /** 反射重放原方法；参数类型必须命中静态白名单 */
    private String invoke(PendingAction a) throws Exception {
        Class<?> clazz = Class.forName(a.getTargetClass());
        Object bean = applicationContext.getBean(clazz);      // 拿代理实例，切面照常生效
        String rawTypes = a.getParamTypes() == null ? "" : a.getParamTypes();
        Class<?>[] types = Arrays.stream(rawTypes.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .map(this::resolveType)
                .toArray(Class[]::new);
        Method m = clazz.getMethod(a.getToolName(), types);
        JsonNode arr = objectMapper.readTree(a.getArgsJson());
        Object[] args = new Object[types.length];
        for (int i = 0; i < types.length; i++) {
            args[i] = objectMapper.convertValue(arr.get(i), types[i]);
        }
        Object r = m.invoke(bean, args);
        return r == null ? "" : (r instanceof String s ? s : objectMapper.writeValueAsString(r));
    }

    private Class<?> resolveType(String name) {
        Class<?> c = ALLOWED_TYPES.get(name);
        if (c == null) {
            // 宁可挂掉也不要 Class.forName 去加载任意类名
            throw new ServiceException("不支持的参数类型: " + name);
        }
        return c;
    }

    /** 摘要用手写映射，不用模型生成 */
    private String summarize(String tool, Object[] args) {
        return switch (tool) {
            case "cancelOrder" -> "取消订单 " + arg(args, 0);
            case "payOrder" -> "支付订单 " + arg(args, 0);
            case "clearCart" -> "清空购物车（该操作不可恢复）";
            case "checkoutFromCart" -> "用购物车内全部商品下单";
            default -> "执行操作 " + tool;
        };
    }

    private String arg(Object[] args, int i) {
        return (args != null && args.length > i && args[i] != null) ? String.valueOf(args[i]) : "";
    }


    /** 组装确认/取消结果：给前端卡片原地更新用，不再把工具原始 JSON 原文直接展示 */
    private Map<String, Object> buildResult(PendingAction a, String status, String message, String rawResult) {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("actionId", a.getActionId());
        data.put("toolName", a.getToolName());
        data.put("status", status);
        data.put("message", message);
        String safe = rawResult == null ? "" : rawResult;
        data.put("result", safe);
        if (!safe.isBlank()) {
            try {
                JsonNode node = objectMapper.readTree(safe);
                if (node.isObject()) {
                    if (node.has("orderNo")) data.put("orderNo", node.get("orderNo").asText());
                    else if (node.has("order_no")) data.put("orderNo", node.get("order_no").asText());
                    if (node.has("logisticsNo")) data.put("logisticsNo", node.get("logisticsNo").asText());
                    else if (node.has("logistics_no")) data.put("logisticsNo", node.get("logistics_no").asText());
                    if (node.has("totalAmount")) data.put("totalAmount", node.get("totalAmount").asText());
                    else if (node.has("total_amount")) data.put("totalAmount", node.get("total_amount").asText());
                }
            } catch (Exception ignored) {
                // 结果不是 JSON（如纯文本“订单已取消”），直接展示原文即可
            }
        }
        return data;
    }
    private String truncate(String text, int maxLength) {
        if (text == null) return null;
        return text.length() > maxLength ? text.substring(0, maxLength) : text;
    }
}
