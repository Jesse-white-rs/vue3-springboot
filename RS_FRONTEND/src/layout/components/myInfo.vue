<template>
  <Teleport to="body">
    <div v-show="homeStore.myInfoVisible" class="modal-overlay" @click.self="homeStore.myInfoVisible = false">
      <Transition name="vp-modal">
        <div v-show="homeStore.myInfoVisible" class="modal-container" @click.stop>
          <div class="modal-content-wrapper">
            <div class="modal-header">
              <h3 class="modal-title">{{ mode === 'view' ? '个人中心' : '修改资料' }}</h3>
              <div class="modal-close" @click="homeStore.myInfoVisible = false">
                <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                  <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                </svg>
              </div>
            </div>

            <div class="modal-content">
              <!-- 查看模式 -->
              <template v-if="mode === 'view'">
                <div class="profile-card">
                  <div class="avatar-section">
                    <div class="avatar-wrapper">
                      <el-avatar :size="88" :src="userStore.myData.emp.eAvatarpath" class="avatar" />
                    </div>
                  </div>
                  <div class="profile-info">
                    <div class="greeting">
                      <span class="user-name">{{ userStore.myData.emp.eName }},</span>
                      <span class="welcome-text">欢迎回来~</span>
                    </div>
                    <div class="detail-grid">
                      <div class="detail-item">
                        <span class="detail-label">ID</span>
                        <span class="detail-value">{{ userStore.myData.emp.id }}</span>
                      </div>
                      <div class="detail-item">
                        <span class="detail-label">部门</span>
                        <span class="detail-value">{{ userStore.myData.qywxDepartment.name }}</span>
                      </div>
                      <div class="detail-item">
                        <span class="detail-label">角色</span>
                        <span class="detail-value">{{ userStore.myData.role.rInfo }}</span>
                      </div>
                      <div class="detail-item highlight">
                        <span class="detail-label">🎀 来这已</span>
                        <span class="detail-value days">{{ calculateDays(userStore.myData.emp.eCreatetime || '') }}天</span>
                      </div>
                    </div>
                  </div>
                </div>
              </template>

              <!-- 编辑模式 -->
              <template v-else>
                <div class="edit-form">
                  <div class="avatar-upload-section">
                    <div class="upload-label">头像</div>
                    <div class="upload-area">
                      <el-upload
                        class="avatar-uploader"
                        :action="userStore.avatarUrl"
                        :show-file-list="false"
                        :on-success="userStore.myInfoEditHandleSuccess"
                        :on-error="userStore.handleFail"
                        accept="image/*"
                      >
                        <div class="upload-preview" v-if="userStore.file1 && userStore.file1.length > 0">
                          <img :src="userStore.file1[0]?.url" class="preview-img" />
                          <div class="upload-overlay">
                            <el-icon :size="20"><RefreshRight /></el-icon>
                          </div>
                        </div>
                        <div class="upload-placeholder" v-else>
                          <el-icon :size="28" class="upload-icon"><Plus /></el-icon>
                          <span class="upload-text">选择图片</span>
                        </div>
                      </el-upload>
                      <div class="upload-hint">上传头像大小不超过5500KB</div>
                    </div>
                  </div>

                  <el-form
                    ref="formRef"
                    :model="userStore.myDataFormData"
                    :rules="formRules"
                    label-position="top"
                    class="ios-form"
                  >
                    <div class="form-row">
                      <el-form-item label="账号" prop="emp.eUsername" class="form-item">
                        <el-input
                          v-model="userStore.myDataFormData.emp.eUsername"
                          disabled
                          class="ios-input"
                          size="large"
                        />
                      </el-form-item>
                    </div>

                    <div class="form-row">
                      <el-form-item label="密码" prop="emp.ePassword" class="form-item">
                        <div class="password-row">
                          <el-input
                            v-model="confirmPwd"
                            type="password"
                            placeholder="请输入后确认"
                            show-password
                            clearable
                            class="ios-input"
                            size="large"
                          />
                          <button
                            type="button"
                            class="confirm-btn"
                            :class="{ active: confirmPwd.length > 2 }"
                            @click="userStore.myDataFormData.emp.ePassword = confirmPwd"
                          >
                            确认
                          </button>
                        </div>
                      </el-form-item>
                    </div>

                    <div class="form-grid">
                      <el-form-item label="姓名" prop="emp.eName" class="form-item">
                        <el-input
                          v-model="userStore.myDataFormData.emp.eName"
                          clearable
                          class="ios-input"
                          size="large"
                        />
                      </el-form-item>

                      <el-form-item label="身份证号" prop="emp.eId" class="form-item">
                        <el-input
                          v-model="userStore.myDataFormData.emp.eId"
                          clearable
                          class="ios-input"
                          size="large"
                        />
                      </el-form-item>

                      <el-form-item label="手机号" prop="emp.ePhone" class="form-item">
                        <el-input
                          v-model="userStore.myDataFormData.emp.ePhone"
                          clearable
                          class="ios-input"
                          size="large"
                        />
                      </el-form-item>

                      <el-form-item label="年龄" prop="emp.eAge" class="form-item">
                        <el-input
                          v-model="userStore.myDataFormData.emp.eAge"
                          clearable
                          class="ios-input"
                          size="large"
                        />
                      </el-form-item>
                    </div>

                    <el-form-item label="性别" prop="emp.eGender" class="form-item">
                      <el-select
                        v-model="userStore.myDataFormData.emp.eGender"
                        clearable
                        placeholder="请选择"
                        class="ios-select"
                        size="large"
                        popper-style="z-index: 3100"
                      >
                        <el-option
                          v-for="option in userStore.options2"
                          :key="option.value"
                          :label="option.label"
                          :value="option.value"
                        />
                      </el-select>
                    </el-form-item>
                  </el-form>
                </div>
              </template>
            </div>

            <div class="modal-footer">
              <template v-if="mode === 'view'">
                <button class="ios-btn primary" @click="mode = 'edit'">
                  <el-icon><Edit /></el-icon>
                  <span>修改个人资料</span>
                </button>
              </template>
              <template v-else>
                <div class="form-actions">
                  <button type="button" class="ios-btn secondary" @click="cancelEdit">取消</button>
                  <button type="button" class="ios-btn primary" @click="submitBtn">提交</button>
                </div>
              </template>
            </div>
          </div>
        </div>
      </Transition>
    </div>
  </Teleport>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';
