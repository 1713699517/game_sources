%% Author: mirahs
%% Created: 2013-1-6
%% Description: TODO: Add description to team_gateway
-module(friend_gateway).

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
%% 根据请求类型 请求好友||最近联系人||黑名单面板 
gateway(?P_FRIEND_REQUES, #player{socket=Socket}=Player, Bin) ->
	?MSG_ECHO("------------------~n",[]),
	{Type} = app_msg:decode({?int8u}, Bin),
	BinMsg = friend_mod:request_friend(Type),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};


%%按名称搜索玩家
gateway(?P_FRIEND_SEARCH_ADD, #player{socket=Socket} = Player, Bin) ->
	{Uname} = app_msg:decode({?string},Bin),
	case friend_mod:search_friend_add(Uname) of
		{?ok,Msg} ->
			app_msg:send(Socket, Msg);
		{?error, ErrorMsg} ->
			BinMsg = system_api:msg_error(ErrorMsg),
			app_msg:send(Socket, BinMsg)
	end,
	{?ok,Player};



%% 添加好友
gateway(?P_FRIEND_ADD, Player, <<Type:8/big-integer-unsigned,Count:16/big-integer-unsigned,Bin/binary>>) ->
	{_,List1} = lists:foldl(fun(_,{<<Fuid:32/big-integer-unsigned, AccBin/binary>>, List}) ->
									{AccBin,[Fuid|List]}
							end, {Bin, []}, lists:duplicate(Count, 0)),
	[friend_mod:friend_add(Player,Type,Fuid) || Fuid <- List1],
%% 	?MSG_ECHO("----------~w~n",[List1]),
	{?ok,Player};


%%删除好友
gateway(?P_FRIEND_DEL, #player{socket=Socket}=Player, Bin) ->
	{Uid,Type} = app_msg:decode({?int32u,?int8u},Bin),
	case friend_mod:delete_friend(Uid,Type) of
		{?ok,Msg} ->
			app_msg:send(Socket, Msg);
		{?error, ErrorMsg} ->
			BinMsg = system_api:msg_error(ErrorMsg),
			app_msg:send(Socket, BinMsg)
	end,
	{?ok,Player};

	

gateway(ProtocolCode,Player,Binary)->
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.