<template>
  <div class="wrap">
    <div class="search-bar">
      <el-input
        v-model="searchKeyword"
        placeholder="请输入关键词搜索设置项"
        clearable
        :prefix-icon="Search"
      />
    </div>

    <div
      class="section"
      v-for="block in filteredBlocks"
      :key="block.title"
    >
      <div class="section-title">{{ block.title }}</div>
      <div class="section-body">
        <component :is="block.component" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import { Search } from "@element-plus/icons-vue";

import routesTable from "./settingsPage/routesTable.vue";
import rolesTable from "./settingsPage/rolesTable.vue";
import roleRoutesTable from "./settingsPage/roleRoutesTable.vue";
import permissionsTable from "./settingsPage/permissionsTable.vue";
import EmpPermissionsTable from "./settingsPage/empPermissionsTable.vue";
import qySync from "./settingsPage/qySync.vue";

const blocks = [
  { title: "路由设置", component: routesTable },
  { title: "角色设置", component: rolesTable },
  { title: "角色-路由设置", component: roleRoutesTable },
  { title: "权限设置", component: permissionsTable },
  { title: "用户-权限设置", component: EmpPermissionsTable },
  { title: "企微同步", component: qySync }
];

const searchKeyword = ref("");

const filteredBlocks = computed(() =>
  blocks.filter((block) =>
    block.title.includes(searchKeyword.value.trim())
  )
);
</script>

<style scoped>
.wrap {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.search-bar {
  width: 320px;
}

.search-bar :deep(.el-input__wrapper) {
  border-radius: 12px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06);
}

.search-bar :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2);
}

.search-bar :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2);
}

.section {
  background: #fff;
  border-radius: 18px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  padding: 20px;
  transition: all 0.3s ease;
}

.section:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: #1f1f1f;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 0.5px solid rgba(0, 0, 0, 0.06);
}
</style>
