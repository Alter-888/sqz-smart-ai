import request from '@/utils/request'

export function listProducts(query) {
  return request({ url: '/business/product/list', method: 'get', params: query })
}

export function getProduct(id) {
  return request({ url: '/business/product/' + id, method: 'get' })
}

export function addProduct(data) {
  return request({ url: '/business/product', method: 'post', data })
}

export function updateProduct(id, data) {
  return request({ url: '/business/product/' + id, method: 'put', data })
}

export function deleteProduct(id) {
  return request({ url: '/business/product/' + id, method: 'delete' })
}

export function getLowStockProducts(threshold) {
  return request({ url: '/business/product/low-stock', method: 'get', params: { threshold } })
}

export function batchUpdateStatus(productIds, status) {
  return request({ url: '/business/product/batch-status', method: 'put', data: { productIds, status } })
}

export function exportProducts(query) {
  return request({ url: '/business/product/export', method: 'post', params: query, responseType: 'blob' })
}
