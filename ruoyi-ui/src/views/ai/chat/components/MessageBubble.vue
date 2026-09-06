<template>
  <div class="message-bubble" :class="[message.role]">
    <!-- 头像 -->
    <div class="avatar">
      <el-avatar v-if="message.role === 'user'" :size="32" :src="userStore.avatar" class="user-avatar">
        <el-icon><User /></el-icon>
      </el-avatar>
      <div v-else class="ai-avatar">
        <div class="ai-icon-bg">
          <img src="@/assets/logo/logo.png" alt="AI" class="ai-logo-img" />
        </div>
      </div>
    </div>

    <!-- 消息内容区 -->
    <div class="bubble-content-wrapper">
      <div class="bubble-info" v-if="message.role === 'assistant'">
        <span class="name">AI 智能助手</span>
        <span class="time">{{ formatTime(message.createTime) }}</span>
      </div>

      <div class="bubble-container">
        <!-- 用户消息: 纯文本 -->
        <div v-if="message.role === 'user'" class="bubble-text user-text">{{ message.content }}</div>

        <!-- AI 消息: Markdown -->
        <div v-else class="bubble-text ai-text">
           <!-- 可折叠工具调用状态栏 -->
           <div v-if="showStatusBar" class="tool-call-status-bar" :class="{ expanded: toolBarExpanded, done: allToolCallsDone }">
             <div class="status-bar-header" @click="hasToolCalls && (toolBarExpanded = !toolBarExpanded)">
               <div class="status-bar-left">
                 <el-icon v-if="!allToolCallsDone" class="status-icon is-loading"><Loading /></el-icon>
                 <el-icon v-else class="status-icon done-icon"><Check /></el-icon>
                 <span class="status-text">{{ toolCallSummary }}</span>
               </div>
               <el-icon v-if="hasToolCalls" class="expand-toggle">
                 <ArrowUp v-if="toolBarExpanded" />
                 <ArrowDown v-else />
               </el-icon>
             </div>

             <div v-if="toolBarExpanded && hasToolCalls" class="status-bar-detail">
               <div v-for="(hint, idx) in message.toolCallHints" :key="idx" class="tool-step">
                 <span class="step-connector">
                   {{ idx === message.toolCallHints.length - 1 ? '└─' : '├─' }}
                 </span>
                 <el-icon v-if="hint.done" class="step-icon done-icon"><Check /></el-icon>
                 <el-icon v-else class="step-icon is-loading"><Loading /></el-icon>
                 <span class="step-text">{{ hint.content }}</span>
               </div>
             </div>
           </div>

           <div v-html="renderedContent" class="markdown-body"></div>

           <!-- AI交互卡片（同类型合并为单行滚动） -->
           <ProductCard v-if="mergedProductItems.length > 0" :items="mergedProductItems" />
           <OrderCard v-if="mergedOrderItems.length > 0" :items="mergedOrderItems" />

           <!-- RAG 参考来源（可折叠，放在卡片之后） -->
           <div v-if="message.ragSources && message.ragSources.length > 0" class="rag-sources">
             <div class="rag-sources-header" @click="ragExpanded = !ragExpanded">
               <div class="rag-sources-left">
                 <el-icon><Document /></el-icon>
                 <span>参考来源 ({{ message.ragSources.length }})</span>
               </div>
               <el-icon class="expand-toggle">
                 <ArrowUp v-if="ragExpanded" />
                 <ArrowDown v-else />
               </el-icon>
             </div>
             <div v-if="ragExpanded" class="rag-sources-list">
               <div v-for="(src, idx) in message.ragSources" :key="idx" class="rag-source-item">
                 <el-tag size="small" :type="ragCategoryType(src.category)">{{ ragCategoryLabel(src.category) }}</el-tag>
                 <span class="rag-source-title">{{ src.title }}</span>
               </div>
             </div>
           </div>
        </div>
      </div>

      <!-- AI 底部操作栏 -->
      <div v-if="message.role === 'assistant' && !loading" class="bubble-actions">
        <div class="action-btn copy-btn" @click="handleCopy(message.content)">
          <el-icon><CopyDocument /></el-icon>
          <span>复制</span>
        </div>
        <div class="divider"></div>
        <div class="action-btn regenerate-btn" @click="handleRegenerate">
          <el-icon><RefreshRight /></el-icon>
          <span>重新生成</span>
        </div>
        <div class="divider"></div>
        <div class="feedback-group">
          <el-tooltip content="有帮助" placement="bottom" :show-after="500">
            <div class="action-btn feedback-btn" :class="{ active: message.feedback === 1 }" @click="handleFeedback(1)">
              <span>赞</span><span class="feedback-emoji">👍</span>
            </div>
          </el-tooltip>
          <el-tooltip content="没帮助" placement="bottom" :show-after="500">
            <div class="action-btn feedback-btn" :class="{ active: message.feedback === 0 }" @click="handleFeedback(0)">
              <span>踩</span><span class="feedback-emoji">👎</span>
            </div>
          </el-tooltip>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { User, Service, Loading, CopyDocument, Check, ArrowDown, ArrowUp, RefreshRight, Document } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { feedbackMessage } from '@/api/ai/chat'
