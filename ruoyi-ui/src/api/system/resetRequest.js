import request from '@/utils/request'

export function listResetRequest(query) {
  return request({ url: '/system/resetRequest/list', method: 'get', params: query })
}

export function approveResetRequest(requestId, data) {
  return request({ url: '/system/resetRequest/approve/' + requestId, method: 'put', data })
}

export function rejectResetRequest(requestId, data) {
  return request({ url: '/system/resetRequest/reject/' + requestId, method: 'put', data })
}
