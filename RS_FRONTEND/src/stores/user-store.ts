import { defineStore } from "pinia";
import { ref, reactive } from "vue";
import type { TableColumnCtx } from "element-plus";
import { computed } from "vue";
import {
  userLogin,
  userLoginBytoken,
  userLogout,
} from "@/api/services/login-api";
import { regUser } from "@/api/services/reg-api";
import {
  fetchUserDataBySearch,
  fetchUserDataPages,
  deleteUsers,
  deleteUser,
  updateUser,
  addUser,
  fetchUserData,
} from "@/api/services/user-api";
import { ElMessage } from "element-plus";
import { useRouter } from "vue-router";
import type { UserData, Emp, Role, Dept, qywxUser, qywxDepartment } from "@/types/userTypes";

// 该模块用于管理用户管理页的用户数据
export const useUserStore = defineStore("user", () => {
  const router = useRouter();
  /*
   *状态
   */
  // 用户登陆状态
  const token = ref(localStorage.getItem("token") || "");
  // 单条用户数据及集合用于管理面板的修改
  const userData = ref<UserData>({
    emp: {} as Emp,
    role: {} as Role,
    dept: {} as Dept,
    isOnline: "",
    qywxUser: {} as qywxUser,
    qywxDepartment: {} as qywxDepartment,
  });
  const emptyUserData = ref<UserData>({
    emp: {} as Emp,
    role: {} as Role,
    dept: {} as Dept,
    isOnline: "",
    qywxUser: {} as qywxUser,
    qywxDepartment: {} as qywxDepartment,
  });
  const tableData = ref<UserData[]>([]);
  // 用户数据体 这里用于登录的帐号 显示数据
  const myData = ref<UserData>({
    emp: {} as Emp,
    role: {} as Role,
    dept: {} as Dept,
    isOnline: "",
    qywxUser: {} as qywxUser,
    qywxDepartment: {} as qywxDepartment,
  });
  const createEmptyUserData = () => ({
    emp: {
      id: null,
      eUsername: null,
      eAvatarpath: null,
      eName: null,
      ePassword: null,
      eId: null,
      ePhone: null,
      eAge: null,
      eDeptid: null,
      eGender: null,
      eCreatetime: null,
      eUpdatetime: null,
      eIsenabled: null,
      eTelephone: null,
      eBirthday: null,
      eDescription: null,
      eQywxid: null
    },
    role: {
      rId: null,
      rName: null,
      rInfo: null,
    },
    dept: {
      id: null,
      dName: null,
    },
    isOnline: null,
  });

  const searchUserData = ref(createEmptyUserData());
  const createTime1 = ref("");
  const createTime2 = ref("");
  const options2 = ref([
    { label: "男", value: "1" },
    { label: "女", value: "0" },
  ]);
  const options4 = ref([
    { label: "正常", value: "1" },
    { label: "禁用", value: "0" },
  ]);
  // 分页数据
  const current = ref<number>(1);
  const pageSize = ref<number>(10);
  const total = ref<number>(0);
  // 选中的ids
  const selectedIds = ref<number[]>([]);
  // 用户头像显示组件配置
  const autoUpload = ref(true);
  const showImageFileName = ref(true);
  const disabled = ref(false);
  const uploadAllFilesInOneRequest = ref(false);
  const file1 = ref<any>([]);
  const Nullfile1 = ref<any>([]);
  const avatarUrl = ref(`${import.meta.env.VITE_API_BASE_URL}/upload`);
  const uploadRef = ref<any>();
  const avatarPath = ref(null);
  // 登陆表单
  const LOGIN_FORM_RULES = {
    account: [{ required: true, message: "账户必填", trigger: "blur" }],
    password: [{ required: true, message: "密码必填", trigger: "blur" }],
  };
  const loginFormData: any = reactive({
    account: "",
    password: "",
    rememberMe: false,
  });
  // 注册表单
  const REG_FORM_RULES = {
    account: [{ required: true, message: "账户必填", trigger: "blur" }],
    password: [{ required: true, message: "密码必填", trigger: "blur" }],
    eid: [{ required: true, message: "身份证号必填", trigger: "blur" }],
    phone: [{ required: true, message: "手机号必填", trigger: "blur" }],
  };
  const regFormData: any = reactive({
    account: "",
    password: "",
    eid: "",
    phone: "",
  });
  // 用户添加表单规则
  const USERADD_FORM_RULES = {
    emp: {
      eUsername: [
        { required: true, message: "账户必填", trigger: "blur" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
      ePassword: [
        { required: true, message: "密码必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
      eId: [
        { required: true, message: "身份证号必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
      ePhone: [
        { required: true, message: "手机号必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
      eDeptid: [
        { required: true, message: "部门必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
    },
    role: {
      rId: [
        { required: true, message: "角色必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
    },
  };
  // 用户添加表单
  const userAddFormData: any = reactive({
    emp: {
      eAvatarpath: "",
      eUsername: "",
      ePassword: "",
      eName: "",
      eId: "",
      ePhone: "",
      eDeptid: "",
      eIsenabled: "",
    },
    role: {
      rId: "",
    },
  });

  // 用户修改表单规则
  const USERDATA_FORM_RULES = {
    emp: {
      eUsername: [
        { required: true, message: "账户必填", trigger: "blur" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
      eId: [
        { required: true, message: "身份证号必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
      ePhone: [
        { required: true, message: "手机号必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
      eDeptid: [
        { required: true, message: "部门必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
    },
    role: {
      rId: [{ required: true, message: "角色必填" }],
    },
  };
  // 用户修改表单
  const userDataFormData: any = reactive({
    emp: {
      id: "",
      eAvatarpath: "",
      eUsername: "",
      ePassword: "",
      eName: "",
      eId: "",
      ePhone: "",
      eDeptid: "",
      eIsenabled: "",
    },
    role: {
      rId: "",
    },
  });

  // 个人信息修改
  const MYDATA_FORM_RULES = {
    emp: {
      eUsername: [
        { required: true, message: "账户必填", trigger: "blur" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
      eName: [
        { required: true, message: "姓名必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
      eId: [
        { required: true, message: "身份证号必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
      ePhone: [
        { required: true, message: "手机号必填" },
        { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
      ],
    },
  };
  const myDataFormData: any = reactive({
    emp: {
      eUsername: null,
      ePassword: null,
      eName: null,
      eId: null,
      ePhone: null,
      eAge: null,
      eGender: null,
      eAvatarpath: null,
    },
    role: {
      rId: null,
    },
  });
  // tableData过滤出isOnline为1的数据长度
  const onlineUserLength = computed(() => {
    return tableData.value.filter((item) => item.isOnline == "1").length;
  });
  // tableData过滤出isOnline为0的数据长度
  const offlineUserLength = computed(() => {
    return tableData.value.filter((item) => item.isOnline == "0").length;
  });
  let sidentifyMode = ref(""); //输入框验证码
  let identifyCode = ref(""); //图形验证码
  let identifyCodes = ref("1234567890abcdefjhijklinopqrsduvwxyz"); //验证码出现的数字和字母
  //
  /*
   *动作
   */
  // 获取所有用户数据
  const getAllUserData = async () => {
    await fetchUserData().then((resp) => {
      tableData.value = resp.data.result;
    });
  };

  // 用户分页数据获取
  const handlePageChange = async () => {
    const response = await fetchUserDataPages(current.value, pageSize.value);
    tableData.value = response.data.result.rows;
    total.value = response.data.result.total;
  };
  // 批量删除用户
  const handleBatchDelete = async () => {
    if (selectedIds.value.length === 0) {
      ElMessage.warning("请先选择要删除的用户");
      return;
    }
    await new Promise((resolve) => setTimeout(resolve, 500));
    await deleteUsers(selectedIds.value).then(() => {
      ElMessage.success("用户删除成功");
      handlePageChange();
    });
  };
  // 删除单条用户BY id
  const handleDelete = async (id: number) => {
    await new Promise((resolve) => setTimeout(resolve, 200));
    await deleteUser(id).then(() => {
      ElMessage.success("用户删除成功");
      handlePageChange();
    });
  };
  // 添加用户
  const handleAddUser = async () => {
    userAddFormData.emp.eAvatarpath = avatarPath.value;
    await addUser(userAddFormData).then(() => {
      ElMessage.success("用户添加成功");
      file1.value = Nullfile1.value;
      avatarPath.value = null;
      handlePageChange();
    });
  };
  // 修改用户
  const handleUpdateUser = async () => {
    userDataFormData.emp.eAvatarpath = avatarPath.value;
    console.log(userDataFormData.emp.eUsername);
    await updateUser(userDataFormData).then(() => {
      ElMessage.success("用户修改成功");
      file1.value = Nullfile1.value;
      avatarPath.value = null;
      handlePageChange();
    });
  };
  // 多选
  const handleSelectionChange = (selection: UserData[]) => {
    selectedIds.value = selection.map((item) => item.emp?.id!);
  };
  // 筛选
  const filterHandler = (
    value: string,
    row: UserData,
    column: TableColumnCtx<UserData>
  ) => {
    const property = column["property"] as keyof UserData; // 使用 keyof UserData
    return row[property] === value;
  };
  const idFilters = computed(() => {
    return tableData.value.map((item) => ({
      text: item.emp.id?.toString() || "",
      value: item.emp.id,
    }));
  });
  // 头像上传回调
  const handleFail = ({ file }: { file: { name: string } }) => {
    ElMessage.error(`文件 ${file.name} 上传失败`);
  };
  const handleSuccess = (response: any, file: File) => {
    if (response.response.code == 1) {
      avatarPath.value = response.response.result;
    } else {
      ElMessage.error("头像上传失败: 响应格式不正确");
    }
  };

  const imageViewerProps = ref<any>({
    closeOnEscKeydown: false,
  });
  // 头像大小限制
  const sizeLimit = ref<any>({
    size: 5500,
    unit: "KB",
  });

  // 更新验证码
  const refreshCode = () => {
    identifyCode.value = "";
    makeCode(identifyCodes.value, 4);
  };
  // 生成随机数
  const randomNum = (min: number, max: number) => {
    max = max + 1;
    return Math.floor(Math.random() * (max - min) + min);
  };
  // 随机生成验证码字符串
  const makeCode = (o: any, l: any) => {
    for (let i = 0; i < l; i++) {
      identifyCode.value += o[randomNum(0, o.length)];
    }
  };
  // 手动登录提交按钮
  const loginOnSubmit = async () => {
    const user = {
      emp: {
        eUsername: loginFormData.account,
        ePassword: loginFormData.password,
      },
      rememberMe: loginFormData.rememberMe,
    };
    await userLogin(user).then((resp) => {
      token.value = resp.data.result;
      localStorage.setItem("token", token.value);
      ElMessage.success("登录成功");
      router.push("/home");
    });
  };
  // 自动登录
  const autoLogin = async () => {
    await new Promise((resolve) => setTimeout(resolve, 1000));
    await userLoginBytoken()
      .then((resp) => {
        router.push("/home");
      })
      .catch(() => {
        router.push("/login");
      });
  };
  // 登录用户数据刷新
  const updateLoginUserData = async () => {
    await userLoginBytoken()
      .then((resp) => {
        ElMessage.success("欢迎使用🌟");
        myData.value = resp.data.result;
        myDataFormData.emp = myData.value.emp;
      })
      .catch(() => {
        router.push("/login");
      });
  };
  const updateLoginUserDataNoInfo = async () => {
    await userLoginBytoken()
      .then((resp) => {
        sessionStorage.setItem("userRoleId", resp.data.result.role.rId);
      })
      .catch(() => {
        router.push("/login");
      });
  };
  // 注册提交按钮
  const regOnSubmit = async () => {
    if (!sidentifyMode.value) {
      ElMessage.warning("请输入验证码");
      return;
    }
    if (sidentifyMode.value != identifyCode.value) {
      ElMessage.error("验证码不正确");
      refreshCode();
      return;
    }
    const user = {
      eUsername: regFormData.account,
      ePassword: regFormData.password,
      eId: regFormData.eid,
      ePhone: regFormData.phone,
    };
    const response = await regUser(user);
    ElMessage.success("注册成功");
    token.value = response.data.result;
    localStorage.setItem("token", response.data.result);
    router.push("/home");
  };
  // 登出
  const logout = async () => {
    const response = await userLogout();
    if (response.data.code == 1) {
      token.value = "";
      localStorage.removeItem("token");
      router.push("/login");
    } else {
      ElMessage.warning("退出登录失败");
    }
  };

  // 修改个人信息头像
  const myInfoEditHandleSuccess = (response: any, file: File) => {
    if (response.response.code == 1) {
      myDataFormData.emp.eAvatarpath = response.response.result;
    } else {
      console.error("Unexpected upload response format:", response.response);
      ElMessage.error("头像上传失败: 响应格式不正确");
    }
  };

  const handleUpdateMe = async () => {
    await updateUser(myDataFormData).then(() => {
      ElMessage.success("用户修改成功");
      file1.value = Nullfile1.value;
      avatarPath.value = null;
      handlePageChange();
    });
  };
  // 清除用户信息缓存
  const cleanUserData = () => {
    userData.value = emptyUserData.value;
  };

  // 搜索用户
  const searchUser = async () => {
    await fetchUserDataBySearch(searchUserData.value).then((resp) => {
      tableData.value = resp.data.result;
      if (searchUserData.value.role.rId == undefined) {
        return;
      }
      const filteredItems = tableData.value.filter(
        (item) => item.role.rId === searchUserData.value.role.rId
      );
      tableData.value = filteredItems;
    });
    if (createTime1.value != "" && createTime2.value != "") {
      const startDate = new Date(createTime1.value).getTime();
      const endDate = new Date(createTime2.value).getTime();
      const filteredItems = tableData.value.filter((item) => {
        const createTime = new Date(item.emp.eCreatetime!).getTime();
        return createTime >= startDate && createTime <= endDate;
      });
      tableData.value = filteredItems;
    }
    total.value = tableData.value.length;
  };

  // 搜索用户数据体重置
  const searchUserDataRefresh = async () => {
    await handlePageChange().then(() => {
      searchUserData.value = createEmptyUserData();
      createTime1.value = "";
      createTime2.value = "";
    });
  };

  return {
    // 状态
    token,
    userData,
    tableData,
    total,
    current,
    pageSize,
    selectedIds,
    imageViewerProps,
    sizeLimit,
    avatarUrl,
    file1,
    uploadAllFilesInOneRequest,
    disabled,
    showImageFileName,
    autoUpload,
    loginFormData,
    LOGIN_FORM_RULES,
    regFormData,
    REG_FORM_RULES,
    uploadRef,
    myData,
    options2,
    userDataFormData,
    USERDATA_FORM_RULES,
    options4,
    userAddFormData,
    USERADD_FORM_RULES,
    myDataFormData,
    MYDATA_FORM_RULES,
    onlineUserLength,
    offlineUserLength,
    searchUserData,
    createTime1,
    createTime2,
    avatarPath,
    Nullfile1,
    sidentifyMode,
    identifyCode,
    identifyCodes,

    // 方法
    makeCode,
    refreshCode,
    handlePageChange,
    handleBatchDelete,
    handleDelete,
    handleSelectionChange,
    idFilters,
    filterHandler,
    handleFail,
    autoLogin,
    loginOnSubmit,
    regOnSubmit,
    logout,
    handleSuccess,
    updateLoginUserData,
    myInfoEditHandleSuccess,
    cleanUserData,
    getAllUserData,
    updateLoginUserDataNoInfo,
    searchUser,
    searchUserDataRefresh,
    handleAddUser,
    handleUpdateUser,
    handleUpdateMe,
  };
});
