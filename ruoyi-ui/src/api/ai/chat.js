import request from '@/utils/request'

export function listSessions() {
  return request({ url: '/ai/chat/session/list', method: 'get' })
}

export function createSession(data) {
  return request({ url: '/ai/chat/session', method: 'post', data })
}

export function getSessionMessages(sessionId) {
  return request({ url: '/ai/chat/session/' + sessionId + '/messages', method: 'get' })
}

export function sendMessage(data) {
  return request({ url: '/ai/chat/send', method: 'post', data })
}

export function deleteSession(sessionId) {
  return request({ url: '/ai/chat/session/' + sessionId, method: 'delete' })
}

export function togglePinSession(sessionId) {
  return request({ url: '/ai/chat/session/' + sessionId + '/pin', method: 'put' })
}

export function renameSession(sessionId, title) {
  return request({ url: '/ai/chat/session/' + sessionId + '/title', method: 'put', data: { title } })
}

export function feedbackMessage(messageId, feedback) {
  return request({ url: '/ai/chat/message/' + messageId + '/feedback', method: 'put', data: { feedback } })
}

// ====== P7 HITL：高危操作确认 ======
export function listPendingActions(status = 'PENDING') {
  return request({ url: '/ai/chat/pending-action/list', method: 'get', params: { status } })
}

export function confirmPendingAction(actionId) {
  return request({ url: '/ai/chat/pending-action/' + actionId + '/confirm', method: 'post' })
}

export function cancelPendingAction(actionId) {
  return request({ url: '/ai/chat/pending-action/' + actionId + '/cancel', method: 'post' })
}

// 确认/取消/超时后，把消息里确认卡的最终状态持久化（刷新页面仍显示最终态）
export function updatePendingCardState(sessionId, actionId, status, result) {
  return request({ url: '/ai/chat/pending-action/' + actionId + '/state', method: 'put', data: { sessionId, status, result } })
}

// 结算成功后，把消息里「去结算」卡的完成态持久化（刷新页面仍显示已完成）
export function updateCheckoutCardState(sessionId, cardId, status, orderNo) {
  return request({ url: '/ai/chat/checkout-card/' + cardId + '/state', method: 'put', data: { sessionId, status, orderNo } })
}