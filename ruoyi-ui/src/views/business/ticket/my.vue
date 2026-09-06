<template>
  <div class="app-container">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-form :inline="true" :model="queryParams" class="search-form-left">
        <el-form-item label="关键字">
          <el-input v-model="titleKeyword" placeholder="搜索标题/工单号" clearable style="width: 170px"
                    @keyup.enter="handleSearch">
            <template #prefix><el-icon><Search /></el-icon></template>
          </el-input>
        </el-form-item>
        <el-form-item label="类型">
          <el-select v-model="queryParams.type" placeholder="全部类型" clearable style="width: 120px" @change="handleSearch">
            <el-option v-for="(val, key) in ticketTypeMap" :key="key" :label="val.label" :value="key" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryParams.status" placeholder="全部状态" clearable style="width: 120px" @change="handleSearch">
            <el-option v-for="(val, key) in ticketStatusMap" :key="key" :label="val.label" :value="key" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
      <el-button type="danger" class="complaint-btn" :icon="WarningFilled" @click="handleComplaint">提交投诉</el-button>
    </div>

    <!-- 状态统计 Tab 栏 -->
    <div class="ticket-stats-bar">
      <div v-for="tab in statusTabs" :key="tab.key"
           class="stats-tab" :class="{ active: activeStatusTab === tab.key }"
           @click="switchStatusTab(tab.key)">
        <span class="stats-tab-count">{{ tab.count }}</span>
        <span class="stats-tab-label">{{ tab.label }}</span>
        <span v-if="tab.key === 'OPEN' && tab.count > 0" class="stats-tab-dot" />
      </div>
    </div>

    <!-- 手风琴工单列表 -->
    <div v-loading="loading" class="ticket-list">
      <!-- 空状态 -->
      <div v-if="filteredData.length === 0 && !loading" class="empty-state">
        <el-empty description="暂无工单">
          <el-button type="primary" @click="handleComplaint">提交投诉</el-button>
        </el-empty>
      </div>

      <!-- 工单条目 -->
      <div v-for="(ticket, index) in filteredData" :key="ticket.ticketId"
           :id="'ticket-' + ticket.ticketId"
           class="ticket-item" :class="['status-' + (ticket.status || '').toLowerCase(), { expanded: expandedTicketId === ticket.ticketId, 'highlight-target': highlightTicketId == ticket.ticketId }]"
           :style="{ animationDelay: index * 0.05 + 's' }">

        <!-- 摘要条（可点击） -->
        <div class="ticket-summary" @click="toggleExpand(ticket)">
          <!-- 第一行：类型图标 + 标题 + 优先级 + 状态 + 箭头 -->
          <div class="summary-row1">
            <el-icon class="type-icon" :style="{ color: ticketTypeIcons[ticket.type]?.color || '#909399' }">
              <component :is="ticketTypeIcons[ticket.type]?.icon || ChatDotRound" />
            </el-icon>
            <span class="ticket-title">{{ ticket.title }}</span>
            <el-tag class="status-tag" :type="ticketStatusMap[ticket.status]?.type || 'info'" effect="light" round>
              {{ ticketStatusMap[ticket.status]?.label || ticket.status }}
            </el-tag>
            <el-icon class="expand-arrow" :class="{ rotated: expandedTicketId === ticket.ticketId }">
              <ArrowDown />
            </el-icon>
          </div>
          <!-- 第二行：工单号 + 时间 + 描述预览 -->
          <div class="summary-row2">
            <span class="ticket-no">{{ ticket.ticketNo }}</span>
            <span class="ticket-time">{{ formatDate(ticket.createTime) }}</span>
            <span v-if="ticket.description" class="ticket-desc-preview">
              {{ ticket.description.length > 40 ? ticket.description.substring(0, 40) + '...' : ticket.description }}
            </span>
          </div>
        </div>

        <!-- 展开区（手风琴内容） -->
        <div class="ticket-expand" :class="{ open: expandedTicketId === ticket.ticketId }">
          <div class="expand-inner">
            <!-- 描述 -->
            <div v-if="currentTicket.description" class="detail-section">
              <div class="detail-label">问题描述</div>
              <div class="detail-text">{{ currentTicket.description }}</div>
            </div>

            <!-- 退款信息 -->
            <div v-if="currentTicket.type === 'REFUND' || currentTicket.type === 'EXCHANGE'" class="detail-section refund-box">
              <div class="refund-info-row">
                <span>退款金额：<b class="refund-val">&yen;{{ formatMoney(currentTicket.refundAmount) }}</b></span>
                <span>退款原因：{{ currentTicket.refundReason || '-' }}</span>
              </div>
              <div class="refund-steps">
                <el-steps :active="refundStepActive" finish-status="success" align-center size="small">
                  <el-step title="提交申请" />
                  <el-step title="审核中" />
                  <el-step :title="currentTicket.refundStatus === 'REJECTED' ? '已拒绝' : (currentTicket.type === 'EXCHANGE' ? '已同意，待退货' : '已同意')"
                           :status="currentTicket.refundStatus === 'REJECTED' ? 'error' : undefined" />
                  <el-step :title="currentTicket.type === 'EXCHANGE' ? '确认收货，退款完成' : '退款完成'" />
                </el-steps>
              </div>
            </div>

            <!-- 聊天沟通区 -->
            <div class="detail-section">
              <div class="detail-label">沟通记录</div>
              <div ref="chatContainerRef" class="chat-container">
                <div v-if="ticketReplies.length === 0" class="chat-empty">
                  <el-icon :size="28" style="color: #dcdfe6"><ChatDotRound /></el-icon>
                  <span>暂无沟通记录</span>
                </div>
                <div v-for="reply in ticketReplies" :key="reply.replyId"
                     class="chat-message" :class="reply.replyType === 'USER' ? 'is-self' : 'is-staff'">
                  <div v-if="reply.replyType !== 'USER'" class="chat-avatar staff-avatar">
                    <el-icon :size="14"><Service /></el-icon>
                  </div>
                  <div class="chat-bubble">
                    <div class="chat-bubble-name">
                      {{ reply.replyType === 'USER' ? '我' : (reply.replyType === 'SYSTEM' ? '系统' : '客服') }}
                    </div>
                    <div class="chat-bubble-content">{{ reply.content }}</div>
                    <div class="chat-bubble-time">{{ formatDate(reply.createTime) }}</div>
                  </div>
                  <div v-if="reply.replyType === 'USER'" class="chat-avatar user-avatar">
                    <el-icon :size="14"><User /></el-icon>
                  </div>
                </div>
              </div>
              <!-- 回复输入 -->
              <div v-if="currentTicket.status !== 'CLOSED'" class="chat-input-bar">
                <el-input v-model="replyContent" type="textarea" :rows="2"
                          placeholder="输入回复内容... (Ctrl+Enter 发送)" resize="none"
                          @keydown.ctrl.enter="submitReply" />
                <el-button type="primary" :loading="replyLoading" @click="submitReply">发送</el-button>
              </div>
              <div v-else class="chat-closed-tip">工单已关闭，无法继续回复</div>
            </div>

            <!-- 操作栏 -->
            <div class="expand-actions">
              <el-button v-if="currentTicket.status !== 'CLOSED'" type="warning" plain @click.stop="handleClose(ticket)">关闭工单</el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 分页 -->
    <el-pagination v-if="total > 0"
      v-model:current-page="queryParams.pageNum" v-model:page-size="queryParams.pageSize"
      :page-sizes="[10, 20, 50]" :total="total"
      layout="total, sizes, prev, pager, next, jumper" class="pagination-bar"
      @size-change="loadData" @current-change="loadData" />

    <!-- 创建工单弹窗 -->
    <el-dialog v-model="createDialogVisible" :title="ticketCreateMode === 'complaint' ? '提交投诉' : '申请售后'" width="600px" destroy-on-close>
      <el-form ref="createFormRef" :model="createForm" :rules="createRules" label-width="80px">
        <el-form-item label="类型" prop="type">
          <div class="type-card-grid">
            <div v-for="(config, key) in ticketTypeIcons" :key="key"
                 v-show="visibleTypes.includes(key)"
                 class="type-card" :class="{ active: createForm.type === key }"
                 @click="createForm.type = key">
              <el-icon :size="24" :color="config.color"><component :is="config.icon" /></el-icon>
              <span class="type-card-label">{{ ticketTypeMap[key].label }}</span>
              <span class="type-card-desc">{{ config.desc }}</span>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="标题" prop="title">
          <el-input v-model="createForm.title" placeholder="请输入工单标题" />
        </el-form-item>
        <el-form-item v-if="ticketCreateMode === 'after-sale'" label="关联订单">
          <el-select v-model="createForm.orderId" placeholder="选择关联订单（可选）" clearable filterable style="width: 100%" @change="onOrderChange">
            <el-option v-for="o in userOrders" :key="o.orderId" :label="o.orderNo" :value="o.orderId">
              <div class="order-option-item">
                <img v-if="o.items && o.items[0]?.imageUrl" :src="o.items[0].imageUrl" class="order-opt-img" />
                <div v-else class="order-opt-img order-opt-img-placeholder"><el-icon><Box /></el-icon></div>
                <div class="order-opt-info">
                  <div class="order-opt-name">{{ getOrderSummary(o) }}</div>
                  <div class="order-opt-meta">{{ formatDate(o.createTime) }}</div>
                </div>
                <div class="order-opt-amount">&yen;{{ formatMoney(o.totalAmount) }}</div>
              </div>
            </el-option>
          </el-select>
        </el-form-item>
        <template v-if="createForm.type === 'REFUND' || createForm.type === 'EXCHANGE'">
          <el-form-item label="退款金额" prop="refundAmount">
            <el-input-number v-model="createForm.refundAmount" :min="0.01" :max="selectedOrderAmount ? Number(selectedOrderAmount) : undefined" :precision="2" :controls="false" placeholder="退款金额" style="width: 200px" />
            <span v-if="selectedOrderAmount" class="order-amount-hint">最多可退：&yen;{{ selectedOrderAmount }}</span>
          </el-form-item>
          <el-form-item label="退款原因" prop="refundReason">
            <el-select v-model="createForm.refundReason" placeholder="请选择退款原因" style="width: 100%">
              <el-option label="商品质量问题" value="商品质量问题" />
              <el-option label="发错/漏发商品" value="发错/漏发商品" />
              <el-option label="商品与描述不符" value="商品与描述不符" />
              <el-option label="不想要了/多拍了" value="不想要了/多拍了" />
              <el-option label="其他原因" value="其他原因" />
            </el-select>
          </el-form-item>
        </template>
        <el-form-item label="描述" prop="description">
          <el-input v-model="createForm.description" type="textarea" :rows="5" placeholder="请详细描述您的问题" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="createDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="createLoading" @click="submitCreate">提交</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Service, User, WarningFilled, RefreshLeft, Switch, ChatDotRound, ArrowDown, Box } from '@element-plus/icons-vue'
