-module(data_pet_skill).
-include("../include/comm.hrl").

-export([get/1]).

% ;
% 
get(1)->
	#d_pet_skill{
		unreal_skin  = 10001,           %% 宠物皮肤
		lv           = 1,               %% 宠物等级
		skill        = 0               %% 学习技能
	};

get(30)->
	#d_pet_skill{
		unreal_skin  = 10002,           %% 宠物皮肤
		lv           = 30,              %% 宠物等级
		skill        = 10024           %% 学习技能
	};

get(60)->
	#d_pet_skill{
		unreal_skin  = 10003,           %% 宠物皮肤
		lv           = 60,              %% 宠物等级
		skill        = 10034           %% 学习技能
	};

get(_)->
	?null.
