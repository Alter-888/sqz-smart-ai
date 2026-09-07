<template>
  <div class="pending-confirm-card" :class="statusClass">
    <div class="pending-header">
      <span class="pending-icon">
        <el-icon v-if="isPending"><Warning /></el-icon>
        <el-icon v-else-if="isConfirmed"><CircleCheck /></el-icon>
        <el-icon v-else><CircleClose /></el-icon>
      </span>
      <span class="pending-title">{{ titleText }}</span>
    </div>

    <div class="pending-summary">{{ item.summary || '高危操作' }}</div>

    <div class="pending-footer">
      <template v-if="isPending && !expired">
        <span class="pending-countdown">剩余 <b>{{ countdownText }}</b> 后自动失效</span>
        <div class="pending-btns">
          <el-button size="small" :loading="loading" @click="handleCancel">取消</el-button>
          <el-button size="small" type="danger" :loading="loading" @click="handleConfirm">确认执行</el-button>
        </div>
      </template>

      <template v-else-if="isPending && expired">
        <span class="pending-expire-tag">该操作已超时，请重新发起</span>
      </template>

      <template v-else-if="isConfirmed">
        <span class="pending-result pending-ok">
          <el-icon><CircleCheck /></el-icon>
          {{ item.result || '操作已执行' }}
        </span>
      </template>

      <template v-else-if="isCancelled">
        <span class="pending-result pending-cancelled">
          <el-icon><CircleClose /></el-icon>
          该操作已取消
        </span>
      </template>

      <template v-else>
        <span class="pending-result pending-fail">
          <el-icon><CircleClose /></el-icon>
          {{ item.result || '操作执行失败，请重试' }}
        </span>
      </template>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch, onBeforeUnmount } from 'vue'
import { storeToRefs } from 'pinia'
import { Warning, CircleCheck, CircleClose } from '@element-plus/icons-vue'
import { confirmPendingAction, cancelPendingAction, updatePendingCardState } from '@/api/ai/chat'
import useChatStore from '@/store/modules/chat'

const props = defineProps({
  item: { type: Object, required: true }
})

const chatStore = useChatStore()
const { currentSessionId } = storeToRefs(chatStore)

const loading = ref(false)
const now = ref(Date.now())
let timer = null

// 确认成功后需要通知刷新购物车/订单等数据
const REFRESH_TYPES = {
  cancelOrder: ['order'],
  payOrder: ['order'],
  clearCart: ['cart'],
}

const status = computed(() => props.item.status || 'PENDING')
const isPending = computed(() => status.value === 'PENDING')
const isConfirmed = computed(() => status.value === 'CONFIRMED')
const isCancelled = computed(() => status.value === 'CANCELLED')
const expired = computed(() => {
  if (!isPending.value) return false
  if (!props.item.expireAt) return false
  return new Date(props.item.expireAt).getTime() <= now.value
})

const statusClass = computed(() => {
  if (isConfirmed.value) return 'is-confirmed'
  if (isCancelled.value) return 'is-cancelled'
  if (isPending.value && expired.value) return 'is-expired'
  if (!isPending.value) return 'is-failed'
  return 'is-pending'
})

const titleText = computed(() => {
  if (isConfirmed.value) return '操作已确认执行'
  if (isCancelled.value) return '操作已取消'
  if (isPending.value && expired.value) return '操作已超时'
  if (!isPending.value) return '操作执行失败'
  return '需要您确认的操作'
})

const countdownText = computed(() => {
  if (!props.item.expireAt) return '--:--'
  const remain = Math.max(0, Math.floor((new Date(props.item.expireAt).getTime() - now.value) / 1000))
  const mm = String(Math.floor(remain / 60)).padStart(2, '0')
  const ss = String(remain % 60).padStart(2, '0')
  return mm + ':' + ss
})

function persistCardState(statusValue, result) {
  const sid = currentSessionId.value
  if (!sid) return
  updatePendingCardState(sid, props.item.actionId, statusValue, result || '').catch(() => {})
}

function buildFriendlyMessage(toolName, data) {
  const orderNo = data.orderNo || ''
  if (toolName === 'cancelOrder') return orderNo ? '订单 ' + orderNo + ' 已成功取消' : '订单已成功取消'
  if (toolName === 'payOrder') return orderNo ? '订单 ' + orderNo + ' 已支付成功' : '订单已支付成功'
  if (toolName === 'clearCart') return '购物车已清空'
  return data.message || '操作已执行'
}
function refreshAfterConfirm() {
  const types = REFRESH_TYPES[props.item.toolName] || []
  if (types.length) {
    window.dispatchEvent(new CustomEvent('ai-data-changed', { detail: { types } }))
  }
}

