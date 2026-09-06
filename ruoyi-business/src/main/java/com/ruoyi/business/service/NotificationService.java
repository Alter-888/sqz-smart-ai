package com.ruoyi.business.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.business.entity.Notification;
import com.ruoyi.business.mapper.NotificationMapper;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private static final Logger log = LoggerFactory.getLogger(NotificationService.class);

    private final NotificationMapper notificationMapper;

    /**
     * 创建通知
     */
    public void createNotification(Long userId, String title, String content, String type, Long refId) {
        Notification notification = new Notification();
        notification.setUserId(userId);
        notification.setTitle(title);
        notification.setContent(content);
        notification.setType(type);
        notification.setRefId(refId);
        notification.setIsRead(0);
        notificationMapper.insert(notification);
        log.info("通知创建: userId={}, type={}, title={}", userId, type, title);
    }

    /**
     * 获取用户未读通知列表
     */
    public List<Notification> getUnreadNotifications(Long userId) {
        LambdaQueryWrapper<Notification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Notification::getUserId, userId);
        wrapper.eq(Notification::getIsRead, 0);
        wrapper.orderByDesc(Notification::getCreateTime);
        return notificationMapper.selectList(wrapper);
    }

    /**
     * 获取未读通知数量
     */
    public long getUnreadCount(Long userId) {
        LambdaQueryWrapper<Notification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Notification::getUserId, userId);
        wrapper.eq(Notification::getIsRead, 0);
        return notificationMapper.selectCount(wrapper);
    }

    /**
     * 标记单条通知为已读
     */
    public void markAsRead(Long notificationId, Long userId) {
        Notification notification = notificationMapper.selectById(notificationId);
        if (notification == null) {
            throw new ServiceException("通知不存在");
        }
        if (!SecurityUtils.isAdmin(userId) && !notification.getUserId().equals(userId)) {
            throw new ServiceException("无权操作该通知");
        }
        notification.setIsRead(1);
        notificationMapper.updateById(notification);
    }

    /**
     * 标记用户所有通知为已读
     */
    public void markAllAsRead(Long userId) {
        LambdaUpdateWrapper<Notification> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Notification::getUserId, userId);
        wrapper.eq(Notification::getIsRead, 0);
        wrapper.set(Notification::getIsRead, 1);
        notificationMapper.update(null, wrapper);
        log.info("用户所有通知标记已读: userId={}", userId);
    }

    /**
     * 分页查询用户所有通知（含已读），支持按类型和已读状态筛选
     */
    public IPage<Notification> listAllNotifications(Long userId, int pageNum, int pageSize, String type, Integer isRead) {
        Page<Notification> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Notification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Notification::getUserId, userId);
        if (type != null && !type.isEmpty()) {
            wrapper.eq(Notification::getType, type);
        }
        if (isRead != null) {
            wrapper.eq(Notification::getIsRead, isRead);
        }
        wrapper.orderByDesc(Notification::getCreateTime);
        return notificationMapper.selectPage(page, wrapper);
    }

    /**
     * 获取通知统计数据（总数、未读数、各类型数量）
     */
    public Map<String, Object> getNotificationStats(Long userId) {
        Map<String, Object> stats = new HashMap<>();

        LambdaQueryWrapper<Notification> totalWrapper = new LambdaQueryWrapper<>();
        totalWrapper.eq(Notification::getUserId, userId);
        stats.put("totalCount", notificationMapper.selectCount(totalWrapper));

        LambdaQueryWrapper<Notification> unreadWrapper = new LambdaQueryWrapper<>();
        unreadWrapper.eq(Notification::getUserId, userId).eq(Notification::getIsRead, 0);
        stats.put("unreadCount", notificationMapper.selectCount(unreadWrapper));

        String[] types = {"ORDER_STATUS", "TICKET_REPLY", "STOCK_WARNING", "TICKET_REFUND", "TICKET_RESOLVED"};
        Map<String, Long> typeCounts = new HashMap<>();
        for (String t : types) {
            LambdaQueryWrapper<Notification> typeWrapper = new LambdaQueryWrapper<>();
            typeWrapper.eq(Notification::getUserId, userId).eq(Notification::getType, t);
            typeCounts.put(t, notificationMapper.selectCount(typeWrapper));
        }
        stats.put("typeCounts", typeCounts);

        return stats;
    }
}
