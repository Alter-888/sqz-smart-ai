import request from '@/utils/request'

// 历史评测结果分页
export function listEvalResults(query) {
  return request({ url: '/ai/eval/list', method: 'get', params: query })
}

// 某次评测详情（含 config_snapshot 参数快照）
export function getEvalResult(id) {
  return request({ url: '/ai/eval/result/' + id, method: 'get' })
}

// 触发一次离线评测（同步长耗时，给足超时）
export function runEval(dataset, remark) {
  return request({ url: '/ai/eval/run', method: 'post', params: { dataset, remark }, timeout: 600000 })
}