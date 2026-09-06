package com.ruoyi.business.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.service.ProductService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/business/product")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @GetMapping("/list")
    @PreAuthorize("@ss.hasPermi('business:product:list')")
    public AjaxResult list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Integer status) {
        IPage<Product> page = productService.listProducts(pageNum, pageSize, name, category, status);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    @GetMapping("/{id}")
    @PreAuthorize("@ss.hasPermi('business:product:list')")
    public AjaxResult getById(@PathVariable("id") Long productId) {
        return AjaxResult.success(productService.getById(productId));
    }

    @PostMapping
    @PreAuthorize("@ss.hasPermi('business:product:add')")
    public AjaxResult add(@RequestBody Product product) {
        productService.addProduct(product);
        return AjaxResult.success();
    }

    @PutMapping("/{id}")
    @PreAuthorize("@ss.hasPermi('business:product:edit')")
    public AjaxResult update(@PathVariable("id") Long productId, @RequestBody Product product) {
        product.setProductId(productId);
        productService.updateProduct(product);
        return AjaxResult.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("@ss.hasPermi('business:product:remove')")
    public AjaxResult delete(@PathVariable("id") Long productId) {
        productService.deleteProduct(productId);
        return AjaxResult.success();
    }

    /**
     * 库存预警
     */
    @GetMapping("/low-stock")
    @PreAuthorize("@ss.hasPermi('business:product:list')")
    public AjaxResult lowStock(@RequestParam(defaultValue = "10") int threshold) {
        List<Product> products = productService.listLowStockProducts(threshold);
        return AjaxResult.success(products);
    }

    /**
     * 批量上下架
     */
    @PutMapping("/batch-status")
    @PreAuthorize("@ss.hasPermi('business:product:edit')")
    public AjaxResult batchStatus(@RequestBody Map<String, Object> body) {
        @SuppressWarnings("unchecked")
        List<Long> productIds = ((List<Number>) body.get("productIds"))
                .stream().map(Number::longValue).toList();
        Integer status = Integer.valueOf(body.get("status").toString());
        productService.batchUpdateStatus(productIds, status);
        return AjaxResult.success();
    }

    /**
     * 导出商品列表
     */
    @PostMapping("/export")
    @PreAuthorize("@ss.hasPermi('business:product:list')")
    public void export(HttpServletResponse response,
                       @RequestParam(required = false) String name,
                       @RequestParam(required = false) String category) {
        List<Product> list = productService.listAllProducts(name, category);
        ExcelUtil<Product> util = new ExcelUtil<>(Product.class);
        util.exportExcel(response, list, "商品数据");
    }

    /**
     * 导入商品数据
     */
    @PostMapping("/importData")
    @PreAuthorize("@ss.hasPermi('business:product:add')")
    public AjaxResult importData(MultipartFile file, boolean updateSupport) throws Exception {
        ExcelUtil<Product> util = new ExcelUtil<>(Product.class);
        List<Product> productList = util.importExcel(file.getInputStream());
        String operName = SecurityUtils.getUsername();
        String message = productService.importProducts(productList, updateSupport, operName);
        return AjaxResult.success(message);
    }

    /**
     * 下载商品导入模板
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<Product> util = new ExcelUtil<>(Product.class);
        util.importTemplateExcel(response, "商品数据");
    }
}