import useUserStore from '@/store/modules/user'
import MarkdownIt from 'markdown-it'
import DOMPurify from 'dompurify'
import ProductCard from './ProductCard.vue'
import OrderCard from './OrderCard.vue'

const props = defineProps({
  message: { type: Object, required: true },
  loading: { type: Boolean, default: false }
})

const emit = defineEmits(['feedbackUpdated', 'regenerate'])
const userStore = useUserStore()

// ====== 工具调用状态栏 ======
const toolBarExpanded = ref(false)
const ragExpanded = ref(false)
const feedbackLoading = ref(false)

const hasToolCalls = computed(() =>
  props.message.toolCallHints && props.message.toolCallHints.length > 0
)

const allToolCallsDone = computed(() =>
  hasToolCalls.value && props.message.toolCallHints.every(h => h.done)
)

const latestToolHint = computed(() => {
  if (!hasToolCalls.value) return null
  return props.message.toolCallHints[props.message.toolCallHints.length - 1]
})

const isThinking = computed(() =>
  props.loading &&
  props.message.role === 'assistant' &&
  !props.message.content &&
  !hasToolCalls.value
)

const showStatusBar = computed(() => isThinking.value || hasToolCalls.value)

const toolCallSummary = computed(() => {
  if (!hasToolCalls.value) return 'AI 正在思考...'
  if (allToolCallsDone.value) {
    return `已完成 ${props.message.toolCallHints.length} 个工具调用`
  }
  return latestToolHint.value?.content || '正在调用工具...'
})

// ====== 合并同类型卡片为单一数组（避免多行） ======
const mergedProductItems = computed(() => {
  if (!props.message.cards || props.message.cards.length === 0) return []
  return props.message.cards
    .filter(card => card.cardType === 'product')
    .flatMap(card => card.items || [])
})

const mergedOrderItems = computed(() => {
  if (!props.message.cards || props.message.cards.length === 0) return []
  return props.message.cards
    .filter(card => card.cardType === 'order')
    .flatMap(card => card.items || [])
})

const md = new MarkdownIt({
  html: false,
  breaks: true,
  linkify: true
})

const renderedContent = computed(() => {
  if (props.message.role === 'user') return ''

  let html = md.render(props.message.content || '')

  // 安全清洗
  html = DOMPurify.sanitize(html, {
    ALLOWED_TAGS: ['p', 'br', 'strong', 'em', 'a', 'ul', 'ol', 'li', 'code', 'pre',
                   'table', 'thead', 'tbody', 'tr', 'th', 'td', 'h1', 'h2', 'h3',
                   'h4', 'h5', 'h6', 'blockquote', 'span', 'div', 'img', 'hr'],
    ALLOWED_ATTR: ['href', 'target', 'class', 'src', 'alt', 'width', 'height']
  })

  // 优化表格显示
  if (html.includes('<table>')) {
    html = html.replace(/<table>/g, '<div class="table-wrapper"><table>')
    html = html.replace(/<\/table>/g, '</table></div>')
  }

  return html
})

function formatTime(time) {
  if (!time) return ''
  const d = new Date(time)
  const now = new Date()
  // 如果是今天的消息，只显示时间
  if (d.toDateString() === now.toDateString()) {
    return `${d.getHours().toString().padStart(2, '0')}:${d.getMinutes().toString().padStart(2, '0')}`
  }
  return `${d.getMonth() + 1}/${d.getDate()} ${d.getHours().toString().padStart(2, '0')}:${d.getMinutes().toString().padStart(2, '0')}`
}

async function handleFeedback(value) {
  if (!props.message.messageId) return
  if (feedbackLoading.value) return // 防止连续点击

  // 相同值再次点击 → 取消反馈
  const newValue = props.message.feedback === value ? null : value

  feedbackLoading.value = true
  try {
    await feedbackMessage(props.message.messageId, newValue)
    props.message.feedback = newValue
    emit('feedbackUpdated', props.message.messageId, newValue)
    ElMessage.success(newValue === null ? '已取消反馈' : '感谢您的反馈')
  } catch (e) {
    ElMessage.error('反馈提交失败，请重试')
  } finally {
    feedbackLoading.value = false
  }
}

