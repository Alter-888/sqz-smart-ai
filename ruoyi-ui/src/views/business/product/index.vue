<template>
  <div class="app-container enhance-layout">
    <el-form :inline="true" :model="queryParams" class="demo-form-inline">
      <el-form-item label="商品名称">
        <el-input v-model="queryParams.name" placeholder="请输入商品名称" clearable @keyup.enter="handleSearch" />
      </el-form-item>
      <el-form-item label="分类">
        <el-select v-model="queryParams.category" placeholder="全部分类" clearable @change="handleSearch">
          <el-option v-for="c in categories" :key="c" :label="c" :value="c" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态">
        <el-select v-model="queryParams.status" placeholder="全部状态" clearable @change="handleSearch">
          <el-option label="上架" :value="1" />
          <el-option label="下架" :value="0" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain v-hasPermi="['business:product:add']" @click="handleAdd">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain v-hasPermi="['business:product:list']" @click="handleLowStock">库存预警</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain v-hasPermi="['business:product:edit']" :disabled="selectedIds.length === 0" @click="handleBatchStatus(1)">批量上架</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="info" plain v-hasPermi="['business:product:edit']" :disabled="selectedIds.length === 0" @click="handleBatchStatus(0)">批量下架</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="info" plain v-hasPermi="['business:product:add']" @click="handleImport">导入</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain v-hasPermi="['business:product:list']" @click="handleExport">导出</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="tableData" stripe border @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" />
      <el-table-column prop="name" label="商品名称" min-width="180" show-overflow-tooltip />
      <el-table-column label="图片" width="80" align="center">
        <template #default="{ row }">
          <el-image v-if="row.imageUrl" :src="row.imageUrl" style="width: 40px; height: 40px" fit="cover" :preview-src-list="[row.imageUrl]" preview-teleported />
        </template>
      </el-table-column>
      <el-table-column prop="category" label="分类" width="120" />
      <el-table-column prop="price" label="价格" width="120" align="right">
        <template #default="{ row }">{{ Number(row.price).toFixed(2) }}</template>
      </el-table-column>
      <el-table-column prop="stock" label="库存" width="100" align="center">
        <template #default="{ row }">
          <span :style="{ color: row.stock <= 10 ? '#F56C6C' : '' }">{{ row.stock }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'info'">{{ row.status === 1 ? '上架' : '下架' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="240" fixed="right">
        <template #default="{ row }">
          <el-button type="success" link v-hasPermi="['business:product:list']" @click="handleDetail(row)">详情</el-button>
          <el-button type="primary" link v-hasPermi="['business:product:edit']" @click="handleEdit(row)">编辑</el-button>
          <el-button type="danger" link v-hasPermi="['business:product:remove']" @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      v-model:current-page="queryParams.pageNum"
      v-model:page-size="queryParams.pageSize"
      :page-sizes="[10, 20, 50]"
      :total="total"
      layout="total, sizes, prev, pager, next, jumper"
      class="mt10"
      @size-change="loadData"
      @current-change="loadData"
    />

    <!-- Add/Edit dialog -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="650px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="商品名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入商品名称" />
        </el-form-item>
        <el-form-item label="商品分类" prop="category">
          <el-input v-model="form.category" placeholder="请输入商品分类" />
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input-number v-model="form.price" :precision="2" :min="0" :step="1" style="width: 200px" />
        </el-form-item>
        <el-form-item label="库存" prop="stock">
          <el-input-number v-model="form.stock" :min="0" :step="1" style="width: 200px" />
        </el-form-item>
        <el-form-item label="商品规格">
          <el-input v-model="form.description" type="textarea" :rows="4" placeholder="请输入商品规格信息" />
        </el-form-item>
        <el-form-item label="商品图片">
          <image-upload v-model="form.imageUrl" :limit="1" />
        </el-form-item>
        <el-form-item label="商品介绍">
          <el-input v-model="form.highlights" type="textarea" :rows="3" placeholder="请输入商品介绍" />
        </el-form-item>
        <el-divider content-position="left">售后信息</el-divider>
        <el-form-item label="退换货政策">
          <el-input v-model="form.refundPolicy" type="textarea" :rows="3" placeholder="请输入退换货政策，如：未拆封7天可退，已激活不可退" />
        </el-form-item>
        <el-form-item label="保修信息">
          <el-input v-model="form.warrantyInfo" placeholder="请输入保修信息，如：全国联保一年" />
        </el-form-item>
        <el-form-item label="售后注意">
          <el-input v-model="form.afterSaleNote" type="textarea" :rows="3" placeholder="请输入售后注意事项" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" active-text="上架" inactive-text="下架" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 商品详情对话框 -->
    <el-dialog v-model="detailVisible" title="商品详情" width="750px" destroy-on-close>
      <div class="detail-hero">
        <div class="detail-hero-image">
          <el-image v-if="detailProduct.imageUrl" :src="detailProduct.imageUrl"
                    fit="contain" :preview-src-list="[detailProduct.imageUrl]"
                    preview-teleported style="width: 100%; max-height: 300px" />
          <div v-else class="no-image-placeholder">暂无图片</div>
        </div>
        <div class="detail-hero-info">
          <h2 class="detail-name">{{ detailProduct.name }}</h2>
          <div class="detail-price-bar">
            <span class="price-symbol">&yen;</span>
            <span class="price-value">{{ Number(detailProduct.price || 0).toFixed(2) }}</span>
          </div>
          <el-descriptions :column="1" border size="small">
            <el-descriptions-item label="商品分类">{{ detailProduct.category || '-' }}</el-descriptions-item>
            <el-descriptions-item label="库存">
              <span :style="{ color: detailProduct.stock <= 10 ? '#F56C6C' : '', fontWeight: 'bold' }">
                {{ detailProduct.stock }}
              </span>
            </el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-tag :type="detailProduct.status === 1 ? 'success' : 'info'">
                {{ detailProduct.status === 1 ? '上架' : '下架' }}
              </el-tag>
            </el-descriptions-item>
          </el-descriptions>
        </div>
      </div>

      <el-divider content-position="left">商品信息</el-divider>

      <div v-if="detailProduct.description" class="detail-section">
        <div class="detail-section-title">商品规格</div>
        <div class="detail-section-text">{{ detailProduct.description }}</div>
      </div>
      <div v-if="detailProduct.highlights" class="detail-section">
        <div class="detail-section-title">商品介绍</div>
        <div class="detail-section-text">{{ detailProduct.highlights }}</div>
      </div>
      <div v-if="!detailProduct.description && !detailProduct.highlights" class="detail-empty">暂无商品信息</div>

      <el-divider content-position="left">售后信息</el-divider>

      <div class="detail-service-cards">
        <div v-if="detailProduct.refundPolicy" class="detail-service-card">
          <div class="service-card-label">退换货政策</div>
          <div class="service-card-content">{{ detailProduct.refundPolicy }}</div>
        </div>
        <div v-if="detailProduct.warrantyInfo" class="detail-service-card">
          <div class="service-card-label">保修信息</div>
          <div class="service-card-content">{{ detailProduct.warrantyInfo }}</div>
        </div>
        <div v-if="detailProduct.afterSaleNote" class="detail-service-card">
          <div class="service-card-label">售后注意</div>
          <div class="service-card-content">{{ detailProduct.afterSaleNote }}</div>
        </div>
        <div v-if="!detailProduct.refundPolicy && !detailProduct.warrantyInfo && !detailProduct.afterSaleNote"
             class="detail-empty">暂无售后信息</div>
      </div>

      <template #footer>
        <el-button @click="detailVisible = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- Low stock dialog -->
    <el-dialog v-model="lowStockVisible" title="库存预警" width="700px" destroy-on-close>
      <el-form :inline="true" style="margin-bottom: 12px">
        <el-form-item label="预警阈值">
          <el-input-number v-model="lowStockThreshold" :min="1" :max="999" @change="loadLowStock" />
        </el-form-item>
      </el-form>
      <el-table :data="lowStockData" stripe border v-loading="lowStockLoading">
        <el-table-column prop="name" label="商品名称" min-width="180" />
        <el-table-column prop="category" label="分类" width="120" />
        <el-table-column prop="stock" label="库存" width="100" align="center">
          <template #default="{ row }"><span style="color: #F56C6C; font-weight: bold">{{ row.stock }}</span></template>
        </el-table-column>
        <el-table-column prop="price" label="价格" width="120" align="right">
          <template #default="{ row }">{{ Number(row.price).toFixed(2) }}</template>
        </el-table-column>
      </el-table>
      <template #footer><el-button @click="lowStockVisible = false">关闭</el-button></template>
    </el-dialog>

    <!-- 商品导入对话框 -->
    <el-dialog :title="upload.title" v-model="upload.open" width="400px" append-to-body>
      <el-upload
        ref="uploadRef"
        :limit="1"
        accept=".xlsx, .xls"
        :headers="upload.headers"
        :action="upload.url + '?updateSupport=' + upload.updateSupport"
        :disabled="upload.isUploading"
        :on-progress="handleFileUploadProgress"
        :on-success="handleFileSuccess"
        :on-change="handleFileChange"
        :on-remove="handleFileRemove"
        :auto-upload="false"
        drag
      >
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <template #tip>
          <div style="margin-top: 10px">
            <el-checkbox v-model="upload.updateSupport" :true-value="1" :false-value="0" /> 是否更新已经存在的商品数据
            <el-link type="primary" :underline="false" style="font-size: 12px; margin-left: 10px" @click="importTemplate">下载模板</el-link>
          </div>
        </template>
      </el-upload>
      <template #footer>
        <el-button type="primary" @click="submitFileForm">确 定</el-button>
        <el-button @click="upload.open = false">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, getCurrentInstance } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { UploadFilled } from '@element-plus/icons-vue'
