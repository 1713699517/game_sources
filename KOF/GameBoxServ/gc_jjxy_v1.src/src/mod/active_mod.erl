%% Author  : tanwer
%% Created: 2013-7-12
%% Description: TODO: Add description to active_api
-module(active_mod).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


%%
%% Exported Functions
%%
%% -export([
%% 		 bool_date/4,
%% 		 bool_week/1,
%% 		 check_date_week/2,
%% 		 get_data4sql/0,
%% 		 get_allactive/0,
%% 		 get_ok_schedule/1,
%% 		 schedule_active/1
%% 		 ]).


-export([
		 ref_active_state/0,

		 get_acty_lv/1,
		 set_data2sql/1,
		 get_active_data/1,
		 get_allactive/0,
		 fun_all_active/1,
		 
		 temp_add_act/1,
		 change_active_handle/1,
		 schedule_active_handle/1
		]).

%% 
%% Api
%%


%% 每日刷新
ref_active_state() ->
	ActiveList=get_allactive(),
	{H0,I0,S0}=util:time(),
	F=fun({ActiveId,ActiveType,Dates,Weeks,TimeList,RoleLv,Show,InHost},{StateAcc,TodayAcc,TimeAcc}) ->
			  case check_date_week(Dates, Weeks) of
				  ?true ->
					  {StateAcc2,TimeAcc2}= 
						  case TimeList of
							  [{_,_,_,_,_}|_]=TimeList ->
								  NewTimeAcc=[{H,I,S,ActiveId,State,Arg}||{H,I,S,State,Arg} <- TimeList,{H,I,S}>={H0,I0,S0}]++TimeAcc,
								  {[{ActiveId,0}|StateAcc],NewTimeAcc};
							  [] ->
								  {[{ActiveId,1}|StateAcc],TimeAcc}
						  end,
					  TodayAcc2	= [{ActiveId,{ActiveType,TimeList,RoleLv,Show,InHost}}|TodayAcc];
				  _ ->	
					  TimeAcc2	= TimeAcc,
					  StateAcc2 = [{ActiveId,0}|StateAcc],
					  TodayAcc2	= TodayAcc
			  end,	
			  {StateAcc2,TodayAcc2,TimeAcc2}
	  end,
	{StateList,TodayList,Schedule} = lists:foldl(F, {[],[],[]}, ActiveList),	
	ets:insert(?ETS_ACTIVE_STATE, StateList),
	ets:insert(?ETS_ACTIVE_TODAY_DATA, TodayList),
	ActiveListNew = check_all_active(ActiveList,TodayList),
	fun_all_active(ActiveListNew),
	schedule_active(Schedule).

%% 检查今天会开的活动数据
check_all_active(ActiveList,TodayList) ->
	TadyId = [Id||{Id,_} <- TodayList],
	lists:foldl(fun({ActiveId,ActiveType,Dates,Weeks,TimeList,RoleLv,Show,InHost},Acc) ->
						case lists:member(ActiveId, TadyId) of
							?true ->
								[{ActiveId,ActiveType,Dates,Weeks,TimeList,RoleLv,Show,InHost}|Acc];
							_ ->
								Acc
						end
				end, [], ActiveList).
	
	
%% 检查活动排程，是否有可启动的活动
%%　{TRef,Schedule,OkSchedule}.
schedule_active_handle(Schedule) ->
	schedule_active(Schedule).
schedule_active([]) -> {0,[],[]};
schedule_active(Schedule) ->
	OkSchedule=get_ok_schedule(Schedule),
	[{H1,I1,S1,_ID,_State,_Arg}|_]=OkSchedule,
	{Y0,M0,D0} = util:date(),
	Seconds2=util:datetime2timestamp(Y0, M0, D0, H1, I1, S1),
	Seconds1=util:seconds(),
	if Seconds2-Seconds1 =< 0 ->
		   active_srv:change_active_cast(),
		   TRef=0;
	   ?true ->
		   {?ok, TRef}= ?IF((Seconds2-Seconds1) =< ?CONST_ACTIVITY_DOLOOP_TIME,
						   timer:apply_after((Seconds2-Seconds1)*1000, active_srv, change_active_cast, []),
						   {?ok,0})
	end,
	{TRef,Schedule--OkSchedule,OkSchedule}.

%%　改变活动状态
change_active_handle([]) ->
	active_srv:schedule_active_cast(),
	?ok;
change_active_handle([{_H,_I,_S,ActyID,State,Arg}|OkSchedule]) -> 
	active_api:do_active(ActyID, State, Arg),
	change_active_handle(OkSchedule).

