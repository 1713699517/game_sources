%% Author: Administrator
%% Created: 2009-4-7
%% Description: TODO: Add description to test
-module(gc_server).

-behaviour(application).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% Behavioural exports
%% --------------------------------------------------------------------
-export([start/2,stop/1]). 
%%
%% Exported Functions
%%
-export([interval/0,
		 
		 gc_start/0,
		 gc_stop/0,
		 % gc_reboot/0,
		 
		 game_stop_node/0,		
		 game_stop/1,
		 game_out/0,
		 game_start/0,
		 game_stop_msg/2,
		 % test/0,
		 lc/0,
		 l/0]).
%% ====================================================================!
%% External functions 
%% ====================================================================!
%% --------------------------------------------------------------------
%% Func: start/2
%% Returns: {?ok, Pid}        |
%%          {?ok, Pid, State} |
%%          {?error, Reason}
%% --------------------------------------------------------------------
start(_Type, _StartArgs) ->     
	Cores		= util:core_count(),
	?ok			= db:init(),  			%% ETS初始化
	?ok			= db:init_config(),  	%% 加载yrl Config
	?ok			= idx:init_not_mysql(), %% Idx 第一次初始化
	{ok,_}= mysql_sup:start_link(mysql_sup, Cores), 		%% 启动MYSQL
	util:sleep(3000),			   	 	%% 暂停 毫秒
	?ok			= idx:init_use_mysql(), %% Idx 第二次初始化，要MYSQL的支持

	?ok 		= db_api:load_ets(),	  	%% 从MYSQL等把数据读入ETS
	
	{?ok,_}		= global_sup:start_link(global_sup, Cores),		%% 启动主监控 

	{?ok,_}		= scene_sup:start_link(scene_sup, Cores),		%% 启动地图
	{?ok,_}		= copy_sup:start_link(copy_sup, Cores),			%% 启动副本
	% 把所有都开动后才开网关
	?ok 		= callback_start(),
	{?ok,_}		= gateway_sup:start_link(gateway_sup, Cores),	%% 启动网关 
	% 
	ping_start(),
	% ?MSG_ECHO("~p",[RS]),
	?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
	?MSG_PRINT(" ~n~nAll Server Start Over ! ~n",[]), 
	{?ok, self() }.

%% --------------------------------------------------------------------
%% Func: stop/1
%% Returns: any
%% --------------------------------------------------------------------
stop(_State)-> 
    ?ok.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 定时调用(17秒)
%% gc_server:interval().
interval() ->
	case db:config_node_state() of
		1 -> ping_start();
		0 -> ?skip
	end.


%% 服务器开启成功 后 要调的写在这里
callback_start()->
	notice_api:init(),
	task_api:init_task_data(),
	is_funs_api:start_funs(),
%% 	active_mod:ref_active_state(),  %%　服务器开启后刷新所有活动状态
	?ok.

%% 关服 前 要调的写在这里
callback_stop()->
	arena_api:maysql_arena(),
	?ok.
	

%% 启动服务
gc_start()-> 
 	l(), 
	inets:start(), 
	crypto:start(),
	application:start(gc_server).

gc_stop()->
	application:stop(gc_server),
	crypto:stop(),
	inets:stop().



%% Ping通Master 
ping_start()->
	{
		sid,	   Sid,
		sid_merge, SidMerge,
		business,  _LineNums
	} 		= db:config_read_file(line),
	Sids	= [Sid|SidMerge],
	Node	= node(),
	NodeNameMaster	= app_tool:node_master(),
%%  	?MSG_PRINT("NodeName:~p",[NodeNameMaster]),
	case net_adm:ping(NodeNameMaster) of
		?pong ->
			rpc:call(NodeNameMaster, master_api, node_sid_start, [Sids,Node]);
		_ ->
%% 			?MSG_ERROR("node_not_started NodeNameMaster:~p",[NodeNameMaster])
             ?skip
	end,
	case app_tool:node_super() of
		0 -> ?skip;
		NodeNameSuper ->
			case net_adm:ping(NodeNameSuper) of
				pong ->
					rpc:call(NodeNameSuper, super_api, node_sid_start, [Sids,Node]);
				_ ->
					?MSG_ERROR("node_not_started NodeNameSuper:~p",[NodeNameSuper])
			end
	end,
	?ok.
