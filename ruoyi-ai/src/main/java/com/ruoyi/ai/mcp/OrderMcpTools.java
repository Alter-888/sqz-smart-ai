package com.ruoyi.ai.mcp;

import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.entity.ToolCallLog;
import com.ruoyi.ai.event.ToolCallEvent;
import com.ruoyi.ai.mapper.OrderToolMapper;
import com.ruoyi.ai.mapper.ToolCallLogMapper;
import com.ruoyi.ai.util.SensitiveDataMasker;
import com.ruoyi.business.entity.Order;
import com.ruoyi.business.service.OrderService;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * MCP 订单工具：为 AI 提供订单查询、物流查询、取消订单、确认收货能力
 * 通过 MCP 协议暴露，同时支持 MethodToolCallbackProvider 直接调用
 */
@Component
@RequiredArgsConstructor
public class OrderMcpTools {

    private static final Logger log = LoggerFactory.getLogger(OrderMcpTools.class);

    private final OrderService orderService;
    private final OrderToolMapper orderToolMapper;
    private final ToolCallLogMapper toolCallLogMapper;
    private final ApplicationEventPublisher eventPublisher;

    private void logToolCall(String toolName, String params, boolean success, long durationMs, String errorMsg) {
        try {
            ToolCallLog callLog = new ToolCallLog();
            callLog.setToolName(toolName);
            callLog.setToolParams(params);
            callLog.setSessionId(ChatContext.getSessionId());
            callLog.setSuccessFlag(success ? 1 : 0);
            callLog.setDurationMs(durationMs);
            callLog.setErrorMsg(errorMsg);
            toolCallLogMapper.insert(callLog);
        } catch (Exception e) {
            log.warn("记录工具调用日志失败: {}", e.getMessage());
        }
    }

    private void publishToolCallEvent(String toolName, String description) {
        publishToolCallEvent(toolName, description, null, null);
    }

