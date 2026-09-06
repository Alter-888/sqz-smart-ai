import request from '@/utils/request'

// 获取密保问题
export function getSecurityQuestion(data) {
  return request({
    url: '/forgotPassword/getQuestion',
    method: 'post',
    data,
    headers: { isToken: false, repeatSubmit: false }
  })
}

// 通过密保重置密码
export function resetByQuestion(data) {
  return request({
    url: '/forgotPassword/resetByQuestion',
    method: 'post',
    data,
    headers: { isToken: false, repeatSubmit: false }
  })
}

// 申请管理员重置
export function requestAdminReset(data) {
  return request({
    url: '/forgotPassword/requestAdminReset',
    method: 'post',
    data,
    headers: { isToken: false, repeatSubmit: false }
  })
}
