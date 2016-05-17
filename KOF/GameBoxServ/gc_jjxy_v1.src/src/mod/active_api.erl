%% Author  : tanwer
%% Created: 2013-7-12
%% Description: TODO: Add description to active_api
-module(active_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-define(TIME_ADD,      3*60). % 数据处理容错 廷时时长

%%
%% Exported Functions
%%
-export([ %% test内部接口
		 active_data_done/3,
		 change_state/3,
		 check_activeid/4,
		 msg_active_data/5
		]).

-export([  % 活动面板	
		 clear_mysql/0,	 
		 
		 get_active_state/1,
		 get_active_data/1,
		 
		 close_active/1,
		 set_active/1,
		 temp_active/1,
		 do_active/3,
		 
		 msg_ok_active_data/1,
		 msg_data/3
		 ]).

-export([	%　活跃度 活动入口
		 decode_link/1,
		 encode_link/1,
		 init_link/1,
		 refresh/1,
		 
		 ask_rewards/2,
		 check_link/2,
		 check_link_cb/2,
		 get_link_data/0,
		 
		 msg_ok_link_data/3,
		 msg_ok_get_rewards/1
		 ]).

%%_______________________________________________________________________________________________________  后台接口
%% 清除活动数据,重新读配置表
clear_mysql() ->
	ets:delete(?ETS_PUBLIC_RECORDS, ?CONST_PUBLIC_KEY_ACTIVE_CONFIG),
	SQL = <<"TRUNCATE `active_data`;">>,
	mysql_api:fetch(SQL),
	active_mod:ref_active_state().

%%　设置活动状态 -- 新增|修改  clear前有效	 活动ID,活动类型,   日期限制,      星期限制,    时间限制{时,分,秒,状态,参数}, 人物等级,?一直显示,?开启时主界面弹出入口图标
%%　active_api:set_active({4009,4,[{{2013,7,1},{2013,8,1}}],[6,7],[{17,53,59,3,30},{17,54,59,3,10},{17,55,59,2,1},{17,58,59,1,30},{17,57,59,0,0}],30,1,1}).
set_active({ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}) ->
	active_srv:set_active_cast({ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}).

%%　设置活动状态 -- 临时加开  一次有效	 活动ID,活动类型,   日期限制,      星期限制,    时间限制{时,分,秒,状态,参数}, 人物等级,?一直显示,?开启时主界面弹出入口图标
%%　active_api:temp_active({4009,4,[{{2013,7,1},{2013,8,1}}],[6,7],[{17,53,59,3,30},{17,54,59,3,10},{17,55,59,2,1},{17,58,59,1,30},{17,57,59,0,0}],30,1,1}).
temp_active({ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}) ->
	active_srv:temp_active_cast({ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}).
%%_________________________________________________________________________________________________________________	

%% 
%% Api
%% 

%%　查询活动状态
%% return: ?CONST_ACTIVITY_STATE_XXX
get_active_state(ActiveId) ->
	case ets:lookup(?ETS_ACTIVE_STATE, ActiveId) of 
		[{ActiveId,State}|_] ->
			State;
		_ ->
			?CONST_ACTIVITY_STATE_OVER 
	end.

%%　活动数据查询
%%　?null::活动不存在  | [0,0] 活动常开 | [Seconds,Seconds2]
%%　return:?null　| [Start,End]
get_active_data(ActiveId) ->
	case active_mod:get_active_data(ActiveId) of
		?null -> ?null; % 无此活动
		[1,_RoleLv] -> [0,0]; % 活动常开
		[[{Seconds,1,_Time},{Seconds2,0,0}],_RoleLv] -> [Seconds,Seconds2] % 活动开始与结束时间
	end.


%% 自主结束活动
close_active(ActyID) ->
	?MSG_ECHO("============= ~w~n",[ActyID]),
	active_srv:close_active_cast(ActyID),
	do_active(ActyID,0,0).

%%
%% local_fun
%%
%%　活动状态改变通知
do_active(ActyID,State,Arg) ->
	case State of
		?CONST_ACTIVITY_STATE_SIGN ->		%% 活动开启前报名 
			State2=?IF(Arg=:=1,?CONST_ACTIVITY_STATE_SIGN,?CONST_ACTIVITY_STATE_NOT_OPEN),
			ets:insert(?ETS_ACTIVE_STATE, {ActyID,State2});
		?CONST_ACTIVITY_STATE_ADVANCE ->	%% 活动开启前通知 
			?ok;
		?CONST_ACTIVITY_STATE_ENTRANCE ->	%%　提前入场
			ets:insert(?ETS_ACTIVE_STATE, {ActyID,State});
		?CONST_ACTIVITY_STATE_START ->		%% 活动开启
			ets:insert(?ETS_ACTIVE_STATE, {ActyID,State});
		?CONST_ACTIVITY_STATE_OVER ->		%% 活动结束总控
			ets:insert(?ETS_ACTIVE_STATE, {ActyID,State});
		_ ->
			?MSG_ERROR("{ActyID, State, Arg} : ~p~n", [{ActyID, State, Arg}])
	end,
	change_state(ActyID,State,Arg),
	BinMsg = msg_data(ActyID,State,Arg),
	chat_api:send_to_all(BinMsg),
%% 	?MSG_ERROR("{ActyID, State, Arg} : ~p~n", [{ActyID, State, Arg}]),
	active_data_done(ActyID,State,Arg).



%%　活动数据处理
%%　return:BinMsg
%%　ActyID　＝　?CONST_ACTIVITY_
%% active_data_done(ActyID,?CONST_ACTIVITY_STATE_SIGN,1) ->			%% 开始报名
%% active_data_done(ActyID,?CONST_ACTIVITY_STATE_SIGN,0) ->			%% 结束报名
%% active_data_done(ActyID,?CONST_ACTIVITY_STATE_ADVANCE,Arg) ->	%% 活动通知  		Arg::提前时间 30分钟 10分钟。。。
%% active_data_done(ActyID,?CONST_ACTIVITY_STATE_ENTRANCE,Arg) ->	%%　提前入场  		Arg::提前时间 1分钟 。。。
%% active_data_done(ActyID,?CONST_ACTIVITY_STATE_START,Arg) ->		%% 活动开启  		Arg::活动时长 30分钟 。。。
%% active_data_done(ActyID,?CONST_ACTIVITY_STATE_OVER,Arg) -> 		%% 活动结束		Arg：：0

%%　 世界BOSS
active_data_done(ActiveId, State, Arg) 
  when ActiveId==?CONST_ACTIVITY_WORLD_BOSS 
	   orelse ActiveId==?CONST_ACTIVITY_WORLD_BOSS_TWO->
	case State of
		?CONST_ACTIVITY_STATE_ADVANCE->
			case Arg==1 of
				?true->
					BinMsg=broadcast_api:msg_broadcast_world_rey();
				_->
					BinMsg=broadcast_api:msg_broadcast_world_start(Arg)
			end,
			chat_api:send_to_all(BinMsg);
		?CONST_ACTIVITY_STATE_START ->
			world_boss_api:boss_monster(Arg);
		?CONST_ACTIVITY_STATE_OVER ->
			world_boss_api:boss_die_exit();
		_ ->
			?ok
	end;
%%　 世界BOSS 2
active_data_done(?CONST_ACTIVITY_WORLD_BOSS_TWO, State, Arg) ->
	case State of
		?CONST_ACTIVITY_STATE_START ->
			world_boss_api:boss_monster(Arg);
		?CONST_ACTIVITY_STATE_OVER ->
			world_boss_api:boss_die_exit();
		_ ->
			?ok
	end;

%%　格斗之王预赛
active_data_done(?CONST_ACTIVITY_WRESTLE_YUSAI, State, Arg) ->
	case State of
		?CONST_ACTIVITY_STATE_SIGN -> 
			case Arg of
				0 ->
					?ok;
%% 					wrestle_api:group();
				_ -> ?ok
			end;
		?CONST_ACTIVITY_STATE_START ->
			?ok;
%% 			wrestle_api:control_preliminary();
		_ ->
			?ok
	end;	

%%　格斗之王决赛
active_data_done(?CONST_ACTIVITY_WRESTLE, State, _Arg) ->
	case State of
		?CONST_ACTIVITY_STATE_START ->
			?ok;
%% 			wrestle_api:control_final();
		_ ->
			?ok
	end;	


active_data_done(_ActyID,_State, Arg) -> ?ok.
%% active_data_done(_ActyID,State,Arg) ->
%% 	case State of
%% 		?CONST_ACTIVITY_STATE_SIGN ->
%% 			case Arg of
%% 				0 -> ?ok;
%% 				_ -> ?ok
%% 			end;
%% 		?CONST_ACTIVITY_STATE_ENTRANCE ->
%% 			?ok;
%% 		?CONST_ACTIVITY_STATE_START ->
%% 			?ok;
%% 		?CONST_ACTIVITY_STATE_OVER ->
%% 			?ok
%% 	end.

















%% local_fun
%%　改变活动状态
change_state(ActyID,State, Arg) -> 
	case State of
		?CONST_ACTIVITY_STATE_ADVANCE ->
			?ok;
		?CONST_ACTIVITY_STATE_ENTRANCE ->
			change_state(ActyID,?CONST_ACTIVITY_STATE_START, Arg);
		?CONST_ACTIVITY_STATE_SIGN ->
			case Arg of
				1 -> %%　开始报名
					change_state(ActyID,?CONST_ACTIVITY_STATE_START, Arg);
				_ ->
					change_state(ActyID,?CONST_ACTIVITY_STATE_NOT_OPEN, Arg)
			end;
		_ ->
			case ets:lookup(?ETS_PUBLIC_RECORDS, ?CONST_PUBLIC_KEY_ALL_ACTIVE) of
				[{_, AllActive}|_] ->
					check_activeid(ActyID,State,AllActive,[]);
				_ ->
					AllAct	= active_mod:get_allactive(),
					AllActive = active_mod:fun_all_active(AllAct),
					check_activeid(ActyID,State,AllActive,[])
			end
	end.

check_activeid(_ActyID,_State0,[],Acc) -> 
	NewAll = lists:keysort(3, Acc),
	ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_ALL_ACTIVE,NewAll});
