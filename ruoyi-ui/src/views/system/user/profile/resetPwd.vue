<template>
  <div class="reset-pwd-form">
    <div class="form-section-header">
      <h4>修改密码</h4>
      <p>为了账户安全，建议定期更换密码</p>
    </div>

    <el-form ref="pwdRef" :model="user" :rules="rules" label-width="100px">
      <el-form-item label="旧密码" prop="oldPassword">
        <el-input v-model="user.oldPassword" placeholder="请输入旧密码" type="password" show-password>
          <template #prefix>
            <el-icon><Lock /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item label="新密码" prop="newPassword">
        <el-input v-model="user.newPassword" placeholder="请输入新密码" type="password" show-password>
          <template #prefix>
            <el-icon><Lock /></el-icon>
          </template>
        </el-input>
        <div class="field-hint">密码长度 6-20 个字符，不能包含 &lt; &gt; " ' \ | 等特殊字符</div>
      </el-form-item>
      <el-form-item label="确认密码" prop="confirmPassword">
        <el-input v-model="user.confirmPassword" placeholder="请再次输入新密码" type="password" show-password>
          <template #prefix>
            <el-icon><Lock /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item class="form-actions">
        <el-button type="primary" class="submit-btn" @click="submit">确认修改</el-button>
        <el-button type="danger" @click="close">关闭</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>
import { updateUserPwd } from "@/api/system/user"
import { Lock } from '@element-plus/icons-vue'

const { proxy } = getCurrentInstance()

const user = reactive({
  oldPassword: undefined,
  newPassword: undefined,
  confirmPassword: undefined
})

const equalToPassword = (rule, value, callback) => {
  if (user.newPassword !== value) {
    callback(new Error("两次输入的密码不一致"))
  } else {
    callback()
  }
}

const rules = ref({
  oldPassword: [{ required: true, message: "旧密码不能为空", trigger: "submit" }],
  newPassword: [{ required: true, message: "新密码不能为空", trigger: "submit" }, { min: 6, max: 20, message: "长度在 6 到 20 个字符", trigger: "submit" }, { pattern: /^[^<>"'|\\]+$/, message: "不能包含非法字符：< > \" ' \\\ |", trigger: "submit" }],
  confirmPassword: [{ required: true, message: "确认密码不能为空", trigger: "submit" }, { required: true, validator: equalToPassword, trigger: "submit" }]
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
  proxy.$refs.pwdRef.validate(valid => {
    if (valid) {
      updateUserPwd(user.oldPassword, user.newPassword).then(() => {
        proxy.$modal.msgSuccess("修改成功")
        Object.assign(user, {
          oldPassword: undefined,
          newPassword: undefined,
          confirmPassword: undefined
        })
        nextTick(() => {
          proxy.$refs.pwdRef.clearValidate()
        })
      })
    } else {
      hideTimer = setTimeout(() => {
        fadeOutValidation(proxy.$refs.pwdRef)
      }, 3000)
    }
  })
}

/** 关闭按钮 */
function close() {
  proxy.$tab.closePage()
}
</script>

<style lang="scss" scoped>
.reset-pwd-form {
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

:deep(.el-input__suffix) {
  color: #b8a99a;
  transition: color 0.2s;

  &:hover {
    color: #8b6f47;
  }
}

/* ===== 密码规则提示 ===== */
.field-hint {
  margin-top: 6px;
  font-size: 12px;
  color: #b8a99a;
  line-height: 1.5;
  padding-left: 2px;
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