import { myTickets, myTicketDetail, myTicketReplies, addTicketReply, closeTicket, myTicketStats } from '@/api/business/ticket'
import { myOrders, myOrderDetail } from '@/api/business/order'
import { formatDate, formatMoney, ticketTypeMap, ticketStatusMap } from '@/utils/format'
import request from '@/utils/request'

const route = useRoute()

// 基础状态
const loading = ref(false)
const replyLoading = ref(false)
const createLoading = ref(false)
const tableData = ref([])
const total = ref(0)
const createDialogVisible = ref(false)
const currentTicket = ref({})
const ticketReplies = ref([])
const replyContent = ref('')
const createFormRef = ref(null)
const userOrders = ref([])
const chatContainerRef = ref(null)

// 手风琴状态
const expandedTicketId = ref(null)
const highlightTicketId = ref(null)

// 查询参数
const queryParams = reactive({ type: '', status: '', pageNum: 1, pageSize: 10 })
const titleKeyword = ref('')

// 统计
const ticketStats = ref({})
const activeStatusTab = ref('')

// 创建模式：'after-sale'（从订单页进入，显示REFUND/EXCHANGE）| 'complaint'（独立投诉，仅显示COMPLAINT）
const ticketCreateMode = ref('after-sale')
const visibleTypes = computed(() =>
  ticketCreateMode.value === 'complaint' ? ['COMPLAINT'] : ['REFUND', 'EXCHANGE']
)

