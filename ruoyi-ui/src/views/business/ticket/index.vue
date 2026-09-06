<template>
  <div class="app-container ticket-admin">
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
      <el-button type="warning" plain v-hasPermi="['business:ticket:list']" @click="handleExport">导出</el-button>
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
      <div v-if="filteredData.length === 0 && !loading" class="empty-state">
        <el-empty description="暂无工单" />
      </div>

      <div v-for="(ticket, index) in filteredData" :key="ticket.ticketId"
           class="ticket-item" :class="['status-' + (ticket.status || '').toLowerCase(), { expanded: expandedTicketId === ticket.ticketId }]"
           :style="{ animationDelay: index * 0.05 + 's' }">

        <!-- 摘要条 -->
        <div class="ticket-summary" @click="toggleExpand(ticket)">
          <div class="summary-row1">
            <div class="type-icon-wrapper" :class="'icon-' + (ticket.status || '').toLowerCase()">
              <el-icon class="type-icon" :style="{ color: ticketTypeIcons[ticket.type]?.color || '#909399' }">
                <component :is="ticketTypeIcons[ticket.type]?.icon || ChatDotRound" />
              </el-icon>
              <span class="status-indicator" :class="'indicator-' + (ticket.status || '').toLowerCase()" />
            </div>
            <span class="ticket-title">{{ ticket.title }}</span>
            <el-tag class="status-tag" :type="ticketStatusMap[ticket.status]?.type || 'info'" effect="light" round>
              {{ ticketStatusMap[ticket.status]?.label || ticket.status }}
            </el-tag>
            <el-icon class="expand-arrow" :class="{ rotated: expandedTicketId === ticket.ticketId }">
              <ArrowDown />
            </el-icon>
          </div>
          <div class="summary-row2">
            <span class="ticket-no">{{ ticket.ticketNo }}</span>
            <span class="ticket-time">{{ formatDate(ticket.createTime) }}</span>
            <span v-if="ticket.description" class="ticket-desc-preview">
              {{ ticket.description.length > 40 ? ticket.description.substring(0, 40) + '...' : ticket.description }}
            </span>
          </div>
        </div>

        <!-- 展开区 -->
        <div class="ticket-expand" :class="{ open: expandedTicketId === ticket.ticketId }">
          <div class="expand-inner">
            <!-- 问题描述 -->
            <div v-if="currentTicket.description" class="detail-section">
              <div class="detail-label">问题描述</div>
              <div class="detail-text">{{ currentTicket.description }}</div>
            </div>

            <!-- 退款信息 + 审批按钮（仅退款/退货退款） -->
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
              <div class="refund-actions">
                <el-button v-if="currentTicket.refundStatus === 'PENDING_REVIEW'" type="success" @click.stop="handleApproveRefund">
                  {{ currentTicket.type === 'EXCHANGE' ? '同意退货' : '同意退款' }}
                </el-button>
                <el-button v-if="currentTicket.refundStatus === 'PENDING_REVIEW'" type="danger" @click.stop="handleRejectRefund">
                  {{ currentTicket.type === 'EXCHANGE' ? '拒绝退货' : '拒绝退款' }}
                </el-button>
                <el-button v-if="currentTicket.refundStatus === 'APPROVED'" type="warning" @click.stop="handleConfirmRefund">
                  {{ currentTicket.type === 'EXCHANGE' ? '确认收货并退款' : '确认退款' }}
                </el-button>
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
                     class="chat-message" :class="reply.replyType === 'STAFF' ? 'is-self' : 'is-staff'">
                  <div v-if="reply.replyType !== 'STAFF'" class="chat-avatar" :class="reply.replyType === 'SYSTEM' ? 'system-avatar' : 'user-avatar'">
                    <el-icon :size="14"><component :is="reply.replyType === 'SYSTEM' ? 'Monitor' : 'User'" /></el-icon>
                  </div>
                  <div class="chat-bubble">
                    <div class="chat-bubble-name">
                      {{ reply.replyType === 'STAFF' ? '我' : (reply.replyType === 'SYSTEM' ? '系统' : '用户') }}
                    </div>
                    <div class="chat-bubble-content">{{ reply.content }}</div>
                    <div class="chat-bubble-time">{{ formatDate(reply.createTime) }}</div>
                  </div>
                  <div v-if="reply.replyType === 'STAFF'" class="chat-avatar staff-avatar">
                    <el-icon :size="14"><Service /></el-icon>
                  </div>
                </div>
              </div>
              <!-- 回复输入 -->
              <div v-if="currentTicket.status !== 'CLOSED'" class="chat-input-bar">
                <el-input v-model="quickReplyContent" type="textarea" :rows="2"
                          placeholder="输入回复内容... (Ctrl+Enter 发送)" resize="none"
                          @keydown.ctrl.enter="submitQuickReply" />
                <el-button type="primary" :loading="replyLoading" @click="submitQuickReply">发送</el-button>
              </div>
              <div v-else class="chat-closed-tip">工单已关闭，无法继续回复</div>
            </div>

            <!-- 操作栏 -->
            <div class="expand-actions">
              <el-button v-if="(currentTicket.type === 'COMPLAINT' || currentTicket.type === 'CONSULT') && currentTicket.status !== 'CLOSED' && currentTicket.status !== 'RESOLVED'"
                         type="success" plain @click.stop="handleResolve(ticket)">标记已解决</el-button>
              <el-button v-if="currentTicket.status !== 'CLOSED'" type="warning" plain @click.stop="handleClose(ticket)">关闭工单</el-button>
              <el-button type="primary" plain v-hasPermi="['business:ticket:reply']" @click.stop="handleAssign(ticket)">指派</el-button>
              <el-button type="danger" plain v-hasPermi="['business:ticket:remove']" @click.stop="handleDelete(ticket)">删除</el-button>
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

    <!-- 指派弹窗 -->
    <el-dialog v-model="assignDialogVisible" title="指派工单" width="420px" destroy-on-close>
      <el-form label-width="80px">
        <el-form-item label="工单号">
          <span class="assign-ticket-no">{{ assignTicketData.ticketNo }}</span>
        </el-form-item>
        <el-form-item label="指派客服">
          <el-select v-model="assigneeId" placeholder="请选择客服" filterable style="width: 100%" :loading="staffLoading">
            <el-option v-for="user in staffList" :key="user.userId" :label="user.nickName + ' (' + user.userName + ')'" :value="user.userId" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="assignDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitAssign">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick, getCurrentInstance } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Service, User, UserFilled, Delete, Monitor, WarningFilled, RefreshLeft, Switch, ChatDotRound, ArrowDown } from '@element-plus/icons-vue'
