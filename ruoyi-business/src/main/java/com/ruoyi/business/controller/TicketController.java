package com.ruoyi.business.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.business.entity.Ticket;
import com.ruoyi.business.entity.TicketReply;
import com.ruoyi.business.service.TicketService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/business/ticket")
@RequiredArgsConstructor
public class TicketController {

    private final TicketService ticketService;

    @GetMapping("/list")
    @PreAuthorize("@ss.hasPermi('business:ticket:list')")
    public AjaxResult list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer priority) {
        IPage<Ticket> page = ticketService.listTickets(pageNum, pageSize, status, type, priority);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    /**
     * 管理端工单统计（全量，各状态数量）
     */
    @GetMapping("/stats")
    @PreAuthorize("@ss.hasPermi('business:ticket:list')")
    public AjaxResult ticketStats() {
        return AjaxResult.success(ticketService.getAllTicketStats());
    }

    @GetMapping("/my")
    public AjaxResult myTickets(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String status) {
        Long userId = SecurityUtils.getUserId();
        IPage<Ticket> page = ticketService.listUserTickets(userId, pageNum, pageSize, type, status);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    /**
     * 用户工单统计（各状态数量）
     */
    @GetMapping("/my/stats")
    public AjaxResult myTicketStats() {
        Long userId = SecurityUtils.getUserId();
        return AjaxResult.success(ticketService.getUserTicketStats(userId));
    }

    /**
     * 用户查看自己的工单详情（无需管理员权限，仅校验所有权）
     */
    @GetMapping("/my/{id:\\d+}")
    public AjaxResult myTicketDetail(@PathVariable("id") Long ticketId) {
        Long userId = SecurityUtils.getUserId();
        ticketService.validateTicketOwnership(ticketId, userId);
        return AjaxResult.success(ticketService.getById(ticketId));
    }

    /**
     * 用户获取自己工单的回复列表（无需管理员权限，仅校验所有权）
     */
    @GetMapping("/my/{id:\\d+}/replies")
    public AjaxResult myTicketReplies(@PathVariable("id") Long ticketId) {
        Long userId = SecurityUtils.getUserId();
        ticketService.validateTicketOwnership(ticketId, userId);
        List<TicketReply> replies = ticketService.getTicketReplies(ticketId);
        return AjaxResult.success(replies);
    }

    /**
     * 用户提交工单
     */
    @PostMapping
    @PreAuthorize("@ss.hasPermi('business:ticket:add')")
    public AjaxResult create(@RequestBody Ticket ticket) {
        ticket.setUserId(SecurityUtils.getUserId());
        return AjaxResult.success(ticketService.createTicket(ticket));
    }

    @GetMapping("/{id:\\d+}")
    @PreAuthorize("@ss.hasPermi('business:ticket:list')")
    public AjaxResult getById(@PathVariable("id") Long ticketId) {
        Long userId = SecurityUtils.getUserId();
        ticketService.validateTicketOwnership(ticketId, userId);
        return AjaxResult.success(ticketService.getById(ticketId));
    }

    /**
     * 获取工单回复列表
     */
    @GetMapping("/{id:\\d+}/replies")
    @PreAuthorize("@ss.hasPermi('business:ticket:list')")
    public AjaxResult getReplies(@PathVariable("id") Long ticketId) {
        Long userId = SecurityUtils.getUserId();
        ticketService.validateTicketOwnership(ticketId, userId);
        List<TicketReply> replies = ticketService.getTicketReplies(ticketId);
        return AjaxResult.success(replies);
    }

    /**
     * 添加回复（多轮沟通）
     */
    @PostMapping("/{id:\\d+}/reply")
    @PreAuthorize("@ss.hasPermi('business:ticket:reply')")
    public AjaxResult addReply(@PathVariable("id") Long ticketId,
                               @RequestBody Map<String, String> body) {
        Long userId = SecurityUtils.getUserId();
        ticketService.validateTicketOwnership(ticketId, userId);
        String content = body.get("content");
        // 后端强制判定身份：管理员 = STAFF，普通用户 = USER，不信任前端传入的 replyType
        String replyType = SecurityUtils.isAdmin(userId) ? "STAFF" : "USER";
        TicketReply reply = ticketService.addReply(ticketId, userId, content, replyType);
        return AjaxResult.success(reply);
    }

    /**
     * 兼容旧接口：回复工单（直接解决）
     */
    @PutMapping("/{id:\\d+}/reply")
    @PreAuthorize("@ss.hasPermi('business:ticket:reply')")
    public AjaxResult reply(@PathVariable("id") Long ticketId,
                            @RequestBody Map<String, String> body) {
        Long userId = SecurityUtils.getUserId();
        ticketService.validateTicketOwnership(ticketId, userId);
        ticketService.replyTicket(ticketId, body.get("reply"));
        return AjaxResult.success();
    }

    /**
     * 关闭工单
     */
    @PutMapping("/{id:\\d+}/close")
    @PreAuthorize("@ss.hasPermi('business:ticket:reply')")
    public AjaxResult closeTicket(@PathVariable("id") Long ticketId) {
        Long userId = SecurityUtils.getUserId();
        ticketService.validateTicketOwnership(ticketId, userId);
        ticketService.closeTicket(ticketId);
        return AjaxResult.success();
    }

    /**
     * 指派工单
     */
    @PutMapping("/{id:\\d+}/assign")
    @PreAuthorize("@ss.hasPermi('business:ticket:reply')")
    public AjaxResult assignTicket(@PathVariable("id") Long ticketId,
                                   @RequestBody Map<String, Long> body) {
        Long userId = SecurityUtils.getUserId();
        if (!SecurityUtils.isAdmin(userId)) {
            throw new ServiceException("仅管理员可指派工单");
        }
        ticketService.assignTicket(ticketId, body.get("assigneeId"));
        return AjaxResult.success();
    }

    @DeleteMapping("/{id:\\d+}")
    @PreAuthorize("@ss.hasPermi('business:ticket:remove')")
    public AjaxResult delete(@PathVariable("id") Long ticketId) {
        ticketService.deleteTicket(ticketId);
        return AjaxResult.success();
    }

    /**
     * 同意退款
     */
    @PutMapping("/{id:\\d+}/approve-refund")
    @PreAuthorize("@ss.hasPermi('business:ticket:reply')")
    public AjaxResult approveRefund(@PathVariable("id") Long ticketId) {
        Long userId = SecurityUtils.getUserId();
        if (!SecurityUtils.isAdmin(userId)) {
            throw new ServiceException("仅管理员可执行此操作");
        }
        ticketService.approveRefund(ticketId);
        return AjaxResult.success();
    }

    /**
     * 确认退款（联动订单状态）
     */
    @PutMapping("/{id:\\d+}/confirm-refund")
    @PreAuthorize("@ss.hasPermi('business:ticket:reply')")
    public AjaxResult confirmRefund(@PathVariable("id") Long ticketId) {
        Long userId = SecurityUtils.getUserId();
        if (!SecurityUtils.isAdmin(userId)) {
            throw new ServiceException("仅管理员可执行此操作");
        }
        ticketService.confirmRefund(ticketId);
        return AjaxResult.success();
    }

    /**
     * 拒绝退款
     */
    @PutMapping("/{id:\\d+}/reject-refund")
    @PreAuthorize("@ss.hasPermi('business:ticket:reply')")
    public AjaxResult rejectRefund(@PathVariable("id") Long ticketId,
                                    @RequestBody Map<String, String> body) {
        Long userId = SecurityUtils.getUserId();
        if (!SecurityUtils.isAdmin(userId)) {
            throw new ServiceException("仅管理员可执行此操作");
        }
        ticketService.rejectRefund(ticketId, body.get("reason"));
        return AjaxResult.success();
    }

    /**
     * 标记工单已解决（管理员操作）
     */
    @PutMapping("/{id:\\d+}/resolve")
    @PreAuthorize("@ss.hasPermi('business:ticket:reply')")
    public AjaxResult resolveTicket(@PathVariable("id") Long ticketId) {
        Long userId = SecurityUtils.getUserId();
        if (!SecurityUtils.isAdmin(userId)) {
            throw new ServiceException("仅管理员可执行此操作");
        }
        ticketService.resolveTicket(ticketId);
        return AjaxResult.success();
    }

    /**
     * 导出工单列表
     */
    @PostMapping("/export")
    @PreAuthorize("@ss.hasPermi('business:ticket:list')")
    public void export(HttpServletResponse response,
                       @RequestParam(required = false) String status,
                       @RequestParam(required = false) String type) {
        List<Ticket> list = ticketService.listAllTickets(status, type);
        ExcelUtil<Ticket> util = new ExcelUtil<>(Ticket.class);
        util.exportExcel(response, list, "工单数据");
    }
}