%% 将活动数据存入数据库　　	
%%　active_mod:set_data2sql({1001,1,[{{2013,7,8},{2013,8,8}}],[1,2,3,4,5],[{07,59,59,3,30},{08,19,59,3,10},{08,28,59,2,1},{08,29,59,1,30},{08,59,59,0,0}],30,1,1}).
set_data2sql({ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}) ->
	Dates2=mysql_api:encode(Dates),
	Weeks2=mysql_api:encode(Weeks),
	Times2=mysql_api:encode(Times),
	SQL	= <<"REPLACE INTO `active_data` (`active_id`, `active_type`, `role_lv`, `show`, `in_host`, `dates`, `weeks`, `times`) VALUES ",
			"('",?B(ActiveId),			"', '",?B(ActiveType),		"', '",?B(RoleLv),		"', '",?B(Show),
			"', '",?B(InHost),			"', ",Dates2/binary,		", ",Weeks2/binary,		", ",Times2/binary, ");">>,
	mysql_api:fetch(SQL).


%% 取出最近可启动的活动
%%　return: OkSchedule=[{H1,I1,S1,ID1,State1,Arg1}|_]=get_ok_schedule(Schedule)
get_ok_schedule(Schedule) ->
	F=fun({H1,I1,S1,ID1,State1,Arg1},Acc) -> 
			  case Acc of
				  [] -> [{H1,I1,S1,ID1,State1,Arg1}|Acc];
				  [{H2,I2,S2,_,_,_}|_] ->
					  if {H1,I1,S1} < {H2,I2,S2} ->
							 [{H1,I1,S1,ID1,State1,Arg1}];
						 {H1,I1,S1} =:= {H2,I2,S2} ->
							 [{H1,I1,S1,ID1,State1,Arg1}|Acc];
						 ?true -> 
							 Acc
					  end;
				  _ -> [{H1,I1,S1,ID1,State1,Arg1}]
			  end
	  end,
	lists:foldl(F, [], Schedule).

%%
%% local_fun
%%
%% -----------------------------------------------------------------------------------
%%　检查时间限制
%% return: ?true | ?false
check_date_week(Dates,Weeks) ->
	Date1 = util:date(),
	Seconds1=util:seconds(),
	BoolDate = ?IF(Dates==[],?true,bool_date(Date1,Seconds1,Dates,?false)),
	BoolWeek = ?IF(Weeks==[],?true,bool_week(Weeks)),
	case [BoolDate,BoolWeek] of
		[?true,?true] -> ?true;
		_ -> ?false
	end.
					  
%%　判断date是否为 true
bool_date(_Date1,_Seconds1,[],Acc) -> Acc;
bool_date(_Date1,_Seconds1,_Dates,?true) -> ?true;
bool_date(Date1,Seconds1,[Date|Dates],Acc) ->
	case Date of
		{Y,M,D,H,I,Days} ->
			Seconds2=util:datetime2timestamp(Y, M, D, H, I, 0),
			Days2= util:days_diff(Seconds1, Seconds2),
			if Days2>Days ->
				   bool_date(Date1,Seconds1,Dates,Acc);
			   ?true ->
				   bool_date(Date1,Seconds1,Dates,?true)
			end;
		{{Y1,M1,D1},{Y2,M2,D2}} ->
			{Y0,M0,D0}=Date1,
			case util:betweet(Date1, {Y1,M1,D1}, {Y2,M2,D2}) of
				{Y1,M1,D1} -> 
					bool_date(Date1,Seconds1,Dates,Acc);
				{Y2,M2,D2} ->
					bool_date(Date1,Seconds1,Dates,Acc);
				{Y0,M0,D0} ->
					bool_date(Date1,Seconds1,Dates,?true)
			end
	end.

%%　判断week是否为 true		
bool_week(Week) ->
	IsWeek=util:week(),
	lists:member(IsWeek, Week).

%% 临时增加活动
temp_add_act({ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}) ->
	AllActive = get_allactive(),
	AllActive2 = 
		case lists:keytake(ActiveId, 1, AllActive) of
			{value, _Tuple, TupleList2} ->
				[{ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}|TupleList2];
			_ ->
				[{ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost}|AllActive]
		end,
	ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_ACTIVE_CONFIG,{util:date(),AllActive2}}).

%%　取出所有的活动数据
get_allactive() ->
	Now = util:date(),
	case ets:lookup(?ETS_PUBLIC_RECORDS, ?CONST_PUBLIC_KEY_ACTIVE_CONFIG) of
		[{_, {Now,ActiveList}}|_] ->
			ActiveList;
		_ ->
			case get_data4sql() of
				[] -> 
					ActiveList=data_active:get(),
					lists:map(fun({ActiveId,ActiveType,Dates,Weeks,Time,RoleLv,Show,InHost}) -> 
									  set_data2sql({ActiveId,ActiveType,Dates,Weeks,Time,RoleLv,Show,InHost}) 
							  end, ActiveList);
				ActiveList ->  
					?ok
			end,
			ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_ACTIVE_CONFIG,{Now,ActiveList}}),
			ActiveList
	end.

%% 从数据库取活动数据　　	
get_data4sql() ->
	SQL = "SELECT `active_id`,`active_type`,`dates`,`weeks`,`times`,`role_lv`,`show`,`in_host` FROM `active_data`;",
	case mysql_api:select(SQL) of
		{?ok, [[_,_,_,_,_,_,_,_]|_]=DataList} ->
			Fun=fun([ActiveId,ActiveType,Dates,Weeks,Times,RoleLv,Show,InHost],Acc) ->
						Dates2 = mysql_api:decode(Dates), 
						Weeks2 = mysql_api:decode(Weeks), 
						Times2 = mysql_api:decode(Times), 
						[{ActiveId,ActiveType,Dates2,Weeks2,Times2,RoleLv,Show,InHost}|Acc]
				end,
			lists:foldl(Fun, [], DataList);
		_R ->
			[]
	end.

