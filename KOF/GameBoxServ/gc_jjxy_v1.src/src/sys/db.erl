%% Author  : Tom Zhang
%% Created: 2012-6-19
%% Description: TODO: Add description to db
-module(db).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").

%%
%% Exported Functions
%%
-export([
		 init/0,
		 init_config/0,
		 % load_mysql/0,
		 
		 % save_s_global/0,
		
		 config/1,
		 
		 config_read_file/1,
		 config_read_file/2,
		 
		 config_api_key/0,
		 config_level_max/0,
		 config_mysql/0,
		 config_mysql/1,
		 config_mysql_logs/0,
		 config_mysql_logs/1,
		 config_gateway/0,
		 config_line/0,
		 
		 config_fcm_callback/0,
		 config_node_callback/0,
		 config_node_super_callback/0,
		 config_node_state/0,
		 
		 config_work_day/0,
		 
		 config_diff_time/0,
		 config_diff_time_set/1
		]).


%% ETS数据库  初始化
init()->
	ets:new(?ETS_S_INDEX,	  		[set,public,named_table,{keypos,1}]),   %% 索引
	ets:new(?ETS_S_CONFIG,	  		[set,public,named_table,{keypos,1}]),	%% 配制
	ets:new(?ETS_S_GLOBAL,	  		[set,public,named_table,{keypos,1}]),	%% 全局状态
	db_api:init_ets(),
	?ok.
 



init_config()->
	NodeTag	  = app_tool:node_tag(),
	SidString = util:to_list(NodeTag), 
	FileName  = ?FILENAME_CONFIG_BASE++SidString++".yrl", 
	Datas 	  = app_tool:ly(FileName), 
	ets:insert(?ETS_S_CONFIG, Datas),
	%% 服务器SID
	case db:config_line() of
		{
			sid,			Sid,
		 	sid_merge,		_SidMerge,
		 	business,		_LineNums
		} ->
			ets:insert(?ETS_S_CONFIG,{sid,Sid});
		_ ->
			ets:insert(?ETS_S_CONFIG,{sid,0})
	end,
	ets:insert(?ETS_S_CONFIG,{node_state,1}),
	?ok.

%% 读取数据库到ETS表(数据加载)
%% load_mysql()->
%% 	% load_ets_s_global(),
%% 	?ok.

%% save_s_global() ->
%% 	clan_api:save_clan_role(),
%% 	L  = ets:tab2list(?ETS_TIMES_GOODS_LOGS),
%% 	global_data:set(?GLOBAL_TIMES_GOODS_LOGS, lists:sublist(L, ?CONST_GOODS_TIMES_GOODS_LOGS)),
%% 	L2 = ets:tab2list(?ETS_TIMES_GOODS_LOGS2),
%% 	global_data:set(?GLOBAL_TIMES_GOODS_LOGS2, lists:sublist(L2, ?CONST_GOODS_TIMES_GOODS_LOGS)),
%% 	
%% 	arena_api:maysql_arena(),
%% 	idx:insert_goods_id(),
%% 	save_ets_dynamic(?ETS_MALL_BUY_MAX, ?GLOBAL_MALL_BUY_MAX),
%% 	save_ets_dynamic(?ETS_WHEEL_LOG, 	?GLOBAL_WHEEL_LOG),
%% 	save_ets_dynamic(?ETS_WHEEL_TIMES, 	?GLOBAL_WHEEL_TIMES).
%% 
%% save_ets_dynamic(Table, Key) ->
%% 	Value = case ets:info(Table) of
%% 				?undefined ->
%% 					[];
%% 				_ ->
%% 					ets:tab2list(Table)
%% 			end,
%% 	global_data:set(Key, Value).
	




%% 读取config(ETS)
config(Mod)->
	try 
		ets:lookup_element(?ETS_S_CONFIG, Mod, 2)
	catch 
		_E:_E2 ->
			ets:insert(?ETS_S_CONFIG,{Mod,0}),
			?MSG_ERROR("config error -> Mod:~p ~w:~w", [Mod,_E,_E2]),
			0
	end.

%% 得到服务器SID
%% config_sid()->
%% 	config(sid).


%% 读取跨服节点ID(为0时不支持跨服)
%% config_super_id()->
%% 	config(super_id).

%% 读取跨服节点
%% config_super_node()->
%% 	config(super_node).


%% 读取config(File)
config_read_file(Mod)->
	NodeTag	  = app_tool:node_tag(),
	config_read_file(Mod,NodeTag).
config_read_file(Mod,NodeTag)->
	SidString = util:to_list(NodeTag),
	FileName  = ?FILENAME_CONFIG_BASE++SidString++".yrl",
	Datas 	  = app_tool:ly(FileName),
	case lists:keyfind(Mod, 1, Datas) of
		?false ->
			exit({?error, "Could not find config:"++util:to_list(Mod)++" file:"++util:to_list(FileName)});
		{Mod,Value} ->
			Value
	end.

%% 游戏线路信息
config_line()-> 
	config(line).  

%% MYSQL
config_mysql()->
	config(mysql).
config_mysql(NodeTag)->
	config_read_file(mysql,NodeTag).

%% MYSQL LOGS
config_mysql_logs()->
	config(mysql_logs).
config_mysql_logs(NodeTag)->
	config_read_file(mysql_logs,NodeTag).

%% 服务器 网关
config_gateway()->
	config(gateway). 

%% 最大等级
config_level_max()->
	config(level_max).

%% 防沉迷回调地址
config_fcm_callback()->
	config(fcm_callback).

%% 节点状态回调地址
config_node_callback()->
	config(node_callback).

%% 跨服节点获取地址
config_node_super_callback()->
	config(node_super).

%% 节点状态
config_node_state()->
	config(node_state).

%% 用户认证API HTTP接口
config_api_key()->
	config(api_key).

%% 开服日期
config_work_day()->
	WorkDay = config(work_day), 
	calendar:date_to_gregorian_days(util:date()) - calendar:date_to_gregorian_days(WorkDay) + 1.

%% 得到时差
config_diff_time()->
	config(diff_time).
	
%% 设定当前时间
%% db:config_diff_time_set(<<"2012-02-27 11:00:09">>).
config_diff_time_set(DateTime)-> 
	{MegaSecs, Secs, _MicroSecs} = erlang:now(),
	Now  						 = MegaSecs*1000000 + Secs,
	SetTime						 = util:datetime2timestamp(DateTime),
	ets:insert(?ETS_S_CONFIG,{diff_time,SetTime-Now}).



%% load_ets_s_global() ->
%% 	Sql = "SELECT `k`,`val` FROM global_data",
%% 	case mysql_api:select(Sql) of
%% 		{ok, L} ->
%% 			F = fun([Key0,Value0]) ->
%% 						Key   = util:bitstring_to_term(Key0),
%% 						Value = util:bitstring_to_term(Value0),
%% 						ets:insert(?ETS_S_GLOBAL, {Key, Value})
%% 				end,
%% 			lists:foreach(F, L);
%% 		Err ->
%% 			?MSG_ERROR("Err : ~p~n", [Err])
%% 	end.