<template>
  <div class="customer-layout">
    <!-- 顶部导航栏 -->
    <div class="customer-header">
      <!-- 左区：Logo + 系统名 -->
      <div class="header-left">
        <img src="@/assets/logo/logo.png" alt="Logo" class="nav-logo" />
        <span class="system-title">智能数码商城AI客服系统</span>
      </div>

      <!-- 中区：水平导航 -->
      <nav class="header-nav">
        <router-link
          v-for="tab in tabs"
          :key="tab.path"
          :to="tab.path"
          class="nav-item"
          :class="{ active: isActive(tab.path) }"
        >
          <el-icon :size="16"><component :is="tab.icon" /></el-icon>
          <span>{{ tab.label }}</span>
        </router-link>
      </nav>

      <!-- 右区：通知 + 购物车 + 用户 -->
      <div class="header-right">
        <!-- 通知铃铛 -->
        <el-popover placement="bottom" :width="360" trigger="click" transition="popover-slide" @show="loadNotifications">
          <template #reference>
            <div class="header-icon-btn">
              <el-badge :value="unreadCount" :hidden="unreadCount === 0" :max="99">
                <el-icon :size="20"><Bell /></el-icon>
              </el-badge>
            </div>
          </template>
          <div class="notification-panel">
            <div class="panel-header">
              <div class="panel-header-left">
                <el-icon :size="16" style="color: #409eff"><Bell /></el-icon>
                <span>通知</span>
                <span v-if="unreadCount > 0" class="notif-count-badge">{{ unreadCount }}</span>
              </div>
              <el-button link type="primary" size="small" @click="handleMarkAllRead" v-if="unreadCount > 0">全部已读</el-button>
            </div>
            <div v-if="notifications.length === 0" class="panel-empty">
              <el-icon :size="36" style="color: #dcdfe6; margin-bottom: 8px"><Bell /></el-icon>
              <div>暂无未读通知</div>
            </div>
            <TransitionGroup name="notif-list" tag="div" class="notification-list">
              <div
                v-for="item in notifications"
                :key="item.notificationId"
                class="notification-item"
                :class="{ 'is-expanded': expandedNotifId === item.notificationId }"
                @click="toggleNotifExpand(item)"
              >
                <div class="notif-icon" :style="{ background: (notifTypeConfig[item.type] || notifTypeConfig.DEFAULT).bgColor }">
                  <el-icon :size="16" color="#fff"><component :is="(notifTypeConfig[item.type] || notifTypeConfig.DEFAULT).icon" /></el-icon>
                </div>
                <div class="notif-body">
                  <div class="notif-title-row">
                    <span class="notification-title">{{ item.title }}</span>
                    <el-tag :type="(notifTypeConfig[item.type] || notifTypeConfig.DEFAULT).tagType" size="small" effect="light" round>
                      {{ (notifTypeConfig[item.type] || notifTypeConfig.DEFAULT).label }}
                    </el-tag>
                  </div>
                  <div class="notification-content" :class="{ expanded: expandedNotifId === item.notificationId }">{{ item.content }}</div>
                  <div v-if="expandedNotifId === item.notificationId" class="notif-actions">
                    <el-button link type="primary" size="small" @click.stop="handleReadNotification(item)">查看详情</el-button>
                  </div>
                  <div class="notification-time">{{ formatDate(item.createTime) }}</div>
                </div>
                <span class="notif-unread-dot"></span>
              </div>
            </TransitionGroup>
            <div class="panel-footer">
              <el-button link type="primary" size="small" @click="router.push('/customer/notifications')">查看全部通知</el-button>
            </div>
          </div>
        </el-popover>

        <!-- 购物车 -->
        <el-popover placement="bottom" :width="440" trigger="click" transition="popover-slide">
          <template #reference>
            <div class="header-icon-btn" :class="{ 'cart-bounce': cartBounce }">
              <el-badge :value="cartStore.totalCount" :hidden="cartStore.totalCount === 0" :max="99">
                <el-icon :size="20"><ShoppingCart /></el-icon>
              </el-badge>
            </div>
          </template>
          <div class="cart-panel">
            <div class="panel-header">
              <div class="panel-header-left">
                <el-icon :size="16" style="color: #409eff"><ShoppingCart /></el-icon>
                <span>购物车</span>
                <span v-if="cartStore.cartItems.length > 0" class="cart-count-badge">{{ cartStore.totalCount }}件</span>
              </div>
              <el-button v-if="cartStore.cartItems.length > 0" link type="danger" size="small" @click="cartStore.clearCart()">清空</el-button>
            </div>
            <div v-if="cartStore.cartItems.length === 0" class="cart-empty-state">
              <el-icon :size="48" class="cart-empty-icon"><ShoppingCart /></el-icon>
              <div style="color: #606266; font-size: 14px; margin-top: 8px">购物车是空的</div>
              <div style="color: #909399; font-size: 12px; margin-top: 4px">快去挑选心仪的商品吧</div>
              <el-button type="primary" size="small" round style="margin-top: 12px" @click="router.push('/customer/products')">去逛逛</el-button>
            </div>
            <TransitionGroup v-else name="cart-item" tag="div" class="cart-list">
              <div
                v-for="item in cartStore.cartItems"
                :key="item.productId"
                class="cart-item"
                :class="{ 'is-removing': removingItemId === item.productId }"
              >
                <el-checkbox v-model="item.checked" style="margin-right: 8px" />
                <img v-if="item.imageUrl" :src="item.imageUrl" class="cart-item-img" />
                <div v-else class="cart-item-img cart-item-img-placeholder">
                  <el-icon :size="20" style="color: #ccc"><Goods /></el-icon>
                </div>
                <div class="cart-item-info">
                  <div class="cart-item-name">{{ item.name }}</div>
                  <div class="cart-item-price">&yen;{{ item.price.toFixed(2) }}</div>
                </div>
                <div :class="{ 'qty-pulse': quantityChangedId === item.productId }">
                  <el-input-number v-model="item.quantity" :min="1" :max="item.stock || 999" size="small" style="width: 100px" @change="(val) => handleQuantityChange(item.productId, val)" />
                </div>
                <el-button class="cart-delete-btn" type="danger" link size="small" style="margin-left: 8px" @click="handleRemoveItem(item.productId)">
                  <el-icon><Delete /></el-icon>
                </el-button>
              </div>
            </TransitionGroup>
            <div v-if="cartStore.cartItems.length > 0" class="cart-footer">
              <div class="cart-total">
                <el-checkbox :model-value="cartStore.allChecked" @change="cartStore.toggleAll()">全选</el-checkbox>
                <span>合计：<b class="cart-total-price">&yen;{{ cartStore.checkedTotal.toFixed(2) }}</b></span>
              </div>
              <div class="cart-footer-actions">
                <el-button size="small" class="view-cart-btn" @click="router.push('/customer/cart')">查看完整购物车</el-button>
                <el-button type="primary" size="small" class="checkout-btn" :disabled="cartStore.checkedItems.length === 0" @click="openCheckout">去结算 ({{ cartStore.checkedItems.length }})</el-button>
              </div>
            </div>
          </div>
        </el-popover>

        <!-- 用户菜单 -->
        <el-dropdown trigger="click" @command="handleCommand">
          <span class="user-info">
            <el-avatar :size="28" :src="userStore.avatar">
              <el-icon :size="14"><User /></el-icon>
            </el-avatar>
            <span class="user-name">{{ userStore.nickName || userStore.name }}</span>
            <el-icon :size="12"><CaretBottom /></el-icon>
          </span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="profile">个人中心</el-dropdown-item>
              <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>

    <!-- 结算对话框 -->
    <el-dialog v-model="checkoutVisible" :title="checkoutStep === 1 ? '确认订单信息' : '模拟支付'" width="650px" destroy-on-close>
      <!-- ========== 步骤 1：确认订单信息 ========== -->
      <div v-if="checkoutStep === 1">
      <!-- 收货地址 -->
      <div class="checkout-section">
        <div class="checkout-section-title">收货地址</div>

        <!-- 操作行：下拉选择 + 按钮 -->
        <div class="address-toolbar">
          <el-select v-if="addressList.length > 0" v-model="selectedAddressId" placeholder="请选择收货地址" style="flex: 1" popper-class="address-select-dropdown">
            <el-option v-for="addr in addressList" :key="addr.addressId" :value="addr.addressId"
              :label="addr.contactName + ' ' + addr.phone + ' ' + [addr.province, addr.city, addr.district, addr.detail].filter(Boolean).join('')">
              <div class="address-option">
                <div class="address-option-row1">
                  <span><b>收货人：</b>{{ addr.contactName }}</span>
                  <span><b>联系电话：</b>{{ addr.phone }}</span>
                  <el-tag v-if="addr.isDefault === 1" size="small" type="warning">默认</el-tag>
                </div>
                <div class="address-option-row2">
                  <b>收货地址：</b>{{ [addr.province, addr.city, addr.district, addr.detail].filter(Boolean).join(' ') }}
                </div>
              </div>
            </el-option>
          </el-select>
          <el-button v-if="selectedAddress && selectedAddress.isDefault !== 1" size="small" @click="handleSetDefault(selectedAddressId)">设为默认</el-button>
          <el-button type="primary" size="small" @click="showNewAddressForm = !showNewAddressForm">
            <el-icon><Plus /></el-icon> 新增地址
          </el-button>
        </div>

        <!-- 选中地址详情卡片 -->
        <div v-if="selectedAddress" class="address-detail-card">
          <div class="address-detail-row">
            <span><b>收货人：</b>{{ selectedAddress.contactName }}</span>
            <span><b>联系电话：</b>{{ selectedAddress.phone }}</span>
            <el-tag v-if="selectedAddress.isDefault === 1" size="small" type="warning">默认</el-tag>
          </div>
          <div class="address-detail-row address-text">
            <b>收货地址：</b>{{ [selectedAddress.province, selectedAddress.city, selectedAddress.district, selectedAddress.detail].filter(Boolean).join(' ') }}
          </div>
        </div>

        <!-- 无地址提示 -->
        <div v-if="addressList.length === 0 && !showNewAddressForm" class="address-empty">暂无收货地址，请新增</div>

        <!-- 新增地址表单 -->
        <div v-if="showNewAddressForm" class="new-address-form">
          <el-form :model="newAddress" :inline="false" label-width="70px" size="small">
            <el-row :gutter="12">
              <el-col :span="12">
                <el-form-item label="收货人">
                  <el-input v-model="newAddress.contactName" placeholder="姓名" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="手机号">
                  <el-input v-model="newAddress.phone" placeholder="手机号" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="所在地区">
              <el-cascader v-model="selectedRegion" :options="regionData" :props="{ value: 'label' }" placeholder="请选择省/市/区" style="width: 100%" clearable />
            </el-form-item>
            <el-form-item label="详细地址">
              <el-input v-model="newAddress.detail" placeholder="街道、楼栋、门牌号等" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" size="small" @click="saveNewAddress">保存并使用</el-button>
              <el-button size="small" @click="showNewAddressForm = false">取消</el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>

      <!-- 商品清单 -->
      <div class="checkout-section">
        <div class="checkout-section-title">商品清单</div>
        <el-table :data="cartStore.checkedItems" stripe border size="small">
          <el-table-column label="商品" min-width="160">
            <template #default="{ row }">
              <div style="display: flex; align-items: center; gap: 8px">
                <img v-if="row.imageUrl" :src="row.imageUrl" style="width: 36px; height: 36px; border-radius: 4px; object-fit: cover" />
                <span>{{ row.name }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="price" label="单价" width="90" align="right">
            <template #default="{ row }">&yen;{{ row.price.toFixed(2) }}</template>
          </el-table-column>
          <el-table-column prop="quantity" label="数量" width="70" align="center" />
          <el-table-column label="小计" width="100" align="right">
            <template #default="{ row }">&yen;{{ (row.price * row.quantity).toFixed(2) }}</template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 备注 -->
      <el-form label-width="50px" style="margin-top: 16px">
        <el-form-item label="备注">
          <el-input v-model="checkoutForm.remark" type="textarea" :rows="2" placeholder="备注信息（可选）" />
        </el-form-item>
      </el-form>

      <div style="text-align: right; font-size: 16px; margin-top: 12px">
        合计：<b style="color: #f56c6c; font-size: 20px">&yen;{{ cartStore.checkedTotal.toFixed(2) }}</b>
      </div>
      </div>

      <!-- ========== 步骤 2：模拟支付 ========== -->
      <div v-if="checkoutStep === 2">
        <div class="pay-info">
          <div class="pay-row"><span class="pay-label">商品：</span><span>{{ payOrderData.productSummary || '-' }}</span></div>
          <div class="pay-row">
            <span class="pay-label">支付金额：</span>
            <span style="color: #f56c6c; font-size: 22px; font-weight: bold">&yen;{{ payOrderData.totalAmount }}</span>
          </div>
        </div>
        <div style="margin-top: 20px">
          <div style="font-weight: 600; margin-bottom: 10px; color: #606266">选择支付方式</div>
          <el-radio-group v-model="payMethod" size="large" style="display: flex; gap: 12px">
            <el-radio-button value="alipay">支付宝</el-radio-button>
            <el-radio-button value="wechat">微信支付</el-radio-button>
            <el-radio-button value="bank">银行卡</el-radio-button>
          </el-radio-group>
        </div>
      </div>

      <template #footer>
        <template v-if="checkoutStep === 1">
          <el-button @click="checkoutVisible = false">取消</el-button>
          <el-button :loading="checkoutLoading" @click="submitCheckout">稍后付款</el-button>
          <el-button type="primary" @click="goToPayStep">下一步：支付</el-button>
        </template>
        <template v-else>
          <el-button @click="checkoutStep = 1">返回修改</el-button>
          <el-button type="danger" :loading="payLoading" @click="confirmPay">确认支付</el-button>
        </template>
      </template>
    </el-dialog>

    <!-- 内容区 -->
    <div class="customer-content">
      <router-view />
      <!-- 全局页脚（AI对话页面除外） -->
      <div class="customer-footer" v-if="route.path !== '/customer/chat'">
        <div class="footer-divider"></div>
        <div class="footer-main">
          <el-icon :size="16"><Service /></el-icon>
          <span class="footer-title">智能数码商城AI客服系统</span>
        </div>
        <div class="footer-bottom">&copy; 2026 All Rights Reserved. · 如有问题请联系客服</div>
      </div>
      <!-- 回到顶部按钮 -->
      <el-backtop target=".customer-content" :bottom="40" :right="40" :visibility-height="300">
        <div class="backtop-btn">
          <el-icon :size="20"><Top /></el-icon>
        </div>
      </el-backtop>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, reactive, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { HomeFilled, ChatDotSquare, Goods, Document, Service, CaretBottom, Bell, User, ShoppingCart, Delete, Plus, WarningFilled, Top } from '@element-plus/icons-vue'
import useUserStore from '@/store/modules/user'
import useCartStore from '@/store/modules/cart'
import { getUnreadCount, getUnreadNotifications, markAsRead, markAllAsRead } from '@/api/business/notification'
import { formatDate } from '@/utils/format'
import { listMyAddresses, addAddress, setDefaultAddress } from '@/api/business/address'
import { createOrder, myUpdateOrderStatus } from '@/api/business/order'
import { regionData } from 'element-china-area-data'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const cartStore = useCartStore()

// 通知数据
const unreadCount = ref(0)
const notifications = ref([])
const expandedNotifId = ref(null)
let notificationTimer = null

// 通知类型配置
const notifTypeConfig = {
  ORDER_STATUS: { label: '订单状态', tagType: 'warning', icon: Document, bgColor: 'rgba(230, 162, 60, 0.15)', color: '#e6a23c' },
  TICKET_REPLY: { label: '工单回复', tagType: 'success', icon: Service, bgColor: 'rgba(103, 194, 58, 0.15)', color: '#67c23a' },
  STOCK_WARNING: { label: '库存预警', tagType: 'danger', icon: WarningFilled, bgColor: 'rgba(245, 108, 108, 0.15)', color: '#f56c6c' },
  TICKET_REFUND: { label: '退款通知', tagType: '', icon: Document, bgColor: 'rgba(144, 147, 153, 0.15)', color: '#909399' },
  TICKET_RESOLVED: { label: '工单已解决', tagType: 'primary', icon: Service, bgColor: 'rgba(64, 158, 255, 0.15)', color: '#409eff' },
  DEFAULT: { label: '系统通知', tagType: 'info', icon: Bell, bgColor: 'rgba(64, 158, 255, 0.15)', color: '#409eff' }
}

// 购物车结算
const checkoutVisible = ref(false)
const checkoutLoading = ref(false)
const checkoutForm = ref({ remark: '' })
const checkoutStep = ref(1) // 1 = 确认订单信息, 2 = 模拟支付
const cartBounce = ref(false)
const quantityChangedId = ref(null)
const removingItemId = ref(null)

// 模拟支付
const payLoading = ref(false)
const payMethod = ref('alipay')
const payOrderData = ref({ productSummary: '', totalAmount: '0.00' })

// 地址管理
const addressList = ref([])
const selectedAddressId = ref(null)
const showNewAddressForm = ref(false)
const selectedRegion = ref([])
const newAddress = reactive({ contactName: '', phone: '', detail: '' })
const selectedAddress = computed(() => addressList.value.find(a => a.addressId === selectedAddressId.value) || null)

const tabs = [
  { path: '/customer/home', label: '首页', icon: HomeFilled },
  { path: '/customer/chat', label: 'AI客服', icon: ChatDotSquare },
  { path: '/customer/products', label: '电子商城', icon: Goods },
  { path: '/customer/orders', label: '我的订单', icon: Document },
  { path: '/customer/tickets', label: '我的工单', icon: Service }
]

function isActive(path) {
  return route.path === path
}

function handleCommand(command) {
  if (command === 'profile') {
    router.push({ name: 'CustomerProfile' })
  } else if (command === 'logout') {
    ElMessageBox.confirm('确定退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      userStore.logOut().then(() => {
        router.push('/login')
      })
    }).catch(() => {})
  }
}

