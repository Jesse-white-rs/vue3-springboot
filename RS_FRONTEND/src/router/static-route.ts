import loginPage from "@/views/loginPage.vue";
import homePage from "@/views/homePage.vue";
import Seller_PC_Helper from '@/views/Seller_PC_Helper.vue';
import EnjoyFood from '@/views/enjoy/index.vue';
export const staticRoutes =[
    {
      path: '/login',
      name: '登录',
      component: loginPage,
    },
    {
      path: '/',
      redirect: '/home',
    },
    {
      path: '/home',
      name: '首页',
      component: homePage,
      children: []
    },
    {
      path:'/seller-pc-helper',
      name: '赛尔技术服务助手',
      component:Seller_PC_Helper
    },
    {
      path:'/enjoy-food',
      name: '今天吃啥',
      component:EnjoyFood
    }

   
  ];