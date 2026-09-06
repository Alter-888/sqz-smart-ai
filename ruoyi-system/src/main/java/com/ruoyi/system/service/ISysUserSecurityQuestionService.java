package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SysUserSecurityQuestion;

/**
 * 用户安全问题 服务层
 */
public interface ISysUserSecurityQuestionService
{
    /**
     * 获取用户的安全问题列表(不含答案)
     *
     * @param userId 用户ID
     * @return 安全问题列表
     */
    public List<SysUserSecurityQuestion> getQuestionsByUserId(Long userId);

    /**
     * 判断用户是否已设置安全问题
     *
     * @param userId 用户ID
     * @return 是否已设置
     */
    public boolean hasSecurityQuestions(Long userId);

    /**
     * 保存用户安全问题(删旧插新)
     *
     * @param userId 用户ID
     * @param questions 安全问题列表
     */
    public void saveQuestions(Long userId, List<SysUserSecurityQuestion> questions);

    /**
     * 验证安全问题答案
     *
     * @param userId 用户ID
     * @param questionId 问题ID
     * @param plainAnswer 明文答案
     * @return 是否正确
     */
    public boolean verifyAnswer(Long userId, Long questionId, String plainAnswer);
}
