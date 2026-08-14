import apiClient from '../index';

// 记录按钮点击次数
export const recordButtonClick = async (key: string) => {
  return apiClient.get('/dashboard/click', {
    params: { key },
  });
};

// 获取按钮点击次数
export const getButtonClickCount = async (key: string) => {
  return apiClient.get('/dashboard/click-count', {
    params: { key },
  });
};
