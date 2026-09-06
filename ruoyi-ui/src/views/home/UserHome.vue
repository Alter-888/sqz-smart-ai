<template>
  <div class="user-home">
    <!-- Section 1: 动态欢迎横幅 -->
    <div class="welcome-banner">
      <div class="welcome-main">
        <div class="welcome-left">
          <div class="avatar-wrapper">
            <el-avatar :size="52" :src="avatar">
              <el-icon :size="24"><User /></el-icon>
            </el-avatar>
          </div>
          <div class="greeting-text">
            <h2>{{ greeting }}，{{ nickName }}！</h2>
            <p class="date-text">{{ currentDate }}</p>
          </div>
        </div>
      </div>
      <div class="welcome-right">
        <el-button size="large" round class="chat-btn" @click="$router.push('/customer/chat')">
          <el-icon><ChatDotRound /></el-icon>
          开始 AI 对话
        </el-button>
      </div>
      <p class="banner-slogan">智能客服 · 数码精选 · 一站式服务</p>
    </div>

    <!-- Section 2: 个人统计卡片 -->
    <el-row :gutter="16" class="stats-row">
      <el-col :xs="12" :sm="12" :lg="6" v-for="(item, index) in statCards" :key="item.key">
        <div
          class="stat-card"
          :style="{ animationDelay: (index * 0.15) + 's', '--accent-color': item.borderColor }"
          @click="$router.push(item.path)"
        >
          <div class="stat-icon-box" :class="{ pulse: item.hasPulse }" :style="{ background: item.gradient }">
            <el-icon :size="26"><component :is="item.icon" /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ item.display }}</div>
            <div class="stat-label">{{ item.label }}</div>
            <div class="stat-sub" v-if="item.sub">{{ item.sub }}</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 数据概览条已移至底部ECharts饼图 -->

    <!-- Section 2.5: 热门商品 -->
    <div class="recommend-card" v-if="recommendProducts.length > 0">
      <div class="recent-header">
        <span class="recent-title-text">热门商品</span>
        <span class="recent-link" @click="$router.push('/customer/products')">查看全部 &rarr;</span>
      </div>
      <div class="product-scroll-wrapper">
        <div class="product-scroll">
          <div
            v-for="item in recommendProducts"
            :key="item.productId"
            class="home-product-card"
            @click="$router.push('/customer/products?highlight=' + item.productId)"
          >
            <div class="product-img-box">
              <img v-if="item.imageUrl" :src="item.imageUrl" class="product-img" />
              <div v-else class="product-img product-img-placeholder">
                <el-icon :size="28"><Goods /></el-icon>
              </div>
            </div>
            <div class="product-info">
              <div class="product-name">{{ item.name }}</div>
              <div class="product-meta" v-if="item.salesCount > 0">
                已售 {{ item.salesCount > 999 ? (item.salesCount / 1000).toFixed(1) + 'k' : item.salesCount }}
              </div>
              <div class="product-price-row">
                <span class="product-price">&yen;{{ Number(item.price).toFixed(2) }}</span>
                <el-button type="warning" size="small" circle @click.stop="handleAddToCart(item)">
                  <el-icon><ShoppingCart /></el-icon>
                </el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Section 3: 待办提醒 -->
    <div class="todo-card" v-if="todoItems.length > 0">
      <div class="recent-header">
        <span class="recent-title-text">待办提醒</span>
        <el-tag size="small" type="danger" round>{{ todoItems.length }}</el-tag>
      </div>
      <div class="todo-body">
        <div
          v-for="(item, index) in todoItems"
          :key="item.key"
          class="todo-item"
          :style="{ animationDelay: (index * 0.08) + 's' }"
        >
          <div class="todo-left">
            <div class="todo-dot" :style="{ backgroundColor: item.color }"></div>
            <div class="todo-info">
              <span class="todo-title">{{ item.title }}</span>
              <span class="todo-desc">{{ item.desc }}</span>
            </div>
          </div>
          <el-button size="small" type="primary" plain round @click="$router.push(item.path)">
            {{ item.action }}
          </el-button>
        </div>
      </div>
    </div>

    <!-- Section 4: 我的动态（Tab切换） -->
    <div class="recent-card recent-row">
      <div class="recent-header">
        <div class="recent-tabs">
          <span class="recent-tab" :class="{ active: activeRecentTab === 'orders' }" @click="activeRecentTab = 'orders'">最近订单</span>
          <span class="recent-tab" :class="{ active: activeRecentTab === 'tickets' }" @click="activeRecentTab = 'tickets'">最近工单</span>
        </div>
        <span class="recent-link" @click="$router.push(activeRecentTab === 'orders' ? '/customer/orders' : '/customer/tickets')">查看全部 &rarr;</span>
      </div>
      <div class="recent-body">
        <!-- 订单 Tab -->
        <template v-if="activeRecentTab === 'orders'">
          <div v-if="recentOrders.length === 0" class="empty-state">
            <el-icon :size="48" color="#dcdfe6"><Document /></el-icon>
            <p class="empty-main">暂无订单记录</p>
            <p class="empty-sub">去商城看看，发现你喜欢的好物~</p>
            <el-button size="small" type="primary" plain round @click="$router.push('/customer/products')">
              <el-icon><Goods /></el-icon>浏览商品
            </el-button>
          </div>
          <div
            v-for="(item, index) in recentOrders.slice(0, 5)"
            :key="item.orderId"
            class="timeline-item"
            :style="{ animationDelay: (index * 0.1) + 's' }"
          >
            <div class="timeline-dot" :style="{ backgroundColor: getOrderColor(item.status) }"></div>
            <div class="timeline-line" v-if="index < Math.min(recentOrders.length, 5) - 1"></div>
            <div class="timeline-content">
              <div class="timeline-top">
                <span class="item-no">{{ item.orderNo }}</span>
                <el-tag size="small" :type="orderStatusMap[item.status]?.type || 'info'" round>
                  {{ orderStatusMap[item.status]?.label || item.status }}
                </el-tag>
              </div>
              <div class="timeline-bottom">
                <span class="item-amount">&yen;{{ Number(item.totalAmount).toFixed(2) }}</span>
                <span class="item-time">{{ formatDate(item.createTime) }}</span>
              </div>
            </div>
          </div>
        </template>
        <!-- 工单 Tab -->
        <template v-else>
          <div v-if="recentTickets.length === 0" class="empty-state">
            <el-icon :size="48" color="#dcdfe6"><Service /></el-icon>
            <p class="empty-main">暂无工单记录</p>
            <p class="empty-sub">遇到问题？随时提交工单~</p>
            <el-button size="small" type="primary" plain round @click="$router.push('/customer/tickets')">
              <el-icon><Document /></el-icon>提交工单
            </el-button>
          </div>
          <div
            v-for="(item, index) in recentTickets.slice(0, 5)"
            :key="item.ticketId"
            class="timeline-item"
            :style="{ animationDelay: (index * 0.1) + 's' }"
          >
            <div class="timeline-dot" :style="{ backgroundColor: getTicketColor(item.status) }"></div>
            <div class="timeline-line" v-if="index < Math.min(recentTickets.length, 5) - 1"></div>
            <div class="timeline-content">
              <div class="timeline-top">
                <span class="item-no">{{ item.ticketNo }}</span>
                <el-tag size="small" :type="ticketStatusMap[item.status]?.type || 'info'" round>
                  {{ ticketStatusMap[item.status]?.label || item.status }}
                </el-tag>
              </div>
              <div class="timeline-bottom">
                <span class="item-title-text">{{ item.title }}</span>
                <span class="item-time">{{ formatDate(item.createTime) }}</span>
              </div>
            </div>
          </div>
        </template>
      </div>
    </div>

    <!-- Section 5: 数据概览（ECharts饼图） -->
    <div class="overview-chart-card" v-if="orderSegments.length > 0 || ticketSegments.length > 0">
      <div class="recent-header">
        <span class="recent-title-text">数据概览</span>
      </div>
      <el-row :gutter="16" class="chart-row">
        <el-col :xs="24" :sm="12" v-if="orderSegments.length > 0">
          <div class="chart-title">订单状态分布</div>
          <div ref="orderChartRef" class="chart-container"></div>
        </el-col>
        <el-col :xs="24" :sm="12" v-if="ticketSegments.length > 0">
          <div class="chart-title">工单状态分布</div>
          <div ref="ticketChartRef" class="chart-container"></div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, nextTick, watch } from 'vue'
