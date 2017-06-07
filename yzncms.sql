/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50553
Source Host           : localhost:3306
Source Database       : yzncms

Target Server Type    : MYSQL
Target Server Version : 50553
File Encoding         : 65001

Date: 2017-06-06 13:51:10
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `yzn_action`
-- ----------------------------
DROP TABLE IF EXISTS `yzn_action`;
CREATE TABLE `yzn_action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` char(30) NOT NULL DEFAULT '' COMMENT '行为唯一标识',
  `title` char(80) NOT NULL DEFAULT '' COMMENT '行为说明',
  `remark` char(140) NOT NULL DEFAULT '' COMMENT '行为描述',
  `rule` text NOT NULL COMMENT '行为规则',
  `log` text NOT NULL COMMENT '日志规则',
  `type` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '类型',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统行为表';

-- ----------------------------
-- Records of yzn_action
-- ----------------------------
INSERT INTO `yzn_action` VALUES ('1', 'user_login', '用户登录', '积分+10，每天一次', 'table:member|field:score|condition:uid={$self} AND status>-1|rule:score+10|cycle:24|max:1;', '[user|get_username]在[time|time_format]登录了后台', '1', '1', '1387181220');
INSERT INTO `yzn_action` VALUES ('2', 'add_article', '发布文章', '积分+5，每天上限5次', 'table:member|field:score|condition:uid={$self}|rule:score+5|cycle:24|max:5', '', '2', '0', '1380173180');
INSERT INTO `yzn_action` VALUES ('3', 'review', '评论', '评论积分+1，无限制', 'table:member|field:score|condition:uid={$self}|rule:score+1', '', '2', '1', '1383285646');
INSERT INTO `yzn_action` VALUES ('4', 'add_document', '发表文档', '积分+10，每天上限1次', 'table:member|field:score|condition:uid={$self}|rule:score+10|cycle:24|max:1', '[user|get_username]在[time|time_format]发表了一篇文章。\n表[model]，记录编号[record]。', '1', '1', '1493877089');
INSERT INTO `yzn_action` VALUES ('5', 'add_document_topic', '发表讨论', '积分+5，每天上限10次', 'table:member|field:score|condition:uid={$self}|rule:score+5|cycle:24|max:10', '', '2', '0', '1383285551');
INSERT INTO `yzn_action` VALUES ('6', 'update_config', '更新配置', '新增或修改或删除配置', '', '', '1', '1', '1383294988');
INSERT INTO `yzn_action` VALUES ('7', 'update_model', '更新模型', '新增或修改模型', '', '', '1', '1', '1383295057');
INSERT INTO `yzn_action` VALUES ('8', 'update_attribute', '更新属性', '新增或更新或删除属性', '', '', '1', '1', '1383295963');
INSERT INTO `yzn_action` VALUES ('9', 'update_channel', '更新导航', '新增或修改或删除导航', '', '', '1', '1', '1383296301');
INSERT INTO `yzn_action` VALUES ('10', 'update_menu', '更新菜单', '新增或修改或删除菜单', '', '', '1', '1', '1383296392');
INSERT INTO `yzn_action` VALUES ('11', 'update_category', '更新分类', '新增或修改或删除分类', '', '', '1', '1', '1383296765');

