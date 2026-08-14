package com.rs.constants;

/**
 * 系统常量定义类
 * 
 * @author RWG
 * @description 统一管理系统中的常量，避免硬编码
 * @createDate 2025-03-13
 */
public final class SystemConstants {
    
    private SystemConstants() {
        // 私有构造器，防止实例化
    }
    
    // ========================== 数据库操作结果常量 ==========================
    /**
     * 数据库操作成功标识
     */
    public static final int DB_OPERATION_SUCCESS = 1;
    public static final int DB_OPERATION_FAILED = 0;
    
    // ========================== 用户状态常量 ==========================
    /**
     * 用户启用状态
     */
    public static final int USER_ENABLED = 1;
    public static final int USER_DISABLED = 0;
    
    /**
     * 用户在线状态
     */
    public static final int USER_ONLINE = 1;
    public static final int USER_OFFLINE = 0;
    
    // ========================== 角色和权限常量 ==========================
    /**
     * 默认角色ID
     */
    public static final int ROLE_ADMIN_ID = 1;        // 管理员角色ID
    public static final int ROLE_OPERATOR_ID = 2;     // 操作员角色ID
    public static final int ROLE_USER_ID = 3;         // 普通用户角色ID
    
    /**
     * 默认菜单权限ID
     */
    public static final int MENU_BASIC_PERMISSION_ID = 1; // 基础权限菜单ID
    
    // ========================== 部门常量 ==========================
    /**
     * 默认部门ID
     */
    public static final int DEFAULT_DEPT_ID = 49;     // 默认部门ID
    
    // ========================== 密码相关常量 ==========================
    /**
     * 密码不更新标识
     */
    public static final String PASSWORD_NO_CHANGE_FLAG = "N";
    
    /**
     * 默认初始密码
     */
    public static final String DEFAULT_INITIAL_PASSWORD = "123456";
    
    // ========================== JWT Token相关常量 ==========================
    /**
     * JWT签名密钥
     */
    public static final String JWT_SIGN_KEY = "loveSJM";
    
    /**
     * Token默认过期时间（12小时）
     */
    public static final long JWT_DEFAULT_EXPIRE_TIME = 43200000L; // 12小时
    
    /**
     * Token过期时间常量（毫秒）
     */
    public static final long TOKEN_EXPIRE_TIME_ONE_WEEK = 7 * 24 * 60 * 60 * 1000L; // 一周
    public static final long TOKEN_EXPIRE_TIME_ONE_DAY = 24 * 60 * 60 * 1000L;      // 一天
    public static final long TOKEN_EXPIRE_TIME_ONE_HOUR = 60 * 60 * 1000L;          // 一小时
    
    // ========================== 时间相关常量 ==========================
    /**
     * 时间单位常量（秒）
     */
    public static final int SECONDS_PER_MINUTE = 60;
    public static final int SECONDS_PER_HOUR = 60 * 60;
    public static final int SECONDS_PER_DAY = 24 * 60 * 60;
    public static final int SECONDS_PER_WEEK = 7 * 24 * 60 * 60;
    
    // ========================== 业务状态常量 ==========================
    /**
     * 通用状态标识
     */
    public static final int STATUS_ACTIVE = 1;    // 激活状态
    public static final int STATUS_INACTIVE = 0;  // 非激活状态
    
    // ========================== 企业微信API相关常量 ==========================
    /**
     * 企业微信API错误码
     */
    public static final String QYWX_SUCCESS_CODE = "0";
    
    /**
     * 企业微信API URL模板
     */
    public static final String QYWX_GET_TOKEN_URL = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=%s&corpsecret=%s";
    public static final String QYWX_USER_LIST_URL = "https://qyapi.weixin.qq.com/cgi-bin/user/simplelist?access_token=%s&department_id=%s&fetch_child=0";
    public static final String QYWX_USER_INFO_URL = "https://qyapi.weixin.qq.com/cgi-bin/user/get?access_token=%s&userid=%s";
    
    // ========================== 分页相关常量 ==========================
    /**
     * 默认分页参数
     */
    public static final int DEFAULT_PAGE_NUMBER = 1;
    public static final int DEFAULT_PAGE_SIZE = 10;
    public static final int MAX_PAGE_SIZE = 100;
    
    // ========================== 系统配置常量 ==========================
    /**
     * 随机用户名长度
     */
    public static final int RANDOM_USERNAME_LENGTH = 8;
    
    /**
     * 通用布尔值常量
     */
    public static final String BOOLEAN_TRUE = "1";
    public static final String BOOLEAN_FALSE = "0";
    
    // ========================== 错误码常量 ==========================
    /**
     * 通用错误码
     */
    public static final String ERROR_CODE_DEFAULT = "-1";
    public static final String ERROR_CODE_SUCCESS = "200";
    public static final String ERROR_CODE_NOT_FOUND = "404";
    public static final String ERROR_CODE_UNAUTHORIZED = "401";
    public static final String ERROR_CODE_INTERNAL_ERROR = "500";
}