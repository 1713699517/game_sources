%% Author: Kevin
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_friend
-module(world_boss_gateway).

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

%% 请求世界boss数据
gateway(?P_WORLD_BOSS_DATA,Player=#player{socket=Socket,uid=Uid,info=Info},_Binary)-> 
	?MSG_ECHO("=========== ~w~n",[Info#info.map_type]),
	case Info#info.map_type of
		?CONST_MAP_TYPE_BOSS->
			case world_boss_api:boss_enjoy(Player) of
				{?error,Error}->
					BinMsg = system_api:msg_error(Error),
					app_msg:send(Socket, BinMsg),
					{?ok, Player};
				{Player2,BinMsg}->
					active_api:check_link(Uid,?CONST_ACTIVITY_LINK_104),
					app_msg:send(Socket, BinMsg),
					{?ok, Player2}
			end;
		?CONST_MAP_TYPE_CLAN_BOSS->
			case clan_boss_api:join_active(Player) of
				{?error,ErrorCode} ->
					BinMsg=system_api:msg_error(ErrorCode),
					app_msg:send(Player#player.socket,BinMsg),
					{?ok,Player};
				{Player2,BinMsg} ->
					app_msg:send(Socket, BinMsg),
					{?ok,Player2}
			end;
		_->
			{?ok,Player}
	end;

%%玩家死亡
%% gateway(?P_WORLD_BOSS_WAR_DIE,Player=#player{socket=Socket},_Binary)-> 
%% 	WorldBoss=role_api_dict:world_boss_get(),
%% 	RMB=world_boss_api:boss_die_rs_rmb(WorldBoss#world_boss.die_count),
%% 	BinMsg=world_boss_api:msg_war_rs(60,RMB),
%% 	app_msg:send(Socket, BinMsg),
%% 	{?ok, Player};

%% 退出世界BOSS
gateway(?P_WORLD_BOSS_EXIT_S,Player,_Bin) ->
	NewPlayer = scene_api:enter_last_city(Player),
	{?ok,NewPlayer};

%% 复活 
gateway(?P_WORLD_BOSS_REVIVE,Player=#player{socket=Socket,spid=Spid,uid=Uid,is=Is},Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	WorldBoss=role_api_dict:world_boss_get(),
	PlayerS=scene_mod:record_player_s(Player),
	RoleMsg=scene_api:msg_role_data(PlayerS,?CONST_MAP_ENTER_NULL),
	case Type of
		0->
			Time=util:seconds(),
			case Time-WorldBoss#world_boss.s_time >= ?CONST_BOSS_RELIVE_TIME of
				?true->
					BinMsg=world_boss_api:msg_revive_ok(),
					app_msg:send(Socket, BinMsg),
					scene_api:broadcast_scene(Spid,Uid,RoleMsg),
					Is2=Is#is{is_war=?CONST_PLAYER_FLAG_NORMAL},
					Hp=world_boss_api:hp_self(Player),
					ets:insert(?ETS_WORLD_BOSS,{Uid,Hp}),
					{?ok,Player#player{is=Is2}};
				_->
					{?ok,Player}
			end;
		1->
			case ets:lookup(?ETS_WORLD_BOSS,Uid) of
				[]->
					RMB=world_boss_api:boss_die_rs_rmb(WorldBoss#world_boss.die_count),
					case role_api:currency_cut([gateway_world,[],<<"世界boss复活消耗">>],Player, [{?CONST_CURRENCY_RMB,RMB}]) of 
						{?error,ErrorCode} ->
							BinMsg = system_api:msg_error(ErrorCode),
							app_msg:send(Socket, BinMsg), 
							{?ok,Player};
						{?ok,Player2,MoneyBin}->
							BinMsg=world_boss_api:msg_revive_ok(),
							WorldBoss2=WorldBoss#world_boss{s_time=0,die_count=WorldBoss#world_boss.die_count+1},
							app_msg:send(Socket,<<BinMsg/binary,MoneyBin/binary>>),
							scene_api:broadcast_scene(Spid,Uid,RoleMsg),
							Is2=Is#is{is_war=?CONST_PLAYER_FLAG_NORMAL},
							Hp=world_boss_api:hp_self(Player),
							ets:insert(?ETS_WORLD_BOSS,{Uid,Hp}),
							role_api_dict:world_boss_set(WorldBoss2),
							{?ok,Player2#player{is=Is2}}
					end;
				_->
					{?ok,Player}
			end
	end;

%% 金元鼓舞
gateway(?P_WORLD_BOSS_RMB_ATTR,Player=#player{socket=Socket},Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	case world_boss_api:boss_rmb_attr(Type,Player) of
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg), 
			{?ok,Player};
		{Player2,BinMsg}->
			app_msg:send(Socket, BinMsg), 
			{?ok,Player2}
	end;

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> 
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.
