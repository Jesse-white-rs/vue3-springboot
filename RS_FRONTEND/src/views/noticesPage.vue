<template>
  <div class="notices-page">
    <!-- 左侧：已发布公告 -->
    <div class="notice-card">
      <div class="card-header">
        <div class="card-title">
          <el-icon :size="18"><Bell /></el-icon>
          <span>已发布公告</span>
        </div>
        <div class="card-actions">
          <el-tooltip content="新增一条公告" placement="top">
            <div class="action-btn" @click="handleAddVisibleChange">
              <el-icon :size="16"><Plus /></el-icon>
            </div>
          </el-tooltip>
          <el-popconfirm
            title="确定要删除24小时之前的公告吗？"
            confirm-button-text="确认"
            cancel-button-text="取消"
            @confirm="deleteExpiredNoticesData"
          >
            <template #reference>
              <div class="action-btn danger">
                <el-icon :size="16"><Delete /></el-icon>
              </div>
            </template>
          </el-popconfirm>
        </div>
      </div>
      <div class="card-body">
        <div class="notice-list" v-if="noticesDataPublished.length > 0">
          <div class="notice-item" v-for="(message, index) in noticesDataPublished" :key="index">
            <div class="notice-item-header">
              <span class="notice-item-title">{{ message.header }}</span>
              <span class="notice-item-time">{{ formatDate(message.createtime || '') }}</span>
            </div>
            <div class="notice-item-content">{{ message.content }}</div>
          </div>
        </div>
        <div class="empty-state" v-else>
          <el-icon :size="40" color="#d1d1d6"><Bell /></el-icon>
          <p>暂无公告</p>
        </div>
      </div>
    </div>

    <!-- 右侧：所有公告 -->
    <div class="notice-table-card">
      <div class="card-header">
        <div class="card-title">
          <el-icon :size="18"><List /></el-icon>
          <span>所有公告</span>
        </div>
        <div class="card-actions">
          <el-tooltip content="新增一条公告" placement="top">
            <div class="action-btn" @click="handleAddVisibleChange">
              <el-icon :size="16"><Plus /></el-icon>
            </div>
          </el-tooltip>
          <el-tooltip content="删除选中的公告" placement="top">
            <div class="action-btn danger" @click="noticesStore.deleteSelectedData()">
              <el-icon :size="16"><Delete /></el-icon>
            </div>
          </el-tooltip>
        </div>
      </div>
      <div class="card-body">
        <div class="table-search-bar">
          <el-input
            v-model="noticesStore.search"
            placeholder="搜索公告..."
            clearable
            class="search-input"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
        </div>
        <div class="table-wrapper">
          <el-table
            :data="filterTableData"
            @selection-change="noticesStore.handleSelectionChange"
      
            class="ios-table"
          >
            <el-table-column type="selection" width="40" />
            <el-table-column prop="header" label="标题" min-width="140" show-overflow-tooltip />
            <el-table-column prop="content" label="内容" min-width="180" show-overflow-tooltip />
            <el-table-column prop="createtime" label="创建时间" width="120" sortable>
              <template #default="scope">
                {{ formatDate(scope.row.createtime) }}
              </template>
            </el-table-column>
            <el-table-column prop="updatetime" label="更新时间" width="120" sortable>
              <template #default="scope">
                {{ formatDate(scope.row.updatetime) }}
              </template>
            </el-table-column>
            <el-table-column prop="status" label="状态" width="90" :filters="[
              { text: '已发布', value: 1 },
              { text: '未发布', value: 0 },
            ]"
              :filter-method="(value: number, row: NoticesData) => row.status === value"
              filter-placement="bottom-end">
              <template #default="scope">
                <el-tag :type="scope.row.status == 1 ? 'success' : 'info'" size="small" round>
                  {{ scope.row.status == 1 ? '已发布' : '未发布' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="author" label="作者" width="80" show-overflow-tooltip />
            <el-table-column fixed="right" width="140">
              <template #default="scope">
                <el-button size="small" type="primary" link @click="handleEdit(scope.row)">编辑</el-button>
                <el-button size="small" type="danger" link @click="noticesStore.deleteData([scope.row.id])">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
        <div class="pagination-wrapper">
          <el-pagination
            v-model:current-page="noticesStore.currentPage"
            v-model:page-size="noticesStore.pageSize"
            :total="noticesStore.data.length"
            :page-sizes="[10, 20, 50]"
            layout="total, sizes, prev, pager, next"
            background
            small
            @size-change="onPageSizeChange"
            @current-change="onCurrentChange"
          />
        </div>
      </div>
    </div>

    <addNotice :visible="addVisible" @update:visible="handleAddVisibleChange" />
    <editNotice :visible="editVisible" @update:visible="handleEditVisibleChange" />
  </div>
</template>

<script setup lang="ts">
import { useNoticesStore, noticeEditFormData, deleteExpiredNoticesData, noticesDataPublished, filterTableData } from '@/stores/notices-store';
import { formatDate } from '@/utils/moment';
import addNotice from './noticesPage/addNotice.vue';
import editNotice from './noticesPage/editNotice.vue';
import { ref, onMounted } from 'vue';
import type { NoticesData } from '@/types/noticesTypes';
import { Bell, Plus, Delete, List, Search } from '@element-plus/icons-vue';

const noticesStore = useNoticesStore();
const addVisible = ref(false);
const editVisible = ref(false);

const handleAddVisibleChange = () => {
  addVisible.value = !addVisible.value;
};

const handleEditVisibleChange = () => {
  editVisible.value = !editVisible.value;
};

const handleEdit = (row: NoticesData) => {
  noticeEditFormData.value = row;
  handleEditVisibleChange();
};

const onPageSizeChange = (pageSize: number) => {
  noticesStore.pageSize = pageSize;
  noticesStore.fetchPageData();
};

const onCurrentChange = (page: number) => {
  noticesStore.currentPage = page;
  noticesStore.fetchPageData();
};

onMounted(() => {
  noticesStore.fetchPageData();
});
</script>

<style scoped>
.notices-page {
  display: flex;
  gap: 20px;
  height: 80vh;
}

.notice-card,
.notice-table-card {
  background: #fff;
  border-radius: 18px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  height: 100%;
}

.notice-card {
  max-width: 400px;
  min-width: 320px;
}

.notice-table-card {
  min-width: 0;
  flex: 1;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 24px;
  border-bottom: 0.5px solid rgba(0, 0, 0, 0.06);
}

.card-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 600;
  color: #1d1d1f;
}

.card-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 10px;
  background: rgba(0, 0, 0, 0.04);
  color: #6e6e73;
  cursor: pointer;
  transition: all 0.2s ease;
}

