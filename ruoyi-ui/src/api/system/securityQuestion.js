import request from '@/utils/request'

// 获取当前用户的安全问题列表
export function getSecurityQuestions() {
  return request({
    url: '/system/user/profile/securityQuestions',
    method: 'get'
  })
}

// 保存当前用户的安全问题
export function saveSecurityQuestions(data) {
  return request({
    url: '/system/user/profile/securityQuestions',
    method: 'post',
    data
  })
}
