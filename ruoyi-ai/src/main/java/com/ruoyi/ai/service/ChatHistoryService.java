package com.ruoyi.ai.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.ai.entity.ChatMessage;
import com.ruoyi.ai.entity.ChatSession;
import com.ruoyi.ai.mapper.ChatMessageMapper;
import com.ruoyi.ai.mapper.ChatSessionMapper;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ChatHistoryService {

    private final ChatSessionMapper chatSessionMapper;
    private final ChatMessageMapper chatMessageMapper;
    private final ChatMemory chatMemory;

    public ChatSession createSession(Long userId, String title) {
        ChatSession session = new ChatSession();
        session.setUserId(userId);
        session.setTitle(title);
        session.setStatus(1);
        chatSessionMapper.insert(session);
        return session;
    }

    public List<ChatSession> listUserSessions(Long userId) {
        LambdaQueryWrapper<ChatSession> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ChatSession::getUserId, userId);
        wrapper.eq(ChatSession::getStatus, 1);
        // 置顶会话优先，再按更新时间倒序
        wrapper.orderByDesc(ChatSession::getIsPinned);
        wrapper.orderByDesc(ChatSession::getUpdateTime);
        return chatSessionMapper.selectList(wrapper);
    }

    public List<ChatSession> listAllSessions(int pageNum, int pageSize) {
        Page<ChatSession> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ChatSession> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(ChatSession::getUpdateTime);
        return chatSessionMapper.selectPage(page, wrapper).getRecords();
    }

    public void saveMessage(Long sessionId, String role, String content, String toolCalls) {
        ChatMessage message = new ChatMessage();
        message.setSessionId(sessionId);
        message.setRole(role);
        message.setContent(content);
        message.setToolCalls(toolCalls);
        chatMessageMapper.insert(message);
    }

    public List<ChatMessage> getSessionMessages(Long sessionId) {
        LambdaQueryWrapper<ChatMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ChatMessage::getSessionId, sessionId);
        wrapper.orderByAsc(ChatMessage::getCreateTime);
        return chatMessageMapper.selectList(wrapper);
    }

    public ChatSession getSession(Long sessionId) {
        return chatSessionMapper.selectById(sessionId);
    }

    /**
     * 验证会话归属权：确认 sessionId 属于 userId，管理员豁免
     */
    public void validateSessionOwnership(Long sessionId, Long userId) {
        if (SecurityUtils.isAdmin(userId)) {
            return;
        }
        ChatSession session = chatSessionMapper.selectById(sessionId);
        if (session == null) {
            throw new ServiceException("会话不存在");
        }
        if (!session.getUserId().equals(userId)) {
            throw new ServiceException("无权访问该会话");
        }
    }

    public void updateSessionTitle(Long sessionId, String title) {
        ChatSession session = chatSessionMapper.selectById(sessionId);
        if (session != null && (session.getTitle() == null || session.getTitle().isEmpty())) {
            session.setTitle(title.length() > 50 ? title.substring(0, 50) : title);
            chatSessionMapper.updateById(session);
        }
    }

    /**
     * 更新消息满意度反馈
     */
    public void updateFeedback(Long messageId, Integer feedback, Long userId) {
        ChatMessage msg = chatMessageMapper.selectById(messageId);
        if (msg == null) {
            throw new ServiceException("消息不存在");
        }
        // 通过消息的sessionId验证会话归属权（复用已有方法）
        validateSessionOwnership(msg.getSessionId(), userId);
        msg.setFeedback(feedback);
        chatMessageMapper.updateById(msg);
    }

    /**
     * 更新最近一条 assistant 消息的卡片数据
     */
    public void updateLastMessageCardsData(Long sessionId, String cardsData) {
        LambdaQueryWrapper<ChatMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ChatMessage::getSessionId, sessionId)
               .eq(ChatMessage::getRole, "assistant")
               .orderByDesc(ChatMessage::getCreateTime)
               .last("LIMIT 1");
        ChatMessage lastMsg = chatMessageMapper.selectOne(wrapper);
        if (lastMsg != null) {
            lastMsg.setCardsData(cardsData);
            chatMessageMapper.updateById(lastMsg);
        }
    }

    /**
     * 删除会话（软删除 + 清除消息 + 清除 ChatMemory）
     */
    public void deleteSession(Long sessionId) {
        ChatSession session = chatSessionMapper.selectById(sessionId);
        if (session == null) {
            throw new ServiceException("会话不存在");
        }

        // 1. 软删除会话：设置 status=0
        session.setStatus(0);
        chatSessionMapper.updateById(session);

        // 2. 删除该会话的所有消息
        LambdaQueryWrapper<ChatMessage> messageWrapper = new LambdaQueryWrapper<>();
        messageWrapper.eq(ChatMessage::getSessionId, sessionId);
        chatMessageMapper.delete(messageWrapper);

        // 3. 清除 ChatMemory 中的缓存
        chatMemory.clear(sessionId.toString());
    }

    /**
     * 切换会话置顶状态
     */
    public ChatSession togglePin(Long sessionId) {
        ChatSession session = chatSessionMapper.selectById(sessionId);
        if (session == null) {
            throw new ServiceException("会话不存在");
        }
        boolean currentlyPinned = session.getIsPinned() != null && session.getIsPinned() == 1;
        session.setIsPinned(currentlyPinned ? 0 : 1);
        session.setPinTime(currentlyPinned ? null : LocalDateTime.now());
        chatSessionMapper.updateById(session);
        return session;
    }

    /**
     * 手动重命名会话标题（用户主动操作）
     */
    public ChatSession renameSession(Long sessionId, String title) {
        ChatSession session = chatSessionMapper.selectById(sessionId);
        if (session == null) {
            throw new ServiceException("会话不存在");
        }
        session.setTitle(title.length() > 100 ? title.substring(0, 100) : title);
        chatSessionMapper.updateById(session);
        return session;
    }
}