// 创建表单
const createForm = reactive({ type: '', title: '', description: '', orderId: null, refundAmount: null, refundReason: '' })
const createRules = {
  type: [{ required: true, message: '请选择工单类型', trigger: 'change' }],
  title: [{ required: true, message: '请输入工单标题', trigger: 'blur' }],
  description: [{ required: true, message: '请描述您的问题', trigger: 'blur' }],
  refundAmount: [
    { required: true, message: '请输入退款金额', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value && selectedOrderAmount.value && value > Number(selectedOrderAmount.value)) {
          callback(new Error(`退款金额不能超过订单金额 ¥${selectedOrderAmount.value}`))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ],
  refundReason: [{ required: true, message: '请选择退款原因', trigger: 'change' }]
}
const selectedOrderAmount = ref('')

// 类型图标配置
const ticketTypeIcons = {
  COMPLAINT: { icon: WarningFilled, color: '#f56c6c', desc: '对商品或服务不满意' },
  REFUND: { icon: RefreshLeft, color: '#e6a23c', desc: '申请订单退款' },
  EXCHANGE: { icon: Switch, color: '#409eff', desc: '退货并申请退款' },
  CONSULT: { icon: ChatDotRound, color: '#67c23a', desc: '咨询产品或服务问题' }
}

// 计算属性：状态Tab栏
const statusTabs = computed(() => [
  { key: '', label: '全部', count: ticketStats.value.totalCount || 0 },
  { key: 'OPEN', label: '待处理', count: ticketStats.value.openCount || 0 },
  { key: 'PROCESSING', label: '处理中', count: ticketStats.value.processingCount || 0 },
  { key: 'RESOLVED', label: '已解决', count: ticketStats.value.resolvedCount || 0 },
  { key: 'CLOSED', label: '已关闭', count: ticketStats.value.closedCount || 0 }
])

// 计算属性：客户端标题过滤
const filteredData = computed(() => {
  if (!titleKeyword.value.trim()) return tableData.value
  const kw = titleKeyword.value.trim().toLowerCase()
  return tableData.value.filter(t =>
    (t.title && t.title.toLowerCase().includes(kw)) ||
    (t.ticketNo && t.ticketNo.toLowerCase().includes(kw))
  )
})

// 退款进度
const refundStepActive = computed(() => {
  const s = currentTicket.value.refundStatus
  if (s === 'PENDING_REVIEW') return 1
  if (s === 'APPROVED') return 2
  if (s === 'REJECTED') return 2
  if (s === 'REFUNDED') return 4
  return 0
})

// 数据加载
const loadStats = async () => {
  try {
    const res = await myTicketStats()
    ticketStats.value = res.data || {}
  } catch { /* ignore */ }
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await myTickets(queryParams)
    tableData.value = res.rows || []
    total.value = res.total || 0
    expandedTicketId.value = null
  } finally { loading.value = false }
}

