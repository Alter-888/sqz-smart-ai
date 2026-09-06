import request from '@/utils/request'

export function listOrders(query) {
  return request({ url: '/business/order/list', method: 'get', params: query })
}

export function myOrders(query) {
  return request({ url: '/business/order/my', method: 'get', params: query })
}

export function getOrder(id) {
  return request({ url: '/business/order/' + id, method: 'get' })
}

export function myOrderDetail(id) {
  return request({ url: '/business/order/my/' + id, method: 'get' })
}

export function myUpdateOrderStatus(id, status) {
  return request({ url: '/business/order/my/' + id + '/status', method: 'put', data: { status } })
}

export function createOrder(data) {
  return request({ url: '/business/order', method: 'post', data })
}

export function updateOrderStatus(id, status, extra = {}) {
  return request({ url: '/business/order/' + id + '/status', method: 'put', data: { status, ...extra } })
}

export function getAllowedStatuses(id) {
  return request({ url: '/business/order/' + id + '/allowed-statuses', method: 'get' })
}

export function myOrderStats() {
  return request({ url: '/business/order/my/stats', method: 'get' })
}

export function adminOrderStats() {
  return request({ url: '/business/order/stats', method: 'get' })
}

export function exportOrders(query) {
  return request({ url: '/business/order/export', method: 'post', params: query, responseType: 'blob' })
}
