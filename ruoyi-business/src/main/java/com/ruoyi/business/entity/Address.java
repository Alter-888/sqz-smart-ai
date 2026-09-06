package com.ruoyi.business.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("biz_address")
public class Address {

    @TableId(type = IdType.AUTO)
    private Long addressId;

    private Long userId;

    private String contactName;

    private String phone;

    private String province;

    private String city;

    private String district;

    private String detail;

    /** 是否默认: 0否 1是 */
    private Integer isDefault;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
