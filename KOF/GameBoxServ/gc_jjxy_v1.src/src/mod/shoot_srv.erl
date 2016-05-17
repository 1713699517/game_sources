%%% -------------------------------------------------------------------
%%% Author  : mirahs
%%% Description :
%%%
%%% Created : 2011-12-17
%%% -------------------------------------------------------------------
-module(shoot_srv).


-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% 调用导出
-export([
		 reward_money_cast/1,
		 reward_history_cast/2,
		 reward_all_cast/3
		]).
%% --------------------------------------------------------------------
%% 以下系统默认导出(勿删)
-export([start_link/2,init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
%% 以下系统默认函数(勿删)
start_link(SrvName, Cores) ->
	app_link:gen_server_start_link(SrvName, ?MODULE, [Cores], Cores).
init([Cores])     ->
	process_flag(?trap_exit, ?true),
	Reply = do_init(), 
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
do_init() ->
	%% 初始化State
	process_flag(?trap_exit, ?true),
	ets_init(),
	{?ok, ?null}.

ets_init() ->
	Data = #shoot_data{money=?CONST_ARROW_DAILY_MIN_REWARD},
	ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_KEY_SHOOT,Data}),
	?ok.


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
do_cast({reward_money,Money},State) ->
	shoot_mod:reward_money_handle(Money),
	{?noreply,State};
do_cast({reward_history,Uid,GoodsId},State) ->
	shoot_mod:reward_history_handle(Uid,GoodsId),
	{?noreply,State};
do_cast({reward_all,Uid,Uname,Money},State) ->
	shoot_mod:reward_all_handle(Uid,Uname,Money),
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
do_info(Info,State)-> %% 默认处理(勿删)
	?MSG_ERROR("Info Info:~w State:~w", [Info,State]),
	{?noreply,State}.


%% --------------------------------------------------------------------
%% Function: do_terminate/2
%% Description: 退出处理内容
%% --------------------------------------------------------------------
do_terminate(_State)-> 
	?ok.


reward_money_cast(Money) ->
	gen_server:cast(?MODULE,{reward_money,Money}).

reward_history_cast(Uid,GoodsId) ->
	gen_server:cast(?MODULE,{reward_history,Uid,GoodsId}).

reward_all_cast(Uid,Uname,Money) ->
	gen_server:cast(?MODULE,{reward_all,Uid,Uname,Money}).


