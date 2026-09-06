<template>
  <div class="address-manage">
    <!-- 头部 -->
    <div class="address-header">
      <span class="address-title">我的收货地址 ({{ addressList.length }})</span>
      <el-button class="add-btn" :icon="Plus" @click="openDialog()">新增地址</el-button>
    </div>

    <!-- 地址列表 -->
    <transition-group name="address-list" tag="div" class="address-list" v-loading="loading">
      <div
        v-for="item in addressList"
        :key="item.addressId"
        class="address-item"
        :class="{ 'is-default': item.isDefault === 1 }"
      >
        <!-- 卡片头部：默认标签 -->
        <div class="card-header">
          <span v-if="item.isDefault === 1" class="default-badge">默认</span>
        </div>

        <!-- 卡片主体：信息详情 -->
        <div class="card-body">
          <div class="info-row info-row-split">
            <div class="info-cell">
              <span class="label">收货人：</span>
              <span class="value">{{ item.contactName }}</span>
            </div>
            <div class="info-cell">
              <span class="label">电话号码：</span>
              <span class="value">{{ item.phone }}</span>
            </div>
          </div>
          <div class="info-row">
            <span class="label">地址：</span>
            <span class="value">{{ item.province }} {{ item.city }} {{ item.district }} {{ item.detail }}</span>
          </div>
        </div>

        <!-- 卡片底部：操作按钮 -->
        <div class="card-footer">
          <el-button
            v-if="item.isDefault !== 1"
            class="btn-wood"
            text
            size="small"
            :loading="settingDefaultId === item.addressId"
            :disabled="settingDefaultId !== null"
            @click="handleSetDefault(item.addressId)"
          ><el-icon><Star /></el-icon> 设为默认</el-button>
          <el-button class="btn-wood" text size="small" :icon="Edit" @click="openDialog(item)">编辑</el-button>
          <el-button class="btn-wood-danger" text size="small" :icon="Delete" @click="handleDelete(item)">删除</el-button>
        </div>
      </div>
    </transition-group>

    <!-- 空状态 -->
    <transition name="fade">
      <div v-if="addressList.length === 0 && !loading" class="address-empty">
        <el-icon :size="48" color="#c0c4cc"><Location /></el-icon>
        <p>暂无收货地址，快去添加吧</p>
        <el-button type="primary" :icon="Plus" @click="openDialog()">新增地址</el-button>
      </div>
    </transition>

    <!-- 新增/编辑弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑地址' : '新增地址'"
      width="520px"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="收货人" prop="contactName">
          <el-input v-model="form.contactName" placeholder="请输入收货人姓名" maxlength="20" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入手机号" maxlength="11" />
        </el-form-item>
        <el-form-item label="所在地区" prop="selectedRegion">
          <el-cascader
            v-model="form.selectedRegion"
            :options="regionData"
            :props="{ value: 'label' }"
            placeholder="请选择省/市/区"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="详细地址" prop="detail">
          <el-input
            v-model="form.detail"
            type="textarea"
            :rows="2"
            placeholder="请输入详细地址"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="默认地址">
          <el-switch v-model="form.isDefault" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="handleSubmit">保 存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { regionData } from 'element-china-area-data'
import { Location, Plus, Edit, Delete, Star } from '@element-plus/icons-vue'
import {
  listMyAddresses,
  addAddress,
  updateAddress,
  deleteAddress,
  setDefaultAddress
} from '@/api/business/address'

const { proxy } = getCurrentInstance()

const loading = ref(false)
const addressList = ref([])
const dialogVisible = ref(false)
const isEdit = ref(false)
const editId = ref(null)
const submitLoading = ref(false)
const formRef = ref(null)
const settingDefaultId = ref(null)

const defaultForm = {
  contactName: '',
  phone: '',
  selectedRegion: [],
  detail: '',
  isDefault: 0
}
const form = ref({ ...defaultForm })

const phoneReg = /^1[3-9]\d{9}$/
const rules = {
  contactName: [{ required: true, message: '请输入收货人姓名', trigger: 'blur' }],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: phoneReg, message: '手机号格式不正确', trigger: 'blur' }
  ],
  selectedRegion: [{ required: true, message: '请选择所在地区', trigger: 'change' }],
  detail: [{ required: true, message: '请输入详细地址', trigger: 'blur' }]
}

/** 加载地址列表 */
function loadList() {
  loading.value = true
  listMyAddresses().then(res => {
    const list = res.data || []
    // 默认地址排前面
    list.sort((a, b) => (b.isDefault === 1 ? 1 : 0) - (a.isDefault === 1 ? 1 : 0))
    addressList.value = list
  }).finally(() => {
    loading.value = false
  })
}

/** 打开弹窗 */
function openDialog(item) {
  if (item) {
    isEdit.value = true
    editId.value = item.addressId
    form.value = {
      contactName: item.contactName,
      phone: item.phone,
      selectedRegion: [item.province, item.city, item.district],
      detail: item.detail,
      isDefault: item.isDefault || 0
    }
  } else {
    isEdit.value = false
    editId.value = null
    form.value = { ...defaultForm, selectedRegion: [] }
  }
  dialogVisible.value = true
}

/** 提交表单 */
function handleSubmit() {
  formRef.value.validate(valid => {
    if (!valid) return
    submitLoading.value = true
    const data = {
      contactName: form.value.contactName,
      phone: form.value.phone,
      province: form.value.selectedRegion[0],
      city: form.value.selectedRegion[1],
      district: form.value.selectedRegion[2],
      detail: form.value.detail,
      isDefault: form.value.isDefault
    }
    const request = isEdit.value
      ? updateAddress(editId.value, data)
      : addAddress(data)
    request.then(() => {
      proxy.$modal.msgSuccess(isEdit.value ? '修改成功' : '新增成功')
      dialogVisible.value = false
      loadList()
    }).finally(() => {
      submitLoading.value = false
    })
  })
}

