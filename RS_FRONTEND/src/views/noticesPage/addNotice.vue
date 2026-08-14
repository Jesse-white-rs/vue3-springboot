<template>
  <Teleport to="body">
    <div v-show="visible" class="modal-overlay" @click.self="handleClose">
      <Transition name="vp-modal">
        <div v-show="visible" class="modal-container" @click.stop>
          <div class="modal-content-wrapper">
            <div class="modal-header">
              <h3 class="modal-title">添加新公告</h3>
              <div class="modal-close" @click="handleClose">
                <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                  <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                </svg>
              </div>
            </div>
            <div class="modal-content">
              <el-form
                ref="formRef"
                :model="noticeAddFormData"
                :rules="formRules"
                label-position="top"
                class="ios-form"
              >
                <el-form-item label="标题" prop="header">
                  <el-input
                    v-model="noticeAddFormData.header"
                    placeholder="请输入标题"
                    size="large"
                    class="ios-input"
                  />
                </el-form-item>
                <el-form-item label="作者" prop="author">
                  <el-input
                    v-model="noticeAddFormData.author"
                    placeholder="请输入作者"
                    size="large"
                    class="ios-input"
                  />
                </el-form-item>
                <el-form-item label="状态" prop="status">
                  <el-select
                    v-model="noticeAddFormData.status"
                    placeholder="请选择状态"
                    size="large"
                    class="ios-select"
                    popper-style="z-index: 3100"
                  >
                    <el-option
                      v-for="item in noticeStatusOptions"
                      :key="item.value"
                      :label="item.label"
                      :value="item.value"
                    />
                  </el-select>
                </el-form-item>
                <el-form-item label="内容" prop="content">
                  <el-input
                    v-model="noticeAddFormData.content"
                    type="textarea"
                    placeholder="请输入公告内容"
                    :autosize="{ minRows: 4, maxRows: 12 }"
                    class="ios-textarea"
                  />
                </el-form-item>
              </el-form>
            </div>
            <div class="modal-footer">
              <div class="form-actions">
                <button type="button" class="ios-btn secondary" @click="handleClose">取消</button>
                <button type="button" class="ios-btn primary" @click="handleSubmit">提交</button>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </div>
  </Teleport>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';
import { useNoticesStore, noticeAddFormData } from '@/stores/notices-store';
import { noticeStatusOptions } from '@/types/noticesTypes';
import { ElMessage } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';

const store = useNoticesStore();
const formRef = ref<FormInstance>();

const props = defineProps<{
  visible: boolean;
}>();

const emit = defineEmits(['update:visible']);

const formRules: FormRules = {
  header: [{ required: true, message: '标题必填', trigger: 'blur' }],
  content: [{ required: true, message: '内容必填', trigger: 'blur' }],
  author: [{ required: true, message: '请输入作者', trigger: 'blur' }],
  status: [{ required: true, message: '请选择状态', trigger: 'change' }],
};

const handleClose = () => {
  formRef.value?.resetFields();
  emit('update:visible');
};

const handleSubmit = async () => {
  if (!formRef.value) return;
  await formRef.value.validate(async (valid) => {
    if (valid) {
      await store.addData(noticeAddFormData.value);
      formRef.value?.resetFields();
      emit('update:visible');
    }
  });
};

watch(() => props.visible, (val) => {
  if (val) {
    document.body.style.overflow = 'hidden';
  } else {
    document.body.style.overflow = '';
  }
});
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
  max-height: 85vh;
}

.modal-content-wrapper {
  background: #fff;
  border-radius: 25px;
  overflow: hidden;
  border: 0.5px solid rgba(0, 0, 0, 0.06);
  box-shadow:
    0 24px 80px rgba(0, 0, 0, 0.15),
    0 8px 24px rgba(0, 0, 0, 0.06);
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
  transform: scale(1.1);
}

.modal-content {
  padding: 20px;
  overflow-y: auto;
  max-height: 60vh;
  scrollbar-width: thin;
  scrollbar-color: rgba(187, 187, 187, 0.4) transparent;
}

.modal-content::-webkit-scrollbar {
  width: 6px;
}

.modal-content::-webkit-scrollbar-track {
  background: transparent;
  border-radius: 3px;
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
  padding: 14px 24px;
  border: none;
  border-radius: 14px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.ios-btn.primary {
  background: #007aff;
  color: #fff;
  box-shadow: 0 4px 16px rgba(0, 122, 255, 0.3);
}

.ios-btn.primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 24px rgba(0, 122, 255, 0.4);
}

.ios-btn.primary:active {
  transform: scale(0.97);
}

.ios-btn.secondary {
  background: rgba(0, 0, 0, 0.06);
  color: #1d1d1f;
}

.ios-btn.secondary:hover {
  background: rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.ios-btn.secondary:active {
  transform: translateY(0) scale(0.98);
}

/* 表单 */
.ios-form :deep(.el-form-item__label) {
  font-size: 13px;
  font-weight: 600;
  color: #8e8e93;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding-bottom: 6px !important;
}

.ios-input :deep(.el-input__wrapper) {
  border-radius: 12px !important;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.08) !important;
  background: #f5f5f5 !important;
  transition: all 0.3s ease !important;
  padding: 4px 14px !important;
}

.ios-input :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2) !important;
}

.ios-input :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.3) !important;
  background: #fff !important;
}

.ios-select :deep(.el-select__wrapper) {
  border-radius: 12px !important;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.08) !important;
  background: #f5f5f5 !important;
  transition: all 0.3s ease !important;
  padding: 4px 14px !important;
}

.ios-select :deep(.el-select__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2) !important;
}

.ios-select :deep(.el-select__wrapper.is-focused) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.3) !important;
  background: #fff !important;
}

.ios-textarea :deep(.el-textarea__inner) {
  border-radius: 12px !important;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.08) !important;
  background: #f5f5f5 !important;
  transition: all 0.3s ease !important;
  padding: 12px 14px !important;
}

.ios-textarea :deep(.el-textarea__inner:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2) !important;
}

.ios-textarea :deep(.el-textarea__inner:focus) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.3) !important;
  background: #fff !important;
}

/* 动画 */
.vp-modal-enter-active {
  animation: vp-modal-in 0.35s cubic-bezier(0.22, 1, 0.36, 1);
}

.vp-modal-leave-active {
  animation: vp-modal-out 0.3s cubic-bezier(0.4, 0, 0.6, 1);
  transform-origin: center;
}

@keyframes vp-modal-in {
  0% {
    transform: translateY(20px) scale(0.95);
    opacity: 0;
  }
  100% {
    transform: translateY(0) scale(1);
    opacity: 1;
  }
}

@keyframes vp-modal-out {
  0% {
    transform: translateY(0) scale(1);
    opacity: 1;
  }
  100% {
    transform: translateY(-10px) scale(0.95);
    opacity: 0;
  }
}
</style>