import * as echarts from 'echarts/core'
import { PieChart } from 'echarts/charts'
import { TooltipComponent, LegendComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'

echarts.use([PieChart, TooltipComponent, LegendComponent, CanvasRenderer])
import { User, ChatDotRound, Document, Service, Bell, Goods, ShoppingCart } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import useUserStore from '@/store/modules/user'
import useCartStore from '@/store/modules/cart'
import { listShopProducts } from '@/api/shop/product'
import { myOrders, myOrderStats } from '@/api/business/order'
import { myTickets, myTicketStats } from '@/api/business/ticket'
import { listSessions } from '@/api/ai/chat'
import { getUnreadCount } from '@/api/business/notification'
import { orderStatusMap, ticketStatusMap, formatDate } from '@/utils/format'

const userStore = useUserStore()
const cartStore = useCartStore()

// 用户信息
const nickName = computed(() => userStore.nickName || userStore.name || '用户')
const avatar = computed(() => userStore.avatar)

// 问候语（根据时段，带图标）
const greeting = computed(() => {
  const hour = new Date().getHours()
  if (hour < 6) return '\u{1F319} 夜深了'
  if (hour < 12) return '\u{1F305} 早上好'
  if (hour < 14) return '\u{2600}\uFE0F 中午好'
  if (hour < 18) return '\u{1F324}\uFE0F 下午好'
  return '\u{1F31B} 晚上好'
})

// 当前日期
const currentDate = computed(() => {
  const now = new Date()
  const weekDays = ['日', '一', '二', '三', '四', '五', '六']
  return `${now.getFullYear()}年${now.getMonth() + 1}月${now.getDate()}日 星期${weekDays[now.getDay()]}`
})

// 热门商品
const recommendProducts = ref([])

// 数据状态
const recentOrders = ref([])
const recentTickets = ref([])
const pendingOrderCount = ref(0)
const pendingOrderAmount = ref(0)
const pendingTicketCount = ref(0)
const chatSessionCount = ref(0)
const unreadCount = ref(0)
const loading = ref(true)

// 数字滚动动画
function useCountUp(targetRef, duration = 1500) {
  const displayValue = ref(0)
  watch(targetRef, (newVal) => {
    if (newVal === 0) { displayValue.value = 0; return }
    const start = displayValue.value
    const end = newVal
    const startTime = performance.now()
    function animate(currentTime) {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / duration, 1)
      const eased = 1 - Math.pow(1 - progress, 3)
      displayValue.value = Math.round(start + (end - start) * eased)
      if (progress < 1) requestAnimationFrame(animate)
    }
    requestAnimationFrame(animate)
  }, { immediate: true })
  return displayValue
}