// 通知功能
function loadUnreadCount() {
  getUnreadCount().then(res => {
    unreadCount.value = res.data ?? res ?? 0
  }).catch(() => {})
}

function loadNotifications() {
  getUnreadNotifications().then(res => {
    notifications.value = res.data || []
  }).catch(() => {})
}

function handleReadNotification(item) {
  markAsRead(item.notificationId).then(() => {
    notifications.value = notifications.value.filter(n => n.notificationId !== item.notificationId)
    unreadCount.value = Math.max(0, unreadCount.value - 1)
    if (item.type === 'ORDER_STATUS') {
      router.push({ path: '/customer/orders', query: { orderId: item.refId } })
    } else if (item.type === 'TICKET_REPLY' || item.type === 'TICKET_REFUND' || item.type === 'TICKET_RESOLVED') {
      router.push({ path: '/customer/tickets', query: { ticketId: item.refId } })
    } else if (item.type === 'STOCK_WARNING') {
      router.push({ path: '/customer/products', query: { productId: item.refId } })
    }
  })
}

function handleMarkAllRead() {
  markAllAsRead().then(() => {
    notifications.value = []
    unreadCount.value = 0
  })
}

function toggleNotifExpand(item) {
  expandedNotifId.value = expandedNotifId.value === item.notificationId ? null : item.notificationId
}

