<template>
  <footer v-if="visible" class="copyright">
    <span>{{ content }}</span>
  </footer>
</template>

<script setup>
import useSettingsStore from '@/store/modules/settings'

const settingsStore = useSettingsStore()

const visible = computed(() => settingsStore.footerVisible)
const content = computed(() => settingsStore.footerContent)
</script>

<style scoped>
.copyright {
  width: 100%;
  height: 36px;
  padding: 10px 20px;
  text-align: center;
  background-color: #fff;
  color: #666;
  font-size: 14px;
  border-top: 1px solid #e7e7e7;
}
</style>