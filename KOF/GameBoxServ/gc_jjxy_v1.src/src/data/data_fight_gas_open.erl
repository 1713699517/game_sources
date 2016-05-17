-module(data_fight_gas_open).
-include("../include/comm.hrl").

-export([get/1,get_ids/0]).

% get();
% 开通斗气栏表;
% 
get(1)->
	#d_fight_gas_open{
		seal_id      = 1,               %% 封印编号
		open_lv      = 1               %% 开通等级
	};
get(2)->
	#d_fight_gas_open{
		seal_id      = 2,               %% 封印编号
		open_lv      = 1               %% 开通等级
	};
get(3)->
	#d_fight_gas_open{
		seal_id      = 3,               %% 封印编号
		open_lv      = 1               %% 开通等级
	};
get(4)->
	#d_fight_gas_open{
		seal_id      = 4,               %% 封印编号
		open_lv      = 30              %% 开通等级
	};
get(5)->
	#d_fight_gas_open{
		seal_id      = 5,               %% 封印编号
		open_lv      = 40              %% 开通等级
	};
get(6)->
	#d_fight_gas_open{
		seal_id      = 6,               %% 封印编号
		open_lv      = 50              %% 开通等级
	};
get(7)->
	#d_fight_gas_open{
		seal_id      = 7,               %% 封印编号
		open_lv      = 60              %% 开通等级
	};
get(8)->
	#d_fight_gas_open{
		seal_id      = 8,               %% 封印编号
		open_lv      = 60              %% 开通等级
	};
get(_)->?null.

get_ids()->[1,2,3,4,5,6,7,8].