const handleSearch = () => { queryParams.pageNum = 1; loadData() }

const resetQuery = () => {
  queryParams.type = ''
  queryParams.status = ''
  titleKeyword.value = ''
  activeStatusTab.value = ''
  queryParams.pageNum = 1
  loadData()
}

const switchStatusTab = (key) => {
  activeStatusTab.value = key
  queryParams.status = key
  queryParams.pageNum = 1
  loadData()
}

// 手风琴展开/收起
const toggleExpand = async (ticket) => {
  if (expandedTicketId.value === ticket.ticketId) {
    expandedTicketId.value = null
    return
  }
  expandedTicketId.value = ticket.ticketId
  replyContent.value = ''
  // 懒加载详情和回复
  try {
    const res = await myTicketDetail(ticket.ticketId)
    currentTicket.value = res.data || ticket
  } catch {
    currentTicket.value = ticket
  }
  try {
    const res = await myTicketReplies(ticket.ticketId)
    ticketReplies.value = res.data || []
  } catch {
    ticketReplies.value = []
  }
  scrollChatToBottom()
}

// 聊天滚动
const scrollChatToBottom = () => {
  nextTick(() => {
    if (chatContainerRef.value) {
      chatContainerRef.value.scrollTop = chatContainerRef.value.scrollHeight
    }
  })
}

