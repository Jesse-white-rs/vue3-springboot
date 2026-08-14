<template>
  <div class="sp-helper">
    <!-- Nav -->
    <nav class="sp-nav" :class="{ 'sp-nav--scrolled': scrolled }">
      <div class="sp-nav__inner">
        <div class="sp-nav__logo">
          <div class="sp-nav__logo-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" fill="currentColor"/></svg>
          </div>
          <span>Seller PC Helper</span>
        </div>
        <div class="sp-nav__actions">
          <a class="sp-nav__link" href="#features">功能</a>
          <a class="sp-nav__link" href="#screenshots">预览</a>
          <button class="sp-nav__btn" @click="downloadFile">立即下载</button>
        </div>
      </div>
    </nav>

    <!-- Hero -->
    <section class="sp-hero" id="hero">
      <div class="sp-hero__bg">
        <div class="sp-hero__particles">
          <span v-for="n in 20" :key="n" class="sp-particle" :style="particleStyle(n)" />
        </div>
        <div class="sp-hero__gradient" />
        <div class="sp-hero__glow sp-hero__glow--1" />
        <div class="sp-hero__glow sp-hero__glow--2" />
        <div class="sp-hero__glow sp-hero__glow--3" />
      </div>
      <div class="sp-hero__content" ref="heroContent">
        <div class="sp-hero__badge">v2.0 · 全新升级</div>
        <h1 class="sp-hero__title">
          <span class="sp-hero__title-line">赛尔AI智慧助手</span>
          <span class="sp-hero__title-sub">你的电脑问题终结者</span>
        </h1>
        <p class="sp-hero__desc">一键诊断 · 智能优化 · 高效运维 — 为每一位 IT 人打造的桌面助手</p>
        <div class="sp-hero__actions">
          <button class="sp-btn sp-btn--primary" @click="downloadFile">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="8 17 12 21 16 17"/><line x1="12" y1="12" x2="12" y2="21"/><path d="M20.88 18.09A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.29"/></svg>
            免费下载
          </button>
          <button class="sp-btn sp-btn--glass" @click="scrollTo('#features')">
            了解更多
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><polyline points="19 12 12 19 5 12"/></svg>
          </button>
        </div>
      </div>
    </section>

    <!-- Stats -->
    <section class="sp-stats" ref="statsSection">
      <div class="sp-stats__inner">
        <div v-for="(s, i) in stats" :key="i" class="sp-stat" ref="statRefs">
          <span class="sp-stat__value"><span ref="countRefs">{{ animatedCounts[i] }}</span>+</span>
          <span class="sp-stat__label">{{ s.label }}</span>
        </div>
      </div>
    </section>

    <!-- Features -->
    <section class="sp-features" id="features">
      <div class="sp-features__inner">
        <div class="sp-section-header" ref="featHeader">
          <span class="sp-section-tag">核心功能</span>
          <h2 class="sp-section-title">为效率而生</h2>
          <p class="sp-section-desc">从诊断到优化，一站式解决电脑问题</p>
        </div>
        <div class="sp-features__grid">
          <div v-for="(f, i) in features" :key="i" class="sp-feature-card" ref="featCards" :style="{ transitionDelay: `${i * 80}ms` }">
            <div class="sp-feature-card__icon" v-html="f.icon" />
            <h3 class="sp-feature-card__title">{{ f.title }}</h3>
            <p class="sp-feature-card__desc">{{ f.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Screenshots / 轮播 -->
    <section class="sp-screenshots" id="screenshots">
      <div class="sp-section-header">
        <span class="sp-section-tag">产品预览</span>
        <h2 class="sp-section-title">简洁而强大</h2>
        <p class="sp-section-desc">精心设计的界面，操作行云流水</p>
      </div>
      <div class="sp-carousel" ref="carouselSection">
        <div class="sp-carousel__track" :style="{ transform: `translateX(-${currentSlide * 100}%)` }">
          <div v-for="(item, i) in carouselData" :key="i" class="sp-carousel__slide">
            <div class="sp-carousel__card">
              <div class="sp-carousel__img">
                <img :src="item.img" :alt="item.title" loading="lazy" />
              </div>
              <div class="sp-carousel__meta">
                <span class="sp-carousel__badge">{{ item.badge }}</span>
                <h3>{{ item.title }}</h3>
                <p>{{ item.desc }}</p>
              </div>
            </div>
          </div>
        </div>
        <div class="sp-carousel__controls">
          <button class="sp-carousel__btn" @click="prevSlide" aria-label="上一张">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
          </button>
          <div class="sp-carousel__dots">
            <span v-for="(_, i) in carouselData" :key="i" :class="['sp-carousel__dot', { active: currentSlide === i }]" @click="goToSlide(i)" />
          </div>
          <button class="sp-carousel__btn" @click="nextSlide" aria-label="下一张">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          </button>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="sp-cta" ref="ctaSection">
      <div class="sp-cta__bg">
        <div class="sp-cta__gradient" />
        <div class="sp-cta__glow" />
      </div>
      <div class="sp-cta__content">
        <h2 class="sp-cta__title">现在就体验赛尔助手</h2>
        <p class="sp-cta__desc">免费下载，开启高效办公之旅</p>
        <button class="sp-btn sp-btn--primary sp-btn--large" @click="downloadFile">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="8 17 12 21 16 17"/><line x1="12" y1="12" x2="12" y2="21"/><path d="M20.88 18.09A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.29"/></svg>
          免费下载
        </button>
        <p class="sp-cta__version">v2.0 · 支持 Windows 10/11 · 17.8 MB</p>
      </div>
    </section>

    <!-- Footer -->
    <footer class="sp-footer">
      <div class="sp-footer__inner">
        <div class="sp-footer__brand">
          <div class="sp-footer__logo">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" fill="currentColor"/></svg>
          </div>
          <span>Seller PC Helper</span>
        </div>
        <p class="sp-footer__copy">&copy; 2026 赛尔助手 · All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from "vue";
import axios from "axios";

const scrolled = ref(false);
const heroContent = ref(null);
const statsSection = ref(null);
const featHeader = ref(null);
const featCards = ref([]);
const carouselSection = ref(null);
const ctaSection = ref(null);

const countRefs = ref([]);
const statRefs = ref([]);
const animatedCounts = ref([0, 0, 0]);

const stats = [
  { value: 10000, label: "活跃用户" },
  { value: 99.9, label: "稳定运行", suffix: "%" },
  { value: 999, label: "累计问题解决" },
];

const features = [
  {
    title: "智能诊断",
    desc: "一键扫描系统状态，精准定位问题根源，秒级生成诊断报告。",
    icon: '<svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>',
  },
  {
    title: "一键优化",
    desc: "自动清理系统垃圾、修复注册表、释放内存，让电脑恢复最佳状态。",
    icon: '<svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>',
  },
  {
    title: "网络修复",
    desc: "深度检测网络连接、DNS 解析、代理配置，一键恢复网络畅通。",
    icon: '<svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>',
  },
  {
    title: "打印机修复",
    desc: "自动检测打印机驱动、服务状态，快速解决打印异常问题。",
    icon: '<svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>',
  },
  {
    title: "工具箱",
    desc: "内含计算器、秒表、倒计时、随机数生成等丰富效率工具。",
    icon: '<svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="2" y="2" width="20" height="8" rx="2" ry="2"/><rect x="2" y="14" width="8" height="8" rx="2" ry="2"/><path d="M16 16h6M19 13v6"/></svg>',
  },
  {
    title: "安全防护",
    desc: "多重加密保障数据安全，实时检测系统异常，主动防御威胁。",
    icon: '<svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>',
  },
];

// Carousel
const carouselData = [
  { img: new URL("../assets/img/app-img/1.png", import.meta.url).href, badge: "高效", title: "一键式直达IT服务", desc: "轻松找到IT人员，迅速解决问题，让您的工作更加高效便捷。" },
  { img: new URL("../assets/img/app-img/2.png", import.meta.url).href, badge: "智能", title: "丰富小工具", desc: "内含多个自动化工具，提升您的办公效率，释放更多生产力。" },
  { img: new URL("../assets/img/app-img/3.png", import.meta.url).href, badge: "精准", title: "精准解析您的设备", desc: "自动识别您当前的设备，辅助办公运维，让管理更简单。" },
];

const currentSlide = ref(0);
let autoplayTimer = null;

const nextSlide = () => { currentSlide.value = (currentSlide.value + 1) % carouselData.length; };
const prevSlide = () => { currentSlide.value = (currentSlide.value - 1 + carouselData.length) % carouselData.length; };
const goToSlide = (i) => { currentSlide.value = i; };

// Particle styles
const particleStyle = (n) => {
  const size = 2 + Math.random() * 4;
  return {
    width: `${size}px`,
    height: `${size}px`,
    left: `${Math.random() * 100}%`,
    top: `${Math.random() * 100}%`,
    animationDelay: `${Math.random() * 8}s`,
    animationDuration: `${6 + Math.random() * 6}s`,
    opacity: 0.2 + Math.random() * 0.4,
  };
};

// Scroll reveal
let observer = null;
const revealed = new Set();

const observeElement = (el) => {
  if (!el || revealed.has(el)) return;
  revealed.add(el);
  el.classList.add("sp-reveal");
};

onMounted(async () => {
  await nextTick();

  // Nav scroll
  const onScroll = () => { scrolled.value = window.scrollY > 40; };
  window.addEventListener("scroll", onScroll, { passive: true });

  // Intersection Observer
  const targets = [
    heroContent.value, statsSection.value, featHeader.value,
    ...featCards.value.filter(Boolean), carouselSection.value, ctaSection.value,
  ];

  observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("sp-reveal--visible");
      }
    });
  }, { threshold: 0.15, rootMargin: "0px 0px -60px 0px" });

  targets.forEach((el) => { if (el) observer.observe(el); });

  // Animate stats counters
  const animateCounters = () => {
    const duration = 2000;
    const start = performance.now();
    const targets = [
      { current: 0, target: 10000 },
      { current: 0, target: 99.9 },
      { current: 0, target: 999 },
    ];
    const step = (now) => {
      const elapsed = now - start;
      const progress = Math.min(elapsed / duration, 1);
      const ease = 1 - Math.pow(1 - progress, 3);
      targets.forEach((t, i) => {
        animatedCounts.value[i] = Math.round(t.target * ease);
      });
      if (progress < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
  };

  // Observe stats for counter animation
  if (statsSection.value) {
    const statsObs = new IntersectionObserver(([entry]) => {
      if (entry.isIntersecting) {
        animateCounters();
        statsObs.disconnect();
      }
    }, { threshold: 0.3 });
    statsObs.observe(statsSection.value);
  }

  // Autoplay carousel
  autoplayTimer = setInterval(nextSlide, 5000);
});

