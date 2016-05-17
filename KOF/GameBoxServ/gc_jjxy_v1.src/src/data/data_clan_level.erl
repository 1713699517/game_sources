-module(data_clan_level).
-include("../include/comm.hrl").

-export([get/1,get_list/0]).

% get(成长类型,等级);
% 帮派等级数据;
% 
get(1)->
	#d_clan{
		lv           = 1,               %% 等级
		devote       = 0,               %% 总贡献下限值
		devote_up    = 1500,            %% 总贡献上限值
		max          = 15,              %% 成员上限值
		exp_plus     = 0,               %% 经验加成
		gold_plus    = 0,               %% 关卡铜钱加成
		tineng_limit = 5,               %% 技能上限等级
		boss_times   = 0,               %% 帮派BOSS次数
		copy_times   = 0,               %% 副本次数
		copy_id      = 34010           %% 副本ID
	};
get(2)->
	#d_clan{
		lv           = 2,               %% 等级
		devote       = 1500,            %% 总贡献下限值
		devote_up    = 12360,           %% 总贡献上限值
		max          = 18,              %% 成员上限值
		exp_plus     = 0,               %% 经验加成
		gold_plus    = 0,               %% 关卡铜钱加成
		tineng_limit = 10,              %% 技能上限等级
		boss_times   = 2,               %% 帮派BOSS次数
		copy_times   = 1,               %% 副本次数
		copy_id      = 34020           %% 副本ID
	};
get(3)->
	#d_clan{
		lv           = 3,               %% 等级
		devote       = 12360,           %% 总贡献下限值
		devote_up    = 77010,           %% 总贡献上限值
		max          = 21,              %% 成员上限值
		exp_plus     = 0,               %% 经验加成
		gold_plus    = 0,               %% 关卡铜钱加成
		tineng_limit = 20,              %% 技能上限等级
		boss_times   = 2,               %% 帮派BOSS次数
		copy_times   = 2,               %% 副本次数
		copy_id      = 34030           %% 副本ID
	};
get(4)->
	#d_clan{
		lv           = 4,               %% 等级
		devote       = 77010,           %% 总贡献下限值
		devote_up    = 184210,          %% 总贡献上限值
		max          = 24,              %% 成员上限值
		exp_plus     = 0,               %% 经验加成
		gold_plus    = 0,               %% 关卡铜钱加成
		tineng_limit = 30,              %% 技能上限等级
		boss_times   = 2,               %% 帮派BOSS次数
		copy_times   = 3,               %% 副本次数
		copy_id      = 34040           %% 副本ID
	};
get(5)->
	#d_clan{
		lv           = 5,               %% 等级
		devote       = 184210,          %% 总贡献下限值
		devote_up    = 415410,          %% 总贡献上限值
		max          = 27,              %% 成员上限值
		exp_plus     = 0,               %% 经验加成
		gold_plus    = 0,               %% 关卡铜钱加成
		tineng_limit = 40,              %% 技能上限等级
		boss_times   = 2,               %% 帮派BOSS次数
		copy_times   = 3,               %% 副本次数
		copy_id      = 34050           %% 副本ID
	};
get(6)->
	#d_clan{
		lv           = 6,               %% 等级
		devote       = 415410,          %% 总贡献下限值
		devote_up    = 787410,          %% 总贡献上限值
		max          = 30,              %% 成员上限值
		exp_plus     = 0,               %% 经验加成
		gold_plus    = 0,               %% 关卡铜钱加成
		tineng_limit = 50,              %% 技能上限等级
		boss_times   = 2,               %% 帮派BOSS次数
		copy_times   = 3,               %% 副本次数
		copy_id      = 34060           %% 副本ID
	};
get(7)->
	#d_clan{
		lv           = 7,               %% 等级
		devote       = 787410,          %% 总贡献下限值
		devote_up    = 1507410,         %% 总贡献上限值
		max          = 30,              %% 成员上限值
		exp_plus     = 0,               %% 经验加成
		gold_plus    = 0,               %% 关卡铜钱加成
		tineng_limit = 60,              %% 技能上限等级
		boss_times   = 2,               %% 帮派BOSS次数
		copy_times   = 3,               %% 副本次数
		copy_id      = 34070           %% 副本ID
	};
get(8)->
	#d_clan{
		lv           = 8,               %% 等级
		devote       = 1507410,         %% 总贡献下限值
		devote_up    = 2707410,         %% 总贡献上限值
		max          = 30,              %% 成员上限值
		exp_plus     = 0,               %% 经验加成
		gold_plus    = 0,               %% 关卡铜钱加成
		tineng_limit = 70,              %% 技能上限等级
		boss_times   = 2,               %% 帮派BOSS次数
		copy_times   = 3,               %% 副本次数
		copy_id      = 34080           %% 副本ID
	};
get(9)->
	#d_clan{
		lv           = 9,               %% 等级
		devote       = 2707410,         %% 总贡献下限值
		devote_up    = 4707410,         %% 总贡献上限值
		max          = 30,              %% 成员上限值
		exp_plus     = 0,               %% 经验加成
		gold_plus    = 0,               %% 关卡铜钱加成
		tineng_limit = 80,              %% 技能上限等级
		boss_times   = 2,               %% 帮派BOSS次数
		copy_times   = 3,               %% 副本次数
		copy_id      = 34090           %% 副本ID
	};
get(10)->
	#d_clan{
		lv           = 10,              %% 等级
		devote       = 4707410,         %% 总贡献下限值
		devote_up    = 7907410,         %% 总贡献上限值
		max          = 30,              %% 成员上限值
		exp_plus     = 0,               %% 经验加成
		gold_plus    = 0,               %% 关卡铜钱加成
		tineng_limit = 100,             %% 技能上限等级
		boss_times   = 3,               %% 帮派BOSS次数
		copy_times   = 3,               %% 副本次数
		copy_id      = 34100           %% 副本ID
	};
get(_)->?null.

get_list()->[1,2,3,4,5,6,7,8,9,10].
