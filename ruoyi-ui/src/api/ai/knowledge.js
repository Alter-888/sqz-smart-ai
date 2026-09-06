import request from '@/utils/request'

export function listKnowledge(query) {
  return request({ url: '/ai/knowledge/list', method: 'get', params: query })
}

export function addKnowledge(data) {
  return request({ url: '/ai/knowledge', method: 'post', data })
}

export function updateKnowledge(id, data) {
  return request({ url: '/ai/knowledge/' + id, method: 'put', data })
}

export function deleteKnowledge(id) {
  return request({ url: '/ai/knowledge/' + id, method: 'delete' })
}

export function deleteKnowledgeBatch(ids) {
  return request({ url: '/ai/knowledge/batch/' + ids.join(','), method: 'delete' })
}

export function uploadDocument(data) {
  return request({ url: '/ai/knowledge/upload', method: 'post', data, headers: { 'Content-Type': 'multipart/form-data' } })
}

export function rebuildVectorStore() {
  return request({ url: '/ai/knowledge/rebuild-vector', method: 'post' })
}

export function getVectorStoreStatus() {
  return request({ url: '/ai/knowledge/vector-store-status', method: 'get' })
}

export function listDocs(query) {
  return request({ url: '/ai/knowledge/doc/list', method: 'get', params: query })
}

export function getDashboardStats(days) {
  return request({ url: '/ai/dashboard/stats', method: 'get', params: { days } })
}

export function getDashboardTrends(days) {
  return request({ url: '/ai/dashboard/trends', method: 'get', params: { days } })
}

export function getDashboardAiMetrics(days) {
  return request({ url: '/ai/dashboard/ai-metrics', method: 'get', params: { days } })
}
