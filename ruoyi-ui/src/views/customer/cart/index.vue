<template>
  <div class="cart-page-container">
    <div class="page-header">
      <h3>我的购物车</h3>
      <span class="cart-count" v-if="cartStore.cartItems.length > 0">共 {{ cartStore.totalCount }} 件商品</span>
    </div>

    <!-- 空状态 -->
    <div v-if="cartStore.cartItems.length === 0 && !cartStore.loading" class="empty-tip">
      <el-empty description="购物车是空的，快去挑选心仪的商品吧~">
        <el-button type="primary" round @click="router.push('/customer/products')">去逛逛</el-button>
      </el-empty>
    </div>

    <!-- 购物车主体 -->
    <div v-else v-loading="cartStore.loading" class="cart-body">
      <!-- 工具栏 -->
      <div class="cart-toolbar">
        <el-checkbox :model-value="cartStore.allChecked" @change="cartStore.toggleAll()">全选</el-checkbox>
        <el-button type="danger" link size="small" @click="handleClearCart">清空购物车</el-button>
      </div>

      <!-- 商品列表 -->
      <TransitionGroup name="cart-fade" tag="div" class="cart-list">
        <div
          v-for="item in cartStore.cartItems"
          :key="item.productId"
          class="cart-card"
          :class="{ 'is-removing': removingItemId === item.productId }"
        >
          <el-checkbox
            :model-value="item.checked"
            @change="cartStore.toggleCheck(item.productId)"
            class="cart-card-check"
          />
          <img v-if="item.imageUrl" :src="item.imageUrl" class="cart-card-img" />
          <div v-else class="cart-card-img cart-card-img-placeholder">
            <el-icon :size="28" style="color: #ccc"><Goods /></el-icon>
          </div>
          <div class="cart-card-info">
            <div class="cart-card-name">{{ item.name }}</div>
            <div class="cart-card-price">&yen;{{ item.price.toFixed(2) }}</div>
          </div>
          <div class="cart-card-quantity" :class="{ 'qty-pulse': quantityChangedId === item.productId }">
            <el-input-number
              v-model="item.quantity"
              :min="1"
              :max="item.stock || 999"
              size="small"
              @change="(val) => handleQuantityChange(item.productId, val)"
            />
          </div>
          <div class="cart-card-subtotal">
            &yen;{{ (item.price * item.quantity).toFixed(2) }}
          </div>
          <el-button type="danger" link @click="handleRemoveItem(item.productId)">
            <el-icon><Delete /></el-icon>
          </el-button>
        </div>
      </TransitionGroup>

      <!-- 底部固定结算栏 -->
      <div class="cart-settlement-bar">
        <div class="settlement-left">
          <el-checkbox :model-value="cartStore.allChecked" @change="cartStore.toggleAll()">全选</el-checkbox>
          <span class="selected-count">已选 <b>{{ cartStore.checkedItems.length }}</b> 件</span>
        </div>
        <div class="settlement-right">
          <span class="settlement-total">
            合计：<b class="total-price">&yen;{{ cartStore.checkedTotal.toFixed(2) }}</b>
          </span>
          <el-button
            type="primary"
            round
            size="large"
            :disabled="cartStore.checkedItems.length === 0"
            @click="openCheckout"
          >去结算 ({{ cartStore.checkedItems.length }})</el-button>
        </div>
      </div>
    </div>

    <!-- 结算对话框 -->
    <el-dialog v-model="checkoutVisible" :title="checkoutStep === 1 ? '确认订单信息' : '模拟支付'" width="650px" destroy-on-close>
      <!-- ========== 步骤 1：确认订单信息 ========== -->
      <div v-if="checkoutStep === 1">
      <!-- 收货地址 -->
      <div class="checkout-section">
        <div class="checkout-section-title">收货地址</div>
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

      <template #footer>
        <el-button @click="checkoutVisible = false">取消</el-button>
        <el-button :loading="checkoutLoading" @click="submitCheckout">稍后付款</el-button>
        <el-button type="primary" @click="goToPayStep">下一步：支付</el-button>
      </template>
    </el-dialog>

    <!-- 统一支付弹窗 -->
    <PayDialog
      v-model:visible="payDialogVisible"
      :loading="payLoading"
      :total-amount="payOrderData.totalAmount"
      :product-summary="payOrderData.productSummary"
      @confirm="handlePayConfirm"
    />
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Goods, Delete, Plus } from '@element-plus/icons-vue'
import useCartStore from '@/store/modules/cart'
import PayDialog from '@/components/PayDialog/index.vue'
import { listMyAddresses, addAddress, setDefaultAddress } from '@/api/business/address'
import { createOrder, myUpdateOrderStatus } from '@/api/business/order'
import { regionData } from 'element-china-area-data'

