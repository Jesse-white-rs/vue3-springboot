<template>
  <div class="table-wrapper">
    <el-table :data="store.tableData" style="width: 100%" height="61vh"
      @selection-change="store.handleSelectionChange" class="ios-table">
      <el-table-column type="selection" width="40" />
      <el-table-column fixed prop="dAvatarpath" label="部门图" width="80">
        <template #default="scope">
          <el-avatar :size="36" :src="scope.row.dAvatarpath" />
        </template>
      </el-table-column>
      <el-table-column fixed prop="id" label="ID" sortable width="80" />
      <el-table-column fixed prop="dName" label="部门" width="150" show-overflow-tooltip>
        <template #default="scope">
          <el-tag effect="plain" round>{{ scope.row.dName }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="dTotal" label="部门人数" width="120" show-overflow-tooltip />
      <el-table-column prop="dCreatetime" label="创建日期" width="170" show-overflow-tooltip sortable>
        <template #default="scope">
          {{ formatDate(scope.row.dCreatetime) }}
        </template>
      </el-table-column>
      <el-table-column prop="dUpdatetime" label="更新日期" width="170" show-overflow-tooltip sortable>
        <template #default="scope">
          {{ formatDate(scope.row.dUpdatetime) }}
        </template>
      </el-table-column>
      <el-table-column fixed="right" label="操作" min-width="120">
        <template #default="{ row }">
          <el-button size="small" type="primary" link @click="handleEditClick(row)">修改</el-button>
          <el-button size="small" type="danger" link @click="handleDeleteClick(row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>

  <deptDataEdit :visible="editVisible" @update:visible="handleEditVisibleChange" />
  <deptDataAdd :visible="addVisible" @update:visible="handleAddVisibleChange" @userAdded="store.handlePageChange" />

  <!-- 删除确认弹窗 -->
  <Teleport to="body">
    <div v-show="confirmVisible" class="modal-overlay" @click.self="handleCancel">
      <Transition name="vp-modal">
        <div v-show="confirmVisible" class="modal-container" @click.stop>
          <div class="modal-content-wrapper">
            <div class="modal-header">
              <h3 class="modal-title">确认删除？</h3>
              <div class="modal-close" @click="handleCancel">
                <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                  <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                </svg>
              </div>
            </div>
            <div class="modal-content">
              <p class="confirm-text">此操作将不可逆，确定要删除吗？</p>
            </div>
            <div class="modal-footer">
              <div class="form-actions">
                <button type="button" class="ios-btn secondary" @click="handleCancel">取消</button>
                <button type="button" class="ios-btn danger" @click="handleDelete(delId)">确认删除</button>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </div>
  </Teleport>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import { formatDate } from "@/utils/moment";
import deptDataEdit from './deptDataEdit.vue';
import deptDataAdd from './deptDataAdd.vue';
import { useDeptStore } from "@/stores/dept-store";

const store = useDeptStore()

const delId = ref()
const confirmVisible = ref(false)

const props = defineProps<{
  addVisible: boolean;
}>();

const emit = defineEmits(['update:addVisible']);

const editVisible = ref(false);

const handleDeleteClick = (id: number) => {
  confirmVisible.value = true
  delId.value = id
}

const handleCancel = () => {
  confirmVisible.value = false
}

const handleAddVisibleChange = () => {
  emit('update:addVisible');
};
const handleEditVisibleChange = () => {
  editVisible.value = false;
}

const handleEditClick = (row: any) => {
  store.deptEditFormData = { ...row };
  editVisible.value = true;
};

const handleDelete = async (id: number) => {
  store.handleDelete(id)
  confirmVisible.value = false;
};
</script>

<style scoped>
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

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.25);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 3000;
}

.modal-container {
  position: relative;
  width: 400px;
  max-width: 90vw;
}

.modal-content-wrapper {
  background: #fff;
  border-radius: 25px;
  overflow: hidden;
  border: 0.5px solid rgba(0, 0, 0, 0.06);
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.15);
}

.modal-header {
  padding: 5px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 0.5px solid rgba(0, 0, 0, 0.06);
}

.modal-title {
  font-size: 18px;
  font-weight: 600;
  color: #1f1f1f;
}

.modal-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
  cursor: pointer;
  color: #6e6e73;
}

.modal-close:hover {
  background: rgba(255, 59, 48, 0.12);
  color: #ff3b30;
}

.modal-content {
  padding: 24px 20px;
}

.confirm-text {
  font-size: 15px;
  color: #6e6e73;
  margin: 0;
  text-align: center;
}

.modal-footer {
  padding: 16px 20px;
  border-top: 0.5px solid rgba(0, 0, 0, 0.06);
}

.form-actions {
  display: flex;
  gap: 12px;
}

.ios-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12px 24px;
  border: none;
  border-radius: 12px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.ios-btn.secondary {
  background: rgba(0, 0, 0, 0.06);
  color: #1d1d1f;
}

.ios-btn.secondary:hover {
  background: rgba(0, 0, 0, 0.1);
}

.ios-btn.danger {
  background: #ff3b30;
  color: #fff;
  box-shadow: 0 4px 12px rgba(255, 59, 48, 0.3);
}

.ios-btn.danger:hover {
  background: #e6352c;
  transform: translateY(-1px);
}

.ios-btn.danger:active {
  transform: scale(0.97);
}

.vp-modal-enter-active {
  animation: vp-modal-in 0.35s cubic-bezier(0.22, 1, 0.36, 1);
}

.vp-modal-leave-active {
  animation: vp-modal-out 0.2s ease;
}

@keyframes vp-modal-in {
  0% { transform: scale(0.95); opacity: 0; }
  100% { transform: scale(1); opacity: 1; }
}

@keyframes vp-modal-out {
  0% { transform: scale(1); opacity: 1; }
  100% { transform: scale(0.95); opacity: 0; }
}
</style>
