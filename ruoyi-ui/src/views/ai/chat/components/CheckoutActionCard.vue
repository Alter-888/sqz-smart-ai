<template>
  <div class="checkout-action-card" :class="{ 'is-completed': completed }">
    <div class="checkout-header">
      <span class="checkout-icon">
        <el-icon><ShoppingCart /></el-icon>
      </span>
      <span class="checkout-title">{{ completed ? '结算已完成' : '购物车结算' }}</span>
    </div>

    <template v-if="!completed">
      <div class="checkout-body">
        <div class="checkout-detail">
          <span class="checkout-line"><b>共 {{ item.itemCount || 0 }} 件</b>商品</span>
          <span v-if="item.checkedCount != null" class="checkout-line">已勾选 <b>{{ item.checkedCount }}</b> 件</span>
          <span class="checkout-price">合计 <b>&yen;{{ Number(item.totalPrice || 0).toFixed(2) }}</b></span>
        </div>
        <div v-if="item.productNames" class="checkout-names">{{ item.productNames }}</div>
      </div>

      <div class="checkout-footer">
        <span class="checkout-tip">点击下方按钮，在标准结算窗口确认地址与支付方式</span>
        <el-button type="primary" size="small" @click="handleGoCheckout">
          <el-icon><Position /></el-icon> 去结算
        </el-button>
      </div>
    </template>

    <template v-else>
      <div class="checkout-body">
        <div class="checkout-result">
          <el-icon class="result-icon"><CircleCheck /></el-icon>
          <span class="result-text">
            <template v-if="orderStatus === 'PAID'">订单已支付成功</template>
            <template v-else>订单已提交，待付款</template>
          </span>
        </div>
        <div v-if="orderNo" class="checkout-order-no">订单号：{{ orderNo }}</div>
      </div>

      <div class="checkout-footer">
        <span class="checkout-tip">可到「我的订单」查看订单进度</span>
      </div>
    </template>
  </div>
</template>

<script setup>
import { computed, ref, onMounted, onBeforeUnmount } from 'vue'
import { storeToRefs } from 'pinia'
import { ShoppingCart, Position, CircleCheck } from '@element-plus/icons-vue'
import { updateCheckoutCardState } from '@/api/ai/chat'
import useChatStore from '@/store/modules/chat'

const props = defineProps({
  item: { type: Object, required: true }
})

const chatStore = useChatStore()
const { currentSessionId } = storeToRefs(chatStore)

const completed = ref(!!props.item.completed)
const orderNo = ref(props.item.orderNo || '')
const orderStatus = ref(props.item.status || '')

function handleGoCheckout() {
  // 触发全局事件，CustomerLayout 监听后打开屏幕中央结算弹窗
  window.dispatchEvent(new CustomEvent('sqz-open-checkout'))
}

// 结算/支付成功后，更新卡片状态并持久化（刷新页面仍显示已完成）
function handleCheckoutCompleted(event) {
  const detail = event.detail || {}
  completed.value = true
  orderNo.value = detail.orderNo || props.item.orderNo || ''
  orderStatus.value = detail.status || props.item.status || ''
  // 同步到 store 内消息里的卡片对象，重进会话也保持一致
  props.item.completed = true
  props.item.orderNo = orderNo.value
  props.item.status = orderStatus.value
  const sid = currentSessionId.value
  if (sid && props.item.cardId) {
    updateCheckoutCardState(sid, props.item.cardId, orderStatus.value, orderNo.value).catch(() => {})
  }
}

onMounted(() => window.addEventListener('sqz-checkout-completed', handleCheckoutCompleted))
onBeforeUnmount(() => window.removeEventListener('sqz-checkout-completed', handleCheckoutCompleted))
</script>

<style scoped>
.checkout-action-card {
  margin-top: 12px;
  width: 100%;
  max-width: 560px;
  border: 1px solid #e4e7ed;
  border-radius: 14px;
  background: linear-gradient(180deg, #ffffff 0%, #fafbfc 100%);
  padding: 14px 16px;
  box-shadow: 0 4px 14px rgba(31, 45, 61, 0.06);
  box-sizing: border-box;
}

.checkout-action-card.is-completed {
  border-color: #c2e7d0;
  background: linear-gradient(180deg, #f4fbf6 0%, #eef9f1 100%);
  box-shadow: 0 4px 14px rgba(103, 194, 58, 0.08);
}

.checkout-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
}

.checkout-icon {
  font-size: 18px;
  color: #409eff;
  display: flex;
  align-items: center;
}

.checkout-action-card.is-completed .checkout-icon { color: #67c23a; }

.checkout-title {
  font-size: 14px;
  font-weight: 600;
  color: #1a1c21;
}

.checkout-body {
  margin-bottom: 10px;
}

.checkout-detail {
  display: flex;
  align-items: center;
  gap: 14px;
  flex-wrap: wrap;
  font-size: 13px;
  color: #606266;
}

.checkout-line b {
  color: #303133;
  font-weight: 600;
}

.checkout-price b {
  color: #f56c6c;
  font-size: 16px;
}

.checkout-names {
  margin-top: 6px;
  font-size: 12px;
  color: #909399;
  line-height: 1.6;
  word-break: break-word;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.checkout-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.checkout-tip {
  font-size: 12px;
  color: #909399;
}

.checkout-result {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}

.result-icon {
  font-size: 20px;
  color: #67c23a;
}

.result-text {
  font-size: 14px;
  font-weight: 600;
  color: #67c23a;
}

.checkout-order-no {
  font-size: 13px;
  color: #606266;
}
</style>