// 购物车删除动效
function handleRemoveItem(productId) {
  removingItemId.value = productId
  setTimeout(() => {
    cartStore.removeItem(productId)
    removingItemId.value = null
  }, 250)
}

// 购物车数量变化脉冲
function handleQuantityChange(productId, val) {
  cartStore.updateQuantity(productId, val)
  quantityChangedId.value = productId
  setTimeout(() => { quantityChangedId.value = null }, 400)
}

// 购物车结算功能
async function openCheckout() {
  checkoutStep.value = 1
  checkoutForm.value = { remark: '' }
  showNewAddressForm.value = false
  selectedRegion.value = []
  newAddress.contactName = ''
  newAddress.phone = ''
  newAddress.detail = ''
  // 加载地址列表
  try {
    const res = await listMyAddresses()
    addressList.value = res.data || []
    // 自动选中默认地址
    const defaultAddr = addressList.value.find(a => a.isDefault === 1)
    selectedAddressId.value = defaultAddr ? defaultAddr.addressId : (addressList.value.length > 0 ? addressList.value[0].addressId : null)
  } catch { addressList.value = [] }
  checkoutVisible.value = true
}

async function saveNewAddress() {
  if (!newAddress.contactName.trim()) { ElMessage.warning('请输入收货人姓名'); return }
  if (!newAddress.phone.trim()) { ElMessage.warning('请输入手机号'); return }
  if (selectedRegion.value.length < 3) { ElMessage.warning('请选择省/市/区'); return }
  if (!newAddress.detail.trim()) { ElMessage.warning('请输入详细地址'); return }
  try {
    const res = await addAddress({
      contactName: newAddress.contactName,
      phone: newAddress.phone,
      province: selectedRegion.value[0],
      city: selectedRegion.value[1],
      district: selectedRegion.value[2],
      detail: newAddress.detail
    })
    const saved = res.data || res
    ElMessage.success('地址保存成功')
    // 重新加载列表并选中新地址
    const listRes = await listMyAddresses()
    addressList.value = listRes.data || []
    selectedAddressId.value = saved.addressId || addressList.value[0]?.addressId
    showNewAddressForm.value = false
  } catch (e) {
    ElMessage.error(e.message || '保存失败')
  }
}

