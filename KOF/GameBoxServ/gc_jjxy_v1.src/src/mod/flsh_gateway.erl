%% Author: mirahs
%% Created: 2013-1-6
%% Description: TODO: Add description to team_gateway
-module(flsh_gateway).

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
%% 请求剩余次数
gateway(?P_FLSH_TIMES_REQUEST, #player{socket=Socket}=Player, _Bin) ->
	BinMsg = flsh_api:request_times(),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 开始游戏
gateway(?P_FLSH_GAME_START, #player{socket=Socket}=Player, _Bin) ->
	case flsh_mod:game_start() of
		{?ok,BinMsg} ->
			app_msg:send(Socket, BinMsg);
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg)
	end,
	{?ok,Player};

%% 换牌
gateway(?P_FLSH_PAI_SWITCH, #player{socket=Socket}=Player, <<Count:16/big-integer-unsigned,Bin/binary>>) ->
	Fun = fun(_,{<<Pos:8/big-integer-unsigned,AccBin/binary>>, AccPos}) ->
				  {AccBin,[Pos|AccPos]}
		  end,
	{_,PosList} = lists:foldl(Fun, {Bin,[]}, lists:duplicate(Count, 0)),
	case flsh_mod:switch(Player,PosList) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 领取奖励
gateway(?P_FLSH_GET_REWARD, #player{socket=Socket}=Player, _Bin) ->
	case flsh_mod:get_reward(Player) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

gateway(ProtocolCode,Player,Binary)->
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.