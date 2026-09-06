<template>
  <div class="app-container shop-product">
    <!-- 搜索区域 -->
    <el-form :inline="true" :model="queryParams" class="search-bar">
      <el-form-item>
        <el-input v-model="queryParams.name" placeholder="搜索商品名称" clearable prefix-icon="Search" @keyup.enter="handleSearch" style="width: 280px" />
      </el-form-item>
      <el-form-item>
        <el-select v-model="queryParams.category" placeholder="全部分类" clearable @change="handleSearch">
          <el-option v-for="c in categories" :key="c" :label="c" :value="c" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-select v-model="queryParams.orderBy" placeholder="排序方式" clearable @change="handleSearch" style="width: 140px">
          <el-option label="最新上架" value="newest" />
          <el-option label="销量优先" value="salesDesc" />
          <el-option label="价格从低到高" value="priceAsc" />
          <el-option label="价格从高到低" value="priceDesc" />
          <el-option label="好评优先" value="ratingDesc" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 商品卡片列表 -->
    <div v-loading="loading" class="product-grid">
      <div v-if="tableData.length === 0 && !loading" class="empty-tip">
        <el-empty description="暂无上架商品" />
      </div>
      <div v-for="item in tableData" :key="item.productId" class="product-card" @click="handleDetail(item)">
        <div class="card-image">
          <el-image v-if="item.imageUrl" :src="item.imageUrl" fit="contain" style="width: 100%; height: 100%" />
          <div v-else class="no-image">
            <el-icon :size="40"><Goods /></el-icon>
          </div>
        </div>
        <div class="card-body">
          <div class="card-name">{{ item.name }}</div>
          <div v-if="item.highlights" class="card-highlights">{{ item.highlights.split('\n')[0] }}</div>
          <div class="card-meta">
            <span v-if="item.salesCount > 0" class="meta-sales">
              已售 {{ item.salesCount > 999 ? (item.salesCount / 1000).toFixed(1) + 'k' : item.salesCount }}
            </span>
            <span v-if="item.avgRating > 0" class="meta-rating">
              <el-icon style="color: #f7ba2a; vertical-align: middle"><Star /></el-icon>
              {{ item.avgRating }}
              <span class="meta-count">({{ item.reviewCount }})</span>
            </span>
          </div>
          <div class="card-footer">
            <span class="card-price">{{ Number(item.price).toFixed(2) }}</span>
            <el-button type="warning" size="small" circle @click.stop="addToCart(item)">
              <el-icon><ShoppingCart /></el-icon>
            </el-button>
          </div>
        </div>
      </div>
    </div>

    <!-- 分页 -->
    <el-pagination
      v-show="total > 0"
      v-model:current-page="queryParams.pageNum"
      v-model:page-size="queryParams.pageSize"
      :page-sizes="[8, 16, 24]"
      :total="total"
      layout="total, sizes, prev, pager, next"
      class="pagination"
      @size-change="loadData"
      @current-change="loadData"
    />

    <!-- 商品详情弹窗 -->
    <el-dialog v-model="detailVisible" :title="detailProduct.name" width="1000px" class="scrollbar" destroy-on-close top="3vh">
      <!-- Hero区：图片 + 信息 -->
      <div class="detail-hero">
        <!-- 左侧图片 -->
        <div class="detail-hero-image">
          <div class="detail-image-box">
            <el-image v-if="detailProduct.imageUrl" :src="detailProduct.imageUrl" fit="contain" :preview-src-list="[detailProduct.imageUrl]" preview-teleported style="width: 100%; max-height: 360px" />
            <div v-else class="no-image-large">
              <el-icon :size="80"><Goods /></el-icon>
              <span>暂无图片</span>
            </div>
          </div>
        </div>

        <!-- 右侧信息 -->
        <div class="detail-hero-info">
          <h2 class="detail-product-name">{{ detailProduct.name }}</h2>

          <!-- 价格条 -->
          <div class="detail-price-bar">
            <div class="price-main">
              <span class="price-symbol">&yen;</span>
              <span class="price-value">{{ Number(detailProduct.price || 0).toFixed(2) }}</span>
            </div>
            <div class="price-meta">
              <span v-if="detailProduct.salesCount > 0" class="detail-sales">
                <el-icon><Sell /></el-icon> 已售 {{ detailProduct.salesCount }} 件
              </span>
              <span v-if="detailProduct.avgRating > 0" class="detail-rating-mini">
                <el-icon style="color: #f7ba2a"><Star /></el-icon> {{ detailProduct.avgRating }} 分
              </span>
            </div>
          </div>

          <!-- 信息chips -->
          <div class="detail-info-chips">
            <div class="info-chip">
              <el-icon><Menu /></el-icon>
              <span class="chip-label">分类</span>
              <span class="chip-value">{{ detailProduct.category || '-' }}</span>
            </div>
            <div class="info-chip" :class="detailProduct.stock > 0 ? 'chip-ok' : 'chip-danger'">
              <el-icon><Box /></el-icon>
              <span class="chip-label">库存</span>
              <span class="chip-value">{{ detailProduct.stock > 0 ? detailProduct.stock + ' 件' : '暂时缺货' }}</span>
            </div>
            <div v-if="detailReviewStats.count > 0" class="info-chip">
              <el-icon><ChatDotSquare /></el-icon>
              <span class="chip-label">评价</span>
              <span class="chip-value">{{ detailReviewStats.count }} 条</span>
            </div>
          </div>

          <!-- 快速卖点 -->
          <div v-if="detailProduct.highlights" class="detail-quick-highlights">
            <div v-for="(line, idx) in detailProduct.highlights.split('\n').slice(0, 3)" :key="idx" class="highlight-line">
              <el-icon class="highlight-icon"><CircleCheck /></el-icon>
              <span>{{ line }}</span>
            </div>
          </div>

          <!-- 操作按钮 -->
          <div class="detail-actions">
            <el-button type="warning" size="large" @click="addToCartFromDetail" class="action-btn">
              <el-icon><ShoppingCart /></el-icon> 加入购物车
            </el-button>
            <el-button type="danger" size="large" @click="handleBuy" class="action-btn">
              立即购买
            </el-button>
            <el-button type="primary" size="large" @click="askAi" class="action-btn" plain>
              <el-icon><Service /></el-icon> 咨询AI客服
            </el-button>
          </div>
        </div>
      </div>

      <el-divider />
      <!-- 区块1：商品介绍 -->
      <div class="detail-section">
        <div class="section-header">
          <el-icon class="section-icon icon-intro"><Document /></el-icon>
          <h3>商品介绍</h3>
        </div>
        <div class="section-content">
          <div v-if="detailProduct.highlights" class="info-block">
            <div class="info-block-title">
              <span class="block-dot"></span> 核心卖点
            </div>
            <div class="highlights-grid">
              <div v-for="(line, idx) in detailProduct.highlights.split('\n').filter(l => l.trim())" :key="idx" class="highlight-item">
                <el-icon class="highlight-check"><Select /></el-icon>
                <span>{{ line }}</span>
              </div>
            </div>
          </div>
          <div v-if="detailProduct.description" class="info-block">
            <div class="info-block-title">
              <span class="block-dot"></span> 商品规格
            </div>
            <div class="description-text">{{ detailProduct.description }}</div>
          </div>
          <div v-if="!detailProduct.highlights && !detailProduct.description" class="empty-section">暂无商品介绍</div>
        </div>
      </div>

      <!-- 区块2：售后服务 -->
      <div class="detail-section">
        <div class="section-header">
          <el-icon class="section-icon icon-service"><Service /></el-icon>
          <h3>售后服务</h3>
        </div>
        <div class="section-content">
          <div class="service-cards" v-if="detailProduct.refundPolicy || detailProduct.warrantyInfo || detailProduct.afterSaleNote">
            <div v-if="detailProduct.refundPolicy" class="service-card">
              <div class="service-card-icon">
                <el-icon :size="24"><Refresh /></el-icon>
              </div>
              <div class="service-card-body">
                <div class="service-card-title">退换货政策</div>
                <div class="service-card-text">{{ detailProduct.refundPolicy }}</div>
              </div>
            </div>
            <div v-if="detailProduct.warrantyInfo" class="service-card">
              <div class="service-card-icon icon-warranty">
                <el-icon :size="24"><CircleCheck /></el-icon>
              </div>
              <div class="service-card-body">
                <div class="service-card-title">保修信息</div>
                <div class="service-card-text">{{ detailProduct.warrantyInfo }}</div>
              </div>
            </div>
            <div v-if="detailProduct.afterSaleNote" class="service-card">
              <div class="service-card-icon icon-note">
                <el-icon :size="24"><InfoFilled /></el-icon>
              </div>
              <div class="service-card-body">
                <div class="service-card-title">售后须知</div>
                <div class="service-card-text">{{ detailProduct.afterSaleNote }}</div>
              </div>
            </div>
          </div>
          <div v-else class="empty-section">暂无售后服务信息</div>
        </div>
      </div>

      <!-- 区块3：用户评价 -->
      <div class="detail-section">
        <div class="section-header">
          <el-icon class="section-icon icon-review"><ChatDotSquare /></el-icon>
          <h3>用户评价</h3>
          <el-badge v-if="detailReviewStats.count > 0" :value="detailReviewStats.count" :max="999" type="info" class="review-badge" />
        </div>
        <div class="section-content">
          <!-- 评价统计条 -->
          <div v-if="detailReviewStats.count > 0" class="review-stats-bar">
            <div class="stats-score">
              <span class="big-score">{{ detailReviewStats.avgRating }}</span>
              <el-rate :model-value="detailReviewStats.avgRating" disabled show-score />
            </div>
            <div class="stats-tags">
              <el-tag :type="reviewFilter === '' ? 'primary' : 'info'" @click="filterReviews('')" class="filter-tag" effect="plain">
                全部({{ detailReviewStats.count }})
              </el-tag>
              <el-tag :type="reviewFilter === 'good' ? 'success' : 'info'" @click="filterReviews('good')" class="filter-tag" effect="plain">
                好评({{ detailReviewStats.goodCount || 0 }})
              </el-tag>
              <el-tag :type="reviewFilter === 'mid' ? 'warning' : 'info'" @click="filterReviews('mid')" class="filter-tag" effect="plain">
                中评({{ detailReviewStats.midCount || 0 }})
              </el-tag>
              <el-tag :type="reviewFilter === 'bad' ? 'danger' : 'info'" @click="filterReviews('bad')" class="filter-tag" effect="plain">
                差评({{ detailReviewStats.badCount || 0 }})
              </el-tag>
              <span v-if="detailReviewStats.goodRate > 0" class="good-rate">
                {{ detailReviewStats.goodRate }}% 好评率
              </span>
            </div>
          </div>

          <!-- 评价列表 -->
          <div v-for="r in detailReviews" :key="r.reviewId" class="review-item">
            <div class="review-item-header">
              <div class="review-avatar">{{ (r.nickName || '匿')[0] }}</div>
              <div class="review-user-info">
                <span class="review-nick">{{ r.nickName || '匿名用户' }}</span>
                <span class="review-time">{{ formatReviewDate(r.createTime) }}</span>
              </div>
              <el-rate :model-value="r.rating" disabled size="small" />
            </div>
            <div v-if="r.content" class="review-text">{{ r.content }}</div>
            <div v-if="r.adminReply" class="review-admin-reply">
              <span class="reply-label">商家回复：</span>{{ r.adminReply }}
            </div>
          </div>

          <!-- 评价分页 -->
          <div v-if="reviewTotal > 5" class="review-pagination">
            <el-pagination
              v-model:current-page="reviewPageNum"
              :page-size="5"
              :total="reviewTotal"
              layout="prev, pager, next"
              small
              @current-change="loadReviews"
            />
          </div>

          <div v-if="detailReviewStats.count === 0" class="empty-section">暂无评价</div>
        </div>
      </div>
    </el-dialog>

    <!-- 下单确认弹窗 -->
    <el-dialog v-model="buyDialogVisible" title="确认下单" width="550px" destroy-on-close>
      <el-form :model="buyForm" label-width="80px">
        <el-form-item label="商品">
          <span>{{ detailProduct.name }}</span>
        </el-form-item>
        <el-form-item label="单价">
          <span style="color: #f56c6c; font-weight: bold">&yen;{{ Number(detailProduct.price || 0).toFixed(2) }}</span>
        </el-form-item>
        <el-form-item label="数量">
          <el-input-number v-model="buyForm.quantity" :min="1" :max="detailProduct.stock || 99" />
        </el-form-item>
        <el-form-item label="收货地址">
          <div style="width: 100%">
            <div v-if="buyAddressList.length > 0">
              <el-radio-group v-model="buySelectedAddressId" style="width: 100%">
                <div v-for="addr in buyAddressList" :key="addr.addressId" class="buy-address-item" :class="{ active: buySelectedAddressId === addr.addressId }">
                  <el-radio :value="addr.addressId">
                    <span style="font-weight: 600">{{ addr.contactName }}</span>
                    <span style="color: #909399; margin: 0 8px">{{ addr.phone }}</span>
                    <span style="color: #606266; font-size: 13px">{{ [addr.province, addr.city, addr.district, addr.detail].filter(Boolean).join('') }}</span>
                  </el-radio>
                </div>
              </el-radio-group>
            </div>
            <div v-if="showBuyNewAddr || buyAddressList.length === 0" style="background: #f8f9fb; padding: 12px; border-radius: 8px; margin-top: 8px">
              <el-row :gutter="8">
                <el-col :span="12"><el-input v-model="buyNewAddr.contactName" placeholder="收货人" size="small" /></el-col>
                <el-col :span="12"><el-input v-model="buyNewAddr.phone" placeholder="手机号" size="small" /></el-col>
              </el-row>
              <el-cascader
                v-model="buyNewAddr.selectedRegion"
                :options="regionData"
                :props="{ value: 'label' }"
                placeholder="请选择省/市/区"
                style="width: 100%; margin-top: 8px"
                size="small"
                clearable
              />
              <el-input v-model="buyNewAddr.detail" placeholder="详细地址（街道、楼栋、门牌号）" size="small" style="margin-top: 8px" />
              <div style="margin-top: 8px; text-align: right">
                <el-button type="primary" size="small" @click="saveBuyNewAddr">保存</el-button>
              </div>
            </div>
            <el-button v-if="!showBuyNewAddr && buyAddressList.length > 0" link type="primary" size="small" style="margin-top: 6px" @click="showBuyNewAddr = true">+ 使用新地址</el-button>
          </div>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="buyForm.remark" type="textarea" :rows="2" placeholder="选填" />
        </el-form-item>
        <el-form-item label="合计">
          <span style="color: #f56c6c; font-size: 20px; font-weight: bold">
            &yen;{{ (Number(detailProduct.price || 0) * buyForm.quantity).toFixed(2) }}
          </span>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="buyDialogVisible = false">取消</el-button>
        <el-button type="danger" :loading="buyLoading" @click="submitOrder">确认下单</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Goods, ShoppingCart, Star, Refresh, CircleCheck, InfoFilled, Sell, Service, ChatDotSquare, Document, Select, Menu, Box } from '@element-plus/icons-vue'
