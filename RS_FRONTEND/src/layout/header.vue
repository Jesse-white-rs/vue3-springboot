<template>
  <div class="ios-header">
    <div class="header-glass"></div>
    <div class="header-content">
      <div class="header-left">
        <div class="logo-wrapper">
          <img src="../assets/img/seller-logo.png" class="logo" />
        </div>
        <transition name="title-fade" appear>
          <h1 class="title">Seller Assist Backend</h1>
        </transition>
        <div v-loading="content" class="loading-dot"></div>
      </div>
      <div class="header-right">
        <div class="avatar-wrapper">
          <el-avatar :size="38" :src="store.myData.emp.eAvatarpath" class="avatar" />
          <span class="online-dot"></span>
        </div>
        <div class="dropdown-wrapper" ref="dropdownRef">
          <span class="user-trigger" @click="toggleDropdown">
            <span class="user-name">{{ store.myData.emp.eName }}</span>
            <el-icon class="trigger-arrow" :class="{ open: dropdownOpen }"><ArrowDown /></el-icon>
          </span>
          <Transition name="dropdown">
            <div v-show="dropdownOpen" class="dropdown-panel">
              <div class="dropdown-glass"></div>
              <div class="dropdown-light"></div>
              <div class="dropdown-content">
                <div class="dropdown-item" @click="handleCommand(1)">
                  <div class="item-icon">
                    <el-icon :size="16"><User /></el-icon>
                  </div>
                  <span>个人中心</span>
                </div>
                <div class="dropdown-divider"></div>
                <div class="dropdown-item danger" @click="handleCommand(2)">
                  <div class="item-icon">
                    <el-icon :size="16"><SwitchButton /></el-icon>
                  </div>
                  <span>退出登录</span>
                </div>
              </div>
            </div>
          </Transition>
        </div>
        <div class="icon-btn" @click="openNews">
          <el-icon :size="20"><Bell /></el-icon>
        </div>
        <newsDrawer ref="newsDrawerRef" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import newsDrawer from "./components/newsDrawer.vue";
import { useUserStore } from "@/stores/user-store";
import { useHomeStore } from "@/stores/home-store";
import { onBeforeMount, ref, onMounted, onUnmounted } from "vue";
import { content } from "@/utils/stateVariables";
import { Bell, ArrowDown, User, SwitchButton } from "@element-plus/icons-vue";
import { ElMessage } from "element-plus";

const store = useUserStore();
const homeStore = useHomeStore();
const newsDrawerRef = ref<InstanceType<typeof newsDrawer>>();
const dropdownRef = ref<HTMLElement>();
const dropdownOpen = ref(false);

onBeforeMount(() => {
  store.updateLoginUserData();
  homeStore.getMyInfo();
});

const toggleDropdown = () => {
  dropdownOpen.value = !dropdownOpen.value;
};

const closeDropdown = (e: MouseEvent) => {
  if (dropdownRef.value && !dropdownRef.value.contains(e.target as Node)) {
    dropdownOpen.value = false;
  }
};

onMounted(() => {
  document.addEventListener('click', closeDropdown);
});

onUnmounted(() => {
  document.removeEventListener('click', closeDropdown);
});

const openNews = () => {
  newsDrawerRef.value?.open();
};

const handleCommand = (command: number) => {
  dropdownOpen.value = false;
  if (command === 2) {
    ElMessage.success("已退出登录");
    store.logout();
  } else if (command === 1) {
    homeStore.myInfoVisible = true;
  }
};
</script>

<style scoped>
.ios-header {
  position: relative;
  height: 64px;
  z-index: 100;
}

.header-glass {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: saturate(180%) blur(20px);
  -webkit-backdrop-filter: saturate(180%) blur(20px);
  border-bottom: 0.5px solid rgba(0, 0, 0, 0.12);
}

.header-content {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
  padding: 0 28px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 14px;
}

