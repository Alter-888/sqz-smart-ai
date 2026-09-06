import { ref } from 'vue'
import request from '@/utils/request'

export function useSSE() {
  const isStreaming = ref(false)
  let eventSource = null

  async function startStream(message, sessionId, onMessage, onDone, onError, onToolCall, onCardData, onRagSource, onDataChanged, onMessageId) {
    isStreaming.value = true
    let hasReceivedData = false

    try {
      // 先换取一次性短期 ticket（替代在 URL 中暴露长期 JWT token）
      const res = await request({ url: '/ai/chat/stream-ticket', method: 'post' })
      const ticket = res.data.ticket

      const params = new URLSearchParams({
        message,
        sessionId: String(sessionId),
        ticket
      })

      const baseApi = import.meta.env.VITE_APP_BASE_API
      const url = `${baseApi}/ai/chat/stream?${params.toString()}`

      eventSource = new EventSource(url)
    } catch (e) {
      console.error('获取 SSE ticket 失败，降级到非流式模式', e)
      isStreaming.value = false
      if (onError) onError()
      return
    }

    eventSource.onmessage = (event) => {
      if (event.data === '[DONE]') {
        // 收到结束信号，主动关闭连接
        isStreaming.value = false
        eventSource.close()
        eventSource = null
        if (onDone) onDone()
        return
      }
      if (event.data) {
        hasReceivedData = true
        onMessage(event.data)
      }
    }

    // 监听工具调用事件
    eventSource.addEventListener('tool_call', (event) => {
      if (event.data && onToolCall) {
        try {
          const data = JSON.parse(event.data)
          onToolCall(data)
        } catch (e) {
          console.warn('解析工具调用事件失败', e)
        }
      }
    })

    // 监听卡片数据事件
    eventSource.addEventListener('card_data', (event) => {
      if (event.data && onCardData) {
        try {
          const data = JSON.parse(event.data)
          onCardData(data)
        } catch (e) {
          console.warn('解析卡片数据事件失败', e)
        }
      }
    })

    // 监听 RAG 来源事件
    eventSource.addEventListener('rag_source', (event) => {
      if (event.data && onRagSource) {
        try {
          const data = JSON.parse(event.data)
          onRagSource(data)
        } catch (e) {
          console.warn('解析RAG来源事件失败', e)
        }
      }
    })

    // 监听数据变更事件（AI工具修改数据后通知前端刷新）
    eventSource.addEventListener('data_changed', (event) => {
      if (event.data && onDataChanged) {
        try {
          const data = JSON.parse(event.data)
          onDataChanged(data)
        } catch (e) {
          console.warn('解析数据变更事件失败', e)
        }
      }
    })

    // 监听消息ID事件（用于赞/踩反馈）
    eventSource.addEventListener('message_id', (event) => {
      if (event.data && onMessageId) {
        try {
          const data = JSON.parse(event.data)
          onMessageId(data)
        } catch (e) {
          console.warn('解析消息ID事件失败', e)
        }
      }
    })

    eventSource.onerror = () => {
      isStreaming.value = false
      const readyState = eventSource.readyState
      eventSource.close()
      eventSource = null

      if (hasReceivedData || readyState === EventSource.CLOSED) {
        // 已收到数据后连接关闭 = 正常结束
        if (onDone) onDone()
      } else {
        // 未收到任何数据就出错 = 真正的错误，触发降级
        console.error('SSE 连接失败，降级到非流式模式')
        if (onError) onError()
      }
    }
  }

  function stopStream() {
    if (eventSource) {
      eventSource.close()
      eventSource = null
    }
    isStreaming.value = false
  }

  return { isStreaming, startStream, stopStream }
}
