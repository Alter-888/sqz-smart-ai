import { defineStore } from 'pinia'
import { ref } from 'vue'

const useChatStore = defineStore('chat', () => {
  const currentSessionId = ref(null)
  const sessions = ref([])
  const messages = ref([])

  function setCurrentSession(sessionId) {
    currentSessionId.value = sessionId
  }

  function setSessions(list) {
    sessions.value = list
  }

  function setMessages(list) {
    messages.value = list.map(msg => {
      if (msg.cardsData) {
        try {
          msg.cards = JSON.parse(msg.cardsData)
        } catch (e) { /* ignore */ }
      }
      return msg
    })
  }

  function addMessage(msg) {
    messages.value.push(msg)
  }

  function updateLastMessage(content) {
    if (messages.value.length > 0) {
      const last = messages.value[messages.value.length - 1]
      if (last.role === 'assistant') {
        last.content += content
      }
    }
  }

  function clearMessages() {
    messages.value = []
  }

  function removeLastMessage() {
    if (messages.value.length > 0) {
      messages.value.pop()
    }
  }

  function removeSession(sessionId) {
    sessions.value = sessions.value.filter(s => s.sessionId !== sessionId)
    if (currentSessionId.value === sessionId) {
      currentSessionId.value = null
      messages.value = []
    }
  }

  function updateSessionTitle(sessionId, title) {
    const session = sessions.value.find(s => s.sessionId === sessionId)
    if (session && (!session.title || session.title.trim() === '')) {
      session.title = title.length > 50 ? title.substring(0, 50) : title
    }
  }

  function toggleSessionPin(sessionId, updatedSession) {
    const session = sessions.value.find(s => s.sessionId === sessionId)
    if (session) {
      session.isPinned = updatedSession.isPinned
      session.pinTime = updatedSession.pinTime
    }
  }

  function renameSessionTitle(sessionId, newTitle) {
    const session = sessions.value.find(s => s.sessionId === sessionId)
    if (session) {
      session.title = newTitle
    }
  }

  function addToolCallHint(toolCallData) {
    // 将工具调用提示挂载到最后一条 assistant 消息上（融入气泡内显示）
    for (let i = messages.value.length - 1; i >= 0; i--) {
      if (messages.value[i].role === 'assistant') {
        if (!messages.value[i].toolCallHints) {
          messages.value[i].toolCallHints = []
        }
        messages.value[i].toolCallHints.push({
          content: toolCallData.description || '正在调用工具...',
          toolName: toolCallData.toolName,
          done: false
        })
        break
      }
    }
  }

  function addCardData(cardPayload) {
    // 将卡片数据挂载到最后一条 assistant 消息上
    for (let i = messages.value.length - 1; i >= 0; i--) {
      if (messages.value[i].role === 'assistant') {
        if (!messages.value[i].cards) {
          messages.value[i].cards = []
        }
        messages.value[i].cards.push(cardPayload)
        break
      }
    }
  }

  function markToolCallHintsDone() {
    // 标记提示为完成态（保留在消息中供用户展开查看）
    for (let i = messages.value.length - 1; i >= 0; i--) {
      if (messages.value[i].role === 'assistant' && messages.value[i].toolCallHints) {
        messages.value[i].toolCallHints.forEach(h => h.done = true)
        break
      }
    }
  }

  function setRagSource(ragSources) {
    // 将 RAG 来源挂载到最后一条 assistant 消息
    for (let i = messages.value.length - 1; i >= 0; i--) {
      if (messages.value[i].role === 'assistant') {
        messages.value[i].ragSources = ragSources
        break
      }
    }
  }

  function setLastAssistantMessageId(messageId) {
    // 将后端返回的 messageId 设置到最后一条 assistant 消息，供赞/踩功能使用
    for (let i = messages.value.length - 1; i >= 0; i--) {
      if (messages.value[i].role === 'assistant') {
        messages.value[i].messageId = messageId
        break
      }
    }
  }

  return {
    currentSessionId, sessions, messages,
    setCurrentSession, setSessions, setMessages,
    addMessage, updateLastMessage, clearMessages, removeLastMessage, removeSession, updateSessionTitle, toggleSessionPin, renameSessionTitle, addToolCallHint, addCardData, markToolCallHintsDone, setRagSource, setLastAssistantMessageId
  }
})

export default useChatStore
