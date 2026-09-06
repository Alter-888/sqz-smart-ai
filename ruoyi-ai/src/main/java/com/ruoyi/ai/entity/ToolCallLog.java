package com.ruoyi.ai.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("ai_tool_call_log")
public class ToolCallLog {

    @TableId(type = IdType.AUTO)
    private Long logId;

    private Long sessionId;

    private String toolName;

    private String toolParams;

    private Integer successFlag;  // 1成功 0失败

    private Long durationMs;       // 执行耗时(毫秒)

    private String errorMsg;       // 错误信息

    private LocalDateTime createTime;
}
