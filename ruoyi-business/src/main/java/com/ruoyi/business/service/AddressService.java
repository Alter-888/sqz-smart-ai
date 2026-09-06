package com.ruoyi.business.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.ruoyi.business.entity.Address;
import com.ruoyi.business.mapper.AddressMapper;
import com.ruoyi.common.exception.ServiceException;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AddressService {

    private static final Logger log = LoggerFactory.getLogger(AddressService.class);

    private final AddressMapper addressMapper;

    /**
     * 查询用户地址列表（默认地址排在前面）
     */
    public List<Address> listByUserId(Long userId) {
        LambdaQueryWrapper<Address> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Address::getUserId, userId);
        wrapper.orderByDesc(Address::getIsDefault);
        wrapper.orderByDesc(Address::getCreateTime);
        return addressMapper.selectList(wrapper);
    }

    /**
     * 获取用户默认地址
     */
    public Address getDefault(Long userId) {
        LambdaQueryWrapper<Address> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Address::getUserId, userId);
        wrapper.eq(Address::getIsDefault, 1);
        wrapper.last("LIMIT 1");
        return addressMapper.selectOne(wrapper);
    }

    /**
     * 新增地址（如果是第一条自动设为默认）
     */
    public Address addAddress(Long userId, Address address) {
        address.setUserId(userId);
        // 如果用户还没有地址，自动设为默认
        Long count = addressMapper.selectCount(
                new LambdaQueryWrapper<Address>().eq(Address::getUserId, userId));
        if (count == 0) {
            address.setIsDefault(1);
        } else if (address.getIsDefault() == null) {
            address.setIsDefault(0);
        }
        // 如果设为默认，先取消其他默认
        if (Integer.valueOf(1).equals(address.getIsDefault())) {
            clearDefault(userId);
        }
        addressMapper.insert(address);
        log.info("用户 {} 新增地址: {}", userId, address.getAddressId());
        return address;
    }

    /**
     * 修改地址（校验归属）
     */
    public void updateAddress(Long addressId, Long userId, Address address) {
        validateOwnership(addressId, userId);
        address.setAddressId(addressId);
        address.setUserId(userId);
        // 如果设为默认，先取消其他默认
        if (Integer.valueOf(1).equals(address.getIsDefault())) {
            clearDefault(userId);
        }
        addressMapper.updateById(address);
    }

    /**
     * 删除地址（校验归属）
     */
    public void deleteAddress(Long addressId, Long userId) {
        validateOwnership(addressId, userId);
        Address address = addressMapper.selectById(addressId);
        addressMapper.deleteById(addressId);
        log.info("用户 {} 删除地址: {}", userId, addressId);
        // 如果删除的是默认地址，自动将剩余的第一条地址设为默认
        if (address != null && Integer.valueOf(1).equals(address.getIsDefault())) {
            List<Address> remaining = listByUserId(userId);
            if (!remaining.isEmpty()) {
                Address first = remaining.get(0);
                first.setIsDefault(1);
                addressMapper.updateById(first);
                log.info("用户 {} 默认地址已自动补位为: {}", userId, first.getAddressId());
            }
        }
    }

    /**
     * 设置默认地址
     */
    public void setDefault(Long addressId, Long userId) {
        validateOwnership(addressId, userId);
        clearDefault(userId);
        Address address = new Address();
        address.setAddressId(addressId);
        address.setIsDefault(1);
        addressMapper.updateById(address);
        log.info("用户 {} 设默认地址: {}", userId, addressId);
    }

    /**
     * 取消用户所有默认地址
     */
    private void clearDefault(Long userId) {
        LambdaUpdateWrapper<Address> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Address::getUserId, userId);
        wrapper.eq(Address::getIsDefault, 1);
        wrapper.set(Address::getIsDefault, 0);
        addressMapper.update(null, wrapper);
    }

    /**
     * 校验地址归属
     */
    private void validateOwnership(Long addressId, Long userId) {
        Address address = addressMapper.selectById(addressId);
        if (address == null) {
            throw new ServiceException("地址不存在");
        }
        if (!address.getUserId().equals(userId)) {
            throw new ServiceException("无权操作该地址");
        }
    }
}