/** 删除地址 */
function handleDelete(item) {
  const msg = item.isDefault === 1
    ? '该地址为默认收货地址，删除后需要重新设置默认地址，确认删除吗？'
    : '确认删除该收货地址吗？'
  proxy.$modal.confirm(msg).then(() => {
    deleteAddress(item.addressId).then(() => {
      proxy.$modal.msgSuccess('删除成功')
      loadList()
    })
  }).catch(() => {})
}

/** 设为默认 */
function handleSetDefault(id) {
  settingDefaultId.value = id
  setDefaultAddress(id).then(() => {
    proxy.$modal.msgSuccess('设置成功')
    loadList()
  }).finally(() => {
    settingDefaultId.value = null
  })
}

onMounted(() => {
  loadList()
})
</script>

<style lang="scss" scoped>
.address-manage {
  padding: 4px 0;
}

.address-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.address-title {
  font-size: 16px;
  font-weight: 700;
  color: #303133;
}

/* 新增按钮 - 棕褐渐变 */
.add-btn {
  background: linear-gradient(135deg, #409eff, #337ecc) !important;
  border: none !important;
  color: #fff !important;
  border-radius: 20px !important;
  padding: 8px 20px !important;
  font-weight: 500;
  transition: all 0.3s ease;

  &:hover {
    box-shadow: 0 4px 15px rgba(64, 158, 255, 0.4);
    transform: translateY(-1px);
  }

  &:active {
    transform: translateY(0);
  }
}

/* ===== 列表网格 ===== */
.address-list {
  position: relative;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

/* ===== 卡片整体 - 木板风格 ===== */
.address-item {
  display: flex;
  flex-direction: column;
  padding: 0;
  border-radius: 12px;
  border: 1px solid #e6ddd0;
  background: linear-gradient(145deg, #faf6f0 0%, #f5efe6 100%);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;

  &.is-default {
    border-color: #d4c4ad;
    background: linear-gradient(145deg, #f5ece0 0%, #efe4d4 100%);
  }

  &:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 30px rgba(139, 111, 71, 0.15);
    border-color: #d4c4ad;
  }
}

/* ===== 卡片头部 ===== */
.card-header {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding: 10px 16px 0;
  min-height: 20px;
}

.default-badge {
  font-size: 11px;
  padding: 2px 10px;
  border-radius: 10px;
  background: linear-gradient(135deg, #409eff, #337ecc);
  color: #fff;
  font-weight: 500;
  letter-spacing: 1px;
}

/* ===== 卡片主体 ===== */
.card-body {
  padding: 6px 16px 12px;
}

.info-row {
  display: flex;
  align-items: baseline;
  font-size: 13px;
  line-height: 1.6;
  padding: 8px 0;
  border-bottom: 1px dashed #e0d5c8;

  &:last-child {
    border-bottom: none;
    padding-bottom: 0;
  }

  .label {
    font-weight: 600;
    color: #606266;
    flex-shrink: 0;
  }

  .value {
    color: #303133;
    word-break: break-all;
  }
}

.info-row-split {
  display: flex;

  .info-cell {
    flex: 1;
    display: flex;
    align-items: baseline;

    & + .info-cell {
      border-left: 1px dashed #e0d5c8;
      padding-left: 16px;
      margin-left: 16px;
    }
  }
}

/* ===== 卡片底部 ===== */
.card-footer {
  border-top: 1px solid #e0d5c8;
  padding: 8px 16px;
  display: flex;
  justify-content: flex-end;
  gap: 6px;
  background: rgba(240, 232, 220, 0.4);
}

/* 棕色按钮 */
.btn-wood {
  color: #409eff !important;
  font-size: 12px !important;
  padding: 4px 12px !important;
  border-radius: 6px !important;

  &:hover {
    color: #337ecc !important;
    background: rgba(64, 158, 255, 0.1) !important;
  }

  .el-icon {
    margin-right: 2px;
  }
}

.btn-wood-danger {
  color: #f56c6c !important;
  font-size: 12px !important;
  padding: 4px 12px !important;
  border-radius: 6px !important;

  &:hover {
    color: #f56c6c !important;
    background: rgba(245, 108, 108, 0.1) !important;
  }

  .el-icon {
    margin-right: 2px;
  }
}

/* ===== 列表动效 ===== */
.address-list-enter-active {
  animation: slideDownIn 0.35s ease-out;
}
.address-list-leave-active {
  animation: slideRightOut 0.25s ease-in;
  position: absolute;
  width: 100%;
}
.address-list-move {
  transition: transform 0.3s ease;
}
@keyframes slideDownIn {
  from { opacity: 0; transform: translateY(-16px); }
  to   { opacity: 1; transform: translateY(0); }
}
@keyframes slideRightOut {
  from { opacity: 1; transform: translateX(0); }
  to   { opacity: 0; transform: translateX(60px); }
}

/* ===== 空状态 ===== */
.address-empty {
  text-align: center;
  padding: 60px 0;

  .el-icon {
    color: #909399 !important;
    opacity: 0.5;
  }

  p {
    margin: 16px 0 20px;
    color: #909399;
    font-size: 14px;
  }
}

.fade-enter-active {
  animation: fadeIn 0.3s ease;
}
@keyframes fadeIn {
  from { opacity: 0; }
  to   { opacity: 1; }
}

/* ===== 响应式 ===== */
@media (max-width: 768px) {
  .address-list {
    grid-template-columns: 1fr;
  }

  .card-header {
    padding: 14px 16px 10px;
  }

  .card-body {
    padding: 0 16px 14px;
  }

  .card-footer {
    padding: 8px 16px;
  }
}
</style>
