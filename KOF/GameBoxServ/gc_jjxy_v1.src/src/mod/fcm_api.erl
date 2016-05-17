%% @author dreamxyp
%% @doc @todo Add description to fcm_api.


-module(fcm_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


-export([fcm/2,record_fcm/2]).



%% 防沉迷
fcm(Player=#player{is=Is,io=Io},Now)->
	case role_api_dict:fcm_get() of
		Fcm when is_record(Fcm,fcm)->
			Fcm2 = case Fcm#fcm.fcm of
					   ?CONST_FALSE ->
						   Fcm;
					   ?CONST_TRUE  ->
						   if
							   Now - Fcm#fcm.fcm_nt > 0 ->
								   {FcmState,FcmNt,FcmBinMsg} = role_mod:fcm_side(Fcm#fcm.fcm_init,Io#io.login_time,Now), 
								   app_msg:send(Player#player.socket,FcmBinMsg),
								   Fcm#fcm{fcm_state=FcmState,fcm_nt=FcmNt};
							   ?true ->
								   Fcm
						   end
				   end,
			% 定时 存player数据
			Io2 = if
					   abs(Now - Io#io.db_save) > ?CONST_DB_SAVE andalso Is#is.is_db =:= ?CONST_TRUE ->
						   ?MSG_ECHO("mongo_data:player_save Uid:~p ",[Player#player.uid]),
						   % mongo_data:player_save(Player#player.sid, Player#player.uid, Player),
						   role_mod:db_save(Player, ?CONST_FALSE),
						   Io#io{db_save = Now + ?CONST_DB_SAVE};
					   ?true ->
						   Io
				   end,
			% 定时与客户端时间同步
			if
				abs(Now - Io2#fcm.tsp) > ?CONST_TSP_INTERVAL ->
					Fcm4 = Io2#fcm{tsp = Now + ?CONST_TSP_INTERVAL},
					BinSystemTime 	= system_api:msg_time(Now),
					app_msg:send(Player#player.socket, BinSystemTime),
					role_api_dict:fcm_set(Fcm4),
					Player;
				?true ->
					role_api_dict:fcm_set(Fcm),
					Player
			end;
		_->
			Player
	end;
fcm(Player,_Now)->
	Player.


record_fcm(FcmInit,Socket) ->
	Now		= util:seconds(),
	if 
		FcmInit > 0 -> 
			{FcmState,FcmNt,FcmBinMsg} = fcm_side(FcmInit, Now, Now), 
			app_msg:send(Socket, FcmBinMsg),
			Fcm 	 = ?CONST_TRUE;
		?true ->
			FcmState = ?CONST_FCM_NORMAL,
			FcmNt	 = 0,
			Fcm 	 = ?CONST_FALSE
	end,
	{Address2, Port2} = case inet:peername(Socket) of
							{?ok, {Address, Port}} -> {Address, Port};
							{?error, _} 		   -> {{0,0,0,0}, 0}
						end,
	#fcm{
		 ip					= {Address2, Port2},
		 fcm				= Fcm,	 					%% 防沉迷-是否加入防沉迷(?CONST_FALSE:不加入，?CONST_TRUE:加入防沉迷)
		 fcm_state			= FcmState, 				%% 防沉迷-状态
		 fcm_init			= FcmInit,					%% 防沉迷-初始时长
		 fcm_nt				= FcmNt,					%% 防沉迷-下次触发时间
		% login				= Now,	 					%% 登录时间
		% save 				= Now + ?CONST_DB_SAVE,	 	%% 数据库，下次存蓄时间
		 tsp				= Now + ?CONST_TSP_INTERVAL	%% 时间同步协议(Time Synchronization Protocol)
		}.


%% 防沉迷
fcm_side(FcmTime,LoginTime,LoginTime)-> % 登录时
	if
		FcmTime < 3600 -> % 小于一小时
			FcmState = ?CONST_FCM_NORMAL,
			FcmNt	 = LoginTime + 3600 - FcmTime;
		FcmTime < 7200 -> % 小于二小时
			FcmState = ?CONST_FCM_NORMAL,
			FcmNt	 = LoginTime + 7200 - FcmTime;
		FcmTime < 10800 -> % 小于三小时
			FcmState = ?CONST_FCM_NORMAL,
			FcmNt	 = LoginTime + 10800 - FcmTime;
		FcmTime < 12600 -> % 在线小于3.5小时
			FcmState = ?CONST_FCM_HALF,
			FcmNt	 = LoginTime + 12600 - FcmTime;
		FcmTime < 14400 -> % 在线小于4小时
			FcmState = ?CONST_FCM_HALF,
			FcmNt	 = LoginTime + 14400 - FcmTime;
		FcmTime < 16200 -> % 在线小于 4.5小时
			FcmState = ?CONST_FCM_HALF,
			FcmNt	 = LoginTime + 16200 - FcmTime;
		FcmTime < 18000 -> % 在线小于5小时
			FcmState = ?CONST_FCM_HALF,
			FcmNt	 = LoginTime + 18000 - FcmTime;
		?true ->		   % 大于5小时
			FcmState = ?CONST_FCM_NOTHING,
			FcmNt	 = LoginTime + ?CONST_FCM_TIP_INTERVAL
	end,
	% ?MSG_ECHO("Login FcmTime:~p, FcmNt:~p FcmState:~p ",[FcmTime,FcmNt, FcmState]),
	if
		FcmState =:= ?CONST_FCM_NORMAL ->
			FcmBinMsg = role_api:msg_fcm_prompt(?false,FcmState,FcmTime);
		?true ->
			FcmBinMsg = role_api:msg_fcm_prompt(?true, FcmState,FcmTime) 
	end,
	{FcmState,FcmNt,FcmBinMsg};		
fcm_side(FcmInit,LoginTime,Now) ->
	FcmTime = FcmInit + Now - LoginTime,
	if
		FcmTime < 3660 -> % 1 小时
			FcmState = ?CONST_FCM_NORMAL,
			FcmNt	 = LoginTime + 7200  - FcmInit;
		FcmTime < 7260 -> % 2小时
			FcmState = ?CONST_FCM_NORMAL,
			FcmNt	 = LoginTime + 10800 - FcmInit;
		FcmTime < 10860 -> % 3小时
			FcmState = ?CONST_FCM_HALF,
			FcmNt	 = LoginTime + 12600 - FcmInit;
		FcmTime < 12660 -> % 3.5小时
			FcmState = ?CONST_FCM_HALF,
			FcmNt	 = LoginTime + 14400 - FcmInit;
		FcmTime < 14460 -> % 4小时
			FcmState = ?CONST_FCM_HALF,
			FcmNt	 = LoginTime + 16200 - FcmInit;
		FcmTime < 16260 -> % 4.5小时
			FcmState = ?CONST_FCM_HALF,
			FcmNt	 = LoginTime + 18000 - FcmInit;
%% 		FcmTime < 18060 -> % 5小时
		?true -> % 大于5小时
			FcmState = ?CONST_FCM_NOTHING,
			FcmNt	 = Now+?CONST_FCM_TIP_INTERVAL
	end,
	% ?MSG_ECHO("Login2 FcmTime:~p, FcmNt:~p FcmState:~p ",[FcmTime,FcmNt, FcmState]),
	FcmBinMsg = role_api:msg_fcm_prompt(?true,FcmState,FcmTime),
	{FcmState,FcmNt,FcmBinMsg}.
