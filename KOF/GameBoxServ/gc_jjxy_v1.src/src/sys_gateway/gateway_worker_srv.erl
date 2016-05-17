%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-6-21
%%% -------------------------------------------------------------------
-module(gateway_worker_srv).




-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% 调用导出
%% -export([request_call/1,msg_cast/1]).
%% --------------------------------------------------------------------
%% 以下系统默认导出(勿删)
-export([start_link/4,init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
%% 以下系统默认函数(勿删)
start_link(_SrvName,Cores,Socket,ListenSocket) ->
	app_link:gen_server_start_link_noname(?MODULE, [Cores,Socket,ListenSocket],Cores).
init([Cores,Socket,ListenSocket])     ->
	process_flag(?trap_exit, ?true),
	Reply = do_init(Cores,Socket, ListenSocket),
	?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
	Reply.
handle_call(Request, From, State) -> 
	?TRY_DO(do_call(Request,From,State) ).
handle_cast(Msg,  State) -> 
	?TRY_DO(do_cast(Msg,State) ).
handle_info(Info, State) -> 
	?TRY_DO(do_info(Info,State)).
terminate(Reason,{_Ref,_Bin,Player})  -> 
	?TRY_DO(do_terminate(Player)),
	case Reason of
		?normal -> 
			?skip;
		_ when is_record(Player#player.is, is) andalso is_record(Player#player.io, io) ->
			Io	= Player#player.io,
			?MSG_ERROR("PlayerUid:~p OnLine:~p Lv:~p  Ip:~p ~nLogs[P,D]:~p~nReason:~p",
					   [Player#player.uid, (util:seconds() - Io#io.login_time),
						Player#player.lv,  Io#io.login_ip,	 Io#io.io_logs,		Reason]);
		_ ->
			?MSG_ERROR("PlayerUid:~p Reason:~p",[Player#player.uid ,Reason])
	end,
	if
		is_port(Player#player.socket) ->
			?TRY_FAST(gen_tcp:close(Player#player.socket),?ok);
		?true -> 
			?ok 
	end,
	util:sleep(?CONST_TIME_SLEEP), %% 暂停一下 确保消息等都执行完
	?ok.
code_change(_OldVsn, State, _Extra) -> 
	{?ok, State}.
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
do_init(_Cores,Socket, ListenSocket) ->
	%% 初始化State
	gen_tcp:controlling_process(Socket, self() ),
	% SchedulerId   = util:core_idx(),
	case set_socket(ListenSocket, Socket) of
		?ok ->
%% 			fprof:trace(start),
			Mpid		= self(),
			LoginTime	= util:seconds(),
			LoginIp		= util:ip(Socket),
			Player  	= #player{socket=Socket,mpid=Mpid,
								  is=#is{is_db=?CONST_FALSE},
								  io=#io{login_time=LoginTime,login_ip=LoginIp} },
			?MSG_ECHO("WAIT SECURITY PREFIX...... ",[]),
			case async_recv(Socket, 0, ?CONST_OUTTIME_GATEWAY) of 
				{?ok, 	 Ref} ->
					% ?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
					{?ok,   {Ref, <<>>, Player} };
				Error ->
					?MSG_ERROR("Error:~p",[Error]),
					{?stop, Error}
			end;
		?error ->
			Error = {?error,set_socket},
			?MSG_ERROR("Error:~p",[Error]),
			{?stop, Error}
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
do_info({?exec, Mod, Fun, Arg},{Ref,Bin,Player})->
	Player2 = Mod:Fun(Player, Arg),
	{?noreply, {Ref,Bin,Player2} };
do_info({?inet_reply,_Socket,_Msg}, State) -> %% 向Socket发包 返回
	{?noreply, State}; 
do_info(?doloop,{Ref,Bin,Player})->  %% 处理注册定时 doloop
%% 	Player2 = role_api:doloop(Player),
	{?noreply, {Ref,Bin,Player}  };
do_info({send, BinMsg},{Ref,Bin,Player})->
	app_msg:send_fast(Player#player.socket,BinMsg),
	{?noreply,{Ref,Bin,Player}};
do_info({inet_async,_,Ref,{?ok,SocketBin}},{Ref,Bin,Player})->
	case SocketBin of
%% 		<<"tgw_l7_forward",TGW/binary>>-> % QQ
%% 			?MSG_ECHO("tgw_l7_forward: ~p",[TGW]),
%% 			State2 = work(Bin,Player),
%% 			{?noreply, State2 };
		?SECURITY_PREFIX ->
			gen_tcp:send(Player#player.socket, ?SECURITY),
			{?stop,   ?normal,	{Ref,Bin,Player}};
		_ ->
%% 			?MSG_ECHO("S:~p",[Player#player.socket]),
			work(<<Bin/binary,SocketBin/binary>>,Ref,Player)
%% 			case work(<<Bin/binary,SocketBin/binary>>,Player) of  
%% 				{?error,Error} ->
%% 					?MSG_ERROR("PlayerUid:~p Reason:~p ", [Player#player.uid,Error]),
%% 					{?stop,	  {?error,Error}, {Ref,Bin,Player}};
%% 				State2 ->
%% 					{?noreply, State2}
%% 			end
	end;
do_info({inet_async,R,_,{?error,closed}},{Ref,Bin,Player})->  
	?MSG_ECHO("PlayerUid:~p Reason:~p Ref:~p Bin:~p ", [Player#player.uid,{?error,closed},Ref,{Bin,R}]),
	hold(Ref,Bin,Player);
do_info({inet_async,_,_,{?error,etimedout}},{Ref,Bin,Player})->
	?MSG_ECHO("PlayerUid:~p Reason:~p Ref:~p Bin:~p ", [Player#player.uid,{?error,etimedout},Ref,Bin]),
	hold(Ref,Bin,Player);
do_info({inet_async,_,_,Reason},{Ref,Bin,Player})->
 	?MSG_ERROR("PlayerUid:~p Reason:~p Ref:~p Bin:~p ", [Player#player.uid,Reason,Ref,Bin]),
%% 	{?noreply,{Ref,Bin,Player}};
	hold(Ref,Bin,Player);
do_info({?change_socket, RefChange, From, Os, NewSocket}, {Ref,_Bin,Player}) ->
	if
		is_port(Player#player.socket) ->
			try 
				gen_tcp:close(Player#player.socket)
			catch  _:_ -> ?ok end;
		?true ->
			?ok
	end,
	erlang:erase(?change_socket),
	MPid = self(),
	erlang:port_connect(NewSocket, MPid),
	gen_tcp:controlling_process(NewSocket, MPid),
	util:pid_send(From, {?change_socket, RefChange}),
	Io		= (Player#player.io)#io{os = Os},
	Player2 = Player#player{socket=NewSocket, io = Io},
	Player3 = role_api:change_socket_update(Player2),
	?MSG_ERROR("duan xian chong lian wang cheng ~w~n",[Player#player.uid]),
	work(<<>>,Ref,Player3);
do_info(?alive,{Ref,Bin,Player}) ->
	case erlang:get(?change_socket) of
		?undefined ->
			{?noreply, {Ref,Bin,Player}};
		Count ->
			if
				Count / 2 >= ?CONST_USER_OFFLINE_ALIVE ->
					{?stop, ?normal, {Ref,Bin,Player}};
				?true ->
					erlang:put(?change_socket, Count + 1),
					erlang:send_after(500, self(), ?alive),
					{?noreply, {Ref,Bin,Player}}
			end
	end;
do_info(?exit,{Ref,Bin,Player})->
	{?stop, ?normal, {Ref,Bin,Player}};
do_info({'EXIT',SubPid,Reason},{Ref,Bin,Player})->
	?MSG_ERROR("'EXIT' PlayerUid:~p Reason:~w Ref:~p ~nBin:~p ", [Player#player.uid,{'EXIT',SubPid,Reason},Ref,Bin]),
	{?stop, Reason,  {Ref,Bin,Player}};
do_info({login_other,FromRef,FromPid},{Ref,Bin,Player}) ->
	Is = Player#player.is,
	if  
		Player#player.uid > 0 andalso is_record(Is, is) 
		  andalso Is#is.is_db == ?CONST_TRUE ->
			role_db:role_save(Player, ?CONST_FALSE);
	    ?true ->  ?ok 
	end,
	util:pid_send(FromPid,{?ok,FromRef}),
	if
		is_record(Is, is) ->
			Is2 = Is#is{is_db=?CONST_FALSE};
		?true ->
			Is2 =   #is{is_db=?CONST_FALSE}
	end,
	{?stop, ?normal,  {Ref,Bin,Player#player{is=Is2}}};
do_info(Info,{Ref,Bin,Player})-> %% 默认处理(勿删)
	case Info of
		{?ok,Player2} when is_record(Player2,player) ->
			?MSG_ERROR("Info PlayerUid:~p Info:{?ok,#player{uid=~w ,..}} ", [Player#player.uid,Player2#player.uid]);
		_ ->
			?MSG_ERROR("Info PlayerUid:~p Info:~w ", [Player#player.uid,Info])
	end,
	{?noreply,{Ref,Bin,Player}}.


%% --------------------------------------------------------------------
%% Function: do_terminate/2
%% Description: 退出处理内容
%% --------------------------------------------------------------------
do_terminate(Player)-> 
	?MSG_ECHO("------logout Uid:~p start ???? ",[Player#player.uid]),
	% 角色退出  新建一个进程去把数据保存 
	if  
		Player#player.uid > 0 -> 
%% 			erlang:spawn(fun() -> role_api:logout(Player) end);
			% ?MSG_ECHO("exit:~p pid:~p",[Player#player.uid,self()]),
%% 			fprof:trace(stop),
%% 			fprof:profile(),
%% 			fprof:analyse({dest,util:to_list(Player#player.uid)++"player.txt"}),
			role_api:logout(Player),
			util:sleep(2000);
	    ?true ->  ?ok 
	end.


%% --------------------------------------------------------------------
%%% 外部调用Serv
%% --------------------------------------------------------------------



%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%% 异步接受Socket连接
set_socket(ListenSocket, Socket) ->
	{?ok, Mod} = inet_db:lookup_socket(ListenSocket),
	?true 	   = inet_db:register_socket(Socket, Mod),
	case prim_inet:getopts(ListenSocket, [active, nodelay, keepalive, delay_send, priority, tos]) of
		{?ok, Opts} ->
			case prim_inet:setopts(Socket, Opts) of
				?ok		-> ?ok;
				?error 	-> gen_tcp:close(Socket), ?error
			end;
		?error -> gen_tcp:close(Socket), ?error
	end.
work(<<Length:16/big-integer-unsigned,BinData:Length/binary,Bin/binary>>,Ref,Player)->
%% 	?MSG_ECHO("---S:~p",[Player#player.socket]),
	case check(BinData) of
		{?ok, ProtocolCode, Data} ->
			if
				(  
				 	is_record(Player#player.is, is) == ?false orelse
				 	( is_record(Player#player.is, is) andalso (Player#player.is)#is.is_db == ?CONST_FALSE  )
				 ) andalso ProtocolCode =/= ?P_ROLE_LOGIN 
				   andalso ProtocolCode =/= ?P_ROLE_RAND_NAME
				   andalso ProtocolCode =/= ?P_ROLE_CREATE ->
					?MSG_ERROR("NOT P_ROLE_LOGIN RECEIVE:~p Data:~p~n", [ProtocolCode, Data]),
					BinMsg		 = system_api:msg_error(?ERROR_CHECK_SUM),
					app_msg:send(Player#player.socket,BinMsg),
					% gen_tcp:close(Player#player.socket),
					{?stop,	{?error,not_login}, {Ref,Bin,Player } };
				?true ->
					Player1  = if 
								   ProtocolCode =:= 501 orelse ProtocolCode =:= 5040 orelse ProtocolCode =:= 5085->
									   %?MSG_ECHO("~nRECEIVE:~p Data:~p~n", [ProtocolCode, Data]),
									   Player;
								   ?true -> 
									   ?MSG_ECHO("~nRECEIVE:~p Data:~p~n", [ProtocolCode, Data]),
									   case  Player#player.io of
										   RecordIo when is_record(RecordIo,io)->
											   Logs		= RecordIo#io.io_logs,
											   Logs2	= [{ProtocolCode,Data}|lists:sublist(Logs,9)],
											   Io2		= RecordIo#io{io_logs=Logs2},
											   Player#player{io=Io2};
										   _->
											   Io		= #io{},
											   Logs 	= [{ProtocolCode,Data}],
											   Io2		= Io#io{io_logs=Logs},
											   Player#player{io=Io2} 
									   end
							   end,
					%% 追踪 
					%% logs_api_trace:trace(ProtocolCode,Player1#player.info,Player1#player.uid, Data),
					%% 进入 gateway
					case global_gateway:gateway(ProtocolCode, Player1, Data) of   
						{?ok, Player2} ->
							work(Bin, Ref, Player2);
						{?ok,?change_socket,Player2} ->
							Ref2 = 0,
							{?noreply,     {Ref2,Bin,Player2} };
						Error ->
							% ?MSG_ERROR("Error:~p~n",[Error]), 在 terminate 会报出来
							{?stop,	Error, {Ref ,Bin,Player } }
					end
			end;
		Error ->
			?MSG_ERROR("Error:~p, Bin:~p",[Error,<<Length,BinData/binary,Bin/binary>>]),
			work(<<>>,Ref,Player)  
	end;

work(Bin,Ref,Player)->
	case async_recv(Player#player.socket, 0, ?CONST_OUTTIME_GATEWAY) of 
		{?ok,	Ref2} ->
			{?noreply,     {Ref2,Bin, Player}  };
		Error ->
			{?stop,	Error, {Ref, Bin, Player}  } 
	end.

async_recv(Socket, Length, _Timeout) when is_port(Socket) ->
	case prim_inet:async_recv(Socket, Length, -1) of
		{?ok, Ref} ->
			{?ok, 	 Ref};
		Error ->
			?MSG_ERROR("Winval Socket : ~p~n", [Socket]),
			{?error, {async_recv,Error}}  
	end;
async_recv(Socket, _Length, _Timeout)->
	% ?MSG_ERROR("Winval Socket : ~p~n", [Socket]),
	{?error, winval}.

check(<<CheckSum:9, ProtocolCode:16/big-integer-unsigned, Hex:7, Data/bits>>) ->
	case ((Hex + ProtocolCode + byte_size(Data) + 87) rem 512) of
		CheckSum -> {?ok, 	ProtocolCode, Data};
		_ 		 -> {?error,?ERROR_CHECK_SUM}
	end.

hold(Ref,Bin,Player)->
	if
		Player#player.uid > 0 
		  andalso is_record(Player#player.is, is) 
		  andalso (Player#player.is)#is.is_db == ?CONST_TRUE ->
			role_db:role_save(Player, ?CONST_FALSE),
			?IF(erlang:is_port(Player#player.socket), erlang:unlink(Player#player.socket),?skip),
			erlang:put(?change_socket, 1),
			erlang:send_after(500, self(), ?alive),
			Player2 = team_api:exit_off_line(Player),
			{?noreply, {Ref,Bin,Player2#player{socket = ?null}}};
		?true ->
			{?stop, ?normal, {Ref,Bin,Player}}
	end.
	
