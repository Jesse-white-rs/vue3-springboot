<template>
  <div class="app">
    <header class="header">
      <h1 class="header__title">今天吃什么</h1>
      <p class="header__sub">再也不用纠结每一餐</p>
    </header>

    <div class="tabs">
      <button :class="['tab', { active: mode === 'cook' }]" @click="mode = 'cook'">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M8 21h8M12 21V10"/><path d="M6 10c0-3.3 2.7-6 6-6s6 2.7 6 6H6z"/></svg>
        自己做
      </button>
      <button :class="['tab', { active: mode === 'eatout' }]" @click="mode = 'eatout'">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2v0a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
        外面吃
      </button>
    </div>

    <div class="card">
      <div class="card__header">
        <h2 class="card__title">{{ mode === 'cook' ? '我的菜谱' : '常去店铺' }}</h2>
        <span class="card__count">{{ items.length }} 项</span>
      </div>

      <div class="add-row">
        <input
          v-model="inputText"
          class="add-input"
          :placeholder="mode === 'cook' ? '输入菜品名称...' : '输入店铺名称...'"
          @keyup.enter="addItem"
          maxlength="30"
        />
        <button class="add-btn" @click="addItem" :disabled="!inputText.trim()">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        </button>
      </div>

      <ul class="list">
        <li v-for="item in items" :key="item.id" class="list-item">
          <span class="list-item__text">{{ item.name }}</span>
          <button class="list-item__del" @click="deleteItem(item.id)">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
          </button>
        </li>
        <li v-if="items.length === 0" class="list-empty">
          <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" opacity="0.3"><circle cx="12" cy="12" r="10"/><path d="M8 14s1.5 2 4 2 4-2 4-2"/><line x1="9" y1="9" x2="9.01" y2="9"/><line x1="15" y1="9" x2="15.01" y2="9"/></svg>
          <p>{{ mode === 'cook' ? '还没有菜品，添加一些吧' : '还没有店铺，添加一些吧' }}</p>
        </li>
      </ul>
    </div>

    <div class="pick-area">
      <button class="pick-btn" :class="{ disabled: items.length === 0 }" :disabled="items.length === 0" @click="pickOne">
        <span class="pick-btn__icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><path d="M16 8l-4 8-4-4"/></svg>
        </span>
        <span class="pick-btn__text">一键决定</span>
      </button>
    </div>

    <transition name="result">
      <div v-if="resultVisible" class="result-overlay" @click="resultVisible = false">
        <div class="result-card" @click.stop>
          <div class="result-emoji">🎉</div>
          <div class="result-label">就吃这个吧！</div>
          <div class="result-name">{{ pickedItem }}</div>
          <button class="result-confirm" @click="resultVisible = false">好的</button>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import Dexie from "dexie";

const db = new Dexie("FoodMemory");
db.version(1).stores({ items: "++id, mode, name" });

const mode = ref("cook");
const items = ref([]);
const inputText = ref("");

const resultVisible = ref(false);
const pickedItem = ref("");

const loadItems = async () => {
  items.value = await db.items.where("mode").equals(mode.value).toArray();
};

const addItem = async () => {
  const name = inputText.value.trim();
  if (!name) return;
  await db.items.add({ mode: mode.value, name });
  inputText.value = "";
  loadItems();
};

const deleteItem = async (id) => {
  await db.items.delete(id);
  loadItems();
};

const pickOne = () => {
  if (items.value.length === 0) return;
  const idx = Math.floor(Math.random() * items.value.length);
  pickedItem.value = items.value[idx].name;
  resultVisible.value = true;
};

watch(mode, loadItems);
onMounted(loadItems);
</script>

<style scoped>
* { margin: 0; padding: 0; box-sizing: border-box; }

.app {
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "SF Pro Text", "PingFang SC", sans-serif;
  background: #f2f2f7;
  min-height: 100vh;
  max-width: 480px;
  margin: 0 auto;
  padding: 0 16px 100px;
  -webkit-font-smoothing: antialiased;
}

