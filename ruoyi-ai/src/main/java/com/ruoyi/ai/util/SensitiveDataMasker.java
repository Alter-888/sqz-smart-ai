package com.ruoyi.ai.util;

/**
 * 敏感数据脱敏工具
 * 对工具返回的用户隐私信息进行脱敏处理
 */
public class SensitiveDataMasker {

    /**
     * 手机号脱敏: 138****1234
     * 短号码也会脱敏，不会泄露原文
     */
    public static String maskPhone(String phone) {
        if (phone == null || phone.isEmpty()) {
            return phone;
        }
        int len = phone.length();
        if (len <= 3) {
            return "***";
        }
        if (len <= 7) {
            return phone.substring(0, 3) + "****";
        }
        // 长度 >= 8：保留前3后4，中间用****替换
        return phone.substring(0, 3) + "****" + phone.substring(len - 4);
    }

    /**
     * 地址脱敏: 保留前几个字符，后面用 ***
     * 短地址也会脱敏，不会泄露原文
     */
    public static String maskAddress(String address) {
        if (address == null || address.isEmpty()) {
            return address;
        }
        int len = address.length();
        if (len <= 2) {
            return "**";
        }
        if (len <= 6) {
            return address.substring(0, 2) + "***";
        }
        return address.substring(0, 6) + "***";
    }

    /**
     * 对 Map 中的敏感字段进行脱敏
     */
    public static void maskOrderData(java.util.Map<String, Object> data) {
        if (data == null) return;
        Object address = data.get("address");
        if (address instanceof String) {
            data.put("address", maskAddress((String) address));
        }
        Object phone = data.get("phone");
        if (phone instanceof String) {
            data.put("phone", maskPhone((String) phone));
        }
    }
}
