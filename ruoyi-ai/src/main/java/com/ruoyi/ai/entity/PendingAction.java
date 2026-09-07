package com.ruoyi.ai.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * P7 HITL：高危操作待确认单（02 §十三 / 05 §3.4）。
 * target_class / param_types / args_json 只由 HitlGuardAspect 写入，永不接受外部输入。
 */
@Data
@TableName("ai_pending_action")
public class PendingAction {

    @TableId(type = IdType.AUTO)
    private Long actionId;

    /** 发起用户，确认时必须比对 */
    private Long userId;

    /** 会话ID */
    private Long sessionId;

    /** 工具方法名，确认时二次核对白名单 */
    private String toolName;

    /** 声明该方法的类全名，反射重放用 */
    private String targetClass;

    /** 参数类型全名，逗号分隔 */
    private String paramTypes;

    /** 位置参数 JSON 数组 */
    private String argsJson;

    /** 给用户看的一句话摘要 */
    private String summary;

    /** PENDING/CONFIRMED/CANCELLED/EXPIRED/FAILED */
    private String status;

    /** 执行结果或失败原因 */
    private String result;

    /** 过期时间（创建 + 10 分钟） */
    private LocalDateTime expireTime;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}