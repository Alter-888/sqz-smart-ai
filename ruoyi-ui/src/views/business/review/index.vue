<template>
  <div class="app-container review-manage">
    <!-- 统计概览区 -->
    <el-row :gutter="16" class="stats-row">
      <el-col :xs="12" :sm="12" :md="6" :lg="6">
        <div class="stat-card stat-blue">
          <div class="stat-icon"><el-icon><ChatDotRound /></el-icon></div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.totalReviews || 0 }}</div>
            <div class="stat-label">总评价数</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :md="6" :lg="6">
        <div class="stat-card stat-green">
          <div class="stat-icon"><el-icon><StarFilled /></el-icon></div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.goodRate || 0 }}%</div>
            <div class="stat-label">好评率</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :md="6" :lg="6">
        <div class="stat-card stat-orange">
          <div class="stat-icon"><el-icon><ChatLineRound /></el-icon></div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.unrepliedCount || 0 }}</div>
            <div class="stat-label">待回复</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :md="6" :lg="6">
        <div class="stat-card stat-purple">
          <div class="stat-icon"><el-icon><Timer /></el-icon></div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.todayNewCount || 0 }}</div>
            <div class="stat-label">今日新增</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 筛选区 -->
    <el-card shadow="never" class="filter-card">
      <el-form :inline="true" :model="queryParams">
        <el-form-item label="商品名称">
          <el-input v-model="queryParams.productName" placeholder="搜索商品名称" clearable
            @keyup.enter="handleSearch" style="width: 200px" />
        </el-form-item>
        <el-form-item label="评分等级">
          <el-select v-model="queryParams.ratingLevel" placeholder="全部" clearable style="width: 120px"
            @change="handleFilterChange">
            <el-option label="好评(4-5星)" value="good" />
            <el-option label="中评(3星)" value="mid" />
            <el-option label="差评(1-2星)" value="bad" />
          </el-select>
        </el-form-item>
        <el-form-item label="评价时间">
          <el-date-picker v-model="queryParams.dateRange" type="daterange" range-separator="至"
            start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD"
            style="width: 240px" @change="handleFilterChange" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon> 查询
          </el-button>
          <el-button @click="resetQuery">
            <el-icon><Refresh /></el-icon> 重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 商品卡片列表 -->
    <div v-loading="loading" class="product-list">
      <div v-if="productList.length === 0 && !loading" class="empty-state">
        <el-empty description="暂无评价数据" />
      </div>

      <div v-for="product in productList" :key="product.productId" class="product-card">
        <!-- 商品头部 -->
        <div class="product-header" @click="toggleExpand(product)">
          <div class="product-image-wrap">
            <el-image :src="product.imageUrl" fit="cover" class="product-image" lazy>
              <template #error>
                <div class="image-placeholder">
                  <el-icon :size="24"><PictureFilled /></el-icon>
                </div>
              </template>
            </el-image>
          </div>
          <div class="product-info">
            <div class="product-name">{{ product.productName }}</div>
            <div class="product-meta">
              <el-tag size="small" type="info" effect="plain">{{ product.category || '未分类' }}</el-tag>
              <span v-if="product.unrepliedCount > 0" class="unreplied-tip">
                <el-icon><ChatLineRound /></el-icon>
                {{ product.unrepliedCount }}条待回复
              </span>
            </div>
          </div>
          <div class="product-stats">
            <div class="rating-display">
              <el-rate :model-value="product.avgRating" disabled show-score text-color="#ff9900"
                score-template="{value}分" />
            </div>
            <el-badge :value="product.reviewCount + '条'" type="primary" class="review-count-badge">
              <span class="badge-label">评价</span>
            </el-badge>
          </div>
          <div class="expand-toggle">
            <el-icon class="toggle-icon" :style="{ transform: expandedProducts[product.productId] ? 'rotate(180deg)' : '' }">
              <ArrowDown />
            </el-icon>
          </div>
        </div>

        <!-- 评价列表（展开区域） -->
        <transition name="slide-down">
          <div v-if="expandedProducts[product.productId]" class="review-list-wrap">
            <div v-loading="reviewLoading[product.productId]" class="review-list">
              <div v-if="!reviewData[product.productId] || reviewData[product.productId].length === 0"
                class="no-reviews">
                <el-empty :image-size="60" description="暂无评价" />
              </div>

              <div v-for="review in (reviewData[product.productId] || [])" :key="review.reviewId"
                class="review-item" :class="getReviewBorderClass(review.rating)">
                <!-- 评价头部 -->
                <div class="review-header">
                  <el-avatar :size="36" class="user-avatar">
                    {{ (review.nickName || '用户').charAt(0) }}
                  </el-avatar>
                  <div class="review-user-info">
                    <span class="user-name">{{ review.nickName || '用户' + review.userId }}</span>
                    <el-rate :model-value="review.rating" disabled :size="'small'" class="review-rating" />
                  </div>
                  <div class="review-right">
                    <el-tag :type="getRatingTagType(review.rating)" size="small" effect="light">
                      {{ getRatingLabel(review.rating) }}
                    </el-tag>
                    <el-tag v-if="review.status === 0" type="info" size="small" effect="dark"
                      style="margin-left: 6px">已隐藏</el-tag>
                    <span class="review-time">{{ parseTime(review.createTime, '{y}-{m}-{d} {h}:{i}') }}</span>
                  </div>
                </div>

                <!-- 评价内容 -->
                <div class="review-content">{{ review.content || '用户未填写评价内容' }}</div>

                <!-- 商家回复区 -->
                <div v-if="review.adminReply && !isEditing(review.reviewId)" class="admin-reply-box">
                  <div class="reply-label">
                    <el-icon><Service /></el-icon> 商家回复
                    <span class="reply-time">{{ parseTime(review.replyTime, '{y}-{m}-{d} {h}:{i}') }}</span>
                  </div>
                  <div class="reply-content">{{ review.adminReply }}</div>
                </div>

                <!-- 内联回复输入区 -->
                <transition name="slide-down">
                  <div v-if="replyingReviewId === review.reviewId" class="inline-reply-box">
                    <el-input v-model="replyContent" type="textarea" :rows="3"
                      placeholder="请输入回复内容..." maxlength="500" show-word-limit />
                    <div class="reply-actions">
                      <el-button size="small" @click="cancelReply">取消</el-button>
                      <el-button size="small" type="primary" :loading="replyLoading"
                        @click="submitReply(review)">提交回复</el-button>
                    </div>
                  </div>
                </transition>

                <!-- 操作区 -->
                <div class="review-actions">
                  <el-button v-hasPermi="['business:review:edit']" type="primary" link size="small"
                    @click.stop="handleReply(review)">
                    <el-icon><ChatDotRound /></el-icon>
                    {{ review.adminReply ? '修改回复' : '回复' }}
                  </el-button>
                  <el-button v-hasPermi="['business:review:edit']" type="warning" link size="small"
                    @click.stop="handleToggleStatus(review, product.productId)">
                    <el-icon><View v-if="review.status === 1" /><Hide v-else /></el-icon>
                    {{ review.status === 1 ? '隐藏' : '显示' }}
                  </el-button>
                  <el-button v-hasPermi="['business:review:remove']" type="danger" link size="small"
                    @click.stop="handleDelete(review, product.productId)">
                    <el-icon><Delete /></el-icon> 删除
                  </el-button>
                </div>
              </div>

              <!-- 评价分页 -->
              <div v-if="reviewTotal[product.productId] > 5" class="review-pagination">
                <el-pagination small layout="prev, pager, next"
                  :total="reviewTotal[product.productId] || 0" :page-size="5"
                  :current-page="reviewPage[product.productId] || 1"
                  @current-change="(page) => handleReviewPageChange(product.productId, page)" />
              </div>
            </div>
          </div>
        </transition>
      </div>
    </div>

    <!-- 商品级分页 -->
    <el-pagination v-if="total > 0" v-model:current-page="queryParams.pageNum"
      v-model:page-size="queryParams.pageSize" :page-sizes="[6, 10, 20]" :total="total"
      layout="total, sizes, prev, pager, next" class="product-pagination"
      @size-change="loadProductList" @current-change="loadProductList" />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { parseTime } from '@/utils/ruoyi'