import { listShopProducts, getShopProduct } from '@/api/shop/product'
import { createOrder } from '@/api/business/order'
import { listMyAddresses, addAddress } from '@/api/business/address'
import { listProductReviews, getProductReviewStats } from '@/api/business/review'
import useCartStore from '@/store/modules/cart'
import { regionData } from 'element-china-area-data'

const router = useRouter()
const route = useRoute()
const cartStore = useCartStore()

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const detailVisible = ref(false)
const detailProduct = ref({})
const categories = ref([])
const detailReviews = ref([])
const detailReviewStats = ref({ avgRating: 0, count: 0, goodCount: 0, midCount: 0, badCount: 0, goodRate: 0 })
const reviewFilter = ref('')
const reviewPageNum = ref(1)
const reviewTotal = ref(0)

const queryParams = reactive({ name: '', category: '', pageNum: 1, pageSize: 8, orderBy: '' })

const loadData = async () => {
  loading.value = true
  try {
    const res = await listShopProducts(queryParams)
    tableData.value = res.rows || []
    total.value = res.total || 0
    // 收集分类选项
    const cats = new Set(categories.value)
    tableData.value.forEach(p => { if (p.category) cats.add(p.category) })
    categories.value = [...cats]
  } finally { loading.value = false }
}

const handleSearch = () => { queryParams.pageNum = 1; loadData() }
const resetQuery = () => { queryParams.name = ''; queryParams.category = ''; queryParams.orderBy = ''; queryParams.pageNum = 1; loadData() }

