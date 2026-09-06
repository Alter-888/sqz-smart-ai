package com.ruoyi.business.service;

import com.ruoyi.business.entity.Product;
import com.ruoyi.business.enums.ProductStatus;
import com.ruoyi.business.event.ProductChangeEvent;
import com.ruoyi.business.mapper.OrderItemMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.business.mapper.ReviewMapper;
import com.ruoyi.common.exception.ServiceException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * ProductService 商品服务单元测试
 */
@ExtendWith(MockitoExtension.class)
class ProductServiceTest {

    @Mock
    private ProductMapper productMapper;
    @Mock
    private OrderItemMapper orderItemMapper;
    @Mock
    private ReviewMapper reviewMapper;
    @Mock
    private ApplicationEventPublisher eventPublisher;

    @InjectMocks
    private ProductService productService;

    // ======================== addProduct ========================

    @Test
    @DisplayName("addProduct - 自动设置status为ON_SHELF")
    void addProduct_setsStatusToOnShelf() {
        Product product = new Product();
        product.setName("测试手机");
        when(productMapper.insert(any(Product.class))).thenReturn(1);

        productService.addProduct(product);

        assertEquals(ProductStatus.ON_SHELF.getCode(), product.getStatus());
        verify(productMapper).insert(product);
    }

    @Test
    @DisplayName("addProduct - 发布CREATED事件")
    void addProduct_publishesCreatedEvent() {
        Product product = new Product();
        product.setName("测试手机");
        when(productMapper.insert(any(Product.class))).thenReturn(1);

        productService.addProduct(product);

        ArgumentCaptor<ProductChangeEvent> captor = ArgumentCaptor.forClass(ProductChangeEvent.class);
        verify(eventPublisher).publishEvent(captor.capture());
        assertEquals(ProductChangeEvent.ChangeType.CREATED, captor.getValue().getChangeType());
    }

    // ======================== updateProduct ========================

    @Test
    @DisplayName("updateProduct - 商品不存在抛出ServiceException")
    void updateProduct_notExists_throwsException() {
        Product product = new Product();
        product.setProductId(999L);
        when(productMapper.selectById(999L)).thenReturn(null);

        ServiceException ex = assertThrows(ServiceException.class,
                () -> productService.updateProduct(product));
        assertEquals("商品不存在", ex.getMessage());
    }

    @Test
    @DisplayName("updateProduct - 下架时发布OFF_SHELF事件")
    void updateProduct_offShelf_publishesOffShelfEvent() {
        Product existing = new Product();
        existing.setProductId(1L);
        existing.setStatus(ProductStatus.ON_SHELF.getCode());

        Product updated = new Product();
        updated.setProductId(1L);
        updated.setStatus(ProductStatus.OFF_SHELF.getCode());

        when(productMapper.selectById(1L)).thenReturn(existing).thenReturn(updated);
        when(productMapper.updateById(any(Product.class))).thenReturn(1);

        Product toUpdate = new Product();
        toUpdate.setProductId(1L);
        toUpdate.setStatus(ProductStatus.OFF_SHELF.getCode());

        productService.updateProduct(toUpdate);

        ArgumentCaptor<ProductChangeEvent> captor = ArgumentCaptor.forClass(ProductChangeEvent.class);
        verify(eventPublisher).publishEvent(captor.capture());
        assertEquals(ProductChangeEvent.ChangeType.OFF_SHELF, captor.getValue().getChangeType());
    }

    // ======================== deleteProduct ========================

    @Test
    @DisplayName("deleteProduct - 商品存在时删除并发布DELETED事件")
    void deleteProduct_exists_deletesAndPublishesEvent() {
        Product product = new Product();
        product.setProductId(1L);
        product.setName("测试手机");
        when(productMapper.selectById(1L)).thenReturn(product);
        when(productMapper.deleteById(1L)).thenReturn(1);

        productService.deleteProduct(1L);

        verify(productMapper).deleteById(1L);
        ArgumentCaptor<ProductChangeEvent> captor = ArgumentCaptor.forClass(ProductChangeEvent.class);
        verify(eventPublisher).publishEvent(captor.capture());
        assertEquals(ProductChangeEvent.ChangeType.DELETED, captor.getValue().getChangeType());
    }

    @Test
    @DisplayName("deleteProduct - 商品不存在时eventPublisher不被调用")
    void deleteProduct_notExists_noEventPublished() {
        when(productMapper.selectById(999L)).thenReturn(null);
        when(productMapper.deleteById(999L)).thenReturn(0);

        productService.deleteProduct(999L);

        verify(eventPublisher, never()).publishEvent(any(ProductChangeEvent.class));
    }
}
