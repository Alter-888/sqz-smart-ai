package com.ruoyi.ai.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.Map;

@Mapper
public interface OrderToolMapper {

    @Select("SELECT o.*, " +
            "GROUP_CONCAT(CONCAT(oi.product_name, ' x', oi.quantity) SEPARATOR ', ') as items_summary " +
            "FROM biz_order o " +
            "LEFT JOIN biz_order_item oi ON o.order_id = oi.order_id " +
            "WHERE o.order_no = #{orderNo} " +
            "GROUP BY o.order_id")
    Map<String, Object> findByOrderNo(@Param("orderNo") String orderNo);
}
