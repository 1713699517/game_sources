%% Author: Administrator
%% Created: 2012-11-13
%% Description: TODO: Add description to energy_gateway
-module(system_gateway).

%%
%% Include files
%%
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([gateway/3]).


gateway(?P_SYSTEM_HEART, Player, _Binary) -> % 501 玩家心跳协议
	Milliseconds	= util:milliseconds(),
	Seconds			= util:seconds(),
	RsList = app_msg:encode([{?int32u,Seconds},
        {?int8u,245},{?int16u,56785},
        {?string,<<"玩家心跳协议">>},{?stringl,<<"4444玩家心gggggggg跳协议">>}]),
    BinTime =  app_msg:msg(?P_SYSTEM_TIME, RsList),
	app_msg:send(Player#player.socket, BinTime),
	{?ok, Player};
%% gateway(?P_SYSTEM_HEART, Player, _Binary) -> % 501 玩家心跳协议
%% 	Milliseconds	= util:milliseconds(),
%% 	Seconds			= util:seconds(),
%% 	%Io				= Player#player.io,
%% 	Io				= #io{},
%% 	if
%% 		Milliseconds - Io#io.heart >= ?CONST_INTERVAL_HEART ->
%% 			Player2 = Io#io{heart = Milliseconds, heart_errs = 0},
%% 			% Player3 = role_api:fcm(Player2, Seconds), 
%% 			Player3 = Player2, 
%% 			BinTime = system_api:msg_time(Seconds),
%% 			app_msg:send(Player3#player.socket, BinTime),
%% 			{?ok, Player3};
%% 		?true ->
%% 			% ?MSG_ERROR("ERROR PLAYER:{Sid:~p Uid:~p} BAD HEART...(~p)", [Player#player.sid, Player#player.uid, Player#player.hearts]),
%% 			Io2 = Io#io{heart = Milliseconds, heart_errs = Io#io.heart_errs + 1},
%% 			if
%% 				Io2#io.heart_errs >= ?CONST_BAD_HEART -> % 作弊行为
%% 					BinMsg = system_api:msg_error(?ERROR_CHEAT),
%% 					app_msg:send(Player#player.socket, BinMsg),
%% 					{?error, ?ERROR_CHEAT};
%% 				?true ->
%% 					Player3 = role_api:fcm(Player#player{io=Io2}, Seconds),
%% 					BinTime = system_api:msg_time(Seconds),
%% 					app_msg:send(Player#player.socket, BinTime),
%% 					{?ok, Player3}
%% 			end
%% 	end;

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

