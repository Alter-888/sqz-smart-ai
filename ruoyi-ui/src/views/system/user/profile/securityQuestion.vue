<template>
  <div class="security-question-form">
    <div class="form-section-header">
      <h4>安全问题</h4>
      <p>设置密保问题以保护您的账户安全，最多可设置5个</p>
    </div>

    <div class="questions-list">
      <!-- 空状态提示 -->
      <div v-if="questions.length === 0" class="empty-questions">
        <el-icon :size="36" color="#c0c4cc"><QuestionFilled /></el-icon>
        <p>暂无安全问题，请点击下方按钮添加</p>
      </div>
      <div v-for="(item, index) in questions" :key="index" class="question-item">
        <div class="question-item-header">
          <span class="question-index">问题 {{ index + 1 }}</span>
          <el-button
            type="danger"
            text
            size="small"
            :icon="Delete"
            @click="removeQuestion(index)"
          >删除</el-button>
        </div>
        <el-form-item label="密保问题" label-width="80px">
          <el-input v-model="item.question" placeholder="请输入密保问题" clearable>
            <template #prefix>
              <el-icon><QuestionFilled /></el-icon>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item label="密保答案" label-width="80px">
          <el-input v-model="item.answer" type="password" placeholder="请输入密保答案" show-password>
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
          </el-input>
        </el-form-item>
      </div>
    </div>

    <div class="add-question-area">
      <el-button
        type="primary"
        plain
        :disabled="questions.length >= 5"
        @click="addQuestion"
      >
        + 添加问题
      </el-button>
      <span class="question-count">{{ questions.length }} / 5</span>
    </div>

    <div class="form-actions">
      <el-button type="primary" class="submit-btn" :loading="saving" @click="handleSave">保存</el-button>
    </div>
  </div>
</template>

<script setup>
import { getSecurityQuestions, saveSecurityQuestions } from "@/api/system/securityQuestion"
import { QuestionFilled, Lock, Delete } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'

const saving = ref(false)

// 默认预设问题（仅显示1个模板，用户自行添加更多）
const defaultQuestions = [
  { question: '您母亲的姓名？', answer: '' }
]

const questions = ref([])

function addQuestion() {
  if (questions.value.length < 5) {
    questions.value.push({ question: '', answer: '' })
  }
}

function removeQuestion(index) {
  questions.value.splice(index, 1)
}

async function loadQuestions() {
  try {
    const res = await getSecurityQuestions()
    const list = res.questions || []
    if (list.length > 0) {
      // 已有保存的问题，显示问题但答案留空（需重新输入）
      questions.value = list.map(q => ({ question: q.question, answer: '' }))
    } else {
      // 无已保存的问题，使用预设
      questions.value = defaultQuestions.map(q => ({ ...q }))
    }
  } catch (e) {
    questions.value = defaultQuestions.map(q => ({ ...q }))
  }
}

async function handleSave() {
  // 至少要有一个问题
  if (questions.value.length === 0) {
    ElMessage.warning('请至少设置一个安全问题')
    return
  }
  // 校验每个问题
  for (let i = 0; i < questions.value.length; i++) {
    if (!questions.value[i].question || !questions.value[i].question.trim()) {
      ElMessage.warning(`请填写第 ${i + 1} 个密保问题`)
      return
    }
    if (!questions.value[i].answer || !questions.value[i].answer.trim()) {
      ElMessage.warning(`请填写第 ${i + 1} 个密保答案`)
      return
    }
  }
  saving.value = true
  try {
    await saveSecurityQuestions(questions.value)
    ElMessage.success('安全问题保存成功')
    // 保存成功后清空答案（已保存的不再展示明文）
    questions.value.forEach(q => { q.answer = '' })
  } catch (e) {
    // 错误由拦截器处理
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  loadQuestions()
})
</script>

<style lang="scss" scoped>
.security-question-form {
  padding: 4px 0;
}

/* ===== 区域标题 ===== */
.form-section-header {
  margin-bottom: 28px;
  padding-bottom: 16px;
  border-bottom: 1px solid #f0ebe4;

  h4 {
    margin: 0 0 6px;
    font-size: 16px;
    font-weight: 700;
    color: #4a3728;
  }

  p {
    margin: 0;
    font-size: 13px;
    color: #9c8878;
    line-height: 1.5;
  }
}

/* ===== 问题列表 ===== */
.questions-list {
  margin-bottom: 16px;
}

.question-item {
  background: #faf8f5;
  border: 1px solid #f0ebe4;
  border-radius: 10px;
  padding: 16px 20px 8px;
  margin-bottom: 16px;
  transition: box-shadow 0.3s;

  &:hover {
    box-shadow: 0 2px 12px rgba(139, 111, 71, 0.08);
  }
}

.question-item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.question-index {
  font-size: 13px;
  font-weight: 600;
  color: #8b6f47;
}

/* ===== 表单项 ===== */
:deep(.el-form-item) {
  margin-bottom: 16px;
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: #606266;
  padding-right: 12px;
  white-space: nowrap;
  height: 40px;
  line-height: 40px;
}

:deep(.el-input__wrapper) {
  background: #fff;
  border: 1px solid #e6ddd0;
  border-radius: 8px;
  box-shadow: none;
  padding: 4px 12px;
  transition: all 0.3s ease;

  &:hover {
    border-color: #d4c4ad;
  }

  &.is-focus {
    border-color: #8b6f47;
    box-shadow: 0 0 0 3px rgba(139, 111, 71, 0.1);
    background: #fff;
  }
}

:deep(.el-input__inner) {
  height: 32px;
  line-height: 32px;

  &::placeholder {
    color: #b8a99a;
    font-size: 13px;
  }
}

:deep(.el-input__prefix) {
  color: #8b6f47;
  margin-right: 4px;
}

/* ===== 添加按钮区 ===== */
.add-question-area {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.question-count {
  font-size: 13px;
  color: #9c8878;
}

/* ===== 提交按钮 ===== */
.form-actions {
  margin-top: 24px;
  padding-top: 20px;
  border-top: 1px solid #f0ebe4;
}

.submit-btn {
  background: linear-gradient(135deg, #8b6f47, #6b4423) !important;
  border: none !important;
  color: #fff !important;
  border-radius: 8px !important;
  padding: 10px 32px !important;
  height: 40px;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 1px;
  transition: all 0.3s ease;

  &:hover {
    box-shadow: 0 4px 15px rgba(139, 111, 71, 0.4);
    transform: translateY(-1px);
  }

  &:active {
    transform: translateY(0);
  }
}
</style>
