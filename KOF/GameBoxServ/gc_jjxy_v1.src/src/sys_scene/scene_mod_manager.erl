%% Author: dreamxyp
%% Created: 2011-10-1
%% Description: TODO: Add description to scenes_manager_mod
-module(scene_mod_manager).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").


-export([
		 select_handle/3,
		 get_spids/1,
		 get_spids/2
		]).

%%
%% API Functions 
%%
select_handle(MapId,_Suffix,?CONST_MAP_TYPE_CITY) ->
	% 根据地图id找地图
	MS = [{'$1',[{'andalso',{'=:=',{element,3,'$1'},{const,MapId}},
                   {'andalso',{'=:=',{element,5,'$1'},?CONST_MAP_TYPE_CITY},
                              {'<',{element,9,'$1'},50}}}],
		   ['$1']}],
	case ets:select(?ETS_SCENE, MS) of
		[] ->
			case data_scene:scene(MapId) of
				#d_scene{scene_type=SceneType} when SceneType =:= ?CONST_MAP_TYPE_CITY ->
					Suffix = map_suffix(MapId),
					MapPid = scene_sup:start_child_map_srv(MapId, Suffix),
					MapPid;
				_ ->
					?null
			end;
		[Map|Maps] ->
			MapPid = select_map(Maps, Map#map.counter, Map#map.pid),
			MapPid
	end;
select_handle(MapId,Suffix,MapType) ->
	MapTypes = [?CONST_MAP_TYPE_INVITE_PK,?CONST_MAP_TYPE_KOF,?CONST_MAP_TYPE_CLAN_BOSS],
	case lists:member(MapType, MapTypes) of
		?true ->
			MS = [{'$1',[{'andalso',{'=:=',{element,3,'$1'},{const,MapId}},{'=:=',{element,4,'$1'},{const,Suffix}}}],[{element,2,'$1'}]}],
			case ets:select(?ETS_SCENE, MS) of
				[] ->
					%?MSG_ECHO("---------------------~w~n",[MapId]),
					case data_scene:scene(MapId) of
						#d_scene{scene_type=SceneType} when SceneType =:= MapType ->
							MapPid = scene_sup:start_child_map_srv(MapId, Suffix),
							MapPid;
						_ ->
							?null
					end;
				[MapPid|_] ->
					%?MSG_ECHO("---------------------~w~n",[MapId]),
					MapPid
			end;
		_ ->
			MS = [{'$1',[{'andalso',{'=:=',{element,3,'$1'},{const,MapId}},{'=:=',{element,5,'$1'},MapType}}],[{element,2,'$1'}]}],
			case ets:select(?ETS_SCENE, MS) of
				[] ->
					case data_scene:scene(MapId) of
						#d_scene{scene_type=SceneType} when SceneType =:= MapType ->
							NewSuffix = map_suffix(MapId),
							MapPid = scene_sup:start_child_map_srv(MapId, NewSuffix),
							MapPid;
						_ ->
							?null
					end;
				[MapPid|_] ->
					MapPid
			end
	end.

select_map([Map|Maps], Counter, Pid)->
	if
		Map#map.counter >= Counter ->
			select_map(Maps, Map#map.counter, Map#map.pid);
		?true ->
			select_map(Maps, Counter, Pid)
	end;
select_map([], _Counter, Pid) ->
	Pid.

%% 选择地图后缀
map_suffix(MapId) ->
	MS = [{'$1',[{'=:=',{element,3,'$1'},{const,MapId}}],[{element,4,'$1'}]}],
	Suffixs = ets:select(?ETS_SCENE, MS),
	map_suffix2(1, Suffixs).
map_suffix2(N, Suffixs) ->
	case lists:member(N, Suffixs) of
		?true  ->
			map_suffix2(N + 1, Suffixs);
		?false -> N
	end.

%% 找出地图的所有进程
get_spids(MapId) ->
	MS = [{'$1',[{'=:=',{element,3,'$1'},{const,MapId}}],[{element,2,'$1'}]}],
	ets:select(?ETS_SCENE, MS).

%% 找出地图和这个后缀的进程
get_spids(MapId,Suffix) ->
	MS = [{'$1',[{'andalso',{'=:=',{element,3,'$1'},{const,MapId}},
				  {'=:=',{element,4,'$1'},{const,Suffix}}}],
		   [{element,2,'$1'}]}],
	ets:select(?ETS_SCENE, MS).