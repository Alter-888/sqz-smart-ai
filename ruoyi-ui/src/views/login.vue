<template>
  <div class="login">
    <!-- 左侧宣传面板 -->
    <div class="login-left">
      <div class="left-content">
        <!-- 品牌标识 -->
        <div class="brand-bar">
          <img src="@/assets/logo/logo.png" alt="Logo" class="brand-logo" />
          <span class="brand-name">智能数码商城AI客服系统</span>
        </div>
        <!-- 主标题 -->
        <div class="hero-section">
          <span class="hero-badge">AI POWERED</span>
          <div class="hero-headline">
            <p class="hero-animate">AI 智能客服</p>
            <p>重新定义购物体验</p>
          </div>
        </div>
        <!-- 描述 -->
        <div class="hero-desc">
          <p>基于 Spring AI 与 MCP 协议</p>
          <p>提供智能化的数码产品导购服务</p>
          <p>融合 RAG 知识增强与实时工具调用，打造新一代AI客服</p>
        </div>
        <!-- 功能标签 -->
        <div class="hero-tags">
          <span class="tag-capsule">智能对话</span>
          <span class="tag-capsule">精准推荐</span>
          <span class="tag-capsule">订单管理</span>
          <span class="tag-capsule">售后服务</span>
        </div>
      </div>
    </div>

    <!-- 右侧登录面板 -->
    <div class="login-right">
      <!-- 背景装饰物件 -->
      <!-- 千纸鹤 - 大 右上 -->
      <div class="decor decor-crane1">
        <svg viewBox="0 0 80 80" fill="none"><path d="M40 2 L60 28 L78 24 L50 42 L58 78 L40 52 L22 78 L30 42 L2 24 L20 28 Z" fill="rgba(99,102,241,0.1)" stroke="rgba(99,102,241,0.25)" stroke-width="1.2" stroke-linejoin="round"/><path d="M40 2 L40 52" stroke="rgba(99,102,241,0.15)" stroke-width="0.8"/></svg>
      </div>
      <!-- 千纸鹤 - 中 左上 -->
      <div class="decor decor-crane2">
        <svg viewBox="0 0 80 80" fill="none"><path d="M40 2 L60 28 L78 24 L50 42 L58 78 L40 52 L22 78 L30 42 L2 24 L20 28 Z" fill="rgba(59,130,246,0.08)" stroke="rgba(59,130,246,0.2)" stroke-width="1.2" stroke-linejoin="round"/><path d="M40 2 L40 52" stroke="rgba(59,130,246,0.12)" stroke-width="0.8"/></svg>
      </div>
      <!-- 纸飞机 - 左中 -->
      <div class="decor decor-plane1">
        <svg viewBox="0 0 64 64" fill="none"><path d="M4 32 L58 4 L36 34 L52 58 Z" fill="rgba(59,130,246,0.09)" stroke="rgba(59,130,246,0.22)" stroke-width="1.3" stroke-linejoin="round"/><path d="M4 32 L36 34 L52 58" stroke="rgba(59,130,246,0.15)" stroke-width="0.8"/></svg>
      </div>
      <!-- 芯片 - 左下 -->
      <div class="decor decor-chip">
        <svg viewBox="0 0 48 48" fill="none"><rect x="12" y="12" width="24" height="24" rx="3" stroke="currentColor" stroke-width="1.5" fill="currentColor" fill-opacity="0.05"/><line x1="18" y1="12" x2="18" y2="4" stroke="currentColor" stroke-width="1.2"/><line x1="24" y1="12" x2="24" y2="4" stroke="currentColor" stroke-width="1.2"/><line x1="30" y1="12" x2="30" y2="4" stroke="currentColor" stroke-width="1.2"/><line x1="18" y1="36" x2="18" y2="44" stroke="currentColor" stroke-width="1.2"/><line x1="24" y1="36" x2="24" y2="44" stroke="currentColor" stroke-width="1.2"/><line x1="30" y1="36" x2="30" y2="44" stroke="currentColor" stroke-width="1.2"/><line x1="12" y1="18" x2="4" y2="18" stroke="currentColor" stroke-width="1.2"/><line x1="12" y1="24" x2="4" y2="24" stroke="currentColor" stroke-width="1.2"/><line x1="12" y1="30" x2="4" y2="30" stroke="currentColor" stroke-width="1.2"/><line x1="36" y1="18" x2="44" y2="18" stroke="currentColor" stroke-width="1.2"/><line x1="36" y1="24" x2="44" y2="24" stroke="currentColor" stroke-width="1.2"/><line x1="36" y1="30" x2="44" y2="30" stroke="currentColor" stroke-width="1.2"/></svg>
      </div>
      <!-- 笔记本 - 底部右 -->
      <div class="decor decor-laptop">
        <svg viewBox="0 0 56 40" fill="none"><rect x="8" y="2" width="40" height="28" rx="3" stroke="currentColor" stroke-width="1.5" fill="currentColor" fill-opacity="0.04"/><path d="M2 30 L54 30 L50 38 L6 38 Z" stroke="currentColor" stroke-width="1.5" fill="currentColor" fill-opacity="0.03"/></svg>
      </div>
      <!-- 3D翻牌容器 -->
      <div class="card-scene">
        <div class="card-flipper" :class="{ 'is-flipped': isFlipped }">
          <!-- 登录面 -->
          <div class="card-face card-front">
      <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form" :class="{ 'admin-switching': adminSwitching }">
        <!-- 表单头部：Logo居左 + 标题居中 -->
        <div class="form-header">
          <h3>{{ isAdminMode ? '管理员登录' : '欢迎使用AI智能客服系统' }}</h3>
          <p>{{ isAdminMode ? '请使用管理员账号登录后台' : '登录您的账户以继续' }}</p>
        </div>
        <!-- 用户名 -->
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            type="text"
            size="large"
            auto-complete="off"
            :placeholder="isAdminMode ? '管理员账号' : '请输入账号'"
          >
            <template #prefix><svg-icon icon-class="user" class="el-input__icon input-icon" /></template>
          </el-input>
        </el-form-item>
        <!-- 密码 -->
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            size="large"
            auto-complete="off"
            placeholder="请输入密码"
            @keyup.enter="handleLogin"
          >
            <template #prefix><svg-icon icon-class="password" class="el-input__icon input-icon" /></template>
          </el-input>
        </el-form-item>
        <!-- 验证码 -->
        <el-form-item prop="code" v-if="captchaEnabled">
          <el-input
            v-model="loginForm.code"
            size="large"
            auto-complete="off"
            placeholder="验证码"
            style="width: 63%"
            @keyup.enter="handleLogin"
          >
            <template #prefix><svg-icon icon-class="validCode" class="el-input__icon input-icon" /></template>
          </el-input>
          <div class="login-code">
            <img :src="codeUrl" @click="getCode" class="login-code-img"/>
          </div>
        </el-form-item>
        <!-- 记住密码 + 忘记密码 -->
        <div class="form-options-row">
          <el-checkbox v-model="loginForm.rememberMe">记住密码</el-checkbox>
          <span class="forgot-link" @click="handleForgotPassword">忘记密码?</span>
        </div>
        <!-- 登录按钮 -->
        <el-form-item style="width:100%;">
          <el-button
            :loading="loading"
            size="large"
            type="primary"
            style="width:100%;"
            class="login-btn"
            @click.prevent="handleLogin"
          >
            <span v-if="!loading">登 录</span>
            <span v-else>登 录 中...</span>
          </el-button>
        </el-form-item>
        <!-- 分隔线 -->
        <div class="form-divider"><span>或</span></div>
        <!-- 底部链接 -->
        <div class="form-footer-links">
          <span v-if="!isAdminMode" class="footer-link register-link" @click="flipToRegister">
            没有账号？<strong>立即注册</strong>
          </span>
          <span v-else class="footer-link placeholder-link"></span>
          <span class="footer-link admin-link" @click="toggleAdminMode">
            {{ isAdminMode ? '返回普通登录' : '管理员入口' }}
            <span v-if="!isAdminMode"> &rarr;</span>
          </span>
        </div>
      </el-form>
          </div>
          <!-- 注册面 -->
          <div class="card-face card-back">
      <el-form ref="registerRef" :model="registerForm" :rules="registerRules" class="login-form">
        <div class="form-header">
          <h3>创建新账户</h3>
          <p>填写信息完成注册</p>
        </div>
        <!-- 用户名 -->
        <el-form-item prop="username">
          <el-input
            v-model="registerForm.username"
            type="text"
            size="large"
            auto-complete="off"
            placeholder="请输入账号"
          >
            <template #prefix><svg-icon icon-class="user" class="el-input__icon input-icon" /></template>
          </el-input>
        </el-form-item>
        <!-- 密码 -->
        <el-form-item prop="password">
          <el-input
            v-model="registerForm.password"
            type="password"
            size="large"
            auto-complete="off"
            placeholder="请输入密码"
          >
            <template #prefix><svg-icon icon-class="password" class="el-input__icon input-icon" /></template>
          </el-input>
        </el-form-item>
        <!-- 确认密码 -->
        <el-form-item prop="confirmPassword">
          <el-input
            v-model="registerForm.confirmPassword"
            type="password"
            size="large"
            auto-complete="off"
            placeholder="确认密码"
            @keyup.enter="handleRegister"
          >
            <template #prefix><svg-icon icon-class="password" class="el-input__icon input-icon" /></template>
          </el-input>
        </el-form-item>
        <!-- 验证码 -->
        <el-form-item prop="code" v-if="captchaEnabled">
          <el-input
            v-model="registerForm.code"
            size="large"
            auto-complete="off"
            placeholder="验证码"
            style="width: 63%"
            @keyup.enter="handleRegister"
          >
            <template #prefix><svg-icon icon-class="validCode" class="el-input__icon input-icon" /></template>
          </el-input>
          <div class="login-code">
            <img :src="codeUrl" @click="getCode" class="login-code-img"/>
          </div>
        </el-form-item>
        <!-- 注册按钮 -->
        <el-form-item style="width:100%;">
          <el-button
            :loading="registerLoading"
            size="large"
            type="primary"
            style="width:100%;"
            class="login-btn"
            @click.prevent="handleRegister"
          >
            <span v-if="!registerLoading">注 册</span>
            <span v-else>注 册 中...</span>
          </el-button>
        </el-form-item>
        <!-- 分隔线 -->
        <div class="form-divider"><span>或</span></div>
        <!-- 底部链接 -->
        <div class="form-footer-links">
          <span class="footer-link register-link" @click="flipToLogin">
            已有账号？<strong>返回登录</strong>
          </span>
        </div>
      </el-form>
          </div>
        </div>
      </div>
    </div>

    <!-- 忘记密码弹窗 -->
    <el-dialog v-model="forgotDialogVisible" title="忘记密码" width="440px" destroy-on-close :close-on-click-modal="false">
      <div class="forgot-pwd-content">
        <div style="margin-bottom:16px;font-size:13px;color:#909399;">步骤 {{ forgotStep === 4 ? 3 : forgotStep }} / 3</div>
      <!-- 步骤1: 输入用户名 -->
      <template v-if="forgotStep === 1">
        <el-form label-width="0">
          <p style="color:#606266;margin:0 0 16px;font-size:14px;">请输入您的账号，我们将通过密保问题验证您的身份</p>
          <el-form-item>
            <el-input v-model="forgotForm.username" placeholder="请输入账号" size="default" @keyup.enter="forgotGetQuestion">
              <template #prefix><svg-icon icon-class="user" class="el-input__icon" /></template>
            </el-input>
          </el-form-item>
        </el-form>
      </template>
      <!-- 步骤2: 选择并回答密保问题 -->
      <template v-if="forgotStep === 2">
        <el-form label-width="0">
          <!-- 区域1：选择密保问题并回答 -->
          <div class="forgot-section">
            <div class="forgot-section-title">
              <span class="section-badge">1</span>
              <span>选择密保问题并回答</span>
            </div>
            <el-radio-group v-model="forgotForm.questionId" @change="forgotForm.securityAnswer = ''">
              <el-radio v-for="(q, index) in securityQuestions" :key="q.id" :value="q.id">
                问题{{ index + 1 }}：{{ q.question }}
              </el-radio>
            </el-radio-group>
            <!-- 选中问题后才显示答案输入框 -->
            <div v-if="forgotForm.questionId" class="answer-area">
              <div class="answer-label">请输入问题{{ selectedQuestionIndex }}的答案</div>
              <el-form-item>
                <el-input v-model="forgotForm.securityAnswer" placeholder="请输入答案" size="default" autocomplete="off" name="forgot-security-answer">
                  <template #prefix><svg-icon icon-class="validCode" class="el-input__icon" /></template>
                </el-input>
              </el-form-item>
            </div>
          </div>

          <!-- 区域2：设置新密码 -->
          <div class="forgot-section">
            <div class="forgot-section-title">
              <span class="section-badge">2</span>
              <span>设置新密码</span>
            </div>
            <el-form-item>
              <el-input v-model="forgotForm.newPassword" type="password" placeholder="请输入新密码" size="default" show-password autocomplete="new-password">
                <template #prefix><svg-icon icon-class="password" class="el-input__icon" /></template>
              </el-input>
            </el-form-item>
            <el-form-item>
              <el-input v-model="forgotForm.confirmNewPassword" type="password" placeholder="确认新密码" size="default" show-password autocomplete="new-password" @keyup.enter="forgotResetPassword">
                <template #prefix><svg-icon icon-class="password" class="el-input__icon" /></template>
              </el-input>
            </el-form-item>
          </div>

          <div style="text-align:center;margin-top:4px;">
            <span class="forgot-link" @click="forgotSwitchToAdminReset">忘记答案？申请管理员重置</span>
          </div>
        </el-form>
      </template>
      <!-- 步骤4: 申请管理员重置 -->
      <template v-if="forgotStep === 4">
        <el-form label-width="0">
          <el-alert title="密保验证不可用，您可以申请管理员帮您重置密码" type="warning" :closable="false" show-icon style="margin-bottom:16px;" />
          <p style="color:#606266;margin:0 0 12px;font-size:14px;">申请账号：<strong>{{ forgotForm.username }}</strong></p>
          <el-form-item>
            <el-input v-model="forgotForm.adminNewPassword" type="password" placeholder="请输入期望的新密码" size="default" show-password autocomplete="new-password">
              <template #prefix><svg-icon icon-class="password" class="el-input__icon" /></template>
            </el-input>
          </el-form-item>
          <el-form-item>
            <el-input v-model="forgotForm.adminConfirmPassword" type="password" placeholder="确认新密码" size="default" show-password autocomplete="new-password">
              <template #prefix><svg-icon icon-class="password" class="el-input__icon" /></template>
            </el-input>
          </el-form-item>
          <el-form-item>
            <el-input v-model="forgotForm.reason" type="textarea" :rows="3" size="default" placeholder="请简要说明申请原因（选填）" />
          </el-form-item>
        </el-form>
      </template>
      </div>
      <template #footer>
        <el-button v-if="forgotStep !== 1" @click="forgotStep = 1; securityQuestions = []">返回</el-button>
        <el-button @click="forgotDialogVisible = false">取消</el-button>
        <el-button v-if="forgotStep === 1" type="primary" :loading="forgotLoading" @click="forgotGetQuestion">下一步</el-button>
        <el-button v-if="forgotStep === 2" type="primary" :loading="forgotLoading" @click="forgotResetPassword">重置密码</el-button>
        <el-button v-if="forgotStep === 4" type="primary" :loading="forgotLoading" @click="forgotRequestAdminReset">提交申请</el-button>
      </template>
    </el-dialog>

    <!-- 底部版权 -->
    <div class="el-login-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script setup>
