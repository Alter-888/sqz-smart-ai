<template>
  <div class="dashboard-container">
    <!-- ===== 顶部操作栏：日期快捷按钮 + 刷新 ===== -->
    <div class="dashboard-toolbar">
      <div class="period-buttons">
        <el-button v-for="p in periodOptions" :key="p.value" size="small"
          :type="activePeriod === p.value ? 'primary' : ''" :plain="activePeriod !== p.value"
          @click="switchPeriod(p.value)">{{ p.label }}</el-button>
      </div>
    </div>

    <!-- ===== Tier 1: 核心统计卡片 ===== -->
    <el-skeleton :loading="loading" animated :count="4" class="tier-stats-skeleton">
      <template #template>
        <el-row :gutter="16" class="tier-stats">
          <el-col :xs="12" :sm="12" :md="6" :lg="6" v-for="i in 4" :key="i">
            <el-skeleton-item variant="rect" style="height: 96px; border-radius: 14px;" />
          </el-col>
        </el-row>
      </template>
      <template #default>
        <el-row :gutter="16" class="tier-stats">
          <el-col :xs="12" :sm="12" :md="6" :lg="6"
                  v-for="(item, index) in coreStatCards" :key="item.key">
            <div class="core-stat-card"
                 :style="{ animationDelay: (index * 0.15) + 's' }">
              <div class="core-stat-icon" :style="{ background: item.gradient }">
                <el-icon :size="26"><component :is="item.icon" /></el-icon>
              </div>
              <div class="core-stat-body">
                <div class="core-stat-number">{{ item.display }}</div>
                <div class="core-stat-footer">
                  <span class="core-stat-label">{{ item.label }}</span>
                  <span v-if="item.trendText" class="core-stat-trend" :class="item.trendClass">
                    {{ item.trendText }}
                  </span>
                </div>
              </div>
            </div>
          </el-col>
        </el-row>
      </template>
    </el-skeleton>

    <!-- ===== Tier 2: 主图表区 ===== -->
    <el-skeleton :loading="chartsLoading" animated>
      <template #template>
        <el-row :gutter="16" class="tier-charts">
          <el-col :xs="24" :lg="14">
            <el-skeleton-item variant="rect" style="height: 380px; border-radius: 14px;" />
          </el-col>
          <el-col :xs="24" :lg="10">
            <el-skeleton-item variant="rect" style="height: 380px; border-radius: 14px;" />
          </el-col>
        </el-row>
      </template>
      <template #default>
        <el-row :gutter="16" class="tier-charts">
          <el-col :xs="24" :lg="14">
            <div class="chart-panel chart-panel-delay1">
              <div class="panel-header">
                <span class="panel-title">近{{ activePeriod }}日消息 & 会话趋势</span>
              </div>
              <div ref="combinedTrendChartRef" class="chart-box"></div>
            </div>
          </el-col>
          <el-col :xs="24" :lg="10">
            <div class="chart-panel chart-panel-delay2">
              <div class="panel-header">
                <span class="panel-title">AI 能力雷达</span>
              </div>
              <div ref="aiRadarChartRef" class="chart-box"></div>
            </div>
          </el-col>
        </el-row>
      </template>
    </el-skeleton>

    <!-- ===== P3: AI 稳定性与路由分布 ===== -->
    <div class="stability-section">
      <el-row :gutter="16">
        <el-col :xs="12" :sm="12" :md="6" :lg="6" v-for="card in stabilityCards" :key="card.key">
          <div class="stability-card" :class="'stability-' + card.key">
            <div class="stability-label">{{ card.label }}</div>
            <div class="stability-value">{{ card.display }}</div>
            <div class="stability-unit">{{ card.unit }}</div>
          </div>
        </el-col>
      </el-row>
      <div class="chart-panel route-panel">
        <div class="panel-header">
          <span class="panel-title">路由规则与意图分布</span>
          <span class="panel-sub">规则路由覆盖率 {{ routeCoverage }}% · RAG 命中率口径：{{ ragScopeText }}</span>
        </div>
        <div v-if="!routeRows.length" class="no-data">暂无数据（新字段从 P4 起埋点，多聊几轮后这里会出现分布）</div>
        <div v-else class="route-table">
          <div class="route-row route-head">
            <span>路由来源</span><span>意图</span><span>次数</span><span>平均耗时</span>
          </div>
          <div class="route-row" v-for="(row, idx) in routeRows" :key="idx">
            <span>{{ routeSourceText(row.route_source) }}</span>
            <span>{{ intentText(row.intent) }}</span>
            <span>{{ row.cnt }}</span>
            <span>{{ row.avgMs != null ? row.avgMs + ' ms' : '—' }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== Tier 3: 业务明细 Tab ===== -->
    <div class="tier-detail">
      <div class="detail-tabs">
        <span v-for="tab in detailTabs" :key="tab.key"
              class="tab-item" :class="{ active: activeTab === tab.key }"
              @click="switchTab(tab.key)">
          {{ tab.label }}
        </span>
      </div>
      <div class="detail-content" :class="{ 'tab-animating': tabAnimating }">
        <!-- 热门问题 -->
        <div v-show="activeTab === 'hotqa'" class="hot-questions">
          <div v-if="hotQuestions.length === 0" class="no-data">暂无数据</div>
          <div v-for="(item, index) in hotQuestions" :key="index" class="hot-question-item">
            <span class="hot-rank" :class="'rank-' + (index + 1)">{{ index + 1 }}</span>
            <span class="hot-text">{{ item.question }}</span>
            <span class="hot-count">{{ item.askCount }}次</span>
          </div>
        </div>
        <!-- 工单分析 -->
        <div v-show="activeTab === 'ticket'">
          <el-row :gutter="16">
            <el-col :xs="24" :lg="12">
              <div ref="ticketTypeChartRef" class="chart-box-sm"></div>
            </el-col>
            <el-col :xs="24" :lg="12">
              <div ref="ticketStatusChartRef" class="chart-box-sm"></div>
            </el-col>
          </el-row>
        </div>
        <!-- 订单分析 -->
        <div v-show="activeTab === 'order'">
          <div ref="orderStatusChartRef" class="chart-box-sm"></div>
        </div>
        <!-- 知识库 -->
        <div v-show="activeTab === 'knowledge'">
          <div ref="knowledgeChartRef" class="chart-box-sm"></div>
        </div>
        <!-- 工具调用 -->
        <div v-show="activeTab === 'toolcall'">
          <div ref="toolCallChartRef" class="chart-box-sm"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, nextTick, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { Message, ChatDotRound, ShoppingCart, Tickets } from '@element-plus/icons-vue'
import { getDashboardStats, getDashboardTrends, getDashboardAiMetrics } from '@/api/ai/knowledge'
import * as echarts from 'echarts/core'
import { LineChart, BarChart, PieChart, RadarChart } from 'echarts/charts'
import {
  TitleComponent, TooltipComponent, LegendComponent,
  GridComponent, RadarComponent
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'

echarts.use([
  LineChart, BarChart, PieChart, RadarChart,
  TitleComponent, TooltipComponent, LegendComponent,
  GridComponent, RadarComponent, CanvasRenderer
])

function createTabInitializedState() {
  return { ticket: false, order: false, knowledge: false, toolcall: false, hotqa: false }
}

function createEmptyTrendData() {
  return {
    messageTrend: [],
    sessionTrend: [],
    ticketTypeDistribution: [],
    ticketStatusDistribution: [],
    knowledgeDistribution: [],
    orderStatusDistribution: [],
    toolCallStats: [],
    hotQuestions: []
  }
}

// ============ 状态 ============
const stats = ref({})
const loading = ref(false)
const chartsLoading = ref(false)
const hotQuestions = ref([])
const aiMetrics = ref({})
const activeTab = ref('hotqa')
const tabAnimating = ref(false)
const trendData = ref(createEmptyTrendData())
const tabInitialized = ref(createTabInitializedState())

// ============ 日期快捷按钮 ============
const activePeriod = ref(7)
const periodOptions = [
  { label: '今日', value: 1 },
  { label: '近7日', value: 7 },
  { label: '近30日', value: 30 },
  { label: '近90日', value: 90 }
]

// ============ Tab 定义 ============
const detailTabs = [
  { key: 'hotqa', label: '热门问题' },
  { key: 'ticket', label: '工单分析' },
  { key: 'order', label: '订单分析' },
  { key: 'knowledge', label: '知识库' },
  { key: 'toolcall', label: '工具调用' }
]

// ============ 图表 DOM 引用 ============
const combinedTrendChartRef = ref(null)
const aiRadarChartRef = ref(null)
const ticketTypeChartRef = ref(null)
const ticketStatusChartRef = ref(null)
const orderStatusChartRef = ref(null)
const knowledgeChartRef = ref(null)
const toolCallChartRef = ref(null)

let chartInstances = []
let dashboardRequestId = 0

// ============ 映射表 ============
const ticketTypeMap = {
  'COMPLAINT': '投诉', 'REFUND': '退款', 'EXCHANGE': '换货', 'CONSULT': '咨询'
}
const ticketStatusMap = {
  'OPEN': '待处理', 'PROCESSING': '处理中', 'RESOLVED': '已解决', 'CLOSED': '已关闭'
}
const knowledgeCategoryMap = {
  'FAQ': '常见问题', 'POLICY': '政策规范', 'PRODUCT_INFO': '商品信息', 'GUIDE': '操作指南'
}
const orderStatusMap = {
  'PENDING': '待付款', 'PAID': '已付款', 'SHIPPED': '已发货',
  'DELIVERED': '已签收', 'CANCELLED': '已取消', 'REFUNDED': '已退款'
}
const toolNameMap = {
  'queryOrder': '订单查询', 'queryUserOrders': '用户订单列表',
  'queryLogistics': '物流查询', 'createTicket': '创建工单',
  'queryTicket': '工单查询', 'queryUserTickets': '用户工单列表',
  'searchProducts': '商品搜索', 'getProductDetail': '商品详情',
  'compareProducts': '商品比较', 'recommendProducts': '商品推荐'
}

// ============ 数字滚动动画 ============
function useCountUp(targetRef, duration = 1500) {
  const displayValue = ref(0)
  watch(targetRef, (newVal) => {
    if (!newVal || newVal === 0) { displayValue.value = 0; return }
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

const totalMessages = computed(() => stats.value.totalMessages || 0)
const totalSessions = computed(() => stats.value.totalSessions || 0)
const totalOrders = computed(() => stats.value.totalOrders || 0)
const totalTickets = computed(() => stats.value.totalTickets || 0)

const displayMessages = useCountUp(totalMessages)
const displaySessions = useCountUp(totalSessions)
const displayOrders = useCountUp(totalOrders)
const displayTickets = useCountUp(totalTickets)

const feedbackRate = computed(() => {
  const fb = stats.value.feedbackStats
  if (!fb || !fb.totalFeedback || fb.totalFeedback === 0) return null
  return Math.round((fb.satisfied / fb.totalFeedback) * 100)
})

// ============ P3: AI 稳定性指标 & 路由分布 ============
const stabilityCards = computed(() => {
  const m = aiMetrics.value
  const fmt = (v) => (v === null || v === undefined || v === '') ? '—' : Number(v).toFixed(1)
  return [
    { key: 'failure', label: '失败率', display: fmt(m.failureRate) + '%', unit: '重试耗尽/系统繁忙轮次占比' },
    { key: 'retry', label: '重试率', display: fmt(m.retryRate) + '%', unit: '发生过重试的轮次占比' },
    { key: 'timeout', label: '超时率', display: fmt(m.timeoutRate) + '%', unit: '因超时失败的轮次占比' },
    { key: 'p95', label: 'P95 延迟', display: (m.p95Latency || m.p95Latency === 0) ? m.p95Latency + ' ms' : '—', unit: '95% 轮次耗时低于该值' }
  ]
})
const routeCoverage = computed(() => {
  const v = aiMetrics.value.routeRuleCoverageRate
  return v === null || v === undefined ? '—' : Number(v).toFixed(1)
})
const ragScopeText = computed(() => aiMetrics.value.ragHitRateScope || '仅统计挂RAG轮次(rag_enabled=1)，已排除评测流量')
const routeRows = computed(() => aiMetrics.value.routeSourceIntentDist || [])
const routeSourceText = (s) => ({ rule: '规则', llm: '模型', fallback: '兜底' })[s] || s || '—'
const intentText = (i) => ({ PRODUCT: '商品', ORDER: '订单', AFTERSALES: '售后', ACCOUNT: '账户', KNOWLEDGE: '知识问答', CHITCHAT: '闲聊', HUMAN_HANDOFF: '转人工', CROSS_DOMAIN: '跨域' })[i] || i || '—'

// ============ 核心统计卡片 ============
const coreStatCards = computed(() => [
  {
    key: 'totalMessages', label: '消息总数', icon: Message,
    gradient: 'linear-gradient(135deg, #E6A23C, #f0c78a)',
    display: displayMessages.value,
    trendClass: feedbackRate.value !== null ? 'trend-up' : '',
    trendText: feedbackRate.value !== null ? '满意率 ' + feedbackRate.value + '%' : ''
  },
  {
    key: 'totalSessions', label: '会话总数', icon: ChatDotRound,
    gradient: 'linear-gradient(135deg, #409EFF, #66b1ff)',
    display: displaySessions.value,
    trendClass: 'trend-info',
    trendText: stats.value.avgTurns ? '均 ' + stats.value.avgTurns + ' 轮/会话' : ''
  },
  {
    key: 'totalOrders', label: '订单总数', icon: ShoppingCart,
    gradient: 'linear-gradient(135deg, #67C23A, #95d475)',
    display: displayOrders.value,
    trendClass: '', trendText: ''
  },
  {
    key: 'totalTickets', label: '工单总数', icon: Tickets,
    gradient: 'linear-gradient(135deg, #F56C6C, #fab6b6)',
    display: displayTickets.value,
    trendClass: '', trendText: ''
  }
])

// ============ Tab 切换(带过渡动效) ============
function switchTab(key) {
  if (key === activeTab.value) return
  // 淡出
  tabAnimating.value = true
  setTimeout(() => {
    // 切换内容
    activeTab.value = key
    nextTick(() => {
      if (!tabInitialized.value[key] && trendData.value) {
        initTabCharts(key)
        tabInitialized.value[key] = true
      }
      // 淡入
      requestAnimationFrame(() => {
        tabAnimating.value = false
        nextTick(() => chartInstances.forEach(c => c.resize()))
      })
    })
  }, 220)
}

function initTabCharts(key) {
  const data = trendData.value
  if (!data) return
  switch (key) {
    case 'order':
      initOrderStatusChart(data.orderStatusDistribution || [])
      break
    case 'knowledge':
      initKnowledgeChart(data.knowledgeDistribution || [])
      break
    case 'toolcall':
      initToolCallChart(data.toolCallStats || [])
      break
  }
}

function disposeCharts() {
  chartInstances.forEach(c => c.dispose())
  chartInstances = []
}

function resetChartState() {
  disposeCharts()
  tabInitialized.value = createTabInitializedState()
}

function resolveDashboardResult(result, fallback, message) {
  if (result.status === 'fulfilled') {
    return result.value?.data ?? fallback
  }
  console.error(message, result.reason)
  ElMessage.error(message)
  return fallback
}

async function reloadDashboard({ showLoading = false, showChartsLoading = false } = {}) {
  const requestId = ++dashboardRequestId
  const days = activePeriod.value

  if (showLoading) loading.value = true
  if (showChartsLoading) chartsLoading.value = true

  try {
    const [statsResult, trendsResult, aiMetricsResult] = await Promise.allSettled([
      getDashboardStats(days),
      getDashboardTrends(days),
      getDashboardAiMetrics(days)
    ])

    if (requestId !== dashboardRequestId) return

    const nextStats = resolveDashboardResult(statsResult, {}, '获取统计数据失败')
    const nextTrendData = resolveDashboardResult(trendsResult, createEmptyTrendData(), '获取趋势数据失败')
    const nextAiMetrics = resolveDashboardResult(aiMetricsResult, {}, '获取AI效果指标失败')

    stats.value = nextStats
    trendData.value = nextTrendData
    hotQuestions.value = nextTrendData.hotQuestions || []
    aiMetrics.value = nextAiMetrics

    resetChartState()

    // 先关闭 skeleton loading，让 #default slot 渲染出 chart DOM 容器
    loading.value = false
    chartsLoading.value = false
    await nextTick()

    if (requestId !== dashboardRequestId) return

    initCombinedTrendChart(nextTrendData.messageTrend || [], nextTrendData.sessionTrend || [])
    initTicketTypeChart(nextTrendData.ticketTypeDistribution || [])
    initTicketStatusChart(nextTrendData.ticketStatusDistribution || [])
    tabInitialized.value.ticket = true
    initAiRadarChart(nextAiMetrics)

    if (activeTab.value !== 'hotqa' && activeTab.value !== 'ticket') {
      initTabCharts(activeTab.value)
      tabInitialized.value[activeTab.value] = true
    }
  } catch (e) {
    if (requestId === dashboardRequestId) {
      loading.value = false
      chartsLoading.value = false
    }
  }
}

// ============ 合并趋势图(消息+会话) ============
function initCombinedTrendChart(messageTrend, sessionTrend) {
  if (!combinedTrendChartRef.value) return
  const chart = echarts.init(combinedTrendChartRef.value)
  chartInstances.push(chart)

  const dateSet = new Set()
  messageTrend.forEach(d => dateSet.add(String(d.date)))
  sessionTrend.forEach(d => dateSet.add(String(d.date)))
  const dates = Array.from(dateSet).sort()

  const msgMap = {}
  messageTrend.forEach(d => { msgMap[String(d.date)] = d.count })
  const sessMap = {}
  sessionTrend.forEach(d => { sessMap[String(d.date)] = d.count })

  chart.setOption({
    tooltip: { trigger: 'axis' },
    legend: { data: ['消息数', '新建会话'], bottom: 0 },
    grid: { left: '3%', right: '4%', bottom: '14%', top: '8%', containLabel: true },
    xAxis: {
      type: 'category',
      data: dates.map(d => d.length >= 10 ? d.substring(5, 10) : d),
      axisLine: { lineStyle: { color: '#dcdfe6' } },
      axisLabel: { color: '#909399' }
    },
    yAxis: {
      type: 'value', minInterval: 1,
      axisLine: { show: false },
      splitLine: { lineStyle: { color: '#f0f0f0', type: 'dashed' } },
      axisLabel: { color: '#909399' }
    },
    series: [
      {
        name: '消息数', type: 'line',
        data: dates.map(d => msgMap[d] ?? 0),
        smooth: true,
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(64,158,255,0.35)' },
            { offset: 1, color: 'rgba(64,158,255,0.02)' }
          ])
        },
        itemStyle: { color: '#409EFF' },
        lineStyle: { width: 2.5 }
      },
      {
        name: '新建会话', type: 'line',
        data: dates.map(d => sessMap[d] ?? 0),
        smooth: true,
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(103,194,58,0.35)' },
            { offset: 1, color: 'rgba(103,194,58,0.02)' }
          ])
        },
        itemStyle: { color: '#67C23A' },
        lineStyle: { width: 2.5 }
      }
    ]
  })
}

