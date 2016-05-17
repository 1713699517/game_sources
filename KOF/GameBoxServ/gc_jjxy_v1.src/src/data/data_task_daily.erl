-module(data_task_daily).
-include("../include/comm.hrl").

-export([get/1,get_ids/0]).

% 类型：1、强化装备；2、完成副本N次；3、领悟斗气N次，4连击副本;
% 目标值：1、次数；2、次数；3、次数；4、次数；5、次数；6、次数；7、次数；8、次数；9、10、11、12无；
get(1001)->
	#d_task_daily{
		node         = 1001,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20080,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1006)->
	#d_task_daily{
		node         = 1006,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20090,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1011)->
	#d_task_daily{
		node         = 1011,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20100,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1016)->
	#d_task_daily{
		node         = 1016,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20110,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1021)->
	#d_task_daily{
		node         = 1021,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20120,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1026)->
	#d_task_daily{
		node         = 1026,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20130,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1031)->
	#d_task_daily{
		node         = 1031,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20140,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1036)->
	#d_task_daily{
		node         = 1036,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20150,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1041)->
	#d_task_daily{
		node         = 1041,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20160,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1046)->
	#d_task_daily{
		node         = 1046,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1051)->
	#d_task_daily{
		node         = 1051,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1056)->
	#d_task_daily{
		node         = 1056,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2001)->
	#d_task_daily{
		node         = 2001,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2006)->
	#d_task_daily{
		node         = 2006,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2011)->
	#d_task_daily{
		node         = 2011,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2016)->
	#d_task_daily{
		node         = 2016,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2021)->
	#d_task_daily{
		node         = 2021,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1061)->
	#d_task_daily{
		node         = 1061,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20160,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1066)->
	#d_task_daily{
		node         = 1066,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20170,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1071)->
	#d_task_daily{
		node         = 1071,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20180,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1076)->
	#d_task_daily{
		node         = 1076,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20190,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1081)->
	#d_task_daily{
		node         = 1081,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20200,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1086)->
	#d_task_daily{
		node         = 1086,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20210,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1091)->
	#d_task_daily{
		node         = 1091,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20220,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1096)->
	#d_task_daily{
		node         = 1096,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20230,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1101)->
	#d_task_daily{
		node         = 1101,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1106)->
	#d_task_daily{
		node         = 1106,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1111)->
	#d_task_daily{
		node         = 1111,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1116)->
	#d_task_daily{
		node         = 1116,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2101)->
	#d_task_daily{
		node         = 2101,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2106)->
	#d_task_daily{
		node         = 2106,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2111)->
	#d_task_daily{
		node         = 2111,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2116)->
	#d_task_daily{
		node         = 2116,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2121)->
	#d_task_daily{
		node         = 2121,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1121)->
	#d_task_daily{
		node         = 1121,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20240,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1126)->
	#d_task_daily{
		node         = 1126,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20250,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1131)->
	#d_task_daily{
		node         = 1131,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20260,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1136)->
	#d_task_daily{
		node         = 1136,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20270,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1141)->
	#d_task_daily{
		node         = 1141,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20280,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1146)->
	#d_task_daily{
		node         = 1146,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20290,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1151)->
	#d_task_daily{
		node         = 1151,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20300,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1156)->
	#d_task_daily{
		node         = 1156,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20310,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1161)->
	#d_task_daily{
		node         = 1161,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1166)->
	#d_task_daily{
		node         = 1166,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1171)->
	#d_task_daily{
		node         = 1171,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1176)->
	#d_task_daily{
		node         = 1176,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2201)->
	#d_task_daily{
		node         = 2201,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2206)->
	#d_task_daily{
		node         = 2206,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2211)->
	#d_task_daily{
		node         = 2211,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2216)->
	#d_task_daily{
		node         = 2216,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2221)->
	#d_task_daily{
		node         = 2221,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1181)->
	#d_task_daily{
		node         = 1181,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20330,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1186)->
	#d_task_daily{
		node         = 1186,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20340,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1191)->
	#d_task_daily{
		node         = 1191,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20350,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1196)->
	#d_task_daily{
		node         = 1196,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20360,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1201)->
	#d_task_daily{
		node         = 1201,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20370,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1206)->
	#d_task_daily{
		node         = 1206,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20380,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1211)->
	#d_task_daily{
		node         = 1211,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20390,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1216)->
	#d_task_daily{
		node         = 1216,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20400,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1221)->
	#d_task_daily{
		node         = 1221,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1226)->
	#d_task_daily{
		node         = 1226,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1231)->
	#d_task_daily{
		node         = 1231,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1236)->
	#d_task_daily{
		node         = 1236,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2301)->
	#d_task_daily{
		node         = 2301,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2306)->
	#d_task_daily{
		node         = 2306,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2311)->
	#d_task_daily{
		node         = 2311,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2316)->
	#d_task_daily{
		node         = 2316,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2321)->
	#d_task_daily{
		node         = 2321,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1241)->
	#d_task_daily{
		node         = 1241,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20380,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1246)->
	#d_task_daily{
		node         = 1246,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20390,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1251)->
	#d_task_daily{
		node         = 1251,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20400,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1256)->
	#d_task_daily{
		node         = 1256,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20410,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1261)->
	#d_task_daily{
		node         = 1261,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20420,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1266)->
	#d_task_daily{
		node         = 1266,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20430,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1271)->
	#d_task_daily{
		node         = 1271,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20440,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1276)->
	#d_task_daily{
		node         = 1276,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20450,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1281)->
	#d_task_daily{
		node         = 1281,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1286)->
	#d_task_daily{
		node         = 1286,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1291)->
	#d_task_daily{
		node         = 1291,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1296)->
	#d_task_daily{
		node         = 1296,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2401)->
	#d_task_daily{
		node         = 2401,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2406)->
	#d_task_daily{
		node         = 2406,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2411)->
	#d_task_daily{
		node         = 2411,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2416)->
	#d_task_daily{
		node         = 2416,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2421)->
	#d_task_daily{
		node         = 2421,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1301)->
	#d_task_daily{
		node         = 1301,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20450,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1306)->
	#d_task_daily{
		node         = 1306,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20460,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1311)->
	#d_task_daily{
		node         = 1311,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20470,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1316)->
	#d_task_daily{
		node         = 1316,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20480,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1321)->
	#d_task_daily{
		node         = 1321,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20490,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1326)->
	#d_task_daily{
		node         = 1326,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20500,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1331)->
	#d_task_daily{
		node         = 1331,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20510,           %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1336)->
	#d_task_daily{
		node         = 1336,            %% 任务id
		type         = 2,               %% 事件类型
		copys_id     = 20520,           %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1341)->
	#d_task_daily{
		node         = 1341,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 3,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1346)->
	#d_task_daily{
		node         = 1346,            %% 任务id
		type         = 1,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1351)->
	#d_task_daily{
		node         = 1351,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(1356)->
	#d_task_daily{
		node         = 1356,            %% 任务id
		type         = 3,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 5,               %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2501)->
	#d_task_daily{
		node         = 2501,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2506)->
	#d_task_daily{
		node         = 2506,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2511)->
	#d_task_daily{
		node         = 2511,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2516)->
	#d_task_daily{
		node         = 2516,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(2521)->
	#d_task_daily{
		node         = 2521,            %% 任务id
		type         = 4,               %% 事件类型
		copys_id     = 0,               %% 副本ID
		value        = 50,              %% 事件目标值
		exp          = 320,             %% 经验
		goods_count  = 0,               %% 奖励物品
		money        = 0,               %% 美刀
		energy       = 0,               %% 精力
		rmb          = 0,               %% 钻石
		renown       = 0               %% 声望
	};
get(_)-> ?null.


%% 集合;
get_ids()->[1001,1006,1011,1016,1021,1026,1031,1036,1041,1046,1051,1056,2001,2006,2011,2016,2021,1061,1066,1071,1076,1081,1086,1091,1096,1101,1106,1111,1116,2101,2106,2111,2116,2121,1121,1126,1131,1136,1141,1146,1151,1156,1161,1166,1171,1176,2201,2206,2211,2216,2221,1181,1186,1191,1196,1201,1206,1211,1216,1221,1226,1231,1236,2301,2306,2311,2316,2321,1241,1246,1251,1256,1261,1266,1271,1276,1281,1286,1291,1296,2401,2406,2411,2416,2421,1301,1306,1311,1316,1321,1326,1331,1336,1341,1346,1351,1356,2501,2506,2511,2516,2521].

