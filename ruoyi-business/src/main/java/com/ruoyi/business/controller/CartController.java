package com.ruoyi.business.controller;

import com.ruoyi.business.entity.CartItem;
import com.ruoyi.business.service.CartService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 购物车接口（用户端）
 */
@RestController
@RequestMapping("/business/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    /**
     * 获取当前用户购物车列表（含商品信息）
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @GetMapping("/list")
    public AjaxResult list() {
        Long userId = SecurityUtils.getUserId();
        List<CartItem> items = cartService.listByUserId(userId);
        Map<String, Object> summary = cartService.getCartSummary(userId);
        AjaxResult ajax = AjaxResult.success(items);
        ajax.put("summary", summary);
        return ajax;
    }

    /**
     * 添加商品到购物车
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @PostMapping
    public AjaxResult add(@RequestBody Map<String, Object> body) {
        Long userId = SecurityUtils.getUserId();
        Long productId = Long.valueOf(body.get("productId").toString());
        Integer quantity = body.get("quantity") != null ? Integer.valueOf(body.get("quantity").toString()) : 1;
        CartItem item = cartService.addItem(userId, productId, quantity);
        return AjaxResult.success(item);
    }

    /**
     * 更新购物车商品数量
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @PutMapping("/{productId}/quantity")
    public AjaxResult updateQuantity(@PathVariable("productId") Long productId,
                                      @RequestBody Map<String, Object> body) {
        Long userId = SecurityUtils.getUserId();
        Integer quantity = Integer.valueOf(body.get("quantity").toString());
        cartService.updateQuantity(userId, productId, quantity);
        return AjaxResult.success();
    }

    /**
     * 切换购物车商品勾选状态
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @PutMapping("/{productId}/checked")
    public AjaxResult updateChecked(@PathVariable("productId") Long productId,
                                     @RequestBody Map<String, Object> body) {
        Long userId = SecurityUtils.getUserId();
        Integer checked = Integer.valueOf(body.get("checked").toString());
        cartService.updateChecked(userId, productId, checked);
        return AjaxResult.success();
    }

    /**
     * 移除购物车商品
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @DeleteMapping("/{productId}")
    public AjaxResult remove(@PathVariable("productId") Long productId) {
        Long userId = SecurityUtils.getUserId();
        cartService.removeItem(userId, productId);
        return AjaxResult.success();
    }

    /**
     * 清空购物车
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @DeleteMapping("/clear")
    public AjaxResult clear() {
        Long userId = SecurityUtils.getUserId();
        cartService.clearCart(userId);
        return AjaxResult.success();
    }
}