// ============ AI 雷达图 ============
function initAiRadarChart(data) {
  if (!aiRadarChartRef.value) return
  const chart = echarts.init(aiRadarChartRef.value)
  chartInstances.push(chart)

  chart.setOption({
    tooltip: {
      trigger: 'item',
      formatter: (params) => {
        const indicators = ['工具成功率', 'RAG命中率', '用户满意度', '对话效率', '会话轮次']
        const suffixes = ['%', '%', '%', '%', '']
        let html = params.name + '<br/>'
        params.value.forEach((v, i) => {
          html += indicators[i] + ': ' + v + suffixes[i] + '<br/>'
        })
        return html
      }
    },
    radar: {
      indicator: [
        { name: '工具成功率', max: 100 },
        { name: 'RAG命中率', max: 100 },
        { name: '用户满意度', max: 100 },
        { name: '对话效率', max: 100 },
        { name: '会话轮次', max: 20 }
      ],
      shape: 'polygon',
      splitNumber: 4,
      axisName: { color: '#909399', fontSize: 12 },
      splitLine: { lineStyle: { color: 'rgba(64,158,255,0.15)' } },
      splitArea: {
        areaStyle: {
          color: ['rgba(64,158,255,0.02)', 'rgba(64,158,255,0.06)',
                  'rgba(64,158,255,0.10)', 'rgba(64,158,255,0.14)']
        }
      }
    },
    series: [{
      type: 'radar',
      data: [{
        value: [
          data.toolCallSuccessRate || 0,
          data.ragHitRate || 0,
          data.satisfactionRate || 0,
          100 - (data.humanEscalationRate || 0),
          data.avgTurnsPerSession || 0
        ],
        name: 'AI 能力',
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(64,158,255,0.45)' },
            { offset: 1, color: 'rgba(103,194,58,0.25)' }
          ])
        },
        lineStyle: { color: '#409EFF', width: 2 },
        itemStyle: { color: '#409EFF' }
      }],
      animationDuration: 1500,
      animationEasing: 'cubicOut'
    }]
  })
}

