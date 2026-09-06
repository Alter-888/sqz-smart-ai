package com.ruoyi.ai.mcp;

import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.entity.ToolCallLog;
import com.ruoyi.ai.event.ToolCallEvent;
import com.ruoyi.ai.mapper.ToolCallLogMapper;
import com.ruoyi.business.entity.Address;
import com.ruoyi.business.entity.CartItem;
import com.ruoyi.business.entity.Order;
import com.ruoyi.business.entity.OrderItem;
import com.ruoyi.business.service.AddressService;
import com.ruoyi.business.service.CartService;
import com.ruoyi.business.service.OrderService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * MCP 购物车工具：为 AI 提供购物车查看、添加、移除、清空能力
 */
@Component
@RequiredArgsConstructor
public class CartMcpTools {

    private static final Logger log = LoggerFactory.getLogger(CartMcpTools.class);

    private final CartService cartService;
    private final OrderService orderService;
    private final AddressService addressService;
    private final ToolCallLogMapper toolCallLogMapper;
    private final ApplicationEventPublisher eventPublisher;

    private void logToolCall(String toolName, String params, boolean success, long durationMs, String errorMsg) {
        try {
            ToolCallLog callLog = new ToolCallLog();
            callLog.setToolName(toolName);
            callLog.setToolParams(params);
            callLog.setSessionId(ChatContext.getSessionId());
            callLog.setSuccessFlag(success ? 1 : 0);
            callLog.setDurationMs(durationMs);
            callLog.setErrorMsg(errorMsg);
            toolCallLogMapper.insert(callLog);
        } catch (Exception e) {
            log.warn("记录工具调用日志失败: {}", e.getMessage());
        }
    }