/* ===== Header ===== */
.header {
  padding: 48px 0 8px;
  text-align: center;
}
.header__title {
  font-size: 32px;
  font-weight: 800;
  background: linear-gradient(135deg, #ff6b6b, #ffa94d);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: -0.5px;
}
.header__sub {
  font-size: 14px;
  color: #8e8e93;
  margin-top: 4px;
}

/* ===== Tabs ===== */
.tabs {
  display: flex;
  gap: 8px;
  margin: 20px 0 16px;
}
.tab {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px;
  border: none;
  border-radius: 14px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  background: #fff;
  color: #8e8e93;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
  transition: all 0.3s ease;
}
.tab.active {
  background: linear-gradient(135deg, #ff6b6b, #ffa94d);
  color: #fff;
  box-shadow: 0 4px 16px rgba(255,107,107,0.3);
}

/* ===== Card ===== */
.card {
  background: #fff;
  border-radius: 20px;
  padding: 20px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
}
.card__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}
.card__title {
  font-size: 17px;
  font-weight: 700;
  color: #1d1d1f;
}
.card__count {
  font-size: 13px;
  color: #8e8e93;
  font-weight: 500;
}

/* ===== Add Row ===== */
.add-row {
  display: flex;
  gap: 10px;
  margin-bottom: 16px;
}
.add-input {
  flex: 1;
  padding: 12px 16px;
  border: none;
  border-radius: 12px;
  background: #f2f2f7;
  font-size: 15px;
  color: #1d1d1f;
  outline: none;
  transition: all 0.25s ease;
}
.add-input:focus {
  background: #fff;
  box-shadow: 0 0 0 2px rgba(255,107,107,0.2);
}
.add-input::placeholder { color: #aeaeb2; }
.add-btn {
  width: 44px;
  height: 44px;
  border: none;
  border-radius: 12px;
  background: linear-gradient(135deg, #ff6b6b, #ffa94d);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.25s ease;
  flex-shrink: 0;
}
.add-btn:active { transform: scale(0.92); }
.add-btn:disabled { opacity: 0.4; }

/* ===== List ===== */
.list { list-style: none; }
.list-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 12px;
  border-radius: 12px;
  margin-bottom: 4px;
  transition: background 0.2s;
}
.list-item:hover { background: #f2f2f7; }
.list-item__text {
  font-size: 15px;
  font-weight: 500;
  color: #1d1d1f;
  word-break: break-all;
}
.list-item__del {
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 50%;
  background: transparent;
  color: #aeaeb2;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  flex-shrink: 0;
}
.list-item__del:hover { background: rgba(255,59,48,0.08); color: #ff3b30; }
.list-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 32px 16px;
  color: #aeaeb2;
  font-size: 14px;
}

/* ===== Pick Area ===== */
.pick-area {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16px;
  background: linear-gradient(transparent, #f2f2f7 30%);
  display: flex;
  justify-content: center;
}
.pick-btn {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 18px 48px;
  border: none;
  border-radius: 18px;
  background: linear-gradient(135deg, #ff6b6b, #ffa94d);
  color: #fff;
  font-size: 18px;
  font-weight: 700;
  cursor: pointer;
  box-shadow: 0 8px 32px rgba(255,107,107,0.35);
  transition: all 0.3s ease;
  letter-spacing: 0.5px;
}
.pick-btn:active { transform: scale(0.96); }
.pick-btn.disabled { opacity: 0.5; box-shadow: none; }

/* ===== Result Modal ===== */
.result-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.35);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}
.result-card {
  background: #fff;
  border-radius: 24px;
  padding: 40px 36px 28px;
  text-align: center;
  width: 300px;
  box-shadow: 0 24px 80px rgba(0,0,0,0.15);
}
.result-emoji { font-size: 48px; margin-bottom: 12px; }
.result-label {
  font-size: 14px;
  color: #8e8e93;
  margin-bottom: 8px;
}
.result-name {
  font-size: 22px;
  font-weight: 700;
  color: #1d1d1f;
  margin-bottom: 24px;
}
.result-confirm {
  width: 100%;
  padding: 14px;
  border: none;
  border-radius: 14px;
  background: linear-gradient(135deg, #ff6b6b, #ffa94d);
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}

/* Transition */
.result-enter-active { transition: all 0.35s cubic-bezier(0.16,1,0.3,1); }
.result-leave-active { transition: all 0.25s ease; }
.result-enter-from, .result-leave-to { opacity: 0; }
.result-enter-from .result-card { transform: scale(0.85); }
</style>
