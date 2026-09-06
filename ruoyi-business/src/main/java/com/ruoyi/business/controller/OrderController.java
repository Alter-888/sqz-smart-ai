package com.ruoyi.business.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.business.entity.Order;
import com.ruoyi.business.entity.OrderItem;
import com.ruoyi.business.enums.OrderStatus;
import com.ruoyi.business.enums.OrderStatusTransition;
import com.ruoyi.business.service.OrderService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/business/order")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @GetMapping("/list")
    @PreAuthorize("@ss.hasPermi('business:order:list')")
    public AjaxResult list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String orderNo,
            @RequestParam(required = false) String status) {
        IPage<Order> page = orderService.listOrders(pageNum, pageSize, orderNo, status);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    @GetMapping("/my")
    public AjaxResult myOrders(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String orderNo,
            @RequestParam(required = false) String status) {
        Long userId = SecurityUtils.getUserId();
        IPage<Order> page = orderService.listUserOrders(userId, pageNum, pageSize, orderNo, status);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    /**
     * 用户订单统计（各状态数量 + 待付金额）
     */
    @GetMapping("/my/stats")
    public AjaxResult myOrderStats() {
        Long userId = SecurityUtils.getUserId();
        return AjaxResult.success(orderService.getUserOrderStats(userId));
    }

    /**
     * 管理员订单统计（各状态数量 + 营业收入 + 今日新增）
     */
    @GetMapping("/stats")
    @PreAuthorize("@ss.hasPermi('business:order:list')")
    public AjaxResult adminOrderStats() {
        return AjaxResult.success(orderService.getAdminOrderStats());
    }

    @GetMapping("/{id:\\d+}")
    @PreAuthorize("@ss.hasPermi('business:order:list')")
    public AjaxResult getById(@PathVariable("id") Long orderId) {
        Long userId = SecurityUtils.getUserId();
        orderService.validateOrderOwnership(orderId, userId);
        Order order = orderService.getById(orderId);
        List<OrderItem> items = orderService.getOrderItems(orderId);
        Map<String, Object> result = new HashMap<>();
        result.put("order", order);
        result.put("items", items);
        return AjaxResult.success(result);
    }

    /**
     * 用户查看自己的订单详情（无需管理员权限，仅校验所有权）
     */
    @GetMapping("/my/{id:\\d+}")
    public AjaxResult myOrderDetail(@PathVariable("id") Long orderId) {
        Long userId = SecurityUtils.getUserId();
        orderService.validateOrderOwnership(orderId, userId);
        Order order = orderService.getById(orderId);
        List<OrderItem> items = orderService.getOrderItems(orderId);
        Map<String, Object> result = new HashMap<>();
        result.put("order", order);
        result.put("items", items);
        return AjaxResult.success(result);
    }

    // 用户侧允许的状态转换白名单
    private static final Set<String> USER_ALLOWED_TRANSITIONS = Set.of(
        "PAID",       // 待付款 → 已付款
        "CANCELLED",  // 待付款 → 已取消
        "DELIVERED"   // 已发货 → 已签收
    );

    /**
     * 用户操作自己的订单状态（支付、取消、确认收货）
     * 无需管理员权限，仅校验所有权，状态机负责校验合法转换
     */
    @PutMapping("/my/{id:\\d+}/status")
    public AjaxResult myOrderUpdateStatus(@PathVariable("id") Long orderId,
                                          @RequestBody Map<String, String> body) {
        Long userId = SecurityUtils.getUserId();
        orderService.validateOrderOwnership(orderId, userId);
        String targetStatus = body.get("status");
        // 用户侧白名单校验：防止用户触发 REFUNDED 等运营侧状态
        if (!USER_ALLOWED_TRANSITIONS.contains(targetStatus)) {
            return AjaxResult.error("用户无权执行该状态变更：" + targetStatus);
        }
        orderService.updateOrderStatus(orderId, targetStatus, null, null);
        return AjaxResult.success();
    }

    /**
     * 创建订单
     */
    @PostMapping
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    public AjaxResult createOrder(@RequestBody Map<String, Object> body) {
        Long userId = SecurityUtils.getUserId();
        String address = (String) body.get("address");
        String remark = (String) body.get("remark");

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> itemMaps = (List<Map<String, Object>>) body.get("items");
        if (itemMaps == null || itemMaps.isEmpty()) {
            return AjaxResult.error("订单项不能为空");
        }

        List<OrderItem> items = itemMaps.stream().map(m -> {
            OrderItem item = new OrderItem();
            item.setProductId(Long.valueOf(m.get("productId").toString()));
            item.setQuantity(Integer.valueOf(m.get("quantity").toString()));
            return item;
        }).collect(Collectors.toList());

        Order order = orderService.createOrder(userId, address, remark, items);
        return AjaxResult.success(order);
    }

    @PutMapping("/{id:\\d+}/status")
    @PreAuthorize("@ss.hasPermi('business:order:status')")
    public AjaxResult updateStatus(@PathVariable("id") Long orderId,
                                   @RequestBody Map<String, String> body) {
        Long userId = SecurityUtils.getUserId();
        orderService.validateOrderOwnership(orderId, userId);
        String logisticsNo = body.get("logisticsNo");
        String logisticsCompany = body.get("logisticsCompany");
        orderService.updateOrderStatus(orderId, body.get("status"), logisticsNo, logisticsCompany);
        return AjaxResult.success();
    }

    /**
     * 获取订单允许的下一步状态列表（供前端状态对话框使用）
     */
    @GetMapping("/{id:\\d+}/allowed-statuses")
    @PreAuthorize("@ss.hasPermi('business:order:status')")
    public AjaxResult getAllowedStatuses(@PathVariable("id") Long orderId) {
        Long userId = SecurityUtils.getUserId();
        orderService.validateOrderOwnership(orderId, userId);
        Order order = orderService.getById(orderId);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }
        OrderStatus current = OrderStatus.fromCode(order.getStatus());
        Set<OrderStatus> allowed = OrderStatusTransition.getAllowedNextStatuses(current);
        List<Map<String, String>> result = allowed.stream().map(s -> Map.of(
                "code", s.getCode(),
                "desc", s.getDesc()
        )).collect(Collectors.toList());
        return AjaxResult.success(result);
    }

    @PutMapping("/{id:\\d+}")
    @PreAuthorize("@ss.hasPermi('business:order:edit')")
    public AjaxResult update(@PathVariable("id") Long orderId, @RequestBody Order order) {
        order.setOrderId(orderId);
        orderService.updateOrder(order);
        return AjaxResult.success();
    }

    /**
     * 导出订单列表
     */
    @PostMapping("/export")
    @PreAuthorize("@ss.hasPermi('business:order:list')")
    public void export(HttpServletResponse response,
                       @RequestParam(required = false) String orderNo,
                       @RequestParam(required = false) String status) {
        List<Order> list = orderService.listAllOrders(orderNo, status);
        ExcelUtil<Order> util = new ExcelUtil<>(Order.class);
        util.exportExcel(response, list, "订单数据");
    }
}