import { getCodeImg, register } from "@/api/login"
import { getSecurityQuestion, resetByQuestion, requestAdminReset } from "@/api/system/forgotPassword"
import Cookies from "js-cookie"
import { encrypt, decrypt } from "@/utils/jsencrypt"
import useUserStore from '@/store/modules/user'
import defaultSettings from '@/settings'
import { ElMessage, ElMessageBox } from 'element-plus'

const title = import.meta.env.VITE_APP_TITLE
const footerContent = defaultSettings.footerContent
const userStore = useUserStore()
const route = useRoute()
const router = useRouter()
const { proxy } = getCurrentInstance()

const loginForm = ref({
  username: "",
  password: "",
  rememberMe: false,
  code: "",
  uuid: ""
})

const loginRules = {
  username: [{ required: true, trigger: "blur", message: "请输入您的账号" }],
  password: [{ required: true, trigger: "blur", message: "请输入您的密码" }],
  code: [{ required: true, trigger: "change", message: "请输入验证码" }]
}

const codeUrl = ref("")
const loading = ref(false)
const captchaEnabled = ref(true)
const redirect = ref(undefined)
const isAdminMode = ref(false)
const adminSwitching = ref(false)

// ========== 翻牌状态 ==========
const isFlipped = ref(false)

// ========== 注册相关 ==========
const registerLoading = ref(false)
const registerForm = ref({
  username: "",
  password: "",
  confirmPassword: "",
  code: "",
  uuid: ""
})

