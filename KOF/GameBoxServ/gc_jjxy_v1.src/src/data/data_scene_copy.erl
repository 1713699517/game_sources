-module(data_scene_copy).
-include("../include/comm.hrl").

-export([get/1,ids/0,belong/1]).

%% get(CopyId) -> 副本数据 
get(20010)->
	#d_copy{
		 copy_id		= 20010,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20010,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 20020,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20010]	% 场景列表
	};
get(20020)->
	#d_copy{
		 copy_id		= 20020,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20020,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20010,	% 前置副本Id
		 next_copy_id= 20030,	% 下一个副本Id
		 lv			= 2,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20020]	% 场景列表
	};
get(20030)->
	#d_copy{
		 copy_id		= 20030,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20030,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20020,	% 前置副本Id
		 next_copy_id= 20040,	% 下一个副本Id
		 lv			= 3,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20030]	% 场景列表
	};
get(20040)->
	#d_copy{
		 copy_id		= 20040,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20040,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20030,	% 前置副本Id
		 next_copy_id= 20050,	% 下一个副本Id
		 lv			= 5,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20040]	% 场景列表
	};
get(20050)->
	#d_copy{
		 copy_id		= 20050,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20050,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20040,	% 前置副本Id
		 next_copy_id= 20060,	% 下一个副本Id
		 lv			= 6,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20050]	% 场景列表
	};
get(20060)->
	#d_copy{
		 copy_id		= 20060,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20060,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 20070,	% 下一个副本Id
		 lv			= 8,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20060]	% 场景列表
	};
get(20070)->
	#d_copy{
		 copy_id		= 20070,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20070,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20060,	% 前置副本Id
		 next_copy_id= 20080,	% 下一个副本Id
		 lv			= 9,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20070]	% 场景列表
	};
get(20080)->
	#d_copy{
		 copy_id		= 20080,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20080,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20070,	% 前置副本Id
		 next_copy_id= 20090,	% 下一个副本Id
		 lv			= 10,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20080]	% 场景列表
	};
get(20090)->
	#d_copy{
		 copy_id		= 20090,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20090,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20080,	% 前置副本Id
		 next_copy_id= 20100,	% 下一个副本Id
		 lv			= 12,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20090]	% 场景列表
	};
get(20100)->
	#d_copy{
		 copy_id		= 20100,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20100,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20090,	% 前置副本Id
		 next_copy_id= 20110,	% 下一个副本Id
		 lv			= 13,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20100]	% 场景列表
	};
get(20110)->
	#d_copy{
		 copy_id		= 20110,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20110,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20100,	% 前置副本Id
		 next_copy_id= 20120,	% 下一个副本Id
		 lv			= 14,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20110]	% 场景列表
	};
get(20120)->
	#d_copy{
		 copy_id		= 20120,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20120,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20110,	% 前置副本Id
		 next_copy_id= 20130,	% 下一个副本Id
		 lv			= 15,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20120]	% 场景列表
	};
get(20130)->
	#d_copy{
		 copy_id		= 20130,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20130,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20120,	% 前置副本Id
		 next_copy_id= 20140,	% 下一个副本Id
		 lv			= 16,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20130]	% 场景列表
	};
get(20140)->
	#d_copy{
		 copy_id		= 20140,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20140,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20130,	% 前置副本Id
		 next_copy_id= 20150,	% 下一个副本Id
		 lv			= 17,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20140]	% 场景列表
	};
get(20150)->
	#d_copy{
		 copy_id		= 20150,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20150,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 20160,	% 下一个副本Id
		 lv			= 18,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20150]	% 场景列表
	};
get(20160)->
	#d_copy{
		 copy_id		= 20160,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20160,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20150,	% 前置副本Id
		 next_copy_id= 20170,	% 下一个副本Id
		 lv			= 20,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20160]	% 场景列表
	};
get(20170)->
	#d_copy{
		 copy_id		= 20170,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20170,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20160,	% 前置副本Id
		 next_copy_id= 20171,	% 下一个副本Id
		 lv			= 21,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20170]	% 场景列表
	};
get(20180)->
	#d_copy{
		 copy_id		= 20180,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20180,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20172,	% 前置副本Id
		 next_copy_id= 20190,	% 下一个副本Id
		 lv			= 24,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20180]	% 场景列表
	};
get(20190)->
	#d_copy{
		 copy_id		= 20190,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20190,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20180,	% 前置副本Id
		 next_copy_id= 20200,	% 下一个副本Id
		 lv			= 25,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20190]	% 场景列表
	};
get(20200)->
	#d_copy{
		 copy_id		= 20200,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20200,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20190,	% 前置副本Id
		 next_copy_id= 20210,	% 下一个副本Id
		 lv			= 26,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20200]	% 场景列表
	};
get(20210)->
	#d_copy{
		 copy_id		= 20210,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20210,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20200,	% 前置副本Id
		 next_copy_id= 20220,	% 下一个副本Id
		 lv			= 27,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20210]	% 场景列表
	};
get(20220)->
	#d_copy{
		 copy_id		= 20220,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20220,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20210,	% 前置副本Id
		 next_copy_id= 20230,	% 下一个副本Id
		 lv			= 28,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20220]	% 场景列表
	};
