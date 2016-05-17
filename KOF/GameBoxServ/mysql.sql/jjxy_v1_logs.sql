

-- --------------------------------------------------------
DROP TABLE IF EXISTS `logs_user`;
CREATE TABLE IF NOT EXISTS `logs_user` (
  `uid` int(20) unsigned NOT NULL COMMENT '人物Uid',
  `uuid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '帐号UUid',
  `cid` int(10) unsigned NOT NULL DEFAULT '888' COMMENT '合作方ID',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `versions` char(16) NOT NULL DEFAULT '' COMMENT '游戏版本',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `uname` char(64) NOT NULL DEFAULT '' COMMENT '人物名字',
  `pro` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '职业',
  `sex` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '性别',
  `country` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '国家',
  `reg_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `reg_ip` char(40) NOT NULL DEFAULT '' COMMENT '注册IP',
  PRIMARY KEY (`uid`),
  KEY `cid` (`cid`),
  KEY `uuid` (`uuid`),
  KEY `os` (`os`),
  KEY `source` (`source`),
  KEY `uname` (`uname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 表的结构 `logs_boss`
--

DROP TABLE IF EXISTS `logs_boss`;
CREATE TABLE IF NOT EXISTS `logs_boss` (
  `uid`     int(10) unsigned NOT NULL COMMENT '玩家UID',
  `boss_id` int(10) unsigned NOT NULL COMMENT 'boss ID',
  `time`    int(10) unsigned NOT NULL COMMENT '时间',
  PRIMARY KEY (`uid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='boss最后击杀';

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- 表的结构 `logs_copy`
--

DROP TABLE IF EXISTS `logs_copy`;
CREATE TABLE IF NOT EXISTS `logs_copy` (
  `uid`         int(10) unsigned NOT NULL COMMENT '玩家UID',
  `copy_id`     int(10) unsigned NOT NULL COMMENT '副本ID',
  `time_add`    int(10) unsigned NOT NULL COMMENT '第一次进入时间',
  `time_finish` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '完成时间 默认为:0',
  `state`       int(10) unsigned NOT NULL COMMENT '状态 ?CONST_FALSE 进入  ?CONST_TRUE 完成',
  `type`        int(10) unsigned NOT NULL COMMENT '类型 1:普通副本 2英雄副本 3:魔王副本 4:拳皇生涯',
  PRIMARY KEY (`uid`,`copy_id`),
  KEY `state` (`state`),
  KEY `time_add` (`time_add`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='副本进入/完成率';

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- 表的结构 `logs_hosting`
--

DROP TABLE IF EXISTS `logs_hosting`;
CREATE TABLE IF NOT EXISTS `logs_hosting` (
  `uid`        int(10) unsigned NOT NULL COMMENT '玩家UID',
  `copy_id`    int(10) unsigned NOT NULL COMMENT '副本ID',
  `count`      int(10) unsigned NOT NULL COMMENT '副本挂机次数',
  `time_begin` int(10) unsigned NOT NULL COMMENT '开始进入副本时间',
  `time_end`   int(10) unsigned NOT NULL COMMENT '结束时间',
  `state`       int(10) unsigned NOT NULL COMMENT '状态 ?CONST_FALSE 停止  ?CONST_TRUE 开始',
  PRIMARY KEY (`uid`,`copy_id`),
  KEY `time_end` (`time_end`),
  KEY `time_begin` (`time_begin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='副本挂机';

-- --------------------------------------------------------


-- --------------------------------------------------------

--
-- 表的结构 `logs_exp`
--

DROP TABLE IF EXISTS `logs_exp`;
CREATE TABLE IF NOT EXISTS `logs_exp` (
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '玩家UID',
  `role_lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '玩家(等级)',
  `method` char(32) NOT NULL DEFAULT '' COMMENT '方法',
  `amount` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `balance` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '经验总数',
  `remark` char(254) NOT NULL DEFAULT '' COMMENT '操作描述',
  KEY `time` (`time`),
  KEY `uid` (`uid`),
  KEY `method` (`method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='经验记录(日志)';

-- --------------------------------------------------------


-- --------------------------------------------------------

--
-- 表的结构 `logs_gold`
--

DROP TABLE IF EXISTS `logs_gold`;
CREATE TABLE IF NOT EXISTS `logs_gold` (
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  `uid`  int(10) unsigned NOT NULL COMMENT '玩家UID',
  `lv`   int(10) unsigned NOT NULL DEFAULT '0' COMMENT '人物等级',
  `method` char(32) NOT NULL COMMENT '方法',
  `amount`   int(10) unsigned NOT NULL COMMENT '金额',
  `balance`  int(10) unsigned NOT NULL COMMENT '余额',
  `remark`   char(254) NOT NULL COMMENT '操作描述',
  KEY `time` (`time`),
  KEY `uid` (`uid`),
  KEY `method` (`method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='金币消费记录';

-- --------------------------------------------------------

--
-- 表的结构 `logs_goods`
--

DROP TABLE IF EXISTS `logs_goods`;
CREATE TABLE IF NOT EXISTS `logs_goods` (
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  `type` char(32) NOT NULL COMMENT '状态 ?CONST_FALSE 扣除  ?CONST_TRUE 获得',
  `uid` int(10) unsigned NOT NULL COMMENT '玩家UID',
  `method` char(32) NOT NULL COMMENT '方法&类型',
  `goods_id` int(10) unsigned DEFAULT '0' COMMENT '物品1',
  `goods_count` int(10) unsigned DEFAULT '0' COMMENT '数量',
  `goods_streng` int(10) unsigned DEFAULT '0' COMMENT '强化类型(0,未强化  强化级别为1-10级)',
  `goods_bind` int(10) unsigned DEFAULT '0' COMMENT '是否绑定(0,未绑定 1,绑定)',
  `goods_name_color` int(10) unsigned DEFAULT '0' COMMENT '颜色',
  `goods_expiry_type` int(10) unsigned DEFAULT '0' COMMENT '时间类型 (1,秒 2, 天)',
  `goods_expiry` int(10) unsigned DEFAULT '0' COMMENT '有效期',
  `remark` char(254) NOT NULL COMMENT '操作描述',
  KEY `time` (`time`),
  KEY `uid` (`uid`),
  KEY `type` (`type`),
  KEY `goods_id` (`goods_id`),
  KEY `method` (`method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物品记录(日志)';


-- --------------------------------------------------------

--
-- 表的结构 `logs_login`
--



-- --------------------------------------------------------

--
-- 表的结构 `logs_lv`
--

DROP TABLE IF EXISTS `logs_lv`;
CREATE TABLE IF NOT EXISTS `logs_lv` (
  `uid` int(10) unsigned NOT NULL COMMENT '玩家UID',
  `last_lv` char(32) NOT NULL COMMENT '当前等级',
  `target_lv` char(32) NOT NULL COMMENT '目标等级',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  PRIMARY KEY (`uid`,`target_lv`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='等级';

-- --------------------------------------------------------






--
-- 表的结构 `logs_login`
--

DROP TABLE IF EXISTS `logs_login`;
CREATE TABLE IF NOT EXISTS `logs_login` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(10) unsigned NOT NULL COMMENT '用户ID',
  `uuid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '帐号UUid',
  `cid` int(10) unsigned NOT NULL DEFAULT '888' COMMENT '合作方ID',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `versions` char(16) NOT NULL DEFAULT '' COMMENT '游戏版本',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `uname` char(64) NOT NULL COMMENT '玩家角色名',
  `ip` char(15) NOT NULL COMMENT '用户登录IP',
  `time` int(10) unsigned NOT NULL COMMENT '用户登录时间',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `os` (`os`),
  KEY `source` (`source`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户登录日志';

-- --------------------------------------------------------

--
-- 表的结构 `logs_online`
--

DROP TABLE IF EXISTS `logs_online`;
CREATE TABLE IF NOT EXISTS `logs_online` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `time` int(10) unsigned NOT NULL COMMENT '登录时间',
  `uid` int(10) unsigned NOT NULL COMMENT '用户ID',
  `uuid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '帐号UUid',
  `cid` int(10) unsigned NOT NULL DEFAULT '888' COMMENT '合作方ID',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Sid',
  `os` char(64) NOT NULL DEFAULT '' COMMENT '系统类型',
  `versions` char(16) NOT NULL DEFAULT '' COMMENT '游戏版本',
  `source` char(32) NOT NULL DEFAULT '' COMMENT '来源渠道',
  `source_sub` char(32) NOT NULL DEFAULT '' COMMENT '子渠道',
  `uname` char(64) NOT NULL COMMENT '玩家角色名',
  `ip` char(15) NOT NULL COMMENT '用户登录IP',
  `online` int(10) unsigned NOT NULL COMMENT '本次在线时长',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `os` (`os`),
  KEY `source` (`source`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线时长';





DROP TABLE IF EXISTS `logs_rmbbind`;
CREATE TABLE IF NOT EXISTS `logs_rmbbind` (
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  `uid` int(10) unsigned NOT NULL COMMENT '玩家UID',
  `lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '人物等级',
  `method` char(32) NOT NULL COMMENT '消费子类型',
  `item` char(32) NOT NULL COMMENT '消费内容(如物口id)',
  `amount` int(11) NOT NULL COMMENT '金额',
  `balance` int(11) NOT NULL COMMENT '余额',
  `remark` char(254) NOT NULL COMMENT '操作描述',
  KEY `time` (`time`),
  KEY `uid` (`uid`),
  KEY `method` (`method`),
  KEY `item` (`item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='礼点消费记录';



DROP TABLE IF EXISTS `logs_rmb`;
CREATE TABLE IF NOT EXISTS `logs_rmb` (
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  `uid` int(10) unsigned NOT NULL COMMENT '玩家UID',
  `lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '人物等级',
  `method` char(32) NOT NULL COMMENT '方法&类型',
  `item` char(32) NOT NULL COMMENT '消费内容(如物口id)',
  `amount` int(11) NOT NULL COMMENT '金额',
  `balance` int(11) NOT NULL COMMENT '余额',
  `remark` char(254) NOT NULL COMMENT '操作描述',
  KEY `time` (`time`),
  KEY `uid` (`uid`),
  KEY `method` (`method`),
  KEY `item` (`item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消费钻石';




--
-- 表的结构 `logs_task`
--

DROP TABLE IF EXISTS `logs_task`;
CREATE TABLE IF NOT EXISTS `logs_task` (
  `uid`       int(10) unsigned NOT NULL COMMENT '玩家UID',
  `task_id`   char(32) NOT NULL COMMENT '主线任务ID',
  `task_type` char(32) NOT NULL COMMENT '任务类型 见常量',
  `time_accept` int(10) unsigned NOT NULL COMMENT '接受时间',
  `time_finish` int(10) unsigned NOT NULL COMMENT '完成时间',
  `state`       char(32) NOT NULL COMMENT '状态 ?CONST_FALSE 接受  ?CONST_TRUE 完成',
  PRIMARY KEY (`uid`,`task_id`),
  KEY `task_type` (`task_type`),
  KEY `time_accept` (`time_accept`),
  KEY `time_finish` (`time_finish`),
  KEY `state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务接受/完成率';


--
-- 表的结构 `logs_treasure`
--

DROP TABLE IF EXISTS `logs_treasure`;
CREATE TABLE IF NOT EXISTS `logs_treasure` (
  `uid`     int(10) unsigned NOT NULL COMMENT '玩家UID',
  `cen_up`  int(10) unsigned NOT NULL COMMENT '上一层',
  `cen`     int(10) unsigned NOT NULL COMMENT '当前层',
  `goods_id`int(10) unsigned NOT NULL COMMENT '当前物品id',
  `time`    int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='珍宝阁';

--
-- 表的结构 `logs_vip`
--

DROP TABLE IF EXISTS `logs_vip`;
CREATE TABLE IF NOT EXISTS `logs_vip` (
  `uid`   int(10) unsigned NOT NULL COMMENT '玩家UID',
  `lv_up` int(10) unsigned NOT NULL COMMENT '上一级',
  `lv`    int(10) unsigned NOT NULL COMMENT '当前级',
  `real_vip` int(10) unsigned NOT NULL COMMENT '真实vip等级',
  `time`  int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='vip';

--
-- 表的结构 `logs_magic`
--

DROP TABLE IF EXISTS `logs_magic`;
CREATE TABLE IF NOT EXISTS `logs_magic` (
  `uid`        int(10) unsigned NOT NULL COMMENT '玩家UID',
  `magic_id`   int(10) unsigned NOT NULL COMMENT '神器ID',
  `strenlv_up` int(10) unsigned NOT NULL COMMENT '强化前等级',
  `strenlv`    int(10) unsigned NOT NULL COMMENT '强化后等级',
  `state`      int(10) unsigned NOT NULL COMMENT '?CONST_TRUE成功 ?CONST_FALSE失败',
  `goods`      int(10) unsigned NOT NULL COMMENT 'n:n为使用的道具Id 0:未使用道具',
  `time`       int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='神器强化';



--
-- 表的结构 `logs_magic_step`
--

DROP TABLE IF EXISTS `logs_magic_step`;
CREATE TABLE IF NOT EXISTS `logs_magic_step` (
  `uid` int(10) unsigned NOT NULL COMMENT '玩家UID',
  `p_magic_id` int(10) unsigned NOT NULL COMMENT '进阶前神器',
  `magic_id` int(10) unsigned NOT NULL COMMENT '进阶后神器',
  `p_steplv` int(10) unsigned NOT NULL COMMENT '进阶前神器',
  `steplv` int(10) unsigned NOT NULL COMMENT '进阶后神器',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='神器进阶';


--
-- 表的结构 `logs_clan`
--

DROP TABLE IF EXISTS `logs_clan`;
CREATE TABLE IF NOT EXISTS `logs_clan` (
  `uid` int(10) unsigned NOT NULL COMMENT '玩家UID',
  `cid` int(10) unsigned NOT NULL COMMENT '帮派ID',
  `clan_name` char(32) NOT NULL COMMENT '帮派名字',
  `state`     int(10) unsigned NOT NULL COMMENT '?CONST_TRUE(加入) ?CONST_FALSE(退出)',
  `method` char(32)  NOT NULL COMMENT '方法',
  `time`   int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `cid` (`cid`),
  KEY `time` (`time`),
  KEY `method` (`method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='社团加入退出记录';


--
-- 表的结构 `logs_wang`
--

DROP TABLE IF EXISTS `logs_wang`;
CREATE TABLE IF NOT EXISTS `logs_wang` (
  `uid` int(10) unsigned NOT NULL COMMENT '前任社长Uid',
  `cid` int(10) unsigned NOT NULL COMMENT '帮派ID',
  `clan_name` char(32) NOT NULL COMMENT '帮派名字',
  `wang_uid` int(10) unsigned NOT NULL COMMENT '现任社长Uid',
  `method` char(32)  NOT NULL COMMENT '方法',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `cid` (`cid`),
  KEY `time` (`time`),
  KEY `method` (`method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='社团更换社长记录';

--
-- 表的结构 `logs_douqi`
--

DROP TABLE IF EXISTS `logs_douqi`;
CREATE TABLE IF NOT EXISTS `logs_douqi` (
  `uid` int(10) unsigned NOT NULL COMMENT '玩家Uid',
  `douqi_id` int(10) unsigned NOT NULL COMMENT '斗气Id',
  `douqi_type` int(10) unsigned NOT NULL COMMENT '斗气类型',
  `state` int(10) unsigned NOT NULL COMMENT '1:获得 0:失去',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `douqi_id` (`douqi_id`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='斗气获得/吞噬记录';

--
-- 表的结构 `logs_skill`
--


DROP TABLE IF EXISTS `logs_skill`;
CREATE TABLE IF NOT EXISTS `logs_skill` (
  `uid` int(10) unsigned NOT NULL COMMENT '玩家Uid',
  `skill_id` int(10) unsigned NOT NULL COMMENT '技能ID',
  `lv_up` int(10) unsigned NOT NULL COMMENT '升级前等级',
  `lv` int(10) unsigned NOT NULL COMMENT '升级后等级',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  `gold` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '''消耗美刀''',
  `power` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '''消耗战功''',
  KEY `uid` (`uid`),
  KEY `skill_id` (`skill_id`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='技能升级记录';


--
-- 表的结构 `logs_partner_skill`
--

DROP TABLE IF EXISTS `logs_partner_skill`;
CREATE TABLE IF NOT EXISTS `logs_partner_skill` (
  `uid` int(10) unsigned NOT NULL COMMENT '玩家Uid',
  `partner_id` int(10) unsigned NOT NULL COMMENT '伙伴ID',
  `skill_id` int(10) unsigned NOT NULL COMMENT '技能ID',
  `lv_up` int(10) unsigned NOT NULL COMMENT '升级前等级',
  `lv` int(10) unsigned NOT NULL COMMENT '升级后等级',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `partner_id` (`partner_id`),
  KEY `skill_id` (`skill_id`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='伙伴技能升级记录';


--
-- 表的结构 `logs_arena_rank`
--

DROP TABLE IF EXISTS `logs_arena_rank`;
CREATE TABLE IF NOT EXISTS `logs_arena_rank` (
  `uid` int(10) unsigned NOT NULL COMMENT '玩家Uid',
  `rank_up` int(10) unsigned NOT NULL COMMENT '挑战前排名',
  `rank` int(10) unsigned NOT NULL COMMENT '挑战后排名',
  `count` int(10) unsigned NOT NULL COMMENT '剩余次数',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='逐鹿台挑战记录';

--
-- 表的结构 `logs_inn`
--

DROP TABLE IF EXISTS `logs_inn`;
CREATE TABLE IF NOT EXISTS `logs_inn` (
  `uid` int(10) unsigned NOT NULL COMMENT '玩家Uid',
  `partner` int(10) unsigned NOT NULL COMMENT '伙伴ID',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `partner` (`partner`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='酒吧记录';

--
-- 表的结构 `logs_inn_lv`
--

DROP TABLE IF EXISTS `logs_inn_lv`;
CREATE TABLE IF NOT EXISTS `logs_inn_lv` (
  `uid` int(10) unsigned NOT NULL COMMENT '玩家Uid',
  `partner` int(10) unsigned NOT NULL COMMENT '伙伴ID',
  `lv_up` int(10) unsigned NOT NULL COMMENT '伙伴升级前等级',
  `lv` int(10) unsigned NOT NULL COMMENT '伙伴升级后等级',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `partner` (`partner`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='伙伴升级记录';


--
-- 表的结构 `logs_energy`
--

DROP TABLE IF EXISTS `logs_energy`;
CREATE TABLE IF NOT EXISTS `logs_energy` (
  `uid`     int(10) unsigned NOT NULL COMMENT '玩家Uid',
  `method`  char(32) NOT NULL COMMENT '函数&类型',
  `amount`  int(11)  NOT NULL COMMENT '精力',
  `balance` int(10) unsigned NOT NULL COMMENT '剩余精力',
  `remark`  int(10) unsigned NOT NULL COMMENT '描述',
  `time`    int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `method` (`method`),
  KEY `remark` (`remark`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='体力记录';

--
-- 表的结构 `logs_devote`  
--

DROP TABLE IF EXISTS `logs_devote`; 
CREATE TABLE IF NOT EXISTS `logs_devote` (
  `uid`     int(10) unsigned NOT NULL COMMENT '玩家Uid',
  `method`  char(32) NOT NULL COMMENT '函数&类型',
  `clan_id`  int(10) unsigned NOT NULL COMMENT '帮派Id',
  `amount` int(11) NOT NULL COMMENT '消耗帮派贡献',
  `balance` int(10) unsigned NOT NULL COMMENT '剩余帮派贡献',
  `remark` char(254) NOT NULL COMMENT '操作描述',
  `time`    int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `method` (`method`),
  KEY `remark` (`remark`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='帮派贡献记录';



--
-- 表的结构 `logs_clan_skill`

DROP TABLE IF EXISTS `logs_clan_skill`;
CREATE TABLE IF NOT EXISTS `logs_clan_skill` (
  `uid`     int(10) unsigned NOT NULL COMMENT '玩家Uid',
  `method`  char(32) NOT NULL COMMENT '函数&类型',
  `clan_id`  int(10) unsigned NOT NULL COMMENT '帮派Id',
  `type`  int(10) unsigned NOT NULL COMMENT '学习技能类别',
  `time`    int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `method` (`method`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='帮派技能';



--
-- 表的结构 `logs_sign`
--

DROP TABLE IF EXISTS `logs_sign`;
CREATE TABLE IF NOT EXISTS `logs_sign` (
  `uid`        int(10) unsigned NOT NULL COMMENT '玩家UID',
  `num`		   int(10) unsigned NOT NULL COMMENT '连续登陆的天数',
  `time`       int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='登陆签到';



--
-- 表的结构 `logs_shoot`
--

DROP TABLE IF EXISTS `logs_shoot`;
CREATE TABLE IF NOT EXISTS `logs_shoot` (
  `uid`        int(10) unsigned NOT NULL COMMENT '玩家UID',
  `pftime`     int(10) unsigned NOT NULL COMMENT '射箭之前剩余免费次数',
  `ftime`      int(10) unsigned NOT NULL COMMENT '剩余免费次数',
  `pptime`     int(10) unsigned NOT NULL COMMENT '射箭之前剩余付费次数',
  `ptime`      int(10) unsigned NOT NULL COMMENT '剩余付费次数',
  `time`       int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='每日一箭';


--
-- 表的结构 `logs_weagod`
--

DROP TABLE IF EXISTS `logs_weagod`;
CREATE TABLE IF NOT EXISTS `logs_weagod` (
  `uid`        int(10) unsigned NOT NULL COMMENT '玩家UID',
  `type`       int(10) unsigned NOT NULL COMMENT '招财类型（1：单次招财；2：批量招财；3：自动招财）',
  `money`      int(10) unsigned NOT NULL COMMENT '招财获得的美刀数',
  `rmb`        int(10) unsigned NOT NULL COMMENT '招财花费的钻石数',
  `times`      int(10) unsigned NOT NULL COMMENT '剩余招财次数',
  `time`       int(10) unsigned NOT NULL COMMENT '时间',
  KEY `uid` (`uid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='招财';





