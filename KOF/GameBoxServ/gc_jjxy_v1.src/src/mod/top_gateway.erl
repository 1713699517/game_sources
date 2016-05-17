%% Author: Administrator
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_war
-module(top_gateway).

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
gateway(?P_TOP_RANK,Player=#player{socket=Socket,uid=Uid},Bin)->
	{Type} = app_msg:decode({?int8u},Bin),
	{Rank,List}=top_api:top_self_rank(Type,Uid),
	BinMsg=top_api:msg_date(Type,Rank,List),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};




%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

