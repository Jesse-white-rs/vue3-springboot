<template>
  <div ref="echartRef" class="chart-box" />
</template>

<script setup lang="ts">
import * as echarts from "echarts";
import { ref, onMounted, onBeforeUnmount, nextTick } from "vue";
import { getButtonClickCount } from "@/api/services/dashboard-api";

const echartRef = ref<HTMLDivElement | null>(null);
let chart: echarts.ECharts | null = null;

const labelMap: Record<string, string> = {
  openInChrome: "常用网站打开",
  yjyh: "一键优化",
  handleLoginBtn: "登录帐号",
  emailQuery: "邮箱有效性查询",
  "rtool-speedtest": "网络测速",
  "rtool-translate": "多国语言互译",
  "rtool-worldclock": "世界时钟",
  "rtool-countdown": "倒计时器",
  "rtool-pomodoro": "番茄钟",
  "rtool-stopwatch": "秒表",
  "rtool-imageconvert": "图片格式互转",
  "rtool-imgdownload": "批量下载图片",
  "rtool-calculator": "科学计算器",
  "rtool-decision": "随机决策助手",
  "rtool-random": "随机数生成器",
  "rtool-password": "密码生成器",
  "rtool-textstats": "文本统计",
  "rtool-food": "今天吃什么",
  "rtool-tarot": "塔罗牌占卜",
  "rtool-memo": "备忘录",
  "rtool-quickcopy": "快捷复制器",
};

const featureKeys = Object.keys(labelMap);

const renderChart = async () => {
  if (!echartRef.value) return;

  const dataPromises = featureKeys.map(async (key) => {
    const res = await getButtonClickCount(key);
    return {
      name: labelMap[key],
      value: res?.data?.result || 0,
    };
  });

  const result = (await Promise.all(dataPromises))
    .filter((r) => r.value > 0)
    .sort((a, b) => b.value - a.value);
  chart = echarts.init(echartRef.value);

  chart.setOption({
    tooltip: {
      trigger: "axis",
      backgroundColor: "rgba(255,255,255,0.96)",
      borderColor: "rgba(0,0,0,0.06)",
      borderWidth: 1,
      padding: [12, 16],
      textStyle: { color: "#1d1d1f", fontSize: 13 },
      axisPointer: { type: "shadow", shadowStyle: { color: "rgba(0,122,255,0.06)" } },
      formatter(params: any) {
        const item = params[0];
        return `<div style="font-weight:600;margin-bottom:4px">${item.name}</div><div style="color:#007aff;font-size:18px;font-weight:700">${item.value}</div><div style="color:#8e8e93;font-size:12px;margin-top:2px">次点击</div>`;
      },
    },
    grid: {
      top: 16,
      right: 24,
      bottom: result.length > 12 ? 48 : 8,
      left: 16,
      containLabel: true,
    },
    dataZoom: result.length > 12 ? [{
      type: "slider",
      xAxisIndex: 0,
      start: 0,
      end: 50,
      height: 28,
      bottom: 4,
      borderColor: "rgba(0,0,0,0.06)",
      fillerColor: "rgba(0,122,255,0.08)",
      handleStyle: { color: "#007aff", borderColor: "#007aff" },
      textStyle: { color: "#8e8e93", fontSize: 11 },
      brushSelect: false,
    }] : [],
    xAxis: {
      type: "category",
      data: result.map((r) => r.name),
      axisLine: { lineStyle: { color: "rgba(0,0,0,0.06)" } },
      axisTick: { show: false },
      axisLabel: {
        color: "#8e8e93",
        fontSize: 12,
        interval: 0,
        rotate: result.length > 6 ? 25 : 0,
      },
    },
    yAxis: {
      type: "value",
      splitLine: { lineStyle: { color: "rgba(0,0,0,0.04)", type: "dashed" } },
      axisLine: { show: false },
      axisTick: { show: false },
      axisLabel: { color: "#8e8e93", fontSize: 12 },
    },
    series: [
      {
        type: "bar",
        data: result.map((r) => r.value),
        barWidth: "45%",
        itemStyle: {
          borderRadius: [8, 8, 0, 0],
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: "#34aadc" },
            { offset: 1, color: "#007aff" },
          ]),
        },
        emphasis: {
          itemStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: "#5bc0f8" },
              { offset: 1, color: "#007aff" },
            ]),
            shadowColor: "rgba(0,122,255,0.24)",
            shadowBlur: 12,
          },
        },
        label: {
          show: true,
          position: "top",
          color: "#007aff",
          fontSize: 13,
          fontWeight: 600,
        },
      },
    ],
  });
};

const handleResize = () => chart?.resize();

onMounted(async () => {
  await nextTick();
  renderChart();
  window.addEventListener("resize", handleResize);
});

onBeforeUnmount(() => {
  window.removeEventListener("resize", handleResize);
  chart?.dispose();
  chart = null;
});
</script>

<style scoped>
.chart-box {
  width: 100%;
  height: 340px;
}
</style>
