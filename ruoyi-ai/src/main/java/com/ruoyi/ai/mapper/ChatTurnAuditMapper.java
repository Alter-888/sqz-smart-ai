package com.ruoyi.ai.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.ai.entity.ChatTurnAudit;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

import java.math.BigDecimal;

@Mapper
public interface ChatTurnAuditMapper extends BaseMapper<ChatTurnAudit> {

    /** P7 异步抽检回写：eval_score / eval_reason */
    @Update("UPDATE ai_chat_turn_audit SET eval_score = #{score}, eval_reason = #{reason} " +
            "WHERE audit_id = #{auditId}")
    int updateEval(@Param("auditId") Long auditId,
                   @Param("score") BigDecimal score,
                   @Param("reason") String reason);
}
