<template>
  <div class="pcInfo-page">
    <!-- 左侧列表卡片区域 -->
    <div class="pcInfo-card">
      <div class="card-header">
        电脑信息管理
        <div class="actions">
          <el-button type="primary" size="small" @click="addVisible = true">添加</el-button>
        </div>
      </div>
      <el-scrollbar height="70vh" class="card-body">
        <div class="pcInfo-list">
          <div class="pcInfo-item" v-for="(item, index) in pageData" :key="index">
            <div class="pcInfo-title">{{ item.empName || "未知使用者" }}</div>
            <div class="pcInfo-content">IP 地址：{{ item.ip }}</div>
            <div class="pcInfo-content">
              内存总量：{{ item.memoryTotal }} GB
            </div>
            <div class="pcInfo-content">
              内存使用率：{{ item.memoryUsage }}%
            </div>
            <div class="pcInfo-content">
              磁盘信息：
              <div v-for="(disk, i) in parseDiskList(item.diskList as string)" :key="i">
                <span>{{ disk.mount }} {{ disk.used }}/{{ disk.total }}GB ({{
                  disk.usage
                }}%)</span>
              </div>
            </div>
            <div class="pcInfo-content">
              更新时间：{{ item.updateTime }}
            </div>
            <div class="pcInfo-footer">
              <el-button text size="small" type="primary" @click="handleEdit(item)">编辑</el-button>
            </div>
          </div>
        </div>
      </el-scrollbar>
    </div>

    <!-- 右侧表格区域 -->
    <div class="pcInfo-table-card">
      <div class="card-header">详细信息</div>
      <div class="card-body">
        <div class="table-wrapper">
          <el-table :data="pageData" style="width: 100%" height="58vh" class="ios-table">
            <el-table-column prop="empName" label="使用者" width="100" />
            <el-table-column prop="ip" label="IP 地址" width="140" />
            <el-table-column prop="memoryTotal" label="总内存 (GB)" width="100" />
            <el-table-column prop="memoryUsage" label="内存使用率 (%)" width="120" />
            <el-table-column label="磁盘信息" width="220" show-overflow-tooltip>
              <template #default="{ row }">
                <div v-if="row.diskList">
                  <div v-for="(disk, i) in parseDiskList(row.diskList)" :key="i">
                    <span>{{ disk.mount }} {{ disk.used }}/{{ disk.total }}GB ({{
                      disk.usage
                    }}%)</span>
                  </div>
                </div>
                <div v-else>无</div>
              </template>
            </el-table-column>
            <el-table-column prop="updateTime" label="更新时间" width="180" sortable />
            <el-table-column prop="createTime" label="创建时间" width="180" sortable />
            <el-table-column label="操作" width="100" fixed="right">
              <template #default="{ row }">
                <el-button type="primary" link size="small" @click="handleEdit(row)">编辑</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 分页 -->
        <div class="pag">
          <el-pagination
            background
            layout="prev, pager, next, sizes, total"
            :total="pcInfoStore.pageDataSum"
            :page-size="pcInfoStore.pageSize"
            :current-page="pcInfoStore.currentPage"
            :page-sizes="[5, 10, 20, 50]"
            @current-change="onCurrentChange"
            @size-change="onPageSizeChange"
          />
        </div>
      </div>
    </div>

    <!-- 弹窗组件 -->
    <addPcInfo :visible="addVisible" @update:visible="handleAddVisibleChange" />
    <editPcInfo :visible="editVisible" @update:visible="handleEditVisibleChange" />
  </div>
</template>

<script setup lang="ts">
import {
  usePcInfoStore,
  pcInfoEditFormData,
  pageData,
} from "@/stores/pcInfo-store";

import { ref, onMounted } from "vue";
import type { PcInfoData } from "@/types/pcInfoTypes";

const pcInfoStore = usePcInfoStore();
const addVisible = ref(false);
const editVisible = ref(false);

const handleEdit = (item: PcInfoData) => {
  pcInfoEditFormData.value = { ...item };
  editVisible.value = true;
};

const handleAddVisibleChange = () => {
  addVisible.value = false;
};

const handleEditVisibleChange = () => {
  editVisible.value = false;
};

const onPageSizeChange = (size: number) => {
  pcInfoStore.pageSize = size;
  pcInfoStore.fetchPageData();
};

const onCurrentChange = (page: number) => {
  pcInfoStore.currentPage = page;
  pcInfoStore.fetchPageData();
};

const parseDiskList = (diskList: string | any[]): any[] => {
  if (Array.isArray(diskList)) return diskList;
  if (typeof diskList === "string") {
    try {
      return JSON.parse(diskList);
    } catch (e) {
      console.warn("磁盘信息解析失败", e);
      return [];
    }
  }
  return [];
};

onMounted(() => {
  pcInfoStore.fetchPageData();
});
</script>

<style scoped>
.pcInfo-page {
  display: flex;
  gap: 20px;
  height: 100%;
}

.pcInfo-card,
.pcInfo-table-card {
  background: #fff;
  border-radius: 18px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.pcInfo-card {
  max-width: 420px;
  min-width: 320px;
}

.pcInfo-table-card {
  flex: 1;
  min-width: 0;
}

.card-header {
  padding: 16px 20px;
  font-weight: 600;
  font-size: 17px;
  color: #1f1f1f;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 0.5px solid rgba(0, 0, 0, 0.06);
}

.card-body {
  padding: 20px;
  flex: 1;
  overflow: auto;
}

.actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.actions :deep(.el-button) {
  border-radius: 10px;
  --el-button-bg-color: #007aff;
  --el-button-border-color: #007aff;
  --el-button-hover-bg-color: #0066d6;
  --el-button-hover-border-color: #0066d6;
}

.pcInfo-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.pcInfo-item {
  padding: 14px 16px;
  background: #f9f9f9;
  border-radius: 14px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  display: flex;
  flex-direction: column;
  gap: 6px;
  transition: all 0.3s ease;
}

.pcInfo-item:hover {
  background: #f5f9ff;
  border-color: rgba(0, 122, 255, 0.15);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 122, 255, 0.08);
}

.pcInfo-title {
  font-weight: 600;
  font-size: 15px;
  color: #1f1f1f;
}

.pcInfo-content {
  font-size: 13px;
  color: #6e6e73;
  line-height: 1.5;
}

.pcInfo-footer {
  margin-top: 4px;
  text-align: right;
}

.pcInfo-footer :deep(.el-button) {
  border-radius: 8px;
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
