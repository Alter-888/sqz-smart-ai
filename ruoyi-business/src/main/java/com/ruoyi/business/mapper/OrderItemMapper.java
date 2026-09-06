package com.ruoyi.business.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.business.entity.OrderItem;
import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface OrderItemMapper extends BaseMapper<OrderItem> {

    /**
     * 查询单个商品的销量（已付款/已发货/已签收订单的quantity之和）
     */
    @Select("SELECT IFNULL(SUM(oi.quantity), 0) FROM biz_order_item oi " +
            "INNER JOIN biz_order o ON oi.order_id = o.order_id " +
            "WHERE oi.product_id = #{productId} AND o.status IN ('PAID', 'SHIPPED', 'DELIVERED')")
    Integer selectSalesCount(@Param("productId") Long productId);

    /**
     * 批量查询多个商品的销量（列表页面用，避免N+1）
     */
    @MapKey("productId")
    @Select("<script>" +
            "SELECT oi.product_id AS productId, IFNULL(SUM(oi.quantity), 0) AS salesCount " +
            "FROM biz_order_item oi " +
            "INNER JOIN biz_order o ON oi.order_id = o.order_id " +
            "WHERE o.status IN ('PAID', 'SHIPPED', 'DELIVERED') " +
            "AND oi.product_id IN " +
            "<foreach collection='productIds' item='id' open='(' separator=',' close=')'>#{id}</foreach> " +
            "GROUP BY oi.product_id" +
            "</script>")
    Map<Long, Map<String, Object>> selectBatchSalesCount(@Param("productIds") List<Long> productIds);
}
