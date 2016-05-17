%%% -------------------------------------------------------------------
%%% Author  : tanwer
%%% Description :
%%%
%%% Created : 2013-07-16
%%% -------------------------------------------------------------------
-module(active_srv).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% 调用导出
-export([change_active_cast/0,
		 schedule_active_cast/0,
		 set_active_cast/1,
		 temp_active_cast/1,
		 close_active_cast/1,
		 
		 gm_change_time/0
		]).
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
-record(state, {
				tref		= 0,
				schedule	= [],
				ok_schedule	= [],
				date		= 0
				}).


%% --------------------------------------------------------------------
%% Function: do_init/1
%% Description: 初始化状态
%% Returns: {?ok, State}          |
%%          {?ok, State, Timeout} |
%%          ?ignore               |
%%          {?stop, Reason}
%% --------------------------------------------------------------------
do_init(_Args) ->
	%% 初始化State
	{TRef,Schedule,OkSchedule}=active_mod:ref_active_state(),
	State = #state{date=util:date(),
				   tref=TRef,
				   schedule=Schedule,
				   ok_schedule=OkSchedule},
	%% 注册定时 doloop
	crond_api:reg(self(), timer:seconds(?CONST_ACTIVITY_DOLOOP_TIME)),
	{?ok, State}.








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

do_cast({change_active_cast,_},#state{ok_schedule=OkSchedule}=State) ->
	active_mod:change_active_handle(OkSchedule),
	{?noreply,State#state{ok_schedule=[]}};

do_cast({schedule_active_cast,_},#state{schedule=Schedule}=State) ->
	State2=?IF(Schedule=:=[], #state{},
			   begin {TRef2,Schedule2,OkSchedule2}=active_mod:schedule_active_handle(Schedule),
					 State#state{tref=TRef2,ok_schedule=OkSchedule2,schedule=Schedule2} 
			   end),
	{?noreply,State2};


do_cast({set_active_cast,ActData},_State) ->
	active_mod:temp_add_act(ActData),
	active_mod:set_data2sql(ActData),
	{TRef,Schedule,OkSchedule}=active_mod:ref_active_state(),
	State2 = #state{tref		= TRef,
					schedule	= Schedule,
					ok_schedule	= OkSchedule,
					date		= util:date()},
	{?noreply,State2};


do_cast({temp_active_cast,ActData},_State) ->
	active_mod:temp_add_act(ActData),
	{TRef,Schedule,OkSchedule}=active_mod:ref_active_state(),
	State2 = #state{tref		= TRef,
					schedule	= Schedule,
					ok_schedule	= OkSchedule,
					date		= util:date()},
	{?noreply,State2};

do_cast({close_active_cast,ActyID}, State) ->
	#state{schedule=Schedule, ok_schedule=OkSchedule} =State,
	case lists:keytake(ActyID, 4, OkSchedule) of
		{value, {_H,_I,_S,ActyID, 0,_Arg}, []} ->
			State2=?IF(Schedule=:=[], #state{},
					   begin {TRef2,Schedule2,OkSchedule2}=active_mod:schedule_active_handle(Schedule),
							 State#state{tref=TRef2,ok_schedule=OkSchedule2,schedule=Schedule2} 
					   end);
		{value, {_H,_I,_S,ActyID, 0,_Arg}, OkSchedule2} ->
			State2 = State#state{ok_schedule=OkSchedule2};
		_ ->
			State2 = 
				case find_active(ActyID, Schedule) of
					?false ->
						State;
					Acty ->
						State#state{schedule=Schedule--[Acty]} 
				end
	end,
	{?noreply,State2};

%%　修改服务器时间
do_cast({gm_change_time,?null},_State) ->
	{TRef,Schedule,OkSchedule}=active_mod:ref_active_state(),
	State2 = #state{tref		= TRef,
					schedule	= Schedule,
					ok_schedule	= OkSchedule,
					date		= util:date()},
	{?noreply,State2};


do_cast(Msg,State)->      %% 默认处理(勿删)
	?MSG_ERROR("Cast Msg:~w State:~w", [Msg,State]),
	{?noreply,State}.
 
%% --------------------------local_fun_do
find_active(_ActyID, []) -> ?false;
find_active(ActyID, Schedule) ->
	{_TRef2,Schedule2,OkSchedule}=active_mod:schedule_active_handle(Schedule),
	case lists:keytake(ActyID, 4, OkSchedule) of
		{value, {H,I,S,ActyID, 0, Arg}, _} ->
			{H,I,S,ActyID, 0,Arg};
		{value, _, _} ->
			?false;
		_ ->
			find_active(ActyID, Schedule2)
	end.
	

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
do_info(?doloop,State)->  %% 处理注册定时 doloop
	#state{tref=TRef,
		   schedule=Schedule,
		   ok_schedule=OkSchedule,date=Date}=State,
	?IF(TRef=:=0,?ok,timer:cancel(TRef)),
	case OkSchedule of
		[] ->
			{TRef2,Schedule2,OkSchedule2}=active_mod:schedule_active_handle(Schedule);
		OkSchedule ->
			{TRef2,Schedule2,OkSchedule2}=active_mod:schedule_active_handle(Schedule++OkSchedule)
	end,
	State2=State#state{tref=TRef2,ok_schedule=OkSchedule2,schedule=Schedule2},
	{?ok, NewState}=?IF(Date=:=util:date(),{?ok,State2},do_init(?null)),
%%	?MSG_ECHO("~nNewState==State2~w~nNewState=======~w~nState2~w~n",[NewState==State2,NewState,State2]),
	{?noreply,NewState};

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
%% 执行活动状态转换
change_active_cast() ->
	gen_server:cast(?MODULE, {change_active_cast,?null}).

%%　刷新活动排程
schedule_active_cast() ->
	gen_server:cast(?MODULE, {schedule_active_cast,?null}).

%%　新增|修改活动,修改活动状态
set_active_cast({ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}) ->
	gen_server:cast(?MODULE, {set_active_cast,{ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}}).

%%　临时加开活动,修改活动状态
temp_active_cast({ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}) ->
	gen_server:cast(?MODULE, {temp_active_cast,{ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}}).

%% 主动关闭活动
close_active_cast(ActyID) ->
	gen_server:cast(?MODULE, {close_active_cast,ActyID}).

%% gm修改时间
gm_change_time() ->
	gen_server:cast(?MODULE, {gm_change_time,?null}).

  




