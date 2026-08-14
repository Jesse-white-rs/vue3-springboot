<template>
  <div class="permissions-table">
    <div class="filter-panel">
      <div class="form-row">
        <el-input v-model="permission.mId" placeholder="ID" clearable class="filter-input" />
        <el-input v-model="permission.mName" placeholder="权限名称" clearable class="filter-input" />
        <el-input v-model="permission.mUrl" placeholder="权限地址" clearable class="filter-input-wide" />
        <el-input v-model="permission.mSign" placeholder="权限标志" clearable class="filter-input-wide" />
      </div>
      <div class="action-row">
        <el-button type="primary" @click="store.searchPermissions(permission!)">
          <el-icon><Search /></el-icon>搜索
        </el-button>
        <el-button type="primary" @click="resetSearch">
          <el-icon><Refresh /></el-icon>重置
        </el-button>
        <el-tooltip content="增行" placement="top">
          <el-button type="primary" circle @click="addVisible = true">
            <el-icon><Plus /></el-icon>
          </el-button>
        </el-tooltip>
        <el-tooltip content="删行" placement="top">
          <el-button type="danger" circle @click="handleDeletePermissions()">
            <el-icon><Delete /></el-icon>
          </el-button>
        </el-tooltip>
      </div>
    </div>

    <div class="table-wrapper">
      <el-table :data="store.permissionsTableData" style="width: 100%" height="300px" class="ios-table"
        @selection-change="store.handleSelectionChange">
        <el-table-column type="selection" width="40" fixed />
        <el-table-column fixed prop="mId" label="ID" width="70" sortable />
        <el-table-column prop="mName" label="权限名称" width="250" show-overflow-tooltip>
          <template #default="scope">
            <el-tag size="small">{{ scope.row.mName }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="mUrl" label="权限地址" width="200" show-overflow-tooltip />
        <el-table-column prop="mSign" label="权限标志" width="200" show-overflow-tooltip />
        <el-table-column fixed="right" label="操作" width="120">
          <template #default="scope">
            <el-button size="small" type="primary" link @click="handleEdit(scope.row)">编辑</el-button>
            <el-button size="small" type="danger" link @click="store.deletePermissions([scope.row.id])">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <div class="pag">
      <el-pagination
        v-model:current-page="store.currentPage"
        v-model:page-size="store.pageSize"
        :page-sizes="[10, 20, 50, 100]"
        :total="store.total"
        layout="sizes, prev, pager, next, jumper"
        @current-change="onCurrentChange"
        @size-change="onPageSizeChange"
      />
    </div>

    <permissionsAdd v-model:visible="addVisible" @update:visible="handleAddVisibleChange" @permission-added="store.getPage()" />
    <permissionsEdit v-model:visible="editVisible" @update:visible="handleEditVisibleChange" @permission-updated="store.getPage()" />
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue'
import { usePermissionStore } from '../../stores/permissions-store'
import { ElMessage } from 'element-plus';
import { Search, Refresh, Plus, Delete } from "@element-plus/icons-vue";
import permissionsAdd from './permissionAdd.vue';
import permissionsEdit from './permissionEdit.vue';

const store = usePermissionStore()
const addVisible = ref(false)
const editVisible = ref(false)

const permission = ref({
  mId: null,
  mName: null,
  mUrl: null,
  mSign: null
})

const resetSearchPermission = ref({
  mId: null,
  mName: null,
  mUrl: null,
  mSign: null
})

onMounted(() => {
  store.getPage()
})

const onPageSizeChange = (size: number) => {
  store.pageSize = size
  store.getPage()
};

const onCurrentChange = (index: number) => {
  store.currentPage = index
  store.getPage()
};

const resetSearch = async () => {
  resetSearchPermission.value = {
    mId: null,
    mName: null,
    mUrl: null,
    mSign: null
  };
  permission.value = resetSearchPermission.value;
  await store.getPage();
};

const handleDeletePermissions = async () => {
  if (store.selectedIds.length > 0) {
    await store.deletePermissions(store.selectedIds)
  } else {
    ElMessage.warning('请选择要删除的项目')
  }
};

const handleAddVisibleChange = (visible: boolean) => {
  addVisible.value = visible
};

const handleEditVisibleChange = (visible: boolean) => {
  editVisible.value = visible
};

const handleEdit = (row: any) => {
  store.permissionEditFormData = { ...row };
  editVisible.value = true
};
</script>

<style scoped>
.permissions-table {
  width: 100%;
}

.filter-panel {
  margin-bottom: 16px;
}

.form-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 12px;
}

.filter-input {
  width: 120px;
}

.filter-input-wide {
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

.action-row {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.action-row :deep(.el-button) {
  border-radius: 10px;
  --el-button-bg-color: #007aff;
  --el-button-border-color: #007aff;
  --el-button-hover-bg-color: #0066d6;
  --el-button-hover-border-color: #0066d6;
}

.action-row :deep(.el-button--danger) {
  --el-button-bg-color: #ff3b30;
  --el-button-border-color: #ff3b30;
  --el-button-hover-bg-color: #e6352c;
  --el-button-hover-border-color: #e6352c;
}

.table-wrapper {
  border-radius: 14px;
  overflow: hidden;
  border: 0.5px solid rgba(0, 0, 0, 0.06);
}

.ios-table :deep(.el-table__header th) {
  background: #f9f9f9 !important;
  font-weight: 600;
  color: #8e8e93;
  font-size: 12px;
}

.ios-table :deep(.el-table__row td) {
  border-bottom-color: rgba(0, 0, 0, 0.04);
}

.ios-table :deep(.el-table__row:hover > td) {
  background: #f5f9ff !important;
}

.pag {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
}
</style>
