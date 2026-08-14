<template>
  <div class="route-table">
    <div class="filter-panel">
      <div class="form-row">
        <el-input v-model="route.alias" placeholder="别名" clearable class="filter-input" />
        <el-input v-model="route.id" placeholder="ID" clearable class="filter-input" />
        <el-input v-model="route.value" placeholder="路径" clearable class="filter-input-wide" />
        <el-input v-model="route.name" placeholder="组件名称" clearable class="filter-input" />
        <el-input v-model="route.redirect" placeholder="重定向" clearable class="filter-input" />
        <el-select v-model="route.type" placeholder="类型" clearable class="filter-select">
          <el-option v-for="item in store.ROUTE_TYPE_OPTIONS" :key="item.value" :value="item.value" :label="item.label" />
        </el-select>
        <el-select v-model="route.state" placeholder="状态" clearable class="filter-select">
          <el-option v-for="item in store.ROUTE_STATE_OPTIONS" :key="item.value" :value="item.value" :label="item.label" />
        </el-select>
      </div>
      <div class="action-row">
        <el-button type="primary" @click="store.searchRoutes(route!)">
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
          <el-button type="danger" circle @click="handleDeleteRoutes()">
            <el-icon><Delete /></el-icon>
          </el-button>
        </el-tooltip>
      </div>
    </div>

    <div class="table-wrapper">
      <el-table :data="store.routesTableData" style="width: 100%" height="300px" class="ios-table"
        @selection-change="store.handleSelectionChange">
        <el-table-column type="selection" width="40" fixed />
        <el-table-column fixed prop="id" label="ID" width="70" sortable />
        <el-table-column prop="parentrouteid" label="父路由ID" width="90" />
        <el-table-column prop="alias" label="别名" width="100" show-overflow-tooltip />
        <el-table-column prop="name" label="组件名称" width="120" show-overflow-tooltip />
        <el-table-column prop="icon" label="图标" width="120" show-overflow-tooltip />
        <el-table-column prop="state" label="状态" width="80" :filters="[
          { text: '启用', value: 1 },
          { text: '禁用', value: 0 },
        ]" :filter-method="(value: number, row: RouteEntity) => row.state === value" filter-placement="bottom-end">
          <template #default="scope">
            <el-tag :type="scope.row.state == 1 ? 'success' : 'danger'" size="small">
              {{ scope.row.state == 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="sort" label="排序" width="60" />
        <el-table-column prop="value" label="路径" width="120" show-overflow-tooltip />
        <el-table-column prop="redirect" label="重定向" width="80" show-overflow-tooltip />
        <el-table-column prop="type" label="类型" width="80" :filters="[
          { text: '菜单', value: 'MENU' },
          { text: '页面', value: 'LINK' }
        ]" :filter-method="(value: string, row: RouteEntity) => row.type === value" filter-placement="bottom-end">
          <template #default="scope">
            <el-tag :type="scope.row.type === 'MENU' ? 'primary' : 'warning'" effect="dark" size="small">
              {{ scope.row.type === 'MENU' ? '菜单' : '页面' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="discription" label="描述" width="120" show-overflow-tooltip />
        <el-table-column prop="createuserid" label="创建用户ID" width="100" show-overflow-tooltip />
        <el-table-column label="操作" fixed="right" width="120">
          <template #default="scope">
            <el-button size="small" type="primary" link @click="handleEdit(scope.row)">编辑</el-button>
            <el-button size="small" type="danger" link @click="store.deleteRoutes([scope.row.id])">删除</el-button>
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

    <routesAdd v-model:visible="addVisible" @update:visible="handleAddVisibleChange" @route-added="store.getPage()" />
    <routesEdit v-model:visible="editVisible" @update:visible="handleEditVisibleChange" @route-updated="store.getPage()" />
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue'
import { useRouteStore } from '../../stores/routes-store'
import type { RouteEntity } from '@/models/route';
import { ElMessage } from 'element-plus';
import { Search, Refresh, Plus, Delete } from "@element-plus/icons-vue";
import routesAdd from './routesAdd.vue';
import routesEdit from './routesEdit.vue';

const store = useRouteStore()
const addVisible = ref(false)
const editVisible = ref(false)

const route = ref({
  alias: null,
  id: null,
  name: null,
  redirect: null,
  state: null,
  type: null,
  value: null
})

const resetSearchRoute = ref({
  alias: null,
  id: null,
  name: null,
  redirect: null,
  state: null,
  type: null,
  value: null
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
  resetSearchRoute.value = {
    alias: null,
    id: null,
    name: null,
    redirect: null,
    state: null,
    type: null,
    value: null
  };
  route.value = resetSearchRoute.value
  await store.getPage();
};

const handleDeleteRoutes = async () => {
  if (store.selectedIds.length > 0) {
    await store.deleteRoutes(store.selectedIds)
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
  store.routeEditFormData = { ...row };
  editVisible.value = true
};
</script>

<style scoped>
.route-table {
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

.filter-select {
  width: 120px;
}

.form-row :deep(.el-input__wrapper),
.form-row :deep(.el-select__wrapper) {
  border-radius: 10px !important;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06) !important;
}

.form-row :deep(.el-input__wrapper:hover),
.form-row :deep(.el-select__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2) !important;
}

.form-row :deep(.el-input__wrapper.is-focus),
.form-row :deep(.el-select__wrapper.is-focused) {
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
