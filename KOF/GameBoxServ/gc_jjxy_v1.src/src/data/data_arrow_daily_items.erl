-module(data_arrow_daily_items).
-include("../include/comm.hrl").

-export([get/1]).

% get();
% 每日一箭道具描述;
% 
get(100)->
	#d_arrow_daily_items{
		items_id     = 100,             %% 物品ID
		value        = 10000           %% 物品值
	};

get(101)->
	#d_arrow_daily_items{
		items_id     = 101,             %% 物品ID
		value        = 50              %% 物品值
	};

get(102)->
	#d_arrow_daily_items{
		items_id     = 102,             %% 物品ID
		value        = 100             %% 物品值
	};

get(103)->
	#d_arrow_daily_items{
		items_id     = 103,             %% 物品ID
		value        = 0               %% 物品值
	};

get(104)->
	#d_arrow_daily_items{
		items_id     = 104,             %% 物品ID
		value        = 0               %% 物品值
	};

get(105)->
	#d_arrow_daily_items{
		items_id     = 105,             %% 物品ID
		value        = 0               %% 物品值
	};

get(106)->
	#d_arrow_daily_items{
		items_id     = 106,             %% 物品ID
		value        = 0               %% 物品值
	};

get(107)->
	#d_arrow_daily_items{
		items_id     = 107,             %% 物品ID
		value        = 0               %% 物品值
	};

get(_)->
	?null.
