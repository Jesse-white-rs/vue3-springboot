import { ref, reactive } from 'vue';
import { computed,onMounted } from 'vue';
import { ElMessage } from "element-plus";
import { createCRUDStore } from '@/stores/utils/createCRUDStore';
import { foundMeApi } from '@/api/services/foundMe-api';
import type { foundMeData} from '@/types/foundMeTypes';


export const usefoundMeStore = createCRUDStore('foundMe', foundMeApi);

// 更新表单
export const foundMeFormRef = ref<foundMeData>({});



