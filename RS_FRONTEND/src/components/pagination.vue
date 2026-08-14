<template>
  <el-pagination
    v-model:current-page="paginationStore.current"
    v-model:page-size="paginationStore.pageSize"
    :page-sizes="[10, 20, 50, 100]"
    :total="paginationStore.total"
    layout="sizes, prev, pager, next, jumper"
    @current-change="onCurrentChange"
    @size-change="onSizeChange"
  />
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  store: any
}>()

const paginationStore = computed(() => props.store)

const onCurrentChange = (page: number) => {
  paginationStore.value.current = page
  paginationStore.value.handlePageChange()
};

const onSizeChange = (size: number) => {
  paginationStore.value.pageSize = size
  paginationStore.value.current = 1
  paginationStore.value.handlePageChange()
};
</script>

<style scoped>
</style>
