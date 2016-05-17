-module(data_player_init_source).
-include("../include/comm.hrl").

-export([get/1]).

% get(pro,sex);
% 主角初始化_来源渠道(额外加的)
get(0)->
	#d_player_source{
		source       = 0,               %% 版本ID
		gold         = 0,               %% 银元
		rmb          = 0,               %% 金元
		bindrmb      = 0,               %% 绑定金元
		rmb_total    = 0,               %% VIP经验
		bag          = []              %% 背包
	};
get(10)->
	#d_player_source{
		source       = 10,              %% 版本ID
		gold         = 0,               %% 银元
		rmb          = 0,               %% 金元
		bindrmb      = 0,               %% 绑定金元
		rmb_total    = 0,               %% VIP经验
		bag          = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,6001,1,0,0,0,0,0}]%% 背包
	};
get(20)->
	#d_player_source{
		source       = 20,              %% 版本ID
		gold         = 0,               %% 银元
		rmb          = 0,               %% 金元
		bindrmb      = 0,               %% 绑定金元
		rmb_total    = 0,               %% VIP经验
		bag          = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,7001,1,0,0,0,0,0}]%% 背包
	};
get(30)->
	#d_player_source{
		source       = 30,              %% 版本ID
		gold         = 0,               %% 银元
		rmb          = 0,               %% 金元
		bindrmb      = 0,               %% 绑定金元
		rmb_total    = 0,               %% VIP经验
		bag          = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,7001,1,0,0,0,0,0}]%% 背包
	};
get(40)->
	#d_player_source{
		source       = 40,              %% 版本ID
		gold         = 0,               %% 银元
		rmb          = 0,               %% 金元
		bindrmb      = 0,               %% 绑定金元
		rmb_total    = 0,               %% VIP经验
		bag          = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,8001,1,0,0,0,0,0}]%% 背包
	};
get(50)->
	#d_player_source{
		source       = 50,              %% 版本ID
		gold         = 0,               %% 银元
		rmb          = 0,               %% 金元
		bindrmb      = 0,               %% 绑定金元
		rmb_total    = 0,               %% VIP经验
		bag          = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,8001,1,0,0,0,0,0}]%% 背包
	};
get(_)-> ?null.


%% 等级集合