async function handleSetDefault(addressId) {
  try {
    await setDefaultAddress(addressId)
    ElMessage.success('默认地址设置成功')
    const res = await listMyAddresses()
    addressList.value = res.data || []
    const defaultAddr = addressList.value.find(a => a.isDefault === 1)
    if (defaultAddr) {
      selectedAddressId.value = defaultAddr.addressId
    }
  } catch (e) {
    ElMessage.error(e.message || '设置失败')
  }
}

function buildAddressString() {
  const addr = addressList.value.find(a => a.addressId === selectedAddressId.value)
  if (!addr) return ''
  const parts = [addr.contactName, addr.phone, addr.province, addr.city, addr.district, addr.detail].filter(Boolean)
  return parts.join(' ')
}

// 进入支付步骤
function goToPayStep() {
  const addressStr = buildAddressString()
  if (!addressStr) {
    ElMessage.warning('请选择或新增收货地址')
    return
  }
  payOrderData.value = {
    productSummary: cartStore.checkedItems.map(i => i.name).join('、'),
    totalAmount: cartStore.checkedTotal.toFixed(2)
  }
  payMethod.value = 'alipay'
  checkoutStep.value = 2
}

// 稍后付款：创建 PENDING 订单后跳转
async function submitCheckout() {
  const addressStr = buildAddressString()
  if (!addressStr) {
    ElMessage.warning('请选择或新增收货地址')
    return
  }
  checkoutLoading.value = true
  try {
    const items = cartStore.checkedItems.map(item => ({
      productId: item.productId,
      quantity: item.quantity
    }))
    const res = await createOrder({ address: addressStr, remark: checkoutForm.value.remark, items })
    const order = res.data || res
    await cartStore.clearChecked()
    checkoutVisible.value = false
    // 通知聊天「去结算」卡变为已完成
    window.dispatchEvent(new CustomEvent('sqz-checkout-completed', { detail: { orderNo: order.orderNo || '', status: 'PENDING' } }))
    ElMessage.success('订单提交成功，请前往我的订单完成支付')
    router.push('/customer/orders')
  } catch (e) {
    ElMessage.error(e.message || '提交失败')
  } finally {
    checkoutLoading.value = false
  }
}