const displayPendingOrders = useCountUp(pendingOrderCount)
const displayPendingTickets = useCountUp(pendingTicketCount)
const displayChatCount = useCountUp(chatSessionCount)
const displayUnread = useCountUp(unreadCount)

// 统计卡片（展示可操作数据）
const statCards = computed(() => [
  {
    key: 'pending-orders', label: '待付款', icon: Document,
    gradient: 'linear-gradient(135deg, #E6A23C, #f0c78a)',
    borderColor: '#E6A23C',
    hasPulse: pendingOrderCount.value > 0,
    display: displayPendingOrders.value,
    sub: pendingOrderCount.value > 0 && pendingOrderAmount.value > 0 ? `合计 ¥${pendingOrderAmount.value.toFixed(2)}` : '暂无待付款',
    path: '/customer/orders'
  },
  {
    key: 'pending-tickets', label: '待处理工单', icon: Service,
    gradient: 'linear-gradient(135deg, #F56C6C, #fab6b6)',
    borderColor: '#F56C6C',
    hasPulse: pendingTicketCount.value > 0,
    display: displayPendingTickets.value,
    sub: pendingTicketCount.value > 0 ? '需要您关注' : '暂无待处理',
    path: '/customer/tickets'
  },
  {
    key: 'chats', label: 'AI 对话', icon: ChatDotRound,
    gradient: 'linear-gradient(135deg, #67C23A, #95d475)',
    borderColor: '#67C23A',
    hasPulse: false,
    display: displayChatCount.value,
    sub: '智能助手',
    path: '/customer/chat'
  },
  {
    key: 'unread', label: '未读通知', icon: Bell,
    gradient: 'linear-gradient(135deg, #409EFF, #66b1ff)',
    borderColor: '#409EFF',
    hasPulse: unreadCount.value > 0,
    display: displayUnread.value,
    sub: unreadCount.value > 0 ? '条未读消息' : '暂无新消息',
    path: '/customer/notifications'
  }
])

