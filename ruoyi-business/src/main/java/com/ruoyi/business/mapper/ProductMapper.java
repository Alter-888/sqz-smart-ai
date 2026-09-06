package com.ruoyi.business.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.business.entity.Product;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface ProductMapper extends BaseMapper<Product> {

    /**
     * 扣减库存（乐观锁防超卖：stock >= quantity 才扣减）
     * @return 受影响行数，0 表示库存不足
     */
    @Update("UPDATE biz_product SET stock = stock - #{quantity} WHERE product_id = #{productId} AND stock >= #{quantity}")
    int deductStock(@Param("productId") Long productId, @Param("quantity") Integer quantity);

    /**
     * 回补库存（取消订单时使用）
     */
    @Update("UPDATE biz_product SET stock = stock + #{quantity} WHERE product_id = #{productId}")
    int restoreStock(@Param("productId") Long productId, @Param("quantity") Integer quantity);
}