// ============ 工单类型饼图 ============
function initTicketTypeChart(data) {
  if (!ticketTypeChartRef.value) return
  const chart = echarts.init(ticketTypeChartRef.value)
  chartInstances.push(chart)
  chart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    legend: { bottom: 0 },
    color: ['#F56C6C', '#E6A23C', '#409EFF', '#67C23A'],
    series: [{
      type: 'pie',
      radius: ['40%', '70%'],
      label: { show: true, formatter: '{b}\n{d}%' },
      data: data.map(d => ({
        name: ticketTypeMap[d.type] || d.type,
        value: d.count
      })),
      animationType: 'scale',
      animationEasing: 'elasticOut',
      animationDelay: (idx) => idx * 200
    }]
  })
}

// ============ 工单状态饼图 ============
function initTicketStatusChart(data) {
  if (!ticketStatusChartRef.value) return
  const chart = echarts.init(ticketStatusChartRef.value)
  chartInstances.push(chart)
  chart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    legend: { bottom: 0 },
    color: ['#E6A23C', '#409EFF', '#67C23A', '#909399'],
    series: [{
      type: 'pie',
      radius: '60%',
      label: { show: true, formatter: '{b}\n{d}%' },
      data: data.map(d => ({
        name: ticketStatusMap[d.status] || d.status,
        value: d.count
      })),
      animationType: 'scale',
      animationEasing: 'elasticOut',
      animationDelay: (idx) => idx * 200
    }]
  })
}

