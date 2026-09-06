package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SysUserSecurityQuestion;
import com.ruoyi.system.mapper.SysUserSecurityQuestionMapper;
import com.ruoyi.system.service.ISysUserSecurityQuestionService;

/**
 * 用户安全问题 服务层实现
 */
@Service
public class SysUserSecurityQuestionServiceImpl implements ISysUserSecurityQuestionService
{
    @Autowired
    private SysUserSecurityQuestionMapper securityQuestionMapper;

    @Override
    public List<SysUserSecurityQuestion> getQuestionsByUserId(Long userId)
    {
        List<SysUserSecurityQuestion> list = securityQuestionMapper.selectByUserId(userId);
        // 将答案置空，防止泄露
        for (SysUserSecurityQuestion q : list)
        {
            q.setAnswer(null);
        }
        return list;
    }

    @Override
    public boolean hasSecurityQuestions(Long userId)
    {
        return securityQuestionMapper.countByUserId(userId) > 0;
    }

    @Override
    @Transactional
    public void saveQuestions(Long userId, List<SysUserSecurityQuestion> questions)
    {
        if (questions == null || questions.size() < 1 || questions.size() > 5)
        {
            throw new ServiceException("安全问题数量必须在1到5个之间");
        }
        // BCrypt加密答案并设置userId和排序
        for (int i = 0; i < questions.size(); i++)
        {
            SysUserSecurityQuestion q = questions.get(i);
            if (q.getQuestion() == null || q.getQuestion().trim().isEmpty())
            {
                throw new ServiceException("安全问题不能为空");
            }
            if (q.getAnswer() == null || q.getAnswer().trim().isEmpty())
            {
                throw new ServiceException("安全问题答案不能为空");
            }
            q.setUserId(userId);
            q.setSortOrder(i + 1);
            q.setAnswer(SecurityUtils.encryptPassword(q.getAnswer()));
        }
        // 删旧插新
        securityQuestionMapper.deleteByUserId(userId);
        securityQuestionMapper.batchInsert(questions);
    }

    @Override
    public boolean verifyAnswer(Long userId, Long questionId, String plainAnswer)
    {
        SysUserSecurityQuestion question = securityQuestionMapper.selectById(questionId);
        if (question == null)
        {
            throw new ServiceException("安全问题不存在");
        }
        if (!question.getUserId().equals(userId))
        {
            throw new ServiceException("安全问题不属于该用户");
        }
        return SecurityUtils.matchesPassword(plainAnswer, question.getAnswer());
    }
}