import { useHomeStore } from "@/stores/home-store";
import { useUserStore } from "@/stores/user-store";
import { Edit, Plus, RefreshRight } from '@element-plus/icons-vue';
import type { FormInstance, FormRules } from 'element-plus';

const userStore = useUserStore();
const homeStore = useHomeStore();
const mode = ref<'view' | 'edit'>('view');
const confirmPwd = ref('');
const formRef = ref<FormInstance>();

const formRules: FormRules = {
  'emp.eUsername': [
    { required: true, message: '请输入正确的账号', trigger: 'blur' },
  ],
  'emp.eName': [
    { required: true, message: '请输入正确的姓名', trigger: 'blur' },
  ],
  'emp.eId': [
    { required: true, message: '请输入正确的身份证号', trigger: 'blur' },
  ],
  'emp.ePhone': [
    { required: true, message: '请输入正确的手机号', trigger: 'blur' },
  ],
};

const calculateDays = (dateString: any) => {
  if (!dateString) return 0;
  const startDate = new Date(dateString) as any;
  const currentDate = new Date() as any;
  const diffTime = currentDate - startDate;
  const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
  return diffDays;
};

const cancelEdit = () => {
  userStore.avatarPath = null;
  userStore.file1 = userStore.Nullfile1;
  confirmPwd.value = '';
  mode.value = 'view';
};

const submitBtn = async () => {
  if (confirmPwd.value === '') {
    userStore.myDataFormData.emp.ePassword = 'N';
  }
  formRef.value?.validate((valid) => {
    if (valid) {
      userStore.handleUpdateMe().then(() => {
        confirmPwd.value = '';
        mode.value = 'view';
      });
    }
  });
};

