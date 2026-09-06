package com.ruoyi.common.core.domain.model;

/**
 * 忘记密码请求体
 */
public class ForgotPasswordBody
{
    /** 用户名 */
    private String username;

    /** 安全问题ID */
    private Long questionId;

    /** 密保答案 */
    private String securityAnswer;

    /** 新密码 */
    private String newPassword;

    public String getUsername()
    {
        return username;
    }

    public void setUsername(String username)
    {
        this.username = username;
    }

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    public String getSecurityAnswer()
    {
        return securityAnswer;
    }

    public void setSecurityAnswer(String securityAnswer)
    {
        this.securityAnswer = securityAnswer;
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
