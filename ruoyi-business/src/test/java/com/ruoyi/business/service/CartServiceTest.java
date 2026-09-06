package com.ruoyi.business.service;

import com.ruoyi.business.entity.CartItem;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.mapper.CartItemMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.common.exception.ServiceException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * CartService 核心方法单元测试
 */
@ExtendWith(MockitoExtension.class)
class CartServiceTest {

    @Mock
    private CartItemMapper cartItemMapper;
    @Mock
    private ProductMapper productMapper;

    @InjectMocks
    private CartService cartService;

    private Product mockProduct(Long id, String name, int stock) {
        Product p = new Product();
        p.setProductId(id);
        p.setName(name);
        p.setPrice(new BigDecimal("999.00"));
        p.setStock(stock);
        p.setStatus(1);
        return p;
    }

    // ======================== addItem ========================

    @Test
    @DisplayName("加入购物车 - 新商品首次加入")
    void addItem_newItem_success() {
        Product product = mockProduct(1L, "测试手机", 50);
        when(productMapper.selectById(1L)).thenReturn(product);
        when(cartItemMapper.selectOne(any())).thenReturn(null); // 不在购物车
        when(cartItemMapper.insert(any(CartItem.class))).thenReturn(1);

        CartItem result = cartService.addItem(1L, 1L, 2);

        assertNotNull(result);
        assertEquals(2, result.getQuantity());
        assertEquals(1, result.getChecked());
        verify(cartItemMapper).insert(any(CartItem.class));
    }

    @Test
    @DisplayName("加入购物车 - 已有商品再次添加，数量累加")
    void addItem_existingItem_accumulatesQuantity() {
        Product product = mockProduct(1L, "测试手机", 50);
        when(productMapper.selectById(1L)).thenReturn(product);

        CartItem existing = new CartItem();
        existing.setCartItemId(100L);
        existing.setUserId(1L);
        existing.setProductId(1L);
        existing.setQuantity(3);
        when(cartItemMapper.selectOne(any())).thenReturn(existing);
        when(cartItemMapper.updateById(any(CartItem.class))).thenReturn(1);

        CartItem result = cartService.addItem(1L, 1L, 2);

        assertEquals(5, result.getQuantity()); // 3 + 2
        verify(cartItemMapper).updateById(any(CartItem.class));
        verify(cartItemMapper, never()).insert(any(CartItem.class));
    }

    // ======================== updateQuantity ========================

    @Test
    @DisplayName("修改购物车数量 - 超过库存抛出异常")
    void updateQuantity_exceedsStock_throwsException() {
        Product product = mockProduct(1L, "测试手机", 5);
        when(productMapper.selectById(1L)).thenReturn(product);

        ServiceException ex = assertThrows(ServiceException.class,
                () -> cartService.updateQuantity(1L, 1L, 100));
        assertTrue(ex.getMessage().contains("库存不足"));
    }
}
