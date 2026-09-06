import request from '@/utils/request'

export function submitReview(data) {
  return request({ url: '/business/review', method: 'post', data })
}

export function listProductReviews(productId, params) {
  return request({ url: '/business/review/product/' + productId, method: 'get', params })
}

export function getProductReviewStats(productId) {
  return request({ url: '/business/review/product/' + productId + '/stats', method: 'get' })
}

export function checkReviewed(orderItemId) {
  return request({ url: '/business/review/check/' + orderItemId, method: 'get' })
}

// 根据订单项ID获取评价详情
export function getReviewByItemId(orderItemId) {
  return request({ url: '/business/review/by-item/' + orderItemId, method: 'get' })
}

// 用户查看自己的评价历史
export function listMyReviews(query) {
  return request({ url: '/business/review/my', method: 'get', params: query })
}

// 管理员查询所有评价列表
export function listAllReviews(query) {
  return request({ url: '/business/review/list', method: 'get', params: query })
}

// 管理员更新评价状态
export function updateReviewStatus(id, status) {
  return request({ url: '/business/review/' + id + '/status', method: 'put', data: { status } })
}

// 管理员删除评价
export function deleteReview(id) {
  return request({ url: '/business/review/' + id, method: 'delete' })
}

// 管理员回复评价
export function adminReplyReview(id, reply) {
  return request({ url: '/business/review/' + id + '/reply', method: 'put', data: { reply } })
}

// 管理员：评价统计概览
export function getReviewOverviewStats() {
  return request({ url: '/business/review/overview-stats', method: 'get' })
}

// 管理员：按商品分组的评价摘要列表
export function getProductReviewSummary(params) {
  return request({ url: '/business/review/product-summary', method: 'get', params })
}

// 管理员：查看某商品下的所有评价（含隐藏的）
export function listProductReviewsForAdmin(productId, params) {
  return request({ url: '/business/review/product/' + productId + '/admin', method: 'get', params })
}