onUnmounted(() => {
  if (autoplayTimer) clearInterval(autoplayTimer);
  if (observer) observer.disconnect();
});

const scrollTo = (sel) => {
  const el = document.querySelector(sel);
  if (el) el.scrollIntoView({ behavior: "smooth" });
};

const downloaded = ref(false);
const downloadFile = () => {
  const fileId = 47;
  axios({
    url: `http://192.168.24.6:8080/version/download/${fileId}`,
    method: "GET",
    responseType: "blob",
  }).then((resp) => {
    const blob = new Blob([resp.data], { type: "application/octet-stream" });
    const link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = "Seller_PC_Helper_Setup.exe";
    link.click();
    downloaded.value = true;
  }).catch(() => {});
};
</script>

<style>
/* ===== GLOBAL RESET ===== */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

.sp-helper {
  --sp-blue: #3b82f6;
  --sp-purple: #8b5cf6;
  --sp-cyan: #06b6d4;
  --sp-bg: #0a0a0f;
  --sp-surface: #12121a;
  --sp-card: #1a1a26;
  --sp-border: rgba(255,255,255,0.06);
  --sp-text: #f1f5f9;
  --sp-muted: #94a3b8;
  --sp-radius: 16px;
  --sp-radius-sm: 12px;
  --sp-gap: clamp(60px, 10vw, 120px);
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "SF Pro Text", "Helvetica Neue", "PingFang SC", sans-serif;
  background: var(--sp-bg);
  color: var(--sp-text);
  overflow-x: hidden;
  -webkit-font-smoothing: antialiased;
}

