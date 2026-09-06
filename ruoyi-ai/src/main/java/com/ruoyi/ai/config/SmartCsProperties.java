package com.ruoyi.ai.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * smart-cs.* 配置绑定：把散落在各类 @Value / @Value 上的可调参数收拢到一处。
 * 对应 application.yml 的 smart-cs 段（agent / model / rag / eval / chat），
 * 供多智能体（P4）、RAG（P2/P5）、评测（P6）及工具预算守卫（P4）统一读取。
 */
@Data
@Component
@ConfigurationProperties(prefix = "smart-cs")
public class SmartCsProperties {

    private Agent agent = new Agent();
    private Model model = new Model();
    private Rag rag = new Rag();
    private Eval eval = new Eval();

    @Data
    public static class Agent {
        /** 单轮工具调用上限，超出即停并提示用户 */
        private int toolBudgetPerTurn = 8;
        /** 关掉后跨域请求退化为按首个命中域直连 */
        private boolean supervisorEnabled = true;
        /** Supervisor 单轮最多委派几个 Worker */
        private int supervisorMaxDelegations = 3;
        /** 异步抽检采样率 */
        private double evalSampleRate = 0.1;
        /** 高危操作先出待确认单 */
        private boolean hitlEnabled = true;
        /** 需要人工确认的高危工具 */
        private List<String> hitlTools =
                List.of("cancelOrder", "payOrder", "checkoutFromCart", "clearCart");
    }

    @Data
    public static class Model {
        /** 5 个领域 Worker 用的模型 */
        private String worker = "qwen3.7-flash";
        /** 意图路由兜底用的模型 */
        private String router = "qwen3.7-flash";
        /** 异步评估 judge 用的模型 */
        private String judge  = "qwen3.7-flash";
    }

    @Data
    public static class Rag {
        private double similarityThreshold = 0.4;
        private int vectorTopK = 20;
        private boolean fullTextEnabled = false;
        private int fullTextTopK = 20;
        private int rrfK = 60;
        private int fusionTopK = 8;
        private int finalTopK = 4;
        private int chunkSize = 400;
        private boolean parentExpand = false;
        private Rerank rerank = new Rerank();

        @Data
        public static class Rerank {
            private boolean enabled = false;
        }
    }

    @Data
    public static class Eval {
        private String dataset = "v1";
        private int k = 8;
        private boolean runAgent = false;
        private boolean judgeEnabled = false;
        private int userId = -1;
        private boolean legacyRetrieval = false;
    }
}