get(20230)->
	#d_copy{
		 copy_id		= 20230,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20230,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20220,	% 前置副本Id
		 next_copy_id= 20240,	% 下一个副本Id
		 lv			= 29,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20230]	% 场景列表
	};
get(20240)->
	#d_copy{
		 copy_id		= 20240,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20240,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20230,	% 前置副本Id
		 next_copy_id= 20250,	% 下一个副本Id
		 lv			= 30,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20240]	% 场景列表
	};
get(20250)->
	#d_copy{
		 copy_id		= 20250,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20250,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20240,	% 前置副本Id
		 next_copy_id= 20260,	% 下一个副本Id
		 lv			= 31,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20250]	% 场景列表
	};
get(20260)->
	#d_copy{
		 copy_id		= 20260,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20260,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20250,	% 前置副本Id
		 next_copy_id= 20270,	% 下一个副本Id
		 lv			= 32,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20260]	% 场景列表
	};
get(20270)->
	#d_copy{
		 copy_id		= 20270,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20270,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 20280,	% 下一个副本Id
		 lv			= 34,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20270]	% 场景列表
	};
get(20280)->
	#d_copy{
		 copy_id		= 20280,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20280,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20270,	% 前置副本Id
		 next_copy_id= 20290,	% 下一个副本Id
		 lv			= 35,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20280]	% 场景列表
	};
get(20290)->
	#d_copy{
		 copy_id		= 20290,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20290,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20280,	% 前置副本Id
		 next_copy_id= 20300,	% 下一个副本Id
		 lv			= 36,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20290]	% 场景列表
	};
get(20300)->
	#d_copy{
		 copy_id		= 20300,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20300,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20290,	% 前置副本Id
		 next_copy_id= 20310,	% 下一个副本Id
		 lv			= 38,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20300]	% 场景列表
	};
get(20310)->
	#d_copy{
		 copy_id		= 20310,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20310,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20300,	% 前置副本Id
		 next_copy_id= 20320,	% 下一个副本Id
		 lv			= 39,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20310]	% 场景列表
	};
get(20320)->
	#d_copy{
		 copy_id		= 20320,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20320,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20310,	% 前置副本Id
		 next_copy_id= 20330,	% 下一个副本Id
		 lv			= 40,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20320]	% 场景列表
	};
get(20330)->
	#d_copy{
		 copy_id		= 20330,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20330,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20320,	% 前置副本Id
		 next_copy_id= 20340,	% 下一个副本Id
		 lv			= 42,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20330]	% 场景列表
	};
get(20340)->
	#d_copy{
		 copy_id		= 20340,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20340,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20330,	% 前置副本Id
		 next_copy_id= 20350,	% 下一个副本Id
		 lv			= 43,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20340]	% 场景列表
	};
get(20350)->
	#d_copy{
		 copy_id		= 20350,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20350,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20340,	% 前置副本Id
		 next_copy_id= 20360,	% 下一个副本Id
		 lv			= 44,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20350]	% 场景列表
	};
get(20360)->
	#d_copy{
		 copy_id		= 20360,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20360,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 20370,	% 下一个副本Id
		 lv			= 46,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20360]	% 场景列表
	};
get(20370)->
	#d_copy{
		 copy_id		= 20370,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20370,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20360,	% 前置副本Id
		 next_copy_id= 20380,	% 下一个副本Id
		 lv			= 47,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20370]	% 场景列表
	};
get(20380)->
	#d_copy{
		 copy_id		= 20380,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20380,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20370,	% 前置副本Id
		 next_copy_id= 20390,	% 下一个副本Id
		 lv			= 48,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20380]	% 场景列表
	};
get(20390)->
	#d_copy{
		 copy_id		= 20390,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20390,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20380,	% 前置副本Id
		 next_copy_id= 20400,	% 下一个副本Id
		 lv			= 49,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20390]	% 场景列表
	};
get(20400)->
	#d_copy{
		 copy_id		= 20400,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20400,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20390,	% 前置副本Id
		 next_copy_id= 20410,	% 下一个副本Id
		 lv			= 50,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20400]	% 场景列表
	};
get(20410)->
	#d_copy{
		 copy_id		= 20410,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20410,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20400,	% 前置副本Id
		 next_copy_id= 20420,	% 下一个副本Id
		 lv			= 51,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20410]	% 场景列表
	};
get(20420)->
	#d_copy{
		 copy_id		= 20420,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20420,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20410,	% 前置副本Id
		 next_copy_id= 20430,	% 下一个副本Id
		 lv			= 53,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20420]	% 场景列表
	};
get(20430)->
	#d_copy{
		 copy_id		= 20430,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20430,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20420,	% 前置副本Id
		 next_copy_id= 20440,	% 下一个副本Id
		 lv			= 54,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20430]	% 场景列表
	};
get(20440)->
	#d_copy{
		 copy_id		= 20440,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20440,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20430,	% 前置副本Id
		 next_copy_id= 20450,	% 下一个副本Id
		 lv			= 55,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20440]	% 场景列表
	};
get(20450)->
	#d_copy{
		 copy_id		= 20450,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20450,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 20460,	% 下一个副本Id
		 lv			= 59,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20450]	% 场景列表
	};
