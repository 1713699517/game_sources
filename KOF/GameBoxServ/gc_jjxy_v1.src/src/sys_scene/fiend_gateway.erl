%% Author: mirahs
%% Created: 2011-12-17
%% Description: TODO: Add description to fiend_gateway
-module(fiend_gateway).

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
%% gateway(?P_FIEND_REQUEST, #player{socket=Socket,lv=Lv,vip=Vip}=Player, Binary) ->
%% 	{ChapId} = app_msg:decode({?int16u},Binary),
%% 	?MSG_ECHO("----------------~w~n",[ChapId]),
%% 	Chaps	= data_copy_chap:gets_fiend(),
%% 	case lists:member(ChapId,Chaps) orelse ChapId =:= 0 of
%% 		?true ->
%% 			ChapFiend = role_api_dict:fiend_get(),
%% 			{Chap,NextChap,BattleList,NewChapFiend} = fiend_api:chap_info(Lv,ChapId,Chaps,ChapFiend),
%% 			VipFreshTimes = vip_api:check_fun(Vip#vip.lv, #d_vip.fiend_times),
%% 			role_api_dict:fiend_set(NewChapFiend),
%% 			FreeTimes = VipFreshTimes-NewChapFiend#fiend.buy_times,
%% 			FreshTimes = ?IF(FreeTimes>0,FreeTimes,0),
%% 			BinMsg1	= fiend_api:msg_chap_data(Chap,NextChap,FreshTimes,BattleList),
%% 			BinMsg2	= fiend_api:msg_chap_data_new(Chap,NextChap,FreshTimes,BattleList),
%% 			app_msg:send(Socket, <<BinMsg1/binary,BinMsg2/binary>>);
%% 		_ ->
%% 			BinMsg	= system_api:msg_error(?ERROR_FIEND_NO_CHAP),
%% 			app_msg:send(Socket, BinMsg)
%% 	end,
%% 	{?ok,Player};

%% 请求魔王副本
gateway(?P_FIEND_REQUEST, #player{socket=Socket,lv=Lv,vip=Vip}=Player, Binary) ->
	{ChapId} = app_msg:decode({?int16u},Binary),
	case ChapId of
		0 ->
			case fiend_api:chap_info_new(Lv,Vip) of
				{?ok,BinMsg} ->
					app_msg:send(Socket, BinMsg);
				{?error,ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg)
			end;
		_ ->
			case fiend_api:chap_info_new(ChapId,Lv,Vip) of
				{?ok,BinMsg} ->
					app_msg:send(Socket, BinMsg);
				{?error,ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg)
			end
	end,
	{?ok,Player};

%% 刷新魔王副本
gateway(?P_FIEND_FRESH_COPY, #player{socket=Socket}=Player, Binary) ->
	{CopyId} = app_msg:decode({?int16u},Binary),
	?MSG_ECHO("----------------~w~n",[CopyId]),
	case fiend_api:fresh_copy(Player,CopyId) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

gateway(ProtocolCode, Player, Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.