.action-btn:hover {
  background: rgba(0, 122, 255, 0.1);
  color: #007aff;
}

.action-btn:active {
  transform: scale(0.95);
}

.action-btn.danger:hover {
  background: rgba(255, 59, 48, 0.1);
  color: #ff3b30;
}

.card-body {
  padding: 20px;
  flex: 1;
  min-height: 0;
  overflow: auto;
}

/* 已发布公告列表 */
.notice-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-height: 65vh;
  overflow-y: auto;
}

.notice-item {
  background: #f9f9f9;
  border-radius: 14px;
  padding: 16px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  transition: all 0.2s ease;
}

.notice-item:hover {
  background: #f3f3f3;
}

.notice-item-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
  margin-bottom: 8px;
}

.notice-item-title {
  font-size: 14px;
  font-weight: 600;
  color: #1d1d1f;
}

.notice-item-time {
  font-size: 12px;
  color: #aeaeb2;
  white-space: nowrap;
  flex-shrink: 0;
}

.notice-item-content {
  font-size: 13px;
  color: #6e6e73;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  gap: 12px;
}

.empty-state p {
  font-size: 14px;
  color: #aeaeb2;
  margin: 0;
}

/* 搜索栏 */
.table-search-bar {
  margin-bottom: 16px;
}

.search-input {
  width: 240px;
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 12px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06) !important;
}

.search-input :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2) !important;
}

.search-input :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2) !important;
}

/* 表格 */
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
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.ios-table :deep(.el-table__row td) {
  border-bottom-color: rgba(0, 0, 0, 0.04);
}

.ios-table :deep(.el-table__row:hover > td) {
  background: #f5f9ff !important;
}

/* 分页 */
.pagination-wrapper {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}
</style>
