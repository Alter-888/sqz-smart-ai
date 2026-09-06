package com.ruoyi.business.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.business.entity.Review;
import com.ruoyi.business.service.ReviewService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/business/review")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    /**
     * 用户提交评价
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @PostMapping
    public AjaxResult submit(@RequestBody Map<String, Object> body) {
        Long userId = SecurityUtils.getUserId();
        Long orderItemId = Long.valueOf(body.get("orderItemId").toString());
        Integer rating = Integer.valueOf(body.get("rating").toString());
        String content = (String) body.get("content");
        Review review = reviewService.submitReview(userId, orderItemId, rating, content);
        return AjaxResult.success(review);
    }

    /**
     * 商品评价列表（分页，支持按等级筛选）
     * @param ratingLevel 评价等级筛选：good=好评, mid=中评, bad=差评, 不传=全部
     */
    @GetMapping("/product/{productId}")
    public AjaxResult listByProduct(@PathVariable("productId") Long productId,
                                     @RequestParam(defaultValue = "1") int pageNum,
                                     @RequestParam(defaultValue = "5") int pageSize,
                                     @RequestParam(required = false) String ratingLevel) {
        IPage<Review> page = reviewService.listByProductId(productId, pageNum, pageSize, ratingLevel);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    /**
     * 商品评价统计
     */
    @GetMapping("/product/{productId}/stats")
    public AjaxResult productStats(@PathVariable("productId") Long productId) {
        return AjaxResult.success(reviewService.getProductStats(productId));
    }

    /**
     * 检查是否已评价
     */
    @GetMapping("/check/{orderItemId}")
    public AjaxResult check(@PathVariable("orderItemId") Long orderItemId) {
        return AjaxResult.success(reviewService.hasReviewed(orderItemId));
    }

    /**
     * 根据订单项ID获取评价详情（用户端：在订单详情中展示评价内容）
     */
    @GetMapping("/by-item/{orderItemId}")
    public AjaxResult getByOrderItemId(@PathVariable("orderItemId") Long orderItemId) {
        Review review = reviewService.getByOrderItemId(orderItemId);
        return AjaxResult.success(review);
    }

    /**
     * 用户查看自己的评价历史（分页）
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @GetMapping("/my")
    public AjaxResult myReviews(@RequestParam(defaultValue = "1") int pageNum,
                                 @RequestParam(defaultValue = "10") int pageSize) {
        Long userId = SecurityUtils.getUserId();
        var page = reviewService.listByUserId(userId, pageNum, pageSize);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    /**
     * 管理员查询所有评价列表（分页）
     */
    @PreAuthorize("@ss.hasPermi('business:review:list')")
    @GetMapping("/list")
    public AjaxResult list(@RequestParam(defaultValue = "1") int pageNum,
                           @RequestParam(defaultValue = "10") int pageSize,
                           @RequestParam(required = false) Long productId,
                           @RequestParam(required = false) Integer rating) {
        var page = reviewService.listAll(pageNum, pageSize, productId, rating);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    /**
     * 管理员回复评价
     */
    @PreAuthorize("@ss.hasPermi('business:review:edit')")
    @PutMapping("/{id}/reply")
    public AjaxResult adminReply(@PathVariable("id") Long reviewId,
                                  @RequestBody Map<String, Object> body) {
        String reply = (String) body.get("reply");
        if (reply == null || reply.trim().isEmpty()) {
            return AjaxResult.error("回复内容不能为空");
        }
        reviewService.adminReply(reviewId, reply.trim());
        return AjaxResult.success();
    }

    /**
     * 管理员更新评价显示状态
     */
    @PreAuthorize("@ss.hasPermi('business:review:edit')")
    @PutMapping("/{id}/status")
    public AjaxResult updateStatus(@PathVariable("id") Long reviewId,
                                    @RequestBody Map<String, Object> body) {
        Integer status = Integer.valueOf(body.get("status").toString());
        reviewService.updateStatus(reviewId, status);
        return AjaxResult.success();
    }

    /**
     * 管理员删除评价
     */
    @PreAuthorize("@ss.hasPermi('business:review:remove')")
    @DeleteMapping("/{id}")
    public AjaxResult delete(@PathVariable("id") Long reviewId) {
        reviewService.deleteReview(reviewId);
        return AjaxResult.success();
    }

    /**
     * 管理员：评价统计概览（总数、好评率、待回复、今日新增）
     */
    @PreAuthorize("@ss.hasPermi('business:review:list')")
    @GetMapping("/overview-stats")
    public AjaxResult overviewStats() {
        return AjaxResult.success(reviewService.getOverviewStats());
    }

    /**
     * 管理员：按商品分组的评价摘要列表（支持评分和日期筛选）
     */
    @PreAuthorize("@ss.hasPermi('business:review:list')")
    @GetMapping("/product-summary")
    public AjaxResult productSummary(@RequestParam(defaultValue = "1") int pageNum,
                                      @RequestParam(defaultValue = "6") int pageSize,
                                      @RequestParam(required = false) String productName,
                                      @RequestParam(required = false) String ratingLevel,
                                      @RequestParam(required = false) String beginTime,
                                      @RequestParam(required = false) String endTime) {
        Map<String, Object> result = reviewService.getProductSummary(pageNum, pageSize, productName, ratingLevel, beginTime, endTime);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", result.get("rows"));
        ajax.put("total", result.get("total"));
        return ajax;
    }

    /**
     * 管理员：查看某商品下的所有评价（含隐藏的，分页，支持评分和日期筛选）
     */
    @PreAuthorize("@ss.hasPermi('business:review:list')")
    @GetMapping("/product/{productId}/admin")
    public AjaxResult listByProductForAdmin(@PathVariable("productId") Long productId,
                                             @RequestParam(defaultValue = "1") int pageNum,
                                             @RequestParam(defaultValue = "5") int pageSize,
                                             @RequestParam(required = false) String ratingLevel,
                                             @RequestParam(required = false) String beginTime,
                                             @RequestParam(required = false) String endTime) {
        var page = reviewService.listByProductIdForAdmin(productId, pageNum, pageSize, ratingLevel, beginTime, endTime);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }
}
