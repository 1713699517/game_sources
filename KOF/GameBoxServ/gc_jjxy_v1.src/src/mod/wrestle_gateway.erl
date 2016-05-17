%% Author: acer
%% Created: 2012-12-28
%% Description: TODO: Add description to defend_book_gateway.
-module(wrestle_gateway).

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

%% 预赛活动入口 54801
gateway(?P_WRESTLE_BOOK, #player{uid = Uid} = Player, _Bin) ->
%% 	case ets:lookup(?ETS_ACTIVE_STATE, ?CONST_ACTIVITY_WRESTLE_YUSAI) of   %% 取得活动的状态
%% 		[{_,State}|_] ->
%% 			case State of
%% 				?CONST_ACTIVITY_STATE_SIGN ->         %%  报名状态
%% 					case wrestle_api:book() of
%% 						{?ok, BinMsg} ->
%% 							app_msg:send(Player#player.socket, BinMsg),
%% 							{?ok, Player};
%% 						{?error, ErrorCode} ->
%% 							ErrMsg = system_api:msg_error(ErrorCode),
%% 							app_msg:send(Player#player.socket, ErrMsg),
%% 							{?ok, Player}
%% 					end;
%% 				?CONST_ACTIVITY_STATE_START ->        %% 活动开始状态
					case wrestle_api:request(Uid) of						 
						{?ok, BinMsg} ->
							app_msg:send(Player#player.socket, BinMsg),
							{?ok, Player};
						{?error, ErrorCode} ->
							ErrMsg = system_api:msg_error(ErrorCode),
							app_msg:send(Player#player.socket, ErrMsg),
							{?ok, Player}
					end;
%% 				_ ->
%% 					app_msg:send(Player#player.socket, app_msg:msg(?P_WRESTLE_PLAYER, <<>>)),
%% 					{?ok, Player}
%% 			end;
%% 		_ ->
%% 			app_msg:send(Player#player.socket, app_msg:msg(?P_WRESTLE_PLAYER, <<>>)),
%% 			{?ok, Player}
%% 	end;

%% 报名 54803
gateway(?P_WRESTLE_APPLY, Player, _Bin) ->
	case wrestle_api:apply(Player) of
		{?ok, BinMsg} ->
			app_msg:send(Player#player.socket, BinMsg),
			{?ok, Player};
		{?error, ErrorCode} ->
			ErrMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, ErrMsg),
			{?ok, Player}
	end;

%% 积分榜数据 54815
gateway(?P_WRESTLE_SCORE, #player{uid = Uid,socket = Socket} = Player, _Bin) ->
	{?ok, BinMsg} = wrestle_api:score(Uid),
	app_msg:send(Socket, BinMsg),
    {?ok, Player};
	
%% 决赛入口  54850
gateway(?P_WRESTLE_FINAL_REQUEST, #player{uid = Uid} = Player, Bin) ->
	 {Type} = app_msg:decode({?int8u},Bin),
     case wrestle_api:final(Type,Uid) of
		{?ok, BinMsg} ->
			app_msg:send(Player#player.socket, BinMsg),
			{?ok, Player};
		{?error, ErrorCode} ->
			ErrMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, ErrMsg),
			{?ok, Player}
	end;

%% 离开格斗之王面板
gateway(?P_WRESTLE_DROP, #player{uid = Uid} = Player, _Bin) ->
	wrestle_api:drop(Uid),
    {?ok, Player};

%% 欢乐竞猜
gateway(?P_WRESTLE_GUESS, Player, Bin) ->
	{Uid1,Uid2,Rmb} = app_msg:decode({?int32u,?int32u,?int32u},Bin),
	?MSG_ECHO("==~w~n",[{Uid1,Uid2,Rmb}]),
	case wrestle_api:guess(Player,Uid1,Uid2,Rmb) of
		{?ok, Player2,BinMsg} ->
			app_msg:send(Player#player.socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			ErrMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, ErrMsg),
			{?ok, Player}
	end;

%% 断线重连，重新请求竞猜数据
gateway(?P_WRESTLE_CONNET, #player{uid = Uid} = Player, _Bin) ->
   {?ok, BinMsg} = wrestle_api:guess_con(Uid),
   app_msg:send(Player#player.socket, BinMsg),
   {?ok, Player};

%% 王者争霸
gateway(?P_WRESTLE_ZHENGBA, Player, _Bin) ->
	{?ok, BinMsg} = wrestle_api:king(),
	app_msg:send(Player#player.socket, BinMsg),
    {?ok, Player};

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Bin)-> % 错误匹配
	?MSG_ERROR("ERROR ProtocolCode:~p, Binary:~p~n",[ProtocolCode, Bin]),
	{?ok, Player}.
