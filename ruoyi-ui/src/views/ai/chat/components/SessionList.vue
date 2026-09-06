<template>
  <div class="session-list">
    <div class="session-header">
      <span class="title">对话列表</span>
      <el-icon class="collapse-btn" @click="emit('collapse')"><Fold /></el-icon>
    </div>

    <div class="new-chat-btn" @click="handleNewSession">
      <el-icon><Plus /></el-icon>
      <span>新聊天</span>
    </div>

    <div class="search-box">
      <el-input
        v-model="searchText"
        placeholder="搜索对话"
        :prefix-icon="Search"
        clearable
      />
    </div>

    <div class="session-items">
      <template v-for="group in groupedSessions" :key="group.label">
        <div class="group-label">{{ group.label }}</div>
        <div
          v-for="session in group.items"
          :key="session.sessionId"
          class="session-item"
          :class="{ active: currentSessionId === session.sessionId }"
          @click="handleSelect(session)"
        >
          <el-icon><ChatDotRound /></el-icon>
          <span class="session-title">{{ session.title || '新对话' }}</span>
          <el-dropdown trigger="click" @command="(cmd) => handleCommand(cmd, session)" popper-class="session-dropdown">
            <img src="@/assets/images/more.png" class="more-btn" @click.stop />
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="rename" :icon="Edit">重命名</el-dropdown-item>
                <el-dropdown-item command="pin" :icon="Top">{{ session.isPinned ? '取消置顶' : '置顶' }}</el-dropdown-item>
                <el-dropdown-item command="delete" :icon="Delete" divided>删除</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </template>

      <div v-if="groupedSessions.length === 0 && searchText.trim()" class="empty-tip">
        未找到匹配的对话
      </div>
      <div v-else-if="sessions.length === 0" class="empty-tip">
        暂无对话，点击上方按钮开始
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Plus, ChatDotRound, Delete, Fold, Search, Top, Edit } from '@element-plus/icons-vue'
import { ElMessageBox, ElMessage } from 'element-plus'
import useChatStore from '@/store/modules/chat'
import { listSessions, createSession, getSessionMessages, deleteSession, togglePinSession, renameSession } from '@/api/ai/chat'
import { storeToRefs } from 'pinia'

const chatStore = useChatStore()
const { currentSessionId, sessions } = storeToRefs(chatStore)

const emit = defineEmits(['sessionChanged', 'collapse'])

const searchText = ref('')

const groupedSessions = computed(() => {
  const now = new Date()
  const minutesAgo = (min) => new Date(now.getTime() - min * 60000)
  const daysAgo = (d) => new Date(new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime() - (d - 1) * 86400000)

  // 7档时间边界
  const boundaries = [
    { label: '刚刚', from: minutesAgo(30) },
    { label: '几小时前', from: daysAgo(1) },
    { label: '昨天', from: daysAgo(2) },
    { label: '一星期内', from: daysAgo(8) },
    { label: '一个月内', from: daysAgo(31) },
    { label: '三个月内', from: daysAgo(91) },
    { label: '更久之前', from: new Date(0) }
  ]

  let filtered = sessions.value
  if (searchText.value.trim()) {
    const keyword = searchText.value.trim().toLowerCase()
    filtered = filtered.filter(s => (s.title || '新对话').toLowerCase().includes(keyword))
  }

  // 分离置顶和非置顶会话
  const pinnedItems = filtered.filter(s => s.isPinned === 1)
  const unpinnedItems = filtered.filter(s => !s.isPinned || s.isPinned === 0)

  const buckets = boundaries.map(b => ({ label: b.label, from: b.from, items: [] }))

  for (const session of unpinnedItems) {
    const d = new Date(session.updateTime || session.createTime)
    for (const bucket of buckets) {
      if (d >= bucket.from) {
        bucket.items.push(session)
        break
      }
    }
  }

  const result = []
  if (pinnedItems.length > 0) {
    result.push({ label: '置顶', items: pinnedItems })
  }
  buckets.filter(b => b.items.length > 0).forEach(b => result.push({ label: b.label, items: b.items }))
  return result
})

async function loadSessions() {
  const res = await listSessions()
  const list = res.data || []
  chatStore.setSessions(list)

  // 自动进入最新会话或创建新会话，避免显示空白界面
  if (list.length > 0) {
    const first = list[0]
    chatStore.setCurrentSession(first.sessionId)
    const msgRes = await getSessionMessages(first.sessionId)
    chatStore.setMessages(msgRes.data || [])
    emit('sessionChanged', first.sessionId)
  } else {
    await handleNewSession()
  }
}

async function handleNewSession() {
  const res = await createSession({ title: '' })
  const newSession = res.data
  chatStore.setSessions([newSession, ...sessions.value])
  chatStore.setCurrentSession(newSession.sessionId)
  chatStore.clearMessages()
  emit('sessionChanged', newSession.sessionId)
}

async function handleSelect(session) {
  chatStore.setCurrentSession(session.sessionId)
  const res = await getSessionMessages(session.sessionId)
  chatStore.setMessages(res.data || [])
  emit('sessionChanged', session.sessionId)
}

