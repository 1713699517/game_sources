%% Author: mirahs
%% Created: 2013-1-6
%% Description: TODO: Add description to team_gateway
-module(weagod_gateway).

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
%% 请求招财面板 
gateway(?P_WEAGOD_REQUEST, #player{socket=Socket,lv=Lv,vip= Vip }=Player, _Bin) ->
	BinMsg = weagod_api:request_weagod(Lv,Vip),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 招财
gateway(?P_WEAGOD_GET_MONEY,#player{socket=Socket}=Player, _Bin) ->
	case weagod_api:money_get(Player) of
		{?ok,Player2} ->
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;


%% 批量招财
gateway(?P_WEAGOD_PL_MONEY,#player{socket=Socket}=Player, _Bin) ->
	case weagod_api:pl_money_get(Player) of 
		{?ok,Player2} ->
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

gateway(?P_WEAGOD_AUTO_GET, Player=#player{socket=Socket},_Bin) ->
	case weagod_api:money_auto_get_open_close(Player) of
		{?ok,Player2} ->
			{?ok,Player2};
		{?error,ErrorCode}->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;


gateway(ProtocolCode,Player,Binary)->
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.