import { listTickets, ticketStats, getTicket, getTicketReplies, addTicketReply, closeTicket, assignTicket, delTicket, approveRefund, confirmRefund, rejectRefund, resolveTicket } from '@/api/business/ticket'
import { formatDate, formatMoney, ticketTypeMap, ticketStatusMap } from '@/utils/format'
import { listUser } from '@/api/system/user'

const { proxy } = getCurrentInstance()

// ===== 映射 =====
const refundStatusMap = {
  PENDING_REVIEW: { label: '待审核', type: 'warning' },
  APPROVED: { label: '已同意', type: 'primary' },
  REFUNDED: { label: '已退款', type: 'success' },
  REJECTED: { label: '已拒绝', type: 'danger' }
}
const ticketTypeIcons = {
  COMPLAINT: { icon: WarningFilled, color: '#f56c6c', desc: '投诉' },
  REFUND: { icon: RefreshLeft, color: '#e6a23c', desc: '仅退款' },
  EXCHANGE: { icon: Switch, color: '#409eff', desc: '退货退款' },
  CONSULT: { icon: ChatDotRound, color: '#67c23a', desc: '转人工客服' }
}

// ===== 状态 =====
const loading = ref(false)
const replyLoading = ref(false)
const tableData = ref([])
const total = ref(0)
const currentTicket = ref({})
const ticketReplies = ref([])
const quickReplyContent = ref('')
const chatContainerRef = ref(null)

// 手风琴
const expandedTicketId = ref(null)

// 查询
const queryParams = reactive({ type: '', status: '', pageNum: 1, pageSize: 10 })
const titleKeyword = ref('')

// 统计
const ticketStatsData = ref({})
const activeStatusTab = ref('')

// 指派
const assignDialogVisible = ref(false)
const assignTicketData = ref({})
const assigneeId = ref(null)
const staffList = ref([])
const staffLoading = ref(false)

