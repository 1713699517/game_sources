-- --------------------------------------------------------

--
-- 表的结构 `xyapi_app_debug`
--

DROP TABLE IF EXISTS `xyapi_app_debug`;
CREATE TABLE IF NOT EXISTS `xyapi_app_debug` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '留言id',
  `type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Debug类型 0:默认',
  `tag` char(40) NOT NULL DEFAULT '' COMMENT '错误标识',
  `subject` char(64) NOT NULL COMMENT '主题',
  `body` char(254) NOT NULL COMMENT '内容',
  `error` text NOT NULL COMMENT '错误细明',
  `count` int(10) unsigned NOT NULL COMMENT '提交(出错)次数',
  `state` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '0 未修复  1 已修复',
  `ip` char(40) NOT NULL COMMENT 'IP',
  `time_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_app_message`
--

DROP TABLE IF EXISTS `xyapi_app_message`;
CREATE TABLE IF NOT EXISTS `xyapi_app_message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '留言id',
  `cid` int(10) unsigned NOT NULL COMMENT '合作方id',
  `sid` int(10) unsigned NOT NULL COMMENT '服务器id',
  `uid` int(20) unsigned NOT NULL COMMENT '人物uid',
  `uname` char(64) NOT NULL COMMENT '角色名称',
  `title` char(50) NOT NULL COMMENT '留言标题',
  `content` char(254) NOT NULL COMMENT '留言内容',
  `post_time` int(10) unsigned NOT NULL COMMENT '发表时间',
  `ip` char(64) NOT NULL COMMENT '留言IP',
  `reply` char(254) NOT NULL COMMENT '回复内容',
  `reply_time` int(10) unsigned NOT NULL COMMENT '回复时间',
  `master_id` int(10) unsigned NOT NULL COMMENT '管理员id',
  `master_name` char(64) NOT NULL COMMENT '管理员名称',
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`),
  KEY `sid` (`sid`),
  KEY `post_time` (`post_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='留言信息';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_app_pay`
--

DROP TABLE IF EXISTS `xyapi_app_pay`;
CREATE TABLE IF NOT EXISTS `xyapi_app_pay` (
  `pid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `oid` char(128) NOT NULL COMMENT '订单编号(请保证唯一性)',
  `cid` int(10) unsigned NOT NULL COMMENT '合作方ID',
  `sid` int(10) unsigned NOT NULL COMMENT '所在服务器ID',
  `uuid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '玩家uuid',
  `uid` int(10) unsigned NOT NULL COMMENT '用户ID',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `account` char(64) NOT NULL COMMENT '用户帐号',
  `rmb_real` decimal(10,2) unsigned NOT NULL COMMENT '真实RMB',
  `rmb` decimal(10,1) unsigned NOT NULL COMMENT '充值金额(元宝)',
  `rmb_balance` decimal(10,1) unsigned NOT NULL COMMENT '余额(元宝)',
  `rmb_bind` decimal(10,1) unsigned NOT NULL COMMENT '游戏礼点',
  `rmb_bind_balance` decimal(10,1) unsigned NOT NULL COMMENT '礼点余额',
  `time_pay` int(10) unsigned NOT NULL COMMENT '充值时间',
  `time_last` int(10) unsigned NOT NULL COMMENT '最后更新时间',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '处理状态,格式：-1:失败,0:没处理,1成功',
  PRIMARY KEY (`pid`),
  UNIQUE KEY `oid` (`cid`,`oid`),
  KEY `uid` (`uid`),
  KEY `state` (`state`),
  KEY `acc` (`cid`,`account`),
  KEY `uuid` (`uuid`),
  KEY `time` (`time_pay`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_app_update`
--

