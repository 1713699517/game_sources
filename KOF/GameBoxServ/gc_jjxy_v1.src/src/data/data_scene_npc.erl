-module(data_scene_npc).
-include("../include/comm.hrl").

-export([get/1]).

%% get(NpcID) -> Npc数据 
get(10176)->
	#d_npc{
		npc_id			= 10176,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10200,	%% 所在场景ID
		func		= [],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10171)->
	#d_npc{
		npc_id			= 10171,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10200,	%% 所在场景ID
		func		= [],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10166)->
	#d_npc{
		npc_id			= 10166,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10200,	%% 所在场景ID
		func		= [],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10161)->
	#d_npc{
		npc_id			= 10161,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10200,	%% 所在场景ID
		func		= [],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10156)->
	#d_npc{
		npc_id			= 10156,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10200,	%% 所在场景ID
		func		= [{3,0,20}],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10151)->
	#d_npc{
		npc_id			= 10151,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10200,	%% 所在场景ID
		func		= [{4,0,0}],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10146)->
	#d_npc{
		npc_id			= 10146,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10200,	%% 所在场景ID
		func		= [],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10141)->
	#d_npc{
		npc_id			= 10141,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10200,	%% 所在场景ID
		func		= [{1,0,10}],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10136)->
	#d_npc{
		npc_id			= 10136,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10200,	%% 所在场景ID
		func		= [],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10131)->
	#d_npc{
		npc_id			= 10131,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10200,	%% 所在场景ID
		func		= [],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10126)->
	#d_npc{
		npc_id			= 10126,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10100,	%% 所在场景ID
		func		= [],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10121)->
	#d_npc{
		npc_id			= 10121,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10100,	%% 所在场景ID
		func		= [{1,0,7}],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10116)->
	#d_npc{
		npc_id			= 10116,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10100,	%% 所在场景ID
		func		= [{4,0,0}],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10111)->
	#d_npc{
		npc_id			= 10111,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10100,	%% 所在场景ID
		func		= [{3,0,10}],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10106)->
	#d_npc{
		npc_id			= 10106,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10100,	%% 所在场景ID
		func		= [],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(10101)->
	#d_npc{
		npc_id			= 10101,	%% npc id
		type				= 0,	%% npc类型
		scene_id	= 10100,	%% 所在场景ID
		func		= [],	%% 功能[{fun_id,fun_arg,fun_lv开放等级},..]
		x	= 0, %% 位置x
		y	= 0  %% 位置y 
	};
get(_)->?null.