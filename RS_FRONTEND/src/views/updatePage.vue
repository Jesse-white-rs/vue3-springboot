<template>
  <div class="wrap">
    <div class="header">
      <el-button type="primary" @click="showAddDialog = true">
        发布新版本
      </el-button>
    </div>

    <!-- Version Table -->
    <div class="table-wrapper">
      <el-table :data="versionList" style="width: 100%" height="65vh" class="ios-table">
        <el-table-column prop="versionName" label="版本号" show-overflow-tooltip sortable />
        <el-table-column prop="versionCode" label="版本代码" show-overflow-tooltip sortable />
        <el-table-column prop="updateContent" label="更新内容" show-overflow-tooltip />
        <el-table-column label="强制更新" width="100">
          <template #default="{ row }">
            <el-tag :type="row.forceUpdate == 1 ? 'danger' : 'info'" size="small">
              {{ row.forceUpdate == 1 ? "是" : "否" }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="fileUrl" label="安装包地址" show-overflow-tooltip />
      </el-table>
    </div>

    <div class="pag">
      <el-pagination
        background
        layout="prev, pager, next"
        :total="pagination.total"
        :page-size="pagination.pageSize"
        :current-page="pagination.current"
        @current-change="onPageChange"
      />
    </div>

    <!-- Add Version Dialog -->
    <Teleport to="body">
      <div v-show="showAddDialog" class="modal-overlay" @click.self="showAddDialog = false">
        <Transition name="vp-modal">
          <div v-show="showAddDialog" class="modal-container" @click.stop>
            <div class="modal-content-wrapper">
              <div class="modal-header">
                <h3 class="modal-title">新版本发布</h3>
                <div class="modal-close" @click="showAddDialog = false">
                  <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                    <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                  </svg>
                </div>
              </div>
              <div class="modal-content">
                <el-form :model="formData" label-width="100px">
                  <el-form-item label="版本号">
                    <el-input v-model="formData.versionName" placeholder="请输入版本号 (v1.0.0)" />
                  </el-form-item>
                  <el-form-item label="版本代码">
                    <el-input-number v-model="formData.versionCode" :min="0" />
                  </el-form-item>
                  <el-form-item label="更新内容">
                    <el-input type="textarea" v-model="formData.updateContent" placeholder="请输入更新内容" :rows="4" />
                  </el-form-item>
                  <el-form-item label="是否强制更新">
                    <el-switch v-model="formData.forceUpdate" :active-value="1" :inactive-value="0" />
                  </el-form-item>
                  <el-form-item label="选择安装包">
                    <input type="file" @change="handleFileChange" class="file-input" />
                  </el-form-item>
                </el-form>
              </div>
              <div class="modal-footer">
                <div class="form-actions">
                  <button type="button" class="ios-btn secondary" @click="showAddDialog = false">取消</button>
                  <button type="button" class="ios-btn primary" @click="handleSubmit">确认发布</button>
                </div>
              </div>
            </div>
          </div>
        </Transition>
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import {
  fetchUpdateDataPages,
  createNewVersion,
  uploadUpdateFile,
} from "@/api/services/update-api";
import { ElMessage } from "element-plus";

interface VersionItem {
  id: number;
  versionName: string;
  versionCode: number;
  updateContent: string;
  forceUpdate: boolean;
  fileUrl: string;
}

const versionList = ref<VersionItem[]>([]);
const pagination = reactive({ current: 1, pageSize: 10, total: 0 });
const showAddDialog = ref(false);
const file = ref<File | null>(null);

const formData = reactive({
  versionName: "",
  versionCode: null,
  updateContent: "",
  forceUpdate: null,
  fileUrl: "",
});

const getData = async () => {
  const res = await fetchUpdateDataPages(
    pagination.current,
    pagination.pageSize
  );
  const result = res.data.result;
  versionList.value = result.records || [];
  pagination.total = result.total || 0;
};

const onPageChange = (page: number) => {
  pagination.current = page;
  getData();
};

const handleFileChange = (e: Event) => {
  const target = e.target as HTMLInputElement;
  if (target.files && target.files.length > 0) {
    file.value = target.files[0];
  }
};

const handleSubmit = async () => {
  if (!file.value) {
    ElMessage.warning("请上传安装包");
    return;
  }

  const uploadRes = await uploadUpdateFile(file.value);
  const uploadedUrl = uploadRes.data.result.fileUrl;

  const versionData = {
    versionName: formData.versionName,
    versionCode: formData.versionCode,
    updateContent: formData.updateContent,
    forceUpdate: formData.forceUpdate,
    fileUrl: uploadedUrl,
  };
  console.log("准备提交版本数据：", versionData);
  await createNewVersion(versionData);

  ElMessage.success("新版本发布成功");
  showAddDialog.value = false;
  getData();
};

onMounted(getData);
</script>

<style scoped>
.wrap {
  background: #fff;
  border-radius: 18px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  padding: 20px;
  display: flex;
  flex-direction: column;
}

.header {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 16px;
}

.header :deep(.el-button) {
  border-radius: 10px;
  --el-button-bg-color: #007aff;
  --el-button-border-color: #007aff;
  --el-button-hover-bg-color: #0066d6;
  --el-button-hover-border-color: #0066d6;
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

/* Modal styles */
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

.modal-content :deep(.el-form-item) {
  margin-bottom: 18px;
}

.modal-content :deep(.el-input__wrapper),
.modal-content :deep(.el-textarea__inner) {
  border-radius: 10px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06);
}

.modal-content :deep(.el-input__wrapper:hover),
.modal-content :deep(.el-textarea__inner:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2);
}

.modal-content :deep(.el-input__wrapper.is-focus),
.modal-content :deep(.el-textarea__inner:focus) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2);
}

.file-input {
  font-size: 13px;
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
