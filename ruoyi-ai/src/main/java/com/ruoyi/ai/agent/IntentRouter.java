package com.ruoyi.ai.agent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * 意图路由：规则优先 + LLM 兜底。
 * 规则命中的那一次是 0 延迟 0 成本，且把"寒暄"和"转人工"两类直接短路、
 * 省掉一次大模型调用。规则没命中才用 router 模型，模型输出还要过枚举白名单。
 */
@Component
public class IntentRouter {

    private static final Logger log = LoggerFactory.getLogger(IntentRouter.class);

    public enum Intent {
        PRODUCT("sales-advisor",  List.of("PRODUCT_INFO", "FAQ")),
        ORDER("order-service",    List.of()),
        AFTERSALES("after-sales", List.of("POLICY", "FAQ", "GUIDE")),
        ACCOUNT("account",        List.of()),
        KNOWLEDGE("knowledge",    List.of("POLICY", "FAQ", "GUIDE")),
        CHITCHAT(null, List.of()),
        HUMAN_HANDOFF(null, List.of()),
        CROSS_DOMAIN(null, List.of());

        public final String agentId;
        /** 该域允许检索的知识类别；空列表 = 不挂 RAG（order-service / account 就是空） */
        public final List<String> ragCategories;
        Intent(String agentId, List<String> ragCategories) {
            this.agentId = agentId;
            this.ragCategories = ragCategories;
        }
    }

    /** source: "rule" / "llm" / "fallback"，写进审计便于分析规则覆盖率 */
    public record RouteDecision(Intent intent, String agentId,
                                List<String> ragCategories, String source) {}

    /** LLM 兜底用结构化输出，结果用字符串接再手动转枚举 */
    private record LlmRoute(String intent, String reason) {}

    private static final Pattern CHITCHAT_P = Pattern.compile(
            "^(你好|您好|hi|hello|嗨|在吗|在不在|谢谢|感谢|辛苦了|再见|拜拜|好的|收到|嗯+|哦+)[!！。，,~\\s]*$",
            Pattern.CASE_INSENSITIVE);
    private static final Pattern HANDOFF_P = Pattern.compile("人工|真人|转接|找客服|人工客服");
    private static final Pattern CONJUNCTION_P = Pattern.compile("再|然后|顺便|另外|还有|同时|并且|以及");

    /**
     * 领域规则表：顺序敏感，越靠前优先级越高（AFTERSALES 必须在 ORDER 之前）。
     * "订单要退货"同时命中 ORDER 和 AFTERSALES，结果取决于声明顺序。
     */
    private static final List<Map.Entry<Intent, Pattern>> DOMAIN_RULES = List.of(
        // AFTERSALES: 退货/维修/保修/售后等。去掉裸"评价"，避免把"用户评价怎么样"（商品咨询，属PRODUCT）
        //   误判成售后；保留"差评/晒单/报修/故障"这类明显售后词。
        Map.entry(Intent.AFTERSALES, Pattern.compile(
            "退货|退款|换货|维修|保修|质保|三包|投诉|工单|售后|差评|晒单|报修|故障|坏了")),
        // ACCOUNT 排在 KNOWLEDGE 之前：地址/资料/通知类。
        Map.entry(Intent.ACCOUNT, Pattern.compile(
            "收货地址|默认地址|改地址|修改地址|新增地址|删除地址|地址|收货人|联系人|个人信息|我的资料|昵称|手机号|通知|未读|消息中心")),
        // KNOWLEDGE(FAQ层) 放到 ORDER 之前：接住"怎么查/支付方式/订单编号/多久发货"这类其实是知识问答的措辞，
        //   不能被 ORDER 的"订单/发货/快递"抢先。注意"什么时候到"不在这，交给 ORDER（那是具体物流状态）。
        Map.entry(Intent.KNOWLEDGE, Pattern.compile(
            "政策|规则|条款|流程|指南|说明|常见问题|支付方式|付款方式|怎么支付|如何支付|怎么付款|如何付款|" +
            "订单编号|订单号|(怎么|如何|怎样).*(查|查询|查看|看|联系|操作|下单)|支持哪些|" +
            "(可以用|能用|可以|支持).*(支付|付款|信用卡|花呗|分期|微信|支付宝|银联)|" +
            "(多久|几天|多长时间).*(发货|能到|到达|收到)|什么快递|哪家快递|发什么快递|下单.*(多久|几天|多长时间).*(发货|到)")),
        // ORDER: 订单/物流/快递状态。去掉"付款/支付"（支付方式类归知识），保留下单/收货/发货。
        Map.entry(Intent.ORDER, Pattern.compile(
            "订单|物流|快递|发货|运单|收货|签收|下单进度|配送进度|到哪了|什么时候到")),
        // PRODUCT: 商品咨询。补上"评价/怎么样/卖点/现货/报价"等，让商品咨询不依赖 LLM。
        Map.entry(Intent.PRODUCT, Pattern.compile(
            "推荐|买|购买|多少钱|价格|性价比|对比|参数|配置|库存|购物车|加购|结算|报价|" +
            "怎么样|好用吗|评价|口碑|卖点|亮点|值得买|续航|电池|屏幕|拍照|颜色|白色|黑色|蓝色|容量|尺寸|现货|有货|" +
            "哪个好|哪个更好|哪个值得买|NFC|公交卡|血氧|心率"))
    );

