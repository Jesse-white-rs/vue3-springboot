import { createRouter, createWebHashHistory } from 'vue-router';
import { useUserStore } from "@/stores/user-store";
import { ElMessage } from "element-plus";
import { content } from "@/utils/stateVariables";
import { useTagsStore } from '@/stores/tags-store';
import { useRouteStore } from '@/stores/routes-store';
import { staticRoutes } from './static-route';

const router = createRouter({
  history: createWebHashHistory(),
  routes: staticRoutes
});

let isToken = true;

router.beforeEach(async (to, from, next) => {
  const routeStore = useRouteStore();
  const userStore = useUserStore();
  const tagsStore = useTagsStore();

  content.value = true;

  // 定义isToken为true时添加路由
  if (isToken && localStorage.getItem('token') !== null) {
    try {
      await routeStore.getDynamicRoutes()
      isToken = false;
      next({
        ...to,
        replace: true,
      });
      return;
    } catch (error) {
      localStorage.removeItem('token');
      next('/login');
      return;
    }
  }

  if (to.matched.some(record => record.meta.id)) {
    userStore.updateLoginUserDataNoInfo();
    if (userStore.token) {
      // 添加当前路由到标签列表
      tagsStore.addRoute({
        name: to.name! as string,
        path: to.fullPath,
        meta: to.meta,
        isActive: true,
      });
      next();
    } else {
      ElMessage.error('您还未登录');
      next('/login');
    }
  } else {
    next();
  }
});

router.afterEach((to, from) => {
  const timer = setTimeout(() => {
    content.value = false;
    clearTimeout(timer);
  }, 500);
});

export default router;
