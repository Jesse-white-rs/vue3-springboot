package com.rs.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * 密码加密工具类
 * 用于对明文密码进行BCrypt加密
 * 
 * @author RWG
 * @date 2026-06-01
 */
public class PasswordUtils {
    
    private static final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    /**
     * 对明文密码进行加密
     * 
     * @param rawPassword 明文密码
     * @return 加密后的密码
     */
    public static String encode(String rawPassword) {
        if (rawPassword == null || rawPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }
        return passwordEncoder.encode(rawPassword);
    }
    
    /**
     * 验证明文密码与加密后的密码是否匹配
     * 
     * @param rawPassword 明文密码
     * @param encodedPassword 加密后的密码
     * @return 是否匹配
     */
    public static boolean matches(String rawPassword, String encodedPassword) {
        if (rawPassword == null || encodedPassword == null) {
            return false;
        }
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }
    
    /**
     * 主方法，方便直接运行此工具类来生成加密密码
     * 使用方式：直接在下方修改 passwordToEncrypt 的值，然后运行 main 方法
     * 
     * @param args 命令行参数（可选）
     */
    public static void main(String[] args) {
        // ========== 在这里填写你要加密的密码 ==========
        String passwordToEncrypt = "1234";
        // ===========================================
        
        if (passwordToEncrypt == null || passwordToEncrypt.trim().isEmpty()) {
            System.out.println("错误：密码不能为空！");
            return;
        }
        
        try {
            String encodedPassword = encode(passwordToEncrypt);
            System.out.println("====================================");
            System.out.println("原始密码: " + passwordToEncrypt);
            System.out.println("加密后密码: " + encodedPassword);
            System.out.println("密码长度: " + encodedPassword.length());
            System.out.println("====================================");
            System.out.println("\n复制上面的加密后密码即可使用！");
        } catch (Exception e) {
            System.out.println("加密失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
}