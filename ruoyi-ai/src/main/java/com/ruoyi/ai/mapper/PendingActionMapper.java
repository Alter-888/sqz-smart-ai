package com.ruoyi.ai.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.ai.entity.PendingAction;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

/**
 * P7 HITL 待确认单 Mapper。
 */
@Mapper
public interface PendingActionMapper extends BaseMapper<PendingAction> {

    @Update("UPDATE ai_pending_action SET status = #{status}, result = #{result}, update_time = NOW() " +
            "WHERE action_id = #{actionId}")
    int updateStatus(@Param("actionId") Long actionId,
                     @Param("status") String status,
                     @Param("result") String result);
}