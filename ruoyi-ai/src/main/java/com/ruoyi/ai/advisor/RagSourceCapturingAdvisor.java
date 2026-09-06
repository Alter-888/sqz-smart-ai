package com.ruoyi.ai.advisor;

import com.ruoyi.ai.context.ChatContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClientRequest;
import org.springframework.ai.chat.client.ChatClientResponse;
import org.springframework.ai.chat.client.advisor.api.CallAdvisor;
import org.springframework.ai.chat.client.advisor.api.CallAdvisorChain;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * RAG 溯源捕获 Advisor
 * 在 QuestionAnswerAdvisor 之前执行，独立进行向量检索，
 * 将检索到的文档元数据存入 ChatContext，供审计和前端展示使用。
 */
public class RagSourceCapturingAdvisor implements CallAdvisor {

    private static final Logger log = LoggerFactory.getLogger(RagSourceCapturingAdvisor.class);

    private final VectorStore vectorStore;
    private final int topK;
    private final double similarityThreshold;

    public RagSourceCapturingAdvisor(VectorStore vectorStore, int topK, double similarityThreshold) {
        this.vectorStore = vectorStore;
        this.topK = topK;
        this.similarityThreshold = similarityThreshold;
    }

    @Override
    public String getName() {
        return "RagSourceCapturingAdvisor";
    }

    @Override
    public int getOrder() {
        // 在 QuestionAnswerAdvisor 之前执行（数值越小越先执行）
        return 0;
    }

    @Override
    public ChatClientResponse adviseCall(ChatClientRequest request, CallAdvisorChain chain) {
        try {
            // 提取用户消息文本
            UserMessage userMessage = request.prompt().getUserMessage();
            String userText = (userMessage != null) ? userMessage.getText() : "";

            if (!userText.isEmpty()) {
                // 执行向量相似性搜索
                List<Document> docs = vectorStore.similaritySearch(
                        SearchRequest.builder()
                                .query(userText)
                                .topK(topK)
                                .similarityThreshold(similarityThreshold)
                                .build()
                );

                if (docs != null && !docs.isEmpty()) {
                    List<Map<String, String>> ragSources = docs.stream()
                            .map(doc -> {
                                Map<String, String> source = new HashMap<>();
                                Map<String, Object> metadata = doc.getMetadata();
                                source.put("title", String.valueOf(metadata.getOrDefault("title", "知识库")));
                                source.put("category", String.valueOf(metadata.getOrDefault("category", "")));
                                source.put("knowledgeId", String.valueOf(metadata.getOrDefault("knowledgeId", "")));
                                return source;
                            })
                            .collect(Collectors.toList());

                    ChatContext.setRagSources(ragSources);
                    log.debug("RAG 溯源捕获 - 命中 {} 条知识: {}", ragSources.size(),
                            ragSources.stream().map(s -> s.get("title")).collect(Collectors.joining(", ")));
                }
            }
        } catch (Exception e) {
            log.warn("RAG 溯源捕获异常（不影响正常对话）: {}", e.getMessage());
        }

        // 继续执行后续 advisor 链
        return chain.nextCall(request);
    }
}