check_activeid(ActyID,State0,AllActive,Acc) ->
	Now = util:seconds(),
	case lists:keytake(ActyID, 1, AllActive) of
		{value, {ActyID,IsNew,StartT,EndT,State}, AllActive2} ->
			case Now =< EndT+?TIME_ADD of
				?true ->
					NewAll = lists:keysort(3, [{ActyID,IsNew,StartT,EndT,State0}|AllActive2]++Acc),
					ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_ALL_ACTIVE,NewAll}),
					BinMsg = case State0 of 
								 ?CONST_ACTIVITY_STATE_ENTRANCE -> 
									 msg_active_data(ActyID, IsNew, StartT, EndT, ?CONST_ACTIVITY_STATE_START);
								 ?CONST_ACTIVITY_STATE_ADVANCE ->  
									 <<>> ;
								 R -> 
									 msg_active_data(ActyID, IsNew, StartT, EndT, R)
							 end,
					chat_api:send_to_all(BinMsg);
				_ ->
					check_activeid(ActyID,State0,AllActive2,[{ActyID,IsNew,StartT,EndT,State}|Acc])
			end;
		_ -> 
			?skip
	end.


%% 
%% msg
%%

% 活动数据返回 [30520]
msg_ok_active_data(ActiveMsg)->
	Rs	   = app_msg:encode([{?int8u,length(ActiveMsg)}]),
	RsList = lists:foldl(fun({Id,IsNew,StartTime,EndTime,State},Acc) -> 
								 Bin = app_msg:encode([{?int16u,Id},{?int8u,IsNew},
													   {?int32u,StartTime},
													   {?int32u,EndTime},{?int8u,State}]),
								 <<Acc/binary,Bin/binary>>
						 end, Rs, ActiveMsg),
	app_msg:msg(?P_ACTIVITY_OK_ACTIVE_DATA, RsList).