const router = useRouter()
const cartStore = useCartStore()

// 动效状态
const quantityChangedId = ref(null)
const removingItemId = ref(null)

// 结算相关
const checkoutVisible = ref(false)
const checkoutLoading = ref(false)
const checkoutForm = ref({ remark: '' })
const checkoutStep = ref(1) // 1 = 确认订单信息, 2 = 模拟支付

// 模拟支付
const payLoading = ref(false)
const payMethod = ref('alipay')
const payOrderData = ref({ productSummary: '', totalAmount: '0.00' })
const payDialogVisible = ref(false)

// 地址管理
const addressList = ref([])
const selectedAddressId = ref(null)
const showNewAddressForm = ref(false)
const selectedRegion = ref([])
const newAddress = reactive({ contactName: '', phone: '', detail: '' })
const selectedAddress = computed(() => addressList.value.find(a => a.addressId === selectedAddressId.value) || null)

// 数量变化
function handleQuantityChange(productId, val) {
  cartStore.updateQuantity(productId, val)
  quantityChangedId.value = productId
  setTimeout(() => { quantityChangedId.value = null }, 400)
}

// 删除商品（带动画）
function handleRemoveItem(productId) {
  removingItemId.value = productId
  setTimeout(() => {
    cartStore.removeItem(productId)
    removingItemId.value = null
  }, 250)
}

// 清空购物车
function handleClearCart() {
  ElMessageBox.confirm('确定要清空购物车吗？', '提示', { type: 'warning' }).then(() => {
    cartStore.clearCart()
  }).catch(() => {})
}

// 打开结算对话框
async function openCheckout() {
  checkoutStep.value = 1
  checkoutForm.value = { remark: '' }
  showNewAddressForm.value = false
  selectedRegion.value = []
  newAddress.contactName = ''
  newAddress.phone = ''
  newAddress.detail = ''
  try {
    const res = await listMyAddresses()
    addressList.value = res.data || []
    const defaultAddr = addressList.value.find(a => a.isDefault === 1)
    selectedAddressId.value = defaultAddr ? defaultAddr.addressId : (addressList.value.length > 0 ? addressList.value[0].addressId : null)
  } catch { addressList.value = [] }
  checkoutVisible.value = true
}

// 保存新地址
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
    const listRes = await listMyAddresses()
    addressList.value = listRes.data || []
    selectedAddressId.value = saved.addressId || addressList.value[0]?.addressId
    showNewAddressForm.value = false
  } catch (e) {
    ElMessage.error(e.message || '保存失败')
  }
}

// 设为默认地址
async function handleSetDefault(addressId) {
  try {
    await setDefaultAddress(addressId)
    ElMessage.success('默认地址设置成功')
    const res = await listMyAddresses()
    addressList.value = res.data || []
    const defaultAddr = addressList.value.find(a => a.isDefault === 1)
    if (defaultAddr) selectedAddressId.value = defaultAddr.addressId
  } catch (e) {
    ElMessage.error(e.message || '设置失败')
  }
}

// 构造地址字符串
function buildAddressString() {
  const addr = addressList.value.find(a => a.addressId === selectedAddressId.value)
  if (!addr) return ''
  return [addr.contactName, addr.phone, addr.province, addr.city, addr.district, addr.detail].filter(Boolean).join(' ')
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
  checkoutVisible.value = false
  payDialogVisible.value = true
}

// PayDialog 确认支付回调
function handlePayConfirm(method) {
  payMethod.value = method
  confirmPay()
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
    await cartStore.clearChecked()
    checkoutVisible.value = false
    ElMessage.success('订单提交成功，请前往我的订单完成支付')
    router.push({ path: '/customer/orders', query: { orderId: (res.data || res).orderId } })
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
    ElMessage.success('支付成功！')
    payDialogVisible.value = false
    checkoutVisible.value = false
    router.push({ path: '/customer/orders', query: { orderId: order.orderId } })
  } catch (e) {
    ElMessage.error(e.message || '支付失败，请重试')
  } finally {
    payLoading.value = false
  }
}

