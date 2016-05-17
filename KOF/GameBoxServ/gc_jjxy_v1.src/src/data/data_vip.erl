-module(data_vip).
-include("../include/comm.hrl").

-export([get/1]).

% get(声望等级);
% VIP等级数据;
% vip等级功能开放：
get(1)->
	#d_vip{
		lv           = 1,               %% VIP等级
		vip_up       = 100,             %% 充值元宝数
		sub_rmb      = 10,              %% RMB
		energy_max   = 0,               %% 体力上限增加
		bag_max      = 0,               %% 背包增加
		bowl_max     = 5,               %% 增加招财次数
		energy_buys  = 0,               %% 购买体力次数
		mining_tim   = 3,               %% 挖金矿次数
		tran_buy     = 0,               %% 购买精英副本次数
		charity_tim  = 1,               %% 日行一善次数
		daily_tim    = 1,               %% 日常任务刷新次数
		energy_add   = 0,               %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 0,               %% 金元领悟次数
		fiend_times  = 5,               %% 每日刷新魔王副本次数
		cat_times    = 5,               %% 帮派招财猫次数
		career_refresh = 1,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(2)->
	#d_vip{
		lv           = 2,               %% VIP等级
		vip_up       = 500,             %% 充值元宝数
		sub_rmb      = 50,              %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 10,              %% 背包增加
		bowl_max     = 7,               %% 增加招财次数
		energy_buys  = 2,               %% 购买体力次数
		mining_tim   = 4,               %% 挖金矿次数
		tran_buy     = 0,               %% 购买精英副本次数
		charity_tim  = 2,               %% 日行一善次数
		daily_tim    = 1,               %% 日常任务刷新次数
		energy_add   = 0,               %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 0,               %% 金元领悟次数
		fiend_times  = 10,              %% 每日刷新魔王副本次数
		cat_times    = 5,               %% 帮派招财猫次数
		career_refresh = 1,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(3)->
	#d_vip{
		lv           = 3,               %% VIP等级
		vip_up       = 1000,            %% 充值元宝数
		sub_rmb      = 100,             %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 10,              %% 背包增加
		bowl_max     = 11,              %% 增加招财次数
		energy_buys  = 3,               %% 购买体力次数
		mining_tim   = 5,               %% 挖金矿次数
		tran_buy     = 5,               %% 购买精英副本次数
		charity_tim  = 2,               %% 日行一善次数
		daily_tim    = 1,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 1,               %% 金元领悟次数
		fiend_times  = 10,              %% 每日刷新魔王副本次数
		cat_times    = 5,               %% 帮派招财猫次数
		career_refresh = 2,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(4)->
	#d_vip{
		lv           = 4,               %% VIP等级
		vip_up       = 2000,            %% 充值元宝数
		sub_rmb      = 200,             %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 10,              %% 背包增加
		bowl_max     = 20,              %% 增加招财次数
		energy_buys  = 5,               %% 购买体力次数
		mining_tim   = 12,              %% 挖金矿次数
		tran_buy     = 10,              %% 购买精英副本次数
		charity_tim  = 3,               %% 日行一善次数
		daily_tim    = 1,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 2,               %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 2,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(5)->
	#d_vip{
		lv           = 5,               %% VIP等级
		vip_up       = 5000,            %% 充值元宝数
		sub_rmb      = 500,             %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 20,              %% 背包增加
		bowl_max     = 35,              %% 增加招财次数
		energy_buys  = 10,              %% 购买体力次数
		mining_tim   = 15,              %% 挖金矿次数
		tran_buy     = 10,              %% 购买精英副本次数
		charity_tim  = 3,               %% 日行一善次数
		daily_tim    = 1,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 3,               %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 2,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(6)->
	#d_vip{
		lv           = 6,               %% VIP等级
		vip_up       = 10000,           %% 充值元宝数
		sub_rmb      = 1000,            %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 20,              %% 背包增加
		bowl_max     = 45,              %% 增加招财次数
		energy_buys  = 15,              %% 购买体力次数
		mining_tim   = 25,              %% 挖金矿次数
		tran_buy     = 20,              %% 购买精英副本次数
		charity_tim  = 3,               %% 日行一善次数
		daily_tim    = 1,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 10,              %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 3,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(7)->
	#d_vip{
		lv           = 7,               %% VIP等级
		vip_up       = 30000,           %% 充值元宝数
		sub_rmb      = 3000,            %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 30,              %% 背包增加
		bowl_max     = 65,              %% 增加招财次数
		energy_buys  = 20,              %% 购买体力次数
		mining_tim   = 30,              %% 挖金矿次数
		tran_buy     = 20,              %% 购买精英副本次数
		charity_tim  = 10,              %% 日行一善次数
		daily_tim    = 1,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 10,              %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 3,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(8)->
	#d_vip{
		lv           = 8,               %% VIP等级
		vip_up       = 50000,           %% 充值元宝数
		sub_rmb      = 5000,            %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 30,              %% 背包增加
		bowl_max     = 85,              %% 增加招财次数
		energy_buys  = 20,              %% 购买体力次数
		mining_tim   = 45,              %% 挖金矿次数
		tran_buy     = 20,              %% 购买精英副本次数
		charity_tim  = 15,              %% 日行一善次数
		daily_tim    = 2,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 20,              %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 4,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(9)->
	#d_vip{
		lv           = 9,               %% VIP等级
		vip_up       = 100000,          %% 充值元宝数
		sub_rmb      = 10000,           %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 30,              %% 背包增加
		bowl_max     = 115,             %% 增加招财次数
		energy_buys  = 25,              %% 购买体力次数
		mining_tim   = 75,              %% 挖金矿次数
		tran_buy     = 20,              %% 购买精英副本次数
		charity_tim  = 15,              %% 日行一善次数
		daily_tim    = 2,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 20,              %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 4,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(10)->
	#d_vip{
		lv           = 10,              %% VIP等级
		vip_up       = 200000,          %% 充值元宝数
		sub_rmb      = 20000,           %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 30,              %% 背包增加
		bowl_max     = 195,             %% 增加招财次数
		energy_buys  = 25,              %% 购买体力次数
		mining_tim   = 150,             %% 挖金矿次数
		tran_buy     = 20,              %% 购买精英副本次数
		charity_tim  = 20,              %% 日行一善次数
		daily_tim    = 2,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 20,              %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 5,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(11)->
	#d_vip{
		lv           = 11,              %% VIP等级
		vip_up       = 500000,          %% 充值元宝数
		sub_rmb      = 50000,           %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 30,              %% 背包增加
		bowl_max     = 395,             %% 增加招财次数
		energy_buys  = 25,              %% 购买体力次数
		mining_tim   = 200,             %% 挖金矿次数
		tran_buy     = 20,              %% 购买精英副本次数
		charity_tim  = 20,              %% 日行一善次数
		daily_tim    = 2,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 30,              %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 5,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(12)->
	#d_vip{
		lv           = 12,              %% VIP等级
		vip_up       = 1000000,         %% 充值元宝数
		sub_rmb      = 100000,          %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 30,              %% 背包增加
		bowl_max     = 595,             %% 增加招财次数
		energy_buys  = 30,              %% 购买体力次数
		mining_tim   = 200,             %% 挖金矿次数
		tran_buy     = 20,              %% 购买精英副本次数
		charity_tim  = 30,              %% 日行一善次数
		daily_tim    = 2,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 30,              %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 5,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(13)->
	#d_vip{
		lv           = 13,              %% VIP等级
		vip_up       = 2000000,         %% 充值元宝数
		sub_rmb      = 200000,          %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 30,              %% 背包增加
		bowl_max     = 745,             %% 增加招财次数
		energy_buys  = 40,              %% 购买体力次数
		mining_tim   = 200,             %% 挖金矿次数
		tran_buy     = 20,              %% 购买精英副本次数
		charity_tim  = 30,              %% 日行一善次数
		daily_tim    = 2,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 40,              %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 6,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(14)->
	#d_vip{
		lv           = 14,              %% VIP等级
		vip_up       = 3000000,         %% 充值元宝数
		sub_rmb      = 300000,          %% RMB
		energy_max   = 50,              %% 体力上限增加
		bag_max      = 40,              %% 背包增加
		bowl_max     = 895,             %% 增加招财次数
		energy_buys  = 40,              %% 购买体力次数
		mining_tim   = 200,             %% 挖金矿次数
		tran_buy     = 20,              %% 购买精英副本次数
		charity_tim  = 30,              %% 日行一善次数
		daily_tim    = 2,               %% 日常任务刷新次数
		energy_add   = 50,              %% 0点额外赠送体力
		dia_got      = 0,               %% 一键合成宝石
		jewel_got    = 0,               %% 一键合成珍宝
		douqi_times  = 40,              %% 金元领悟次数
		fiend_times  = 20,              %% 每日刷新魔王副本次数
		cat_times    = 10,              %% 帮派招财猫次数
		career_refresh = 6,             %% 拳皇生涯重置次数
		tim_exit3    = 0,               %% tim_exit3
		tim_exit4    = 0,               %% tim_exit4
		tim_exit5    = 0,               %% tim_exit5
		tim_exit6    = 0,               %% tim_exit6
		tim_exit7    = 0,               %% tim_exit7
		tim_exit8    = 0,               %% tim_exit8
		tim_exit9    = 0,               %% tim_exit9
		tim_exit10   = 0,               %% tim_exit10
		tim_exit11   = 0,               %% tim_exit11
		tim_exit12   = 0,               %% tim_exit12
		tim_exit13   = 0,               %% tim_exit13
		tim_exit14   = 0,               %% tim_exit14
		tim_exit15   = 0               %% tim_exit15
	};
get(_)->?null.