import {
  getReviewOverviewStats,
  getProductReviewSummary,
  listProductReviewsForAdmin,
  adminReplyReview,
  updateReviewStatus,
  deleteReview
} from '@/api/business/review'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  ChatDotRound, StarFilled, ChatLineRound, Timer,
  Search, Refresh, PictureFilled, ArrowDown,
  Service, View, Hide, Delete
} from '@element-plus/icons-vue'

// ========== 统计概览 ==========
const stats = ref({})

async function loadStats() {
  try {
    const res = await getReviewOverviewStats()
    stats.value = res.data || {}
  } catch { /* ignore */ }
}

// ========== 商品列表 ==========
const loading = ref(false)
const productList = ref([])
const total = ref(0)
const queryParams = reactive({
  pageNum: 1,
  pageSize: 6,
  productName: '',
  ratingLevel: '',
  dateRange: null
})

async function loadProductList() {
  loading.value = true
  try {
    // 构建请求参数，将 dateRange 转为 beginTime/endTime
    const params = {
      pageNum: queryParams.pageNum,
      pageSize: queryParams.pageSize,
      productName: queryParams.productName
    }
    if (queryParams.ratingLevel) {
      params.ratingLevel = queryParams.ratingLevel
    }
    if (queryParams.dateRange && queryParams.dateRange.length === 2) {
      params.beginTime = queryParams.dateRange[0]
      params.endTime = queryParams.dateRange[1]
    }
    const res = await getProductReviewSummary(params)
    productList.value = res.rows || []
    total.value = res.total || 0
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  queryParams.pageNum = 1
  // 清除评价缓存并收起所有展开的商品
  Object.keys(reviewData).forEach(k => delete reviewData[k])
  Object.keys(expandedProducts).forEach(k => { expandedProducts[k] = false })
  loadProductList()
}

function resetQuery() {
  queryParams.pageNum = 1
  queryParams.productName = ''
  queryParams.ratingLevel = ''
  queryParams.dateRange = null
  // 清除评价缓存并收起展开
  Object.keys(reviewData).forEach(k => delete reviewData[k])
  Object.keys(expandedProducts).forEach(k => { expandedProducts[k] = false })
  loadProductList()
}

// 筛选条件变化时重新加载商品列表和评价
function handleFilterChange() {
  queryParams.pageNum = 1
  // 清除评价缓存并收起展开
  Object.keys(reviewData).forEach(k => delete reviewData[k])
  Object.keys(expandedProducts).forEach(k => { expandedProducts[k] = false })
  loadProductList()
}

// ========== 展开/收起 ==========
const expandedProducts = reactive({})
const reviewData = reactive({})
const reviewTotal = reactive({})
const reviewPage = reactive({})
const reviewLoading = reactive({})

function toggleExpand(product) {
  const pid = product.productId
  if (expandedProducts[pid]) {
    expandedProducts[pid] = false
  } else {
    expandedProducts[pid] = true
    if (!reviewData[pid]) {
      reviewPage[pid] = 1
      loadReviews(pid)
    }
  }
}

async function loadReviews(productId) {
  reviewLoading[productId] = true
  try {
    const params = {
      pageNum: reviewPage[productId] || 1,
      pageSize: 5
    }
    // 传递评分筛选
    if (queryParams.ratingLevel) {
      params.ratingLevel = queryParams.ratingLevel
    }
    // 传递日期范围筛选
    if (queryParams.dateRange && queryParams.dateRange.length === 2) {
      params.beginTime = queryParams.dateRange[0]
      params.endTime = queryParams.dateRange[1]
    }
    const res = await listProductReviewsForAdmin(productId, params)
    reviewData[productId] = res.rows || []
    reviewTotal[productId] = res.total || 0
  } finally {
    reviewLoading[productId] = false
  }
}

function handleReviewPageChange(productId, page) {
  reviewPage[productId] = page
  loadReviews(productId)
}

// ========== 工具函数 ==========
function getRatingLabel(rating) {
  if (rating >= 4) return '好评'
  if (rating === 3) return '中评'
  return '差评'
}

function getRatingTagType(rating) {
  if (rating >= 4) return 'success'
  if (rating === 3) return 'warning'
  return 'danger'
}

function getReviewBorderClass(rating) {
  if (rating >= 4) return 'border-good'
  if (rating === 3) return 'border-mid'
  return 'border-bad'
}

// ========== 内联回复 ==========
const replyingReviewId = ref(null)
const replyContent = ref('')
const replyLoading = ref(false)

function isEditing(reviewId) {
  return replyingReviewId.value === reviewId
}

function handleReply(review) {
  replyingReviewId.value = review.reviewId
  replyContent.value = review.adminReply || ''
}

function cancelReply() {
  replyingReviewId.value = null
  replyContent.value = ''
}

async function submitReply(review) {
  if (!replyContent.value.trim()) {
    ElMessage.warning('请输入回复内容')
    return
  }
  replyLoading.value = true
  try {
    await adminReplyReview(review.reviewId, replyContent.value.trim())
    ElMessage.success('回复成功')
    review.adminReply = replyContent.value.trim()
    review.replyTime = new Date().toISOString()
    cancelReply()
    loadStats()
    // 更新商品卡片上的待回复数
    const product = productList.value.find(p => p.productId === review.productId)
    if (product && product.unrepliedCount > 0) {
      product.unrepliedCount--
    }
  } catch (e) {
    ElMessage.error(e.message || '回复失败')
  } finally {
    replyLoading.value = false
  }
}

// ========== 状态切换 ==========
async function handleToggleStatus(review, productId) {
  const newStatus = review.status === 1 ? 0 : 1
  const label = newStatus === 1 ? '显示' : '隐藏'
  try {
    await ElMessageBox.confirm(`确定要${label}该评价吗？`, '提示', { type: 'warning' })
    await updateReviewStatus(review.reviewId, newStatus)
    ElMessage.success(`已${label}`)
    review.status = newStatus
  } catch { /* 取消 */ }
}

// ========== 删除 ==========
async function handleDelete(review, productId) {
  try {
    await ElMessageBox.confirm('确定要删除该评价吗？删除后不可恢复。', '警告', { type: 'warning' })
    await deleteReview(review.reviewId)
    ElMessage.success('删除成功')
    loadReviews(productId)
    loadStats()
    loadProductList()
  } catch { /* 取消 */ }
}

// ========== 初始化 ==========
onMounted(() => {
  loadStats()
  loadProductList()
})
</script>

<style scoped>
.review-manage {
  padding: 20px;
}

/* ===== 统计卡片 ===== */
.stats-row {
  margin-bottom: 20px;
}
.stat-card {
  display: flex;
  align-items: center;
  padding: 20px;
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
  transition: transform 0.2s, box-shadow 0.2s;
}
.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}
.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
  color: #fff;
  margin-right: 16px;
  flex-shrink: 0;
}
.stat-blue .stat-icon { background: linear-gradient(135deg, #409eff, #79bbff); }
.stat-green .stat-icon { background: linear-gradient(135deg, #67c23a, #95d475); }
.stat-orange .stat-icon { background: linear-gradient(135deg, #e6a23c, #eebe77); }
.stat-purple .stat-icon { background: linear-gradient(135deg, #9b59b6, #c39bd3); }
.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
}
.stat-label {
  font-size: 13px;
  color: #909399;
  margin-top: 4px;
}

/* ===== 筛选区 ===== */
.filter-card {
  margin-bottom: 20px;
  border-radius: 12px;
}
.filter-card :deep(.el-card__body) {
  padding: 16px 20px 4px;
}

/* ===== 商品卡片 ===== */
.product-list {
  min-height: 200px;
}
.product-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
  margin-bottom: 16px;
  overflow: hidden;
  transition: box-shadow 0.2s;
}
.product-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}
.product-header {
  display: flex;
  align-items: center;
  padding: 16px 20px;
  cursor: pointer;
  transition: background-color 0.2s;
}
.product-header:hover {
  background-color: #f9fafc;
}
.product-image-wrap {
  flex-shrink: 0;
  margin-right: 16px;
}
.product-image {
  width: 72px;
  height: 72px;
  border-radius: 8px;
  overflow: hidden;
}
.image-placeholder {
  width: 72px;
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
  color: #c0c4cc;
  font-size: 24px;
  border-radius: 8px;
}
.product-info {
  flex: 1;
  min-width: 0;
}
.product-name {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.product-meta {
  display: flex;
  align-items: center;
  gap: 12px;
}
.unreplied-tip {
  color: #e6a23c;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 4px;
}
.product-stats {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-right: 16px;
}
.rating-display {
  display: flex;
  align-items: center;
}
.rating-display :deep(.el-rate) {
  height: auto;
}
.review-count-badge {
  display: flex;
  align-items: center;
}
.badge-label {
  font-size: 13px;
  color: #909399;
  padding: 2px 6px;
}
.expand-toggle {
  flex-shrink: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  color: #909399;
  transition: background 0.2s;
}
.expand-toggle:hover {
  background: #f0f2f5;
}
.toggle-icon {
  transition: transform 0.3s ease;
  font-size: 16px;
}

/* ===== 评价列表 ===== */
.review-list-wrap {
  border-top: 1px solid #ebeef5;
  overflow: hidden;
}
.review-list {
  padding: 16px 20px;
}
.no-reviews {
  padding: 20px 0;
}
.review-item {
  padding: 16px;
  margin-bottom: 12px;
  border-radius: 8px;
  background: #fafafa;
  border-left: 3px solid #dcdfe6;
  transition: background-color 0.2s;
}
.review-item:hover {
  background: #f5f7fa;
}
.review-item:last-child {
  margin-bottom: 0;
}
.review-item.border-good { border-left-color: #67c23a; }
.review-item.border-mid { border-left-color: #e6a23c; }
.review-item.border-bad { border-left-color: #f56c6c; }

.review-header {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}
.user-avatar {
  background: linear-gradient(135deg, #409eff, #79bbff);
  color: #fff;
  font-size: 14px;
  flex-shrink: 0;
}
.review-user-info {
  margin-left: 10px;
  flex: 1;
  display: flex;
  align-items: center;
  gap: 8px;
}
.user-name {
  font-weight: 600;
  color: #303133;
  font-size: 14px;
}
.review-rating :deep(.el-rate__icon) {
  font-size: 14px !important;
}
.review-right {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}
.review-time {
  color: #c0c4cc;
  font-size: 12px;
}

.review-content {
  color: #606266;
  font-size: 14px;
  line-height: 1.6;
  margin-bottom: 10px;
  padding-left: 46px;
}

/* ===== 商家回复 ===== */
.admin-reply-box {
  margin-left: 46px;
  background: #ecf5ff;
  border-left: 3px solid #409eff;
  border-radius: 8px;
  padding: 12px 16px;
  margin-bottom: 10px;
}
.reply-label {
  font-size: 12px;
  color: #409eff;
  font-weight: 600;
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 4px;
}
.reply-time {
  font-weight: 400;
  color: #a0cfff;
  margin-left: 8px;
}
.reply-content {
  color: #606266;
  font-size: 13px;
  line-height: 1.5;
}

/* ===== 内联回复框 ===== */
.inline-reply-box {
  margin-left: 46px;
  margin-bottom: 10px;
}
.reply-actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 8px;
}

/* ===== 操作区 ===== */
.review-actions {
  display: flex;
  justify-content: flex-end;
  gap: 4px;
  padding-left: 46px;
}

/* ===== 评价分页 ===== */
.review-pagination {
  display: flex;
  justify-content: center;
  padding-top: 12px;
  border-top: 1px dashed #ebeef5;
  margin-top: 12px;
}

/* ===== 商品分页 ===== */
.product-pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* ===== 空状态 ===== */
.empty-state {
  padding: 60px 0;
  text-align: center;
}

/* ===== 动画 ===== */
.slide-down-enter-active,
.slide-down-leave-active {
  transition: all 0.3s ease;
  max-height: 2000px;
  opacity: 1;
}
.slide-down-enter-from,
.slide-down-leave-to {
  max-height: 0;
  opacity: 0;
  overflow: hidden;
}
</style>

<!-- 暗黑模式适配（不带scoped，html.dark在根元素） -->
<style>
/* 统计卡片 */
html.dark .review-manage .stat-card {
  background: #1d1e1f;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
html.dark .review-manage .stat-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.4);
}
html.dark .review-manage .stat-value {
  color: #e0e0e0;
}
html.dark .review-manage .stat-label {
  color: #a0a0a0;
}

/* 筛选卡片 */
html.dark .review-manage .filter-card {
  border-color: #303030;
}

/* 商品卡片 */
html.dark .review-manage .product-card {
  background: #1d1e1f;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
html.dark .review-manage .product-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
}
html.dark .review-manage .product-header:hover {
  background-color: #2a2a2a;
}
html.dark .review-manage .product-name {
  color: #e0e0e0;
}
html.dark .review-manage .image-placeholder {
  background: #2a2a2a;
  color: #555;
}
html.dark .review-manage .expand-toggle:hover {
  background: #2a2a2a;
}
html.dark .review-manage .expand-toggle {
  color: #666;
}
html.dark .review-manage .badge-label {
  color: #a0a0a0;
}

/* 评价列表 */
html.dark .review-manage .review-list-wrap {
  border-top-color: #303030;
}
html.dark .review-manage .review-item {
  background: #141414;
  border-left-color: #434343;
}
html.dark .review-manage .review-item:hover {
  background: #1d1e1f;
}
html.dark .review-manage .review-item.border-good { border-left-color: #67c23a; }
html.dark .review-manage .review-item.border-mid { border-left-color: #e6a23c; }
html.dark .review-manage .review-item.border-bad { border-left-color: #f56c6c; }

/* 评价头部 */
html.dark .review-manage .user-name {
  color: #e0e0e0;
}
html.dark .review-manage .review-time {
  color: #555;
}

/* 评价内容 */
html.dark .review-manage .review-content {
  color: #d0d0d0;
}

/* 商家回复 */
html.dark .review-manage .admin-reply-box {
  background: rgba(64, 158, 255, 0.08);
  border-left-color: #409eff;
}
html.dark .review-manage .reply-label {
  color: #79bbff;
}
html.dark .review-manage .reply-time {
  color: #555;
}
html.dark .review-manage .reply-content {
  color: #d0d0d0;
}

/* 评价分页 */
html.dark .review-manage .review-pagination {
  border-top-color: #303030;
}

/* 空状态 */
html.dark .review-manage .unreplied-tip {
  color: #eebe77;
}
</style>
