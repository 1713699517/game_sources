%% Author: mirahs
%% Created: 2011-12-17
%% Description: TODO: Add description to copy_gateway
-module(hero_gateway).

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
%% 请求英雄副本
%% gateway(?P_HERO_REQUEST, #player{socket=Socket,lv=Lv,vip=Vip}=Player, Binary) ->
%% 	{ChapId} = app_msg:decode({?int16u},Binary),
%% 	?MSG_ECHO("----------------~w~n",[ChapId]),
%% 	Chaps	= data_copy_chap:gets_hero(),
%% 	case lists:member(ChapId,Chaps) orelse ChapId =:= 0 of
%% 		?true ->
%% 			ChapHero = role_api_dict:hero_get(),
%% 			{Chap,NextChap,MyChap,NewChapHero} = hero_api:chap_info(Lv,ChapId,Chaps,ChapHero),
%% 			role_api_dict:hero_set(NewChapHero),
%% 			CanBuyTimes = vip_api:check_fun(Vip#vip.lv, #d_vip.tran_buy),
%% 			AlBuyTimes = ChapHero#hero.buy_times,
%% 			FreeBuyTimes1 = CanBuyTimes - AlBuyTimes,
%% 			FreeBuyTimes = ?IF(FreeBuyTimes1 > 0, FreeBuyTimes1, 0),
%% 			BinMsg1	= hero_api:msg_chap_data(Chap,NextChap,NewChapHero#hero.times,AlBuyTimes,FreeBuyTimes,MyChap),
%% 			BinMsg2	= hero_api:msg_chap_data_new(Chap,NextChap,NewChapHero#hero.times,AlBuyTimes,FreeBuyTimes,MyChap),
%% 			app_msg:send(Socket, <<BinMsg1/binary,BinMsg2/binary>>);
%% 		_ ->
%% 			BinMsg	= system_api:msg_error(?ERROR_HERO_NO_CHAP),
%% 			app_msg:send(Socket, BinMsg)
%% 	end,
%% 	{?ok,Player};

gateway(?P_HERO_REQUEST, #player{socket=Socket,lv=Lv,vip=Vip}=Player, Binary) ->
	{ChapId} = app_msg:decode({?int16u},Binary),
	?MSG_ECHO("=====================~w~n",[ChapId]),
	case ChapId of
		0 ->
			case hero_api:chap_info_new(Lv,Vip) of
				{?ok,BinMsg} ->
					app_msg:send(Socket, BinMsg);
				{?error,ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg)
			end;
		_ ->
			case hero_api:chap_info_new(ChapId,Lv,Vip) of
				{?ok,BinMsg} ->
					app_msg:send(Socket, BinMsg);
				{?error,ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg)
			end
	end,
	{?ok,Player};

%% 购买英雄副本次数
gateway(?P_HERO_BUY_TIMES, #player{socket=Socket}=Player, Binary) ->
	{Times} = app_msg:decode({?int16u},Binary),
	?MSG_ECHO("----------------~w~n",[Times]),
	case hero_api:buy_times(Player,Times) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

gateway(ProtocolCode, Player, Binary)->
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.