const handleDetail = async (item) => {
  // 重置评价相关状态
  reviewFilter.value = ''
  reviewPageNum.value = 1
  reviewTotal.value = 0
  detailReviews.value = []
  detailReviewStats.value = { avgRating: 0, count: 0, goodCount: 0, midCount: 0, badCount: 0, goodRate: 0 }

  // 获取商品详情，合并列表项中已有的评价数据作为兜底
  const res = await getShopProduct(item.productId)
  if (res.data) {
    detailProduct.value = {
      ...item,
      ...res.data
    }
  } else {
    detailProduct.value = item
  }
  detailVisible.value = true

  // 并行加载评价列表和统计
  try {
    const [reviewRes, statsRes] = await Promise.all([
      listProductReviews(item.productId, { pageNum: 1, pageSize: 5 }),
      getProductReviewStats(item.productId)
    ])
    detailReviews.value = reviewRes.rows || []
    reviewTotal.value = reviewRes.total || 0
    detailReviewStats.value = statsRes.data || { avgRating: 0, count: 0, goodCount: 0, midCount: 0, badCount: 0, goodRate: 0 }
  } catch (e) {
    console.warn('评价数据加载失败:', e)
  }
}

const loadReviews = async () => {
  if (!detailProduct.value.productId) return
  try {
    const res = await listProductReviews(detailProduct.value.productId, {
      pageNum: reviewPageNum.value,
      pageSize: 5,
      ratingLevel: reviewFilter.value || undefined
    })
    detailReviews.value = res.rows || []
    reviewTotal.value = res.total || 0
  } catch (e) {
    console.warn('评价列表加载失败:', e)
  }
}

