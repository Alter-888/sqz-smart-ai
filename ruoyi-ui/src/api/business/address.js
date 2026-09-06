import request from '@/utils/request'

export function listMyAddresses() {
  return request({ url: '/business/address/my', method: 'get' })
}

export function addAddress(data) {
  return request({ url: '/business/address', method: 'post', data })
}

export function updateAddress(id, data) {
  return request({ url: '/business/address/' + id, method: 'put', data })
}

export function deleteAddress(id) {
  return request({ url: '/business/address/' + id, method: 'delete' })
}

export function setDefaultAddress(id) {
  return request({ url: '/business/address/' + id + '/default', method: 'put' })
}
