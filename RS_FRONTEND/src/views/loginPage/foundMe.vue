<template>
    <div class="foundMe">

        <el-form ref="formRef" :model="foundMeFormRef" :rules="FOUND_FORM_RULES" label-width="0" @submit.prevent="foundSubmit">
            <el-form-item prop="eUsername">
                <el-input v-model="foundMeFormRef.eUsername" clearable placeholder="账号" :prefix-icon="User" />
            </el-form-item>

            <el-form-item prop="eName">
                <el-input v-model="foundMeFormRef.eName" clearable placeholder="姓名" :prefix-icon="UserFilled" />
            </el-form-item>

            <el-form-item prop="eId">
                <el-input v-model="foundMeFormRef.eId" clearable placeholder="身份证号" :prefix-icon="Stamp" />
            </el-form-item>

            <el-form-item prop="ePhone">
                <el-input v-model="foundMeFormRef.ePhone" clearable placeholder="手机号" :prefix-icon="Phone" />
            </el-form-item>

            <el-form-item prop="验证码">
                <el-input placeholder="请输入验证码" v-model="store.sidentifyMode" @click="identifyCodeVisible = true" clearable />
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
                <el-button type="primary" native-type="submit" style="width: 100%">找回</el-button>
            </el-form-item>
        </el-form>
    </div>
</template>
<script setup lang="ts">
import { usefoundMeStore, foundMeFormRef } from '@/stores/foundMe-store'
import { useUserStore } from '@/stores/user-store';
import { onMounted, ref } from 'vue';
import SIdentify from '@/components/loginPage/Sidentify.vue'
import { FOUND_FORM_RULES } from '@/types/foundMeTypes'
import { ElMessage } from "element-plus";
import { foundMeApi } from '@/api/services/foundMe-api';
import { User, UserFilled, Stamp, Phone } from '@element-plus/icons-vue';

const store = useUserStore()
const foundMeStore = usefoundMeStore();
const identifyCodeVisible = ref(false)
const formRef = ref();

onMounted(() => {
    store.identifyCode = ''
    store.makeCode(store.identifyCodes, 4)
});

const foundSubmit = async (formData: any) => {
    try {
        await formRef.value?.validate();
        console.log(foundMeFormRef.value)
        await foundMeApi.update(foundMeFormRef.value).then(() => {
            identifyCodeVisible.value = false
            ElMessage.success('找回成功，您的密码重置为：1234')
        })
    } catch (validationResult: any) {
        if (validationResult && validationResult === false) {
            ElMessage.warning('验证失败');
        } else if (validationResult && validationResult.message) {
            ElMessage.warning(validationResult.message);
        } else {
            ElMessage.warning('验证失败');
        }
    }
}


</script>
<style scoped>
.foundMe {
    padding: 40px;
    width: 300px;
    height: 220px;
}
</style>