watch(() => homeStore.myInfoVisible, (val) => {
  if (val) {
    document.body.style.overflow = 'hidden';
    mode.value = 'view';
    confirmPwd.value = '';
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
  width: 680px;
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

/* 按钮 */
.ios-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 14px 24px;
  border: none;
  border-radius: 16px;
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

.form-actions {
  display: flex;
  gap: 12px;
  width: 100%;
}

.form-actions .ios-btn {
  flex: 1;
  width: 100%;
}

/* 个人资料卡片 */
.profile-card {
  display: flex;
  gap: 32px;
  padding: 32px;
  background: #f9f9f9;
  border-radius: 20px;
  border: 0.5px solid rgba(0, 0, 0, 0.06);
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
  transition: box-shadow 0.3s ease;
}

.profile-card:hover {
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.06);
}

.avatar-section {
  flex-shrink: 0;
}

.avatar-wrapper {
  position: relative;
}

.avatar-wrapper::after {
  content: '';
  position: absolute;
  inset: -4px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(0,122,255,0.3), rgba(52,170,220,0.15));
  z-index: -1;
}

.avatar {
  border: 3px solid rgba(255, 255, 255, 0.9);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.profile-info {
  flex: 1;
  min-width: 0;
}

.greeting {
  margin-bottom: 24px;
}

.user-name {
  font-size: 26px;
  font-weight: 700;
  color: #1d1d1f;
  display: block;
}

.welcome-text {
  font-size: 16px;
  font-weight: 500;
  color: #007aff;
  display: block;
  margin-top: 6px;
  opacity: 0.85;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
}

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 14px 16px;
  background: #fff;
  border-radius: 14px;
  border: 0.5px solid rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;
}

.detail-item:hover {
  background: #f5f5f5;
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
}

.detail-label {
  font-size: 11px;
  font-weight: 600;
  color: #8e8e93;
  text-transform: uppercase;
  letter-spacing: 0.8px;
}

.detail-value {
  font-size: 14px;
  font-weight: 600;
  color: #1d1d1f;
}

.detail-item.highlight {
  background: linear-gradient(135deg, rgba(0,122,255,0.08), rgba(52,170,220,0.05));
  border-color: rgba(0, 122, 255, 0.15);
}

.detail-item.highlight:hover {
  background: linear-gradient(135deg, rgba(0,122,255,0.12), rgba(52,170,220,0.08));
}

.detail-item.highlight .detail-value.days {
  color: #007aff;
  font-size: 18px;
  font-weight: 700;
}

/* 编辑表单 */
.edit-form {
  padding: 0;
}

.avatar-upload-section {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 28px;
  padding-bottom: 24px;
  border-bottom: 0.5px solid rgba(0, 0, 0, 0.08);
}

.upload-label {
  font-size: 15px;
  font-weight: 600;
  color: #1d1d1f;
  min-width: 40px;
  padding-top: 16px;
}

.upload-area {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.upload-preview {
  position: relative;
  width: 88px;
  height: 88px;
  border-radius: 50%;
  overflow: hidden;
  cursor: pointer;
}

.preview-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.upload-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.4);
  color: #fff;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.upload-preview:hover .upload-overlay {
  opacity: 1;
}

.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 88px;
  height: 88px;
  border-radius: 50%;
  background: rgba(0, 122, 255, 0.06);
  border: 2px dashed rgba(0, 122, 255, 0.3);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.upload-placeholder:hover {
  background: rgba(0, 122, 255, 0.1);
  border-color: #007aff;
  transform: scale(1.05);
}

.upload-icon {
  color: #007aff;
  margin-bottom: 4px;
}

.upload-text {
  font-size: 11px;
  color: #007aff;
  font-weight: 500;
}

.upload-hint {
  margin-top: 8px;
  font-size: 12px;
  color: #aeaeb2;
}

.ios-form :deep(.el-form-item__label) {
  font-size: 13px;
  font-weight: 600;
  color: #8e8e93;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding-bottom: 6px !important;
}

.form-row {
  margin-bottom: 4px;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 0 16px;
}

.form-item {
  margin-bottom: 18px;
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

.ios-input :deep(.el-input__inner) {
  font-size: 15px;
  color: #1d1d1f;
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

.password-row {
  display: flex;
  gap: 8px;
  width: 100%;
}

.password-row .ios-input {
  flex: 1;
}

.confirm-btn {
  padding: 10px 20px;
  border: none;
  border-radius: 12px;
  background: rgba(0, 0, 0, 0.06);
  color: #8e8e93;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  white-space: nowrap;
}

.confirm-btn.active {
  background: #007aff;
  color: #fff;
  box-shadow: 0 2px 8px rgba(0, 122, 255, 0.3);
}

.confirm-btn:hover {
  transform: scale(1.05);
}

.confirm-btn:active {
  transform: scale(0.95);
}

/* 过渡动画 */
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
