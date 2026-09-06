package com.ruoyi.ai.mcp;

import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.entity.ToolCallLog;
import com.ruoyi.ai.event.ToolCallEvent;
import com.ruoyi.ai.mapper.ToolCallLogMapper;
import com.ruoyi.business.entity.Review;
import com.ruoyi.business.service.ReviewService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * MCP 评价工具：为 AI 提供商品评价提交、评价状态查询能力
 * 通过 MCP 协议暴露，同时支持 MethodToolCallbackProvider 直接调用
 */
@Component
@RequiredArgsConstructor
public class ReviewMcpTools {

    private static final Logger log = LoggerFactory.getLogger(ReviewMcpTools.class);

    private final ReviewService reviewService;
    private final ToolCallLogMapper toolCallLogMapper;
    private final ApplicationEventPublisher eventPublisher;

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
        try {
            Long sessionId = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, toolName, description, sessionId));
        } catch (Exception e) {
            log.warn("发布工具调用事件失败: {}", e.getMessage());
        }
    }

    private void publishToolCallEvent(String toolName, String description, List<String> refreshTypes) {
        try {
            Long sessionId = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, toolName, description, sessionId, null, null, refreshTypes));
        } catch (Exception e) {
            log.warn("发布工具调用事件失败: {}", e.getMessage());
        }
    }

    @Tool(description = "提交商品评价。用户确认收货后可以对购买的商品进行评分和评价。评分范围1-5分。当用户要评价商品、写评论时使用此工具。")
    public Map<String, Object> submitProductReview(
            @ToolParam(description = "订单项ID") Long orderItemId,
            @ToolParam(description = "评分，1-5分，5分为最高") Integer rating,
            @ToolParam(description = "评价内容") String content) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 提交商品评价: orderItemId={}, rating={}, userId={}", orderItemId, rating, userId);
        publishToolCallEvent("submitProductReview", "正在提交商品评价...", List.of("review"));
        try {
            if (rating == null || rating < 1 || rating > 5) {
                ChatContext.addToolCallName("submitProductReview");
                return Map.of("error", "评分必须在1-5之间");
            }
            if (content == null || content.trim().isEmpty()) {
                ChatContext.addToolCallName("submitProductReview");
                return Map.of("error", "评价内容不能为空");
            }

            Review review = reviewService.submitReview(userId, orderItemId, rating, content);
            log.info("工具调用 - 提交评价成功: reviewId={}, orderItemId={}", review.getReviewId(), orderItemId);
            ChatContext.addToolCallName("submitProductReview");
            return Map.of(
                    "reviewId", review.getReviewId(),
                    "message", "评价提交成功，感谢您的反馈！"
            );
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("submitProductReview");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("submitProductReview",
                    "orderItemId=" + orderItemId + ",rating=" + rating + ",userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "检查某个订单商品是否已经评价过。当用户想评价商品前先确认是否已评价时使用此工具。")
    public Map<String, Object> checkReviewStatus(
            @ToolParam(description = "订单项ID") Long orderItemId) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 检查评价状态: orderItemId={}, userId={}", orderItemId, userId);
        publishToolCallEvent("checkReviewStatus", "正在检查评价状态...");
        try {
            boolean reviewed = reviewService.hasReviewed(orderItemId, userId);

            publishToolCallEvent("checkReviewStatus", reviewed ? "该商品已评价" : "该商品未评价");
            ChatContext.addToolCallName("checkReviewStatus");
            return Map.of(
                    "orderItemId", orderItemId,
                    "reviewed", reviewed,
                    "message", reviewed ? "该订单商品已评价" : "该订单商品尚未评价，可以提交评价"
            );
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("checkReviewStatus");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("checkReviewStatus", "orderItemId=" + orderItemId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "查询当前用户的评价历史记录。当用户想查看自己写过的评价、评价记录时使用此工具。")
    public Map<String, Object> queryMyReviews() {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 查询我的评价, userId: {}", userId);
        publishToolCallEvent("queryMyReviews", "正在查询评价记录...");
        try {
            var page = reviewService.listByUserId(userId, 1, 10);
            List<Review> reviews = page.getRecords();
            if (reviews.isEmpty()) {
                ChatContext.addToolCallName("queryMyReviews");
                return Map.of("message", "您暂无评价记录");
            }
            List<Map<String, Object>> reviewList = reviews.stream().map(r -> {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("productName", r.getProductName() != null ? r.getProductName() : "");
                map.put("rating", r.getRating());
                map.put("content", r.getContent());
                map.put("createTime", r.getCreateTime() != null ? r.getCreateTime().toString() : "");
                return map;
            }).collect(Collectors.toList());

            publishToolCallEvent("queryMyReviews", "查询到 " + reviewList.size() + " 条评价");
            ChatContext.addToolCallName("queryMyReviews");
            return Map.of("reviews", reviewList, "total", page.getTotal());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryMyReviews", "userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

}
