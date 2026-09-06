package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.SysPasswordResetRequest;
import com.ruoyi.system.mapper.SysPasswordResetRequestMapper;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.service.ISysPasswordResetRequestService;

/**
 * 密码重置申请 服务层实现
 */
@Service
public class SysPasswordResetRequestServiceImpl implements ISysPasswordResetRequestService
{
    @Autowired
    private SysPasswordResetRequestMapper requestMapper;

    @Autowired
    private SysUserMapper userMapper;

    @Override
    public List<SysPasswordResetRequest> selectRequestList(SysPasswordResetRequest request)
    {
        return requestMapper.selectRequestList(request);
    }

    @Override
    public int createRequest(Long userId, String userName, String reason, String newPassword)
    {
        // 检查是否已有未处理的申请
        int pendingCount = requestMapper.countPendingByUserId(userId);
        if (pendingCount > 0)
        {
            throw new ServiceException("您已有待处理的重置申请，请耐心等待管理员处理");
        }
        SysPasswordResetRequest request = new SysPasswordResetRequest();
        request.setUserId(userId);
        request.setUserName(userName);
        request.setReason(reason);
        request.setNewPassword(newPassword);
        return requestMapper.insertRequest(request);
    }

    @Override
    public int approveRequest(Long requestId, String handleBy, String handleRemark)
    {
        SysPasswordResetRequest request = requestMapper.selectRequestById(requestId);
        if (request == null)
        {
            throw new ServiceException("申请记录不存在");
        }
        if (!"0".equals(request.getStatus()))
        {
            throw new ServiceException("该申请已被处理");
        }

        // 使用用户提交的已加密密码直接重置
        userMapper.resetUserPwd(request.getUserId(), request.getNewPassword());

        // 更新申请状态
        request.setStatus("1");
        request.setHandleBy(handleBy);
        request.setHandleTime(new Date());
        request.setHandleRemark(handleRemark);
        return requestMapper.updateRequest(request);
    }

    @Override
    public int rejectRequest(Long requestId, String handleBy, String handleRemark)
    {
        SysPasswordResetRequest request = requestMapper.selectRequestById(requestId);
        if (request == null)
        {
            throw new ServiceException("申请记录不存在");
        }
        if (!"0".equals(request.getStatus()))
        {
            throw new ServiceException("该申请已被处理");
        }

        request.setStatus("2");
        request.setHandleBy(handleBy);
        request.setHandleTime(new Date());
        request.setHandleRemark(handleRemark);
        return requestMapper.updateRequest(request);
    }
}
