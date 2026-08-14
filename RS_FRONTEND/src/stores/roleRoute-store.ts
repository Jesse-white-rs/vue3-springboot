import { defineStore } from "pinia";
import { ref, toRaw, reactive } from "vue";
import { ElMessage } from "element-plus";
import { addRoleRoute, deleteRoleRoute,getRoleRoutes } from '@/api/services/roleRoute-api';



export interface RoleRoute {
  id: number;
  rId: number;
  roId: number;
  roName: string;
  roType: string;
}
export const useRoleRouteStore = defineStore('roleRoute', () => {
    const roleRoutesList = ref<RoleRoute[]>([]);

    // 获取rId对应的路由列表
    const getRoleRoutesList = async (rId:number) => {
      await getRoleRoutes(rId).then(res => {
      roleRoutesList.value = res.data.result;
      })
    }
    // 删除角色路由
    const deleteRoleRouteById = async (id: number) => {
      await deleteRoleRoute(id).then(res => {
        ElMessage.success('删除成功');
      })
    }
    // 添加角色路由
    const addRoleRouteItem = async (rId:any,roId:number[]) => {
      await addRoleRoute(rId,roId).then(res => {
        ElMessage.success('添加成功');
      })
    }
    

  return {
    roleRoutesList,
    getRoleRoutesList,
    deleteRoleRouteById,
    addRoleRouteItem
    
  };
});
