<template>
  <div class="ai-chat-container">
    <!-- 侧边栏 -->
    <div class="chat-sidebar" :class="{ collapsed: sidebarCollapsed }">
      <SessionList @sessionChanged="handleSessionChanged" @collapse="toggleSidebar" />
    </div>

    <!-- 主区域 -->
    <div class="chat-main">
      <!-- 侧边栏收起后的展开按钮 -->
      <div v-if="sidebarCollapsed" class="sidebar-expand-btn" @click="toggleSidebar">
        <el-icon><Expand /></el-icon>
      </div>

      <div v-if="!currentSessionId" class="no-session">
        <el-empty description="请选择或新建一个对话" />
      </div>
      <template v-else>
        <!-- P4: 意图路由提示条（路由一出结果立刻显示"导购助手正在处理…"） -->
        <div v-if="agentProcessing" class="agent-processing-bar">
          <span class="agent-dot"></span>
          <span>导购助手正在处理…</span>
          <el-tag v-if="currentAgentLabel" size="small" type="info" effect="plain">{{ currentAgentLabel }}</el-tag>
        </div>
        <MessageList
          ref="messageListRef"
          :messages="messages"
          :loading="isLoading"
          @quickSend="handleQuickSend"
          @regenerate="handleRegenerate"
        />
        <MessageInput
          ref="messageInputRef"
          :disabled="isLoading"
          :is-loading="isLoading"
          @send="handleSend"
          @stop="handleStop"
        />
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, nextTick, onBeforeUnmount } from 'vue'
import { useRoute } from 'vue-router'
import { storeToRefs } from 'pinia'
import { Expand } from '@element-plus/icons-vue'
import useChatStore from '@/store/modules/chat'
import { sendMessage } from '@/api/ai/chat'
import { useSSE } from './composables/useSSE'
import SessionList from './components/SessionList.vue'
import MessageList from './components/MessageList.vue'
import MessageInput from './components/MessageInput.vue'

const chatStore = useChatStore()
const route = useRoute()
const { currentSessionId, messages } = storeToRefs(chatStore)
const { isStreaming, startStream, stopStream } = useSSE()

const isLoadingApi = ref(false)
const isLoading = computed(() => isStreaming.value || isLoadingApi.value)

// ====== P4: 意图路由处理提示 ======
const agentProcessing = ref(false)
const currentAgentLabel = ref('')
const AGENT_LABELS = {
  'sales-advisor': '商品导购',
  'order-service': '订单专员',
  'after-sales': '售后处理',
  account: '账户助理',
  knowledge: '政策顾问'
}
function handleIntent(intentData) {
  if (intentData && intentData.agentId) {
    agentProcessing.value = true
    currentAgentLabel.value = AGENT_LABELS[intentData.agentId] || intentData.agentId
  }
}

const messageListRef = ref(null)
const messageInputRef = ref(null)

// ====== 侧边栏收纳 ======
const sidebarCollapsed = ref(false)

function toggleSidebar() {
  sidebarCollapsed.value = !sidebarCollapsed.value
}

// ====== 打字机效果 ======
const pendingFullText = ref('')
const pendingCards = ref([])
let typingTimer = null
let typingIndex = 0

function startTyping() {
  typingIndex = 0
  const CHUNK_SIZE = 2
  const INTERVAL = 20

  typingTimer = setInterval(() => {
    const text = pendingFullText.value
    if (typingIndex < text.length) {
      const chunk = text.slice(typingIndex, typingIndex + CHUNK_SIZE)
      chatStore.updateLastMessage(chunk)
      typingIndex += CHUNK_SIZE
    } else {
      clearInterval(typingTimer)
      typingTimer = null
      // 打字完成后显示缓冲的卡片
      pendingCards.value.forEach(card => chatStore.addCardData(card))
      pendingCards.value = []
    }
  }, INTERVAL)
}

function stopTyping() {
  if (typingTimer) {
    clearInterval(typingTimer)
    typingTimer = null
    // 立即显示剩余文字
    const remaining = pendingFullText.value.slice(typingIndex)
    if (remaining) {
      chatStore.updateLastMessage(remaining)
    }
    // 立即显示缓冲的卡片
    pendingCards.value.forEach(card => chatStore.addCardData(card))
    pendingCards.value = []
    pendingFullText.value = ''
    typingIndex = 0
  }
}

onBeforeUnmount(() => {
  stopTyping()
})

// ====== 会话切换 ======
function handleSessionChanged(sessionId) {
  stopStream()
  stopTyping()
  if (messageListRef.value) {
    messageListRef.value.scrollToBottom()
  }
}

// ====== 停止生成 ======
function handleStop() {
  stopStream()
  stopTyping()
  chatStore.markToolCallHintsDone()
  isLoadingApi.value = false
}