import { listProducts, addProduct, updateProduct, deleteProduct, getLowStockProducts, batchUpdateStatus } from '@/api/business/product'
import { getToken } from '@/utils/auth'

const { proxy } = getCurrentInstance()

const loading = ref(false)
const submitLoading = ref(false)
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const editingId = ref(null)
const selectedIds = ref([])

// Detail
const detailVisible = ref(false)
const detailProduct = ref({})

// Low stock
const lowStockVisible = ref(false)
const lowStockLoading = ref(false)
const lowStockData = ref([])
const lowStockThreshold = ref(10)
const categories = ref([])

const queryParams = reactive({ name: '', category: '', status: '', pageNum: 1, pageSize: 10 })

const form = reactive({ name: '', category: '', price: 0, stock: 10, description: '', imageUrl: '', highlights: '', refundPolicy: '', warrantyInfo: '', afterSaleNote: '', status: 1 })

const rules = {
  name: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
  category: [{ required: true, message: '请输入商品分类', trigger: 'blur' }],
  price: [{ required: true, message: '请输入价格', trigger: 'blur' }],
  stock: [{ required: true, message: '请输入库存', trigger: 'blur' }]
}

const resetForm = () => {
  form.name = ''; form.category = ''; form.price = 0; form.stock = 10; form.description = ''; form.imageUrl = ''; form.highlights = ''; form.refundPolicy = ''; form.warrantyInfo = ''; form.afterSaleNote = ''; form.status = 1
  editingId.value = null
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await listProducts(queryParams)
    tableData.value = res.rows || []
    total.value = res.total || 0
    // 收集分类选项
    const cats = new Set(categories.value)
    tableData.value.forEach(p => { if (p.category) cats.add(p.category) })
    categories.value = [...cats]
  } finally { loading.value = false }
}

