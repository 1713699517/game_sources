%% Author: mirahs
%% Created: 2013-1-6
%% Description: TODO: Add description to team_gateway
-module(privilege_gateway).

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
%% 请求特权面板 
gateway(?P_PRIVILEGE_REQUEST, #player{socket=Socket}= Player, _Bin) ->
	AllMsg = privilege_api:request_privilege(),
	?MSG_ECHO("=====================~p~n",[AllMsg]),
	app_msg:send(Socket, AllMsg),
	{?ok, Player};

%% 开启投资理财 
gateway(?P_PRIVILEGE_OPEN, #player{socket=Socket}= Player, _Bin) ->
	case privilege_api:open(Player) of
		{?ok,Player2, Bin} ->
			app_msg:send(Socket, Bin),
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 领取
gateway(?P_PRIVILEGE_GET_REWARDS,#player{socket=Socket}= Player, _Bin) ->
	case privilege_api:get_rewards(Player) of
		{?ok,Player2, BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;	

gateway(ProtocolCode,Player,Binary)->
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.