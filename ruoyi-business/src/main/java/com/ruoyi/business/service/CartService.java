package com.ruoyi.business.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ruoyi.business.entity.CartItem;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.mapper.CartItemMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.common.exception.ServiceException;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CartService {

    private static final Logger log = LoggerFactory.getLogger(CartService.class);

    private final CartItemMapper cartItemMapper;
    private final ProductMapper productMapper;

    /**
     * 查询用户购物车列表，填充商品信息
     */
    public List<CartItem> listByUserId(Long userId) {
        LambdaQueryWrapper<CartItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CartItem::getUserId, userId);
        wrapper.orderByDesc(CartItem::getCreateTime);
        List<CartItem> items = cartItemMapper.selectList(wrapper);
        items.forEach(this::fillProductInfo);
        return items;
    }

    /**
     * 添加商品到购物车（已在购物车则累加数量）
     */
    public CartItem addItem(Long userId, Long productId, Integer quantity) {
        if (quantity == null || quantity < 1) {
            throw new ServiceException("数量必须大于0");
        }
        // 校验商品状态
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new ServiceException("商品不存在");
        }
        if (product.getStatus() == null || product.getStatus() != 1) {
            throw new ServiceException("该商品已下架，无法加入购物车");
        }

        // 检查是否已在购物车
        LambdaQueryWrapper<CartItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CartItem::getUserId, userId);
        wrapper.eq(CartItem::getProductId, productId);
        CartItem existing = cartItemMapper.selectOne(wrapper);

        if (existing != null) {
            int newQuantity = existing.getQuantity() + quantity;
            if (newQuantity > product.getStock()) {
                throw new ServiceException("库存不足，当前库存: " + product.getStock() + "，购物车已有: " + existing.getQuantity());
            }
            existing.setQuantity(newQuantity);
            cartItemMapper.updateById(existing);
            fillProductInfo(existing);
            log.info("购物车累加: userId={}, productId={}, quantity={}→{}", userId, productId, existing.getQuantity() - quantity, newQuantity);
            return existing;
        } else {
            if (quantity > product.getStock()) {
                throw new ServiceException("库存不足，当前库存: " + product.getStock());
            }
            CartItem item = new CartItem();
            item.setUserId(userId);
            item.setProductId(productId);
            item.setQuantity(quantity);
            item.setChecked(1);
            cartItemMapper.insert(item);
            fillProductInfo(item);
            log.info("购物车新增: userId={}, productId={}, quantity={}", userId, productId, quantity);
            return item;
        }
    }

    /**
     * 移除购物车商品
     */
    public void removeItem(Long userId, Long productId) {
        LambdaQueryWrapper<CartItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CartItem::getUserId, userId);
        wrapper.eq(CartItem::getProductId, productId);
        int deleted = cartItemMapper.delete(wrapper);
        if (deleted == 0) {
            throw new ServiceException("该商品不在购物车中");
        }
        log.info("购物车移除: userId={}, productId={}", userId, productId);
    }

    /**
     * 更新购物车商品数量
     */
    public void updateQuantity(Long userId, Long productId, Integer quantity) {
        if (quantity == null || quantity < 1) {
            throw new ServiceException("数量必须大于0");
        }
        // 校验库存
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new ServiceException("商品不存在");
        }
        if (quantity > product.getStock()) {
            throw new ServiceException("库存不足，当前库存: " + product.getStock());
        }

        LambdaQueryWrapper<CartItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CartItem::getUserId, userId);
        wrapper.eq(CartItem::getProductId, productId);
        CartItem item = cartItemMapper.selectOne(wrapper);
        if (item == null) {
            throw new ServiceException("该商品不在购物车中");
        }
        item.setQuantity(quantity);
        cartItemMapper.updateById(item);
        log.info("购物车数量更新: userId={}, productId={}, quantity={}", userId, productId, quantity);
    }

    /**
     * 更新购物车商品勾选状态
     */
    public void updateChecked(Long userId, Long productId, Integer checked) {
        LambdaQueryWrapper<CartItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CartItem::getUserId, userId);
        wrapper.eq(CartItem::getProductId, productId);
        CartItem item = cartItemMapper.selectOne(wrapper);
        if (item == null) {
            throw new ServiceException("该商品不在购物车中");
        }
        item.setChecked(checked);
        cartItemMapper.updateById(item);
        log.info("购物车勾选更新: userId={}, productId={}, checked={}", userId, productId, checked);
    }

    /**
     * 清空购物车
     */
    public void clearCart(Long userId) {
        LambdaQueryWrapper<CartItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CartItem::getUserId, userId);
        cartItemMapper.delete(wrapper);
        log.info("购物车清空: userId={}", userId);
    }

    /**
     * 购物车摘要统计
     */
    public Map<String, Object> getCartSummary(Long userId) {
        List<CartItem> items = listByUserId(userId);
        int totalItems = items.size();
        int checkedItems = 0;
        BigDecimal totalPrice = BigDecimal.ZERO;

        for (CartItem item : items) {
            if (item.getChecked() != null && item.getChecked() == 1) {
                checkedItems++;
                if (item.getPrice() != null) {
                    totalPrice = totalPrice.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
                }
            }
        }

        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("totalItems", totalItems);
        summary.put("checkedItems", checkedItems);
        summary.put("totalPrice", totalPrice);
        return summary;
    }

    /**
     * 查询用户已勾选的购物车商品列表（checked=1），并填充商品信息
     */
    public List<CartItem> listCheckedItems(Long userId) {
        LambdaQueryWrapper<CartItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CartItem::getUserId, userId);
        wrapper.eq(CartItem::getChecked, 1);
        wrapper.orderByDesc(CartItem::getCreateTime);
        List<CartItem> items = cartItemMapper.selectList(wrapper);
        items.forEach(this::fillProductInfo);
        return items;
    }

    /**
     * 批量移除购物车中指定商品（下单成功后清理已购商品）
     */
    public void removeItems(Long userId, List<Long> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return;
        }
        LambdaQueryWrapper<CartItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CartItem::getUserId, userId);
        wrapper.in(CartItem::getProductId, productIds);
        cartItemMapper.delete(wrapper);
        log.info("购物车批量移除: userId={}, productIds={}", userId, productIds);
    }

    /**
     * 填充商品信息到购物车项
     */
    private void fillProductInfo(CartItem item) {
        Product product = productMapper.selectById(item.getProductId());
        if (product != null) {
            item.setProductName(product.getName());
            item.setPrice(product.getPrice());
            item.setImageUrl(product.getImageUrl());
            item.setStock(product.getStock());
        }
    }
}
