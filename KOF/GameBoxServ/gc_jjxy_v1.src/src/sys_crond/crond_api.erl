%% Author: dreamxyp
%% Created: 2011-5-30
%% Description: TODO: Add description to system_api_crond
-module(crond_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([reg/2,
		 reg_undo/2,
		 time_after/4,
		 time_after_cancel/1,
		 seed/0,
		 clock_add/10,
		 clock_del/1,
		 clock_list/0,
		 interval_add/5,
		 interval_del/1,
		 interval_list/0,
		 interval/0,
		 interval_half/0,
		 reload/0]).

%% 得到种子数
seed()->
	case erlang:whereis(crond_srv) of
		Pid when is_pid(Pid) ->
			crond_srv:seed_call();
		_undefined -> 
			{M,S,Ms} = erlang:now(),
			{M,S,Ms div 1000}
	end.

%% 多少秒后执行(Module,Function,Args)
time_after(AfterTime, Module,Function,Args) ->
	TaskID	= make_ref(),
	Limit	= 1,  % 执行上限次数  1:执行一次就 消失 
	crond_srv:interval_add_cast(TaskID, AfterTime, Limit, Module, Function, Args),
	TaskID.
%% 取消
time_after_cancel(TaskId)->
	crond_srv:interval_del_cast(TaskId).
		
	
%% 注册一个时间 
reg(Pid, Time) ->
	crond_srv:reg_cast(Pid, Time). 

%% 撤销注册一个时间 
reg_undo(Pid, Time) ->
	crond_srv:reg_undo_cast(Pid, Time). 

%% 列出当前任务
clock_list() ->
	crond_srv:clock_list_call().
%% 添加一个任务
clock_add(TaskID,Sec,Min,Hour,Day,Month,Week,Module,Function,Args) ->
	Limit	= 0, % 执行上限次数  0:没上限  
	crond_srv:clock_add_cast(TaskID,Sec, Min, Hour, Day, Month, Week, Limit,Module, Function, Args).
%% 删除一个任务(参数要与添加任务时提供的参数相同)
clock_del(TaskId) ->
	crond_srv:clock_del_cast(TaskId).
%% 列出当前任务
interval_list() ->
	crond_srv:interval_list_call().
%% 添加一个任务
interval_add(TaskID,Interval,Module,Function,Args) ->
	Limit	= 0, % 执行上限次数  0:没上限  
	crond_srv:interval_add_cast(TaskID, Interval, Limit,Module, Function, Args).
%% 删除一个任务(参数要与添加任务时提供的参数相同)
interval_del(TaskId) ->
	crond_srv:interval_del_cast(TaskId).
%% 定时回调
interval()->
	crond_srv:interval_cast().
%% 定时回调(半秒)
interval_half()->
	crond_srv:interval_half_cast().
%% 重载配置文件
reload() ->
	crond_srv:reload_cast().
