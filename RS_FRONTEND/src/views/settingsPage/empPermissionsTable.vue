<template>
  <div class="empPermission-table">
    <div class="filter-panel">
      <div class="form-row">
        <span class="filter-label">用户：</span>
        <el-select v-model="empName" placeholder="请选择用户" clearable @change="handleChange" class="filter-select">
          <el-option v-for="item in empStore.tableData" :key="item.emp.id" :value="item.emp.id" :label="item.emp.eName" />
        </el-select>
      </div>
    </div>

    <div class="section-label">用户所对应的权限：</div>
    <div class="tags-card">
      <el-tag
        v-for="ep in empPermissionList"
        :key="ep.id"
        size="default"
        closable
        @close="handleDel(ep.id, ep.mId)"
        class="perm-tag"
      >
        {{ ep.mName }}
      </el-tag>
      <el-tag class="perm-tag add-tag" @click="handleAdd()">
        <el-icon><Plus /></el-icon>
        添加权限
      </el-tag>
    </div>

    <!-- 添加权限弹窗 -->
    <Teleport to="body">
      <div v-show="dialogVisibleAdd" class="modal-overlay" @click.self="dialogVisibleAdd = false">
        <Transition name="vp-modal">
          <div v-show="dialogVisibleAdd" class="modal-container" @click.stop>
            <div class="modal-content-wrapper">
              <div class="modal-header">
                <h3 class="modal-title">添加权限</h3>
                <div class="modal-close" @click="dialogVisibleAdd = false">
                  <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                    <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                  </svg>
                </div>
              </div>
              <div class="modal-content">
                <el-form label-width="80px">
                  <el-form-item label="选择权限">
                    <el-select v-model="newEmpPermission.mId" placeholder="选择权限" clearable multiple style="width: 100%" popper-style="z-index: 3100">
                      <el-option v-for="item in permissionStore.allPermissions" :key="item.mId" :value="item.mId" :label="item.mName" />
                    </el-select>
                  </el-form-item>
                </el-form>
              </div>
              <div class="modal-footer">
                <div class="form-actions">
                  <button type="button" class="ios-btn secondary" @click="dialogVisibleAdd = false">取消</button>
                  <button type="button" class="ios-btn primary" @click="handleAddConfirm">确认添加</button>
                </div>
              </div>
            </div>
          </div>
        </Transition>
      </div>
    </Teleport>

    <!-- 删除确认弹窗 -->
    <Teleport to="body">
      <div v-show="confirmVisible" class="modal-overlay" @click.self="confirmVisible = false">
        <Transition name="vp-modal">
          <div v-show="confirmVisible" class="modal-container modal-small" @click.stop>
            <div class="modal-content-wrapper">
              <div class="modal-header">
                <h3 class="modal-title">删除权限</h3>
                <div class="modal-close" @click="confirmVisible = false">
                  <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                    <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                  </svg>
                </div>
              </div>
              <div class="modal-content">
                <p class="confirm-text">确定要删除该权限吗？</p>
              </div>
              <div class="modal-footer">
                <div class="form-actions">
                  <button type="button" class="ios-btn secondary" @click="confirmVisible = false">取消</button>
                  <button type="button" class="ios-btn danger" @click="handleConfirmDelete">确认删除</button>
                </div>
              </div>
            </div>
          </div>
        </Transition>
      </div>
    </Teleport>
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from "vue";
import { ElMessage } from 'element-plus';
import { Plus } from "@element-plus/icons-vue";
import { usePermissionStore } from "../../stores/permissions-store";
import { useEmpPermissionStore } from "../../stores/empPermission-store";
import { useUserStore } from "../../stores/user-store";

const empPermissionStore = useEmpPermissionStore();
const permissionStore = usePermissionStore();
const empStore = useUserStore();

const empName = ref();
const empPermissionList = ref();
const newEmpPermission = ref({
  eId: '',
  mId: [],
});
const dialogVisibleAdd = ref(false);
const confirmVisible = ref(false);
const deleteId = ref<number>(0);

const handleChange = async () => {
  await permissionStore.getAllPermissions();
  if (empName.value == undefined) {
    empPermissionList.value = [];
    return;
  }
  await empPermissionStore.getEmpPermissionList(empName.value);
  empPermissionStore.empPermissionList.forEach((ep: any) => {
    permissionStore.allPermissions.forEach((p: any) => {
      if (ep.mId == p.mId) {
        ep.mName = p.mName;
      }
    })
  })
  empPermissionList.value = empPermissionStore.empPermissionList;
};

const handleDel = async (id: number, mId: number) => {
  deleteId.value = id;
  confirmVisible.value = true;
};

const handleConfirmDelete = async () => {
  await empPermissionStore.deleteEmpPermissionById(deleteId.value);
  await handleChange();
  confirmVisible.value = false;
};

const handleAdd = async () => {
  if (empName.value == undefined) {
    ElMessage.warning('请先选择用户');
    return;
  }
  newEmpPermission.value.eId = empName.value;
  await permissionStore.getAllPermissions();
  dialogVisibleAdd.value = true;
};

const handleAddConfirm = async () => {
  await empPermissionStore.addEmpPermissionItem(newEmpPermission.value.eId, newEmpPermission.value.mId).then(() => {
    dialogVisibleAdd.value = false;
    handleChange();
    newEmpPermission.value.mId = [];
  });
};

onMounted(() => {
  empStore.getAllUserData();
});
</script>

<style scoped>
.empPermission-table {
  padding: 10px 0;
}

.filter-panel {
  margin-bottom: 16px;
}

.form-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-label {
  font-size: 14px;
  color: #6e6e73;
  white-space: nowrap;
}

.filter-select {
  width: 180px;
}

.form-row :deep(.el-select__wrapper) {
  border-radius: 10px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06);
}

.form-row :deep(.el-select__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2);
}

.form-row :deep(.el-select__wrapper.is-focused) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2);
}

.section-label {
  font-size: 14px;
  color: #6e6e73;
  margin-bottom: 12px;
}

.tags-card {
  background: #f9f9f9;
  border-radius: 14px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  padding: 16px;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.perm-tag {
  cursor: pointer;
  border-radius: 10px;
  transition: all 0.3s ease;
}

.perm-tag:hover {
  transform: translateY(-2px);
}

.add-tag {
  background: #fff;
  border-color: #dcdfe6;
  color: #606266;
}

.add-tag:hover {
  background: #eaf4ff;
  border-color: #007aff;
  color: #007aff;
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
  width: 480px;
  max-width: 90vw;
}

.modal-small {
  width: 360px;
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

.modal-content :deep(.el-form-item) {
  margin-bottom: 18px;
}

.modal-content :deep(.el-select__wrapper) {
  border-radius: 10px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06);
}

.modal-content :deep(.el-select__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2);
}

.modal-content :deep(.el-select__wrapper.is-focused) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2);
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

.ios-btn.primary {
  background: #007aff;
  color: #fff;
  box-shadow: 0 4px 12px rgba(0, 122, 255, 0.3);
}

.ios-btn.primary:hover {
  background: #0066d6;
  transform: translateY(-1px);
}

.ios-btn.primary:active {
  transform: scale(0.97);
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
