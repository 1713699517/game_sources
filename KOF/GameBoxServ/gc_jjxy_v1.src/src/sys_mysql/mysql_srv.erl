%%% -------------------------------------------------------------------
%%% Author  : lenovo
%%% Description :
%%%
%%% Created : 2010-5-10
%%% -------------------------------------------------------------------
-module(mysql_srv).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
-include("../include/drive.mysql.hrl").
%% --------------------------------------------------------------------
%% 调用导出
-export([callback_result_cast/1,heart_cast/1,fetch_cast/3]). 
%% --------------------------------------------------------------------
%% 以下系统默认导出(勿删)
-export([start_link/2,init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
%% 以下系统默认函数(勿删)
start_link(SrvName,Cores) -> 
	app_link:gen_server_start_link(SrvName, ?MODULE, [Cores], Cores).
init([Cores])     ->
	process_flag(?trap_exit, ?true),
	Reply = do_init(Cores),
	?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
	Reply.
handle_call(Request, From, State) -> 
	?TRY_DO(do_call(Request,From,State) ).
handle_cast(Msg,  State) -> 
	?TRY_DO(do_cast(Msg,State) ).
handle_info(Info, State) -> 
	?TRY_DO(do_info(Info,State)).
terminate(Reason,State)  -> 
	?TRY_DO(do_terminate(State)),
	case Reason of 
		?normal -> ?skip;
		_ 		-> ?MSG_ERROR("Terminate Reason:~w State:~w ",[Reason,State])
	end.
code_change(_OldVsn, State, _Extra) -> {?ok, State}.
%% --------------------------------------------------------------------
%%% DO 内部处理
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: do_init/1
%% Description: 初始化状态
%% Returns: {?ok, State}          |
%%          {?ok, State, Timeout} |
%%          ?ignore               |
%%          {?stop, Reason}
%% --------------------------------------------------------------------
do_init(Cores) ->
	%% 初始化State
    %% =================================================================
	State 		= #mysql_state{pool_ready	= [],	 	pool_working=[],
							   %sid			= Sid,		
							   queue		= []},
	%% =================================================================
	{
	 	host,		Host,
		post,		Port,
	 	username,	Username,
	 	password,	Password,
	 	database,	DatabasePre,
	 	charset,	Charset
	} 	  		= db:config_mysql(),
	Database 	= util:to_list(DatabasePre),
	StateSide	= #mysql_side{ %sid	  		= Sid ,  	 
							   %ver	  		= ?null, 
							   socket 		= ?null, 	 bin_acc  	= <<>>,					
					  		   host			= Host, 	 port		= Port,
						 	   username		= Username,  password	= Password,  
						 	   database		= Database,  charset	= Charset},
	PoolReady	= mysql_side_sup:start_child_mysql_side_srv(Cores, StateSide),
	%% =================================================================
	case db:config_mysql_logs() of
		{
		 	host,		LogsHost,
			post,		LogsPort,
		 	username,	LogsUsername,
		 	password,	LogsPassword,
		 	database,	LogsDatabasePre,
		 	charset,	LogsCharset
		} -> 
			LogsDatabase	= util:to_list(LogsDatabasePre),
			LogsStateSide	= #mysql_side{ %sid	  		= Sid ,  	 
									   %ver	  		= ?null, 
									   socket 		= ?null, 	 bin_acc  	= <<>>,					
							  		   host			= LogsHost, 	 port		= LogsPort,
								 	   username		= LogsUsername,  password	= LogsPassword,  
								 	   database		= LogsDatabase,  charset	= LogsCharset},
			% PoolReady	= mysql_side_sup:start_child_mysql_side_srv(Cores, StateSide),
			PoolLogs	= mysql_side_sup:start_child_mysql_side_srv_logs(Cores, LogsStateSide);
		_ ->
			PoolLogs	= ?null
	end,
	%% =================================================================
	% 
	idx:mysql_idx_clear_logs(),
	idx:mysql_idx_clear(),
	% ?MSG_ECHO(" PoolReady:~p ",[PoolReady]),
	State2		= State#mysql_state{pool_ready=PoolReady,pool_logs=PoolLogs},
	{?ok, State2}.