DROP TABLE IF EXISTS `xyapi_app_update`;
CREATE TABLE IF NOT EXISTS `xyapi_app_update` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `cid` int(10) unsigned NOT NULL COMMENT '合作方ID',
  `title` char(254) NOT NULL COMMENT ' 日志标题',
  `content` text NOT NULL COMMENT '日志内容',
  `time_show` int(11) NOT NULL COMMENT '发布时间(添加当天)',
  `time_add` int(11) NOT NULL COMMENT '添加日志时间',
  `ip` char(40) NOT NULL COMMENT '添加人ip',
  `master_id` int(10) unsigned NOT NULL COMMENT '管理员id',
  `master_name` char(64) NOT NULL COMMENT '管理员名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='日志表';

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_app_manage`
--

DROP TABLE IF EXISTS `xyapi_app_manage`;
CREATE TABLE IF NOT EXISTS `xyapi_app_manage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `cid` int(10) unsigned NOT NULL COMMENT '合作方ID',
  `title` char(254) NOT NULL COMMENT ' 日志标题',
  `content` text NOT NULL COMMENT '日志内容',
  `time_show` int(11) NOT NULL COMMENT '发布时间(添加当天)',
  `time_add` int(11) NOT NULL COMMENT '添加日志时间',
  `ip` char(40) NOT NULL COMMENT '添加人ip',
  `master_id` int(10) unsigned NOT NULL COMMENT '管理员id',
  `master_name` char(64) NOT NULL COMMENT '管理员名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='日志表';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_coop`
--