// 确认支付：创建订单并立即标记为 PAID
async function confirmPay() {
  payLoading.value = true
  try {
    const addressStr = buildAddressString()
    const items = cartStore.checkedItems.map(item => ({
      productId: item.productId,
      quantity: item.quantity
    }))
    const res = await createOrder({ address: addressStr, remark: checkoutForm.value.remark, items })
    const order = res.data || res
    await cartStore.clearChecked()
    // 模拟支付处理延时
    await new Promise(resolve => setTimeout(resolve, 1000))
    await myUpdateOrderStatus(order.orderId, 'PAID')
    // 通知聊天「去结算」卡变为已完成
    window.dispatchEvent(new CustomEvent('sqz-checkout-completed', { detail: { orderNo: order.orderNo || '', status: 'PAID' } }))
    ElMessage.success('支付成功！')
    checkoutVisible.value = false
    router.push('/customer/orders')
  } catch (e) {
    ElMessage.error(e.message || '支付失败，请重试')
  } finally {
    payLoading.value = false
  }
}

// 购物车加购动效
function onCartItemAdded() {
  cartBounce.value = true
  setTimeout(() => { cartBounce.value = false }, 500)
}

// AI 数据变更事件处理：AI工具修改数据后立即刷新对应UI
function onAiDataChanged(event) {
  const types = event.detail?.types || []
  if (types.includes('cart')) {
    cartStore.fetchCart()
    cartBounce.value = true
    setTimeout(() => { cartBounce.value = false }, 500)
  }
  if (types.includes('notification')) {
    loadUnreadCount()
  }
  if (types.includes('order')) {
    window.dispatchEvent(new CustomEvent('ai-refresh-orders'))
  }
  if (types.includes('address')) {
    window.dispatchEvent(new CustomEvent('ai-refresh-addresses'))
  }
  if (types.includes('review')) {
    window.dispatchEvent(new CustomEvent('ai-refresh-reviews'))
  }
  if (types.includes('ticket')) {
    window.dispatchEvent(new CustomEvent('ai-refresh-tickets'))
  }
}

// 从聊天「去结算」卡片触发：打开屏幕中央结算弹窗（标准电商结算流程）
async function openCheckoutFromChat() {
  if (cartStore.cartItems.length === 0) {
    ElMessage.warning('购物车为空，请先添加商品')
    return
  }
  // 若没有任何已勾选商品，自动全选，避免结算弹窗「去结算」不可点
  if (cartStore.checkedItems.length === 0) {
    await cartStore.toggleAll()
  }
  openCheckout()
}

onMounted(() => {
  loadUnreadCount()
  notificationTimer = setInterval(loadUnreadCount, 30000)
  window.addEventListener('cart-item-added', onCartItemAdded)
  window.addEventListener('ai-data-changed', onAiDataChanged)
  window.addEventListener('sqz-open-checkout', openCheckoutFromChat)
})

onUnmounted(() => {
  if (notificationTimer) clearInterval(notificationTimer)
  window.removeEventListener('cart-item-added', onCartItemAdded)
  window.removeEventListener('ai-data-changed', onAiDataChanged)
  window.removeEventListener('sqz-open-checkout', openCheckoutFromChat)
})
</script>

<style scoped>
.customer-layout {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #f0f2f5;
  position: relative;
}

.customer-layout::before {
  display: none;
}

/* ====== 顶部导航栏 ====== */
.customer-header {
  height: 60px;
  background: rgba(255, 255, 255, 0.78);
  backdrop-filter: blur(20px) saturate(1.8);
  -webkit-backdrop-filter: blur(20px) saturate(1.8);
  border-bottom: none;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 28px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04), 0 4px 12px rgba(0, 0, 0, 0.03);
  flex-shrink: 0;
  z-index: 100;
  position: sticky;
  top: 0;
}

.customer-header::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(64, 158, 255, 0.15) 15%,
    rgba(64, 158, 255, 0.25) 50%,
    rgba(64, 158, 255, 0.15) 85%,
    transparent
  );
}

/* 左区 */
.header-left {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-shrink: 0;
}

.nav-logo {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  object-fit: contain;
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.12);
  transition: transform 0.3s ease;
}

.nav-logo:hover {
  transform: rotate(6deg) scale(1.05);
}