    private final ChatClient routerClient;

    public IntentRouter(@Qualifier("routerClient") ChatClient routerClient) {
        this.routerClient = routerClient;
    }

    /**
     * 路由入口。判定顺序本身就是设计（见 02 §8.1）。
     */
    public RouteDecision route(String message) {
        String msg = message == null ? "" : message.trim();

        if (msg.isEmpty() || CHITCHAT_P.matcher(msg).matches()) return decide(Intent.CHITCHAT, "rule");
        if (HANDOFF_P.matcher(msg).find())                       return decide(Intent.HUMAN_HANDOFF, "rule");

        List<Intent> hit = DOMAIN_RULES.stream()
                .filter(e -> e.getValue().matcher(msg).find())
                .map(Map.Entry::getKey).toList();

        if (hit.size() >= 2 && CONJUNCTION_P.matcher(msg).find()) return decide(Intent.CROSS_DOMAIN, "rule");
        if (!hit.isEmpty())                                       return decide(hit.get(0), "rule");

        return routeByLlm(msg);
    }

    private RouteDecision decide(Intent intent, String source) {
        log.info("意图路由 - intent: {}, agentId: {}, source: {}", intent, intent.agentId, source);
        return new RouteDecision(intent, intent.agentId, intent.ragCategories, source);
    }

    /**
     * LLM 兜底：只让模型吐一个标签，不让它自由发挥；结果用字符串接再手动转枚举。
     * 路由失败不能让整轮对话挂掉，降级到 KNOWLEDGE（这个域只读 + 有 RAG，最安全）。
     */
    private RouteDecision routeByLlm(String msg) {
        try {
            LlmRoute r = routerClient.prompt()
                    .user("用户消息：" + msg)
                    .call()
                    .entity(LlmRoute.class);
            Intent intent = parse(r == null ? null : r.intent());
            if (intent != null) {
                log.info("意图路由(LLM) - intent: {}, reason: {}", intent, r.reason());
                return decide(intent, "llm");
            }
            log.warn("路由模型返回了无法识别的意图: {}", r == null ? "null" : r.intent());
        } catch (Exception e) {
            log.warn("路由模型调用失败，降级到 KNOWLEDGE: {}", e.getMessage());
        }
        return decide(Intent.KNOWLEDGE, "fallback");
    }

    /**
     * 模型不允许直接指定 CROSS_DOMAIN，跨域只能由规则判定（02 §8.3）。
     * 无法识别（空串/非法枚举/markdown 代码块）统一返回 null。
     */
    private Intent parse(String raw) {
        if (raw == null || raw.isBlank()) return null;
        try {
            Intent i = Intent.valueOf(raw.trim().toUpperCase());
            return (i == Intent.CROSS_DOMAIN) ? null : i;
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }

    /** router 客户端不挂工具、不挂 RAG、不挂记忆：路由只看这一句话 */
    public static ChatClient buildRouterClient(ChatClient.Builder builder, String model) {
        return builder
                .defaultOptions(OpenAiChatOptions.builder()
                        .model(model)
                        .temperature(0.0)      // 分类任务，要确定性
                        .maxTokens(128)
                        .build())
                .defaultSystem("""
                        你是客服系统的意图分类器。只输出分类结果，不要回答用户问题。
                        可选 intent（必须原样返回其中一个）：
                        PRODUCT       商品搜索、推荐、对比、价格、购物车、结算
                        ORDER         订单查询、物流、支付、取消、确认收货
                        AFTERSALES    退换货、维修、保修、投诉、工单、商品评价
                        ACCOUNT       个人资料、收货地址、站内通知
                        KNOWLEDGE     政策条款、操作指南、规则说明
                        CHITCHAT      寒暄、闲聊、与业务无关
                        HUMAN_HANDOFF 明确要求人工客服
                        无法判断时返回 KNOWLEDGE。reason 用一句中文说明理由。
                        """)
                .build();
    }
}
