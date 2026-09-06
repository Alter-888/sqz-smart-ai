package com.ruoyi.ai.agent;

import lombok.Builder;
import lombok.Data;

import java.util.List;

/** 一轮对话的上下文：身份 + 意图 + 允许检索的知识类别 */
@Data
@Builder
public class AgentContext {

    private Long userId;
    private Long sessionId;
    private IntentRouter.Intent intent;

    /**
     * 本轮允许检索的知识类别；空 = 不挂 RAG。
     * 刻意存「类别列表」而不是 Spring AI 过滤表达式字符串：
     * 混合检索有两路（向量走 filterExpression，全文走原生 SQL 参数绑定），
     * 存列表才能让两路从同一个来源各自派生，也避免把字符串拼进 SQL。
     */
    private List<String> ragCategories;
}
