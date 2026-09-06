import router from './router'
import { ElMessage } from 'element-plus'
import { getToken } from '@/utils/auth'
import { isHttp, isPathMatch } from '@/utils/validate'
import { isRelogin } from '@/utils/request'
import useUserStore from '@/store/modules/user'
import useSettingsStore from '@/store/modules/settings'
import usePermissionStore from '@/store/modules/permission'

const whiteList = ['/login', '/register']

const isWhiteList = (path) => {
  return whiteList.some(pattern => isPathMatch(pattern, path))
}

router.beforeEach((to, from, next) => {
  if (getToken()) {
    to.meta.title && useSettingsStore().setTitle(to.meta.title)
    /* has token*/
    if (to.path === '/login') {
      next({ path: '/' })
    } else if (isWhiteList(to.path)) {
      next()
    } else {
      if (useUserStore().roles.length === 0) {
        isRelogin.show = true
        // 判断当前用户是否已拉取完user_info信息
        useUserStore().getInfo().then(() => {
          isRelogin.show = false
          usePermissionStore().generateRoutes().then(accessRoutes => {
            // 根据roles权限生成可访问的路由表
            accessRoutes.forEach(route => {
              if (!isHttp(route.path)) {
                router.addRoute(route) // 动态添加可访问路由表
              }
            })
            // 非管理员用户访问首页时重定向到客户端
            const roles = useUserStore().roles
            if ((to.path === '/' || to.path === '/index') && !roles.includes('admin')) {
              next({ path: '/customer/home', replace: true })
            } else if (to.path.startsWith('/customer/') && roles.includes('admin')) {
              // 管理员不允许访问用户端页面
              next({ path: '/index', replace: true })
            } else {
              next({ ...to, replace: true }) // hack方法 确保addRoutes已完成
            }
          })
        }).catch(err => {
          useUserStore().logOut().then(() => {
            ElMessage.error(err)
            next({ path: '/' })
          })
        })
      } else {
        // 非管理员用户访问首页时始终重定向到客户端
        if ((to.path === '/' || to.path === '/index') && !useUserStore().roles.includes('admin')) {
          next({ path: '/customer/home', replace: true })
        } else if (to.path.startsWith('/customer/') && useUserStore().roles.includes('admin')) {
          // 管理员不允许访问用户端页面
          next({ path: '/index', replace: true })
        } else {
          next()
        }
      }
    }
  } else {
    // 没有token
    if (isWhiteList(to.path)) {
      // 在免登录白名单，直接进入
      next()
    } else {
      next(`/login?redirect=${to.fullPath}`) // 否则全部重定向到登录页
    }
  }
})
