<template>
  <div class="qy-sync">
    <div class="sync-item">
      <div class="sync-label">一键同步企微用户与部门架构到本地数据库</div>
      <el-button type="primary" @click="syncBtn">启动</el-button>
    </div>
    <div class="sync-item">
      <div class="sync-label">一键完成企微用户账号注册</div>
      <el-button type="primary" @click="regBtn">启动</el-button>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ElMessage } from "element-plus";
import { regData, syncData } from "@/api/services/qywx-api";

const syncBtn = async () => {
  try {
    await syncData().then((res: any) => {
      if (res.data.code == "1") {
        ElMessage.success("同步成功");
      } else {
        ElMessage.error("同步失败：" + res.message);
      }
    })
  } catch (error) {
    ElMessage.error("同步过程中发生错误：" + error);
  }
};

const regBtn = async () => {
  try {
    await regData().then((res: any) => {
      if (res.data.code == "1") {
        ElMessage.success("注册成功");
      } else {
        ElMessage.error("注册失败：" + res.message);
      }
    })
  } catch (error) {
    ElMessage.error("注册过程中发生错误：" + error);
  }
};
</script>

<style scoped>
.qy-sync {
  padding: 10px 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.sync-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16px;
  border-bottom: 0.5px solid rgba(0, 0, 0, 0.06);
}

.sync-item:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.sync-label {
  font-size: 14px;
  color: #1f1f1f;
  font-weight: 500;
}

.sync-item :deep(.el-button) {
  border-radius: 10px;
  --el-button-bg-color: #007aff;
  --el-button-border-color: #007aff;
  --el-button-hover-bg-color: #0066d6;
  --el-button-hover-border-color: #0066d6;
}
</style>
