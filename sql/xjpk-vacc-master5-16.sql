/*
 Navicat Premium Dump SQL

 Source Server         : 本地sql
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : xjpk-vacc-master

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 16/05/2026 10:26:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for oa_area
-- ----------------------------
DROP TABLE IF EXISTS `oa_area`;
CREATE TABLE `oa_area`  (
  `area_id` bigint NOT NULL AUTO_INCREMENT COMMENT '区划ID',
  `area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '区划编码（国标6位/12位）',
  `area_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '区划名称',
  `parent_area_id` bigint NULL DEFAULT 0 COMMENT '上级区划ID（0=顶级）',
  `parent_area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '上级区划编码',
  `ancestors` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '祖级列表（仿sys_dept.ancestors）',
  `area_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区划层级（PROVINCE省/CITY市/COUNTY县/TOWN乡镇/VILLAGE村）',
  `area_level_num` int NULL DEFAULT NULL COMMENT '层级数字（1省 2市 3县 4乡镇 5村）',
  `area_full_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区划全称（如：贵州省贵阳市云岩区）',
  `area_short_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区划简称',
  `pinyin_initial` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拼音首字母',
  `pinyin_full` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '完整拼音',
  `longitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '经度',
  `latitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '纬度',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序号',
  `source_area_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统区划ID（迁移兼容 t_sys_area.id）',
  `source_area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统区划编码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`area_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '行政区划表（平台级）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_area
-- ----------------------------
INSERT INTO `oa_area` VALUES (1, '520000', '贵州省', 0, '', '0', 'province', 1, '贵州省', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (2, '520100', '贵阳市', 1, '520000', '0,1', 'city', 2, '贵州省贵阳市', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (3, '520300', '遵义市', 1, '520000', '0,1', 'city', 2, '贵州省遵义市', NULL, NULL, NULL, NULL, NULL, 2, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (4, '520400', '安顺市', 1, '520000', '0,1', 'city', 2, '贵州省安顺市', NULL, NULL, NULL, NULL, NULL, 3, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (5, '520103', '云岩区', 2, '520100', '0,1,2', 'county', 3, '贵州省贵阳市云岩区', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (6, '520102', '南明区', 2, '520100', '0,1,2', 'county', 3, '贵州省贵阳市南明区', NULL, NULL, NULL, NULL, NULL, 2, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (7, '520111', '花溪区', 2, '520100', '0,1,2', 'county', 3, '贵州省贵阳市花溪区', NULL, NULL, NULL, NULL, NULL, 3, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (8, '520302', '红花岗区', 3, '520300', '0,1,3', 'county', 3, '贵州省遵义市红花岗区', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (9, '520303', '汇川区', 3, '520300', '0,1,3', 'county', 3, '贵州省遵义市汇川区', NULL, NULL, NULL, NULL, NULL, 2, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (10, '520402', '西秀区', 4, '520400', '0,1,4', 'county', 3, '贵州省安顺市西秀区', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (11, '520403', '平坝区', 4, '520400', '0,1,4', 'county', 3, '贵州省安顺市平坝区', NULL, NULL, NULL, NULL, NULL, 2, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (12, '52000301', '乡镇区A', 5, NULL, '0,1,2,5', 'town', 4, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, '0', '0', 'admin', '2026-05-09 11:21:40', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (13, '560101', '云南省', 0, NULL, '0', 'province', NULL, NULL, '云', NULL, NULL, NULL, NULL, 0, NULL, NULL, '0', '0', 'admin', '2026-05-10 16:20:40', '', NULL, NULL);
INSERT INTO `oa_area` VALUES (14, '56010101', '云南某市', 13, NULL, '0,13', 'city', NULL, NULL, '云南某市', NULL, NULL, NULL, NULL, 0, NULL, NULL, '0', '0', 'admin', '2026-05-10 16:21:59', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_attachment
-- ----------------------------
DROP TABLE IF EXISTS `oa_attachment`;
CREATE TABLE `oa_attachment`  (
  `attachment_id` bigint NOT NULL AUTO_INCREMENT COMMENT '附件关联ID',
  `tablename` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联业务表名',
  `fid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联业务主键ID',
  `file_id` bigint NULL DEFAULT NULL COMMENT '文件ID（FK→oa_base_file.file_id）',
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件显示名称',
  `attachment` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '附件路径/名称（兼容旧系统）',
  `file_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '附件业务类型（COVER封面/DOC文档/IMAGE图片/VIDEO视频/OTHER其他）',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`attachment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '附件关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_attachment
-- ----------------------------

-- ----------------------------
-- Table structure for oa_base_file
-- ----------------------------
DROP TABLE IF EXISTS `oa_base_file`;
CREATE TABLE `oa_base_file`  (
  `file_id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `filepath` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件路径/对象存储key',
  `filename` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '原始文件名',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件MD5（去重校验）',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小（字节）',
  `file_ext` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件扩展名（pdf/jpg/mp4等）',
  `content_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'MIME类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '上传人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '上传时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`file_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文件基础表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_base_file
-- ----------------------------

-- ----------------------------
-- Table structure for oa_company
-- ----------------------------
DROP TABLE IF EXISTS `oa_company`;
CREATE TABLE `oa_company`  (
  `company_id` bigint NOT NULL AUTO_INCREMENT COMMENT '推广商公司ID',
  `company_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公司名称',
  `company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '公司编码（唯一）',
  `company_short_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '公司简称',
  `social_credit_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '统一社会信用代码',
  `legal_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '法定代表人',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `province_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所在省编码',
  `province_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所在省名称',
  `city_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所在市编码',
  `city_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所在市名称',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `business_scope` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '经营范围',
  `company_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'PROMOTER' COMMENT '公司类型（字典 oa_company_type：PROMOTER/AGENT/DISTRIBUTOR）',
  `company_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'ACTIVE' COMMENT '公司状态（ACTIVE正常/STOPPED停用/EXPIRED到期）',
  `admin_user_id` bigint NULL DEFAULT NULL COMMENT '默认管理员 sys_user.user_id',
  `max_dept_level` int NULL DEFAULT 5 COMMENT '最大部门层级深度',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`company_id`) USING BTREE,
  UNIQUE INDEX `uk_oa_company_code`(`company_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '推广商公司主体表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_company
-- ----------------------------

-- ----------------------------
-- Table structure for oa_company_area
-- ----------------------------
DROP TABLE IF EXISTS `oa_company_area`;
CREATE TABLE `oa_company_area`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '推广商公司ID',
  `area_id` bigint NOT NULL COMMENT '行政区划ID（oa_area.area_id）',
  `area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '行政区划编码',
  `area_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行政区划名称（冗余）',
  `area_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '区域层级（PROVINCE/CITY/COUNTY）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_company_area_active`(`company_id` ASC, `area_code` ASC, `del_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '公司经营区域表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_company_area
-- ----------------------------
INSERT INTO `oa_company_area` VALUES (26, 200, 13, '560101', '云南省', 'province', '0', '0', NULL, 'test_boss1', '2026-05-11 15:08:00', NULL, NULL);
INSERT INTO `oa_company_area` VALUES (27, 200, 1, '520000', '贵州省', 'province', '0', '0', NULL, 'test_boss1', '2026-05-11 15:08:00', NULL, NULL);
INSERT INTO `oa_company_area` VALUES (28, 200, 2, '520100', '贵阳市', 'city', '0', '0', NULL, 'test_boss1', '2026-05-11 15:08:00', NULL, NULL);
INSERT INTO `oa_company_area` VALUES (29, 200, 5, '520103', '云岩区', 'county', '0', '0', NULL, 'test_boss1', '2026-05-11 15:08:00', NULL, NULL);
INSERT INTO `oa_company_area` VALUES (30, 200, 12, '52000301', '乡镇区A', 'town', '0', '0', NULL, 'test_boss1', '2026-05-11 15:08:00', NULL, NULL);
INSERT INTO `oa_company_area` VALUES (31, 200, 6, '520102', '南明区', 'county', '0', '0', NULL, 'test_boss1', '2026-05-11 15:08:00', NULL, NULL);
INSERT INTO `oa_company_area` VALUES (32, 200, 3, '520300', '遵义市', 'city', '0', '0', NULL, 'test_boss1', '2026-05-11 15:08:00', NULL, NULL);

-- ----------------------------
-- Table structure for oa_company_customer_unit
-- ----------------------------
DROP TABLE IF EXISTS `oa_company_customer_unit`;
CREATE TABLE `oa_company_customer_unit`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '推广商公司ID',
  `unit_id` bigint NOT NULL COMMENT '客户单位ID（FK→oa_customer_unit）',
  `owner_user_id` bigint NULL DEFAULT NULL COMMENT '默认负责人（sys_user.user_id）',
  `owner_dept_id` bigint NULL DEFAULT NULL COMMENT '默认负责部门（sys_dept.dept_id）',
  `is_focus` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否重点关注（0否 1是）',
  `default_grade` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '默认等级（A/B/C）',
  `customer_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'NORMAL' COMMENT '客户状态（NORMAL/PAUSED/UNDEVELOPED/COVERED/UNCOVERED）',
  `first_contact_date` date NULL DEFAULT NULL COMMENT '首次接触时间',
  `last_visit_time` datetime NULL DEFAULT NULL COMMENT '最近拜访时间',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_company_unit_active`(`company_id` ASC, `unit_id` ASC, `del_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '公司客户单位关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_company_customer_unit
-- ----------------------------
INSERT INTO `oa_company_customer_unit` VALUES (1, 200, 16, NULL, NULL, '0', NULL, 'NORMAL', NULL, NULL, '0', '2', 'test_boss1', '2026-05-10 16:48:13', '', '2026-05-16 10:03:27', NULL, NULL);
INSERT INTO `oa_company_customer_unit` VALUES (2, 200, 2, NULL, NULL, '0', NULL, 'NORMAL', NULL, NULL, '0', '0', 'test_boss1', '2026-05-10 16:48:14', '', NULL, NULL, NULL);
INSERT INTO `oa_company_customer_unit` VALUES (3, 200, 3, NULL, NULL, '0', NULL, 'NORMAL', NULL, NULL, '0', '0', 'test_boss1', '2026-05-10 16:48:15', '', NULL, NULL, NULL);
INSERT INTO `oa_company_customer_unit` VALUES (4, 200, 4, NULL, NULL, '0', NULL, 'NORMAL', NULL, NULL, '0', '0', 'test_boss1', '2026-05-10 16:48:17', '', NULL, NULL, NULL);
INSERT INTO `oa_company_customer_unit` VALUES (5, 200, 1, NULL, NULL, '0', NULL, 'NORMAL', NULL, NULL, '0', '0', 'test_boss1', '2026-05-10 16:48:31', '', NULL, NULL, NULL);
INSERT INTO `oa_company_customer_unit` VALUES (6, 200, 7, NULL, NULL, '0', NULL, 'NORMAL', NULL, NULL, '0', '0', 'test_boss1', '2026-05-10 16:53:31', '', NULL, NULL, NULL);
INSERT INTO `oa_company_customer_unit` VALUES (7, 200, 9, NULL, NULL, '0', 'C', 'NORMAL', NULL, NULL, '0', '0', 'test_boss1', '2026-05-10 16:53:38', 'test_boss1', '2026-05-11 15:06:16', NULL, NULL);
INSERT INTO `oa_company_customer_unit` VALUES (8, 200, 10, NULL, NULL, '0', 'B', 'NORMAL', NULL, NULL, '0', '0', 'test_boss1', '2026-05-10 16:53:38', 'test_boss1', '2026-05-11 15:06:13', NULL, NULL);
INSERT INTO `oa_company_customer_unit` VALUES (9, 200, 13, NULL, NULL, '0', 'A', 'NORMAL', NULL, NULL, '0', '0', 'test_boss1', '2026-05-10 16:57:09', 'test_boss1', '2026-05-11 15:06:08', NULL, NULL);
INSERT INTO `oa_company_customer_unit` VALUES (10, 200, 16, NULL, NULL, '0', NULL, 'NORMAL', NULL, NULL, '0', '0', 'test_boss1', '2026-05-16 10:03:41', '', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for oa_company_license
-- ----------------------------
DROP TABLE IF EXISTS `oa_company_license`;
CREATE TABLE `oa_company_license`  (
  `license_id` bigint NOT NULL AUTO_INCREMENT COMMENT '授权ID',
  `company_id` bigint NOT NULL COMMENT '推广商公司ID',
  `company_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '公司名称（冗余）',
  `province_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属省编码',
  `province_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属省名称',
  `package_level` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '套餐级别（BASIC/STANDARD/PREMIUM）',
  `max_user_count` int NULL DEFAULT 10 COMMENT '最大账号数',
  `current_user_count` int NULL DEFAULT 0 COMMENT '当前账号数（冗余，可实时统计）',
  `start_date` date NULL DEFAULT NULL COMMENT '服务开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '服务结束日期',
  `license_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'ACTIVE' COMMENT '授权状态（字典 oa_license_status：ACTIVE/STOPPED/EXPIRED）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`license_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '推广商账号授权表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_company_license
-- ----------------------------

-- ----------------------------
-- Table structure for oa_company_vaccine
-- ----------------------------
DROP TABLE IF EXISTS `oa_company_vaccine`;
CREATE TABLE `oa_company_vaccine`  (
  `company_vaccine_id` bigint NOT NULL AUTO_INCREMENT COMMENT '公司在售疫苗ID',
  `company_id` bigint NOT NULL COMMENT '推广商公司ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '疫苗大类ID',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '疫苗小类ID',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '生产企业ID',
  `vaccine_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '展示名称（如\"某厂乙肝CHO\"）',
  `is_agent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否代理（0否 1是）',
  `is_main` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否主推（0否 1是）',
  `is_sale` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否在售（0否 1是）',
  `unit_price` decimal(12, 4) NULL DEFAULT NULL COMMENT '出厂/代理单价（元）',
  `sale_start_date` date NULL DEFAULT NULL COMMENT '销售开始日期',
  `sale_end_date` date NULL DEFAULT NULL COMMENT '销售结束日期',
  `vaccine_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'ON_SALE' COMMENT '在售状态（字典 oa_company_vaccine_status：ON_SALE/PAUSED/STOPPED）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '产品规格SKU_ID',
  `dosage_form_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '剂型编码',
  `dosage_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '剂量编码',
  `crowd_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品人群编码',
  `assessment_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '默认考核方式（支持多选逗号分隔）：FIRST_NEEDLE/DISTRIBUTE/PURE_SALE/CERT',
  `price_id` bigint NULL DEFAULT NULL COMMENT '当前价格ID（关联oa_product_price）',
  PRIMARY KEY (`company_vaccine_id`) USING BTREE,
  INDEX `idx_company_sku_active`(`company_id` ASC, `sku_id` ASC, `del_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '本公司在售/代理疫苗表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_company_vaccine
-- ----------------------------
INSERT INTO `oa_company_vaccine` VALUES (1, 200, 7, 13, 5, '狂犬Vero/成大/冻干/1.0ml/通用', '0', '0', '1', NULL, NULL, NULL, 'ON_SALE', '0', '0', 'test_boss1', '2026-05-11 15:22:28', '', NULL, NULL, NULL, 8, '03', '03', '05', NULL, NULL);
INSERT INTO `oa_company_vaccine` VALUES (2, 200, 6, 12, 7, '9价HPV/默沙东/注射液/0.5ml/女性', '0', '1', '1', NULL, NULL, NULL, 'ON_SALE', '0', '0', 'test_boss1', '2026-05-11 15:22:57', 'test_boss1', '2026-05-16 10:11:14', NULL, NULL, 7, '06', '02', '04', NULL, NULL);
INSERT INTO `oa_company_vaccine` VALUES (3, 200, 1, 2, 4, '乙肝酵母/康泰/注射液/1.0ml/成人', '0', '0', '1', NULL, NULL, NULL, 'ON_SALE', '0', '0', 'test_boss1', '2026-05-11 15:22:57', '', NULL, NULL, NULL, 3, '06', '03', '01', NULL, NULL);

-- ----------------------------
-- Table structure for oa_compliance_material
-- ----------------------------
DROP TABLE IF EXISTS `oa_compliance_material`;
CREATE TABLE `oa_compliance_material`  (
  `material_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '公司ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_id` bigint NOT NULL COMMENT '上传人ID',
  `task_id` bigint NULL DEFAULT NULL COMMENT '关联合规任务ID',
  `type_id` bigint NULL DEFAULT NULL COMMENT '资料分类ID',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '关联厂家ID',
  `company_vaccine_id` bigint NULL DEFAULT NULL COMMENT '关联在售疫苗ID',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件路径',
  `file_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件类型：IMAGE/PDF/DOC/VIDEO/PPT',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小（字节）',
  `file_group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件分组标识',
  `audit_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'DRAFT' COMMENT '审核状态：DRAFT草稿/SUBMITTED已提交/APPROVED通过/REJECTED不通过',
  `audit_by` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `reject_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '不通过原因',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`material_id`) USING BTREE,
  INDEX `idx_material_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_material_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_material_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_material_audit`(`audit_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '合规资料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_compliance_material
-- ----------------------------

-- ----------------------------
-- Table structure for oa_compliance_material_type
-- ----------------------------
DROP TABLE IF EXISTS `oa_compliance_material_type`;
CREATE TABLE `oa_compliance_material_type`  (
  `type_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NULL DEFAULT NULL COMMENT '公司ID（平台通用分类为空）',
  `type_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类编码',
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `abbr` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '简称',
  `legal_person_sign` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '法人签名/电子签名图片路径',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`type_id`) USING BTREE,
  INDEX `idx_cmt_company`(`company_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '合规资料分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_compliance_material_type
-- ----------------------------
INSERT INTO `oa_compliance_material_type` VALUES (1, NULL, 'VISIT', '拜访记录类', '拜访', NULL, 1, '0', '0', 'admin', '2026-05-08 16:06:08', '', NULL, NULL);
INSERT INTO `oa_compliance_material_type` VALUES (2, NULL, 'MEETING', '学术会议类', '会议', NULL, 2, '0', '0', 'admin', '2026-05-08 16:06:08', '', NULL, NULL);
INSERT INTO `oa_compliance_material_type` VALUES (3, NULL, 'SURVEY', '市场调研类', '调研', NULL, 3, '0', '0', 'admin', '2026-05-08 16:06:08', '', NULL, NULL);
INSERT INTO `oa_compliance_material_type` VALUES (4, NULL, 'PROMO', '宣传推广类', '宣传', NULL, 4, '0', '0', 'admin', '2026-05-08 16:06:08', '', NULL, NULL);
INSERT INTO `oa_compliance_material_type` VALUES (5, NULL, 'REPORT', '总结报告类', '报告', NULL, 5, '0', '0', 'admin', '2026-05-08 16:06:08', '', NULL, NULL);
INSERT INTO `oa_compliance_material_type` VALUES (6, NULL, 'INVOICE', '发票/回款凭证', '发票', NULL, 6, '0', '0', 'admin', '2026-05-08 16:06:08', '', NULL, NULL);
INSERT INTO `oa_compliance_material_type` VALUES (7, NULL, 'SIGN', '签到/签名类', '签到', NULL, 7, '0', '0', 'admin', '2026-05-08 16:06:08', '', NULL, NULL);
INSERT INTO `oa_compliance_material_type` VALUES (8, NULL, 'OTHER', '其他类', '其他', NULL, 8, '0', '0', 'admin', '2026-05-08 16:06:08', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_compliance_meeting
-- ----------------------------
DROP TABLE IF EXISTS `oa_compliance_meeting`;
CREATE TABLE `oa_compliance_meeting`  (
  `meeting_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '公司ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_id` bigint NOT NULL COMMENT '创建人/组织人ID',
  `task_id` bigint NULL DEFAULT NULL COMMENT '关联合规任务ID',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '厂家ID',
  `company_vaccine_id` bigint NULL DEFAULT NULL COMMENT '在售疫苗ID',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '产品规格ID',
  `unit_id` bigint NULL DEFAULT NULL COMMENT '客户单位ID（会议关联的目标单位）',
  `meeting_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '会议名称',
  `meeting_theme` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '会议主题',
  `meeting_date` date NULL DEFAULT NULL COMMENT '会议日期',
  `meeting_start_time` datetime NULL DEFAULT NULL COMMENT '会议开始时间',
  `meeting_end_time` datetime NULL DEFAULT NULL COMMENT '会议结束时间',
  `meeting_address` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '会议地点',
  `people_num` int NULL DEFAULT NULL COMMENT '参会人数',
  `speaker` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '宣讲人',
  `modality` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '形式：ONLINE线上/OFFLINE线下/HYBRID混合',
  `purpose` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '会议目的',
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '会议总结',
  `cost` decimal(12, 2) NULL DEFAULT NULL COMMENT '费用',
  `audit_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'DRAFT' COMMENT '审核状态：DRAFT草稿/SUBMITTED已提交/APPROVED通过/REJECTED不通过',
  `audit_by` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核备注',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`meeting_id`) USING BTREE,
  INDEX `idx_meeting_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_meeting_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_meeting_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_meeting_factory`(`factory_id` ASC) USING BTREE,
  INDEX `idx_meeting_date`(`meeting_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '合规会议表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_compliance_meeting
-- ----------------------------

-- ----------------------------
-- Table structure for oa_compliance_meeting_material
-- ----------------------------
DROP TABLE IF EXISTS `oa_compliance_meeting_material`;
CREATE TABLE `oa_compliance_meeting_material`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `meeting_id` bigint NOT NULL COMMENT '会议ID',
  `material_id` bigint NULL DEFAULT NULL COMMENT '合规资料ID（关联oa_compliance_material）',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件路径',
  `file_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件类型：IMAGE/PDF/DOC/PPT/VIDEO',
  `file_category` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件分类：SIGN_IN签到/PHOTO照片/PPT演示/CERT证书/OTHER其他',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_mm_meeting`(`meeting_id` ASC) USING BTREE,
  INDEX `idx_mm_material`(`material_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会议资料关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_compliance_meeting_material
-- ----------------------------

-- ----------------------------
-- Table structure for oa_compliance_meeting_schedule
-- ----------------------------
DROP TABLE IF EXISTS `oa_compliance_meeting_schedule`;
CREATE TABLE `oa_compliance_meeting_schedule`  (
  `schedule_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `meeting_id` bigint NOT NULL COMMENT '会议ID',
  `start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开始时间（如09:00）',
  `end_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结束时间（如10:30）',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行程内容',
  `speaker` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '本时段主讲人',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`schedule_id`) USING BTREE,
  INDEX `idx_schedule_meeting`(`meeting_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会议行程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_compliance_meeting_schedule
-- ----------------------------

-- ----------------------------
-- Table structure for oa_compliance_task
-- ----------------------------
DROP TABLE IF EXISTS `oa_compliance_task`;
CREATE TABLE `oa_compliance_task`  (
  `task_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '公司ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_id` bigint NOT NULL COMMENT '负责人ID',
  `template_id` bigint NULL DEFAULT NULL COMMENT '来源模板ID',
  `template_item_id` bigint NULL DEFAULT NULL COMMENT '来源模板明细ID',
  `factory_id` bigint NOT NULL COMMENT '厂家ID',
  `company_vaccine_id` bigint NULL DEFAULT NULL COMMENT '公司在售疫苗ID',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '产品规格ID',
  `task_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `task_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务类型：VISIT拜访/MEETING会议/SURVEY调研/PROMO宣传/REPORT报告/MATERIAL资料',
  `task_month` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务月份（如202505）',
  `task_quarter` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务季度（Q1/Q2/Q3/Q4）',
  `required_qty` int NULL DEFAULT 1 COMMENT '要求完成数量',
  `completed_qty` int NULL DEFAULT 0 COMMENT '已完成数量',
  `completion_rate` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '完成率（%）',
  `task_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'PENDING' COMMENT '状态：PENDING待执行/IN_PROGRESS进行中/REVIEW待审核/COMPLETED已完成/OVERDUE已逾期',
  `deadline` date NULL DEFAULT NULL COMMENT '截止日期',
  `cost_total` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '累计费用',
  `cost_limit` decimal(12, 2) NULL DEFAULT NULL COMMENT '费用上限',
  `audit_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核状态：PENDING/APPROVED/REJECTED',
  `audit_by` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核备注',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`task_id`) USING BTREE,
  INDEX `idx_task_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_task_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_task_factory`(`factory_id` ASC) USING BTREE,
  INDEX `idx_task_month`(`task_month` ASC) USING BTREE,
  INDEX `idx_task_status`(`task_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '合规任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_compliance_task
-- ----------------------------

-- ----------------------------
-- Table structure for oa_compliance_template
-- ----------------------------
DROP TABLE IF EXISTS `oa_compliance_template`;
CREATE TABLE `oa_compliance_template`  (
  `template_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '公司ID',
  `factory_id` bigint NOT NULL COMMENT '厂家ID',
  `company_vaccine_id` bigint NULL DEFAULT NULL COMMENT '公司在售疫苗ID（空=该厂家通用模板）',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '产品规格ID',
  `template_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模板名称',
  `template_year` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '适用年份（如2025）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`template_id`) USING BTREE,
  INDEX `idx_tpl_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_tpl_factory`(`factory_id` ASC) USING BTREE,
  INDEX `idx_tpl_year`(`template_year` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '厂商合规模板表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_compliance_template
-- ----------------------------

-- ----------------------------
-- Table structure for oa_compliance_template_item
-- ----------------------------
DROP TABLE IF EXISTS `oa_compliance_template_item`;
CREATE TABLE `oa_compliance_template_item`  (
  `item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `template_id` bigint NOT NULL COMMENT '模板ID',
  `material_type_id` bigint NULL DEFAULT NULL COMMENT '资料分类ID',
  `material_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '材料描述（如：拜访记录≥4次/月）',
  `required_qty` int NULL DEFAULT NULL COMMENT '要求数量',
  `frequency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '频率：MONTHLY月度/QUARTERLY季度/YEARLY年度/PER_VISIT每次',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否必须（1必须 0可选）',
  `deadline_rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '截止日规则描述（如：每月5日前）',
  `cost_limit` decimal(12, 2) NULL DEFAULT NULL COMMENT '费用上限',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`item_id`) USING BTREE,
  INDEX `idx_tplitem_template`(`template_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '合规模板材料明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_compliance_template_item
-- ----------------------------

-- ----------------------------
-- Table structure for oa_customer_contact
-- ----------------------------
DROP TABLE IF EXISTS `oa_customer_contact`;
CREATE TABLE `oa_customer_contact`  (
  `contact_id` bigint NOT NULL AUTO_INCREMENT COMMENT '客户信息ID',
  `company_id` bigint NOT NULL COMMENT '推广商公司ID',
  `company_unit_id` bigint NULL DEFAULT NULL COMMENT '公司客户单位关系ID（FK→oa_company_customer_unit.id）',
  `unit_id` bigint NULL DEFAULT NULL COMMENT '客户单位ID（FK→oa_customer_unit.unit_id）',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '客户姓名',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性别（0男 1女 2未知）',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `office_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '办公电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `wechat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信号',
  `department_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所在科室',
  `position_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '职务',
  `primary_role_id` bigint NULL DEFAULT NULL COMMENT '主要客户角色ID（FK→oa_customer_role）',
  `decision_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '决策类型（字典 oa_customer_decision_type：决策者/影响者/执行者/财务/库管）',
  `influence_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '影响力等级（HIGH/MEDIUM/LOW）',
  `relationship_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客情等级（HIGH/MEDIUM/LOW）',
  `attitude` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '态度（SUPPORT/NEUTRAL/OPPOSE/UNKNOWN）',
  `is_key_person` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否关键人（0否 1是）',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `hobbies` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '兴趣爱好',
  `personality_tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性格标签',
  `communication_preference` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '沟通偏好',
  `background_info` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '背调信息',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '所属部门ID（若依数据权限过滤用）',
  `owner_user_id` bigint NULL DEFAULT NULL COMMENT '负责维护的业务员（sys_user.user_id）',
  `last_visit_time` datetime NULL DEFAULT NULL COMMENT '最近拜访时间',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`contact_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_customer_contact
-- ----------------------------

-- ----------------------------
-- Table structure for oa_customer_contact_role
-- ----------------------------
DROP TABLE IF EXISTS `oa_customer_contact_role`;
CREATE TABLE `oa_customer_contact_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '推广商公司ID',
  `contact_id` bigint NOT NULL COMMENT '客户信息ID（FK→oa_customer_contact）',
  `unit_id` bigint NULL DEFAULT NULL COMMENT '客户单位ID',
  `role_id` bigint NOT NULL COMMENT '客户角色ID（FK→oa_customer_role）',
  `category_id` bigint NULL DEFAULT NULL COMMENT '疫苗大类（可为空）',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '疫苗小类（可为空）',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '厂家（可为空）',
  `company_vaccine_id` bigint NULL DEFAULT NULL COMMENT '公司在售疫苗ID（可为空）',
  `is_primary` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否主要角色（0否 1是）',
  `start_date` date NULL DEFAULT NULL COMMENT '生效开始',
  `end_date` date NULL DEFAULT NULL COMMENT '生效结束',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户-角色关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_customer_contact_role
-- ----------------------------

-- ----------------------------
-- Table structure for oa_customer_role
-- ----------------------------
DROP TABLE IF EXISTS `oa_customer_role`;
CREATE TABLE `oa_customer_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '客户角色ID',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码（DEAN/DIRECTOR/DOCTOR/FINANCE/KEEPER等）',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称（院长/主任/医生/财务/库管）',
  `role_category` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色分类（决策/影响/执行/财务/库管/信息）',
  `role_level` int NULL DEFAULT NULL COMMENT '角色重要程度',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色说明',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序号',
  `company_id` bigint NULL DEFAULT NULL COMMENT '公司ID（空=平台通用角色）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_customer_role
-- ----------------------------
INSERT INTO `oa_customer_role` VALUES (1, 'DEAN', '院长', '决策', 1, NULL, 1, NULL, '0', '0', 'admin', '2026-05-07 16:37:46', '', NULL, NULL);
INSERT INTO `oa_customer_role` VALUES (2, 'DIRECTOR', '主任', '决策', 2, NULL, 2, NULL, '0', '0', 'admin', '2026-05-07 16:37:46', '', NULL, NULL);
INSERT INTO `oa_customer_role` VALUES (3, 'SECTION_CHIEF', '科长', '影响', 3, NULL, 3, NULL, '0', '0', 'admin', '2026-05-07 16:37:46', '', NULL, NULL);
INSERT INTO `oa_customer_role` VALUES (4, 'DOCTOR', '医生', '执行', 4, NULL, 4, NULL, '0', '0', 'admin', '2026-05-07 16:37:46', '', NULL, NULL);
INSERT INTO `oa_customer_role` VALUES (5, 'FINANCE', '财务', '财务', 5, NULL, 5, NULL, '0', '0', 'admin', '2026-05-07 16:37:46', '', NULL, NULL);
INSERT INTO `oa_customer_role` VALUES (6, 'KEEPER', '库管', '库管', 6, NULL, 6, NULL, '0', '0', 'admin', '2026-05-07 16:37:46', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_customer_unit
-- ----------------------------
DROP TABLE IF EXISTS `oa_customer_unit`;
CREATE TABLE `oa_customer_unit`  (
  `unit_id` bigint NOT NULL AUTO_INCREMENT COMMENT '客户单位ID',
  `parent_unit_id` bigint NULL DEFAULT 0 COMMENT '上级客户单位ID（0=顶级）',
  `ancestors` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `unit_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '单位名称',
  `unit_full_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位全称',
  `unit_short_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位简称',
  `unit_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位编码（参考 t_s_depart.org_code）',
  `external_depa_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省平台单位ID',
  `external_depa_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省平台单位编号',
  `unit_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位层级（字典 oa_unit_level：PROVINCE/CITY/COUNTY/POV）',
  `unit_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位类型（字典 oa_unit_type：CDC/POV/HOSPITAL/ASSOCIATION/OTHER）',
  `site_level` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接种点级别（省级/市级/县级/普通POV）',
  `is_cdc` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否疾控（0否 1是）',
  `is_pov` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否POV（0否 1是）',
  `is_vaccination_site` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否接种单位（0否 1是）',
  `is_order_unit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否点单单位（0否 1是）',
  `province_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省编码',
  `province_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省名称',
  `city_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市编码',
  `city_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市名称',
  `county_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '县编码',
  `county_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '县名称',
  `town_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '乡镇编码',
  `town_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '乡镇名称',
  `area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行政区划编码',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '默认联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `pinyin_initial` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拼音首字母',
  `longitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '经度',
  `latitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '纬度',
  `source_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'PLATFORM' COMMENT '数据来源（PLATFORM平台标准/COMPANY公司自建/IMPORT导入）',
  `source_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源系统主键（迁移兼容）',
  `audit_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核状态',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`unit_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户单位主表（平台级标准库）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_customer_unit
-- ----------------------------
INSERT INTO `oa_customer_unit` VALUES (1, 0, '0', '贵州省CDC', '贵州省疾病预防控制中心', NULL, 'GZ-CDC', NULL, NULL, 'province', 'CDC', NULL, '1', '0', '0', '0', '520000', '贵州省', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 1, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (2, 1, '0,1', '贵阳市CDC', '贵阳市疾病预防控制中心', NULL, 'GY-CDC', NULL, NULL, 'city', 'CDC', NULL, '1', '0', '0', '0', '520000', '贵州省', '520100', '贵阳市', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 1, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (3, 2, '0,1,2', '云岩区CDC', '贵阳市云岩区疾病预防控制中心', NULL, 'GY-YY-CDC', NULL, NULL, 'county', 'CDC', NULL, '1', '0', '0', '0', '520000', '贵州省', '520100', '贵阳市', '520103', '云岩区', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 1, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (4, 3, '0,1,2,3', '云岩区社区POV', '贵阳市云岩区社区卫生服务中心接种门诊', NULL, 'GY-YY-POV-01', NULL, NULL, 'town', 'POV', NULL, '0', '1', '0', '0', '520000', '贵州省', '520100', '贵阳市', '520103', '云岩区', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 1, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (5, 3, '0,1,2,3', '云岩区北京路POV', '贵阳市云岩区北京路社区接种门诊', NULL, 'GY-YY-POV-02', NULL, NULL, 'town', 'POV', NULL, '0', '1', '0', '0', '520000', '贵州省', '520100', '贵阳市', '520103', '云岩区', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 2, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (6, 2, '0,1,2', '南明区CDC', '贵阳市南明区疾病预防控制中心', NULL, 'GY-NM-CDC', NULL, NULL, 'county', 'CDC', NULL, '1', '0', '0', '0', '520000', '贵州省', '520100', '贵阳市', '520102', '南明区', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 2, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (7, 6, '0,1,2,6', '南明区花果园POV', '贵阳市南明区花果园社区接种门诊', NULL, 'GY-NM-POV-01', NULL, NULL, 'town', 'POV', NULL, '0', '1', '0', '0', '520000', '贵州省', '520100', '贵阳市', '520102', '南明区', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 1, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (8, 1, '0,1', '遵义市CDC', '遵义市疾病预防控制中心', NULL, 'ZY-CDC', NULL, NULL, 'city', 'CDC', NULL, '1', '0', '0', '0', '520000', '贵州省', '520300', '遵义市', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 2, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (9, 8, '0,1,8', '红花岗区CDC', '遵义市红花岗区疾病预防控制中心', NULL, 'ZY-HHG-CDC', NULL, NULL, 'county', 'CDC', NULL, '1', '0', '0', '0', '520000', '贵州省', '520300', '遵义市', '520302', '红花岗区', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 1, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (10, 9, '0,1,8,9', '红花岗区中心POV', '遵义市红花岗区中心接种门诊', NULL, 'ZY-HHG-POV-01', NULL, NULL, 'town', 'POV', NULL, '0', '1', '0', '0', '520000', '贵州省', '520300', '遵义市', '520302', '红花岗区', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 1, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (11, 8, '0,1,8', '汇川区CDC', '遵义市汇川区疾病预防控制中心', NULL, 'ZY-HC-CDC', NULL, NULL, 'county', 'CDC', NULL, '1', '0', '0', '0', '520000', '贵州省', '520300', '遵义市', '520303', '汇川区', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 2, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (12, 1, '0,1', '安顺市CDC', '安顺市疾病预防控制中心', NULL, 'AS-CDC', NULL, NULL, 'city', 'CDC', NULL, '1', '0', '0', '0', '520000', '贵州省', '520400', '安顺市', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 3, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (13, 12, '0,1,12', '西秀区CDC', '安顺市西秀区疾病预防控制中心', NULL, 'AS-XX-CDC', NULL, NULL, 'county', 'CDC', NULL, '1', '0', '0', '0', '520000', '贵州省', '520400', '安顺市', '520402', '西秀区', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 1, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (14, 13, '0,1,12,13', '西秀区城关POV', '安顺市西秀区城关社区接种门诊', NULL, 'AS-XX-POV-01', NULL, NULL, 'town', 'POV', NULL, '0', '1', '0', '0', '520000', '贵州省', '520400', '安顺市', '520402', '西秀区', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 1, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (15, 1, '0,1', '贵州省人民医院', '贵州省人民医院', NULL, 'GZ-HOSP-01', NULL, NULL, 'province', 'HOSPITAL', NULL, '0', '0', '0', '0', '520000', '贵州省', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 10, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_customer_unit` VALUES (16, 0, '0', '贵阳学院', '贵阳学院', NULL, '贵阳学院', NULL, NULL, 'county', 'OTHER', NULL, '0', '0', '0', '0', '520100', '贵阳市', '520103', '云岩区', '52000301', '乡镇区A', NULL, NULL, '52000301', '祁阳县白水镇烟', 'gg bond', '19976628341', NULL, NULL, NULL, 'PLATFORM', NULL, NULL, 0, '0', '0', 'admin', '2026-05-09 13:53:27', 'admin', '2026-05-09 13:53:56', NULL);

-- ----------------------------
-- Table structure for oa_customer_unit_grade
-- ----------------------------
DROP TABLE IF EXISTS `oa_customer_unit_grade`;
CREATE TABLE `oa_customer_unit_grade`  (
  `grade_id` bigint NOT NULL AUTO_INCREMENT COMMENT '客户类别ID',
  `company_id` bigint NOT NULL COMMENT '推广商公司ID',
  `company_vaccine_id` bigint NULL DEFAULT NULL COMMENT '本公司在售疫苗ID（FK→oa_company_vaccine）',
  `unit_id` bigint NOT NULL COMMENT '客户单位ID（FK→oa_customer_unit）',
  `company_unit_id` bigint NULL DEFAULT NULL COMMENT '公司客户单位关系ID（FK→oa_company_customer_unit）',
  `category_id` bigint NULL DEFAULT NULL COMMENT '疫苗大类ID（冗余加速查询）',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '疫苗小类ID（冗余）',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '生产企业ID（冗余）',
  `grade` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ABC等级（A/B/C）',
  `grade_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '等级名称（超重点客户/重点客户/一般客户）',
  `grade_dimension` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分级维度（MARKET_CAP/SALES/PROFIT/STRATEGY/MANUAL）',
  `grade_basis` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分级依据说明',
  `stat_year` int NULL DEFAULT NULL COMMENT '统计年度',
  `stat_month` int NULL DEFAULT NULL COMMENT '统计月份（空=年度级别）',
  `usage_qty` decimal(12, 2) NULL DEFAULT NULL COMMENT '使用量',
  `sales_amount` decimal(14, 2) NULL DEFAULT NULL COMMENT '销售金额',
  `profit_amount` decimal(14, 2) NULL DEFAULT NULL COMMENT '利润金额',
  `market_potential` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市场潜力（HIGH/MEDIUM/LOW）',
  `is_manual` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否人工指定（0否 1是）',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '所属部门ID（若依数据权限过滤用）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '操作人/负责人（sys_user.user_id）',
  `effective_start` date NULL DEFAULT NULL COMMENT '生效开始日期',
  `effective_end` date NULL DEFAULT NULL COMMENT '生效结束日期',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '产品规格SKU_ID',
  `grade_source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'MANUAL' COMMENT '来源：MANUAL人工/SYSTEM系统计算',
  `last_calc_time` datetime NULL DEFAULT NULL COMMENT '最近系统计算时间',
  PRIMARY KEY (`grade_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户单位类别表（ABC分级）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_customer_unit_grade
-- ----------------------------

-- ----------------------------
-- Table structure for oa_customer_unit_grade_log
-- ----------------------------
DROP TABLE IF EXISTS `oa_customer_unit_grade_log`;
CREATE TABLE `oa_customer_unit_grade_log`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `grade_id` bigint NOT NULL COMMENT '客户类别ID（FK→oa_customer_unit_grade）',
  `company_id` bigint NOT NULL COMMENT '推广商公司ID',
  `company_vaccine_id` bigint NULL DEFAULT NULL COMMENT '在售疫苗ID',
  `unit_id` bigint NOT NULL COMMENT '客户单位ID',
  `old_grade` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '调整前等级',
  `new_grade` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '调整后等级',
  `change_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '调整原因',
  `change_user_id` bigint NULL DEFAULT NULL COMMENT '调整人（sys_user.user_id）',
  `change_time` datetime NULL DEFAULT NULL COMMENT '调整时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户类别调整日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_customer_unit_grade_log
-- ----------------------------

-- ----------------------------
-- Table structure for oa_data_import_batch
-- ----------------------------
DROP TABLE IF EXISTS `oa_data_import_batch`;
CREATE TABLE `oa_data_import_batch`  (
  `batch_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '公司ID',
  `source_id` bigint NULL DEFAULT NULL COMMENT '数据源ID（关联oa_external_source）',
  `import_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '导入类型：ORDER点单/REAL_SALE实销/INVENTORY库存/MONTHLY月报',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '导入文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件存储路径',
  `data_month` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '数据所属月份（如202505）',
  `total_count` int NULL DEFAULT 0 COMMENT '总条数',
  `success_count` int NULL DEFAULT 0 COMMENT '成功条数',
  `fail_count` int NULL DEFAULT 0 COMMENT '失败条数',
  `unmatch_count` int NULL DEFAULT 0 COMMENT '未匹配条数',
  `import_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'INIT' COMMENT '导入状态：INIT初始/PROCESSING处理中/SUCCESS成功/PARTIAL部分成功/FAILED失败',
  `error_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误信息（JSON格式记录每行错误）',
  `start_time` datetime NULL DEFAULT NULL COMMENT '导入开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '导入结束时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '导入人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`batch_id`) USING BTREE,
  INDEX `idx_batch_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_batch_type`(`import_type` ASC) USING BTREE,
  INDEX `idx_batch_month`(`data_month` ASC) USING BTREE,
  INDEX `idx_batch_status`(`import_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据导入批次表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_data_import_batch
-- ----------------------------

-- ----------------------------
-- Table structure for oa_exam
-- ----------------------------
DROP TABLE IF EXISTS `oa_exam`;
CREATE TABLE `oa_exam`  (
  `exam_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '公司ID',
  `exam_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '考试名称',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '关联疫苗小类（限定题目范围）',
  `exam_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型：REGULAR定期/MEETING会议随堂/RANDOM随机',
  `total_score` int NULL DEFAULT 100 COMMENT '总分',
  `pass_score` int NULL DEFAULT 60 COMMENT '及格分',
  `time_limit` int NULL DEFAULT NULL COMMENT '限时（分钟，空=不限时）',
  `question_count` int NULL DEFAULT NULL COMMENT '题目数量',
  `question_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '题目ID列表（JSON数组）',
  `start_time` datetime NULL DEFAULT NULL COMMENT '考试开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '考试结束时间',
  `target_dept_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '目标部门ID列表（逗号分隔）',
  `target_user_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '目标人员ID列表（逗号分隔）',
  `exam_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0草稿 1已发布 2已结束）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`exam_id`) USING BTREE,
  INDEX `idx_exam_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_exam_subclass`(`subclass_id` ASC) USING BTREE,
  INDEX `idx_exam_status`(`exam_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '考试表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_exam
-- ----------------------------

-- ----------------------------
-- Table structure for oa_exam_record
-- ----------------------------
DROP TABLE IF EXISTS `oa_exam_record`;
CREATE TABLE `oa_exam_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `exam_id` bigint NOT NULL COMMENT '考试ID',
  `user_id` bigint NOT NULL COMMENT '考生ID',
  `company_id` bigint NULL DEFAULT NULL COMMENT '公司ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `score` int NULL DEFAULT NULL COMMENT '得分',
  `is_pass` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否通过（1是 0否）',
  `correct_count` int NULL DEFAULT NULL COMMENT '正确题数',
  `wrong_count` int NULL DEFAULT NULL COMMENT '错误题数',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始答题时间',
  `submit_time` datetime NULL DEFAULT NULL COMMENT '提交时间',
  `duration` int NULL DEFAULT NULL COMMENT '用时（秒）',
  `answer_detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '答题详情（JSON：[{questionId,selectedAnswers,isCorrect}]）',
  `record_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0答题中 1已提交 2已批改）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  UNIQUE INDEX `uk_exam_user`(`exam_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_er_exam`(`exam_id` ASC) USING BTREE,
  INDEX `idx_er_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_er_company`(`company_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '考试记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_exam_record
-- ----------------------------

-- ----------------------------
-- Table structure for oa_external_mapping
-- ----------------------------
DROP TABLE IF EXISTS `oa_external_mapping`;
CREATE TABLE `oa_external_mapping`  (
  `mapping_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NULL DEFAULT NULL COMMENT '公司ID（平台级映射为空，公司私有映射填充）',
  `source_id` bigint NULL DEFAULT NULL COMMENT '数据源ID（关联oa_external_source）',
  `mapping_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '映射类型：VACCINE疫苗/FACTORY厂家/ORG机构',
  `standard_id` bigint NULL DEFAULT NULL COMMENT '标准ID（我方系统的主键ID）',
  `standard_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标准编码（我方系统的编码）',
  `standard_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标准名称（我方系统的名称）',
  `source_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部系统编码',
  `source_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部系统简称',
  `source_full_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部系统全称',
  `source_scene` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场景：ORDER点单/INVENTORY库存/REAL_SALE实销',
  `match_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'UNMATCHED' COMMENT '匹配状态：MATCHED已匹配/UNMATCHED未匹配/IGNORED忽略',
  `last_match_time` datetime NULL DEFAULT NULL COMMENT '最近匹配时间',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`mapping_id`) USING BTREE,
  INDEX `idx_mapping_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_mapping_type_scene`(`mapping_type` ASC, `source_scene` ASC) USING BTREE,
  INDEX `idx_mapping_status`(`match_status` ASC) USING BTREE,
  INDEX `idx_mapping_standard`(`standard_id` ASC, `mapping_type` ASC) USING BTREE,
  INDEX `idx_mapping_source`(`source_name` ASC, `mapping_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '外部名称映射表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_external_mapping
-- ----------------------------

-- ----------------------------
-- Table structure for oa_external_source
-- ----------------------------
DROP TABLE IF EXISTS `oa_external_source`;
CREATE TABLE `oa_external_source`  (
  `source_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `source_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '数据源编码',
  `source_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '数据源名称',
  `source_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型：PROVINCE省平台/VACCINATION接种系统/INVENTORY库存系统/OTHER其他',
  `api_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接口地址（如有API对接）',
  `data_format` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '数据格式：EXCEL/CSV/API',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`source_id`) USING BTREE,
  UNIQUE INDEX `uk_source_code`(`source_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '外部数据源表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_external_source
-- ----------------------------
INSERT INTO `oa_external_source` VALUES (1, 'PROVINCE_PLATFORM', '省疾控平台', 'PROVINCE', NULL, 'EXCEL', 1, '0', '0', 'admin', '2026-05-08 16:05:55', '', NULL, NULL);
INSERT INTO `oa_external_source` VALUES (2, 'VACCINATION_SYS', '接种信息系统', 'VACCINATION', NULL, 'EXCEL', 2, '0', '0', 'admin', '2026-05-08 16:05:55', '', NULL, NULL);
INSERT INTO `oa_external_source` VALUES (3, 'INVENTORY_SYS', '库存管理系统', 'INVENTORY', NULL, 'EXCEL', 3, '0', '0', 'admin', '2026-05-08 16:05:55', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_factory_vaccine_subclass
-- ----------------------------
DROP TABLE IF EXISTS `oa_factory_vaccine_subclass`;
CREATE TABLE `oa_factory_vaccine_subclass`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `factory_id` bigint NOT NULL COMMENT '生产企业ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '疫苗大类ID（冗余加速查询）',
  `subclass_id` bigint NOT NULL COMMENT '疫苗小类ID',
  `can_produce` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否可生产（0否 1是）',
  `is_main_product` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否主力产品（0否 1是）',
  `approval_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '批准文号',
  `start_date` date NULL DEFAULT NULL COMMENT '生效开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '生效结束日期',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '厂家-疫苗小类关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_factory_vaccine_subclass
-- ----------------------------
INSERT INTO `oa_factory_vaccine_subclass` VALUES (1, 1, 1, 1, '1', '1', 'S20200001', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (2, 1, 10, 19, '1', '0', 'S20200002', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (3, 2, 6, 12, '1', '1', 'S20200003', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (4, 2, 9, 18, '1', '0', 'S20200004', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (5, 3, 9, 17, '1', '1', 'S20200005', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (6, 3, 8, 15, '1', '0', 'S20200006', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (7, 4, 1, 2, '1', '1', 'S20200007', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (8, 4, 1, 1, '1', '0', 'S20200008', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (9, 5, 7, 13, '1', '1', 'S20200009', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (10, 6, 4, 7, '1', '1', 'S20200010', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (11, 6, 3, 5, '1', '0', 'S20200011', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (12, 7, 6, 12, '1', '1', 'S20200012', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (13, 7, 9, 18, '1', '0', 'S20200013', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (14, 8, 6, 11, '1', '1', 'S20200014', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (15, 8, 5, 9, '1', '0', 'S20200015', NULL, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_factory_vaccine_subclass` VALUES (16, 1, 1, 2, '1', '0', NULL, NULL, NULL, '0', '0', 'admin', '2026-05-09 10:52:13', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_product_assessment_rule
-- ----------------------------
DROP TABLE IF EXISTS `oa_product_assessment_rule`;
CREATE TABLE `oa_product_assessment_rule`  (
  `rule_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '公司ID',
  `scope_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '范围类型：AREA区域/UNIT单位',
  `area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区域编码（scope_type=AREA时填写）',
  `unit_id` bigint NULL DEFAULT NULL COMMENT '客户单位ID（scope_type=UNIT时填写）',
  `company_vaccine_id` bigint NULL DEFAULT NULL COMMENT '公司在售疫苗ID',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '产品规格SKU_ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '疫苗大类ID',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '疫苗小类ID',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '厂家ID',
  `dosage_form_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '剂型编码',
  `dosage_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '剂量编码',
  `assess_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '考核方式（支持多选逗号分隔）：FIRST_NEEDLE首针/DISTRIBUTE分销/PURE_SALE纯销/CERT凭证',
  `primary_assess` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主考核方式（多选时标记哪个为主，用于计算优先级）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`rule_id`) USING BTREE,
  INDEX `idx_rule_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_rule_sku`(`sku_id` ASC) USING BTREE,
  INDEX `idx_rule_unit`(`unit_id` ASC) USING BTREE,
  INDEX `idx_company_scope_target_sku`(`company_id` ASC, `scope_type` ASC, `unit_id` ASC, `area_code` ASC, `sku_id` ASC, `del_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品考核规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_product_assessment_rule
-- ----------------------------

-- ----------------------------
-- Table structure for oa_product_crowd
-- ----------------------------
DROP TABLE IF EXISTS `oa_product_crowd`;
CREATE TABLE `oa_product_crowd`  (
  `crowd_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `crowd_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '人群编码',
  `crowd_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '人群名称（成人/儿童/全年龄等）',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`crowd_id`) USING BTREE,
  UNIQUE INDEX `uk_crowd_code`(`crowd_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品人群字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_product_crowd
-- ----------------------------
INSERT INTO `oa_product_crowd` VALUES (1, '01', '成人', 1, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_crowd` VALUES (2, '02', '儿童', 2, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_crowd` VALUES (3, '03', '全年龄', 3, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_crowd` VALUES (4, '04', '女性', 4, '0', '0', 'admin', '2026-05-09 11:27:14', '', NULL, NULL);
INSERT INTO `oa_product_crowd` VALUES (5, '05', '全人群', 5, '0', '0', 'admin', '2026-05-09 11:27:14', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_product_dosage
-- ----------------------------
DROP TABLE IF EXISTS `oa_product_dosage`;
CREATE TABLE `oa_product_dosage`  (
  `dosage_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dosage_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剂量编码',
  `dosage_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剂量名称（0.5ml/1.0ml等）',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dosage_id`) USING BTREE,
  UNIQUE INDEX `uk_dosage_code`(`dosage_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剂量字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_product_dosage
-- ----------------------------
INSERT INTO `oa_product_dosage` VALUES (1, '01', '0.25ml', 1, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_dosage` VALUES (2, '02', '0.5ml', 2, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_dosage` VALUES (3, '03', '1.0ml', 3, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_dosage` VALUES (4, '04', '1.5ml', 4, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_dosage` VALUES (5, '05', '2.0ml', 5, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_product_dosage_form
-- ----------------------------
DROP TABLE IF EXISTS `oa_product_dosage_form`;
CREATE TABLE `oa_product_dosage_form`  (
  `dosage_form_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dosage_form_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剂型编码',
  `dosage_form_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剂型名称（预充/西林瓶/冻干等）',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dosage_form_id`) USING BTREE,
  UNIQUE INDEX `uk_dosage_form_code`(`dosage_form_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剂型字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_product_dosage_form
-- ----------------------------
INSERT INTO `oa_product_dosage_form` VALUES (1, '01', '预充', 1, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_dosage_form` VALUES (2, '02', '西林瓶', 2, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_dosage_form` VALUES (3, '03', '冻干', 3, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_dosage_form` VALUES (4, '04', '口服液', 4, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_dosage_form` VALUES (5, '05', '糖丸', 5, '0', '0', 'admin', '2026-05-08 16:05:30', '', NULL, NULL);
INSERT INTO `oa_product_dosage_form` VALUES (6, '06', '注射液', 6, '0', '0', 'admin', '2026-05-09 11:27:14', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_product_price
-- ----------------------------
DROP TABLE IF EXISTS `oa_product_price`;
CREATE TABLE `oa_product_price`  (
  `price_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NULL DEFAULT NULL COMMENT '公司ID（平台统一价为空，公司独立价填充）',
  `sku_id` bigint NOT NULL COMMENT '产品规格SKU_ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '疫苗大类ID（冗余便于查询）',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '疫苗小类ID（冗余）',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '厂家ID（冗余）',
  `base_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '基础价（市场费用基数）',
  `diff_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '差额价（市场费用差额）',
  `sti_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '激励价（市场费用激励）',
  `ret_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '回款价（地区经理）',
  `floor_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '底价（劳务费用）',
  `fix_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '固定价',
  `settle_flag` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '结算方式：1默认多层价 2固定价',
  `start_month` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生效开始月份（如202501）',
  `end_month` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生效结束月份（如202512）',
  `is_current` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否当前有效价格（1是 0否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`price_id`) USING BTREE,
  INDEX `idx_price_sku`(`sku_id` ASC) USING BTREE,
  INDEX `idx_price_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_price_current`(`sku_id` ASC, `is_current` ASC) USING BTREE,
  INDEX `idx_company_sku_current`(`company_id` ASC, `sku_id` ASC, `is_current` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品价格表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_product_price
-- ----------------------------

-- ----------------------------
-- Table structure for oa_product_price_log
-- ----------------------------
DROP TABLE IF EXISTS `oa_product_price_log`;
CREATE TABLE `oa_product_price_log`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `price_id` bigint NOT NULL COMMENT '价格ID',
  `sku_id` bigint NOT NULL COMMENT '产品规格ID',
  `company_id` bigint NULL DEFAULT NULL COMMENT '公司ID',
  `change_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '变更类型：CREATE新建/UPDATE修改',
  `old_base_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '旧基础价',
  `new_base_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '新基础价',
  `old_diff_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '旧差额价',
  `new_diff_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '新差额价',
  `old_sti_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '旧激励价',
  `new_sti_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '新激励价',
  `old_ret_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '旧回款价',
  `new_ret_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '新回款价',
  `old_floor_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '旧底价',
  `new_floor_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '新底价',
  `old_fix_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '旧固定价',
  `new_fix_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '新固定价',
  `change_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '变更原因',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_pricelog_price`(`price_id` ASC) USING BTREE,
  INDEX `idx_pricelog_sku`(`sku_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品价格变更日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_product_price_log
-- ----------------------------

-- ----------------------------
-- Table structure for oa_sales_staff_profile
-- ----------------------------
DROP TABLE IF EXISTS `oa_sales_staff_profile`;
CREATE TABLE `oa_sales_staff_profile`  (
  `profile_id` bigint NOT NULL AUTO_INCREMENT COMMENT '业务员档案ID',
  `company_id` bigint NOT NULL COMMENT '所属推广商公司ID',
  `sys_user_id` bigint NOT NULL COMMENT '若依用户ID（FK→sys_user.user_id）',
  `staff_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务员编号',
  `staff_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务员姓名（冗余 sys_user.nick_name）',
  `staff_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务身份（字典 oa_staff_type：BOSS/DIRECTOR/REGION_MANAGER/MED_REP/MARKET_INFO）',
  `staff_level` int NULL DEFAULT NULL COMMENT '业务层级深度',
  `leader_user_id` bigint NULL DEFAULT NULL COMMENT '直属上级用户ID（快查）',
  `default_dept_id` bigint NULL DEFAULT NULL COMMENT '默认所属内部部门ID（FK→sys_dept.dept_id）',
  `province_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '[已废弃-权限请用oa_staff_area_scope] 默认负责省编码',
  `province_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '[已废弃] 默认负责省名称',
  `city_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '[已废弃-权限请用oa_staff_area_scope] 默认负责市编码',
  `city_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '[已废弃] 默认负责市名称',
  `county_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '[已废弃-权限请用oa_staff_area_scope] 默认负责县编码',
  `county_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '[已废弃] 默认负责县名称',
  `phone_num` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号（业务联系用）',
  `job_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'ACTIVE' COMMENT '在职状态（字典 oa_job_status：ACTIVE/LEFT/DISABLED）',
  `entry_date` date NULL DEFAULT NULL COMMENT '入职日期',
  `leave_date` date NULL DEFAULT NULL COMMENT '离职日期',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `userid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统用户ID（迁移兼容 t_s_user.id）',
  `departid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统部门ID（迁移兼容 t_s_user.departid）',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`profile_id`) USING BTREE,
  UNIQUE INDEX `uk_staff_company_user`(`company_id` ASC, `sys_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务员扩展表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_sales_staff_profile
-- ----------------------------

-- ----------------------------
-- Table structure for oa_sales_staff_relation
-- ----------------------------
DROP TABLE IF EXISTS `oa_sales_staff_relation`;
CREATE TABLE `oa_sales_staff_relation`  (
  `relation_id` bigint NOT NULL AUTO_INCREMENT COMMENT '关系ID',
  `company_id` bigint NOT NULL COMMENT '所属推广商公司ID',
  `user_id` bigint NOT NULL COMMENT '下级用户ID（sys_user.user_id）',
  `parent_user_id` bigint NOT NULL COMMENT '上级用户ID（sys_user.user_id）',
  `relation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'DIRECT' COMMENT '关系类型（字典 oa_relation_type：DIRECT直属/ASSIST协管/TEMPORARY临时）',
  `is_primary` tinyint(1) NULL DEFAULT 1 COMMENT '是否主关系（0否 1是）',
  `start_date` date NULL DEFAULT NULL COMMENT '生效开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '生效结束日期',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`relation_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务员上下级关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_sales_staff_relation
-- ----------------------------

-- ----------------------------
-- Table structure for oa_staff_area_scope
-- ----------------------------
DROP TABLE IF EXISTS `oa_staff_area_scope`;
CREATE TABLE `oa_staff_area_scope`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '推广商公司ID',
  `user_id` bigint NOT NULL COMMENT '业务员用户ID（sys_user.user_id）',
  `area_id` bigint NULL DEFAULT NULL COMMENT '行政区划ID（FK→oa_area）',
  `area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行政区划编码（冗余）',
  `area_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行政区划名称（冗余）',
  `area_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区域层级（PROVINCE/CITY/COUNTY）',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '所属部门ID（若依数据权限过滤用）',
  `scope_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'OWN' COMMENT '范围类型（OWN负责/ASSIST协同/VIEW查看）',
  `category_id` bigint NULL DEFAULT NULL COMMENT '负责疫苗大类（可为空=全部）',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '负责疫苗小类（可为空）',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '负责厂家（可为空）',
  `start_date` date NULL DEFAULT NULL COMMENT '生效开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '生效结束日期',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务员负责区域表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_staff_area_scope
-- ----------------------------

-- ----------------------------
-- Table structure for oa_staff_unit_scope
-- ----------------------------
DROP TABLE IF EXISTS `oa_staff_unit_scope`;
CREATE TABLE `oa_staff_unit_scope`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '推广商公司ID',
  `user_id` bigint NOT NULL COMMENT '业务员用户ID（sys_user.user_id）',
  `unit_id` bigint NOT NULL COMMENT '客户单位ID（FK→oa_customer_unit）',
  `company_unit_id` bigint NULL DEFAULT NULL COMMENT '公司客户单位关系ID（FK→oa_company_customer_unit）',
  `unit_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位名称（冗余便于查询）',
  `unit_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位编码（冗余便于外部匹配）',
  `unit_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位层级',
  `unit_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位类型',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '所属部门ID（若依数据权限过滤用）',
  `scope_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'OWN' COMMENT '范围类型（OWN负责/ASSIST协同/VIEW查看）',
  `staff_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务员身份类型（冗余）',
  `company_vaccine_id` bigint NULL DEFAULT NULL COMMENT '本公司在售疫苗ID（FK→oa_company_vaccine，可为空=全部）',
  `category_id` bigint NULL DEFAULT NULL COMMENT '负责疫苗大类（可为空=全部）',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '负责疫苗小类（可为空）',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '负责厂家（可为空）',
  `is_primary` tinyint(1) NULL DEFAULT 0 COMMENT '是否主负责人（0否 1是）',
  `start_date` date NULL DEFAULT NULL COMMENT '生效开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '生效结束日期',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（迁移兼容）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务员负责客户单位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_staff_unit_scope
-- ----------------------------

-- ----------------------------
-- Table structure for oa_user_visible_scope
-- ----------------------------
DROP TABLE IF EXISTS `oa_user_visible_scope`;
CREATE TABLE `oa_user_visible_scope`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '公司ID',
  `user_id` bigint NOT NULL COMMENT '系统用户ID',
  `unit_id` bigint NOT NULL COMMENT '可见客户单位ID',
  `area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '该unit的行政区划编码（冗余加速查询）',
  `scope_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'OWN' COMMENT '最高权限类型（OWN/ASSIST/VIEW）',
  `source_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '范围来源（AREA_SELF/UNIT_SELF/SUBORDINATE）',
  `source_user_id` bigint NULL DEFAULT NULL COMMENT '来源用户ID（继承下级时记录）',
  `category_id` bigint NULL DEFAULT NULL COMMENT '疫苗大类（NULL=不限）',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '疫苗小类（NULL=不限）',
  `computed_time` datetime NULL DEFAULT NULL COMMENT '最近计算时间',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_unit`(`user_id` ASC, `unit_id` ASC) USING BTREE,
  INDEX `idx_company_user`(`company_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_unit`(`unit_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户可见业务范围汇总表（预计算）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_user_visible_scope
-- ----------------------------

-- ----------------------------
-- Table structure for oa_vaccine_advantage
-- ----------------------------
DROP TABLE IF EXISTS `oa_vaccine_advantage`;
CREATE TABLE `oa_vaccine_advantage`  (
  `advantage_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '疫苗小类ID',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '产品规格SKU_ID（精确到SKU则填）',
  `advantage_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优势标题',
  `advantage_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '优势内容（支持Markdown/富文本）',
  `advantage_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型：ADVANTAGE优势/COMPARE对比/FAQ常见问题/SCRIPT话术',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`advantage_id`) USING BTREE,
  INDEX `idx_adv_subclass`(`subclass_id` ASC) USING BTREE,
  INDEX `idx_adv_sku`(`sku_id` ASC) USING BTREE,
  INDEX `idx_adv_type`(`advantage_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品优势/知识库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_vaccine_advantage
-- ----------------------------

-- ----------------------------
-- Table structure for oa_vaccine_answer
-- ----------------------------
DROP TABLE IF EXISTS `oa_vaccine_answer`;
CREATE TABLE `oa_vaccine_answer`  (
  `answer_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `answer_label` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '选项标签（A/B/C/D/对/错）',
  `answer_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '答案内容',
  `is_correct` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否正确答案（1是 0否）',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`answer_id`) USING BTREE,
  INDEX `idx_ans_question`(`question_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '答案表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_vaccine_answer
-- ----------------------------

-- ----------------------------
-- Table structure for oa_vaccine_category
-- ----------------------------
DROP TABLE IF EXISTS `oa_vaccine_category`;
CREATE TABLE `oa_vaccine_category`  (
  `category_id` bigint NOT NULL AUTO_INCREMENT COMMENT '疫苗大类ID',
  `class_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '大类编码（行业编码如01/02/03）',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '大类名称（乙肝、百白破等）',
  `class_sortname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中文简称',
  `class_en_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '英文名称',
  `inner_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '内部编码',
  `bact_cn_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标准中文名（参考 t_sys_bachinfo）',
  `bact_en_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标准英文名（参考 t_sys_bachinfo）',
  `immunization_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '免疫规划类型（字典 oa_vaccine_immunization_type：EPI/NON_EPI）',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否默认显示（0否 1是）',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序号',
  `source_class_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统大类ID（迁移兼容）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '疫苗大类表（平台级）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_vaccine_category
-- ----------------------------
INSERT INTO `oa_vaccine_category` VALUES (1, '01', '乙型肝炎疫苗', '乙肝', NULL, NULL, NULL, NULL, 'EPI', '0', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_category` VALUES (2, '02', '卡介苗', '卡介', NULL, NULL, NULL, NULL, 'EPI', '0', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_category` VALUES (3, '03', '脊髓灰质炎疫苗', '脊灰', NULL, NULL, NULL, NULL, 'EPI', '0', 3, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_category` VALUES (4, '04', '百白破联合疫苗', '百白破', NULL, NULL, NULL, NULL, 'EPI', '0', 4, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_category` VALUES (5, '05', '流感疫苗', '流感', NULL, NULL, NULL, NULL, 'NON_EPI', '0', 5, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_category` VALUES (6, '06', 'HPV疫苗', 'HPV', NULL, NULL, NULL, NULL, 'NON_EPI', '0', 6, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_category` VALUES (7, '07', '狂犬病疫苗', '狂犬', NULL, NULL, NULL, NULL, 'NON_EPI', '0', 7, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_category` VALUES (8, '08', '水痘疫苗', '水痘', NULL, NULL, NULL, NULL, 'NON_EPI', '0', 8, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_category` VALUES (9, '09', '肺炎疫苗', '肺炎', NULL, NULL, NULL, NULL, 'NON_EPI', '0', 9, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_category` VALUES (10, '10', '甲型肝炎疫苗', '甲肝', NULL, NULL, NULL, NULL, 'EPI', '0', 10, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_vaccine_factory
-- ----------------------------
DROP TABLE IF EXISTS `oa_vaccine_factory`;
CREATE TABLE `oa_vaccine_factory`  (
  `factory_id` bigint NOT NULL AUTO_INCREMENT COMMENT '生产企业ID',
  `factory_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '厂家名称',
  `factory_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '厂家编码',
  `corp_fullname` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '企业全称（参考旧表 corp_fullname）',
  `corp_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '企业简称',
  `corp_nationcode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '国家/单位编码',
  `social_credit_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '统一社会信用代码',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `production_scope` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生产范围',
  `source_system` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '数据来源（PLATFORM/IMPORT/OLD_DB）',
  `source_factory_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统厂家ID（迁移兼容）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`factory_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '生产企业表（平台级）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_vaccine_factory
-- ----------------------------
INSERT INTO `oa_vaccine_factory` VALUES (1, '北京科兴生物制品有限公司', 'KXSW', NULL, '科兴', NULL, '911101052011XXXXA', '张经理', '010-88881111', NULL, NULL, 'PLATFORM', NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_factory` VALUES (2, '重庆智飞生物制品股份有限公司', 'ZFSW', NULL, '智飞', NULL, '915001082011XXXXB', '李经理', '023-66661111', NULL, NULL, 'PLATFORM', NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_factory` VALUES (3, '云南沃森生物技术股份有限公司', 'WSSW', NULL, '沃森', NULL, '915301002011XXXXC', '王经理', '0871-6661111', NULL, NULL, 'PLATFORM', NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_factory` VALUES (4, '深圳康泰生物制品股份有限公司', 'KTSW', NULL, '康泰', NULL, '914403002011XXXXD', '赵经理', '0755-8881111', NULL, NULL, 'PLATFORM', NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_factory` VALUES (5, '辽宁成大生物股份有限公司', 'CDSW', NULL, '成大', NULL, '912101002011XXXXE', '孙经理', '024-88881111', NULL, NULL, 'PLATFORM', NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_factory` VALUES (6, '长春生物制品研究所有限责任公司', 'CCSW', NULL, '长春所', NULL, '912201002011XXXXF', '周经理', '0431-8881111', NULL, NULL, 'PLATFORM', NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_factory` VALUES (7, '默沙东（中国）有限公司', 'MSD', NULL, '默沙东', NULL, '913100002011XXXXG', 'MSD客服', '400-888-1111', NULL, NULL, 'PLATFORM', NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_factory` VALUES (8, '葛兰素史克（中国）投资有限公司', 'GSK', NULL, 'GSK', NULL, '913100002011XXXXH', 'GSK客服', '400-888-2222', NULL, NULL, 'PLATFORM', NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_vaccine_instruction
-- ----------------------------
DROP TABLE IF EXISTS `oa_vaccine_instruction`;
CREATE TABLE `oa_vaccine_instruction`  (
  `instruction_id` bigint NOT NULL AUTO_INCREMENT COMMENT '说明书ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '疫苗大类ID',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '疫苗小类ID',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '生产企业ID',
  `instruction_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '说明书名称',
  `approval_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '批准文号',
  `version_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '版本号',
  `indication` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '适应症/接种对象',
  `dosage` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用法用量',
  `contraindication` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '禁忌',
  `adverse_reaction` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '不良反应',
  `storage_condition` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '贮藏条件',
  `validity_period` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '有效期',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '说明书正文（富文本）',
  `publish_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'DRAFT' COMMENT '发布状态（DRAFT草稿/PUBLISHED已发布/DISABLED停用）',
  `effective_date` date NULL DEFAULT NULL COMMENT '生效日期',
  `expire_date` date NULL DEFAULT NULL COMMENT '失效日期',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`instruction_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '疫苗说明书表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_vaccine_instruction
-- ----------------------------

-- ----------------------------
-- Table structure for oa_vaccine_question
-- ----------------------------
DROP TABLE IF EXISTS `oa_vaccine_question`;
CREATE TABLE `oa_vaccine_question`  (
  `question_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type_id` bigint NOT NULL COMMENT '题目类型ID',
  `question_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '题目内容',
  `question_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'SINGLE' COMMENT '题型：SINGLE单选/MULTI多选/JUDGE判断',
  `difficulty` int NULL DEFAULT 1 COMMENT '难度（1~5）',
  `score` int NULL DEFAULT 1 COMMENT '分值',
  `explanation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '答案解析',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`question_id`) USING BTREE,
  INDEX `idx_q_type`(`type_id` ASC) USING BTREE,
  INDEX `idx_q_difficulty`(`difficulty` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '题目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_vaccine_question
-- ----------------------------

-- ----------------------------
-- Table structure for oa_vaccine_question_type
-- ----------------------------
DROP TABLE IF EXISTS `oa_vaccine_question_type`;
CREATE TABLE `oa_vaccine_question_type`  (
  `type_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `subclass_id` bigint NULL DEFAULT NULL COMMENT '关联疫苗小类ID',
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型名称（如：乙肝基础知识/接种方案/不良反应处理）',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`type_id`) USING BTREE,
  INDEX `idx_qt_subclass`(`subclass_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '题目类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_vaccine_question_type
-- ----------------------------

-- ----------------------------
-- Table structure for oa_vaccine_sku
-- ----------------------------
DROP TABLE IF EXISTS `oa_vaccine_sku`;
CREATE TABLE `oa_vaccine_sku`  (
  `sku_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `sku_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'SKU编码（自动生成）',
  `sku_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'SKU显示名称（自动拼接：小类+厂家+剂型+剂量）',
  `category_id` bigint NOT NULL COMMENT '疫苗大类ID',
  `subclass_id` bigint NOT NULL COMMENT '疫苗小类ID',
  `factory_id` bigint NOT NULL COMMENT '生产企业ID',
  `product_id` bigint NULL DEFAULT NULL COMMENT '关联oa_vaccine_product产品主数据ID（可选）',
  `dosage_form_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剂型编码（关联oa_product_dosage_form）',
  `dosage_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剂量编码（关联oa_product_dosage）',
  `crowd_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品人群编码（关联oa_product_crowd）',
  `specification` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规格描述（如：0.5ml/支）',
  `approval_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '批准文号',
  `product_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'OWN' COMMENT '产品类型：OWN本品/COMPETE竞品/OTHER其他',
  `is_active` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否有效（1有效 0无效）',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`sku_id`) USING BTREE,
  UNIQUE INDEX `uk_sku`(`subclass_id` ASC, `factory_id` ASC, `dosage_form_code` ASC, `dosage_code` ASC, `crowd_code` ASC) USING BTREE,
  INDEX `idx_sku_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_sku_subclass`(`subclass_id` ASC) USING BTREE,
  INDEX `idx_sku_factory`(`factory_id` ASC) USING BTREE,
  INDEX `idx_sku_code`(`sku_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品规格SKU表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_vaccine_sku
-- ----------------------------
INSERT INTO `oa_vaccine_sku` VALUES (1, 'SKU-0101-KX', '乙肝CHO/科兴/注射液/0.5ml/儿童', 1, 1, 1, NULL, '03', '02', '03', '0.5ml/支', 'S20200001', 'OWN', '1', 1, '0', '0', 'admin', '2026-05-09 11:16:28', 'admin', '2026-05-09 11:19:13', NULL);
INSERT INTO `oa_vaccine_sku` VALUES (2, 'SKU-0101-KT', '乙肝CHO/康泰/注射液/0.5ml/儿童', 1, 1, 4, NULL, '06', '02', '02', '0.5ml/支', 'S20200008', 'OWN', '1', 2, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_vaccine_sku` VALUES (3, 'SKU-0102-KT', '乙肝酵母/康泰/注射液/1.0ml/成人', 1, 2, 4, NULL, '06', '03', '01', '1.0ml/支', 'S20200007', 'OWN', '1', 3, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_vaccine_sku` VALUES (4, 'SKU-0301-CC', '脊灰IPV/长春所/注射液/0.5ml/儿童', 3, 5, 6, NULL, '06', '02', '02', '0.5ml/支', 'S20200011', 'OWN', '1', 4, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_vaccine_sku` VALUES (5, 'SKU-0401-CC', '百白破/长春所/注射液/0.5ml/儿童', 4, 7, 6, NULL, '06', '02', '02', '0.5ml/支', 'S20200010', 'OWN', '1', 5, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_vaccine_sku` VALUES (6, 'SKU-0601-GSK', '2价HPV/GSK/注射液/0.5ml/女性', 6, 11, 8, NULL, '06', '02', '04', '0.5ml/支', 'S20200014', 'OWN', '1', 6, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_vaccine_sku` VALUES (7, 'SKU-0602-MSD', '9价HPV/默沙东/注射液/0.5ml/女性', 6, 12, 7, NULL, '06', '02', '04', '0.5ml/支', 'S20200012', 'OWN', '1', 7, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_vaccine_sku` VALUES (8, 'SKU-0701-CD', '狂犬Vero/成大/冻干/1.0ml/通用', 7, 13, 5, NULL, '03', '03', '05', '1.0ml/瓶', 'S20200009', 'OWN', '1', 8, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_vaccine_sku` VALUES (9, 'SKU-0901-WS', '13价肺炎/沃森/注射液/0.5ml/儿童', 9, 17, 3, NULL, '06', '02', '02', '0.5ml/支', 'S20200005', 'OWN', '1', 9, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_vaccine_sku` VALUES (10, 'SKU-0902-ZF', '23价肺炎/智飞/注射液/0.5ml/成人', 9, 18, 2, NULL, '06', '02', '01', '0.5ml/支', 'S20200004', 'OWN', '1', 10, '0', '0', 'admin', '2026-05-09 11:16:28', '', NULL, NULL);
INSERT INTO `oa_vaccine_sku` VALUES (11, 'SKU1778297325308', NULL, 2, 4, 7, NULL, '03', '01', '02', '0.5/只', 'ak47', 'OWN', '1', 0, '0', '0', 'admin', '2026-05-09 11:28:45', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_vaccine_subclass
-- ----------------------------
DROP TABLE IF EXISTS `oa_vaccine_subclass`;
CREATE TABLE `oa_vaccine_subclass`  (
  `subclass_id` bigint NOT NULL AUTO_INCREMENT COMMENT '疫苗小类ID',
  `category_id` bigint NOT NULL COMMENT '所属疫苗大类ID',
  `subclass_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '小类编码（如0201/0202）',
  `subclass_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '小类名称（乙肝CHO、乙肝酿酒酵母等）',
  `subclass_sortname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '小类简称',
  `subclass_en_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '小类英文名',
  `bio_sort_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接种途径（参考旧 t_bio_bacterin.bio_sort_id）',
  `bio_spec_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规格（参考旧表）',
  `bio_activity_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '疫苗活性',
  `bio_technology_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '疫苗工艺',
  `bio_techexplain_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工艺说明',
  `immunization_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '免疫规划类型（字典 oa_vaccine_immunization_type）',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序号',
  `source_subclass_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统小类ID（迁移兼容）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`subclass_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '疫苗小类表（平台级）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_vaccine_subclass
-- ----------------------------
INSERT INTO `oa_vaccine_subclass` VALUES (1, 1, '0101', '重组乙型肝炎疫苗（CHO细胞）', '乙肝CHO', NULL, NULL, NULL, NULL, NULL, NULL, 'EPI', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (2, 1, '0102', '重组乙型肝炎疫苗（酿酒酵母）', '乙肝酵母', NULL, NULL, NULL, NULL, NULL, NULL, 'EPI', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (3, 2, '0201', '皮内注射用卡介苗', '卡介苗', NULL, NULL, NULL, NULL, NULL, NULL, 'EPI', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (4, 2, '0202', '卡介苗（冻干）', '卡介冻干', NULL, NULL, NULL, NULL, NULL, NULL, 'EPI', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (5, 3, '0301', '脊髓灰质炎灭活疫苗（IPV）', '脊灰IPV', NULL, NULL, NULL, NULL, NULL, NULL, 'EPI', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (6, 3, '0302', '口服脊髓灰质炎减毒活疫苗（bOPV）', '脊灰bOPV', NULL, NULL, NULL, NULL, NULL, NULL, 'EPI', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (7, 4, '0401', '吸附无细胞百白破联合疫苗', '百白破无细胞', NULL, NULL, NULL, NULL, NULL, NULL, 'EPI', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (8, 4, '0402', '吸附百白破联合疫苗', '百白破全细胞', NULL, NULL, NULL, NULL, NULL, NULL, 'EPI', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (9, 5, '0501', '四价流感病毒裂解疫苗', '四价流感', NULL, NULL, NULL, NULL, NULL, NULL, 'NON_EPI', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (10, 5, '0502', '三价流感病毒裂解疫苗', '三价流感', NULL, NULL, NULL, NULL, NULL, NULL, 'NON_EPI', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (11, 6, '0601', '双价人乳头瘤病毒疫苗（2价HPV）', '2价HPV', NULL, NULL, NULL, NULL, NULL, NULL, 'NON_EPI', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (12, 6, '0602', '九价人乳头瘤病毒疫苗（9价HPV）', '9价HPV', NULL, NULL, NULL, NULL, NULL, NULL, 'NON_EPI', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (13, 7, '0701', '冻干人用狂犬病疫苗（Vero细胞）', '狂犬Vero', NULL, NULL, NULL, NULL, NULL, NULL, 'NON_EPI', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (14, 7, '0702', '人用狂犬病疫苗（人二倍体细胞）', '狂犬二倍体', NULL, NULL, NULL, NULL, NULL, NULL, 'NON_EPI', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (15, 8, '0801', '水痘减毒活疫苗', '水痘减毒', NULL, NULL, NULL, NULL, NULL, NULL, 'NON_EPI', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (16, 8, '0802', '水痘减毒活疫苗（冻干）', '水痘冻干', NULL, NULL, NULL, NULL, NULL, NULL, 'NON_EPI', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (17, 9, '0901', '13价肺炎球菌多糖结合疫苗', '13价肺炎', NULL, NULL, NULL, NULL, NULL, NULL, 'NON_EPI', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (18, 9, '0902', '23价肺炎球菌多糖疫苗', '23价肺炎', NULL, NULL, NULL, NULL, NULL, NULL, 'NON_EPI', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (19, 10, '1001', '甲型肝炎灭活疫苗', '甲肝灭活', NULL, NULL, NULL, NULL, NULL, NULL, 'EPI', 1, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);
INSERT INTO `oa_vaccine_subclass` VALUES (20, 10, '1002', '甲型肝炎减毒活疫苗', '甲肝减毒', NULL, NULL, NULL, NULL, NULL, NULL, 'EPI', 2, NULL, '0', '0', 'admin', '2026-05-09 10:41:49', '', NULL, NULL);

-- ----------------------------
-- Table structure for oa_visit_record
-- ----------------------------
DROP TABLE IF EXISTS `oa_visit_record`;
CREATE TABLE `oa_visit_record`  (
  `visit_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_id` bigint NOT NULL COMMENT '公司ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_id` bigint NOT NULL COMMENT '拜访人ID',
  `task_id` bigint NULL DEFAULT NULL COMMENT '关联合规任务ID',
  `unit_id` bigint NULL DEFAULT NULL COMMENT '客户单位ID（oa_customer_unit）',
  `company_unit_id` bigint NULL DEFAULT NULL COMMENT '公司客户单位ID（oa_company_customer_unit）',
  `visit_date` date NOT NULL COMMENT '拜访日期',
  `visit_location` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拜访地点（文字描述）',
  `visit_lng` decimal(12, 8) NULL DEFAULT NULL COMMENT '签到经度',
  `visit_lat` decimal(12, 8) NULL DEFAULT NULL COMMENT '签到纬度',
  `check_in_time` datetime NULL DEFAULT NULL COMMENT '签到时间',
  `check_out_time` datetime NULL DEFAULT NULL COMMENT '签退时间',
  `visit_purpose` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拜访目的',
  `visit_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拜访内容/沟通记录',
  `visit_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拜访结果',
  `visit_imgs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拜访照片（JSON数组：[\"/path/1.jpg\",\"/path/2.jpg\"]）',
  `assess_imgs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '考核照片（JSON数组）',
  `visit_prod` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拜访产品（多产品逗号分隔）',
  `user_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份标识：1业务员 2地区经理',
  `audit_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'DRAFT' COMMENT '审核状态：DRAFT草稿/SUBMITTED已提交/APPROVED通过/REJECTED不通过',
  `audit_by` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核备注',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
  PRIMARY KEY (`visit_id`) USING BTREE,
  UNIQUE INDEX `uk_visit`(`visit_date` ASC, `user_id` ASC, `unit_id` ASC) USING BTREE,
  INDEX `idx_visit_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_visit_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_visit_unit`(`unit_id` ASC) USING BTREE,
  INDEX `idx_visit_date`(`visit_date` ASC) USING BTREE,
  INDEX `idx_visit_task`(`task_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '拜访记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oa_visit_record
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-05-07 10:37:49', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-05-07 10:37:49', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-05-07 10:37:49', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-05-07 10:37:49', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-05-07 10:37:49', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-05-07 10:37:49', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-05-07 10:37:49', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-05-07 10:37:49', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `company_id` bigint NULL DEFAULT 0 COMMENT '所属推广商公司ID（0=平台）',
  `dept_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门类型（COMPANY/SALES_DEPT/MARKET_DEPT/SALES_AREA/TEAM）',
  `dept_level` int NULL DEFAULT NULL COMMENT '公司内部层级深度',
  `province_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责省编码',
  `city_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责市编码',
  `county_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责县编码',
  `biz_area_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务区域名称',
  `source_dept_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统部门ID（数据迁移用）',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 202 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (200, 100, '0,100', '贵州省疫苗公司1', 0, '1', NULL, NULL, '0', '0', 'admin', '2026-05-10 15:40:39', 'admin', '2026-05-10 15:41:22', 200, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (201, 100, '0,100', '贵州省疫苗公司2', 0, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-10 15:41:10', 'admin', '2026-05-10 15:41:27', 201, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2035 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 1, '老板', 'BOSS', 'oa_staff_type', '', 'primary', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商老板');
INSERT INTO `sys_dict_data` VALUES (101, 2, '总监', 'DIRECTOR', 'oa_staff_type', '', 'success', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商总监');
INSERT INTO `sys_dict_data` VALUES (102, 3, '区域经理', 'REGION_MANAGER', 'oa_staff_type', '', 'info', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商区域经理');
INSERT INTO `sys_dict_data` VALUES (103, 4, '医药代表', 'MED_REP', 'oa_staff_type', '', 'warning', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商医药代表');
INSERT INTO `sys_dict_data` VALUES (104, 5, '信息工作员', 'MARKET_INFO', 'oa_staff_type', '', '', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商信息工作员/市场部');
INSERT INTO `sys_dict_data` VALUES (114, 1, 'A类', 'A', 'oa_customer_grade', '', 'danger', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '重点客户');
INSERT INTO `sys_dict_data` VALUES (115, 2, 'B类', 'B', 'oa_customer_grade', '', 'warning', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '一般客户');
INSERT INTO `sys_dict_data` VALUES (116, 3, 'C类', 'C', 'oa_customer_grade', '', 'info', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '潜力客户');
INSERT INTO `sys_dict_data` VALUES (117, 1, '决策者', 'DECISION', 'oa_customer_role_category', '', 'danger', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '决策者/拍板人');
INSERT INTO `sys_dict_data` VALUES (118, 2, '影响者', 'INFLUENCE', 'oa_customer_role_category', '', 'warning', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '影响决策的人');
INSERT INTO `sys_dict_data` VALUES (119, 3, '执行者', 'EXECUTOR', 'oa_customer_role_category', '', 'success', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '具体执行接种的人');
INSERT INTO `sys_dict_data` VALUES (120, 4, '财务', 'FINANCE', 'oa_customer_role_category', '', 'primary', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '财务/回款相关');
INSERT INTO `sys_dict_data` VALUES (121, 5, '库管', 'WAREHOUSE', 'oa_customer_role_category', '', 'info', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '库存管理员');
INSERT INTO `sys_dict_data` VALUES (124, 1, '负责', 'OWNER', 'oa_scope_type', '', 'primary', 'Y', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '主要负责人');
INSERT INTO `sys_dict_data` VALUES (125, 2, '协同', 'ASSIST', 'oa_scope_type', '', 'success', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '协同支持');
INSERT INTO `sys_dict_data` VALUES (126, 3, '查看', 'VIEWER', 'oa_scope_type', '', 'info', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '仅可查看');
INSERT INTO `sys_dict_data` VALUES (127, 1, '在售', 'ON_SALE', 'oa_company_vaccine_status', '', 'success', 'Y', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '正在销售');
INSERT INTO `sys_dict_data` VALUES (128, 2, '暂停', 'PAUSED', 'oa_company_vaccine_status', '', 'warning', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '暂停销售');
INSERT INTO `sys_dict_data` VALUES (129, 3, '停止代理', 'STOPPED', 'oa_company_vaccine_status', '', 'danger', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '停止代理');
INSERT INTO `sys_dict_data` VALUES (130, 1, '直属', 'DIRECT', 'oa_relation_type', '', 'primary', 'Y', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '直属上下级');
INSERT INTO `sys_dict_data` VALUES (131, 2, '协管', 'ASSIST', 'oa_relation_type', '', 'success', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '协管关系');
INSERT INTO `sys_dict_data` VALUES (132, 3, '临时', 'TEMPORARY', 'oa_relation_type', '', 'info', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '临时调配');
INSERT INTO `sys_dict_data` VALUES (133, 1, '在职', 'ACTIVE', 'oa_job_status', '', 'success', 'Y', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '在职');
INSERT INTO `sys_dict_data` VALUES (134, 2, '离职', 'LEFT', 'oa_job_status', '', 'danger', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '离职');
INSERT INTO `sys_dict_data` VALUES (135, 3, '停用', 'DISABLED', 'oa_job_status', '', 'warning', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '账号停用');
INSERT INTO `sys_dict_data` VALUES (136, 1, '推广商', 'PROMOTER', 'oa_company_type', '', 'primary', 'Y', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '疫苗推广商');
INSERT INTO `sys_dict_data` VALUES (137, 2, '代理商', 'AGENT', 'oa_company_type', '', 'success', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '疫苗代理商');
INSERT INTO `sys_dict_data` VALUES (138, 3, '经销商', 'DISTRIBUTOR', 'oa_company_type', '', 'info', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '疫苗经销商');
INSERT INTO `sys_dict_data` VALUES (139, 1, '正常', 'ACTIVE', 'oa_license_status', '', 'success', 'Y', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '授权正常');
INSERT INTO `sys_dict_data` VALUES (140, 2, '停用', 'STOPPED', 'oa_license_status', '', 'danger', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '授权停用');
INSERT INTO `sys_dict_data` VALUES (141, 3, '到期', 'EXPIRED', 'oa_license_status', '', 'warning', 'N', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '授权到期');
INSERT INTO `sys_dict_data` VALUES (142, 1, '预充', '01', 'oa_dosage_form', '', 'primary', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '预充式注射器');
INSERT INTO `sys_dict_data` VALUES (143, 2, '西林瓶', '02', 'oa_dosage_form', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '西林瓶装');
INSERT INTO `sys_dict_data` VALUES (144, 3, '冻干', '03', 'oa_dosage_form', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '冻干剂');
INSERT INTO `sys_dict_data` VALUES (145, 4, '口服液', '04', 'oa_dosage_form', '', 'warning', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '口服液');
INSERT INTO `sys_dict_data` VALUES (146, 5, '糖丸', '05', 'oa_dosage_form', '', '', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '糖丸');
INSERT INTO `sys_dict_data` VALUES (147, 1, '0.25ml', '01', 'oa_dosage', '', 'primary', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (148, 2, '0.5ml', '02', 'oa_dosage', '', 'success', 'Y', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '最常见剂量');
INSERT INTO `sys_dict_data` VALUES (149, 3, '1.0ml', '03', 'oa_dosage', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (150, 4, '1.5ml', '04', 'oa_dosage', '', '', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (151, 5, '2.0ml', '05', 'oa_dosage', '', '', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (152, 1, '成人', '01', 'oa_crowd', '', 'primary', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '成人适用');
INSERT INTO `sys_dict_data` VALUES (153, 2, '儿童', '02', 'oa_crowd', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '儿童适用');
INSERT INTO `sys_dict_data` VALUES (154, 3, '全年龄', '03', 'oa_crowd', '', 'info', 'Y', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '全年龄适用');
INSERT INTO `sys_dict_data` VALUES (155, 1, '本品', 'OWN', 'oa_product_type', '', 'primary', 'Y', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '我司代理产品');
INSERT INTO `sys_dict_data` VALUES (156, 2, '竞品', 'COMPETE', 'oa_product_type', '', 'danger', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '竞争对手产品');
INSERT INTO `sys_dict_data` VALUES (157, 3, '其他', 'OTHER', 'oa_product_type', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '其他产品');
INSERT INTO `sys_dict_data` VALUES (158, 1, '首针', 'FIRST_NEEDLE', 'oa_assess_type', '', 'danger', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '按首针数考核');
INSERT INTO `sys_dict_data` VALUES (159, 2, '分销', 'DISTRIBUTE', 'oa_assess_type', '', 'warning', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '按分销量考核');
INSERT INTO `sys_dict_data` VALUES (160, 3, '纯销', 'PURE_SALE', 'oa_assess_type', '', 'success', 'Y', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '按纯销量考核');
INSERT INTO `sys_dict_data` VALUES (161, 4, '凭证', 'CERT', 'oa_assess_type', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '按凭证考核');
INSERT INTO `sys_dict_data` VALUES (162, 1, '默认多层价', '1', 'oa_settle_flag', '', 'primary', 'Y', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '按五层价格体系结算');
INSERT INTO `sys_dict_data` VALUES (163, 2, '固定价', '2', 'oa_settle_flag', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '按固定价结算');
INSERT INTO `sys_dict_data` VALUES (164, 1, '疫苗', 'VACCINE', 'oa_mapping_type', '', 'primary', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (165, 2, '厂家', 'FACTORY', 'oa_mapping_type', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (166, 3, '机构', 'ORG', 'oa_mapping_type', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (167, 1, '点单', 'ORDER', 'oa_source_scene', '', 'primary', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (168, 2, '实销', 'REAL_SALE', 'oa_source_scene', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (169, 3, '库存', 'INVENTORY', 'oa_source_scene', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (170, 1, '已匹配', 'MATCHED', 'oa_match_status', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (171, 2, '未匹配', 'UNMATCHED', 'oa_match_status', '', 'danger', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (172, 3, '忽略', 'IGNORED', 'oa_match_status', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (173, 1, '初始', 'INIT', 'oa_import_status', '', '', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (174, 2, '处理中', 'PROCESSING', 'oa_import_status', '', 'warning', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (175, 3, '成功', 'SUCCESS', 'oa_import_status', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (176, 4, '部分成功', 'PARTIAL', 'oa_import_status', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (177, 5, '失败', 'FAILED', 'oa_import_status', '', 'danger', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (178, 1, '待执行', 'PENDING', 'oa_task_status', '', '', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (179, 2, '进行中', 'IN_PROGRESS', 'oa_task_status', '', 'primary', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (180, 3, '待审核', 'REVIEW', 'oa_task_status', '', 'warning', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (181, 4, '已完成', 'COMPLETED', 'oa_task_status', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (182, 5, '已逾期', 'OVERDUE', 'oa_task_status', '', 'danger', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (183, 1, '草稿', 'DRAFT', 'oa_audit_status', '', '', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (184, 2, '已提交', 'SUBMITTED', 'oa_audit_status', '', 'primary', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (185, 3, '通过', 'APPROVED', 'oa_audit_status', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (186, 4, '不通过', 'REJECTED', 'oa_audit_status', '', 'danger', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (187, 1, '月度', 'MONTHLY', 'oa_frequency', '', 'primary', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (188, 2, '季度', 'QUARTERLY', 'oa_frequency', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (189, 3, '年度', 'YEARLY', 'oa_frequency', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (190, 4, '每次', 'PER_VISIT', 'oa_frequency', '', 'warning', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (191, 1, '线下', 'OFFLINE', 'oa_meeting_modality', '', 'primary', 'Y', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (192, 2, '线上', 'ONLINE', 'oa_meeting_modality', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (193, 3, '混合', 'HYBRID', 'oa_meeting_modality', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (194, 1, '单选', 'SINGLE', 'oa_question_type', '', 'primary', 'Y', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (195, 2, '多选', 'MULTI', 'oa_question_type', '', 'success', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (196, 3, '判断', 'JUDGE', 'oa_question_type', '', 'info', 'N', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (2001, 1, '免疫规划', 'EPI', 'oa_vaccine_immunization_type', '', 'success', 'N', '0', 'admin', '2026-05-09 10:45:59', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (2002, 2, '非免疫规划', 'NON_EPI', 'oa_vaccine_immunization_type', '', 'warning', 'N', '0', 'admin', '2026-05-09 10:45:59', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (2011, 1, '省级', 'province', 'oa_area_level', '', 'primary', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2012, 2, '市级', 'city', 'oa_area_level', '', 'success', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2013, 3, '县/区级', 'county', 'oa_area_level', '', 'info', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2014, 4, '乡/镇级', 'town', 'oa_area_level', '', 'warning', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2015, 5, '村级', 'village', 'oa_area_level', '', '', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2021, 1, '疾控中心', 'CDC', 'oa_unit_type', '', 'primary', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2022, 2, '预防接种门诊', 'POV', 'oa_unit_type', '', 'success', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2023, 3, '医院', 'HOSPITAL', 'oa_unit_type', '', 'info', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2024, 4, '其他', 'OTHER', 'oa_unit_type', '', '', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2031, 1, '省级', 'province', 'oa_unit_level', '', 'primary', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2032, 2, '市级', 'city', 'oa_unit_level', '', 'success', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2033, 3, '县级', 'county', 'oa_unit_level', '', 'info', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (2034, 4, '乡级', 'town', 'oa_unit_level', '', 'warning', 'N', '0', 'admin', '2026-05-09 11:50:57', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 204 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '业务身份', 'oa_staff_type', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '老板/总监/区域经理/医药代表/信息工作员');
INSERT INTO `sys_dict_type` VALUES (101, '客户单位层级', 'oa_unit_level', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '省/市/县/POV');
INSERT INTO `sys_dict_type` VALUES (102, '客户单位类型', 'oa_unit_type', '0', 'admin', '2026-05-07 16:37:06', '', NULL, 'CDC/POV/医院/预防医学会/其他');
INSERT INTO `sys_dict_type` VALUES (103, '客户ABC类别', 'oa_customer_grade', '0', 'admin', '2026-05-07 16:37:06', '', NULL, 'A/B/C客户分级');
INSERT INTO `sys_dict_type` VALUES (104, '客户角色分类', 'oa_customer_role_category', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '决策/影响/执行/财务/库管');
INSERT INTO `sys_dict_type` VALUES (105, '免疫规划类型', 'oa_vaccine_immunization_type', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '免规/非免规');
INSERT INTO `sys_dict_type` VALUES (106, '负责范围类型', 'oa_scope_type', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '负责/协同/查看');
INSERT INTO `sys_dict_type` VALUES (107, '在售疫苗状态', 'oa_company_vaccine_status', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '在售/暂停/停止代理');
INSERT INTO `sys_dict_type` VALUES (108, '上下级关系类型', 'oa_relation_type', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '直属/协管/临时');
INSERT INTO `sys_dict_type` VALUES (109, '在职状态', 'oa_job_status', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '在职/离职/停用');
INSERT INTO `sys_dict_type` VALUES (110, '推广商类型', 'oa_company_type', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商/代理商/经销商');
INSERT INTO `sys_dict_type` VALUES (111, '授权状态', 'oa_license_status', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '正常/停用/到期');
INSERT INTO `sys_dict_type` VALUES (112, '剂型', 'oa_dosage_form', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '预充/西林瓶/冻干/口服液');
INSERT INTO `sys_dict_type` VALUES (113, '剂量', 'oa_dosage', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '0.5ml/1.0ml/0.25ml');
INSERT INTO `sys_dict_type` VALUES (114, '产品人群', 'oa_crowd', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '成人/儿童/全年龄');
INSERT INTO `sys_dict_type` VALUES (115, '产品类型', 'oa_product_type', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '本品/竞品/其他');
INSERT INTO `sys_dict_type` VALUES (116, '考核方式', 'oa_assess_type', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '首针/分销/纯销/凭证');
INSERT INTO `sys_dict_type` VALUES (117, '结算方式', 'oa_settle_flag', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '默认多层价/固定价');
INSERT INTO `sys_dict_type` VALUES (118, '映射类型', 'oa_mapping_type', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '疫苗/厂家/机构');
INSERT INTO `sys_dict_type` VALUES (119, '数据场景', 'oa_source_scene', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '点单/实销/库存');
INSERT INTO `sys_dict_type` VALUES (120, '匹配状态', 'oa_match_status', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '已匹配/未匹配/忽略');
INSERT INTO `sys_dict_type` VALUES (121, '导入状态', 'oa_import_status', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '初始/处理中/成功/部分成功/失败');
INSERT INTO `sys_dict_type` VALUES (122, '合规任务状态', 'oa_task_status', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '待执行/进行中/待审核/已完成/已逾期');
INSERT INTO `sys_dict_type` VALUES (123, '审核状态', 'oa_audit_status', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '草稿/已提交/通过/不通过');
INSERT INTO `sys_dict_type` VALUES (124, '频率', 'oa_frequency', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '月度/季度/年度/每次');
INSERT INTO `sys_dict_type` VALUES (125, '会议形式', 'oa_meeting_modality', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '线上/线下/混合');
INSERT INTO `sys_dict_type` VALUES (126, '题目类型', 'oa_question_type', '0', 'admin', '2026-05-08 16:06:43', '', NULL, '单选/多选/判断');
INSERT INTO `sys_dict_type` VALUES (201, '行政区划层级', 'oa_area_level', '0', 'admin', '2026-05-09 11:16:28', '', NULL, '省/市/县/乡/村');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-05-07 10:37:49', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 146 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'test1', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '1', '用户不存在/密码错误', '2026-05-07 10:41:06');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '1', '用户不存在/密码错误', '2026-05-07 10:41:11');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-07 10:41:18');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-07 17:00:21');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-08 09:09:04');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-08 09:43:44');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-08 10:28:37');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-08 16:07:39');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-08 16:51:31');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '1', '验证码错误', '2026-05-09 09:06:56');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-09 09:06:59');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-09 10:10:35');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-09 13:51:18');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-09 14:48:01');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '退出成功', '2026-05-09 14:56:32');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-09 14:56:36');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-10 09:17:59');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-10 10:08:41');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-10 15:18:40');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-05-10 15:50:41');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '退出成功', '2026-05-10 15:50:48');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-10 15:51:11');
INSERT INTO `sys_logininfor` VALUES (122, 'test_boss1', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-05-10 15:51:31');
INSERT INTO `sys_logininfor` VALUES (123, 'test_boss1', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '退出成功', '2026-05-10 16:16:33');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-05-10 16:16:38');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '退出成功', '2026-05-10 16:16:43');
INSERT INTO `sys_logininfor` VALUES (126, 'test_boss1', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-05-10 16:16:48');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '1', '验证码错误', '2026-05-10 16:16:59');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-10 16:17:02');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-11 09:23:48');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '退出成功', '2026-05-11 09:37:03');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-11 09:37:05');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码错误', '2026-05-11 10:55:45');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-05-11 10:55:48');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '退出成功', '2026-05-11 10:55:59');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-11 10:56:06');
INSERT INTO `sys_logininfor` VALUES (136, 'test_boss1', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-05-11 10:56:34');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-11 14:52:36');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-05-11 14:58:24');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '退出成功', '2026-05-11 14:58:31');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-05-11 15:04:54');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '退出成功', '2026-05-11 15:05:20');
INSERT INTO `sys_logininfor` VALUES (142, 'test_boss1', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-05-11 15:05:27');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-16 09:16:21');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Edge 148', 'Windows >=10', '0', '登录成功', '2026-05-16 09:57:11');
INSERT INTO `sys_logininfor` VALUES (145, 'test_boss1', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-05-16 09:58:47');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3134 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-05-07 10:37:49', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-05-07 10:37:49', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2026-05-07 10:37:49', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '1', '0', '', 'guide', 'admin', '2026-05-07 10:37:49', 'admin', '2026-05-08 09:50:22', '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-05-07 10:37:49', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-05-07 10:37:49', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-05-07 10:37:49', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-05-07 10:37:49', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-05-07 10:37:49', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-05-07 10:37:49', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-05-07 10:37:49', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-05-07 10:37:49', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-05-07 10:37:49', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-05-07 10:37:49', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-05-07 10:37:49', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-05-07 10:37:49', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-05-07 10:37:49', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-05-07 10:37:49', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-05-07 10:37:49', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-05-07 10:37:49', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-05-07 10:37:49', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-05-07 10:37:49', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-05-07 10:37:49', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-05-07 10:37:49', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1900, '系统数据维护', 0, 4, 'sysdata', NULL, '', '', 1, 0, 'M', '0', '0', '', 'server', 'admin', '2026-05-08 16:51:24', '', NULL, '系统数据维护目录（平台admin维护的标准数据）');
INSERT INTO `sys_menu` VALUES (2000, '公司业务配置', 0, 5, 'basedata', NULL, '', '', 1, 0, 'M', '0', '0', '', 'documentation', 'admin', '2026-05-07 16:37:06', '', NULL, '公司业务配置目录（推广商自有业务数据）');
INSERT INTO `sys_menu` VALUES (2001, '疫苗大类', 1900, 1, 'vaccineCategory', 'oa/vaccine/category/index', '', 'VaccineCategory', 1, 0, 'C', '0', '0', 'oa:vaccine:category:list', 'skill', 'admin', '2026-05-07 16:37:06', '', NULL, '疫苗大类管理菜单');
INSERT INTO `sys_menu` VALUES (2002, '疫苗小类', 1900, 2, 'vaccineSubclass', 'oa/vaccine/subclass/index', '', 'VaccineSubclass', 1, 0, 'C', '0', '0', 'oa:vaccine:subclass:list', 'component', 'admin', '2026-05-07 16:37:06', '', NULL, '疫苗小类管理菜单');
INSERT INTO `sys_menu` VALUES (2003, '生产企业', 1900, 3, 'vaccineFactory', 'oa/vaccine/factory/index', '', 'VaccineFactory', 1, 0, 'C', '0', '0', 'oa:vaccine:factory:list', 'international', 'admin', '2026-05-07 16:37:06', '', NULL, '生产企业管理菜单');
INSERT INTO `sys_menu` VALUES (2004, '在售疫苗', 2000, 2, 'companyVaccine', 'oa/company/vaccine/index', '', 'CompanyVaccine', 1, 0, 'C', '0', '0', 'oa:company:vaccine:list', 'shopping', 'admin', '2026-05-07 16:37:06', '', NULL, '本公司在售疫苗菜单');
INSERT INTO `sys_menu` VALUES (2005, '行政区划', 1900, 4, 'area', 'oa/base/area/index', '', 'Area', 1, 0, 'C', '0', '0', 'oa:base:area:list', 'tree', 'admin', '2026-05-07 16:37:06', '', NULL, '行政区划管理菜单');
INSERT INTO `sys_menu` VALUES (2006, '指南与手册', 2300, 2, 'guide', 'oa/base/guide/index', '', 'Guide', 1, 0, 'C', '0', '0', 'oa:base:guide:list', 'education', 'admin', '2026-05-07 16:37:06', '', NULL, '指南与手册管理菜单');
INSERT INTO `sys_menu` VALUES (2007, '推广商', 1, 11, 'company', 'oa/company/index', '', 'Company', 1, 0, 'C', '0', '0', 'oa:company:list', 'star', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商管理菜单（平台admin专用）');
INSERT INTO `sys_menu` VALUES (2008, '产品规格', 1900, 5, 'vaccineSku', 'oa/vaccine/sku/index', '', 'VaccineSku', 1, 0, 'C', '0', '0', 'oa:vaccine:sku:list', 'build', 'admin', '2026-05-08 16:06:43', '', NULL, '产品规格SKU管理（含剂型/剂量/人群字典Tab）');
INSERT INTO `sys_menu` VALUES (2009, '产品价格', 1900, 6, 'vaccinePrice', 'oa/vaccine/price/index', '', 'VaccinePrice', 1, 0, 'C', '1', '1', 'oa:vaccine:price:list', 'money', 'admin', '2026-05-08 16:06:43', '', NULL, '已废弃：产品价格由公司管理员在公司业务配置中维护，见菜单2012');
INSERT INTO `sys_menu` VALUES (2010, '产品考核规则', 2000, 4, 'assessRule', 'oa/company/assessRule/index', '', 'VaccineAssessment', 1, 0, 'C', '0', '0', 'oa:company:assess:list', 'validCode', 'admin', '2026-05-08 16:06:43', '', NULL, '产品考核规则菜单');
INSERT INTO `sys_menu` VALUES (2011, '数据映射', 2000, 6, 'dataMapping', 'oa/vaccine/mapping/index', '', 'DataMapping', 1, 0, 'C', '0', '0', 'oa:vaccine:mapping:list', 'cascader', 'admin', '2026-05-08 16:06:43', '', NULL, '外部数据映射管理（含数据源/映射/导入记录Tab）');
INSERT INTO `sys_menu` VALUES (2012, '产品定价', 2000, 3, 'companyPrice', 'oa/company/price/index', '', 'CompanyPrice', 1, 0, 'C', '0', '0', 'oa:company:price:list', 'money', 'admin', '2026-05-09 10:10:27', '', NULL, '公司产品定价（按company_id隔离，公司管理员维护）');
INSERT INTO `sys_menu` VALUES (2013, '经营客户单位', 2000, 1, 'companyCustomer', 'oa/company/customer/index', '', 'CompanyCustomer', 1, 0, 'C', '0', '0', 'oa:company:customer:list', 'peoples', 'admin', '2026-05-09 10:10:27', '', NULL, '公司客户关联（从标准库启用客户单位到本公司）');
INSERT INTO `sys_menu` VALUES (2014, '业务员配置', 2000, 5, 'staffConfig', 'oa/company/staff/index', '', 'StaffConfig', 1, 0, 'C', '0', '0', 'oa:company:staff:list', 'peoples', 'admin', '2026-05-10 12:03:26', '', NULL, '业务员档案+上下级+负责范围配置');
INSERT INTO `sys_menu` VALUES (2015, '经营区域', 2000, 0, 'companyArea', 'oa/company/area/index', '', 'CompanyArea', 1, 0, 'C', '0', '0', 'oa:company:area:list', 'international', 'admin', '2026-05-10 15:15:42', '', NULL, '公司经营区域管理（省/市/县）');
INSERT INTO `sys_menu` VALUES (2100, '客户管理', 0, 6, 'customer', NULL, '', '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', '2026-05-07 16:37:06', '', NULL, '客户管理目录');
INSERT INTO `sys_menu` VALUES (2101, '客户单位', 1900, 6, 'customerUnit', 'oa/customer/unit/index', '', 'CustomerUnit', 1, 0, 'C', '0', '0', 'oa:customer:unit:list', 'tree', 'admin', '2026-05-07 16:37:06', '', NULL, '客户单位标准库（平台admin维护CDC/POV主档，无公司维度）');
INSERT INTO `sys_menu` VALUES (2102, '客户信息', 2100, 1, 'customerContact', 'oa/customer/contact/index', '', 'CustomerContact', 1, 0, 'C', '0', '0', 'oa:customer:contact:list', 'user', 'admin', '2026-05-07 16:37:06', '', NULL, '客户信息管理菜单（联系人/干系人）');
INSERT INTO `sys_menu` VALUES (2103, '客户类别', 2100, 2, 'customerGrade', 'oa/customer/grade/index', '', 'CustomerGrade', 1, 0, 'C', '0', '0', 'oa:customer:grade:list', 'chart', 'admin', '2026-05-07 16:37:06', '', NULL, '客户类别管理菜单（ABC分类）');
INSERT INTO `sys_menu` VALUES (2200, '合规材料管理', 0, 7, 'compliance', NULL, '', '', 1, 0, 'M', '0', '0', '', 'clipboard', 'admin', '2026-05-08 16:06:43', '', NULL, '合规材料管理目录');
INSERT INTO `sys_menu` VALUES (2201, '合规资料分类', 2200, 1, 'complianceType', 'oa/compliance/type/index', '', 'ComplianceType', 1, 0, 'C', '0', '0', 'oa:compliance:type:list', 'list', 'admin', '2026-05-08 16:06:43', '', NULL, '合规资料分类管理');
INSERT INTO `sys_menu` VALUES (2202, '厂商合规模板', 2200, 2, 'complianceTemplate', 'oa/compliance/template/index', '', 'ComplianceTemplate', 1, 0, 'C', '0', '0', 'oa:compliance:template:list', 'form', 'admin', '2026-05-08 16:06:43', '', NULL, '厂商合规模板管理');
INSERT INTO `sys_menu` VALUES (2203, '合规任务', 2200, 3, 'complianceTask', 'oa/compliance/task/index', '', 'ComplianceTask', 1, 0, 'C', '0', '0', 'oa:compliance:task:list', 'job', 'admin', '2026-05-08 16:06:43', '', NULL, '合规任务管理（看板/列表）');
INSERT INTO `sys_menu` VALUES (2204, '拜访记录', 2200, 4, 'visitRecord', 'oa/compliance/visit/index', '', 'VisitRecord', 1, 0, 'C', '0', '0', 'oa:compliance:visit:list', 'guide', 'admin', '2026-05-08 16:06:43', '', NULL, '拜访记录管理');
INSERT INTO `sys_menu` VALUES (2205, '合规会议', 2200, 5, 'complianceMeeting', 'oa/compliance/meeting/index', '', 'ComplianceMeeting', 1, 0, 'C', '0', '0', 'oa:compliance:meeting:list', 'date', 'admin', '2026-05-08 16:06:43', '', NULL, '合规会议管理');
INSERT INTO `sys_menu` VALUES (2206, '合规资料', 2200, 6, 'complianceMaterial', 'oa/compliance/material/index', '', 'ComplianceMaterial', 1, 0, 'C', '0', '0', 'oa:compliance:material:list', 'upload', 'admin', '2026-05-08 16:06:43', '', NULL, '合规资料上传/审核');
INSERT INTO `sys_menu` VALUES (2300, '培训学习', 0, 8, 'training', NULL, '', '', 1, 0, 'M', '0', '0', '', 'education', 'admin', '2026-05-08 16:06:43', '', NULL, '培训学习目录');
INSERT INTO `sys_menu` VALUES (2301, '产品知识库', 2300, 1, 'advantage', 'oa/training/advantage/index', '', 'Advantage', 1, 0, 'C', '0', '0', 'oa:training:advantage:list', 'documentation', 'admin', '2026-05-08 16:06:43', '', NULL, '产品优势知识库');
INSERT INTO `sys_menu` VALUES (2302, '题库', 2300, 3, 'question', 'oa/training/question/index', '', 'Question', 1, 0, 'C', '0', '0', 'oa:training:question:list', 'edit', 'admin', '2026-05-08 16:06:43', '', NULL, '题库管理（题类+题目+答案）');
INSERT INTO `sys_menu` VALUES (2303, '考试', 2300, 4, 'exam', 'oa/training/exam/index', '', 'Exam', 1, 0, 'C', '0', '0', 'oa:training:exam:list', 'time', 'admin', '2026-05-08 16:06:43', '', NULL, '考试管理（创建+发布+成绩）');
INSERT INTO `sys_menu` VALUES (2304, '学习统计', 2300, 5, 'statistics', 'oa/training/statistics/index', '', 'Statistics', 1, 0, 'C', '0', '0', 'oa:training:statistics:list', 'chart', 'admin', '2026-05-08 16:06:43', '', NULL, '学习情况统计（按人/按产品/按部门）');
INSERT INTO `sys_menu` VALUES (3001, '疫苗大类查询', 2001, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:category:query', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3002, '疫苗大类新增', 2001, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:category:add', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3003, '疫苗大类修改', 2001, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:category:edit', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3004, '疫苗大类删除', 2001, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:category:remove', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3005, '疫苗大类导出', 2001, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:category:export', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3006, '疫苗小类查询', 2002, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:subclass:query', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3007, '疫苗小类新增', 2002, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:subclass:add', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3008, '疫苗小类修改', 2002, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:subclass:edit', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3009, '疫苗小类删除', 2002, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:subclass:remove', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3010, '疫苗小类导出', 2002, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:subclass:export', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3011, '生产企业查询', 2003, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:factory:query', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3012, '生产企业新增', 2003, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:factory:add', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3013, '生产企业修改', 2003, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:factory:edit', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3014, '生产企业删除', 2003, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:factory:remove', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3015, '生产企业导出', 2003, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:factory:export', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3016, '在售疫苗查询', 2004, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:vaccine:query', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3017, '在售疫苗新增', 2004, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:vaccine:add', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3018, '在售疫苗修改', 2004, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:vaccine:edit', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3019, '在售疫苗删除', 2004, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:vaccine:remove', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3020, '在售疫苗导出', 2004, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:vaccine:export', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3021, '行政区划查询', 2005, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:base:area:query', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3022, '行政区划新增', 2005, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:base:area:add', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3023, '行政区划修改', 2005, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:base:area:edit', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3024, '行政区划删除', 2005, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:base:area:remove', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3025, '行政区划导出', 2005, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:base:area:export', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3026, '指南手册查询', 2006, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:base:guide:query', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3027, '指南手册新增', 2006, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:base:guide:add', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3028, '指南手册修改', 2006, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:base:guide:edit', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3029, '指南手册删除', 2006, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:base:guide:remove', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3030, '指南手册导出', 2006, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:base:guide:export', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3031, '推广商查询', 2007, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:query', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3032, '推广商新增', 2007, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:add', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3033, '推广商修改', 2007, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:edit', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3034, '推广商删除', 2007, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:remove', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3035, '推广商导出', 2007, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:export', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3036, '客户单位查询', 2101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:unit:query', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3037, '客户单位新增', 2101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:unit:add', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3038, '客户单位修改', 2101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:unit:edit', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3039, '客户单位删除', 2101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:unit:remove', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3040, '客户单位导出', 2101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:unit:export', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3041, '客户信息查询', 2102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:contact:query', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3042, '客户信息新增', 2102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:contact:add', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3043, '客户信息修改', 2102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:contact:edit', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3044, '客户信息删除', 2102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:contact:remove', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3045, '客户信息导出', 2102, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:contact:export', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3046, '客户类别查询', 2103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:grade:query', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3047, '客户类别新增', 2103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:grade:add', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3048, '客户类别修改', 2103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:grade:edit', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3049, '客户类别删除', 2103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:grade:remove', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3050, '客户类别导出', 2103, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:customer:grade:export', '#', 'admin', '2026-05-07 16:37:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3051, '产品规格查询', 2008, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:sku:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3052, '产品规格新增', 2008, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:sku:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3053, '产品规格修改', 2008, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:sku:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3054, '产品规格删除', 2008, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:sku:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3055, '产品规格导出', 2008, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:sku:export', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3056, '产品价格查询', 2009, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:price:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3057, '产品价格新增', 2009, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:price:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3058, '产品价格修改', 2009, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:price:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3059, '产品价格删除', 2009, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:price:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3060, '产品价格导出', 2009, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:price:export', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3061, '公司定价查询', 2012, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:price:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3062, '公司定价新增', 2012, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:price:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3063, '公司定价修改', 2012, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:price:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3064, '公司定价删除', 2012, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:price:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3065, '公司定价导出', 2012, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:price:export', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3066, '公司客户查询', 2013, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:customer:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3067, '公司客户启用', 2013, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:customer:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3068, '公司客户停用', 2013, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:customer:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3069, '公司客户移除', 2013, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:customer:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3070, '公司客户导出', 2013, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:customer:export', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3071, '资料分类查询', 2201, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:type:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3072, '资料分类新增', 2201, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:type:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3073, '资料分类修改', 2201, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:type:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3074, '资料分类删除', 2201, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:type:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3075, '合规模板查询', 2202, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:template:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3076, '合规模板新增', 2202, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:template:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3077, '合规模板修改', 2202, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:template:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3078, '合规模板删除', 2202, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:template:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3079, '合规任务查询', 2203, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:task:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3080, '合规任务新增', 2203, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:task:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3081, '合规任务修改', 2203, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:task:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3082, '合规任务删除', 2203, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:task:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3083, '合规任务审核', 2203, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:task:audit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3084, '拜访记录查询', 2204, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:visit:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3085, '拜访记录新增', 2204, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:visit:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3086, '拜访记录修改', 2204, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:visit:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3087, '拜访记录删除', 2204, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:visit:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3088, '拜访记录审核', 2204, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:visit:audit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3089, '拜访记录导出', 2204, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:visit:export', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3090, '合规会议查询', 2205, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:meeting:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3091, '合规会议新增', 2205, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:meeting:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3092, '合规会议修改', 2205, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:meeting:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3093, '合规会议删除', 2205, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:meeting:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3094, '合规会议审核', 2205, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:meeting:audit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3095, '合规资料查询', 2206, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:material:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3096, '合规资料上传', 2206, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:material:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3097, '合规资料修改', 2206, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:material:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3098, '合规资料删除', 2206, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:material:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3099, '合规资料审核', 2206, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:compliance:material:audit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3100, '知识库查询', 2301, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:advantage:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3101, '知识库新增', 2301, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:advantage:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3102, '知识库修改', 2301, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:advantage:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3103, '知识库删除', 2301, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:advantage:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3104, '题库查询', 2302, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:question:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3105, '题库新增', 2302, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:question:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3106, '题库修改', 2302, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:question:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3107, '题库删除', 2302, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:question:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3108, '题库导入', 2302, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:question:import', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3109, '考试查询', 2303, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:exam:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3110, '考试新增', 2303, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:exam:add', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3111, '考试修改', 2303, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:exam:edit', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3112, '考试删除', 2303, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:exam:remove', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3113, '考试发布', 2303, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:exam:publish', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3114, '学习统计查询', 2304, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:statistics:query', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3115, '学习统计导出', 2304, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:training:statistics:export', '#', 'admin', '2026-05-08 16:06:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3116, '业务员查询', 2014, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:staff:query', '#', 'admin', '2026-05-10 12:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3117, '业务员新增', 2014, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:staff:add', '#', 'admin', '2026-05-10 12:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3118, '业务员修改', 2014, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:staff:edit', '#', 'admin', '2026-05-10 12:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3119, '业务员删除', 2014, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:staff:remove', '#', 'admin', '2026-05-10 12:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3120, '业务员导出', 2014, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:staff:export', '#', 'admin', '2026-05-10 12:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3121, '考核规则查询', 2010, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:assess:query', '#', 'admin', '2026-05-10 12:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3122, '考核规则新增', 2010, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:assess:add', '#', 'admin', '2026-05-10 12:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3123, '考核规则修改', 2010, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:assess:edit', '#', 'admin', '2026-05-10 12:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3124, '考核规则删除', 2010, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:assess:remove', '#', 'admin', '2026-05-10 12:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3125, '考核规则导出', 2010, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:assess:export', '#', 'admin', '2026-05-10 12:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3126, '经营区域查询', 2015, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:area:query', '#', 'admin', '2026-05-10 15:15:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3127, '经营区域新增', 2015, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:area:add', '#', 'admin', '2026-05-10 15:15:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3128, '经营区域删除', 2015, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:company:area:remove', '#', 'admin', '2026-05-10 15:15:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3129, '数据映射查询', 2011, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:mapping:query', '#', 'admin', '2026-05-10 16:04:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3130, '数据映射新增', 2011, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:mapping:add', '#', 'admin', '2026-05-10 16:04:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3131, '数据映射修改', 2011, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:mapping:edit', '#', 'admin', '2026-05-10 16:04:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3132, '数据映射删除', 2011, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:mapping:remove', '#', 'admin', '2026-05-10 16:04:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (3133, '数据映射导入', 2011, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'oa:vaccine:mapping:import', '#', 'admin', '2026-05-10 16:04:51', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-05-07 10:37:49', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-05-07 10:37:49', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 159 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '菜单管理', 2, 'com.xjpk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-05-07 10:37:49\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-08 09:50:22', 38);
INSERT INTO `sys_oper_log` VALUES (101, '厂家疫苗关系', 1, 'com.xjpk.web.controller.oa.OaVaccineFactoryController.addSubclass()', 'POST', 1, 'admin', '研发部门', '/oa/vaccine/factory/1/subclass', '127.0.0.1', '内网IP', '1 {\"categoryId\":1,\"createBy\":\"admin\",\"factoryId\":1,\"id\":16,\"isMainProduct\":\"0\",\"params\":{},\"subclassId\":2} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 10:52:13', 154);
INSERT INTO `sys_oper_log` VALUES (102, '产品规格SKU', 2, 'com.xjpk.web.controller.oa.OaVaccineSkuController.edit()', 'PUT', 1, 'admin', '研发部门', '/oa/vaccine/sku', '127.0.0.1', '内网IP', '{\"approvalNo\":\"S20200001\",\"categoryId\":1,\"categoryName\":\"乙型肝炎疫苗\",\"createBy\":\"admin\",\"createTime\":\"2026-05-09 11:16:28\",\"crowdCode\":\"03\",\"delFlag\":\"0\",\"dosageCode\":\"0.5ml\",\"dosageFormCode\":\"injection\",\"factoryId\":1,\"factoryName\":\"北京科兴生物制品有限公司\",\"isActive\":\"1\",\"params\":{},\"productType\":\"OWN\",\"skuCode\":\"SKU-0101-KX\",\"skuId\":1,\"skuName\":\"乙肝CHO/科兴/注射液/0.5ml/儿童\",\"sortNo\":1,\"specification\":\"0.5ml/支\",\"status\":\"0\",\"subclassId\":1,\"subclassName\":\"重组乙型肝炎疫苗（CHO细胞）\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 11:18:54', 28);
INSERT INTO `sys_oper_log` VALUES (103, '产品规格SKU', 2, 'com.xjpk.web.controller.oa.OaVaccineSkuController.edit()', 'PUT', 1, 'admin', '研发部门', '/oa/vaccine/sku', '127.0.0.1', '内网IP', '{\"approvalNo\":\"S20200001\",\"categoryId\":1,\"categoryName\":\"乙型肝炎疫苗\",\"createBy\":\"admin\",\"createTime\":\"2026-05-09 11:16:28\",\"crowdCode\":\"03\",\"crowdName\":\"全年龄\",\"delFlag\":\"0\",\"dosageCode\":\"02\",\"dosageFormCode\":\"injection\",\"factoryId\":1,\"factoryName\":\"北京科兴生物制品有限公司\",\"isActive\":\"1\",\"params\":{},\"productType\":\"OWN\",\"skuCode\":\"SKU-0101-KX\",\"skuId\":1,\"skuName\":\"乙肝CHO/科兴/注射液/0.5ml/儿童\",\"sortNo\":1,\"specification\":\"0.5ml/支\",\"status\":\"0\",\"subclassId\":1,\"subclassName\":\"重组乙型肝炎疫苗（CHO细胞）\",\"updateBy\":\"admin\",\"updateTime\":\"2026-05-09 11:18:53\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 11:19:02', 16);
INSERT INTO `sys_oper_log` VALUES (104, '产品规格SKU', 2, 'com.xjpk.web.controller.oa.OaVaccineSkuController.edit()', 'PUT', 1, 'admin', '研发部门', '/oa/vaccine/sku', '127.0.0.1', '内网IP', '{\"approvalNo\":\"S20200001\",\"categoryId\":1,\"categoryName\":\"乙型肝炎疫苗\",\"createBy\":\"admin\",\"createTime\":\"2026-05-09 11:16:28\",\"crowdCode\":\"03\",\"crowdName\":\"全年龄\",\"delFlag\":\"0\",\"dosageCode\":\"02\",\"dosageFormCode\":\"03\",\"dosageName\":\"0.5ml\",\"factoryId\":1,\"factoryName\":\"北京科兴生物制品有限公司\",\"isActive\":\"1\",\"params\":{},\"productType\":\"OWN\",\"skuCode\":\"SKU-0101-KX\",\"skuId\":1,\"skuName\":\"乙肝CHO/科兴/注射液/0.5ml/儿童\",\"sortNo\":1,\"specification\":\"0.5ml/支\",\"status\":\"0\",\"subclassId\":1,\"subclassName\":\"重组乙型肝炎疫苗（CHO细胞）\",\"updateBy\":\"admin\",\"updateTime\":\"2026-05-09 11:19:02\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 11:19:13', 13);
INSERT INTO `sys_oper_log` VALUES (105, '行政区划', 1, 'com.xjpk.web.controller.oa.OaAreaController.add()', 'POST', 1, 'admin', '研发部门', '/oa/base/area', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,1,2,5\",\"areaCode\":\"52000301\",\"areaId\":12,\"areaLevel\":\"town\",\"areaName\":\"乡镇区A\",\"children\":[],\"createBy\":\"admin\",\"params\":{},\"parentAreaId\":5,\"sortNo\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 11:21:40', 25);
INSERT INTO `sys_oper_log` VALUES (106, '产品规格SKU', 1, 'com.xjpk.web.controller.oa.OaVaccineSkuController.add()', 'POST', 1, 'admin', '研发部门', '/oa/vaccine/sku', '127.0.0.1', '内网IP', '{\"approvalNo\":\"ak47\",\"categoryId\":2,\"createBy\":\"admin\",\"crowdCode\":\"02\",\"dosageCode\":\"01\",\"dosageFormCode\":\"03\",\"factoryId\":7,\"params\":{},\"skuCode\":\"SKU1778297325308\",\"skuId\":11,\"sortNo\":0,\"specification\":\"0.5/只\",\"status\":\"0\",\"subclassId\":4} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 11:28:45', 162);
INSERT INTO `sys_oper_log` VALUES (107, '客户单位', 1, 'com.xjpk.web.controller.oa.OaCustomerUnitController.add()', 'POST', 1, 'admin', '研发部门', '/oa/customer/unit', '127.0.0.1', '内网IP', '{\"address\":\"祁阳县白水镇烟\",\"ancestors\":\"0\",\"areaCode\":\"52000301\",\"children\":[],\"cityCode\":\"520103\",\"cityName\":\"云岩区\",\"contactPhone\":\"19976628341\",\"countyCode\":\"52000301\",\"countyName\":\"乡镇区A\",\"createBy\":\"admin\",\"params\":{},\"parentUnitId\":0,\"provinceCode\":\"520100\",\"provinceName\":\"贵阳市\",\"sortNo\":0,\"status\":\"0\",\"unitCode\":\"贵阳学院\",\"unitFullName\":\"贵阳学院\",\"unitId\":16,\"unitName\":\"贵阳学院\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 13:53:27', 32);
INSERT INTO `sys_oper_log` VALUES (108, '客户单位', 2, 'com.xjpk.web.controller.oa.OaCustomerUnitController.edit()', 'PUT', 1, 'admin', '研发部门', '/oa/customer/unit', '127.0.0.1', '内网IP', '{\"address\":\"祁阳县白水镇烟\",\"ancestors\":\"0\",\"areaCode\":\"52000301\",\"children\":[],\"cityCode\":\"520103\",\"cityName\":\"云岩区\",\"contactPerson\":\"gg bond\",\"contactPhone\":\"19976628341\",\"countyCode\":\"52000301\",\"countyName\":\"乡镇区A\",\"createBy\":\"admin\",\"createTime\":\"2026-05-09 13:53:27\",\"delFlag\":\"0\",\"isCdc\":\"0\",\"isOrderUnit\":\"0\",\"isPov\":\"0\",\"isVaccinationSite\":\"0\",\"params\":{},\"parentUnitId\":0,\"provinceCode\":\"520100\",\"provinceName\":\"贵阳市\",\"sortNo\":0,\"sourceType\":\"PLATFORM\",\"status\":\"0\",\"unitCode\":\"贵阳学院\",\"unitFullName\":\"贵阳学院\",\"unitId\":16,\"unitLevel\":\"county\",\"unitName\":\"贵阳学院\",\"unitType\":\"OTHER\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 13:53:56', 22);
INSERT INTO `sys_oper_log` VALUES (109, '公司经营区域', 2, 'com.xjpk.web.controller.oa.OaCompanyAreaController.save()', 'POST', 1, 'admin', '研发部门', '/oa/company/area/save', '127.0.0.1', '内网IP', '[{\"areaCode\":\"520000\",\"areaId\":1,\"areaLevel\":\"province\",\"areaName\":\"贵州省\",\"companyId\":0,\"createBy\":\"admin\",\"params\":{}}] ', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLException: Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'\r\n### The error may exist in file [E:\\.A-新纪普康项目\\xjpk-vacc-master\\xjpk-system\\target\\classes\\mapper\\oa\\OaCompanyAreaMapper.xml]\r\n### The error may involve com.xjpk.system.mapper.oa.OaCompanyAreaMapper.selectUnitIdsOutsideAreas-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select ccu.id from oa_company_customer_unit ccu   inner join oa_customer_unit cu on ccu.unit_id = cu.unit_id   where ccu.company_id = ? and ccu.del_flag = \'0\'     and not exists (       select 1 from oa_company_area ca       where ca.company_id = ccu.company_id and ca.del_flag = \'0\'         and (cu.province_code = ca.area_code           or cu.city_code = ca.area_code           or cu.county_code = ca.area_code)     )\r\n### Cause: java.sql.SQLException: Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'\n; uncategorized SQLException; SQL state [HY000]; error code [1267]; Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'; nested exception is java.sql.SQLException: Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'', '2026-05-10 15:39:09', 162);
INSERT INTO `sys_oper_log` VALUES (110, '部门管理', 1, 'com.xjpk.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"companyId\":0,\"createBy\":\"admin\",\"deptName\":\"贵州省疫苗公司A\",\"leader\":\"1\",\"orderNum\":0,\"params\":{},\"parentId\":100,\"phone\":\"\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 15:40:39', 18);
INSERT INTO `sys_oper_log` VALUES (111, '部门管理', 1, 'com.xjpk.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"companyId\":0,\"createBy\":\"admin\",\"deptName\":\"贵州省疫苗公司B\",\"orderNum\":0,\"params\":{},\"parentId\":100,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 15:41:10', 15);
INSERT INTO `sys_oper_log` VALUES (112, '部门管理', 2, 'com.xjpk.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"companyId\":0,\"deptId\":200,\"deptName\":\"贵州省疫苗公司1\",\"leader\":\"1\",\"orderNum\":0,\"params\":{},\"parentId\":100,\"parentName\":\"若依科技\",\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 15:41:22', 29);
INSERT INTO `sys_oper_log` VALUES (113, '部门管理', 2, 'com.xjpk.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"companyId\":0,\"deptId\":201,\"deptName\":\"贵州省疫苗公司2\",\"orderNum\":0,\"params\":{},\"parentId\":100,\"parentName\":\"若依科技\",\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 15:41:27', 18);
INSERT INTO `sys_oper_log` VALUES (114, '用户管理', 1, 'com.xjpk.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"accountType\":\"PLATFORM\",\"admin\":false,\"companyId\":0,\"createBy\":\"admin\",\"deptId\":200,\"nickName\":\"test_boss1\",\"params\":{},\"postIds\":[10],\"roleIds\":[101],\"status\":\"0\",\"userId\":100,\"userName\":\"test_boss1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 15:48:13', 122);
INSERT INTO `sys_oper_log` VALUES (115, '用户管理', 1, 'com.xjpk.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"accountType\":\"PLATFORM\",\"admin\":false,\"companyId\":0,\"createBy\":\"admin\",\"deptId\":200,\"nickName\":\"test_rep1\",\"params\":{},\"postIds\":[13],\"roleIds\":[105],\"sex\":\"0\",\"status\":\"0\",\"userId\":101,\"userName\":\"test_rep1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 15:48:42', 83);
INSERT INTO `sys_oper_log` VALUES (116, '用户管理', 1, 'com.xjpk.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"accountType\":\"PLATFORM\",\"admin\":false,\"companyId\":0,\"createBy\":\"admin\",\"deptId\":201,\"nickName\":\"test_boss2\",\"params\":{},\"postIds\":[10],\"roleIds\":[101],\"sex\":\"0\",\"status\":\"0\",\"userId\":102,\"userName\":\"test_boss2\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 15:49:14', 81);
INSERT INTO `sys_oper_log` VALUES (117, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,1900,2001,3001,3002,3003,3004,3005,2002,3006,3007,3008,3009,3010,2003,3011,3012,3013,3014,3015,2005,3021,3022,3023,3024,3025,2008,3051,3052,3053,3054,3055,2009,3056,3057,3058,3059,3060,2101,3036,3037,3038,3039,3040,2000,2015,3126,3127,3128,2013,2004,3016,3017,3018,3019,3020,2012,2010,3061,3121,3062,3122,3063,3123,3064,3124,3065,3125,2014,3116,3117,3118,3119,3120,2011,3066,3067,3068,3069,3070],\"params\":{},\"remark\":\"推广商系统管理员（模板角色）\",\"roleBizType\":\"COMPANY\",\"roleId\":101,\"roleKey\":\"company_admin\",\"roleName\":\"推广商管理员\",\"roleSort\":4,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 15:56:31', 35);
INSERT INTO `sys_oper_log` VALUES (118, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,2000,2015,3126,3127,3128,2013,2004,3016,3017,3018,3019,3020,2012,2010,3061,3121,3062,3122,3063,3123,3064,3124,3065,3125,2014,3116,3117,3118,3119,3120,2011,3066,3067,3068,3069,3070],\"params\":{},\"remark\":\"推广商老板（模板角色）\",\"roleBizType\":\"SALES\",\"roleId\":102,\"roleKey\":\"oa_boss\",\"roleName\":\"老板\",\"roleSort\":5,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 15:56:44', 23);
INSERT INTO `sys_oper_log` VALUES (119, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,2000,2015,3126,3127,3128,2013,3066,3067,3068,3069,3070,2004,3016,3017,3018,3019,3020,2012,3061,3062,3063,3064,3065,2010,3121,3122,3123,3124,3125,2014,3116,3117,3118,3119,3120,2011,2100,2102,3041,3042,3043,3044,3045,2103,3046,3047,3048,3049,3050,2200,2201,3071,3072,3073,3074,2202,3075,3076,3077,3078,2203,3079,3080,3081,3082,3083,2204,3084,3085,3086,3087,3088,3089,2205,3090,3091,3092,3093,3094,2206,3095,3096,3097,3098,3099,2300,2301,3100,3101,3102,3103,2006,3026,3027,3028,3029,3030,2302,3104,3105,3106,3107,3108,2303,3109,3110,3111,3112,3113,2304,3114,3115],\"params\":{},\"remark\":\"推广商老板（模板角色）\",\"roleBizType\":\"SALES\",\"roleId\":102,\"roleKey\":\"oa_boss\",\"roleName\":\"老板\",\"roleSort\":5,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:05:47', 32);
INSERT INTO `sys_oper_log` VALUES (120, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,1900,2001,3001,3002,3003,3004,3005,2002,3006,3007,3008,3009,3010,2003,3011,3012,3013,3014,3015,2005,3021,3022,3023,3024,3025,2008,3051,3052,3053,3054,3055,2009,3056,3057,3058,3059,3060,2101,3036,3037,3038,3039,3040,2000,2015,3126,3127,3128,2013,3066,3067,3068,3069,3070,2004,3016,3017,3018,3019,3020,2012,3061,3062,3063,3064,3065,2010,3121,3122,3123,3124,3125,2014,3116,3117,3118,3119,3120,2011,2100,2102,3041,3042,3043,3044,3045,2103,3046,3047,3048,3049,3050,2200,2201,3071,3072,3073,3074,2202,3075,3076,3077,3078,2203,3079,3080,3081,3082,3083,2204,3084,3085,3086,3087,3088,3089,2205,3090,3091,3092,3093,3094,2206,3095,3096,3097,3098,3099,2300,2301,3100,3101,3102,3103,2006,3026,3027,3028,3029,3030,2302,3104,3105,3106,3107,3108,2303,3109,3110,3111,3112,3113,2304,3114,3115],\"params\":{},\"remark\":\"推广商系统管理员（模板角色）\",\"roleBizType\":\"COMPANY\",\"roleId\":101,\"roleKey\":\"company_admin\",\"roleName\":\"推广商管理员\",\"roleSort\":4,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:05:54', 27);
INSERT INTO `sys_oper_log` VALUES (121, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"SELF\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"menuIds\":[2000,2015,2013,2004,2012,2010,2100,2102,2103,3126,3066,3016,3061,3121,3041,3046],\"params\":{},\"remark\":\"推广商医药代表（模板角色）\",\"roleBizType\":\"SALES\",\"roleId\":105,\"roleKey\":\"oa_med_rep\",\"roleName\":\"医药代表\",\"roleSort\":8,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:06:45', 21);
INSERT INTO `sys_oper_log` VALUES (122, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"SELF\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"menuIds\":[2000,2015,2013,2004,2012,2010,2100,2102,2103,3126,3066,3016,3061,3121,3041,3046],\"params\":{},\"remark\":\"推广商医药代表（模板角色）\",\"roleBizType\":\"SALES\",\"roleId\":105,\"roleKey\":\"oa_med_rep\",\"roleName\":\"医药代表\",\"roleSort\":8,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:08:16', 23);
INSERT INTO `sys_oper_log` VALUES (123, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,2007,3031,3032,3033,3034,3035,2000,2015,3126,3127,3128,2013,3066,3067,3068,3069,3070,2004,3016,3017,3018,3019,3020,2012,3061,3062,3063,3064,3065,2010,3121,3122,3123,3124,3125,2014,3116,3117,3118,3119,3120,2011,2100,2102,3041,3042,3043,3044,3045,2103,3046,3047,3048,3049,3050,2200,2201,3071,3072,3073,3074,2202,3075,3076,3077,3078,2203,3079,3080,3081,3082,3083,2204,3084,3085,3086,3087,3088,3089,2205,3090,3091,3092,3093,3094,2206,3095,3096,3097,3098,3099,2300,2301,3100,3101,3102,3103,2006,3026,3027,3028,3029,3030,2302,3104,3105,3106,3107,3108,2303,3109,3110,3111,3112,3113,2304,3114,3115],\"params\":{},\"remark\":\"推广商老板（模板角色）\",\"roleBizType\":\"SALES\",\"roleId\":102,\"roleKey\":\"oa_boss\",\"roleName\":\"老板\",\"roleSort\":5,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:09:20', 25);
INSERT INTO `sys_oper_log` VALUES (124, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,2007,3031,3032,3033,3034,3035,1900,2001,3001,3002,3003,3004,3005,2002,3006,3007,3008,3009,3010,2003,3011,3012,3013,3014,3015,2005,3021,3022,3023,3024,3025,2008,3051,3052,3053,3054,3055,2009,3056,3057,3058,3059,3060,2101,3036,3037,3038,3039,3040,2000,2015,3126,3127,3128,2013,3066,3067,3068,3069,3070,2004,3016,3017,3018,3019,3020,2012,3061,3062,3063,3064,3065,2010,3121,3122,3123,3124,3125,2014,3116,3117,3118,3119,3120,2011,2100,2102,3041,3042,3043,3044,3045,2103,3046,3047,3048,3049,3050,2200,2201,3071,3072,3073,3074,2202,3075,3076,3077,3078,2203,3079,3080,3081,3082,3083,2204,3084,3085,3086,3087,3088,3089,2205,3090,3091,3092,3093,3094,2206,3095,3096,3097,3098,3099,2300,2301,3100,3101,3102,3103,2006,3026,3027,3028,3029,3030,2302,3104,3105,3106,3107,3108,2303,3109,3110,3111,3112,3113,2304,3114,3115],\"params\":{},\"remark\":\"推广商系统管理员（模板角色）\",\"roleBizType\":\"COMPANY\",\"roleId\":101,\"roleKey\":\"company_admin\",\"roleName\":\"推广商管理员\",\"roleSort\":4,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:09:39', 27);
INSERT INTO `sys_oper_log` VALUES (125, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"4\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"params\":{},\"remark\":\"推广商系统管理员（模板角色）\",\"roleBizType\":\"COMPANY\",\"roleId\":101,\"roleKey\":\"company_admin\",\"roleName\":\"推广商管理员\",\"roleSort\":4,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:15:08', 8);
INSERT INTO `sys_oper_log` VALUES (126, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"4\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"params\":{},\"remark\":\"推广商系统管理员（模板角色）\",\"roleBizType\":\"COMPANY\",\"roleId\":101,\"roleKey\":\"company_admin\",\"roleName\":\"推广商管理员\",\"roleSort\":4,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:15:12', 8);
INSERT INTO `sys_oper_log` VALUES (127, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"4\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"params\":{},\"remark\":\"推广商老板（模板角色）\",\"roleBizType\":\"SALES\",\"roleId\":102,\"roleKey\":\"oa_boss\",\"roleName\":\"老板\",\"roleSort\":5,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:15:19', 8);
INSERT INTO `sys_oper_log` VALUES (128, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"DEPT\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"4\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"params\":{},\"remark\":\"推广商总监（模板角色）\",\"roleBizType\":\"SALES\",\"roleId\":103,\"roleKey\":\"oa_director\",\"roleName\":\"总监\",\"roleSort\":6,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:15:32', 8);
INSERT INTO `sys_oper_log` VALUES (129, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"STAFF_SCOPE\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"4\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"params\":{},\"remark\":\"推广商区域经理（模板角色）\",\"roleBizType\":\"SALES\",\"roleId\":104,\"roleKey\":\"oa_region_manager\",\"roleName\":\"区域经理\",\"roleSort\":7,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:15:37', 9);
INSERT INTO `sys_oper_log` VALUES (130, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"DEPT\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"3\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"params\":{},\"remark\":\"推广商信息工作员（模板角色）\",\"roleBizType\":\"MARKET\",\"roleId\":106,\"roleKey\":\"oa_market_info\",\"roleName\":\"信息工作员\",\"roleSort\":9,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:15:56', 7);
INSERT INTO `sys_oper_log` VALUES (131, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"DEPT\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"params\":{},\"remark\":\"推广商信息工作员（模板角色）\",\"roleBizType\":\"MARKET\",\"roleId\":106,\"roleKey\":\"oa_market_info\",\"roleName\":\"信息工作员\",\"roleSort\":9,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:16:15', 8);
INSERT INTO `sys_oper_log` VALUES (132, '行政区划', 1, 'com.xjpk.web.controller.oa.OaAreaController.add()', 'POST', 1, 'admin', '研发部门', '/oa/base/area', '127.0.0.1', '内网IP', '{\"ancestors\":\"0\",\"areaCode\":\"560101\",\"areaId\":13,\"areaLevel\":\"province\",\"areaName\":\"云南省\",\"areaShortName\":\"云\",\"children\":[],\"createBy\":\"admin\",\"params\":{},\"parentAreaId\":0,\"sortNo\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:20:40', 35);
INSERT INTO `sys_oper_log` VALUES (133, '行政区划', 1, 'com.xjpk.web.controller.oa.OaAreaController.add()', 'POST', 1, 'admin', '研发部门', '/oa/base/area', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,13\",\"areaCode\":\"56010101\",\"areaId\":14,\"areaLevel\":\"city\",\"areaName\":\"云南某市\",\"areaShortName\":\"云南某市\",\"children\":[],\"createBy\":\"admin\",\"params\":{},\"parentAreaId\":13,\"sortNo\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:21:59', 10);
INSERT INTO `sys_oper_log` VALUES (134, '公司经营区域', 2, 'com.xjpk.web.controller.oa.OaCompanyAreaController.save()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/area/save', '127.0.0.1', '内网IP', '[{\"areaCode\":\"560101\",\"areaId\":13,\"areaLevel\":\"province\",\"areaName\":\"云南省\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520000\",\"areaId\":1,\"areaLevel\":\"province\",\"areaName\":\"贵州省\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520100\",\"areaId\":2,\"areaLevel\":\"city\",\"areaName\":\"贵阳市\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520103\",\"areaId\":5,\"areaLevel\":\"county\",\"areaName\":\"云岩区\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520102\",\"areaId\":6,\"areaLevel\":\"county\",\"areaName\":\"南明区\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520300\",\"areaId\":3,\"areaLevel\":\"city\",\"areaName\":\"遵义市\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}}] ', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLException: Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'\r\n### The error may exist in file [E:\\.A-新纪普康项目\\xjpk-vacc-master\\xjpk-system\\target\\classes\\mapper\\oa\\OaCompanyAreaMapper.xml]\r\n### The error may involve com.xjpk.system.mapper.oa.OaCompanyAreaMapper.selectUnitIdsOutsideAreas-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select ccu.id from oa_company_customer_unit ccu   inner join oa_customer_unit cu on ccu.unit_id = cu.unit_id   where ccu.company_id = ? and ccu.del_flag = \'0\'     and not exists (       select 1 from oa_company_area ca       where ca.company_id = ccu.company_id and ca.del_flag = \'0\'         and (cu.province_code = ca.area_code           or cu.city_code = ca.area_code           or cu.county_code = ca.area_code)     )\r\n### Cause: java.sql.SQLException: Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'\n; uncategorized SQLException; SQL state [HY000]; error code [1267]; Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'; nested exception is java.sql.SQLException: Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'', '2026-05-10 16:23:22', 20);
INSERT INTO `sys_oper_log` VALUES (135, '公司经营区域', 2, 'com.xjpk.web.controller.oa.OaCompanyAreaController.save()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/area/save', '127.0.0.1', '内网IP', '[{\"areaCode\":\"560101\",\"areaId\":13,\"areaLevel\":\"province\",\"areaName\":\"云南省\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520000\",\"areaId\":1,\"areaLevel\":\"province\",\"areaName\":\"贵州省\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520100\",\"areaId\":2,\"areaLevel\":\"city\",\"areaName\":\"贵阳市\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520103\",\"areaId\":5,\"areaLevel\":\"county\",\"areaName\":\"云岩区\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520102\",\"areaId\":6,\"areaLevel\":\"county\",\"areaName\":\"南明区\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520300\",\"areaId\":3,\"areaLevel\":\"city\",\"areaName\":\"遵义市\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}}] ', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLException: Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'\r\n### The error may exist in file [E:\\.A-新纪普康项目\\xjpk-vacc-master\\xjpk-system\\target\\classes\\mapper\\oa\\OaCompanyAreaMapper.xml]\r\n### The error may involve com.xjpk.system.mapper.oa.OaCompanyAreaMapper.selectUnitIdsOutsideAreas-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select ccu.id from oa_company_customer_unit ccu   inner join oa_customer_unit cu on ccu.unit_id = cu.unit_id   where ccu.company_id = ? and ccu.del_flag = \'0\'     and not exists (       select 1 from oa_company_area ca       where ca.company_id = ccu.company_id and ca.del_flag = \'0\'         and (cu.province_code = ca.area_code           or cu.city_code = ca.area_code           or cu.county_code = ca.area_code)     )\r\n### Cause: java.sql.SQLException: Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'\n; uncategorized SQLException; SQL state [HY000]; error code [1267]; Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'; nested exception is java.sql.SQLException: Illegal mix of collations (utf8mb4_0900_ai_ci,IMPLICIT) and (utf8mb4_general_ci,IMPLICIT) for operation \'=\'', '2026-05-10 16:23:33', 15);
INSERT INTO `sys_oper_log` VALUES (136, '公司经营区域', 2, 'com.xjpk.web.controller.oa.OaCompanyAreaController.save()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/area/save', '127.0.0.1', '内网IP', '[{\"areaCode\":\"560101\",\"areaId\":13,\"areaLevel\":\"province\",\"areaName\":\"云南省\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520000\",\"areaId\":1,\"areaLevel\":\"province\",\"areaName\":\"贵州省\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520100\",\"areaId\":2,\"areaLevel\":\"city\",\"areaName\":\"贵阳市\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520103\",\"areaId\":5,\"areaLevel\":\"county\",\"areaName\":\"云岩区\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520102\",\"areaId\":6,\"areaLevel\":\"county\",\"areaName\":\"南明区\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520300\",\"areaId\":3,\"areaLevel\":\"city\",\"areaName\":\"遵义市\",\"companyId\":0,\"createBy\":\"test_boss1\",\"params\":{}}] ', '{\"msg\":\"保存成功\",\"code\":200,\"disabledCount\":0}', 0, NULL, '2026-05-10 16:36:20', 23);
INSERT INTO `sys_oper_log` VALUES (137, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"params\":{},\"remark\":\"推广商系统管理员（模板角色）\",\"roleBizType\":\"COMPANY\",\"roleId\":101,\"roleKey\":\"company_admin\",\"roleName\":\"推广商管理员\",\"roleSort\":4,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:43:02', 34);
INSERT INTO `sys_oper_log` VALUES (138, '角色管理', 2, 'com.xjpk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"bizScopeType\":\"COMPANY\",\"companyId\":0,\"createTime\":\"2026-05-07 16:37:06\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"isPlatformRole\":\"0\",\"menuCheckStrictly\":true,\"params\":{},\"remark\":\"推广商老板（模板角色）\",\"roleBizType\":\"SALES\",\"roleId\":102,\"roleKey\":\"oa_boss\",\"roleName\":\"老板\",\"roleSort\":5,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:43:07', 13);
INSERT INTO `sys_oper_log` VALUES (139, '经营客户单位', 1, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.enable()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer/enable', '127.0.0.1', '内网IP', '[16] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:48:13', 161);
INSERT INTO `sys_oper_log` VALUES (140, '经营客户单位', 1, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.enable()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer/enable', '127.0.0.1', '内网IP', '[2] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:48:14', 15);
INSERT INTO `sys_oper_log` VALUES (141, '经营客户单位', 1, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.enable()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer/enable', '127.0.0.1', '内网IP', '[3] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:48:15', 11);
INSERT INTO `sys_oper_log` VALUES (142, '经营客户单位', 1, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.enable()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer/enable', '127.0.0.1', '内网IP', '[4] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:48:17', 12);
INSERT INTO `sys_oper_log` VALUES (143, '经营客户单位', 1, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.enable()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer/enable', '127.0.0.1', '内网IP', '[1] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:48:31', 10);
INSERT INTO `sys_oper_log` VALUES (144, '经营客户单位', 1, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.enable()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer/enable', '127.0.0.1', '内网IP', '[7] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:53:31', 157);
INSERT INTO `sys_oper_log` VALUES (145, '经营客户单位', 1, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.enable()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer/enable', '127.0.0.1', '内网IP', '[9,10] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:53:38', 23);
INSERT INTO `sys_oper_log` VALUES (146, '经营客户单位', 1, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.enable()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer/enable', '127.0.0.1', '内网IP', '[13] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-10 16:57:09', 21);
INSERT INTO `sys_oper_log` VALUES (147, '公司经营区域', 2, 'com.xjpk.web.controller.oa.OaCompanyAreaController.save()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/area/save', '127.0.0.1', '内网IP', '[{\"areaCode\":\"560101\",\"areaId\":13,\"areaLevel\":\"province\",\"areaName\":\"云南省\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520000\",\"areaId\":1,\"areaLevel\":\"province\",\"areaName\":\"贵州省\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520100\",\"areaId\":2,\"areaLevel\":\"city\",\"areaName\":\"贵阳市\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520103\",\"areaId\":5,\"areaLevel\":\"county\",\"areaName\":\"云岩区\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520102\",\"areaId\":6,\"areaLevel\":\"county\",\"areaName\":\"南明区\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520300\",\"areaId\":3,\"areaLevel\":\"city\",\"areaName\":\"遵义市\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}}] ', '{\"msg\":\"保存成功\",\"code\":200,\"disabledCount\":0}', 0, NULL, '2026-05-11 10:57:11', 87);
INSERT INTO `sys_oper_log` VALUES (148, '经营客户单位', 2, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.edit()', 'PUT', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer', '127.0.0.1', '内网IP', '{\"cityCode\":\"520400\",\"cityName\":\"安顺市\",\"companyId\":200,\"countyCode\":\"520402\",\"countyName\":\"西秀区\",\"createBy\":\"test_boss1\",\"createTime\":\"2026-05-10 16:57:09\",\"customerStatus\":\"NORMAL\",\"defaultGrade\":\"A\",\"delFlag\":\"0\",\"id\":9,\"isFocus\":\"0\",\"params\":{},\"provinceCode\":\"520000\",\"provinceName\":\"贵州省\",\"status\":\"0\",\"unitCode\":\"AS-XX-CDC\",\"unitId\":13,\"unitLevel\":\"county\",\"unitName\":\"西秀区CDC\",\"unitType\":\"CDC\",\"updateBy\":\"test_boss1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-11 15:06:08', 67);
INSERT INTO `sys_oper_log` VALUES (149, '经营客户单位', 2, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.edit()', 'PUT', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer', '127.0.0.1', '内网IP', '{\"cityCode\":\"520300\",\"cityName\":\"遵义市\",\"companyId\":200,\"countyCode\":\"520302\",\"countyName\":\"红花岗区\",\"createBy\":\"test_boss1\",\"createTime\":\"2026-05-10 16:53:38\",\"customerStatus\":\"NORMAL\",\"defaultGrade\":\"B\",\"delFlag\":\"0\",\"id\":8,\"isFocus\":\"0\",\"params\":{},\"provinceCode\":\"520000\",\"provinceName\":\"贵州省\",\"status\":\"0\",\"unitCode\":\"ZY-HHG-POV-01\",\"unitId\":10,\"unitLevel\":\"town\",\"unitName\":\"红花岗区中心POV\",\"unitType\":\"POV\",\"updateBy\":\"test_boss1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-11 15:06:13', 18);
INSERT INTO `sys_oper_log` VALUES (150, '经营客户单位', 2, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.edit()', 'PUT', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer', '127.0.0.1', '内网IP', '{\"cityCode\":\"520300\",\"cityName\":\"遵义市\",\"companyId\":200,\"countyCode\":\"520302\",\"countyName\":\"红花岗区\",\"createBy\":\"test_boss1\",\"createTime\":\"2026-05-10 16:53:38\",\"customerStatus\":\"NORMAL\",\"defaultGrade\":\"C\",\"delFlag\":\"0\",\"id\":7,\"isFocus\":\"0\",\"params\":{},\"provinceCode\":\"520000\",\"provinceName\":\"贵州省\",\"status\":\"0\",\"unitCode\":\"ZY-HHG-CDC\",\"unitId\":9,\"unitLevel\":\"county\",\"unitName\":\"红花岗区CDC\",\"unitType\":\"CDC\",\"updateBy\":\"test_boss1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-11 15:06:16', 17);
INSERT INTO `sys_oper_log` VALUES (151, '公司经营区域', 2, 'com.xjpk.web.controller.oa.OaCompanyAreaController.save()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/area/save', '127.0.0.1', '内网IP', '[{\"areaCode\":\"560101\",\"areaId\":13,\"areaLevel\":\"province\",\"areaName\":\"云南省\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520000\",\"areaId\":1,\"areaLevel\":\"province\",\"areaName\":\"贵州省\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520100\",\"areaId\":2,\"areaLevel\":\"city\",\"areaName\":\"贵阳市\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520103\",\"areaId\":5,\"areaLevel\":\"county\",\"areaName\":\"云岩区\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"52000301\",\"areaId\":12,\"areaLevel\":\"town\",\"areaName\":\"乡镇区A\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520102\",\"areaId\":6,\"areaLevel\":\"county\",\"areaName\":\"南明区\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}},{\"areaCode\":\"520300\",\"areaId\":3,\"areaLevel\":\"city\",\"areaName\":\"遵义市\",\"companyId\":200,\"createBy\":\"test_boss1\",\"params\":{}}] ', '{\"msg\":\"保存成功\",\"code\":200,\"disabledCount\":0}', 0, NULL, '2026-05-11 15:08:00', 40);
INSERT INTO `sys_oper_log` VALUES (152, '在售疫苗', 1, 'com.xjpk.web.controller.oa.OaCompanyVaccineController.selectSkus()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/vaccine/select', '127.0.0.1', '内网IP', '[8] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-11 15:22:28', 181);
INSERT INTO `sys_oper_log` VALUES (153, '在售疫苗', 1, 'com.xjpk.web.controller.oa.OaCompanyVaccineController.selectSkus()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/vaccine/select', '127.0.0.1', '内网IP', '[7,3] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-11 15:22:57', 32);
INSERT INTO `sys_oper_log` VALUES (154, '在售疫苗', 2, 'com.xjpk.web.controller.oa.OaCompanyVaccineController.edit()', 'PUT', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/vaccine', '127.0.0.1', '内网IP', '{\"companyId\":200,\"companyVaccineId\":2,\"isMain\":\"1\",\"params\":{},\"subclassId\":12,\"updateBy\":\"test_boss1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-11 15:23:29', 29);
INSERT INTO `sys_oper_log` VALUES (155, '经营客户单位', 3, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.remove()', 'DELETE', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer/1', '127.0.0.1', '内网IP', '[1] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-16 10:03:27', 66);
INSERT INTO `sys_oper_log` VALUES (156, '经营客户单位', 1, 'com.xjpk.web.controller.oa.OaCompanyCustomerUnitController.enable()', 'POST', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/customer/enable', '127.0.0.1', '内网IP', '[16] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-16 10:03:41', 23);
INSERT INTO `sys_oper_log` VALUES (157, '在售疫苗', 2, 'com.xjpk.web.controller.oa.OaCompanyVaccineController.edit()', 'PUT', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/vaccine', '127.0.0.1', '内网IP', '{\"companyId\":200,\"companyVaccineId\":2,\"isMain\":\"0\",\"params\":{},\"subclassId\":12,\"updateBy\":\"test_boss1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-16 10:11:10', 27);
INSERT INTO `sys_oper_log` VALUES (158, '在售疫苗', 2, 'com.xjpk.web.controller.oa.OaCompanyVaccineController.edit()', 'PUT', 1, 'test_boss1', '贵州省疫苗公司1', '/oa/company/vaccine', '127.0.0.1', '内网IP', '{\"companyId\":200,\"companyVaccineId\":2,\"isMain\":\"1\",\"params\":{},\"subclassId\":12,\"updateBy\":\"test_boss1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-16 10:11:14', 17);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-05-07 10:37:49', '', NULL, '');
INSERT INTO `sys_post` VALUES (10, 'BOSS', '老板', 10, '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商老板');
INSERT INTO `sys_post` VALUES (11, 'DIRECTOR', '总监', 11, '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商总监');
INSERT INTO `sys_post` VALUES (12, 'REGION_MANAGER', '区域经理', 12, '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商区域经理');
INSERT INTO `sys_post` VALUES (13, 'MED_REP', '医药代表', 13, '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商医药代表');
INSERT INTO `sys_post` VALUES (14, 'MARKET_INFO', '信息工作员', 14, '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商信息工作员/市场部');
INSERT INTO `sys_post` VALUES (15, 'FINANCE', '财务/回款人员', 15, '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商财务/回款人员');
INSERT INTO `sys_post` VALUES (16, 'OA_ADMIN', '系统管理员', 16, '0', 'admin', '2026-05-07 16:37:06', '', NULL, '推广商系统管理员');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `company_id` bigint NULL DEFAULT 0 COMMENT '所属公司ID（0=平台角色）',
  `role_biz_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色业务类型（PLATFORM/COMPANY/SALES/MARKET/FINANCE）',
  `staff_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '对应业务身份（BOSS/DIRECTOR/REGION_MANAGER/MED_REP/MARKET_INFO）',
  `is_platform_role` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否平台角色（0=否 1=是）',
  `biz_scope_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务数据范围（COMPANY/DEPT/STAFF_SCOPE/SELF）',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '超级管理员', 0, 'PLATFORM', NULL, '1', NULL);
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-05-07 10:37:49', '', NULL, '普通角色', 0, NULL, NULL, '0', NULL);
INSERT INTO `sys_role` VALUES (100, '平台管理员', 'platform_admin', 3, '1', 1, 1, '0', '0', 'admin', '2026-05-07 16:37:06', '', NULL, '平台级管理员', 0, 'PLATFORM', NULL, '1', 'COMPANY');
INSERT INTO `sys_role` VALUES (101, '推广商管理员', 'company_admin', 4, '1', 1, 1, '0', '0', 'admin', '2026-05-07 16:37:06', 'admin', '2026-05-10 16:43:02', '推广商系统管理员（模板角色）', 0, 'COMPANY', NULL, '0', 'COMPANY');
INSERT INTO `sys_role` VALUES (102, '老板', 'oa_boss', 5, '1', 1, 1, '0', '0', 'admin', '2026-05-07 16:37:06', 'admin', '2026-05-10 16:43:07', '推广商老板（模板角色）', 0, 'SALES', 'BOSS', '0', 'COMPANY');
INSERT INTO `sys_role` VALUES (103, '总监', 'oa_director', 6, '4', 1, 1, '0', '0', 'admin', '2026-05-07 16:37:06', '', '2026-05-10 16:15:32', '推广商总监（模板角色）', 0, 'SALES', 'DIRECTOR', '0', 'DEPT');
INSERT INTO `sys_role` VALUES (104, '区域经理', 'oa_region_manager', 7, '4', 1, 1, '0', '0', 'admin', '2026-05-07 16:37:06', '', '2026-05-10 16:15:37', '推广商区域经理（模板角色）', 0, 'SALES', 'REGION_MANAGER', '0', 'STAFF_SCOPE');
INSERT INTO `sys_role` VALUES (105, '医药代表', 'oa_med_rep', 8, '5', 1, 1, '0', '0', 'admin', '2026-05-07 16:37:06', 'admin', '2026-05-10 16:08:16', '推广商医药代表（模板角色）', 0, 'SALES', 'MED_REP', '0', 'SELF');
INSERT INTO `sys_role` VALUES (106, '信息工作员', 'oa_market_info', 9, '5', 1, 1, '0', '0', 'admin', '2026-05-07 16:37:06', '', '2026-05-10 16:16:15', '推广商信息工作员（模板角色）', 0, 'MARKET', 'MARKET_INFO', '0', 'DEPT');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (101, 1);
INSERT INTO `sys_role_menu` VALUES (101, 100);
INSERT INTO `sys_role_menu` VALUES (101, 102);
INSERT INTO `sys_role_menu` VALUES (101, 103);
INSERT INTO `sys_role_menu` VALUES (101, 104);
INSERT INTO `sys_role_menu` VALUES (101, 1000);
INSERT INTO `sys_role_menu` VALUES (101, 1001);
INSERT INTO `sys_role_menu` VALUES (101, 1002);
INSERT INTO `sys_role_menu` VALUES (101, 1003);
INSERT INTO `sys_role_menu` VALUES (101, 1004);
INSERT INTO `sys_role_menu` VALUES (101, 1005);
INSERT INTO `sys_role_menu` VALUES (101, 1006);
INSERT INTO `sys_role_menu` VALUES (101, 1012);
INSERT INTO `sys_role_menu` VALUES (101, 1013);
INSERT INTO `sys_role_menu` VALUES (101, 1014);
INSERT INTO `sys_role_menu` VALUES (101, 1015);
INSERT INTO `sys_role_menu` VALUES (101, 1016);
INSERT INTO `sys_role_menu` VALUES (101, 1017);
INSERT INTO `sys_role_menu` VALUES (101, 1018);
INSERT INTO `sys_role_menu` VALUES (101, 1019);
INSERT INTO `sys_role_menu` VALUES (101, 1020);
INSERT INTO `sys_role_menu` VALUES (101, 1021);
INSERT INTO `sys_role_menu` VALUES (101, 1022);
INSERT INTO `sys_role_menu` VALUES (101, 1023);
INSERT INTO `sys_role_menu` VALUES (101, 1024);
INSERT INTO `sys_role_menu` VALUES (101, 1900);
INSERT INTO `sys_role_menu` VALUES (101, 2000);
INSERT INTO `sys_role_menu` VALUES (101, 2001);
INSERT INTO `sys_role_menu` VALUES (101, 2002);
INSERT INTO `sys_role_menu` VALUES (101, 2003);
INSERT INTO `sys_role_menu` VALUES (101, 2004);
INSERT INTO `sys_role_menu` VALUES (101, 2005);
INSERT INTO `sys_role_menu` VALUES (101, 2006);
INSERT INTO `sys_role_menu` VALUES (101, 2007);
INSERT INTO `sys_role_menu` VALUES (101, 2008);
INSERT INTO `sys_role_menu` VALUES (101, 2009);
INSERT INTO `sys_role_menu` VALUES (101, 2010);
INSERT INTO `sys_role_menu` VALUES (101, 2011);
INSERT INTO `sys_role_menu` VALUES (101, 2012);
INSERT INTO `sys_role_menu` VALUES (101, 2013);
INSERT INTO `sys_role_menu` VALUES (101, 2014);
INSERT INTO `sys_role_menu` VALUES (101, 2015);
INSERT INTO `sys_role_menu` VALUES (101, 2100);
INSERT INTO `sys_role_menu` VALUES (101, 2101);
INSERT INTO `sys_role_menu` VALUES (101, 2102);
INSERT INTO `sys_role_menu` VALUES (101, 2103);
INSERT INTO `sys_role_menu` VALUES (101, 2200);
INSERT INTO `sys_role_menu` VALUES (101, 2201);
INSERT INTO `sys_role_menu` VALUES (101, 2202);
INSERT INTO `sys_role_menu` VALUES (101, 2203);
INSERT INTO `sys_role_menu` VALUES (101, 2204);
INSERT INTO `sys_role_menu` VALUES (101, 2205);
INSERT INTO `sys_role_menu` VALUES (101, 2206);
INSERT INTO `sys_role_menu` VALUES (101, 2300);
INSERT INTO `sys_role_menu` VALUES (101, 2301);
INSERT INTO `sys_role_menu` VALUES (101, 2302);
INSERT INTO `sys_role_menu` VALUES (101, 2303);
INSERT INTO `sys_role_menu` VALUES (101, 2304);
INSERT INTO `sys_role_menu` VALUES (101, 3001);
INSERT INTO `sys_role_menu` VALUES (101, 3002);
INSERT INTO `sys_role_menu` VALUES (101, 3003);
INSERT INTO `sys_role_menu` VALUES (101, 3004);
INSERT INTO `sys_role_menu` VALUES (101, 3005);
INSERT INTO `sys_role_menu` VALUES (101, 3006);
INSERT INTO `sys_role_menu` VALUES (101, 3007);
INSERT INTO `sys_role_menu` VALUES (101, 3008);
INSERT INTO `sys_role_menu` VALUES (101, 3009);
INSERT INTO `sys_role_menu` VALUES (101, 3010);
INSERT INTO `sys_role_menu` VALUES (101, 3011);
INSERT INTO `sys_role_menu` VALUES (101, 3012);
INSERT INTO `sys_role_menu` VALUES (101, 3013);
INSERT INTO `sys_role_menu` VALUES (101, 3014);
INSERT INTO `sys_role_menu` VALUES (101, 3015);
INSERT INTO `sys_role_menu` VALUES (101, 3016);
INSERT INTO `sys_role_menu` VALUES (101, 3017);
INSERT INTO `sys_role_menu` VALUES (101, 3018);
INSERT INTO `sys_role_menu` VALUES (101, 3019);
INSERT INTO `sys_role_menu` VALUES (101, 3020);
INSERT INTO `sys_role_menu` VALUES (101, 3021);
INSERT INTO `sys_role_menu` VALUES (101, 3022);
INSERT INTO `sys_role_menu` VALUES (101, 3023);
INSERT INTO `sys_role_menu` VALUES (101, 3024);
INSERT INTO `sys_role_menu` VALUES (101, 3025);
INSERT INTO `sys_role_menu` VALUES (101, 3026);
INSERT INTO `sys_role_menu` VALUES (101, 3027);
INSERT INTO `sys_role_menu` VALUES (101, 3028);
INSERT INTO `sys_role_menu` VALUES (101, 3029);
INSERT INTO `sys_role_menu` VALUES (101, 3030);
INSERT INTO `sys_role_menu` VALUES (101, 3031);
INSERT INTO `sys_role_menu` VALUES (101, 3032);
INSERT INTO `sys_role_menu` VALUES (101, 3033);
INSERT INTO `sys_role_menu` VALUES (101, 3034);
INSERT INTO `sys_role_menu` VALUES (101, 3035);
INSERT INTO `sys_role_menu` VALUES (101, 3036);
INSERT INTO `sys_role_menu` VALUES (101, 3037);
INSERT INTO `sys_role_menu` VALUES (101, 3038);
INSERT INTO `sys_role_menu` VALUES (101, 3039);
INSERT INTO `sys_role_menu` VALUES (101, 3040);
INSERT INTO `sys_role_menu` VALUES (101, 3041);
INSERT INTO `sys_role_menu` VALUES (101, 3042);
INSERT INTO `sys_role_menu` VALUES (101, 3043);
INSERT INTO `sys_role_menu` VALUES (101, 3044);
INSERT INTO `sys_role_menu` VALUES (101, 3045);
INSERT INTO `sys_role_menu` VALUES (101, 3046);
INSERT INTO `sys_role_menu` VALUES (101, 3047);
INSERT INTO `sys_role_menu` VALUES (101, 3048);
INSERT INTO `sys_role_menu` VALUES (101, 3049);
INSERT INTO `sys_role_menu` VALUES (101, 3050);
INSERT INTO `sys_role_menu` VALUES (101, 3051);
INSERT INTO `sys_role_menu` VALUES (101, 3052);
INSERT INTO `sys_role_menu` VALUES (101, 3053);
INSERT INTO `sys_role_menu` VALUES (101, 3054);
INSERT INTO `sys_role_menu` VALUES (101, 3055);
INSERT INTO `sys_role_menu` VALUES (101, 3056);
INSERT INTO `sys_role_menu` VALUES (101, 3057);
INSERT INTO `sys_role_menu` VALUES (101, 3058);
INSERT INTO `sys_role_menu` VALUES (101, 3059);
INSERT INTO `sys_role_menu` VALUES (101, 3060);
INSERT INTO `sys_role_menu` VALUES (101, 3061);
INSERT INTO `sys_role_menu` VALUES (101, 3062);
INSERT INTO `sys_role_menu` VALUES (101, 3063);
INSERT INTO `sys_role_menu` VALUES (101, 3064);
INSERT INTO `sys_role_menu` VALUES (101, 3065);
INSERT INTO `sys_role_menu` VALUES (101, 3066);
INSERT INTO `sys_role_menu` VALUES (101, 3067);
INSERT INTO `sys_role_menu` VALUES (101, 3068);
INSERT INTO `sys_role_menu` VALUES (101, 3069);
INSERT INTO `sys_role_menu` VALUES (101, 3070);
INSERT INTO `sys_role_menu` VALUES (101, 3071);
INSERT INTO `sys_role_menu` VALUES (101, 3072);
INSERT INTO `sys_role_menu` VALUES (101, 3073);
INSERT INTO `sys_role_menu` VALUES (101, 3074);
INSERT INTO `sys_role_menu` VALUES (101, 3075);
INSERT INTO `sys_role_menu` VALUES (101, 3076);
INSERT INTO `sys_role_menu` VALUES (101, 3077);
INSERT INTO `sys_role_menu` VALUES (101, 3078);
INSERT INTO `sys_role_menu` VALUES (101, 3079);
INSERT INTO `sys_role_menu` VALUES (101, 3080);
INSERT INTO `sys_role_menu` VALUES (101, 3081);
INSERT INTO `sys_role_menu` VALUES (101, 3082);
INSERT INTO `sys_role_menu` VALUES (101, 3083);
INSERT INTO `sys_role_menu` VALUES (101, 3084);
INSERT INTO `sys_role_menu` VALUES (101, 3085);
INSERT INTO `sys_role_menu` VALUES (101, 3086);
INSERT INTO `sys_role_menu` VALUES (101, 3087);
INSERT INTO `sys_role_menu` VALUES (101, 3088);
INSERT INTO `sys_role_menu` VALUES (101, 3089);
INSERT INTO `sys_role_menu` VALUES (101, 3090);
INSERT INTO `sys_role_menu` VALUES (101, 3091);
INSERT INTO `sys_role_menu` VALUES (101, 3092);
INSERT INTO `sys_role_menu` VALUES (101, 3093);
INSERT INTO `sys_role_menu` VALUES (101, 3094);
INSERT INTO `sys_role_menu` VALUES (101, 3095);
INSERT INTO `sys_role_menu` VALUES (101, 3096);
INSERT INTO `sys_role_menu` VALUES (101, 3097);
INSERT INTO `sys_role_menu` VALUES (101, 3098);
INSERT INTO `sys_role_menu` VALUES (101, 3099);
INSERT INTO `sys_role_menu` VALUES (101, 3100);
INSERT INTO `sys_role_menu` VALUES (101, 3101);
INSERT INTO `sys_role_menu` VALUES (101, 3102);
INSERT INTO `sys_role_menu` VALUES (101, 3103);
INSERT INTO `sys_role_menu` VALUES (101, 3104);
INSERT INTO `sys_role_menu` VALUES (101, 3105);
INSERT INTO `sys_role_menu` VALUES (101, 3106);
INSERT INTO `sys_role_menu` VALUES (101, 3107);
INSERT INTO `sys_role_menu` VALUES (101, 3108);
INSERT INTO `sys_role_menu` VALUES (101, 3109);
INSERT INTO `sys_role_menu` VALUES (101, 3110);
INSERT INTO `sys_role_menu` VALUES (101, 3111);
INSERT INTO `sys_role_menu` VALUES (101, 3112);
INSERT INTO `sys_role_menu` VALUES (101, 3113);
INSERT INTO `sys_role_menu` VALUES (101, 3114);
INSERT INTO `sys_role_menu` VALUES (101, 3115);
INSERT INTO `sys_role_menu` VALUES (101, 3116);
INSERT INTO `sys_role_menu` VALUES (101, 3117);
INSERT INTO `sys_role_menu` VALUES (101, 3118);
INSERT INTO `sys_role_menu` VALUES (101, 3119);
INSERT INTO `sys_role_menu` VALUES (101, 3120);
INSERT INTO `sys_role_menu` VALUES (101, 3121);
INSERT INTO `sys_role_menu` VALUES (101, 3122);
INSERT INTO `sys_role_menu` VALUES (101, 3123);
INSERT INTO `sys_role_menu` VALUES (101, 3124);
INSERT INTO `sys_role_menu` VALUES (101, 3125);
INSERT INTO `sys_role_menu` VALUES (101, 3126);
INSERT INTO `sys_role_menu` VALUES (101, 3127);
INSERT INTO `sys_role_menu` VALUES (101, 3128);
INSERT INTO `sys_role_menu` VALUES (102, 1);
INSERT INTO `sys_role_menu` VALUES (102, 100);
INSERT INTO `sys_role_menu` VALUES (102, 103);
INSERT INTO `sys_role_menu` VALUES (102, 104);
INSERT INTO `sys_role_menu` VALUES (102, 1000);
INSERT INTO `sys_role_menu` VALUES (102, 1001);
INSERT INTO `sys_role_menu` VALUES (102, 1002);
INSERT INTO `sys_role_menu` VALUES (102, 1003);
INSERT INTO `sys_role_menu` VALUES (102, 1004);
INSERT INTO `sys_role_menu` VALUES (102, 1005);
INSERT INTO `sys_role_menu` VALUES (102, 1006);
INSERT INTO `sys_role_menu` VALUES (102, 1016);
INSERT INTO `sys_role_menu` VALUES (102, 1017);
INSERT INTO `sys_role_menu` VALUES (102, 1018);
INSERT INTO `sys_role_menu` VALUES (102, 1019);
INSERT INTO `sys_role_menu` VALUES (102, 1020);
INSERT INTO `sys_role_menu` VALUES (102, 1021);
INSERT INTO `sys_role_menu` VALUES (102, 1022);
INSERT INTO `sys_role_menu` VALUES (102, 1023);
INSERT INTO `sys_role_menu` VALUES (102, 1024);
INSERT INTO `sys_role_menu` VALUES (102, 2000);
INSERT INTO `sys_role_menu` VALUES (102, 2004);
INSERT INTO `sys_role_menu` VALUES (102, 2006);
INSERT INTO `sys_role_menu` VALUES (102, 2007);
INSERT INTO `sys_role_menu` VALUES (102, 2010);
INSERT INTO `sys_role_menu` VALUES (102, 2011);
INSERT INTO `sys_role_menu` VALUES (102, 2012);
INSERT INTO `sys_role_menu` VALUES (102, 2013);
INSERT INTO `sys_role_menu` VALUES (102, 2014);
INSERT INTO `sys_role_menu` VALUES (102, 2015);
INSERT INTO `sys_role_menu` VALUES (102, 2100);
INSERT INTO `sys_role_menu` VALUES (102, 2102);
INSERT INTO `sys_role_menu` VALUES (102, 2103);
INSERT INTO `sys_role_menu` VALUES (102, 2200);
INSERT INTO `sys_role_menu` VALUES (102, 2201);
INSERT INTO `sys_role_menu` VALUES (102, 2202);
INSERT INTO `sys_role_menu` VALUES (102, 2203);
INSERT INTO `sys_role_menu` VALUES (102, 2204);
INSERT INTO `sys_role_menu` VALUES (102, 2205);
INSERT INTO `sys_role_menu` VALUES (102, 2206);
INSERT INTO `sys_role_menu` VALUES (102, 2300);
INSERT INTO `sys_role_menu` VALUES (102, 2301);
INSERT INTO `sys_role_menu` VALUES (102, 2302);
INSERT INTO `sys_role_menu` VALUES (102, 2303);
INSERT INTO `sys_role_menu` VALUES (102, 2304);
INSERT INTO `sys_role_menu` VALUES (102, 3016);
INSERT INTO `sys_role_menu` VALUES (102, 3017);
INSERT INTO `sys_role_menu` VALUES (102, 3018);
INSERT INTO `sys_role_menu` VALUES (102, 3019);
INSERT INTO `sys_role_menu` VALUES (102, 3020);
INSERT INTO `sys_role_menu` VALUES (102, 3026);
INSERT INTO `sys_role_menu` VALUES (102, 3027);
INSERT INTO `sys_role_menu` VALUES (102, 3028);
INSERT INTO `sys_role_menu` VALUES (102, 3029);
INSERT INTO `sys_role_menu` VALUES (102, 3030);
INSERT INTO `sys_role_menu` VALUES (102, 3031);
INSERT INTO `sys_role_menu` VALUES (102, 3032);
INSERT INTO `sys_role_menu` VALUES (102, 3033);
INSERT INTO `sys_role_menu` VALUES (102, 3034);
INSERT INTO `sys_role_menu` VALUES (102, 3035);
INSERT INTO `sys_role_menu` VALUES (102, 3041);
INSERT INTO `sys_role_menu` VALUES (102, 3042);
INSERT INTO `sys_role_menu` VALUES (102, 3043);
INSERT INTO `sys_role_menu` VALUES (102, 3044);
INSERT INTO `sys_role_menu` VALUES (102, 3045);
INSERT INTO `sys_role_menu` VALUES (102, 3046);
INSERT INTO `sys_role_menu` VALUES (102, 3047);
INSERT INTO `sys_role_menu` VALUES (102, 3048);
INSERT INTO `sys_role_menu` VALUES (102, 3049);
INSERT INTO `sys_role_menu` VALUES (102, 3050);
INSERT INTO `sys_role_menu` VALUES (102, 3061);
INSERT INTO `sys_role_menu` VALUES (102, 3062);
INSERT INTO `sys_role_menu` VALUES (102, 3063);
INSERT INTO `sys_role_menu` VALUES (102, 3064);
INSERT INTO `sys_role_menu` VALUES (102, 3065);
INSERT INTO `sys_role_menu` VALUES (102, 3066);
INSERT INTO `sys_role_menu` VALUES (102, 3067);
INSERT INTO `sys_role_menu` VALUES (102, 3068);
INSERT INTO `sys_role_menu` VALUES (102, 3069);
INSERT INTO `sys_role_menu` VALUES (102, 3070);
INSERT INTO `sys_role_menu` VALUES (102, 3071);
INSERT INTO `sys_role_menu` VALUES (102, 3072);
INSERT INTO `sys_role_menu` VALUES (102, 3073);
INSERT INTO `sys_role_menu` VALUES (102, 3074);
INSERT INTO `sys_role_menu` VALUES (102, 3075);
INSERT INTO `sys_role_menu` VALUES (102, 3076);
INSERT INTO `sys_role_menu` VALUES (102, 3077);
INSERT INTO `sys_role_menu` VALUES (102, 3078);
INSERT INTO `sys_role_menu` VALUES (102, 3079);
INSERT INTO `sys_role_menu` VALUES (102, 3080);
INSERT INTO `sys_role_menu` VALUES (102, 3081);
INSERT INTO `sys_role_menu` VALUES (102, 3082);
INSERT INTO `sys_role_menu` VALUES (102, 3083);
INSERT INTO `sys_role_menu` VALUES (102, 3084);
INSERT INTO `sys_role_menu` VALUES (102, 3085);
INSERT INTO `sys_role_menu` VALUES (102, 3086);
INSERT INTO `sys_role_menu` VALUES (102, 3087);
INSERT INTO `sys_role_menu` VALUES (102, 3088);
INSERT INTO `sys_role_menu` VALUES (102, 3089);
INSERT INTO `sys_role_menu` VALUES (102, 3090);
INSERT INTO `sys_role_menu` VALUES (102, 3091);
INSERT INTO `sys_role_menu` VALUES (102, 3092);
INSERT INTO `sys_role_menu` VALUES (102, 3093);
INSERT INTO `sys_role_menu` VALUES (102, 3094);
INSERT INTO `sys_role_menu` VALUES (102, 3095);
INSERT INTO `sys_role_menu` VALUES (102, 3096);
INSERT INTO `sys_role_menu` VALUES (102, 3097);
INSERT INTO `sys_role_menu` VALUES (102, 3098);
INSERT INTO `sys_role_menu` VALUES (102, 3099);
INSERT INTO `sys_role_menu` VALUES (102, 3100);
INSERT INTO `sys_role_menu` VALUES (102, 3101);
INSERT INTO `sys_role_menu` VALUES (102, 3102);
INSERT INTO `sys_role_menu` VALUES (102, 3103);
INSERT INTO `sys_role_menu` VALUES (102, 3104);
INSERT INTO `sys_role_menu` VALUES (102, 3105);
INSERT INTO `sys_role_menu` VALUES (102, 3106);
INSERT INTO `sys_role_menu` VALUES (102, 3107);
INSERT INTO `sys_role_menu` VALUES (102, 3108);
INSERT INTO `sys_role_menu` VALUES (102, 3109);
INSERT INTO `sys_role_menu` VALUES (102, 3110);
INSERT INTO `sys_role_menu` VALUES (102, 3111);
INSERT INTO `sys_role_menu` VALUES (102, 3112);
INSERT INTO `sys_role_menu` VALUES (102, 3113);
INSERT INTO `sys_role_menu` VALUES (102, 3114);
INSERT INTO `sys_role_menu` VALUES (102, 3115);
INSERT INTO `sys_role_menu` VALUES (102, 3116);
INSERT INTO `sys_role_menu` VALUES (102, 3117);
INSERT INTO `sys_role_menu` VALUES (102, 3118);
INSERT INTO `sys_role_menu` VALUES (102, 3119);
INSERT INTO `sys_role_menu` VALUES (102, 3120);
INSERT INTO `sys_role_menu` VALUES (102, 3121);
INSERT INTO `sys_role_menu` VALUES (102, 3122);
INSERT INTO `sys_role_menu` VALUES (102, 3123);
INSERT INTO `sys_role_menu` VALUES (102, 3124);
INSERT INTO `sys_role_menu` VALUES (102, 3125);
INSERT INTO `sys_role_menu` VALUES (102, 3126);
INSERT INTO `sys_role_menu` VALUES (102, 3127);
INSERT INTO `sys_role_menu` VALUES (102, 3128);
INSERT INTO `sys_role_menu` VALUES (105, 2000);
INSERT INTO `sys_role_menu` VALUES (105, 2004);
INSERT INTO `sys_role_menu` VALUES (105, 2010);
INSERT INTO `sys_role_menu` VALUES (105, 2012);
INSERT INTO `sys_role_menu` VALUES (105, 2013);
INSERT INTO `sys_role_menu` VALUES (105, 2015);
INSERT INTO `sys_role_menu` VALUES (105, 2100);
INSERT INTO `sys_role_menu` VALUES (105, 2102);
INSERT INTO `sys_role_menu` VALUES (105, 2103);
INSERT INTO `sys_role_menu` VALUES (105, 3016);
INSERT INTO `sys_role_menu` VALUES (105, 3041);
INSERT INTO `sys_role_menu` VALUES (105, 3046);
INSERT INTO `sys_role_menu` VALUES (105, 3061);
INSERT INTO `sys_role_menu` VALUES (105, 3066);
INSERT INTO `sys_role_menu` VALUES (105, 3121);
INSERT INTO `sys_role_menu` VALUES (105, 3126);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `company_id` bigint NULL DEFAULT 0 COMMENT '所属推广商公司ID（0=平台）',
  `account_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'COMPANY' COMMENT '账号类型（PLATFORM=平台 COMPANY=推广商）',
  `last_device_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最近登录设备标识',
  `login_limit_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'SINGLE' COMMENT '登录限制（SINGLE=单端 MULTI=多端）',
  `source_user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统用户ID（数据迁移用）',
  `orgid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧系统推广商ID（兼容迁移）',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-05-16 09:57:11', '2026-05-07 10:37:49', 'admin', '2026-05-07 10:37:49', '', NULL, '管理员', 0, 'PLATFORM', NULL, 'SINGLE', NULL, NULL);
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-05-07 10:37:49', '2026-05-07 10:37:49', 'admin', '2026-05-07 10:37:49', '', NULL, '测试员', 0, 'COMPANY', NULL, 'SINGLE', NULL, NULL);
INSERT INTO `sys_user` VALUES (100, 200, 'test_boss1', 'test_boss1', '00', '', '', '0', '', '$2a$10$lP3pIKjyySNdjhRCrXBKtegLLrP0qa0y/ZDFjRhjLpNUmhUCYsJ5e', '0', '0', '127.0.0.1', '2026-05-16 09:58:48', NULL, 'admin', '2026-05-10 15:48:13', '', NULL, NULL, 200, 'PLATFORM', NULL, 'SINGLE', NULL, NULL);
INSERT INTO `sys_user` VALUES (101, 200, 'test_rep1', 'test_rep1', '00', '', '', '0', '', '$2a$10$e6gCb12ejXhBD65yufejLOYxTo.yjgZqCVF8ls3V9N0AzIBmg7x1q', '0', '0', '', NULL, NULL, 'admin', '2026-05-10 15:48:42', '', NULL, NULL, 200, 'PLATFORM', NULL, 'SINGLE', NULL, NULL);
INSERT INTO `sys_user` VALUES (102, 201, 'test_boss2', 'test_boss2', '00', '', '', '0', '', '$2a$10$fdU1Qdzpe8SgLoK9OYtCPuhKiRZb6rPbdmk/yLpKXry2uOjQdCJ06', '0', '0', '', NULL, NULL, 'admin', '2026-05-10 15:49:14', '', NULL, NULL, 201, 'PLATFORM', NULL, 'SINGLE', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);
INSERT INTO `sys_user_post` VALUES (100, 10);
INSERT INTO `sys_user_post` VALUES (101, 13);
INSERT INTO `sys_user_post` VALUES (102, 10);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (100, 101);
INSERT INTO `sys_user_role` VALUES (101, 105);
INSERT INTO `sys_user_role` VALUES (102, 101);

SET FOREIGN_KEY_CHECKS = 1;
