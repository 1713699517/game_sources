-module(data_active_link_rewards).
-include("../include/comm.hrl").

-export([get/1]).

% get(成长类型,等级);
% 活跃度奖励配置表;
% ;
% {Id,Vitality,rewards};
% 
get(1)->
	#link_rewards{
		id           = 1,               %% 活动进展
		vitality     = 25,              %% 所需活跃度
		rewards_id   = 40031,           %% 活动奖励
		rewards_count = 1              %% 活动奖励数量
	};
get(2)->
	#link_rewards{
		id           = 2,               %% 活动进展
		vitality     = 50,              %% 所需活跃度
		rewards_id   = 40041,           %% 活动奖励
		rewards_count = 1              %% 活动奖励数量
	};
get(3)->
	#link_rewards{
		id           = 3,               %% 活动进展
		vitality     = 75,              %% 所需活跃度
		rewards_id   = 40051,           %% 活动奖励
		rewards_count = 1              %% 活动奖励数量
	};
get(4)->
	#link_rewards{
		id           = 4,               %% 活动进展
		vitality     = 100,             %% 所需活跃度
		rewards_id   = 40061,           %% 活动奖励
		rewards_count = 1              %% 活动奖励数量
	};
get(_)->?null.
