<template>
  <div class="customer-profile">
    <!-- 顶部用户信息卡片 -->
    <div class="profile-header profile-header-enter">
      <div class="profile-header-bg">
        <img :src="profileBg" alt="profile background" />
        <div class="profile-header-overlay"></div>
      </div>
      <div class="profile-header-content">
        <div class="profile-avatar-area">
          <userAvatar />
        </div>
        <div class="profile-info">
          <h3 class="profile-name">{{ user.userName }}</h3>
          <div class="profile-details">
            <span v-if="user.phonenumber">
              <el-icon><Phone /></el-icon> {{ user.phonenumber }}
            </span>
            <span v-if="user.email">
              <el-icon><Message /></el-icon> {{ user.email }}
            </span>
            <span v-if="roleGroup">
              <el-icon><User /></el-icon> {{ roleGroup }}
            </span>
            <span v-if="user.createTime">
              <el-icon><Calendar /></el-icon> {{ user.createTime }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- 下方编辑区 -->
    <div class="profile-edit-card profile-edit-enter">
      <el-tabs v-model="activeTab">
        <el-tab-pane name="userinfo">
          <template #label><el-icon><User /></el-icon> 基本资料</template>
          <userInfo :user="user" @profileUpdated="loadProfile" />
        </el-tab-pane>
        <el-tab-pane name="resetPwd">
          <template #label><el-icon><Lock /></el-icon> 修改密码</template>
          <resetPwd />
        </el-tab-pane>
        <el-tab-pane name="securityQuestion">
          <template #label><el-icon><QuestionFilled /></el-icon> 安全问题</template>
          <securityQuestion />
        </el-tab-pane>
        <el-tab-pane name="address">
          <template #label><el-icon><Location /></el-icon> 地址管理</template>
          <addressManage />
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import userAvatar from '@/views/system/user/profile/userAvatar.vue'
import userInfo from '@/views/system/user/profile/userInfo.vue'
import resetPwd from '@/views/system/user/profile/resetPwd.vue'
import securityQuestion from '@/views/system/user/profile/securityQuestion.vue'
import addressManage from './addressManage.vue'
import { getUserProfile } from '@/api/system/user'
import { Phone, Message, User, Calendar, Lock, Location, QuestionFilled } from '@element-plus/icons-vue'
import profileBg from '@/assets/images/profile-bg.jpg'

const route = useRoute()
const router = useRouter()
const activeTab = ref('userinfo')
const user = ref({})
const roleGroup = ref('')
const postGroup = ref('')

function loadProfile() {
  getUserProfile().then(response => {
    user.value = response.data
    roleGroup.value = response.roleGroup
    postGroup.value = response.postGroup
  })
}

onMounted(() => {
  const tab = route.params?.activeTab
  if (tab) activeTab.value = tab
  loadProfile()
})

watch(activeTab, (tab) => {
  router.replace({
    name: 'CustomerProfile',
    params: { activeTab: tab }
  })
})
</script>

<style lang="scss" scoped>
.customer-profile {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px 24px 40px;
}

/* ===== 入场动效 ===== */
.profile-header-enter {
  animation: slideDownFadeIn 0.5s ease both;
}
.profile-edit-enter {
  animation: slideUpFadeIn 0.5s ease 0.15s both;
}
@keyframes slideDownFadeIn {
  from { opacity: 0; transform: translateY(-24px); }
  to   { opacity: 1; transform: translateY(0); }
}
@keyframes slideUpFadeIn {
  from { opacity: 0; transform: translateY(24px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* ===== 顶部用户信息卡片 ===== */
.profile-header {
  position: relative;
  background: #fff;
  border-radius: 14px;
  border: 1px solid #ebeef5;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  overflow: hidden;
  margin-bottom: 20px;
}

/* 图片背景 + 遮罩 */
.profile-header-bg {
  position: relative;
  height: 160px;
  overflow: hidden;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center 30%;
    display: block;
  }
}

.profile-header-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0.05) 0%, rgba(0, 0, 0, 0.3) 100%);
}

.profile-header-content {
  display: flex;
  align-items: flex-end;
  padding: 0 32px 24px;
  margin-top: -44px;
  position: relative;
  gap: 24px;
}

.profile-avatar-area {
  flex-shrink: 0;

  :deep(.el-avatar),
  :deep(.user-avatar) {
    width: 88px !important;
    height: 88px !important;
    border: 3px solid #fff;
    border-radius: 50%;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  }

  :deep(.el-upload) {
    width: 88px;
    height: 88px;
    border-radius: 50%;
    overflow: hidden;
  }
}

.profile-info {
  flex: 1;
  padding-bottom: 4px;
}

.profile-name {
  margin: 0 0 8px;
  font-size: 20px;
  font-weight: 600;
  color: #303133;
}

/* 信息标签 pill 化 */
.profile-details {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;

  span {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    font-size: 13px;
    color: #606266;
    background: #f4f4f5;
    padding: 4px 12px;
    border-radius: 20px;
    transition: all 0.25s ease;

    .el-icon {
      font-size: 14px;
    }

    &:hover {
      background: #ecf5ff;
      color: #409eff;
      transform: translateY(-1px);
    }
  }
}

/* ===== 编辑区卡片 ===== */
.profile-edit-card {
  background: #fff;
  border-radius: 14px;
  border: 1px solid #ebeef5;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  padding: 24px 32px;

  :deep(.el-tabs__header) {
    margin-bottom: 24px;
  }

  /* Tab 分隔线 */
  :deep(.el-tabs__nav-wrap::after) {
    background-color: #f0ebe4;
    height: 1px;
  }

  /* Tab 下划线渐变 - 木色主题 */
  :deep(.el-tabs__active-bar) {
    background: linear-gradient(90deg, #409eff, #337ecc);
    height: 3px;
    border-radius: 2px;
  }

  /* Tab 项样式 */
  :deep(.el-tabs__item) {
    font-size: 15px;
    padding: 0 24px;
    height: 48px;
    line-height: 48px;
    border-radius: 8px 8px 0 0;
    transition: all 0.3s ease;
    color: #909399;

    .el-icon {
      margin-right: 6px;
      font-size: 16px;
    }

    &:hover {
      background: #faf8f5;
      color: #409eff;
    }

    &.is-active {
      font-weight: 600;
      color: #409eff;
      background: linear-gradient(to bottom, #faf8f5, #fff);
    }
  }

  :deep(.el-form) {
    max-width: 460px;
    margin: 0;
  }
}

/* ===== 响应式 ===== */
@media (max-width: 768px) {
  .customer-profile {
    padding: 12px 16px 24px;
  }

  .profile-header-content {
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: 0 16px 20px;
  }

  .profile-details {
    justify-content: center;
  }

  .profile-edit-card {
    padding: 16px 20px;
  }
}
</style>