const filterReviews = (level) => {
  reviewFilter.value = level
  reviewPageNum.value = 1
  loadReviews()
}

const formatReviewDate = (dt) => {
  if (!dt) return ''
  return dt.replace('T', ' ').substring(0, 16)
}

const askAi = () => {
  detailVisible.value = false
  router.push({ path: '/customer/chat', query: { productName: detailProduct.value.name } })
}

const addToCart = async (product) => {
  if (await cartStore.addItem(product)) {
    ElMessage.success('已加入购物车')
  }
}

const addToCartFromDetail = async () => {
  if (await cartStore.addItem(detailProduct.value)) {
    ElMessage.success('已加入购物车')
  }
}

const buyDialogVisible = ref(false)
const buyLoading = ref(false)
const buyForm = reactive({ quantity: 1, remark: '' })

// 地址管理
const buyAddressList = ref([])
const buySelectedAddressId = ref(null)
const showBuyNewAddr = ref(false)
const buyNewAddr = reactive({ contactName: '', phone: '', selectedRegion: [], detail: '' })

const handleBuy = async () => {
  buyForm.quantity = 1
  buyForm.remark = ''
  showBuyNewAddr.value = false
  buyNewAddr.contactName = ''
  buyNewAddr.phone = ''
  buyNewAddr.selectedRegion = []
  buyNewAddr.detail = ''
  // 加载地址列表
  try {
    const res = await listMyAddresses()
    buyAddressList.value = res.data || []
    const def = buyAddressList.value.find(a => a.isDefault === 1)
    buySelectedAddressId.value = def ? def.addressId : (buyAddressList.value.length > 0 ? buyAddressList.value[0].addressId : null)
  } catch { buyAddressList.value = [] }
  buyDialogVisible.value = true
}