// ===== 计算属性 =====
const statusTabs = computed(() => [
  { key: '', label: '全部', count: ticketStatsData.value.totalCount || 0 },
  { key: 'OPEN', label: '待处理', count: ticketStatsData.value.openCount || 0 },
  { key: 'PROCESSING', label: '处理中', count: ticketStatsData.value.processingCount || 0 },
  { key: 'RESOLVED', label: '已解决', count: ticketStatsData.value.resolvedCount || 0 },
  { key: 'CLOSED', label: '已关闭', count: ticketStatsData.value.closedCount || 0 }
])

const filteredData = computed(() => {
  if (!titleKeyword.value.trim()) return tableData.value
  const kw = titleKeyword.value.trim().toLowerCase()
  return tableData.value.filter(t =>
    (t.title && t.title.toLowerCase().includes(kw)) ||
    (t.ticketNo && t.ticketNo.toLowerCase().includes(kw))
  )
})

const refundStepActive = computed(() => {
  const s = currentTicket.value.refundStatus
  if (s === 'PENDING_REVIEW') return 1
  if (s === 'APPROVED') return 2
  if (s === 'REJECTED') return 2
  if (s === 'REFUNDED') return 4
  return 0
})

// ===== 数据加载 =====
const loadStats = async () => {
  try {
    const res = await ticketStats()
    ticketStatsData.value = res.data || {}
  } catch { /* ignore */ }
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await listTickets(queryParams)
    tableData.value = res.rows || []
    total.value = res.total || 0
    expandedTicketId.value = null
  } finally { loading.value = false }
}

const handleSearch = () => { queryParams.pageNum = 1; loadData() }

const resetQuery = () => {
  queryParams.type = ''; queryParams.status = ''
  titleKeyword.value = ''; activeStatusTab.value = ''; queryParams.pageNum = 1
  loadData(); loadStats()
}

const switchStatusTab = (key) => {
  activeStatusTab.value = key
  queryParams.status = key
  queryParams.pageNum = 1
  loadData()
}

// ===== 手风琴展开 =====
const toggleExpand = async (ticket) => {
  if (expandedTicketId.value === ticket.ticketId) {
    expandedTicketId.value = null
    return
  }
  expandedTicketId.value = ticket.ticketId
  quickReplyContent.value = ''
  try {
    const res = await getTicket(ticket.ticketId)
    currentTicket.value = res.data || ticket
  } catch { currentTicket.value = ticket }
  try {
    const res = await getTicketReplies(ticket.ticketId)
    ticketReplies.value = res.data || []
  } catch { ticketReplies.value = [] }
  scrollChatToBottom()
}

const scrollChatToBottom = () => {
  nextTick(() => {
    if (chatContainerRef.value) {
      chatContainerRef.value.scrollTop = chatContainerRef.value.scrollHeight
    }
  })
}

// ===== 快速回复 =====
const submitQuickReply = async () => {
  if (!quickReplyContent.value.trim()) { ElMessage.warning('请输入回复内容'); return }
  replyLoading.value = true
  try {
    await addTicketReply(currentTicket.value.ticketId, { content: quickReplyContent.value, replyType: 'STAFF' })
    quickReplyContent.value = ''
    const [detailRes, repliesRes] = await Promise.all([
      getTicket(currentTicket.value.ticketId),
      getTicketReplies(currentTicket.value.ticketId)
    ])
    currentTicket.value = detailRes.data || currentTicket.value
    ticketReplies.value = repliesRes.data || []
    ElMessage.success('回复成功')
    scrollChatToBottom()
    loadData(); loadStats()
  } finally { replyLoading.value = false }
}

// ===== 关闭工单 =====
const handleClose = (row) => {
  ElMessageBox.confirm('确认关闭工单 ' + row.ticketNo + ' ?', '提示', { type: 'warning' })
    .then(async () => {
      await closeTicket(row.ticketId)
      ElMessage.success('工单已关闭')
      expandedTicketId.value = null
      loadData(); loadStats()
    }).catch(() => {})
}

// ===== 指派 =====
const handleAssign = async (row) => {
  assignTicketData.value = row
  assigneeId.value = row.assigneeId || null
  staffList.value = []
  assignDialogVisible.value = true
  staffLoading.value = true
  try {
    const res = await listUser({ pageNum: 1, pageSize: 100 })
    staffList.value = res.rows || []
  } finally { staffLoading.value = false }
}

const submitAssign = async () => {
  if (!assigneeId.value) { ElMessage.warning('请选择客服'); return }
  await assignTicket(assignTicketData.value.ticketId, assigneeId.value)
  ElMessage.success('指派成功')
  assignDialogVisible.value = false
  loadData()
}

