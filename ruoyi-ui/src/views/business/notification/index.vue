<template>
  <div class="app-container notification-page">
    <!-- 统计摘要卡片 -->
    <div class="summary-cards">
      <div
        v-for="(card, index) in summaryCards"
        :key="card.title"
        class="summary-card"
        :style="{ animationDelay: index * 0.1 + 's' }"
      >
        <div class="card-icon" :style="{ background: card.bg }">
          <el-icon :size="24" :style="{ color: card.color }"><component :is="card.icon" /></el-icon>
        </div>
        <div class="card-content">
          <div class="card-value">{{ card.value }}</div>
          <div class="card-title">{{ card.title }}</div>
        </div>
      </div>
    </div>

    <!-- 工具栏 -->
    <div class="search-card">
      <div class="toolbar-row">
        <el-radio-group v-model="readFilter" size="default" @change="switchReadFilter">
          <el-radio-button label="">全部</el-radio-button>
          <el-radio-button label="0">未读</el-radio-button>
          <el-radio-button label="1">已读</el-radio-button>
        </el-radio-group>
        <div class="toolbar-right">
          <el-button type="primary" plain :disabled="notifStats.unreadCount === 0" @click="handleMarkAllRead">
            <el-icon><Check /></el-icon> 全部已读
          </el-button>
          <el-button @click="handleRefresh">
            <el-icon><Refresh /></el-icon> 刷新
          </el-button>
        </div>
      </div>
    </div>

    <!-- 类型分类Tab -->
    <div class="notification-stats-bar">
      <div
        v-for="tab in typeTabs"
        :key="tab.key"
        class="stats-tab"
        :class="{ active: activeTypeTab === tab.key }"
        @click="switchTypeTab(tab.key)"
      >
        <span class="stats-tab-count">{{ tab.count }}</span>
        <span class="stats-tab-label">{{ tab.label }}</span>
      </div>
    </div>

    <!-- 表格 -->
    <div class="table-card">
      <el-table v-loading="loading" :data="tableData" stripe>
        <el-table-column prop="title" label="标题" min-width="180" show-overflow-tooltip />
        <el-table-column prop="content" label="内容" min-width="260" show-overflow-tooltip />
        <el-table-column prop="type" label="类型" width="120">
          <template #default="{ row }">
            <el-tag :type="notificationTypeMap[row.type]?.type || 'info'" size="small" effect="light" round>
              {{ notificationTypeMap[row.type]?.label || row.type }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="isRead" label="状态" width="90" align="center">
          <template #default="{ row }">
            <el-tag :type="row.isRead === 1 ? 'info' : 'danger'" size="small" effect="light" round>
              {{ row.isRead === 1 ? '已读' : '未读' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="时间" width="180">
          <template #default="{ row }">{{ formatDate(row.createTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button v-if="row.isRead === 0" type="primary" link @click="handleRead(row)">标记已读</el-button>
            <el-button type="success" link @click="handleNavigate(row)">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 分页 -->
    <div class="pagination-card">
      <el-pagination
        v-model:current-page="queryParams.pageNum"
        v-model:page-size="queryParams.pageSize"
        :page-sizes="[10, 20, 50]"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="loadData"
        @current-change="loadData"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Bell, Check, Refresh, Document, WarningFilled } from '@element-plus/icons-vue'
import { listNotifications, markAsRead, markAllAsRead, getNotificationStats } from '@/api/business/notification'
import { formatDate, notificationTypeMap } from '@/utils/format'

const router = useRouter()

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const activeTypeTab = ref('')
const readFilter = ref('')
const notifStats = ref({ totalCount: 0, unreadCount: 0, typeCounts: {} })

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  type: undefined,
  isRead: undefined
})

const summaryCards = computed(() => [
  { title: '通知总数', value: notifStats.value.totalCount || 0, icon: Bell, color: '#409eff', bg: '#ecf5ff' },
  { title: '未读通知', value: notifStats.value.unreadCount || 0, icon: WarningFilled, color: '#f56c6c', bg: '#fef0f0' },
  { title: '已读通知', value: (notifStats.value.totalCount || 0) - (notifStats.value.unreadCount || 0), icon: Document, color: '#67c23a', bg: '#f0f9eb' }
])

const typeTabs = computed(() => [
  { key: '', label: '全部', count: notifStats.value.totalCount || 0 },
  { key: 'ORDER_STATUS', label: '订单状态', count: notifStats.value.typeCounts?.ORDER_STATUS || 0 },
  { key: 'TICKET_REPLY', label: '工单回复', count: notifStats.value.typeCounts?.TICKET_REPLY || 0 },
  { key: 'TICKET_REFUND', label: '退款通知', count: notifStats.value.typeCounts?.TICKET_REFUND || 0 },
  { key: 'TICKET_RESOLVED', label: '工单已解决', count: notifStats.value.typeCounts?.TICKET_RESOLVED || 0 }
])

const loadData = async () => {
  loading.value = true
  try {
    const res = await listNotifications(queryParams)
    tableData.value = res.rows || []
    total.value = res.total || 0
  } finally {
    loading.value = false
  }
}

const loadStats = async () => {
  try {
    const res = await getNotificationStats()
    notifStats.value = res.data || { totalCount: 0, unreadCount: 0, typeCounts: {} }
  } catch {
    /* stats failure doesn't block main flow */
  }
}

const switchTypeTab = (key) => {
  activeTypeTab.value = key
  queryParams.type = key || undefined
  queryParams.pageNum = 1
  loadData()
}

