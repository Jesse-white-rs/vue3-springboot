<template>
  <div class="ios-content-wrapper">
    <div class="content-glass"></div>
    <div class="content-inner">
      <transition name="tags-slide" appear>
        <div class="ios-tags-wrapper">
          <el-scrollbar class="tags-scroll">
            <div class="tags-container">
              <transition-group name="tag-anim" tag="div" class="tags-list">
                <div
                  v-for="(item, index) in tagData"
                  :key="item.name + index"
                  class="ios-tag"
                  :class="{ active: item.isActive }"
                  @click="handleSelect(item)"
                  @contextmenu.prevent="onRightClick"
                >
                  <el-icon class="tag-icon" :size="12">
                    <component :is="getIconComponent(item.meta?.icon)" />
                  </el-icon>
                  <span class="tag-text">{{ item.name }}</span>
                  <span class="tag-close" @click.stop="handleClose(item)">
                    <el-icon :size="11"><Close /></el-icon>
                  </span>
                </div>
              </transition-group>
            </div>
          </el-scrollbar>
        </div>
      </transition>
      <div class="content-scroll" ref="scrollRef">
        <div v-if="route.path === '/home'" class="home-tip">
          <a href="http://cloud.sellersuniononline.com:28888/assist/#/seller-pc-helper">你正位于空白页，点击前往软件下载页</a>
        </div>
        <div class="page-slide-wrapper">
          <router-view></router-view>
        </div>
        <el-backtop
          target=".content-scroll"
          :visibility-height="200"
          :right="28"
          :bottom="80"
          :duration="600"
          class="ios-backtop"
        />
        <myInfo />
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import myInfo from "@/layout/components/myInfo.vue";
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import { useTagsStore } from '@/stores/tags-store';
import router from '@/router';
import * as ElementPlusIconsVue from '@element-plus/icons-vue';
import { Close } from '@element-plus/icons-vue';

const route = useRoute();
const tagsStore = useTagsStore();
const tagData = computed(() => tagsStore.tagsList);

const handleClose = (item: any) => {
  tagsStore.delRoute(item);
};

const handleSelect = (item: any) => {
  if (item.name !== tagsStore.currentRoute?.name) {
    router.push(item.path);
    tagsStore.setTagsList(item);
  }
};

const onRightClick = (e: any) => {};

const getIconComponent = (iconName: string | undefined) => {
  if (!iconName) return ElementPlusIconsVue['Document'];
  const key = iconName as keyof typeof ElementPlusIconsVue;
  if (ElementPlusIconsVue[key]) return ElementPlusIconsVue[key];
  return ElementPlusIconsVue['Document'];
};
</script>

<style scoped>
.ios-content-wrapper {
  position: relative;
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.content-glass {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: saturate(150%) blur(16px);
  -webkit-backdrop-filter: saturate(150%) blur(16px);
  box-shadow:
    0 1px 3px rgba(0, 0, 0, 0.04),
    inset 0 0.5px 0 rgba(255, 255, 255, 0.6);
}

.content-inner {
  position: relative;
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
  z-index: 1;
}

.content-scroll {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 16px 20px;
  scroll-behavior: smooth;
}

.content-scroll::-webkit-scrollbar {
  width: 6px;
}

.content-scroll::-webkit-scrollbar-track {
  background: transparent;
}

.content-scroll::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 3px;
}

.content-scroll::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 0, 0, 0.2);
}

.content-scroll > .page-slide-enter-active,
.content-scroll > .page-slide-leave-active {
  width: 100%;
}

.page-slide-wrapper {
  min-height: 100%;
}

.home-tip a{

  padding: 12px 16px;
  margin-bottom: 12px;
  color: #007AFF;
  font-size: 13px;
  font-weight: 500;
}

.ios-backtop :deep(.el-backtop) {
  background: rgba(0, 122, 255, 0.9) !important;
  backdrop-filter: saturate(180%) blur(12px) !important;
  -webkit-backdrop-filter: saturate(180%) blur(12px) !important;
  border: none !important;
  box-shadow: 0 4px 16px rgba(0, 122, 255, 0.3) !important;
  color: #fff !important;
  border-radius: 50% !important;
  width: 44px !important;
  height: 44px !important;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1) !important;
}

.ios-backtop :deep(.el-backtop:hover) {
  transform: scale(1.1) !important;
  box-shadow: 0 6px 24px rgba(0, 122, 255, 0.2) !important;
}

/* Tags */
.ios-tags-wrapper {
  padding: 0 2px;
  margin-bottom: 6px;
}

.tags-scroll {
  cursor: pointer;
}

.tags-container {
  padding: 4px 0;
}

.tags-list {
  margin-left: 2px;
  display: flex;
  gap: 6px;
  flex-wrap: nowrap;
  align-items: center;
}

.ios-tag {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 0px 5px;
  height: 28px;
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  border: 0.5px solid rgba(0, 0, 0, 0.07);
  border-radius: 8px;
  cursor: pointer;
  white-space: nowrap;
  user-select: none;
  transition:
    background 0.25s ease,
    box-shadow 0.25s ease,
    transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
}

.ios-tag:hover {
  background: rgba(255, 255, 255, 0.9);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.ios-tag:active {
  transform: scale(0.95);
}

.ios-tag.active {
  background: #007aff;
  border-color: transparent;
  box-shadow: 0 2px 5px rgba(0, 122, 255, 0.28);
}

.ios-tag.active:hover {
  color: white;
}

.ios-tag.active .tag-icon,
.ios-tag.active .tag-text {
  color: #fff;
}

.ios-tag.active .tag-close {
  color: rgba(255, 255, 255, 0.6);
}

.ios-tag.active .tag-close:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.2);
}

.tag-icon {
  color: #8e8e93;
  transition: color 0.2s ease;
  flex-shrink: 0;
}


.tag-text {
  font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Text', 'Helvetica Neue', sans-serif;
  font-size: 12px;
  font-weight: 500;
  color: #1d1d1f;
  letter-spacing: -0.1px;
  line-height: 1;
}

.tag-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  color: #aeaeb2;
  margin-left: 1px;
  transition: all 0.2s ease;
}

.tag-close:hover {
  background: rgba(255, 59, 48, 0.12);
  color: #ff3b30;
}

/* Tags 动画 */
.tags-slide-enter-active {
  transition: all 0.45s cubic-bezier(0.22, 1, 0.36, 1);
}

.tags-slide-enter-from {
  opacity: 0;
  transform: translateY(-16px);
}

.tag-anim-enter-active {
  transition: all 0.28s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.tag-anim-leave-active {
  transition: all 0.18s ease;
  position: absolute;
}

.tag-anim-enter-from {
  opacity: 0;
  transform: scale(0.7) translateY(-8px);
}

.tag-anim-leave-to {
  opacity: 0;
  transform: scale(0.7);
}

.tag-anim-move {
  transition: transform 0.25s ease;
}

/* 页面过渡 */
.page-slide-enter-active {
  transition: all 0.45s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.page-slide-leave-active {
  transition: all 0.3s cubic-bezier(0.55, 0, 1, 0.45);
}

.page-slide-enter-from {
  opacity: 0;
  transform: translateX(30px) scale(0.98);
}

.page-slide-leave-to {
  opacity: 0;
  transform: translateX(-30px) scale(0.98);
}
</style>
