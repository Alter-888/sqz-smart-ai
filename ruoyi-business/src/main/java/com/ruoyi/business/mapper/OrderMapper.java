package com.ruoyi.business.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.business.entity.Order;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface OrderMapper extends BaseMapper<Order> {

    /**
     * 批量查询用户昵称（直接查sys_user表，避免跨模块依赖）
     */
    @MapKey("userId")
    @Select("<script>SELECT user_id AS userId, nick_name AS nickName FROM sys_user WHERE user_id IN " +
            "<foreach collection='userIds' item='id' open='(' separator=',' close=')'>#{id}</foreach></script>")
    Map<Long, Map<String, Object>> selectUserNickNames(List<Long> userIds);
}