// ============ 订单状态饼图 ============
function initOrderStatusChart(data) {
  if (!orderStatusChartRef.value) return
  const chart = echarts.init(orderStatusChartRef.value)
  chartInstances.push(chart)
  chart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    legend: { bottom: 0 },
    color: ['#E6A23C', '#409EFF', '#67C23A', '#95de64', '#909399', '#F56C6C'],
    series: [{
      type: 'pie',
      radius: ['40%', '70%'],
      label: { show: true, formatter: '{b}\n{d}%' },
      data: data.map(d => ({
        name: orderStatusMap[d.status] || d.status,
        value: d.count
      })),
      animationType: 'scale',
      animationEasing: 'elasticOut',
      animationDelay: (idx) => idx * 200
    }]
  })
}

// ============ 知识库柱图 ============
function initKnowledgeChart(data) {
  if (!knowledgeChartRef.value) return
  const chart = echarts.init(knowledgeChartRef.value)
  chartInstances.push(chart)
  chart.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: {
      type: 'category',
      data: data.map(d => knowledgeCategoryMap[d.category] || d.category || '未分类'),
      axisLabel: { interval: 0 }
    },
    yAxis: { type: 'value', minInterval: 1 },
    series: [{
      type: 'bar',
      data: data.map(d => d.count),
      itemStyle: {
        borderRadius: [4, 4, 0, 0],
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: '#409EFF' },
          { offset: 1, color: '#67C23A' }
        ])
      },
      barMaxWidth: 50
    }]
  })
}