const handleSearch = () => { queryParams.pageNum = 1; loadData() }
const resetQuery = () => { queryParams.name = ''; queryParams.category = ''; queryParams.status = ''; queryParams.pageNum = 1; loadData() }

const handleSelectionChange = (selection) => {
  selectedIds.value = selection.map(item => item.productId)
}

const handleAdd = () => { resetForm(); dialogTitle.value = '新增商品'; dialogVisible.value = true }

const handleDetail = (row) => {
  detailProduct.value = { ...row }
  detailVisible.value = true
}

const handleEdit = (row) => {
  resetForm(); dialogTitle.value = '编辑商品'; editingId.value = row.productId
  Object.assign(form, { name: row.name, category: row.category, price: row.price, stock: row.stock, description: row.description, imageUrl: row.imageUrl || '', highlights: row.highlights || '', refundPolicy: row.refundPolicy || '', warrantyInfo: row.warrantyInfo || '', afterSaleNote: row.afterSaleNote || '', status: row.status })
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (!formRef.value) return
  await formRef.value.validate()
  submitLoading.value = true
  try {
    if (editingId.value) { await updateProduct(editingId.value, { ...form }); ElMessage.success('更新成功') }
    else { await addProduct({ ...form }); ElMessage.success('新增成功') }
    dialogVisible.value = false; loadData()
  } finally { submitLoading.value = false }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除该商品？', '提示', { type: 'warning' }).then(async () => {
    await deleteProduct(row.productId); ElMessage.success('删除成功'); loadData()
  }).catch(() => {})
}

const handleLowStock = async () => {
  lowStockVisible.value = true
  await loadLowStock()
}