onMounted(() => {
  cartStore.fetchCart()
})
</script>

<style scoped>
.cart-page-container {
  padding: 20px;
  max-width: 1000px;
  margin: 0 auto;
  padding-bottom: 100px;
}
.page-header {
  display: flex;
  align-items: baseline;
  gap: 12px;
  margin-bottom: 20px;
}
.page-header h3 {
  margin: 0;
  font-size: 18px;
  color: #303133;
}
.cart-count {
  font-size: 13px;
  color: #909399;
}
.empty-tip {
  padding: 80px 0;
}
.cart-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
  background: #fff;
  border-radius: 10px 10px 0 0;
  border-bottom: 1px solid #f0f0f0;
}
.cart-list {
  position: relative;
}
.cart-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px 20px;
  background: #fff;
  border-bottom: 1px solid #f5f5f5;
  transition: all 0.3s ease;
}
.cart-card:last-child {
  border-bottom: none;
  border-radius: 0 0 10px 10px;
}
.cart-card:hover {
  background: #fafafa;
}
.cart-card.is-removing {
  opacity: 0;
  transform: translateX(30px);
}
.cart-card-check {
  flex-shrink: 0;
}
.cart-card-img {
  width: 64px;
  height: 64px;
  border-radius: 8px;
  object-fit: cover;
  flex-shrink: 0;
}
.cart-card-img-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
}
.cart-card-info {
  flex: 1;
  min-width: 0;
}
.cart-card-name {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-bottom: 6px;
}
.cart-card-price {
  font-size: 13px;
  color: #f56c6c;
}
.cart-card-quantity {
  flex-shrink: 0;
  transition: transform 0.2s;
}
.cart-card-quantity.qty-pulse {
  animation: qtyPulse 0.3s ease;
}
@keyframes qtyPulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.08); }
}
.cart-card-subtotal {
  width: 90px;
  text-align: right;
  font-size: 15px;
  font-weight: 600;
  color: #303133;
  flex-shrink: 0;
}
/* 底部结算栏 */
.cart-settlement-bar {
  position: sticky;
  bottom: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 -2px 12px rgba(0,0,0,0.08);
  margin-top: 16px;
  z-index: 10;
}
.settlement-left {
  display: flex;
  align-items: center;
  gap: 16px;
}
.selected-count {
  font-size: 13px;
  color: #606266;
}
.selected-count b {
  color: #409eff;
}
.settlement-right {
  display: flex;
  align-items: center;
  gap: 20px;
}
.settlement-total {
  font-size: 14px;
  color: #606266;
}
.total-price {
  font-size: 22px;
  color: #f56c6c;
}
/* 结算对话框 */
.checkout-section {
  margin-bottom: 16px;
}
.checkout-section-title {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 10px;
  padding-left: 8px;
  border-left: 3px solid #409eff;
}
.address-toolbar {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 10px;
}
.address-option {
  line-height: 1.6;
}
.address-option-row1 {
  display: flex;
  gap: 16px;
  align-items: center;
}
.address-option-row2 {
  font-size: 12px;
  color: #909399;
}
.address-detail-card {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 12px 16px;
  margin-bottom: 10px;
}
.address-detail-row {
  display: flex;
  gap: 16px;
  align-items: center;
  font-size: 13px;
  color: #606266;
}
.address-detail-row.address-text {
  margin-top: 4px;
  color: #909399;
}
.address-empty {
  color: #c0c4cc;
  font-size: 13px;
  text-align: center;
  padding: 16px 0;
}
.new-address-form {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 16px;
  margin-top: 10px;
}
/* 过渡动画 */
.cart-fade-enter-active,
.cart-fade-leave-active {
  transition: all 0.3s ease;
}
.cart-fade-enter-from {
  opacity: 0;
  transform: translateY(10px);
}
.cart-fade-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
/* 模拟支付弹窗 */
.pay-info { padding: 16px 0; }
.pay-row { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; font-size: 14px; }
.pay-label { color: #909399; min-width: 80px; }
</style>
