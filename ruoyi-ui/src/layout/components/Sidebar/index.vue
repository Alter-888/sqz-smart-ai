<template>
  <div :class="[{ 'has-logo': showLogo }, sideTheme]" class="sidebar-container">
    <logo v-if="showLogo" :collapse="isCollapse" />
    <el-scrollbar wrap-class="scrollbar-wrapper">
      <el-menu
        :default-active="activeMenu"
        :collapse="isCollapse"
        :background-color="getMenuBackground"
        :text-color="getMenuTextColor"
        :unique-opened="true"
        :active-text-color="theme"
        :collapse-transition="false"
        mode="vertical"
        :class="sideTheme"
      >
        <sidebar-item
          v-for="(route, index) in sidebarRouters"
          :key="route.path + index"
          :item="route"
          :base-path="route.path"
        />
      </el-menu>
    </el-scrollbar>
  </div>
</template>

<script setup>
import Logo from './Logo'
import SidebarItem from './SidebarItem'
import variables from '@/assets/styles/variables.module.scss'
import useAppStore from '@/store/modules/app'
import useSettingsStore from '@/store/modules/settings'
import usePermissionStore from '@/store/modules/permission'

const route = useRoute()
const appStore = useAppStore()
const settingsStore = useSettingsStore()
const permissionStore = usePermissionStore()

const sidebarRouters = computed(() => permissionStore.sidebarRouters)
const showLogo = computed(() => settingsStore.sidebarLogo)
const sideTheme = computed(() => settingsStore.sideTheme)
const theme = computed(() => settingsStore.theme)
const isCollapse = computed(() => !appStore.sidebar.opened)

// 获取菜单背景色
const getMenuBackground = computed(() => {
  if (settingsStore.isDark) {
    return 'transparent'
  }
  return sideTheme.value === 'theme-dark' ? 'transparent' : variables.menuLightBg
})

// 获取菜单文字颜色
const getMenuTextColor = computed(() => {
  if (settingsStore.isDark) {
    return 'var(--sidebar-text)'
  }
  return sideTheme.value === 'theme-dark' ? variables.menuText : variables.menuLightText
})

const activeMenu = computed(() => {
  const { meta, path } = route
  if (meta.activeMenu) {
    return meta.activeMenu
  }
  return path
})
</script>

<style lang="scss" scoped>
.sidebar-container {
  // 深色主题 — 图片背景 + 暗色遮罩
  &.theme-dark {
    background-image: url('@/assets/images/sidebar-bg.jpg');
    background-size: cover;
    background-position: 30% center; //55月亮、35人物、85背景
    background-repeat: no-repeat;
    position: relative;

    // 45% 暗色遮罩（保证文字可读性）
    &::before {
      content: '';
      position: absolute;
      inset: 0;
      background: rgba(0, 0, 0, 0.45);
      z-index: 0;
      pointer-events: none;
    }

    // 内容层级在遮罩之上
    .sidebar-logo-container,
    .el-scrollbar {
      position: relative;
      z-index: 1;
    }
  }

  // 浅色主题白色背景
  &.theme-light {
    background-color: #ffffff;

    .el-menu {
      .el-menu-item:hover,
      .el-sub-menu__title:hover {
        background-color: #f1f5f9 !important;
      }

      .el-menu-item.is-active {
        color: #0f766e !important;
        background-color: rgba(20, 184, 166, 0.08) !important;
      }

      // 子菜单背景保持白色
      .el-sub-menu .el-menu {
        background-color: #ffffff !important;
      }
    }
  }

  .scrollbar-wrapper {
    background-color: transparent;
  }

  .el-menu {
    border: none;
    height: 100%;
    width: 100% !important;
    background-color: transparent !important;

    .el-menu-item, .el-sub-menu__title {
      &:hover {
        background-color: var(--menu-hover-bg, rgba(255, 255, 255, 0.05)) !important;
      }
    }

    .el-menu-item {
      color: v-bind(getMenuTextColor);

      &.is-active {
        color: #fff !important;
        background-color: var(--menu-active-bg, rgba(20, 184, 166, 0.15)) !important;
      }
    }

    .el-sub-menu__title {
      color: v-bind(getMenuTextColor);
    }

    // 子菜单背景透明，让渐变穿透
    .el-sub-menu .el-menu {
      background-color: transparent !important;
    }
  }
}
</style>