// 发送回复
const submitReply = async () => {
  if (!replyContent.value.trim()) { ElMessage.warning('请输入回复内容'); return }
  replyLoading.value = true
  try {
    await addTicketReply(currentTicket.value.ticketId, { content: replyContent.value, replyType: 'USER' })
    replyContent.value = ''
    const [detailRes, repliesRes] = await Promise.all([
      myTicketDetail(currentTicket.value.ticketId),
      myTicketReplies(currentTicket.value.ticketId)
    ])
    currentTicket.value = detailRes.data || currentTicket.value
    ticketReplies.value = repliesRes.data || []
    ElMessage.success('回复成功')
    scrollChatToBottom()
    loadStats()
  } finally { replyLoading.value = false }
}

// 关闭工单
const handleClose = (row) => {
  ElMessageBox.confirm('确认关闭该工单？关闭后将无法继续回复。', '关闭工单', { type: 'warning' })
    .then(async () => {
      await closeTicket(row.ticketId)
      ElMessage.success('工单已关闭')
      expandedTicketId.value = null
      loadData()
      loadStats()
    })
    .catch(() => {})
}

// 订单摘要：商品名 + 件数
const getOrderSummary = (order) => {
  if (!order.items || order.items.length === 0) return order.orderNo
  const first = order.items[0].productName
  return order.items.length > 1 ? `${first} 等${order.items.length}件商品` : first
}

// 订单金额联动 + 自动填充标题
const onOrderChange = (orderId) => {
  if (orderId && (createForm.type === 'REFUND' || createForm.type === 'EXCHANGE')) {
    const order = userOrders.value.find(o => o.orderId === orderId)
    if (order) {
      createForm.refundAmount = Number(order.totalAmount)
      selectedOrderAmount.value = Number(order.totalAmount).toFixed(2)
      // 自动生成标题（用户可手动修改）
      const summary = getOrderSummary(order)
      const suffix = createForm.type === 'EXCHANGE' ? '退货退款申请' : '退款申请'
      if (!createForm.title || createForm.title.endsWith('退款申请') || createForm.title.endsWith('退货退款申请')) {
        createForm.title = `${summary} - ${suffix}`
      }
    }
  } else {
    selectedOrderAmount.value = ''
  }
}

// 从订单页进入创建（after-sale 模式）
const handleCreate = async (preType = '') => {
  ticketCreateMode.value = 'after-sale'
  createForm.type = preType || 'REFUND'
  createForm.title = ''; createForm.description = ''; createForm.orderId = null
  createForm.refundAmount = null; createForm.refundReason = ''
  selectedOrderAmount.value = ''
  createDialogVisible.value = true
  try {
    const res = await myOrders({ pageNum: 1, pageSize: 100 })
    const orders = res.rows || []
    // 异步补充 items 信息，用于富文本显示
    await Promise.allSettled(orders.map(async (o) => {
      try {
        const detail = await myOrderDetail(o.orderId)
        o.items = (detail.data?.items) || []
      } catch { o.items = [] }
    }))
    userOrders.value = orders
  } catch { userOrders.value = [] }
}

