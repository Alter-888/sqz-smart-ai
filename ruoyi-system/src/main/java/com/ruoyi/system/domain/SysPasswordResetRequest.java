package com.ruoyi.system.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ruoyi.common.core.domain.BaseEntity;
import java.util.Date;

/**
 * 密码重置申请对象 sys_password_reset_request
 */
public class SysPasswordResetRequest extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 申请ID */
    private Long requestId;

    /** 用户ID */
    private Long userId;

    /** 用户账号 */
    private String userName;

    /** 申请原因 */
    private String reason;

    /** 状态（0待处理 1已通过 2已拒绝） */
    private String status;

    /** 处理人 */
    private String handleBy;

    /** 处理时间 */
    private Date handleTime;

    /** 处理备注 */
    private String handleRemark;

    /** 用户提交的新密码(BCrypt加密) */
    private String newPassword;

    public Long getRequestId()
    {
        return requestId;
    }

    public void setRequestId(Long requestId)
    {
        this.requestId = requestId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getUserName()
    {
        return userName;
    }

    public void setUserName(String userName)
    {
        this.userName = userName;
    }

    public String getReason()
    {
        return reason;
    }

    public void setReason(String reason)
    {
        this.reason = reason;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getHandleBy()
    {
        return handleBy;
    }

    public void setHandleBy(String handleBy)
    {
        this.handleBy = handleBy;
    }

    public Date getHandleTime()
    {
        return handleTime;
    }

    public void setHandleTime(Date handleTime)
    {
        this.handleTime = handleTime;
    }

    public String getHandleRemark()
    {
        return handleRemark;
    }

    public void setHandleRemark(String handleRemark)
    {
        this.handleRemark = handleRemark;
    }

    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    public String getNewPassword()
    {
        return newPassword;
    }

    public void setNewPassword(String newPassword)
    {
        this.newPassword = newPassword;
    }
}
