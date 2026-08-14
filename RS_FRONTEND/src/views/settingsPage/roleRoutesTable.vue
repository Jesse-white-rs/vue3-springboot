<template>
  <div class="roleRoute-table">
    <div class="filter-panel">
      <div class="form-row">
        <span class="filter-label">角色：</span>
        <el-select v-model="roleName" placeholder="请选择角色" clearable @change="handleChange" class="filter-select">
          <el-option v-for="item in roleStore.roleList" :key="item.rId" :value="item.rId" :label="item.rInfo" />
        </el-select>
      </div>
    </div>

    <div class="section-label">角色所对应的路由：</div>
    <div class="tags-card">
      <el-tag
        v-for="rr in roleRoutesList"
        :key="rr.id"
        :type="rr.roType == 'LINK' ? 'primary' : 'success'"
        size="default"
        closable
        @close="handleDel(rr.id, rr.roId)"
        class="route-tag"
      >
        {{ rr.roName }}
      </el-tag>
      <el-tag class="route-tag add-tag" @click="handleAdd()">
        <el-icon><Plus /></el-icon>
        添加路由
      </el-tag>
    </div>

    <!-- 添加路由弹窗 -->
    <Teleport to="body">
      <div v-show="dialogVisibleAdd" class="modal-overlay" @click.self="dialogVisibleAdd = false">
        <Transition name="vp-modal">
          <div v-show="dialogVisibleAdd" class="modal-container" @click.stop>
            <div class="modal-content-wrapper">
              <div class="modal-header">
                <h3 class="modal-title">添加路由</h3>
                <div class="modal-close" @click="dialogVisibleAdd = false">
                  <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                    <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                  </svg>
                </div>
              </div>
              <div class="modal-content">
                <el-form label-width="80px">
                  <el-form-item label="选择路由">
                    <el-select v-model="newRoleRoute.roId" placeholder="选择路由" clearable multiple style="width: 100%" popper-style="z-index: 3100">
                      <el-option v-for="item in routeStore.allRoutes" :key="item.id" :value="item.id" :label="item.alias" />
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
                <h3 class="modal-title">删除路由</h3>
                <div class="modal-close" @click="confirmVisible = false">
                  <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                    <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                  </svg>
                </div>
              </div>
              <div class="modal-content">
                <p class="confirm-text">确定要删除该路由吗？</p>
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
import { ref } from "vue";
import { ElMessage } from 'element-plus';
import { Plus } from "@element-plus/icons-vue";
import { useRoleStore } from "../../stores/role-store";
import { useRoleRouteStore } from "../../stores/roleRoute-store";
import { useRouteStore } from "../../stores/routes-store";

const roleStore = useRoleStore();
const roleRouteStore = useRoleRouteStore();
const routeStore = useRouteStore();

const roleName = ref();
const roleRoutesList = ref();
const newRoleRoute = ref({
  rId: '',
  roId: [],
});
const dialogVisibleAdd = ref(false);
const confirmVisible = ref(false);
const deleteData = ref({ id: 0, roId: 0 });

const handleChange = async () => {
  await routeStore.getAllRoutes();
  if (roleName.value == undefined) {
    roleRoutesList.value = [];
    return;
  }
  await roleRouteStore.getRoleRoutesList(roleName.value);
  roleRouteStore.roleRoutesList.forEach(rr => {
    routeStore.allRoutes.forEach(ro => {
      if (rr.roId == ro.id) {
        rr.roName = ro.alias;
        rr.roType = ro.type;
      }
    })
  })
  roleRoutesList.value = roleRouteStore.roleRoutesList;
};

const handleDel = async (id: number, roId: number) => {
  if (roId == 1) {
    ElMessage.warning('主页不能删除');
    return;
  }
  deleteData.value = { id, roId };
  confirmVisible.value = true;
};

const handleConfirmDelete = async () => {
  await roleRouteStore.deleteRoleRouteById(deleteData.value.id);
  await handleChange();
  confirmVisible.value = false;
};

const handleAdd = async () => {
  if (roleName.value == undefined) {
    ElMessage.warning('请先选择角色');
    return;
  }
  newRoleRoute.value.rId = roleName.value;
  await routeStore.getAllRoutes();
  dialogVisibleAdd.value = true;
};

const handleAddConfirm = async () => {
  await roleRouteStore.addRoleRouteItem(newRoleRoute.value.rId, newRoleRoute.value.roId).then(() => {
    dialogVisibleAdd.value = false;
    handleChange();
    newRoleRoute.value.roId = [];
  });
};
</script>

<style scoped>
.roleRoute-table {
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

.route-tag {
  cursor: pointer;
  border-radius: 10px;
  transition: all 0.3s ease;
}

.route-tag:hover {
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
