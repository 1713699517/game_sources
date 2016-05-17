%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-6-21
%%% -------------------------------------------------------------------
-module(gateway_acceptor_srv).


-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% 调用导出
-export([switch/2,show/1]).
%% --------------------------------------------------------------------
%% 以下系统默认导出(勿删)
-export([start_link/3,init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
%% 以下系统默认函数(勿删)
start_link(SrvName,Cores,ListenSocket) -> 
	app_link:gen_server_start_link(SrvName, ?MODULE, [Cores,ListenSocket], Cores).
init([Cores,ListenSocket])     ->
	process_flag(?trap_exit, ?true),
	Reply = do_init(Cores,ListenSocket), 
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
-record(state, {%sid, 
				socket, ref, cores, switch}).

%% --------------------------------------------------------------------
%% Function: do_init/1
%% Description: 初始化状态
%% Returns: {?ok, State}          |
%%          {?ok, State, Timeout} |
%%          ?ignore               |
%%          {?stop, Reason}
%% --------------------------------------------------------------------
do_init(Cores,ListenSocket) ->
	%% 初始化State
	State	= #state{socket = ListenSocket,
					 cores= Cores,switch = ?true},
	case accept(State) of 
		{?noreply, State2} ->
			{?ok, State2};
		{?stop, Reason, _State2} ->
			{?stop, Reason}
	end.








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
do_cast(show, State) ->
	?MSG_ECHO("~nState:~p~n ",[State]),
	{?noreply, State};
do_cast({switch, Switch}, State) ->
	{?noreply, State#state{switch = Switch}};
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
do_info({inet_async, ListenSocket, Ref, {?ok, Socket}},
            State = #state{socket = ListenSocket, ref = Ref,cores= Cores,switch = Switch}) ->
	% SchedulerId   = util:core_idx(),
	% ?MSG_ECHO("ListenSocket:~p SchedulerId:~p",[ListenSocket,SchedulerId]),
	case Switch of
		?true -> 
			gateway_worker_sup:start_child_gateway_worker_srv(Cores,Socket, ListenSocket),
			accept(State);
		?false ->
			gen_tcp:close(Socket),
			accept(State)
	end;
do_info({inet_async, ListenSocket, Ref, {?error, closed}},
            State = #state{socket = ListenSocket, ref = Ref}) ->
    {?stop, ?normal, State};
do_info({inet_async, ListenSocket, Ref, {?error, _Error}},
            State = #state{socket = ListenSocket, ref = Ref}) ->
	{?stop, ?normal, State};

do_info({'EXIT', Port, ?normal}, State) when is_port(Port)->
	{?noreply, State};
do_info({'EXIT', Pid, Reason}, State) ->
	?MSG_ERROR("EXIT	Pid:~p   Reason:~p",[Pid,Reason]),
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
do_terminate(_State)-> 
	?ok.


%% --------------------------------------------------------------------
%%% 外部调用Serv
%% --------------------------------------------------------------------
switch(Pid, Switch) ->
	gen_server:cast(Pid, {switch, Switch}).

show(Pid) ->
	gen_server:cast(Pid, show).


%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%% 异步接受Socket连接
accept(State = #state{socket = ListenSocket}) ->
    case prim_inet:async_accept(ListenSocket, -1) of
        {?ok, Ref} ->
			{?noreply, State#state{ref = Ref}}; 
        Error     ->
			?MSG_ERROR("prim_inet:async_accept Error:~p~n",[Error]),
			{?stop, {cannot_accept, Error}, State}
    end. 