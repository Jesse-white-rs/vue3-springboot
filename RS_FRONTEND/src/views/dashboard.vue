<template>
  <div class="dashboard-page">
    <div class="dashboard-cards">
      <div class="stat-card" v-for="item in statList" :key="item.title">
        <div class="stat-icon" :style="{ background: item.gradient }">
          <el-icon :size="24"><component :is="item.icon" /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-title">{{ item.title }}</div>
          <div class="stat-value">{{ item.value }}</div>
        </div>
      </div>
    </div>

    <div class="query-card">
      <div class="query-left">
        <el-icon :size="20" class="query-icon"><Search /></el-icon>
        <span class="query-label">功能点击查询</span>
      </div>
      <div class="query-right">
        <el-select v-model="queryKey" placeholder="选择功能" clearable class="query-select">
          <el-option v-for="item in functionOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
        <el-button type="primary" :disabled="!queryKey || queryLoading" :loading="queryLoading" @click="handleQuery">
          查询
        </el-button>
      </div>
      <transition name="fade-slide" mode="out-in">
        <div v-if="queryResult !== null" :key="queryKey" class="query-result">
          <span class="query-result-name">{{ queryResultName }}</span>
          <span class="query-result-count">{{ queryResult }}</span>
          <span class="query-result-unit">次</span>
        </div>
      </transition>
    </div>

    <div class="chart-section">
      <div class="chart-title">功能使用统计</div>
      <appsClickedRecordViewing />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { getButtonClickCount } from '@/api/services/dashboard-api';
import { usePcInfoStore } from '@/stores/pcInfo-store';
import { DataLine, Monitor, User, Search } from '@element-plus/icons-vue';
import appsClickedRecordViewing from './dashboard/appsClickedRecordViewing.vue';

const nowRecord = ref<number>(0);
const pcRecord = ref<number>(0);
const queryKey = ref('');
const queryResult = ref<number | null>(null);
const queryResultName = ref('');
const queryLoading = ref(false);

const functionOptions = [
  { label: '常用网站打开', value: 'openInChrome' },
  { label: '一键优化', value: 'yjyh' },
  { label: '登录帐号', value: 'handleLoginBtn' },
  { label: '邮箱有效性查询', value: 'emailQuery' },
  { label: '网络测速', value: 'rtool-speedtest' },
  { label: '多国语言互译', value: 'rtool-translate' },
  { label: '世界时钟', value: 'rtool-worldclock' },
  { label: '倒计时器', value: 'rtool-countdown' },
  { label: '番茄钟', value: 'rtool-pomodoro' },
  { label: '秒表', value: 'rtool-stopwatch' },
  { label: '图片格式互转', value: 'rtool-imageconvert' },
  { label: '批量下载图片', value: 'rtool-imgdownload' },
  { label: '科学计算器', value: 'rtool-calculator' },
  { label: '随机决策助手', value: 'rtool-decision' },
  { label: '随机数生成器', value: 'rtool-random' },
  { label: '密码生成器', value: 'rtool-password' },
  { label: '文本统计', value: 'rtool-textstats' },
  { label: '今天吃什么', value: 'rtool-food' },
  { label: '塔罗牌占卜', value: 'rtool-tarot' },
  { label: '备忘录', value: 'rtool-memo' },
  { label: '快捷复制器', value: 'rtool-quickcopy' },
];

async function handleQuery() {
  if (!queryKey.value) return;
  queryLoading.value = true;
  try {
    const res = await getButtonClickCount(queryKey.value);
    queryResult.value = res?.data?.result || 0;
    queryResultName.value = functionOptions.find(o => o.value === queryKey.value)?.label || '';
  } catch {
    queryResult.value = 0;
  } finally {
    queryLoading.value = false;
  }
}

const statList = computed(() => [
  {
    title: '今日访问',
    value: nowRecord.value,
    icon: DataLine,
    gradient: 'linear-gradient(135deg, #007aff, #34aadc)',
  },
  {
    title: '装机量',
    value: pcRecord.value,
    icon: Monitor,
    gradient: 'linear-gradient(135deg, #34c759, #30d158)',
  },
  {
    title: '在线用户',
    value: 'null',
    icon: User,
    gradient: 'linear-gradient(135deg, #ff9500, #ff6b00)',
  },
]);

onMounted(async () => {
  try {
    const response = await getButtonClickCount('index');
    if (response.data && response.data.result) {
      nowRecord.value = response.data.result;
    }
  } catch (error) {
    console.error('请求失败:', error);
  }
  try {
    const pcInfoStore = usePcInfoStore();
    await pcInfoStore.fetchPageData();
    pcRecord.value = pcInfoStore.pageDataSum;
  } catch (error) {
    console.error('获取 PC 信息失败:', error);
  }
});
</script>

<style scoped>
.dashboard-page {
  padding: 0;
}

.dashboard-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.stat-card {
  background: #fff;
  border-radius: 18px;
  display: flex;
  align-items: center;
  padding: 24px;
  gap: 18px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.08);
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.stat-info {
  flex: 1;
  min-width: 0;
}

.stat-title {
  font-size: 13px;
  font-weight: 500;
  color: #8e8e93;
  margin-bottom: 6px;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #1d1d1f;
  letter-spacing: -0.5px;
}

.chart-section {
  margin-top: 24px;
  background: #fff;
  border-radius: 18px;
  padding: 20px 16px 8px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}

.chart-title {
  font-size: 16px;
  font-weight: 600;
  color: #1d1d1f;
  padding: 0 8px 12px;
}

.query-card {
  margin-top: 24px;
  background: #fff;
  border-radius: 18px;
  padding: 20px 24px;
  border: 0.5px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  display: flex;
  align-items: center;
  gap: 20px;
  flex-wrap: wrap;
}

.query-left {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

.query-icon {
  color: #007aff;
}

.query-label {
  font-size: 15px;
  font-weight: 600;
  color: #1d1d1f;
  white-space: nowrap;
}

.query-right {
  display: flex;
  align-items: center;
  gap: 10px;
}

.query-select {
  width: 200px;
}

.query-result {
  margin-left: auto;
  display: flex;
  align-items: baseline;
  gap: 6px;
}

.query-result-name {
  font-size: 13px;
  color: #8e8e93;
}

.query-result-count {
  font-size: 28px;
  font-weight: 700;
  color: #007aff;
  letter-spacing: -0.5px;
}

.query-result-unit {
  font-size: 13px;
  color: #8e8e93;
}

.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.3s ease;
}
.fade-slide-enter-from {
  opacity: 0;
  transform: translateX(12px);
}
.fade-slide-leave-to {
  opacity: 0;
  transform: translateX(-12px);
}
</style>