get(20460)->
	#d_copy{
		 copy_id		= 20460,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20460,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 20450,	% 前置副本Id
		 next_copy_id= 20470,	% 下一个副本Id
		 lv			= 61,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20460]	% 场景列表
	};
get(30010)->
	#d_copy{
		 copy_id		= 30010,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30010,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 30020,	% 下一个副本Id
		 lv			= 20,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30010]	% 场景列表
	};
get(30020)->
	#d_copy{
		 copy_id		= 30020,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30020,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30010,	% 前置副本Id
		 next_copy_id= 30030,	% 下一个副本Id
		 lv			= 20,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30020]	% 场景列表
	};
get(30030)->
	#d_copy{
		 copy_id		= 30030,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30030,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30020,	% 前置副本Id
		 next_copy_id= 30040,	% 下一个副本Id
		 lv			= 20,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30030]	% 场景列表
	};
get(30040)->
	#d_copy{
		 copy_id		= 30040,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30040,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30030,	% 前置副本Id
		 next_copy_id= 30050,	% 下一个副本Id
		 lv			= 20,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30040]	% 场景列表
	};
get(30050)->
	#d_copy{
		 copy_id		= 30050,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30050,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30040,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 20,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30050]	% 场景列表
	};
get(30060)->
	#d_copy{
		 copy_id		= 30060,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30060,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 30070,	% 下一个副本Id
		 lv			= 30,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30060]	% 场景列表
	};
get(30070)->
	#d_copy{
		 copy_id		= 30070,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30070,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30060,	% 前置副本Id
		 next_copy_id= 30080,	% 下一个副本Id
		 lv			= 30,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30070]	% 场景列表
	};
get(32010)->
	#d_copy{
		 copy_id		= 32010,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32010,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 32020,	% 下一个副本Id
		 lv			= 25,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32010]	% 场景列表
	};
get(32020)->
	#d_copy{
		 copy_id		= 32020,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32020,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32010,	% 前置副本Id
		 next_copy_id= 32030,	% 下一个副本Id
		 lv			= 25,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32020]	% 场景列表
	};
get(32030)->
	#d_copy{
		 copy_id		= 32030,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32030,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32020,	% 前置副本Id
		 next_copy_id= 32040,	% 下一个副本Id
		 lv			= 25,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32030]	% 场景列表
	};
get(32040)->
	#d_copy{
		 copy_id		= 32040,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32040,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32030,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 25,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32040]	% 场景列表
	};
get(32050)->
	#d_copy{
		 copy_id		= 32050,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32050,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 32060,	% 下一个副本Id
		 lv			= 35,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32050]	% 场景列表
	};
get(32060)->
	#d_copy{
		 copy_id		= 32060,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32060,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32050,	% 前置副本Id
		 next_copy_id= 32070,	% 下一个副本Id
		 lv			= 35,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32060]	% 场景列表
	};
get(32070)->
	#d_copy{
		 copy_id		= 32070,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32070,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32060,	% 前置副本Id
		 next_copy_id= 32080,	% 下一个副本Id
		 lv			= 35,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32070]	% 场景列表
	};
get(40100)->
	#d_copy{
		 copy_id		= 40100,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40100,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 40110,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40100,40101,40102]	% 场景列表
	};
get(40110)->
	#d_copy{
		 copy_id		= 40110,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40110,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40100,	% 前置副本Id
		 next_copy_id= 40120,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40110,40111,40112]	% 场景列表
	};
get(40120)->
	#d_copy{
		 copy_id		= 40120,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40120,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40110,	% 前置副本Id
		 next_copy_id= 40130,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40120,40121,40122]	% 场景列表
	};
get(40130)->
	#d_copy{
		 copy_id		= 40130,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40130,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40120,	% 前置副本Id
		 next_copy_id= 40140,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40130,40131,40132]	% 场景列表
	};
get(40140)->
	#d_copy{
		 copy_id		= 40140,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40140,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40130,	% 前置副本Id
		 next_copy_id= 40150,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40140,40141,40142]	% 场景列表
	};
get(40150)->
	#d_copy{
		 copy_id		= 40150,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40150,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40140,	% 前置副本Id
		 next_copy_id= 40160,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40150,40151,40152]	% 场景列表
	};
get(40160)->
	#d_copy{
		 copy_id		= 40160,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40160,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40150,	% 前置副本Id
		 next_copy_id= 40170,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40160,40161,40162]	% 场景列表
	};
get(40170)->
	#d_copy{
		 copy_id		= 40170,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40170,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40160,	% 前置副本Id
		 next_copy_id= 40180,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40170,40171,40172]	% 场景列表
	};
get(30080)->
	#d_copy{
		 copy_id		= 30080,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30080,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30070,	% 前置副本Id
		 next_copy_id= 30090,	% 下一个副本Id
		 lv			= 30,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30080]	% 场景列表
	};
get(40180)->
	#d_copy{
		 copy_id		= 40180,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40180,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40170,	% 前置副本Id
		 next_copy_id= 40190,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40180,40181,40182]	% 场景列表
	};
get(40190)->
	#d_copy{
		 copy_id		= 40190,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40190,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40180,	% 前置副本Id
		 next_copy_id= 40200,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40190,40191,40192]	% 场景列表
	};
