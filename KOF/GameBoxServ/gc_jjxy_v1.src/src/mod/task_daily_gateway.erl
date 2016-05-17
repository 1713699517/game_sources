%% Author: dreamxyp
%% Created: 2011-9-14
%% Description: TODO: Add description to task_gateway
-module(task_daily_gateway).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% Exported Functions

-export([gateway/3]).

%%
%% API Functions
%% 

%% 请求任务列表
gateway(?P_DAILY_TASK_REQUEST, #player{socket = Socket} = Player, _Bin) ->
%% 	BinMsg = task_daily_api:ask(Player),
%% 	app_msg:send(Socket, BinMsg),
%% 	{?ok, Player};
    case task_daily_api:ask(Player) of 
		{?ok,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok,Player};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{ok,Player}
	end; 

%% 请求放弃任务
gateway(?P_DAILY_TASK_DROP, #player{socket = Socket,lv = Lv} = Player, _Bin) ->
	TaskDaily = role_api_dict:task_daily_get(),
	case TaskDaily#task_daily.left > ?CONST_TASK_DAILY_ZERO of
		?true ->
			BinMsg = task_daily_api:drop(Lv),
			app_msg:send(Socket, BinMsg),
			{?ok, Player};
		_ ->
			BinMsg = system_api:msg_error(?ERROR_TASK_DAILY_NOT_COUNT),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 请求一键完成任务
gateway(?P_DAILY_TASK_KEY, #player{socket = Socket} = Player, _Bin) ->
	TaskDaily = role_api_dict:task_daily_get(),
	case TaskDaily#task_daily.left > ?CONST_TASK_DAILY_ZERO of
		?true ->
			case task_daily_api:key(Player) of
				{?ok,Player2,BinMsg} ->
					app_msg:send(Socket, BinMsg),
					{?ok, Player2};
				{?error,ErrorCode} ->
					Bin = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, Bin),
					{?ok,Player}
			end;
		_ ->
			BinMsg = system_api:msg_error(?ERROR_TASK_DAILY_NOT_COUNT),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 请求领取奖励
gateway(?P_DAILY_TASK_REWARD, #player{socket = Socket} = Player, _Bin) ->
	case task_daily_api:reward(Player) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{ok,Player}
	end;
	
%% 请求vip 重置次数
gateway(?P_DAILY_TASK_VIP_REFRESH, #player{socket = Socket} = Player, _Bin) ->
	case task_daily_api:vip_refresh(Player) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
	        {?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{ok,Player}
	end;
	

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.