// ===== 删除 =====
const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除工单 ' + row.ticketNo + ' ?', '提示', { type: 'warning' })
    .then(async () => {
      await delTicket(row.ticketId)
      ElMessage.success('删除成功')
      loadData(); loadStats()
    }).catch(() => {})
}

// ===== 标记已解决 =====
const handleResolve = (row) => {
  ElMessageBox.confirm('确认将工单 ' + row.ticketNo + ' 标记为已解决？', '标记已解决', { type: 'info' })
    .then(async () => {
      await resolveTicket(row.ticketId)
      ElMessage.success('工单已标记为已解决')
      const res = await getTicket(row.ticketId)
      currentTicket.value = res.data || currentTicket.value
      loadData(); loadStats()
    }).catch(() => {})
}

// ===== 退款审批 =====
const handleApproveRefund = () => {
  ElMessageBox.confirm('确认同意该退款申请？', '同意退款', { type: 'warning' })
    .then(async () => {
      await approveRefund(currentTicket.value.ticketId)
      ElMessage.success('已同意退款')
      const res = await getTicket(currentTicket.value.ticketId)
      currentTicket.value = res.data || currentTicket.value
      loadData(); loadStats()
    }).catch(() => {})
}

const handleConfirmRefund = () => {
  ElMessageBox.confirm('确认退款后将联动更新订单状态为"已退款"并恢复库存，是否继续？', '确认退款', { type: 'warning' })
    .then(async () => {
      await confirmRefund(currentTicket.value.ticketId)
      ElMessage.success('退款已完成')
      const [detailRes, repliesRes] = await Promise.all([
        getTicket(currentTicket.value.ticketId),
        getTicketReplies(currentTicket.value.ticketId)
      ])
      currentTicket.value = detailRes.data || currentTicket.value
      ticketReplies.value = repliesRes.data || []
      loadData(); loadStats()
    }).catch(() => {})
}

const handleRejectRefund = () => {
  ElMessageBox.prompt('请输入拒绝原因', '拒绝退款', {
    confirmButtonText: '确定', cancelButtonText: '取消', inputType: 'textarea',
    inputPlaceholder: '请说明拒绝原因...'
  }).then(async ({ value }) => {
    await rejectRefund(currentTicket.value.ticketId, value)
    ElMessage.success('已拒绝退款')
    const [detailRes, repliesRes] = await Promise.all([
      getTicket(currentTicket.value.ticketId),
      getTicketReplies(currentTicket.value.ticketId)
    ])
    currentTicket.value = detailRes.data || currentTicket.value
    ticketReplies.value = repliesRes.data || []
    loadData(); loadStats()
  }).catch(() => {})
}

// ===== 导出 =====
const handleExport = () => {
  proxy.download('business/ticket/export', { ...queryParams }, `工单数据_${new Date().getTime()}.xlsx`)
}

// ===== 初始化 =====
onMounted(() => { loadData(); loadStats() })
</script>

<style scoped>
/* ========== 基础容器 ========== */
.ticket-admin {
  padding: 20px 24px 30px;
  max-width: 1100px;
  margin: 0 auto;
  background-color: #f5f7fa;
  min-height: calc(100vh - 84px);
}

/* ========== 搜索栏 ========== */
.search-bar {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 16px;
  gap: 12px;
  background: #fff;
  padding: 18px 20px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid #ebeef5;
  animation: fadeSlideUp 0.4s ease both;
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
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 12px;
  padding: 6px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  animation: fadeSlideUp 0.4s ease 0.05s both;
}
.stats-tab {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10px 0 8px;
  cursor: pointer;
  position: relative;
  color: #909399;
  user-select: none;
  border-radius: 8px;
  overflow: hidden;
  transition: color 0.35s ease, box-shadow 0.35s ease, transform 0.25s ease;
}
.stats-tab::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 8px;
  background: linear-gradient(135deg, #b2f5ea 0%, #81e6d9 100%);
  opacity: 0;
  transition: opacity 0.35s ease;
  z-index: 0;
}
.stats-tab > * {
  position: relative;
  z-index: 1;
}
.stats-tab:hover {
  color: #14b8a6;
}
.stats-tab:hover::before {
  opacity: 0.3;
}
.stats-tab:active {
  transform: scale(0.97);
}
.stats-tab.active {
  color: #0f766e;
  box-shadow: 0 2px 8px rgba(20, 184, 166, 0.2);
}
.stats-tab.active::before {
  opacity: 1;
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

/* ========== 工单列表 ========== */
.ticket-list {
  min-height: 200px;
}
.empty-state {
  padding: 60px 0;
}

/* ========== 工单条目 ========== */
.ticket-item {
  background: #fff;
  border-radius: 12px;
  margin-bottom: 12px;
  border: 1px solid #ebeef5;
  overflow: hidden;
  transition: box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1),
              border-color 0.3s,
              transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  animation: fadeSlideUp 0.4s ease both;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}