get(40200)->
	#d_copy{
		 copy_id		= 40200,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40200,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40190,	% 前置副本Id
		 next_copy_id= 40210,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40200,40201,40202]	% 场景列表
	};
get(40210)->
	#d_copy{
		 copy_id		= 40210,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40210,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40200,	% 前置副本Id
		 next_copy_id= 40220,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40210,40211,40212]	% 场景列表
	};
get(50001)->
	#d_copy{
		 copy_id		= 50001,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 0,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 0,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40200,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [50001]	% 场景列表
	};
get(34010)->
	#d_copy{
		 copy_id		= 34010,	% 副本Id
		 copy_type	= 5,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 34010,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 34010,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [34010]	% 场景列表
	};
get(34020)->
	#d_copy{
		 copy_id		= 34020,	% 副本Id
		 copy_type	= 5,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 34020,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 34020,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [34020]	% 场景列表
	};
get(34030)->
	#d_copy{
		 copy_id		= 34030,	% 副本Id
		 copy_type	= 5,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 34030,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 34030,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [34030]	% 场景列表
	};
get(20171)->
	#d_copy{
		 copy_id		= 20171,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20171,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20170,	% 前置副本Id
		 next_copy_id= 20172,	% 下一个副本Id
		 lv			= 22,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20171]	% 场景列表
	};
get(30090)->
	#d_copy{
		 copy_id		= 30090,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30090,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30080,	% 前置副本Id
		 next_copy_id= 30100,	% 下一个副本Id
		 lv			= 30,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30090]	% 场景列表
	};
get(30100)->
	#d_copy{
		 copy_id		= 30100,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30100,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30090,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 30,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30100]	% 场景列表
	};
get(30110)->
	#d_copy{
		 copy_id		= 30110,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30110,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 30120,	% 下一个副本Id
		 lv			= 40,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30110]	% 场景列表
	};
get(30120)->
	#d_copy{
		 copy_id		= 30120,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30120,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30110,	% 前置副本Id
		 next_copy_id= 30130,	% 下一个副本Id
		 lv			= 40,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30120]	% 场景列表
	};
get(30130)->
	#d_copy{
		 copy_id		= 30130,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30130,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30120,	% 前置副本Id
		 next_copy_id= 30140,	% 下一个副本Id
		 lv			= 40,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30130]	% 场景列表
	};
get(30140)->
	#d_copy{
		 copy_id		= 30140,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30140,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30130,	% 前置副本Id
		 next_copy_id= 30150,	% 下一个副本Id
		 lv			= 40,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30140]	% 场景列表
	};
get(30150)->
	#d_copy{
		 copy_id		= 30150,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30150,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30140,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 40,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30150]	% 场景列表
	};
get(30160)->
	#d_copy{
		 copy_id		= 30160,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30160,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 30170,	% 下一个副本Id
		 lv			= 50,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30160]	% 场景列表
	};
get(34040)->
	#d_copy{
		 copy_id		= 34040,	% 副本Id
		 copy_type	= 5,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 34040,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 34040,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [34040]	% 场景列表
	};
get(34050)->
	#d_copy{
		 copy_id		= 34050,	% 副本Id
		 copy_type	= 5,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 34050,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 34050,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [34050]	% 场景列表
	};
get(34060)->
	#d_copy{
		 copy_id		= 34060,	% 副本Id
		 copy_type	= 5,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 34060,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 34060,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [34060]	% 场景列表
	};
get(34070)->
	#d_copy{
		 copy_id		= 34070,	% 副本Id
		 copy_type	= 5,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 34070,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 34070,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [34070]	% 场景列表
	};
get(34080)->
	#d_copy{
		 copy_id		= 34080,	% 副本Id
		 copy_type	= 5,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 34080,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 34080,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [34080]	% 场景列表
	};
get(34090)->
	#d_copy{
		 copy_id		= 34090,	% 副本Id
		 copy_type	= 5,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 34090,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 34090,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [34090]	% 场景列表
	};
get(34100)->
	#d_copy{
		 copy_id		= 34100,	% 副本Id
		 copy_type	= 5,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 34100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 34100,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [34100]	% 场景列表
	};
get(20172)->
	#d_copy{
		 copy_id		= 20172,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20172,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20171,	% 前置副本Id
		 next_copy_id= 20180,	% 下一个副本Id
		 lv			= 23,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20172]	% 场景列表
	};
get(20470)->
	#d_copy{
		 copy_id		= 20470,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20470,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 20460,	% 前置副本Id
		 next_copy_id= 20480,	% 下一个副本Id
		 lv			= 62,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20470]	% 场景列表
	};
get(20480)->
	#d_copy{
		 copy_id		= 20480,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20480,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20470,	% 前置副本Id
		 next_copy_id= 20490,	% 下一个副本Id
		 lv			= 65,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20480]	% 场景列表
	};
get(20490)->
	#d_copy{
		 copy_id		= 20490,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20490,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20480,	% 前置副本Id
		 next_copy_id= 20500,	% 下一个副本Id
		 lv			= 66,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20490]	% 场景列表
	};
get(20500)->
	#d_copy{
		 copy_id		= 20500,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20500,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20490,	% 前置副本Id
		 next_copy_id= 20510,	% 下一个副本Id
		 lv			= 67,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20500]	% 场景列表
	};
