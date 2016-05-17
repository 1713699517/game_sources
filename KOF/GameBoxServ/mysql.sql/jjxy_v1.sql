

DROP TABLE IF EXISTS `arena`, `arena_data`, `arena_moil`, `arena_reward`, `card`, `card_list`, `circle`, `clan_apply`, `clan_com`, `clan_log`,
 `clan_mem`, `clan_war_com`, `clan_war_role`, `copy_reward`, `copy_save`, `cp_control`, `cp_inside_user`, `cp_logs`, `cp_mail`, 
 `cp_notice`, `cp_rmb`, `kinghell`, `logs_book_join`, `logs_book_last`, `logs_boss`, `logs_circle`, `logs_clan_war`, `logs_copy`,
 `logs_devote`, `logs_energy`, `logs_exp`, `logs_funs`, `logs_gold`, `logs_goods`, `logs_integral`, `logs_login`, `logs_lv`, 
 `logs_mount`, `logs_online`, `logs_pay`, `logs_pilroad_kill`, `logs_point`, `logs_renown`, `logs_rmb`, `logs_soul`, `logs_star`, 
 `logs_task`, `logs_xiannv`, `nianshou`, `online_reward`, `online_reward_lv`, `pil_best`, `pil_black_shop`, `pil_save`, `sales_arena`, 
 `sales_ask_use`, `skywar_clan`, `skywar_role`, `stat_gamedata`, `stat_online`, `stat_register`, `stride_arena`, `stride_arena_super`, 
 `sys_friend`, `sys_global`, `sys_mail`, `user`, `user_zoom_iphone`, `war_datas`;
--
-- 数据库: `gc_jjxy_v1_s1`
--

-- --------------------------------------------------------

--
-- 表的结构 `card`
--