// 独立投诉入口（complaint 模式，仅 COMPLAINT 类型）
const handleComplaint = () => {
  ticketCreateMode.value = 'complaint'
  createForm.type = 'COMPLAINT'
  createForm.title = ''; createForm.description = ''; createForm.orderId = null
  createForm.refundAmount = null; createForm.refundReason = ''
  selectedOrderAmount.value = ''
  createDialogVisible.value = true
  userOrders.value = []
}

const submitCreate = async () => {
  if (!createFormRef.value) return
  await createFormRef.value.validate()
  createLoading.value = true
  try {
    await request({ url: '/business/ticket', method: 'post', data: createForm })
    ElMessage.success('工单提交成功')
    createDialogVisible.value = false
    loadData()
    loadStats()
  } finally { createLoading.value = false }
}

// 从通知跳转定位到具体工单
const locateTicket = async () => {
  const targetId = route.query.ticketId
  if (!targetId) return
  highlightTicketId.value = Number(targetId)
  await nextTick()
  const ticket = tableData.value.find(t => t.ticketId == targetId)
  if (ticket) {
    await toggleExpand(ticket)
    await nextTick()
  }
  const el = document.getElementById('ticket-' + targetId)
  if (el) {
    el.scrollIntoView({ behavior: 'smooth', block: 'center' })
  }
  setTimeout(() => { highlightTicketId.value = null }, 4000)
}

// 初始化
onMounted(async () => {
  await loadData()
  loadStats()
  if (route.query.action === 'create') {
    const preType = route.query.type || 'REFUND'
    await handleCreate(preType)
    if (route.query.orderId) {
      createForm.orderId = Number(route.query.orderId)
      onOrderChange(createForm.orderId)
    }
  } else if (route.query.ticketId) {
    locateTicket()
  }
})

// 已在工单页时再次从通知跳转，监听 query 变化
watch(() => route.query.ticketId, (newVal) => {
  if (newVal) locateTicket()
})
</script>

<style scoped>
/* ========== 基础容器 ========== */
.app-container {
  padding: 20px 24px 30px;
  max-width: 960px;
  margin: 0 auto;
}

/* ========== 搜索栏 ========== */
.search-bar {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 16px;
  gap: 12px;
}
.search-form-left {
  flex: 1;
}
.search-bar :deep(.el-form-item) {
  margin-bottom: 0;
  margin-right: 10px;
}

/* ========== 状态统计 Tab 栏 ========== */
.ticket-stats-bar {
  display: flex;
  gap: 4px;
  background: #f5f7fa;
  border: 1px solid #e4e7ed;
  border-radius: 10px;
  padding: 4px;
  margin-bottom: 20px;
}
.stats-tab {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10px 0 8px;
  cursor: pointer;
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  color: #909399;
  user-select: none;
  border-radius: 8px;
}
.stats-tab:hover {
  color: #409eff;
  background: rgba(64, 158, 255, 0.06);
}
.stats-tab.active {
  color: #409eff;
  background: #fff;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
}
.stats-tab-count {
  font-size: 22px;
  font-weight: 700;
  line-height: 1.2;
}
.stats-tab-label {
  font-size: 12px;
  margin-top: 2px;
}
.stats-tab-dot {
  position: absolute;
  top: 6px;
  right: calc(50% - 20px);
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #f56c6c;
  animation: pulse 2s infinite;
}

/* ========== 工单列表容器 ========== */
.ticket-list {
  min-height: 200px;
}

/* ========== 空状态 ========== */
.empty-state {
  padding: 60px 0;
}

/* ========== 工单条目 ========== */
.ticket-item {
  background: #fff;
  border-radius: 10px;
  margin-bottom: 12px;
  border: 1px solid #ebeef5;
  border-left: 4px solid #dcdfe6;
  overflow: hidden;
  transition: box-shadow 0.25s, border-color 0.25s;
  animation: fadeSlideUp 0.4s ease both;
}
.ticket-item:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
}
.ticket-item.expanded {
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.08);
  border-color: #d0d7de;
}