/* ===== SCROLL REVEAL ===== */
.sp-reveal { opacity: 0; transform: translateY(36px); transition: opacity 0.8s cubic-bezier(0.16,1,0.3,1), transform 0.8s cubic-bezier(0.16,1,0.3,1); }
.sp-reveal--visible { opacity: 1; transform: translateY(0); }

/* ===== NAV ===== */
.sp-nav {
  position: fixed; top: 0; left: 0; right: 0; z-index: 1000;
  padding: 12px 24px;
  transition: all 0.5s cubic-bezier(0.16,1,0.3,1);
}
.sp-nav--scrolled {
  padding: 8px 24px;
  background: rgba(10,10,15,0.72);
  backdrop-filter: blur(24px) saturate(1.4);
  -webkit-backdrop-filter: blur(24px) saturate(1.4);
  border-bottom: 0.5px solid rgba(255,255,255,0.06);
}
.sp-nav__inner {
  max-width: 1200px; margin: 0 auto;
  display: flex; align-items: center; justify-content: space-between;
}
.sp-nav__logo {
  display: flex; align-items: center; gap: 10px;
  font-size: 16px; font-weight: 600; color: var(--sp-text);
}
.sp-nav__logo-icon {
  width: 34px; height: 34px;
  background: linear-gradient(135deg, var(--sp-blue), var(--sp-purple));
  border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
  color: #fff; font-size: 16px;
}
.sp-nav__actions { display: flex; align-items: center; gap: 24px; }
.sp-nav__link {
  color: var(--sp-muted); text-decoration: none; font-size: 14px; font-weight: 500;
  transition: color 0.3s;
}
.sp-nav__link:hover { color: var(--sp-text); }
.sp-nav__btn {
  padding: 8px 20px;
  background: linear-gradient(135deg, var(--sp-blue), var(--sp-purple));
  color: #fff; border: none; border-radius: 8px;
  font-size: 14px; font-weight: 600; cursor: pointer;
  transition: all 0.3s ease;
}
.sp-nav__btn:hover { transform: translateY(-1px); box-shadow: 0 4px 20px rgba(59,130,246,0.35); }

