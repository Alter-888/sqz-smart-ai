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
