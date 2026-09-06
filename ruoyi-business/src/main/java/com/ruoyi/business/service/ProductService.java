package com.ruoyi.business.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.enums.ProductStatus;
import com.ruoyi.business.event.ProductChangeEvent;
import com.ruoyi.business.mapper.OrderItemMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.business.mapper.ReviewMapper;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.web.util.HtmlUtils;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductService {

    private static final Logger log = LoggerFactory.getLogger(ProductService.class);

    private final ProductMapper productMapper;
    private final OrderItemMapper orderItemMapper;
    private final ReviewMapper reviewMapper;
    private final ApplicationEventPublisher eventPublisher;

    public IPage<Product> listProducts(int pageNum, int pageSize, String name, String category, Integer status) {
        Page<Product> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        if (name != null && !name.isEmpty()) {
            wrapper.like(Product::getName, name);
        }
        if (category != null && !category.isEmpty()) {
            wrapper.eq(Product::getCategory, category);
        }
        if (status != null) {
            wrapper.eq(Product::getStatus, status);
        }
        wrapper.orderByDesc(Product::getCreateTime);
        return productMapper.selectPage(page, wrapper);
    }

    public Product getById(Long productId) {
        return productMapper.selectById(productId);
    }

    public void addProduct(Product product) {
        product.setStatus(ProductStatus.ON_SHELF.getCode());
        productMapper.insert(product);
        log.info("商品添加成功: {}, 分类: {}", product.getName(), product.getCategory());
        eventPublisher.publishEvent(new ProductChangeEvent(this, product, ProductChangeEvent.ChangeType.CREATED));
    }

    public void updateProduct(Product product) {
        Product existing = productMapper.selectById(product.getProductId());
        if (existing == null) {
            throw new ServiceException("商品不存在");
        }
        productMapper.updateById(product);
        log.info("商品更新成功: id={}, name={}", product.getProductId(), product.getName());
        // 查询更新后的完整数据发布事件
        Product updated = productMapper.selectById(product.getProductId());
        if (updated.getStatus() != null && updated.getStatus().equals(ProductStatus.OFF_SHELF.getCode())) {
            eventPublisher.publishEvent(new ProductChangeEvent(this, updated, ProductChangeEvent.ChangeType.OFF_SHELF));
        } else {
            eventPublisher.publishEvent(new ProductChangeEvent(this, updated, ProductChangeEvent.ChangeType.UPDATED));
        }
    }

    public void deleteProduct(Long productId) {
        // 删除前查出商品，用于发布事件触发知识库清理
        Product product = productMapper.selectById(productId);
        productMapper.deleteById(productId);
        log.info("商品删除成功: id={}", productId);
        if (product != null) {
            eventPublisher.publishEvent(new ProductChangeEvent(this, product, ProductChangeEvent.ChangeType.DELETED));
        }
    }

    /**
     * 库存预警查询：stock <= threshold 且上架中
     */
    public List<Product> listLowStockProducts(int threshold) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.le(Product::getStock, threshold);
        wrapper.eq(Product::getStatus, ProductStatus.ON_SHELF.getCode());
        wrapper.orderByAsc(Product::getStock);
        return productMapper.selectList(wrapper);
    }

    /**
     * 批量上下架
     */
    public void batchUpdateStatus(List<Long> productIds, Integer status) {
        // 校验状态值合法性
        ProductStatus.fromCode(status);
        for (Long id : productIds) {
            Product product = productMapper.selectById(id);
            if (product != null) {
                product.setStatus(status);
                productMapper.updateById(product);
                // 发布事件：下架则禁用知识，上架则同步知识
                if (status.equals(ProductStatus.OFF_SHELF.getCode())) {
                    eventPublisher.publishEvent(new ProductChangeEvent(this, product, ProductChangeEvent.ChangeType.OFF_SHELF));
                } else {
                    eventPublisher.publishEvent(new ProductChangeEvent(this, product, ProductChangeEvent.ChangeType.UPDATED));
                }
            }
        }
        log.info("商品批量状态更新: ids={}, status={}", productIds, status);
    }

    /**
     * 不分页全量查询（导出用）
     */
    public List<Product> listAllProducts(String name, String category) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        if (name != null && !name.isEmpty()) {
            wrapper.like(Product::getName, name);
        }
        if (category != null && !category.isEmpty()) {
            wrapper.eq(Product::getCategory, category);
        }
        wrapper.orderByDesc(Product::getCreateTime);
        return productMapper.selectList(wrapper);
    }

    /**
     * 用户端商品列表：仅查询上架商品，支持分页、搜索、排序
     * @param orderBy 排序方式：newest(默认), salesDesc, priceAsc, priceDesc, ratingDesc
     */
    public IPage<Product> listOnShelfProducts(int pageNum, int pageSize, String name, String category, String orderBy) {
        // 价格和时间排序直接走DB
        if (orderBy == null || "newest".equals(orderBy) || "priceAsc".equals(orderBy) || "priceDesc".equals(orderBy)) {
            Page<Product> page = new Page<>(pageNum, pageSize);
            LambdaQueryWrapper<Product> wrapper = buildOnShelfWrapper(name, category);
            if ("priceAsc".equals(orderBy)) {
                wrapper.orderByAsc(Product::getPrice);
            } else if ("priceDesc".equals(orderBy)) {
                wrapper.orderByDesc(Product::getPrice);
            } else {
                wrapper.orderByDesc(Product::getCreateTime);
            }
            IPage<Product> result = productMapper.selectPage(page, wrapper);
            fillSalesAndRating(result.getRecords());
            return result;
        }

        // 销量和评分排序需要全量查出后内存排序
        LambdaQueryWrapper<Product> wrapper = buildOnShelfWrapper(name, category);
        List<Product> allProducts = productMapper.selectList(wrapper);
        fillSalesAndRating(allProducts);

        if ("salesDesc".equals(orderBy)) {
            allProducts.sort((a, b) -> (b.getSalesCount() == null ? 0 : b.getSalesCount()) -
                                        (a.getSalesCount() == null ? 0 : a.getSalesCount()));
        } else if ("ratingDesc".equals(orderBy)) {
            allProducts.sort((a, b) -> Double.compare(
                    b.getAvgRating() == null ? 0 : b.getAvgRating(),
                    a.getAvgRating() == null ? 0 : a.getAvgRating()));
        }

        // 手动分页
        int start = (pageNum - 1) * pageSize;
        int end = Math.min(start + pageSize, allProducts.size());
        List<Product> pageList = start < allProducts.size() ? allProducts.subList(start, end) : List.of();

        Page<Product> resultPage = new Page<>(pageNum, pageSize);
        resultPage.setRecords(pageList);
        resultPage.setTotal(allProducts.size());
        return resultPage;
    }

    /**
     * 用户端商品列表（兼容原有调用）
     */
    public IPage<Product> listOnShelfProducts(int pageNum, int pageSize, String name, String category) {
        return listOnShelfProducts(pageNum, pageSize, name, category, null);
    }

    /**
     * 用户端商品详情：仅返回上架商品
     */
    public Product getOnShelfById(Long productId) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Product::getProductId, productId);
        wrapper.eq(Product::getStatus, ProductStatus.ON_SHELF.getCode());
        return productMapper.selectOne(wrapper);
    }

    /**
     * 构建上架商品查询条件
     */
    private LambdaQueryWrapper<Product> buildOnShelfWrapper(String name, String category) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Product::getStatus, ProductStatus.ON_SHELF.getCode());
        if (name != null && !name.isEmpty()) {
            wrapper.like(Product::getName, name);
        }
        if (category != null && !category.isEmpty()) {
            wrapper.eq(Product::getCategory, category);
        }
        return wrapper;
    }

    /**
     * 单个商品填充销量和评分数据（详情页面用）
     */
    public void fillSalesAndRating(Product product) {
        if (product == null) {
            return;
        }
        fillSalesAndRating(List.of(product));
    }

    public void fillSalesAndRating(List<Product> products) {
        if (products == null || products.isEmpty()) {
            return;
        }
        List<Long> productIds = products.stream().map(Product::getProductId).collect(Collectors.toList());

        // 批量查销量
        try {
            Map<Long, Map<String, Object>> salesMap = orderItemMapper.selectBatchSalesCount(productIds);
            for (Product p : products) {
                Map<String, Object> data = salesMap.get(p.getProductId());
                p.setSalesCount(data != null ? ((Number) data.get("salesCount")).intValue() : 0);
            }
        } catch (Exception e) {
            log.warn("批量查询销量失败: {}", e.getMessage());
            products.forEach(p -> p.setSalesCount(0));
        }

        // 批量查评分
        try {
            Map<Long, Map<String, Object>> ratingMap = reviewMapper.selectBatchAvgRating(productIds);
            for (Product p : products) {
                Map<String, Object> data = ratingMap.get(p.getProductId());
                if (data != null) {
                    p.setAvgRating(((Number) data.get("avgRating")).doubleValue());
                    p.setReviewCount(((Number) data.get("reviewCount")).intValue());
                } else {
                    p.setAvgRating(0.0);
                    p.setReviewCount(0);
                }
            }
        } catch (Exception e) {
            log.warn("批量查询评分失败: {}", e.getMessage());
            products.forEach(p -> { p.setAvgRating(0.0); p.setReviewCount(0); });
        }
    }

    /**
     * 批量导入商品
     * @param productList   Excel解析出的商品列表
     * @param updateSupport 是否更新已存在的商品（按名称匹配）
     * @param operName      操作人
     * @return 导入结果消息（HTML格式）
     */
    public String importProducts(List<Product> productList, boolean updateSupport, String operName) {
        if (productList == null || productList.isEmpty()) {
            throw new ServiceException("导入数据不能为空");
        }

        int successCount = 0;
        int updateCount = 0;
        int failCount = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (int i = 0; i < productList.size(); i++) {
            Product product = productList.get(i);
            try {
                // 校验必填字段
                if (StringUtils.isEmpty(product.getName())) {
                    failCount++;
                    failureMsg.append("<br/>").append(failCount).append("、第 ").append(i + 1).append(" 行商品名称为空，跳过");
                    continue;
                }

                // 按名称查找已有商品
                LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(Product::getName, product.getName());
                Product existing = productMapper.selectOne(wrapper);

                if (existing == null) {
                    // 新商品：默认下架
                    product.setStatus(ProductStatus.OFF_SHELF.getCode());
                    productMapper.insert(product);
                    successCount++;
                    successMsg.append("<br/>").append(successCount).append("、商品 ").append(esc(product.getName())).append(" 导入成功");
                    eventPublisher.publishEvent(new ProductChangeEvent(this, product, ProductChangeEvent.ChangeType.CREATED));
                } else if (updateSupport) {
                    // 更新已有商品（保留原有状态和ID）
                    product.setProductId(existing.getProductId());
                    product.setStatus(existing.getStatus());
                    productMapper.updateById(product);
                    updateCount++;
                    successMsg.append("<br/>").append(updateCount).append("、商品 ").append(esc(product.getName())).append(" 更新成功");
                    Product updated = productMapper.selectById(existing.getProductId());
                    eventPublisher.publishEvent(new ProductChangeEvent(this, updated, ProductChangeEvent.ChangeType.UPDATED));
                } else {
                    failCount++;
                    failureMsg.append("<br/>").append(failCount).append("、商品 ").append(esc(product.getName())).append(" 已存在，跳过");
                }
            } catch (Exception e) {
                failCount++;
                failureMsg.append("<br/>").append(failCount).append("、商品 ").append(esc(product.getName())).append(" 导入失败：").append(esc(e.getMessage()));
                log.error("商品导入异常: name={}, error={}", product.getName(), e.getMessage());
            }
        }

        StringBuilder resultMsg = new StringBuilder();
        resultMsg.append("操作人：").append(esc(operName)).append("，共 ").append(productList.size()).append(" 条数据");
        if (successCount > 0) {
            resultMsg.append("，成功导入 ").append(successCount).append(" 条");
        }
        if (updateCount > 0) {
            resultMsg.append("，成功更新 ").append(updateCount).append(" 条");
        }
        if (failCount > 0) {
            resultMsg.append("，失败 ").append(failCount).append(" 条");
            resultMsg.append(failureMsg);
        }
        if (successCount > 0 || updateCount > 0) {
            resultMsg.append(successMsg);
        }

        log.info("商品批量导入完成: 总数={}, 新增={}, 更新={}, 失败={}, 操作人={}",
                productList.size(), successCount, updateCount, failCount, operName);
        return resultMsg.toString();
    }

    /**
     * HTML转义，防止XSS注入（用于导入结果消息拼接）
     */
    private String esc(String text) {
        return text == null ? "" : HtmlUtils.htmlEscape(text);
    }
}
