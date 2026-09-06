package com.ruoyi.business.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.business.entity.Notification;
import com.ruoyi.business.service.NotificationService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/business/notification")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    /**
     * 分页查询当前用户所有通知（含已读），支持按类型和已读状态筛选
     */
    @GetMapping("/list")
    public AjaxResult list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer isRead) {
        Long userId = SecurityUtils.getUserId();
        IPage<Notification> page = notificationService.listAllNotifications(userId, pageNum, pageSize, type, isRead);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    /**
     * 获取通知统计数据
     */
    @GetMapping("/stats")
    public AjaxResult stats() {
        Long userId = SecurityUtils.getUserId();
        return AjaxResult.success(notificationService.getNotificationStats(userId));
    }

    /**
     * 获取未读通知列表
     */
    @GetMapping("/unread")
    public AjaxResult unread() {
        Long userId = SecurityUtils.getUserId();
        List<Notification> notifications = notificationService.getUnreadNotifications(userId);
        return AjaxResult.success(notifications);
    }

    /**
     * 获取未读通知数量
     */
    @GetMapping("/unread-count")
    public AjaxResult unreadCount() {
        Long userId = SecurityUtils.getUserId();
        long count = notificationService.getUnreadCount(userId);
        return AjaxResult.success(count);
    }

    /**
     * 标记单条通知已读
     */
    @PutMapping("/{id}/read")
    public AjaxResult markAsRead(@PathVariable("id") Long notificationId) {
        Long userId = SecurityUtils.getUserId();
        notificationService.markAsRead(notificationId, userId);
        return AjaxResult.success();
    }

    /**
     * 标记所有通知已读
     */
    @PutMapping("/read-all")
    public AjaxResult markAllAsRead() {
        Long userId = SecurityUtils.getUserId();
        notificationService.markAllAsRead(userId);
        return AjaxResult.success();
    }
}
