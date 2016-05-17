%% Author: mirahs
%% Created: 2011-12-17
%% Description: TODO: Add description to fiend_gateway
-module(fighters_gateway).

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
%% 请求魔王副本
gateway(?P_FIGHTERS_REQUEST, #player{socket=Socket,lv=Lv,vip=Vip}=Player, Binary) ->
	{ChapId} = app_msg:decode({?int16u},Binary),
	?MSG_ECHO("----------------~w~n",[ChapId]),
	Chaps	= data_copy_chap:gets_fighters(),
	case lists:member(ChapId,Chaps) orelse ChapId =:= 0 of
		?true ->
			ChapFighters = role_api_dict:fighters_get(),
			{Chap,NextChap,BattleList,NewChapFighters,NewSave} = fighters_api:chap_info(Lv,ChapId,Chaps,ChapFighters),
			role_api_dict:fighters_set(NewChapFighters),
			WarTimes = ?CONST_FIGHTERS_CHALLENGE_TIMES - NewChapFighters#fighters.war_times,
			VipResetTimes = vip_api:check_fun(Vip#vip.lv, #d_vip.career_refresh),
			ResetTimes1 = VipResetTimes - NewChapFighters#fighters.reset_times,
			ResetTimes	= ?IF(ResetTimes1 > 0, ResetTimes1, 0),
			BinMsg	= fighters_api:msg_chap_data(Chap,NextChap,WarTimes,ResetTimes,NewChapFighters,BattleList,NewSave),
			app_msg:send(Socket, BinMsg);
		_ ->
			BinMsg	= system_api:msg_error(?ERROR_FIEND_NO_CHAP),
			app_msg:send(Socket, BinMsg)
	end,
	{?ok,Player};

%% 购买挑战次数
gateway(?P_FIGHTERS_BUY_TIMES, #player{socket=Socket}=Player, Binary) ->
	{BuyTimes} = app_msg:decode({?int16u},Binary),
	?MSG_ECHO("----------------~w~n",[BuyTimes]),
	case fighters_api:buy_times(Player,BuyTimes) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 开始挂机
gateway(?P_FIGHTERS_UP_START, #player{socket=Socket}=Player, _Binary) ->
	?MSG_ECHO("----------------~n",[]),
	case fighters_api:up_start(Player) of
		{?ok,Player2} ->
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 停止挂机
gateway(?P_FIGHTERS_UP_STOP, Player, _Binary) ->
	?MSG_ECHO("----------------~n",[]),
	fighters_api:up_stop(Player#player.socket),
	{?ok,Player};

%% 重置挂机
gateway(?P_FIGHTERS_UP_RESET, #player{socket=Socket}=Player, _Binary) ->
	?MSG_ECHO("----------------~n",[]),
	case fighters_api:up_reset(Player) of
		{?ok,Player2} ->
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

gateway(ProtocolCode, Player, Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.