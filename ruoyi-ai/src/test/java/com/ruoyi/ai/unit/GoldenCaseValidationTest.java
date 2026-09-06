package com.ruoyi.ai.unit;

import com.ruoyi.ai.eval.GoldenRules;
import com.ruoyi.ai.entity.EvalGolden;
import com.ruoyi.common.exception.ServiceException;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * 黄金集入库校验单测（P6）。
 * 写操作工具必须在入库时就拦（否则每跑一次评测就改一批真实数据）；
 * expect_intent 必须是合法枚举（否则跑评测时 Intent.valueOf 炸在半路）。
 */
class GoldenCaseValidationTest {

    @Test
    void 写操作工具被拒() {
        EvalGolden g = new EvalGolden();
        g.setExpectTools("[\"cancelOrder\"]");
        assertThatThrownBy(() -> GoldenRules.validate(g))
                .isInstanceOf(ServiceException.class)
                .hasMessageContaining("写操作工具");
    }

    @Test
    void expectIntent拼错被拒() {
        EvalGolden g = new EvalGolden();
        g.setExpectIntent("PRODCUT");
        assertThatThrownBy(() -> GoldenRules.validate(g))
                .isInstanceOf(ServiceException.class)
                .hasMessageContaining("不是合法意图枚举");
    }

    @Test
    void 合法条目放行() {
        EvalGolden g = new EvalGolden();
        g.setExpectIntent("PRODUCT");
        g.setExpectTools("[\"searchProducts\"]");
        // 不抛即通过
        GoldenRules.validate(g);
    }
}
