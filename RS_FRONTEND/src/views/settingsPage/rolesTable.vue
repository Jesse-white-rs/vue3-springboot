<template>
  <div class="roles-table">
    <div class="role-tags">
      <span class="role-label">当前角色：</span>
      <div class="tags-wrapper">
        <el-tag
          v-for="role in store.roleList"
          :key="role.rId"
          :type="role.rId == 1 ? 'danger' : role.rId == 2 ? 'warning' : 'primary'"
          size="large"
          closable
          @close="handleDel(role.rId)"
          @click="handleEdit(role)"
          class="role-tag"
        >
          {{ role.rInfo }}
        </el-tag>
        <el-tag size="large" class="role-tag add-tag" @click="handleAdd()">
          <el-icon><Plus /></el-icon>
          添加角色
        </el-tag>
      </div>
    </div>

    <!-- 添加角色弹窗 -->
    <Teleport to="body">
      <div v-show="dialogVisibleAdd" class="modal-overlay" @click.self="dialogVisibleAdd = false">
        <Transition name="vp-modal">
          <div v-show="dialogVisibleAdd" class="modal-container" @click.stop>
            <div class="modal-content-wrapper">
              <div class="modal-header">
                <h3 class="modal-title">添加角色</h3>
                <div class="modal-close" @click="dialogVisibleAdd = false">
                  <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                    <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                  </svg>
                </div>
              </div>
              <div class="modal-content">
                <el-form label-width="80px">
                  <el-form-item label="角色代号">
                    <el-input v-model="newRole.rName" placeholder="请输入角色代号" clearable />
                  </el-form-item>
                  <el-form-item label="角色名称">
                    <el-input v-model="newRole.rInfo" placeholder="请输入角色名称" clearable />
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

    <!-- 编辑角色弹窗 -->
    <Teleport to="body">
      <div v-show="dialogVisibleEdit" class="modal-overlay" @click.self="dialogVisibleEdit = false">
        <Transition name="vp-modal">
          <div v-show="dialogVisibleEdit" class="modal-container" @click.stop>
            <div class="modal-content-wrapper">
              <div class="modal-header">
                <h3 class="modal-title">编辑角色</h3>
                <div class="modal-close" @click="dialogVisibleEdit = false">
                  <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                    <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                  </svg>
                </div>
              </div>
              <div class="modal-content">
                <el-form label-width="80px">
                  <el-form-item label="角色ID">
                    <el-input v-model="editRole.rId" disabled />
                  </el-form-item>
                  <el-form-item label="角色代号">
                    <el-input v-model="editRole.rName" placeholder="请输入角色代号" />
                  </el-form-item>
                  <el-form-item label="角色名称">
                    <el-input v-model="editRole.rInfo" placeholder="请输入角色名称" />
                  </el-form-item>
                </el-form>
              </div>
              <div class="modal-footer">
                <div class="form-actions">
                  <button type="button" class="ios-btn secondary" @click="dialogVisibleEdit = false">取消</button>
                  <button type="button" class="ios-btn primary" @click="handleEditConfirm">确认修改</button>
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
                <h3 class="modal-title">警告</h3>
                <div class="modal-close" @click="confirmVisible = false">
                  <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                    <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                  </svg>
                </div>
              </div>
              <div class="modal-content">
                <p class="confirm-text">你确定删除该角色?</p>
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
import { useRoleStore } from "@/stores/role-store";
import { ElMessage } from 'element-plus';
import { Plus } from "@element-plus/icons-vue";

const store = useRoleStore();
const dialogVisibleAdd = ref(false);
const dialogVisibleEdit = ref(false);
const confirmVisible = ref(false);
const deleteRoleId = ref<any>(null);

const editRole = ref({
  rInfo: '',
  rName: '',
  rId: ''
});

const newRole = ref({
  rInfo: '',
  rName: ''
});

const handleDel = (id: any) => {
  if (id == 1) {
    ElMessage.warning('超级管理员角色不能删除');
    return;
  }
  if (id == 2) {
    ElMessage.warning('管理员角色不能删除');
    return;
  }
  deleteRoleId.value = id;
  confirmVisible.value = true;
};

const handleConfirmDelete = async () => {
  await store.deleteRoleItem(deleteRoleId.value);
  confirmVisible.value = false;
};

const handleAdd = () => {
  dialogVisibleAdd.value = true;
};

const handleAddConfirm = async () => {
  await store.addRoleItem(newRole.value).then(() => {
    dialogVisibleAdd.value = false;
    newRole.value = { rName: '', rInfo: '' };
  });
};

const handleEdit = (role: any) => {
  editRole.value = { ...role };
  dialogVisibleEdit.value = true;
};

const handleEditConfirm = async () => {
  await store.editRoleItem(editRole.value);
  dialogVisibleEdit.value = false;
  store.getRoleListAll();
};

onMounted(() => {
  store.getRoleListAll();
});
</script>

<style scoped>
.roles-table {
  padding: 10px 0;
}

.role-tags {
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

.role-label {
  font-size: 14px;
  color: #6e6e73;
  white-space: nowrap;
  line-height: 36px;
}

.tags-wrapper {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.role-tag {
  cursor: pointer;
  border-radius: 10px;
  transition: all 0.3s ease;
}

.role-tag:hover {
  transform: translateY(-2px);
}

.add-tag {
  background: #f5f5f5;
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
  width: 420px;
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

.modal-content :deep(.el-input__wrapper) {
  border-radius: 10px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06);
}

.modal-content :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2);
}

.modal-content :deep(.el-input__wrapper.is-focus) {
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
