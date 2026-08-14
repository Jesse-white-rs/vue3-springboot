<template>
  <div class="ios-footer">
    <div class="footer-glass"></div>
    <div class="footer-content">
      <el-breadcrumb separator="/" class="ios-breadcrumb">
        <el-breadcrumb-item>
          <div class="breadcrumb-icon-wrap">
            <el-icon :size="12"><Location /></el-icon>
          </div>
          <span class="breadcrumb-label">当前位置</span>
        </el-breadcrumb-item>
        <el-breadcrumb-item
          v-for="(item, index) in $route.matched"
          :key="index"
          :to="item.path"
          :replace="true"
        >
          {{ item.name }}
        </el-breadcrumb-item>
      </el-breadcrumb>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { Location } from '@element-plus/icons-vue';
</script>

<style scoped>
.ios-footer {
  position: relative;
  padding: 8px 16px;
  flex-shrink: 0;
}

.footer-glass {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.5);
  backdrop-filter: saturate(150%) blur(12px);
  -webkit-backdrop-filter: saturate(150%) blur(12px);
  box-shadow:
    0 1px 2px rgba(0, 0, 0, 0.03),
    inset 0 0.5px 0 rgba(255, 255, 255, 0.5);
}

.footer-content {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
}

.ios-breadcrumb {
  display: flex;
  align-items: center;
  line-height: 1;
}

.ios-breadcrumb :deep(.el-breadcrumb__item) {
  display: flex;
  align-items: center;
  line-height: 1;
}

.ios-breadcrumb :deep(.el-breadcrumb__inner) {
  font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Text', 'Helvetica Neue', sans-serif;
  font-size: 13px;
  font-weight: 500;
  color: #8e8e93;
  letter-spacing: -0.1px;
  display: flex;
  align-items: center;
  line-height: 1;
}

.ios-breadcrumb :deep(.el-breadcrumb__inner a) {
  color: #007aff;
  font-weight: 500;
  transition: color 0.2s ease;
  display: flex;
  align-items: center;
  line-height: 1;
}

.ios-breadcrumb :deep(.el-breadcrumb__inner a:hover) {
  color: #0056cc;
}

.ios-breadcrumb :deep(.el-breadcrumb__separator) {
  color: #c7c7cc;
  font-weight: 400;
  display: flex;
  align-items: center;
  line-height: 1;
}

.breadcrumb-icon-wrap {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  border-radius: 5px;
  background: #007aff;
  color: #fff;
  margin-right: 6px;
  flex-shrink: 0;
}

.breadcrumb-label {
  vertical-align: middle;
}
</style>
