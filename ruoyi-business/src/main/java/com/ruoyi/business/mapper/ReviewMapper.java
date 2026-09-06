package com.ruoyi.business.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.business.entity.Review;
import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface ReviewMapper extends BaseMapper<Review> {

    /**
     * 批量查询多个商品的平均评分和评价数量（列表页面用）
     */
    @MapKey("productId")
    @Select("<script>" +
            "SELECT product_id AS productId, " +
            "ROUND(AVG(rating), 1) AS avgRating, " +
            "COUNT(*) AS reviewCount " +
            "FROM biz_review WHERE status = 1 AND product_id IN " +
            "<foreach collection='productIds' item='id' open='(' separator=',' close=')'>#{id}</foreach> " +
            "GROUP BY product_id" +
            "</script>")
    Map<Long, Map<String, Object>> selectBatchAvgRating(@Param("productIds") List<Long> productIds);
}
