<template>
  <div class="app-container">
    <!-- 搜索栏 -->
    <el-form :inline="true" :model="queryParams" class="search-bar">
      <el-form-item label="订单号">
        <el-input v-model="queryParams.orderNo" placeholder="请输入订单号" clearable @keyup.enter="handleSearch" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 状态统计 Tab 栏 -->
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
        <span v-if="tab.key === 'PENDING' && tab.count > 0" class="stats-tab-dot" />
      </div>
    </div>

    <!-- 待付金额提示 -->
    <div v-if="orderStats.pendingAmount > 0" class="pending-amount-tip">
      待付款合计：<span class="amount">&yen;{{ formatMoney(orderStats.pendingAmount) }}</span>
    </div>

    <!-- 订单卡片列表 -->
    <div v-loading="loading" class="order-card-list">
      <div v-if="tableData.length === 0 && !loading" class="empty-state">
        <el-empty description="暂无订单" />
      </div>
      <div
        v-for="(order, index) in tableData"
        :key="order.orderId"
        :id="'order-' + order.orderId"
        class="order-card"
        :class="['status-' + (order.status || '').toLowerCase(), { 'highlight-target': highlightOrderId == order.orderId }]"
        :style="{ animationDelay: index * 0.06 + 's' }"
      >
        <!-- 卡片头部 -->
        <div class="order-card-header">
          <div class="header-left">
            <span class="order-no-label">订单号：</span>
            <span class="order-no">{{ order.orderNo }}</span>
            <span class="order-time">{{ formatDate(order.createTime) }}</span>
          </div>
          <el-tag :type="orderStatusMap[order.status]?.type || 'info'" effect="light" round>
            {{ orderStatusMap[order.status]?.label || order.status }}
          </el-tag>
        </div>

        <!-- 卡片主体：商品列表 -->
        <div class="order-card-body">
          <template v-if="order.items && order.items.length > 0">
            <div
              v-for="(item, idx) in getDisplayItems(order)"
              :key="item.itemId"
              class="order-item-row"
              :class="{ 'has-border': idx < getDisplayItems(order).length - 1 }"
            >
              <img v-if="item.imageUrl" :src="item.imageUrl" class="item-img" />
              <div v-else class="item-img-placeholder" />
              <div class="item-info">
                <span class="item-name">{{ item.productName }}</span>
                <span class="item-spec">&yen;{{ formatMoney(item.price) }} &times; {{ item.quantity }}</span>
              </div>
              <span class="item-subtotal">&yen;{{ formatMoney(item.price * item.quantity) }}</span>
            </div>
            <div v-if="order.items.length > 2" class="items-more" @click="handleView(order)">
              ...查看全部 {{ order.items.length }} 件商品
            </div>
          </template>
          <div v-else class="items-skeleton">
            <div class="skeleton-row">
              <div class="skeleton-img" />
              <div class="skeleton-text">
                <div class="skeleton-line" />
                <div class="skeleton-line short" />
              </div>
            </div>
          </div>
        </div>

        <!-- 卡片底部 -->
        <div class="order-card-footer">
          <div class="footer-summary">
            共 <span class="count">{{ order.totalQuantity || '-' }}</span> 件商品
            合计：<span class="amount">&yen;{{ formatMoney(order.totalAmount) }}</span>
          </div>
          <div class="footer-actions">
            <el-button type="primary" link @click="handleView(order)">查看详情</el-button>
            <el-button v-if="order.status === 'PENDING'" class="btn-pay" @click="handlePay(order)">去支付</el-button>
            <el-button v-if="order.status === 'SHIPPED'" class="btn-receive" @click="handleConfirmReceive(order)">确认收货</el-button>
            <el-button v-if="order.status === 'PENDING'" type="info" link @click="handleCancel(order)">取消订单</el-button>
            <el-dropdown v-if="['PAID','SHIPPED','DELIVERED'].includes(order.status)"
                         trigger="click" @command="(type) => handleAfterSales(order, type)">
              <el-button type="warning" link>
                申请售后 <el-icon style="margin-left:2px; vertical-align: middle"><ArrowDown /></el-icon>
              </el-button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item v-if="['PAID','SHIPPED'].includes(order.status)" command="REFUND">仅退款</el-dropdown-item>
                  <el-dropdown-item v-if="['SHIPPED','DELIVERED'].includes(order.status)" command="EXCHANGE">退货退款</el-dropdown-item>
                  <el-dropdown-item command="COMPLAINT">投诉</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </div>
      </div>
    </div>

    <!-- 分页 -->
    <el-pagination
      v-if="total > 0"
      v-model:current-page="queryParams.pageNum"
      v-model:page-size="queryParams.pageSize"
      :page-sizes="[10, 20, 50]"
      :total="total"
      layout="total, sizes, prev, pager, next, jumper"
      class="pagination-bar"
      @size-change="loadData"
      @current-change="loadData"
    />

    <!-- 订单详情弹窗 -->
    <el-dialog v-model="detailDialogVisible" title="订单详情" width="750px" destroy-on-close class="detail-dialog">
      <!-- 订单进度条 -->
      <div v-if="!['CANCELLED','REFUNDED'].includes(currentOrder.status)" class="order-progress">
        <el-steps :active="orderProgressStep" finish-status="success" align-center>
          <el-step title="下单" :description="formatDate(currentOrder.createTime)" />
          <el-step title="付款" :description="formatDate(currentOrder.payTime) || '待付款'" />
          <el-step title="发货" :description="formatDate(currentOrder.shipTime) || '待发货'" />
          <el-step title="签收" :description="currentOrder.status === 'DELIVERED' ? '已签收' : '待签收'" />
        </el-steps>
      </div>
      <!-- 已取消/已退款横幅 -->
      <div v-else class="status-banner" :class="'banner-' + (currentOrder.status || '').toLowerCase()">
        {{ currentOrder.status === 'CANCELLED' ? '订单已取消' : '订单已退款' }}
      </div>

      <!-- 基础信息 -->
      <el-descriptions :column="2" border class="detail-descriptions">
        <el-descriptions-item label="订单号">{{ currentOrder.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="总金额">
          <span class="detail-amount">&yen;{{ formatMoney(currentOrder.totalAmount) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ formatDate(currentOrder.createTime) }}</el-descriptions-item>
        <el-descriptions-item label="付款时间">{{ formatDate(currentOrder.payTime) || '-' }}</el-descriptions-item>
        <el-descriptions-item label="收货地址" :span="2">{{ currentOrder.address || '-' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ currentOrder.remark || '-' }}</el-descriptions-item>
      </el-descriptions>

      <!-- 物流信息卡片 -->
      <div v-if="currentOrder.logisticsNo" class="logistics-card">
        <div class="logistics-header">物流信息</div>
        <div class="logistics-body">
          <div class="logistics-row">
            <span class="logistics-label">物流公司</span>
            <span>{{ currentOrder.logisticsCompany || '-' }}</span>
          </div>
          <div class="logistics-row">
            <span class="logistics-label">物流单号</span>
            <span class="logistics-no">{{ currentOrder.logisticsNo }}</span>
          </div>
        </div>
      </div>

      <!-- 订单商品 -->
      <div v-if="orderItems.length > 0" class="detail-items-section">
        <div class="detail-items-title">订单商品</div>
        <div class="detail-items-list">
          <div v-for="item in orderItems" :key="item.itemId" class="detail-item-block">
            <!-- 商品行 -->
            <div class="detail-item-row">
              <img v-if="item.imageUrl" :src="item.imageUrl" class="detail-item-img" />
              <div v-else class="detail-item-img-placeholder" />
              <div class="detail-item-info">
                <span class="detail-item-name">{{ item.productName }}</span>
                <span class="detail-item-spec">&yen;{{ formatMoney(item.price) }} &times; {{ item.quantity }}</span>
              </div>
              <div class="detail-item-right">
                <span class="detail-item-subtotal">&yen;{{ formatMoney(item.price * item.quantity) }}</span>
                <!-- 评价指示器：内联在商品行右侧 -->
                <div v-if="currentOrder.status === 'DELIVERED'" class="detail-item-review-badge">
                  <template v-if="item.reviewed">
                    <div
                      class="review-indicator"
                      :class="{ 'is-expanded': isReviewExpanded(item.itemId) }"
                      @click="toggleReviewExpand(item.itemId)"
                    >
                      <el-rate
                        :model-value="item.reviewRating"
                        disabled
                        size="small"
                        class="review-indicator-stars"
                      />
                      <span class="review-indicator-text">{{ ratingLabels[item.reviewRating] || '已评价' }}</span>
                      <el-icon class="review-indicator-arrow">
                        <component :is="isReviewExpanded(item.itemId) ? ArrowUp : ArrowDown" />
                      </el-icon>
                    </div>
                  </template>
                  <el-button
                    v-else
                    type="warning"
                    size="small"
                    round
                    class="review-write-btn"
                    @click="openReviewDialog(item)"
                  >
                    <el-icon style="margin-right: 4px"><EditPen /></el-icon>
                    写评价
                  </el-button>
                </div>
              </div>
            </div>

            <!-- 评价展开区域 -->
            <Transition name="review-expand">
              <div v-if="item.reviewed && isReviewExpanded(item.itemId)" class="review-expand-panel">
                <div class="review-expand-body">
                  <div class="review-expand-rating-row">
                    <el-rate :model-value="item.reviewRating" disabled />
                    <span class="review-rating-label">{{ ratingLabels[item.reviewRating] }}</span>
                    <span class="review-expand-time">{{ formatDate(item.reviewCreateTime) }}</span>
                  </div>
                  <div v-if="item.reviewContent" class="review-expand-text">{{ item.reviewContent }}</div>
                  <div v-else class="review-expand-text review-no-content">用户未填写评价内容</div>
                  <div v-if="item.reviewAdminReply" class="review-admin-reply-box">
                    <div class="reply-header">
                      <el-icon><Service /></el-icon>
                      <span class="reply-label">商家回复</span>
                    </div>
                    <div class="reply-content">{{ item.reviewAdminReply }}</div>
                  </div>
                </div>
              </div>
            </Transition>
          </div>
          <div class="detail-item-total">
            合计：<span class="amount">&yen;{{ formatMoney(currentOrder.totalAmount) }}</span>
          </div>
        </div>
      </div>

      <template #footer>
        <div style="display: flex; justify-content: space-between; align-items: center; width: 100%">
          <div style="display: flex; gap: 10px">
            <el-button v-if="currentOrder.status === 'PENDING'" class="btn-pay" @click="handlePayFromDetail">去支付</el-button>
            <el-button v-if="currentOrder.status === 'PENDING'" type="info" link @click="handleCancelFromDetail">取消订单</el-button>
            <el-button v-if="currentOrder.status === 'SHIPPED'" class="btn-receive" @click="handleConfirmReceiveFromDetail">确认收货</el-button>
          </div>
          <el-button @click="detailDialogVisible = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 统一支付弹窗 -->
    <PayDialog
      v-model:visible="payDialogVisible"
      :loading="payLoading"
      :order-no="payOrder.orderNo"
      :total-amount="formatMoney(payOrder.totalAmount)"
      :product-summary="payOrder.productSummary"
      @confirm="handlePayConfirm"
    />

    <!-- 评价弹窗 -->
    <el-dialog v-model="reviewDialogVisible" title="商品评价" width="480px" destroy-on-close>
      <!-- 商品信息卡片 -->
      <div class="review-product-card">
        <img v-if="reviewForm.imageUrl" :src="reviewForm.imageUrl" class="review-product-img" />
        <div v-else class="review-product-img review-product-img-placeholder" />
        <div class="review-product-info">
          <div class="review-product-name">{{ reviewForm.productName }}</div>
          <div class="review-product-price">
            &yen;{{ formatMoney(reviewForm.price) }}
            <span class="review-product-qty">&times; {{ reviewForm.quantity }}</span>
          </div>
        </div>
      </div>
      <el-form label-width="60px" style="margin-top: 16px">
        <el-form-item label="评分">
          <el-rate v-model="reviewForm.rating" show-text :texts="['很差', '较差', '一般', '满意', '非常满意']" />
        </el-form-item>
        <el-form-item label="评价">
          <el-input v-model="reviewForm.content" type="textarea" :rows="4" placeholder="分享您的使用体验..." />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="reviewDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="reviewLoading" @click="submitReviewAction">提交评价</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { myOrders, myOrderDetail, myUpdateOrderStatus, myOrderStats } from '@/api/business/order'
import { submitReview, getReviewByItemId } from '@/api/business/review'
import { StarFilled, ArrowDown, ArrowUp, EditPen, Service } from '@element-plus/icons-vue'
import { formatDate, formatMoney, orderStatusMap } from '@/utils/format'
import PayDialog from '@/components/PayDialog/index.vue'

const router = useRouter()
const route = useRoute()

// 基础状态
const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const detailDialogVisible = ref(false)
const currentOrder = ref({})
const orderItems = ref([])
const highlightOrderId = ref(null)
const queryParams = reactive({ orderNo: '', status: '', pageNum: 1, pageSize: 10 })

// 统计相关
const orderStats = ref({})
const activeStatusTab = ref('')

const statusTabs = computed(() => [
  { key: '', label: '全部', count: orderStats.value.totalCount || 0 },
  { key: 'PENDING', label: '待付款', count: orderStats.value.pendingCount || 0 },
  { key: 'PAID', label: '已付款', count: orderStats.value.paidCount || 0 },
  { key: 'SHIPPED', label: '已发货', count: orderStats.value.shippedCount || 0 },
  { key: 'DELIVERED', label: '已签收', count: orderStats.value.deliveredCount || 0 },
  { key: 'CANCELLED', label: '已取消', count: orderStats.value.cancelledCount || 0 },
  { key: 'REFUNDED', label: '已退款', count: orderStats.value.refundedCount || 0 }
])

// 详情弹窗进度
const orderProgressStep = computed(() => {
  const s = currentOrder.value.status
  if (s === 'PENDING') return 1    // 下单✅ → 付款🔵(等待中)
  if (s === 'PAID') return 2       // 下单✅ 付款✅ → 发货🔵(等待中)
  if (s === 'SHIPPED') return 3    // 下单✅ 付款✅ 发货✅ → 签收🔵(等待中)
  if (s === 'DELIVERED') return 4  // 全部✅
  return 0
})

// 获取展示的商品（列表中最多显示2个）
const getDisplayItems = (order) => {
  if (!order.items) return []
  return order.items.slice(0, 2)
}

// 数据加载
const loadStats = async () => {
  try {
    const res = await myOrderStats()
    orderStats.value = res.data || {}
  } catch { /* 统计加载失败不影响主流程 */ }
}

const enrichOrderItems = async () => {
  await Promise.allSettled(
    tableData.value.map(async (order) => {
      try {
        const res = await myOrderDetail(order.orderId)
        const data = res.data || {}
        order.items = data.items || []
        order.totalQuantity = order.items.reduce((s, i) => s + i.quantity, 0)
      } catch {
        order.items = []
        order.totalQuantity = 0
      }
    })
  )
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await myOrders(queryParams)
    tableData.value = res.rows || []
    total.value = res.total || 0
    enrichOrderItems() // 异步填充商品，不阻塞渲染
  } finally { loading.value = false }
}

const handleSearch = () => { queryParams.pageNum = 1; loadData() }
const resetQuery = () => {
  queryParams.orderNo = ''
  queryParams.status = ''
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

// 查看详情
const handleView = async (row) => {
  const res = await myOrderDetail(row.orderId)
  const data = res.data || {}
  currentOrder.value = data.order || row
  orderItems.value = data.items || []
  expandedReviewItems.value = new Set()
  if (currentOrder.value.status === 'DELIVERED') {
    await Promise.allSettled(
      orderItems.value.map(async (item) => {
        try {
          const reviewRes = await getReviewByItemId(item.itemId)
          if (reviewRes.data) {
            item.reviewed = true
            item.reviewRating = reviewRes.data.rating
            item.reviewContent = reviewRes.data.content
            item.reviewAdminReply = reviewRes.data.adminReply
            item.reviewCreateTime = reviewRes.data.createTime
          } else {
            item.reviewed = false
          }
        } catch { item.reviewed = false }
      })
    )
  }
  detailDialogVisible.value = true
}

// 评价相关
const reviewDialogVisible = ref(false)
const reviewLoading = ref(false)
const reviewForm = reactive({ orderItemId: null, productName: '', imageUrl: '', price: 0, quantity: 0, rating: 5, content: '' })

// 评价展开/收起控制
const expandedReviewItems = ref(new Set())
const ratingLabels = { 1: '很差', 2: '较差', 3: '一般', 4: '满意', 5: '非常满意' }

const toggleReviewExpand = (itemId) => {
  const set = new Set(expandedReviewItems.value)
  if (set.has(itemId)) {
    set.delete(itemId)
  } else {
    set.add(itemId)
  }
  expandedReviewItems.value = set
}

const isReviewExpanded = (itemId) => {
  return expandedReviewItems.value.has(itemId)
}

const openReviewDialog = (item) => {
  reviewForm.orderItemId = item.itemId
  reviewForm.productName = item.productName
  reviewForm.imageUrl = item.imageUrl || ''
  reviewForm.price = item.price
  reviewForm.quantity = item.quantity
  reviewForm.rating = 5
  reviewForm.content = ''
  reviewDialogVisible.value = true
}

const submitReviewAction = async () => {
  if (!reviewForm.rating) { ElMessage.warning('请选择评分'); return }
  reviewLoading.value = true
  try {
    await submitReview({ orderItemId: reviewForm.orderItemId, rating: reviewForm.rating, content: reviewForm.content })
    ElMessage.success('评价提交成功')
    reviewDialogVisible.value = false
    const item = orderItems.value.find(i => i.itemId === reviewForm.orderItemId)
    if (item) {
      item.reviewed = true
      item.reviewRating = reviewForm.rating
      item.reviewContent = reviewForm.content
      item.reviewAdminReply = null
      item.reviewCreateTime = new Date().toISOString()
    }
  } catch (e) { ElMessage.error(e.message || '评价提交失败') }
  finally { reviewLoading.value = false }
}

// 模拟支付
const payDialogVisible = ref(false)
const payLoading = ref(false)
const payMethod = ref('alipay')
const payOrder = ref({})

const handlePay = (row) => {
  payOrder.value = { orderId: row.orderId, orderNo: row.orderNo, totalAmount: row.totalAmount, productSummary: row.productSummary || row.orderNo }
  payMethod.value = 'alipay'
  payDialogVisible.value = true
}

const confirmPay = async () => {
  payLoading.value = true
  try {
    await new Promise(resolve => setTimeout(resolve, 1000))
    await myUpdateOrderStatus(payOrder.value.orderId, 'PAID')
    ElMessage.success('支付成功')
    payDialogVisible.value = false
    loadData()
    loadStats()
  } catch (e) { ElMessage.error(e.message || '支付失败，请重试') }
  finally { payLoading.value = false }
}

const handlePayConfirm = (method) => {
  payMethod.value = method
  confirmPay()
}

const handleConfirmReceive = (row) => {
  ElMessageBox.confirm('确认已收到该订单商品？', '确认收货', { type: 'info' }).then(async () => {
    await myUpdateOrderStatus(row.orderId, 'DELIVERED')
    ElMessage.success('已确认收货')
    loadData()
    loadStats()
  }).catch(() => {})
}

const handleCancel = (row) => {
  ElMessageBox.confirm('确认取消该订单？取消后不可恢复。', '取消订单', { type: 'warning' }).then(async () => {
    await myUpdateOrderStatus(row.orderId, 'CANCELLED')
    ElMessage.success('订单已取消')
    loadData()
    loadStats()
  }).catch(() => {})
}

// 从详情弹窗发起支付
const handlePayFromDetail = () => {
  const order = currentOrder.value
  detailDialogVisible.value = false
  nextTick(() => {
    setTimeout(() => {
      handlePay(order)
    }, 350)
  })
}

// 从详情弹窗取消订单
const handleCancelFromDetail = () => {
  ElMessageBox.confirm('确认取消该订单？取消后不可恢复。', '取消订单', { type: 'warning' }).then(async () => {
    await myUpdateOrderStatus(currentOrder.value.orderId, 'CANCELLED')
    ElMessage.success('订单已取消')
    detailDialogVisible.value = false
    loadData()
    loadStats()
  }).catch(() => {})
}

// 从详情弹窗确认收货
const handleConfirmReceiveFromDetail = () => {
  ElMessageBox.confirm('确认已收到该订单商品？', '确认收货', { type: 'info' }).then(async () => {
    await myUpdateOrderStatus(currentOrder.value.orderId, 'DELIVERED')
    ElMessage.success('已确认收货')
    detailDialogVisible.value = false
    loadData()
    loadStats()
  }).catch(() => {})
}

const handleAfterSales = (row, type = 'REFUND') => {
  router.push({ path: '/customer/tickets', query: { action: 'create', orderId: row.orderId, type } })
}

// 从通知跳转定位到具体订单
const locateOrder = async () => {
  const targetId = route.query.orderId
  if (!targetId) return
  highlightOrderId.value = Number(targetId)
  await nextTick()
  const el = document.getElementById('order-' + targetId)
  if (el) {
    el.scrollIntoView({ behavior: 'smooth', block: 'center' })
    const order = tableData.value.find(o => o.orderId == targetId)
    if (order) handleView(order)
  }
  setTimeout(() => { highlightOrderId.value = null }, 4000)
}

onMounted(async () => {
  await loadData()
  loadStats()
  locateOrder()
})

// 已在订单页时再次从通知跳转，监听 query 变化
watch(() => route.query.orderId, (newVal) => {
  if (newVal) locateOrder()
})
</script>

<style scoped>
/* === 容器 === */
.app-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 24px;
  min-height: calc(100vh - 84px);
  background-color: #f5f7fa;
}

/* === 搜索栏 === */
.search-bar {
  background: #fff;
  padding: 18px 20px 2px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  margin-bottom: 16px;
  border: 1px solid #ebeef5;
}

/* === 统计 Tab 栏 === */
.order-stats-bar {
  display: flex;
  background: #fff;
  border-radius: 12px;
  margin-bottom: 16px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
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
.stats-tab-dot {
  position: absolute;
  top: 10px;
  right: calc(50% - 20px);
  width: 8px;
  height: 8px;
  background: #f56c6c;
  border-radius: 50%;
  animation: pulse 2s infinite;
}

/* === 待付金额提示 === */
.pending-amount-tip {
  background: linear-gradient(135deg, #fff5f5, #fff0f0);
  border: 1px solid #fde2e2;
  border-radius: 10px;
  padding: 10px 20px;
  margin-bottom: 16px;
  font-size: 14px;
  color: #606266;
}
.pending-amount-tip .amount {
  color: #f56c6c;
  font-weight: 700;
  font-size: 18px;
}

/* === 订单卡片列表 === */
.order-card-list {
  min-height: 200px;
}
.order-card {
  background: #fff;
  border-radius: 16px;
  border: 1px solid #eef0f4;
  box-shadow: 0 2px 8px rgba(0,0,0,0.03), 0 1px 2px rgba(0,0,0,0.02);
  margin-bottom: 16px;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  animation: fadeSlideUp 0.5s ease both;
}
.order-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 12px 28px rgba(0,0,0,0.08), 0 4px 10px rgba(0,0,0,0.04);
  border-color: rgba(64, 158, 255, 0.2);
}

/* 卡片头部 */
.order-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 20px;
  background: linear-gradient(135deg, #fafbfd 0%, #f5f7fa 100%);
  border-bottom: 1px solid #f0f2f5;
}
.header-left {
  display: flex;
  align-items: center;
  gap: 8px;
}
.order-no-label {
  font-size: 14px;
  color: #909399;
}
.order-no {
  font-family: 'SF Mono', Consolas, 'Courier New', monospace;
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}
.order-time {
  font-size: 13px;
  color: #b0b5bd;
  margin-left: 8px;
}

/* 卡片主体 */
.order-card-body {
  padding: 12px 20px;
}
.order-item-row {
  display: flex;
  align-items: center;
  padding: 10px 0;
  gap: 14px;
}
.order-item-row.has-border {
  border-bottom: 1px solid #f2f6fc;
}
.item-img {
  width: 64px;
  height: 64px;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid #ebeef5;
  flex-shrink: 0;
}
.item-img-placeholder {
  width: 64px;
  height: 64px;
  background: #f5f7fa;
  border-radius: 8px;
  flex-shrink: 0;
}
.item-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}
.item-name {
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}
.item-spec {
  font-size: 13px;
  color: #909399;
}
.item-subtotal {
  font-size: 15px;
  color: #303133;
  font-weight: 600;
}
.items-more {
  text-align: center;
  padding: 8px 0;
  font-size: 13px;
  color: #409eff;
  cursor: pointer;
}
.items-more:hover {
  text-decoration: underline;
}

/* 骨架占位 */
.items-skeleton {
  padding: 10px 0;
}
.skeleton-row {
  display: flex;
  align-items: center;
  gap: 14px;
}
.skeleton-img {
  width: 64px;
  height: 64px;
  background: linear-gradient(90deg, #f2f2f2 25%, #e6e6e6 50%, #f2f2f2 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 8px;
  flex-shrink: 0;
}
.skeleton-text {
  flex: 1;
}
.skeleton-line {
  height: 14px;
  background: linear-gradient(90deg, #f2f2f2 25%, #e6e6e6 50%, #f2f2f2 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 4px;
  margin-bottom: 8px;
  width: 80%;
}
.skeleton-line.short {
  width: 50%;
}

/* 卡片底部 */
.order-card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 20px;
  background: linear-gradient(135deg, #fafbfd 0%, #f8f9fb 100%);
  border-top: 1px solid #f0f2f5;
  flex-wrap: wrap;
  gap: 10px;
}
.footer-summary {
  font-size: 14px;
  color: #606266;
}
.footer-summary .count {
  font-weight: 600;
  color: #303133;
}
.footer-summary .amount {
  font-size: 18px;
  font-weight: 700;
  color: #f56c6c;
}
.footer-actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  align-items: center;
}

/* 按钮样式覆盖 */
.footer-actions :deep(.el-button) {
  border-radius: 20px;
  padding: 8px 18px;
  font-size: 13px;
  font-weight: 500;
}
/* 去支付按钮 */
.btn-pay {
  background: linear-gradient(135deg, #ff6b6b, #ee5a24) !important;
  border: none !important;
  color: #fff !important;
  box-shadow: 0 3px 10px rgba(238, 90, 36, 0.3);
  transition: all 0.3s ease !important;
}
.btn-pay:hover {
  background: linear-gradient(135deg, #ff8787, #ff6b6b) !important;
  transform: translateY(-1px);
  box-shadow: 0 5px 15px rgba(238, 90, 36, 0.4);
}
/* 确认收货按钮 */
.btn-receive {
  background: linear-gradient(135deg, #51cf66, #37b24d) !important;
  border: none !important;
  color: #fff !important;
  box-shadow: 0 3px 10px rgba(55, 178, 77, 0.3);
  transition: all 0.3s ease !important;
}
.btn-receive:hover {
  background: linear-gradient(135deg, #69db7c, #51cf66) !important;
  transform: translateY(-1px);
  box-shadow: 0 5px 15px rgba(55, 178, 77, 0.4);
}

/* === 分页 === */
.pagination-bar {
  margin-top: 16px;
  justify-content: flex-end;
  background: #fff;
  padding: 16px 20px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  border: 1px solid #ebeef5;
}

/* === 详情弹窗 === */
.order-progress {
  margin-bottom: 24px;
  padding: 20px 10px;
  background: #f8f9fb;
  border-radius: 10px;
}
.status-banner {
  text-align: center;
  padding: 16px;
  border-radius: 10px;
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 20px;
}
.banner-cancelled {
  background: #f4f4f5;
  color: #909399;
}
.banner-refunded {
  background: #fef0f0;
  color: #f56c6c;
}
.detail-descriptions {
  margin-bottom: 20px;
}
.detail-amount {
  color: #f56c6c;
  font-weight: 700;
  font-size: 16px;
}

/* 物流信息卡片 */
.logistics-card {
  background: #f8f9fb;
  border-radius: 10px;
  padding: 16px 20px;
  margin-bottom: 20px;
  border: 1px solid #ebeef5;
}
.logistics-header {
  font-weight: 600;
  color: #303133;
  margin-bottom: 12px;
  font-size: 15px;
}
.logistics-body {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.logistics-row {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 14px;
}
.logistics-label {
  color: #909399;
  min-width: 70px;
}
.logistics-no {
  font-family: 'SF Mono', Consolas, monospace;
  color: #409eff;
}

/* 详情商品列表 */
.detail-items-section {
  margin-top: 20px;
}
.detail-items-title {
  font-weight: 600;
  font-size: 15px;
  color: #303133;
  margin-bottom: 12px;
}
.detail-items-list {
  border: 1px solid #ebeef5;
  border-radius: 10px;
  overflow: hidden;
}
.detail-item-block {
  border-bottom: 1px solid #f2f6fc;
}
.detail-item-block:last-of-type {
  border-bottom: none;
}
.detail-item-row {
  display: flex;
  align-items: center;
  padding: 14px 16px;
  gap: 14px;
  transition: background 0.2s;
}
.detail-item-row:hover {
  background: #fafafa;
}
.detail-item-img {
  width: 56px;
  height: 56px;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid #ebeef5;
  flex-shrink: 0;
}
.detail-item-img-placeholder {
  width: 56px;
  height: 56px;
  background: #f5f7fa;
  border-radius: 8px;
  flex-shrink: 0;
}
.detail-item-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}
.detail-item-name {
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}
.detail-item-spec {
  font-size: 13px;
  color: #909399;
}
.detail-item-subtotal {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
  flex-shrink: 0;
}
/* ===== 商品行右侧容器 ===== */
.detail-item-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 8px;
  flex-shrink: 0;
}
/* ===== 评价内联指示器 ===== */
.detail-item-review-badge {
  display: flex;
  align-items: center;
}
.review-indicator {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px 4px 6px;
  border-radius: 20px;
  background: #f0f9eb;
  border: 1px solid #e1f3d8;
  cursor: pointer;
  transition: all 0.25s ease;
  user-select: none;
}
.review-indicator:hover {
  background: #e1f3d8;
  border-color: #b3e19d;
  box-shadow: 0 2px 8px rgba(103, 194, 58, 0.15);
}
.review-indicator.is-expanded {
  background: #ecf5ff;
  border-color: #b3d8ff;
}
.review-indicator.is-expanded:hover {
  background: #d9ecff;
  border-color: #a0cfff;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.15);
}
.review-indicator-stars {
  height: 16px;
  line-height: 16px;
}
.review-indicator-stars :deep(.el-rate__icon) {
  font-size: 14px !important;
  margin-right: 1px !important;
}
.review-indicator-text {
  font-size: 12px;
  color: #67c23a;
  font-weight: 500;
  white-space: nowrap;
}
.review-indicator.is-expanded .review-indicator-text {
  color: #409eff;
}
.review-indicator-arrow {
  font-size: 12px;
  color: #909399;
  transition: transform 0.3s ease;
}
.review-indicator.is-expanded .review-indicator-arrow {
  color: #409eff;
}
/* 写评价按钮美化 */
.review-write-btn {
  border-radius: 20px !important;
  font-size: 12px !important;
  padding: 0 14px !important;
  height: 28px !important;
  background: linear-gradient(135deg, #fdf6ec, #fef0e0) !important;
  border: 1px solid #f5dab1 !important;
  color: #e6a23c !important;
  transition: all 0.25s ease !important;
}
.review-write-btn:hover {
  background: linear-gradient(135deg, #fef0e0, #fde2c0) !important;
  border-color: #e6a23c !important;
  box-shadow: 0 2px 8px rgba(230, 162, 60, 0.2) !important;
  transform: translateY(-1px);
}
.detail-item-total {
  text-align: right;
  padding: 14px 16px;
  border-top: 1px solid #ebeef5;
  font-size: 14px;
  color: #606266;
  background: #f8f9fb;
}
.detail-item-total .amount {
  font-size: 18px;
  font-weight: 700;
  color: #f56c6c;
}

/* === 评价展开面板（卡片式） === */
.review-expand-panel {
  margin: 0 16px 12px 16px;
  border-radius: 10px;
  background: linear-gradient(135deg, #fafbfc 0%, #f5f8ff 100%);
  border: 1px solid #e8ecf0;
  overflow: hidden;
}
.review-expand-body {
  padding: 16px 18px;
}
.review-expand-rating-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eef0f5;
}
.review-rating-label {
  font-size: 14px;
  color: #e6a23c;
  font-weight: 600;
}
.review-expand-time {
  font-size: 12px;
  color: #c0c4cc;
  margin-left: auto;
}
.review-expand-text {
  font-size: 14px;
  color: #4e5969;
  line-height: 1.7;
  margin-bottom: 12px;
  padding: 10px 14px;
  background: rgba(255, 255, 255, 0.7);
  border-radius: 8px;
  border: 1px solid #f0f2f5;
}
.review-expand-text.review-no-content {
  color: #c0c4cc;
  font-style: italic;
  background: transparent;
  border: 1px dashed #e8ecf0;
}
.review-admin-reply-box {
  padding: 12px 14px;
  background: linear-gradient(135deg, #ecf5ff, #f0f7ff);
  border-radius: 8px;
  border: 1px solid #d9ecff;
  border-left: 3px solid #409eff;
}
.reply-header {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-bottom: 6px;
  font-size: 13px;
  font-weight: 600;
  color: #337ecc;
}
.reply-header .el-icon {
  font-size: 14px;
  color: #409eff;
}
.reply-content {
  font-size: 13px;
  color: #606266;
  line-height: 1.7;
  padding-left: 20px;
}

/* 展开/收起动画 */
.review-expand-enter-active {
  transition: all 0.3s ease;
  overflow: hidden;
}
.review-expand-leave-active {
  transition: all 0.2s ease;
  overflow: hidden;
}
.review-expand-enter-from,
.review-expand-leave-to {
  opacity: 0;
  max-height: 0;
  padding-top: 0;
  padding-bottom: 0;
}

/* === 评价弹窗商品卡片 === */
.review-product-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: #f8f9fb;
  border-radius: 10px;
  border: 1px solid #ebeef5;
}
.review-product-img {
  width: 64px;
  height: 64px;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid #ebeef5;
  flex-shrink: 0;
}
.review-product-img-placeholder {
  background: #f0f2f5;
}
.review-product-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}
.review-product-name {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.review-product-price {
  font-size: 16px;
  color: #f56c6c;
  font-weight: 600;
}
.review-product-qty {
  font-size: 13px;
  color: #909399;
  font-weight: 400;
}

/* === 支付弹窗 === */
.pay-info {
  background: #f8f9fb;
  border-radius: 10px;
  padding: 16px 20px;
}
.pay-row {
  display: flex;
  align-items: center;
  padding: 6px 0;
}
.pay-label {
  color: #909399;
  min-width: 80px;
  font-size: 14px;
}

/* === 空状态 === */
.empty-state {
  padding: 60px 0;
  text-align: center;
}

/* === 标签优化 === */
:deep(.el-tag) {
  border-radius: 20px;
  padding: 0 12px;
  height: 28px;
  line-height: 26px;
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
@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}

/* === 通知跳转高亮 === */
.order-card.highlight-target {
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
</style>
