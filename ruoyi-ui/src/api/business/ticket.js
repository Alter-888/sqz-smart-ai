import request from '@/utils/request'

export function listTickets(query) {
  return request({ url: '/business/ticket/list', method: 'get', params: query })
}

export function ticketStats() {
  return request({ url: '/business/ticket/stats', method: 'get' })
}

export function myTickets(query) {
  return request({ url: '/business/ticket/my', method: 'get', params: query })
}

export function myTicketDetail(id) {
  return request({ url: '/business/ticket/my/' + id, method: 'get' })
}

export function myTicketReplies(id) {
  return request({ url: '/business/ticket/my/' + id + '/replies', method: 'get' })
}

export function getTicket(id) {
  return request({ url: '/business/ticket/' + id, method: 'get' })
}

export function replyTicket(id, reply) {
  return request({ url: '/business/ticket/' + id + '/reply', method: 'put', data: { reply } })
}

export function getTicketReplies(id) {
  return request({ url: '/business/ticket/' + id + '/replies', method: 'get' })
}

export function addTicketReply(id, data) {
  return request({ url: '/business/ticket/' + id + '/reply', method: 'post', data })
}

export function closeTicket(id) {
  return request({ url: '/business/ticket/' + id + '/close', method: 'put' })
}

export function assignTicket(id, assigneeId) {
  return request({ url: '/business/ticket/' + id + '/assign', method: 'put', data: { assigneeId } })
}

export function delTicket(id) {
  return request({ url: '/business/ticket/' + id, method: 'delete' })
}

export function myTicketStats() {
  return request({ url: '/business/ticket/my/stats', method: 'get' })
}

export function exportTickets(query) {
  return request({ url: '/business/ticket/export', method: 'post', params: query, responseType: 'blob' })
}

export function approveRefund(id) {
  return request({ url: '/business/ticket/' + id + '/approve-refund', method: 'put' })
}

export function confirmRefund(id) {
  return request({ url: '/business/ticket/' + id + '/confirm-refund', method: 'put' })
}

export function rejectRefund(id, reason) {
  return request({ url: '/business/ticket/' + id + '/reject-refund', method: 'put', data: { reason } })
}

export function resolveTicket(id) {
  return request({ url: '/business/ticket/' + id + '/resolve', method: 'put' })
}
