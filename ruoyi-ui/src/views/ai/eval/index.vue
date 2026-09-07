<template>
  <div class="app-container enhance-layout">
    <!-- 说明条 -->
    <el-alert :closable="false" type="info" show-icon class="mb8">
      <template #title>
        离线评测：读取黄金集（ai_eval_golden），逐条跑「意图路由 + 混合检索」并计算指标，结果落库 ai_eval_result。
        跑评测约 1~3 分钟，期间请勿重复触发。
      </template>
    </el-alert>

    <!-- 搜索栏 -->
    <el-form :inline="true" :model="queryParams" class="search-form">
      <el-form-item label="数据集">
        <el-select v-model="queryParams.dataset" placeholder="数据集" clearable @change="handleSearch">
          <el-option v-for="d in datasetOptions" :key="d" :label="d" :value="d" />
        </el-select>
      </el-form-item>
      <el-form-item label="备注">
        <el-input v-model="queryParams.remark" placeholder="按备注模糊搜索" clearable @keyup.enter="handleSearch" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 操作栏 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain :loading="runLoading" @click="handleRun" v-hasPermi="['ai:eval:run']">
          {{ runLoading ? '评测运行中…' : '跑评测' }}
        </el-button>
      </el-col>
    </el-row>

    <!-- 历史结果表（表格+分页合成一张卡片，避免间距断层） -->
    <div class="eval-list-card">
      <el-table v-loading="loading" :data="tableData" stripe border>
        <el-table-column prop="resultId" label="结果ID" width="80" />
        <el-table-column prop="dataset" label="数据集" width="70" />
        <el-table-column prop="caseCount" label="条数" width="70" align="center" />
        <el-table-column prop="recallAtFinalK" label="Recall@Final" min-width="110" align="center">
          <template #default="scope">{{ pct(scope.row.recallAtFinalK) }}</template>
        </el-table-column>
        <el-table-column prop="mrr" label="MRR" min-width="85" align="center">
          <template #default="scope">{{ pct(scope.row.mrr) }}</template>
        </el-table-column>
        <el-table-column prop="hitRate" label="HitRate" min-width="85" align="center">
          <template #default="scope">{{ pct(scope.row.hitRate) }}</template>
        </el-table-column>
        <el-table-column prop="avgDurationMs" label="平均耗时(ms)" min-width="110" align="center">
          <template #default="scope">{{ scope.row.avgDurationMs == null ? '—' : scope.row.avgDurationMs }}</template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="150" show-overflow-tooltip />
        <el-table-column prop="runTime" label="运行时间" width="180" align="center" />
        <el-table-column prop="intentAccuracy" label="意图准确率" min-width="118" align="center" fixed="right">
          <template #default="scope">
            <el-tag :type="intentTag(scope.row.intentAccuracy)">{{ pct(scope.row.intentAccuracy) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="95" align="center" fixed="right">
          <template #default="scope">
            <el-button type="primary" link @click="openDetail(scope.row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
                  v-model:limit="queryParams.pageSize" @pagination="getList" />
    </div>

    <!-- 跑评测参数弹窗 -->
    <el-dialog v-model="runOptionsVisible" title="评测参数" width="480px" append-to-body destroy-on-close>
      <el-form label-width="90px">
        <el-form-item label="数据集">
          <el-select v-model="runOptions.dataset" placeholder="数据集">
            <el-option v-for="d in datasetOptions" :key="d" :label="d" :value="d" />
          </el-select>
        </el-form-item>
        <el-form-item label="本次备注">
          <el-input v-model="runOptions.remark" placeholder="如：P6路由治本后" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="runOptionsVisible = false">取消</el-button>
        <el-button type="primary" :loading="runLoading" @click="doRun">开始评测</el-button>
      </template>
    </el-dialog>

    <!-- 评测详情弹窗 -->
    <el-dialog v-model="detailVisible" title="评测详情" width="680px" append-to-body destroy-on-close>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="结果ID">{{ detail.resultId }}</el-descriptions-item>
        <el-descriptions-item label="数据集">{{ detail.dataset }}</el-descriptions-item>
        <el-descriptions-item label="条数">{{ detail.caseCount }}</el-descriptions-item>
        <el-descriptions-item label="运行时间">{{ detail.runTime }}</el-descriptions-item>
        <el-descriptions-item label="Recall@K">{{ pct(detail.recallAtK) }}</el-descriptions-item>
        <el-descriptions-item label="Recall@Final">{{ pct(detail.recallAtFinalK) }}</el-descriptions-item>
        <el-descriptions-item label="Precision@K">{{ pct(detail.precisionAtK) }}</el-descriptions-item>
        <el-descriptions-item label="MRR">{{ pct(detail.mrr) }}</el-descriptions-item>
        <el-descriptions-item label="HitRate">{{ pct(detail.hitRate) }}</el-descriptions-item>
        <el-descriptions-item label="意图准确率">{{ pct(detail.intentAccuracy) }}</el-descriptions-item>
        <el-descriptions-item label="平均耗时">{{ detail.avgDurationMs }} ms</el-descriptions-item>
        <el-descriptions-item label="备注">{{ detail.remark }}</el-descriptions-item>
      </el-descriptions>
      <div class="snapshot-title">参数快照（config_snapshot）</div>
      <pre class="snapshot-pre">{{ snapshotText }}</pre>
    </el-dialog>
  </div>
</template>

<script setup name="AiEval">
import { getCurrentInstance, reactive, ref } from 'vue'
import { listEvalResults, getEvalResult, runEval } from '@/api/ai/eval'

const { proxy } = getCurrentInstance()

const datasetOptions = ['v1']
const tableData = ref([])
const total = ref(0)
const loading = ref(false)
const runLoading = ref(false)
const runOptionsVisible = ref(false)
const detailVisible = ref(false)
const detail = ref({})
const snapshotText = ref('')

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  dataset: 'v1',
  remark: ''
})