/* ===== HERO ===== */
.sp-hero {
  position: relative; min-height: 100vh;
  display: flex; align-items: center; justify-content: center;
  overflow: hidden;
}
.sp-hero__bg { position: absolute; inset: 0; overflow: hidden; }
.sp-hero__gradient {
  position: absolute; inset: 0;
  background: radial-gradient(ellipse 80% 60% at 50% 20%, rgba(59,130,246,0.15) 0%, transparent 60%),
              radial-gradient(ellipse 60% 50% at 80% 80%, rgba(139,92,246,0.1) 0%, transparent 50%),
              radial-gradient(ellipse 50% 40% at 20% 60%, rgba(6,182,212,0.08) 0%, transparent 50%);
}
.sp-hero__glow {
  position: absolute; border-radius: 50%; filter: blur(100px);
  pointer-events: none; opacity: 0.5;
}
.sp-hero__glow--1 {
  width: 600px; height: 600px; top: -200px; right: -100px;
  background: var(--sp-blue);
  animation: sp-float1 12s ease-in-out infinite;
}
.sp-hero__glow--2 {
  width: 400px; height: 400px; bottom: -100px; left: -80px;
  background: var(--sp-purple);
  animation: sp-float2 10s ease-in-out infinite reverse;
}
.sp-hero__glow--3 {
  width: 350px; height: 350px; top: 50%; left: 50%; transform: translate(-50%,-50%);
  background: var(--sp-cyan);
  animation: sp-float1 14s ease-in-out infinite; opacity: 0.3;
}
@keyframes sp-float1 { 0%,100% { transform: translate(0,0) scale(1); } 33% { transform: translate(30px,-40px) scale(1.08); } 66% { transform: translate(-20px,20px) scale(0.95); } }
@keyframes sp-float2 { 0%,100% { transform: translate(0,0) scale(1); } 50% { transform: translate(-40px,30px) scale(1.06); } }

