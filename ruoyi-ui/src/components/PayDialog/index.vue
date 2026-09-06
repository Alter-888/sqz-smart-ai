<template>
  <el-dialog :model-value="visible" title="模拟支付" width="500px" destroy-on-close @update:model-value="$emit('update:visible', $event)">
    <div class="pay-info">
      <div v-if="orderNo" class="pay-row">
        <span class="pay-label">订单号：</span>
        <span class="pay-value">{{ orderNo }}</span>
      </div>
      <div class="pay-row">
        <span class="pay-label">商品：</span>
        <span class="pay-value">{{ productSummary || '-' }}</span>
      </div>
      <div class="pay-row">
        <span class="pay-label">支付金额：</span>
        <span class="pay-amount">&yen;{{ totalAmount }}</span>
      </div>
    </div>

    <div class="pay-method-section">
      <div class="pay-method-title">选择支付方式</div>
      <el-radio-group v-model="payMethod" size="large" class="pay-method-group">
        <el-radio-button value="alipay">
          <span class="pay-method-item">
            <svg class="pay-method-icon" viewBox="0 0 1024 1024" width="22" height="22">
              <path d="M230.4 512c0-155.648 126.208-281.6 281.6-281.6s281.6 125.952 281.6 281.6-126.208 281.6-281.6 281.6S230.4 667.648 230.4 512zM512 64C264.576 64 64 264.576 64 512s200.576 448 448 448 448-200.576 448-448S759.424 64 512 64z m148.48 479.488s-25.6 65.28-72.192 127.744c0 0 118.272 54.784 152.576 83.712-45.824 30.464-139.776 36.608-139.776 36.608L471.04 706.56s-100.864 87.808-234.496 60.928c-66.56-23.296-93.696-103.68-17.408-157.952 72.96-41.984 168.448-12.032 224.512 16.128 22.528-29.696 40.448-62.72 52.736-95.232H314.368v-24.832h109.568v-53.504H289.792v-25.088h134.144V370.688s2.304-16.384 20.48-16.384h61.44v72.704h143.616v25.088h-143.616v53.504h116.224l-61.6 37.888z m-290.048 169.984c64.768 26.88 134.4-9.728 167.168-35.072l-97.28-50.944c-61.696-25.856-130.304-13.312-150.528 14.848-14.592 32.256 16.128 48.128 80.64 71.168z" fill="#1677FF"/>
            </svg>
            支付宝
          </span>
        </el-radio-button>
        <el-radio-button value="wechat">
          <span class="pay-method-item">
            <svg class="pay-method-icon" viewBox="0 0 1024 1024" width="22" height="22">
              <path d="M690.1 377.4c5.9 0 11.8 0.2 17.6 0.5-24.4-128.7-158.3-227.1-313.4-227.1C221.2 150.8 82.2 267.1 82.2 409.4c0 81.9 44.8 149.3 119.8 201.5l-29.9 89.6 104.4-52.2c37.4 7.5 67.3 15 104.4 15 5.6 0 11.2-0.2 16.7-0.6-3.5-12.2-5.5-24.9-5.5-38 0-136.7 119.9-247.3 297.9-247.3z m-179.7-84c22.4 0 37.4 14.9 37.4 37.4 0 22.4-15 37.4-37.4 37.4-22.4 0-44.8-15-44.8-37.4 0-22.5 22.5-37.4 44.8-37.4z m-224.4 74.7c-22.4 0-44.8-14.9-44.8-37.4 0-22.4 22.4-37.4 44.8-37.4 22.4 0 37.4 15 37.4 37.4 0 22.5-15 37.4-37.4 37.4zM942 629.5c0-119.8-119.8-217.1-254.5-217.1-142.2 0-254.5 97.3-254.5 217.1s112.3 217.1 254.5 217.1c29.9 0 59.8-7.5 89.6-15l82 44.8-22.4-74.7c59.7-44.8 104.4-112.2 105.3-172.2zM601.4 597c-14.9 0-29.9-14.9-29.9-29.9 0-14.9 15-29.9 29.9-29.9 22.4 0 37.4 15 37.4 29.9 0 15-15 29.9-37.4 29.9z m254.5 0c-14.9 0-29.9-14.9-29.9-29.9 0-14.9 15-29.9 29.9-29.9 22.4 0 37.4 15 37.4 29.9 0 15-14.9 29.9-37.4 29.9z" fill="#07C160"/>
            </svg>
            微信支付
          </span>
        </el-radio-button>
        <el-radio-button value="bank">
          <span class="pay-method-item">
            <svg class="pay-method-icon" viewBox="0 0 1024 1024" width="22" height="22">
              <path d="M894.3 192H129.7c-34.8 0-63 28.2-63 63v514c0 34.8 28.2 63 63 63h764.6c34.8 0 63-28.2 63-63V255c0-34.8-28.2-63-63-63z m0 63v103.2H129.7V255h764.6zM129.7 769V421.2h764.6V769H129.7z m95.6-126h286.4c17.4 0 31.5-14.1 31.5-31.5S529.1 580 511.7 580H225.3c-17.4 0-31.5 14.1-31.5 31.5s14.1 31.5 31.5 31.5z m0 95h143.2c17.4 0 31.5-14.1 31.5-31.5s-14.1-31.5-31.5-31.5H225.3c-17.4 0-31.5 14.1-31.5 31.5s14.1 31.5 31.5 31.5z" fill="#606266"/>
            </svg>
            银行卡
          </span>
        </el-radio-button>
      </el-radio-group>
    </div>

    <template #footer>
      <el-button @click="$emit('update:visible', false)">取消</el-button>
      <el-button type="danger" :loading="loading" @click="$emit('confirm', payMethod)">确认支付</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  visible: { type: Boolean, default: false },
  loading: { type: Boolean, default: false },
  orderNo: { type: String, default: '' },
  totalAmount: { type: String, default: '0.00' },
  productSummary: { type: String, default: '' }
})

defineEmits(['update:visible', 'confirm'])

const payMethod = ref('alipay')

watch(() => props.visible, (val) => {
  if (val) payMethod.value = 'alipay'
})
</script>

<style scoped>
.pay-info {
  background: #f8f9fb;
  border-radius: 12px;
  padding: 18px 22px;
  border: 1px solid #ebeef5;
}
.pay-row {
  display: flex;
  align-items: center;
  padding: 8px 0;
  font-size: 14px;
}
.pay-label {
  color: #909399;
  min-width: 80px;
  font-weight: 500;
}
.pay-value {
  color: #303133;
}
.pay-amount {
  color: #f56c6c;
  font-size: 24px;
  font-weight: 700;
  font-family: 'DIN Alternate', 'Helvetica Neue', sans-serif;
}

.pay-method-section {
  margin-top: 24px;
}
.pay-method-title {
  font-weight: 600;
  margin-bottom: 14px;
  color: #303133;
  font-size: 15px;
}
.pay-method-group {
  display: flex;
  gap: 12px;
  width: 100%;
}
.pay-method-group :deep(.el-radio-button) {
  flex: 1;
}
.pay-method-group :deep(.el-radio-button__inner) {
  width: 100%;
  border-radius: 10px !important;
  border: 1.5px solid #dcdfe6 !important;
  box-shadow: none !important;
  padding: 14px 12px !important;
  transition: all 0.25s;
}
.pay-method-group :deep(.el-radio-button__original-radio:checked + .el-radio-button__inner) {
  background: #f0f7ff !important;
  border-color: #409eff !important;
  color: #409eff !important;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.1) !important;
}
.pay-method-item {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  font-weight: 500;
}
.pay-method-icon {
  flex-shrink: 0;
}
</style>
