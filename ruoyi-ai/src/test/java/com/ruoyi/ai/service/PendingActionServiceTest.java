package com.ruoyi.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.context.HitlContext;
import com.ruoyi.ai.entity.PendingAction;
import com.ruoyi.ai.mapper.PendingActionMapper;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.exception.ServiceException;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationContext;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.contains;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * P7 HITL 安全测试（07 §9.4）：
 * confirm() 拿 actionId 反射重放一个方法，四道校验少一道就是任意方法调用，必须逐条断言。
 */
@ExtendWith(MockitoExtension.class)
class PendingActionServiceTest {

    @Mock
    private PendingActionMapper mapper;

    @Mock
    private ApplicationContext applicationContext;

    private final ObjectMapper objectMapper = new ObjectMapper();
    private final SmartCsProperties props = new SmartCsProperties();
    private PendingActionService service;

    /** 测试替身：confirm 成功路径反射重放的“业务 Bean” */
    public static class FakeOrderTools {
        boolean cancelled = false;

        public Map<String, Object> cancelOrder(String orderNo) {
            cancelled = true;
            return Map.of("orderNo", orderNo, "message", "订单已成功取消");
        }
    }

    @BeforeEach
    void setUp() {
        service = new PendingActionService(mapper, applicationContext, objectMapper, props);
        LoginUser loginUser = new LoginUser();
        loginUser.setUserId(100L);
        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(loginUser, null, Collections.emptyList()));
    }

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
        HitlContext.clear();
    }

    private PendingAction pending(Long actionId, Long userId, String status, String tool,
                                  LocalDateTime expireTime, String targetClass,
                                  String paramTypes, String argsJson) {
        PendingAction a = new PendingAction();
        a.setActionId(actionId);
        a.setUserId(userId);
        a.setSessionId(1L);
        a.setToolName(tool);
        a.setTargetClass(targetClass);
        a.setParamTypes(paramTypes);
        a.setArgsJson(argsJson);
        a.setStatus(status);
        a.setExpireTime(expireTime);
        return a;
    }

    @Test
    @DisplayName("他人确认 → 报操作不存在，且错误信息不含“无权限”（不泄露 id 是否存在）")
    void confirm_otherUser_rejectedWithoutLeaking() {
        PendingAction a = pending(1L, 999L, "PENDING", "cancelOrder",
                LocalDateTime.now().plusMinutes(5), FakeOrderTools.class.getName(),
                "java.lang.String", "[\"ORD1\"]");
        when(mapper.selectById(1L)).thenReturn(a);

        ServiceException ex = assertThrows(ServiceException.class, () -> service.confirm(1L));

        assertEquals("操作不存在", ex.getMessage());
        assertFalse(ex.getMessage().contains("无权限"));
        verify(mapper, never()).updateStatus(anyLong(), anyString(), any());
    }

    @Test
    @DisplayName("状态已是 CONFIRMED/CANCELLED 再确认 → 拒绝（防重放）")
    void confirm_alreadyHandled_rejected() {
        PendingAction a = pending(1L, 100L, "CONFIRMED", "cancelOrder",
                LocalDateTime.now().plusMinutes(5), FakeOrderTools.class.getName(),
                "java.lang.String", "[\"ORD1\"]");
        when(mapper.selectById(1L)).thenReturn(a);

        ServiceException ex = assertThrows(ServiceException.class, () -> service.confirm(1L));

        assertEquals("该操作已处理", ex.getMessage());
        verify(mapper, never()).updateStatus(anyLong(), anyString(), any());
    }

    @Test
    @DisplayName("已过期确认 → 报已超时、状态转 EXPIRED、原方法未执行")
    void confirm_expired_flipsExpiredAndDoesNotExecute() {
        PendingAction a = pending(1L, 100L, "PENDING", "cancelOrder",
                LocalDateTime.now().minusMinutes(1), FakeOrderTools.class.getName(),
                "java.lang.String", "[\"ORD1\"]");
        when(mapper.selectById(1L)).thenReturn(a);

        ServiceException ex = assertThrows(ServiceException.class, () -> service.confirm(1L));

        assertTrue(ex.getMessage().contains("已超时"));
        verify(mapper).updateStatus(1L, "EXPIRED", null);
    }

    @Test
    @DisplayName("伪造 tool_name 不在 hitl-tools 白名单 → 拒绝（白名单二次校验）")
    void confirm_toolNotInWhitelist_rejected() {
        PendingAction a = pending(1L, 100L, "PENDING", "evilMethod",
                LocalDateTime.now().plusMinutes(5), FakeOrderTools.class.getName(),
                "java.lang.String", "[\"x\"]");
        when(mapper.selectById(1L)).thenReturn(a);

        ServiceException ex = assertThrows(ServiceException.class, () -> service.confirm(1L));

        assertEquals("不支持确认该操作", ex.getMessage());
        verify(mapper, never()).updateStatus(anyLong(), anyString(), any());
    }

    @Test
    @DisplayName("伪造 param_types 含 java.lang.Runtime → 静态类型白名单拦下")
    void confirm_runtimeParamType_rejected() {
        PendingAction a = pending(1L, 100L, "PENDING", "cancelOrder",
                LocalDateTime.now().plusMinutes(5), FakeOrderTools.class.getName(),
                "java.lang.Runtime", "[\"x\"]");
        when(mapper.selectById(1L)).thenReturn(a);

        ServiceException ex = assertThrows(ServiceException.class, () -> service.confirm(1L));

        assertTrue(ex.getMessage().contains("不支持的参数类型"));
        ArgumentCaptor<String> statusCaptor = ArgumentCaptor.forClass(String.class);
        verify(mapper).updateStatus(eq(1L), statusCaptor.capture(), any());
        assertEquals("FAILED", statusCaptor.getValue());
    }

    @Test
    @DisplayName("确认成功 → 反射重放原方法、状态 CONFIRMED、回写结果")
    void confirm_success_replaysAndMarksConfirmed() {
        FakeOrderTools fake = new FakeOrderTools();
        PendingAction a = pending(1L, 100L, "PENDING", "cancelOrder",
                LocalDateTime.now().plusMinutes(5), FakeOrderTools.class.getName(),
                "java.lang.String", "[\"ORD20250001\"]");
        when(mapper.selectById(1L)).thenReturn(a);
        when(applicationContext.getBean(FakeOrderTools.class)).thenReturn(fake);

        Map<String, Object> result = service.confirm(1L);

        assertTrue(fake.cancelled);
        assertTrue(result.get("result").toString().contains("ORD20250001"));
        assertEquals("ORD20250001", result.get("orderNo"));
        verify(mapper).updateStatus(eq(1L), eq("CONFIRMED"), contains("ORD20250001"));
        assertFalse(HitlContext.isConfirmedReplay());   // 令牌用后必须清
    }
}