.logo-wrapper {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.logo {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.title {
  font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'SF Pro Text', 'Helvetica Neue', sans-serif;
  font-size: 17px;
  font-weight: 600;
  color: #1d1d1f;
  letter-spacing: -0.2px;
  margin: 0;
}

.loading-dot {
  width: 18px;
  height: 18px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.avatar-wrapper {
  position: relative;
  cursor: pointer;
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.avatar-wrapper:hover {
  transform: scale(1.08);
}

.avatar {
  border: 2.5px solid rgba(255, 255, 255, 0.9);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.12);
}

.online-dot {
  position: absolute;
  bottom: 1px;
  right: 1px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: #34c759;
  border: 2px solid #fff;
  box-shadow: 0 0 6px rgba(52, 199, 89, 0.5);
  animation: pulse-dot 2s ease-in-out infinite;
}

/* 下拉触发器 */
.dropdown-wrapper {
  position: relative;
}

.user-trigger {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border-radius: 20px;
  background: rgba(0, 0, 0, 0.04);
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
  user-select: none;
}

.user-trigger:hover {
  background: rgba(0, 122, 255, 0.1);
  transform: scale(1.03);
}

.user-trigger:active {
  transform: scale(0.97);
}

.user-name {
  font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Text', 'Helvetica Neue', sans-serif;
  font-size: 14px;
  font-weight: 500;
  color: #1d1d1f;
}

.trigger-arrow {
  font-size: 12px;
  color: #8e8e93;
  transition: transform 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.trigger-arrow.open {
  transform: rotate(180deg);
  color: #007aff;
}

.user-trigger:hover .trigger-arrow {
  color: #007aff;
}

/* 下拉面板 */
.dropdown-panel {
  position: absolute;
  top: calc(100% + 8px);
  right: 0;
  width: 180px;
  border-radius: 18px;
  overflow: hidden;
  transform-origin: top right;
}

.dropdown-glass {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: saturate(180%) blur(40px);
  -webkit-backdrop-filter: saturate(180%) blur(40px);
  border: 0.5px solid rgba(255, 255, 255, 0.6);
  border-radius: 18px;
  box-shadow:
    0 12px 48px rgba(0, 0, 0, 0.12),
    0 4px 16px rgba(0, 0, 0, 0.06),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
}

.dropdown-light {
  position: absolute;
  top: -50%;
  left: -20%;
  width: 140%;
  height: 80%;
  background: radial-gradient(
    ellipse 80% 50% at 50% 0%,
    rgba(120, 180, 255, 0.2) 0%,
    transparent 50%
  );
  pointer-events: none;
  border-radius: 18px;
}

.dropdown-content {
  position: relative;
  z-index: 1;
  padding: 6px;
}

.dropdown-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 14px;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.22, 1, 0.36, 1);
}

.dropdown-item:hover {
  background: rgba(0, 122, 255, 0.08);
  transform: translateX(2px);
}

.dropdown-item:active {
  transform: scale(0.98);
}

.dropdown-item span {
  font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Text', 'Helvetica Neue', sans-serif;
  font-size: 14px;
  font-weight: 500;
  color: #1d1d1f;
}

.dropdown-item.danger span {
  color: #ff3b30;
}

.dropdown-item.danger:hover {
  background: rgba(255, 59, 48, 0.08);
}

.dropdown-divider {
  height: 0.5px;
  background: rgba(0, 0, 0, 0.08);
  margin: 4px 12px;
}

.item-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border-radius: 8px;
  background: rgba(0, 0, 0, 0.04);
  transition: all 0.2s ease;
}

.dropdown-item:hover .item-icon {
  background: rgba(0, 122, 255, 0.12);
}

.dropdown-item.danger .item-icon {
  background: rgba(255, 59, 48, 0.1);
}

.dropdown-item.danger:hover .item-icon {
  background: rgba(255, 59, 48, 0.15);
}

.icon-btn {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 38px;
  height: 38px;
  border-radius: 12px;
  background: rgba(0, 0, 0, 0.04);
  cursor: pointer;
  color: #6e6e73;
  transition: all 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.icon-btn:hover {
  background: rgba(0, 122, 255, 0.1);
  color: #007aff;
  transform: scale(1.08);
}

.icon-btn:active {
  transform: scale(0.95);
}

.title-fade-enter-active {
  transition: all 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.title-fade-enter-from {
  opacity: 0;
  transform: translateY(-16px) scale(0.95);
}

/* 下拉动画 */
.dropdown-enter-active {
  animation: dropdown-in 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.dropdown-leave-active {
  animation: dropdown-out 0.2s cubic-bezier(0.4, 0, 0.6, 1);
}

@keyframes dropdown-in {
  0% {
    opacity: 0;
    transform: scale(0.9) translateY(-8px);
  }
  100% {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

@keyframes dropdown-out {
  0% {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
  100% {
    opacity: 0;
    transform: scale(0.9) translateY(-8px);
  }
}

@keyframes pulse-dot {
  0%, 100% {
    box-shadow: 0 0 4px rgba(52, 199, 89, 0.4);
  }
  50% {
    box-shadow: 0 0 10px rgba(52, 199, 89, 0.7);
  }
}
</style>