// 统计数据（来自专用stats接口）
const orderStatsData = ref({})
const ticketStatsData = ref({})

// 数据概览条 - 订单状态分布（基于stats接口数据）
const orderSegments = computed(() => {
  const s = orderStatsData.value
  if (!s.totalCount) return []
  const entries = [
    { status: 'PENDING', count: s.pendingCount || 0 },
    { status: 'PAID', count: s.paidCount || 0 },
    { status: 'SHIPPED', count: s.shippedCount || 0 },
    { status: 'DELIVERED', count: s.deliveredCount || 0 },
    { status: 'CANCELLED', count: s.cancelledCount || 0 },
    { status: 'REFUNDED', count: s.refundedCount || 0 }
  ].filter(e => e.count > 0)
  const total = s.totalCount
  return entries.map(e => ({
    status: e.status,
    count: e.count,
    pct: (e.count / total * 100).toFixed(1),
    color: orderColorMap[e.status] || '#909399',
    label: orderStatusMap[e.status]?.label || e.status
  }))
})

// 数据概览条 - 工单状态分布（基于stats接口数据）
const ticketSegments = computed(() => {
  const s = ticketStatsData.value
  if (!s.totalCount) return []
  const entries = [
    { status: 'OPEN', count: s.openCount || 0 },
    { status: 'PROCESSING', count: s.processingCount || 0 },
    { status: 'RESOLVED', count: s.resolvedCount || 0 },
    { status: 'CLOSED', count: s.closedCount || 0 }
  ].filter(e => e.count > 0)
  const total = s.totalCount
  return entries.map(e => ({
    status: e.status,
    count: e.count,
    pct: (e.count / total * 100).toFixed(1),
    color: ticketColorMap[e.status] || '#909399',
    label: ticketStatusMap[e.status]?.label || e.status
  }))
})

// 待办提醒
const todoItems = computed(() => {
  const items = []
  recentOrders.value
    .filter(o => o.status === 'PENDING')
    .forEach(o => {
      items.push({
        key: 'order-' + o.orderId,
        title: `订单 ${o.orderNo} 待付款`,
        desc: `¥${Number(o.totalAmount).toFixed(2)}`,
        action: '去付款',
        path: '/customer/orders',
        color: '#E6A23C'
      })
    })
  recentTickets.value
    .filter(t => ['OPEN', 'PROCESSING'].includes(t.status))
    .forEach(t => {
      items.push({
        key: 'ticket-' + t.ticketId,
        title: t.title,
        desc: ticketStatusMap[t.status]?.label || t.status,
        action: '查看详情',
        path: '/customer/tickets',
        color: t.status === 'OPEN' ? '#F56C6C' : '#E6A23C'
      })
    })
  return items
})

