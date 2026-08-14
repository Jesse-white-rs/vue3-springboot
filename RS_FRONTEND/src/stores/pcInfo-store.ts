import { ref, reactive } from 'vue';
import { computed } from 'vue';
import { ElMessage } from "element-plus";
import { pcInfoApi } from '@/api/services/pcInfo-api';
import { createCRUDStore } from '@/stores/utils/createCRUDStore';
import type { PcInfoData } from '@/types/pcInfoTypes';

export const usePcInfoStore = createCRUDStore('pcInfo', pcInfoApi);

export const pcInfoAddFormData = ref<PcInfoData>({});
export const pcInfoEditFormData = ref<PcInfoData>({});
export const pageData = computed(() => {
    return usePcInfoStore().dataPages as PcInfoData[];
});