const runOptions = reactive({
  dataset: 'v1',
  remark: ''
})

function pct(v) {
  if (v === null || v === undefined) return '—'
  return Number(v).toFixed(2) + '%'
}

function intentTag(v) {
  if (v === null || v === undefined) return 'info'
  return Number(v) >= 90 ? 'success' : (Number(v) >= 70 ? 'warning' : 'danger')
}

function getList() {
  loading.value = true
  listEvalResults(queryParams).then(res => {
    tableData.value = res.rows
    total.value = res.total
  }).finally(() => {
    loading.value = false
  })
}

function handleSearch() {
  queryParams.pageNum = 1
  getList()
}

function resetQuery() {
  queryParams.dataset = 'v1'
  queryParams.remark = ''
  handleSearch()
}

function openRunOptions() {
  runOptions.dataset = queryParams.dataset || 'v1'
  runOptions.remark = ''
  runOptionsVisible.value = true
}

async function doRun() {
  runLoading.value = true
  try {
    const res = await runEval(runOptions.dataset, runOptions.remark)
    proxy.$modal.msgSuccess('评测完成')
    runOptionsVisible.value = false
    getList()
  } catch (e) {
    proxy.$modal.msgError(e.msg || '评测失败')
  } finally {
    runLoading.value = false
  }
}

function handleRun() {
  openRunOptions()
}

function openDetail(row) {
  getEvalResult(row.resultId).then(res => {
    detail.value = res.data || row
    let snap = detail.value.configSnapshot
    try {
      snap = typeof snap === 'string' && snap ? JSON.stringify(JSON.parse(snap), null, 2) : (snap ? JSON.stringify(snap, null, 2) : '—')
    } catch (e) {
      snap = snap || '—'
    }
    snapshotText.value = snap
    detailVisible.value = true
  })
}

getList()
</script>

<style scoped>
.search-form {
  margin-top: 4px;
}
/* 表格 + 分页 合成一张卡片，消除两者之间的间距缝隙 */
.eval-list-card {
  background: #fff;
  border-radius: 12px;
  border: 1px solid rgba(0, 0, 0, 0.02);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
  overflow: hidden;
}
.eval-list-card :deep(.el-table) {
  border-radius: 0;
  box-shadow: none;
  border-left: none;
  border-right: none;
}
.eval-list-card :deep(.pagination-container) {
  margin-top: 0 !important;
  background: transparent !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  border: none !important;
  padding: 12px 20px;
}
.snapshot-title {
  margin-top: 16px;
  font-weight: 600;
  color: #303133;
}
.snapshot-pre {
  background: #f5f7fa;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  padding: 10px;
  max-height: 320px;
  overflow: auto;
  font-size: 12px;
  line-height: 1.5;
  white-space: pre-wrap;
}
</style>