import request from '@/utils/request'

export function listNotifications(query) {
  return request({ url: '/business/notification/list', method: 'get', params: query })
}

export function getUnreadNotifications() {
  return request({ url: '/business/notification/unread', method: 'get' })
}

export function getUnreadCount() {
  return request({ url: '/business/notification/unread-count', method: 'get' })
}

export function markAsRead(id) {
  return request({ url: '/business/notification/' + id + '/read', method: 'put' })
}

export function markAllAsRead() {
  return request({ url: '/business/notification/read-all', method: 'put' })
}

export function getNotificationStats() {
  return request({ url: '/business/notification/stats', method: 'get' })
}
