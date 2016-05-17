%% Author: mirahs
%% Created: 2013-1-6
%% Description: TODO: Add description to team_gateway
-module(sys_set_gateway).

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
%% 请求系统设置
gateway(?P_SYS_SET_CHECK, Player=#player{socket=Socket}, Bin) ->
	{Type} = app_msg:decode({?int16u},Bin),
	List=sys_set_api:sys_set(Type),
	role_api_dict:sys_set_set(List),
	BinMsg=sys_set_api:msg_type_state(List),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};


gateway(ProtocolCode,Player,Binary)->
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.