/* 状态左边框着色 */
.ticket-item.status-open { border-left-color: #f56c6c; }
.ticket-item.status-processing { border-left-color: #e6a23c; }
.ticket-item.status-resolved { border-left-color: #67c23a; }
.ticket-item.status-closed { border-left-color: #c0c4cc; }

/* ========== 摘要条 ========== */
.ticket-summary {
  padding: 14px 18px 12px;
  cursor: pointer;
  transition: background 0.2s;
}
.ticket-summary:hover {
  background: #fafbfc;
}

/* 第一行 */
.summary-row1 {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 6px;
}
.type-icon {
  font-size: 18px;
  flex-shrink: 0;
}
.ticket-title {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.status-tag {
  flex-shrink: 0;
  font-size: 13px !important;
  padding: 6px 16px !important;
  font-weight: 600;
  letter-spacing: 1px;
}
.expand-arrow {
  font-size: 14px;
  color: #c0c4cc;
  transition: transform 0.3s ease, color 0.2s;
  flex-shrink: 0;
}
.expand-arrow.rotated {
  transform: rotate(180deg);
  color: #409eff;
}

/* 第二行 */
.summary-row2 {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 12px;
  color: #909399;
  padding-left: 26px;
}
.ticket-no {
  font-family: 'Consolas', 'Monaco', monospace;
  color: #606266;
  flex-shrink: 0;
}
.ticket-time {
  flex-shrink: 0;
}
.ticket-desc-preview {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #b0b5bd;
}

/* ========== 展开区（手风琴核心动画 — CSS Grid 平滑过渡） ========== */
.ticket-expand {
  display: grid;
  grid-template-rows: 0fr;
  opacity: 0;
  transition: grid-template-rows 0.5s cubic-bezier(0.33, 1, 0.68, 1),
              opacity 0.4s ease;
}
.ticket-expand.open {
  grid-template-rows: 1fr;
  opacity: 1;
}
.expand-inner {
  overflow: hidden;
  min-height: 0;
  padding: 0 18px 16px;
  border-top: 1px dashed #ebeef5;
}

/* ========== 详情区块 ========== */
.detail-section {
  margin-top: 14px;
}
.detail-label {
  font-size: 13px;
  font-weight: 600;
  color: #606266;
  margin-bottom: 8px;
  padding-left: 8px;
  border-left: 3px solid #409eff;
}
.detail-text {
  font-size: 13px;
  color: #606266;
  line-height: 1.7;
  background: #f9fafb;
  padding: 10px 14px;
  border-radius: 6px;
}

/* ========== 退款信息 ========== */
.refund-box {
  background: #fffbf0;
  border: 1px solid #faecd8;
  border-radius: 8px;
  padding: 14px 16px;
}
.refund-info-row {
  display: flex;
  gap: 24px;
  font-size: 13px;
  color: #606266;
  margin-bottom: 12px;
}
.refund-val {
  color: #e6a23c;
  font-size: 16px;
}
.refund-steps {
  margin-top: 4px;
}

/* ========== 聊天沟通区 ========== */
.chat-container {
  max-height: 320px;
  overflow-y: auto;
  padding: 12px 8px;
  background: #f5f7fa;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.chat-container::-webkit-scrollbar {
  width: 4px;
}
.chat-container::-webkit-scrollbar-thumb {
  background: #dcdfe6;
  border-radius: 2px;
}
.chat-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 30px 0;
  color: #c0c4cc;
  font-size: 13px;
}

/* 聊天消息布局 */
.chat-message {
  display: flex;
  align-items: flex-start;
  gap: 8px;
}
.chat-message.is-self {
  justify-content: flex-end;
}

/* 头像 */
.chat-avatar {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.staff-avatar {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: #fff;
}
.user-avatar {
  background: linear-gradient(135deg, #409eff, #53a8ff);
  color: #fff;
}

/* 气泡 */
.chat-bubble {
  max-width: 65%;
  padding: 8px 12px;
  border-radius: 10px;
  position: relative;
}
.is-staff .chat-bubble {
  background: #fff;
  border: 1px solid #ebeef5;
  border-top-left-radius: 2px;
}
.is-self .chat-bubble {
  background: linear-gradient(135deg, #409eff, #53a8ff);
  color: #fff;
  border-top-right-radius: 2px;
}
.chat-bubble-name {
  font-size: 11px;
  margin-bottom: 3px;
  opacity: 0.7;
}
.is-self .chat-bubble-name {
  text-align: right;
}
.chat-bubble-content {
  font-size: 13px;
  line-height: 1.6;
  word-break: break-word;
}
.chat-bubble-time {
  font-size: 10px;
  margin-top: 4px;
  opacity: 0.5;
}
.is-self .chat-bubble-time {
  text-align: right;
}

/* 回复输入栏 */
.chat-input-bar {
  display: flex;
  gap: 10px;
  margin-top: 10px;
  align-items: flex-end;
}
.chat-input-bar .el-button {
  height: 54px;
}
.chat-closed-tip {
  text-align: center;
  color: #c0c4cc;
  font-size: 13px;
  padding: 12px 0 4px;
}

/* ========== 展开区操作栏 ========== */
.expand-actions {
  margin-top: 14px;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding-top: 12px;
  border-top: 1px solid #f0f0f0;
}
.expand-actions .el-button {
  font-size: 14px;
  padding: 10px 24px;
  font-weight: 500;
  border-radius: 8px;
}

/* ========== 分页 ========== */
.pagination-bar {
  margin-top: 20px;
  justify-content: center;
}

/* ========== 创建工单弹窗 — 类型卡片 ========== */
.type-card-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
}
.type-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  padding: 16px 8px;
  border: 2px solid #ebeef5;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.25s;
  text-align: center;
}
.type-card:hover {
  border-color: #c6e2ff;
  background: #f0f7ff;
}
.type-card.active {
  border-color: #409eff;
  background: #ecf5ff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.15);
}
.type-card-label {
  font-size: 13px;
  font-weight: 600;
  color: #303133;
}
.type-card-desc {
  font-size: 11px;
  color: #909399;
  line-height: 1.3;
}
.order-amount-hint {
  margin-left: 12px;
  font-size: 12px;
  color: #e6a23c;
}

/* ========== 富文本订单选项 ========== */
.order-option-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 4px 0;
}
.order-opt-img {
  width: 40px;
  height: 40px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid #ebeef5;
  flex-shrink: 0;
}
.order-opt-img-placeholder {
  background: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #c0c4cc;
}
.order-opt-info {
  flex: 1;
  min-width: 0;
}
.order-opt-name {
  font-size: 13px;
  color: #303133;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.order-opt-meta {
  font-size: 11px;
  color: #909399;
  margin-top: 2px;
}
.order-opt-amount {
  font-size: 14px;
  font-weight: 600;
  color: #f56c6c;
  flex-shrink: 0;
}

/* ========== 动画 ========== */
@keyframes fadeSlideUp {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}

/* === 通知跳转高亮 === */
.ticket-item.highlight-target {
  animation: highlightPulse 1.5s ease 3;
  box-shadow: 0 0 0 3px rgba(64, 158, 255, 0.5);
  border-color: #409eff !important;
  z-index: 1;
  position: relative;
}
@keyframes highlightPulse {
  0%, 100% { box-shadow: 0 0 0 3px rgba(64, 158, 255, 0.2); }
  50% { box-shadow: 0 0 0 6px rgba(64, 158, 255, 0.5); }
}
/* 投诉按钮 */
.complaint-btn {
  border-radius: 20px !important;
  padding: 10px 24px !important;
  font-weight: 600;
  font-size: 14px !important;
  box-shadow: 0 4px 12px rgba(245, 108, 108, 0.3);
  transition: all 0.3s !important;
}
.complaint-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 18px rgba(245, 108, 108, 0.45);
}
</style>