const saveBuyNewAddr = async () => {
  if (!buyNewAddr.contactName.trim()) { ElMessage.warning('请输入收货人姓名'); return }
  if (!buyNewAddr.phone.trim()) { ElMessage.warning('请输入手机号'); return }
  if (!buyNewAddr.selectedRegion || buyNewAddr.selectedRegion.length < 3) { ElMessage.warning('请选择省/市/区'); return }
  if (!buyNewAddr.detail.trim()) { ElMessage.warning('请输入详细地址'); return }
  try {
    const res = await addAddress({
      contactName: buyNewAddr.contactName,
      phone: buyNewAddr.phone,
      province: buyNewAddr.selectedRegion[0],
      city: buyNewAddr.selectedRegion[1],
      district: buyNewAddr.selectedRegion[2],
      detail: buyNewAddr.detail
    })
    const saved = res.data || res
    const listRes = await listMyAddresses()
    buyAddressList.value = listRes.data || []
    buySelectedAddressId.value = saved.addressId || buyAddressList.value[0]?.addressId
    showBuyNewAddr.value = false
    ElMessage.success('地址保存成功')
  } catch (e) {
    ElMessage.error(e.message || '保存失败')
  }
}

const submitOrder = async () => {
  const addr = buyAddressList.value.find(a => a.addressId === buySelectedAddressId.value)
  if (!addr) {
    ElMessage.warning('请选择或新增收货地址')
    return
  }
  const addressStr = [addr.contactName, addr.phone, addr.province, addr.city, addr.district, addr.detail].filter(Boolean).join(' ')
  buyLoading.value = true
  try {
    await createOrder({
      address: addressStr,
      remark: buyForm.remark,
      items: [{ productId: detailProduct.value.productId, quantity: buyForm.quantity }]
    })
    buyDialogVisible.value = false
    detailVisible.value = false
    ElMessageBox.confirm('订单已创建，是否前往"我的订单"查看？', '下单成功', {
      confirmButtonText: '去查看',
      cancelButtonText: '继续浏览',
      type: 'success'
    }).then(() => {
      router.push({ path: '/customer/orders' })
    }).catch(() => {})
  } catch (e) {
    ElMessage.error(e.message || '下单失败，请重试')
  } finally {
    buyLoading.value = false
  }
}