.system-title {
  font-size: 16px;
  font-weight: 700;
  background: linear-gradient(135deg, #303133, #409eff, #303133, #409eff);
  background-size: 300% 300%;
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  white-space: nowrap;
  letter-spacing: 0.5px;
  animation: titleGradientFlow 6s ease-in-out infinite;
}

@keyframes titleGradientFlow {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

/* 中区导航 */
.header-nav {
  display: flex;
  align-items: center;
  gap: 4px;
  height: 100%;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 0 16px;
  height: 100%;
  text-decoration: none;
  color: #606266;
  font-size: 14px;
  border-bottom: 2px solid transparent;
  transition: color 0.25s, background-color 0.25s, transform 0.25s;
  box-sizing: border-box;
  position: relative;
}

.nav-item::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  right: 50%;
  height: 3px;
  background: linear-gradient(90deg, #409eff, #66b1ff);
  border-radius: 3px 3px 0 0;
  transition: left 0.3s ease, right 0.3s ease, box-shadow 0.3s ease;
}

.nav-item:hover {
  color: #409eff;
  background-color: rgba(64, 158, 255, 0.06);
  transform: translateY(-1px);
}

.nav-item:hover::after {
  left: 16px;
  right: 16px;
}

.nav-item.active {
  color: #409eff;
  font-weight: 600;
  border-bottom-color: transparent;
  background-color: rgba(64, 158, 255, 0.08);
  border-radius: 8px 8px 0 0;
}

.nav-item.active::after {
  left: 16px;
  right: 16px;
  box-shadow: 0 -1px 6px rgba(64, 158, 255, 0.3);
}

/* 右区 */
.header-right {
  display: flex;
  align-items: center;
  gap: 18px;
  flex-shrink: 0;
}

.header-icon-btn {
  cursor: pointer;
  color: #606266;
  transition: color 0.25s, background-color 0.25s, transform 0.2s, box-shadow 0.25s;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: 10px;
}

.header-icon-btn:hover {
  color: #409eff;
  background-color: rgba(64, 158, 255, 0.1);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.15);
}

.header-icon-btn:active {
  transform: scale(0.92);
  box-shadow: none;
  transition-duration: 0.08s;
}

.notification-bell {
  cursor: pointer;
  color: #606266;
  transition: color 0.2s;
  display: flex;
  align-items: center;
}

.notification-bell:hover {
  color: #409eff;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  color: #606266;
  transition: color 0.25s, background-color 0.25s, box-shadow 0.25s, border-color 0.25s;
  padding: 4px 12px;
  border-radius: 20px;
  border: 1px solid transparent;
}

.user-info:hover {
  color: #409eff;
  background-color: rgba(64, 158, 255, 0.06);
  border-color: rgba(64, 158, 255, 0.15);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.1);
}

.user-info :deep(.el-avatar) {
  border: 2px solid rgba(64, 158, 255, 0.2);
  transition: border-color 0.25s;
}

.user-info:hover :deep(.el-avatar) {
  border-color: rgba(64, 158, 255, 0.5);
}

.user-name {
  font-size: 14px;
  font-weight: 500;
  max-width: 100px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #303133;
  transition: color 0.25s;
}

.user-info:hover .user-name {
  color: #409eff;
}

/* 内容区 */
.customer-content {
  flex: 1;
  overflow: auto;
  height: calc(100vh - 60px);
  position: relative;
  z-index: 1;
}

/* AI 聊天页面：内容区不滚动，让聊天容器自己管理滚动 */
.customer-content:has(.ai-chat-container) {
  overflow: hidden;
}

/* ====== 子页面样式优化 (Clean Tech) ====== */
.customer-content :deep(.app-container) {
  background: transparent;
  padding: 20px;
}

/* 表格优化 */
.customer-content :deep(.el-table) {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  --el-table-header-bg-color: #f8f9fb;
  --el-table-header-text-color: #606266;
  --el-table-border-color: #ebeef5;
}

.customer-content :deep(.el-table th.el-table__cell) {
  font-weight: 600;
  background-color: #f8f9fb !important;
}

/* 输入框优化 */
.customer-content :deep(.el-input__wrapper) {
  box-shadow: 0 0 0 1px #dcdfe6 inset !important;
  transition: all 0.2s;
}

.customer-content :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #409eff inset !important;
}

.customer-content :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #409eff inset !important;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2) inset !important;
}