/* Particles */
.sp-hero__particles { position: absolute; inset: 0; }
.sp-particle {
  position: absolute; border-radius: 50%;
  background: var(--sp-blue);
  animation: sp-particle 8s ease-in-out infinite;
}
@keyframes sp-particle {
  0%,100% { transform: translateY(0) scale(1); opacity: 0.2; }
  25% { transform: translateY(-60px) scale(1.4); opacity: 0.6; }
  50% { transform: translateY(0) scale(0.8); opacity: 0.3; }
  75% { transform: translateY(40px) scale(1.2); opacity: 0.5; }
}

.sp-hero__content {
  position: relative; z-index: 2;
  text-align: center; max-width: 720px; padding: 120px 24px 80px;
}
.sp-hero__badge {
  display: inline-block; margin-bottom: 28px;
  padding: 6px 18px;
  background: rgba(255,255,255,0.05);
  backdrop-filter: blur(8px); border: 0.5px solid rgba(255,255,255,0.08);
  border-radius: 100px;
  font-size: 13px; font-weight: 500; color: var(--sp-muted);
  letter-spacing: 0.3px;
}
.sp-hero__title { margin-bottom: 20px; }
.sp-hero__title-line {
  display: block;
  font-size: clamp(48px, 10vw, 88px);
  font-weight: 800;
  background: linear-gradient(135deg, #fff 0%, #94a3b8 50%, #fff 100%);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent;
  background-clip: text;
  line-height: 1.05;
  letter-spacing: -2px;
}
.sp-hero__title-sub {
  display: block;
  font-size: clamp(20px, 4vw, 36px);
  font-weight: 600;
  color: var(--sp-muted);
  margin-top: 8px;
  letter-spacing: -0.5px;
}
.sp-hero__desc {
  font-size: clamp(15px, 2vw, 18px);
  color: var(--sp-muted);
  line-height: 1.7;
  margin-bottom: 40px;
  max-width: 540px; margin-left: auto; margin-right: auto;
}
.sp-hero__actions { display: flex; gap: 16px; justify-content: center; flex-wrap: wrap; }

/* ===== BUTTONS ===== */
.sp-btn {
  display: inline-flex; align-items: center; gap: 10px;
  padding: 14px 32px; border: none; border-radius: var(--sp-radius-sm);
  font-size: 16px; font-weight: 600; cursor: pointer;
  transition: all 0.35s cubic-bezier(0.16,1,0.3,1);
  text-decoration: none;
}
.sp-btn--primary {
  background: linear-gradient(135deg, var(--sp-blue), var(--sp-purple));
  color: #fff;
  box-shadow: 0 4px 24px rgba(59,130,246,0.3);
}
.sp-btn--primary:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 40px rgba(59,130,246,0.4);
}
.sp-btn--primary:active { transform: translateY(-1px) scale(0.98); }
.sp-btn--glass {
  background: rgba(255,255,255,0.04);
  backdrop-filter: blur(12px);
  border: 0.5px solid rgba(255,255,255,0.08);
  color: var(--sp-text);
}
.sp-btn--glass:hover {
  background: rgba(255,255,255,0.08);
  transform: translateY(-2px);
}
.sp-btn--large { padding: 16px 40px; font-size: 18px; }