% 活动数据 [30540]
msg_active_data(Id,IsNew,StartTime,EndTime,State)->
	RsList = app_msg:encode([{?int16u,Id},
							 {?int8u,IsNew},{?int32u,StartTime},
							 {?int32u,EndTime},{?int8u,State}]),
	app_msg:msg(?P_ACTIVITY_ACTIVE_DATA, RsList).

% 活动状态改变 [30501]
msg_data(ActiveId,State,Arg)->
    RsList = app_msg:encode([{?int16u,ActiveId},{?int8u,State},{?int32u,Arg}]),
    app_msg:msg(?P_ACTIVITY_DATA, RsList).









%% ----------------------------------------------------------------------------------------
%% ------------------------------------------------------------------------------------活跃度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% init
encode_link(ActiveLink) -> 
	ActiveLink.

decode_link(ActiveLink) ->
	ActiveLink.

init_link(Player) ->
	BaseData = data_active_link:get(),
	LinkData = [{Id,0,Alltimes,Vitality}||{Id,Alltimes,Vitality} <-BaseData],
	ActiveLink = #active_link{date=util:date(),link_data=LinkData},
	{Player,ActiveLink}.

%% 每日零点刷新
refresh(Socket) ->
	#active_link{link_data=ActiveData,rewards=Rewards} = active_api:get_link_data(),
	Vitality = lists:sum([V||{_,T,All,V} <- ActiveData,T >= All]),
	BinMsg = active_api:msg_ok_link_data(Vitality, ActiveData, Rewards),
	app_msg:send(Socket, BinMsg).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  api
%% 检查活动
check_link(Uid,Id) ->
	util:pid_send(Uid, ?MODULE, check_link_cb, Id).

