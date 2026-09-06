package com.ruoyi.business.service;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.core.metadata.TableInfoHelper;
import com.ruoyi.business.entity.Notification;
import com.ruoyi.business.mapper.NotificationMapper;
import com.ruoyi.common.exception.ServiceException;
import org.apache.ibatis.builder.MapperBuilderAssistant;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * NotificationService 通知服务单元测试
 */
@ExtendWith(MockitoExtension.class)
class NotificationServiceTest {

    @Mock
    private NotificationMapper notificationMapper;

    @InjectMocks
    private NotificationService notificationService;

    @BeforeAll
    static void initMybatisPlusCache() {
        // 初始化 MyBatis-Plus Lambda 缓存，避免 LambdaUpdateWrapper 报错
        TableInfoHelper.initTableInfo(
                new MapperBuilderAssistant(new MybatisConfiguration(), ""),
                Notification.class);
    }

    @Test
    @DisplayName("createNotification - 正确设置所有字段，isRead=0")
    void createNotification_setsFieldsCorrectly() {
        when(notificationMapper.insert(any(Notification.class))).thenReturn(1);

        notificationService.createNotification(100L, "订单发货", "您的订单已发货", "ORDER_STATUS", 1001L);

        ArgumentCaptor<Notification> captor = ArgumentCaptor.forClass(Notification.class);
        verify(notificationMapper).insert(captor.capture());

        Notification saved = captor.getValue();
        assertEquals(100L, saved.getUserId());
        assertEquals("订单发货", saved.getTitle());
        assertEquals("您的订单已发货", saved.getContent());
        assertEquals("ORDER_STATUS", saved.getType());
        assertEquals(1001L, saved.getRefId());
        assertEquals(0, saved.getIsRead());
    }

    @Test
    @DisplayName("markAsRead - 通知不存在抛出ServiceException")
    void markAsRead_notExists_throwsException() {
        when(notificationMapper.selectById(999L)).thenReturn(null);

        ServiceException ex = assertThrows(ServiceException.class,
                () -> notificationService.markAsRead(999L, 100L));
        assertEquals("通知不存在", ex.getMessage());
    }

    @Test
    @DisplayName("markAllAsRead - 批量更新被调用")
    void markAllAsRead_updateCalled() {
        when(notificationMapper.update(any(), any())).thenReturn(5);

        notificationService.markAllAsRead(100L);

        verify(notificationMapper).update(any(), any());
    }
}