// ============ 工具调用柱图 ============
function initToolCallChart(data) {
  if (!toolCallChartRef.value) return
  const chart = echarts.init(toolCallChartRef.value)
  chartInstances.push(chart)
  chart.setOption({
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: '3%', right: '10%', bottom: '3%', containLabel: true },
    xAxis: { type: 'value', minInterval: 1 },
    yAxis: {
      type: 'category',
      data: data.map(d => toolNameMap[d.toolName] || d.toolName),
      inverse: true
    },
    series: [{
      type: 'bar',
      data: data.map(d => d.callCount),
      itemStyle: {
        borderRadius: [0, 4, 4, 0],
        color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
          { offset: 0, color: '#409EFF' },
          { offset: 1, color: '#67C23A' }
        ])
      },
      barMaxWidth: 30,
      label: { show: true, position: 'right', formatter: '{c}次' }
    }]
  })
}

// ============ 窗口 resize ============
const handleResize = () => {
  chartInstances.forEach(c => c.resize())
}

// ============ 切换日期范围 ============
async function switchPeriod(days) {
  if (days === activePeriod.value) return
  activePeriod.value = days
  await reloadDashboard({ showLoading: true, showChartsLoading: true })
}

// ============ 生命周期 ============
onMounted(async () => {
  await reloadDashboard({ showLoading: true, showChartsLoading: true })
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  disposeCharts()
  window.removeEventListener('resize', handleResize)
})
</script>

