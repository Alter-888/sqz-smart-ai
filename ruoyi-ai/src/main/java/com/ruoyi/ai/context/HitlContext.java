package com.ruoyi.ai.context;

/**
 * P7 HITL：确认重放令牌（02 §13.3）。
 * 确认接口反射重放原方法时前置位，让 HitlGuardAspect 放行，避免"确认→再拦→死循环"。
 * 绝不用"参数里塞 confirmed 字段"——那等于把令牌暴露给模型。
 */
public final class HitlContext {

    private static final ThreadLocal<Boolean> CONFIRMED_REPLAY = new ThreadLocal<>();

    private HitlContext() {
    }

    public static void markConfirmedReplay() {
        CONFIRMED_REPLAY.set(Boolean.TRUE);
    }

    public static boolean isConfirmedReplay() {
        return Boolean.TRUE.equals(CONFIRMED_REPLAY.get());
    }

    public static void clear() {
        CONFIRMED_REPLAY.remove();
    }
}