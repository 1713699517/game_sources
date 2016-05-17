%% Author: youxi
%% Created: 2012-9-24
%% Description: TODO: Add description to task_api
-module(task_daily_api).

%%
%% Include files
%%
-include("../include/comm.hrl").

%%
%% Exported Functions
%%

-export([
		 encode_daily/1,
		 decode_daily/1,
		 init/1,
		 interval/0,
		 refresh_cb/2,
		 task_daily_login/1,
		 ask/1,
		 drop/1,
		 key/1,
		 reward/1,	
		 vip_refresh/1,
		 check_cb/2,
		 check_cast/3,
		 check_cast/4,
		 refresh_task/1,
		 check/3,
		 vip_lvup_cb/1,
		 set_task_daily/1,
		 set_task_cb/2
		 ]).

encode_daily(Task_daily) ->  
	Task_daily.

decode_daily(Task_daily) ->
	case is_record(Task_daily,task_daily) of
		?true->
			Task_daily;
		_->
			#task_daily{}
	end.

%% 初始化任务
init(Player) ->
	Task_daily = init_task(Player),
    {Player,Task_daily}.

%% 任务
init_task(#player{lv = Lv,vip = Vip}) ->
	DTaskId = refresh_task(Lv),
	VipCount = vip_api:check_fun(Vip#vip.lv, #d_vip.daily_tim),
	Now = util:date(),
	#task_daily{
				dTaskId = DTaskId,
				left = ?CONST_TASK_DAILY_ALL,
			    state = ?CONST_TASK_DAILY_UNFINISH,
				refresh = VipCount,
				timec = Now
			   }.
%% 0点在线刷新
interval() ->
	Online = ets:tab2list(?ETS_ONLINE),
	[util:pid_send(Uid, ?MODULE, refresh_cb, ?null)||#player{uid = Uid}<-Online].

%% 0点在线刷新回调
refresh_cb(Player,_) ->
	Task_daily = init_task(Player),
	role_api_dict:task_daily_set(Task_daily),
	Player.	
	
%% 刷新该等级任务
refresh_task(Lv) ->
    KeyList = data_task_daily_lv:get_ids(),
	[Key] = random_task(Lv,KeyList,[]),
	#d_task_daily_lv{list = DTaskList} = data_task_daily_lv:get(Key),
	lists:nth(util:uniform(length(DTaskList)),DTaskList).	

%% 随机一个任务列表
random_task(_Lv,[],Acc) ->
	Acc;
random_task(Lv,[Key|KeyList],Acc) ->
	case Lv =< Key of
	   ?true ->	
		    [Key|Acc];
	   _ ->
		   random_task(Lv,KeyList,Acc)
	end.

task_daily_login(Player)->
   Taskdaily = role_api_dict:task_daily_get(),
   #task_daily{timec = Timec} = Taskdaily,
   Now = util:date(),
   case Timec of
		Now ->
			?skip;
        _  ->
			Taskdaily2 = init_task(Player),
			role_api_dict:task_daily_set(Taskdaily2)
   end.

%% 请求日常任务 
ask(#player{uid = Uid} = Player) ->
	   task_daily_login(Player),
       Taskdaily = role_api_dict:task_daily_get(),
       #task_daily{dTaskId = DTaskId,left = Left,value = Value,state = State,refresh = Refresh,refreshc = Turn} = Taskdaily,	
       stat_api:logs_task(Uid,DTaskId * 10,?CONST_TASK_TYPE_EVERYDAY,util:seconds(),?CONST_FALSE),
       case State == ?CONST_TASK_DAILY_ALLFINISH of
            ?true ->
    			case Refresh == 0 of
					?true ->
						Bin = msg_data(0,0,0,3,0),
						{?ok,Bin};
					_->
						Bin = msg_data(0,Left,Value,State,Refresh),
						{?ok,Bin}
				end;
			_ ->
				Now = util:date(),
				Taskdaily2 = Taskdaily#task_daily{timec = Now},
				role_api_dict:task_daily_set(Taskdaily2),
				?MSG_ECHO("============================~w~n",[{DTaskId,Left,Value,State,Refresh}]),
				Bin = msg_data(DTaskId,Left,Value,State,Refresh),
                Bin2 = msg_turn(Turn + 1),
            	ask2(DTaskId,Bin,Bin2)
	 end.
ask2(DTaskId,Bin,Bin2)->
	case data_task:get(DTaskId) of
		#d_task{target_t = T,target_v = V} ->
			case T of
				?CONST_TASK_TARGET_COPY ->
					case copy_api:check_over(V) of
						?true ->
							{?ok,<<Bin/binary,Bin2/binary>>};
						_ ->
							{?error,?ERROR_COPY_NOT_COPY}
					end;
				_ ->
					{?ok,<<Bin/binary,Bin2/binary>>}
			end;
		_ ->
			{?ok,<<Bin/binary,Bin2/binary>>}
	end.
	

%% 2处理放弃日常任务列表
drop(Lv) ->
	DTaskId2 = refresh_task(Lv),
	Task_Daily = role_api_dict:task_daily_get(),
	Left = Task_Daily#task_daily.left - 1,
	VipCount = Task_Daily#task_daily.refresh,
	case Left == ?CONST_TASK_DAILY_ZERO of 
		?true ->
			Task_Daily2 = Task_Daily#task_daily{dTaskId = ?CONST_TASK_DAILY_SETZERO,left = ?CONST_TASK_DAILY_ZERO,state = ?CONST_TASK_DAILY_FINISH},
			role_api_dict:task_daily_set(Task_Daily2),
			msg_data(?CONST_TASK_DAILY_SETZERO,?CONST_TASK_DAILY_ZERO,?CONST_TASK_DAILY_INITVALUE,?CONST_TASK_DAILY_FINISH,VipCount);
		_ ->
			Task_Daily2 = Task_Daily#task_daily{dTaskId = DTaskId2,left = Left,state = ?CONST_TASK_DAILY_UNFINISH},
			role_api_dict:task_daily_set(Task_Daily2),
			msg_data(DTaskId2,Left,?CONST_TASK_DAILY_INITVALUE,?CONST_TASK_DAILY_UNFINISH,VipCount)
	end.

%% 3处理一键完成任务
key(#player{lv = Lv} = Player) ->
	Task_Daily = role_api_dict:task_daily_get(),
	#task_daily{refreshc = Refreshc,dTaskId = DTaskId} = Task_Daily,
	case role_api:currency_cut(<<"一键完成任务">>, Player, [{?CONST_CURRENCY_RMB,?CONST_TASK_DAILY_ONE_FINISH}]) of
		{?ok,Player2,Bin2} ->
			case data_task_daily:get(DTaskId) of
				#d_task_daily{exp = Exp,type = Type,value = Value} ->
					Exp2 = util:floor((Exp * Lv * (1 + 0.2 * Refreshc))),
					Player3 = role_api:exp_add(Player2, Exp2,reward,<<"reward">>),
					Left = Task_Daily#task_daily.left - 1,
					VipCount = Task_Daily#task_daily.refresh,
					case key_cut(Player3,Type,Value) of
						{?ok,Player4,Bin3} ->
							Bin = case Left == ?CONST_TASK_DAILY_ZERO of
									  ?true ->
										  Task_Daily2 = Task_Daily#task_daily{dTaskId = ?CONST_TASK_DAILY_SETZERO,left = ?CONST_TASK_DAILY_ZERO,state = ?CONST_TASK_DAILY_FINISH},
										  role_api_dict:task_daily_set(Task_Daily2),
										  ?MSG_ECHO("==========================~w~n",[Task_Daily2]),
										  msg_data(?CONST_TASK_DAILY_SETZERO,?CONST_TASK_DAILY_ZERO,?CONST_TASK_DAILY_INITVALUE,?CONST_TASK_DAILY_FINISH,VipCount);
									  _ ->
										  DTaskId2 = refresh_task(Lv),
										  Task_Daily2 = Task_Daily#task_daily{dTaskId = DTaskId2,left = Left,state = ?CONST_TASK_DAILY_UNFINISH},
										  ?MSG_ECHO("==========================~w~n",[Task_Daily2]),
										  role_api_dict:task_daily_set(Task_Daily2),
										  msg_data(DTaskId2,Left,?CONST_TASK_DAILY_INITVALUE,?CONST_TASK_DAILY_UNFINISH,VipCount)
								  end,
							?MSG_ECHO("===================~w~n",[Task_Daily2]),
							{?ok,Player4,<<Bin/binary,Bin2/binary,Bin3/binary>>};
						{?error,ErrorCode} ->
							{?error,ErrorCode}
					end;
				_->
					?MSG_ECHO("===================~n",[]),
			        {?error,?ERROR_TASK_DAILY_COMPELETE}
			end;
		{?error,ErrorCode} ->
			?MSG_ECHO("===================~n",[]),
			{?error,ErrorCode}
	end.

key_cut(Player,Type,Value) ->
	case Type of
	    ?CONST_TASK_DAILY_REFRESH_COPY -> 
			 role_api:currency_cut([key_cut,5 * Value,<<"一键完成任务扣减体力">>], Player, [{?CONST_CURRENCY_ENERGY,5 * Value}]);
		?CONST_TASK_DAILY_LINK_COPYS ->
			 role_api:currency_cut([key_cut,5,<<"一键完成任务扣减体力">>], Player, [{?CONST_CURRENCY_ENERGY,5}]);
		_ ->
			{?ok,Player,<<>>}
	end.
				 
	
	

%% 领取奖励
reward(#player{uid = Uid,lv = Lv} = Player) ->
	Task_Daily = role_api_dict:task_daily_get(),
	#task_daily{dTaskId = DTaskId,left = Left,state = State,value = Value0,refresh = Refresh,refreshc = Refreshc} = Task_Daily,
	case Left == ?CONST_TASK_DAILY_ZERO of    %% 这一轮任务已经完成需要领取奖励
		?true ->
			Bag = role_api_dict:bag_get(),
			case bag_api:goods_set([reward,[],<<"日常任务一轮发放的物品">>], Player, Bag, [{?CONST_TASK_DAILY_REWARD_GOOD,1}]) of
				{?ok,Player2,Bag2,GoodsBin,Bin} ->
					role_api_dict:bag_set(Bag2),
					stat_api:logs_task(Uid, DTaskId * 10, ?CONST_TASK_TYPE_EVERYDAY, util:seconds(), ?CONST_TRUE),
					Task_Daily2 = Task_Daily#task_daily{left = ?CONST_TASK_DAILY_ZERO,dTaskId = ?CONST_TASK_DAILY_SETZERO,
														state = ?CONST_TASK_DAILY_ALLFINISH,value = ?CONST_TASK_DAILY_INITVALUE},
					role_api_dict:task_daily_set(Task_Daily2),
					active_api:check_link(Uid,?CONST_ACTIVITY_LINK_101),
					Bin2 = msg_data(?CONST_TASK_DAILY_SETZERO,?CONST_TASK_DAILY_ZERO,?CONST_TASK_DAILY_INITVALUE,?CONST_TASK_DAILY_ALLFINISH,Refresh),
					{?ok,Player2,<<Bin2/binary,GoodsBin/binary,Bin/binary>>};
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		_ ->	                              %% 单个任务领取奖励
			case data_task_daily:get(DTaskId) of
				#d_task_daily{value = Value,exp = Exp} ->
					case State == ?CONST_TASK_DAILY_FINISH of
						?true ->
							case Value0 >= Value of
								?true ->
									stat_api:logs_task(Uid, DTaskId * 10, ?CONST_TASK_TYPE_EVERYDAY, util:seconds(), ?CONST_TRUE),
									Exp2 = util:floor((Exp * Lv * (1 + 0.2 * Refreshc))),
									Player2 = role_api:exp_add(Player, Exp2,reward,<<"reward">>),
									Letf2 = Left - 1,
									DTaskId2 = refresh_task(Lv),
									Task_Daily2 = Task_Daily#task_daily{dTaskId = DTaskId2,left = Letf2,state = ?CONST_TASK_DAILY_UNFINISH,value = ?CONST_TASK_DAILY_INITVALUE},
									role_api_dict:task_daily_set(Task_Daily2),							 
									Bin = case Letf2 == ?CONST_TASK_DAILY_ZERO of
											  ?true ->
												  msg_data(?CONST_TASK_DAILY_SETZERO,?CONST_TASK_DAILY_ZERO,?CONST_TASK_DAILY_INITVALUE,?CONST_TASK_DAILY_FINISH,Refresh);
											  _ ->
												  msg_data(DTaskId2,Letf2,?CONST_TASK_DAILY_INITVALUE,?CONST_TASK_DAILY_UNFINISH,Refresh)
										  end,
									{?ok,Player2,Bin};
								_ ->
									{?error,?ERROR_TASK_DAILY_ERROR_REWARD}
							end;
						_ ->
							{?error,?ERROR_TASK_DAILY_NOT_COMPELETE}
					end;
				_->
			           {?error,?ERROR_TASK_DAILY_ERROR_REWARD}
			end	
	end.

%% 4vip刷新请求
vip_refresh(#player{lv = Lv} = Player) ->
	R = role_api_dict:task_daily_get(),
	#task_daily{refresh = Refresh,refreshc = Refreshc} = R,
	case Refresh == ?CONST_TASK_DAILY_VIPZERO of
		?true ->
			{?error,?ERROR_TASK_DAILY_NOT_COUNT};
		_ ->
			Refresh2 = Refresh - 1,
			Refreshc2 = Refreshc + 1,
			case role_api:currency_cut([vip_refresh,[],<<"vip刷新任务次数">>], Player, 
									   [{?CONST_CURRENCY_RMB,?CONST_TASK_DAILY_REFALSH_RMB_USE * Refreshc2}]) of
				{?ok,Player2,Bin2} ->
					DTaskId = refresh_task(Lv),
					Now = util:date(),
					Task_daily = R#task_daily{
                                             dTaskId = DTaskId,
											 left = ?CONST_TASK_DAILY_ALL,
											 state = ?CONST_TASK_DAILY_UNFINISH,
											 refresh = Refresh2,
											 refreshc = Refreshc2,
											 timec = Now
											 },
					role_api_dict:task_daily_set(Task_daily),
					Bin = msg_data(DTaskId,?CONST_TASK_DAILY_ALL,?CONST_TASK_DAILY_INITVALUE,?CONST_TASK_DAILY_UNFINISH,Refresh2),
					Bin3 = msg_turn(Refreshc2 + 1),
					{?ok,Player2,<<Bin/binary,Bin2/binary,Bin3/binary>>};
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end
	end.

%% vip升级回调
vip_lvup_cb(#player{vip = Vip,socket = Socket}) ->
	VipCount = vip_api:check_fun(Vip#vip.lv, #d_vip.daily_tim),	
	R= role_api_dict:task_daily_get(),
	#task_daily{refreshc = Refreshc,dTaskId = DTaskId,state = State,left = Left,value = Value} = R,
	Refresh = VipCount - Refreshc,
	R2 = R#task_daily{refresh = Refresh},
	role_api_dict:task_daily_set(R2),
    BinMsg = msg_data(DTaskId,Left,Value,State,Refresh),
	app_msg:send(Socket, BinMsg).

%% 外部调用任务接口
check_cast(Uid, TargetT,Value) ->
	util:pid_send(Uid, task_daily_api, check_cb, [{TargetT,Value}]).
check_cast(Uid, TargetT,Value,Value2) ->
	util:pid_send(Uid, task_daily_api, check_cb, [{TargetT,Value,Value2}]).
check_cb(Player,[{TargetT,Value}]) ->
	check(Player,TargetT,Value),
	Player;
check_cb(Player,[{TargetT,Value,Value2}]) ->
	check(Player,TargetT,Value,Value2),
	Player.

%% 日常任务监听接口
check(#player{socket = Socket,lv = Lv},TargetT,CopyId) ->
	#task_daily{dTaskId = DTaskId,refresh = VipCount} = role_api_dict:task_daily_get(),
	case data_task_daily:get(DTaskId) of 
		#d_task_daily{value = Value,copys_id = CopysId,type = Type} ->
			case Type of
				?CONST_TASK_DAILY_STRENGTH_EQUIP ->
					case TargetT of
						?CONST_TASK_DAILY_STRENGTH_EQUIP ->
							do_check_cb(Socket,Value,DTaskId,VipCount,Lv);
						_ ->
							?skip
					end;			
				?CONST_TASK_DAILY_REFRESH_COPY ->
					case CopyId of
						CopysId ->
							do_check_cb(Socket,Value,DTaskId,VipCount,Lv);
						_ ->
							?skip
					end;
				?CONST_TASK_DAILY_DOUQI ->
					case TargetT of
						?CONST_TASK_DAILY_DOUQI ->
							do_check_cb(Socket,Value,DTaskId,VipCount,Lv);
						_ ->
							?skip
					end;
				_ ->
					?skip
			end;
		_ ->
			?skip
	end.
check(#player{socket = Socket,lv = Lv},_TargetT,_CopyId,Value) ->
	#task_daily{dTaskId = DTaskId,refresh = VipCount} = role_api_dict:task_daily_get(),
	case data_task_daily:get(DTaskId) of 
		#d_task_daily{value = Value0,type = Type} ->
			case Type of
				?CONST_TASK_DAILY_LINK_COPYS ->
					?MSG_ECHO("===========~w~n",[{Value,DTaskId}]),
					do_check_cb2(Socket,Value0,Value,DTaskId,VipCount,Lv);
				_ ->
					?skip
			end;
		_ ->
			?skip
	end.

%% 检查任务接口
do_check_cb(Socket,Value,DTaskId,VipCount,_Lv) ->
	Task_daily = role_api_dict:task_daily_get(),
	#task_daily{value = RoleValue,left = Left} = Task_daily,
	case RoleValue + 1 >= Value of
		?true ->
			BinMsg = msg_data(DTaskId,Left,Value,?CONST_TASK_DAILY_FINISH,VipCount),
			Task_daily2 = Task_daily#task_daily{value = Value,state = ?CONST_TASK_DAILY_FINISH},
			role_api_dict:task_daily_set(Task_daily2),
			app_msg:send(Socket, BinMsg);
		_ ->
			RoleValue2 = RoleValue + 1,
			Task_daily2 = Task_daily#task_daily{dTaskId = DTaskId,value = RoleValue2},
			role_api_dict:task_daily_set(Task_daily2),
			BinMsg = msg_data(DTaskId,Left,RoleValue2,?CONST_TASK_DAILY_UNFINISH,VipCount),
			app_msg:send(Socket, BinMsg)
	end.
do_check_cb2(Socket,Value0,Value,DTaskId,VipCount,_Lv) ->
	Task_daily = role_api_dict:task_daily_get(),
	#task_daily{left = Left} = Task_daily,
	case Value >= Value0 of
		?true ->
			BinMsg = msg_data(DTaskId,Left,Value,?CONST_TASK_DAILY_FINISH,VipCount),
			Task_daily2 = Task_daily#task_daily{value = Value,state = ?CONST_TASK_DAILY_FINISH},
			?MSG_ECHO("===============~w~n",[Task_daily2]),
			role_api_dict:task_daily_set(Task_daily2),
			app_msg:send(Socket, BinMsg);
		_ ->
			?MSG_ECHO("===============~w~n",[Task_daily]),
			BinMsg = msg_data(DTaskId,Left,Value,?CONST_TASK_DAILY_UNFINISH,VipCount),
			app_msg:send(Socket, BinMsg)
	end.

%% 回调清空数据
set_task_daily(Uid)->
	util:pid_send(Uid, ?MODULE, set_task_cb, ?null).

set_task_cb(Player,_) ->
    R = init_task(Player),
	role_api_dict:task_daily_set(R),
	Player.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%msg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 日常任务数据返回 [49201]
msg_data(Node,Left,Value,
    State,VipCount)->
    RsList = app_msg:encode([{?int16u,Node},
        {?int8u,Left},{?int8u,Value},
        {?int8u,State},{?int8u,VipCount}]),
    app_msg:msg(?P_DAILY_TASK_DATA, RsList).

% 日常任务当前轮次 [49206]
msg_turn(Turn)->
    RsList = app_msg:encode([{?int16u,Turn}]),
    app_msg:msg(?P_DAILY_TASK_TURN, RsList).



	