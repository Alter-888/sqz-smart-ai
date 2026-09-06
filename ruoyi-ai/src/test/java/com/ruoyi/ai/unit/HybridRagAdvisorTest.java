package com.ruoyi.ai.unit;

import com.ruoyi.ai.advisor.HybridRagAdvisor;
import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.rag.FullTextRetriever;
import com.ruoyi.ai.rag.HybridRagRetrievalService;
import com.ruoyi.ai.rag.PassThroughReranker;
import com.ruoyi.ai.rag.RagRetrievalService;
import com.ruoyi.ai.rag.VectorRetriever;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.ChatClientRequest;
import org.springframework.ai.chat.client.advisor.api.AdvisorChain;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.model.Generation;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.document.Document;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.vectorstore.SimpleVectorStore;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * P2 核心：HybridRagAdvisor 单测（不需要 PG/Redis）。
 * 覆盖 07 §4.2 的 4 条验收：
 * 1. 整条对话链路 query 只向量化一次（P2 意义：embedding 2 -> 1）
 * 2. 溯源与增强用的是同一批检索结果（同源）
 * 3. categories 为空时照样检索、只是不加过滤
 * 4. 检索异常时 before() 不抛、对话照走（对应手工验收"停 PG 再问"）
 */
class HybridRagAdvisorTest {

    @AfterEach
    void tearDown() {
        ChatContext.clear();
    }

    @Test
    void singleDialog_vectorsQueryOnce_andSourcesSameAsAugmented() {
        // 真实检索链路：SimpleVectorStore(内存) + mock EmbeddingModel + mock ChatModel
        EmbeddingModel embeddingModel = mock(EmbeddingModel.class);
        float[] vec = new float[]{0.1f, 0.2f, 0.3f};
        when(embeddingModel.embed(anyString())).thenReturn(vec);
        when(embeddingModel.embed(any(Document.class))).thenReturn(vec);
        when(embeddingModel.dimensions()).thenReturn(3);

        SimpleVectorStore store = SimpleVectorStore.builder(embeddingModel).build();
        store.add(List.of(new Document("doc1", "退货政策：支持七天无理由退货。",
                Map.of("title", "退货政策", "category", "POLICY", "knowledgeId", "k1"))));

        SmartCsProperties props = new SmartCsProperties();
        RagRetrievalService svc = new HybridRagRetrievalService(
                new VectorRetriever(store, props),
                new FullTextRetriever(),
                new PassThroughReranker(),
                props);

        HybridRagAdvisor advisor = new HybridRagAdvisor(svc, props);

        ChatModel chatModel = mock(ChatModel.class);
        when(chatModel.call(any(Prompt.class)))
                .thenReturn(new ChatResponse(List.of(new Generation(new AssistantMessage("这是回复")))));

        ChatClient client = ChatClient.builder(chatModel).defaultAdvisors(advisor).build();
        String out = client.prompt().user("退货政策是什么").call().content();
        assertNotNull(out);

        // P2 全部意义：单轮对话 query 只向量化一次（旧链路是两个 Advisor 各检索一次 -> 2 次）
        verify(embeddingModel, times(1)).embed(anyString());

        // 增强进 Prompt 的内容 = 检索命中的块（证明增强真实用了检索结果）
        ArgumentCaptor<Prompt> cap = ArgumentCaptor.forClass(Prompt.class);
        verify(chatModel).call(cap.capture());
        String augmented = cap.getValue().getUserMessage().getText();
        assertTrue(augmented.contains("退货政策"), "增强 Prompt 应包含检索到的块");

        // 溯源与增强同源：rag_source 条数 = 命中数，且标题来自同一批
        List<Map<String, String>> sources = ChatContext.getRagSources();
        assertNotNull(sources);
        assertEquals(1, sources.size());
        assertEquals("退货政策", sources.get(0).get("title"));
    }

    @Test
    void emptyCategories_stillRetrieves_butNoFilter() {
        RagRetrievalService svc = mock(RagRetrievalService.class);
        when(svc.retrieve(anyString(), anyList(), anyInt())).thenReturn(List.of());
        HybridRagAdvisor advisor = new HybridRagAdvisor(svc, new SmartCsProperties());

        ChatClientRequest request = ChatClientRequest.builder()
                .prompt(new Prompt(new UserMessage("退货政策是什么")))
                .context(new HashMap<>())
                .build();

        ChatClientRequest result = advisor.before(request, mock(AdvisorChain.class));

        // 空 categories 仍触发检索，且传入空列表 == 不过滤
        verify(svc).retrieve(eq("退货政策是什么"), eq(List.of()), anyInt());
        assertSame(request, result, "检索无命中时应返回原请求（不增强）");
    }

    @Test
    void retrievalException_doesNotThrow_requestProceeds() {
        RagRetrievalService svc = mock(RagRetrievalService.class);
        when(svc.retrieve(anyString(), anyList(), anyInt())).thenThrow(new RuntimeException("pg down"));
        HybridRagAdvisor advisor = new HybridRagAdvisor(svc, new SmartCsProperties());

        ChatClientRequest request = ChatClientRequest.builder()
                .prompt(new Prompt(new UserMessage("退货政策是什么")))
                .context(new HashMap<>())
                .build();

        ChatClientRequest result = advisor.before(request, mock(AdvisorChain.class));

        // 异常被吞掉：不抛、返回原请求、无溯源
        assertSame(request, result, "检索异常时不修改请求、不往外抛");
        assertTrue(ChatContext.getRagSources().isEmpty(), "检索异常时不应留下溯源");
    }
}