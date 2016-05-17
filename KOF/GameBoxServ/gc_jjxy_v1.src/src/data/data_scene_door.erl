-module(data_scene_door).
-include("../include/comm.hrl").

-export([get/1]).

% get();
% 传送门;
% type:1=传送场景，2=传送界面
get(50001)->
	#d_scene_door{
		door_id      = 50001,           %% 传送门ID
		type         = 1,               %% 类型
		transfer_id  = 10100           %% 传送ID
	};

get(50002)->
	#d_scene_door{
		door_id      = 50002,           %% 传送门ID
		type         = 1,               %% 类型
		transfer_id  = 10200           %% 传送ID
	};

get(50101)->
	#d_scene_door{
		door_id      = 50101,           %% 传送门ID
		type         = 2,               %% 类型
		transfer_id  = 101             %% 传送ID
	};

get(50102)->
	#d_scene_door{
		door_id      = 50102,           %% 传送门ID
		type         = 2,               %% 类型
		transfer_id  = 102             %% 传送ID
	};

get(50103)->
	#d_scene_door{
		door_id      = 50103,           %% 传送门ID
		type         = 2,               %% 类型
		transfer_id  = 103             %% 传送ID
	};

get(50104)->
	#d_scene_door{
		door_id      = 50104,           %% 传送门ID
		type         = 3,               %% 类型
		transfer_id  = 0               %% 传送ID
	};

get(_)->
	?null.