DROP TABLE IF EXISTS `xyapi_coop`;
CREATE TABLE IF NOT EXISTS `xyapi_coop` (
  `cid` int(10) unsigned NOT NULL COMMENT '合作ID',
  `cname` char(64) NOT NULL COMMENT '平台名称',
  `ckey` char(32) NOT NULL DEFAULT '' COMMENT '32位加密码key',
  `ckey_lock` enum('true','false') NOT NULL DEFAULT 'false' COMMENT '是否锁定',
  `domain` char(64) NOT NULL DEFAULT '' COMMENT '游戏服域名',
  `fcm` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '防沉迷开关',
  `cf_gname` char(64) NOT NULL DEFAULT '' COMMENT '游戏平台的名称',
  `cf_cs_tel` char(64) NOT NULL DEFAULT '' COMMENT '客服电话',
  `cf_cs_email` char(64) NOT NULL DEFAULT '' COMMENT '客服Email',
  `cf_url_site` char(254) NOT NULL DEFAULT '' COMMENT '官网地址',
  `cf_url_upgrade` char(254) NOT NULL DEFAULT '' COMMENT '更新地址',
  `cf_url_login` char(254) NOT NULL DEFAULT '' COMMENT '登录地址',
  `cf_url_bbs` char(254) NOT NULL DEFAULT '' COMMENT 'BBS社区',
  `cf_url_pay` char(254) NOT NULL DEFAULT '' COMMENT '充值地址',
  `cf_url_help` char(254) NOT NULL DEFAULT '' COMMENT '帮助地址',
  `cf_url_fcm` char(254) NOT NULL DEFAULT '' COMMENT '解除反沉迷网址',
  `cf_fav_url` char(254) NOT NULL DEFAULT '' COMMENT '收藏URL',
  `cf_fav_title` char(128) NOT NULL DEFAULT '' COMMENT '收藏名称',
  `time_add` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开通时间',
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='运营商';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_coop_area`
--

DROP TABLE IF EXISTS `xyapi_coop_area`;
CREATE TABLE IF NOT EXISTS `xyapi_coop_area` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `cid` int(10) unsigned NOT NULL COMMENT '运营商Cid',
  `area_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT ' 所属大区 ',
  `area_name` char(32) NOT NULL DEFAULT '0' COMMENT ' 大区名称 ',
  `stat` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '是否开起加载统计(调试) 0:关 1:开',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_2` (`cid`,`area_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='所属大区';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_idc_fun`
--

DROP TABLE IF EXISTS `xyapi_idc_fun`;
CREATE TABLE IF NOT EXISTS `xyapi_idc_fun` (
  `fun_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '功能主机ID',
  `host_id` int(10) unsigned NOT NULL COMMENT '所在主机ID',
  `type` int(10) unsigned NOT NULL COMMENT '功能类型 1:游戏  2:MYSQL 3:MongoDB 4:资源 5:Web 6:备份',
  `fun_name` char(32) NOT NULL,
  `exts` text NOT NULL COMMENT '扩展参数',
  PRIMARY KEY (`fun_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='功能主机';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_idc_home`
--

DROP TABLE IF EXISTS `xyapi_idc_home`;
CREATE TABLE IF NOT EXISTS `xyapi_idc_home` (
  `home_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '机房ID',
  `home_key` char(16) NOT NULL COMMENT '标识',
  `home_name` char(32) NOT NULL COMMENT '机房名称',
  PRIMARY KEY (`home_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='机房名称';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_idc_hosts`
--

DROP TABLE IF EXISTS `xyapi_idc_hosts`;
CREATE TABLE IF NOT EXISTS `xyapi_idc_hosts` (
  `host_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主机ID',
  `host_name` char(32) NOT NULL COMMENT '主机名称',
  `home_id` int(10) unsigned NOT NULL COMMENT '所在机房',
  `ct_ip` char(40) NOT NULL DEFAULT '0.0.0.0' COMMENT '电信IP',
  `cu_ip` char(40) NOT NULL DEFAULT '0.0.0.0' COMMENT '联通IP',
  `cm_ip` char(40) NOT NULL DEFAULT '0.0.0.0' COMMENT '移动IP',
  `side_ip` char(40) NOT NULL DEFAULT '192.168.1.8' COMMENT '内网IP',
  `default_ip` enum('cu_ip','ct_ip','cm_ip') NOT NULL DEFAULT 'ct_ip',
  `state` int(10) unsigned NOT NULL DEFAULT '3' COMMENT '状态 0停服 1维护 2拥挤 3正常 4推荐',
  `domains` text NOT NULL,
  PRIMARY KEY (`host_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='主机';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_idc_hosts_domain`
--

DROP TABLE IF EXISTS `xyapi_idc_hosts_domain`;
CREATE TABLE IF NOT EXISTS `xyapi_idc_hosts_domain` (
  `domain` char(32) NOT NULL,
  `ip` char(15) NOT NULL,
  PRIMARY KEY (`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_serv`
--

DROP TABLE IF EXISTS `xyapi_serv`;
CREATE TABLE IF NOT EXISTS `xyapi_serv` (
  `sid` int(10) unsigned NOT NULL COMMENT '服务ID',
  `state` int(10) unsigned NOT NULL DEFAULT '3' COMMENT '状态 0停服 1维护 2拥挤 3正常 4推荐',
  `state_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后更新状态时间',
  `port` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '端口',
  `node` char(128) NOT NULL DEFAULT '' COMMENT '节点名称',
  `super_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '跨服战目标ID',
  `business` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '合区是否通商（交易,邮寄,市场）  0:不可交易   1:可以交易',
  `level_max` int(10) unsigned NOT NULL DEFAULT '70' COMMENT '本服上限等级',
  `merge_target` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '合服 0:独立服  n>0:n为目标服',
  `ver_id` int(10) unsigned NOT NULL COMMENT '版本ID',
  `host_id_web` int(10) unsigned NOT NULL COMMENT 'Web主机ID',
  `host_id_game` int(10) unsigned NOT NULL COMMENT '游戏主机ID',
  `host_id_mongo` int(10) unsigned NOT NULL COMMENT 'Mongo主机ID',
  `host_id_mysql` int(10) unsigned NOT NULL COMMENT 'MYSQl主机ID',
  `host_id_res` int(10) unsigned NOT NULL COMMENT '资源主机ID',
  `host_id_logs` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '日志服务器',
  `serv_name` char(32) NOT NULL,
  `work_day` char(10) NOT NULL DEFAULT '' COMMENT '开服日期',
  PRIMARY KEY (`sid`),
  KEY `port` (`port`),
  KEY `merge_target` (`merge_target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='游戏服';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_serv_coop`
--

DROP TABLE IF EXISTS `xyapi_serv_coop`;
CREATE TABLE IF NOT EXISTS `xyapi_serv_coop` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `cid` int(10) unsigned NOT NULL COMMENT '合作ID',
  `sid` int(10) unsigned NOT NULL COMMENT '服务ID',
  `csid` int(10) unsigned NOT NULL COMMENT '运营商服务SID',
  `is_new` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新服 0:正常 1:新服',
  `is_recommend` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '推荐 0:正常 1:推荐',
  `area_id` int(10) unsigned NOT NULL COMMENT '所属大区',
  `serv_name` char(32) NOT NULL,
  `work_day` char(32) NOT NULL DEFAULT '' COMMENT '开服日期',
  `open_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开服时间(秒)',
  `show_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '显示时间',
  `para` char(254) NOT NULL COMMENT '回传参数',
  `domains` text NOT NULL COMMENT '域名，多个用,号分开',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`,`csid`),
  KEY `show_time` (`show_time`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='功能主机';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_serv_ver`
--

DROP TABLE IF EXISTS `xyapi_serv_ver`;
CREATE TABLE IF NOT EXISTS `xyapi_serv_ver` (
  `ver_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '版本ID',
  `ver_name` char(32) NOT NULL COMMENT '版本名称',
  `level_max` int(10) unsigned NOT NULL DEFAULT '80' COMMENT '等级上限',
  `default` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '1:默认版本 0:非默认版本',
  `ver_serv` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '服器版本号',
  `ver_ios_new` decimal(10,4) unsigned NOT NULL DEFAULT '1.0000' COMMENT 'iOS版本号最新 ',
  `ver_ios_must` decimal(10,4) unsigned NOT NULL DEFAULT '1.0000' COMMENT 'iOS版本号要求最低 ',
  `ver_ios_res` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'iOS资源版本号',
  `ver_android_new` decimal(10,4) unsigned NOT NULL DEFAULT '1.0000' COMMENT 'Android版本号最新 ',
  `ver_android_must` decimal(10,4) unsigned NOT NULL DEFAULT '1.0000' COMMENT 'Android程序版本号要求最低 ',
  `ver_android_res` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'Android资源版本号',
  `ver_web_res_sub` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'WEB公共子版本号',
  `ver_web_res` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '素材（skin/npc/map）',
  `ver_web_swf` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '程序swf版本号(game)',
  `ver_web_ui` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'UI版本号',
  `ver_web_data` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '数据版本号',
  `cdn_phone_package` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'cdnPhone素材',
  `cdn_phone_package_big` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'cdnPhone素材(完整包)',
  `cdn_web_res` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'cdn素材',
  `cdn_web_swf` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'cdn程序swf',
  `cdn_web_ui_img` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'cdnUI(img) ',
  `cdn_web_ui_swf` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'cdnUI(swf) ',
  `cdn_web_data` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'cdn数据',
  PRIMARY KEY (`ver_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='主机版本';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_stat_consume`
--

DROP TABLE IF EXISTS `xyapi_stat_consume`;
CREATE TABLE IF NOT EXISTS `xyapi_stat_consume` (
  `Ym` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月   0:汇总',
  `Ymd` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月日 0:汇总',
  `type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '消费类型 0:汇总',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid 0:汇总',
  `rmb_all` decimal(10,1) unsigned NOT NULL COMMENT '元宝总数',
  `rmb_bind` decimal(10,1) unsigned NOT NULL COMMENT '绑定元宝',
  `rmb_real` decimal(10,1) unsigned NOT NULL COMMENT '充值元宝',
  `count_goods` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品总数',
  `count_logs` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '记录条数',
  `percent` decimal(10,4) unsigned NOT NULL COMMENT '本项百分比',
  PRIMARY KEY (`Ym`,`Ymd`,`type`,`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消费统计';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_stat_gamedata`
--

DROP TABLE IF EXISTS `xyapi_stat_gamedata`;
CREATE TABLE IF NOT EXISTS `xyapi_stat_gamedata` (
  `Ymd` int(10) NOT NULL DEFAULT '0' COMMENT '日期',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid',
  `cid` int(10) unsigned NOT NULL DEFAULT '888' COMMENT '合作方ID',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `online_max` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最高在线',
  `online_min` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最低在线',
  `online_avg` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '平均在线',
  `pay_count_total` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '总付费人数',
  `pay_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '付费人数',
  `pay_count_new` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新增付费人数',
  `pay_count_reg` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新注册付费人数',
  `pay_cc` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '充值笔数',
  `pay_sum` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '充值总数',
  `pay_cc_day` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '今天充值笔数',
  `pay_sum_day` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '今天充值总数',
  `arp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '充值ARP值',
  `arp_avg` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '平均ARP值',
  `online_30` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '30分钟活跃',
  `online_30_new` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新注册30分钟活跃',
  `sum_account` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '账号总数',
  `sum_role` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '总角色数',
  `new_account` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当天新账号数',
  `new_role` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当天新角色数',
  `login_account` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当前帐号登录',
  `login_role` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当天登录角色数',
  `account1` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '1天前注册',
  `role1` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '1天前创建',
  `account2` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '2天前注册',
  `role2` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '2天前创建',
  `account3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '3天前注册',
  `role3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '3天前创建',
  `account4` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '4天前注册',
  `role4` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '4天前创建',
  `account5` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '5天前注册',
  `role5` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '5天前创建',
  `account6` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '6天前注册',
  `role6` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '6天前创建',
  `account7` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '7天前注册',
  `role7` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '7天前创建',
  `account_3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '前3天注册',
  `role_3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '前3天创建',
  `account_7` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '前7天注册',
  `role_7` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '前7天创建',
  PRIMARY KEY (`Ymd`,`sid`,`cid`,`os`,`source`,`source_sub`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='游戏数据汇总';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_stat_online`
--

DROP TABLE IF EXISTS `xyapi_stat_online`;
CREATE TABLE IF NOT EXISTS `xyapi_stat_online` (
  `YmdHi` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '所在小时',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid 0:汇总',
  `online_num` smallint(6) NOT NULL DEFAULT '0' COMMENT '在线人数',
  `ip_num` smallint(6) NOT NULL DEFAULT '0' COMMENT 'ip数',
  PRIMARY KEY (`YmdHi`,`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线数据';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_stat_pay`
--

DROP TABLE IF EXISTS `xyapi_stat_pay`;
CREATE TABLE IF NOT EXISTS `xyapi_stat_pay` (
  `Ym` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月   0:汇总',
  `Ymd` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月日 0:汇总',
  `YmdH` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月日时 0:汇总',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid 0:汇总',
  `cid` int(10) unsigned NOT NULL COMMENT '平台ID 0:汇总',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `rmb_total` decimal(10,2) unsigned NOT NULL COMMENT '充值总数',
  `rmb_times` int(10) unsigned NOT NULL COMMENT '充值次数',
  `uuid_times` int(10) unsigned NOT NULL COMMENT '充值帐号数',
  `uid_times` int(10) unsigned NOT NULL COMMENT '充值玩家数',
  `yb_total` int(20) unsigned NOT NULL COMMENT '充值元宝总数',
  PRIMARY KEY (`Ym`,`Ymd`,`YmdH`,`sid`,`cid`,`os`,`source`,`source_sub`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='每日充值对比';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_stat_pay_top`
--

DROP TABLE IF EXISTS `xyapi_stat_pay_top`;
CREATE TABLE IF NOT EXISTS `xyapi_stat_pay_top` (
  `uuid` int(20) unsigned NOT NULL COMMENT '帐号uuid',
  `Ym` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月   0:汇总',
  `Ymd` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月日 0:汇总',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid 0:汇总',
  `uid` int(20) unsigned NOT NULL COMMENT '人物Uid',
  `uname` char(64) NOT NULL DEFAULT '' COMMENT '人物名字',
  `cid` int(10) unsigned NOT NULL DEFAULT '888' COMMENT '合作方ID',
  `rmb_total` decimal(10,2) unsigned NOT NULL COMMENT '充值总数',
  `rmb_times` int(10) unsigned NOT NULL COMMENT '充值次数',
  `uid_times` int(10) unsigned NOT NULL COMMENT '充值玩家数',
  `rmb_last` decimal(10,2) unsigned NOT NULL COMMENT '最后充值',
  `time_last` int(10) unsigned NOT NULL COMMENT '最近充值时间',
  `yb_total` int(20) unsigned NOT NULL COMMENT '充值元宝总数',
  PRIMARY KEY (`uuid`,`Ym`,`Ymd`,`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值排行';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_stat_register`
--

DROP TABLE IF EXISTS `xyapi_stat_register`;
CREATE TABLE IF NOT EXISTS `xyapi_stat_register` (
  `Ymd` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月日 0:汇总',
  `YmdH` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月日时 0:汇总',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid',
  `cid` int(10) unsigned NOT NULL DEFAULT '888' COMMENT '合作方ID',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `total_account` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '总账号数',
  `total_role` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '总角色数',
  `new_account` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新账号数',
  `new_role` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新角色数',
  `online_max` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '每小时最高在线人数',
  `online_min` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '每小时最低在线人数',
  `online_average` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '每小时平均在线人数',
  `country_1` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '阵营-沙阔界',
  `country_2` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '阵营-火宙界',
  `country_3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '阵营-水源界',
  PRIMARY KEY (`Ymd`,`YmdH`,`sid`,`cid`,`os`,`source`,`source_sub`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='注册统计';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_super`
--

DROP TABLE IF EXISTS `xyapi_super`;
CREATE TABLE IF NOT EXISTS `xyapi_super` (
  `super_id` int(10) unsigned NOT NULL COMMENT 'super服务ID',
  `state` int(10) unsigned NOT NULL DEFAULT '3' COMMENT '状态 0停服 1维护 2拥挤 3正常 4推荐',
  `state_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后更新状态时间',
  `node` char(128) NOT NULL DEFAULT '' COMMENT '节点名称',
  `business` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '合区是否通商（交易,邮寄,市场）  0:不可交易   1:可以交易',
  `super_ver_id` int(10) unsigned NOT NULL COMMENT '版本ID',
  `host_id_game` int(10) unsigned NOT NULL COMMENT '游戏主机ID',
  `host_id_mysql` int(10) unsigned NOT NULL COMMENT 'MYSQl主机ID',
  `serv_name` char(32) NOT NULL,
  `work_day` char(10) NOT NULL DEFAULT '' COMMENT '开服日期',
  PRIMARY KEY (`super_id`),
  KEY `state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='super服务';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_sys_cp`
--

DROP TABLE IF EXISTS `xyapi_sys_cp`;
CREATE TABLE IF NOT EXISTS `xyapi_sys_cp` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '类型:10=>管理员,20=>核心成员,30=>系统管理员(SA),40=>研发客服,50=>联运核心,60=>联运客服',
  `cid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '合作方ID',
  `account` char(32) NOT NULL COMMENT '用户帐号',
  `password` char(32) NOT NULL COMMENT '密码',
  `login_times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '登录次数',
  `login_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `note` text NOT NULL COMMENT '注释',
  PRIMARY KEY (`id`),
  UNIQUE KEY `account` (`cid`,`account`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='管理员';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_sys_login_logs`
--

DROP TABLE IF EXISTS `xyapi_sys_login_logs`;
CREATE TABLE IF NOT EXISTS `xyapi_sys_login_logs` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  `status` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '返回状态 0:失败 1:成功',
  `cid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '合作方ID',
  `account` char(32) NOT NULL COMMENT '用户帐号',
  `ip` char(15) NOT NULL COMMENT 'IP',
  `ip_segment` char(31) NOT NULL DEFAULT '0.0.0.0-0.0.0.0' COMMENT 'IP段',
  `address` char(128) NOT NULL COMMENT '地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='登录日志';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_sys_shortcuts`
--

DROP TABLE IF EXISTS `xyapi_sys_shortcuts`;
CREATE TABLE IF NOT EXISTS `xyapi_sys_shortcuts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '快捷内容id',
  `type` int(10) unsigned NOT NULL COMMENT '类型：1=>留言，...',
  `details` char(255) NOT NULL COMMENT '详细内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='自定义快捷内容';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_user`
--

DROP TABLE IF EXISTS `xyapi_user`;
CREATE TABLE IF NOT EXISTS `xyapi_user` (
  `uuid` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '帐号uuid',
  `cid` int(10) unsigned NOT NULL COMMENT '合作方ID',
  `mac` char(64) NOT NULL DEFAULT '' COMMENT '机器码',
  `mac_direct` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '绑定帐号,直接登录 2:要帐号密码 1:直接进入',
  `session_id` char(254) NOT NULL DEFAULT '' COMMENT 'session id',
  `account` char(64) NOT NULL DEFAULT '' COMMENT '用户帐号(合作平台KEY)',
  `email` char(64) NOT NULL DEFAULT '' COMMENT 'email',
  `phone` char(32) NOT NULL DEFAULT '' COMMENT '手机',
  `passwd` char(32) NOT NULL DEFAULT '' COMMENT '密码',
  `remark` char(254) NOT NULL DEFAULT '' COMMENT '备注',
  `register_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `register_ip` char(40) NOT NULL DEFAULT '' COMMENT '注册IP',
  `login_times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '登录次数',
  `login_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  PRIMARY KEY (`uuid`),
  KEY `account` (`account`,`cid`),
  KEY `mac` (`mac`,`cid`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_user_device`
--

DROP TABLE IF EXISTS `xyapi_user_device`;
CREATE TABLE IF NOT EXISTS `xyapi_user_device` (
  `mac` char(64) NOT NULL DEFAULT '' COMMENT '机器码',
  `cid` int(10) unsigned NOT NULL COMMENT '合作方ID',
  `uuid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '帐号UUid',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `os_var` char(64) NOT NULL DEFAULT '' COMMENT '系统版本',
  `res` char(64) NOT NULL DEFAULT '' COMMENT '资源版本类型 320 480 640 768',
  `res_ver` char(64) NOT NULL DEFAULT '' COMMENT '资源版本',
  `device` char(64) NOT NULL DEFAULT '' COMMENT '客户端设备',
  `screen` char(32) NOT NULL COMMENT '玩家屏尺寸(宽x高 如:1024x768)',
  `language` char(16) NOT NULL COMMENT '用户语言',
  `versions` char(16) NOT NULL DEFAULT '' COMMENT '游戏版本',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `lv` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '等级',
  `rmb_total` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '累积充值',
  `referrer` char(254) NOT NULL COMMENT '广告引导网址',
  `ip` char(40) NOT NULL DEFAULT '' COMMENT 'IP',
  `area` char(24) NOT NULL COMMENT '地区',
  `address` char(32) NOT NULL COMMENT '地址',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '首次时间',
  `times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '登陆次数',
  `time_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后时间',
  PRIMARY KEY (`mac`,`cid`,`uuid`),
  KEY `source` (`source`,`source_sub`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_user_fcm`
--

DROP TABLE IF EXISTS `xyapi_user_fcm`;
CREATE TABLE IF NOT EXISTS `xyapi_user_fcm` (
  `key` char(32) NOT NULL COMMENT 'uuid 或 card_id',
  `Ymd` int(10) unsigned NOT NULL DEFAULT '20120131' COMMENT '防沉迷日期',
  `online` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '已在线时长',
  `offline` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '离线时间',
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='防沉迷';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_user_fcm_card_id`
--

DROP TABLE IF EXISTS `xyapi_user_fcm_card_id`;
CREATE TABLE IF NOT EXISTS `xyapi_user_fcm_card_id` (
  `uuid` int(20) unsigned NOT NULL COMMENT '帐号uuid',
  `card_id` char(18) NOT NULL DEFAULT '' COMMENT '身份证ID',
  `realname` char(16) NOT NULL DEFAULT '' COMMENT '真实姓名',
  `state` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '状态 0:未校验 1:已校验',
  PRIMARY KEY (`uuid`),
  KEY `card_id` (`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='身份证';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_user_login_logs`
--

DROP TABLE IF EXISTS `xyapi_user_login_logs`;
CREATE TABLE IF NOT EXISTS `xyapi_user_login_logs` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uuid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '帐号UUid',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid',
  `mac` char(64) NOT NULL DEFAULT '' COMMENT '机器码',
  `cid` int(10) unsigned NOT NULL COMMENT '合作方ID',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `versions` char(16) NOT NULL DEFAULT '' COMMENT '游戏版本',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  `status` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '返回状态 0:失败 1:成功',
  `ip` char(15) NOT NULL COMMENT 'IP',
  `ip_segment` char(31) NOT NULL DEFAULT '0.0.0.0-0.0.0.0' COMMENT 'IP段',
  `area` char(24) NOT NULL COMMENT '地区',
  `address` char(32) NOT NULL COMMENT '地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='登录日志';

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_user_role`
--

DROP TABLE IF EXISTS `xyapi_user_role`;
CREATE TABLE IF NOT EXISTS `xyapi_user_role` (
  `uid` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '人物Uid',
  `uuid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '帐号uuid',
  `fcm_id` char(32) NOT NULL DEFAULT '' COMMENT '防沉迷唯一标识',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器SID',
  `cid` int(10) unsigned NOT NULL DEFAULT '888' COMMENT '合作方ID',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `uname` char(64) NOT NULL DEFAULT '' COMMENT '人物名字',
  `uname_color` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '名字颜色',
  `pro` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '职业',
  `sex` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '性别',
  `country` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '国家',
  `lv` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '等级',
  `vip` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'vip',
  `login_times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '登陆次数',
  `login_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登陆',
  `login_ip` char(64) NOT NULL DEFAULT '' COMMENT '最后登陆IP',
  PRIMARY KEY (`uid`),
  KEY `cid` (`cid`),
  KEY `sid` (`sid`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `xyapi_user_zoom`
--

DROP TABLE IF EXISTS `xyapi_user_zoom`;
CREATE TABLE IF NOT EXISTS `xyapi_user_zoom` (
  `uid` int(20) unsigned NOT NULL COMMENT '人物Uid',
  `uuid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '帐号UUid',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid',
  `mac` char(64) NOT NULL DEFAULT '' COMMENT '机器码',
  `cid` int(10) unsigned NOT NULL COMMENT '合作方ID',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `os_var` char(64) NOT NULL DEFAULT '' COMMENT '系统版本',
  `res` char(64) NOT NULL DEFAULT '' COMMENT '资源版本类型 320 480 640 768',
  `res_ver` char(64) NOT NULL DEFAULT '' COMMENT '资源版本',
  `device` char(64) NOT NULL DEFAULT '' COMMENT '客户端设备',
  `screen` char(32) NOT NULL COMMENT '玩家屏尺寸(宽x高 如:1024x768)',
  `language` char(16) NOT NULL COMMENT '用户语言',
  `versions` char(16) NOT NULL DEFAULT '' COMMENT '游戏版本',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `referrer` char(254) NOT NULL COMMENT '广告引导网址',
  `ip` char(40) NOT NULL DEFAULT '' COMMENT 'IP',
  `area` char(24) NOT NULL COMMENT '地区',
  `address` char(32) NOT NULL COMMENT '地址',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '首次时间',
  `times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '登陆次数',
  `time_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后时间',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家扩展信息手端';