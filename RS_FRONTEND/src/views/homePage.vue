<template>
  <div class="ios-home-layout">
    <div class="bg-gradient"></div>
    <div class="layout-header">
      <rheader />
    </div>
    <div class="layout-main">
      <div class="layout-sidebar">
        <sideBar />
      </div>
      <div class="layout-content-area">
        <div class="layout-content">
          <content />
        </div>
        <div class="layout-footer">
          <rfooter />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import sideBar from "@/layout/sideBar.vue";
import rheader from "@/layout/header.vue";
import content from "@/layout/content.vue";
import rfooter from "@/layout/footer.vue";
</script>

<style scoped>
.ios-home-layout {
  position: relative;
  display: flex;
  flex-direction: column;
  height: 100vh;
  overflow: hidden;
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display",
    "SF Pro Text", "Helvetica Neue", sans-serif;
}

.bg-gradient {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, #f5f5f7 0%, #e8e8ed 50%, #f0f0f5 100%);
  z-index: -2;
}

.layout-header {
  flex-shrink: 0;
  z-index: 10;
}

.layout-main {
  display: flex;
  flex: 1;
  min-height: 0;
  z-index: 5;
}

.layout-sidebar {
  flex-shrink: 0;
  height: 100%;
}

.layout-content-area {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-width: 0;
  min-height: 0;
}

.layout-content {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
}

.layout-footer {
  flex-shrink: 0;
  z-index: 5;
}
</style>
