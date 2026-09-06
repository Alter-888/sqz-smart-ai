package com.ruoyi.common.core.domain.model;

/**
 * 管理员重置申请请求体
 */
public class ResetRequestBody
{
    /** 用户名 */
    private String username;

    /** 申请原因 */
    private String reason;

    /** 用户期望的新密码 */
    private String newPassword;

    public String getUsername()
    {
        return username;
    }

    public void setUsername(String username)
    {
        this.username = username;
    }

    public String getReason()
    {
        return reason;
    }

    public void setReason(String reason)
    {
        this.reason = reason;
    }

    public String getNewPassword()
    {
        return newPassword;
    }

    public void setNewPassword(String newPassword)
    {
        this.newPassword = newPassword;
    }
}
