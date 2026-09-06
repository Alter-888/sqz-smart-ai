package com.ruoyi.ai.agent;

import java.util.List;

/** 一轮 Agent 执行结果。text=回复文本；toolCalls=本轮实际调用的工具名；resolved=是否给出有效回复 */
public record AgentResult(String text, List<String> toolCalls, boolean resolved) {}