/* ===== STATS ===== */
.sp-stats {
  padding: 0 24px;
  margin: calc(var(--sp-gap) * -0.5) auto var(--sp-gap);
  max-width: 1200px;
}
.sp-stats__inner {
  display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;
}
.sp-stat {
  background: var(--sp-surface);
  border-radius: var(--sp-radius);
  padding: 36px 24px; text-align: center;
  border: 0.5px solid var(--sp-border);
  transition: all 0.4s ease;
}
.sp-stat:hover {
  transform: translateY(-4px);
  border-color: rgba(59,130,246,0.2);
  box-shadow: 0 8px 32px rgba(0,0,0,0.3);
}
.sp-stat__value {
  display: block;
  font-size: 36px; font-weight: 800;
  background: linear-gradient(135deg, var(--sp-blue), var(--sp-cyan));
  -webkit-background-clip: text; -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 6px;
}
.sp-stat__label { font-size: 14px; color: var(--sp-muted); font-weight: 500; }

/* ===== SECTION HEADER ===== */
.sp-section-header { text-align: center; margin-bottom: 56px; }
.sp-section-tag {
  display: inline-block;
  padding: 4px 14px;
  background: rgba(59,130,246,0.08);
  border: 0.5px solid rgba(59,130,246,0.15);
  border-radius: 100px;
  font-size: 12px; font-weight: 600; color: var(--sp-blue);
  letter-spacing: 1px; text-transform: uppercase;
  margin-bottom: 16px;
}
.sp-section-title {
  font-size: clamp(32px, 5vw, 48px);
  font-weight: 700;
  color: var(--sp-text);
  margin-bottom: 12px;
  letter-spacing: -1px;
}
.sp-section-desc {
  font-size: 16px; color: var(--sp-muted);
  max-width: 500px; margin: 0 auto;
}

/* ===== FEATURES ===== */
.sp-features {
  padding: 0 24px;
  max-width: 1200px; margin: 0 auto var(--sp-gap);
}
.sp-features__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
}
.sp-feature-card {
  background: var(--sp-surface);
  border-radius: var(--sp-radius);
  padding: 32px 28px;
  border: 0.5px solid var(--sp-border);
  transition: all 0.5s cubic-bezier(0.16,1,0.3,1);
}
.sp-feature-card:hover {
  transform: translateY(-6px);
  border-color: rgba(59,130,246,0.2);
  box-shadow: 0 12px 40px rgba(0,0,0,0.3), 0 0 60px rgba(59,130,246,0.05);
}
.sp-feature-card__icon {
  width: 48px; height: 48px;
  background: linear-gradient(135deg, rgba(59,130,246,0.12), rgba(139,92,246,0.12));
  border-radius: 14px;
  display: flex; align-items: center; justify-content: center;
  color: var(--sp-blue); margin-bottom: 20px;
  transition: all 0.4s ease;
}
.sp-feature-card:hover .sp-feature-card__icon {
  background: linear-gradient(135deg, var(--sp-blue), var(--sp-purple));
  color: #fff;
  box-shadow: 0 4px 20px rgba(59,130,246,0.3);
}
.sp-feature-card__title {
  font-size: 18px; font-weight: 600; color: var(--sp-text);
  margin-bottom: 10px;
}
.sp-feature-card__desc {
  font-size: 14px; color: var(--sp-muted); line-height: 1.7;
}

