import request from '@/utils/request'

// 用户端商品列表（仅上架商品）
export function listShopProducts(query) {
  return request({ url: '/shop/product/list', method: 'get', params: query })
}

// 用户端商品详情（仅上架商品）
export function getShopProduct(id) {
  return request({ url: '/shop/product/' + id, method: 'get' })
}