// ====== 发送消息 ======
async function handleSend(text) {
  if (!currentSessionId.value) return

  chatStore.addMessage({
    role: 'user',
    content: text,
    createTime: new Date().toISOString()
  })

  // 首条消息时，本地立即更新会话标题（与后端逻辑一致）
  chatStore.updateSessionTitle(currentSessionId.value, text)

  doSend(text)
}

// 核心流式发送逻辑（不添加 user 消息）
function doSend(text) {
  // 清理上一次的打字状态
  stopTyping()
  pendingFullText.value = ''
  pendingCards.value = []

  chatStore.addMessage({
    role: 'assistant',
    content: '',
    createTime: new Date().toISOString()
  })

  startStream(
    text,
    currentSessionId.value,
    (chunk) => {
      // 缓冲文字，启动打字机
      pendingFullText.value += chunk
      if (!typingTimer) {
        startTyping()
      }
    },
    () => {
      // onDone - 标记工具提示完成
      agentProcessing.value = false
      chatStore.markToolCallHintsDone()
    },
    async () => {
      // onError - 降级为非流式
      stopTyping()
      agentProcessing.value = false
      isLoadingApi.value = true
      try {
        chatStore.removeLastMessage()
        const res = await sendMessage({
          message: text,
          sessionId: currentSessionId.value
        })
        chatStore.addMessage({
          role: 'assistant',
          content: res.data,
          createTime: new Date().toISOString()
        })
      } catch (e) {
        chatStore.addMessage({
          role: 'assistant',
          content: '抱歉，服务暂时不可用，请稍后重试。',
          createTime: new Date().toISOString()
        })
      } finally {
        isLoadingApi.value = false
      }
    },
    (intentData) => {
      // P4: 路由一出结果立刻显示"导购助手正在处理…"
      handleIntent(intentData)
    },
    (toolCallData) => {
      chatStore.addToolCallHint(toolCallData)
    },
    (cardPayload) => {
      // 缓冲卡片数据，等打字完成后再显示
      pendingCards.value.push(cardPayload)
    },
    (ragSources) => {
      // RAG 来源数据挂载到最后一条 assistant 消息
      chatStore.setRagSource(ragSources)
    },
    (dataChangedPayload) => {
      // AI工具修改数据后，分发全局自定义事件通知 CustomerLayout 刷新相关数据
      window.dispatchEvent(new CustomEvent('ai-data-changed', { detail: dataChangedPayload }))
    },
    (messageIdData) => {
      // 后端返回assistant消息ID，供赞/踩功能使用
      chatStore.setLastAssistantMessageId(messageIdData.messageId)
    }
  )
}

function handleQuickSend(text) {
  handleSend(text)
}

function handleRegenerate(userMessage) {
  if (!currentSessionId.value || isLoading.value) return
  // 只移除最后一条 assistant 消息，不再添加 user 消息
  if (messages.value.length > 0 && messages.value[messages.value.length - 1].role === 'assistant') {
    messages.value.pop()
  }
  doSend(userMessage)
}

// 从商品详情页跳转来时，预填商品咨询内容
const pendingProductQuery = ref(route.query.productName || '')

watch(currentSessionId, (newVal) => {
  if (newVal && pendingProductQuery.value) {
    nextTick(() => {
      if (messageInputRef.value) {
        messageInputRef.value.setInput(`我想了解一下「${pendingProductQuery.value}」这个商品，请介绍一下它的详细信息。`)
        pendingProductQuery.value = ''
      }
    })
  }
}, { immediate: true })
</script>

<style scoped>
.ai-chat-container {
  display: flex;
  height: calc(100vh - 84px);
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.08),
              0 1px 3px rgba(0, 0, 0, 0.04);
  overflow: hidden;
  border: 1px solid rgba(0, 0, 0, 0.06);
}

.chat-sidebar {
  width: 300px;
  background: linear-gradient(180deg, #eef1f5 0%, #f3f5f8 100%);
  border-right: 1px solid #e8eaee;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  transition: width 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  overflow: hidden;
}

.chat-sidebar.collapsed {
  width: 0;
  border-right: none;
}

.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
  position: relative;
  background-color: #f7f8fa;
}
.agent-processing-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  margin: 8px 16px 0;
  background: #f0f6ff;
  border: 1px solid #d6e4ff;
  border-radius: 8px;
  color: #409eff;
  font-size: 13px;
}
.agent-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #409eff;
  animation: agentPulse 1s ease-in-out infinite;
}
@keyframes agentPulse {
  0%, 100% { opacity: 0.3; transform: scale(0.9); }
  50% { opacity: 1; transform: scale(1.1); }
}


.sidebar-expand-btn {
  position: absolute;
  top: 12px;
  left: 12px;
  z-index: 20;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #ffffff;
  border: 1px solid #eef0f3;
  border-radius: 10px;
  cursor: pointer;
  color: #606266;
  font-size: 18px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  transition: all 0.2s;
}

.sidebar-expand-btn:hover {
  background: #f0f2f5;
  color: #409eff;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.no-session {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #a0a3ab;
  font-size: 15px;
}
</style>