check_link_cb(#player{uid=Uid}=Player,Id) ->
	ActiveLink = get_link_data(),
	#active_link{link_data=LinkData,rewards=RewardsOk} = ActiveLink,
	case lists:keytake(Id, 1, LinkData) of
		{value, {Id,Times,Alltimes,VitalityOne}, TupleList2} ->
			LinkData2 = 
				case Times>=Alltimes of
					?true ->
						[{Id,Alltimes,Alltimes,VitalityOne}|TupleList2];
					_ ->
						LinkDataNew = [{Id,Times+1,Alltimes,VitalityOne}|TupleList2],
						check_have_rewards(Uid, LinkDataNew, RewardsOk),
						LinkDataNew
				end,
			role_api_dict:link_set(ActiveLink#active_link{link_data=LinkData2});
		_ ->
			?ok
	end,
	Player.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%　local_fun
%% 请求领取奖励
%%　{?error,Error}　｜　{?ok, BinMsg};
ask_rewards(Player,Id) ->
	ActiveLink = get_link_data(),
	#active_link{link_data=ActiveData,rewards=Rewards} = ActiveLink,
	case lists:member(Id, Rewards) of
		?true ->
			{?error,?ERROR_KOF_TIPS_REGET};
		_ ->
			case data_active_link_rewards:get(Id) of
				#link_rewards{vitality=BaseV,rewards_count=Count,rewards_id=GoodsId} ->
					Vitality = lists:sum([V||{_,T,All,V} <- ActiveData,T>=All]),
					case Vitality>=BaseV of
						?true ->
							LogSrc = [ask_rewards,[],<<"领取活跃度奖励">>],
							case bag_api:goods_set(LogSrc, Player, [{GoodsId, Count}]) of
								{?ok,Player2,GoodBin,Bin1} ->
									NewRewards = [Id|Rewards],
									role_api_dict:link_set(ActiveLink#active_link{rewards=NewRewards}),
									Bin2 = msg_ok_get_rewards(Id),
%% 									check_have_rewards(Player#player.uid, ActiveData, NewRewards),
									{?ok, Player2, <<GoodBin/binary,Bin1/binary,Bin2/binary>>};
								{?error,Error} ->
									{?error,Error}
							end;
						_ ->
							{?error,?ERROR_KOF_TIPS_LOW_VITALITY}
					end;
				_ ->
					{?error,?ERROR_KOF_TIPS_REGET}
			end
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% local_mod
%% 取活动数据
get_link_data() ->
	ActiveLink = role_api_dict:link_get(),
	#active_link{date=Date} = ActiveLink,
	Now = util:date(),
	case Date =:= Now of
		?true ->
			ActiveLink;
		_ ->
			BaseData = data_active_link:get(),
			LinkData = [{Id,0,Alltimes,Vitality}||{Id,Alltimes,Vitality} <-BaseData],
			ActiveLink2 = #active_link{date=Now,link_data=LinkData,rewards=[]},
			role_api_dict:link_set(ActiveLink2),
			ActiveLink2
	end.

%% 检查是否可以领取奖励
check_have_rewards(Uid, ActiveData, RewardsOk) ->
	NewGetLv = ?IF(RewardsOk =:= [], 1, lists:max(RewardsOk) + 1),
	case data_active_link_rewards:get(NewGetLv) of
		#link_rewards{vitality=BaseV} ->
			Vitality = lists:sum([V||{_,T,All,V} <- ActiveData,T>=All]),
			case Vitality>=BaseV of
				?true ->
					logs_api:action_notice(Uid, ?CONST_LOGS_1117, [], [NewGetLv]);
				_ ->
					?ok
			end;
		_ ->
			?ok
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  msg
% 活跃度数据返回 [30620]
msg_ok_link_data(Vitality,ActiveData,Rewards)->
	Rs1		= app_msg:encode([{?int32u,Vitality},{?int16u,length(ActiveData)}]),
	RsList1	= lists:foldl(fun({ActiveId,OkTimes,AllTimes,ActiveVitality},Acc) ->
								  Bin = app_msg:encode([{?int16u,ActiveId},
														{?int8u,OkTimes},{?int8u,AllTimes},
														{?int8u,ActiveVitality}]),
								  <<Acc/binary,Bin/binary>>
						  end, Rs1, ActiveData),
	Rs2		= app_msg:encode([{?int16u,length(Rewards)}]),
	RsList2	= lists:foldl(fun(ID,Acc) ->
								  Bin = app_msg:encode([{?int8u,ID}]),
								  <<Acc/binary,Bin/binary>>
						  end, Rs2, Rewards),
	app_msg:msg(?P_ACTIVITY_OK_LINK_DATA, <<RsList1/binary,RsList2/binary>>).

% 领奖状态返回 [30660]
msg_ok_get_rewards(Id)->
    RsList = app_msg:encode([{?int8u,Id}]),
    app_msg:msg(?P_ACTIVITY_OK_GET_REWARDS, RsList).