// Tab切换
const activeRecentTab = ref('orders')

// ECharts
const orderChartRef = ref(null)
const ticketChartRef = ref(null)
let chartInstances = []

function initCharts() {
  nextTick(() => {
    if (orderChartRef.value && orderSegments.value.length > 0) {
      const chart = echarts.init(orderChartRef.value)
      chartInstances.push(chart)
      chart.setOption({
        tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
        legend: { bottom: 0, itemWidth: 10, itemHeight: 10, textStyle: { fontSize: 12, color: '#909399' } },
        series: [{
          type: 'pie', radius: ['40%', '68%'], center: ['50%', '42%'],
          avoidLabelOverlap: false, label: { show: false },
          itemStyle: { borderRadius: 4, borderColor: '#fff', borderWidth: 2 },
          data: orderSegments.value.map(s => ({ name: s.label, value: s.count, itemStyle: { color: s.color } }))
        }]
      })
    }
    if (ticketChartRef.value && ticketSegments.value.length > 0) {
      const chart = echarts.init(ticketChartRef.value)
      chartInstances.push(chart)
      chart.setOption({
        tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
        legend: { bottom: 0, itemWidth: 10, itemHeight: 10, textStyle: { fontSize: 12, color: '#909399' } },
        series: [{
          type: 'pie', radius: ['40%', '68%'], center: ['50%', '42%'],
          avoidLabelOverlap: false, label: { show: false },
          itemStyle: { borderRadius: 4, borderColor: '#fff', borderWidth: 2 },
          data: ticketSegments.value.map(s => ({ name: s.label, value: s.count, itemStyle: { color: s.color } }))
        }]
      })
    }
  })
}

function handleResize() {
  chartInstances.forEach(c => c.resize())
}

// 状态颜色映射
const orderColorMap = { PENDING: '#E6A23C', PAID: '#409EFF', SHIPPED: '#909399', DELIVERED: '#67C23A', CANCELLED: '#c0c4cc', REFUNDED: '#F56C6C' }
const ticketColorMap = { OPEN: '#F56C6C', PROCESSING: '#E6A23C', RESOLVED: '#67C23A', CLOSED: '#909399' }
function getOrderColor(status) { return orderColorMap[status] || '#909399' }
function getTicketColor(status) { return ticketColorMap[status] || '#909399' }

// 数据加载
const loadOrders = async () => {
  try {
    // 统计数据来自专用接口（准确、高效）
    const statsRes = await myOrderStats()
    const stats = statsRes.data || statsRes || {}
    orderStatsData.value = stats
    pendingOrderCount.value = stats.pendingCount || 0
    pendingOrderAmount.value = Number(stats.pendingAmount || 0)
    // 最近订单仅取5条用于展示
    const listRes = await myOrders({ pageNum: 1, pageSize: 5 })
    recentOrders.value = listRes.rows || []
  } catch (e) {
    console.error('加载订单失败', e)
  }
}

const loadTickets = async () => {
  try {
    // 统计数据来自专用接口（准确、高效）
    const statsRes = await myTicketStats()
    const stats = statsRes.data || statsRes || {}
    ticketStatsData.value = stats
    pendingTicketCount.value = (stats.openCount || 0) + (stats.processingCount || 0)
    // 最近工单仅取5条用于展示
    const listRes = await myTickets({ pageNum: 1, pageSize: 5 })
    recentTickets.value = listRes.rows || []
  } catch (e) {
    console.error('加载工单失败', e)
  }
}

const loadChatSessions = async () => {
  try {
    const res = await listSessions()
    chatSessionCount.value = (res.data || res || []).length
  } catch (e) {
    console.error('加载会话失败', e)
  }
}

const loadRecommendProducts = async () => {
  try {
    const res = await listShopProducts({ pageNum: 1, pageSize: 8, orderBy: 'salesDesc' })
    recommendProducts.value = res.rows || []
  } catch (e) {
    console.error('加载推荐商品失败', e)
  }
}