async function handleTogglePin(session) {
  try {
    const res = await togglePinSession(session.sessionId)
    chatStore.toggleSessionPin(session.sessionId, res.data)
    ElMessage.success(res.data.isPinned ? '已置顶' : '已取消置顶')
    // 重新加载列表以获取后端排序
    const listRes = await listSessions()
    chatStore.setSessions(listRes.data || [])
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

function handleCommand(command, session) {
  if (command === 'rename') handleRename(session)
  else if (command === 'pin') handleTogglePin(session)
  else if (command === 'delete') handleDelete(session)
}

async function handleRename(session) {
  try {
    const { value: newTitle } = await ElMessageBox.prompt('请输入新的对话标题', '重命名', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      inputValue: session.title || '新对话',
      inputPattern: /\S+/,
      inputErrorMessage: '标题不能为空'
    })
    if (newTitle && newTitle.trim()) {
      await renameSession(session.sessionId, newTitle.trim())
      chatStore.renameSessionTitle(session.sessionId, newTitle.trim())
      ElMessage.success('重命名成功')
    }
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('重命名失败')
    }
  }
}

async function handleDelete(session) {
  try {
    await ElMessageBox.confirm(
      '确定要删除对话"' + (session.title || '新对话') + '"吗？删除后无法恢复。',
      '删除确认',
      { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
    )
    await deleteSession(session.sessionId)
    chatStore.removeSession(session.sessionId)
    ElMessage.success('删除成功')

    // 删除后自动选中下一个会话或新建
    if (sessions.value.length === 0) {
      await handleNewSession()
    } else if (!currentSessionId.value) {
      const first = sessions.value[0]
      chatStore.setCurrentSession(first.sessionId)
      const msgRes = await getSessionMessages(first.sessionId)
      chatStore.setMessages(msgRes.data || [])
      emit('sessionChanged', first.sessionId)
    }
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

onMounted(() => {
  loadSessions()
})
</script>

<style scoped>
.session-list {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: linear-gradient(180deg, #eef1f5 0%, #f3f5f8 100%);
  min-width: 300px;
}

.session-header {
  padding: 16px 16px 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: transparent;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.title {
  font-size: 18px;
  font-weight: 700;
  color: #1a1c21;
  letter-spacing: 0.3px;
}

.collapse-btn {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  color: #606266;
  cursor: pointer;
  border-radius: 10px;
  border: 1px solid #eef0f3;
  background: #ffffff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  transition: all 0.2s;
}

.collapse-btn:hover {
  background: #f0f2f5;
  color: #409eff;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

/* 新聊天按钮 */
.new-chat-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 12px 12px 8px;
  padding: 10px 16px;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  color: #ffffff;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.25s;
  background: linear-gradient(135deg, #36b5a0, #2ec4b6);
  box-shadow: 0 2px 8px rgba(46, 196, 182, 0.25);
}

.new-chat-btn:hover {
  background: linear-gradient(135deg, #2fa08d, #28b0a3);
  color: #ffffff;
  box-shadow: 0 4px 16px rgba(46, 196, 182, 0.35);
  transform: translateY(-1px);
}

.new-chat-btn .el-icon {
  font-size: 16px;
}

/* 搜索框 */
.search-box {
  padding: 4px 12px 4px;
}

.search-box :deep(.el-input__wrapper) {
  border-radius: 8px;
  background: #ffffff;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05) !important;
  border: 1px solid #e8eaee;
  transition: all 0.2s;
  padding: 4px 8px;
}

.search-box :deep(.el-input__wrapper.is-focus) {
  background: #fff;
  border-color: #c6e2ff;
}

/* 日期分组标签 - 带右侧延伸线 */
.group-label {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 12px;
  font-weight: 600;
  color: #a0a3ab;
  padding: 10px 4px 8px;
  letter-spacing: 0.5px;
  white-space: nowrap;
}

.group-label:first-child {
  padding-top: 8px;
}

.group-label::after {
  content: '';
  flex: 1;
  height: 1px;
  background: linear-gradient(to right, #e0e1e3, transparent);
}

.session-items {
  flex: 1;
  overflow-y: auto;
  padding: 0 12px 12px;
  scrollbar-width: thin;
  scrollbar-color: #e0e1e3 transparent;
}
.session-items::-webkit-scrollbar { width: 4px; }
.session-items::-webkit-scrollbar-thumb {
  background: #dcdee2;
  border-radius: 2px;
}
.session-items::-webkit-scrollbar-track { background: transparent; }

.session-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  margin-bottom: 4px;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.25, 0.8, 0.25, 1);
  color: #5a5d65;
  font-size: 14px;
  position: relative;
  border: 1px solid transparent;
}

.session-item:hover {
  background: rgba(64, 158, 255, 0.06);
  color: #303133;
  transform: translateX(3px);
}

/* 悬停时显示三个点图标 */
.session-item:hover .more-btn {
  opacity: 0.6;
}

.session-item.active {
  background: rgba(255, 255, 255, 0.85);
  color: #409eff;
  font-weight: 500;
  border-color: rgba(64, 158, 255, 0.2);
  box-shadow: 0 2px 12px rgba(64, 158, 255, 0.1);
}

.session-item.active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 60%;
  background: linear-gradient(180deg, #409eff, #667eea);
  border-radius: 0 2px 2px 0;
}

.session-title {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.more-btn {
  width: 24px;
  height: 24px;
  padding: 6px;
  border-radius: 8px;
  flex-shrink: 0;
  cursor: pointer;
  transition: all 0.25s ease;
  opacity: 0;
}

.more-btn:hover {
  background-color: rgba(0, 0, 0, 0.08);
  opacity: 1 !important;
  transform: scale(1.15);
}

.session-item.active .more-btn {
  opacity: 0.6;
}

.empty-tip {
  text-align: center;
  color: #b0b3ba;
  padding: 60px 20px;
  font-size: 13px;
  line-height: 1.8;
}
</style>