DROP TABLE IF EXISTS `card`;
CREATE TABLE IF NOT EXISTS `card` (
  `tag` char(8) NOT NULL COMMENT '标识(卡号第一区),限4-8位。如:新手卡NEW1-*-*—*,媒体卡17173-*-*-* 52PK-*-*-*等',
  `type` char(4) NOT NULL COMMENT '类型(卡号第二区),限4位，同标识每个玩家只能领一次,如:*-N001-*-*',
  `model` char(1) NOT NULL COMMENT '模式(卡号第三区),限1位，1:一卡只能一玩家领取,N:一卡可多玩家领取(有上限)',
  `name` char(24) NOT NULL COMMENT '活动卡名称',
  `give` text NOT NULL COMMENT '奖励物品',
  `total` smallint(6) unsigned NOT NULL COMMENT '生成/最大总数量',
  `used` smallint(6) unsigned NOT NULL DEFAULT '0' COMMENT '已经使用量',
  `remark` char(254) NOT NULL COMMENT '活动卡描述',
  `start_time` int(10) unsigned NOT NULL COMMENT '开始时间',
  `end_time` int(10) unsigned NOT NULL COMMENT '结束时间',
  `time` int(10) unsigned NOT NULL COMMENT '记录时间',
  PRIMARY KEY (`type`,`tag`,`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动卡';

-- --------------------------------------------------------

--
-- 表的结构 `card_list`
--

DROP TABLE IF EXISTS `card_list`;
CREATE TABLE IF NOT EXISTS `card_list` (
  `tag` char(8) NOT NULL COMMENT '标识(卡号第一区),限4-8位。如:新手卡NEW1-*-*—*,媒体卡17173-*-*-* 52PK-*-*-*等',
  `type` char(4) NOT NULL COMMENT '类型(卡号第二区),限4位，同标识每个玩家只能领一次,如:*-N001-*-*',
  `model` char(1) NOT NULL COMMENT '模式(卡号第三区),限1位，1:一卡只能一玩家领取,N:一卡可多玩家领取(有上限)',
  `sn` char(6) NOT NULL COMMENT '编号(卡号第四区),限6位',
  `uid` bigint(20) unsigned NOT NULL COMMENT '玩家UID',
  `time` int(10) unsigned NOT NULL COMMENT '激活时间',
  PRIMARY KEY (`type`,`tag`,`model`,`sn`,`uid`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动卡列表';

-- --------------------------------------------------------

--
-- 表的结构 `cp_control`
--

DROP TABLE IF EXISTS `cp_control`;
CREATE TABLE IF NOT EXISTS `cp_control` (
  `type` int(10) unsigned NOT NULL COMMENT '类型 1:uid 2:Ip',
  `data` char(40) NOT NULL COMMENT '禁止登录IP 或 uid',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  `end_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '有效间期 0:永久',
  `describe` char(254) NOT NULL COMMENT '描述',
  PRIMARY KEY (`type`,`data`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='登录表';

-- --------------------------------------------------------

--
-- 表的结构 `cp_inside_user`
--

DROP TABLE IF EXISTS `cp_inside_user`;
CREATE TABLE IF NOT EXISTS `cp_inside_user` (
  `uid` int(20) unsigned NOT NULL COMMENT '玩家ID',
  `sid` int(10) unsigned NOT NULL COMMENT ' server ID',
  `uname` char(64) NOT NULL DEFAULT '' COMMENT '人物名字',
  `bind_rmb` int(20) unsigned NOT NULL COMMENT '发放的绑定金元',
  `operator` char(64) NOT NULL DEFAULT '' COMMENT '操作人',
  `seconds` int(20) unsigned NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`uid`,`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='每周固定发放金元内部号数据';

-- --------------------------------------------------------

--
-- 表的结构 `cp_logs`
--

DROP TABLE IF EXISTS `cp_logs`;
CREATE TABLE IF NOT EXISTS `cp_logs` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL COMMENT '用户uid',
  `uname` char(64) NOT NULL COMMENT '玩家',
  `type` int(10) NOT NULL COMMENT '操作(1,发放物品 2,发放金币 3,发放经验 4,发放元宝)',
  `content` text NOT NULL COMMENT '操作内容',
  `cid` int(10) NOT NULL COMMENT '平台cid',
  `account` char(64) NOT NULL COMMENT '发放人账号',
  `ip` char(15) NOT NULL COMMENT 'ip地址',
  `address` char(128) NOT NULL COMMENT '地址',
  `time` int(10) unsigned NOT NULL COMMENT '发放时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='操作日志';

-- --------------------------------------------------------

--
-- 表的结构 `cp_mail`
--

DROP TABLE IF EXISTS `cp_mail`;
CREATE TABLE IF NOT EXISTS `cp_mail` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `isall` int(10) unsigned NOT NULL COMMENT '是否全服 0:否 1: 是',
  `to` text NOT NULL COMMENT '发放对像，全服时为空',
  `title` char(128) NOT NULL COMMENT '邮件主题',
  `content` text NOT NULL COMMENT '邮件内容',
  `gold` int(10) unsigned DEFAULT '0' COMMENT '金钱',
  `goods` text NOT NULL COMMENT '物品信息',
  `reason` char(254) NOT NULL DEFAULT '' COMMENT '申请原因',
  `cid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '平台cid',
  `account` char(64) NOT NULL COMMENT '申请人账号',
  `check` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0-申请状态，1-审核通过，但没有发放成功（需重新发放）2-审核不通过，3-物品成功发放',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '申请时间',
  `check_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '批准/或拒绝时间',
  `check_account` char(64) NOT NULL DEFAULT '0' COMMENT '物品审核人账号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发放物品';

-- --------------------------------------------------------

--
-- 表的结构 `cp_notice`
--

DROP TABLE IF EXISTS `cp_notice`;
CREATE TABLE IF NOT EXISTS `cp_notice` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `type` int(10) unsigned NOT NULL DEFAULT '5' COMMENT '显示区域  见常量：CONST_BROAD_AREA_＊',
  `interval` int(10) unsigned NOT NULL COMMENT '显示间隔,5分钟，10分钟，15分钟, 30分钟, 60分钟',
  `begin_time` int(10) unsigned NOT NULL COMMENT '开始时间',
  `end_time` int(10) unsigned NOT NULL COMMENT '结束时间',
  `show_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '显示时长(小于默认时长或于最大,为默认时长)',
  `content` text NOT NULL COMMENT '内容',
  `text` char(254) NOT NULL COMMENT '文本内容(内部)',
  `url` char(254) NOT NULL COMMENT '连接(内部)',
  `cid` int(10) NOT NULL COMMENT '发布人平台cid',
  `account` char(64) NOT NULL COMMENT '发布人账号',
  `time` int(10) unsigned NOT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`),
  KEY `end_time` (`end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公告';

-- --------------------------------------------------------

--
-- 表的结构 `cp_rmb`
--

DROP TABLE IF EXISTS `cp_rmb`;
CREATE TABLE IF NOT EXISTS `cp_rmb` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `isall` int(10) unsigned NOT NULL COMMENT '是否全服 0:否 1: 是',
  `to` text NOT NULL COMMENT '发放对像，全服时为空',
  `rmb` int(11) DEFAULT '0' COMMENT '元宝',
  `point` int(11) DEFAULT '0' COMMENT '礼券',
  `reason` char(254) NOT NULL DEFAULT '' COMMENT '申请原因',
  `cid` int(10) NOT NULL COMMENT '申请平台cid',
  `account` char(64) NOT NULL COMMENT '申请人账号',
  `state` tinyint(2) NOT NULL DEFAULT '0' COMMENT '0-申请状态，1-审核通过，但没有发放成功（需重新发放）2-审核不通过，3-物品成功发放',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '申请时间',
  `check_time` int(11) NOT NULL DEFAULT '0' COMMENT '批准/或拒绝时间',
  `check_account` char(64) NOT NULL DEFAULT '0' COMMENT '物品审核人账号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发放元宝';

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- 表的结构 `logs_pay`
--

DROP TABLE IF EXISTS `logs_pay`;
CREATE TABLE IF NOT EXISTS `logs_pay` (
  `oid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单OID',
  `ooid` char(64) NOT NULL DEFAULT '' COMMENT '运营订单id',
  `uid` int(10) unsigned NOT NULL COMMENT '玩家uid',
  `uuid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '帐号UUid',
  `cid` int(10) unsigned NOT NULL DEFAULT '888' COMMENT '合作方ID',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `uname` char(64) NOT NULL COMMENT '玩家角色名',
  `type` int(2) unsigned NOT NULL COMMENT '类型 0:充值 1:后台',
  `state` int(2) unsigned NOT NULL COMMENT '领取状态',
  `pay` int(10) unsigned NOT NULL COMMENT '充值金额',
  `balance` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '充值余额',
  `time` int(10) unsigned NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`oid`),
  UNIQUE KEY `ooid` (`ooid`),
  KEY `uid` (`uid`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值记录';


-- --------------------------------------------------------

DROP TABLE IF EXISTS `stat_gamedata`;
CREATE TABLE IF NOT EXISTS `stat_gamedata` (
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



--
-- 表的结构 `stat_online`
--

DROP TABLE IF EXISTS `stat_online`;
CREATE TABLE IF NOT EXISTS `stat_online` (
  `YmdHi` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '所在小时',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid 0:汇总',
  `online_num` smallint(6) NOT NULL DEFAULT '0' COMMENT '在线人数',
  `ip_num` smallint(6) NOT NULL DEFAULT '0' COMMENT 'ip数',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '统计时间',
  PRIMARY KEY (`YmdHi`,`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线数据';

-- --------------------------------------------------------

--
-- 表的结构 `stat_register`
--

DROP TABLE IF EXISTS `stat_register`;
CREATE TABLE IF NOT EXISTS `stat_register` (
  `Ymd`   int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月日 0:汇总',
  `YmdH`   int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月日时 0:汇总',
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



DROP TABLE IF EXISTS `stat_consume`;
CREATE TABLE IF NOT EXISTS `stat_consume` (
  `Ym`    int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月   0:汇总',
  `Ymd`   int(10) unsigned NOT NULL DEFAULT '0' COMMENT '年月日 0:汇总',
  `type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '消费类型 0:汇总',
  `sid`  int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid 0:汇总',
  `rmb_all` decimal(10,1) unsigned NOT NULL COMMENT  '元宝总数',
  `rmb_bind` decimal(10,1) unsigned NOT NULL COMMENT  '绑定元宝',
  `rmb_real`  decimal(10,1) unsigned NOT NULL COMMENT '充值元宝',
  `count_goods` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品总数',
  `count_logs` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '记录条数',
  `percent` decimal(10,4) unsigned NOT NULL COMMENT '本项百分比',
  PRIMARY KEY (`Ym`,`Ymd`,`type`,`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消费统计';

-- --------------------------------------------------------

--
-- 表的结构 `sys_friend`
--

DROP TABLE IF EXISTS `sys_friend`;
CREATE TABLE IF NOT EXISTS `sys_friend` (
  `uid` int(20) unsigned NOT NULL COMMENT '玩家Uid',
  `friend` blob COMMENT '玩家好友信息',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `sys_global`
--

DROP TABLE IF EXISTS `sys_global`;
CREATE TABLE IF NOT EXISTS `sys_global` (
  `k` char(254) NOT NULL,
  `val` longtext,
  PRIMARY KEY (`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------



-- --------------------------------------------------------

--
-- 表的结构 `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `uid` int(20) unsigned NOT NULL COMMENT '人物Uid',
  `uuid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '帐号UUid',
  `cid` int(10) unsigned NOT NULL DEFAULT '888' COMMENT '合作方ID',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `versions` char(16) NOT NULL DEFAULT '' COMMENT '游戏版本',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `uname` char(64) NOT NULL DEFAULT '' COMMENT '人物名字',
  `uname_color` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '名字颜色',
  `pro` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '职业',
  `sex` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '性别',
  `country` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '国家',
  `lv` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '等级',
  `vip` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'vip',
  `vip_indate` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Vip 有效时间',
  `map_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '地图id',
  `x` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'X坐标',
  `y` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'Y坐标',
  `exp` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `exp_total` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '总经验',
  `gold` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '铜钱',
  `rmb` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '元宝',
  `rmb_bind` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '绑定元宝',
  `rmb_total` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '累积充值',
  `rmb_consume` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '已消耗元宝',
  `reg_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `reg_ip` char(40) NOT NULL DEFAULT '' COMMENT '注册IP',
  `login_times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '登陆次数',
  `login_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登陆',
  `login_ip` char(40) NOT NULL DEFAULT '' COMMENT '最后登陆IP',
  `online_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '在线时总长',
  `online_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后一次在线时长',
  `state` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '状态 0:正常  1:新手指导员',
  `data` blob COMMENT '基础数据',
  PRIMARY KEY (`uid`),
  KEY `cid` (`cid`),
  KEY `uuid` (`uuid`),
  KEY `os` (`os`),
  KEY `source` (`source`),
  KEY `uname` (`uname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `user_zoom_iphone`
--

DROP TABLE IF EXISTS `user_zoom_iphone`;
CREATE TABLE IF NOT EXISTS `user_zoom_iphone` (
  `uid` int(10) unsigned NOT NULL COMMENT '用户uid',
  `uuid` int(10) unsigned NOT NULL COMMENT '用户uuid',
  `cid` int(10) unsigned NOT NULL COMMENT '合作方ID',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid',
  `mac` char(64) NOT NULL DEFAULT '' COMMENT '机器码',
  `device` char(64) NOT NULL DEFAULT '' COMMENT '客户端设备',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `screen` char(9) NOT NULL COMMENT '屏幕类型X*Y',
  `language` char(16) NOT NULL COMMENT '用户语言',
  `ver_release` char(16) NOT NULL COMMENT '发布版本 ios,ioshd,ioshdhh,android,androidhd',
  `ver_program` char(16) NOT NULL COMMENT '程序版本 1.24,1.25等',
  `ver_res` int(10) unsigned NOT NULL COMMENT '资源版本 16,17等',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `ip` char(40) NOT NULL DEFAULT '' COMMENT 'IP',
  `area` char(24) NOT NULL COMMENT '地区',
  `address` char(32) NOT NULL COMMENT '地址',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '首次时间',
  `time_last` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后时间',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家扩展信息手端';

-- --------------------------------------------------------

--
-- 表的结构 `war_datas`
--

DROP TABLE IF EXISTS `war_datas`;
CREATE TABLE IF NOT EXISTS `war_datas` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '战报ID',
  `datas` blob COMMENT '战报数据',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='战报';

-- --------------------------------------------------------
--
-- 表的结构 `sys_mail`
--

DROP TABLE IF EXISTS `sys_mail`;
CREATE TABLE IF NOT EXISTS `sys_mail` (
  `mail_id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '邮件唯一Uid',
  `recv_uid` bigint(20) NOT NULL DEFAULT '0' COMMENT '收件人id',
  `recv_del` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '收件人是否删除0未删1已删',
  `recv_name` char(64) NOT NULL DEFAULT '' COMMENT '收件人名字',
  `send_uid` bigint(20) NOT NULL DEFAULT '0' COMMENT '发件人id',
  `send_del` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发件人是否删除0未删1已删',
  `send_name` char(64) NOT NULL DEFAULT '' COMMENT '发件人名字',
  `title` char(254) NOT NULL DEFAULT '' COMMENT '邮件标题',
  `content` text NOT NULL COMMENT '邮件内容',
  `vgoods` blob COMMENT '数值类物品数据({type,velue}..)',
  `goods` blob COMMENT '包裹物品数据({give},...)',
  `state` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '查看邮件标志0 or 1',
  `mtype` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '邮件类型 系统or玩家',
  `boxtype` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '邮箱类型 收 发 存',
  `pick` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '提取附件标志0无 or 1有 or 2已提',
  `date` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发送邮件生成时间戳',
  PRIMARY KEY (`mail_id`),
  KEY `recv_uid` (`recv_uid`),
  KEY `send_uid` (`send_uid`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件数据';


-- --------------------------------------------------------

-- 以下帮派数据
-- --------------------------------------------------------
--
-- 表的结构 `clan_public`
--

DROP TABLE IF EXISTS `clan_public`;
CREATE TABLE IF NOT EXISTS `clan_public` (
  `clan_id` int(20) unsigned NOT NULL COMMENT '帮派ID',
  `clan_rank` int(15) unsigned NOT NULL COMMENT '帮派排名',
  `clan_name` char(64) NOT NULL COMMENT '名字',
  `clan_lv` int(10) unsigned NOT NULL COMMENT '等级',
  `devote` int(20) unsigned NOT NULL COMMENT '贡献',
  `up_devote` int(20) unsigned NOT NULL COMMENT '下级所需贡献', 
  `max_member` int(10) unsigned NOT NULL COMMENT '成员上限',
  `master_id` int(20) unsigned NOT NULL COMMENT '帮主uid',
  `master_name` char(64) NOT NULL COMMENT '帮主名字',
  `master_color` int(10) unsigned NOT NULL COMMENT '帮主名字颜色', 
  `master_Lv` int(10) unsigned NOT NULL COMMENT '帮主等级', 
  `notice` char(254) NOT NULL COMMENT '帮派公告',
  `member` blob NOT NULL COMMENT '帮派成员id列表',
  `master_list` blob NOT NULL COMMENT '帮派管理成员id列表',
  `seconds` int(20) unsigned NOT NULL COMMENT '创建时间戳',
  PRIMARY KEY (`clan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- 表的结构 `clan_mem`
--

DROP TABLE IF EXISTS `clan_mem`;
CREATE TABLE IF NOT EXISTS `clan_mem` (
  `uid` int(20) unsigned NOT NULL COMMENT '玩家uid',
  `clan_id` int(20) NOT NULL COMMENT '帮派id',
  `name` char(64) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `name_color` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '玩家名字颜色',
  `lv` int(10) unsigned NOT NULL COMMENT '玩家等级',
  `post` int(5) unsigned NOT NULL COMMENT '职位',
  `devote_day` int(10) unsigned NOT NULL COMMENT '日贡献',
  `devote_sum` int(20) unsigned NOT NULL COMMENT '总贡献',
  `logout_time` int(20) unsigned NOT NULL COMMENT '离线时间戳',
  `join_time` int(20) unsigned NOT NULL COMMENT '加入时间戳',
  PRIMARY KEY (`uid`,`clan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------
--
-- 表的结构 `cat_data`
--
DROP TABLE IF EXISTS `clan_cat_data`;
CREATE TABLE IF NOT EXISTS `clan_cat_data` (
  `clan_id` int(20) unsigned NOT NULL COMMENT '帮派ID',
  `cat_lv` int(10) unsigned NOT NULL COMMENT '招财猫等级', 
  `cat_exp` int(20) unsigned NOT NULL COMMENT '招财猫经验',
  PRIMARY KEY (`clan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 表的结构 `clan_boss`
--
DROP TABLE IF EXISTS `clan_boss`;
CREATE TABLE IF NOT EXISTS `clan_boss` (
  `clan_id` int(20) unsigned NOT NULL COMMENT '帮派ID',
  `times` int(10) unsigned NOT NULL COMMENT '开启次数',
  `date` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开启日期',
  PRIMARY KEY (`clan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 以上帮派活动数据
-- --------------------------------------------------------


-- 表的结构 `arena`
--

DROP TABLE IF EXISTS `arena`;
CREATE TABLE IF NOT EXISTS `arena` (
  `rank` int(10) NOT NULL COMMENT '排名',
  `uid` int(10) unsigned NOT NULL COMMENT '用户Uid',
  `name` char(64) NOT NULL COMMENT '玩家名字',
  `country` int(10) NOT NULL COMMENT '阵营',
  `sex` int(10) NOT NULL COMMENT '性别',
  `pro` int(10) NOT NULL COMMENT '职业',
  `lv` int(10) NOT NULL COMMENT '等级',
  `renown` int(10) NOT NULL COMMENT '声望',
  `win_count` int(10) NOT NULL COMMENT '连赢次数',
  `surplus` int(10) NOT NULL COMMENT '剩余挑战次数',
  `power` int(10) NOT NULL COMMENT '战斗力',
  PRIMARY KEY (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='封神台排名';

-- --------------------------------------------------------

--
-- 表的结构 `arena_data`
--

DROP TABLE IF EXISTS `arena_data`;
CREATE TABLE IF NOT EXISTS `arena_data` (
  `uid` int(10) unsigned NOT NULL COMMENT '用户Uid',
  `datas` blob NOT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='封神台战斗提示';

-- --------------------------------------------------------
--
-- 表的结构 `active_data`
-- (`active_id`, `active_type`, `role_lv`,`show`, `in_host`', `dates`, `weeks`, `times`)
-- ActiveId,ActiveType,Dates,Weeks,Time,RoleLv,Show,InHost
DROP TABLE IF EXISTS `active_data`;
CREATE TABLE IF NOT EXISTS `active_data` (
  `active_id` int(10) unsigned NOT NULL COMMENT '活动ID',
  `active_type` int(10) unsigned NOT NULL COMMENT '活动类型', 
  `role_lv` int(10) unsigned NOT NULL COMMENT '玩家等级限制', 
  `show` int(10) unsigned NOT NULL COMMENT '是否一直显示', 
  `in_host` int(10) unsigned NOT NULL COMMENT '是否入口图标',
  
  `dates` blob NOT NULL COMMENT '日期限制列表',
  `weeks` blob NOT NULL COMMENT '星期限制列表',
  `times` blob NOT NULL COMMENT '时间限制列表',
  PRIMARY KEY (`active_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动数据';

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- 表的结构 `sales_arena`
--

DROP TABLE IF EXISTS `sales_arena`;
CREATE TABLE IF NOT EXISTS `sales_arena` (
  `sid` int(10) unsigned NOT NULL COMMENT '服务器Sid',
  `uid` int(10) unsigned NOT NULL COMMENT '用户Uid',
  `rank` int(10) unsigned NOT NULL COMMENT '排名',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='竞技场活动数据';


-- --------------------------------------------------------

--
-- 表的结构 `logs_exp`
--



-- --------------------------------------------------------

--
-- 表的结构 `sales_ask_use`
--

DROP TABLE IF EXISTS `sales_ask_use`;
CREATE TABLE IF NOT EXISTS `sales_ask_use` (
  `aid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) unsigned NOT NULL COMMENT '用户uid',
  `id` int(10) unsigned NOT NULL COMMENT '活动ID',
  `type` int(10) unsigned NOT NULL COMMENT '活动类型)',
  `arg` bigint(20) unsigned NOT NULL COMMENT '活动参数订单ID..',
  `type_step` int(10) unsigned NOT NULL COMMENT '活动等阶',
  `times` int(10) unsigned NOT NULL COMMENT '领取的时间',
  `count` int(10) unsigned NOT NULL COMMENT '领取的次数',
  PRIMARY KEY (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='精彩活动已领取的阶段奖励';



-- --------------------------------------------------------

--
-- 表的结构 `top_ngc`
--

DROP TABLE IF EXISTS `top_ngc`;
CREATE TABLE IF NOT EXISTS `top_ngc` (
  `uid` int(10) unsigned NOT NULL COMMENT '用户uid',
  `name` char(64) NOT NULL DEFAULT '' COMMENT '人物名字',
  `name_color` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '名字颜色',
  `clan_id` int(10) unsigned NOT NULL COMMENT '用户uid',
  `clan_name` char(64) NOT NULL DEFAULT '' COMMENT '帮派名字',
  `lv` int(10) unsigned NOT NULL COMMENT '用户等级',
  `powerful` int(10) unsigned NOT NULL COMMENT '战斗力',
  `rank` int(10) unsigned NOT NULL COMMENT '逐鹿台排名',
  PRIMARY KEY (`uid`),
  KEY `lv` (`lv`),
  KEY `powerful` (`powerful`),
  KEY `rank` (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='排行数据';