get(20510)->
	#d_copy{
		 copy_id		= 20510,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20510,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20500,	% 前置副本Id
		 next_copy_id= 20520,	% 下一个副本Id
		 lv			= 69,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20510]	% 场景列表
	};
get(20520)->
	#d_copy{
		 copy_id		= 20520,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20520,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20510,	% 前置副本Id
		 next_copy_id= 20530,	% 下一个副本Id
		 lv			= 70,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20520]	% 场景列表
	};
get(20530)->
	#d_copy{
		 copy_id		= 20530,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20530,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20520,	% 前置副本Id
		 next_copy_id= 20540,	% 下一个副本Id
		 lv			= 71,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20530]	% 场景列表
	};
get(20540)->
	#d_copy{
		 copy_id		= 20540,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20540,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20530,	% 前置副本Id
		 next_copy_id= 20550,	% 下一个副本Id
		 lv			= 72,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20540]	% 场景列表
	};
get(20550)->
	#d_copy{
		 copy_id		= 20550,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20550,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20540,	% 前置副本Id
		 next_copy_id= 20560,	% 下一个副本Id
		 lv			= 73,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20550]	% 场景列表
	};
get(20560)->
	#d_copy{
		 copy_id		= 20560,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20560,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20550,	% 前置副本Id
		 next_copy_id= 20570,	% 下一个副本Id
		 lv			= 74,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20560]	% 场景列表
	};
get(20570)->
	#d_copy{
		 copy_id		= 20570,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11700,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20570,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 20580,	% 下一个副本Id
		 lv			= 76,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20570]	% 场景列表
	};
get(20580)->
	#d_copy{
		 copy_id		= 20580,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11700,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20580,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20570,	% 前置副本Id
		 next_copy_id= 20590,	% 下一个副本Id
		 lv			= 77,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20580]	% 场景列表
	};
get(20590)->
	#d_copy{
		 copy_id		= 20590,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11700,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20590,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20580,	% 前置副本Id
		 next_copy_id= 20600,	% 下一个副本Id
		 lv			= 78,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20590]	% 场景列表
	};
get(20600)->
	#d_copy{
		 copy_id		= 20600,	% 副本Id
		 copy_type	= 1,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 11700,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 20600,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 20590,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 80,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 5,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1001,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [20600]	% 场景列表
	};
get(30210)->
	#d_copy{
		 copy_id		= 30210,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30210,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 30220,	% 下一个副本Id
		 lv			= 60,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30210]	% 场景列表
	};
get(30170)->
	#d_copy{
		 copy_id		= 30170,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30170,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30160,	% 前置副本Id
		 next_copy_id= 30180,	% 下一个副本Id
		 lv			= 50,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30170]	% 场景列表
	};
get(30180)->
	#d_copy{
		 copy_id		= 30180,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30180,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30170,	% 前置副本Id
		 next_copy_id= 30190,	% 下一个副本Id
		 lv			= 50,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30180]	% 场景列表
	};
get(30190)->
	#d_copy{
		 copy_id		= 30190,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30190,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30180,	% 前置副本Id
		 next_copy_id= 30200,	% 下一个副本Id
		 lv			= 50,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30190]	% 场景列表
	};
get(30200)->
	#d_copy{
		 copy_id		= 30200,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30200,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 30190,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 50,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30200]	% 场景列表
	};
get(32080)->
	#d_copy{
		 copy_id		= 32080,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15200,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32080,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32070,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 35,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32080]	% 场景列表
	};
get(32090)->
	#d_copy{
		 copy_id		= 32090,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32090,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 32100,	% 下一个副本Id
		 lv			= 45,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32090]	% 场景列表
	};
get(32100)->
	#d_copy{
		 copy_id		= 32100,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32100,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32090,	% 前置副本Id
		 next_copy_id= 32110,	% 下一个副本Id
		 lv			= 45,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32100]	% 场景列表
	};
get(32110)->
	#d_copy{
		 copy_id		= 32110,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32110,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32100,	% 前置副本Id
		 next_copy_id= 32120,	% 下一个副本Id
		 lv			= 45,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32110]	% 场景列表
	};
get(32120)->
	#d_copy{
		 copy_id		= 32120,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15300,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32120,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32110,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 45,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32120]	% 场景列表
	};
get(30220)->
	#d_copy{
		 copy_id		= 30220,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30220,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 30210,	% 前置副本Id
		 next_copy_id= 30230,	% 下一个副本Id
		 lv			= 60,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30220]	% 场景列表
	};
get(30230)->
	#d_copy{
		 copy_id		= 30230,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30230,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 30220,	% 前置副本Id
		 next_copy_id= 30240,	% 下一个副本Id
		 lv			= 60,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30230]	% 场景列表
	};
get(30240)->
	#d_copy{
		 copy_id		= 30240,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30240,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 30230,	% 前置副本Id
		 next_copy_id= 30250,	% 下一个副本Id
		 lv			= 60,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30240]	% 场景列表
	};
get(30250)->
	#d_copy{
		 copy_id		= 30250,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30250,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 30240,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 60,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30250]	% 场景列表
	};
get(30260)->
	#d_copy{
		 copy_id		= 30260,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30260,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 30270,	% 下一个副本Id
		 lv			= 70,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30260]	% 场景列表
	};
