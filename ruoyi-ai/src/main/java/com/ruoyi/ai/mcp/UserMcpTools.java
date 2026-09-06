package com.ruoyi.ai.mcp;

import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.entity.ToolCallLog;
import com.ruoyi.ai.event.ToolCallEvent;
import com.ruoyi.ai.mapper.ToolCallLogMapper;
import com.ruoyi.ai.util.SensitiveDataMasker;
import com.ruoyi.business.entity.Address;
import com.ruoyi.business.service.AddressService;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.service.ISysUserService;
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
 * MCP 用户工具：为 AI 提供用户信息查询、收货地址管理能力
 * 通过 MCP 协议暴露，同时支持 MethodToolCallbackProvider 直接调用
 */
@Component
@RequiredArgsConstructor
public class UserMcpTools {

    private static final Logger log = LoggerFactory.getLogger(UserMcpTools.class);

    private final ISysUserService userService;
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

    @Tool(description = "查询当前登录用户的基本信息，包括昵称、手机号、邮箱、性别。当用户询问自己的个人信息、账号信息时使用此工具。")
    public Map<String, Object> queryUserInfo() {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 查询用户信息, userId: {}", userId);
        publishToolCallEvent("queryUserInfo", "正在查询用户信息...");
        try {
            SysUser user = userService.selectUserById(userId);
            if (user == null) {
                ChatContext.addToolCallName("queryUserInfo");
                return Map.of("error", "未找到用户信息");
            }

            String sex;
            if ("0".equals(user.getSex())) {
                sex = "男";
            } else if ("1".equals(user.getSex())) {
                sex = "女";
            } else {
                sex = "未知";
            }

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("nickName", user.getNickName() != null ? user.getNickName() : "");
            result.put("phone", SensitiveDataMasker.maskPhone(user.getPhonenumber()));
            result.put("email", user.getEmail() != null ? user.getEmail() : "");
            result.put("sex", sex);
            result.put("lastLoginTime", user.getLoginDate() != null ? user.getLoginDate().toString() : "");

            ChatContext.addToolCallName("queryUserInfo");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryUserInfo", "userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "查询当前用户的所有收货地址列表。当用户想查看自己的收货地址、配送地址时使用此工具。")
    public List<Map<String, Object>> queryUserAddresses() {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 查询用户地址列表, userId: {}", userId);
        publishToolCallEvent("queryUserAddresses", "正在查询收货地址...");
        try {
            List<Address> addresses = addressService.listByUserId(userId);
            if (addresses.isEmpty()) {
                ChatContext.addToolCallName("queryUserAddresses");
                return List.of(Map.of("message", "您暂无收货地址"));
            }

            List<Map<String, Object>> result = addresses.stream().map(addr -> {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("addressId", addr.getAddressId());
                map.put("contactName", addr.getContactName() != null ? addr.getContactName() : "");
                map.put("phone", SensitiveDataMasker.maskPhone(addr.getPhone()));
                map.put("province", addr.getProvince() != null ? addr.getProvince() : "");
                map.put("city", addr.getCity() != null ? addr.getCity() : "");
                map.put("district", addr.getDistrict() != null ? addr.getDistrict() : "");
                map.put("detail", SensitiveDataMasker.maskAddress(addr.getDetail()));
                map.put("isDefault", addr.getIsDefault() != null && addr.getIsDefault() == 1 ? "是" : "否");
                return map;
            }).collect(Collectors.toList());

            publishToolCallEvent("queryUserAddresses", "查询到 " + result.size() + " 个收货地址");
            ChatContext.addToolCallName("queryUserAddresses");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryUserAddresses", "userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "查询当前用户的默认收货地址。当用户询问默认地址或下单需要确认地址时使用此工具。")
    public Map<String, Object> queryDefaultAddress() {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 查询默认地址, userId: {}", userId);
        publishToolCallEvent("queryDefaultAddress", "正在查询默认收货地址...");
        try {
            Address address = addressService.getDefault(userId);
            if (address == null) {
                ChatContext.addToolCallName("queryDefaultAddress");
                return Map.of("message", "您暂未设置默认收货地址");
            }

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("addressId", address.getAddressId());
            result.put("contactName", address.getContactName() != null ? address.getContactName() : "");
            result.put("phone", SensitiveDataMasker.maskPhone(address.getPhone()));
            result.put("province", address.getProvince() != null ? address.getProvince() : "");
            result.put("city", address.getCity() != null ? address.getCity() : "");
            result.put("district", address.getDistrict() != null ? address.getDistrict() : "");
            result.put("detail", SensitiveDataMasker.maskAddress(address.getDetail()));

            ChatContext.addToolCallName("queryDefaultAddress");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryDefaultAddress", "userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "将指定收货地址设为默认地址。当用户要求更改默认地址时使用此工具。")
    public Map<String, Object> setDefaultAddress(
            @ToolParam(description = "地址ID") Long addressId) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 设置默认地址: addressId={}, userId={}", addressId, userId);
        publishToolCallEvent("setDefaultAddress", "正在设置默认地址...", List.of("address"));
        try {
            addressService.setDefault(addressId, userId);
            ChatContext.addToolCallName("setDefaultAddress");
            return Map.of(
                    "addressId", addressId,
                    "message", "已将该地址设为默认收货地址"
            );
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("setDefaultAddress");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("setDefaultAddress", "addressId=" + addressId + ",userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "新增收货地址。当用户要求添加新地址时使用此工具。如果是第一个地址会自动设为默认。")
    public Map<String, Object> addAddress(
            @ToolParam(description = "联系人姓名") String contactName,
            @ToolParam(description = "联系电话") String phone,
            @ToolParam(description = "省份") String province,
            @ToolParam(description = "城市") String city,
            @ToolParam(description = "区/县") String district,
            @ToolParam(description = "详细地址") String detail) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 新增地址, userId: {}", userId);
        publishToolCallEvent("addAddress", "正在新增收货地址...", List.of("address"));
        try {
            Address address = new Address();
            address.setContactName(contactName);
            address.setPhone(phone);
            address.setProvince(province);
            address.setCity(city);
            address.setDistrict(district);
            address.setDetail(detail);

            Address saved = addressService.addAddress(userId, address);
            ChatContext.addToolCallName("addAddress");
            return Map.of(
                    "addressId", saved.getAddressId(),
                    "message", "收货地址添加成功"
            );
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("addAddress");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("addAddress", "userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "修改收货地址信息。当用户要求更新、修改某个地址时使用此工具。")
    public Map<String, Object> updateAddress(
            @ToolParam(description = "地址ID") Long addressId,
            @ToolParam(description = "联系人姓名") String contactName,
            @ToolParam(description = "联系电话") String phone,
            @ToolParam(description = "省份") String province,
            @ToolParam(description = "城市") String city,
            @ToolParam(description = "区/县") String district,
            @ToolParam(description = "详细地址") String detail) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 修改地址: addressId={}, userId={}", addressId, userId);
        publishToolCallEvent("updateAddress", "正在修改收货地址...", List.of("address"));
        try {
            Address address = new Address();
            address.setContactName(contactName);
            address.setPhone(phone);
            address.setProvince(province);
            address.setCity(city);
            address.setDistrict(district);
            address.setDetail(detail);

            addressService.updateAddress(addressId, userId, address);
            ChatContext.addToolCallName("updateAddress");
            return Map.of(
                    "addressId", addressId,
                    "message", "收货地址修改成功"
            );
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("updateAddress");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("updateAddress", "addressId=" + addressId + ",userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "删除收货地址。当用户要求删除某个地址时使用此工具。")
    public Map<String, Object> deleteAddress(
            @ToolParam(description = "地址ID") Long addressId) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 删除地址: addressId={}, userId={}", addressId, userId);
        publishToolCallEvent("deleteAddress", "正在删除收货地址...", List.of("address"));
        try {
            addressService.deleteAddress(addressId, userId);
            ChatContext.addToolCallName("deleteAddress");
            return Map.of(
                    "addressId", addressId,
                    "message", "收货地址已删除"
            );
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("deleteAddress");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("deleteAddress", "addressId=" + addressId + ",userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }
}