function handleCopy(text) {
  navigator.clipboard.writeText(text).then(() => {
    ElMessage.success('已复制到剪贴板')
  }).catch(() => {
    ElMessage.error('复制失败')
  })
}

function handleRegenerate() {
  emit('regenerate')
}

function ragCategoryType(category) {
  const map = { POLICY: 'warning', PRODUCT_INFO: 'success', GUIDE: 'info' }
  return map[category] || ''
}

function ragCategoryLabel(category) {
  const map = { POLICY: '政策规则', PRODUCT_INFO: '商品信息', GUIDE: '使用指南', FAQ: '常见问题' }
  return map[category] || category || '其他'
}
</script>

<style scoped>
.message-bubble {
  display: flex;
  gap: 12px;
  margin-bottom: 28px;
  padding: 0 20px;
  animation: msgSlideIn 0.35s ease-out;
  width: 100%;
  box-sizing: border-box;
}

@keyframes msgSlideIn {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}

/* ====== 头像区域 ====== */
.avatar {
  flex-shrink: 0;
  margin-top: 4px;
}

.user-avatar {
  border: 2px solid #fff;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s;
}
.user-avatar:hover { transform: scale(1.05); }

.ai-avatar {
  width: 36px;
  height: 36px;
}

.ai-icon-bg {
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #667eea, #409eff);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 20px;
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.35);
  transition: transform 0.2s;
}
.ai-icon-bg:hover { transform: scale(1.05); }

.ai-logo-img {
  width: 24px;
  height: 24px;
  object-fit: contain;
}

/* ====== 内容包裹区 ====== */
.bubble-content-wrapper {
  flex: 1;
  max-width: calc(100% - 48px);
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

/* 用户消息右对齐 */
.message-bubble.user {
  flex-direction: row-reverse;
}

.message-bubble.user .bubble-content-wrapper {
  align-items: flex-end;
}

/* 信息头（仅AI显示） */
.bubble-info {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  padding-left: 4px;
}

.bubble-info .name {
  font-size: 13px;
  font-weight: 600;
  color: #1a1c21;
}

.bubble-info .time {
  font-size: 12px;
  color: #b0b3ba;
}

/* ====== 气泡样式 ====== */
.bubble-text {
  position: relative;
  font-size: 14.5px;
  line-height: 1.7;
  word-break: break-word;
  max-width: 100%;
}

/* 用户气泡 - 浅绿色 */
.user-text {
  background: #d4f5e2;
  color: #1a1c21;
  padding: 12px 18px;
  border-radius: 18px 4px 18px 18px;
  box-shadow: 0 2px 8px rgba(76, 175, 80, 0.15);
}

/* AI气泡 */
.ai-text {
  background: #ffffff;
  color: #303133;
  padding: 18px 20px;
  border-radius: 4px 18px 18px 18px;
  border: 1px solid #eef0f3;
  width: 100%;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  transition: box-shadow 0.3s;
  overflow-x: hidden;
  box-sizing: border-box;
}
.ai-text:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
}

/* ====== Markdown 样式 ====== */
.markdown-body :deep(p) {
  margin-bottom: 10px;
}

.markdown-body :deep(p:last-child) {
  margin-bottom: 0;
}

.markdown-body :deep(strong) {
  font-weight: 600;
  color: #1a1a1a;
}

.markdown-body :deep(ul), .markdown-body :deep(ol) {
  padding-left: 20px;
  margin-bottom: 10px;
}

.markdown-body :deep(li) {
  margin-bottom: 4px;
}

.markdown-body :deep(h1), .markdown-body :deep(h2), .markdown-body :deep(h3) {
  margin: 16px 0 8px;
  font-weight: 600;
  line-height: 1.4;
  color: #1a1a1a;
}

.markdown-body :deep(h1) { font-size: 1.4em; }
.markdown-body :deep(h2) { font-size: 1.25em; }
.markdown-body :deep(h3) { font-size: 1.1em; }

/* 代码块 */
.markdown-body :deep(pre) {
  background: #282c34;
  color: #abb2bf;
  padding: 12px 16px;
  border-radius: 8px;
  overflow-x: auto;
  margin: 12px 0;
  font-family: 'Fira Code', Consolas, Monaco, monospace;
  font-size: 13px;
  line-height: 1.5;
}

