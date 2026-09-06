package com.ruoyi.ai.agent;

import com.ruoyi.ai.agent.worker.AbstractWorkerAgent;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** agentId → ChatAgent 注册表，启动时打印清单（验收第一条） */
@Component
@RequiredArgsConstructor
public class AgentRegistry {

    private static final Logger log = LoggerFactory.getLogger(AgentRegistry.class);

    private final List<AbstractWorkerAgent> workers;

    private final Map<String, ChatAgent> registry = new LinkedHashMap<>();

    @PostConstruct
    public void init() {
        for (AbstractWorkerAgent w : workers) {
            if (registry.putIfAbsent(w.getId(), w) != null) {
                log.warn("检测到重复 agentId，后者已忽略: {}", w.getId());
            }
        }
        log.info("Agent 注册完成 - 共 {} 个: {}", registry.size(), registry.keySet());
    }

    public ChatAgent get(String agentId) {
        ChatAgent agent = registry.get(agentId);
        if (agent == null) {
            throw new IllegalStateException("未注册的 Agent: " + agentId);
        }
        return agent;
    }
}