async function handleAddToCart(product) {
  const ok = await cartStore.addItem(product)
  if (ok) {
    ElMessage.success('已加入购物车')
  }
}

const loadUnread = async () => {
  try {
    const res = await getUnreadCount()
    unreadCount.value = res.data ?? res ?? 0
  } catch (e) {
    console.error('加载未读通知失败', e)
  }
}

onMounted(async () => {
  await Promise.allSettled([
    loadOrders(),
    loadTickets(),
    loadChatSessions(),
    loadUnread(),
    loadRecommendProducts()
  ])
  loading.value = false
  initCharts()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  chartInstances.forEach(c => c.dispose())
  chartInstances = []
})
</script>

<style scoped>
.user-home {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px 24px;
  min-height: calc(100vh - 60px);
}

/* ====== Section 1: 欢迎横幅 ====== */
.welcome-banner {
  position: relative;
  border-radius: 16px;
  padding: 28px 32px;
  margin-bottom: 20px;
  background: linear-gradient(135deg, #667eea 0%, #409eff 40%, #36d1dc 100%);
  border: none;
  box-shadow: 0 4px 20px rgba(64, 158, 255, 0.2);
  overflow: hidden;
  color: #ffffff;
}

.welcome-banner::before {
  content: '';
  position: absolute;
  top: -40px;
  right: -20px;
  width: 180px;
  height: 180px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.08);
}

.welcome-banner::after {
  content: '';
  position: absolute;
  bottom: -50px;
  right: 80px;
  width: 120px;
  height: 120px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.06);
}

.welcome-main {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.welcome-left {
  display: flex;
  align-items: center;
  gap: 24px;
}

.avatar-wrapper .el-avatar {
  border: 3px solid rgba(255, 255, 255, 0.4);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.15);
  transition: transform 0.3s;
}

.avatar-wrapper .el-avatar:hover {
  transform: scale(1.05);
}

.greeting-text h2 {
  margin: 0 0 4px 0;
  font-size: 22px;
  font-weight: 700;
  color: #ffffff;
  letter-spacing: 0.5px;
}

.date-text {
  margin: 0;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.75);
  font-weight: 400;
}

.welcome-right {
  position: absolute;
  right: 32px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 1;
}

.chat-btn {
  padding: 10px 28px;
  font-size: 14px;
  background: #ffffff !important;
  color: #409eff !important;
  border: none !important;
  font-weight: 600;
  box-shadow: 0 4px 15px rgba(64, 158, 255, 0.3);
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.chat-btn:hover {
  transform: translateY(-3px);
  background: #ffffff !important;
  color: #2b7de9 !important;
  box-shadow: 0 6px 20px rgba(64, 158, 255, 0.4);
}

/* ====== 横幅标语 ====== */
.banner-slogan {
  position: relative;
  z-index: 1;
  text-align: center;
  margin: 18px 0 0;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.65);
  letter-spacing: 4px;
  font-weight: 400;
}

/* ====== Section 2: 统计卡片 ====== */
.stats-row {
  margin-bottom: 16px;
}

.stats-row :deep(.el-col) {
  display: flex;
}

