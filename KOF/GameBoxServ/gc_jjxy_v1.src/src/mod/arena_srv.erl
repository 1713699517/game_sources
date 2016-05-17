%%% -------------------------------------------------------------------
%%% Author  : liutao
%%% Description :
%%%
%%% Created : 2012-7-23
%%% -------------------------------------------------------------------
-module(arena_srv).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% 调用导出
-export([hearsay_call/0,hearsay_event_call/0,arena_war_cast/3,arena_lv_cast/2,arena_powerful_cast/2,hearsay_cast/1]).
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
-record(state, {hearsay=[],date=0}).


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
	State = #state{hearsay=[]},
	%% 注册定时 doloop
	%% crond_api:reg(self(), MilliSecond), 
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
do_call(hearsay,_From,State=#state{hearsay = Hearsay})->
	Reply = Hearsay,
	{reply,Reply,State};
do_call(hearsay_event,_From,State)->
	Reply = ?IF(get(event)=:=?undefined,[],get(event)),
	{reply,Reply,State};

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
do_cast({hearsay,Hearsay},State) ->
	{?noreply, State#state{hearsay=[Hearsay]}};

do_cast({arena_war,Player,Ranking,Res},State)->
	arena_api:arena_war_handle(Player,Ranking,Res), 
	{?noreply,State};

do_cast({arena_lv,Uid,Lv},State)->
	arena_api:arena_update_lv_handle(Uid,Lv), 
	{?noreply,State};

do_cast({arena_powerful,Uid,Powerful},State)->
	arena_api:arena_update_powerful_handle(Uid,Powerful), 
	{?noreply,State};

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
do_info({?inet_reply,_Socket,_Msg}, State) -> %% 向Socket发包 返回
	{?noreply, State};
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

hearsay_call() ->
	gen_server:call(?MODULE, hearsay).

hearsay_event_call()->
	gen_server:call(?MODULE, hearsay_event).

hearsay_cast(Hearsay)->
	gen_server:cast(?MODULE, {hearsay,Hearsay}).

arena_war_cast(Player,Ranking,Res) ->
	gen_server:cast(?MODULE, {arena_war, Player,Ranking,Res}).

arena_lv_cast(Uid,Lv)->
	gen_server:cast(?MODULE, {arena_lv,Uid,Lv}).

arena_powerful_cast(Uid,Powerful)->
	gen_server:cast(?MODULE, {arena_powerful,Uid,Powerful}).
