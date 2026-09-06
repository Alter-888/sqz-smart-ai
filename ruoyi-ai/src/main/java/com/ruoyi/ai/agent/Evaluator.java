package com.ruoyi.ai.agent;

import com.ruoyi.ai.context.ChatContext;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * 异步抽检评估（P7 实现）。
 * P4 阶段先给空实现：不抽检、不阻塞回复，保持 ChatOrchestrator 可编译可启动。
 */
@Component
public class Evaluator {

    public void spotCheckAsync(String message, ChatOrchestrator.TurnResult turn,
                               List<Map<String, String>> ragSources) {
        // P7 实现：采样抽检打分，写审计
    }
}
