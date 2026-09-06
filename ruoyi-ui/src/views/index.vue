<template>
  <Dashboard v-if="isAdmin" />
  <UserHome v-else />
</template>

<script setup name="Index">
import { computed } from 'vue'
import useUserStore from '@/store/modules/user'
import Dashboard from '@/views/ai/dashboard/index.vue'
import UserHome from '@/views/home/UserHome.vue'

const userStore = useUserStore()
const isAdmin = computed(() => userStore.roles.includes('admin'))
</script>