.ticket-item:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
  border-color: #d0d7de;
}
.ticket-item.expanded {
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border-color: rgba(20, 184, 166, 0.3);
}
/* 状态背景色微调 */
.ticket-item.status-open { background: linear-gradient(135deg, #fff5f5 0%, #fff 35%); border-left: 3px solid #f56c6c; }
.ticket-item.status-processing { background: linear-gradient(135deg, #fffaf0 0%, #fff 35%); border-left: 3px solid #e6a23c; }
.ticket-item.status-resolved { background: linear-gradient(135deg, #f0fdfa 0%, #fff 35%); border-left: 3px solid #14b8a6; }
.ticket-item.status-closed { background: #fafbfc; border-left: 3px solid #c0c4cc; }

/* ========== 状态图标徽章 ========== */
.type-icon-wrapper {
  position: relative;
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: background 0.2s, transform 0.2s;
}
.type-icon-wrapper.icon-open { background: rgba(245, 108, 108, 0.12); }
.type-icon-wrapper.icon-processing { background: rgba(230, 162, 60, 0.12); }
.type-icon-wrapper.icon-resolved { background: rgba(20, 184, 166, 0.12); }
.type-icon-wrapper.icon-closed { background: rgba(192, 196, 204, 0.12); }
.status-indicator {
  position: absolute;
  top: -2px;
  right: -2px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  border: 2px solid #fff;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
}
.indicator-open { background: #f56c6c; animation: pulse 2s infinite; }
.indicator-processing { background: #e6a23c; }
.indicator-resolved { background: #67c23a; }
.indicator-closed { background: #c0c4cc; }

/* ========== 摘要条 ========== */
.ticket-summary {
  padding: 14px 18px 12px;
  cursor: pointer;
  transition: background 0.2s;
}
.ticket-summary:hover {
  background: rgba(20, 184, 166, 0.03);
}
.summary-row1 {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 6px;
}
.type-icon {
  font-size: 17px;
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
.summary-actions {
  display: flex;
  gap: 2px;
  flex-shrink: 0;
  margin-left: 4px;
}
.summary-actions .el-button {
  font-size: 12px;
}
.expand-arrow {
  font-size: 14px;
  color: #c0c4cc;
  transition: transform 0.3s ease, color 0.2s;
  flex-shrink: 0;
}
.expand-arrow.rotated {
  transform: rotate(180deg);
  color: #14b8a6;
}
.summary-row2 {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 12px;
  color: #909399;
  padding-left: 42px;
}
.ticket-no {
  font-family: 'Consolas', 'Monaco', monospace;
  color: #14b8a6;
  flex-shrink: 0;
  font-size: 11px;
  background: rgba(20, 184, 166, 0.08);
  padding: 1px 8px;
  border-radius: 4px;
}
.ticket-time { flex-shrink: 0; }
.ticket-desc-preview {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #b0b5bd;
}

/* ========== 展开区（手风琴） ========== */
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
  border-top: 1px dashed #e4e7ed;
  background: linear-gradient(180deg, #f9fafb 0%, #fff 60px);
}

/* ========== 详情区块 ========== */
.detail-section {
  margin-top: 14px;
}
.detail-label {
  font-size: 13px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
  padding-left: 8px;
  border-left: 3px solid #14b8a6;
}
.detail-text {
  font-size: 13px;
  color: #606266;
  line-height: 1.7;
  background: #f5f7fa;
  padding: 10px 14px;
  border-radius: 8px;
  border: 1px solid #eef0f3;
}

/* ========== 退款信息 ========== */
.refund-box {
  background: linear-gradient(135deg, #fffbf0 0%, #fff8e6 100%);
  border: 1px solid #faecd8;
  border-radius: 10px;
  padding: 16px 18px;
  box-shadow: 0 2px 8px rgba(230, 162, 60, 0.08);
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
  font-size: 18px;
  font-weight: 700;
}
.refund-steps {
  margin-top: 4px;
}
.refund-actions {
  margin-top: 16px;
  display: flex;
  gap: 12px;
  justify-content: center;
}

/* ========== 聊天沟通区 ========== */
.chat-container {
  max-height: 360px;
  overflow-y: auto;
  padding: 16px 12px;
  background: linear-gradient(180deg, #f0f2f5 0%, #f5f7fa 100%);
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  gap: 14px;
  border: 1px solid #e8ebf0;
}
.chat-container::-webkit-scrollbar {
  width: 5px;
}
.chat-container::-webkit-scrollbar-thumb {
  background: #c0c4cc;
  border-radius: 3px;
}
.chat-container::-webkit-scrollbar-track {
  background: transparent;
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
.chat-message {
  display: flex;
  align-items: flex-start;
  gap: 8px;
}
.chat-message.is-self {
  justify-content: flex-end;
}
.chat-avatar {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}
.staff-avatar {
  background: linear-gradient(135deg, #14b8a6, #0d9488);
  color: #fff;
}
.user-avatar {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: #fff;
}
.system-avatar {
  background: linear-gradient(135deg, #6b7280, #9ca3af);
  color: #fff;
}
.chat-bubble {
  max-width: 70%;
  padding: 10px 14px;
  border-radius: 16px;
  position: relative;
  transition: transform 0.15s;
}
.chat-bubble:hover {
  transform: scale(1.01);
}
.is-staff .chat-bubble {
  background: #fff;
  border: none;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06),
              0 0 0 1px rgba(0, 0, 0, 0.03);
  border-top-left-radius: 4px;
}
.is-self .chat-bubble {
  background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
  color: #fff;
  border-top-right-radius: 4px;
  box-shadow: 0 2px 8px rgba(20, 184, 166, 0.3);
}
.chat-bubble-name {
  font-size: 11px;
  margin-bottom: 4px;
  opacity: 0.65;
  font-weight: 500;
}
.is-self .chat-bubble-name {
  text-align: right;
}
.chat-bubble-content {
  font-size: 13px;
  line-height: 1.6;
  word-break: break-word;
  letter-spacing: 0.01em;
}
.chat-bubble-time {
  font-size: 10px;
  margin-top: 6px;
  opacity: 0.45;
  letter-spacing: 0.02em;
}
.is-self .chat-bubble-time {
  text-align: right;
}
.chat-input-bar {
  display: flex;
  gap: 10px;
  margin-top: 12px;
  align-items: flex-end;
  background: #fff;
  padding: 10px;
  border-radius: 12px;
  border: 1px solid #e8ebf0;
}
.chat-input-bar .el-button {
  height: 54px;
  border-radius: 10px;
}
.chat-closed-tip {
  text-align: center;
  color: #c0c4cc;
  font-size: 13px;
  padding: 14px 0 4px;
  font-style: italic;
}

/* ========== 展开操作栏 ========== */
.expand-actions {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding-top: 14px;
  border-top: 1px dashed #e8ebf0;
}
.expand-actions .el-button {
  font-size: 13px;
  padding: 9px 22px;
  font-weight: 500;
  border-radius: 8px;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

/* ========== 分页 ========== */
.pagination-bar {
  margin-top: 16px;
  justify-content: center;
  background: #fff;
  padding: 14px 20px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid #ebeef5;
}

/* ========== 指派弹窗 ========== */
.assign-ticket-no {
  font-family: 'Consolas', 'Monaco', monospace;
  color: #14b8a6;
}

/* ========== 动画 ========== */
@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}
.ticket-expand.open .detail-section {
  animation: fadeIn 0.3s ease 0.15s both;
}
</style>

<!-- 暗黑模式适配（不带scoped，html.dark在根元素） -->
<style>
html.dark .ticket-admin {
  background-color: #0a0a0a;
}

/* 搜索栏 */
html.dark .ticket-admin .search-bar {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}

/* 状态统计栏 */
html.dark .ticket-admin .ticket-stats-bar {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
html.dark .ticket-admin .stats-tab {
  color: #a0a0a0;
}
html.dark .ticket-admin .stats-tab::before {
  background: linear-gradient(135deg, rgba(20, 184, 166, 0.3) 0%, rgba(13, 148, 136, 0.3) 100%);
}
html.dark .ticket-admin .stats-tab:hover {
  color: #14b8a6;
}
html.dark .ticket-admin .stats-tab.active {
  color: #5eead4;
  box-shadow: 0 2px 8px rgba(20, 184, 166, 0.15);
}

/* 工单条目 */
html.dark .ticket-admin .ticket-item {
  background: #1d1e1f;
  border-color: #303030;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}
html.dark .ticket-admin .ticket-item:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
  border-color: #434343;
}
html.dark .ticket-admin .ticket-item.expanded {
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.35);
  border-color: rgba(20, 184, 166, 0.3);
}

/* 状态渐变 */
html.dark .ticket-admin .ticket-item.status-open {
  background: linear-gradient(135deg, rgba(245, 108, 108, 0.08) 0%, #1d1e1f 35%);
  border-left-color: #f56c6c;
}
html.dark .ticket-admin .ticket-item.status-processing {
  background: linear-gradient(135deg, rgba(230, 162, 60, 0.08) 0%, #1d1e1f 35%);
  border-left-color: #e6a23c;
}
html.dark .ticket-admin .ticket-item.status-resolved {
  background: linear-gradient(135deg, rgba(20, 184, 166, 0.08) 0%, #1d1e1f 35%);
  border-left-color: #14b8a6;
}
html.dark .ticket-admin .ticket-item.status-closed {
  background: #1a1a1a;
  border-left-color: #4a4a4a;
}

/* 状态图标 */
html.dark .ticket-admin .type-icon-wrapper.icon-open { background: rgba(245, 108, 108, 0.15); }
html.dark .ticket-admin .type-icon-wrapper.icon-processing { background: rgba(230, 162, 60, 0.15); }
html.dark .ticket-admin .type-icon-wrapper.icon-resolved { background: rgba(20, 184, 166, 0.15); }
html.dark .ticket-admin .type-icon-wrapper.icon-closed { background: rgba(74, 74, 74, 0.2); }
html.dark .ticket-admin .status-indicator {
  border-color: #1d1e1f;
}

/* 摘要条 */
html.dark .ticket-admin .ticket-summary:hover {
  background: rgba(20, 184, 166, 0.04);
}
html.dark .ticket-admin .ticket-title {
  color: #e0e0e0;
}
html.dark .ticket-admin .summary-row2 {
  color: #a0a0a0;
}
html.dark .ticket-admin .ticket-no {
  color: #5eead4;
  background: rgba(20, 184, 166, 0.15);
}
html.dark .ticket-admin .ticket-desc-preview {
  color: #666;
}
html.dark .ticket-admin .expand-arrow {
  color: #555;
}
html.dark .ticket-admin .expand-arrow.rotated {
  color: #14b8a6;
}

/* 展开区 */
html.dark .ticket-admin .expand-inner {
  border-top-color: #303030;
  background: linear-gradient(180deg, #141414 0%, #1d1e1f 60px);
}

/* 详情区块 */
html.dark .ticket-admin .detail-label {
  color: #e0e0e0;
}
html.dark .ticket-admin .detail-text {
  color: #d0d0d0;
  background: #141414;
  border-color: #303030;
}

/* 退款信息 */
html.dark .ticket-admin .refund-box {
  background: linear-gradient(135deg, rgba(230, 162, 60, 0.08) 0%, rgba(230, 162, 60, 0.04) 100%);
  border-color: rgba(230, 162, 60, 0.2);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}
html.dark .ticket-admin .refund-info-row {
  color: #d0d0d0;
}

/* 聊天区 */
html.dark .ticket-admin .chat-container {
  background: linear-gradient(180deg, #1a1a1a 0%, #141414 100%);
  border-color: #303030;
}
html.dark .ticket-admin .chat-container::-webkit-scrollbar-thumb {
  background: #434343;
}
html.dark .ticket-admin .chat-empty {
  color: #555;
}
html.dark .ticket-admin .is-staff .chat-bubble {
  background: #2a2a2a;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(255, 255, 255, 0.04);
  color: #d0d0d0;
}
html.dark .ticket-admin .chat-input-bar {
  background: #1d1e1f;
  border-color: #303030;
}
html.dark .ticket-admin .chat-closed-tip {
  color: #555;
}

/* 操作栏 */
html.dark .ticket-admin .expand-actions {
  border-top-color: #303030;
}

/* 分页 */
html.dark .ticket-admin .pagination-bar {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}

/* 指派弹窗 */
html.dark .ticket-admin .assign-ticket-no {
  color: #5eead4;
}
</style>
