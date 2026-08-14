<template>
  <Teleport to="body">
    <div v-show="visible" class="modal-overlay" @click.self="visible = false">
      <Transition name="vp-modal">
        <div v-show="visible" class="modal-container" @click.stop>
          <div class="modal-content-wrapper">
            <div class="modal-header">
              <h3 class="modal-title">消息</h3>
              <div class="modal-close" @click="visible = false">
                <svg width="14" height="14" viewBox="0 0 12 12" fill="currentColor">
                  <path d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z" />
                </svg>
              </div>
            </div>
            <div class="modal-content">
              <template v-if="noticesDataPublished.length > 0">
                <div class="notice-list">
                  <div
                    v-for="(message, index) in noticesDataPublished"
                    :key="index"
                    class="notice-card"
                  >
                    <div class="notice-header">
                      <span class="notice-title">{{ message.header }}</span>
                      <span class="notice-time">{{ formatDate(message.createtime || '') }}</span>
                    </div>
                    <div class="notice-content">{{ message.content }}</div>
                  </div>
                </div>
              </template>
              <div v-else class="empty-state">
                <svg class="empty-icon" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
                  <path d="M13.73 21a2 2 0 0 1-3.46 0" />
                </svg>
                <p class="empty-text">暂无消息</p>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </div>
  </Teleport>
</template>

<script lang="ts" setup>
import { ref, onMounted, watch } from 'vue';
import { useNoticesStore, noticesDataPublished } from '@/stores/notices-store';
import { formatDate } from '@/utils/moment';
import { useHomeStore } from "@/stores/home-store";

const noticesStore = useNoticesStore();
const homeStore = useHomeStore();

onMounted(() => {
  noticesStore.fetchAllData();
  homeStore.getMyInfo();
});

const visible = ref(false);

watch(visible, (val) => {
  if (val) {
    document.body.style.overflow = 'hidden';
  } else {
    document.body.style.overflow = '';
  }
});

defineExpose({
  open: () => { visible.value = true; }
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
  width: 480px;
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
  padding: 16px;
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

.notice-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.notice-card {
  padding: 16px;
  background: #f9f9f9;
  border-radius: 14px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  transition: all 0.2s ease;
  cursor: pointer;
}

.notice-card:hover {
  background: #f3f3f3;
}

.notice-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
  margin-bottom: 8px;
}

.notice-title {
  font-size: 14px;
  font-weight: 600;
  color: #1d1d1f;
  line-height: 1.4;
}

.notice-time {
  font-size: 12px;
  color: #aeaeb2;
  white-space: nowrap;
  flex-shrink: 0;
}

.notice-content {
  font-size: 13px;
  color: #6e6e73;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
}

.empty-icon {
  color: #d1d1d6;
  margin-bottom: 16px;
}

.empty-text {
  font-size: 14px;
  color: #aeaeb2;
  margin: 0;
}

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
