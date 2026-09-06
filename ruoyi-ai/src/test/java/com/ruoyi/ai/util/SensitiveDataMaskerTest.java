package com.ruoyi.ai.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * SensitiveDataMasker 敏感数据脱敏工具单元测试
 */
class SensitiveDataMaskerTest {

    // ======================== maskPhone ========================

    @Test
    @DisplayName("maskPhone - 标准11位手机号脱敏")
    void maskPhone_standard11Digits() {
        assertEquals("138****5678", SensitiveDataMasker.maskPhone("13812345678"));
    }

    @Test
    @DisplayName("maskPhone - 短号码(<=3位)全部替换为***")
    void maskPhone_shortNumber() {
        assertEquals("***", SensitiveDataMasker.maskPhone("123"));
        assertEquals("***", SensitiveDataMasker.maskPhone("12"));
        assertEquals("***", SensitiveDataMasker.maskPhone("1"));
    }

    @Test
    @DisplayName("maskPhone - 中等长度(4-7位)保留前3位加****")
    void maskPhone_mediumLength() {
        assertEquals("138****", SensitiveDataMasker.maskPhone("1381234"));
        assertEquals("138****", SensitiveDataMasker.maskPhone("1381"));
    }

    @Test
    @DisplayName("maskPhone - null和空串原样返回")
    void maskPhone_nullAndEmpty() {
        assertNull(SensitiveDataMasker.maskPhone(null));
        assertEquals("", SensitiveDataMasker.maskPhone(""));
    }

    // ======================== maskAddress ========================

    @Test
    @DisplayName("maskAddress - 标准地址(>6字符)保留前6加***")
    void maskAddress_standardLong() {
        assertEquals("北京市朝阳区***", SensitiveDataMasker.maskAddress("北京市朝阳区建国门外大街1号"));
    }

    @Test
    @DisplayName("maskAddress - 短地址(<=2字符)返回**")
    void maskAddress_shortAddress() {
        assertEquals("**", SensitiveDataMasker.maskAddress("北京"));
        assertEquals("**", SensitiveDataMasker.maskAddress("京"));
    }

    @Test
    @DisplayName("maskAddress - 中等地址(3-6字符)保留前2加***")
    void maskAddress_mediumAddress() {
        assertEquals("北京***", SensitiveDataMasker.maskAddress("北京市朝阳"));
        assertEquals("北京***", SensitiveDataMasker.maskAddress("北京市"));
    }

    // ======================== maskOrderData ========================

    @Test
    @DisplayName("maskOrderData - 正常Map中phone和address字段都被脱敏")
    void maskOrderData_normalMap() {
        Map<String, Object> data = new HashMap<>();
        data.put("phone", "13812345678");
        data.put("address", "北京市朝阳区建国门外大街1号");
        data.put("orderId", 12345L);

        SensitiveDataMasker.maskOrderData(data);

        assertEquals("138****5678", data.get("phone"));
        assertEquals("北京市朝阳区***", data.get("address"));
        assertEquals(12345L, data.get("orderId")); // 其他字段不受影响
    }

    @Test
    @DisplayName("maskOrderData - null Map不抛异常")
    void maskOrderData_nullMap() {
        assertDoesNotThrow(() -> SensitiveDataMasker.maskOrderData(null));
    }

    @Test
    @DisplayName("maskOrderData - 非String类型的phone值被跳过")
    void maskOrderData_nonStringPhone() {
        Map<String, Object> data = new HashMap<>();
        data.put("phone", 13812345678L); // Long类型，非String
        data.put("address", 12345); // Integer类型，非String

        SensitiveDataMasker.maskOrderData(data);

        assertEquals(13812345678L, data.get("phone")); // 未被修改
        assertEquals(12345, data.get("address")); // 未被修改
    }
}