.stat-card {
  background: #ffffff;
  border: 1px solid #ebeef5;
  border-top: 3px solid var(--accent-color, #409eff);
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  cursor: pointer;
  margin-bottom: 16px;
  width: 100%;
  opacity: 0;
  animation: fadeSlideUp 0.6s ease forwards;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  position: relative;
  overflow: hidden;
}

.stat-card::after {
  content: '';
  position: absolute;
  top: -15px;
  right: -15px;
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: var(--accent-color, #409eff);
  opacity: 0.06;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.stat-card:hover .stat-icon-box {
  transform: scale(1.1);
}

@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(25px); }
  to { opacity: 1; transform: translateY(0); }
}

.stat-icon-box {
  width: 52px;
  height: 52px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
  transition: transform 0.3s ease;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.stat-icon-box.pulse {
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
  50% { box-shadow: 0 4px 20px rgba(0,0,0,0.25); transform: scale(1.05); }
}

.stat-content {
  flex: 1;
  min-width: 0;
}

.stat-number {
  font-size: 28px;
  font-weight: 800;
  color: #303133;
  line-height: 1.2;
}

.stat-label {
  font-size: 13px;
  color: #909399;
  margin-top: 2px;
}

.stat-sub {
  font-size: 12px;
  color: #c0c4cc;
  margin-top: 2px;
  font-weight: 500;
}

/* ====== Section 2.5: 热门商品 ====== */
.recommend-card {
  background: #ffffff;
  border: 1px solid #ebeef5;
  border-radius: 14px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  overflow: hidden;
  transition: all 0.3s;
}

.recommend-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.product-scroll-wrapper {
  padding: 0 20px 20px;
  overflow: hidden;
}

.product-scroll {
  display: flex;
  gap: 16px;
  overflow-x: auto;
  padding: 4px 0 8px;
  scroll-behavior: smooth;
  scrollbar-width: thin;
  scrollbar-color: #e4e7ed transparent;
}

.product-scroll::-webkit-scrollbar {
  height: 4px;
}

.product-scroll::-webkit-scrollbar-thumb {
  background: #e4e7ed;
  border-radius: 2px;
}

.home-product-card {
  min-width: 176px;
  width: 176px;
  border: 1px solid #f0f2f5;
  border-radius: 12px;
  overflow: hidden;
  background: #fff;
  cursor: pointer;
  flex-shrink: 0;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.home-product-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
  border-color: transparent;
}

.product-img-box {
  width: 100%;
  height: 140px;
  overflow: hidden;
}

.product-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
}

.home-product-card:hover .product-img {
  transform: scale(1.08);
}

.product-img-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f7fa, #eef0f3);
  color: #c0c4cc;
}

.product-info {
  padding: 12px;
}

.product-name {
  font-size: 13px;
  font-weight: 600;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-bottom: 4px;
}

.product-meta {
  font-size: 11px;
  color: #909399;
  margin-bottom: 6px;
}

.product-price-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.product-price {
  color: #f56c6c;
  font-size: 16px;
  font-weight: 700;
}

/* ====== Section 3: 待办提醒 ====== */
.todo-card {
  background: #ffffff;
  border: 1px solid #ebeef5;
  border-radius: 14px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  overflow: hidden;
  transition: all 0.3s;
}

.todo-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.todo-body {
  padding: 8px 20px 16px;
}

.todo-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 8px;
  border-bottom: 1px solid #f2f6fc;
  opacity: 0;
  animation: fadeSlideUp 0.5s ease forwards;
  border-radius: 8px;
  transition: background-color 0.2s;
}

.todo-item:hover {
  background-color: #fafbfc;
}

.todo-item:last-child {
  border-bottom: none;
}

.todo-left {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
  min-width: 0;
}

.todo-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
  box-shadow: 0 0 0 3px rgba(0, 0, 0, 0.04);
}

.todo-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
  min-width: 0;
}

.todo-title {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.todo-desc {
  font-size: 12px;
  color: #909399;
}

/* ====== Section 4: 最近动态 ====== */
.recent-row {
  margin-bottom: 20px;
}

.recent-card {
  background: #ffffff;
  border: 1px solid #ebeef5;
  border-radius: 14px;
  padding: 0;
  margin-bottom: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  overflow: hidden;
  transition: all 0.3s;
}

.recent-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.recent-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px 14px;
  border-bottom: 1px solid #f2f6fc;
}

.recent-title-text {
  font-size: 15px;
  font-weight: 700;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
}

