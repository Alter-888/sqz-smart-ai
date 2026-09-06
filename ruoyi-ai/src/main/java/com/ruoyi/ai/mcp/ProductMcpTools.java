package com.ruoyi.ai.mcp;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.entity.ToolCallLog;
import com.ruoyi.ai.event.ToolCallEvent;
import com.ruoyi.ai.mapper.ToolCallLogMapper;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.entity.Review;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.business.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

import com.baomidou.mybatisplus.core.metadata.IPage;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * MCP 商品工具：为 AI 提供商品搜索、详情、比较、推荐能力
 * 通过 MCP 协议暴露，同时支持 MethodToolCallbackProvider 直接调用
 */
@Component
@RequiredArgsConstructor
public class ProductMcpTools {

    private static final Logger log = LoggerFactory.getLogger(ProductMcpTools.class);

    private final ProductMapper productMapper;
    private final ToolCallLogMapper toolCallLogMapper;
    private final ApplicationEventPublisher eventPublisher;
    private final ReviewService reviewService;

    private void logToolCall(String toolName, String params, boolean success, long durationMs, String errorMsg) {
        try {
            ToolCallLog callLog = new ToolCallLog();
            callLog.setToolName(toolName);
            callLog.setToolParams(params);
            callLog.setSessionId(ChatContext.getSessionId());
            callLog.setSuccessFlag(success ? 1 : 0);
            callLog.setDurationMs(durationMs);
            callLog.setErrorMsg(errorMsg);
            toolCallLogMapper.insert(callLog);
        } catch (Exception e) {
            log.warn("记录工具调用日志失败: {}", e.getMessage());
        }
    }

    private void publishToolCallEvent(String toolName, String description) {
        publishToolCallEvent(toolName, description, null, null);
    }

