package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysPasswordResetRequest;
import com.ruoyi.system.service.ISysPasswordResetRequestService;

/**
 * 密码重置申请管理（管理员端）
 */
@RestController
@RequestMapping("/system/resetRequest")
public class SysResetRequestController extends BaseController
{
    @Autowired
    private ISysPasswordResetRequestService resetRequestService;

    /**
     * 查询申请列表
     */
    @PreAuthorize("@ss.hasPermi('system:resetRequest:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysPasswordResetRequest request)
    {
        startPage();
        List<SysPasswordResetRequest> list = resetRequestService.selectRequestList(request);
        return getDataTable(list);
    }

    /**
     * 通过申请（一键通过，使用用户提交的密码）
     */
    @PreAuthorize("@ss.hasPermi('system:resetRequest:handle')")
    @PutMapping("/approve/{requestId}")
    public AjaxResult approve(@PathVariable Long requestId, @RequestBody Map<String, String> params)
    {
        String handleRemark = params.get("handleRemark");
        String handleBy = SecurityUtils.getUsername();
        resetRequestService.approveRequest(requestId, handleBy, handleRemark);
        return success("申请已通过，用户密码已重置");
    }

    /**
     * 拒绝申请
     */
    @PreAuthorize("@ss.hasPermi('system:resetRequest:handle')")
    @PutMapping("/reject/{requestId}")
    public AjaxResult reject(@PathVariable Long requestId, @RequestBody Map<String, String> params)
    {
        String handleRemark = params.get("handleRemark");
        String handleBy = SecurityUtils.getUsername();
        resetRequestService.rejectRequest(requestId, handleBy, handleRemark);
        return success("申请已拒绝");
    }
}
