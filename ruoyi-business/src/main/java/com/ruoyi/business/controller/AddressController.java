package com.ruoyi.business.controller;

import com.ruoyi.business.entity.Address;
import com.ruoyi.business.service.AddressService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/business/address")
@RequiredArgsConstructor
public class AddressController {

    private final AddressService addressService;

    /**
     * 获取当前用户地址列表
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @GetMapping("/my")
    public AjaxResult list() {
        Long userId = SecurityUtils.getUserId();
        List<Address> list = addressService.listByUserId(userId);
        return AjaxResult.success(list);
    }

    /**
     * 新增地址
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @PostMapping
    public AjaxResult add(@RequestBody Address address) {
        Long userId = SecurityUtils.getUserId();
        addressService.addAddress(userId, address);
        return AjaxResult.success(address);
    }

    /**
     * 修改地址
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @PutMapping("/{id}")
    public AjaxResult update(@PathVariable("id") Long id, @RequestBody Address address) {
        Long userId = SecurityUtils.getUserId();
        addressService.updateAddress(id, userId, address);
        return AjaxResult.success();
    }

    /**
     * 删除地址
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @DeleteMapping("/{id}")
    public AjaxResult delete(@PathVariable("id") Long id) {
        Long userId = SecurityUtils.getUserId();
        addressService.deleteAddress(id, userId);
        return AjaxResult.success();
    }

    /**
     * 设为默认地址
     */
    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @PutMapping("/{id}/default")
    public AjaxResult setDefault(@PathVariable("id") Long id) {
        Long userId = SecurityUtils.getUserId();
        addressService.setDefault(id, userId);
        return AjaxResult.success();
    }
}
