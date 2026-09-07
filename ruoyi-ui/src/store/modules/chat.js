import { defineStore } from 'pinia'
import { ref } from 'vue'

const TOOL_HINT_LABELS = {
  searchProducts: '正在搜索商品...',
  recommendProducts: '正在为您推荐商品...',
  getProductDetail: '查询商品详情',
  compareProducts: '正在对比商品',
  getProductReviews: '正在查询商品评价',
  viewCart: '查看购物车',
  addToCart: '加入购物车',
  updateCartQuantity: '更新购物车数量',
  removeFromCart: '移除商品',
  clearCart: '清空购物车',
  queryOrder: '查询订单',
  queryUserOrders: '查询订单列表',
  queryLogistics: '查询物流',
  cancelOrder: '取消订单',
  payOrder: '支付订单',
  confirmReceive: '确认收货',
  createTicket: '创建工单',
  queryTicket: '查询工单',
  queryUserTickets: '查询工单列表',
  replyTicket: '回复工单',
  closeTicket: '关闭工单',
  submitProductReview: '提交评价',
  checkReviewStatus: '查询评价资格',
  queryMyReviews: '查询我的评价',
  queryUserInfo: '查询个人资料',
  queryUserAddresses: '查询收货地址',
  queryDefaultAddress: '查询默认地址',
  addAddress: '新增收货地址',
  updateAddress: '修改收货地址',
  deleteAddress: '删除收货地址',
  setDefaultAddress: '设为默认地址',
  queryUnreadNotifications: '查询未读通知',
  getUnreadCount: '查询未读数',
  markNotificationRead: '标记通知已读',
  markAllNotificationsRead: '全部已读',
  queryNotificationHistory: '查询通知历史',
  escalateToHuman: '转人工客服'
}

function toolHintLabel(name) {
  return TOOL_HINT_LABELS[name] || ('调用工具：' + name)
}

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
      // 历史消息恢复工具调用提示：toolCalls 是后端持久化的工具名数组
      if (msg.toolCalls) {
        try {
          const names = JSON.parse(msg.toolCalls)
          if (Array.isArray(names) && names.length > 0) {
            msg.toolCallHints = names.map(name => ({
              toolName: name,
              content: toolHintLabel(name),
              done: true
            }))
          }
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
