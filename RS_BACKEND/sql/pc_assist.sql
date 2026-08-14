/*
 Navicat Premium Dump SQL

 Source Server         : 赛尔助手
 Source Server Type    : MySQL
 Source Server Version : 80045 (8.0.45)
 Source Host           : 192.168.24.6:3306
 Source Schema         : pc_assist

 Target Server Type    : MySQL
 Target Server Version : 80045 (8.0.45)
 File Encoding         : 65001

 Date: 14/08/2026 11:07:17
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for app_version
-- ----------------------------
DROP TABLE IF EXISTS `app_version`;
CREATE TABLE `app_version`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version_code` int NOT NULL,
  `version_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `update_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `file_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `file_size` bigint NULL DEFAULT NULL,
  `force_update` tinyint NULL DEFAULT 0,
  `published` tinyint NULL DEFAULT 0,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for dept
-- ----------------------------
DROP TABLE IF EXISTS `dept`;
CREATE TABLE `dept`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `d_total` int NOT NULL,
  `d_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `d_avatarpath` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `d_createtime` date NULL DEFAULT NULL,
  `d_updatetime` date NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE,
  UNIQUE INDEX `d_name`(`d_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for dynamic_routes
-- ----------------------------
DROP TABLE IF EXISTS `dynamic_routes`;
CREATE TABLE `dynamic_routes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `parentRouteId` int NULL DEFAULT NULL COMMENT '父路由id',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件名',
  `icon` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标',
  `alias` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '别名',
  `state` int NULL DEFAULT NULL COMMENT '“1”启用，“0”禁用',
  `sort` int NULL DEFAULT NULL COMMENT '排序顺序，数字越小越靠前',
  `value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地址值',
  `redirect` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类型',
  `discription` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `createUserId` int NULL DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 238 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for emp
-- ----------------------------
DROP TABLE IF EXISTS `emp`;
CREATE TABLE `emp`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `e_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证号',
  `e_username` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '账号',
  `e_password` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密码',
  `e_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `e_gender` int NULL DEFAULT NULL COMMENT '性别：0-女1-男',
  `e_age` int NULL DEFAULT NULL COMMENT '年龄',
  `e_phone` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `e_telephone` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电话',
  `e_avatarpath` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `e_birthday` datetime(6) NULL DEFAULT NULL COMMENT '生日',
  `e_createtime` datetime(6) NOT NULL COMMENT '字段创建时间',
  `e_updatetime` datetime(6) NOT NULL COMMENT '字段更新时间',
  `e_isEnabled` int NULL DEFAULT 0 COMMENT '是否启用该账户：0-禁用1-启用',
  `e_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '个人简介',
  `e_qywx_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '企微id',
  `e_Deptid` int NULL DEFAULT NULL COMMENT '本系统的用户部门',
  PRIMARY KEY (`id`, `e_qywx_id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE,
  UNIQUE INDEX `e_username`(`e_username` ASC) USING BTREE,
  UNIQUE INDEX `e_id`(`e_id` ASC) USING BTREE,
  INDEX `e_name`(`e_name` ASC) USING BTREE,
  INDEX `e_Deptid`(`e_Deptid` ASC) USING BTREE,
  INDEX `e_qywx_id`(`e_qywx_id` ASC) USING BTREE,
  CONSTRAINT `emp_ibfk_1` FOREIGN KEY (`e_Deptid`) REFERENCES `dept` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1954679759 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for emp_menu
-- ----------------------------
DROP TABLE IF EXISTS `emp_menu`;
CREATE TABLE `emp_menu`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `e_id` int NOT NULL,
  `m_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for emp_role
-- ----------------------------
DROP TABLE IF EXISTS `emp_role`;
CREATE TABLE `emp_role`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `e_id` int NULL DEFAULT NULL,
  `r_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `r_id`(`r_id` ASC) USING BTREE,
  INDEX `e_id`(`e_id` ASC) USING BTREE,
  CONSTRAINT `e_id` FOREIGN KEY (`e_id`) REFERENCES `emp` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `r_id` FOREIGN KEY (`r_id`) REFERENCES `role` (`r_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for enjoy_food
-- ----------------------------
DROP TABLE IF EXISTS `enjoy_food`;
CREATE TABLE `enjoy_food`  (
  `id` int NOT NULL COMMENT '菜品id',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '菜品类型',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '菜名',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '位置',
  `pic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `extra` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '补充内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for important_msg
-- ----------------------------
DROP TABLE IF EXISTS `important_msg`;
CREATE TABLE `important_msg`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `header` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `createTime` datetime NULL DEFAULT NULL,
  `updateTime` datetime NULL DEFAULT NULL,
  `author` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for it_appointments
-- ----------------------------
DROP TABLE IF EXISTS `it_appointments`;
CREATE TABLE `it_appointments`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'it',
  `problem` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '问题',
  `status` int NULL DEFAULT NULL COMMENT '状态',
  `createAt` datetime NULL DEFAULT NULL COMMENT '预约时间',
  `createBy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预约人',
  `evaluation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评价',
  `level` int NULL DEFAULT NULL COMMENT '等级',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for it_questionare
-- ----------------------------
DROP TABLE IF EXISTS `it_questionare`;
CREATE TABLE `it_questionare`  (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` int NULL DEFAULT NULL,
  `createAt` datetime NULL DEFAULT NULL,
  `deadline` datetime NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `m_id` int NOT NULL AUTO_INCREMENT,
  `m_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `m_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `m_sign` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`m_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for pc_info
-- ----------------------------
DROP TABLE IF EXISTS `pc_info`;
CREATE TABLE `pc_info`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `memory_total` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `memory_usage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `disk_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `emp_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `ip`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 174 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for questionare_questions
-- ----------------------------
DROP TABLE IF EXISTS `questionare_questions`;
CREATE TABLE `questionare_questions`  (
  `id` int NOT NULL,
  `question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `anwser` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` int NULL DEFAULT NULL,
  `questionare_id` int NULL DEFAULT NULL,
  `type` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qywx_department
-- ----------------------------
DROP TABLE IF EXISTS `qywx_department`;
CREATE TABLE `qywx_department`  (
  `id` bigint NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `parent_id` bigint NULL DEFAULT NULL,
  `order_num` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for qywx_user
-- ----------------------------
DROP TABLE IF EXISTS `qywx_user`;
CREATE TABLE `qywx_user`  (
  `userid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `department_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`userid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `r_id` int NOT NULL AUTO_INCREMENT,
  `r_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `r_info` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`r_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for role_routes
-- ----------------------------
DROP TABLE IF EXISTS `role_routes`;
CREATE TABLE `role_routes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `r_id` int NOT NULL,
  `ro_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ro_id`(`ro_id` ASC) USING BTREE,
  INDEX `r_id`(`r_id` ASC) USING BTREE,
  CONSTRAINT `role_routes_ibfk_1` FOREIGN KEY (`ro_id`) REFERENCES `dynamic_routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_routes_ibfk_2` FOREIGN KEY (`r_id`) REFERENCES `role` (`r_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 114 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for treasure
-- ----------------------------
DROP TABLE IF EXISTS `treasure`;
CREATE TABLE `treasure`  (
  `tre_id` int NOT NULL AUTO_INCREMENT,
  `tre_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `tre_status` int NULL DEFAULT NULL,
  `tre_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `tre_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `createtime` datetime NULL DEFAULT NULL,
  `updatetime` datetime NULL DEFAULT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`tre_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for treasure_emp
-- ----------------------------
DROP TABLE IF EXISTS `treasure_emp`;
CREATE TABLE `treasure_emp`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `tre_id` int NULL DEFAULT NULL,
  `e_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for ym_domains
-- ----------------------------
DROP TABLE IF EXISTS `ym_domains`;
CREATE TABLE `ym_domains`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `registrar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `expiration_date` datetime NULL DEFAULT NULL,
  `remaining_days` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `dns_records` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `updatetime` datetime NULL DEFAULT NULL,
  `createtime` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
