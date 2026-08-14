<template>
    <Teleport to="body">
        <Transition name="vp-modal">
            <div v-if="visible" class="vp-modal-overlay" @click.self="close">
                <div class="vp-modal-container">
                    <div class="vp-modal-header">
                        <span class="vp-modal-title">{{ header }}</span>
                        <button class="vp-modal-close" @click="close">
                            <el-icon><Close /></el-icon>
                        </button>
                    </div>
                    <div class="main-container">
                        <slot name="main"></slot>
                    </div>
                    <div class="footer-container">
                        <slot name="footer"></slot>
                    </div>
                </div>
            </div>
        </Transition>
    </Teleport>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import { Close } from '@element-plus/icons-vue';

interface Props {
    visible: boolean;
    header?: string;
}

const props = withDefaults(defineProps<Props>(), {
    header: '',
});

const emit = defineEmits<{
    (e: 'update:visible', value: boolean): void;
}>();

const close = () => {
    emit('update:visible', false);
};

const handleKeydown = (e: KeyboardEvent) => {
    if (e.key === 'Escape' && props.visible) {
        close();
    }
};

watch(
    () => props.visible,
    (val) => {
        if (val) {
            document.addEventListener('keydown', handleKeydown);
            document.body.style.overflow = 'hidden';
        } else {
            document.removeEventListener('keydown', handleKeydown);
            document.body.style.overflow = '';
        }
    }
);
</script>

<style scoped>
.vp-modal-overlay {
    position: fixed;
    inset: 0;
    z-index: 2000;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(0, 0, 0, 0.45);
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
}

.vp-modal-container {
    position: relative;
    width: 90%;
    max-width: 560px;
    max-height: 85vh;
    background: #ffffff;
    opacity: 1;
    border-radius: 25px;
    box-shadow:
        0 24px 80px rgba(0, 0, 0, 0.25),
        0 0 0 1px rgba(255, 255, 255, 0.08);
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.vp-modal-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20px 24px 0;
    flex-shrink: 0;
}

.vp-modal-title {
    font-size: 18px;
    font-weight: 600;
    color: #1d1d1f;
    letter-spacing: 0.3px;
}

.vp-modal-close {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 32px;
    height: 32px;
    border: none;
    border-radius: 50%;
    background: rgba(0, 0, 0, 0.06);
    color: #8e8e93;
    cursor: pointer;
    transition: all 0.2s ease;
    flex-shrink: 0;
}

.vp-modal-close:hover {
    background: rgba(0, 0, 0, 0.1);
    color: #1d1d1f;
}

.main-container {
    padding: 20px 24px;
    overflow-y: auto;
    flex: 1;
}

.main-container > * {
    margin-bottom: 16px;
}

.footer-container {
    padding: 0 24px 20px;
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    flex-shrink: 0;
}

.footer-container > * {
    margin-right: 5px;
}

/* ==================== 过渡动画 ==================== */
.vp-modal-enter-active {
    transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);
}

.vp-modal-leave-active {
    transition: all 0.25s cubic-bezier(0.4, 0, 1, 1);
}

.vp-modal-enter-from {
    opacity: 0;
}

.vp-modal-leave-to {
    opacity: 0;
}

.vp-modal-enter-from .vp-modal-container {
    transform: scale(0.92) translateY(20px);
    opacity: 0;
}

.vp-modal-leave-to .vp-modal-container {
    transform: scale(0.95);
    opacity: 0;
}

.vp-modal-enter-active .vp-modal-container {
    transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);
}

.vp-modal-leave-active .vp-modal-container {
    transition: all 0.2s cubic-bezier(0.4, 0, 1, 1);
}
</style>