    private void publishToolCallEvent(String toolName, String description,
                                       String cardType, List<Map<String, Object>> cardData) {
        try {
            Long sessionId = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, toolName, description, sessionId, cardType, cardData));
        } catch (Exception e) {
            log.warn("发布工具调用事件失败: {}", e.getMessage());
        }
    }

    private void publishToolCallEvent(String toolName, String description, List<String> refreshTypes) {
        try {
            Long sessionId = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, toolName, description, sessionId, null, null, refreshTypes));
        } catch (Exception e) {
            log.warn("发布工具调用事件失败: {}", e.getMessage());
        }
    }

    @Tool(description = "根据订单编号查询订单详情，包括订单状态、商品列表、金额、物流信息。当用户询问某个订单的信息时使用此工具。")
    public Map<String, Object> queryOrder(
            @ToolParam(description = "订单编号，如 ORD20250001") String orderNo) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        log.info("工具调用 - 查询订单: {}", orderNo);
        try {
            Map<String, Object> order = orderToolMapper.findByOrderNo(orderNo);
            if (order == null) {
                ChatContext.addToolCallName("queryOrder");
                return Map.of("error", "未找到订单: " + orderNo);
            }
            Long currentUserId = SecurityUtils.getUserId();
            if (!SecurityUtils.isAdmin(currentUserId)) {
                Object orderUserId = order.get("user_id");
                if (orderUserId != null && !currentUserId.equals(Long.valueOf(orderUserId.toString()))) {
                    ChatContext.addToolCallName("queryOrder");
                    return Map.of("error", "您无权查看该订单");
                }
            }
            SensitiveDataMasker.maskOrderData(order);
            publishToolCallEvent("queryOrder", "查询到订单 " + orderNo, "order", List.of(order));
            ChatContext.addToolCallName("queryOrder");
            return order;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryOrder", orderNo, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "查询当前用户的订单列表，可按状态筛选。当用户想查看自己的订单或按状态查询（如待付款、已发货）时使用此工具。")
    public List<Map<String, Object>> queryUserOrders(
            @ToolParam(required = false, description = "订单状态筛选，可选值：PENDING(待付款)、PAID(已付款)、SHIPPED(已发货)、DELIVERED(已签收)、CANCELLED(已取消)、REFUNDED(已退款)。不传则查全部。") String status) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 查询用户订单列表, userId: {}", userId);
        try {
            var page = orderService.listUserOrders(userId, 1, 20, null, status);
            List<Order> orders = page.getRecords();
            if (orders.isEmpty()) {
                ChatContext.addToolCallName("queryUserOrders");
                return List.of(Map.of("message", "您暂无订单"));
            }
            List<Map<String, Object>> result = orders.stream().map(o -> {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("orderId", o.getOrderId());
                map.put("orderNo", o.getOrderNo());
                map.put("totalAmount", o.getTotalAmount());
                map.put("status", o.getStatus());
                map.put("createTime", o.getCreateTime() != null ? o.getCreateTime().toString() : "");
                SensitiveDataMasker.maskOrderData(map);
                return (Map<String, Object>) map;
            }).collect(Collectors.toList());
            publishToolCallEvent("queryUserOrders", "查询到 " + result.size() + " 个订单", "order", result);
            ChatContext.addToolCallName("queryUserOrders");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryUserOrders", "userId=" + userId + ",status=" + status, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "查询订单的物流配送信息。当用户询问快递物流进度时使用此工具。")
    public Map<String, Object> queryLogistics(
            @ToolParam(description = "订单编号") String orderNo) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        log.info("工具调用 - 查询物流信息: {}", orderNo);
        try {
            Order order = orderService.getByOrderNo(orderNo);
            if (order == null) {
                ChatContext.addToolCallName("queryLogistics");
                return Map.of("error", "未找到订单物流信息: " + orderNo);
            }
            Long currentUserId = SecurityUtils.getUserId();
            if (!SecurityUtils.isAdmin(currentUserId) && !order.getUserId().equals(currentUserId)) {
                ChatContext.addToolCallName("queryLogistics");
                return Map.of("error", "您无权查看该订单的物流信息");
            }
            if (order.getLogisticsNo() == null) {
                ChatContext.addToolCallName("queryLogistics");
                return Map.of("orderNo", orderNo, "message", "该订单暂未发货，无物流信息");
            }
            ChatContext.addToolCallName("queryLogistics");
            return Map.of(
                    "orderNo", order.getOrderNo(),
                    "logisticsNo", order.getLogisticsNo() != null ? order.getLogisticsNo() : "",
                    "logisticsCompany", order.getLogisticsCompany() != null ? order.getLogisticsCompany() : "",
                    "status", order.getStatus()
            );
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryLogistics", orderNo, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "帮助用户取消待付款订单。当用户要求取消订单时使用此工具。仅可取消待付款状态的订单。注意：取消后不可恢复，AI应先向用户确认订单号，确认后再执行。")
    public Map<String, Object> cancelOrder(
            @ToolParam(description = "订单编号") String orderNo) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 取消订单: orderNo={}, userId={}", orderNo, userId);
        publishToolCallEvent("cancelOrder", "正在取消订单 " + orderNo + " ...", List.of("order"));
        try {
            Order order = orderService.getByOrderNo(orderNo);
            if (order == null) {
                ChatContext.addToolCallName("cancelOrder");
                return Map.of("error", "未找到订单: " + orderNo);
            }
            if (!order.getUserId().equals(userId)) {
                ChatContext.addToolCallName("cancelOrder");
                return Map.of("error", "您无权操作该订单");
            }
            if (!"PENDING".equals(order.getStatus())) {
                ChatContext.addToolCallName("cancelOrder");
                return Map.of("error", "仅待付款订单可取消，当前状态: " + order.getStatus());
            }
            orderService.updateOrderStatus(order.getOrderId(), "CANCELLED");
            ChatContext.addToolCallName("cancelOrder");
            return Map.of("orderNo", orderNo, "message", "订单已成功取消");
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("cancelOrder", "orderNo=" + orderNo, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "帮助用户确认收货。当用户表示已收到商品时使用此工具。仅可操作已发货状态的订单。")
    public Map<String, Object> confirmReceive(
            @ToolParam(description = "订单编号") String orderNo) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 确认收货: orderNo={}, userId={}", orderNo, userId);
        publishToolCallEvent("confirmReceive", "正在确认收货 " + orderNo + " ...", List.of("order"));
        try {
            Order order = orderService.getByOrderNo(orderNo);
            if (order == null) {
                ChatContext.addToolCallName("confirmReceive");
                return Map.of("error", "未找到订单: " + orderNo);
            }
            if (!order.getUserId().equals(userId)) {
                ChatContext.addToolCallName("confirmReceive");
                return Map.of("error", "您无权操作该订单");
            }
            if (!"SHIPPED".equals(order.getStatus())) {
                ChatContext.addToolCallName("confirmReceive");
                return Map.of("error", "仅已发货订单可确认收货，当前状态: " + order.getStatus());
            }
            orderService.updateOrderStatus(order.getOrderId(), "DELIVERED");
            ChatContext.addToolCallName("confirmReceive");
            return Map.of("orderNo", orderNo, "message", "已确认收货");
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("confirmReceive", "orderNo=" + orderNo, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "帮助用户模拟支付待付款订单。当用户要求支付、付款时使用此工具。仅可支付待付款(PENDING)状态的订单。AI应先向用户确认订单号和金额后再执行。")
    public Map<String, Object> payOrder(
            @ToolParam(description = "订单编号，如 ORD20250001") String orderNo) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 支付订单: orderNo={}, userId={}", orderNo, userId);
        publishToolCallEvent("payOrder", "正在支付订单 " + orderNo + " ...", List.of("order"));
        try {
            Order order = orderService.getByOrderNo(orderNo);
            if (order == null) {
                ChatContext.addToolCallName("payOrder");
                return Map.of("error", "未找到订单: " + orderNo);
            }
            if (!order.getUserId().equals(userId)) {
                ChatContext.addToolCallName("payOrder");
                return Map.of("error", "您无权操作该订单");
            }
            if (!"PENDING".equals(order.getStatus())) {
                ChatContext.addToolCallName("payOrder");
                return Map.of("error", "仅待付款订单可支付，当前状态: " + order.getStatus());
            }
            orderService.updateOrderStatus(order.getOrderId(), "PAID");
            ChatContext.addToolCallName("payOrder");
            return Map.of(
                "orderNo", orderNo,
                "totalAmount", order.getTotalAmount().toString(),
                "status", "PAID",
                "message", "订单支付成功"
            );
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("payOrder", "orderNo=" + orderNo, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }
}