onMounted(async () => {
  await loadData()
  // 处理 highlight 参数：自动打开指定商品的详情弹窗
  const highlightId = route.query.highlight
  if (highlightId) {
    const target = tableData.value.find(p => String(p.productId) === String(highlightId))
    if (target) {
      handleDetail(target)
    } else {
      // 商品不在当前页，直接通过 API 获取并打开详情
      try {
        const res = await getShopProduct(highlightId)
        if (res.data) {
          handleDetail(res.data)
        }
      } catch (e) {
        console.warn('高亮商品加载失败:', e)
      }
    }
  }
})
</script>

<style scoped>
.app-container.shop-product {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
  min-height: calc(100vh - 84px);
  background-color: #f5f7fa;
}

/* 搜索栏优化 */
.search-bar {
  background: #ffffff;
  padding: 18px 20px 2px;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
  margin-bottom: 20px;
  border: 1px solid #ebeef5;
}

/* 商品网格优化 */
.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 20px;
  min-height: 200px;
  padding-bottom: 20px;
}

.product-card {
  background: #ffffff;
  border: 1px solid #ebeef5;
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  position: relative;
  display: flex;
  flex-direction: column;
}

.product-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.08);
  border-color: #c6e2ff;
}

.card-image {
  height: 200px;
  background: #f8f9fb;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  position: relative;
}

.card-image :deep(.el-image) {
  transition: transform 0.5s ease;
}

.product-card:hover .card-image :deep(.el-image) {
  transform: scale(1.08);
}

