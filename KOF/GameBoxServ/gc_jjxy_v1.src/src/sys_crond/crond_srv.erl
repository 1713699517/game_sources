%%% -------------------------------------------------------------------
%%% Author  : zhys9
%%% Description :
%%%
%%% Created : 2010-12-8
%%% -------------------------------------------------------------------
-module(crond_srv).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% 调用导出
-export([reg_cast/2,reg_undo_cast/2,seed_call/0,
		 clock_add_cast/11,clock_del_cast/1,clock_list_call/0,
		 interval_del_cast/1,interval_list_call/0,
		 reload_cast/0,
		 interval_add_cast/6,interval_cast/0,interval_half_cast/0]).
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

%% 状态定义
-type timestamp() :: pos_integer().
%% 定时任务
-record(task_clock, {id,
					 sec,min,hour,day,month,week,
					 exem,exef,exea,limit,
					 last_exec :: timestamp(),
			   		 is_yrl :: boolean()}).
%% 间隔任务 
-record(task_interval,{id,
					   interval,
					   exem,exef,exea,limit,
			   		   last_exec :: timestamp(),
					   is_yrl :: boolean()}).

%% crond 状态
-record(state,{tref  	  = ?null, %% 定时
			   tref_half  = ?null, %% 定时半秒
			   half  = 0,	  %% 半秒 记数
			   total = 0,	  %% 开启到现在用的秒数
			   cores = 1,
			   times = 0,	  %% 核的计数
			   task_half	 = [] :: [#task_interval{}],
			   task_interval = [] :: [#task_interval{}],
			   task_clock    = [] :: [#task_clock{}]}).


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
	{M,S,Ms} 	= erlang:now(),
	put(seed,{M,S,Ms div 1}),
	%% 任务
%% 	{?ok,TRef}	= timer:apply_interval(round(timer:seconds(1)),  crond_api, interval, [] ),
	{?ok,TRef}	= timer:apply_interval(round(timer:seconds(0.5)), crond_api, interval_half, [] ),
	State		= #state{tref=TRef,cores=Cores,times=1}, 
 	State2 		= task_init(State),
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
do_call(rand_seed, _From, State) ->
	{A1,A2,A3} = get(seed),
	B1 = (A1*171) rem 30269,
    B2 = (A2*172) rem 30307,
    B3 = (A3*170) rem 30323, 
	put(seed,{B1,B2,B3}),
	{?reply, {A1,A2,A3}, State};
do_call(clist, _From, State) ->
    Reply = State#state.task_clock,
    {?reply, Reply, State};
do_call(ilist, _From, State) ->
    Reply = State#state.task_interval,
    {?reply, Reply, State};
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
do_cast({reg, Pid, Time},State) ->
	case get({timer,Time}) of
		?undefined->
			put({timer,Time},[Pid]),
			erlang:send_after(Time, self(), {?loop,Time}); 
		L->
			case lists:member(Pid, L) of
				?true ->?skip;
				?false->put({timer,Time},[Pid|L])
			end
	end,	
    {?noreply, State};
do_cast({reg_undo, Pid, Time},State) ->
	case get({timer,Time}) of
		?undefined->
			?skip; 
		L->
			case lists:member(Pid, L) of
				?true -> put({timer,Time},lists:delete(Pid, L));
				?false-> ?skip
			end
	end,
    {?noreply, State};
do_cast(interval, State) ->
	State2 = task_run(State),
    {?noreply, State2};
do_cast(half, State) ->
	State2 = task_run_half(State),
    {?noreply, State2};
do_cast({cadd, TaskID,Sec,Min,Hour,Day,Month,Week,Limit,Module,Function,Args}, State) ->
	State2 = task_record({TaskID,Sec,Min,Hour,Day,Month,Week,Limit,{Module,Function,Args}}, State, ?false),
	{?noreply, State2};
do_cast({iadd, TaskID,Interval,Limit,Module,Function,Args}, State) ->
	State2 = task_record({TaskID,Interval,Limit,{Module,Function,Args}}, State, ?false),
	{?noreply, State2};
do_cast({cdel, TaskId},State) ->	
	Task  =lists:foldl(fun(Data, Task2) when is_record(Data,task_clock)   andalso Data#task_clock.id /= TaskId  -> [Data|Task2];
			   		      (_Data,Task2) -> Task2
					   end,[],State#state.task_clock),
	State2=State#state{task_clock=Task},
	{?noreply, State2};
do_cast({idel, TaskId}, State) ->
	Task  =lists:foldl(fun(Data, Task2) when is_record(Data,task_interval) andalso Data#task_interval.id /= TaskId  -> [Data|Task2];
			   		      (_Data,Task2) -> Task2
					   end,[],State#state.task_interval),
	State2=State#state{task_interval=Task},
	{?noreply, State2};
do_cast(reload, State) ->
	timer:cancel(State#state.tref),
	{?ok,TRef}	= timer:apply_interval(round(timer:seconds(0.5)),crond_api,interval_half,[]),
	%{?ok,TRef}	= timer:apply_interval(round(timer:seconds(1)),crond_api,interval,[]),
	Interval 	= [T || T <- State#state.task_interval, T#task_interval.is_yrl=/=?true],
	Clock 		= [T || T <- State#state.task_clock, 	T#task_clock.is_yrl   =/=?true],
	Cores		= State#state.cores,
	State2		= #state{tref         =TRef,	cores     =Cores,
						 task_interval=Interval,task_clock=Clock},
	State3		= task_init(State2),
	?MSG_ECHO(" Server Restart ok ",[]),
    {?noreply, State3};
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
do_info({?loop,Time},State) ->
	case get({timer,Time}) of
		?undefined -> ?ok;
		Pids ->
			case [begin Pid!doloop,Pid end||Pid<-Pids, begin case is_pid(Pid) of
																 ?true ->
																	 erlang:is_process_alive(Pid);
																 ?false ->
																	 case whereis(Pid) of
																		 ?undefined ->
																			 ?false;
																		 PID ->
																			 erlang:is_process_alive(PID)
																	 end
															 end
													   end] of
				[] 		-> 
					erase({timer,Time});
				NewPids	-> 
					erlang:send_after(Time, self(),{?loop,Time}),
					put({timer,Time},NewPids)
			end
	end,
    {?noreply, State};
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
do_terminate(State)->
	timer:cancel(State#state.tref),
	?ok.


%% --------------------------------------------------------------------
%%% 外部调用Serv
%% --------------------------------------------------------------------


 
%% 得到种子数
seed_call()->
	gen_server:call(?MODULE,rand_seed).
%% 注册一个时间
reg_cast(Pid, Time) ->
	gen_server:cast(?MODULE,{reg, Pid, Time}),
	?ok.
%% 注销一个时间
reg_undo_cast(Pid, Time) ->
	gen_server:cast(?MODULE,{reg_undo, Pid, Time}),
	?ok.
%% 列出当前任务
clock_list_call() -> 
	gen_server:call(?MODULE, clist,?CONST_OUTTIME_CALL).
%% 添加一个任务
clock_add_cast(TaskID,Sec,Min,Hour,Day,Month,Week,Limit,Module,Function,Args) ->
	gen_server:cast(?MODULE, {cadd,TaskID,Sec,Min,Hour,Day,Month,Week,Limit,Module,Function,Args}).
%% 删除一个任务(参数要与添加任务时提供的参数相同)
clock_del_cast(TaskId) ->
	gen_server:cast(?MODULE, {cdel, TaskId}).
%% 列出当前任务
interval_list_call() ->
	gen_server:call(?MODULE, ilist,?CONST_OUTTIME_CALL).
%% 添加一个任务
interval_add_cast(TaskID,Interval,Limit,Module,Function,Args) ->
	gen_server:cast(?MODULE, {iadd,TaskID,Interval,Limit,Module,Function,Args}).
%% 删除一个任务(参数要与添加任务时提供的参数相同)
interval_del_cast(TaskId) ->
	gen_server:cast(?MODULE, {idel, TaskId}).
%% 定时回调
interval_cast()->
	gen_server:cast(?MODULE, interval).
%% 定时回调(半秒)
interval_half_cast()->
	gen_server:cast(?MODULE, half).
%% 重载配置文件
reload_cast() ->
	gen_server:cast(?MODULE, reload).



%% 从yrl加载初始配置
task_init(State) ->
	Dir = ?DIR_YRL_ROOT ++ "crontab/",
	case filelib:is_file(Dir) of
		?true ->
			{?ok,FileList} 	= file:list_dir(?DIR_YRL_ROOT ++ "crontab/"),
			Fun				= fun(FileBaseName)->
							  		FileName = ?DIR_YRL_ROOT ++ "crontab/"++FileBaseName,
							  		case filename:extension(FileBaseName) of
								  		".yrl" -> FileName;
								  		_ -> ?false
							  		end
							  end,
			FileList2		= lists:map(Fun, FileList),
			lists:foldl(fun task_file/2,   State, FileList2);
		?false ->
			State
	end.

task_file(FileName,State)->
	case filelib:is_file(FileName) of
		?true ->
			Data = app_tool:ly(FileName),
%% 			if 
%% 				is_list(Data) -> Data2 = Data;
%% 				?true 		  -> Data2 = [Data]
%% 			end,
			lists:foldl(fun task_record/2, State, Data);
		_ ->
			State
	end.	
task_record(Data,State)->
	task_record(Data,State,?true).
task_record({ID,{M,F,A},0.5,Limit},State,IsYrl) ->
	Task = #task_interval{id  =ID,interval=0.5,
						  exem=M, exef=F, exea=A,limit=Limit,
						  last_exec=0,is_yrl=IsYrl},
	TaskInterval = [Task|State#state.task_half],
	State#state{task_half=TaskInterval};
task_record({ID,{M,F,A},Interval,Limit},State,IsYrl) ->
	Task = #task_interval{id  =ID,interval=Interval,
						  exem=M, exef=F, exea=A,limit=Limit,
						  last_exec=0,is_yrl=IsYrl},
	TaskInterval = [Task|State#state.task_interval],
	State#state{task_interval=TaskInterval};
task_record({ID,{M,F,A},Sec,Min,Hour,Day,Month,Week,Limit},State,IsYrl) ->
	Task = #task_clock{id=ID,
					   sec=Sec,min=Min,hour=Hour,day=Day,
					   month=Month,week=Week,
					   exem=M,exef=F,exea=A,limit=Limit,
					   last_exec=0,is_yrl=IsYrl},
	TaskClock = [Task|State#state.task_clock],
	State#state{task_clock=TaskClock};
task_record(_Data,State,_IsYrl)->
	State.

%% 扫描任务列表，执行可执行的任务
task_run_half(State=#state{task_half=TaskHalf,half=Half,total=Total,cores=Cores,times=Times})-> 
	Half2				  	= (Half+1) rem 2,
	{TaskHalf2,Times2,_,_}	= lists:foldl(fun task_run_half/2,{[],Times,Cores,Total},TaskHalf),
	if
		0 == Half2 ->
			%% 有一秒 进入秒
			task_run(State#state{times=Times2,task_half=TaskHalf2,half=Half2});
		?true ->
			%% 只有半秒 直接退出
			State#state{times=Times2,task_half=TaskHalf2,half=Half2}
	end.
	
%% 扫描任务列表，执行可执行的任务
task_run(State=#state{total=Total0,cores=Cores,times=Times})->
	Total					  = Total0 + 1 ,
	{Interval,Times2,_,_}	  = lists:foldl(fun task_run_interval/2,{[],Times ,Cores,Total},State#state.task_interval),
%% 	if
%% 		(Total rem 60) == 0 ->
%% 			{Date,Time}  	  = util:localtime(),
%%     		Week 		      = calendar:day_of_the_week(Date),
%% 			{Clock,Times3,
%% 			 _,_,_,_,_}       = lists:foldl(fun task_run_clock/2,	{[],Times2,Cores,Total,Date,Time,Week},State#state.task_clock);
%% 		?true ->
%% 			Clock			  = State#state.task_clock,
%% 			Times3 			  = Times2
%% 	end,
	{Date,Time}  	  			= util:localtime(),
    Week 		      			= calendar:day_of_the_week(Date),
	{Clock,Times3,_,_,_,_,_}    = lists:foldl(fun task_run_clock/2,	{[],Times2,Cores,Total,Date,Time,Week},State#state.task_clock),
	State#state{total=Total,times=Times3,task_interval=Interval,task_clock=Clock}.

%% 间隔
task_run_interval(Data,{Interval,Times,Cores,Total}) when is_record(Data, task_interval)->
	if
		0 == (Total rem Data#task_interval.interval) ->
			task_run_interval(Times,Cores,Total,Data,Interval);
		?true ->
			{[Data|Interval],Times,Cores,Total}
	end;
task_run_interval(_Data,Rs) -> Rs.

%% 半秒
task_run_half(Data,{Interval,Times,Cores,Total}) when is_record(Data, task_interval)->
	task_run_interval(Times,Cores,Total,Data,Interval);
task_run_half(_Data,Rs) -> Rs.

%% 执行 
task_run_interval(Times,Cores,Total,Data,Interval) ->
	Times2	  = Times+1,
	app_link:spawn(Data#task_interval.exem,
				   Data#task_interval.exef,
				   Data#task_interval.exea, Cores, Times),
	if
		0 == Data#task_interval.limit ->
			Data2	  = Data#task_interval{last_exec=Total},
			{[Data2|Interval],Times2,Cores,Total};
		1 >= Data#task_interval.limit ->
			{Interval,        Times2,Cores,Total};
		?true ->
			Limit2	  = Data#task_interval.limit - 1,
			Data2	  = Data#task_interval{last_exec=Total,limit=Limit2},
			{[Data2|Interval],Times2,Cores,Total}
	end.

%% 定时
task_run_clock(Data,{Clock,Times,Cores,Total,Date,Time,Week}) when is_record(Data, task_clock)->	
	case check_time(Data, Date, Time, Week) of
		?true ->
			Times2	  = Times+1,
			app_link:spawn(Data#task_clock.exem, 
						   Data#task_clock.exef, 
						   Data#task_clock.exea, Cores, Times),
			if
				0 == Data#task_clock.limit ->
					Data2	  = Data#task_clock{last_exec=Total},
					{[Data2|Clock],Times2,Cores,Total,Date,Time,Week};
				1 >= Data#task_clock.limit ->
					{Clock,        Times2,Cores,Total,Date,Time,Week};
				?true ->
					Limit2	  = Data#task_clock.limit - 1,
					Data2	  = Data#task_clock{last_exec=Total,limit=Limit2},
					{[Data2|Clock],Times2,Cores,Total,Date,Time,Week}
			end;
		_ ->
			{[Data|Clock],Times,Cores,Total,Date,Time,Week}
	end;
task_run_clock(_Data,Rs) -> Rs.



  
%% 时间检查
check_time(Task, {_Y,M,D}, {H,I,S}, Week) ->
	CheckList = [{Task#task_clock.sec, S},{Task#task_clock.min, I}, {Task#task_clock.hour, H}, 
				 {Task#task_clock.day, D},{Task#task_clock.month,M},{Task#task_clock.week, Week}],
	check_time(CheckList).

check_time([])    -> ?true;
check_time([H|T]) ->
	case check_time2(H) of
		?true  -> check_time(T);
		?false -> ?false
	end.
check_time2({[],      _NowTime}) -> ?true;
check_time2({TaskTime, NowTime}) -> lists:member(NowTime, TaskTime).