    private void publishToolCallEvent(String toolName, String description,
                                       String cardType, List<Map<String, Object>> cardData) {
        try {
            Long sessionId = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, toolName, description, sessionId, cardType, cardData));
        } catch (Exception e) {
            log.warn("发布工具调用事件失败: {}", e.getMessage());
        }
    }

    @Tool(description = "搜索商品列表。根据关键词、分类、价格范围搜索上架商品。当用户想找某类商品、查看有什么商品、搜索商品时使用此工具。")
    public List<Map<String, Object>> searchProducts(
            @ToolParam(description = "搜索关键词，匹配商品名称、卖点、描述。如：iPhone、MacBook、骁龙", required = false) String keyword,
            @ToolParam(description = "商品分类，可选值：手机、笔记本电脑、平板电脑、耳机、智能手表/手环、充电器/配件。当用户按品类搜索时优先使用此参数", required = false) String category,
            @ToolParam(description = "最低价格", required = false) BigDecimal minPrice,
            @ToolParam(description = "最高价格", required = false) BigDecimal maxPrice) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        String params = String.format("keyword=%s, category=%s, minPrice=%s, maxPrice=%s", keyword, category, minPrice, maxPrice);
        log.info("工具调用 - 搜索商品: {}", params);
        publishToolCallEvent("searchProducts", "正在搜索商品...");
        try {
            LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Product::getStatus, 1);
            if (keyword != null && !keyword.isEmpty()) {
                wrapper.and(w -> w.like(Product::getName, keyword)
                        .or().like(Product::getCategory, keyword)
                        .or().like(Product::getHighlights, keyword)
                        .or().like(Product::getDescription, keyword));
            }
            if (category != null && !category.isEmpty()) {
                wrapper.eq(Product::getCategory, category);
            }
            if (minPrice != null) {
                wrapper.ge(Product::getPrice, minPrice);
            }
            if (maxPrice != null) {
                wrapper.le(Product::getPrice, maxPrice);
            }
            wrapper.orderByDesc(Product::getCreateTime);
            wrapper.last("LIMIT 10");

            List<Product> products = productMapper.selectList(wrapper);

            // 智能降级：keyword + category 同时设置但无结果时，放宽条件重试
            if (products.isEmpty() && keyword != null && !keyword.isEmpty()
                    && category != null && !category.isEmpty()) {
                log.info("精确搜索无结果，尝试放宽条件（仅关键词）");
                LambdaQueryWrapper<Product> fallback = new LambdaQueryWrapper<>();
                fallback.eq(Product::getStatus, 1);
                fallback.and(w -> w.like(Product::getName, keyword)
                        .or().like(Product::getCategory, keyword)
                        .or().like(Product::getHighlights, keyword)
                        .or().like(Product::getDescription, keyword));
                if (minPrice != null) fallback.ge(Product::getPrice, minPrice);
                if (maxPrice != null) fallback.le(Product::getPrice, maxPrice);
                fallback.orderByDesc(Product::getCreateTime);
                fallback.last("LIMIT 10");
                products = productMapper.selectList(fallback);
            }

            if (products.isEmpty()) {
                ChatContext.addToolCallName("searchProducts");
                return List.of(Map.of("message", "未找到符合条件的商品，您可以换个关键词试试"));
            }
            List<Map<String, Object>> result = products.stream().map(this::toSummaryMap).collect(Collectors.toList());
            publishToolCallEvent("searchProducts", "搜索到 " + result.size() + " 个商品", "product", result);
            ChatContext.addToolCallName("searchProducts");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("searchProducts", params, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "获取商品详细信息，包括价格、核心卖点、规格参数、库存等。当用户询问某个商品的具体信息时使用此工具。")
    public Map<String, Object> getProductDetail(
            @ToolParam(description = "商品ID") Long productId) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        String params = String.valueOf(productId);
        log.info("工具调用 - 获取商品详情: productId={}", productId);
        try {
            LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Product::getProductId, productId);
            wrapper.eq(Product::getStatus, 1);
            Product product = productMapper.selectOne(wrapper);
            if (product == null) {
                ChatContext.addToolCallName("getProductDetail");
                return Map.of("error", "商品不存在或已下架");
            }
            Map<String, Object> detail = toDetailMap(product);
            publishToolCallEvent("getProductDetail", "查询到商品详情", "product", List.of(detail));
            ChatContext.addToolCallName("getProductDetail");
            return detail;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("getProductDetail", params, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "比较两个商品的参数。当用户想对比两个商品时使用此工具。")
    public Map<String, Object> compareProducts(
            @ToolParam(description = "第一个商品ID") Long productId1,
            @ToolParam(description = "第二个商品ID") Long productId2) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        String params = productId1 + " vs " + productId2;
        log.info("工具调用 - 比较商品: {}", params);
        try {
            Product p1 = productMapper.selectById(productId1);
            Product p2 = productMapper.selectById(productId2);

            if (p1 == null || p2 == null) {
                ChatContext.addToolCallName("compareProducts");
                return Map.of("error", "一个或多个商品不存在");
            }

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("商品1", toDetailMap(p1));
            result.put("商品2", toDetailMap(p2));

            if (p1.getPrice() != null && p2.getPrice() != null) {
                BigDecimal diff = p1.getPrice().subtract(p2.getPrice());
                if (diff.compareTo(BigDecimal.ZERO) > 0) {
                    result.put("价格对比", p2.getName() + " 便宜 " + diff + " 元");
                } else if (diff.compareTo(BigDecimal.ZERO) < 0) {
                    result.put("价格对比", p1.getName() + " 便宜 " + diff.abs() + " 元");
                } else {
                    result.put("价格对比", "两款商品价格相同");
                }
            }
            publishToolCallEvent("compareProducts", "正在比较两个商品", "product", List.of(toSummaryMap(p1), toSummaryMap(p2)));
            ChatContext.addToolCallName("compareProducts");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("compareProducts", params, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "根据使用场景和预算推荐商品。当用户需要购买建议、推荐时使用此工具。")
    public List<Map<String, Object>> recommendProducts(
            @ToolParam(description = "使用场景或商品分类描述。场景如：办公、游戏、送礼、追剧、运动。分类如：手机、笔记本电脑、平板电脑、耳机", required = false) String scene,
            @ToolParam(description = "预算上限（元）", required = false) BigDecimal budget) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        String params = String.format("scene=%s, budget=%s", scene, budget);
        log.info("工具调用 - 推荐商品: {}", params);
        publishToolCallEvent("recommendProducts", "正在为您推荐商品...");
        try {
            LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Product::getStatus, 1);
            if (budget != null) {
                wrapper.le(Product::getPrice, budget);
            }
            if (scene != null && !scene.isEmpty()) {
                wrapper.and(w -> w.like(Product::getName, scene)
                        .or().like(Product::getCategory, scene)
                        .or().like(Product::getHighlights, scene)
                        .or().like(Product::getDescription, scene));
            }
            wrapper.orderByDesc(Product::getCreateTime);
            wrapper.last("LIMIT 5");

            List<Product> products = productMapper.selectList(wrapper);
            if (products.isEmpty()) {
                ChatContext.addToolCallName("recommendProducts");
                return List.of(Map.of("message", "暂无符合条件的推荐商品，您可以调整预算或场景再试"));
            }
            List<Map<String, Object>> result = products.stream().map(this::toSummaryMap).collect(Collectors.toList());
            publishToolCallEvent("recommendProducts", "为您推荐了 " + result.size() + " 个商品", "product", result);
            ChatContext.addToolCallName("recommendProducts");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("recommendProducts", params, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    private Map<String, Object> toSummaryMap(Product p) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("productId", p.getProductId());
        map.put("name", p.getName());
        map.put("category", p.getCategory());
        map.put("price", p.getPrice());
        map.put("stock", p.getStock());
        map.put("imageUrl", p.getImageUrl() != null ? p.getImageUrl() : "");
        map.put("highlights", p.getHighlights() != null ? p.getHighlights() : "");
        return map;
    }

    private Map<String, Object> toDetailMap(Product p) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("productId", p.getProductId());
        map.put("name", p.getName());
        map.put("category", p.getCategory());
        map.put("price", p.getPrice());
        map.put("stock", p.getStock());
        map.put("highlights", p.getHighlights() != null ? p.getHighlights() : "");
        map.put("description", p.getDescription() != null ? p.getDescription() : "");
        map.put("imageUrl", p.getImageUrl() != null ? p.getImageUrl() : "");
        map.put("refundPolicy", p.getRefundPolicy() != null ? p.getRefundPolicy() : "");
        map.put("warrantyInfo", p.getWarrantyInfo() != null ? p.getWarrantyInfo() : "");
        map.put("afterSaleNote", p.getAfterSaleNote() != null ? p.getAfterSaleNote() : "");
        // 追加评价统计
        try {
            Map<String, Object> stats = reviewService.getProductStats(p.getProductId());
            map.put("avgRating", stats.get("avgRating"));
            map.put("reviewCount", stats.get("count"));
        } catch (Exception e) {
            map.put("avgRating", 0);
            map.put("reviewCount", 0);
        }
        return map;
    }

    @Tool(description = "查询商品的用户评价列表。当用户想了解某个商品的评价、口碑、其他买家评论时使用此工具。")
    public Map<String, Object> getProductReviews(
            @ToolParam(description = "商品ID") Long productId) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        String params = String.valueOf(productId);
        log.info("工具调用 - 查询商品评价: productId={}", productId);
        publishToolCallEvent("getProductReviews", "正在查询商品评价...");
        try {
            Map<String, Object> result = new LinkedHashMap<>();
            // 统计数据
            Map<String, Object> stats = reviewService.getProductStats(productId);
            result.put("avgRating", stats.get("avgRating"));
            result.put("reviewCount", stats.get("count"));

            // 最新5条评价
            IPage<Review> page = reviewService.listByProductId(productId, 1, 5);
            List<Map<String, Object>> reviews = page.getRecords().stream().map(r -> {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("rating", r.getRating());
                m.put("content", r.getContent());
                m.put("nickName", r.getNickName() != null ? r.getNickName() : "匿名用户");
                m.put("createTime", r.getCreateTime() != null ? r.getCreateTime().toString() : "");
                return m;
            }).collect(Collectors.toList());
            result.put("reviews", reviews);

            if (reviews.isEmpty()) {
                result.put("message", "该商品暂无用户评价");
            }
            ChatContext.addToolCallName("getProductReviews");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("getProductReviews", params, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }
}
