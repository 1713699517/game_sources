%% Author: mirahs
%% Created: 2013-1-6
%% Description: TODO: Add description to team_gateway
-module(shoot_gateway).

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
%% 请求射箭面板 
gateway(?P_SHOOT_REQUEST, #player{socket=Socket}= Player, _Bin) ->
	AllMsg = shoot_api:request_shoot(),
	app_msg:send(Socket, AllMsg),
	{?ok, Player};

%% 射箭
gateway(?P_SHOOT_SHOOTED, Player, Bin) ->
	{Position} = app_msg:decode({?int16u},Bin),
	shoot_api:shooted(Player, Position);

gateway(ProtocolCode,Player,Binary)->
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.