/* 按钮优化 */
.customer-content :deep(.el-button--primary:not(.is-plain):not(.is-link)) {
  background: linear-gradient(135deg, #409eff, #2b7de9);
  border: none;
  box-shadow: 0 2px 6px rgba(64, 158, 255, 0.3);
  transition: all 0.3s;
  color: #fff;
}

.customer-content :deep(.el-button--primary:not(.is-plain):not(.is-link):hover) {
  background: linear-gradient(135deg, #66b1ff, #409eff);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

/* Plain类型的按钮 (如: 提交工单) */
.customer-content :deep(.el-button--primary.is-plain) {
  background: #ffffff;
  border-color: #409eff;
  color: #409eff;
  transition: all 0.3s;
}

.customer-content :deep(.el-button--primary.is-plain:hover) {
  background: #ecf5ff;
  border-color: #66b1ff;
  color: #409eff;
}

/* Link类型的按钮 (如: 表格操作) */
.customer-content :deep(.el-button--primary.is-link) {
  background: transparent;
  border: none;
  box-shadow: none;
  color: #409eff;
}

.customer-content :deep(.el-button--primary.is-link:hover) {
  color: #66b1ff;
  background: transparent;
  transform: none;
  box-shadow: none;
}

/* 弹窗优化 */
.customer-content :deep(.el-dialog) {
  border-radius: 12px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.customer-content :deep(.el-dialog__header) {
  margin-right: 0;
  border-bottom: 1px solid #f0f2f5;
  padding: 20px;
}

.customer-content :deep(.el-dialog__body) {
  padding: 24px;
}

.customer-content :deep(.el-pagination) {
  justify-content: flex-end;
  margin-top: 20px;
  --el-pagination-hover-color: #409eff;
}

/* ====== 通知面板样式 ====== */
.notification-panel {
  max-height: 460px;
  overflow-y: auto;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 8px;
  border-bottom: 1px solid #ebeef5;
  margin-bottom: 8px;
  font-weight: bold;
}

.panel-empty {
  text-align: center;
  padding: 24px 20px;
  color: #999;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.panel-footer {
  text-align: center;
  padding-top: 8px;
  border-top: 1px solid #ebeef5;
  margin-top: 8px;
}

.panel-header-left {
  display: flex;
  align-items: center;
  gap: 6px;
}

.notif-count-badge {
  background: #f56c6c;
  color: #fff;
  font-size: 11px;
  font-weight: 600;
  padding: 1px 6px;
  border-radius: 10px;
  line-height: 1.4;
}

.notification-list {
  position: relative;
}

.notification-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 10px 12px;
  border-radius: 8px;
  margin-bottom: 4px;
  cursor: pointer;
  transition: background-color 0.25s ease, transform 0.2s ease, box-shadow 0.2s ease;
  position: relative;
}

.notification-item:hover {
  background-color: #f0f6ff;
  transform: translateX(2px);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.08);
}

.notification-item.is-expanded {
  background-color: #f5f9ff;
  box-shadow: 0 2px 10px rgba(64, 158, 255, 0.1);
}

.notif-icon {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.notif-body {
  flex: 1;
  min-width: 0;
}

.notif-title-row {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-bottom: 4px;
}

.notification-title {
  font-size: 13px;
  font-weight: 600;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  flex: 1;
}

.notification-content {
  font-size: 12px;
  color: #666;
  margin-bottom: 4px;
  overflow: hidden;
  max-height: 20px;
  transition: max-height 0.3s ease;
  line-height: 1.5;
}

.notification-content.expanded {
  max-height: 200px;
}

.notif-actions {
  margin: 4px 0 2px;
}

.notification-time {
  font-size: 11px;
  color: #999;
}

.notif-unread-dot {
  position: absolute;
  top: 14px;
  right: 8px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #409eff;
  box-shadow: 0 0 4px rgba(64, 158, 255, 0.4);
}

/* 通知列表 TransitionGroup */
.notif-list-enter-active {
  transition: all 0.35s ease-out;
}
.notif-list-leave-active {
  transition: all 0.25s ease-in;
}
.notif-list-enter-from {
  opacity: 0;
  transform: translateY(-12px);
}
.notif-list-leave-to {
  opacity: 0;
  transform: translateX(20px);
}
.notif-list-move {
  transition: transform 0.3s ease;
}

/* ====== 购物车面板样式 ====== */
.cart-panel {
  display: flex;
  flex-direction: column;
  max-height: 480px;
}

.cart-count-badge {
  background: rgba(64, 158, 255, 0.1);
  color: #409eff;
  font-size: 11px;
  font-weight: 600;
  padding: 1px 8px;
  border-radius: 10px;
  line-height: 1.4;
}

.cart-list {
  max-height: 340px;
  overflow-y: auto;
  flex: 1;
  position: relative;
  padding: 4px 0;
}

.cart-item {
  display: flex;
  align-items: center;
  padding: 10px 8px;
  border-radius: 10px;
  margin-bottom: 6px;
  border: 1px solid transparent;
  transition: background-color 0.25s ease, border-color 0.25s ease,
              transform 0.2s ease, box-shadow 0.25s ease;
}

.cart-item:hover {
  background-color: #f8faff;
  border-color: rgba(64, 158, 255, 0.12);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
}

.cart-item.is-removing {
  opacity: 0;
  transform: translateX(30px) scale(0.9);
  transition: opacity 0.25s ease-in, transform 0.25s ease-in;
}

.cart-item-img {
  width: 52px;
  height: 52px;
  object-fit: cover;
  border-radius: 8px;
  margin-right: 10px;
  flex-shrink: 0;
  border: 1px solid #f0f0f0;
  transition: transform 0.25s ease, box-shadow 0.25s ease;
}

.cart-item:hover .cart-item-img {
  transform: scale(1.05);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.cart-item-img-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
}

.cart-item-info {
  flex: 1;
  min-width: 0;
  margin-right: 8px;
}

.cart-item-name {
  font-size: 13px;
  font-weight: 500;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.cart-item-price {
  font-size: 14px;
  color: #f56c6c;
  font-weight: 600;
  margin-top: 3px;
}

/* 删除按钮渐显 */
.cart-delete-btn {
  opacity: 0.4;
  transition: opacity 0.2s ease, transform 0.2s ease;
}
.cart-item:hover .cart-delete-btn {
  opacity: 1;
}
.cart-delete-btn:hover {
  transform: scale(1.2);
}

/* 数量变化脉冲 */
.qty-pulse {
  animation: qtyPulse 0.4s ease;
}
@keyframes qtyPulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.08); }
  100% { transform: scale(1); }
}

.cart-footer {
  padding-top: 12px;
  border-top: none;
  margin-top: 8px;
  position: relative;
}

.cart-footer::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, transparent, rgba(64, 158, 255, 0.3) 30%, rgba(64, 158, 255, 0.5) 50%, rgba(64, 158, 255, 0.3) 70%, transparent);
  border-radius: 1px;
}