get(30270)->
	#d_copy{
		 copy_id		= 30270,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30270,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 30260,	% 前置副本Id
		 next_copy_id= 30280,	% 下一个副本Id
		 lv			= 70,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30270]	% 场景列表
	};
get(30280)->
	#d_copy{
		 copy_id		= 30280,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30280,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 30270,	% 前置副本Id
		 next_copy_id= 30290,	% 下一个副本Id
		 lv			= 70,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30280]	% 场景列表
	};
get(30290)->
	#d_copy{
		 copy_id		= 30290,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30290,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 30280,	% 前置副本Id
		 next_copy_id= 30300,	% 下一个副本Id
		 lv			= 70,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30290]	% 场景列表
	};
get(30300)->
	#d_copy{
		 copy_id		= 30300,	% 副本Id
		 copy_type	= 2,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 13600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 30300,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 30290,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 70,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 10,	% 消耗体力
		 fast_vip		= 3,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 0,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [30300]	% 场景列表
	};
get(32130)->
	#d_copy{
		 copy_id		= 32130,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32130,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 32140,	% 下一个副本Id
		 lv			= 55,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32130]	% 场景列表
	};
get(32140)->
	#d_copy{
		 copy_id		= 32140,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32140,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32130,	% 前置副本Id
		 next_copy_id= 32150,	% 下一个副本Id
		 lv			= 55,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32140]	% 场景列表
	};
get(32150)->
	#d_copy{
		 copy_id		= 32150,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32150,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32140,	% 前置副本Id
		 next_copy_id= 32160,	% 下一个副本Id
		 lv			= 55,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32150]	% 场景列表
	};
get(32160)->
	#d_copy{
		 copy_id		= 32160,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15400,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32160,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 32150,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 55,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32160]	% 场景列表
	};
get(32170)->
	#d_copy{
		 copy_id		= 32170,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32170,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 32180,	% 下一个副本Id
		 lv			= 65,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32170]	% 场景列表
	};
get(32180)->
	#d_copy{
		 copy_id		= 32180,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32180,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 32170,	% 前置副本Id
		 next_copy_id= 32190,	% 下一个副本Id
		 lv			= 65,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32180]	% 场景列表
	};
get(32190)->
	#d_copy{
		 copy_id		= 32190,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32190,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 32180,	% 前置副本Id
		 next_copy_id= 32200,	% 下一个副本Id
		 lv			= 65,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32190]	% 场景列表
	};
get(32200)->
	#d_copy{
		 copy_id		= 32200,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15500,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32200,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 32190,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 65,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32200]	% 场景列表
	};
get(32210)->
	#d_copy{
		 copy_id		= 32210,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32210,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 0,	% 前置副本Id
		 next_copy_id= 32220,	% 下一个副本Id
		 lv			= 75,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32210]	% 场景列表
	};
get(32220)->
	#d_copy{
		 copy_id		= 32220,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32220,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 32210,	% 前置副本Id
		 next_copy_id= 32230,	% 下一个副本Id
		 lv			= 75,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32220]	% 场景列表
	};
get(32230)->
	#d_copy{
		 copy_id		= 32230,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32230,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 32220,	% 前置副本Id
		 next_copy_id= 32240,	% 下一个副本Id
		 lv			= 75,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32230]	% 场景列表
	};
get(32240)->
	#d_copy{
		 copy_id		= 32240,	% 副本Id
		 copy_type	= 3,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 15600,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 32240,    % 条件主健
		 task_id   = 10561,    % 前置任务
		 pre_copy_id = 32230,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 75,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 15,	% 消耗体力
		 fast_vip		= 1,		% 挂机加速VIP等级
		 score_id		= 1003,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [32240]	% 场景列表
	};
get(40220)->
	#d_copy{
		 copy_id		= 40220,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40220,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40210,	% 前置副本Id
		 next_copy_id= 40230,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40213,40214,40215]	% 场景列表
	};
get(40230)->
	#d_copy{
		 copy_id		= 40230,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40230,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40220,	% 前置副本Id
		 next_copy_id= 40240,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40216,40217,40218]	% 场景列表
	};
get(40240)->
	#d_copy{
		 copy_id		= 40240,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40240,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40230,	% 前置副本Id
		 next_copy_id= 40250,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40219,40220,40221]	% 场景列表
	};
get(40250)->
	#d_copy{
		 copy_id		= 40250,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40250,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40240,	% 前置副本Id
		 next_copy_id= 40260,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40222,40223,40224]	% 场景列表
	};
get(40260)->
	#d_copy{
		 copy_id		= 40260,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40260,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40250,	% 前置副本Id
		 next_copy_id= 40270,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40225,40226,40227]	% 场景列表
	};
get(40270)->
	#d_copy{
		 copy_id		= 40270,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40270,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40260,	% 前置副本Id
		 next_copy_id= 40280,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40228,40229,40230]	% 场景列表
	};
get(40280)->
	#d_copy{
		 copy_id		= 40280,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40280,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40270,	% 前置副本Id
		 next_copy_id= 40290,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40231,40232,40233]	% 场景列表
	};
get(40290)->
	#d_copy{
		 copy_id		= 40290,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40290,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40280,	% 前置副本Id
		 next_copy_id= 40300,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40234,40235,40236]	% 场景列表
	};