<style scoped>
/* ==================== 全局容器 ==================== */
.dashboard-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 16px;
}

/* ==================== 顶部操作栏 ==================== */
.dashboard-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  padding: 12px 16px;
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}
.period-buttons {
  display: flex;
  gap: 8px;
}
.tier-stats-skeleton {
  margin-bottom: 16px;
}

/* ==================== 入场动画 ==================== */
@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(25px); }
  to { opacity: 1; transform: translateY(0); }
}

/* ==================== Tier 1: 核心统计卡片 ==================== */
.tier-stats {
  margin-bottom: 16px;
}

.core-stat-card {
  background: #fff;
  border-radius: 14px;
  padding: 22px 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
  opacity: 0;
  animation: fadeSlideUp 0.6s ease forwards;
  transition: transform 0.3s cubic-bezier(0.25, 0.8, 0.25, 1), box-shadow 0.3s;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.core-stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.core-stat-card:hover .core-stat-icon {
  transform: scale(1.1);
}

.core-stat-icon {
  width: 54px;
  height: 54px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
  transition: transform 0.3s ease;
}

.core-stat-body {
  flex: 1;
  min-width: 0;
}

.core-stat-number {
  font-size: 30px;
  font-weight: 800;
  color: #303133;
  line-height: 1.2;
  letter-spacing: -0.5px;
}

.core-stat-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 6px;
}

