package com.rs.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * 企业微信配置类
 * 
 * @author RWG
 * @description 企业微信相关配置
 * @createDate 2025-03-13
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "wx")
public class QywxConfig {
    
    /**
     * 企业ID
     */
    private String corpId;
    
    /**
     * 应用密钥
     */
    private String secret;
    
    /**
     * API URL模板
     */
    private Urls urls = new Urls();
    
    @Data
    public static class Urls {
        /**
         * 获取access_token URL
         */
        private String getToken = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=%s&corpsecret=%s";
        
        /**
         * 获取部门列表 URL
         */
        private String getDepartmentList = "https://qyapi.weixin.qq.com/cgi-bin/department/list?access_token=%s";
        
        /**
         * 获取部门成员 URL
         */
        private String getUserSimpleList = "https://qyapi.weixin.qq.com/cgi-bin/user/simplelist?access_token=%s&department_id=%s&fetch_child=0";
        
        /**
         * 获取用户信息 URL
         */
        private String getUserInfo = "https://qyapi.weixin.qq.com/cgi-bin/user/get?access_token=%s&userid=%s";
        
        /**
         * 获取用户userid URL
         */
        private String getUserInfoByCode = "https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s";
        
        /**
         * 获取launch_code URL
         */
        private String getLaunchCode = "https://qyapi.weixin.qq.com/cgi-bin/get_launch_code?access_token=%s";
    }
}