<template>
  <Teleport to="body">
    <div v-show="props.visible" class="modal-overlay" @click.self="handleCancel">
      <Transition name="vp-modal">
        <div v-show="props.visible" class="modal-container" @click.stop>
          <div class="modal-content-wrapper">
            <div class="modal-header">
              <h3 class="modal-title">编辑用户</h3>
              <div class="modal-close" @click="handleCancel">
                <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                  <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                </svg>
              </div>
            </div>
            <div class="modal-content">
              <div class="avatar-section">
                <div class="avatar-preview" @click="triggerUpload">
                  <img v-if="avatarUrl" :src="avatarUrl" alt="avatar" />
                  <div v-else class="avatar-placeholder">
                    <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                      <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                      <circle cx="12" cy="7" r="4"/>
                    </svg>
                  </div>
                </div>
                <input ref="uploadRef" type="file" accept="image/*" @change="handleFileChange" style="display:none" />
              </div>
              <el-form :model="store.userDataFormData" :rules="store.USERDATA_FORM_RULES" label-width="80px">
                <el-form-item label="姓名" prop="eName">
                  <el-input v-model="store.userDataFormData.emp.eName" />
                </el-form-item>
                <el-form-item label="账号" prop="eUsername">
                  <el-input v-model="store.userDataFormData.emp.eUsername" />
                </el-form-item>
                <el-form-item label="密码" prop="ePassword">
                  <el-input v-model="store.userDataFormData.emp.ePassword" type="password" show-password />
                </el-form-item>
                <el-form-item label="手机号" prop="ePhone">
                  <el-input v-model="store.userDataFormData.emp.ePhone" />
                </el-form-item>
                <el-form-item label="证件号" prop="eId">
                  <el-input v-model="store.userDataFormData.emp.eId" />
                </el-form-item>
                <el-form-item label="年龄" prop="eAge">
                  <el-input v-model="store.userDataFormData.emp.eAge" />
                </el-form-item>
                <el-form-item label="性别" prop="eGender">
                  <el-radio-group v-model="store.userDataFormData.emp.eGender">
                    <el-radio value="1">男</el-radio>
                    <el-radio value="0">女</el-radio>
                  </el-radio-group>
                </el-form-item>
                <el-form-item label="状态" prop="eIsenabled">
                  <el-radio-group v-model="store.userDataFormData.emp.eIsenabled">
                    <el-radio value="1">启用</el-radio>
                    <el-radio value="0">禁用</el-radio>
                  </el-radio-group>
                </el-form-item>
                <el-form-item label="部门" prop="eDeptid">
                  <el-select v-model="store.userDataFormData.emp.eDeptid" placeholder="请选择部门" popper-style="z-index: 3100">
                    <el-option v-for="item in deptStore.tableData" :key="item.id" :value="item.id" :label="item.dName" />
                  </el-select>
                </el-form-item>
                <el-form-item label="角色" prop="rId">
                  <el-select v-model="store.userDataFormData.role.rId" placeholder="请选择角色" popper-style="z-index: 3100">
                    <el-option v-for="item in roleStore.roleList" :key="item.rId" :value="item.rId" :label="item.rInfo" />
                  </el-select>
                </el-form-item>
              </el-form>
            </div>
            <div class="modal-footer">
              <div class="form-actions">
                <button type="button" class="ios-btn secondary" @click="handleCancel">取消</button>
                <button type="button" class="ios-btn primary" @click="handleConfirm">确认修改</button>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </div>
  </Teleport>
</template>

<script lang="ts" setup>
import { ref, computed, watch } from 'vue';
import { useUserStore } from "@/stores/user-store";
import { useDeptStore } from '@/stores/dept-store';
import { useRoleStore } from '@/stores/role-store';

const store = useUserStore();
const deptStore = useDeptStore();
const roleStore = useRoleStore();

const props = defineProps<{
  visible: boolean;
}>();

const emit = defineEmits(['update:visible']);

const uploadRef = ref<HTMLInputElement>();
const avatarUrl = computed(() => store.avatarUrl);

watch(() => props.visible, (visible) => {
  if (visible) {
    store.avatarUrl = store.userDataFormData.emp.eAvatarpath;
    store.file1 = undefined;
    deptStore.getAllDeptData();
    roleStore.getRoleListAll();
  }
});

const triggerUpload = () => {
  uploadRef.value?.click();
};

const handleFileChange = (e: Event) => {
  const file = (e.target as HTMLInputElement).files?.[0];
  if (file) {
    store.file1 = file;
    const reader = new FileReader();
    reader.onload = (ev) => {
      store.avatarUrl = ev.target?.result as string;
    };
    reader.readAsDataURL(file);
  }
};

const handleCancel = () => {
  emit('update:visible');
};

const handleConfirm = () => {
  store.handleUpdateUser();
  emit('update:visible');
};
</script>

<style scoped>
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
  width: 520px;
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
  max-height: 65vh;
  overflow-y: auto;
}

.avatar-section {
  display: flex;
  justify-content: center;
  margin-bottom: 24px;
}

.avatar-preview {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  background: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  overflow: hidden;
  transition: all 0.3s ease;
  border: 2px solid rgba(0, 122, 255, 0.15);
}

.avatar-preview:hover {
  transform: scale(1.05);
  border-color: rgba(0, 122, 255, 0.3);
}

.avatar-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-placeholder {
  color: #c7c7cc;
}

.modal-content :deep(.el-form-item) {
  margin-bottom: 18px;
}

.modal-content :deep(.el-input__wrapper),
.modal-content :deep(.el-select__wrapper) {
  border-radius: 10px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06);
}

.modal-content :deep(.el-input__wrapper:hover),
.modal-content :deep(.el-select__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2);
}

.modal-content :deep(.el-input__wrapper.is-focus),
.modal-content :deep(.el-select__wrapper.is-focused) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2);
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
