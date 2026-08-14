<template>
    <div class="reg">
    <el-form ref="form" :model="store.regFormData" :rules="store.REG_FORM_RULES" :label-width="0" @submit.prevent="handleReg">
            <el-form-item name="account" prop="account">
                <el-input v-model="store.regFormData.account" clearable placeholder="账号">
                    <template #prefix>
                        <user-icon />
                    </template>
                </el-input>
            </el-form-item>
            <el-form-item name="password" prop="password">
                <el-input v-model="store.regFormData.password" type="password" clearable placeholder="密码" show-password>
                    <template #prefix>
                        <lock-on-icon />
                    </template>
                </el-input>
            </el-form-item>
            <el-form-item name="eid" prop="eid">
                <el-input v-model="store.regFormData.eid" clearable placeholder="身份证号">
                    <template #prefix>
                        <verify-icon />
                    </template>
                </el-input>
            </el-form-item>
            <el-form-item name="phone" prop="phone">
                <el-input v-model="store.regFormData.phone" clearable placeholder="手机号">
                    <template #prefix>
                        <call-icon />
                    </template>
                </el-input>
            </el-form-item>
            <el-form-item name="验证码" prop="验证码">
                <el-input placeholder="请输入验证码" v-model="store.sidentifyMode" @click="identifyCodeVisible = true" style="width: 100%"
                    clearable></el-input>

            </el-form-item>
            <div @click="store.refreshCode" v-if="identifyCodeVisible">
                <el-row>
                    <el-col :span="4">
                        验证码：
                    </el-col>
                    <el-col :span="8">
                        <SIdentify :identifyCode="store.identifyCode"></SIdentify>
                    </el-col>
                </el-row>
            </div>
            <el-form-item>
                <el-button type="primary" native-type="submit" style="width: 100%">注册</el-button>
            </el-form-item>
        </el-form>
</div>
</template>
<script lang="ts" setup>
import { useUserStore } from '@/stores/user-store'
import SIdentify from '../loginPage/Sidentify.vue'
import { ref} from 'vue'

const identifyCodeVisible = ref(false)
const store = useUserStore()
const form = ref()

const handleReg = async () => {
  if (!form.value) return;
  try {
    await form.value.validate();
    await store.regOnSubmit();
  } catch {
    // validation failed
  }
};
</script>
<style scoped>
.reg {
    padding: 40px;
    width: 300px;
    height: 200px;
    margin-bottom: 30px;
}   
</style>