const equalToPassword = (rule, value, callback) => {
  if (registerForm.value.password !== value) {
    callback(new Error("两次输入的密码不一致"))
  } else {
    callback()
  }
}

const registerRules = {
  username: [
    { required: true, trigger: "blur", message: "请输入您的账号" },
    { min: 2, max: 20, message: "用户账号长度必须介于 2 和 20 之间", trigger: "blur" }
  ],
  password: [
    { required: true, trigger: "blur", message: "请输入您的密码" },
    { min: 5, max: 20, message: "用户密码长度必须介于 5 和 20 之间", trigger: "blur" },
    { pattern: /^[^<>"'|\\]+$/, message: "不能包含非法字符：< > \" ' \\ |", trigger: "blur" }
  ],
  confirmPassword: [
    { required: true, trigger: "blur", message: "请再次输入您的密码" },
    { required: true, validator: equalToPassword, trigger: "blur" }
  ],
  code: [{ required: true, trigger: "change", message: "请输入验证码" }]
}

watch(route, (newRoute) => {
    redirect.value = newRoute.query && newRoute.query.redirect
}, { immediate: true })

function toggleAdminMode() {
  adminSwitching.value = true
  setTimeout(() => {
    isAdminMode.value = !isAdminMode.value
    setTimeout(() => {
      adminSwitching.value = false
    }, 50)
  }, 300)
}


// ========== 忘记密码 ==========
const forgotDialogVisible = ref(false)
const forgotStep = ref(1) // 1=输入用户名, 2=选择问题回答, 4=申请管理员重置
const forgotForm = ref({ username: '', questionId: null, securityAnswer: '', newPassword: '', confirmNewPassword: '', adminNewPassword: '', adminConfirmPassword: '', reason: '' })
const securityQuestions = ref([])
const forgotLoading = ref(false)

const selectedQuestionIndex = computed(() => {
  const idx = securityQuestions.value.findIndex(item => item.id === forgotForm.value.questionId)
  return idx >= 0 ? idx + 1 : ''
})

function handleForgotPassword() {
  forgotStep.value = 1
  forgotForm.value = { username: '', questionId: null, securityAnswer: '', newPassword: '', confirmNewPassword: '', adminNewPassword: '', adminConfirmPassword: '', reason: '' }
  securityQuestions.value = []
  forgotDialogVisible.value = true
}

async function forgotGetQuestion() {
  if (!forgotForm.value.username) {
    ElMessage.warning('请输入用户名')
    return
  }
  forgotLoading.value = true
  try {
    const res = await getSecurityQuestion({ username: forgotForm.value.username })
    const questions = res.questions || []
    securityQuestions.value = questions
    if (questions.length > 0) {
      forgotStep.value = 2
    } else {
      ElMessage.warning('该用户未设置密保问题，请申请管理员重置')
      forgotStep.value = 4
    }
  } catch (e) {
    console.error('[忘记密码] 获取密保问题失败:', e)
    // 错误已由 request.js 拦截器通过 ElMessage.error 展示
    // 保持步骤1，让用户看到错误后可修改用户名重试
  } finally {
    forgotLoading.value = false
  }
}

async function forgotResetPassword() {
  if (!forgotForm.value.questionId) {
    ElMessage.warning('请先选择一个密保问题')
    return
  }
  if (!forgotForm.value.securityAnswer || !forgotForm.value.securityAnswer.trim()) {
    ElMessage.warning('请输入密保答案')
    return
  }
  if (!forgotForm.value.newPassword) {
    ElMessage.warning('请输入新密码')
    return
  }
  if (forgotForm.value.newPassword.length < 5 || forgotForm.value.newPassword.length > 20) {
    ElMessage.warning('密码长度必须在5到20个字符之间')
    return
  }
  if (forgotForm.value.newPassword !== forgotForm.value.confirmNewPassword) {
    ElMessage.warning('两次输入的密码不一致')
    return
  }
  forgotLoading.value = true
  try {
    await resetByQuestion({
      username: forgotForm.value.username,
      questionId: forgotForm.value.questionId,
      securityAnswer: forgotForm.value.securityAnswer,
      newPassword: forgotForm.value.newPassword
    })
    ElMessage.success('密码重置成功，请使用新密码登录')
    forgotDialogVisible.value = false
    loginForm.value.username = forgotForm.value.username
    loginForm.value.password = ''
  } catch (e) {
    console.error('[忘记密码] 密码重置失败:', e)
  } finally {
    forgotLoading.value = false
  }
}

function forgotSwitchToAdminReset() {
  forgotStep.value = 4
}

async function forgotRequestAdminReset() {
  if (!forgotForm.value.adminNewPassword) {
    ElMessage.warning('请输入期望的新密码')
    return
  }
  if (forgotForm.value.adminNewPassword.length < 5 || forgotForm.value.adminNewPassword.length > 20) {
    ElMessage.warning('密码长度必须在5到20个字符之间')
    return
  }
  if (forgotForm.value.adminNewPassword !== forgotForm.value.adminConfirmPassword) {
    ElMessage.warning('两次输入的密码不一致')
    return
  }
  forgotLoading.value = true
  try {
    await requestAdminReset({
      username: forgotForm.value.username,
      newPassword: forgotForm.value.adminNewPassword,
      reason: forgotForm.value.reason || '密保答案遗忘，申请管理员重置密码'
    })
    ElMessage.success('申请已提交，请等待管理员处理')
    forgotDialogVisible.value = false
  } catch (e) {
    console.error('[忘记密码] 管理员重置申请失败:', e)
  } finally {
    forgotLoading.value = false
  }
}

// ========== 翻牌切换 ==========
function flipToRegister() {
  isFlipped.value = true
  nextTick(() => {
    proxy.$refs.registerRef?.clearValidate()
    getCode()
  })
}

function flipToLogin() {
  isFlipped.value = false
  nextTick(() => {
    proxy.$refs.loginRef?.clearValidate()
    getCode()
  })
}

// ========== 注册处理 ==========
function handleRegister() {
  proxy.$refs.registerRef.validate(valid => {
    if (valid) {
      registerLoading.value = true
      register(registerForm.value).then(res => {
        const username = registerForm.value.username
        ElMessageBox.alert(
          "<font color='red'>恭喜你，您的账号 " + username + " 注册成功！</font>",
          "系统提示",
          {
            dangerouslyUseHTMLString: true,
            type: "success",
          }
        ).then(() => {
          // 翻回登录面，自动填入用户名
          isFlipped.value = false
          loginForm.value.username = username
          loginForm.value.password = ""
          nextTick(() => getCode())
        }).catch(() => {})
      }).catch(() => {
        registerLoading.value = false
        if (captchaEnabled.value) {
          getCode()
        }
      })
    }
  })
}

function handleLogin() {
  proxy.$refs.loginRef.validate(valid => {
    if (valid) {
      loading.value = true
      if (loginForm.value.rememberMe) {
        Cookies.set("username", loginForm.value.username, { expires: 30 })
        Cookies.set("password", encrypt(loginForm.value.password), { expires: 30 })
        Cookies.set("rememberMe", loginForm.value.rememberMe, { expires: 30 })
      } else {
        Cookies.remove("username")
        Cookies.remove("password")
        Cookies.remove("rememberMe")
      }
      userStore.login({ ...loginForm.value, loginType: isAdminMode.value ? 'admin' : 'user' }).then(() => {
        const query = route.query
        const otherQueryParams = Object.keys(query).reduce((acc, cur) => {
          if (cur !== "redirect") {
            acc[cur] = query[cur]
          }
          return acc
        }, {})
        router.push({ path: redirect.value || "/", query: otherQueryParams })
      }).catch(() => {
        loading.value = false
        if (captchaEnabled.value) {
          getCode()
        }
      })
    }
  })
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
    if (captchaEnabled.value) {
      codeUrl.value = "data:image/png;base64," + res.img
      loginForm.value.uuid = res.uuid
      registerForm.value.uuid = res.uuid
    }
  })
}

