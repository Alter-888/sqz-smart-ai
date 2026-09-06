<template>
  <div class="order-cards">
    <div v-for="item in items" :key="item.orderNo || item.order_no" class="order-card-item">
      <div class="order-header">
        <span class="order-no">{{ item.orderNo || item.order_no }}</span>
        <el-tag size="small" :type="statusType(item.status)">{{ statusLabel(item.status) }}</el-tag>
      </div>
      <div class="order-body">
        <div class="order-amount">&yen;{{ Number(item.totalAmount || item.total_amount || 0).toFixed(2) }}</div>
        <div v-if="item.createTime || item.create_time" class="order-time">{{ formatTime(item.createTime || item.create_time) }}</div>
      </div>
      <div class="order-actions">
        <el-button
          v-if="item.status === 'PENDING'"
          type="danger"
          size="small"
          @click="openPay(item)"
        >去支付</el-button>
        <el-button type="primary" size="small" link @click="handleDetail">查看详情</el-button>
      </div>
    </div>

    <!-- 支付弹窗 -->
    <PayDialog
      v-model:visible="payVisible"
      :loading="payLoading"
      :order-no="payingOrder.orderNo"
      :total-amount="payingOrder.totalAmount"
      :product-summary="payingOrder.summary"
      @confirm="handlePayConfirm"
    />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { orderStatusMap } from '@/utils/format'
import PayDialog from '@/components/PayDialog/index.vue'
import { myUpdateOrderStatus } from '@/api/business/order'

defineProps({
  items: { type: Array, default: () => [] }
})

const router = useRouter()

const payVisible = ref(false)
const payLoading = ref(false)
const payingOrder = ref({ orderId: null, orderNo: '', totalAmount: '0.00', summary: '' })

function statusLabel(status) {
  return orderStatusMap[status]?.label || status
}

function statusType(status) {
  return orderStatusMap[status]?.type || 'info'
}

function formatTime(time) {
  if (!time) return ''
  return time.replace('T', ' ').substring(0, 16)
}

function handleDetail() {
  router.push('/customer/orders')
}

function openPay(item) {
  payingOrder.value = {
    orderId: item.order_id || item.orderId,
    orderNo: item.orderNo || item.order_no || '',
    totalAmount: Number(item.totalAmount || item.total_amount || 0).toFixed(2),
    summary: item.items_summary || ''
  }
  payVisible.value = true
}

async function handlePayConfirm(method) {
  payLoading.value = true
  try {
    // 模拟支付延时
    await new Promise(resolve => setTimeout(resolve, 1000))
    await myUpdateOrderStatus(payingOrder.value.orderId, 'PAID')
    ElMessage.success('支付成功！')
    payVisible.value = false
    // 通知刷新订单数据
    window.dispatchEvent(new CustomEvent('ai-data-changed', { detail: { types: ['order'] } }))
  } catch (e) {
    ElMessage.error(e.message || '支付失败，请重试')
  } finally {
    payLoading.value = false
  }
}
</script>

<style scoped>
.order-cards {
  display: flex;
  gap: 14px;
  overflow-x: auto;
  padding: 8px 4px 16px;
  max-width: 820px;
  scrollbar-width: thin;
}

.order-cards::-webkit-scrollbar {
  height: 6px;
}

.order-cards::-webkit-scrollbar-thumb {
  background: #e4e7ed;
  border-radius: 3px;
}

.order-card-item {
  width: 260px;
  min-width: 260px;
  border: 1px solid #eef0f3;
  border-radius: 16px;
  padding: 18px;
  background: #fff;
  flex-shrink: 0;
  transition: all 0.35s cubic-bezier(0.25, 0.8, 0.25, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  display: flex;
  flex-direction: column;
}

.order-card-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.1);
  border-color: transparent;
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 14px;
  padding-bottom: 10px;
  border-bottom: 1px dashed #eef0f3;
}

.order-no {
  font-size: 13px;
  color: #1a1c21;
  font-family: 'Fira Code', monospace;
  font-weight: 600;
}

.order-body {
  flex: 1;
  margin-bottom: 12px;
}

.order-amount {
  font-size: 22px;
  font-weight: 700;
  color: #f56c6c;
  margin-bottom: 6px;
}

.order-time {
  font-size: 12px;
  color: #b0b3ba;
}

.order-actions {
  margin-top: auto;
  text-align: right;
  display: flex;
  justify-content: flex-end;
  align-items: center;
  gap: 8px;
}
</style>
