%% Author: youxi
%% Created: 2012-9-24
%% Description: TODO: Add description to task_api
-module(task_api).

%%
%% Include files
%%
-include("comm.hrl").
%%
%% Exported Functions
%%
-export([
		 encode_task/1,
		 decode_task/1,
		 encode_taskc/1,
		 decode_taskc/1,

		 init/1,
		 init_task_data/0,		 
		 is_complete/1,
		 
		 check/3,
		 check_cast/2,
		 check_cast/3,
		 check_copy/2,
		 
		 login_task/1,

		 accept/2, 
		 drop/2,
		 submit/3,
		 pay/2,
		 refresh/1,
		 do_check/3,

		 
		 msg/2
		]).


encode_task(Task) -> 
	Task.

decode_task(Task) ->
	Task.

encode_taskc(Task) -> 
	Task.

decode_taskc(Task) ->
	Task.


%%
%% API Functions
%%

login_task(Player) ->
	AllTask = role_api_dict:tasks_get(),
%% 	AllTask = check_change(Player#player.lv),
	#tasks{tlist=Tasks} = AllTask,
	F = fun(#user_task{id=TaskId,state=State0}=UserTask,Acc) -> 
				#d_task{target_t=TargetT, target_v = TargetV} = data_task:get(TaskId),
				State = 
					case TargetT of
						?CONST_TASK_TARGET_OTHER ->
							case TargetV of
								{?CONST_TASK_TO_RENOWN_LV, RenownLv,_,_,_,_} ->
									Renown = role_api_dict:renown_get(),
									?IF(Renown#renown.renown_lv >= RenownLv, ?CONST_TASK_STATE_FINISHED, ?CONST_TASK_STATE_UNFINISHED);
								{?CONST_TASK_TO_BUY, _,_,_,_,_} ->
									case clan_api:clan_id_get(Player#player.uid) of
										0 ->
											State0;
										_ ->
											?IF(State0 =:= ?CONST_TASK_STATE_UNFINISHED ,?CONST_TASK_STATE_FINISHED, State0)
									end;
								_ ->
									State0
							end;
						_ ->
							State0
					end,
				[UserTask#user_task{state=State}|Acc]
		end, 
	Tasks2 =lists:foldl(F, [], Tasks),
	role_api_dict:tasks_set(AllTask#tasks{tlist=Tasks2}),
	Player.

%%　检查策划数值改变
check_change(Lv) ->
	Tasks = role_api_dict:tasks_get(),
	#tasks{tlist=TList,taskclist=TasksC}=Tasks,
	EtsTasks = ets:tab2list(?ETS_TASK),
	LvAll = [LvTasks || {LvEts,LvTasks} <- EtsTasks, LvEts>=Lv],
	LvAllTask = lists:append(LvAll),
	Fun = fun(Id,Acc) ->
				  case data_task:get(Id) of
					  #d_task{lv=TLv,pre=0} ->
						  case TLv =< Lv of
							  ?true ->
								  case lists:member(Id, TasksC) of
									  ?true ->
										  Acc;
									  _ ->
										  Ut = #user_task{id=Id,seconds=util:seconds(),state=2},
										  [Ut|Acc]
								  end;
							  _ ->
								  Acc
						  end;
					  #d_task{lv=TLv,pre=Pre} ->
						  case TLv =< Lv of
							  ?true ->
								  case lists:member(Id, TasksC) of
									  ?true ->
										  Acc;
									  _ ->
										  case lists:member(Pre, TasksC) of
											  ?false ->
												  Acc;
											  _ ->
												  case lists:keyfind(Id, #user_task.id, TList) of
													  ?false ->
														  Ut = #user_task{id=Id,seconds=util:seconds(),state=2},
														  [Ut|Acc];
													  _ ->
														  Acc
												  end
										  end
								  end;
							  _ ->
								  Acc
						  end;
					  _ ->
						  Acc
				  end
		  end,
	TList2 = lists:foldl(Fun, TList, LvAllTask),
	Tasks#tasks{tlist=TList2}.

%% return : boolean()
check_copy(Tasks, TaskID) ->
	Pred = fun(#user_task{id = ID, state = ?CONST_TASK_STATE_UNFINISHED}) ->
				   Sub = ID - TaskID * 10,
				   Sub >= 0 andalso Sub =< 3;
			  (#user_task{}) ->
				   ?false
		   end,
	lists:any(Pred, Tasks).

init(Player) ->
	Tlists = task_mod:init(),
	{Player,#tasks{tlist=Tlists,taskclist=[]}}.

	
init_task_data() ->
	task_mod:init_task_data().

accept(Player,TaskId) ->
	task_mod:accept(Player,TaskId).

drop(Player, TaskID) ->
	task_mod:drop(Player, TaskID).

submit(Player, TaskID, Arg) ->
	task_mod:submit(Player, TaskID, Arg).

do_check(Player, TargetT, TargetV) ->
	task_mod:do_check(Player, ?CONST_TASK_TARGET_COPY, TargetV).

refresh(Player) ->
	task_mod:refresh(Player). 

check(Player, Target, Value) ->
	task_mod:check(Player, Target, Value).

%% return : void()
check_cast(TargetT, Value) ->
	util:pid_send(self(), task_mod, check_cb, [TargetT, Value]).

check_cast(Uid, TargetT, Value) ->
	util:pid_send(Uid, task_mod, check_cb, [TargetT, Value]).



%% 充值 回调
%% 返回:Player
pay(Player,_RmbTotal)-> Player.

%% 检查某个任务是否已完成提交(包括主线支线) return : boolean()
is_complete(TaskID) ->
	#tasks{taskclist=TaskC} = role_api_dict:tasks_get(),
	lists:member(TaskID, TaskC).

	
%%
%% Local Functions
%%

msg(?P_TASK_DATA=MsgID, [UserTasks]) when is_list(UserTasks) ->
	iolist_to_binary([msg(MsgID, [UserTask])||UserTask <- UserTasks]);

msg(?P_TASK_DATA=MsgID, [#user_task{id = Id, state = State, value = Value}]) 
  when State =:= ?CONST_TASK_STATE_UNFINISHED orelse State =:= ?CONST_TASK_STATE_FINISHED 
		   orelse State =:= ?CONST_TASK_STATE_ACCEPTABLE orelse State =:= ?CONST_TASK_STATE_ACTIVATE ->
	case data_task:get(Id) of
		#d_task{type = Type, target_t = TargetT, target_v = TargetV} ->
			case State =/= ?CONST_TASK_STATE_ACTIVATE orelse Type =:= ?CONST_TASK_TYPE_MAIN of
				?true ->
					case TargetT of
						?CONST_TASK_TARGET_TALK ->% 对话
							BinData = app_msg:encode([{int16,1},{?int32u,Id},{?int8u,State},{?int8u,TargetT}]),
							app_msg:msg(MsgID, BinData);
						?CONST_TASK_TARGET_KILL ->% 杀怪
							case TargetV of
								{_Scenes, IdCountL} ->
									Acc0 = app_msg:encode([{int16,1},{?int32u,Id},{?int8u,State},{?int8u,TargetT},
														   {?int16u,length(IdCountL)}]),
									BinData = lists:foldl(fun({MID,Max}, Acc) ->
																  Count = 
																	  case lists:keyfind(MID, 1, Value) of
																		  {_, Count0} ->
																			  Count0;
																		  ?false ->
																			  0
																	  end,
																  Bin0 = app_msg:encode([{int16,1},{?int16u, MID},{?int8u, Count},{?int8u, Max}]),
																  <<Acc/binary, Bin0/binary>>
														  end, Acc0, IdCountL),
									app_msg:msg(MsgID, BinData);
								_ ->
									<<>>
							end;
						?CONST_TASK_TARGET_COPY ->
							case TargetV of
								{CopyId, MaxCount} ->
									Bin = app_msg:encode([{int16,1},{?int32u,Id},{?int8u,State},{?int8u,TargetT},{?int16u,CopyId},
														  {?int16u,?IF(is_integer(Value), Value, 0)},{?int16u,MaxCount}]),
									app_msg:msg(MsgID, Bin);
								_ ->
									<<>>
							end;
						?CONST_TASK_TARGET_OTHER ->
							{OtherId, Value1, Value2, Value3, Value4, Value5} = TargetV,
							Bin = app_msg:encode([{int16,1},{?int32u,Id},{?int8u,State},{?int8u,TargetT},
												  {?int16u,OtherId},{?int32,Value1},{?int32,Value2},
												  {?int32,Value3},{?int32,Value4},{?int32,Value5}]),
							app_msg:msg(MsgID, Bin);
						_ ->
							<<>>
					end;
				?false ->
					<<>>
			end;
		_ ->
			<<>>
	end;

msg(?P_TASK_DATA, _) ->
	<<>>;

msg(?P_TASK_REMOVE=MsgID, [Id,Reason]) ->
	Bin = app_msg:encode([{?int32u,Id},{?int8u,Reason}]),
	app_msg:msg(MsgID, Bin);

msg(?P_TASK_TASK_DRAMA=MsgID, [DramaId]) ->
	Bin = app_msg:encode([{?int16u,DramaId}]),
	app_msg:msg(MsgID, Bin).


	
