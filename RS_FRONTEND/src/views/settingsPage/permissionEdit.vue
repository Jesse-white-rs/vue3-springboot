<template>
  <Teleport to="body">
    <div v-show="props.visible" class="modal-overlay" @click.self="handleCancel">
      <Transition name="vp-modal">
        <div v-show="props.visible" class="modal-container" @click.stop>
          <div class="modal-content-wrapper">
            <div class="modal-header">
              <h3 class="modal-title">编辑权限</h3>
              <div class="modal-close" @click="handleCancel">
                <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                  <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                </svg>
              </div>
            </div>
            <div class="modal-content">
              <el-form ref="formRef" :model="store.permissionEditFormData" :rules="store.PERMISSION_EDIT_FORM_RULES" label-width="80px">
                <el-form-item label="权限ID" prop="mId">
                  <el-input v-model="store.permissionEditFormData.mId" disabled />
                </el-form-item>
                <el-form-item label="权限名" prop="mName">
                  <el-input v-model="store.permissionEditFormData.mName" />
                </el-form-item>
                <el-form-item label="地址值" prop="mUrl">
                  <el-input v-model="store.permissionEditFormData.mUrl" />
                </el-form-item>
                <el-form-item label="权限标志" prop="mSign">
                  <el-input v-model="store.permissionEditFormData.mSign" />
                </el-form-item>
              </el-form>
            </div>
            <div class="modal-footer">
              <div class="form-actions">
                <button type="button" class="ios-btn secondary" @click="handleCancel">取消</button>
                <button type="button" class="ios-btn primary" @click="handleSubmit">确认修改</button>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </div>
  </Teleport>
</template>

<script lang="ts" setup>
import { usePermissionStore } from '@/stores/permissions-store';
import { ref } from 'vue';
import { ElMessage } from 'element-plus';
import type { FormInstance } from 'element-plus';

const formRef = ref<FormInstance>();
const store = usePermissionStore();

const props = defineProps<{
  visible: boolean;
}>();

const emit = defineEmits(['update:visible', 'permissionEdited']);

const handleCancel = () => {
  emit('update:visible');
};

const handleSubmit = async () => {
  if (!formRef.value) return;
  await formRef.value.validate(async (valid) => {
    if (valid) {
      await store.updatePermissions(store.permissionEditFormData).then(() => {
        emit('permissionEdited');
        formRef.value?.resetFields();
      });
    }
  });
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
  width: 480px;
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