const loadLowStock = async () => {
  lowStockLoading.value = true
  try {
    const res = await getLowStockProducts(lowStockThreshold.value)
    lowStockData.value = res.data || []
  } finally { lowStockLoading.value = false }
}

const handleBatchStatus = (status) => {
  const action = status === 1 ? '上架' : '下架'
  ElMessageBox.confirm(`确认批量${action}选中的 ${selectedIds.value.length} 个商品？`, '提示', { type: 'warning' }).then(async () => {
    await batchUpdateStatus(selectedIds.value, status)
    ElMessage.success(`批量${action}成功`)
    loadData()
  }).catch(() => {})
}

onMounted(() => { loadData() })

const handleExport = () => {
  proxy.download('business/product/export', { ...queryParams }, `商品数据_${new Date().getTime()}.xlsx`)
}

// ===== 商品导入 =====
const uploadRef = ref(null)
const upload = reactive({
  open: false,
  title: '商品导入',
  isUploading: false,
  updateSupport: 0,
  headers: { Authorization: 'Bearer ' + getToken() },
  url: import.meta.env.VITE_APP_BASE_API + '/business/product/importData',
  selectedFile: null
})

const handleImport = () => {
  upload.open = true
  upload.selectedFile = null
}

const importTemplate = () => {
  proxy.download('business/product/importTemplate', {}, `商品导入模板_${new Date().getTime()}.xlsx`)
}

const handleFileChange = (file) => {
  upload.selectedFile = file
}

const handleFileRemove = () => {
  upload.selectedFile = null
}

const handleFileUploadProgress = () => {
  upload.isUploading = true
}

const handleFileSuccess = (response) => {
  upload.open = false
  upload.isUploading = false
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
  ElMessageBox.alert("<div style='overflow: auto; overflow-x: hidden; max-height: 70vh; padding: 10px 20px 0;'>" + response.msg + "</div>", "导入结果", { dangerouslyUseHTMLString: true })
  loadData()
}

const submitFileForm = () => {
  if (!upload.selectedFile) {
    ElMessage.warning('请选择要导入的文件')
    return
  }
  const fileName = upload.selectedFile.name.toLowerCase()
  if (!fileName.endsWith('.xls') && !fileName.endsWith('.xlsx')) {
    ElMessage.error("请选择后缀为 '.xls' 或 '.xlsx' 的文件")
    return
  }
  if (uploadRef.value) {
    uploadRef.value.submit()
  }
}
</script>

<style scoped>
.mt10 { margin-top: 10px; }

/* 详情对话框 - hero布局 */
.detail-hero { display: flex; gap: 24px; }
.detail-hero-image { flex: 0 0 280px; background: #f8f9fb; border-radius: 12px; padding: 12px; text-align: center; border: 1px solid #ebeef5; }
.detail-hero-info { flex: 1; min-width: 0; display: flex; flex-direction: column; }
.detail-name { font-size: 18px; font-weight: 700; color: #1d2129; margin: 0 0 12px 0; }
.detail-price-bar { background: linear-gradient(135deg, #fff1f0, #fff7e6); padding: 12px 16px; border-radius: 10px; margin-bottom: 14px; }
.price-symbol { font-size: 14px; font-weight: 700; color: #f56c6c; }
.price-value { font-size: 28px; font-weight: 800; color: #f56c6c; font-family: 'DIN Alternate', sans-serif; }
.no-image-placeholder { height: 200px; display: flex; align-items: center; justify-content: center; color: #c0c4cc; font-size: 14px; }

/* 详情段落 */
.detail-section { margin-bottom: 16px; }
.detail-section-title { font-size: 14px; font-weight: 600; color: #303133; margin-bottom: 8px; }
.detail-section-text { font-size: 14px; color: #606266; line-height: 1.8; white-space: pre-wrap; background: #f8f9fb; padding: 12px 16px; border-radius: 8px; border: 1px solid #ebeef5; }

/* 售后信息卡片 */
.detail-service-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px; }
.detail-service-card { padding: 14px 16px; background: #f8f9fb; border-radius: 10px; border: 1px solid #ebeef5; }
.service-card-label { font-size: 13px; font-weight: 600; color: #303133; margin-bottom: 6px; }
.service-card-content { font-size: 13px; color: #606266; line-height: 1.6; }
.detail-empty { text-align: center; color: #c0c4cc; padding: 20px 0; font-size: 14px; }
</style>
