%% Author: mirahs
%% Created: 2013-1-6
%% Description: TODO: Add description to team_gateway
-module(sign_gateway).

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
%% 请求签到面板 
gateway(?P_SIGN_REQUES, #player{socket=Socket}= Player, _Bin) ->
	AllMsg = sign_api:request_sign(),
	app_msg:send(Socket, AllMsg),
	{?ok, Player};

%% 领取奖励 
gateway(?P_SIGN_GET_REWARDS,#player{socket=Socket}= Player, Bin) ->
	{Day} = app_msg:decode({?int16u}, Bin),
	case sign_api:get_rewards(Player,Day) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

gateway(ProtocolCode,Player,Binary)->
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.