/**
 * 日期格式化
 */
export function formatDate(dateStr) {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  return `${year}-${month}-${day} ${hours}:${minutes}`
}

/**
 * 金额格式化
 */
export function formatMoney(amount) {
  if (amount === null || amount === undefined) return '0.00'
  return Number(amount).toFixed(2)
}

/**
 * 订单状态映射
 */
export const orderStatusMap = {
  PENDING: { label: '待付款', type: 'warning' },
  PAID: { label: '已付款', type: 'primary' },
  SHIPPED: { label: '已发货', type: '' },
  DELIVERED: { label: '已签收', type: 'success' },
  CANCELLED: { label: '已取消', type: 'info' },
  REFUNDED: { label: '已退款', type: 'danger' }
}

/**
 * 工单类型映射
 */
export const ticketTypeMap = {
  COMPLAINT: { label: '投诉', type: 'danger' },
  REFUND: { label: '仅退款', type: 'warning' },
  EXCHANGE: { label: '退货退款', type: '' },
  CONSULT: { label: '转人工客服', type: 'primary' }
}

/**
 * 工单状态映射
 */
export const ticketStatusMap = {
  OPEN: { label: '待处理', type: 'danger' },
  PROCESSING: { label: '处理中', type: 'warning' },
  RESOLVED: { label: '已解决', type: 'success' },
  CLOSED: { label: '已关闭', type: 'info' }
}

/**
 * 通知类型映射
 */
export const notificationTypeMap = {
  ORDER_STATUS: { label: '订单状态', type: 'warning' },
  TICKET_REPLY: { label: '工单回复', type: 'success' },
  STOCK_WARNING: { label: '库存预警', type: 'danger' },
  TICKET_REFUND: { label: '退款通知', type: '' },
  TICKET_RESOLVED: { label: '工单已解决', type: 'primary' }
}