%% --------------------------------------------------------------------
%% Function: do_call/3
%% Description: 等待Call处理
%% Returns: {?reply, Reply, State}          |
%%          {?reply, Reply, State, Timeout} |
%%          {?noreply, State}               |
%%          {?noreply, State, Timeout}      |
%%          {?stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {?stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% do_call(Request,From,State)-> %% 示列
%% 	{?reply,?ok,State};
do_call(Request,From,State)->    %% 默认处理(勿删)
	?MSG_ERROR("Call Request:~p From:~w State:~w", [Request, From, State]),
	{?reply,?ok,State}.





%% --------------------------------------------------------------------
%% Function: do_cast/2
%% Description: 异步Cast处理
%% Returns: {?noreply, State}          |
%%          {?noreply, State, Timeout} |
%%          {?stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% do_cast(Msg,State) ->  %% 示列
%% 	{?noreply,State};
do_cast({fetch,FromPid,Ref,Query},State) ->
	State2		= fetch_handle(State, FromPid,Ref,Query), 
	{?noreply,	State2};
do_cast(heart,State) ->
	State2 		= heart_handle(State#mysql_state.pool_working,State#mysql_state{pool_working=[]}),
	{?noreply,	State2};
do_cast({ref,Ref},State) ->
	State2		= callback_result_handle(State, Ref),
	State3		= queue_handle(State2#mysql_state.queue, State2),
	{?noreply,	State3};
do_cast(Msg,State)->      %% 默认处理(勿删)
	?MSG_ERROR("Cast Msg:~w State:~w", [Msg,State]),
	{?noreply,State}.


%% --------------------------------------------------------------------
%% Function: do_info/2
%% Description: 异步Info处理
%% Returns: {?noreply, State}          |
%%          {?noreply, State, Timeout} |
%%          {?stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% do_info(Info,State)->     %% 示列
%% 	{?noreply,State};
%% do_info({?inet_reply,_Socket,_Msg}, State) -> %% 向Socket发包 返回
%% 	{?noreply, State};
do_info({?exec, Mod, Fun, Arg},State)->
	State2 = Mod:Fun(State, Arg),
	{?noreply, State2 };
%% do_info(?doloop,State)->  %% 处理注册定时 doloop
%% 	{?noreply,State};
do_info(Info,State)-> %% 默认处理(勿删)
	?MSG_ERROR("Info Info:~w State:~w", [Info,State]),
	{?noreply,State}.


%% --------------------------------------------------------------------
%% Function: do_terminate/2
%% Description: 退出处理内容
%% --------------------------------------------------------------------
do_terminate(_State)-> 
	?ok.


%% --------------------------------------------------------------------
%%% 外部调用Serv
%% --------------------------------------------------------------------
fetch_cast(PidFrom,Ref,Query) ->
	SrvName	= ?MODULE,% app_link:srv_name(?MODULE, Sid),
	gen_server:cast(SrvName, {fetch,PidFrom,Ref,Query}).
	
%% 查询完成，callback
callback_result_cast(Ref) ->
	SrvName = ?MODULE,%app_link:srv_name(?MODULE, Sid),
	gen_server:cast(SrvName, {ref,Ref}).
	
%% 心跳
heart_cast(SrvPid) ->
	gen_server:cast(SrvPid,	heart).



%% 发送查询
fetch_handle(State,FromPid,Ref,Query)->
	case State#mysql_state.pool_ready of
		[] ->
			Queue		= State#mysql_state.queue,
			State#mysql_state{queue=[{FromPid,Ref,Query}|Queue]}; 
		[SideSrvName|Readys] ->
			mysql_side_srv:fetch_cast(SideSrvName, FromPid, Ref, Query),
			Time 		= util:seconds(),
			This		= {Ref,FromPid,Time,SideSrvName},
			State#mysql_state{pool_ready=Readys,pool_working=[This|State#mysql_state.pool_working]}
	end.

%% 接收结果
callback_result_handle(State, Ref)->
	case lists:keytake( Ref, 1, State#mysql_state.pool_working) of
		{value, {Ref,_FromPid,_Time,SideSrvName},  Working} ->
			Readys		= State#mysql_state.pool_ready,
			State#mysql_state{pool_ready=Readys++[SideSrvName],pool_working=Working};
		?false ->
			State
	end.
%% 接收结果 时看看队列是否有存货有就发出去
queue_handle([],State)-> State#mysql_state{queue=[]};
queue_handle([{FromPid,Ref,Query}|Queue],State)-> 
	case State#mysql_state.pool_ready of
		[] -> 
			State#mysql_state{queue=[{FromPid,Ref,Query}|Queue]};
		_  ->
			State2 = fetch_handle(State,FromPid,Ref,Query),
			queue_handle(Queue,State2)
	end.
	

%% 心跳 
heart_handle(Workings,State)->
	heart_handle2(State#mysql_state.pool_ready),
	heart_handle3(Workings,State).
	
heart_handle2([])-> ?ok;
heart_handle2([SideSrvName|Readys]) ->
	mysql_side_srv:heart_cast(SideSrvName),
	heart_handle2(Readys).	
	
heart_handle3([], State)->State;
heart_handle3([{Ref,FromPid,Time,SideSrvName}|Workings2], State) ->
	TimeNow = util:seconds(),
	if
		TimeNow - Time >= ?MYSQL_TIMEOUT_RUN -> % SideSrv 重起
			mysql_side_sup:restart_child(SideSrvName),
			Readys		= State#mysql_state.pool_ready,
			State2		= State#mysql_state{pool_ready=Readys++[SideSrvName]};
		?true ->
			Workings    = State#mysql_state.pool_working,
			State2		= State#mysql_state{pool_working=[{Ref,FromPid,Time,SideSrvName}|Workings]}
	end,
	heart_handle3(Workings2,State2).
		
	
	

	