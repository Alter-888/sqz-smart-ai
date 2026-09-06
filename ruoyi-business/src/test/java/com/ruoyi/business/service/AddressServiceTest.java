package com.ruoyi.business.service;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.core.metadata.TableInfoHelper;
import com.ruoyi.business.entity.Address;
import com.ruoyi.business.mapper.AddressMapper;
import org.apache.ibatis.builder.MapperBuilderAssistant;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * AddressService 核心方法单元测试
 */
@ExtendWith(MockitoExtension.class)
class AddressServiceTest {

    @Mock
    private AddressMapper addressMapper;

    @InjectMocks
    private AddressService addressService;

    @BeforeAll
    static void initMybatisPlusCache() {
        TableInfoHelper.initTableInfo(
                new MapperBuilderAssistant(new MybatisConfiguration(), ""),
                Address.class);
    }

    // ======================== deleteAddress ========================

    @Test
    @DisplayName("删除默认地址 - 自动将剩余第一条地址设为默认")
    void deleteAddress_defaultAddress_autoPromotes() {
        Long userId = 1L;
        Long addressId = 10L;

        // 被删除的地址是默认地址
        Address defaultAddr = new Address();
        defaultAddr.setAddressId(addressId);
        defaultAddr.setUserId(userId);
        defaultAddr.setIsDefault(1);
        // validateOwnership 和 selectById 都会查询
        when(addressMapper.selectById(addressId)).thenReturn(defaultAddr);
        when(addressMapper.deleteById(addressId)).thenReturn(1);

        // 删除后剩余一条地址
        Address remaining = new Address();
        remaining.setAddressId(20L);
        remaining.setUserId(userId);
        remaining.setIsDefault(0);
        when(addressMapper.selectList(any())).thenReturn(List.of(remaining));
        when(addressMapper.updateById(any(Address.class))).thenReturn(1);

        addressService.deleteAddress(addressId, userId);

        // 验证剩余地址被设为默认
        verify(addressMapper).updateById(argThat((Address addr) ->
                addr.getAddressId().equals(20L) && Integer.valueOf(1).equals(addr.getIsDefault())
        ));
    }

    // ======================== addAddress ========================

    @Test
    @DisplayName("新增地址 - 用户第一个地址自动设为默认")
    void addAddress_firstAddress_autoDefault() {
        Long userId = 1L;
        when(addressMapper.selectCount(any())).thenReturn(0L); // 用户无地址
        when(addressMapper.insert(any(Address.class))).thenReturn(1);

        Address address = new Address();
        address.setContactName("张三");
        address.setPhone("13800138000");

        Address result = addressService.addAddress(userId, address);

        assertEquals(1, result.getIsDefault()); // 自动设为默认
        verify(addressMapper).insert(any(Address.class));
    }
}
