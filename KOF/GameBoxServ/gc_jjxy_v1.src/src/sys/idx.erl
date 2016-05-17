%% Author: Administrator
%% Created: 2012-6-30
%% Description: TODO: Add description to lib_index
-module(idx).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([init_not_mysql/0,
		 init_use_mysql/0,
		 
		 reg/2,
		 reg_mysql/3,
		 reg_mysql_sid/3,
		 reg_global/3,
		 
		 srv_idx/0,
		 work_idx/0,
		 mysql_idx_logs/0,
		 mysql_idx_clear_logs/0,
		 mysql_idx/0,
		 mysql_idx_clear/0
		 ]).


%% 最开始的初始化(不用MYSQL数据库)
init_not_mysql() ->
	reg(srv_idx,		1),
	reg(work_idx,		1), 
	reg(mysql_idx,		1),
	reg(mysql_idx_logs, 1),
	idx_api:init_not_mysql(),
	?ok.

%% 正常初始化(需要MYSQL服务启动)
init_use_mysql() ->
	idx_api:init_use_mysql(),
	?ok.


reg(Name,DefaultVal) ->
	ets:insert(?ETS_S_INDEX, 	{Name,DefaultVal}).

reg_mysql(TableName,DefaultVal,FieldName) ->
	Val = case mysql_api:select_max(io_lib:format("SELECT max(~p) FROM `~p` ", [FieldName,TableName])) of 
			   {?error,Error}->
				   ?MSG_ERROR("~p",[Error]), 
				   DefaultVal;
			   {?ok,[[MaxVal]]}->
				   MaxVal
		   end,
	ets:insert(?ETS_S_INDEX,	{TableName,Val}).

reg_mysql_sid(TableName,DefaultVal,FieldName) ->
	Val = case mysql_api:select_max(io_lib:format("SELECT max(~p) FROM `~p` ", [FieldName,TableName])) of 
			   {?error,Error}->
				   ?MSG_ERROR("~p",[Error]), 
				   DefaultVal;
			   {?ok,[[MaxVal]]}->
				  lists:max([MaxVal,DefaultVal])
		   end,
	ets:insert(?ETS_S_INDEX,	{TableName,Val}).

reg_global(TableName,DefaultVal,GlobalKey) ->
	Val = case global_data:get(GlobalKey) of
			  V when is_integer(V) -> V;
			  _null -> DefaultVal
		  end,
	ets:insert(?ETS_S_INDEX,	{TableName,Val}).

%% Serv累加器
srv_idx()->
	ets:update_counter(?ETS_S_INDEX, srv_idx, 1).

%% 玩家工作进程
work_idx()->
	ets:update_counter(?ETS_S_INDEX, work_idx,1).

%% 超时次数
mysql_idx()->
	ets:update_counter(?ETS_S_INDEX, mysql_idx,1).

%% 超时次数清理
mysql_idx_clear()->
	ets:insert(?ETS_S_INDEX, 		{mysql_idx,1}).

%% 超时次数
mysql_idx_logs()->
	ets:update_counter(?ETS_S_INDEX, mysql_idx_logs,1).

%% 超时次数清理
mysql_idx_clear_logs()->
	ets:insert(?ETS_S_INDEX, 		{mysql_idx_logs,1}).
