package com.ruoyi.web.controller.system;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.ForgotPasswordBody;
import com.ruoyi.common.core.domain.model.ResetRequestBody;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysUserSecurityQuestion;
import com.ruoyi.system.service.ISysPasswordResetRequestService;
import com.ruoyi.system.service.ISysUserSecurityQuestionService;
import com.ruoyi.system.service.ISysUserService;

/**
 * 忘记密码（公开接口，无需token）
 */
@RestController
@RequestMapping("/forgotPassword")
public class SysForgotPasswordController extends BaseController
{
    @Autowired
    private ISysUserService userService;

    @Autowired
    private ISysPasswordResetRequestService resetRequestService;

    @Autowired
    private ISysUserSecurityQuestionService securityQuestionService;

    /**
     * 步骤1: 根据用户名获取密保问题列表
     */
    @PostMapping("/getQuestion")
    public AjaxResult getSecurityQuestion(@RequestBody ForgotPasswordBody body)
    {
        if (StringUtils.isEmpty(body.getUsername()))
        {
            return error("请输入用户名");
        }
        SysUser user = userService.selectUserByUserName(body.getUsername());
        if (user == null || "2".equals(user.getDelFlag()))
        {
            return error("用户不存在");
        }
        List<SysUserSecurityQuestion> questions = securityQuestionService.getQuestionsByUserId(user.getUserId());
        if (questions == null || questions.isEmpty())
        {
            return error("该用户未设置密保问题，请直接申请管理员重置");
        }
        AjaxResult ajax = AjaxResult.success();
        ajax.put("questions", questions);
        return ajax;
    }

    /**
     * 步骤2: 验证密保答案并重置密码
     */
    @PostMapping("/resetByQuestion")
    public AjaxResult resetByQuestion(@RequestBody ForgotPasswordBody body)
    {
        if (StringUtils.isEmpty(body.getUsername()))
        {
            return error("请输入用户名");
        }
        if (body.getQuestionId() == null)
        {
            return error("请选择一个密保问题");
        }
        if (StringUtils.isEmpty(body.getSecurityAnswer()))
        {
            return error("请输入密保答案");
        }
        if (StringUtils.isEmpty(body.getNewPassword()))
        {
            return error("请输入新密码");
        }
        if (body.getNewPassword().length() < UserConstants.PASSWORD_MIN_LENGTH
                || body.getNewPassword().length() > UserConstants.PASSWORD_MAX_LENGTH)
        {
            return error("密码长度必须在5到20个字符之间");
        }

        SysUser user = userService.selectUserByUserName(body.getUsername());
        if (user == null || "2".equals(user.getDelFlag()))
        {
            return error("用户不存在");
        }
        // 验证密保答案
        if (!securityQuestionService.verifyAnswer(user.getUserId(), body.getQuestionId(), body.getSecurityAnswer()))
        {
            return error("密保答案错误");
        }
        // 重置密码
        user.setPassword(SecurityUtils.encryptPassword(body.getNewPassword()));
        userService.resetPwd(user);
        return success("密码重置成功，请使用新密码登录");
    }

    /**
     * 步骤3: 申请管理员重置密码（用户提交期望的新密码）
     */
    @PostMapping("/requestAdminReset")
    public AjaxResult requestAdminReset(@RequestBody ResetRequestBody body)
    {
        if (StringUtils.isEmpty(body.getUsername()))
        {
            return error("请输入用户名");
        }
        if (StringUtils.isEmpty(body.getNewPassword()))
        {
            return error("请输入期望的新密码");
        }
        if (body.getNewPassword().length() < UserConstants.PASSWORD_MIN_LENGTH
                || body.getNewPassword().length() > UserConstants.PASSWORD_MAX_LENGTH)
        {
            return error("密码长度必须在5到20个字符之间");
        }
        SysUser user = userService.selectUserByUserName(body.getUsername());
        if (user == null || "2".equals(user.getDelFlag()))
        {
            return error("用户不存在");
        }
        // BCrypt加密后存储
        String encryptedPassword = SecurityUtils.encryptPassword(body.getNewPassword());
        resetRequestService.createRequest(user.getUserId(), user.getUserName(), body.getReason(), encryptedPassword);
        return success("申请已提交，请等待管理员处理");
    }
}
