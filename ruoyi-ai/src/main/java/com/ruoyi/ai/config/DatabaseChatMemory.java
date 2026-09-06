package com.ruoyi.ai.config;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ruoyi.ai.entity.ChatMessage;
import com.ruoyi.ai.mapper.ChatMessageMapper;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * 基于数据库的 ChatMemory 实现
 * 直接读写 ai_chat_message 表，替代默认的内存实现
 * 服务重启后 AI 仍能记住之前的对话上下文
 */
@Component
@RequiredArgsConstructor
public class DatabaseChatMemory implements ChatMemory {

    private static final Logger log = LoggerFactory.getLogger(DatabaseChatMemory.class);

    private final ChatMessageMapper chatMessageMapper;

    @Value("${smart-cs.chat.max-memory-messages:20}")
    private int maxMemoryMessages;

    @Override
    public void add(String conversationId, List<Message> messages) {
        Long sessionId = Long.valueOf(conversationId);
        int insertedCount = 0;
        for (Message message : messages) {
            String role = toRoleString(message);
            String content = message.getText();

            // 跳过空内容的消息
            if (content == null || content.isEmpty()) {
                continue;
            }

            // 防止重试导致用户消息重复插入：检查该会话最近一条消息是否与当前相同
            if ("user".equals(role) && isDuplicateUserMessage(sessionId, content)) {
                log.info("ChatMemory.add - 跳过重复用户消息, sessionId: {}", sessionId);
                continue;
            }

            ChatMessage dbMsg = new ChatMessage();
            dbMsg.setSessionId(sessionId);
            dbMsg.setRole(role);
            dbMsg.setContent(content);
            chatMessageMapper.insert(dbMsg);
            insertedCount++;
        }
        log.debug("ChatMemory.add - sessionId: {}, 新增消息数: {}/{}", sessionId, insertedCount, messages.size());
    }

    /**
     * 检查该会话最近一条消息是否为相同内容的用户消息（重试去重）
     */
    private boolean isDuplicateUserMessage(Long sessionId, String content) {
        LambdaQueryWrapper<ChatMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ChatMessage::getSessionId, sessionId);
        wrapper.eq(ChatMessage::getRole, "user");
        wrapper.orderByDesc(ChatMessage::getCreateTime);
        wrapper.last("LIMIT 1");
        List<ChatMessage> lastMessages = chatMessageMapper.selectList(wrapper);
        return !lastMessages.isEmpty() && content.equals(lastMessages.get(0).getContent());
    }

    @Override
    public List<Message> get(String conversationId) {
        Long sessionId = Long.valueOf(conversationId);

        // 只返回最近 N 条消息（约 N/2 轮对话），避免无限制增长
        LambdaQueryWrapper<ChatMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ChatMessage::getSessionId, sessionId);
        wrapper.orderByDesc(ChatMessage::getCreateTime);
        wrapper.last("LIMIT " + maxMemoryMessages);
        List<ChatMessage> dbMessages = chatMessageMapper.selectList(wrapper);

        // 反转为时间正序
        Collections.reverse(dbMessages);

        List<Message> result = new ArrayList<>(dbMessages.size());
        for (ChatMessage dbMessage : dbMessages) {
            Message aiMessage = toSpringAiMessage(dbMessage);
            if (aiMessage != null) {
                result.add(aiMessage);
            }
        }
        log.debug("ChatMemory.get - sessionId: {}, 返回: {} 条消息 (限制: {})", sessionId, result.size(), maxMemoryMessages);
        return result;
    }

    @Override
    public void clear(String conversationId) {
        Long sessionId = Long.valueOf(conversationId);
        LambdaQueryWrapper<ChatMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ChatMessage::getSessionId, sessionId);
        chatMessageMapper.delete(wrapper);
        log.info("ChatMemory.clear - 已清除会话记忆: sessionId={}", sessionId);
    }

    /**
     * 将数据库消息转换为 Spring AI Message 对象
     */
    private Message toSpringAiMessage(ChatMessage dbMessage) {
        String role = dbMessage.getRole();
        String content = dbMessage.getContent() != null ? dbMessage.getContent() : "";
        return switch (role) {
            case "user" -> new UserMessage(content);
            case "assistant" -> new AssistantMessage(content);
            case "system" -> new SystemMessage(content);
            default -> new UserMessage(content);
        };
    }

    /**
     * 从 Spring AI Message 提取角色字符串
     */
    private String toRoleString(Message message) {
        if (message instanceof UserMessage) return "user";
        if (message instanceof AssistantMessage) return "assistant";
        if (message instanceof SystemMessage) return "system";
        return "user";
    }
}
