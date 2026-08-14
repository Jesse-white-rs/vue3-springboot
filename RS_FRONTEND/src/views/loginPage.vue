<template>
  <div class="login-page">
    <transition name="fade-scale" appear>
      <div class="login-card">
        <!-- Logo / 头像区域 -->
        <div class="login-avatar">
          <div class="avatar-circle">
            <el-icon class="avatar-icon" :size="32"><User /></el-icon>
          </div>
        </div>

        <div class="login-title">赛尔技术服务助手</div>
        <div class="login-subtitle">后台管理系统</div>

        <transition name="fade-scale" mode="out-in" @after-enter="onAfterEnter">
          <!-- 账户密码登录 -->
          <el-form
            v-if="rwg"
            key="form"
            ref="formRef"
            :model="store.loginFormData"
            :rules="store.LOGIN_FORM_RULES"
            label-width="0"
            @submit.prevent="handleLogin"
            class="login-form"
          >
            <!-- 账号输入框 -->
            <el-form-item prop="account" class="ios-form-item">
              <el-input
                v-model="store.loginFormData.account"
                clearable
                placeholder="请输入账号"
                class="ios-input"
                :prefix-icon="User"
              />
            </el-form-item>

            <!-- 密码输入框 -->
            <el-form-item prop="password" class="ios-form-item">
              <el-input
                v-model="store.loginFormData.password"
                type="password"
                clearable
                show-password
                placeholder="请输入密码"
                class="ios-input"
                :prefix-icon="Lock"
              />
            </el-form-item>

            <!-- 记住密码 -->
            <el-checkbox
              v-model="store.loginFormData.rememberMe"
              class="ios-checkbox"
            >
              7天内记住密码
            </el-checkbox>

            <!-- 登录按钮 -->
            <div class="btn-section">
              <el-button
                native-type="submit"
                class="ios-btn-primary"
              >
                登 录
              </el-button>

              <el-button
                class="ios-btn-secondary"
                @click="rwg = false"
              >
                企业微信扫码登录
              </el-button>
            </div>
          </el-form>

          <!-- 企微扫码登录 -->
          <div v-else key="qrcode" class="qywx-login">
            <div id="qywx-login-container"></div>
            <el-button
              class="ios-btn-secondary"
              style="margin-top: 20px; width: 100%"
              @click="rwg = true"
            >
              使用账户密码登录
            </el-button>
          </div>
        </transition>
      </div>
    </transition>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useUserStore } from "@/stores/user-store";
import { Lock, User } from "@element-plus/icons-vue";
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from "element-plus";

const rwg = ref(true);
const store = useUserStore();
const formRef = ref();

const handleLogin = async () => {
  if (!formRef.value) return;
  try {
    await formRef.value.validate();
    await store.loginOnSubmit();
  } catch {
    // validation failed
  }
};

// 企业微信扫码登录
function initQywxQrcode() {
  const container = document.getElementById("qywx-login-container");
  if (container) {
    container.innerHTML = "";
    const appid = "wwbf157b81fe36259a";
    const agentid = "1000179";
    const redirect_uri = encodeURIComponent(
      "http://cloud.sellersuniononline.com:18086"
    );
    const state = "fuwu";
    const iframe = document.createElement("iframe");
    iframe.src = `https://open.work.weixin.qq.com/wwopen/sso/qrConnect?appid=${appid}&agentid=${agentid}&redirect_uri=${redirect_uri}&state=${state}&login_type=jssdk&version=1.2.7`;
    iframe.style.width = "200px";
    iframe.style.height = "300px";
    iframe.style.border = "none";
    container.appendChild(iframe);
  }
}

onMounted(() => {
  if (localStorage.getItem("token")) {
    store.autoLogin();
  }
  const route = useRoute();
  const token = route.query.token as string;
  if (token) {
    localStorage.setItem("token", token);
    store.token = token;
    store.autoLogin();
  }
});

// 过渡动画结束后初始化企微二维码
function onAfterEnter() {
  if (!rwg.value) {
    initQywxQrcode();
  }
}
</script>
<style scoped>
/* ==================== 页面容器 ==================== */
.login-page {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-size: cover;
  background-position: center;
  background-image: url("../assets/img/loginPage/background.jpg");
  animation: bg-drift 425s ease infinite;
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif;
}

@keyframes bg-drift {
  0%, 100% { background-position: 0% 50%; }
  50%      { background-position: 100% 50%; }
}

/* ==================== 卡片主体 ==================== */
.login-card {
  width: 380px;
  padding: 44px 36px 36px;
  border-radius: 36px;
  background: rgba(255, 255, 255, 0.18);
  backdrop-filter: blur(40px) saturate(160%);
  -webkit-backdrop-filter: blur(40px) saturate(160%);
  border: 1px solid rgba(255, 255, 255, 0.25);
  box-shadow:
    0 8px 32px rgba(0, 0, 0, 0.12),
    inset 0 1px 0 rgba(255, 255, 255, 0.2);
  animation: card-enter 0.8s cubic-bezier(0.16, 1, 0.3, 1);
}

