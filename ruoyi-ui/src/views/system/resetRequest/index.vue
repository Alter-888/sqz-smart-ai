<template>
  <div class="app-container">
    <!-- 搜索栏 -->
    <el-form :inline="true" :model="queryParams" class="search-form">
      <el-form-item label="用户账号">
        <el-input v-model="queryParams.userName" placeholder="请输入用户账号" clearable @keyup.enter="handleSearch" />
      </el-form-item>
      <el-form-item label="状态">
        <el-select v-model="queryParams.status" placeholder="全部状态" clearable @change="handleSearch">
          <el-option label="待处理" value="0" />
          <el-option label="已通过" value="1" />
          <el-option label="已拒绝" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 表格 -->
    <el-table v-loading="loading" :data="tableData" stripe border>
      <el-table-column prop="requestId" label="申请ID" width="80" />
      <el-table-column prop="userName" label="用户账号" width="120" />
      <el-table-column prop="reason" label="申请原因" min-width="200" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="statusTagType(row.status)">{{ statusLabel(row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="申请时间" width="180" />
      <el-table-column prop="handleBy" label="处理人" width="100" />
      <el-table-column prop="handleTime" label="处理时间" width="180" />
      <el-table-column prop="handleRemark" label="处理备注" min-width="150" show-overflow-tooltip />
      <el-table-column label="操作" width="160" fixed="right">
        <template #default="{ row }">
          <template v-if="row.status === '0'">
            <el-button type="primary" link @click="handleApprove(row)" v-hasPermi="['system:resetRequest:handle']">通过</el-button>
            <el-button type="danger" link @click="handleReject(row)" v-hasPermi="['system:resetRequest:handle']">拒绝</el-button>
          </template>
          <span v-else style="color:#909399;font-size:13px;">已处理</span>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="loadData"
    />

    <!-- 通过弹窗 -->
    <el-dialog v-model="approveDialogVisible" title="通过申请 - 确认重置密码" width="460px" destroy-on-close>
      <el-form label-width="100px">
        <el-form-item label="用户账号">
          <el-input :model-value="currentRow.userName" disabled />
        </el-form-item>
        <el-alert title="通过后将使用用户申请时提交的密码进行重置" type="info" :closable="false" show-icon style="margin-bottom:16px;" />
        <el-form-item label="处理备注">
          <el-input v-model="approveForm.handleRemark" type="textarea" :rows="2" placeholder="选填" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="approveDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="submitApprove">确认通过</el-button>
      </template>
    </el-dialog>

    <!-- 拒绝弹窗 -->
    <el-dialog v-model="rejectDialogVisible" title="拒绝申请" width="460px" destroy-on-close>
      <el-form label-width="100px">
        <el-form-item label="用户账号">
          <el-input :model-value="currentRow.userName" disabled />
        </el-form-item>
        <el-form-item label="拒绝原因">
          <el-input v-model="rejectForm.handleRemark" type="textarea" :rows="3" placeholder="请输入拒绝原因（选填）" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="rejectDialogVisible = false">取消</el-button>
        <el-button type="danger" :loading="submitLoading" @click="submitReject">确认拒绝</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { listResetRequest, approveResetRequest, rejectResetRequest } from '@/api/system/resetRequest'

const loading = ref(false)
const submitLoading = ref(false)
const tableData = ref([])
const total = ref(0)
const approveDialogVisible = ref(false)
const rejectDialogVisible = ref(false)
const currentRow = ref({})
const approveForm = reactive({ handleRemark: '' })
const rejectForm = reactive({ handleRemark: '' })

const queryParams = reactive({
  userName: '',
  status: '',
  pageNum: 1,
  pageSize: 10
})

const statusLabel = (status) => {
  const map = { '0': '待处理', '1': '已通过', '2': '已拒绝' }
  return map[status] || status
}

const statusTagType = (status) => {
  const map = { '0': 'warning', '1': 'success', '2': 'danger' }
  return map[status] || 'info'
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await listResetRequest(queryParams)
    tableData.value = res.rows || []
    total.value = res.total || 0
  } catch (e) {
    ElMessage.error('加载数据失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  queryParams.pageNum = 1
  loadData()
}

const resetQuery = () => {
  queryParams.userName = ''
  queryParams.status = ''
  queryParams.pageNum = 1
  loadData()
}

const handleApprove = (row) => {
  currentRow.value = row
  approveForm.handleRemark = ''
  approveDialogVisible.value = true
}

const handleReject = (row) => {
  currentRow.value = row
  rejectForm.handleRemark = ''
  rejectDialogVisible.value = true
}

const submitApprove = async () => {
  submitLoading.value = true
  try {
    await approveResetRequest(currentRow.value.requestId, {
      handleRemark: approveForm.handleRemark
    })
    ElMessage.success('申请已通过，用户密码已重置')
    approveDialogVisible.value = false
    loadData()
  } finally {
    submitLoading.value = false
  }
}

const submitReject = async () => {
  submitLoading.value = true
  try {
    await rejectResetRequest(currentRow.value.requestId, {
      handleRemark: rejectForm.handleRemark
    })
    ElMessage.success('申请已拒绝')
    rejectDialogVisible.value = false
    loadData()
  } finally {
    submitLoading.value = false
  }
}

onMounted(() => {
  loadData()
})
</script>