.recent-title-text::before {
  content: '';
  width: 3px;
  height: 16px;
  background: linear-gradient(180deg, #409eff, #667eea);
  border-radius: 2px;
}

.recent-link {
  font-size: 13px;
  color: #409eff;
  cursor: pointer;
  transition: color 0.2s;
}

.recent-link:hover {
  color: #66b1ff;
}

.recent-body {
  padding: 12px 20px 16px;
}

.empty-state {
  text-align: center;
  padding: 32px 0 28px;
  color: #909399;
}

.empty-state .empty-main {
  margin: 10px 0 0;
  font-size: 14px;
  color: #909399;
  font-weight: 500;
}

.empty-state .empty-sub {
  margin: 4px 0 14px;
  font-size: 12px;
  color: #c0c4cc;
}

.empty-state .el-button {
  font-size: 12px;
}

/* 时间线样式 */
.timeline-item {
  display: flex;
  align-items: flex-start;
  position: relative;
  padding: 10px 8px 10px 22px;
  opacity: 0;
  animation: slideInLeft 0.5s ease forwards;
  border-radius: 8px;
  transition: background-color 0.2s;
}

.timeline-item:hover {
  background-color: #fafbfc;
}

@keyframes slideInLeft {
  from { opacity: 0; transform: translateX(-20px); }
  to { opacity: 1; transform: translateX(0); }
}

.timeline-dot {
  position: absolute;
  left: 0;
  top: 16px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
  z-index: 1;
  box-shadow: 0 0 0 3px rgba(255, 255, 255, 1), 0 0 0 5px rgba(0, 0, 0, 0.05);
}

.timeline-line {
  position: absolute;
  left: 4px;
  top: 28px;
  bottom: -12px;
  width: 2px;
  background: linear-gradient(180deg, #e4e7ed, #f0f2f5);
}

.timeline-content {
  flex: 1;
  min-width: 0;
  padding-left: 8px;
}

.timeline-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 4px;
}

.item-no {
  font-size: 13px;
  font-weight: 600;
  color: #606266;
  font-family: 'SF Mono', 'Consolas', monospace;
}

.timeline-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.item-amount {
  font-size: 14px;
  color: #f56c6c;
  font-weight: 700;
}

.item-title-text {
  font-size: 13px;
  color: #606266;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 180px;
}

.item-time {
  font-size: 12px;
  color: #909399;
}

/* ====== Tab切换 ====== */
.recent-tabs {
  display: flex;
  gap: 20px;
}

.recent-tab {
  font-size: 15px;
  font-weight: 500;
  color: #909399;
  cursor: pointer;
  padding-bottom: 4px;
  border-bottom: 2px solid transparent;
  transition: all 0.3s;
}

.recent-tab.active {
  color: #303133;
  font-weight: 700;
  border-bottom-color: #409eff;
}

.recent-tab:hover {
  color: #409eff;
}

/* ====== 数据概览饼图 ====== */
.overview-chart-card {
  background: #ffffff;
  border: 1px solid #ebeef5;
  border-radius: 14px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  overflow: hidden;
  transition: all 0.3s;
}

.overview-chart-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.chart-row {
  padding: 8px 20px 16px;
}

.chart-title {
  font-size: 13px;
  font-weight: 600;
  color: #606266;
  text-align: center;
  margin-bottom: 4px;
}

.chart-container {
  height: 220px;
}

/* ====== 响应式 ====== */
@media (max-width: 768px) {
  .user-home {
    padding: 12px;
  }

  .welcome-banner {
    padding: 20px 16px;
    border-radius: 12px;
  }

  .welcome-main {
    flex-direction: column;
    text-align: center;
    gap: 16px;
  }

  .welcome-right {
    position: static;
    transform: none;
  }

  .welcome-left {
    flex-direction: column;
    align-items: center;
  }

  .greeting-text {
    text-align: center;
  }

  .greeting-text h2 {
    font-size: 17px;
    color: #ffffff;
  }

  .banner-slogan {
    font-size: 11px;
    letter-spacing: 2px;
    margin-top: 12px;
  }

  .stat-card {
    padding: 14px;
  }

  .stat-number {
    font-size: 22px;
  }

  .stat-icon-box {
    width: 44px;
    height: 44px;
  }

  .chart-container {
    height: 180px;
  }
}
</style>
