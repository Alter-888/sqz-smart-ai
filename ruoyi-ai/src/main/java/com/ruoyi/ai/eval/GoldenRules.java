package com.ruoyi.ai.eval;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.ai.agent.IntentRouter;
import com.ruoyi.ai.entity.EvalGolden;
import com.ruoyi.common.exception.ServiceException;

import java.util.List;
import java.util.Set;

/**
 * 黄金集入库校验 + JSON 工具（P6）。
 * 硬约束（05 §6.3）：评测会反复跑，写操作工具绝不能进黄金集；expect_intent 必须合法，否则跑评测时枚举炸在半路。
 */
public final class GoldenRules {

    private static final ObjectMapper MAPPER = new ObjectMapper();

    /**
     * 评测绝对不能碰的写操作工具。
     * 与 HITL 名单重叠但不能复用：HITL 是"需用户确认的"，这份是"评测绝对不能碰的"，后者必须更宽。
     */
    public static final Set<String> FORBIDDEN_IN_GOLDEN = Set.of(
            "cancelOrder", "payOrder", "checkoutFromCart", "clearCart",
            "submitTicket", "updateAddress", "deleteAddress", "addToCart");

    private GoldenRules() {
    }

    /** JSON 字符串数组 -> List&lt;String&gt;；null/空/非法都返回空列表（不抛） */
    public static List<String> readJsonList(String json) {
        if (json == null || json.isBlank()) {
            return List.of();
        }
        try {
            return MAPPER.readValue(json, new TypeReference<List<String>>() {
            });
        } catch (Exception e) {
            return List.of();
        }
    }

    /** 入库校验：写操作工具拒绝；expect_intent 必须是合法意图枚举。校验失败抛 ServiceException。 */
    public static void validate(EvalGolden g) {
        if (g == null) {
            throw new ServiceException("黄金集条目不能为空");
        }
        for (String t : readJsonList(g.getExpectTools())) {
            if (FORBIDDEN_IN_GOLDEN.contains(t)) {
                throw new ServiceException("黄金集不允许写操作工具: " + t);
            }
        }
        if (g.getExpectIntent() != null && !g.getExpectIntent().isBlank()) {
            try {
                IntentRouter.Intent.valueOf(g.getExpectIntent());
            } catch (IllegalArgumentException e) {
                throw new ServiceException("expect_intent 不是合法意图枚举: " + g.getExpectIntent());
            }
        }
    }
}
