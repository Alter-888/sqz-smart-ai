package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysPasswordResetRequest;
import java.util.List;

/**
 * 密码重置申请 数据层
 */
public interface SysPasswordResetRequestMapper
{
    /**
     * 查询密码重置申请列表
     */
    public List<SysPasswordResetRequest> selectRequestList(SysPasswordResetRequest request);

    /**
     * 根据ID查询申请
     */
    public SysPasswordResetRequest selectRequestById(Long requestId);

    /**
     * 查询用户未处理的申请数量
     */
    public int countPendingByUserId(Long userId);

    /**
     * 新增申请
     */
    public int insertRequest(SysPasswordResetRequest request);

    /**
     * 更新申请
     */
    public int updateRequest(SysPasswordResetRequest request);
}