function getCookie() {
  const username = Cookies.get("username")
  const password = Cookies.get("password")
  const rememberMe = Cookies.get("rememberMe")
  loginForm.value = {
    username: username === undefined ? loginForm.value.username : username,
    password: password === undefined ? loginForm.value.password : decrypt(password),
    rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
  }
}

getCode()
getCookie()
</script>

<style lang='scss' scoped>
.login {
  display: flex;
  flex-direction: row;
  height: 100vh;
  width: 100%;
  overflow: hidden;
}

/* ========== 左侧宣传面板 ========== */
.login-left {
  width: 50%;
  background-image: url("../assets/images/login-background.png");
  background-size: cover;
  background-position: center;
  display: flex;
  align-items: stretch;
  justify-content: flex-start;
  padding: 8vh 3% 12vh;
  position: relative;
  overflow: hidden;

  // 深色遮罩让文字更清晰
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 10, 30, 0.55);
    z-index: 0;
  }
}

.left-content {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100%;
  text-align: left;
}

/* 品牌标识：图标贴左，文字居中，同行底部对齐 */
.brand-bar {
  position: relative;
  width: 100%;
  min-height: clamp(36px, 4.5vw, 52px);
  flex-shrink: 0;
}

.brand-logo {
  position: absolute;
  left: 0;
  bottom: 0;
  width: clamp(36px, 4.5vw, 52px);
  height: clamp(36px, 4.5vw, 52px);
  object-fit: contain;
  filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.3));
}

