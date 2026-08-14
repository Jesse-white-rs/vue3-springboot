import apiClient from '../index';

// 获取版本列表
export const fetchUpdateDataPages = async (page: number, pageSize: number) => {
  return apiClient.get('/version/list', {
      params: { page, pageSize }
    })
};
// 上传安装包
export const uploadUpdateFile = async (file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  return apiClient.post('/version/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  });
};
// 创建新版本
export const createNewVersion = async (versionData: any) => {
    return apiClient.post('/version/create', versionData);
}
// 更新版本信息
export const updateVersionInfo = async (versionId: string, versionData: any) => {
    return apiClient.put(`/version/update/${versionId}`, versionData);
}
// 删除版本
export const deleteVersion = async (versionId: string) => {
    return apiClient.delete(`/version/delete/${versionId}`);
}
// 客户端版本检查接口
export const checkClientVersion = async (version: string) => {
  return apiClient.get('/version/check', {
    params: { version }
  });
};
// 客户端版本下载接口
export const downloadClientVersion = async (versionId: string) => {
  return apiClient.get(`/version/download/${versionId}`, {
    responseType: 'blob' // 确保返回类型为 Blob
  });
}