import router from '@/router'
import { ElMessageBox } from 'element-plus'
import { nextTick } from 'vue'
import { login, logout, getInfo } from '@/api/login'
import { getToken, setToken, removeToken } from '@/utils/auth'
import { isHttp, isEmpty } from "@/utils/validate"
import defAva from '@/assets/images/profile.jpg'
import useCartStore from './cart'

const useUserStore = defineStore(
  'user',
  {
    state: () => ({
      token: getToken(),
      id: '',
      name: '',
      nickName: '',
      avatar: '',
      roles: [],
      permissions: []
    }),
    actions: {
      // 登录
      login(userInfo) {
        const username = userInfo.username.trim()
        const password = userInfo.password
        const code = userInfo.code
        const uuid = userInfo.uuid
        const loginType = userInfo.loginType
        return new Promise((resolve, reject) => {
          login(username, password, code, uuid, loginType).then(res => {
            setToken(res.token)
            this.token = res.token
            resolve()
          }).catch(error => {
            reject(error)
          })
        })
      },
      // 获取用户信息
      getInfo() {
        return new Promise((resolve, reject) => {
          getInfo().then(res => {
            const user = res.user
            let avatar = user.avatar || ""
            if (!isHttp(avatar)) {
              avatar = (isEmpty(avatar)) ? defAva : import.meta.env.VITE_APP_BASE_API + avatar
            }
            if (res.roles && res.roles.length > 0) { // 验证返回的roles是否是一个非空数组
              this.roles = res.roles
              this.permissions = res.permissions
            } else {
              this.roles = ['ROLE_DEFAULT']
            }
            this.id = user.userId
            this.name = user.userName
            this.nickName = user.nickName
            this.avatar = avatar
            // 登录后加载该用户自己的购物车数据
            const cartStore = useCartStore()
            cartStore.initForUser(user.userId)
            // 先resolve让路由导航完成，再弹安全提示
            resolve(res)
            // 延迟到路由渲染完成后再弹窗，避免遮罩层与路由跳转竞争
            nextTick(() => {
              setTimeout(() => {
                const profileRoute = this.roles.includes('admin') ? 'Profile' : 'CustomerProfile'
                /* 初始密码提示 */
                if (res.isDefaultModifyPwd) {
                  ElMessageBox.confirm('您的密码还是初始密码，请修改密码！', '安全提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }).then(() => {
                    router.push({ name: profileRoute, params: { activeTab: 'resetPwd' } })
                  }).catch(() => {})
                }
                /* 过期密码提示 */
                else if (res.isPasswordExpired) {
                  ElMessageBox.confirm('您的密码已过期，请尽快修改密码！', '安全提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }).then(() => {
                    router.push({ name: profileRoute, params: { activeTab: 'resetPwd' } })
                  }).catch(() => {})
                }
                /* 安全问题提示 */
                else if (!res.hasSecurityQuestion) {
                  ElMessageBox.confirm('请设置安全问题以保护您的账户安全', '安全提示', { confirmButtonText: '去设置', cancelButtonText: '稍后再说', type: 'info' }).then(() => {
                    router.push({ name: profileRoute, params: { activeTab: 'securityQuestion' } })
                  }).catch(() => {})
                }
              }, 500)
            })
          }).catch(error => {
            reject(error)
          })
        })
      },
      // 退出系统
      logOut() {
        return new Promise((resolve, reject) => {
          logout(this.token).then(() => {
            this.token = ''
            this.roles = []
            this.permissions = []
            removeToken()
            // 重置购物车内存状态（不删除localStorage，用户数据保留）
            const cartStore = useCartStore()
            cartStore.resetCart()
            resolve()
          }).catch(error => {
            reject(error)
          })
        })
      }
    }
  })

export default useUserStore
