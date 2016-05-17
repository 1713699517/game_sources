%% Author: dreamxyp
%% Created: 2012-2-13
%% Description: TODO: Add description to mysql_side_srv
-module(mysql_side_srv).


-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
-include("../include/drive.mysql.hrl").
%% --------------------------------------------------------------------
%% 调用导出
-export([fetch_cast/4,heart_cast/1]).
%% --------------------------------------------------------------------
%% 以下系统默认导出(勿删)
-export([start_link/3,init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
%% 以下系统默认函数(勿删)
start_link(SrvName,Cores,MysqlSideState) -> 
	app_link:gen_server_start_link(SrvName, ?MODULE, [Cores,MysqlSideState], Cores).
init([Cores,MysqlSideState]) ->
	process_flag(?trap_exit, ?true),
	Reply = do_init(Cores,MysqlSideState),
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
%%% DO 内部处理   800219
%% --------------------------------------------------------------------



%% --------------------------------------------------------------------
%% Function: do_init/1
%% Description: 初始化状态
%% Returns: {?ok, State}          |
%%          {?ok, State, Timeout} |
%%          ?ignore               |
%%          {?stop, Reason}
%% --------------------------------------------------------------------
do_init(_Cores,MysqlSideState) ->
	%% 初始化
	case gen_tcp:connect(MysqlSideState#mysql_side.host, MysqlSideState#mysql_side.port, [binary, {packet, 0}]) of
		{?ok, Socket} ->
			case mysql_mod_auth:auth(MysqlSideState#mysql_side{socket=Socket}) of
				{?ok, MysqlSideState2} ->
					Db 			= util:to_binary(MysqlSideState#mysql_side.database),
					QueryUseDb 	= <<"use ", Db/binary>>,
					case handle_cast({fetch,?null,QueryUseDb}, MysqlSideState2) of
						{?noreply, MysqlSideState3} ->
							case MysqlSideState3#mysql_side.charset of
								?undefined ->
									{?noreply, MysqlSideState3};
								Charset ->
									EncodingBinary = util:to_binary(Charset),
									QueryEncoding  = <<"set names '", EncodingBinary/binary, "'">>,
									case handle_cast({fetch,?null,QueryEncoding}, MysqlSideState3) of
										{?noreply, MysqlSideState4} ->
											{?ok, MysqlSideState4};
										{?stop, Reason, _State} ->
											{?stop, Reason}
									end
							end;
						{?stop, Reason, _State} ->
							{?stop, Reason}
					end;
				{?error, Reason} ->
					{?stop, Reason}
			end; 
		Error ->
			Error2 	= lists:flatten(io_lib:format("connect failed : ~p", [Error])),
			{?stop, Error2}
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
do_cast({fetch,From,Query}, State) ->
	case mysql_mod:do_query(State#mysql_side.socket, State#mysql_side.bin_acc, State#mysql_side.ver, Query) of
		{?ok, Result, BinAcc2} ->
			case From of
				{FromPid,Ref} ->
					util:pid_send(FromPid, {?ok,Ref,Result}),
					% FromPid ! {?ok,Ref,Result},					
					mysql_srv:callback_result_cast(Ref); 
				_ -> ?ok
			end,
			{?noreply, State#mysql_side{bin_acc=BinAcc2}};
		{?error,Reason} ->
			?MSG_ERROR("Fetch Query:~p,Reason:~p",[Query,Reason]),
			{?stop, Reason, State}
	end;
do_cast(heart, State) ->
	Db 		= util:to_binary(State#mysql_side.database),
	Query	= <<"use ", Db/binary>>,
	handle_cast({fetch,?null,Query}, State);
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
do_info({tcp_closed,_Port},State) ->
	{?stop, ?normal, State};
do_info({tcp,_Socket,_Msg}, State) ->
	{?noreply,	State};
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
	gen_tcp:close(State#mysql_side.socket),
	?ok.


%% --------------------------------------------------------------------
%%% 外部调用Serv
%% --------------------------------------------------------------------

fetch_cast(SideSrvName,FromPid,Ref,Query)->
	gen_server:cast(SideSrvName,	{fetch,{FromPid,Ref},Query}).


%% 心跳
heart_cast(SideSrvName) ->
	gen_server:cast(SideSrvName,	heart).
	




