<template>
  <div class="ios-sidebar">
    <div class="sidebar-glass"></div>
    <div class="sidebar-content">
      <el-menu
        :default-active="activeMenu"
        class="ios-menu"
      >
        <template v-for="route in menuRoutes" :key="route.name || route.path">
          <el-menu-item
            v-if="!route.children || route.children.length === 0"
            :index="route.path"
            class="ios-menu-item"
            @click="handleMenuClick(route.path)"
          >
            <div class="menu-icon-wrapper">
              <el-icon :size="18">
              <component :is="getIconComponent(route.meta?.icon as string | undefined)" />
            </el-icon>
          </div>
          <template #title>
            <span class="menu-label">{{ route.name }}</span>
          </template>
        </el-menu-item>

        <el-sub-menu v-else :index="route.path" class="ios-submenu">
          <template #title>
            <div class="menu-icon-wrapper">
              <el-icon :size="18">
                <component :is="getIconComponent(route.meta?.icon as string | undefined)" />
                </el-icon>
              </div>
              <span class="menu-label">{{ route.name }}</span>
            </template>

            <template v-for="childRoute in route.children" :key="childRoute.name || childRoute.path">
              <el-menu-item
                v-if="!childRoute.children || childRoute.children.length === 0"
                :index="route.path + '/' + childRoute.path"
                class="ios-menu-item child"
                @click="handleMenuClick(route.path + '/' + childRoute.path)"
              >
                <span class="menu-label">{{ childRoute.name }}</span>
              </el-menu-item>

              <el-sub-menu v-else :index="route.path + '/' + childRoute.path" class="ios-submenu">
                <template #title>
                  <div class="menu-icon-wrapper small">
                    <el-icon :size="16">
                      <component :is="getIconComponent(childRoute.meta?.icon as string | undefined)" />
                    </el-icon>
                  </div>
                  <span class="menu-label">{{ childRoute.name }}</span>
                </template>

                <el-menu-item
                  v-for="subChildRoute in childRoute.children"
                  :key="subChildRoute.path"
                  :index="subChildRoute.path"
                  class="ios-menu-item child"
                  @click="handleMenuClick(subChildRoute.path)"
                >
                  <span class="menu-label">{{ subChildRoute.name }}</span>
                </el-menu-item>
              </el-sub-menu>
            </template>
          </el-sub-menu>
        </template>
      </el-menu>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { useRouteStore } from '@/stores/routes-store';
import * as ElementPlusIconsVue from '@element-plus/icons-vue';

const router = useRouter();
const routeStore = useRouteStore();
const menuRoutes = router.getRoutes().find((route) => route.path === '/home')?.children;

const activeMenu = computed(() => routeStore.aimRoutePath || '');

const handleMenuClick = (path: string) => {
  routeStore.aimRoutePath = path;
  router.push('/home/' + path);
};

const iconMap: Record<string, string> = {
  'dashboard': 'DataBoard',
  'user': 'User',
  'setting': 'Setting',
  'system': 'Setting',
  'management': 'Management',
  'menu': 'Menu',
  'role': 'UserFilled',
  'route': 'Share',
  'permission': 'Lock',
  'department': 'OfficeBuilding',
  'notice': 'Bell',
  'found': 'Search',
  'info': 'Document',
  'home': 'HomeFilled',
  'pc': 'Monitor',
  'chart': 'PieChart',
  'file': 'FolderOpened',
  'log': 'Notebook',
  'admin': 'Avatar',
};

const getIconComponent = (iconName: string | undefined) => {
  if (!iconName) return ElementPlusIconsVue['Document'];
  const mapped = iconMap[iconName] as keyof typeof ElementPlusIconsVue | undefined;
  if (mapped && ElementPlusIconsVue[mapped]) return ElementPlusIconsVue[mapped];
  const key = iconName as keyof typeof ElementPlusIconsVue;
  if (ElementPlusIconsVue[key]) return ElementPlusIconsVue[key];
  return ElementPlusIconsVue['Document'];
};
</script>

<style scoped>
.ios-sidebar {
  position: relative;
  height: 100%;
  width: 240px;
  overflow: hidden;
}

.sidebar-glass {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.68);
  backdrop-filter: saturate(180%) blur(20px);
  -webkit-backdrop-filter: saturate(180%) blur(20px);
  border-right: 0.5px solid rgba(0, 0, 0, 0.1);
}

.sidebar-content {
  position: relative;
  display: flex;
  flex-direction: column;
  height: 100%;
  z-index: 1;
}

.ios-menu {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  border-right: none !important;
  background: transparent !important;
  padding: 12px 10px;
}

.ios-menu::-webkit-scrollbar {
  width: 4px;
}

.ios-menu::-webkit-scrollbar-track {
  background: transparent;
}

.ios-menu::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.12);
  border-radius: 4px;
}

.ios-menu-item {
  margin: 3px 0;
  border-radius: 12px !important;
  height: 44px !important;
  line-height: 44px !important;
  transition: background 0.2s ease !important;
  padding: 0 12px !important;
}

.ios-menu-item:hover {
  background: rgba(0, 122, 255, 0.08) !important;
}

.ios-menu-item.is-active {
  background: rgba(0, 122, 255, 0.12) !important;
}

.ios-menu-item.is-active .menu-icon-wrapper {
  background: #007aff;
  color: #fff;
  box-shadow: 0 2px 8px rgba(0, 122, 255, 0.3);
}

.ios-menu-item.child {
  height: 40px !important;
  line-height: 40px !important;
  padding-left: 16px !important;
}

.ios-submenu :deep(.el-sub-menu__title) {
  border-radius: 12px;
  height: 44px !important;
  line-height: 44px !important;
  padding: 0 12px !important;
  transition: background 0.2s ease !important;
}

.ios-submenu :deep(.el-sub-menu__title:hover) {
  background: rgba(0, 122, 255, 0.08) !important;
}

/* 子菜单展开后的内联容器 */
.ios-submenu :deep(.el-menu--inline) {
  background: transparent !important;
  padding: 4px 0;
}

.ios-submenu :deep(.el-menu--inline .el-menu-item) {
  border-radius: 10px !important;
  margin: 2px 8px;
  height: 40px !important;
  line-height: 40px !important;
}

.ios-submenu :deep(.el-menu--inline .el-menu-item:hover) {
  background: rgba(0, 122, 255, 0.08) !important;
}

.ios-submenu :deep(.el-menu--inline .el-menu-item.is-active) {
  background: rgba(0, 122, 255, 0.12) !important;
}

.menu-icon-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: rgba(0, 0, 0, 0.04);
  color: #6e6e73;
  transition: background 0.2s ease, color 0.2s ease;
  flex-shrink: 0;
  margin-right: 10px;
}

.menu-icon-wrapper.small {
  width: 28px;
  height: 28px;
  border-radius: 7px;
}

.menu-label {
  font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Text', 'Helvetica Neue', sans-serif;
  font-size: 14px;
  font-weight: 500;
  color: #1d1d1f;
  letter-spacing: -0.1px;
}


</style>

<style>
.el-menu--popup {
  border-radius: 20px !important;
  padding: 6px !important;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.1) !important;
}

.el-menu--popup .el-menu-item {
  border-radius: 8px !important;
  height: 40px !important;
  line-height: 40px !important;
}

.el-menu--popup .el-menu-item:hover {
  background: rgba(0, 122, 255, 0.08) !important;
}

.el-menu--popup .el-menu-item.is-active {
  background: rgba(0, 122, 255, 0.12) !important;
}
</style>
