<template>
  <div class="user-info-form">
    <div class="form-section-header">
      <h4>基本信息</h4>
      <p>更新您的个人资料，这些信息将在您的账户中显示</p>
    </div>

    <el-form ref="userRef" :model="form" :rules="rules" label-width="100px">
      <el-form-item label="用户昵称" prop="nickName">
        <el-input v-model="form.nickName" maxlength="30" placeholder="请输入您的昵称">
          <template #prefix>
            <el-icon><User /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item label="手机号码" prop="phonenumber">
        <el-input v-model="form.phonenumber" maxlength="11" placeholder="请输入手机号码">
          <template #prefix>
            <el-icon><Phone /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item label="邮箱" prop="email">
        <el-input v-model="form.email" maxlength="50" placeholder="请输入您的邮箱地址">
          <template #prefix>
            <el-icon><Message /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item label="性别" class="gender-item">
        <el-radio-group v-model="form.sex" class="gender-radio-group">
          <el-radio value="0" class="gender-radio">男</el-radio>
          <el-radio value="1" class="gender-radio">女</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item class="form-actions">
        <el-button type="primary" class="submit-btn" @click="submit">保存修改</el-button>
        <el-button type="danger" @click="close">关闭</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>
import { updateUserProfile } from "@/api/system/user"
import { User, Phone, Message } from '@element-plus/icons-vue'

const props = defineProps({
  user: {
    type: Object
  }
})

const { proxy } = getCurrentInstance()
const emit = defineEmits(['profileUpdated'])

const form = ref({})
const rules = ref({
  nickName: [{ required: true, message: "用户昵称不能为空", trigger: "submit" }],
  email: [{ required: true, message: "邮箱地址不能为空", trigger: "submit" }, { type: "email", message: "请输入正确的邮箱地址", trigger: "submit" }],
  phonenumber: [{ required: true, message: "手机号码不能为空", trigger: "submit" }, { pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/, message: "请输入正确的手机号码", trigger: "submit" }],
})

let hideTimer = null

/** 淡出并清除验证提示 */
function fadeOutValidation(formRef) {
  const formEl = formRef.$el || formRef
  formEl.querySelectorAll('.el-form-item__error').forEach(el => el.classList.add('fade-out'))
  setTimeout(() => {
    formRef.clearValidate()
  }, 500)
}

/** 提交按钮 */
function submit() {
  if (hideTimer) clearTimeout(hideTimer)
  proxy.$refs.userRef.validate(valid => {
    if (valid) {
      updateUserProfile(form.value).then(() => {
        proxy.$modal.msgSuccess("修改成功")
        emit('profileUpdated')
      })
    } else {
      hideTimer = setTimeout(() => {
        fadeOutValidation(proxy.$refs.userRef)
      }, 3000)
    }
  })
}

/** 关闭按钮 */
function close() {
  proxy.$tab.closePage()
}

// 回显当前登录用户信息
watch(() => props.user, user => {
  if (user) {
    form.value = { nickName: user.nickName, phonenumber: user.phonenumber, email: user.email, sex: user.sex }
    nextTick(() => {
      proxy.$refs.userRef?.clearValidate()
    })
  }
},{ immediate: true })
</script>

<style lang="scss" scoped>
.user-info-form {
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

/* ===== 表单项间距 ===== */
:deep(.el-form-item) {
  margin-bottom: 24px;
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: #606266;
  padding-right: 16px;
  white-space: nowrap;
  height: 48px;
  line-height: 48px;
}

/* ===== 输入框样式 ===== */
:deep(.el-input__wrapper) {
  background: #faf8f5;
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
  height: 38px;
  line-height: 38px;

  &::placeholder {
    color: #b8a99a;
    font-size: 13px;
  }
}

:deep(.el-input__prefix) {
  color: #8b6f47;
  margin-right: 4px;
}

/* ===== 性别胶囊按钮 ===== */
.gender-radio-group {
  display: flex;
  gap: 12px;
}

.gender-radio {
  :deep(.el-radio__input) {
    display: none;
  }

  :deep(.el-radio__label) {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 72px;
    height: 36px;
    padding: 0 20px;
    border: 1px solid #e6ddd0;
    border-radius: 18px;
    background: #faf8f5;
    color: #6b5a4e;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.25s ease;
  }

  &:hover :deep(.el-radio__label) {
    border-color: #d4c4ad;
    background: #f5efe6;
  }

  :deep(.el-radio__input.is-checked) + .el-radio__label {
    background: linear-gradient(135deg, #8b6f47, #6b4423);
    border-color: transparent;
    color: #fff;
    box-shadow: 0 2px 8px rgba(139, 111, 71, 0.3);
  }
}

/* ===== 提交按钮 ===== */
.form-actions {
  margin-top: 32px;
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

/* ===== 验证提示淡出动画 ===== */
:deep(.el-form-item__error) {
  transition: opacity 0.5s ease;

  &.fade-out {
    opacity: 0;
  }
}
</style>
