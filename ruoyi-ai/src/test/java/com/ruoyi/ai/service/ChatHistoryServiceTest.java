package com.ruoyi.ai.service;

import com.ruoyi.ai.entity.ChatMessage;
import com.ruoyi.ai.entity.ChatSession;
import com.ruoyi.ai.mapper.ChatMessageMapper;
import com.ruoyi.ai.mapper.ChatSessionMapper;
import com.ruoyi.common.exception.ServiceException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.ai.chat.memory.ChatMemory;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * ChatHistoryService 聊天历史服务单元测试
 */
@ExtendWith(MockitoExtension.class)
class ChatHistoryServiceTest {

    @Mock
    private ChatSessionMapper chatSessionMapper;
    @Mock
    private ChatMessageMapper chatMessageMapper;
    @Mock
    private ChatMemory chatMemory;

    @InjectMocks
    private ChatHistoryService chatHistoryService;

    // ======================== updateSessionTitle ========================

    @Test
    @DisplayName("updateSessionTitle - title为null时设置标题")
    void updateSessionTitle_nullTitle_setsTitle() {
        ChatSession session = new ChatSession();
        session.setSessionId(1L);
        session.setTitle(null);
        when(chatSessionMapper.selectById(1L)).thenReturn(session);

        chatHistoryService.updateSessionTitle(1L, "第一条消息");

        ArgumentCaptor<ChatSession> captor = ArgumentCaptor.forClass(ChatSession.class);
        verify(chatSessionMapper).updateById(captor.capture());
        assertEquals("第一条消息", captor.getValue().getTitle());
    }

    @Test
    @DisplayName("updateSessionTitle - 超长标题截断到50字符")
    void updateSessionTitle_longTitle_truncatedTo50() {
        ChatSession session = new ChatSession();
        session.setSessionId(1L);
        session.setTitle(null);
        when(chatSessionMapper.selectById(1L)).thenReturn(session);

        String longTitle = "这是一段非常长的标题".repeat(10); // 100字符

        chatHistoryService.updateSessionTitle(1L, longTitle);

        ArgumentCaptor<ChatSession> captor = ArgumentCaptor.forClass(ChatSession.class);
        verify(chatSessionMapper).updateById(captor.capture());
        assertEquals(50, captor.getValue().getTitle().length());
    }

    @Test
    @DisplayName("updateSessionTitle - 已有标题时跳过更新")
    void updateSessionTitle_existingTitle_skipsUpdate() {
        ChatSession session = new ChatSession();
        session.setSessionId(1L);
        session.setTitle("已有标题");
        when(chatSessionMapper.selectById(1L)).thenReturn(session);

        chatHistoryService.updateSessionTitle(1L, "新消息");

        verify(chatSessionMapper, never()).updateById(any(ChatSession.class));
    }

    // ======================== togglePin ========================

    @Test
    @DisplayName("togglePin - 未置顶→置顶：isPinned=1, pinTime非null")
    void togglePin_unpinned_becomePinned() {
        ChatSession session = new ChatSession();
        session.setSessionId(1L);
        session.setIsPinned(0);
        when(chatSessionMapper.selectById(1L)).thenReturn(session);

        ChatSession result = chatHistoryService.togglePin(1L);

        assertEquals(1, result.getIsPinned());
        assertNotNull(result.getPinTime());
        verify(chatSessionMapper).updateById(session);
    }

    @Test
    @DisplayName("togglePin - 已置顶→取消：isPinned=0, pinTime=null")
    void togglePin_pinned_becomeUnpinned() {
        ChatSession session = new ChatSession();
        session.setSessionId(1L);
        session.setIsPinned(1);
        when(chatSessionMapper.selectById(1L)).thenReturn(session);

        ChatSession result = chatHistoryService.togglePin(1L);

        assertEquals(0, result.getIsPinned());
        assertNull(result.getPinTime());
        verify(chatSessionMapper).updateById(session);
    }

    // ======================== deleteSession ========================

    @Test
    @DisplayName("deleteSession - 正常删除：软删除+清消息+清ChatMemory")
    void deleteSession_normal_softDeletesAndClearsMemory() {
        ChatSession session = new ChatSession();
        session.setSessionId(1L);
        session.setStatus(1);
        when(chatSessionMapper.selectById(1L)).thenReturn(session);

        chatHistoryService.deleteSession(1L);

        assertEquals(0, session.getStatus());
        verify(chatSessionMapper).updateById(session);
        verify(chatMessageMapper).delete(any());
        verify(chatMemory).clear("1");
    }

    @Test
    @DisplayName("deleteSession - 会话不存在抛出ServiceException")
    void deleteSession_notExists_throwsException() {
        when(chatSessionMapper.selectById(999L)).thenReturn(null);

        ServiceException ex = assertThrows(ServiceException.class,
                () -> chatHistoryService.deleteSession(999L));
        assertEquals("会话不存在", ex.getMessage());
    }

    // ======================== renameSession ========================

    @Test
    @DisplayName("renameSession - 超长标题截断到100字符")
    void renameSession_longTitle_truncatedTo100() {
        ChatSession session = new ChatSession();
        session.setSessionId(1L);
        session.setTitle("原标题");
        when(chatSessionMapper.selectById(1L)).thenReturn(session);

        String longTitle = "重命名标题测试".repeat(20); // 140字符

        ChatSession result = chatHistoryService.renameSession(1L, longTitle);

        assertEquals(100, result.getTitle().length());
        verify(chatSessionMapper).updateById(session);
    }
}
