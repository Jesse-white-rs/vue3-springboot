import apiClient from '../index';

// 同步
export const syncData = async () => {
  return apiClient.get('/wx/sync');
};
// 注册
export const regData = async () => {
  return apiClient.get('/wx/reg');
};