.no-image {
  color: #dcdfe6;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}

.card-body {
  padding: 16px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.card-name {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.card-highlights {
  font-size: 13px;
  color: #909399;
  background: #f4f4f5;
  padding: 4px 8px;
  border-radius: 6px;
  margin-bottom: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  align-self: flex-start;
  max-width: 100%;
}

.card-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 8px;
  font-size: 12px;
  color: #909399;
}
.meta-sales {
  color: #ff6b35;
  font-weight: 500;
}
.meta-rating {
  display: flex;
  align-items: center;
  gap: 2px;
}
.meta-count {
  color: #c0c4cc;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
  padding-top: 12px;
  border-top: 1px solid #f2f6fc;
}

.card-price {
  color: #f56c6c;
  font-size: 20px;
  font-weight: 800;
  font-family: 'DIN Alternate', sans-serif;
}

.card-price::before {
  content: '¥';
  font-size: 14px;
  margin-right: 2px;
  font-weight: 600;
}

/* 购物车按钮悬浮效果 */
.card-footer :deep(.el-button) {
  transition: all 0.3s;
  box-shadow: 0 2px 8px rgba(230, 162, 60, 0.3);
}

.card-footer :deep(.el-button:hover) {
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(230, 162, 60, 0.5);
}

/* 分页优化 */
.pagination {
  margin-top: 10px;
  justify-content: flex-end;
  background: #fff;
  padding: 16px 20px;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
}

.empty-tip {
  grid-column: 1 / -1;
  padding: 40px 0;
  background: #fff;
  border-radius: 12px;
}

/* ==================== 详情弹窗 ==================== */

/* Hero区：图片+信息两栏 */
.detail-hero {
  display: flex;
  gap: 28px;
}
.detail-hero-image {
  flex: 0 0 360px;
}
.detail-hero-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

/* 商品名 */
.detail-product-name {
  font-size: 20px;
  font-weight: 700;
  color: #1d2129;
  margin: 0 0 12px 0;
  line-height: 1.4;
}

/* 图片容器 */
.detail-image-box {
  background: #f8f9fb;
  border-radius: 14px;
  padding: 16px;
  border: 1px solid #ebeef5;
  text-align: center;
  overflow: hidden;
}
.detail-image-box :deep(.el-image) {
  border-radius: 8px;
  cursor: zoom-in;
}
.no-image-large {
  height: 280px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #c0c4cc;
  gap: 12px;
  font-size: 14px;
}

/* 价格条 */
.detail-price-bar {
  background: linear-gradient(135deg, #fff1f0 0%, #fff7e6 100%);
  padding: 16px 20px;
  border-radius: 12px;
  margin-bottom: 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.price-main {
  display: flex;
  align-items: baseline;
}
.price-symbol {
  font-size: 16px;
  font-weight: 700;
  color: #f56c6c;
  margin-right: 2px;
}
.price-value {
  font-size: 32px;
  font-weight: 800;
  color: #f56c6c;
  font-family: 'DIN Alternate', 'Helvetica Neue', sans-serif;
  letter-spacing: -0.5px;
}
.price-meta {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 4px;
  font-size: 13px;
  color: #909399;
}
.price-meta .el-icon {
  vertical-align: -2px;
  margin-right: 2px;
}
.detail-sales,
.detail-rating-mini {
  display: flex;
  align-items: center;
  gap: 4px;
}

/* 信息chips */
.detail-info-chips {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}
.info-chip {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 14px;
  background: #f5f7fa;
  border-radius: 8px;
  font-size: 13px;
  border: 1px solid #ebeef5;
  transition: all 0.2s;
}
.info-chip .el-icon {
  color: #409eff;
  font-size: 16px;
}
.chip-label {
  color: #909399;
}
.chip-value {
  color: #303133;
  font-weight: 600;
}
.chip-ok .chip-value { color: #67c23a; }
.chip-danger .chip-value { color: #f56c6c; font-weight: 700; }
.chip-danger { border-color: #fde2e2; background: #fef0f0; }

/* 快速卖点 */
.detail-quick-highlights {
  margin-bottom: 16px;
  padding: 12px 16px;
  background: #f0f9eb;
  border-radius: 10px;
  border: 1px solid #e1f3d8;
}
.highlight-line {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  font-size: 13px;
  color: #606266;
  line-height: 1.6;
  padding: 2px 0;
}
.highlight-icon {
  color: #67c23a;
  flex-shrink: 0;
  margin-top: 3px;
}

/* 操作按钮 */
.detail-actions {
  display: flex;
  gap: 10px;
  margin-top: auto;
  padding-top: 16px;
}
.action-btn {
  flex: 1;
  border-radius: 10px !important;
  font-size: 15px !important;
  height: 44px !important;
}

/* ==================== 垂直内容区块 ==================== */

.detail-section {
  margin-bottom: 24px;
}
.detail-section:last-child {
  margin-bottom: 0;
}
.section-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
}
.section-header h3 {
  font-size: 17px;
  font-weight: 700;
  color: #1d2129;
  margin: 0;
}
.section-icon {
  width: 28px;
  height: 28px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  color: #fff;
}
.icon-intro { background: linear-gradient(135deg, #409eff, #79bbff); }
.icon-service { background: linear-gradient(135deg, #67c23a, #95d475); }
.icon-review { background: linear-gradient(135deg, #e6a23c, #f0c78a); }

.section-content {
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 12px;
  padding: 20px;
}

/* 商品介绍 - 信息块 */
.info-block {
  margin-bottom: 20px;
}
.info-block:last-child {
  margin-bottom: 0;
}
.info-block-title {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  gap: 8px;
}
.block-dot {
  width: 4px;
  height: 16px;
  border-radius: 2px;
  background: #409eff;
  display: inline-block;
}
.highlights-grid {
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.highlight-item {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  font-size: 14px;
  color: #606266;
  line-height: 1.7;
  padding: 4px 8px;
  background: #f9fafb;
  border-radius: 6px;
}
.highlight-check {
  color: #67c23a;
  flex-shrink: 0;
  margin-top: 4px;
}
.description-text {
  font-size: 14px;
  color: #606266;
  line-height: 1.8;
  white-space: pre-wrap;
}
.empty-section {
  text-align: center;
  color: #c0c4cc;
  padding: 32px 0;
  font-size: 14px;
}

/* 售后服务 - 图标卡片 */
.service-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 14px;
}
.service-card {
  display: flex;
  gap: 14px;
  padding: 16px;
  background: #f9fafb;
  border-radius: 10px;
  border: 1px solid #ebeef5;
  transition: all 0.2s;
}
.service-card:hover {
  border-color: #c6e2ff;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}
.service-card-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  background: linear-gradient(135deg, #e8f4ff, #d9ecff);
  color: #409eff;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.service-card-icon.icon-warranty {
  background: linear-gradient(135deg, #f0f9eb, #e1f3d8);
  color: #67c23a;
}
.service-card-icon.icon-note {
  background: linear-gradient(135deg, #fdf6ec, #faecd8);
  color: #e6a23c;
}
.service-card-body {
  min-width: 0;
}
.service-card-title {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 4px;
}
.service-card-text {
  font-size: 13px;
  color: #909399;
  line-height: 1.6;
}

/* 评价统计条 */
.review-stats-bar {
  background: #fafafa;
  padding: 14px 18px;
  border-radius: 10px;
  margin-bottom: 16px;
  border: 1px solid #f0f0f0;
}
.stats-score {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
}
.big-score {
  font-size: 28px;
  font-weight: 800;
  color: #f7ba2a;
  font-family: 'DIN Alternate', sans-serif;
}
.stats-tags {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.filter-tag { cursor: pointer; }
.good-rate {
  color: #67c23a;
  font-size: 13px;
  font-weight: 600;
  margin-left: 4px;
}
.review-badge {
  margin-left: 4px;
}

/* 评价分页 */
.review-pagination {
  margin-top: 14px;
  display: flex;
  justify-content: center;
}

/* 下单地址选择 */
.buy-address-item {
  padding: 10px 12px;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  margin-bottom: 8px;
  transition: all 0.2s;
  cursor: pointer;
}

.buy-address-item:hover {
  border-color: #c6e2ff;
  background: #f5f7fa;
}

.buy-address-item.active {
  border-color: #409eff;
  background: #ecf5ff;
}

/* 评价列表 */
.review-item {
  padding: 14px 0;
  border-bottom: 1px solid #f2f3f5;
}
.review-item:last-child { border-bottom: none; }

.review-item-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 8px;
}
.review-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: linear-gradient(135deg, #409eff, #79bbff);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
  flex-shrink: 0;
}
.review-user-info {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-width: 0;
}
.review-nick {
  font-size: 13px;
  font-weight: 600;
  color: #303133;
}
.review-time {
  font-size: 12px;
  color: #c0c4cc;
}
.review-text {
  font-size: 13px;
  color: #303133;
  line-height: 1.7;
  padding-left: 42px;
}
.review-admin-reply {
  margin-top: 8px;
  margin-left: 42px;
  padding: 10px 14px;
  background: #ecf5ff;
  border-radius: 8px;
  font-size: 13px;
  color: #409eff;
  line-height: 1.6;
}
.reply-label {
  font-weight: 600;
  color: #337ecc;
}

/* 响应式 - 弹窗小屏堆叠 */
@media (max-width: 900px) {
  .detail-hero {
    flex-direction: column;
  }
  .detail-hero-image {
    flex: none;
  }
  .service-cards {
    grid-template-columns: 1fr;
  }
  .detail-actions {
    flex-wrap: wrap;
  }
  .action-btn {
    flex: 1 1 calc(50% - 5px);
    min-width: 120px;
  }
  .review-text,
  .review-admin-reply {
    padding-left: 0;
    margin-left: 0;
  }
}

/* 响应式 */
@media (max-width: 768px) {
  .app-container.shop-product {
    padding: 12px;
  }

  .product-grid {
    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
    gap: 12px;
  }

  .card-image {
    height: 140px;
  }

  .card-name {
    font-size: 14px;
  }

  .card-price {
    font-size: 16px;
  }
}
</style>