const switchReadFilter = (val) => {
  readFilter.value = val
  queryParams.isRead = val === '' ? undefined : Number(val)
  queryParams.pageNum = 1
  loadData()
}

const handleRead = async (row) => {
  await markAsRead(row.notificationId)
  row.isRead = 1
  loadStats()
}

const handleMarkAllRead = async () => {
  await markAllAsRead()
  ElMessage.success('已全部标记为已读')
  loadData()
  loadStats()
}

const handleRefresh = () => {
  loadData()
  loadStats()
}

const handleNavigate = async (row) => {
  if (row.isRead === 0) {
    await markAsRead(row.notificationId)
    row.isRead = 1
    loadStats()
  }
  if (row.type === 'ORDER_STATUS') {
    router.push({ path: '/customer/orders', query: { orderId: row.refId } })
  } else if (row.type === 'TICKET_REPLY' || row.type === 'TICKET_REFUND' || row.type === 'TICKET_RESOLVED') {
    router.push({ path: '/customer/tickets', query: { ticketId: row.refId } })
  }
}

onMounted(() => {
  loadData()
  loadStats()
})
</script>

<style scoped>
/* === 页面容器 === */
.notification-page {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 84px);
}

/* === 统计摘要卡片 === */
.summary-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 16px;
}
.summary-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid #ebeef5;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  animation: fadeSlideUp 0.5s ease both;
  cursor: default;
}
.summary-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}
.card-icon {
  width: 52px;
  height: 52px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.card-content {
  flex: 1;
  min-width: 0;
}
.card-value {
  font-size: 24px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
}
.card-title {
  font-size: 13px;
  color: #909399;
  margin-top: 4px;
}

/* === 工具栏 === */
.search-card {
  background: #fff;
  border-radius: 12px;
  padding: 16px 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  margin-bottom: 16px;
  border: 1px solid #ebeef5;
}
.toolbar-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.toolbar-right {
  display: flex;
  gap: 8px;
}

/* === 类型Tab栏 === */
.notification-stats-bar {
  display: flex;
  background: #fff;
  border-radius: 12px;
  margin-bottom: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid #ebeef5;
  overflow: hidden;
}
.stats-tab {
  flex: 1;
  padding: 16px 8px;
  text-align: center;
  cursor: pointer;
  position: relative;
  transition: all 0.25s;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}
.stats-tab:hover {
  background-color: #f5f7fa;
}
.stats-tab.active {
  background-color: #f0f7ff;
}
.stats-tab.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 20%;
  width: 60%;
  height: 3px;
  background: linear-gradient(90deg, #409eff, #667eea);
  border-radius: 3px 3px 0 0;
}
.stats-tab-count {
  font-size: 22px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
}
.stats-tab.active .stats-tab-count {
  color: #409eff;
}
.stats-tab-label {
  font-size: 13px;
  color: #909399;
}
.stats-tab.active .stats-tab-label {
  color: #409eff;
}

/* === 表格卡片 === */
.table-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid #ebeef5;
  overflow: hidden;
  margin-bottom: 16px;
  animation: fadeSlideUp 0.5s ease 0.3s both;
}
.table-card :deep(.el-table) {
  --el-table-border-color: #ebeef5;
}
.table-card :deep(.el-table th.el-table__cell) {
  background: linear-gradient(135deg, #f5f7fa 0%, #eef1f6 100%);
  font-weight: 600;
  color: #303133;
  font-size: 13px;
}
.table-card :deep(.el-table tr) {
  transition: background 0.2s;
}
:deep(.el-tag) {
  border-radius: 20px;
  padding: 0 12px;
  height: 28px;
  line-height: 26px;
}

/* === 分页 === */
.pagination-card {
  background: #fff;
  border-radius: 12px;
  padding: 16px 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid #ebeef5;
  display: flex;
  justify-content: flex-end;
}

/* === 动画 === */
@keyframes fadeSlideUp {
  from {
    opacity: 0;
    transform: translateY(16px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>

<!-- 暗黑模式适配 -->
<style>
html.dark .notification-page {
  background-color: #0a0a0a;
}
html.dark .notification-page .summary-card {
  background: #1d1e1f;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
html.dark .notification-page .summary-card:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
}
html.dark .notification-page .card-value {
  color: #e0e0e0;
}
html.dark .notification-page .card-title {
  color: #a0a0a0;
}
html.dark .notification-page .search-card {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
html.dark .notification-page .notification-stats-bar {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
html.dark .notification-page .stats-tab:hover {
  background-color: #2a2a2a;
}
html.dark .notification-page .stats-tab.active {
  background-color: rgba(64, 158, 255, 0.1);
}
html.dark .notification-page .stats-tab-count {
  color: #e0e0e0;
}
html.dark .notification-page .stats-tab.active .stats-tab-count {
  color: #79bbff;
}
html.dark .notification-page .stats-tab-label {
  color: #a0a0a0;
}
html.dark .notification-page .stats-tab.active .stats-tab-label {
  color: #79bbff;
}
html.dark .notification-page .table-card {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
html.dark .notification-page .table-card .el-table th.el-table__cell {
  background: linear-gradient(135deg, #1d1e1f 0%, #252525 100%) !important;
  color: #a0a0a0;
}
html.dark .notification-page .table-card .el-table {
  --el-table-border-color: #303030;
}
html.dark .notification-page .pagination-card {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
</style>
