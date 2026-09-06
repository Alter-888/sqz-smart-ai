import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { getCartList, addCartItem, updateCartQuantity, updateCartChecked, removeCartItem, clearCart as clearCartApi } from '@/api/business/cart'

const useCartStore = defineStore('cart', () => {
  const currentUserId = ref(null)
  const cartItems = ref([])
  const loading = ref(false)

  // 计算属性（保持原有接口不变，外部调用方无需修改）
  const totalCount = computed(() => cartItems.value.reduce((sum, item) => sum + item.quantity, 0))
  const checkedItems = computed(() => cartItems.value.filter(item => item.checked))
  const checkedTotal = computed(() => checkedItems.value.reduce((sum, item) => sum + Number(item.price || 0) * item.quantity, 0))
  const allChecked = computed(() => cartItems.value.length > 0 && cartItems.value.every(item => item.checked))

  // 从后端加载购物车数据
  async function fetchCart() {
    try {
      loading.value = true
      const res = await getCartList()
      const items = res.data || []
      // 映射后端字段到前端使用的字段名
      cartItems.value = items.map(item => ({
        productId: item.productId,
        name: item.productName || '',
        price: Number(item.price || 0),
        imageUrl: item.imageUrl || '',
        quantity: item.quantity,
        stock: item.stock,
        checked: item.checked === 1
      }))
    } catch (e) {
      console.error('加载购物车失败:', e)
    } finally {
      loading.value = false
    }
  }

  // 登录后初始化：从后端加载购物车
  async function initForUser(userId) {
    currentUserId.value = userId
    await fetchCart()
  }

  // 登出时重置
  function resetCart() {
    currentUserId.value = null
    cartItems.value = []
  }

  // 添加商品到购物车（调用后端API）
  async function addItem(product, qty = 1) {
    try {
      await addCartItem(product.productId, qty)
      // 触发加购动效事件
      window.dispatchEvent(new CustomEvent('cart-item-added'))
      // 重新从后端加载最新数据
      await fetchCart()
      return true
    } catch (e) {
      ElMessage.warning(e.msg || e.message || '加入购物车失败')
      return false
    }
  }

  // 移除购物车商品
  async function removeItem(productId) {
    try {
      await removeCartItem(productId)
      await fetchCart()
    } catch (e) {
      ElMessage.warning(e.msg || '移除失败')
    }
  }

  // 更新数量
  async function updateQuantity(productId, qty) {
    if (qty <= 0) {
      await removeItem(productId)
      return
    }
    try {
      await updateCartQuantity(productId, qty)
      await fetchCart()
    } catch (e) {
      ElMessage.warning(e.msg || '更新数量失败')
    }
  }

  // 切换勾选状态
  async function toggleCheck(productId) {
    const item = cartItems.value.find(i => i.productId === productId)
    if (!item) return
    try {
      await updateCartChecked(productId, item.checked ? 0 : 1)
      await fetchCart()
    } catch (e) {
      ElMessage.warning(e.msg || '操作失败')
    }
  }

  // 全选/全不选
  async function toggleAll() {
    const newVal = !allChecked.value
    try {
      // 逐个更新勾选状态（批量操作）
      await Promise.all(cartItems.value.map(item =>
        updateCartChecked(item.productId, newVal ? 1 : 0)
      ))
      await fetchCart()
    } catch (e) {
      ElMessage.warning(e.msg || '操作失败')
    }
  }

  // 清空购物车
  async function clearCart() {
    try {
      await clearCartApi()
      cartItems.value = []
    } catch (e) {
      ElMessage.warning(e.msg || '清空失败')
    }
  }

  // 清除已勾选项（结算后调用）
  async function clearChecked() {
    try {
      const checkedProductIds = cartItems.value.filter(i => i.checked).map(i => i.productId)
      await Promise.all(checkedProductIds.map(pid => removeCartItem(pid)))
      await fetchCart()
    } catch (e) {
      ElMessage.warning(e.msg || '操作失败')
    }
  }

  return {
    cartItems, totalCount, checkedItems, checkedTotal, allChecked, currentUserId, loading,
    initForUser, resetCart, fetchCart,
    addItem, removeItem, updateQuantity, toggleCheck, toggleAll, clearCart, clearChecked
  }
})

export default useCartStore