    private void publishToolCallEvent(String toolName, String description) {
        try {
            Long sessionId = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, toolName, description, sessionId));
        } catch (Exception e) {
            log.warn("发布工具调用事件失败: {}", e.getMessage());
        }
    }

    private void publishToolCallEvent(String toolName, String description, List<String> refreshTypes) {
        try {
            Long sessionId = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, toolName, description, sessionId, null, null, refreshTypes));
        } catch (Exception e) {
            log.warn("发布工具调用事件失败: {}", e.getMessage());
        }
    }

    @Tool(description = "查看当前用户的购物车内容，包括商品列表和总计信息。当用户询问购物车、想看购物车时使用此工具。")
    public Map<String, Object> viewCart() {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 查看购物车, userId: {}", userId);
        publishToolCallEvent("viewCart", "正在查看购物车...");
        try {
            List<CartItem> items = cartService.listByUserId(userId);
            Map<String, Object> summary = cartService.getCartSummary(userId);

            if (items.isEmpty()) {
                ChatContext.addToolCallName("viewCart");
                return Map.of("message", "您的购物车是空的");
            }

            List<Map<String, Object>> itemList = items.stream().map(item -> {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("productId", item.getProductId());
                map.put("productName", item.getProductName() != null ? item.getProductName() : "");
                map.put("price", item.getPrice() != null ? item.getPrice().toString() : "");
                map.put("quantity", item.getQuantity());
                map.put("stock", item.getStock() != null ? item.getStock() : 0);
                map.put("checked", item.getChecked() != null && item.getChecked() == 1 ? "是" : "否");
                return map;
            }).collect(Collectors.toList());

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("items", itemList);
            result.put("totalItems", summary.get("totalItems"));
            result.put("checkedItems", summary.get("checkedItems"));
            result.put("totalPrice", summary.get("totalPrice").toString());

            publishToolCallEvent("viewCart", "购物车共 " + items.size() + " 件商品");
            ChatContext.addToolCallName("viewCart");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("viewCart", "userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "添加商品到购物车。如果商品已在购物车中，会累加数量。当用户要求加入购物车、想买某个商品时使用此工具。")
    public Map<String, Object> addToCart(
            @ToolParam(description = "商品ID") Long productId,
            @ToolParam(description = "数量，默认为1") Integer quantity) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        if (quantity == null) {
            quantity = 1;
        }
        log.info("工具调用 - 添加到购物车: productId={}, quantity={}, userId={}", productId, quantity, userId);
        publishToolCallEvent("addToCart", "正在添加商品到购物车...", List.of("cart"));
        try {
            CartItem item = cartService.addItem(userId, productId, quantity);

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("productId", item.getProductId());
            result.put("productName", item.getProductName() != null ? item.getProductName() : "");
            result.put("quantity", item.getQuantity());
            result.put("price", item.getPrice() != null ? item.getPrice().toString() : "");
            result.put("message", "已将「" + (item.getProductName() != null ? item.getProductName() : "商品") + "」加入购物车，当前数量: " + item.getQuantity());

            ChatContext.addToolCallName("addToCart");
            return result;
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("addToCart");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("addToCart", "productId=" + productId + ",quantity=" + quantity + ",userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "从购物车中移除指定商品。当用户要求删除购物车中的某个商品、不想要某个商品时使用此工具。")
    public Map<String, Object> removeFromCart(
            @ToolParam(description = "商品ID") Long productId) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 移除购物车商品: productId={}, userId={}", productId, userId);
        publishToolCallEvent("removeFromCart", "正在移除购物车商品...", List.of("cart"));
        try {
            cartService.removeItem(userId, productId);
            ChatContext.addToolCallName("removeFromCart");
            return Map.of(
                    "productId", productId,
                    "message", "已将商品从购物车移除"
            );
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("removeFromCart");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("removeFromCart", "productId=" + productId + ",userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "修改购物车中指定商品的数量。当用户要求更改、修改购物车商品数量时使用此工具。")
    public Map<String, Object> updateCartQuantity(
            @ToolParam(description = "商品ID") Long productId,
            @ToolParam(description = "新的数量，必须大于0") Integer quantity) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 修改购物车数量: productId={}, quantity={}, userId={}", productId, quantity, userId);
        publishToolCallEvent("updateCartQuantity", "正在修改购物车数量...", List.of("cart"));
        try {
            cartService.updateQuantity(userId, productId, quantity);
            List<CartItem> items = cartService.listByUserId(userId);
            String productName = items.stream()
                    .filter(i -> i.getProductId().equals(productId))
                    .map(CartItem::getProductName)
                    .findFirst().orElse("商品");

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("productId", productId);
            result.put("productName", productName);
            result.put("quantity", quantity);
            result.put("message", "已将「" + productName + "」数量修改为 " + quantity);

            ChatContext.addToolCallName("updateCartQuantity");
            return result;
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("updateCartQuantity");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("updateCartQuantity", "productId=" + productId + ",quantity=" + quantity + ",userId=" + userId,
                    success, System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "清空当前用户的购物车。当用户要求清空购物车时使用此工具。注意：这是一个危险操作，AI应先向用户确认。")
    public Map<String, Object> clearCart() {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 清空购物车, userId: {}", userId);
        publishToolCallEvent("clearCart", "正在清空购物车...", List.of("cart"));
        try {
            cartService.clearCart(userId);
            ChatContext.addToolCallName("clearCart");
            return Map.of("message", "购物车已清空");
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("clearCart", "userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "购物车结算下单。将购物车中已勾选的商品生成订单，使用用户的默认收货地址。当用户要求结算、下单、购买购物车中的商品时使用此工具。注意：这是一个重要操作，AI应先用 viewCart 展示待结算商品和地址，确认后再执行。")
    public Map<String, Object> checkoutFromCart(
            @ToolParam(description = "订单备注信息，可为空") String remark) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 购物车结算下单, userId: {}", userId);
        publishToolCallEvent("checkoutFromCart", "正在处理购物车结算...");
        try {
            // 1. 获取已勾选的购物车商品
            List<CartItem> checkedItems = cartService.listCheckedItems(userId);
            if (checkedItems.isEmpty()) {
                ChatContext.addToolCallName("checkoutFromCart");
                return Map.of("error", "购物车中没有已勾选的商品，请先选择要购买的商品");
            }

            // 2. 获取用户默认收货地址
            Address defaultAddress = addressService.getDefault(userId);
            if (defaultAddress == null) {
                ChatContext.addToolCallName("checkoutFromCart");
                return Map.of("error", "您尚未设置默认收货地址，请先添加收货地址");
            }

            // 3. 拼接完整地址字符串（含联系人和电话）
            String fullAddress = (defaultAddress.getContactName() != null ? defaultAddress.getContactName() + " " : "")
                    + (defaultAddress.getPhone() != null ? defaultAddress.getPhone() + " " : "")
                    + (defaultAddress.getProvince() != null ? defaultAddress.getProvince() : "")
                    + (defaultAddress.getCity() != null ? defaultAddress.getCity() : "")
                    + (defaultAddress.getDistrict() != null ? defaultAddress.getDistrict() : "")
                    + (defaultAddress.getDetail() != null ? defaultAddress.getDetail() : "");

            // 4. CartItem 转换为 OrderItem
            List<OrderItem> orderItems = checkedItems.stream().map(cartItem -> {
                OrderItem oi = new OrderItem();
                oi.setProductId(cartItem.getProductId());
                oi.setQuantity(cartItem.getQuantity());
                return oi;
            }).collect(Collectors.toList());

            // 5. 创建订单（含库存扣减，事务保护）
            Order order = orderService.createOrder(userId, fullAddress, remark, orderItems);

            // 6. 移除已下单的购物车商品
            List<Long> purchasedProductIds = checkedItems.stream()
                    .map(CartItem::getProductId)
                    .collect(Collectors.toList());
            cartService.removeItems(userId, purchasedProductIds);

            // 7. 构造返回结果
            Map<String, Object> result = new LinkedHashMap<>();
            result.put("orderNo", order.getOrderNo());
            result.put("orderId", order.getOrderId());
            result.put("totalAmount", order.getTotalAmount().toString());
            result.put("itemCount", checkedItems.size());
            result.put("address", fullAddress);
            result.put("message", "下单成功！订单号: " + order.getOrderNo()
                    + "，共 " + checkedItems.size() + " 件商品，合计 ¥" + order.getTotalAmount());

            // 构造订单卡片数据，推送到前端展示
            Map<String, Object> orderCardData = new LinkedHashMap<>();
            orderCardData.put("orderId", order.getOrderId());
            orderCardData.put("orderNo", order.getOrderNo());
            orderCardData.put("totalAmount", order.getTotalAmount());
            orderCardData.put("status", order.getStatus());
            orderCardData.put("createTime", order.getCreateTime() != null ? order.getCreateTime().toString() : "");

            Long sid = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, "checkoutFromCart",
                    "下单成功，订单号: " + order.getOrderNo(), sid,
                    "order", List.of(orderCardData), List.of("cart", "order")));
            ChatContext.addToolCallName("checkoutFromCart");
            return result;
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("checkoutFromCart");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("checkoutFromCart", "userId=" + userId + ",remark=" + remark, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }
}
