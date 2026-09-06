<template>
  <div class="message-input-container">
    <div class="input-box-wrapper">
      <div class="input-box" :class="{ focused: isFocused }">
        <el-input
          v-model="inputText"
          type="textarea"
          :rows="1"
          :autosize="{ minRows: 1, maxRows: 6 }"
          placeholder="请输入您的问题... (Enter发送，Shift+Enter换行)"
          resize="none"
          :disabled="disabled"
          class="chat-textarea"
          @focus="isFocused = true"
          @blur="isFocused = false"
          @keydown.enter.exact.prevent="handleSend"
        />

        <div class="input-actions">
          <!-- isLoading时: 红色圆形停止按钮; 否则: 蓝色圆形发送按钮 -->
          <el-button
            v-if="isLoading"
            class="stop-circle-btn"
            circle
            @click="$emit('stop')"
          >
            <span class="stop-square"></span>
          </el-button>

          <el-button
            v-else
            type="primary"
            class="send-btn"
            :disabled="!inputText.trim() || disabled"
            circle
            @click="handleSend"
          >
            <el-icon><Promotion /></el-icon>
          </el-button>
        </div>
      </div>

      <div class="input-footer">
        <span>AI 生成的内容可能不准确，请核对重要信息。</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Promotion } from '@element-plus/icons-vue'

const props = defineProps({
  disabled: { type: Boolean, default: false },
  isLoading: { type: Boolean, default: false }
})

const emit = defineEmits(['send', 'stop'])
const inputText = ref('')
const isFocused = ref(false)

function handleSend() {
  const text = inputText.value.trim()
  if (!text || props.disabled) return
  emit('send', text)
  inputText.value = ''
}

defineExpose({ setInput(text) { inputText.value = text } })
</script>

<style scoped>
.message-input-container {
  padding: 0 24px 24px;
  background: linear-gradient(180deg, transparent 0%, #f7f8fa 100%);
  display: flex;
  justify-content: center;
  position: relative;
  z-index: 10;
}

.input-box-wrapper {
  width: 100%;
  max-width: 820px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.input-box {
  background: #fff;
  border: 1.5px solid #e8eaee;
  border-radius: 20px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
  padding: 14px 18px 10px;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  display: flex;
  flex-direction: column;
}

.input-box.focused {
  border-color: #a3c9f7;
  box-shadow: 0 8px 32px rgba(64, 158, 255, 0.15),
              0 0 0 3px rgba(64, 158, 255, 0.06);
}

.chat-textarea :deep(.el-textarea__inner) {
  box-shadow: none !important;
  border: none !important;
  padding: 0;
  background: transparent;
  font-size: 15px;
  line-height: 1.6;
  color: #1a1c21;
}

.chat-textarea :deep(.el-textarea__inner::placeholder) {
  color: #b0b3ba;
}

.input-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  margin-top: 10px;
  padding-top: 6px;
}

/* 停止按钮: 红色圆形 + 白色方块 */
.stop-circle-btn {
  width: 36px;
  height: 36px;
  min-height: 36px;
  padding: 0;
  background: #f56c6c !important;
  border: none !important;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
}
.stop-circle-btn:hover {
  background: #e34d59 !important;
  transform: scale(1.12);
  box-shadow: 0 4px 16px rgba(245, 108, 108, 0.4);
}
.stop-square {
  display: block;
  width: 12px;
  height: 12px;
  background: #fff;
  border-radius: 2px;
}

.send-btn {
  width: 36px;
  height: 36px;
  min-height: 36px;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea, #409eff);
  border: none;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  font-size: 16px;
}

.send-btn:not(.is-disabled):hover {
  transform: scale(1.12);
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.4);
}

.send-btn:not(.is-disabled):active {
  transform: scale(0.95);
}

.send-btn.is-disabled {
  background: #e4e7ed;
  color: #fff;
  transform: none;
}

.input-footer {
  text-align: center;
  font-size: 12px;
  color: #c0c3ca;
  transform: scale(0.9);
}
</style>