.core-stat-label {
  font-size: 13px;
  color: #909399;
}

.core-stat-trend {
  font-size: 12px;
  display: flex;
  align-items: center;
  gap: 2px;
  padding: 2px 8px;
  border-radius: 10px;
  background: rgba(103, 194, 58, 0.1);
}

.trend-up { color: #67C23A; }
.trend-down { color: #F56C6C; background: rgba(245, 108, 108, 0.1); }
.trend-info { color: #409EFF; background: rgba(64, 158, 255, 0.1); }

/* ==================== Tier 2: 主图表面板 ==================== */
.tier-charts {
  margin-bottom: 16px;
}

.chart-panel {
  background: #fff;
  border-radius: 14px;
  padding: 0;
  margin-bottom: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  overflow: hidden;
  opacity: 0;
  animation: fadeSlideUp 0.6s ease forwards;
  transition: transform 0.3s cubic-bezier(0.25, 0.8, 0.25, 1), box-shadow 0.3s;
}

.chart-panel:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
}

.chart-panel-delay1 { animation-delay: 0.45s; }
.chart-panel-delay2 { animation-delay: 0.55s; }

.panel-header {
  padding: 16px 20px 12px;
  border-bottom: 1px solid #f5f5f5;
}

.panel-title {
  font-size: 15px;
  font-weight: 700;
  color: #303133;
}

/* ==================== 图表容器 ==================== */
.chart-box {
  height: 320px;
}
.chart-box-sm {
  height: 300px;
}

/* ==================== Tier 3: Tab 业务明细 ==================== */
.tier-detail {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  overflow: hidden;
  opacity: 0;
  animation: fadeSlideUp 0.6s ease 0.65s forwards;
}

.detail-tabs {
  display: flex;
  border-bottom: 1px solid #f0f0f0;
  padding: 0 20px;
  gap: 0;
  overflow-x: auto;
}

.detail-tabs::-webkit-scrollbar {
  height: 0;
}

.tab-item {
  position: relative;
  padding: 14px 20px;
  font-size: 14px;
  color: #909399;
  cursor: pointer;
  transition: color 0.3s, background-color 0.2s;
  white-space: nowrap;
  user-select: none;
  border-radius: 8px 8px 0 0;
}

.tab-item::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 20px;
  right: 20px;
  height: 2.5px;
  background: linear-gradient(90deg, #409EFF, #67C23A);
  border-radius: 2px;
  transform: scaleX(0);
  transition: transform 0.35s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.tab-item:hover {
  color: #409EFF;
  background-color: rgba(64, 158, 255, 0.04);
}

.tab-item.active {
  color: #409EFF;
  font-weight: 600;
}

.tab-item.active::after {
  transform: scaleX(1);
}

.detail-content {
  padding: 20px;
  min-height: 320px;
  transition: opacity 0.22s ease, transform 0.22s ease;
}

.detail-content.tab-animating {
  opacity: 0;
  transform: translateY(10px);
}

/* ==================== 热门问题 ==================== */
.hot-questions {
  padding: 10px 0;
  min-height: 260px;
}

.no-data {
  text-align: center;
  color: #909399;
  padding: 80px 0;
}

.hot-question-item {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid #f0f0f0;
  transition: background-color 0.2s;
}

.hot-question-item:hover {
  background-color: #fafafa;
}

.hot-question-item:last-child {
  border-bottom: none;
}

.hot-rank {
  width: 24px;
  height: 24px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  color: #fff;
  background: #909399;
  flex-shrink: 0;
  margin-right: 12px;
}

.hot-rank.rank-1 { background: #F56C6C; }
.hot-rank.rank-2 { background: #E6A23C; }
.hot-rank.rank-3 { background: #409EFF; }

.hot-text {
  flex: 1;
  font-size: 14px;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.hot-count {
  font-size: 13px;
  color: #909399;
  margin-left: 12px;
  flex-shrink: 0;
}

/* ==================== 响应式 ==================== */
@media (max-width: 768px) {
  .dashboard-container { padding: 12px; }
  .dashboard-toolbar { flex-direction: column; gap: 10px; padding: 10px 12px; }
  .period-buttons { flex-wrap: wrap; }
  .core-stat-card { padding: 16px 14px; }
  .core-stat-number { font-size: 22px; }
  .core-stat-icon { width: 44px; height: 44px; }
  .core-stat-footer { flex-direction: column; align-items: flex-start; gap: 2px; }
  .tab-item { padding: 12px 14px; font-size: 13px; }
  .detail-content { padding: 12px; }
}

/* ==================== P3: AI 稳定性与路由分布 ==================== */
.stability-section {
  margin-top: 4px;
}
.stability-card {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  padding: 18px 20px;
  margin-bottom: 16px;
  transition: transform 0.25s, box-shadow 0.25s;
}
.stability-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
}
.stability-label { font-size: 13px; color: #909399; }
.stability-value { font-size: 26px; font-weight: 600; margin: 6px 0 2px; color: #303133; }
.stability-failure .stability-value,
.stability-timeout .stability-value { color: #F56C6C; }
.stability-retry .stability-value { color: #E6A23C; }
.stability-p95 .stability-value { color: #409EFF; }
.stability-unit { font-size: 12px; color: #c0c4cc; }
.route-panel { margin-bottom: 4px; }
.panel-sub { font-size: 12px; color: #909399; margin-left: auto; padding-left: 12px; }
.route-table { padding: 4px 16px 12px; }
.route-row { display: flex; gap: 12px; padding: 8px 0; border-bottom: 1px dashed #f0f0f0; font-size: 13px; color: #606266; }
.route-row > span { flex: 1; min-width: 0; }
.route-row:last-child { border-bottom: none; }
.route-head { color: #909399; font-weight: 500; border-bottom: 1px solid #f0f0f0; }
@media (max-width: 768px) {
  .stability-card { padding: 14px 16px; }
  .stability-value { font-size: 22px; }
  .route-table { padding: 4px 10px 8px; }
}
</style>

<!-- 暗黑模式需要不带scoped，因为html.dark在根元素 -->
<style>
html.dark .dashboard-container .core-stat-card,
html.dark .dashboard-container .chart-panel,
html.dark .dashboard-container .tier-detail,
html.dark .dashboard-container .dashboard-toolbar {
  background: var(--el-bg-color-overlay);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}

html.dark .dashboard-container .core-stat-number,
html.dark .dashboard-container .panel-title {
  color: var(--el-text-color-primary);
}

html.dark .dashboard-container .core-stat-label,
html.dark .dashboard-container .tab-item {
  color: var(--el-text-color-regular);
}

html.dark .dashboard-container .tab-item:hover {
  background-color: rgba(255, 255, 255, 0.04);
}

html.dark .dashboard-container .tab-item.active {
  color: #409EFF;
}

html.dark .dashboard-container .panel-header,
html.dark .dashboard-container .detail-tabs {
  border-bottom-color: var(--el-border-color);
}

html.dark .dashboard-container .hot-question-item {
  border-bottom-color: var(--el-border-color);
}

html.dark .dashboard-container .hot-question-item:hover {
  background-color: rgba(255, 255, 255, 0.04);
}

html.dark .dashboard-container .hot-text {
  color: var(--el-text-color-primary);
}

html.dark .dashboard-container .stability-card {
  background: var(--el-bg-color-overlay);
  box-shadow: none;
  border: 1px solid var(--el-border-color);
}
html.dark .dashboard-container .stability-value {
  color: var(--el-text-color-primary);
}
html.dark .dashboard-container .stability-label,
html.dark .dashboard-container .stability-unit,
html.dark .dashboard-container .panel-sub {
  color: var(--el-text-color-secondary);
}
html.dark .dashboard-container .route-row {
  color: var(--el-text-color-regular);
  border-bottom-color: var(--el-border-color-lighter);
}
</style>
