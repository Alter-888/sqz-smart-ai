<template>
  <div class="app-container admin-order-page">
    <!-- 统计摘要卡片行 -->
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

    <!-- 搜索栏 -->
    <div class="search-card">
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="订单号">
          <el-input v-model="queryParams.orderNo" placeholder="请输入订单号" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetQuery">重置</el-button>
          <el-button type="warning" plain v-hasPermi="['business:order:list']" @click="handleExport">导出</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 状态Tab栏 -->
    <div class="order-stats-bar">
      <div
        v-for="tab in statusTabs"
        :key="tab.key"
        class="stats-tab"
        :class="{ active: activeStatusTab === tab.key }"
        @click="switchStatusTab(tab.key)"
      >
        <span class="stats-tab-count">{{ tab.count }}</span>
        <span class="stats-tab-label">{{ tab.label }}</span>
      </div>
    </div>

    <!-- 表格区域 -->
    <div class="table-card">
      <el-table v-loading="loading" :data="tableData" stripe>
        <el-table-column prop="orderNo" label="订单号" min-width="180" show-overflow-tooltip />
        <el-table-column label="商品信息" min-width="220">
          <template #default="{ row }">
            <div v-if="row.firstItemName" class="product-cell">
              <img v-if="row.firstItemImage" :src="row.firstItemImage" class="product-thumb" />
              <div v-else class="product-thumb-empty">
                <el-icon :size="16" color="#c0c4cc"><Goods /></el-icon>
              </div>
              <div class="product-info">
                <span class="product-name">{{ row.firstItemName }}</span>
                <span v-if="row.itemCount > 1" class="product-count">等{{ row.itemCount }}件</span>
                <span v-else-if="row.itemCount === 1" class="product-count">共1件</span>
              </div>
            </div>
            <span v-else class="no-product">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="nickName" label="用户" width="120">
          <template #default="{ row }">{{ row.nickName || row.userId }}</template>
        </el-table-column>
        <el-table-column prop="totalAmount" label="总金额" width="120" align="right">
          <template #default="{ row }">&yen;{{ formatMoney(row.totalAmount) }}</template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="110">
          <template #default="{ row }">
            <el-tag :type="adminStatusMap[row.status]?.type || 'info'" effect="light" round>{{ adminStatusMap[row.status]?.label || row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180">
          <template #default="{ row }">{{ formatDate(row.createTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleView(row)">查看详情</el-button>
            <el-button v-if="!terminalStatuses.includes(row.status)" type="warning" link v-hasPermi="['business:order:status']" @click="handleStatusChange(row)">更新状态</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 分页 -->
    <div class="pagination-card">
      <el-pagination v-model:current-page="queryParams.pageNum" v-model:page-size="queryParams.pageSize" :page-sizes="[10, 20, 50]" :total="total" layout="total, sizes, prev, pager, next, jumper" @size-change="loadData" @current-change="loadData" />
    </div>

    <!-- Order detail dialog -->
    <el-dialog v-model="detailDialogVisible" title="订单详情" width="700px" destroy-on-close>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="订单号">{{ currentOrder.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="用户">{{ currentOrder.nickName || currentOrder.userId }}</el-descriptions-item>
        <el-descriptions-item label="总金额">&yen;{{ formatMoney(currentOrder.totalAmount) }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="adminStatusMap[currentOrder.status]?.type || 'info'">{{ adminStatusMap[currentOrder.status]?.label || currentOrder.status }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ formatDate(currentOrder.createTime) }}</el-descriptions-item>
        <el-descriptions-item label="付款时间">{{ formatDate(currentOrder.payTime) || '-' }}</el-descriptions-item>
        <el-descriptions-item label="发货时间">{{ formatDate(currentOrder.shipTime) || '-' }}</el-descriptions-item>
        <el-descriptions-item label="物流公司">{{ currentOrder.logisticsCompany || '-' }}</el-descriptions-item>
        <el-descriptions-item label="物流单号">{{ currentOrder.logisticsNo || '-' }}</el-descriptions-item>
        <el-descriptions-item label="收货地址">{{ currentOrder.address || '-' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ currentOrder.remark || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div v-if="orderItems.length > 0" style="margin-top: 20px">
        <h4>订单商品</h4>
        <el-table :data="orderItems" stripe border size="small">
          <el-table-column label="商品信息" min-width="240">
            <template #default="{ row }">
              <div style="display: flex; align-items: center; gap: 10px;">
                <img
                  v-if="row.imageUrl"
                  :src="row.imageUrl"
                  style="width: 48px; height: 48px; object-fit: cover; border-radius: 6px; border: 1px solid #ebeef5; flex-shrink: 0;"
                />
                <div v-else style="width: 48px; height: 48px; background: #f5f7fa; border-radius: 6px; border: 1px solid #ebeef5; flex-shrink: 0;" />
                <span>{{ row.productName }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="price" label="单价" width="100" align="right">
            <template #default="{ row }">&yen;{{ formatMoney(row.price) }}</template>
          </el-table-column>
          <el-table-column prop="quantity" label="数量" width="80" align="center" />
        </el-table>
      </div>
      <template #footer><el-button @click="detailDialogVisible = false">关闭</el-button></template>
    </el-dialog>

    <!-- Status change dialog -->
    <el-dialog v-model="statusDialogVisible" title="更新订单状态" width="450px" destroy-on-close>
      <el-form label-width="80px">
        <el-form-item label="订单号">{{ currentOrder.orderNo }}</el-form-item>
        <el-form-item label="当前状态">
          <el-tag :type="adminStatusMap[currentOrder.status]?.type || 'info'">{{ adminStatusMap[currentOrder.status]?.label || currentOrder.status }}</el-tag>
        </el-form-item>
        <el-form-item label="新状态">
          <el-select v-model="newStatus" placeholder="请选择新状态" style="width: 100%" :loading="allowedStatusLoading" @change="onNewStatusChange">
            <el-option v-for="item in allowedStatuses" :key="item.code" :label="item.desc" :value="item.code" />
          </el-select>
          <div v-if="allowedStatuses.length === 0 && !allowedStatusLoading" style="color: #999; font-size: 12px; margin-top: 4px">当前状态为终态，不可变更</div>
        </el-form-item>
        <template v-if="newStatus === 'SHIPPED'">
          <el-form-item label="物流公司">
            <el-select v-model="logisticsCompany" placeholder="请选择物流公司" style="width: 100%">
              <el-option v-for="c in logisticsCompanyOptions" :key="c" :label="c" :value="c" />
            </el-select>
          </el-form-item>
          <el-form-item label="物流单号">
            <div style="display: flex; gap: 8px; width: 100%">
              <el-input v-model="logisticsNo" placeholder="物流单号" style="flex: 1" />
              <el-button type="primary" plain size="small" @click="generateLogisticsNo">随机生成</el-button>
            </div>
          </el-form-item>
        </template>
      </el-form>
      <template #footer>
        <el-button @click="statusDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="statusLoading" @click="submitStatusChange">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, getCurrentInstance } from 'vue'
import { ElMessage } from 'element-plus'
import { Document, Calendar, Wallet, Timer, Goods } from '@element-plus/icons-vue'
import { listOrders, getOrder, updateOrderStatus, getAllowedStatuses, adminOrderStats } from '@/api/business/order'
import { formatDate, formatMoney, orderStatusMap } from '@/utils/format'

// 管理员视角：PAID 状态显示为"待发货"
const adminStatusMap = {
  ...orderStatusMap,
  PAID: { label: '待发货', type: 'primary' }
}

const { proxy } = getCurrentInstance()

const loading = ref(false)
const statusLoading = ref(false)
const tableData = ref([])
const total = ref(0)
const detailDialogVisible = ref(false)
const statusDialogVisible = ref(false)
const currentOrder = ref({})
const orderItems = ref([])
const newStatus = ref('')
const allowedStatuses = ref([])
const allowedStatusLoading = ref(false)
const logisticsNo = ref('')
const logisticsCompany = ref('')
const queryParams = reactive({ orderNo: '', status: '', pageNum: 1, pageSize: 10 })

const terminalStatuses = ['CANCELLED', 'REFUNDED', 'DELIVERED']

// 统计相关
const orderStats = ref({})
const activeStatusTab = ref('')

const statusTabs = computed(() => [
  { key: '', label: '全部', count: orderStats.value.totalCount || 0 },
  { key: 'PAID', label: '待发货', count: orderStats.value.paidCount || 0 },
  { key: 'SHIPPED', label: '已发货', count: orderStats.value.shippedCount || 0 },
  { key: 'DELIVERED', label: '已签收', count: orderStats.value.deliveredCount || 0 },
  { key: 'CANCELLED', label: '已取消', count: orderStats.value.cancelledCount || 0 },
  { key: 'REFUNDED', label: '已退款', count: orderStats.value.refundedCount || 0 }
])

const summaryCards = computed(() => [
  { title: '订单总数', value: orderStats.value.totalCount || 0, icon: Document, color: '#409eff', bg: '#ecf5ff' },
  { title: '今日新增', value: orderStats.value.todayCount || 0, icon: Calendar, color: '#67c23a', bg: '#f0f9eb' },
  { title: '营业收入', value: '\u00a5' + formatMoney(orderStats.value.totalRevenue || 0), icon: Wallet, color: '#e6a23c', bg: '#fdf6ec' },
  { title: '待发货', value: orderStats.value.paidCount || 0, icon: Timer, color: '#f56c6c', bg: '#fef0f0' }
])

const logisticsCompanyOptions = ['顺丰速运', '中通快递', '圆通速递', '韵达快递', '申通快递', '百世快递', '极兔速递', 'EMS', '京东物流', '德邦快递']

// 各快递公司单号前缀和长度规则
const logisticsNoRules = {
  '顺丰速运': { prefix: 'SF', len: 12 },
  '中通快递': { prefix: 'ZTO', len: 12 },
  '圆通速递': { prefix: 'YT', len: 13 },
  '韵达快递': { prefix: 'YD', len: 13 },
  '申通快递': { prefix: 'STO', len: 12 },
  '百世快递': { prefix: 'BS', len: 12 },
  '极兔速递': { prefix: 'JT', len: 13 },
  'EMS': { prefix: 'EMS', len: 13 },
  '京东物流': { prefix: 'JD', len: 12 },
  '德邦快递': { prefix: 'DB', len: 12 }
}

const generateLogisticsNo = () => {
  const rule = logisticsNoRules[logisticsCompany.value] || { prefix: 'PKG', len: 12 }
  const numLen = rule.len - rule.prefix.length
  let digits = ''
  for (let i = 0; i < numLen; i++) {
    digits += Math.floor(Math.random() * 10)
  }
  logisticsNo.value = rule.prefix + digits
}

const onNewStatusChange = (val) => {
  if (val === 'SHIPPED' && !logisticsCompany.value) {
    logisticsCompany.value = '顺丰速运'
    generateLogisticsNo()
  }
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await listOrders(queryParams)
    tableData.value = res.rows || []
    total.value = res.total || 0
  } finally { loading.value = false }
}

const handleSearch = () => { queryParams.pageNum = 1; loadData() }
const resetQuery = () => { queryParams.orderNo = ''; queryParams.status = ''; activeStatusTab.value = ''; queryParams.pageNum = 1; loadData() }

const loadStats = async () => {
  try {
    const res = await adminOrderStats()
    orderStats.value = res.data || {}
  } catch { /* 统计加载失败不影响主流程 */ }
}

const switchStatusTab = (key) => {
  activeStatusTab.value = key
  queryParams.status = key
  queryParams.pageNum = 1
  loadData()
}

const handleView = async (row) => {
  const res = await getOrder(row.orderId)
  const data = res.data || {}
  currentOrder.value = data.order || row
  orderItems.value = data.items || []
  detailDialogVisible.value = true
}

const handleStatusChange = async (row) => {
  currentOrder.value = row
  newStatus.value = ''
  logisticsNo.value = ''
  logisticsCompany.value = ''
  allowedStatuses.value = []
  statusDialogVisible.value = true
  allowedStatusLoading.value = true
  try {
    const res = await getAllowedStatuses(row.orderId)
    allowedStatuses.value = res.data || []
  } finally { allowedStatusLoading.value = false }
}

const submitStatusChange = async () => {
  if (!newStatus.value) { ElMessage.warning('请选择新状态'); return }
  if (newStatus.value === 'SHIPPED' && !logisticsNo.value.trim()) {
    ElMessage.warning('请输入物流单号'); return
  }
  statusLoading.value = true
  try {
    const extra = newStatus.value === 'SHIPPED' ? { logisticsNo: logisticsNo.value, logisticsCompany: logisticsCompany.value } : {}
    await updateOrderStatus(currentOrder.value.orderId, newStatus.value, extra)
    ElMessage.success('状态更新成功'); statusDialogVisible.value = false; loadData(); loadStats()
  } finally { statusLoading.value = false }
}

onMounted(() => { loadData(); loadStats() })

const handleExport = () => {
  proxy.download('business/order/export', { ...queryParams }, `订单数据_${new Date().getTime()}.xlsx`)
}
</script>

<style scoped>
/* === 页面容器 === */
.admin-order-page {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 84px);
}

/* === 统计摘要卡片 === */
.summary-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
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
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.card-title {
  font-size: 13px;
  color: #909399;
  margin-top: 4px;
}

/* === 搜索栏 === */
.search-card {
  background: #fff;
  border-radius: 12px;
  padding: 18px 20px 2px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  margin-bottom: 16px;
  border: 1px solid #ebeef5;
}

/* === 状态Tab栏 === */
.order-stats-bar {
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

/* 标签圆角 pill 样式 */
:deep(.el-tag) {
  border-radius: 20px;
  padding: 0 12px;
  height: 28px;
  line-height: 26px;
}

/* === 商品信息列 === */
.product-cell {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 4px 0;
}
.product-thumb {
  width: 40px;
  height: 40px;
  border-radius: 6px;
  object-fit: cover;
  border: 1px solid #ebeef5;
  flex-shrink: 0;
}
.product-thumb-empty {
  width: 40px;
  height: 40px;
  border-radius: 6px;
  background: #f5f7fa;
  border: 1px dashed #dcdfe6;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.product-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.product-name {
  font-size: 13px;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  line-height: 1.3;
}
.product-count {
  font-size: 12px;
  color: #909399;
  line-height: 1.2;
}
.no-product {
  color: #c0c4cc;
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

<!-- 暗黑模式适配（不带scoped，html.dark在根元素） -->
<style>
/* 页面容器 */
html.dark .admin-order-page {
  background-color: #0a0a0a;
}

/* 统计摘要卡片 */
html.dark .admin-order-page .summary-card {
  background: #1d1e1f;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
html.dark .admin-order-page .summary-card:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
}
html.dark .admin-order-page .card-value {
  color: #e0e0e0;
}
html.dark .admin-order-page .card-title {
  color: #a0a0a0;
}

/* 搜索栏 */
html.dark .admin-order-page .search-card {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}

/* 状态Tab栏 */
html.dark .admin-order-page .order-stats-bar {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
html.dark .admin-order-page .stats-tab:hover {
  background-color: #2a2a2a;
}
html.dark .admin-order-page .stats-tab.active {
  background-color: rgba(64, 158, 255, 0.1);
}
html.dark .admin-order-page .stats-tab-count {
  color: #e0e0e0;
}
html.dark .admin-order-page .stats-tab.active .stats-tab-count {
  color: #79bbff;
}
html.dark .admin-order-page .stats-tab-label {
  color: #a0a0a0;
}
html.dark .admin-order-page .stats-tab.active .stats-tab-label {
  color: #79bbff;
}
html.dark .admin-order-page .stats-tab.active::after {
  background: linear-gradient(90deg, #409eff, #667eea);
}

/* 表格卡片 */
html.dark .admin-order-page .table-card {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
html.dark .admin-order-page .table-card .el-table th.el-table__cell {
  background: linear-gradient(135deg, #1d1e1f 0%, #252525 100%) !important;
  color: #a0a0a0;
}
html.dark .admin-order-page .table-card .el-table {
  --el-table-border-color: #303030;
}

/* 商品信息列 */
html.dark .admin-order-page .product-name {
  color: #e0e0e0;
}
html.dark .admin-order-page .product-count {
  color: #a0a0a0;
}
html.dark .admin-order-page .no-product {
  color: #555;
}
html.dark .admin-order-page .product-thumb {
  border-color: #303030;
}
html.dark .admin-order-page .product-thumb-empty {
  background: #2a2a2a;
  border-color: #434343;
}

/* 分页 */
html.dark .admin-order-page .pagination-card {
  background: #141414;
  border-color: #303030;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
</style>
