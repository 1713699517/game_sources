%% Author: Administrator
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_war
-module(clan_boss_gateway).

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

%% 请求开启帮派BOSS
gateway(?P_CLAN_BOSS_START_BOSS, Player, _Bin) ->
	clan_srv:open_active_cast(Player#player.mpid),
	{?ok,Player};


%%　请求参加帮派BOSS
gateway(?P_CLAN_BOSS_ASK_JOIN, Player, _Bin) ->
	case clan_boss_api:join_active(Player) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket,BinMsg),
			{?ok,Player};
		Player2 ->
			{?ok,Player2}
	end;

%%　请求豉舞【54260】
gateway(?P_CLAN_BOSS_ASK_INCITE, Player, _Bin) ->
	case clan_boss_api:boss_rmb_attr(Player) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket,BinMsg),
			{?ok,Player};
		Player2 ->
			{?ok,Player2}
	end;

%%　玩家死亡
gateway(?P_CLAN_BOSS_DIED, #player{uid=Uid,socket=Socket}=Player, _Bin) ->
	case ets:lookup(?ETS_CLAN_BOSS_RANK, Uid) of
		[#clan_boss_rank{relive_tims=ReliveTimes}|_] ->
			Spend =  clan_boss_api:boss_die_rs_rmb(ReliveTimes),
			BinMsg = clan_boss_api:msg_died_state(?CONST_CLAN_RELIVE_TIME,Spend);
		Err ->
			?MSG_ERROR(" +++ not in war ~w~n",[Err]),
			BinMsg = <<>>
	end,
	app_msg:send(Socket,BinMsg),
	{?ok,Player};

%%　请求复活
gateway(?P_CLAN_BOSS_ASK_RELIVE, Player, _Bin) ->
	case clan_boss_api:ask_relive(Player) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket,BinMsg),
			{?ok,Player};
		{?ok, Player2, BinMsg} ->
			app_msg:send(Player#player.socket,BinMsg),
			{?ok,Player2}
	end;

%%　退出活动
gateway(?P_CLAN_BOSS_ASK_OUT, Player, _Bin) ->
	Player2 = scene_api:enter_last_city(Player),
	{?ok,Player2};



%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

