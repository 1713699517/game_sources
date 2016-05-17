-module(data_sign).
-include("../include/comm.hrl").

-export([get/1]).

% get();
% 每日签到奖励;
% 
get(1)->
	#d_sign{
		day          = 1,               %% 天数
		reward_1     = 43211,           %% 奖励1
		count_1      = 5,               %% 奖励1数量
		reward_2     = 43001,           %% 奖励2
		count_2      = 1,               %% 奖励2数量
		reward_3     = 43251,           %% 奖励3
		count_3      = 1,               %% 奖励3数量
		reward_4     = 0,               %% 奖励4
		count_4      = 0               %% 奖励4数量
	};

get(2)->
	#d_sign{
		day          = 2,               %% 天数
		reward_1     = 43211,           %% 奖励1
		count_1      = 7,               %% 奖励1数量
		reward_2     = 43001,           %% 奖励2
		count_2      = 1,               %% 奖励2数量
		reward_3     = 43251,           %% 奖励3
		count_3      = 1,               %% 奖励3数量
		reward_4     = 43100,           %% 奖励4
		count_4      = 1               %% 奖励4数量
	};

get(3)->
	#d_sign{
		day          = 3,               %% 天数
		reward_1     = 43211,           %% 奖励1
		count_1      = 10,              %% 奖励1数量
		reward_2     = 43001,           %% 奖励2
		count_2      = 1,               %% 奖励2数量
		reward_3     = 43251,           %% 奖励3
		count_3      = 1,               %% 奖励3数量
		reward_4     = 43101,           %% 奖励4
		count_4      = 1               %% 奖励4数量
	};

get(_)->
	?null.