ping_stop()->
	ets:insert(?ETS_S_CONFIG,{node_state,0}),
	{
		sid,	   Sid,
		sid_merge, SidMerge,
		business,  _LineNums
	} 		= db:config_read_file(line),
	Sids	= [Sid|SidMerge],
	
	NodeNameMaster	= app_tool:node_master(),
	?MSG_PRINT("NodeName:~p",[NodeNameMaster]),
	case net_adm:ping(NodeNameMaster) of
		pong ->
			rpc:call(NodeNameMaster, master_api, node_sid_stop, [Sids]);
		_ ->
			?MSG_ERROR("node_not_started NodeNameMaster:~p",[NodeNameMaster])
	end,
	case app_tool:node_super() of
		0 -> ?skip;
		NodeNameSuper ->
			case net_adm:ping(NodeNameSuper) of
				pong ->
					rpc:call(NodeNameSuper, super_api, node_sid_stop, [Sids]);
				_ ->
					?MSG_ERROR("node_not_started NodeNameSuper:~p",[NodeNameSuper])
			end
	end,
	?ok.
	





%% 加载beam
l()->
	{?ok,Dir} 		= file:get_cwd(),
	app_tool:l(Dir).

%% 加载beam
lc()->
	l(),
	ets:delete_all_objects(?ETS_OFFLINE),
	goods_api:activity_state_init(),
	idx:mysql_idx_clear_logs(),
	idx:mysql_idx_clear(),
	crond_api:reload(),
	?ok.


%% 开服
game_start()->
	?MSG_PRINT("start",[]),
	gc_start(),
	?ok.

%% 停止服务
%% @param bool $is_now  true:关服  false:先发通知，5分钟后重起服务器
game_stop(?true)->
	gc_stop();
game_stop(_false)->
	game_stop2(?null).


%% 停止节点
game_stop_node()->
	gc_stop(),
	halt().



game_stop2(CallBack)->
	% gateway_sup:wake_up().
	ping_stop(),
	% --------------------
	gateway_sup:down(),
	callback_stop(),
	% 发通知
	game_stop_msg(10),
	game_stop_msg(5000, 600000),
	% 踢人下线
	game_out(),
	% 再停半分钟
	util:sleep(30500), 
	% 停服
	gc_stop(),
	% 回调
	case CallBack of
		?null -> ?ok;
		_ -> CallBack()
	end,
	?ok.

% 在Long时长时每Delay执行一次
game_stop_msg(Delay,Long) ->
	if
		Delay < Long ->
			game_stop_msg(Delay),
			game_stop_msg(Delay,Long-Delay);
		?true ->
			?skip
	end.
% 延时毫秒
game_stop_msg(Delay)->
	spawn(fun()->
				  process_flag(?trap_exit, ?true),
				  BeginTime = util:seconds(),
				  EndTime   = BeginTime + 600,
				  util:sleep(Delay),
				  notice_api:update(sys_stop, 6 ,300, BeginTime, EndTime,20, <<"为游戏更好服务玩家，本服即将停机维护，给您带来诸多不便敬请原谅！">>)
		  end).
% 踢人
game_out()->
	BinMsg	   = system_api:msg_disconnect(?ERROR_OUT_STOP,<<>>),
	WorkerList = gateway_worker_sup:worker_list(),
	?MSG_ECHO("WorkerList:~p",[WorkerList]),
	lists:foreach(fun({_ServName,MPid,_Type,_Modules}) -> 
						  app_msg:send(MPid,  BinMsg),
						  util:sleep(50), % 每秒踢20个下线
						  % ?MSG_ECHO("MPid:~p",[MPid]),
						  util:pid_send(MPid, ?exit)
				  end, WorkerList),
	util:sleep(?CONST_OUTTIME_CALL),
	case WorkerList of
		[] -> ?skip;
		_  -> game_out() % 再来一次
	end.







