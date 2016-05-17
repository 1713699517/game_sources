%% Author: acer
%% Created: 2012-12-28
%% Description: TODO: Add description to defend_book_api.
-module(wrestle_mod).

%% --------------------------------------------------------------------
%% Include files
			
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
-export([
		 %%%%%%%%%%%%%%%%%%%%%%%%%test%%%%%%%%%%%%%%%%%%%%%%%%%
		 final_group_handle/0,
		 group_handle/0,
		 divide/1,
		 enter/2,
		 get_out_cb/2,
		 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 
	     control_preliminary_handle/0,
		 turn_start_ys_cb/2,
		 mon_war_ys_cb/1,
		 
		 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%api模块回调%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 get_turns_number/1,
		 get_next/2,
		 get_count/0,
		 get_list/0,
		 		 
		 %%%%%%%%%%%决赛控制接口%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         control_final_handle/0,         
		 enter_final/1,
		 update_final/1,
		 interval_final_reward/1,
		 %%%%%%%%%%%%进入场景回调%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 enter_cb/2,
		 enter_cb_only/2,
		 die_cb/2,
		 
		 fail_reduce_handle/1,
		
		 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		 book_handle/0,
		 app_cb/2,
		 clean_handle/0,
		 control_preliminary_test_handle/1,
		 control_preliminary_test_cb/1,
		 control_final_test_handle/1,
		 control_final_test_cb/1,
		 rew_handle/0
		 ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 预赛分组
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 报名结束后，进行分组，活动进程调用,预赛分组
group_handle() ->	
	case insert_book() of
		{?ok,Ulist} ->
			N     = get_count(),	
            {_,R} = get(N,Ulist),        %R: [[#wrestle{},#wrestle{}]|...]
			R2    = group_idx(lists:reverse(R),[],1),			            
			R3    = lists:append(R2),
			R4    = lists:keysort(#wrestle.uid, R3),
			ets:delete_all_objects(?ETS_WRESTLE),
			ets:insert(?ETS_WRESTLE, R4);
		 _ -> 			
			?skip
	end,
	init_preliminary().

%% 初始化预赛
init_preliminary() ->
	case active_api:get_active_data(?CONST_ACTIVITY_WRESTLE_YUSAI) of
		[Seconds,_Seconds2] ->
			case  Seconds == 0 of 
				?true ->
					?skip;
				_ ->
					Max   = max_turn_ys(),  %% 得到最大的轮次
					Time  = iterater_turn(Seconds,?CONST_WRESTLE_ROUND_TIME,1,Max,[]),  
					Time2 = lists:keysort(1, Time),
					init_preliminary_data(Time2)
			end;
		_ ->
			?skip
	end.	

%% 将每一轮的时间计算出来
iterater_turn(_,_,_,0,Acc) ->
	Acc;
iterater_turn(StartTime,TurnTime,Turn,Count,Acc) ->
	Turn2 = Turn + 1,
	iterater_turn(StartTime + TurnTime,TurnTime,Turn2,Count-1,[{Turn,StartTime,StartTime + TurnTime}|Acc]).

%% 初始化预赛数据
init_preliminary_data(Time) ->
	List = lists:seq(6000, 6064),
	WrestleCon = #wrestle_con{idx = ?CONST_ACTIVITY_WRESTLE_YUSAI,state = ?CONST_WRESTLE_NOT_START,time = Time,drop = List,value = 1},
	ets:delete(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI),
	ets:insert(?ETS_WRESTLE_CONTROL, WrestleCon).

%% 筛选人数
insert_book() ->
	List = wrestle_mod:get_list(),
	case length(List) >= ?CONST_WRESTLE_GROUNP_COUNT of
		?true ->			
			List3 = case length(List) >= ?CONST_WRESTLE_COUNT of
						 ?true ->
							 List2 = lists:keysort(#wrestle.areana_rank, List),
							 lists:sublist(List2, ?CONST_WRESTLE_COUNT);
						 _ ->
							 List
					 end,
			ets:delete_all_objects(?ETS_WRESTLE),
			ets:insert(?ETS_WRESTLE, List3),
			{?ok,List3};
		_ ->
			?skip
	end.
		
%% 分组索引
group_idx([],Acc,_)->Acc;
group_idx([L|R],Acc,Group)->
	Fun = fun(Wrestle,{Idx,UidIdxs})->
				UidIdxs2=[Wrestle#wrestle{group_index=Idx}|UidIdxs],
				{Idx+1,UidIdxs2}
		end,
	{_,L2} = lists:foldl(Fun,{1,[]},L),
	L3 = [NewWrestle#wrestle{group_id=Group}||NewWrestle<-L2],
	group_idx(R,[L3|Acc],Group+1).
	
%% 分组选人
%% reg:N 人数:63 || Ulist [id,id,id,id]
%% [[],[],[]]
get(N,Ulist) ->
   List = divide(N),
   Fun = fun(Item,{Key,L}) ->
		     L2 = lists:sublist(Ulist, Key, Item),			 
		     Next = Key + Item,
		     {Next,[L2|L]}
		 end,
   lists:foldl(Fun, {1,[]}, List).

%% 自动分组，分出每组所需要的人数
%% reg: N||人数:63
%% return: [8,8,8,8,8,8,8,7]
divide(N) ->
	%NC = N div ?CONST_WRESTLE_GROUNP_COUNT,
    NC = trunc(N/?CONST_WRESTLE_GROUNP_COUNT),
	NC2 = lists:duplicate(?CONST_WRESTLE_GROUNP_COUNT,NC),
	NR = N rem ?CONST_WRESTLE_GROUNP_COUNT,
	war_api:b(NC2,NR,[]).   		

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 决赛分组接口
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 决赛分组
final_group_handle() ->
	FinalList         = final_get(),
	Num               = length(FinalList),
	TopNum            = Num div 2,
	TopLeftNum        = TopNum div 2,
	TopList           = lists:sublist(FinalList,TopNum),
	TopList2          = final_set(?CONST_WRESTLE_SHANGBANQU,TopList,TopLeftNum),	
	LowNum            = Num - TopNum,
	LowLeftNum        = LowNum div 2,
	LowList           = FinalList -- TopList,
	LowList2          = final_set(?CONST_WRESTLE_XIABANQU,LowList,LowLeftNum),
	ets:delete_all_objects(?ETS_WRESTLE_FINAL),
	ets:insert(?ETS_WRESTLE_FINAL, TopList2 ++ LowList2),
	init_final().

%% 初始化决赛
init_final()->
	case active_api:get_active_data(?CONST_ACTIVITY_WRESTLE) of
		[Seconds,_Seconds2] ->
			case  Seconds == 0 of 
				?true ->
					?skip;
				_ ->
					Time  = iterater_turn(Seconds,?CONST_WRESTLE_ROUND_TIME,1,5,[]), 
					Time2 = lists:keysort(1, Time),
					init_final_data(Time2)
			end;
		_ ->
			?skip
	end.

%% 初始化决赛数据
init_final_data(Time)->
	List = lists:seq(6000, 6064),
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI) of
		[#wrestle_con{drop = DropList}|_] ->
			List2 = lists:append(List, DropList),
	        WrestleCon = #wrestle_con{idx = ?CONST_ACTIVITY_WRESTLE,value = 0,state = ?CONST_WRESTLE_JUESAIJINGXINGZHONG,time = Time,drop = List2}, 
	        ets:delete(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI), %% 删除预赛数据
            ets:insert(?ETS_WRESTLE_CONTROL,WrestleCon);
		_->
			WrestleCon = #wrestle_con{idx = ?CONST_ACTIVITY_WRESTLE,value = 0,state = ?CONST_WRESTLE_JUESAIJINGXINGZHONG,time = Time,drop = List}, 
	        ets:delete(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI), %% 删除预赛数据
            ets:insert(?ETS_WRESTLE_CONTROL,WrestleCon)
	end.
	
%% 决赛设置索引
final_set(Type,List,LeftNum) ->
	ListLeft       = lists:sublist(List, LeftNum),
	ListRight      = List -- ListLeft,
	{ListLeft2,_}  = final_set_index(Type,ListLeft,1),
	{ListRight2,_} = final_set_index(Type,ListRight,9),
	ListLeft2 ++ ListRight2.

%% 取得参加决赛的人
final_get() ->
	List  = get_list(),
	List2 = lists:keysort(#wrestle.score, List),
	List3 = lists:reverse(List2),
	List4 = lists:sublist(List3, ?CONST_WRESTLE_FINAL_COUNT),
	List5 =[{Uid,Name}||#wrestle{uid = Uid,name = Name}<-List4],
	lists:keysort(1, List5).

%% 设置参加决赛的索引
final_set_index(Type,List,Key) ->
	Fun = fun({Uid,Name},{Acc,Index}) ->
				  {[#wrestle_final{type = Type,index = Index,uid = Uid,name = Name,is_fail = ?false}|Acc],Index + 1}
		  end,
	lists:foldl(Fun, {[],Key}, List).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 预赛控制
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 预赛控制
control_preliminary_handle() ->
	Max   = max_turn_ys(),                  %% 得到最大的轮次
    set_state(?CONST_WRESTLE_YUSAIZHONG,?false),
	timer:apply_after(?CONST_WRESTLE_BEFORE_TIME * 1000, ?MODULE, turn_start_ys_cb, [Max,1]).

%% 轮完了,预赛结束了,这里可以做预赛结束的事情
turn_start_ys_cb(0,_Turn) ->
	wrestle_api:final_group(),
	set_state(?CONST_WRESTLE_YUSAIJIESU,?false),
	exit_preliminary(?CONST_WRESTLE_GROUNP_COUNT);
turn_start_ys_cb(Max,1) ->
	turn_start_ys_item(?CONST_WRESTLE_GROUNP_COUNT,1),         %% 一轮每组
	timer:apply_after(?CONST_WRESTLE_ROUND_TIME * 1000, ?MODULE, turn_start_ys_cb, [Max-1,2]);  %% 多少秒打一轮 
turn_start_ys_cb(Max,Turn) ->        %% 预赛开始从第一轮开始
	turn_start_ys_item(?CONST_WRESTLE_GROUNP_COUNT,Turn),      %% 一轮每组
	update_preliminary_turns(),      %% 更新轮次
	timer:apply_after(?CONST_WRESTLE_ROUND_TIME * 1000, ?MODULE, turn_start_ys_cb, [Max-1,Turn+1]).  %% 多少秒打一轮 

%% 一轮每组都处理完了
turn_start_ys_item(0,_Turn) ->
	?ok;
turn_start_ys_item(Gid,Turn) ->
	GroupTurnList  = get_turns(Gid,Turn),           %获取这一组这一轮要战斗的Index列表[{IndexA,IndexB}|...]
    GroupTurnList2 = get_group_do(Gid,GroupTurnList,[]),
	timer:apply_after(?CONST_WRESTLE_ACTIVE_TIME * 1000, ?MODULE, mon_war_ys_cb, [GroupTurnList2]),   %% 多少秒后更新数据
	turn_start_ys_item(Gid - 1,Turn).

%% 获取这一组这一轮要战斗的Index列表[{IndexA,IndexB}|...]
get_turns(GroupId,Turn) ->
	Count  	  = get_count(),
	Indexs    = war_api:b(Count),
	TurnsList = lists:nth(GroupId, Indexs),
	case length(TurnsList) >= Turn of
		?true ->
			lists:nth(Turn, TurnsList);
		_ ->
			[]
	end.

%% 拉人进去
get_group_do(_Gid,[],Acc) ->
	Acc;
get_group_do(GroupId,[{IndexA,IndexB}|T],Acc) ->
	Uid   = get_uid(GroupId,IndexA),
	ToUid = get_uid(GroupId,IndexB),
	invited(Uid,ToUid,?false),
	get_group_do(GroupId,T,[{Uid,ToUid}|Acc]).

%% 决赛更新对手
preliminary_insert_uid(Uid,ToUid) ->
	preliminary_insert_uid2(Uid,ToUid),
	preliminary_insert_uid2(ToUid,Uid).
preliminary_insert_uid2(Uid,ToUid) ->
	case ets:lookup(?ETS_WRESTLE, Uid) of
		[#wrestle{uid = Uid} = Wrestle|_]->
			ets:insert(?ETS_WRESTLE, Wrestle#wrestle{foe_uid = ToUid});
		_ ->
			?skip
	end.

%% 监控预赛
mon_war_ys_cb(GroupTurnList) ->
	mon_war_ys(GroupTurnList),
	get_out_robot(GroupTurnList).
mon_war_ys([]) ->
	?skip;
mon_war_ys([{Uid,ToUid}|GroupTurnList]) ->
	mon_war_harm_ys(Uid,ToUid),
	mon_war_ys(GroupTurnList).
mon_war_harm_ys(Uid,ToUid) ->
	case ets:lookup(?ETS_WRESTLE, Uid) of
		[#wrestle{is_handle = ?false,areana_rank = Rank}|_] ->
			[#wrestle{is_handle = ?false,areana_rank = Rank2}|_] = ets:lookup(?ETS_WRESTLE, ToUid),
			case scene_api:ko_hps_get([Uid,ToUid]) of
				[] ->
					wrestle_srv:fail_reduce_cast(Uid);
				[{Uid,_HarmA}]->
					wrestle_srv:fail_reduce_cast(ToUid);
				[{ToUid,_HarmB}] ->
					wrestle_srv:fail_reduce_cast(Uid);
				[{Uid,HarmA},{ToUid,HarmB}]->
					case HarmA - HarmB of
						HarmInd when HarmInd > 0->
							wrestle_srv:fail_reduce_cast(ToUid);
						0 ->
							case Rank - Rank2 of
								RankInt when RankInt > 0 ->
									wrestle_srv:fail_reduce_cast(ToUid);
								_ ->
									wrestle_srv:fail_reduce_cast(Uid)
							end;
						_ ->
							wrestle_srv:fail_reduce_cast(Uid)
					end
			end;
		_ ->
			wrestle_srv:fail_reduce_cast(Uid)
	end.

%% 拉人回程
get_out_robot(OnlineList)->
	[get_out(Uid,ToUid) || {Uid,ToUid} <- OnlineList].
get_out(Uid,ToUid) ->
    util:pid_send(Uid,?MODULE,get_out_cb,?null),
	util:pid_send(ToUid,?MODULE,get_out_cb,?null).
get_out_cb(Player,_)->
	case (Player#player.info)#info.map_type of
		?CONST_MAP_TYPE_CITY ->
			Player;
		_ ->
			Player2 = scene_api:enter_last_city(Player),
			Player2
	end.

%% 根据组Id和位置Id取Uid
get_uid(GroupId,Index) ->
	[Uid0] = ets:select(?ETS_WRESTLE,ets:fun2ms(fun(#wrestle{uid = Uid,group_id = GroupId0,group_index = GroupIndex0})
										   when GroupId0 == GroupId andalso GroupIndex0 == Index ->Uid end)),
	Uid0.

%% 拿到下一个对手
get_next(Uid,NowCount)->
	 Dname = get_next_name(Uid,NowCount),
	 Uid2  = get_next_uid(Uid,NowCount),
     {Uid2,Dname}.
get_next_name(Uid,NowCount) ->
	Duid = get_next_uid(Uid,NowCount),
	case ets:lookup(?ETS_WRESTLE, Duid) of
		[#wrestle{name = Name}|_] ->
			Name;
		_ ->		
			<<>>
	end.
get_next_uid(Uid,Turn) ->
	case ets:lookup(?ETS_WRESTLE, Uid) of
		[#wrestle{group_id = GroupId,group_index = Index}|_] ->
			List = get_turns(GroupId,Turn),
			ToIndex = get_next_index(List,Index),
			case ToIndex == Index of
				?true ->
					?CONST_WRESTLE_NO_MATCH_UID;
				_ ->
			       get_uid(GroupId,ToIndex)
			end;
	     _ ->
            ?CONST_WRESTLE_NO_MATCH_UID
	end.
get_next_index(List,Index)->
	Fun = fun({A,B},Acc) ->
				  case A == Index of
					  ?true ->
						  B;
					  _ ->
						  case B == Index of
							  ?true ->
								  A;
							  _ ->
								  Acc
						  end
				  end
		  end,
	lists:foldl(Fun, Index, List).



%% 每组总轮次
get_turns_number(GroupId) ->
	N      = get_count(),
    Indexs = war_api:b(N),
    length(lists:nth(GroupId, Indexs)).

%% 得到最大的轮次
max_turn_ys() ->
	Count = get_count(),
	List = war_api:b(Count),
	max_turn_ys(List,0).
max_turn_ys([],Max) ->
	Max;
max_turn_ys([H|T],Max) ->
	Count = length(H),
	case Count > Max of
		?true ->
			max_turn_ys(T,Count);
		_ ->
			max_turn_ys(T,Max)
	end.

%% 更新预赛的轮次
update_preliminary_turns() ->
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI) of
		[#wrestle_con{value = Value}|_] ->
			ets:update_element(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI, {#wrestle_con.value,Value + 1});
		_->		
			?skip
	end.

%% 预赛活动结束发送奖励
exit_preliminary(0) ->
	?skip;
exit_preliminary(GroupId0) ->
	RecvUids = ets:select(?ETS_WRESTLE, ets:fun2ms(fun(#wrestle{group_id = GroupId,uid = Uid}) when GroupId0 == GroupId -> Uid end)),
	reward_preliminary(RecvUids),
	exit_preliminary(GroupId0 - 1).

%% 发送奖励
reward_preliminary(RecvUids)->
	Fun = fun(RecvUid,Rank)->			
                Title = <<"格斗之王预赛奖励">>,
				GoodsList = data_wrestle_preliminary:get(Rank),
				Content = mail_api:get_content(3002,[Rank,GoodsList]),
				mail_api:send_mail_uids([RecvUid], Title, Content, GoodsList, []),
				Rank + 1
 		end,
	lists:foldl(Fun,1,RecvUids).

%% 更新战斗分数
update_score_ys(Suid,Fuid) ->
	case ets:lookup(?ETS_WRESTLE, Suid) of
		[#wrestle{success = Success0,score = SuccessScore} = Wrestle|_] ->
			SuidScore  = SuccessScore + ?CONST_WRESTLE_SUCCESS_SCORE,
			Success    = Success0 + 1,
			case ets:lookup(?ETS_WRESTLE, Fuid) of
				[#wrestle{fail = Fail0,score = FailScore} = Wrestle2|_] ->		
					FuidScore  = FailScore + ?CONST_WRESTLE_FAIL_SCORE,
					Fail       = Fail0 + 1,
					ets:insert(?ETS_WRESTLE, Wrestle#wrestle{score = SuidScore,success  = Success,foe_uid = 0,is_handle = ?true}),
					ets:insert(?ETS_WRESTLE, Wrestle2#wrestle{score = FuidScore,fail = Fail,foe_uid = 0,is_handle = ?true});			
				_ ->
					ets:insert(?ETS_WRESTLE, Wrestle#wrestle{score = SuidScore,success  = Success,foe_uid = 0,is_handle = ?true})
			end;
		_ ->
			?skip
	end.

%% 失败处理
fail_reduce_handle(Uid) ->
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI) of
		[#wrestle_con{}|_] -> % 预赛失败处理
			case ets:lookup(?ETS_WRESTLE,Uid) of
				[#wrestle{is_handle = ?true}|_] ->					
					?skip;
				[#wrestle{foe_uid = FoeUid,is_handle = ?false}|_] ->
					broacast_die(FoeUid, Uid),
		            update_score_ys(FoeUid, Uid);
				_ ->					
					?skip
			end;
		_->   % 决赛失败处理
			case ets:lookup(?ETS_WRESTLE_FINAL, Uid) of
				[#wrestle_final{is_handle=?true}|_] ->
					?skip;
				[#wrestle_final{to_uid = ToUid,is_handle=?false} = WrestleFinal|_] ->
					broacast_die(ToUid, Uid),
					FailTurn = get_final_turns_now(),
					ets:insert(?ETS_WRESTLE_FINAL, WrestleFinal#wrestle_final{to_uid = 0,is_handle = ?true,is_fail = ?true,fail_turn = FailTurn}),
					case ets:lookup(?ETS_WRESTLE_FINAL, ToUid) of
						[#wrestle_final{} = WrestleFinal2|_] ->
							ets:insert(?ETS_WRESTLE_FINAL, WrestleFinal2#wrestle_final{to_uid = 0,is_handle = ?true});
						_->
							?skip
					end;
			    _ ->
					?skip
			end
	end.

%% 广播死亡协议接口
broacast_die(Uid,ToUid) ->
	util:pid_send(Uid,?MODULE,die_cb,ToUid),
	util:pid_send(ToUid,?MODULE,die_cb,ToUid).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 决赛控制
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 决赛控制
control_final_handle() ->
	timer:apply_after(?CONST_WRESTLE_BEFORE_TIME * 1000, ?MODULE, enter_final, [4]).               %% 每隔一分钟 进入
%%     timer:apply_after(?CONST_WRESTLE_ROUND_TIME * 1000, ?MODULE, interval_final_reward, [1]).      %% 每隔240秒 发奖励
			
%% 决赛开始接口
enter_final(0) ->    %% 第五轮决赛
    ?MSG_ECHO("==============================~n",[]),
	[TopUid|_] = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_SHANGBANQU,uid = Uid,is_fail = ?false}) -> Uid end)),
	[LowUid|_] = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_XIABANQU,uid = Uid2,is_fail = ?false}) ->Uid2 end)),
	timer:apply_after(?CONST_WRESTLE_ACTIVE_TIME * 1000, ?MODULE, update_final, [[{TopUid,LowUid}]]),
	update_king([TopUid,LowUid]),
	update_final_turns(),
	set_state(?CONST_WRESTLE_ZHENGBASAIJINXINGZHONG, ?true),
	invited(TopUid, LowUid,?true);
enter_final(1)  ->  %% 第四轮决赛 
      ?MSG_ECHO("==============================~n",[]),
	{TopLeftUid,TopRightUid} = get_top_final_left_right(),
	{LowLeftUid,LowRightUid} = get_low_final_left_right(),
	List = [{TopLeftUid,TopRightUid},{LowLeftUid,LowRightUid}],
	[invited(Uid1, Uid2,?true)||{Uid1, Uid2}<-List],  
	update_final_turns(),
	timer:apply_after(?CONST_WRESTLE_ACTIVE_TIME * 1000, ?MODULE, update_final, [List]),
	timer:apply_after(?CONST_WRESTLE_ROUND_TIME *1000, ?MODULE, enter_final, [0]);
enter_final(N) ->  %% 正常拉人进入
	%上下半区没失败的人
    ?MSG_ECHO("==============================~w~n",[N]),
	FinalTops = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_SHANGBANQU,uid = Uid,index = Index,is_fail = ?false}) -> {Index,Uid} end)),
	FinalLows = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_XIABANQU,uid = Uid,index = Index,is_fail = ?false}) ->{Index,Uid} end)),
	FinalTops2 = enter_final_top_low(FinalTops),     %% 拉人进去
    FinalLows2 = enter_final_top_low(FinalLows),     %% 拉人进去
	List = FinalTops2 ++ FinalLows2,                 %% 返回用来更新决赛数据
	update_final_turns(),
	timer:apply_after(?CONST_WRESTLE_ACTIVE_TIME * 1000, ?MODULE, update_final, [List]),
	timer:apply_after(?CONST_WRESTLE_ROUND_TIME * 1000, ?MODULE, enter_final, [N - 1]).

%% 拿到第四轮上半区左右两边的数据
get_top_final_left_right() ->
	[LeftUid|_] = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_SHANGBANQU,index = Index,uid = Uid,is_fail = ?false}) when Index =< 8 -> Uid end)),
	[RightUid|_] = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_SHANGBANQU,index = Index,uid = Uid2,is_fail = ?false}) when Index > 8 -> Uid2 end)),
	{LeftUid,RightUid}.

%% 拿到第四轮下半区左右两边的数据
get_low_final_left_right()->
	[LeftUid|_] = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_XIABANQU,index = Index,uid = Uid,is_fail = ?false}) when Index =< 8 -> Uid end)),
	[RightUid|_] = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_XIABANQU,index = Index,uid = Uid2,is_fail = ?false}) when Index > 8 -> Uid2 end)),
	{LeftUid,RightUid}.

%% 更新总决赛
update_final(List) ->%[{6001,6021}]
	[update_final_acc(UidA,UidB)||{UidA,UidB}<-List],
	get_out_robot(List).
	
%% 更新打架两个人的情况
update_final_acc(UidA,UidB) ->
	case scene_api:ko_hps_get([UidA,UidB]) of
		[] ->
			wrestle_srv:fail_reduce_cast(UidA);
		[{UidA,_HarmA}]->
			wrestle_srv:fail_reduce_cast(UidB);
		[{UidB,_HarmB}] ->
			wrestle_srv:fail_reduce_cast(UidA);
		[{UidA,HarmA},{UidB,HarmB}]->
			case HarmA > HarmB of
				?true ->
					wrestle_srv:fail_reduce_cast(UidB);
				_ ->
					wrestle_srv:fail_reduce_cast(UidA)
			end
	end.

%% 进入总决赛的上下半区玩家
enter_final_top_low(Lists) ->
	{Lefts,Rights} = final_left_right(Lists,[],[]),
	Lefts2  = final_fight(lists:keysort(1, Lefts),[]),
	Rights2 = final_fight(lists:keysort(1, Rights),[]),
	Lefts2 ++ Rights2.

%% 拉进去打架
final_fight([],Acc) ->
	Acc;	
final_fight([{_Index1,Uid1},{_Index2,Uid2}|T],Acc) ->
	invited(Uid1, Uid2,?true),            %% 拉人进去
	final_fight(T,[{Uid1,Uid2}|Acc]);
final_fight([{_Index1,_Uid1}],Acc) ->
	Acc.
	
%% 各个半区分左右两边
final_left_right([],Lefts,Rights) ->
	{Lefts,Rights};
final_left_right([{Index,Uid}|T],Lefts,Rights) ->
	case Index > 8 of
		?true ->
			final_left_right(T,Lefts,[{Index,Uid}|Rights]);
		_ ->
			final_left_right(T,[{Index,Uid}|Lefts],Rights)
	end.

%% 决赛更新对手
final_insert_uid(Uid,ToUid) ->
	final_insert_uid2(Uid,ToUid),
	final_insert_uid2(ToUid,Uid).

final_insert_uid2(Uid,ToUid) ->
	case ets:lookup(?ETS_WRESTLE_FINAL, Uid) of
		[#wrestle_final{uid = Uid} = WrestleFinal|_]->
			ets:insert(?ETS_WRESTLE_FINAL, WrestleFinal#wrestle_final{to_uid = ToUid});
		_ ->
			?skip
	end.

%% 得到当前决赛轮次
get_final_turns_now() ->
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE) of 
		[#wrestle_con{value = Value}|_] ->
			Value;
		_->
			0
	end.

%% 更新决赛的轮次
update_final_turns() ->
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE) of
		[#wrestle_con{value = Value}|_] ->
			ets:update_element(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE, {#wrestle_con.value,Value + 1});
		_->
			?skip
	end.

%% 更新王者争霸数据
update_king(List)->
	[update_king_data(Uid)||Uid<-List].
update_king_data(Uid) ->
	ets:update_element(?ETS_WRESTLE_FINAL, Uid, [{#wrestle_final.is_king,?true}]).


%% 邀请pk
invited(Uid1,Uid2,Type) ->
	reset_final_handle([Uid1,Uid2],Type),   %% 重置是否处理过
	final_insert_uid(Uid1,Uid2),            %% 更新对手
    preliminary_insert_uid(Uid1,Uid2),
	case check_enter(Uid1,Uid2,Type) of
		?true  ->
		   ?MSG_ECHO("=================enter==========================================~w~n",[{Uid1,Uid2}]),
	       enter(Uid1,Uid2);
		Uid1 ->
		   enter(Uid1,0),
		   wrestle_srv:fail_reduce_cast(Uid2);
		Uid2 ->
		   enter(Uid2,0),
           wrestle_srv:fail_reduce_cast(Uid1);
		_ ->
		   wrestle_srv:fail_reduce_cast(Uid2)
    end.

%% 检查能否进入场景
check_enter(Uid1,Uid2,Type) ->
	case Type of
		?false ->
			case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI) of
				[#wrestle_con{drop = Drop}|_] ->
					case lists:member(Uid1, Drop) of
						?true ->
							case lists:member(Uid2, Drop) of
								?true ->									
									?true;
								_ ->
									Uid1     %% Uid1 在
							end;
						_ ->
							case lists:member(Uid2, Drop) of
								?true ->
									Uid2;
								_ ->
									?false
							end
					end;
				_ ->
					?false
			end;
		_ ->
			check_enter2(Uid1,Uid2)
	end.

check_enter2(Uid1,Uid2) ->
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE) of
		[#wrestle_con{drop = Drop}|_] ->
			case lists:member(Uid1, Drop) of
				?true ->
					case lists:member(Uid2, Drop) of
						?true ->
							?true;
						_ ->
							Uid1     %% Uid1 在
					end;
				_ ->
					case lists:member(Uid2, Drop) of
						?true ->
							Uid2;
						_ ->
							?false
					end
			end;
		_ ->
			?false
	end.

%% 进入场景Pk 
enter(Uid,ToUid) ->
	UidPid   = role_api:mpid(Uid),
	ToUidPid = role_api:mpid(ToUid),
	Pos = 1,ToPos = 2,
	case is_pid(UidPid) of
		?true-> 
			case is_pid(ToUidPid) of
				?true->    %1在 2 在
					scene_api:stop_map_kof(?CONST_WRESTLE_KOF_SENCE, Uid),   %% 关闭上一回合那个场景
					util:pid_send(UidPid, ?MODULE, enter_cb, [ToUid,?CONST_WRESTLE_KOF_SENCE,Pos,ToPos,Uid]);
				_ ->       %% 1在，2不在                    			  
					scene_api:stop_map_kof(?CONST_WRESTLE_KOF_SENCE, Uid),
					util:pid_send(UidPid, ?MODULE, enter_cb_only, [?CONST_WRESTLE_KOF_SENCE,Pos,Uid]),
					wrestle_srv:fail_reduce_cast(ToUid)
			end;
		_ ->
			case is_pid(ToUidPid) of
				?true ->   %% 1不在，2在		
					scene_api:stop_map_kof(?CONST_WRESTLE_KOF_SENCE, Uid),
					util:pid_send(ToUidPid, ?MODULE, enter_cb_only, [?CONST_WRESTLE_KOF_SENCE,Pos,Uid]),
					wrestle_srv:fail_reduce_cast(Uid);
				_ ->      %% 两个不在线
					wrestle_srv:fail_reduce_cast(Uid)
			end
	end.

%% 重置总决赛和预赛是否已经处理
reset_final_handle(List,Type) ->
	case Type of
		?true ->
			[ets:update_element(?ETS_WRESTLE_FINAL, Uid, [{#wrestle_final.is_handle,?false}])||Uid<-List];
		_ ->
			[ets:update_element(?ETS_WRESTLE, Uid, [{#wrestle.is_handle,?false}])||Uid<-List]
	end.
			

%% 玩家A首先进入场景
enter_cb(Player,[ToUid,MapId,Pos,ToPos,Suffix]) ->
	Player2 = scene_api:enter_map(Player, MapId, Pos, Suffix),
    case (Player2#player.info)#info.map_type =:= ?CONST_MAP_TYPE_KOF of  % 更新地图类型
		 ?true ->
	        util:pid_send(ToUid, ?MODULE, enter_cb_only, [MapId, ToPos, Suffix]),
	        Player2;
         _ ->
            wrestle_srv:fail_reduce_cast(ToUid),
            Player2
   end.            

%% 玩家B随后独自进入场景
enter_cb_only(Player,[MapId,Pos,Suffix]) ->
	?MSG_ECHO("=================enter==========================================~w~n",[{MapId,Pos,Suffix}]),
	scene_api:enter_map(Player, MapId, Pos, Suffix).

%% 更新死亡玩家,发送死亡协议
die_cb(#player{socket = Socket} = Player,Uid) ->
	?MSG_ECHO("===========================diecb================================~w~n",[Uid]),
	case (Player#player.info)#info.map_type =:= ?CONST_MAP_TYPE_KOF of
		?true ->
			Bin = war_api:msg_pk_lose(Uid),
			app_msg:send(Socket, Bin),
			Player;
		_ ->
			Player
	end.

%% 决赛每一轮发放奖励
interval_final_reward(4) ->
	?skip;
interval_final_reward(N) ->
	List = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{is_fail = ?true,is_reward = ?false,uid = Uid})-> Uid end)),
    give_final_reward(List,N),
	timer:apply_after(250 * 1000, ?MODULE, interval_final_reward, [N - 1]).

%% 决赛活动每一轮发放奖励
give_final_reward(RecvUids,N) ->
	Fun = fun(RecvUid)->			
                Title = <<"格斗之王决赛奖励">>,
				GoodsList = data_wrestle_final:get(N),
				Content = mail_api:get_content(3003,[GoodsList]),
				case ets:lookup(?ETS_WRESTLE_FINAL, RecvUid) of
					[#wrestle_final{} = WrestleFinal|_] ->
						ets:insert(?ETS_WRESTLE_FINAL, RecvUid,WrestleFinal#wrestle_final{is_reward = ?true});
					_ ->
						?skip
			    end,
				mail_api:send_mail_uids([RecvUid], Title, Content, GoodsList, [])			
 		end,
	lists:map(Fun,RecvUids).

%% 参赛人数
get_count() ->
	ets:info(?ETS_WRESTLE,size).

%% 取得列表
get_list() ->
	ets:tab2list(?ETS_WRESTLE).

%% 设置活动状态
set_state(State,Type)->
	case Type of
		?false ->
			ets:update_element(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI,[{#wrestle_con.state,State}]);
	    _ ->
			ets:update_element(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE,[{#wrestle_con.state,State}])
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gm命令%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 给所有在线玩家报名 插入表的接口
book_handle() ->
%% 	?MSG_ECHO("===========================~n",[]),
	Online = ets:tab2list(?ETS_ONLINE),
	ets:delete_all_objects(?ETS_WRESTLE),
	[util:pid_send(Uid, ?MODULE,app_cb,[])|| #player{uid = Uid}<- Online].

app_cb(#player{lv = Lv,uid = Uid,uname = Name,uname_color = Name_color,sex = Sex,pro = Pro,info = #info{power = Power}} = Player,_) ->
	case ets:lookup(?ETS_WRESTLE, Uid) of
		[#wrestle{}|_] ->
%% 			?MSG_ECHO("===========================~n",[]),
			?skip;
		_ ->
%% 			?MSG_ECHO("===========================~n",[]),
			Areana_rank = arena_api:arena_get_rank(),
			Wrestle = #wrestle{uid = Uid,lv = Lv,name = Name,name_color = Name_color,pro = Pro,
							                          sex = Sex,power = Power,areana_rank = Areana_rank},
			ets:insert(?ETS_WRESTLE, Wrestle)
	end,
	Player.

clean_handle()->
	ets:delete(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI),
	ets:delete(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE),
	ets:delete_all_objects(?ETS_WRESTLE),
	ets:delete_all_objects(?ETS_WRESTLE_FINAL),
    ets:delete_all_objects(?ETS_WRESTLE_GUESS).

control_preliminary_test_handle(Turn) ->
	timer:apply_after(30 * 1000, ?MODULE, control_preliminary_test_cb, [Turn]).

control_preliminary_test_cb(Turn) ->
	case Turn of
		1 ->
			turn_start_ys_item(?CONST_WRESTLE_GROUNP_COUNT,1);
		_ ->
			turn_start_ys_item(?CONST_WRESTLE_GROUNP_COUNT,Turn),      %% 一轮每组
			update_preliminary_turns()
	end.

control_final_test_cb(Turn) ->
	timer:apply_after(10 * 1000, ?MODULE, control_final_test_handle, [Turn]).

control_final_test_handle(Turn) ->
	case Turn of
		5 ->
			?MSG_ECHO("==============================~n",[]),
			[TopUid|_] = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_SHANGBANQU,uid = Uid,is_fail = ?false}) -> Uid end)),
			[LowUid|_] = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_XIABANQU,uid = Uid2,is_fail = ?false}) ->Uid2 end)),
			timer:apply_after(?CONST_WRESTLE_ACTIVE_TIME * 1000, ?MODULE, update_final, [[{TopUid,LowUid}]]),
			update_king([TopUid,LowUid]),
			update_final_turns(),
			set_state(?CONST_WRESTLE_ZHENGBASAIJINXINGZHONG, ?true),
			invited(TopUid, LowUid,?true);
		4 ->
			?MSG_ECHO("==============================~n",[]),
			{TopLeftUid,TopRightUid} = get_top_final_left_right(),
			{LowLeftUid,LowRightUid} = get_low_final_left_right(),
			List = [{TopLeftUid,TopRightUid},{LowLeftUid,LowRightUid}],
			[invited(Uid1, Uid2,?true)||{Uid1, Uid2}<-List],
			timer:apply_after(?CONST_WRESTLE_ACTIVE_TIME * 1000, ?MODULE, update_final, [List]),
			update_final_turns();		
		_ ->
			FinalTops  = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_SHANGBANQU,uid = Uid,index = Index,is_fail = ?false}) -> {Index,Uid} end)),
			FinalLows  = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_XIABANQU,uid = Uid,index = Index,is_fail = ?false}) ->{Index,Uid} end)),
			FinalTops2 = enter_final_top_low(FinalTops),     %% 拉人进去
			FinalLows2 = enter_final_top_low(FinalLows),     %% 拉人进去
			List = FinalTops2 ++ FinalLows2,                 %% 返回用来更新决赛数据
            timer:apply_after(?CONST_WRESTLE_ACTIVE_TIME * 1000, ?MODULE, update_final, [List]),
			update_final_turns()
	end.

rew_handle()->
	exit_preliminary(?CONST_WRESTLE_GROUNP_COUNT).





