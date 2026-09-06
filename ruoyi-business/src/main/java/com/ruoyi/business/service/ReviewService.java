package com.ruoyi.business.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.business.entity.Order;
import com.ruoyi.business.entity.OrderItem;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.entity.Review;
import com.ruoyi.business.enums.OrderStatus;
import com.ruoyi.business.mapper.OrderItemMapper;
import com.ruoyi.business.mapper.OrderMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.business.mapper.ReviewMapper;
import com.ruoyi.common.exception.ServiceException;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private static final Logger log = LoggerFactory.getLogger(ReviewService.class);

    private final ReviewMapper reviewMapper;
    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final ProductMapper productMapper;

    /**
     * 提交评价
     */
    public Review submitReview(Long userId, Long orderItemId, Integer rating, String content) {
        // 检查是否已评价
        if (hasReviewed(orderItemId)) {
            throw new ServiceException("该商品已评价，不可重复评价");
        }

        // 查询订单项
        OrderItem item = orderItemMapper.selectById(orderItemId);
        if (item == null) {
            throw new ServiceException("订单项不存在");
        }

        // 校验订单归属和状态
        Order order = orderMapper.selectById(item.getOrderId());
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        if (!order.getUserId().equals(userId)) {
            throw new ServiceException("无权评价该订单");
        }
        if (!OrderStatus.DELIVERED.getCode().equals(order.getStatus())) {
            throw new ServiceException("只有已签收的订单才能评价");
        }

        Review review = new Review();
        review.setOrderId(item.getOrderId());
        review.setOrderItemId(orderItemId);
        review.setProductId(item.getProductId());
        review.setUserId(userId);
        review.setRating(rating);
        review.setContent(content);
        review.setStatus(1);
        reviewMapper.insert(review);

        log.info("评价提交成功: orderItemId={}, productId={}, rating={}", orderItemId, item.getProductId(), rating);
        return review;
    }

    /**
     * 商品评价列表（分页）
     */
    public IPage<Review> listByProductId(Long productId, int pageNum, int pageSize) {
        return listByProductId(productId, pageNum, pageSize, null);
    }

    /**
     * 商品评价列表（分页，支持按评价等级筛选）
     * @param ratingLevel good=好评(>=4), mid=中评(=3), bad=差评(<=2), null=全部
     */
    public IPage<Review> listByProductId(Long productId, int pageNum, int pageSize, String ratingLevel) {
        Page<Review> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Review> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Review::getProductId, productId);
        wrapper.eq(Review::getStatus, 1);

        if ("good".equals(ratingLevel)) {
            wrapper.ge(Review::getRating, 4);
        } else if ("mid".equals(ratingLevel)) {
            wrapper.eq(Review::getRating, 3);
        } else if ("bad".equals(ratingLevel)) {
            wrapper.le(Review::getRating, 2);
        }

        wrapper.orderByDesc(Review::getCreateTime);
        IPage<Review> result = reviewMapper.selectPage(page, wrapper);
        fillNickNames(result.getRecords());
        return result;
    }

    /**
     * 获取商品评价统计：平均评分 + 评价数量 + 好评率 + 各等级数量
     */
    public Map<String, Object> getProductStats(Long productId) {
        LambdaQueryWrapper<Review> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Review::getProductId, productId);
        wrapper.eq(Review::getStatus, 1);
        List<Review> reviews = reviewMapper.selectList(wrapper);

        Map<String, Object> stats = new HashMap<>();
        int count = reviews.size();
        stats.put("count", count);

        if (reviews.isEmpty()) {
            stats.put("avgRating", 0.0);
            stats.put("goodCount", 0L);
            stats.put("midCount", 0L);
            stats.put("badCount", 0L);
            stats.put("goodRate", 0.0);
        } else {
            double avg = reviews.stream().mapToInt(Review::getRating).average().orElse(0);
            stats.put("avgRating", Math.round(avg * 10) / 10.0);

            long goodCount = reviews.stream().filter(r -> r.getRating() >= 4).count();
            long midCount = reviews.stream().filter(r -> r.getRating() == 3).count();
            long badCount = reviews.stream().filter(r -> r.getRating() <= 2).count();
            stats.put("goodCount", goodCount);
            stats.put("midCount", midCount);
            stats.put("badCount", badCount);
            stats.put("goodRate", Math.round(goodCount * 1000.0 / count) / 10.0);
        }
        return stats;
    }

    /**
     * 检查是否已评价
     */
    public boolean hasReviewed(Long orderItemId) {
        LambdaQueryWrapper<Review> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Review::getOrderItemId, orderItemId);
        return reviewMapper.selectCount(wrapper) > 0;
    }

    /**
     * 根据订单项ID查询评价详情
     * @return 评价对象，未评价则返回null
     */
    public Review getByOrderItemId(Long orderItemId) {
        LambdaQueryWrapper<Review> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Review::getOrderItemId, orderItemId);
        wrapper.last("LIMIT 1");
        Review review = reviewMapper.selectOne(wrapper);
        if (review != null) {
            Product product = productMapper.selectById(review.getProductId());
            if (product != null) {
                review.setProductName(product.getName());
            }
        }
        return review;
    }

    /**
     * 检查是否已评价（带用户所有权校验）
     */
    public boolean hasReviewed(Long orderItemId, Long userId) {
        OrderItem item = orderItemMapper.selectById(orderItemId);
        if (item == null) {
            throw new ServiceException("订单项不存在");
        }
        Order order = orderMapper.selectById(item.getOrderId());
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        if (!order.getUserId().equals(userId)) {
            throw new ServiceException("该订单项不属于当前用户");
        }
        return hasReviewed(orderItemId);
    }

    /**
     * 查询用户自己的评价历史（分页）
     */
    public IPage<Review> listByUserId(Long userId, int pageNum, int pageSize) {
        Page<Review> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Review> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Review::getUserId, userId);
        wrapper.orderByDesc(Review::getCreateTime);
        IPage<Review> result = reviewMapper.selectPage(page, wrapper);
        fillProductNames(result.getRecords());
        return result;
    }

    /**
     * 管理员分页查询所有评价（支持按商品ID和评分筛选）
     */
    public IPage<Review> listAll(int pageNum, int pageSize, Long productId, Integer rating) {
        Page<Review> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Review> wrapper = new LambdaQueryWrapper<>();
        if (productId != null) {
            wrapper.eq(Review::getProductId, productId);
        }
        if (rating != null) {
            wrapper.eq(Review::getRating, rating);
        }
        wrapper.orderByDesc(Review::getCreateTime);
        IPage<Review> result = reviewMapper.selectPage(page, wrapper);
        fillNickNames(result.getRecords());
        fillProductNames(result.getRecords());
        return result;
    }

    /**
     * 管理员更新评价状态（显示/隐藏）
     */
    public void updateStatus(Long reviewId, Integer status) {
        Review review = reviewMapper.selectById(reviewId);
        if (review == null) {
            throw new ServiceException("评价不存在");
        }
        review.setStatus(status);
        reviewMapper.updateById(review);
        log.info("评价状态更新: reviewId={}, status={}", reviewId, status);
    }

    /**
     * 管理员回复评价
     */
    public void adminReply(Long reviewId, String replyContent) {
        Review review = reviewMapper.selectById(reviewId);
        if (review == null) {
            throw new ServiceException("评价不存在");
        }
        review.setAdminReply(replyContent);
        review.setReplyTime(LocalDateTime.now());
        reviewMapper.updateById(review);
        log.info("管理员回复评价: reviewId={}, replyContent={}", reviewId, replyContent);
    }

    /**
     * 管理员删除评价
     */
    public void deleteReview(Long reviewId) {
        Review review = reviewMapper.selectById(reviewId);
        if (review == null) {
            throw new ServiceException("评价不存在");
        }
        reviewMapper.deleteById(reviewId);
        log.info("评价删除: reviewId={}", reviewId);
    }

    /**
     * 全局评价统计概览（管理员）
     * @return totalReviews, goodRate, unrepliedCount, todayNewCount
     */
    public Map<String, Object> getOverviewStats() {
        Map<String, Object> stats = new HashMap<>();
        long totalReviews = reviewMapper.selectCount(null);
        stats.put("totalReviews", totalReviews);

        if (totalReviews == 0) {
            stats.put("goodRate", 0.0);
            stats.put("unrepliedCount", 0L);
            stats.put("todayNewCount", 0L);
            return stats;
        }

        // 好评率(rating >= 4)
        LambdaQueryWrapper<Review> goodWrapper = new LambdaQueryWrapper<>();
        goodWrapper.ge(Review::getRating, 4);
        long goodCount = reviewMapper.selectCount(goodWrapper);
        stats.put("goodRate", Math.round(goodCount * 1000.0 / totalReviews) / 10.0);

        // 待回复数
        LambdaQueryWrapper<Review> unrepliedWrapper = new LambdaQueryWrapper<>();
        unrepliedWrapper.isNull(Review::getAdminReply);
        long unrepliedCount = reviewMapper.selectCount(unrepliedWrapper);
        stats.put("unrepliedCount", unrepliedCount);

        // 今日新增
        LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LambdaQueryWrapper<Review> todayWrapper = new LambdaQueryWrapper<>();
        todayWrapper.ge(Review::getCreateTime, todayStart);
        long todayNewCount = reviewMapper.selectCount(todayWrapper);
        stats.put("todayNewCount", todayNewCount);

        return stats;
    }

    /**
     * 按商品分组的评价摘要列表（管理员）
     * 返回有评价的商品及其统计信息，支持评分和日期范围筛选
     */
    public Map<String, Object> getProductSummary(int pageNum, int pageSize, String productName,
                                                  String ratingLevel, String beginTime, String endTime) {
        // 1. 构建查询条件
        LambdaQueryWrapper<Review> wrapper = new LambdaQueryWrapper<>();
        // 评分等级筛选
        if ("good".equals(ratingLevel)) {
            wrapper.ge(Review::getRating, 4);
        } else if ("mid".equals(ratingLevel)) {
            wrapper.eq(Review::getRating, 3);
        } else if ("bad".equals(ratingLevel)) {
            wrapper.le(Review::getRating, 2);
        }
        // 日期范围筛选
        if (beginTime != null && !beginTime.isEmpty()) {
            wrapper.ge(Review::getCreateTime, LocalDateTime.parse(beginTime + "T00:00:00"));
        }
        if (endTime != null && !endTime.isEmpty()) {
            wrapper.le(Review::getCreateTime, LocalDateTime.parse(endTime + "T23:59:59"));
        }

        List<Review> allReviews = reviewMapper.selectList(wrapper);

        // 按productId分组
        Map<Long, List<Review>> grouped = allReviews.stream()
                .collect(Collectors.groupingBy(Review::getProductId));

        // 2. 批量获取商品信息
        List<Map<String, Object>> summaryList = new ArrayList<>();
        for (Map.Entry<Long, List<Review>> entry : grouped.entrySet()) {
            Long productId = entry.getKey();
            List<Review> reviews = entry.getValue();
            Product product = productMapper.selectById(productId);
            String pName;
            String pImageUrl;
            String pCategory;
            if (product != null) {
                pName = product.getName();
                pImageUrl = product.getImageUrl();
                pCategory = product.getCategory();
            } else {
                pName = "商品已删除 (ID:" + productId + ")";
                pImageUrl = null;
                pCategory = "已删除";
            }
            // 商品名称模糊筛选
            if (productName != null && !productName.isEmpty()
                    && !pName.contains(productName)) {
                continue;
            }

            Map<String, Object> item = new HashMap<>();
            item.put("productId", productId);
            item.put("productName", pName);
            item.put("imageUrl", pImageUrl);
            item.put("category", pCategory);

            int reviewCount = reviews.size();
            item.put("reviewCount", reviewCount);

            double avgRating = reviews.stream().mapToInt(Review::getRating).average().orElse(0);
            item.put("avgRating", Math.round(avgRating * 10) / 10.0);

            long unrepliedCount = reviews.stream()
                    .filter(r -> r.getAdminReply() == null || r.getAdminReply().isEmpty())
                    .count();
            item.put("unrepliedCount", unrepliedCount);

            summaryList.add(item);
        }

        // 按评价数量降序排列
        summaryList.sort((a, b) -> Integer.compare(
                (int) b.get("reviewCount"), (int) a.get("reviewCount")));

        // 3. 手动分页
        int total = summaryList.size();
        int fromIndex = (pageNum - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, total);
        List<Map<String, Object>> pageList = fromIndex < total
                ? summaryList.subList(fromIndex, toIndex)
                : new ArrayList<>();

        Map<String, Object> result = new HashMap<>();
        result.put("rows", pageList);
        result.put("total", total);
        return result;
    }

    /**
     * 管理员查看某商品下的所有评价（含隐藏的，分页，支持评分和日期筛选）
     */
    public IPage<Review> listByProductIdForAdmin(Long productId, int pageNum, int pageSize,
                                                  String ratingLevel, String beginTime, String endTime) {
        Page<Review> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Review> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Review::getProductId, productId);
        // 评分等级筛选
        if ("good".equals(ratingLevel)) {
            wrapper.ge(Review::getRating, 4);
        } else if ("mid".equals(ratingLevel)) {
            wrapper.eq(Review::getRating, 3);
        } else if ("bad".equals(ratingLevel)) {
            wrapper.le(Review::getRating, 2);
        }
        // 日期范围筛选
        if (beginTime != null && !beginTime.isEmpty()) {
            wrapper.ge(Review::getCreateTime, LocalDateTime.parse(beginTime + "T00:00:00"));
        }
        if (endTime != null && !endTime.isEmpty()) {
            wrapper.le(Review::getCreateTime, LocalDateTime.parse(endTime + "T23:59:59"));
        }
        wrapper.orderByDesc(Review::getCreateTime);
        IPage<Review> result = reviewMapper.selectPage(page, wrapper);
        fillNickNames(result.getRecords());
        return result;
    }

    /**
     * 批量填充商品名称和图片URL
     */
    private void fillProductNames(List<Review> reviews) {
        if (reviews == null || reviews.isEmpty()) {
            return;
        }
        List<Long> productIds = reviews.stream()
                .map(Review::getProductId)
                .distinct()
                .collect(java.util.stream.Collectors.toList());
        for (Long pid : productIds) {
            Product product = productMapper.selectById(pid);
            if (product != null) {
                reviews.stream()
                        .filter(r -> r.getProductId().equals(pid))
                        .forEach(r -> {
                            r.setProductName(product.getName());
                            r.setProductImageUrl(product.getImageUrl());
                        });
            }
        }
    }

    /**
     * 批量填充用户昵称
     */
    private void fillNickNames(List<Review> reviews) {
        if (reviews == null || reviews.isEmpty()) {
            return;
        }
        List<Long> userIds = reviews.stream()
                .map(Review::getUserId)
                .distinct()
                .collect(java.util.stream.Collectors.toList());
        try {
            Map<Long, Map<String, Object>> nickMap = orderMapper.selectUserNickNames(userIds);
            for (Review review : reviews) {
                Map<String, Object> userInfo = nickMap.get(review.getUserId());
                if (userInfo != null) {
                    review.setNickName((String) userInfo.get("nickName"));
                }
            }
        } catch (Exception e) {
            log.warn("批量查询评价用户昵称失败: {}", e.getMessage());
        }
    }
}