get(40300)->
	#d_copy{
		 copy_id		= 40300,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40300,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40290,	% 前置副本Id
		 next_copy_id= 40310,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40237,40238,40239]	% 场景列表
	};
get(40310)->
	#d_copy{
		 copy_id		= 40310,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40310,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40300,	% 前置副本Id
		 next_copy_id= 40320,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40240,40241,40242]	% 场景列表
	};
get(40320)->
	#d_copy{
		 copy_id		= 40320,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40320,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40310,	% 前置副本Id
		 next_copy_id= 40330,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40243,40244,40245]	% 场景列表
	};
get(40330)->
	#d_copy{
		 copy_id		= 40330,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40330,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40320,	% 前置副本Id
		 next_copy_id= 40340,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40246,40247,40248]	% 场景列表
	};
get(40340)->
	#d_copy{
		 copy_id		= 40340,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40340,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40330,	% 前置副本Id
		 next_copy_id= 40350,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40249,40250,40251]	% 场景列表
	};
get(40350)->
	#d_copy{
		 copy_id		= 40350,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40350,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40340,	% 前置副本Id
		 next_copy_id= 40360,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40252,40253,40254]	% 场景列表
	};
get(40360)->
	#d_copy{
		 copy_id		= 40360,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40360,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40350,	% 前置副本Id
		 next_copy_id= 40370,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40255,40256,40257]	% 场景列表
	};
get(40370)->
	#d_copy{
		 copy_id		= 40370,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40370,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40360,	% 前置副本Id
		 next_copy_id= 40380,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40258,40259,40260]	% 场景列表
	};
get(40380)->
	#d_copy{
		 copy_id		= 40380,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40380,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40370,	% 前置副本Id
		 next_copy_id= 40390,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40261,40262,40263]	% 场景列表
	};
get(40390)->
	#d_copy{
		 copy_id		= 40390,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40390,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40380,	% 前置副本Id
		 next_copy_id= 40400,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40264,40265,40266]	% 场景列表
	};
get(40400)->
	#d_copy{
		 copy_id		= 40400,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40400,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40390,	% 前置副本Id
		 next_copy_id= 40410,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40267,40268,40269]	% 场景列表
	};
get(40410)->
	#d_copy{
		 copy_id		= 40410,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40410,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40400,	% 前置副本Id
		 next_copy_id= 40420,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40270,40271,40272]	% 场景列表
	};
get(40420)->
	#d_copy{
		 copy_id		= 40420,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40420,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40410,	% 前置副本Id
		 next_copy_id= 40430,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40273,40274,40275]	% 场景列表
	};
get(40430)->
	#d_copy{
		 copy_id		= 40430,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40430,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40420,	% 前置副本Id
		 next_copy_id= 40440,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40276,40277,40278]	% 场景列表
	};
get(40440)->
	#d_copy{
		 copy_id		= 40440,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40440,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40430,	% 前置副本Id
		 next_copy_id= 40450,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40279,40280,40281]	% 场景列表
	};
get(40450)->
	#d_copy{
		 copy_id		= 40450,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40450,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40440,	% 前置副本Id
		 next_copy_id= 40460,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40282,40283,40284]	% 场景列表
	};
get(40460)->
	#d_copy{
		 copy_id		= 40460,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40460,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40450,	% 前置副本Id
		 next_copy_id= 40470,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40285,40286,40287]	% 场景列表
	};
get(40470)->
	#d_copy{
		 copy_id		= 40470,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40470,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40460,	% 前置副本Id
		 next_copy_id= 40480,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40288,40289,40290]	% 场景列表
	};
get(40480)->
	#d_copy{
		 copy_id		= 40480,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40480,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40470,	% 前置副本Id
		 next_copy_id= 40490,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40291,40292,40293]	% 场景列表
	};
get(40490)->
	#d_copy{
		 copy_id		= 40490,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40490,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40480,	% 前置副本Id
		 next_copy_id= 40500,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40294,40295,40296]	% 场景列表
	};
get(40500)->
	#d_copy{
		 copy_id		= 40500,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40500,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40490,	% 前置副本Id
		 next_copy_id= 40510,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40297,40298,40299]	% 场景列表
	};
get(40510)->
	#d_copy{
		 copy_id		= 40510,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40510,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40500,	% 前置副本Id
		 next_copy_id= 40520,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40300,40301,40302]	% 场景列表
	};
get(40520)->
	#d_copy{
		 copy_id		= 40520,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40520,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40510,	% 前置副本Id
		 next_copy_id= 40530,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40303,40304,40305]	% 场景列表
	};
get(40530)->
	#d_copy{
		 copy_id		= 40530,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40530,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40520,	% 前置副本Id
		 next_copy_id= 40540,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40306,40307,40308]	% 场景列表
	};
get(40540)->
	#d_copy{
		 copy_id		= 40540,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40540,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40530,	% 前置副本Id
		 next_copy_id= 40550,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40309,40310,40311]	% 场景列表
	};
get(40550)->
	#d_copy{
		 copy_id		= 40550,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40550,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40540,	% 前置副本Id
		 next_copy_id= 40560,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40312,40313,40314]	% 场景列表
	};
