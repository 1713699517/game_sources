%% Author: Administrator
%% Created: 2012-11-13
%% Description: TODO: Add description to energy_gateway
-module(title_gateway).

%%
%% Include files
%%
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([gateway/3]).


%% 请求称号列表
gateway(?P_TITLE_REQUEST, Player, _Bin) ->
	TitleList = role_api_dict:title_get(),
	Now = util:seconds(),
	Fun = fun(#title{et=ST, st=ET}=Title, Acc) ->
				  case util:betweet(Now, ST, ET) of
					  Now	-> [Title|Acc];
					  _		-> Acc
				  end
		  end,
	TitleList	= lists:foldl(Fun, [], TitleList),
	BinMsg 		= title_api:msg_list_back(TitleList),
	app_msg:send(Player#player.socket, BinMsg),
	{?ok,Player};

%% 设置称号状态
gateway(?P_TITLE_SET_STATE, Player, Bin) ->
	{State,Tid} = app_msg:decode({?int8u,?int16u},Bin),
	case title_api:set_title(Player#player.uid,State,Tid) of
		{?ok, BinMsg} ->
			BinMsg;
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode)
	end,
	app_msg:send(Player#player.socket, BinMsg),
	{?ok,Player};

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

