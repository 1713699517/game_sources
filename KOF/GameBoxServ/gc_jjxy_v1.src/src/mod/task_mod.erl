%% Author: Goku
%% Created: 2012-9-22
%% Description: TODO: task module
-module(task_mod).

%%
%% Include files
%%
-include("comm.hrl").
%%
%% Exported Functions
%% 
-export([
		 check/3,	
		 check_cb/2,
		 check_task_type/2,
		 accept_state/1,
		 init/0,
		 init_task_data/0,
		 idx_key/2,
		 refresh/1,
		 accept/2,
		 submit/3,
		 submit/4,
		 drop/2,

		 check_all_task/1,
		 choose_country/2
		]).

%% 初始化人物任务数据
%% init  return: [#user_task{}|_]
init() ->
	Key = idx_key(0, 1),
	case ets:lookup(?ETS_TASK, Key) of
		[] ->%% 该等级和国家无任务
			[];
		[{_,Ids}] ->
			lists:foldl(fun(Id,Acc) ->
								case data_task:get(Id) of
									#d_task{pre = 0} ->% 无前置任务需求,满足等级和阵营需求的任务
										[#user_task{id=Id, state=?CONST_TASK_STATE_ACCEPTABLE}|Acc];
									_ ->
										Acc
								end
						end, [], Ids)
	end.

%% 标准任务索引关键字
idx_key(_Country,Lv) -> Lv.

%%
%% API Functions
%% 建立任务数据索引,开服调用,主要索引为 国家和等级
init_task_data() ->
	F = fun(ID, Acc) ->
				case data_task:get(ID) of
					#d_task{country = Country, lv = Lv} ->
						Key = idx_key(Country, Lv),
						case lists:keytake(Key, 1, Acc) of
							{value, {Key, IDL}, Acc2} ->
								[{Key,[ID|IDL]}|Acc2];
							?false ->
								[{Key,[ID]}|Acc]
						end;
					_ ->
						Acc
				end
		end,
	IDS = data_task:get_ids(),
	IdxL = lists:foldl(F, [], IDS),
	ets:insert(?ETS_TASK, IdxL).

%% 每升一级或者加入了国家调用一次刷新玩家任务数据(按国家和等级开放) 1.使人物身上满足条件的已激活的变为可接受 2.刷新不需要前置的任务为可接受
refresh(#player{lv=Lv,country=Country} = Player) ->%% 刷新可接受的支线任务,忽略有前置需求的,达到等级国家等级的无前置条件任务
	AllTask = role_api_dict:tasks_get(),
	#tasks{tlist=Tasks} = AllTask,
	Key = idx_key(Country, Lv),
	Ids = case ets:lookup(?ETS_TASK, Key) of
			  [] ->
				  [];
			  [{_, Ids0}] ->
				  Ids0
		  end,
	Fun = fun(Id, Acc) ->
				  case data_task:get(Id) of
					  #d_task{pre=0, accept = 1} ->%% 无前置任务,按阵营等级开发
						  UT = #user_task{id=Id,state=?CONST_TASK_STATE_ACCEPTABLE},
						  [UT|Acc];
					  #d_task{pre=0, accept = 2} ->
						  UT = #user_task{id=Id,state=?CONST_TASK_STATE_UNFINISHED},
						  [UT|Acc];
					  _ ->
						  Acc
				  end
		  end,
	Tasks2 = lists:foldl(Fun, [], Ids),
	{NewTasks, BinMsg} = ignore(Lv, Tasks ++ Tasks2),
	BinTask2 = check_all_task(NewTasks),
	Bin = task_api:msg(?P_TASK_DATA, [BinTask2]),
	?MSG_ECHO("---------------------refresh ~w~n",[BinTask2]),
	active(Player,AllTask#tasks{tlist=NewTasks}, <<Bin/binary,BinMsg/binary>>).     %% 刷新人物身上满足条件的已激活隐藏任务

%% 升级或者加入国家触发已激活隐藏的达到等级国家的任务(包括主线)
active(#player{socket=Socket,lv=Lv}=Player,#tasks{tlist=Tasks}=AllTask, Bin0) ->%% 激活人物身上任务数据中已激活不可接且符合等级条件的任务
	Fun = fun(#user_task{id=Id,state = ?CONST_TASK_STATE_ACTIVATE} = UT, {Acc, BinAcc}) ->
				  case data_task:get(Id) of
					  #d_task{lv=Lv0,type=?CONST_TASK_TYPE_MAIN} ->
						  case Lv >= Lv0 of     %% 等级和国家条件满足
							  ?true ->
								  UT2 = UT#user_task{state=?CONST_TASK_STATE_ACCEPTABLE},
								  BinAcc2 = task_api:msg(?P_TASK_DATA, [UT2]),
								  {[UT2|Acc], <<BinAcc/binary, BinAcc2/binary>>};
							  ?false ->
								  {[UT|Acc], BinAcc}
						  end;
					  #d_task{lv=Lv0} ->
						  case Lv >= Lv0 of     %% 等级和国家条件满足
							  ?true ->
								  UT2 = UT#user_task{state=?CONST_TASK_STATE_ACCEPTABLE},
								  {[UT2|Acc], BinAcc};
							  ?false ->
								  {[UT|Acc], BinAcc}
						  end;
					  _ ->
						  {[UT|Acc], BinAcc}
				  end;
			 (UT, {Acc, BinAcc}) ->
				  {[UT|Acc], BinAcc}
		  end,
	{Tasks2, BinMsg} = lists:foldl(Fun, {[], Bin0}, Tasks),
	role_api_dict:tasks_set(AllTask#tasks{tlist=Tasks2}),
	app_msg:send(Socket, BinMsg),
	Player.

%% 异步监听任务事件
%% callback check task event
check_cb(Player, [TargetT, TargetV]) ->%% 任务事件监听
	check(Player, TargetT, TargetV).

%% 同步监听任务事件
check(#player{socket=Socket} = Player, TargetT, Value) ->%% 监听任务事件
	AllTask = role_api_dict:tasks_get(),
	#tasks{tlist=Tasks} = AllTask,
	Fun = fun(#user_task{state = ?CONST_TASK_STATE_UNFINISHED}=UT,{Acc,Bin}) ->
				  {UT2, Bin2} = do_check(UT, TargetT, Value),
				  Bin3 = drama(UT2),
				  {[UT2|Acc],<<Bin/binary,Bin2/binary,Bin3/binary>>};
			 (UT, {Acc,Bin}) ->
				  {[UT|Acc],Bin}
		  end,
	{Tasks2, BinMsg} = lists:foldl(Fun, {[], <<>>}, Tasks),
	role_api_dict:tasks_set(AllTask#tasks{tlist=Tasks2}),
	app_msg:send(Socket, BinMsg),
	Player.

%% 检查任务事件
%% return : {UT, Bin}
do_check(#user_task{id=ID, value = Val0} = UT, TargetT, Value) ->
	case data_task:get(ID) of
		#d_task{target_t = TargetT, target_v = TargetV} ->
			case TargetT of
				?CONST_TASK_TARGET_KILL ->% 击杀怪物
					{Scenes, IdCountL} = TargetV,
					case Value of
						{Scenes, IdCountL0} ->
							IdCountL2 = lists:foldl(fun({Id, Count}, Acc) ->
															case lists:keyfind(Id, 1, IdCountL) of
																{_, Max} ->
																	[{Id, Count, Max}|Acc];
																?false ->
																	Acc
															end
													end, [], IdCountL0),
							{UT2, BinMsg} = do_check_kill(UT, IdCountL2, IdCountL),
							{UT2, BinMsg};
						_ ->% 忽略
							{UT, <<>>}
					end;
				?CONST_TASK_TARGET_COPY ->% 副本通关
					case TargetV of
						{Value, Max} ->
							CountNow = ?IF(erlang:is_integer(Val0), Val0, 0),
							UT2 = ?IF(CountNow + 1 >= Max, 
									  UT#user_task{state = ?CONST_TASK_STATE_FINISHED, value = Max},
									  UT#user_task{value = CountNow + 1}),
							{UT2,task_api:msg(?P_TASK_DATA, [UT2])};
						_ ->
							{UT, <<>>}
					end;
				?CONST_TASK_TARGET_OTHER ->
					case TargetV of 
						{?CONST_TASK_TO_BUY, _, _, _, _, _} ->% 加入帮派
							#clan{clan_id=ClanId} = role_api_dict:clan_get(),
							case ClanId of
								0 ->
									{UT, <<>>};
								_ ->
									UT2 = UT#user_task{state = ?CONST_TASK_STATE_FINISHED},
									BinMsg = task_api:msg(?P_TASK_DATA, [UT2]),
									{UT2, BinMsg}
							end;
						{?CONST_TASK_TO_PAY_FIRST, TarValue, _, _, _, _} ->% 充值数量
							if
								Value >= TarValue ->
									UT2 = UT#user_task{state = ?CONST_TASK_STATE_FINISHED, value = TarValue},
									BinMsg = task_api:msg(?P_TASK_DATA, [UT2]),
									{UT2, BinMsg};
								?true ->
									{UT, <<>>}
							end;
						{?CONST_TASK_TO_ARENA, Count, _, _, _, _} ->% 封神台
							case Value of
								?CONST_TASK_TO_ARENA ->
									Val = ?IF(is_integer(Val0), Val0 + 1, 1),
									{Stat, Var} = ?IF(Val >= Count, {?CONST_TASK_STATE_FINISHED, Count}, {?CONST_TASK_STATE_UNFINISHED,Val}),
									UT2 = UT#user_task{state = Stat, value = Var},
									BinMsg = task_api:msg(?P_TASK_DATA, [UT2]),
									{UT2, BinMsg};
								_ ->
									{UT, <<>>}
							end;
						{?CONST_TASK_TO_SANJIESHA, Mid, _, _, _, _} ->% 三界杀BOSS
							case Value of
								{?CONST_TASK_TO_SANJIESHA, Mid} ->
									UT2 = UT#user_task{state = ?CONST_TASK_STATE_FINISHED},
									BinMsg = task_api:msg(?P_TASK_DATA, [UT2]),
									{UT2, BinMsg};
								_ ->
									{UT, <<>>}
							end;
						{?CONST_TASK_TO_RENOWN_LV, RenownLv,_,_,_,_} ->
							case Value of
								{?CONST_TASK_TO_RENOWN_LV, RenownLv0} when RenownLv0 >= RenownLv ->
									UT2 = UT#user_task{state = ?CONST_TASK_STATE_FINISHED},
									BinMsg = task_api:msg(?P_TASK_DATA, [UT2]),
									{UT2, BinMsg};
								_ ->
									{UT, <<>>}
							end;
						_ ->
							{UT, <<>>}
					end;
				_ ->
					{UT, <<>>}
			end;
		_ ->
			{UT, <<>>}
	end.

%% 检查击杀怪物
%% return : {UT, BinMsg}
do_check_kill(#user_task{value = L} = UT, IdCount0, IdCount) ->
	L2 = lists:foldl(fun({Id, Count, Max}, Acc) ->
							 case lists:keytake(Id, 1, Acc) of
								 {value, {Id, Count0}, Acc2} ->
									 [{Id, erlang:min(Max,Count0 + Count)}|Acc2];
								 ?false ->
									 [{Id, erlang:min(Max, Count)}|Acc]
							 end
					 end, L, IdCount0),
	case length(L2) == length(IdCount) andalso begin
												   lists:foldl(fun({Id, Count}, Acc) ->
																	   case lists:keyfind(Id, 1, IdCount) of
																		   {_, C} ->
																			   Count >= C andalso Acc;
																		   _ ->
																			   Acc
																	   end
															   end, ?true, L2)
											   end of
		?true ->
			UT2 = UT#user_task{state = ?CONST_TASK_STATE_FINISHED, value = IdCount,seconds = util:seconds()},
			{UT2,task_api:msg(?P_TASK_DATA, [UT2])};
		?false ->
			{UT#user_task{value = L2}, <<>>}
	end.


%% 接受任务,判断是否可以接受
accept(#player{uid = Uid}=Player, TaskId) ->
	AllTask = role_api_dict:tasks_get(),
	#tasks{tlist=Tasks} = AllTask,
	case check_accept(Player, TaskId) of
		?ok ->
			case lists:keytake(TaskId, #user_task.id, Tasks) of
				{value, #user_task{state = ?CONST_TASK_STATE_ACCEPTABLE}=UT, Tasks2} ->
					NewState = accept_state(TaskId),
					UT2 = UT#user_task{id=TaskId,state=NewState,seconds=util:seconds()},
					Bin = task_api:msg(?P_TASK_DATA, [UT2]),%% 通知前端任务状态改变
					Bin2 = drama(UT2),
					logs_task(Uid, TaskId, ?CONST_FALSE),
					role_api_dict:tasks_set(AllTask#tasks{tlist=[UT2|Tasks2]}),
					{?ok, Player, <<Bin/binary,Bin2/binary>>};
				_ ->
					{?ok, Player, <<>>}
			end;
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	
	end.

%% 接任务状态变化
accept_state(TaskId) ->
	#d_task{target_t=TargetT, target_v = TargetV} = data_task:get(TaskId),
	case TargetT of
		?CONST_TASK_TARGET_TALK ->% 对话类任务,直接完成该任务
			?CONST_TASK_STATE_FINISHED;
		?CONST_TASK_TARGET_OTHER ->
			case TargetV of
				{?CONST_TASK_TO_PARTNER, _,_,_,_,_} ->
					?CONST_TASK_STATE_FINISHED;
				{?CONST_TASK_TO_RENOWN_LV, RenownLv,_,_,_,_} ->
						Renown = role_api_dict:renown_get(),
					?IF(Renown#renown.renown_lv >= RenownLv, ?CONST_TASK_STATE_FINISHED, ?CONST_TASK_STATE_UNFINISHED);
				{?CONST_TASK_TO_BUY, _,_,_,_,_} ->
					#clan{clan_id=ClanId} = role_api_dict:clan_get(),
					case ClanId of
						0 ->
							?CONST_TASK_STATE_UNFINISHED;
						_ ->
							?CONST_TASK_STATE_FINISHED
					end;
				_ ->
					?CONST_TASK_STATE_UNFINISHED
			end;	
		_ ->
			?CONST_TASK_STATE_UNFINISHED
	end.

%% 提交任务 return: {?ok, Player, Bin} | {?error, ErrorCode}
submit(Player, TaskId, Arg) ->
	AllTask = role_api_dict:tasks_get(),
	submit(Player, AllTask, TaskId, Arg).

submit(#player{uid = Uid,socket=Socket} = Player, AllTask0, TaskId, Arg) ->
	AllTask = update_taskc(AllTask0, TaskId),
	#tasks{tlist=Tasks} = AllTask,
	case lists:keytake(TaskId, #user_task.id, Tasks) of
		{value, #user_task{state = ?CONST_TASK_STATE_FINISHED}=UT,Tasks2} ->
			BinMove = task_api:msg(?P_TASK_REMOVE, [TaskId, ?CONST_TASK_REMOVE_REASON_DOWN]),     %% 任务移除
			case check_reward(Player, TaskId) of
				{?ok,TaskId, {Exp, Currency, GoodsList02}} ->%% 领取奖励成功
					{Player2, Tasks3, BinRef} = refresh_next(Player, Tasks2, TaskId),
					BinDrama = drama(UT#user_task{state = ?CONST_TASK_STATE_SUBMIT}),
					role_api:sys_task(Player2, TaskId),
					Player3 = submit_event(Player2, TaskId),
					logs_task(Uid, TaskId, ?CONST_TRUE),
					logs_api:task_notice(Uid,TaskId),
					role_api_dict:tasks_set(AllTask#tasks{tlist=Tasks3}),
					app_msg:send(Socket, <<BinMove/binary, BinRef/binary, BinDrama/binary>>),
					reward_get(Player3, TaskId, {Exp, Currency, GoodsList02});
				{?error, ErrorCode} ->%% 领取任务奖励失败
					{?error, ErrorCode}
			end;
		{value, #user_task{state = ?CONST_TASK_STATE_UNFINISHED}=UT,Tasks2} -> 
			case data_task:get(TaskId) of  %% 下载新资源
				#d_task{target_t = ?CONST_TASK_TARGET_OTHER, target_v = {?CONST_TASK_DOWN_NEWS,_,_,_,_,_}} -> 
					BinMove = task_api:msg(?P_TASK_REMOVE, [TaskId, ?CONST_TASK_REMOVE_REASON_DOWN]),     %% 任务移除
					case check_reward(Player, TaskId) of
						{?ok,TaskId, {Exp, Currency, GoodsList02}} ->%% 领取奖励成功
							{Player2, Tasks3, BinRef} = refresh_next(Player, Tasks2, TaskId),
							BinDrama = drama(UT#user_task{state = ?CONST_TASK_STATE_SUBMIT}),
							role_api:sys_task(Player2, TaskId),
							Player3 = submit_event(Player2, TaskId),
							logs_task(Uid, TaskId, ?CONST_TRUE),
							logs_api:task_notice(Uid,TaskId),
							role_api_dict:tasks_set(AllTask#tasks{tlist=Tasks3}),
							app_msg:send(Socket, <<BinMove/binary, BinRef/binary, BinDrama/binary>>),
							reward_get(Player3, TaskId, {Exp, Currency, GoodsList02});
						{?error, ErrorCode} ->%% 领取任务奖励失败
							{?error, ErrorCode}
					end;
				#d_task{target_t = ?CONST_TASK_TARGET_OTHER, target_v = {?CONST_TASK_TO_BUY,_,_,_,_,_}} -> 
					case clan_api:clan_id_get(Uid) of % 任务目标其它 - 加入帮派 
						0 ->
							{?ok, Player, <<>>};
						_ ->
							BinMove = task_api:msg(?P_TASK_REMOVE, [TaskId, ?CONST_TASK_REMOVE_REASON_DOWN]),     %% 任务移除
							case check_reward(Player, TaskId) of
								{?ok,TaskId, {Exp, Currency, GoodsList02}} ->%% 领取奖励成功
									{Player2, Tasks3, BinRef} = refresh_next(Player, Tasks2, TaskId),
									BinDrama = drama(UT#user_task{state = ?CONST_TASK_STATE_SUBMIT}),
									role_api:sys_task(Player2, TaskId),
									Player3 = submit_event(Player2, TaskId),
									logs_task(Uid, TaskId, ?CONST_TRUE),
									logs_api:task_notice(Uid,TaskId),
									role_api_dict:tasks_set(AllTask#tasks{tlist=Tasks3}),
									app_msg:send(Socket, <<BinMove/binary, BinRef/binary, BinDrama/binary>>),
									reward_get(Player3, TaskId, {Exp, Currency, GoodsList02});
								{?error, ErrorCode} ->%% 领取任务奖励失败
									{?error, ErrorCode}
							end
					end;
				#d_task{target_t = ?CONST_TASK_TARGET_OTHER, target_v = {?CONST_TASK_TO_COUNTRY,_,_,_,_,_}} ->
					case choose_country(Player, Arg) of % 任务目标其它 - 加入阵营 
						{?ok, Player2, BinCountry} ->
							BinMove = task_api:msg(?P_TASK_REMOVE, [TaskId, ?CONST_TASK_REMOVE_REASON_DOWN]),     %% 任务移除
							case check_reward(Player, TaskId) of
								{?ok,TaskId, {Exp, Currency, GoodsList02}} ->%% 领取奖励成功
									{Player2, Tasks3, BinRef} = refresh_next(Player, Tasks2, TaskId),
									BinDrama = drama(UT#user_task{state = ?CONST_TASK_STATE_SUBMIT}),
									role_api:sys_task(Player2, TaskId),
									Player3 = submit_event(Player2, TaskId),
									logs_task(Uid, TaskId, ?CONST_TRUE),
									logs_api:task_notice(Uid,TaskId),
									role_api_dict:tasks_set(AllTask#tasks{tlist=Tasks3}),
									app_msg:send(Socket, <<BinCountry/binary, BinMove/binary, BinRef/binary, BinDrama/binary>>),
									reward_get(Player3, TaskId, {Exp, Currency, GoodsList02});
								{?error, ErrorCode} ->%% 领取任务奖励失败
									{?error, ErrorCode}
							end
					end;
				_ ->
					{?ok, Player, <<>>}
			end;
		_ ->
			{?ok, Player, <<>>}
	end.

%% 任务奖励  检查是否可以领取奖励
%% return: {?ok,TaskId, {Exp, Currency, GoodsList02}} || {?error, ErrorCode}
check_reward(#player{pro=Pro,sex=Sex},TaskId) ->
	Fcm = role_api_dict:fcm_get(),
	#d_task{exp = Exp, id=TaskId,gold = Gold, goods = Gives, ext_id = ExtID, ext_v = Extv} = data_task:get(TaskId),
	F = fun({Pro0,Sex0,Give0},Acc) ->
				case (Pro0 == 0 orelse Pro0 == Pro) andalso
						 (Sex0 == 0 orelse Sex0 == Sex) of
					?true ->
						case bag_api:goods(Give0) of
							#goods{}=Goods ->
								[Goods|Acc];
							_ ->
								Acc
						end;
					?false ->
						Acc
				end
		end,
	GoodsList0 = lists:foldl(F, [], Gives),
	Currency0 = [{?CONST_CURRENCY_GOLD, Gold}, {ExtID,Extv}],
	{Currency, GoodsList02} = reward_fcm(Fcm,Currency0,GoodsList0),
	case GoodsList02 of
		[] ->
			{?ok,TaskId, {Exp, Currency, []}};
		_ ->
			case bag_api:check_bag_goods(GoodsList02) of
				?true ->
					{?ok,TaskId, {Exp, Currency, GoodsList02}};
				{?error, ErrorCode} ->
					{?error, ErrorCode}
			end
	end.
%% 任务奖励 领取奖励
%%　return: {?ok,Player, Bin} || {?error, ErrorCode}			
reward_get(Player, TaskId, {Exp, Currency, GoodsList02}) ->
	case bag_api:goods_set([reward,[],<<"任务奖励">>], Player, GoodsList02) of
		{?ok, Player2,GoodsBin,BinMsg} ->
			{Player3, BinMsg2} = role_api:currency_add([reward,[],<<"任务奖励">>],Player2, Currency),
			Player4 = role_api:exp_add(Player3, Exp, reward,<<"任务id:",(util:to_binary(TaskId))/binary>>),  
			{?ok, Player4, <<GoodsBin/binary,BinMsg/binary,BinMsg2/binary>>};
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.


%% 提交任务刷新后置任务数据,后置触发(支线可不触发暂隐藏,主线需要任何时刻要有唯一一个任务或者无)
refresh_next(Player, Tasks, TaskId) ->
	case data_task:get(TaskId) of
		#d_task{lv=Lv, next=Next, next_ext = NextExt0} ->%% 获取任务后置数据
			NextExt = lists:foldl(fun(TaskID0, Acc) ->
										  case check_task_type(TaskID0, ?CONST_TASK_TYPE_MAIN) of
											  ?false ->
												  [TaskID0|Acc];
											  ?true ->
												  ?MSG_ERROR("{TaskId,TaskID0} : ~p~n", [{TaskId,TaskID0}]),
												  Acc
										  end
								  end, [], NextExt0),
			ExtList = ?IF(Next == 0, NextExt, [Next|NextExt]),
			BinTask = 
				case check_task_type(TaskId, ?CONST_TASK_TYPE_MAIN) of
					?false ->
						?false ; 
					?true ->
						check_lv_othe(Tasks, Lv)
				end,
			refresh_next2(Player, Tasks, ExtList, BinTask);
		_ ->
			{Player, Tasks, <<>>}
	end.

%% return:{Player,Tasks2, Bin}
refresh_next2(Player, Tasks, Next, ?false) when is_list(Next) ->
	F = fun(NextID, {PlayerAcc, TasksAcc, BinAcc}) ->
				{PlayerAcc2,TasksAcc2, BinAcc2} = refresh_next2(PlayerAcc, TasksAcc, NextID, ?false),
				{PlayerAcc2, TasksAcc2, <<BinAcc/binary, BinAcc2/binary>>}
		end, 
	lists:foldl(F, {Player, Tasks, <<>>}, Next);
refresh_next2(Player, Tasks, Next, BinTask) when is_list(Next) ->
	F = fun(NextID, {PlayerAcc, TasksAcc, BinAcc}) ->
				{PlayerAcc2,TasksAcc2, BinAcc2} = refresh_next2(PlayerAcc, TasksAcc, NextID, <<>>),
				{PlayerAcc2, TasksAcc2, <<BinAcc/binary, BinAcc2/binary>>}
		end, 
	lists:foldl(F, {Player, Tasks, BinTask}, Next);

%% return:{Player, Bin}
refresh_next2(#player{lv=Lv}=Player, Tasks, Next, ?false) when is_integer(Next) ->
	case data_task:get(Next) of
		#d_task{lv=Lv0, accept = Accept} ->
			State = 
				case Accept of
					2 ->
						?CONST_TASK_STATE_ACCEPTABLE;
					_ ->
						?IF(Lv >= Lv0, ?CONST_TASK_STATE_ACCEPTABLE, ?CONST_TASK_STATE_ACTIVATE)
				end,
			UT = #user_task{id=Next,state=State,seconds=util:seconds()},
			Bin = check_main_task_is_submit(UT, Lv0, Tasks), %% 新的支线任务数据
			{Player, [UT|Tasks], Bin};
		_ ->
			{Player, Tasks, <<>>}
	end;
refresh_next2(#player{lv=Lv}=Player, Tasks, Next, BinTask) when is_integer(Next) ->
	case data_task:get(Next) of
		#d_task{lv=Lv0, accept = Accept} ->
			State = 
				case Accept of
					2 ->
						?CONST_TASK_STATE_ACCEPTABLE;
					_ ->
						?IF(Lv >= Lv0, ?CONST_TASK_STATE_ACCEPTABLE, ?CONST_TASK_STATE_ACTIVATE)
				end,
			UT = #user_task{id=Next,state=State,seconds=util:seconds()},
			Bin = task_api:msg(?P_TASK_DATA,[UT]), %% 新的主线任务数据
			{Player, [UT|Tasks], <<Bin/binary, BinTask/binary>>};
		_ ->
			{Player, Tasks, <<>>}
	end.

%% 当前主线任务是否大于新支线任务等级
check_main_task_is_submit(UTask, Lv0, Tasks) ->
	F =fun(#user_task{id=Id}, Acc) -> 
			   case data_task:get(Id) of
				   #d_task{type=?CONST_TASK_TYPE_MAIN, lv=Lv} ->
					   Lv > Lv0;
				   _ ->
					   Acc
			   end
	   end,
	case lists:foldl(F, ?false, Tasks) of
		?true ->
			task_api:msg(?P_TASK_DATA,[UTask]);
		_ ->
			<<>>
	end.

check_task_type(TaskID, Type) ->
	case data_task:get(TaskID) of
		#d_task{type = Type} ->
			?true;
		_ ->
			?false
	end.

check_lv_othe(Tasks, Lv) ->
	F = fun(#user_task{id=TaskId}=Task,Acc) ->
				case data_task:get(TaskId) of
					#d_task{type=?CONST_TASK_TYPE_MAIN} ->
						Acc;
					#d_task{lv=Lv} ->
						[Task|Acc];
					_ ->
						Acc
				end
		end,
	TaskBin = lists:foldl(F, [], Tasks),
	?MSG_ECHO("-----------------------check_lv_othe ~w~n",[TaskBin]),
	task_api:msg(?P_TASK_DATA, [TaskBin]).
			
	

%% 检查接受任务玩家与npc的距离是否在有效范围内
%% return: ok | {?error, ErrorCode}
check_location_a(TaskId, SceneId, X, Y) ->?ok.

%% 检查提交任务玩家与npc的距离是否在有效范围内
check_location_s(TaskId, SceneId, X, Y) ->?ok.
%% 	#d_task{npc_e=Npc} = data_task:get(TaskId),
%% 	#d_npc{scene_id=SceneId0,x=PosX,y=PosY} = data_npc:get(Npc),
%% 	case SceneId == SceneId0 andalso erlang:abs(X-PosX) =< 10 andalso erlang:abs(Y-PosY) =< 10 of
%% 	?true ->%% 玩家所在位置处于距离npc有效的范围内
%% 			ok;
%% 	?false ->
%% 			{?error, ?ERROR_TASK_DISTANCE_LONG}     %% 距离npc太远
%% 	end.

%% 放弃任务 return:{?ok, Player, Bin} | {?error, ErrorCode} 
drop(Player, TaskId) ->%% 放弃任务重接
	AllTask = role_api_dict:tasks_get(),
	#tasks{tlist=Tasks} = AllTask,
	case data_task:get(TaskId) of
		#d_task{is_give_up = ?CONST_TRUE} ->%% 可放弃重接
			case lists:keytake(TaskId, #user_task.id, Tasks) of
				{value, UT, Tasks2} ->
					UT2 = UT#user_task{state = ?CONST_TASK_STATE_ACCEPTABLE, value = []},
					Bin = task_api:msg(?P_TASK_DATA, [UT2]),
					role_api_dict:tasks_set(AllTask#tasks{tlist=[UT2|Tasks2]}),
					{?ok, Player, Bin};
				?false ->%% 任务不存在
					{?error, ?ERROR_TASK_NOT_EXIST}     %% 参数错误
			end;
		_ ->
			{?error, ?ERROR_TASK_NOT_ABANDON}     %% 任务不可放弃
	end.

%% 忽略跳级任务 return : {Tasks,BinMsg} :: [#user_task{}|_]
ignore(Lv, Tasks) ->
	Fun = fun(#user_task{id = Id}=UT,{Acc,BinAcc}) ->
				  case data_task:get(Id) of
					  #d_task{is_skip = ?CONST_TRUE, lv = Lvt} ->
						  case Lv - Lvt >= 10 of
							  ?true ->
								  BinAcc2 = task_api:msg(?P_TASK_REMOVE, [Id,?CONST_TASK_REMOVE_REASON_CANCEL]),
								  {Acc,<<BinAcc/binary, BinAcc2/binary>>};
							  ?false ->
								  {[UT|Acc],BinAcc}
						  end;
					  _ ->
						  {[UT|Acc],BinAcc}
				  end
		  end,
	lists:foldl(Fun, {[], <<>>}, Tasks).

%%
%% Local Function
%% 任务剧情触发 return : BinMsg | <<>>
drama(#user_task{id=TaskID, state = State}) 
  when State == ?CONST_TASK_STATE_UNFINISHED orelse
		   State == ?CONST_TASK_STATE_FINISHED orelse
		   State == ?CONST_TASK_STATE_SUBMIT ->
	case data_task:get(TaskID) of
		#d_task{drama_id = DramaID, drama_touch = State} ->
			case DramaID of
				0 ->
					<<>>;
				_ ->
					?MSG_ECHO("DramaID : ~p~n",[DramaID]),
					task_api:msg(?P_TASK_TASK_DRAMA, [DramaID])
			end;
		_ ->
			<<>>
	end;

drama(_) -> <<>>.


%%  提交任务事件触发
submit_event(Player, _TaskId) -> Player.
%% 	case data_task:get(TaskId) of
%% 		#d_task{type = ?CONST_TASK_TYPE_MAIN} ->
%% 			target_api:listen_task_over(Player,TaskId);
%% 		_ ->
%% 			Player
%% 	end.

%% 选择阵营任务
%% choose country
choose_country(Player, Country) ->
	CountryL = [?CONST_COUNTRY_ONE, ?CONST_COUNTRY_FAIRY, ?CONST_COUNTRY_MAGIC],
	case lists:member(Country, CountryL) of
		?true ->
			Bin = role_api:msg_property_update(0, ?CONST_ATTR_COUNTRY,Country),
			{?ok, Player#player{country = Country}, Bin};
		?false ->
			case Country of
				?CONST_COUNTRY_DEFAULT ->
					CountryN = role_api:min_country(),
					Bin = role_api:msg_property_update(0, ?CONST_ATTR_COUNTRY,CountryN),
					Goods = bag_api:goods(?CONST_COUNTRY_RAND_GIFT),
					case bag_api:goods_set([reward,[],<<"选择阵营任务">>],Player#player{country = CountryN}, [Goods]) of
						{?ok,Player2,GoodsBin,BinMsg} ->
							{?ok, Player2, <<GoodsBin/binary,BinMsg/binary,Bin/binary>>};
						{?error, ErrorCode} ->
							{?error, ErrorCode}
					end;
				_ ->
					{?error, ?ERROR_BADARG}
			end
	end.

%% update_complete return : AllTask
update_taskc(#tasks{taskclist = Taskc} = AllTask, TaskID) ->
	case data_task:get(TaskID) of
		#d_task{} ->
			case lists:member(TaskID, Taskc) of
				?true ->
					AllTask;
				?false ->
					Taskc2 = [TaskID|Taskc],
					AllTask#tasks{taskclist = Taskc2}
			end;
		_ ->
			AllTask
	end.

%% 检查接受任务属性要求 return : ?ok | {?error, ErrorCode}
check_accept(#player{vip=Vip} = Player, TaskID) ->
	case data_task:get(TaskID) of
		#d_task{accept_id = AcceptID, accept_v = AcceptV} ->
			case AcceptID of
				0 ->
					?ok;
				?CONST_ATTR_VIP ->
					if
						Vip#vip.lv >= AcceptV ->
							?ok;
						?true ->
							{?error, ?ERROR_VIP_LV_LACK}
					end;
				_ ->
					case lists:keyfind(AcceptID, 1, ?ATTR_TYPE_POS) of
						{_, Pos} ->
							if
								erlang:element(Pos, Player#player.attr) >= AcceptV ->
									?ok;
								?true ->
									{?error, ?ERROR_TASK_NOT_RECEIVE}
							end;
						?false ->
							?ok
					end
			end;				
		_ ->
			{?error, ?ERROR_BADARG}
	end.

reward_fcm(#fcm{fcm_state = ?CONST_FCM_NORMAL}, CL, GL) ->
	{CL,GL};
reward_fcm(#fcm{fcm_state = ?CONST_FCM_HALF}, CL, _GL) ->
	{[ {T, util:floor(V / 2)} || {T,V} <- CL, T =/= 0 orelse V =/= 0], []};
reward_fcm(#fcm{fcm_state = ?CONST_FCM_NOTHING}, _, _) ->
	{[], []};
reward_fcm(_, _, _) ->
	{[], []}.

%% 统计任务
logs_task(Uid, TaskId, State) ->
	AllTask = role_api_dict:tasks_get(),
	#tasks{tlist=Tlist} = AllTask,
	case lists:keyfind(TaskId, #user_task.id, Tlist) of
		#user_task{seconds=Time} ->
			case data_task:get(TaskId) of
				#d_task{type =Type} ->
 					stat_api:logs_task(Uid,TaskId,Type,Time,State);
				_ ->
					?skip
			end;
		_ ->
			?skip
	end.

%% 登陆检查  去除与当前主线任务等级相同的支线任务，完成主线任务时才刷出同等级的支线任务
check_all_task(Tasks) ->
	F =fun(#user_task{id=Id}=Task, {Acc,MAcc}) -> 
			   case data_task:get(Id) of
				   #d_task{type=?CONST_TASK_TYPE_MAIN, lv=Lv} ->
					   {Acc, [{Lv, Task}|MAcc]};
				   #d_task{lv=Lv} ->
					   {[{Lv, Task}|Acc], MAcc};
				   _ ->
					   {Acc,MAcc}
			   end
	   end,
	{TaskList, MTaskList}= lists:foldl(F, {[],[]}, Tasks),
	case MTaskList of
		[] ->
			Tasks;
		_ ->
			{MainLv,MainTask} =
				case MTaskList of
					[{MLv,MTask}] ->
						{MLv,MTask};
					_ ->
						[{MLv,MTask}|_] = lists:keysort(2, MTaskList),
						{MLv,MTask}
				end,
			[MainTask|[T||{L,T} <- TaskList, L < MainLv]]
	end.


	
