<template>
    <router-view v-slot="{ Component }">
      <component v-if="Component" :is="Component" />
      <div v-else>
            
        <el-row>
            <el-col :span="4"></el-col>
            <el-col :span="4">
              <el-row>
                <p style="font-size: 100px;color: blue;">404</p>
              </el-row>
              <el-row>
                <h1 style="margin: 0;">页面未找到，请检查路由设置。</h1>
              </el-row>
              <el-row style="margin-top: 20px;">
                <el-button type="info"><router-link to="/" style="text-decoration:none;color:inherit;">回到首页</router-link></el-button>
              </el-row>
            </el-col>
        </el-row>
        
      </div>
    </router-view>
  </template>
<script lang="ts" setup>

</script>
<style scoped>

</style>
