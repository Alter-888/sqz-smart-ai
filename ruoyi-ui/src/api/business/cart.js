import request from '@/utils/request'

// 获取购物车列表（含商品信息和摘要统计）
export function getCartList() {
  return request({ url: '/business/cart/list', method: 'get' })
}

// 添加商品到购物车
export function addCartItem(productId, quantity) {
  return request({ url: '/business/cart', method: 'post', data: { productId, quantity: quantity || 1 } })
}

// 更新购物车商品数量
export function updateCartQuantity(productId, quantity) {
  return request({ url: '/business/cart/' + productId + '/quantity', method: 'put', data: { quantity } })
}

// 切换购物车商品勾选状态
export function updateCartChecked(productId, checked) {
  return request({ url: '/business/cart/' + productId + '/checked', method: 'put', data: { checked } })
}

// 移除购物车商品
export function removeCartItem(productId) {
  return request({ url: '/business/cart/' + productId, method: 'delete' })
}

// 清空购物车
export function clearCart() {
  return request({ url: '/business/cart/clear', method: 'delete' })
}
