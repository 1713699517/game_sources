%% Author: Administrator
%% Created: 2011-8-9
%% Description: TODO: Add description to scenes_gateway
-module(scene_gateway).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([gateway/3]).
%%
%% API Functions
%%

%% 请求进入场景(飞)
gateway(?P_SCENE_ENTER_FLY, Player, Binary) ->
	{MapId} = app_msg:decode({?int32u},Binary),
	% ?MSG_ECHO("-------------------~w~n",[MapId]),
	Pos = 0,
	Suffix = 0,
	Player2 = scene_api:enter_fly(Player,MapId,Pos,Suffix),
	{?ok,Player2};

%% 请求进入场景
gateway(?P_SCENE_ENTER, #player{info=Info}=Player, Binary) ->
	{DoorId} = app_msg:decode({?int32u},Binary),
	% ?MSG_ECHO("-----------------------~w~n",[{DoorId,Info#info.map_type}]),
	case DoorId of
		0 ->
			Player2	= scene_api:enter_login(Player);
		_ ->
			Player2	=
				case Info#info.map_type of
					?CONST_MAP_TYPE_CITY ->
						scene_api:enter_door(Player, DoorId);
					?CONST_MAP_TYPE_COPY_NORMAL ->
						copy_api:switch(Player);
					?CONST_MAP_TYPE_COPY_HERO ->
						copy_api:switch(Player);
					?CONST_MAP_TYPE_COPY_FIEND ->
						copy_api:switch(Player);
					?CONST_MAP_TYPE_COPY_FIGHTERS ->
						copy_api:switch(Player);
					_ ->
						Player
				end
	end,
	{?ok, Player2};

%% 请求场景内玩家信息列表
gateway(?P_SCENE_REQUEST_PLAYERS, Player, _Binary) ->
	scene_api:player_list(Player),
	{?ok, Player};

%% 请求场景玩家列表(NEW)
gateway(?P_SCENE_REQ_PLAYERS_NEW, Player, _Binary) ->
	scene_api:player_list_new(Player),
	{?ok, Player};

%% 请求场景怪物数据
gateway(?P_SCENE_REQUEST_MONSTER, #player{uid=Uid,spid=Spid}=Player, _Binary) ->
	scene_api:monster_list(Spid,Uid),
	{?ok, Player};

%% 行走数据(要广播也要记录位置)
gateway(?P_SCENE_MOVE, #player{spid=Spid,uid=Uid,info=Info}=Player, Binary) ->
	{Type,MoveUid,MoveType,PosX,PosY} = app_msg:decode({?int8u,?int32u,?int8u,?int16u,?int16u},Binary),
%% 	?MSG_ECHO("=====================~w~n",[{Type,MoveUid,MoveType,PosX,PosY}]),
	case Type of
		?CONST_PLAYER ->
			Info2 = Info#info{pos_x=PosX, pos_y=PosY},
			scene_api:move(MoveUid,Type,Spid,MoveType,PosX,PosY,0);
		?CONST_PARTNER ->
			Info2 = Info,
			scene_api:move(MoveUid,Type,Spid,MoveType,PosX,PosY,Uid);
		_ ->
			Info2 = Info
	end,
	{?ok, Player#player{info=Info2}};

%% 行走数据(要广播,后端不记录位置         这条现在不管)
gateway(?P_SCENE_MOVE_NEW, #player{uid=Uid,spid=Spid}=Player, Binary) ->
	{Type,MoveUid,MoveType,PosX,PosY} = app_msg:decode({?int8u,?int32u,?int8u,?int16u,?int16u},Binary),
	OwnerUid = ?IF(Type =:= ?CONST_PARTNER, Uid, 0),
	scene_api:move_new(MoveUid,Type,Spid,MoveType,PosX,PosY,OwnerUid),
	{?ok, Player};

%% 杀怪连击次数 
gateway(?P_SCENE_CAROM_TIMES, #player{spid=Spid,uid=Uid}=Player, Binary) ->
	{Times} = app_msg:decode({?int16u},Binary),
	if Times > 0 ->
		   scene_api:times_carom(Spid,Uid,Times);
	   ?true ->
		   ?skip
	end,
	{?ok,Player};

%% 击杀怪物
gateway(?P_SCENE_KILL_MONSTER, #player{spid=Spid,uid=Uid}=Player, Binary) ->
	{MonsMid} = app_msg:decode({?int32u},Binary),
	scene_api:mons_kill(Spid,Uid,MonsMid),
	{?ok,Player};
	
%% 被怪物击中
gateway(?P_SCENE_HIT_TIMES, #player{spid=Spid,uid=Uid}=Player, Binary) ->
	{Times} = app_msg:decode({?int16u},Binary),
	if Times > 0 ->
		   scene_api:times_hit(Spid,Uid,Times);
	   ?true ->
		   ?skip
	end,
	{?ok,Player};

%% 玩家死亡
gateway(?P_SCENE_DIE, #player{spid=Spid,uid=Uid}=Player, _Binary) ->
	scene_api:die(Spid,Uid),
	{?ok,Player};

%% 伙伴死亡
gateway(?P_SCENE_DIE_PARTNER, #player{spid=Spid,uid=Uid}=Player, Binary) ->
	{PartnerId} = app_msg:decode({?int32u},Binary),
	scene_api:die_partner(Spid,Uid,PartnerId),
	{?ok,Player};

%% 玩家请求复活
gateway(?P_SCENE_RELIVE_REQUEST, #player{socket=Socket}=Player, _Binary) ->
	case scene_api:relive(Player) of
		{?ok,Player2} ->
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 退出场景
gateway(?P_SCENE_ENTER_CITY, Player, _Binary) ->
	Player2 = scene_api:enter_last_city(Player),
	{?ok, Player2};

%% 错误匹配 ------------
gateway(ProtocolCode, Player, Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.