get(40560)->
	#d_copy{
		 copy_id		= 40560,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40560,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40550,	% 前置副本Id
		 next_copy_id= 40570,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40315,40316,40317]	% 场景列表
	};
get(40570)->
	#d_copy{
		 copy_id		= 40570,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40570,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40560,	% 前置副本Id
		 next_copy_id= 40580,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40318,40319,40320]	% 场景列表
	};
get(40580)->
	#d_copy{
		 copy_id		= 40580,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40580,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40570,	% 前置副本Id
		 next_copy_id= 40590,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40321,40322,40323]	% 场景列表
	};
get(40590)->
	#d_copy{
		 copy_id		= 40590,	% 副本Id
		 copy_type	= 4,	% 类型
		 relive_lim	= 0,% 复活次数
		 belong_id   = 17100,	% 上级Id(退出副本回去的场景ID)
		 key_id	   = 40590,    % 条件主健
		 task_id   = 0,    % 前置任务
		 pre_copy_id = 40580,	% 前置副本Id
		 next_copy_id= 0,	% 下一个副本Id
		 lv			= 1,	% 等级
		 lv_max		= 999,	% 等级上限
		 time			= 0,	% 限时(秒)
		 use_energy	= 0,	% 消耗体力
		 fast_vip		= 0,		% 挂机加速VIP等级
		 score_id		= 1002,		% 挂机加速VIP等级
		 times_max_day	= 1,	% 每天上限次数
		 flop			= [],	%% 掉落
		 scene		= [40324,40325,40326]	% 场景列表
	};
get(_)->?null.


%% belong(BelongId) -> 旗下 副本ID 
belong(11100)->[20010,20020,20030,20040,20050]; 
belong(11200)->[20060,20070,20080,20090,20100,20110,20120,20130,20140]; 
belong(11300)->[20150,20160,20170,20171,20172,20180,20190,20200,20210,20220,20230,20240,20250,20260]; 
belong(11400)->[20270,20280,20290,20300,20310,20320,20330,20340,20350]; 
belong(11500)->[20360,20370,20380,20390,20400,20410,20420,20430,20440]; 
belong(11600)->[20450,20460,20470,20480,20490,20500,20510,20520,20530,20540,20550,20560]; 
belong(13100)->[30010,30020,30030,30040,30050]; 
belong(13200)->[30060,30070,30080,30090,30100]; 
belong(15100)->[32010,32020,32030,32040]; 
belong(15200)->[32050,32060,32070,32080]; 
belong(17100)->[40100,40110,40120,40130,40140,40150,40160,40170,40180,40190,40200,40210,40220,40230,40240,40250,40260,40270,40280,40290,40300,40310,40320,40330,40340,40350,40360,40370,40380,40390,40400,40410,40420,40430,40440,40450,40460,40470,40480,40490,40500,40510,40520,40530,40540,40550,40560,40570,40580,40590]; 
belong(0)->[50001];%% <!有误> 
belong(34010)->[34010]; 
belong(34020)->[34020]; 
belong(34030)->[34030]; 
belong(13300)->[30110,30120,30130,30140,30150]; 
belong(13400)->[30160,30170,30180,30190,30200]; 
belong(34040)->[34040]; 
belong(34050)->[34050]; 
belong(34060)->[34060]; 
belong(34070)->[34070]; 
belong(34080)->[34080]; 
belong(34090)->[34090]; 
belong(34100)->[34100]; 
belong(11700)->[20570,20580,20590,20600]; 
belong(13500)->[30210,30220,30230,30240,30250]; 
belong(15300)->[32090,32100,32110,32120]; 
belong(13600)->[30260,30270,30280,30290,30300]; 
belong(15400)->[32130,32140,32150,32160]; 
belong(15500)->[32170,32180,32190,32200]; 
belong(15600)->[32210,32220,32230,32240]; 
belong(_)->[].



%% ids() -> [副本ID,...] 
ids()->[20010,20020,20030,20040,20050,20060,20070,20080,20090,20100,20110,20120,20130,20140,20150,20160,20170,20180,20190,20200,20210,20220,20230,20240,20250,20260,20270,20280,20290,20300,20310,20320,20330,20340,20350,20360,20370,20380,20390,20400,20410,20420,20430,20440,20450,20460,30010,30020,30030,30040,30050,30060,30070,32010,32020,32030,32040,32050,32060,32070,40100,40110,40120,40130,40140,40150,40160,40170,30080,40180,40190,40200,40210,50001,34010,34020,34030,20171,30090,30100,30110,30120,30130,30140,30150,30160,34040,34050,34060,34070,34080,34090,34100,20172,20470,20480,20490,20500,20510,20520,20530,20540,20550,20560,20570,20580,20590,20600,30210,30170,30180,30190,30200,32080,32090,32100,32110,32120,30220,30230,30240,30250,30260,30270,30280,30290,30300,32130,32140,32150,32160,32170,32180,32190,32200,32210,32220,32230,32240,40220,40230,40240,40250,40260,40270,40280,40290,40300,40310,40320,40330,40340,40350,40360,40370,40380,40390,40400,40410,40420,40430,40440,40450,40460,40470,40480,40490,40500,40510,40520,40530,40540,40550,40560,40570,40580,40590].