.markdown-body :deep(code) {
  background: rgba(175, 184, 193, 0.2);
  padding: 2px 6px;
  border-radius: 4px;
  font-family: Consolas, monospace;
  font-size: 0.9em;
  color: #eb5757;
}

.markdown-body :deep(pre code) {
  background: transparent;
  padding: 0;
  color: inherit;
}

/* 引用 */
.markdown-body :deep(blockquote) {
  margin: 10px 0;
  padding: 0 12px;
  color: #606266;
  border-left: 4px solid #dfe2e5;
  background-color: #f9fafc;
  padding-top: 8px;
  padding-bottom: 8px;
}

/* 表格 */
.markdown-body :deep(.table-wrapper) {
  overflow-x: auto;
  margin: 12px 0;
  border-radius: 8px;
  border: 1px solid #ebeef5;
}

.markdown-body :deep(table) {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.markdown-body :deep(th) {
  background-color: #f5f7fa;
  font-weight: 600;
  text-align: left;
  padding: 8px 12px;
  border-bottom: 1px solid #ebeef5;
}

.markdown-body :deep(td) {
  padding: 8px 12px;
  border-bottom: 1px solid #ebeef5;
}

.markdown-body :deep(tr:last-child td) {
  border-bottom: none;
}

/* ====== 底部操作栏 ====== */
.bubble-actions {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-top: 8px;
  padding-left: 4px;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  cursor: pointer;
  color: #8c8f97;
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 6px;
  transition: all 0.2s;
}

.action-btn:hover {
  background-color: #eef0f3;
  color: #4a4d55;
}

.copy-btn {
  background-color: #f5f6f8;
  color: #606266;
  font-weight: 500;
}

.copy-btn:hover {
  background-color: #e8eaee;
  color: #303133;
}

.action-btn.active {
  color: #409eff;
  background-color: #ecf5ff;
  border: 1px solid #b3d8ff;
}

.action-btn.active:hover {
  background-color: #d9ecff;
}

.feedback-btn {
  padding: 4px 10px;
  gap: 3px;
}

.feedback-emoji {
  font-size: 15px;
  line-height: 1;
}

.divider {
  width: 1px;
  height: 14px;
  background-color: #dcdfe6;
  margin: 0 2px;
}

.feedback-group {
  display: flex;
  gap: 4px;
}

/* ====== 可折叠工具调用状态栏 ====== */
.tool-call-status-bar {
  background: #f5f7fa;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  margin-bottom: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
}

.status-bar-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  cursor: pointer;
  user-select: none;
  transition: background 0.2s;
}

.status-bar-header:hover {
  background: #eef0f3;
}

.status-bar-left {
  display: flex;
  align-items: center;
  gap: 8px;
}

.status-icon {
  font-size: 14px;
  color: #409eff;
}

.status-icon.done-icon {
  color: #67c23a;
}

.status-text {
  font-size: 13px;
  color: #606266;
}

.tool-call-status-bar.done .status-text {
  color: #67c23a;
}

.expand-toggle {
  font-size: 12px;
  color: #909399;
  transition: transform 0.2s;
}

.status-bar-detail {
  padding: 4px 12px 8px 20px;
  border-top: 1px solid #ebeef5;
}

.tool-step {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 4px 0;
  font-size: 12px;
  color: #909399;
}

.step-connector {
  color: #dcdfe6;
  font-family: monospace;
  width: 24px;
  flex-shrink: 0;
}

.step-icon {
  font-size: 12px;
  flex-shrink: 0;
}

.step-icon.done-icon {
  color: #67c23a;
}

.step-text {
  color: #606266;
}

/* 思考中状态的脉冲效果 */
.tool-call-status-bar:not(.done) .status-text {
  animation: thinkingPulse 1.5s ease-in-out infinite;
}

@keyframes thinkingPulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

/* ====== RAG 参考来源 ====== */
.rag-sources {
  margin-top: 12px;
  background: #f9fafc;
  border: 1px solid #eef0f3;
  border-radius: 8px;
  overflow: hidden;
}

.rag-sources-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  cursor: pointer;
  user-select: none;
  transition: background 0.2s;
}

.rag-sources-header:hover {
  background: #f0f2f5;
}

.rag-sources-left {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #909399;
}

.rag-sources-list {
  padding: 4px 12px 8px;
  border-top: 1px solid #eef0f3;
}

.rag-source-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 4px 0;
  font-size: 12px;
}

.rag-source-title {
  color: #606266;
}

/* ====== 重新生成按钮 ====== */
.regenerate-btn {
  color: #909399;
}

.regenerate-btn:hover {
  color: #e6a23c;
  background-color: #fdf6ec;
}
</style>