.cart-total {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.cart-total-price {
  color: #f56c6c;
  font-size: 18px;
  font-weight: 700;
}

.cart-footer-actions {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-top: 4px;
}

.cart-footer-actions .view-cart-btn,
.cart-footer-actions .checkout-btn {
  width: calc((100% - 10px) / 3);
  font-size: 13px;
  height: 34px;
}

.view-cart-btn {
  font-weight: 500;
  color: #409eff !important;
  border-color: #409eff !important;
  background: #fff !important;
  transition: all 0.3s ease;
}

.view-cart-btn:hover {
  background: rgba(64, 158, 255, 0.06) !important;
  border-color: #66b1ff !important;
  color: #66b1ff !important;
}

/* 结算按钮渐变色 */
.checkout-btn {
  background: linear-gradient(135deg, #409eff, #2b7de9) !important;
  border: none !important;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.35);
  transition: all 0.3s ease;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.checkout-btn:hover:not(.is-disabled) {
  background: linear-gradient(135deg, #66b1ff, #409eff) !important;
  transform: translateY(-1px);
  box-shadow: 0 4px 14px rgba(64, 158, 255, 0.45);
}

.checkout-btn:active:not(.is-disabled) {
  transform: translateY(0);
  box-shadow: 0 2px 6px rgba(64, 158, 255, 0.3);
}

/* 购物车空状态 */
.cart-empty-state {
  text-align: center;
  padding: 30px 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.cart-empty-icon {
  color: #dcdfe6;
  animation: emptyFloat 3s ease-in-out infinite;
}

@keyframes emptyFloat {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-6px); }
}

/* 购物车项 TransitionGroup */
.cart-item-enter-active {
  transition: all 0.35s ease-out;
}
.cart-item-leave-active {
  transition: all 0.25s ease-in;
}
.cart-item-enter-from {
  opacity: 0;
  transform: translateX(-20px) scale(0.95);
}
.cart-item-leave-to {
  opacity: 0;
  transform: translateX(30px) scale(0.9);
}
.cart-item-move {
  transition: transform 0.3s ease;
}

/* ====== 购物车加购动效 ====== */
.cart-bounce {
  animation: cartBounceAnim 0.5s ease;
}

.cart-bounce :deep(.el-badge__content) {
  animation: badgeFlash 0.5s ease;
}

@keyframes cartBounceAnim {
  0% { transform: scale(1) rotate(0); }
  25% { transform: scale(1.25) rotate(-5deg); }
  50% { transform: scale(0.95) rotate(3deg); }
  75% { transform: scale(1.1) rotate(-1deg); }
  100% { transform: scale(1) rotate(0); }
}

@keyframes badgeFlash {
  0%, 100% { box-shadow: 0 0 0 0 rgba(245, 108, 108, 0); }
  50% { box-shadow: 0 0 0 6px rgba(245, 108, 108, 0.3); }
}

/* ====== 结算对话框地址区域 ====== */
.checkout-section {
  margin-bottom: 20px;
}

.checkout-section-title {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 12px;
  padding-left: 8px;
  border-left: 3px solid #409eff;
}

.address-toolbar {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
}

.address-detail-card {
  padding: 12px 16px;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  background: #f9fafc;
  margin-bottom: 8px;
}

.address-detail-row {
  display: flex;
  align-items: center;
  gap: 20px;
  font-size: 14px;
  color: #303133;
  line-height: 1.6;
}

.address-detail-row b {
  color: #606266;
  font-weight: 500;
}

.address-detail-row + .address-detail-row {
  margin-top: 6px;
}

.address-text {
  display: block;
  word-break: break-all;
  color: #606266;
}

.address-empty {
  text-align: center;
  color: #909399;
  padding: 20px;
  font-size: 13px;
}

.new-address-form {
  background: #f8f9fb;
  padding: 16px;
  border-radius: 10px;
  margin-top: 8px;
  border: 1px dashed #dcdfe6;
}

/* 模拟支付弹窗 */
.pay-info { padding: 16px 0; }
.pay-row { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; font-size: 14px; }
.pay-label { color: #909399; min-width: 80px; }

/* 回到顶部按钮 */
.backtop-btn {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: linear-gradient(135deg, #409eff, #337ecc);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 16px rgba(64, 158, 255, 0.35);
  transition: all 0.3s;
}
.backtop-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 6px 20px rgba(64, 158, 255, 0.5);
}
</style>

<!-- 下拉弹出层挂在 body 上，需要非 scoped 样式 -->
<style>
.address-select-dropdown {
  max-width: 600px !important;
}

.address-select-dropdown .el-select-dropdown__item {
  height: auto !important;
  padding: 10px 16px !important;
  line-height: normal !important;
  white-space: normal !important;
  border-bottom: 1px solid #f2f3f5;
}

.address-select-dropdown .el-select-dropdown__item:last-child {
  border-bottom: none;
}

.address-option {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.address-option-row1 {
  display: flex;
  align-items: center;
  gap: 16px;
  font-size: 14px;
  color: #303133;
}

.address-option-row1 b {
  color: #606266;
  font-weight: 500;
}

.address-option-row2 {
  font-size: 13px;
  color: #606266;
  line-height: 1.5;
  word-break: break-all;
}

.address-option-row2 b {
  color: #909399;
  font-weight: 500;
}
</style>

<style scoped>
.customer-content :deep(.el-overlay) {
  z-index: 2001 !important;
}

.customer-content :deep(.el-dialog) {
  margin-top: 8vh !important;
  max-height: 80vh;
  display: flex;
  flex-direction: column;
}

.customer-content :deep(.el-dialog__body) {
  overflow-y: auto;
  flex: 1;
}

/* ====== 全局页脚 ====== */
.customer-footer {
  padding: 40px 0 24px;
  text-align: center;
}

.footer-divider {
  width: 200px;
  height: 1px;
  margin: 0 auto 18px;
  background: linear-gradient(90deg, transparent, #dcdfe6, transparent);
}

.footer-main {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #909399;
  margin-bottom: 6px;
}

.footer-title {
  font-weight: 500;
}

.footer-bottom {
  font-size: 12px;
  color: #c0c4cc;
}

/* ====== 响应式 ====== */
@media (max-width: 768px) {
  .customer-header {
    padding: 0 12px;
  }

  .system-title {
    display: none;
  }

  .nav-item .el-icon {
    display: none;
  }

  .nav-item {
    padding: 0 10px;
    font-size: 13px;
  }

  .user-name {
    display: none;
  }
}
</style>

<style>
/* 自定义 popover 展开/收起动效（非 scoped，因为 popover 渲染在 body 上） */
.popover-slide-enter-active {
  transition: opacity 0.2s ease-out, transform 0.2s ease-out;
}
.popover-slide-leave-active {
  transition: opacity 0.15s ease-in, transform 0.15s ease-in;
}
.popover-slide-enter-from {
  opacity: 0;
  transform: translateY(-8px) scale(0.98);
}
.popover-slide-leave-to {
  opacity: 0;
  transform: translateY(-6px) scale(0.98);
}
</style>
