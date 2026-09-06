package com.ruoyi.system.service;

import com.ruoyi.system.domain.SysPasswordResetRequest;
import java.util.List;

/**
 * 密码重置申请 服务层
 */
public interface ISysPasswordResetRequestService
{
    /**
     * 查询申请列表
     */
    public List<SysPasswordResetRequest> selectRequestList(SysPasswordResetRequest request);

    /**
     * 创建重置申请（含用户期望的新密码）
     */
    public int createRequest(Long userId, String userName, String reason, String newPassword);

    /**
     * 通过申请并重置密码（使用用户提交的密码）
     */
    public int approveRequest(Long requestId, String handleBy, String handleRemark);

    /**
     * 拒绝申请
     */
    public int rejectRequest(Long requestId, String handleBy, String handleRemark);
}