-- ----------------------------
-- Table structure for `yzn_action_log`
-- ----------------------------
DROP TABLE IF EXISTS `yzn_action_log`;
CREATE TABLE `yzn_action_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `action_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '行为id',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '执行用户id',
  `action_ip` bigint(20) NOT NULL COMMENT '执行行为者ip',
  `model` varchar(50) NOT NULL DEFAULT '' COMMENT '触发行为的表',
  `record_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '触发行为的数据id',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '日志备注',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '执行行为的时间',
  PRIMARY KEY (`id`),
  KEY `action_ip_ix` (`action_ip`),
  KEY `action_id_ix` (`action_id`),
  KEY `user_id_ix` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='行为日志表';

-- ----------------------------
-- Records of yzn_action_log
-- ----------------------------
INSERT INTO `yzn_action_log` VALUES ('35', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-18 12:26登录了后台', '1495081597');
INSERT INTO `yzn_action_log` VALUES ('34', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-18 08:06登录了后台', '1495065962');
INSERT INTO `yzn_action_log` VALUES ('69', '1', '1', '2130706433', 'member', '1', 'admin在2017-06-06 12:57登录了后台', '1496725042');
INSERT INTO `yzn_action_log` VALUES ('68', '1', '1', '2130706433', 'member', '1', 'admin在2017-06-06 10:11登录了后台', '1496715109');
INSERT INTO `yzn_action_log` VALUES ('67', '1', '1', '2130706433', 'member', '1', 'admin在2017-06-06 10:01登录了后台', '1496714464');
INSERT INTO `yzn_action_log` VALUES ('66', '1', '2', '2130706433', 'member', '2', 'ken678在2017-06-06 10:00登录了后台', '1496714402');
INSERT INTO `yzn_action_log` VALUES ('65', '1', '1', '2130706433', 'member', '1', 'admin在2017-06-06 09:56登录了后台', '1496714179');
INSERT INTO `yzn_action_log` VALUES ('64', '1', '1', '2130706433', 'member', '1', 'admin在2017-06-06 09:09登录了后台', '1496711353');
INSERT INTO `yzn_action_log` VALUES ('63', '1', '1', '2130706433', 'member', '1', 'admin在2017-06-05 17:49登录了后台', '1496656198');
INSERT INTO `yzn_action_log` VALUES ('32', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-15 17:31登录了后台', '1494840674');
INSERT INTO `yzn_action_log` VALUES ('33', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-17 16:56登录了后台', '1495011414');
INSERT INTO `yzn_action_log` VALUES ('36', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-18 16:30登录了后台', '1495096205');
INSERT INTO `yzn_action_log` VALUES ('37', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-19 08:46登录了后台', '1495154788');
INSERT INTO `yzn_action_log` VALUES ('38', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-22 11:07登录了后台', '1495422456');
INSERT INTO `yzn_action_log` VALUES ('39', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-22 14:13登录了后台', '1495433633');
INSERT INTO `yzn_action_log` VALUES ('40', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-22 16:54登录了后台', '1495443254');
INSERT INTO `yzn_action_log` VALUES ('41', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-23 08:44登录了后台', '1495500256');
INSERT INTO `yzn_action_log` VALUES ('42', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-23 10:19登录了后台', '1495505986');
INSERT INTO `yzn_action_log` VALUES ('43', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-23 10:50登录了后台', '1495507826');
INSERT INTO `yzn_action_log` VALUES ('44', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-23 11:33登录了后台', '1495510432');
INSERT INTO `yzn_action_log` VALUES ('45', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-23 17:28登录了后台', '1495531714');
INSERT INTO `yzn_action_log` VALUES ('46', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-24 08:24登录了后台', '1495585442');
INSERT INTO `yzn_action_log` VALUES ('47', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-24 17:32登录了后台', '1495618327');
INSERT INTO `yzn_action_log` VALUES ('48', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-25 08:03登录了后台', '1495670624');
INSERT INTO `yzn_action_log` VALUES ('49', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-26 11:04登录了后台', '1495767859');
INSERT INTO `yzn_action_log` VALUES ('50', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-26 16:52登录了后台', '1495788759');
INSERT INTO `yzn_action_log` VALUES ('53', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-27 09:06登录了后台', '1495847205');
INSERT INTO `yzn_action_log` VALUES ('55', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-27 14:56登录了后台', '1495868189');
INSERT INTO `yzn_action_log` VALUES ('56', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-27 17:36登录了后台', '1495877769');
INSERT INTO `yzn_action_log` VALUES ('57', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-31 11:08登录了后台', '1496200085');
INSERT INTO `yzn_action_log` VALUES ('58', '1', '1', '2130706433', 'member', '1', 'admin在2017-05-31 11:33登录了后台', '1496201600');
INSERT INTO `yzn_action_log` VALUES ('59', '1', '1', '2130706433', 'member', '1', 'admin在2017-06-01 11:41登录了后台', '1496288460');
INSERT INTO `yzn_action_log` VALUES ('60', '1', '1', '2130706433', 'member', '1', 'admin在2017-06-01 13:37登录了后台', '1496295424');
INSERT INTO `yzn_action_log` VALUES ('61', '1', '1', '2130706433', 'member', '1', 'admin在2017-06-02 17:17登录了后台', '1496395021');
INSERT INTO `yzn_action_log` VALUES ('62', '1', '1', '2130706433', 'member', '1', 'admin在2017-06-05 17:00登录了后台', '1496653241');

-- ----------------------------
-- Table structure for `yzn_admin`
-- ----------------------------
DROP TABLE IF EXISTS `yzn_admin`;
CREATE TABLE `yzn_admin` (
  `userid` smallint(3) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(20) DEFAULT NULL COMMENT '管理账号',
  `password` varchar(40) DEFAULT NULL COMMENT '管理密码',
  `roleid` tinyint(4) unsigned DEFAULT '0',
  `encrypt` varchar(6) DEFAULT NULL COMMENT '加密因子',
  `nickname` char(16) NOT NULL COMMENT '昵称',
  `last_login_time` int(10) unsigned DEFAULT '0' COMMENT '最后登录时间',
  `last_login_ip` bigint(20) unsigned DEFAULT '0' COMMENT '最后登录IP',
  `email` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`userid`),
  KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='管理员表';

-- ----------------------------
-- Records of yzn_admin
-- ----------------------------
INSERT INTO `yzn_admin` VALUES ('1', 'admin', '29b2d14df82d7db68dc31faa9af3e7fee7499546', '1', 'djvlfg', '御宅男', '1496725042', '2130706433', '530765310@qq.com');
INSERT INTO `yzn_admin` VALUES ('2', 'ken678', 'abbcdc6e46d13db19e5b7e64ebcf44e625407165', '2', 'ILHWqH', '御宅男', '1496714402', '2130706433', '530765310@qq.com');

-- ----------------------------
-- Table structure for `yzn_auth_group`
-- ----------------------------
DROP TABLE IF EXISTS `yzn_auth_group`;
CREATE TABLE `yzn_auth_group` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户组id,自增主键',
  `module` varchar(20) NOT NULL COMMENT '用户组所属模块',
  `type` tinyint(4) NOT NULL COMMENT '组类型',
  `title` char(20) NOT NULL DEFAULT '' COMMENT '用户组中文名称',
  `description` varchar(80) NOT NULL DEFAULT '' COMMENT '描述信息',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '用户组状态：为1正常，为0禁用,-1为删除',
  `rules` varchar(500) NOT NULL DEFAULT '' COMMENT '用户组拥有的规则id，多个规则 , 隔开',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='权限组表';

-- ----------------------------
-- Records of yzn_auth_group
-- ----------------------------
INSERT INTO `yzn_auth_group` VALUES ('1', 'admin', '1', '超级管理员', '拥有所有权限', '1', '1,2,4,6,7,8,10,12');
INSERT INTO `yzn_auth_group` VALUES ('2', 'admin', '1', '测试用户', '部分低级权限', '1', '4,6,7');
INSERT INTO `yzn_auth_group` VALUES ('3', 'admin', '1', '121', '121', '1', '');

-- ----------------------------
-- Table structure for `yzn_auth_rule`
-- ----------------------------
DROP TABLE IF EXISTS `yzn_auth_rule`;
CREATE TABLE `yzn_auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '规则id,自增主键',
  `module` varchar(20) NOT NULL COMMENT '规则所属module',
  `type` tinyint(2) NOT NULL DEFAULT '1' COMMENT '1-url;2-主菜单',
  `name` char(80) NOT NULL DEFAULT '' COMMENT '规则唯一英文标识',
  `title` char(20) NOT NULL DEFAULT '' COMMENT '规则中文描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否有效(0:无效,1:有效)',
  `condition` varchar(300) NOT NULL DEFAULT '' COMMENT '规则附加条件',
  PRIMARY KEY (`id`),
  KEY `module` (`module`,`status`,`type`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='规则表';

-- ----------------------------
-- Records of yzn_auth_rule
-- ----------------------------
INSERT INTO `yzn_auth_rule` VALUES ('1', 'Admin', '1', 'Admin/Setting/index', '设置', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('2', 'Admin', '1', 'Admin/Manager/index', '管理员', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('3', 'Admin', '1', 'Admin/Manager/add', '添加管理员', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('4', 'Admin', '1', 'Admin/database/index', '应用', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('5', 'Admin', '1', 'Admin/database/repair_list', '数据库恢复', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('6', 'Admin', '2', 'Admin/Setting/index', '设置', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('7', 'Admin', '2', 'Admin/Content/index', '内容', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('8', 'Admin', '1', 'Admin/Config/index', '站点配置', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('9', 'Admin', '1', 'Admin/Manager/edit', '编辑管理员', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('10', 'Admin', '1', 'Admin/AuthManager/index', '权限设置', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('11', 'Admin', '1', 'Admin/Config/extend', '扩展配置', '1', '');
INSERT INTO `yzn_auth_rule` VALUES ('12', 'Admin', '1', 'Admin/Action/actionlog', '操作日志', '1', '');

-- ----------------------------
-- Table structure for `yzn_config`
-- ----------------------------
DROP TABLE IF EXISTS `yzn_config`;
CREATE TABLE `yzn_config` (
  `id` smallint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '配置名称',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '配置说明',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '配置分组',
  `value` text NOT NULL COMMENT '配置值',
  `sort` smallint(3) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='网站配置表';

-- ----------------------------
-- Records of yzn_config
-- ----------------------------
INSERT INTO `yzn_config` VALUES ('1', 'site_title', '网站标题', '1', 'Yzncms内容管理框架 - Powered by Yzncms', '1');
INSERT INTO `yzn_config` VALUES ('2', 'site_keyword', '网站关键字', '1', 'ThinkPHP,tp5.0,yzncms,内容管理系统', '2');
INSERT INTO `yzn_config` VALUES ('3', 'site_description', '网站描述', '1', 'Yzncms内容管理框架,一套简单，易用，面向开发者的内容管理框,采用TP5.0框架开发', '3');
INSERT INTO `yzn_config` VALUES ('4', 'site_name', '网站名称', '1', 'Yzncms内容管理框架', '0');
INSERT INTO `yzn_config` VALUES ('5', 'icp', 'icp', '2', '苏ICP备15017030', '0');
INSERT INTO `yzn_config` VALUES ('6', 'close', '关闭站点', '2', '1', '0');

-- ----------------------------
-- Table structure for `yzn_config_field`
-- ----------------------------
DROP TABLE IF EXISTS `yzn_config_field`;
CREATE TABLE `yzn_config_field` (
  `fid` smallint(6) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `fieldname` varchar(30) NOT NULL DEFAULT '' COMMENT '字段名',
  `type` varchar(10) NOT NULL DEFAULT '' COMMENT '配置表单类型',
  `setting` mediumtext COMMENT '其他设置',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`fid`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='网站扩展配置表';

-- ----------------------------
-- Records of yzn_config_field
-- ----------------------------
INSERT INTO `yzn_config_field` VALUES ('1', 'icp', 'input', 'a:4:{s:5:\"title\";s:3:\"icp\";s:4:\"tips\";s:9:\"备案号\";s:5:\"style\";s:0:\"\";s:6:\"option\";s:24:\"选项名称1|选项值1\";}', '1492738742');
INSERT INTO `yzn_config_field` VALUES ('2', 'close', 'select', 'a:4:{s:5:\"title\";s:12:\"关闭站点\";s:4:\"tips\";s:0:\"\";s:5:\"style\";s:0:\"\";s:6:\"option\";a:2:{i:0;a:2:{s:5:\"title\";s:6:\"关闭\";s:5:\"value\";s:2:\"0\r\";}i:1;a:2:{s:5:\"title\";s:6:\"开启\";s:5:\"value\";s:1:\"1\";}}}', '1492741857');

-- ----------------------------
-- Table structure for `yzn_menu`
-- ----------------------------
DROP TABLE IF EXISTS `yzn_menu`;
CREATE TABLE `yzn_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '标题',
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上级分类ID',
  `app` char(20) NOT NULL DEFAULT '' COMMENT '应用标识',
  `controller` char(20) NOT NULL DEFAULT '' COMMENT '控制器标识',
  `action` char(20) NOT NULL DEFAULT '' COMMENT '方法标识',
  `parameter` char(255) NOT NULL DEFAULT '' COMMENT '附加参数',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态',
  `tip` varchar(255) NOT NULL DEFAULT '' COMMENT '提示',
  `is_dev` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否开发者可见',
  `listorder` smallint(6) unsigned NOT NULL DEFAULT '0' COMMENT '排序ID',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='后台菜单表';

-- ----------------------------
-- Records of yzn_menu
-- ----------------------------
INSERT INTO `yzn_menu` VALUES ('1', '设置', '0', 'Admin', 'Setting', 'index', '', '1', '', '0', '1');
INSERT INTO `yzn_menu` VALUES ('2', '内容', '0', 'Admin', 'Content', 'index', '', '1', '', '0', '1');
INSERT INTO `yzn_menu` VALUES ('5', '站点配置', '10', 'Admin', 'Config', 'index', '', '1', '', '0', '1');
INSERT INTO `yzn_menu` VALUES ('6', '管理员', '1', 'Admin', 'Manager', 'index', '', '1', '', '0', '1');
INSERT INTO `yzn_menu` VALUES ('9', '扩展配置', '5', 'Admin', 'Config', 'extend', '', '1', '', '0', '5');
INSERT INTO `yzn_menu` VALUES ('10', '设置', '1', 'Admin', 'Setting', 'index', '', '1', '', '0', '0');
INSERT INTO `yzn_menu` VALUES ('12', '管理员管理', '6', 'Admin', 'Manager', 'index', '', '1', '', '0', '0');
INSERT INTO `yzn_menu` VALUES ('13', '添加管理员', '12', 'Admin', 'Manager', 'add', '', '0', '', '0', '0');
INSERT INTO `yzn_menu` VALUES ('14', '编辑管理员', '12', 'Admin', 'Manager', 'edit', '', '0', '', '0', '1');
INSERT INTO `yzn_menu` VALUES ('15', '操作日志', '10', 'Admin', 'Action', 'actionlog', '', '1', '', '0', '10');
INSERT INTO `yzn_menu` VALUES ('16', '应用', '1', 'Admin', 'database', 'index', '', '1', '', '0', '3');
INSERT INTO `yzn_menu` VALUES ('17', '数据库备份', '16', 'Admin', 'database', 'index', '', '1', '', '0', '0');
INSERT INTO `yzn_menu` VALUES ('18', '数据库恢复', '17', 'Admin', 'database', 'repair_list', '', '1', '', '0', '0');
INSERT INTO `yzn_menu` VALUES ('19', '权限设置', '10', 'Admin', 'AuthManager', 'index', '', '1', '', '0', '3');