/* ===== CAROUSEL ===== */
.sp-screenshots {
  padding: 0 24px;
  max-width: 1200px; margin: 0 auto var(--sp-gap);
}
.sp-carousel {
  background: var(--sp-surface);
  border-radius: var(--sp-radius);
  overflow: hidden;
  border: 0.5px solid var(--sp-border);
}
.sp-carousel__track { display: flex; transition: transform 0.6s cubic-bezier(0.22,1,0.36,1); }
.sp-carousel__slide { min-width: 100%; }
.sp-carousel__card {
  display: flex; align-items: center; gap: 48px;
  padding: 48px;
}
.sp-carousel__img {
  flex: 1; min-width: 0;
}
.sp-carousel__img img {
  width: 100%; max-width: 420px; height: auto;
  border-radius: var(--sp-radius-sm);
  box-shadow: 0 8px 32px rgba(0,0,0,0.4);
  display: block;
}
.sp-carousel__meta { flex: 1; }
.sp-carousel__badge {
  display: inline-block;
  padding: 4px 12px;
  background: linear-gradient(135deg, var(--sp-blue), var(--sp-purple));
  color: #fff; border-radius: 6px;
  font-size: 11px; font-weight: 600;
  text-transform: uppercase; letter-spacing: 1px;
  margin-bottom: 14px;
}
.sp-carousel__meta h3 {
  font-size: 26px; font-weight: 700;
  color: var(--sp-text); margin-bottom: 12px;
}
.sp-carousel__meta p {
  font-size: 15px; color: var(--sp-muted); line-height: 1.7;
}
.sp-carousel__controls {
  display: flex; align-items: center; justify-content: center; gap: 16px;
  padding: 20px; border-top: 0.5px solid var(--sp-border);
}
.sp-carousel__btn {
  width: 38px; height: 38px; border-radius: 50%;
  border: 0.5px solid var(--sp-border);
  background: transparent; color: var(--sp-muted);
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  transition: all 0.3s ease;
}
.sp-carousel__btn:hover { background: rgba(59,130,246,0.1); color: var(--sp-blue); border-color: rgba(59,130,246,0.2); }
.sp-carousel__dots { display: flex; gap: 8px; }
.sp-carousel__dot {
  width: 8px; height: 8px; border-radius: 50%;
  background: rgba(255,255,255,0.12); cursor: pointer;
  transition: all 0.4s ease;
}
.sp-carousel__dot.active { background: var(--sp-blue); width: 24px; border-radius: 4px; }

/* ===== CTA ===== */
.sp-cta {
  position: relative;
  max-width: 1200px; margin: 0 auto var(--sp-gap);
  border-radius: var(--sp-radius);
  overflow: hidden; padding: 80px 24px; text-align: center;
}
.sp-cta__bg { position: absolute; inset: 0; z-index: 0; }
.sp-cta__gradient {
  position: absolute; inset: 0;
  background: var(--sp-surface);
  border: 0.5px solid var(--sp-border);
  border-radius: var(--sp-radius);
}
.sp-cta__glow {
  position: absolute; top: 50%; left: 50%;
  width: 500px; height: 500px;
  transform: translate(-50%,-50%);
  background: radial-gradient(circle, rgba(59,130,246,0.12) 0%, transparent 70%);
  border-radius: 50%;
  animation: sp-pulse 6s ease-in-out infinite;
}
@keyframes sp-pulse { 0%,100% { transform: translate(-50%,-50%) scale(1); opacity: 0.5; } 50% { transform: translate(-50%,-50%) scale(1.3); opacity: 1; } }
.sp-cta__content { position: relative; z-index: 1; }
.sp-cta__title {
  font-size: clamp(28px, 5vw, 44px); font-weight: 700;
  color: var(--sp-text); margin-bottom: 12px;
}
.sp-cta__desc {
  font-size: 16px; color: var(--sp-muted); margin-bottom: 32px;
}
.sp-cta__version { margin-top: 16px; font-size: 13px; color: var(--sp-muted); }

/* ===== FOOTER ===== */
.sp-footer {
  border-top: 0.5px solid var(--sp-border);
  padding: 24px;
}
.sp-footer__inner {
  max-width: 1200px; margin: 0 auto;
  display: flex; justify-content: space-between; align-items: center;
}
.sp-footer__brand { display: flex; align-items: center; gap: 8px; font-size: 14px; color: var(--sp-muted); }
.sp-footer__logo { color: var(--sp-blue); display: flex; }
.sp-footer__copy { font-size: 13px; color: var(--sp-muted); }

/* ===== RESPONSIVE ===== */
@media (max-width: 768px) {
  .sp-nav__link { display: none; }
  .sp-hero__content { padding-top: 100px; }
  .sp-hero__actions { flex-direction: column; align-items: center; }
  .sp-btn { width: 100%; justify-content: center; }
  .sp-stats__inner { grid-template-columns: 1fr; }
  .sp-carousel__card { flex-direction: column; padding: 32px 24px; }
  .sp-carousel__meta { text-align: center; }
  .sp-footer__inner { flex-direction: column; gap: 8px; text-align: center; }
}
</style>
