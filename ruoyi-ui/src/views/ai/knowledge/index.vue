<template>
  <div class="app-container enhance-layout">
    <!-- 搜索栏 -->
    <el-form :inline="true" :model="queryParams" class="search-form">
      <el-form-item label="标题">
        <el-input v-model="queryParams.title" placeholder="搜索标题关键词" clearable @keyup.enter="handleSearch" />
      </el-form-item>
      <el-form-item label="分类">
        <el-select v-model="queryParams.category" placeholder="全部分类" clearable @change="handleSearch">
          <el-option v-for="item in categoryOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="来源">
        <el-select v-model="queryParams.sourceType" placeholder="全部来源" clearable @change="handleSearch">
          <el-option label="手动创建" value="MANUAL" />
          <el-option label="商品自动同步" value="PRODUCT_AUTO" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 向量库状态信息条 -->
    <el-alert v-if="vectorStatus" :closable="false" class="vector-status-bar"
      :type="vectorStatus.vectorCount > 0 ? 'success' : 'error'">
      <template #title>
        <div class="vector-status-content">
          <span v-if="vectorStatus.vectorCount > 0">
            向量库正常 | 分块数：{{ vectorStatus.vectorCount }} | 知识数：{{ vectorStatus.knowledgeCount }} | 表大小：{{ vectorStatus.tableSize }}
          </span>
          <span v-else>
            向量库暂无数据，AI 对话暂无法引用知识库内容，请点击"重建向量库"修复
          </span>
        </div>
      </template>
    </el-alert>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain @click="handleAdd" v-hasPermi="['ai:knowledge:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain @click="uploadDialogVisible = true" v-hasPermi="['ai:knowledge:upload']">上传文档</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain :loading="rebuildLoading" @click="handleRebuildVector" v-hasPermi="['ai:knowledge:edit']">
          重建向量库
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain :disabled="selectedIds.length === 0" @click="handleBatchDelete" v-hasPermi="['ai:knowledge:remove']">
          批量删除
        </el-button>
      </el-col>
    </el-row>

    <!-- 表格 -->
    <el-table v-loading="loading" :data="tableData" stripe border @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column prop="title" label="标题" min-width="200" show-overflow-tooltip />
      <el-table-column prop="category" label="分类" width="200">
        <template #default="{ row }">
          <el-tag>{{ categoryLabelMap[row.category] || row.category }}</el-tag>
          <el-tag v-if="row.sourceType === 'PRODUCT_AUTO' && row.productCategory"
                  type="success" size="small" style="margin-left: 4px">
            {{ row.productCategory }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="content" label="内容预览" min-width="250" show-overflow-tooltip>
        <template #default="{ row }">
          <span class="content-preview">{{ row.content?.substring(0, 80) }}{{ row.content?.length > 80 ? '...' : '' }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="sourceType" label="来源" width="100">
        <template #default="{ row }">
          <el-tag :type="row.sourceType === 'PRODUCT_AUTO' ? 'warning' : 'primary'" size="small">
            {{ row.sourceType === 'PRODUCT_AUTO' ? '自动' : '手动' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'info'">
            {{ row.status === 1 ? '启用' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="180">
        <template #default="{ row }">{{ formatDate(row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right">
        <template #default="{ row }">
          <template v-if="row.sourceType === 'PRODUCT_AUTO'">
            <el-button type="primary" link @click="handleView(row)">查看</el-button>
          </template>
          <template v-else>
            <el-button type="primary" link @click="handleEdit(row)" v-hasPermi="['ai:knowledge:edit']">编辑</el-button>
          </template>
          <el-button type="danger" link @click="handleDelete(row)" v-hasPermi="['ai:knowledge:remove']">删除</el-button>
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

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="分类" prop="category">
          <el-select v-model="form.category" placeholder="请选择分类" style="width: 100%">
            <el-option v-for="item in categoryOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input v-model="form.content" type="textarea" :rows="6" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" active-text="启用" inactive-text="停用" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 上传文档对话框 -->
    <el-dialog v-model="uploadDialogVisible" title="上传文档" width="500px" destroy-on-close>
      <el-upload
        ref="uploadRef"
        drag
        action=""
        :auto-upload="false"
        :limit="1"
        :on-exceed="handleExceed"
        accept=".txt,.pdf,.doc,.docx,.md"
      >
        <el-icon class="el-icon--upload"><Upload /></el-icon>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <template #tip>
          <div class="el-upload__tip">支持 txt / pdf / doc / docx / md 格式文件</div>
        </template>
      </el-upload>
      <template #footer>
        <el-button @click="uploadDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="uploadLoading" @click="handleUpload">上传</el-button>
      </template>
    </el-dialog>

    <!-- 查看自动同步条目对话框 -->
    <el-dialog v-model="viewDialogVisible" title="查看知识条目" width="600px" destroy-on-close>
      <el-form label-width="80px">
        <el-form-item label="标题">
          <el-input :model-value="viewForm.title" disabled />
        </el-form-item>
        <el-form-item label="分类">
          <el-tag>{{ categoryLabelMap[viewForm.category] || viewForm.category }}</el-tag>
        </el-form-item>
        <el-form-item label="内容">
          <el-input :model-value="viewForm.content" type="textarea" :rows="8" disabled />
        </el-form-item>
        <el-form-item label="状态">
          <el-tag :type="viewForm.status === 1 ? 'success' : 'info'">{{ viewForm.status === 1 ? '启用' : '停用' }}</el-tag>
        </el-form-item>
      </el-form>
      <el-alert type="warning" :closable="false" show-icon style="margin-top: 10px">
        <template #title>该条目由商品管理自动同步，如需修改请前往 商品管理</template>
      </el-alert>
      <template #footer>
        <el-button @click="viewDialogVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload } from '@element-plus/icons-vue'
import { listKnowledge, addKnowledge, updateKnowledge, deleteKnowledge, deleteKnowledgeBatch, uploadDocument, rebuildVectorStore, getVectorStoreStatus } from '@/api/ai/knowledge'
import { formatDate } from '@/utils/format'

const categoryOptions = [
  { label: '常见问题', value: 'FAQ' },
  { label: '政策规范', value: 'POLICY' },
  { label: '产品信息', value: 'PRODUCT_INFO' },
  { label: '使用指南', value: 'GUIDE' }
]

const categoryLabelMap = {
  FAQ: '常见问题',
  POLICY: '政策规范',
  PRODUCT_INFO: '产品信息',
  GUIDE: '使用指南'
}

const selectedIds = ref([])
const loading = ref(false)
const submitLoading = ref(false)
const uploadLoading = ref(false)
const rebuildLoading = ref(false)
const vectorStatus = ref(null)
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const uploadDialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const uploadRef = ref(null)
const editingId = ref(null)
const viewDialogVisible = ref(false)
const viewForm = reactive({ title: '', content: '', category: '', status: 1 })

const queryParams = reactive({
  title: '',
  category: '',
  sourceType: '',
  pageNum: 1,
  pageSize: 10
})

const form = reactive({
  title: '',
  content: '',
  category: '',
  status: 1
})

const rules = {
  title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
  category: [{ required: true, message: '请选择分类', trigger: 'change' }],
  content: [{ required: true, message: '请输入内容', trigger: 'blur' }]
}

const resetForm = () => {
  form.title = ''
  form.content = ''
  form.category = ''
  form.status = 1
  editingId.value = null
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await listKnowledge(queryParams)
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
  queryParams.title = ''
  queryParams.category = ''
  queryParams.sourceType = ''
  queryParams.pageNum = 1
  queryParams.pageSize = 10
  loadData()
}

const handleAdd = () => {
  resetForm()
  dialogTitle.value = '新增知识'
  dialogVisible.value = true
}

const handleEdit = (row) => {
  resetForm()
  dialogTitle.value = '编辑知识'
  editingId.value = row.knowledgeId
  form.title = row.title
  form.content = row.content
  form.category = row.category
  form.status = row.status
  dialogVisible.value = true
}

const handleView = (row) => {
  viewForm.title = row.title
  viewForm.content = row.content
  viewForm.category = row.category
  viewForm.status = row.status
  viewDialogVisible.value = true
}

const handleSubmit = async () => {
  if (!formRef.value) return
  await formRef.value.validate()
  submitLoading.value = true
  try {
    if (editingId.value) {
      await updateKnowledge(editingId.value, { ...form })
      ElMessage.success('更新成功')
    } else {
      await addKnowledge({ ...form })
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    loadData()
  } finally {
    submitLoading.value = false
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除该知识条目？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    await deleteKnowledge(row.knowledgeId)
    ElMessage.success('删除成功')
    loadData()
  }).catch(() => {})
}

const handleSelectionChange = (selection) => {
  selectedIds.value = selection.map(item => item.knowledgeId)
}

const handleBatchDelete = () => {
  if (selectedIds.value.length === 0) return
  ElMessageBox.confirm(
    `确认删除选中的 ${selectedIds.value.length} 条知识条目？`,
    '批量删除',
    { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
  ).then(async () => {
    await deleteKnowledgeBatch(selectedIds.value)
    ElMessage.success('批量删除成功')
    selectedIds.value = []
    loadData()
  }).catch(() => {})
}

const handleExceed = () => {
  ElMessage.warning('最多只能上传1个文件')
}

const handleUpload = async () => {
  if (!uploadRef.value) return
  const files = uploadRef.value.uploadFiles
  if (!files || files.length === 0) {
    ElMessage.warning('请先选择文件')
    return
  }
  uploadLoading.value = true
  try {
    const formData = new FormData()
    formData.append('file', files[0].raw)
    await uploadDocument(formData)
    ElMessage.success('文档已上传，正在后台处理中...')
    uploadDialogVisible.value = false
    loadData()
  } finally {
    uploadLoading.value = false
  }
}

onMounted(() => {
  loadData()
  loadVectorStatus()
})

const loadVectorStatus = async () => {
  try {
    const res = await getVectorStoreStatus()
    vectorStatus.value = res.data || res.msg
  } catch (e) {
    // 静默失败
  }
}

const handleRebuildVector = () => {
  ElMessageBox.confirm(
    '重建向量库将重新处理所有启用的知识条目，确认执行？',
    '重建向量库',
    { confirmButtonText: '确认重建', cancelButtonText: '取消', type: 'warning' }
  ).then(async () => {
    rebuildLoading.value = true
    try {
      const res = await rebuildVectorStore()
      ElMessage.success(res.msg || '向量库重建完成')
      loadVectorStatus()
    } catch (e) {
      ElMessage.error('重建失败，请稍后重试')
    } finally {
      rebuildLoading.value = false
    }
  }).catch(() => {})
}
</script>

<style scoped>
.search-form {
  margin-bottom: 10px;
}

.vector-status-bar {
  margin-bottom: 14px;
}

.vector-status-content {
  font-size: 13px;
}

.content-preview {
  color: #606266;
  font-size: 13px;
  line-height: 1.4;
}
</style>
