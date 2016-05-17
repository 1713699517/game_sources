-module(data_flsh_reward).
-include("../include/comm.hrl").

-export([get/3]).

% 风林山火奖励数据;
% 三个都填1为风林山火,三个都填0为什么也没有
get(0,5,0)->
	#d_flsh_reward{
		sz_num       = 0,               %% 顺子数
		same_num     = 5,               %% 相同牌数
		dz_num       = 0,               %% 对子数
		money        = 0,               %% 美刀
		renown       = 300             %% 声望
	};

get(0,4,0)->
	#d_flsh_reward{
		sz_num       = 0,               %% 顺子数
		same_num     = 4,               %% 相同牌数
		dz_num       = 0,               %% 对子数
		money        = 0,               %% 美刀
		renown       = 250             %% 声望
	};

get(5,0,0)->
	#d_flsh_reward{
		sz_num       = 5,               %% 顺子数
		same_num     = 0,               %% 相同牌数
		dz_num       = 0,               %% 对子数
		money        = 0,               %% 美刀
		renown       = 200             %% 声望
	};

get(0,3,1)->
	#d_flsh_reward{
		sz_num       = 0,               %% 顺子数
		same_num     = 3,               %% 相同牌数
		dz_num       = 1,               %% 对子数
		money        = 0,               %% 美刀
		renown       = 150             %% 声望
	};

get(4,0,0)->
	#d_flsh_reward{
		sz_num       = 4,               %% 顺子数
		same_num     = 0,               %% 相同牌数
		dz_num       = 0,               %% 对子数
		money        = 0,               %% 美刀
		renown       = 120             %% 声望
	};

get(0,3,0)->
	#d_flsh_reward{
		sz_num       = 0,               %% 顺子数
		same_num     = 3,               %% 相同牌数
		dz_num       = 0,               %% 对子数
		money        = 0,               %% 美刀
		renown       = 80              %% 声望
	};

get(0,0,2)->
	#d_flsh_reward{
		sz_num       = 0,               %% 顺子数
		same_num     = 0,               %% 相同牌数
		dz_num       = 2,               %% 对子数
		money        = 0,               %% 美刀
		renown       = 60              %% 声望
	};

get(0,0,1)->
	#d_flsh_reward{
		sz_num       = 0,               %% 顺子数
		same_num     = 0,               %% 相同牌数
		dz_num       = 1,               %% 对子数
		money        = 0,               %% 美刀
		renown       = 40              %% 声望
	};

get(0,0,0)->
	#d_flsh_reward{
		sz_num       = 0,               %% 顺子数
		same_num     = 0,               %% 相同牌数
		dz_num       = 0,               %% 对子数
		money        = 0,               %% 美刀
		renown       = 10              %% 声望
	};

get(_,_,_)->
	?null.
