<template>
  <div class="message-list" ref="listRef">
    <div v-if="messages.length === 0" class="welcome-tip">
      <div class="welcome-icon-wrapper">
        <el-icon :size="36" color="#fff"><ChatDotRound /></el-icon>
      </div>
      <h3>你好，我是智能客服</h3>
      <p>有什么可以帮助你的吗？你可以向我咨询商品信息、查询订单或了解售后政策。</p>
      <div class="quick-actions">
        <div class="quick-card" @click="$emit('quickSend', '有什么热门商品推荐？')">
          <el-icon :size="20"><Goods /></el-icon>
          <span>商品推荐</span>
        </div>
        <div class="quick-card" @click="$emit('quickSend', '帮我查询一下我的订单状态')">
          <el-icon :size="20"><List /></el-icon>
          <span>查询订单</span>
        </div>
        <div class="quick-card" @click="$emit('quickSend', '我想了解一下退换货政策')">
          <el-icon :size="20"><QuestionFilled /></el-icon>
          <span>退换货政策</span>
        </div>
        <div class="quick-card" @click="$emit('quickSend', '帮我看看我的购物车')">
          <el-icon :size="20"><ShoppingCart /></el-icon>
          <span>查看购物车</span>
        </div>
        <div class="quick-card" @click="$emit('quickSend', '有什么5000元以内的手机推荐？')">
          <el-icon :size="20"><Search /></el-icon>
          <span>预算选购</span>
        </div>
      </div>
    </div>
    <MessageBubble
      v-for="(msg, index) in messages"
      :key="index"
      :message="msg"
      :loading="index === messages.length - 1 && loading"
      @regenerate="handleRegenerate(index)"
    />
  </div>
</template>

<script setup>
import { ref, watch, nextTick } from 'vue'
import { ChatDotRound, Goods, List, QuestionFilled, ShoppingCart, Search } from '@element-plus/icons-vue'
import MessageBubble from './MessageBubble.vue'

const props = defineProps({
  messages: { type: Array, default: () => [] },
  loading: { type: Boolean, default: false }
})

const emit = defineEmits(['quickSend', 'regenerate'])

const listRef = ref(null)

function handleRegenerate(index) {
  // 查找该 assistant 消息前面最近的 user 消息
  for (let i = index - 1; i >= 0; i--) {
    if (props.messages[i].role === 'user') {
      emit('regenerate', props.messages[i].content)
      return
    }
  }
}

function scrollToBottom() {
  nextTick(() => {
    if (listRef.value) {
      listRef.value.scrollTop = listRef.value.scrollHeight
    }
  })
}

watch(() => props.messages.length, () => {
  scrollToBottom()
})

watch(() => {
  if (props.messages.length > 0) {
    return props.messages[props.messages.length - 1].content
  }
  return ''
}, () => {
  scrollToBottom()
})

defineExpose({ scrollToBottom })
</script>

<style scoped>
.message-list {
  flex: 1;
  overflow-y: auto;
  padding: 32px 24px;
  background-color: #f7f8fa;
  scroll-behavior: smooth;
  scrollbar-width: thin;
  scrollbar-color: #dcdee2 transparent;
}
.message-list::-webkit-scrollbar { width: 6px; }
.message-list::-webkit-scrollbar-thumb {
  background: #dcdee2;
  border-radius: 3px;
}
.message-list::-webkit-scrollbar-track { background: transparent; }

/* 欢迎页 */
.welcome-tip {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: 40px;
  text-align: center;
  animation: welcomeFadeIn 0.6s ease-out;
}

@keyframes welcomeFadeIn {
  from { opacity: 0; transform: translateY(20px) scale(0.98); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

.welcome-icon-wrapper {
  width: 72px;
  height: 72px;
  background: linear-gradient(135deg, #667eea, #409eff);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 28px;
  box-shadow: 0 12px 32px rgba(64, 158, 255, 0.25);
  animation: iconFloat 3s ease-in-out infinite;
}

@keyframes iconFloat {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-6px); }
}

.welcome-tip h3 {
  font-size: 26px;
  font-weight: 700;
  color: #1a1c21;
  margin-bottom: 12px;
  letter-spacing: 0.5px;
}

.welcome-tip p {
  font-size: 15px;
  color: #8c8f97;
  margin-bottom: 40px;
  line-height: 1.7;
  max-width: 440px;
}

/* 快捷操作卡片 */
.quick-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  justify-content: center;
  max-width: 600px;
}

.quick-card {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 24px;
  background: #ffffff;
  border: 1px solid #ebedf0;
  border-radius: 12px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  color: #4a4d55;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.quick-card:hover {
  background: #ffffff;
  border-color: #c6e2ff;
  color: #409eff;
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(64, 158, 255, 0.15);
}

.quick-card .el-icon {
  color: #409eff;
}
</style>
