%% Author: dreamxyp
%% Created: 2011-9-14
%% Description: TODO: Add description to task_gateway
-module(task_gateway).

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
gateway(?P_TASK_REQUEST_LIST, #player{socket=Socket}=Player, _Bin) ->
	#tasks{tlist=Tasks} = role_api_dict:tasks_get(),
	Tasks2 = task_mod:check_all_task(Tasks),
	Bin = task_api:msg(?P_TASK_DATA, [Tasks2]), 
?MSG_ECHO("~n~n~n Tasks ~w~n Tasks2~w~n",[Tasks, Tasks2]),
	app_msg:send(Socket, Bin),
	{?ok, Player};

%% 接受任务
gateway(?P_TASK_ACCEPT, #player{socket=Socket}=Player, Bin) ->
	{TaskId} = app_msg:decode({?int32u},Bin),
	case task_mod:accept(Player,TaskId) of
		{?ok, Player2, BinMsg} when is_record(Player, player) ->
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;
		
%% 放弃任务 
gateway(?P_TASK_CANCEL, #player{socket = Socket} = Player, Bin) ->
	{TaskId}	= app_msg:decode({?int32u},Bin),
	case task_mod:drop(Player, TaskId) of
		{?ok, Player2, BinMsg} when is_record(Player, player) ->
			app_msg:send(Socket,BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket,BinMsg),
			{?ok, Player}
	end;		
		
%% 提交任务   
gateway(?P_TASK_SUBMIT, #player{socket = Socket} = Player, Bin) ->
	{TaskId, Arg} = app_msg:decode({?int32u, ?int32u},Bin),
	case task_mod:submit(Player, TaskId, Arg) of
		{?ok, Player2, BinMsg} when is_record(Player, player)->
			app_msg:send(Socket,BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket,BinMsg),
			{?ok, Player}
	end;

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.
