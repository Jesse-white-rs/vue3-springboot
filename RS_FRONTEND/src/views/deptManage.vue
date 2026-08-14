<template>
  <div class="wrap">
    <!-- 筛选区域 -->
    <div class="filter-panel">
      <div class="form-row">
        <el-input v-model="store.searchData.id" placeholder="部门 ID" clearable class="filter-input" />
        <el-input v-model="store.searchData.dName" placeholder="部门名称" clearable class="filter-input" />
        <el-button type="primary" @click="store.searchDept()">
          <el-icon><Search /></el-icon>搜索
        </el-button>
        <el-button type="primary" @click="store.searchDeptDataRefresh()">
          <el-icon><Refresh /></el-icon>重置
        </el-button>
        <el-tooltip content="新增部门" placement="top">
          <el-button type="primary" circle @click="addButton()">
            <el-icon><Plus /></el-icon>
          </el-button>
        </el-tooltip>
        <el-tooltip content="批量删除" placement="top">
          <el-button type="danger" circle @click="store.handleBatchDelete()">
            <el-icon><Delete /></el-icon>
          </el-button>
        </el-tooltip>
      </div>
    </div>

    <!-- 表格 & 分页 -->
    <div class="table-section">
      <deptTable v-model:addVisible="addVisible" @update:addVisible="handleUpdateAddVisible" />
      <pagination class="pag" :store="store" />
    </div>
  </div>
</template>

<script setup lang="ts">
import deptTable from './deptManage/deptTable.vue'
import { ref, onMounted } from "vue";
import pagination from "@/components/pagination.vue";
import { useDeptStore } from "@/stores/dept-store";
import { Search, Refresh, Plus, Delete } from "@element-plus/icons-vue";

const store = useDeptStore()

onMounted(() => {
  store.handlePageChange()
});

const addVisible = ref(false)
const addButton = () => {
  addVisible.value = true
}
const handleUpdateAddVisible = () => {
  addVisible.value = false;
};
</script>

<style scoped>
.wrap {
  background: #fff;
  border-radius: 18px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  padding: 20px;
  display: flex;
  flex-direction: column;
}

.filter-panel {
  margin-bottom: 16px;
}

.form-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.filter-input {
  width: 150px;
}

.form-row :deep(.el-input__wrapper) {
  border-radius: 10px !important;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06) !important;
}

.form-row :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2) !important;
}

.form-row :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2) !important;
}

.form-row :deep(.el-button) {
  border-radius: 10px;
  --el-button-bg-color: #007aff;
  --el-button-border-color: #007aff;
  --el-button-hover-bg-color: #0066d6;
  --el-button-hover-border-color: #0066d6;
  --el-button-active-bg-color: #0055b3;
  --el-button-active-border-color: #0055b3;
}

.form-row :deep(.el-button--danger) {
  --el-button-bg-color: #ff3b30;
  --el-button-border-color: #ff3b30;
  --el-button-hover-bg-color: #e6352c;
  --el-button-hover-border-color: #e6352c;
  --el-button-active-bg-color: #cc2f26;
  --el-button-active-border-color: #cc2f26;
}

.table-section {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.pag {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
}
</style>
