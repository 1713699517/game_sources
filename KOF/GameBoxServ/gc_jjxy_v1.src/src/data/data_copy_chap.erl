-module(data_copy_chap).
-include("../include/comm.hrl").

-export([get/2,gets_normal/0,gets_hero/0,gets_fiend/0,gets_fighters/0]).

% get();
% 各种副本章节;
% type为类型：普通|英雄|魔王|拳皇
get(1,11100)->
	#d_copy_chap{
		type         = 1,               %% 章节类型
		chap_id      = 11100,           %% 章节
		chap_lv      = 1,               %% 章节等级
		copy_id      = [20010,20020,20030,20040,20050],%% 副本ID
		pre_chap_id  = 0,               %% 上一个章节
		next_chap_id = 11200,           %% 下一个章节
		chap_reward  = [{43101,2}],     %% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(1,11200)->
	#d_copy_chap{
		type         = 1,               %% 章节类型
		chap_id      = 11200,           %% 章节
		chap_lv      = 1,               %% 章节等级
		copy_id      = [20060,20070,20080,20090,20100,20110,20120,20130,20140],%% 副本ID
		pre_chap_id  = 11100,           %% 上一个章节
		next_chap_id = 11300,           %% 下一个章节
		chap_reward  = [{43101,2}],     %% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(1,11300)->
	#d_copy_chap{
		type         = 1,               %% 章节类型
		chap_id      = 11300,           %% 章节
		chap_lv      = 1,               %% 章节等级
		copy_id      = [20150,20160,20170,20171,20172,20180,20190,20200,20210,20220,20230,20240,20250,20260],%% 副本ID
		pre_chap_id  = 11200,           %% 上一个章节
		next_chap_id = 11400,           %% 下一个章节
		chap_reward  = [{43101,2}],     %% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(1,11400)->
	#d_copy_chap{
		type         = 1,               %% 章节类型
		chap_id      = 11400,           %% 章节
		chap_lv      = 1,               %% 章节等级
		copy_id      = [20270,20280,20290,20300,20310,20320,20330,20340,20350],%% 副本ID
		pre_chap_id  = 11300,           %% 上一个章节
		next_chap_id = 11500,           %% 下一个章节
		chap_reward  = [{43101,2}],     %% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(1,11500)->
	#d_copy_chap{
		type         = 1,               %% 章节类型
		chap_id      = 11500,           %% 章节
		chap_lv      = 1,               %% 章节等级
		copy_id      = [20360,20370,20380,20390,20400,20410,20420,20430,20440],%% 副本ID
		pre_chap_id  = 11400,           %% 上一个章节
		next_chap_id = 11600,           %% 下一个章节
		chap_reward  = [{43101,2}],     %% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(1,11600)->
	#d_copy_chap{
		type         = 1,               %% 章节类型
		chap_id      = 11600,           %% 章节
		chap_lv      = 1,               %% 章节等级
		copy_id      = [20450,20460,20470,20480,20490,20500,20510,20520,20530,20540,20550,20560],%% 副本ID
		pre_chap_id  = 11500,           %% 上一个章节
		next_chap_id = 11700,           %% 下一个章节
		chap_reward  = [{43101,2}],     %% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(1,11700)->
	#d_copy_chap{
		type         = 1,               %% 章节类型
		chap_id      = 11700,           %% 章节
		chap_lv      = 1,               %% 章节等级
		copy_id      = [20570,20580,20590,20600],%% 副本ID
		pre_chap_id  = 11600,           %% 上一个章节
		next_chap_id = 0,               %% 下一个章节
		chap_reward  = [{43101,2}],     %% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(2,13100)->
	#d_copy_chap{
		type         = 2,               %% 章节类型
		chap_id      = 13100,           %% 章节
		chap_lv      = 20,              %% 章节等级
		copy_id      = [30010,30020,30030,30040,30050],%% 副本ID
		pre_chap_id  = 0,               %% 上一个章节
		next_chap_id = 13200,           %% 下一个章节
		chap_reward  = [{43101,3},{43261,3}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(2,13200)->
	#d_copy_chap{
		type         = 2,               %% 章节类型
		chap_id      = 13200,           %% 章节
		chap_lv      = 30,              %% 章节等级
		copy_id      = [30060,30070,30080,30090,30100],%% 副本ID
		pre_chap_id  = 13100,           %% 上一个章节
		next_chap_id = 13300,           %% 下一个章节
		chap_reward  = [{43101,3},{43261,6}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(2,13300)->
	#d_copy_chap{
		type         = 2,               %% 章节类型
		chap_id      = 13300,           %% 章节
		chap_lv      = 40,              %% 章节等级
		copy_id      = [30110,30120,30130,30140,30150],%% 副本ID
		pre_chap_id  = 13200,           %% 上一个章节
		next_chap_id = 13400,           %% 下一个章节
		chap_reward  = [{43101,3},{43261,9}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(2,13400)->
	#d_copy_chap{
		type         = 2,               %% 章节类型
		chap_id      = 13400,           %% 章节
		chap_lv      = 50,              %% 章节等级
		copy_id      = [30160,30170,30180,30190,30200],%% 副本ID
		pre_chap_id  = 13300,           %% 上一个章节
		next_chap_id = 13500,           %% 下一个章节
		chap_reward  = [{43101,3},{43261,12}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(2,13500)->
	#d_copy_chap{
		type         = 2,               %% 章节类型
		chap_id      = 13500,           %% 章节
		chap_lv      = 60,              %% 章节等级
		copy_id      = [30210,30220,30230,30240,30250],%% 副本ID
		pre_chap_id  = 13400,           %% 上一个章节
		next_chap_id = 13600,           %% 下一个章节
		chap_reward  = [{43101,3},{43261,15}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(2,13600)->
	#d_copy_chap{
		type         = 2,               %% 章节类型
		chap_id      = 13600,           %% 章节
		chap_lv      = 70,              %% 章节等级
		copy_id      = [30260,30270,30280,30290,30300],%% 副本ID
		pre_chap_id  = 13500,           %% 上一个章节
		next_chap_id = 0,               %% 下一个章节
		chap_reward  = [{43101,3},{43261,18}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(3,15100)->
	#d_copy_chap{
		type         = 3,               %% 章节类型
		chap_id      = 15100,           %% 章节
		chap_lv      = 25,              %% 章节等级
		copy_id      = [32010,32020,32030,32040],%% 副本ID
		pre_chap_id  = 0,               %% 上一个章节
		next_chap_id = 15200,           %% 下一个章节
		chap_reward  = [{43101,5},{40351,2},{43261,5}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(3,15200)->
	#d_copy_chap{
		type         = 3,               %% 章节类型
		chap_id      = 15200,           %% 章节
		chap_lv      = 35,              %% 章节等级
		copy_id      = [32050,32060,32070,32080],%% 副本ID
		pre_chap_id  = 15100,           %% 上一个章节
		next_chap_id = 15300,           %% 下一个章节
		chap_reward  = [{43101,5},{40351,3},{43261,10}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(3,15300)->
	#d_copy_chap{
		type         = 3,               %% 章节类型
		chap_id      = 15300,           %% 章节
		chap_lv      = 45,              %% 章节等级
		copy_id      = [32090,32100,32110,32120],%% 副本ID
		pre_chap_id  = 15200,           %% 上一个章节
		next_chap_id = 15400,           %% 下一个章节
		chap_reward  = [{43101,5},{40351,4},{43261,15}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(3,15400)->
	#d_copy_chap{
		type         = 3,               %% 章节类型
		chap_id      = 15400,           %% 章节
		chap_lv      = 55,              %% 章节等级
		copy_id      = [32130,32140,32150,32160],%% 副本ID
		pre_chap_id  = 15300,           %% 上一个章节
		next_chap_id = 15500,           %% 下一个章节
		chap_reward  = [{43101,5},{40351,5},{43261,20}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(3,15500)->
	#d_copy_chap{
		type         = 3,               %% 章节类型
		chap_id      = 15500,           %% 章节
		chap_lv      = 65,              %% 章节等级
		copy_id      = [32170,32180,32190,32200],%% 副本ID
		pre_chap_id  = 15400,           %% 上一个章节
		next_chap_id = 15600,           %% 下一个章节
		chap_reward  = [{43101,5},{40351,6},{43261,25}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(3,15600)->
	#d_copy_chap{
		type         = 3,               %% 章节类型
		chap_id      = 15600,           %% 章节
		chap_lv      = 75,              %% 章节等级
		copy_id      = [32210,32220,32230,32240],%% 副本ID
		pre_chap_id  = 15500,           %% 上一个章节
		next_chap_id = 0,               %% 下一个章节
		chap_reward  = [{43101,5},{40351,7},{43261,30}],%% 章节奖励
		reset_rmb    = 0               %% 重置钻石
	};

get(4,17100)->
	#d_copy_chap{
		type         = 4,               %% 章节类型
		chap_id      = 17100,           %% 章节
		chap_lv      = 1,               %% 章节等级
		copy_id      = [40100,40110,40120,40130,40140,40150,40160,40170,40180,40190,40200,40210,40220,40230,40240,40250,40260,40270,40280,40290,40300,40310,40320,40330,40340,40350,40360,40370,40380,40390,40400,40410,40420,40430,40440,40450,40460,40470,40480,40490,40500,40510,40520,40530,40540,40550,40560,40570,40580,40590],%% 副本ID
		pre_chap_id  = 0,               %% 上一个章节
		next_chap_id = 0,               %% 下一个章节
		chap_reward  = [],              %% 章节奖励
		reset_rmb    = 50              %% 重置钻石
	};

get(4,17110)->
	#d_copy_chap{
		type         = 4,               %% 章节类型
		chap_id      = 17110,           %% 章节
		chap_lv      = 1,               %% 章节等级
		copy_id      = [40140,40150,40160,40170],%% 副本ID
		pre_chap_id  = 17100,           %% 上一个章节
		next_chap_id = 17120,           %% 下一个章节
		chap_reward  = [],              %% 章节奖励
		reset_rmb    = 100             %% 重置钻石
	};

get(4,17120)->
	#d_copy_chap{
		type         = 4,               %% 章节类型
		chap_id      = 17120,           %% 章节
		chap_lv      = 1,               %% 章节等级
		copy_id      = [40180,40190,40200,40210],%% 副本ID
		pre_chap_id  = 17110,           %% 上一个章节
		next_chap_id = 0,               %% 下一个章节
		chap_reward  = [],              %% 章节奖励
		reset_rmb    = 150             %% 重置钻石
	};

get(_,_)->
	?null.

% gets_normal()->[ChapId,..]

gets_normal()->[11100,11200,11300,11400,11500,11600,11700].

% gets_hero()->[ChapId,..]

gets_hero()->[13100,13200,13300,13400,13500,13600].

% gets_fiend()->[ChapId,..]

gets_fiend()->[15100,15200,15300,15400,15500,15600].

% gets_fighters()->[ChapId,..]

gets_fighters()->[17100,17110,17120].