%% 将所有数据处理后存入公共ets表，用与前端请求活动面板数据   [{17,53,59,3,30},{17,54,59,3,10},{17,55,59,2,1},{17,58,59,1,30},{17,57,59,0,0}]
fun_all_active(ActiveList) ->
	{Y, M, D} = util:date(),
	Seconds = util:seconds(),
	Fun = fun({ActiveId,_ActiveType,Dates,_Weeks,Time,_RoleLv,_Show,_InHost},Acc) ->
				  IsNew = ?IF(length([Day||Day <- Dates,Day =:= {Y, M, D}]) > 0, 1, 0),
				  TimeList = case Time of
								 [] ->  
									 {ST,ET} = util:seconds_today_tomorrow(Seconds),
									 [ST,ET];
								 _ ->
									 F = fun({H,I,S,State,_Arg},Acc) -> 
												 if State =:= 0 orelse State =:= 1 ->
														ST = util:datetime2timestamp(Y, M, D, H, I, S),
														[ST|Acc];
													?true ->
														Acc
												 end
										 end,
									 lists:sort(lists:foldl(F, [], Time))
							 end,
				  case TimeList of
					  [StartT,EndT]->  % {Id,IsNew,StartTime,EndTime,State}
						  [{ActiveId,IsNew,StartT,EndT,check_active_state(Seconds, StartT,EndT)}|Acc];
					  [_StartT, _EndT|_Tail] ->
						  check_active_times(ActiveId,IsNew,Seconds,TimeList,Acc);
					  _ ->
						  Acc
				  end
		  end,
	ActiveData =lists:foldl(Fun, [], ActiveList),
	
	ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_ALL_ACTIVE,ActiveData}),
	ActiveData.

%% 检查活动开启次数
check_active_times(_ActiveId,_IsNew,_Seconds,[_StartTime],Acc) -> Acc;
check_active_times(_ActiveId,_IsNew,_Seconds,[],Acc) -> Acc;
check_active_times(ActiveId,IsNew,Seconds,[StartT,EndT|TimeList],Acc) ->
	State = check_active_state(Seconds, StartT,EndT),
	Acc2 = [{ActiveId,IsNew,StartT,EndT,State}|Acc],
	check_active_times(ActiveId,IsNew,Seconds,TimeList,Acc2).
%% 检查活动状态	
check_active_state(Seconds, StartT,EndT) ->
	case util:betweet(Seconds, StartT,EndT) of
		Seconds -> ?CONST_ACTIVITY_STATE_START;		% 已开始
		EndT 	-> ?CONST_ACTIVITY_STATE_OVER;		% 已结束
		StartT	-> ?CONST_ACTIVITY_STATE_NOT_OPEN	% 未开始
	end.


%%　取出活动需要的等级限制  Lv=get_acty_lv(Id)
get_acty_lv(Id) ->
	case ets:lookup(?ETS_ACTIVE_TODAY_DATA, Id) of 
		[{Id,{_ActiveType,_TimeList,RoleLv,_Show,_InHost}}|_] ->
			RoleLv;
		_ ->
			10000
	end.

get_active_data(ActiveId) -> 
	case ets:lookup(?ETS_ACTIVE_TODAY_DATA, ActiveId) of
		[{ActiveId,{_ActiveType,TimeList,RoleLv,_Show,_InHost}}|_] ->
			case TimeList of
				[] ->
					[1,RoleLv];
				[{_H,_I,_S,_State,_Arg}|_] ->
					{Y,M,D}=util:date(),
					TimeList2= [{util:datetime2timestamp(Y,M,D,H,I,S),State,Arg} 
								|| {H,I,S,State,Arg} <- TimeList,
								   case State of 1 -> ?true; 0 -> ?true; _ -> ?false end],
					case TimeList2 of
						[_,_] ->
							[lists:sort(TimeList2),RoleLv];
						[_,_|_] ->
							TimeList3=lists:sort(TimeList2),
							?IF(get_time_se(TimeList3)==?null,?null,[get_time_se(TimeList3),RoleLv]);
						_ ->
							?null
					end;
				_ ->
					?null
			end;
		_ ->
			?null
	end.

get_time_se(List) ->
	Seconds=util:seconds(),
	{[{S1,State1,Arg1},{S2,State2,Arg2}],List2}=lists:split(2, List),
	if Seconds =< S2 ->
		   [{S1,State1,Arg1},{S2,State2,Arg2}];
	   ?true ->
		   if length(List2) >= 2 ->
				  get_time_se(List2);
			  ?true ->
				  ?null
		   end
	end.
%% 
%% msg
%%
%% ------------------------------------------------------------------------------------------

