%% Author: mirahs
%% Created: 2013-1-6
%% Description: TODO: Add description to team_gateway
-module(team_gateway).

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
%% 请求队伍面板 
gateway(?P_TEAM_REQUEST, #player{socket=Socket}=Player, Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	case team_api:request_team(Type) of
		{?ok,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok, Player#player{team_type=Type}};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 请求通关的副本 
gateway(?P_TEAM_PASS_REQUEST, #player{socket=Socket}=Player, Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	BinMsg = team_api:request_pass(Type),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 创建队伍 
gateway(?P_TEAM_CREAT, #player{socket=Socket}=Player, Bin) ->
	{CopyId} = app_msg:decode({?int16u},Bin),
	?MSG_ECHO("_--------------------~w~n",[CopyId]),
	case team_mod:creat(Player,CopyId) of
		{?ok,Player1} ->
			{?ok,Player1};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 加入队伍 
gateway(?P_TEAM_JOIN, #player{socket=Socket}=Player, Bin) ->
	{TeamId} = app_msg:decode({?int32u},Bin),
	?MSG_ECHO("_--------------------~w~n",[TeamId]),
	case team_mod:join(Player,TeamId) of
		{?ok,Player1} ->
			{?ok,Player1};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 离开队伍 
gateway(?P_TEAM_LEAVE, Player, _Bin) ->
	Player1 = team_mod:leave(Player),
	{?ok,Player1};

%% 踢出队员
gateway(?P_TEAM_KICK, Player, Bin) ->
	{Uid} = app_msg:decode({?int32u},Bin),
	team_mod:kick(Player,Uid),
	{?ok,Player};

%% 设置新队长
gateway(?P_TEAM_SET_LEADER, #player{socket=Socket}=Player, Bin) ->
	{MemUid} = app_msg:decode({?int32u},Bin),
	case team_mod:leader_set(Player,MemUid) of
		{?ok,Player1} ->
			{?ok,Player1};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 申请做队长
gateway(?P_TEAM_APPLY_LEADER, Player, _Bin) ->
	team_mod:leader_apply(Player),
	{?ok,Player};

%% 邀请好友
gateway(?P_TEAM_INVITE, #player{socket=Socket}=Player, Bin) ->
	{InviteUid,InviteType} = app_msg:decode({?int32u,?int8u},Bin),
	case team_mod:invite(Player,InviteUid,InviteType) of
		?ok ->
			?ok;
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg)
	end,
	{?ok,Player};

%% 查询队伍是否存在
gateway(?P_TEAM_LIVE_REQ, #player{socket=Socket}=Player, Bin) ->
	{TeamId,Type} = app_msg:decode({?int32u,?int8u},Bin),
	BinMsg = team_api:team_live(TeamId,Type),
	app_msg:send(Socket, BinMsg),
	{?ok,Player};

gateway(ProtocolCode,Player,Binary)->
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.