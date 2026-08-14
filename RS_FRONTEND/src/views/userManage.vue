<template>
  <div class="wrap">
    <!-- 筛选区域 -->
    <div class="filter-panel">
      <div class="form-row">
        <el-input
          v-model="store.searchUserData.emp.id"
          placeholder="ID"
          clearable
          class="filter-input"
        />
        <el-input
          v-model="store.searchUserData.emp.eUsername"
          placeholder="账号"
          clearable
          class="filter-input"
        />
        <el-input
          v-model="store.searchUserData.emp.eName"
          placeholder="姓名"
          clearable
          class="filter-input"
        />
        <el-input
          v-model="store.searchUserData.emp.ePhone"
          placeholder="手机号"
          clearable
          class="filter-input"
        />
        <el-input
          v-model="store.searchUserData.emp.eId"
          placeholder="证件号"
          clearable
          class="filter-input"
        />
        <el-select
          v-model="store.searchUserData.emp.eDeptid"
          placeholder="部门"
          clearable
          class="filter-select"
        >
          <el-option
            v-for="item in storeDept.tableData"
            :key="item.id"
            :value="item.id"
            :label="item.dName"
          />
        </el-select>
        <el-select
          v-model="store.searchUserData.role.rId"
          placeholder="角色"
          clearable
          class="filter-select"
        >
          <el-option
            v-for="item in storeRole.roleList"
            :key="item.rId"
            :value="item.rId"
            :label="item.rInfo"
          />
        </el-select>
        <el-select
          v-model="store.searchUserData.emp.eIsenabled"
          placeholder="状态"
          clearable
          class="filter-select"
        >
          <el-option value="1" label="启用" />
          <el-option value="0" label="禁用" />
        </el-select>
        <el-select
          v-model="store.searchUserData.emp.eGender"
          placeholder="性别"
          clearable
          class="filter-select"
        >
          <el-option value="1" label="男" />
          <el-option value="0" label="女" />
        </el-select>
      </div>

      <!-- 操作按钮区 -->
      <div class="action-row">
        <el-button type="primary" @click="store.searchUser">
          <el-icon><Search /></el-icon>搜索
        </el-button>
        <el-button type="primary" @click="handleReset">
          <el-icon><Refresh /></el-icon>重置
        </el-button>
        <el-tooltip content="新增用户" placement="top">
          <el-button type="primary" circle @click="addButton">
            <el-icon><Plus /></el-icon>
          </el-button>
        </el-tooltip>
        <el-tooltip content="批量删除" placement="top">
          <el-button type="danger" circle @click="store.handleBatchDelete">
            <el-icon><Delete /></el-icon>
          </el-button>
        </el-tooltip>
      </div>
    </div>

    <!-- 表格 & 分页 -->
    <div class="table">
      <userTable
        v-model:addVisible="addVisible"
        @update:addVisible="handleUpdateAddVisible"
      />
      <pagination class="pag" :store="store" />
    </div>
  </div>
</template>

<script setup lang="ts">
import userTable from "./userManage/userTable.vue";
import { ref, onMounted } from "vue";
import pagination from "@/components/pagination.vue";
import { useUserStore } from "@/stores/user-store";
import { useDeptStore } from "@/stores/dept-store";
import { useRoleStore } from "@/stores/role-store";
import { Search, Refresh, Plus, Delete } from "@element-plus/icons-vue";

const store = useUserStore();
const storeDept = useDeptStore();
const storeRole = useRoleStore();

const handleReset = () => {
  store.searchUserDataRefresh();
};

onMounted(() => {
  store.handlePageChange();
});

const addVisible = ref(false);
const addButton = () => {
  store.cleanUserData();
  addVisible.value = true;
};
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
  margin-bottom: 12px;
}

.filter-input {
  width: 130px;
}

.filter-select {
  width: 130px;
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
  flex-wrap: wrap;
}

.action-row :deep(.el-button) {
  border-radius: 10px;
  --el-button-bg-color: #007aff;
  --el-button-border-color: #007aff;
  --el-button-hover-bg-color: #0066d6;
  --el-button-hover-border-color: #0066d6;
  --el-button-active-bg-color: #0055b3;
  --el-button-active-border-color: #0055b3;
}

.action-row :deep(.el-button--danger) {
  --el-button-bg-color: #ff3b30;
  --el-button-border-color: #ff3b30;
  --el-button-hover-bg-color: #e6352c;
  --el-button-hover-border-color: #e6352c;
  --el-button-active-bg-color: #cc2f26;
  --el-button-active-border-color: #cc2f26;
}

.table {
  display: flex;
  flex-direction: column;
}

.pag {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
}
</style>