@keyframes card-enter {
  from {
    opacity: 0;
    transform: translateY(30px) scale(0.94);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

/* ==================== 头像区域 ==================== */
.login-avatar {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.avatar-circle {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  background: linear-gradient(135deg, #007AFF 0%, #34AADC 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow:
    0 8px 24px rgba(0, 122, 255, 0.3),
    inset 0 1px 0 rgba(255, 255, 255, 0.3);
}

.avatar-icon {
  color: #fff;
}

/* ==================== 标题区域 ==================== */
.login-title {
  text-align: center;
  font-size: 22px;
  font-weight: 600;
  color: #fff;
  letter-spacing: 1px;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.login-subtitle {
  text-align: center;
  font-size: 13px;
  font-weight: 400;
  color: rgba(255, 255, 255, 0.7);
  margin-top: 4px;
  margin-bottom: 32px;
  letter-spacing: 2px;
}

/* ==================== 表单间距 ==================== */
.login-form {
  display: flex;
  flex-direction: column;
}

/* ==================== iOS 风格输入框 ==================== */
.ios-form-item {
  margin-bottom: 16px;
}

.ios-input :deep(.el-input__wrapper) {
  height: 44px;
  border: none;
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.85);
  box-shadow:
    0 2px 8px rgba(0, 0, 0, 0.04),
    inset 0 1px 2px rgba(0, 0, 0, 0.04);
  transition: all 0.25s cubic-bezier(0.25, 0.8, 0.25, 1.2);
  font-size: 15px;
  color: #1d1d1f;
}

.ios-input :deep(.el-input__wrapper:hover) {
  background: rgba(255, 255, 255, 0.95);
  box-shadow:
    0 4px 14px rgba(0, 0, 0, 0.06),
    inset 0 1px 2px rgba(0, 0, 0, 0.04);
}

.ios-input :deep(.el-input__wrapper.is-focus) {
  background: #fff;
  box-shadow:
    0 0 0 4px rgba(0, 122, 255, 0.12),
    0 4px 16px rgba(0, 122, 255, 0.08);
}

.ios-input :deep(.el-input__inner) {
  padding-left: 4px;
  font-size: 15px;
  font-weight: 400;
  letter-spacing: 0.3px;
  color: #1d1d1f;
}

.ios-input :deep(.el-input__inner::placeholder) {
  color: #b0b0b5;
  font-weight: 400;
}

/* 图标样式 */
.ios-input :deep(.el-input__prefix) {
  display: flex;
  align-items: center;
}

.ios-input :deep(.el-input__prefix .el-icon) {
  font-size: 18px;
  color: #8e8e93;
  transition: color 0.25s ease;
}

.ios-input :deep(.el-input__wrapper.is-focus .el-input__prefix .el-icon) {
  color: #007AFF;
}

/* 清除按钮 */
.ios-input :deep(.el-input__suffix) {
  display: flex;
  align-items: center;
}

.ios-input :deep(.el-input__suffix .el-icon) {
  color: #c7c7cc;
  transition: color 0.2s;
}

.ios-input :deep(.el-input__suffix .el-icon:hover) {
  color: #8e8e93;
}

/* ==================== 记住密码 ==================== */
.ios-checkbox {
  margin: 18px 0 24px 4px;
  color: rgba(255, 255, 255, 0.85) !important;
  font-size: 14px;
  font-weight: 450;
  letter-spacing: 0.3px;
}

.ios-checkbox :deep(.el-checkbox__label) {
  color: rgba(255, 255, 255, 0.85) !important;
  font-size: 14px;
}

.ios-checkbox :deep(.el-checkbox__inner) {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.4);
}

.ios-checkbox :deep(.el-checkbox__input.is-checked .el-checkbox__inner) {
  background: #007AFF;
  border-color: #007AFF;
}

/* ==================== 按钮区域 ==================== */
.btn-section {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  gap: 14px;
}

/* 主按钮 —— iOS 风格 */
.ios-btn-primary {
  width: 100%;
  height: 46px !important;
  border-radius: 14px !important;
  border: none !important;
  font-size: 17px !important;
  font-weight: 590 !important;
  letter-spacing: 1.5px;
  color: #fff !important;
  background: linear-gradient(135deg, #007AFF 0%, #34AADC 100%) !important;
  box-shadow:
    0 8px 24px rgba(0, 122, 255, 0.35),
    inset 0 1px 0 rgba(255, 255, 255, 0.25);
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1.2);
  cursor: pointer;
}

.ios-btn-primary:hover {
  transform: translateY(-2px);
  box-shadow:
    0 12px 32px rgba(0, 122, 255, 0.45),
    inset 0 1px 0 rgba(255, 255, 255, 0.3);
}

.ios-btn-primary:active {
  transform: translateY(0) scale(0.98);
  box-shadow:
    0 4px 12px rgba(0, 122, 255, 0.3),
    inset 0 1px 0 rgba(255, 255, 255, 0.2);
}

/* 次要按钮 —— iOS 风格 */
.ios-btn-secondary {
  width: 100%;
  height: 46px !important;
  border-radius: 14px !important;
  font-size: 15px !important;
  font-weight: 500 !important;
  letter-spacing: 1px;
  color: rgba(255, 255, 255, 0.9) !important;
  background: rgba(255, 255, 255, 0.15) !important;
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1.2);
  cursor: pointer;
}

.ios-btn-secondary:hover {
  background: rgba(255, 255, 255, 0.25) !important;
  border-color: rgba(255, 255, 255, 0.45) !important;
  transform: translateY(-1px);
}

.ios-btn-secondary:active {
  transform: translateY(0) scale(0.98);
}

/* ==================== 过渡动画 ==================== */
.fade-scale-enter-from,
.fade-scale-leave-to {
  opacity: 0;
  transform: scale(0.92);
}

.fade-scale-enter-active,
.fade-scale-leave-active {
  transition: all 0.45s cubic-bezier(0.16, 1, 0.3, 1);
}

/* ==================== 企微登录区域 ==================== */
.qywx-login {
  text-align: center;
  margin-top: 24px;
}
</style>
