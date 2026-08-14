<template>
  <div class="login">
    <el-form ref="formRef" :model="store.loginFormData" :rules="store.LOGIN_FORM_RULES" label-width="0" @submit.prevent="handleSubmit">
      <el-form-item prop="account">
        <el-input v-model="store.loginFormData.account" clearable placeholder="账号" :prefix-icon="User" />
      </el-form-item>

      <el-form-item prop="password">
        <el-input v-model="store.loginFormData.password" type="password" clearable placeholder="密码" show-password :prefix-icon="Lock" />
      </el-form-item>

      <el-form-item prop="验证码">
        <el-input placeholder="请输入验证码" v-model="store.sidentifyMode" @click="identifyCodeVisible = true" clearable />
      </el-form-item>

      <div @click="store.refreshCode" v-if="identifyCodeVisible" class="captcha-row">
        <span class="captcha-label">验证码：</span>
        <SIdentify :identifyCode="store.identifyCode"></SIdentify>
      </div>

      <el-form-item>
        <el-checkbox v-model="store.loginFormData.rememberMe">7天内记住密码</el-checkbox>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" class="login-btn" native-type="submit">登录</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup lang="ts">
import { useUserStore } from '@/stores/user-store'
import { onMounted, ref } from 'vue';
import { User, Lock } from '@element-plus/icons-vue';
import SIdentify from '../loginPage/Sidentify.vue'

const identifyCodeVisible = ref(false)
const store = useUserStore()
const formRef = ref()

onMounted(() => {
  if (localStorage.getItem('token') != null) {
    store.autoLogin()
  }
  store.identifyCode = ''
  store.makeCode(store.identifyCodes, 4)
});

const handleSubmit = async () => {
  if (!formRef.value) return;
  try {
    await formRef.value.validate();
    await store.loginOnSubmit();
  } catch {
    // validation failed
  }
};
</script>

<style scoped>
.login {
  padding: 40px;
  width: 300px;
  height: 240px;
}

.login :deep(.el-input__wrapper) {
  border-radius: 10px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06);
}

.login :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.2);
}

.login :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2);
}

.captcha-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 18px;
}

.captcha-label {
  font-size: 14px;
  color: #606266;
}

.login-btn {
  width: 100%;
  border-radius: 10px;
  --el-button-bg-color: #007aff;
  --el-button-border-color: #007aff;
  --el-button-hover-bg-color: #0066d6;
  --el-button-hover-border-color: #0066d6;
}
</style>
