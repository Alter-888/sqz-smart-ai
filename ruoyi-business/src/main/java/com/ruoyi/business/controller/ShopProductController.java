package com.ruoyi.business.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.mapper.OrderItemMapper;
import com.ruoyi.business.service.ProductService;
import com.ruoyi.common.core.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户端商品浏览接口
 * 登录用户均可访问，仅返回上架商品
 */
@RestController
@RequestMapping("/shop/product")
@RequiredArgsConstructor
public class ShopProductController {

    private final ProductService productService;
    private final OrderItemMapper orderItemMapper;

    /**
     * 用户端商品列表（仅上架商品，支持排序）
     * @param orderBy 排序方式：newest(默认), salesDesc, priceAsc, priceDesc, ratingDesc
     */
    @GetMapping("/list")
    public AjaxResult list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String orderBy) {
        // 白名单校验排序参数，防止注入
        if (orderBy != null && !List.of("newest", "salesDesc", "priceAsc", "priceDesc", "ratingDesc").contains(orderBy)) {
            orderBy = "newest";
        }
        IPage<Product> page = productService.listOnShelfProducts(pageNum, pageSize, name, category, orderBy);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    /**
     * 用户端商品详情（仅上架商品，含销量）
     */
    @GetMapping("/{id}")
    public AjaxResult getById(@PathVariable("id") Long productId) {
        Product product = productService.getOnShelfById(productId);
        if (product != null) {
            productService.fillSalesAndRating(product);
        }
        return AjaxResult.success(product);
    }
}