async function handleConfirm() {
  loading.value = true
  try {
    const res = await confirmPendingAction(props.item.actionId)
    const data = res.data || {}
    const friendly = buildFriendlyMessage(props.item.toolName, data)
    Object.assign(props.item, {
      status: 'CONFIRMED',
      result: friendly,
      orderNo: data.orderNo || '',
      message: data.message || ''
    })
    persistCardState('CONFIRMED', friendly)
    refreshAfterConfirm()
  } catch (e) {
    const msg = (e && e.message) || ''
    if (/已超时|已处理|操作不存在/.test(msg)) {
      Object.assign(props.item, { status: 'EXPIRED', result: msg })
      persistCardState('EXPIRED', msg)
    } else {
      Object.assign(props.item, { status: 'FAILED', result: msg || '操作执行失败' })
      persistCardState('FAILED', msg || '')
    }
  } finally {
    loading.value = false
  }
}

async function handleCancel() {
  loading.value = true
  try {
    await cancelPendingAction(props.item.actionId)
    Object.assign(props.item, { status: 'CANCELLED', result: '' })
    persistCardState('CANCELLED', '')
  } catch (e) {
    const msg = (e && e.message) || ''
    if (/已超时|已处理|操作不存在/.test(msg)) {
      Object.assign(props.item, { status: 'EXPIRED', result: msg })
      persistCardState('EXPIRED', msg)
    } else {
      Object.assign(props.item, { status: 'FAILED', result: msg || '取消失败' })
      persistCardState('FAILED', msg || '')
    }
  } finally {
    loading.value = false
  }
}

// 每 1 秒刷新倒计时
timer = setInterval(() => {
  now.value = Date.now()
}, 1000)

// 一旦确认/取消/超时/失败，停掉倒计时
watch([status, expired], (vals) => {
  if (timer && (vals[0] !== 'PENDING' || vals[1])) {
    clearInterval(timer)
    timer = null
  }
})

onBeforeUnmount(() => {
  if (timer) clearInterval(timer)
})
</script>

<style scoped>
.pending-confirm-card {
  margin-top: 12px;
  width: 100%;
  max-width: 560px;
  border: 1px solid #f3d19e;
  border-radius: 14px;
  background: linear-gradient(180deg, #fffbf2 0%, #fff8ec 100%);
  padding: 14px 16px;
  box-shadow: 0 4px 14px rgba(232, 162, 60, 0.08);
  box-sizing: border-box;
}

.pending-confirm-card.is-confirmed {
  border-color: #c2e7d0;
  background: linear-gradient(180deg, #f4fbf6 0%, #eef9f1 100%);
  box-shadow: 0 4px 14px rgba(103, 194, 58, 0.08);
}

.pending-confirm-card.is-cancelled,
.pending-confirm-card.is-expired {
  border-color: #e4e7ed;
  background: #f7f8fa;
  box-shadow: none;
}

.pending-confirm-card.is-failed {
  border-color: #fbc4c4;
  background: #fef0f0;
  box-shadow: none;
}

.pending-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.pending-icon {
  font-size: 18px;
  color: #e6a23c;
  display: flex;
  align-items: center;
}

.pending-confirm-card.is-confirmed .pending-icon { color: #67c23a; }
.pending-confirm-card.is-cancelled .pending-icon,
.pending-confirm-card.is-expired .pending-icon { color: #909399; }
.pending-confirm-card.is-failed .pending-icon { color: #f56c6c; }

.pending-title {
  font-size: 14px;
  font-weight: 600;
  color: #1a1c21;
}

.pending-summary {
  font-size: 14px;
  line-height: 1.7;
  color: #303133;
  word-break: break-word;
  white-space: pre-wrap;
  margin-bottom: 12px;
}

.pending-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.pending-countdown {
  font-size: 12px;
  color: #b88230;
}

.pending-countdown b {
  font-family: 'Fira Code', Consolas, monospace;
  font-size: 13px;
}

.pending-btns {
  display: flex;
  gap: 8px;
}

.pending-expire-tag {
  font-size: 13px;
  color: #909399;
}

.pending-result {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: #606266;
}

.pending-result.pending-ok {
  color: #67c23a;
  font-weight: 500;
}

.pending-result.pending-cancelled {
  color: #909399;
}

.pending-result.pending-fail {
  color: #f56c6c;
}
</style>
