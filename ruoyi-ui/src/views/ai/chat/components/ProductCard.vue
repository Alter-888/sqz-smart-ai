<template>
  <div class="product-cards">
    <div v-for="item in items" :key="item.productId" class="product-card-item">
      <img v-if="item.imageUrl" :src="item.imageUrl" class="card-img" />
      <div v-else class="card-img card-img-placeholder">
        <el-icon :size="24"><Goods /></el-icon>
      </div>
      <div class="card-info">
        <div class="card-name">{{ item.name }}</div>
        <div v-if="item.highlights" class="card-highlights">{{ item.highlights.split('\n')[0] }}</div>
        <div class="card-bottom">
          <span class="card-price">&yen;{{ Number(item.price).toFixed(2) }}</span>
          <span v-if="item.stock != null" class="card-stock">库存: {{ item.stock }}</span>
        </div>
      </div>
      <div class="card-actions">
        <el-button type="warning" size="small" @click="handleAddCart(item)">
          <el-icon><ShoppingCart /></el-icon> 加入购物车
        </el-button>
        <el-button type="primary" size="small" link @click="handleDetail(item)">查看详情</el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ElMessage } from 'element-plus'
import { Goods, ShoppingCart } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import useCartStore from '@/store/modules/cart'

defineProps({
  items: { type: Array, default: () => [] }
})

const cartStore = useCartStore()
const router = useRouter()

async function handleAddCart(item) {
  if (await cartStore.addItem(item)) {
    ElMessage.success('已加入购物车')
  }
}

function handleDetail(item) {
  router.push({ path: '/customer/products', query: { highlight: item.productId } })
}
</script>

<style scoped>
.product-cards {
  display: flex;
  gap: 14px;
  overflow-x: auto;
  padding: 8px 4px 16px;
  max-width: 670px;
  scrollbar-width: thin;
}

.product-cards::-webkit-scrollbar {
  height: 6px;
}

.product-cards::-webkit-scrollbar-thumb {
  background: #e4e7ed;
  border-radius: 3px;
}

.product-card-item {
  width: 230px;
  min-width: 230px;
  border: 1px solid #eef0f3;
  border-radius: 16px;
  overflow: hidden;
  background: #fff;
  flex-shrink: 0;
  transition: all 0.35s cubic-bezier(0.25, 0.8, 0.25, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.product-card-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.1);
  border-color: transparent;
}

.card-img {
  width: 100%;
  height: 160px;
  object-fit: contain;
  background: #f8f9fb;
  display: block;
  padding: 8px;
  box-sizing: border-box;
  transition: transform 0.4s ease;
}

.product-card-item:hover .card-img {
  transform: scale(1.05);
}

.card-img-placeholder {
  height: 160px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f7fa, #eef0f3);
  color: #c0c4cc;
}

.card-info {
  padding: 12px 14px;
}

.card-name {
  font-size: 14px;
  font-weight: 600;
  color: #1a1c21;
  margin-bottom: 6px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.card-highlights {
  font-size: 12px;
  color: #909399;
  margin-bottom: 8px;
  height: 18px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.card-bottom {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}

.card-price {
  color: #f56c6c;
  font-size: 18px;
  font-weight: 700;
}

.card-stock {
  font-size: 12px;
  color: #909399;
}

.card-actions {
  padding: 0 14px 14px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.card-actions .el-button {
  margin-left: 0;
  width: 100%;
  border-radius: 10px;
}

.card-actions .el-button:hover {
  transform: scale(1.02);
}
</style>