.brand-name {
  display: block;
  width: 100%;
  text-align: center;
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  font-size: clamp(1.2rem, 2.8vw, 2.4rem);
  font-weight: 700;
  letter-spacing: 2px;
  white-space: nowrap;
  background: linear-gradient(135deg, #ffffff 0%, #93c5fd 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  line-height: 1.2;
}

/* 主标题区域 */
.hero-section {
  margin-top: 10vh;
  flex-shrink: 0;
}

.hero-badge {
  display: inline-block;
  padding: clamp(2px, 0.4vh, 6px) clamp(10px, 1vw, 16px);
  background: linear-gradient(135deg, rgba(64, 158, 255, 0.2), rgba(99, 102, 241, 0.2));
  border: 1px solid rgba(147, 197, 253, 0.3);
  border-radius: 20px;
  color: rgba(147, 197, 253, 0.9);
  font-size: clamp(0.55rem, 0.8vw, 0.8rem);
  font-weight: 600;
  letter-spacing: 3px;
  margin-bottom: 2vh;
}

.hero-headline {
  p {
    font-size: clamp(1.1rem, 2.5vw, 2.5rem);
    font-weight: 800;
    line-height: 1.35;
    margin: 0;
    background: linear-gradient(135deg, #ffffff 0%, #93c5fd 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  .hero-animate {
    font-size: clamp(1.3rem, 3vw, 2.9rem);
    background: linear-gradient(
      120deg,
      #67e8f9 0%,
      #ffffff 25%,
      #818cf8 50%,
      #ffffff 75%,
      #67e8f9 100%
    );
    background-size: 400% 100%;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    animation: hero-gradient-shift 5s linear infinite;
    filter: drop-shadow(0 0 12px rgba(103, 232, 249, 0.3))
            drop-shadow(0 0 24px rgba(129, 140, 248, 0.15));
  }
}

@keyframes hero-gradient-shift {
  0% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

@keyframes border-gradient-flow {
  0% {
    background-position: 0 0, 100% 50%;
  }
  100% {
    background-position: 0 0, 0% 50%;
  }
}

/* 描述文字 */
.hero-desc {
  margin-top: auto;
  flex-shrink: 0;
  padding-left: clamp(12px, 1.5vw, 20px);
  border-left: 3px solid;
  border-image: linear-gradient(to bottom, rgba(147, 197, 253, 0.6), rgba(99, 102, 241, 0.3)) 1;
  p {
    color: rgba(186, 210, 255, 0.85);
    font-size: clamp(0.8rem, 1.3vw, 1.35rem);
    line-height: 1.8;
    margin: 0;
    text-align: left;
  }
}

/* 功能标签 */
.hero-tags {
  margin-top: auto;
  padding-bottom: 2vh;
  display: flex;
  justify-content: center;
  gap: clamp(6px, 0.8vw, 14px);
  flex-wrap: wrap;
}

.tag-capsule {
  padding: clamp(3px, 0.4vh, 6px) clamp(10px, 1vw, 16px);
  background: rgba(99, 102, 241, 0.1);
  border: 1px solid rgba(147, 197, 253, 0.3);
  border-radius: 20px;
  color: rgba(147, 197, 253, 0.85);
  font-size: clamp(0.6rem, 1vw, 0.9rem);
  font-weight: 600;
  letter-spacing: 1px;
  white-space: nowrap;
}

/* ========== 右侧登录面板 ========== */
.login-right {
  width: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background:
    radial-gradient(circle, rgba(99, 102, 241, 0.03) 1px, transparent 1px),
    linear-gradient(160deg, #f8faff 0%, #eef2ff 40%, #f0f4ff 70%, #f7f8fc 100%);
  background-size: 20px 20px, 100% 100%;
  position: relative;
  overflow: hidden;

  // 右上角蓝紫色光斑
  &::before {
    content: '';
    position: absolute;
    top: -80px;
    right: -80px;
    width: 360px;
    height: 360px;
    background: radial-gradient(circle, rgba(99, 102, 241, 0.1) 0%, rgba(99, 102, 241, 0.04) 40%, transparent 70%);
    border-radius: 50%;
    pointer-events: none;
  }

  // 左下角蓝色光斑
  &::after {
    content: '';
    position: absolute;
    bottom: -60px;
    left: -60px;
    width: 300px;
    height: 300px;
    background: radial-gradient(circle, rgba(59, 130, 246, 0.08) 0%, rgba(59, 130, 246, 0.03) 40%, transparent 70%);
    border-radius: 50%;
    pointer-events: none;
  }
}

/* 装饰物件通用样式 */
.decor {
  position: absolute;
  pointer-events: none;
  z-index: 0;
  animation: decor-float 6s ease-in-out infinite;

  svg {
    width: 100%;
    height: 100%;
  }
}

// === 千纸鹤 ===
.decor-crane1 {
  top: 6%;
  right: 6%;
  width: 90px;
  --r: 12deg;
  animation-delay: 0s;
  animation-duration: 7s;
}

.decor-crane2 {
  top: 18%;
  left: 5%;
  width: 65px;
  --r: -15deg;
  animation-delay: -2s;
  animation-duration: 8s;
}

// === 纸飞机 ===
.decor-plane1 {
  top: 40%;
  left: 4%;
  width: 80px;
  --r: 18deg;
  animation-delay: -1s;
  animation-duration: 7.5s;
}

// === 电子产品 ===
.decor-chip {
  bottom: 12%;
  left: 6%;
  width: 54px;
  color: rgba(59, 130, 246, 0.16);
  --r: -8deg;
  animation-delay: -2.5s;
  animation-duration: 7s;
}

.decor-laptop {
  bottom: 5%;
  right: 30%;
  width: 64px;
  color: rgba(59, 130, 246, 0.13);
  --r: -6deg;
  animation-delay: -1.5s;
  animation-duration: 8s;
}

@keyframes decor-float {
  0%, 100% { transform: translateY(0) rotate(var(--r, 0deg)); }
  50% { transform: translateY(-10px) rotate(var(--r, 0deg)); }
}

/* ========== 3D 翻牌容器 ========== */
.card-scene {
  width: 420px;
  perspective: 1200px;
  z-index: 1;
}

.card-flipper {
  position: relative;
  width: 100%;
  transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
  transform-style: preserve-3d;

  &.is-flipped {
    transform: rotateY(180deg);
  }
}

.card-face {
  backface-visibility: hidden;
  -webkit-backface-visibility: hidden;
}

.card-front {
  position: relative;
}

.card-back {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  transform: rotateY(180deg);
}

.login-form {
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border: 1px solid rgba(255, 255, 255, 0.7);
  width: 100%;
  padding: 36px 32px 24px 32px;
  z-index: 1;
  box-shadow:
    0 8px 32px rgba(99, 102, 241, 0.08),
    0 2px 8px rgba(0, 0, 0, 0.04),
    inset 0 1px 0 rgba(255, 255, 255, 0.6);
  transition: transform 0.3s ease, opacity 0.3s ease;

  &.admin-switching {
    opacity: 0;
    transform: scale(0.96) rotateX(8deg);
  }

  :deep(.el-input__wrapper) {
    background: #f7f8fa;
    border: 1px solid #dcdfe6;
    border-radius: 8px;
    box-shadow: none;
    transition: all 0.3s ease;

    &:hover {
      border-color: #409eff;
    }

    &.is-focus {
      border-color: #6366f1;
      box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15), 0 0 16px rgba(64, 158, 255, 0.08);
      background: #fff;
    }
  }

  :deep(.el-input__inner) {
    color: #303133;
    caret-color: #409eff;
    background: transparent !important;

    &::placeholder {
      color: #a8abb2;
    }

    &:-webkit-autofill,
    &:-webkit-autofill:hover,
    &:-webkit-autofill:focus,
    &:-webkit-autofill:active {
      -webkit-text-fill-color: #303133 !important;
      -webkit-box-shadow: 0 0 0 1000px #f7f8fa inset !important;
      transition: background-color 5000s ease-in-out 0s;
    }
  }

  .el-input {
    height: 44px;
    input {
      height: 44px;
    }
  }

  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 0px;
    color: #909399;
  }

  :deep(.el-checkbox__label) {
    color: #606266;
    font-size: 13px;
  }

  :deep(.el-checkbox__inner) {
    background: #fff;
    border-color: #dcdfe6;
  }

  :deep(.el-checkbox__input.is-checked .el-checkbox__inner) {
    background: #409eff;
    border-color: #409eff;
  }

  :deep(.el-form-item) {
    margin-bottom: 20px;
  }
}

.form-header {
  position: relative;
  text-align: center;
  margin-bottom: 28px;

  h3 {
    margin: 0;
    color: #1d2129;
    font-size: 20px;
    font-weight: 600;
    letter-spacing: 0.5px;
  }

  p {
    margin: 8px 0 0;
    color: #909399;
    font-size: 13px;
  }

  &::after {
    content: '';
    display: block;
    width: 40px;
    height: 3px;
    background: linear-gradient(90deg, #409eff, #6366f1);
    border-radius: 2px;
    margin: 16px auto 6px;
  }
}

.form-options-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.forgot-link {
  color: #409eff;
  font-size: 13px;
  cursor: pointer;
  transition: color 0.2s;

  &:hover {
    color: #66b1ff;
  }
}

.login-btn {
  position: relative;
  overflow: visible;
  z-index: 0;
  height: 44px;
  border-radius: 10px;
  border: none;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 4px;
  background: linear-gradient(
    120deg,
    #3b82f6 0%,
    #60a5fa 25%,
    #6366f1 50%,
    #60a5fa 75%,
    #3b82f6 100%
  );
  background-size: 400% 100%;
  animation: hero-gradient-shift 5s linear infinite;
  color: #fff;
  box-shadow: 0 2px 8px rgba(37, 99, 235, 0.25);
  transition: box-shadow 0.3s ease, transform 0.3s ease, filter 0.3s ease;

  &:hover {
    filter: brightness(1.12);
    box-shadow: 0 4px 16px rgba(37, 99, 235, 0.4);
    transform: translateY(-2px);
  }

  &:active {
    transform: translateY(0);
    filter: brightness(0.95);
    box-shadow: 0 2px 6px rgba(37, 99, 235, 0.2);
  }

  &::before {
    content: '';
    position: absolute;
    inset: -2px;
    border-radius: 12px;
    z-index: -1;
    background:
      repeating-linear-gradient(
        45deg,
        rgba(255, 255, 255, 0.08) 0px,
        rgba(255, 255, 255, 0.08) 1px,
        transparent 1px,
        transparent 4px
      ),
      linear-gradient(120deg, #2563eb, #60a5fa, #818cf8, #6366f1, #60a5fa, #2563eb);
    background-size: 8px 8px, 400% 100%;
    animation: border-gradient-flow 5s linear infinite;
    filter: blur(0px) brightness(1.2);
    opacity: 1;
    transition: opacity 0.3s, filter 0.3s;
  }

  &:active::before {
    opacity: 0.75;
  }
}

.form-divider {
  display: flex;
  align-items: center;
  margin: 4px 0 16px;

  &::before {
    content: '';
    flex: 1;
    height: 1px;
    background: linear-gradient(90deg, transparent, #dcdfe6 80%);
  }

  &::after {
    content: '';
    flex: 1;
    height: 1px;
    background: linear-gradient(90deg, #dcdfe6 20%, transparent);
  }

  span {
    padding: 2px 14px;
    color: #a8abb2;
    font-size: 12px;
    background: rgba(255, 255, 255, 0.6);
    border: 1px solid rgba(220, 223, 230, 0.5);
    border-radius: 10px;
    line-height: 20px;
  }
}

.form-footer-links {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-link {
  font-size: 13px;
  cursor: pointer;
  transition: color 0.2s;
}

.register-link {
  color: #909399;
  text-decoration: none;

  strong {
    color: #409eff;
  }

  &:hover {
    color: #606266;

    strong {
      color: #66b1ff;
    }
  }
}

.placeholder-link {
  cursor: default;
}

.admin-link {
  color: #909399;

  &:hover {
    color: #409eff;
  }
}

.login-code {
  width: 33%;
  height: 44px;
  float: right;
  padding-left: 8px;
  box-sizing: border-box;
  img {
    cursor: pointer;
    vertical-align: middle;
  }
}

.login-code-img {
  width: 100%;
  height: 44px;
  border-radius: 8px;
  border: 1px solid #dcdfe6;
  object-fit: cover;
  background: #f7f8fa;
  transition: all 0.3s ease;
  cursor: pointer;

  &:hover {
    border-color: #6366f1;
    box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.12);
    transform: scale(1.03);
  }

  &:active {
    transform: scale(0.97);
  }
}

.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: rgba(150, 175, 210, 0.75);
  font-family: Arial, sans-serif;
  font-size: 12px;
  letter-spacing: 1px;
  z-index: 1;
}

/* ========== 响应式 ========== */
@media (max-width: 768px) {
  .login {
    flex-direction: column;
  }

  .login-left {
    display: none;
  }

  .login-right {
    width: 100%;
    height: 100vh;
  }

  .card-scene {
    width: 90%;
    max-width: 400px;
  }
}

@media (max-width: 1200px) and (min-width: 769px) {
  .card-scene {
    width: 360px;
  }

  .login-form {
    padding: 28px 24px 20px;
  }
}
</style>

<!-- 忘记密码弹窗独立样式（非 scoped，因为 el-dialog 会 teleport 到 body） -->
<style lang="scss">
.forgot-pwd-content {
  /* ---------- 表单项间距 ---------- */
  .el-form-item {
    margin-bottom: 16px;
  }

  /* ---------- 输入框尺寸与样式 ---------- */
  .el-input--default {
    height: 36px;

    .el-input__wrapper {
      background: #f7f8fa;
      border: 1px solid #dcdfe6;
      border-radius: 6px;
      box-shadow: none;
      padding: 0 11px;
      transition: all 0.3s ease;

      &:hover {
        border-color: #409eff;
      }

      &.is-focus {
        border-color: #409eff;
        box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.12);
        background: #fff;
      }
    }

    .el-input__inner {
      height: 34px;
      line-height: 34px;
    }
  }

  /* ---------- 文本域样式 ---------- */
  .el-textarea__inner {
    background: #f7f8fa;
    border: 1px solid #dcdfe6;
    border-radius: 6px;
    padding: 8px 11px;
    transition: all 0.3s ease;

    &:hover {
      border-color: #409eff;
    }

    &:focus {
      border-color: #409eff;
      box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.12);
      background: #fff;
    }
  }

  /* ---------- 前缀图标尺寸 ---------- */
  .el-input__icon,
  .el-input__prefix-inner > .svg-icon {
    width: 14px;
    height: 14px;
    color: #909399;
  }

  /* ---------- 密保问题单选组（步骤2） ---------- */
  .el-radio-group {
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding-left: 24px;
    gap: 6px;
    margin-bottom: 16px;

    .el-radio {
      height: auto;
      margin-right: 0;
      padding: 8px 12px;
      border-radius: 6px;
      border: 1px solid #e4e7ed;
      background: #fafafa;
      transition: all 0.2s ease;
      line-height: 22px;
      justify-content: flex-start;
      text-align: left;

      &:hover {
        border-color: #c0c4cc;
        background: #f5f7fa;
      }

      &.is-checked {
        border-color: #409eff;
        background: rgba(64, 158, 255, 0.04);
      }
    }
  }

  /* ---------- 警告提示（步骤4） ---------- */
  .el-alert {
    padding: 10px 14px;
    border-radius: 6px;
  }

  /* ---------- 密码显隐切换图标 ---------- */
  .el-input__suffix-inner .el-icon {
    color: #909399;
    font-size: 14px;
  }

  /* ---------- 步骤2 分区 ---------- */
  .forgot-section {
    margin-bottom: 20px;

    &:last-of-type {
      margin-bottom: 8px;
    }
  }

  .forgot-section-title {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 12px;
    font-size: 14px;
    font-weight: 600;
    color: #303133;
  }

  .section-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: #409eff;
    color: #fff;
    font-size: 12px;
    font-weight: 700;
    flex-shrink: 0;
  }

  .answer-area {
    margin-top: 12px;
    padding-top: 12px;
    border-top: 1px dashed #e4e7ed;
  }

  .answer-label {
    font-size: 13px;
    color: #606266;
    margin-bottom: 8px;
    padding-left: 0;
  }
}

/* ---------- 忘记密码弹窗：确保 body 区域足够高，内容不遮挡按钮 ---------- */
.el-dialog:has(.forgot-pwd-content) {
  .el-dialog__body {
    min-height: 360px;
    padding-bottom: 20px;
  }
}
</style>
