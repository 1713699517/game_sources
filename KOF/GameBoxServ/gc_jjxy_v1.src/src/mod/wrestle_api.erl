%% Author: acer
%% Created: 2012-12-28
%% Description: TODO: Add description to defend_book_api.
-module(wrestle_api).

%% --------------------------------------------------------------------
%% Include files
			
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
-export([
		 control_preliminary_test/1,
		 control_final_test/1,
		 rew/0,
		 rbook/0,
		 clean/0,
		 enter/2,	 		 
		 %%%%%%%%%%%%战斗外部调用%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 off_line/1,
         lie_exit_kof/1,
		 
		 %%%%%%%%%%%%控制接口%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 control_preliminary/0,
		 control_final/0,
		 divide/1,
        
		 %%%%%%%%%%%%%%%%%%%%走协议过来的接口%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 book/0,
		 apply/1,
		 request/1,
		 score/1,
		 final/2,
		 king/0,
		 guess/4,
		 guess_con/1,
		 drop/1,
		 
		 %%%%%%%%%%%%%%%%%%%%%外部增加竞技水晶%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 add_pebble/3,
		 
		 %%%%%%%%%%分组接口%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 group/0,
		 final_group/0
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 	 
		   ]).

rbook()->
	wrestle_srv:book_cast().

enter(Uid, ToUid)->
	wrestle_mod:enter(Uid, ToUid).

%% 断线重连调这个接口
off_line(#player{uid=Uid,info=Info}) ->
	case Info#info.map_type of
		?CONST_MAP_TYPE_KOF ->
			wrestle_srv:fail_reduce_cast(Uid);
		_ ->
			?skip
	end.

%% 场景死亡调这个接口
lie_exit_kof(Uid) ->
	wrestle_srv:fail_reduce_cast(Uid).

%% 预赛分组接口
group()->
	wrestle_srv:group_cast().

%% 预赛控制
control_preliminary() ->
	wrestle_srv:control_preliminary_cast().

%% 决赛分组接口
final_group()->
	wrestle_srv:final_group_cast().

%% 决赛
control_final() ->
	wrestle_srv:control_final_cast().

%% 清空活动数据
clean()->
	wrestle_srv:clean_cast().
	
%% gm测试命令
control_preliminary_test(Turn) ->
	wrestle_srv:control_preliminary_test_cast(Turn).
control_final_test(Turn) ->
    wrestle_srv:control_final_test_cast(Turn).

rew() ->
	wrestle_srv:rew_cast().
%% 1活动报名
book() ->
	case arena_api:arena_get_rank() of
		 0 ->
			{?error,?ERROR_WRESTLE_NOT_AREAN};
	     Areana_rank ->			 
			{?ok,msg_areank_rank(Areana_rank)}
	end.

%% 2报名接口
apply(#player{lv = Lv,uid = Uid,uname = Name,uname_color = Name_color,sex = Sex,pro = Pro,info = #info{power = Power}}) ->
	case Lv >= ?CONST_WRESTLE_LV of
		?true ->
			case ets:lookup(?ETS_WRESTLE, Uid) of 
				[#wrestle{}|_] ->
					{?error,?ERROR_WRESTLE_REPEAT_APPLY};
				_ ->
					Areana_rank = arena_api:arena_get_rank(),
					Wrestle = #wrestle{uid = Uid,lv = Lv,name = Name,name_color = Name_color,pro = Pro,sex = Sex,power = Power,areana_rank = Areana_rank},
					ets:insert(?ETS_WRESTLE, Wrestle),
					Bin = msg_apply_state(),
					{?ok,Bin}
			end;
		_ ->
			{?error,?ERROR_WRESTLE_NOT_LV}
	end.

%% 1处理格斗之王
request(Uid) ->
	case ets:lookup(?ETS_WRESTLE, Uid) of
		[#wrestle{lv = Lv,name = Name,name_color = NameColor,power = Power,score = Score,group_id = GroupId,success = Success,fail = Fail}|_] ->
			AllCount = wrestle_mod:get_turns_number(GroupId),      %% 总共的轮次
		    request2(Uid,Name,NameColor,Lv,Power,Score,AllCount,Success,Fail);			
		_ ->
			{?error,?ERROR_WRESTLE_NOT_APPLY}
	end.
request2(Uid,Name,NameColor,Lv,Power,Score,AllCount,Success,Fail) ->
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI) of
		[#wrestle_con{state = State,drop = DropList,time = Time,value = NowCount}|_] ->
			set_drop(Uid,DropList,?false),
			case lists:keyfind(NowCount, 1, Time) of
				{_,StartTime,EndTime} ->
					{_Uid2,Dname}  = wrestle_mod:get_next(Uid,NowCount), 
					case AllCount >= NowCount of
						?true ->
							?MSG_ECHO("=================~w~n",[NowCount]),
							Bin = msg_player(Uid,Name,NameColor,Lv,Power,Score,NowCount,AllCount,Dname,Success,Fail),
							Bin2 = msg_time(State,StartTime,EndTime),
							{?ok,<<Bin/binary,Bin2/binary>>};
						_ ->
							?MSG_ECHO("=================~w~n",[NowCount]),
							Bin = msg_player(Uid,Name,NameColor,Lv,Power,Score,AllCount,AllCount,Dname,Success,Fail),
							Bin2 = msg_time(State,StartTime,EndTime),
							{?ok,<<Bin/binary,Bin2/binary>>}
					end;
				_->
					{?ok,app_msg:msg(?P_WRESTLE_PLAYER, <<>>)}
			
			end;
		_ ->
			{?ok,app_msg:msg(?P_WRESTLE_PLAYER, <<>>)}
	end.
score(Uid) ->
	case ets:lookup(?ETS_WRESTLE, Uid) of
			  [#wrestle{group_id = Key}|_] ->
				  Bin = get_all_score(Key),
				  {?ok,Bin};
			  _ ->
				  {?ok,<<>>}
    end.

%% 3决赛入口
final(Type,Uid0) ->
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE) of
		[#wrestle_con{value = Turn,time = Time,state = State,drop = DropList}|_] ->
			Turn2 = case Turn == 0 of
						?true ->
							1;
						_->
							Turn
					end,
			{Turn2,StartTime,EndTime} = lists:nth(Turn2, Time),
			Bin0 = msg_time(State,StartTime,EndTime),
			set_drop(Uid0,DropList,?true),
			case Type of
				?CONST_WRESTLE_SHANGBANQU ->
					TopList  = ets:select(?ETS_WRESTLE_FINAL, ets:fun2ms(fun(#wrestle_final{index= Index,uid = Uid,name = Name,is_fail = IsFail,type = Type2,fail_turn = FailTurn})
																			  when Type2 == Type ->{Index,Uid,Name,IsFail,FailTurn} end)),
					TopList2 = [get_final_data(Index,Uid,Name,IsFail,FailTurn)||{Index,Uid,Name,IsFail,FailTurn}<-TopList],
					Bin      = msg_final_rep(?CONST_WRESTLE_SHANGBANQU,Turn,TopList2),		
					{?ok,<<Bin0/binary,Bin/binary>>};
				?CONST_WRESTLE_XIABANQU ->
					LowList = ets:select(?ETS_WRESTLE_FINAL, ets:fun2ms(fun(#wrestle_final{index= Index,uid = Uid,name = Name,is_fail = IsFail,type = Type2,fail_turn = FailTurn}) 
																			 when Type2 == Type ->{Index,Uid,Name,IsFail,FailTurn} end)),
					LowList2 = [get_final_data(Index,Uid,Name,IsFail,FailTurn)||{Index,Uid,Name,IsFail,FailTurn}<-LowList],
					Bin      = msg_final_rep(?CONST_WRESTLE_XIABANQU,Turn,LowList2),
					{?ok,<<Bin0/binary,Bin/binary>>}
			end;				
		_->
			{?error,?ERROR_WRESTLE_NOT_FINAL}
	end.
get_final_data(Index,Uid,Name,IsFail,FailTurn) ->
	case ets:lookup(?ETS_WRESTLE, Uid) of
		[#wrestle{pro = Pro,power = Power}|_] ->
			?MSG_ECHO("==================~w~n",[{Index,Uid,Name,IsFail,FailTurn}]),
			{Index,Uid,Name,Pro,Power,IsFail,FailTurn};
		_ ->
			{Index,Uid,Name,0,0,IsFail,FailTurn}
	end.

%% 4决赛争霸 
king() ->
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE) of
		[#wrestle_con{state = ?CONST_WRESTLE_ZHENGBASAIJINXINGZHONG,time = Time2,value = Turn}|_] ->
			[TopUid|_] = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_SHANGBANQU,uid = Uid,is_king = ?true}) -> Uid end)),
			?MSG_ECHO("======================~w~n",[TopUid]),
	        [LowUid|_] = ets:select(?ETS_WRESTLE_FINAL,ets:fun2ms(fun(#wrestle_final{type = ?CONST_WRESTLE_XIABANQU,uid = Uid2,is_king = ?true}) ->Uid2 end)),
			{Turn,StartTime,EndTime} = lists:nth(Turn, Time2),
			{Name,Lv,Power}          = get_king_data(TopUid),
			{Name2,Lv2,Power2}       = get_king_data(LowUid),
			Bin  = msg_zhengba_request(Name,Lv,Power),
			Bin2 = msg_zhengba_request(Name2,Lv2,Power2),
			Bin3 = msg_time(?CONST_WRESTLE_ZHENGBASAIJINXINGZHONG,StartTime,EndTime),
			{?ok,<<Bin/binary,Bin2/binary,Bin3/binary>>};
		_ ->
			Bin = msg_time(?CONST_WRESTLE_NOT_START,0,0),
			{?ok,Bin}
	end.
get_king_data(Uid) ->
	case ets:lookup(?ETS_WRESTLE, Uid) of
		 [#wrestle{name = Name,lv = Lv,power = Power}|_] ->
		        {Name,Lv,Power};
		_ ->
			{<<>>,0,0}
	end.
	
%% 5欢乐竞猜
guess(#player{uid = Uid,uname = Name} = Player,Uid1,Uid2,Rmb) ->
	case role_api:currency_cut([guess,[],<<"格斗之王竞猜活动">>], Player, [?CONST_CURRENCY_RMB,Rmb]) of
		{?ok, Player2, BinAcc} ->						
			case ets:lookup(?ETS_WRESTLE, Uid1) of
				[#wrestle{name = Name1}|_] ->
					case ets:lookup(?ETS_WRESTLE, Uid2) of
						[#wrestle{name = Name2}|_] ->
							Bin = msg_guess_state(?CONST_WRESTLE_GUESS_SUCCESS,Name1,Name2,Rmb),
							ets:insert(?ETS_WRESTLE_GUESS, #wrestle_guess{uid = Uid,name = Name,pick_list = [{Uid1,Name1},{Uid2,Name2}],rmb = Rmb}),
							Bin2 = msg_pebble(set_tote(Rmb)),
							{?ok,Player2,<<Bin/binary,BinAcc/binary,Bin2/binary>>};
						_ ->
							{?error,?ERROR_WRESTLE_NOT_YAJUN}
					end;
				_ ->
					{?error,?ERROR_WRESTLE_NOT_GUANJUN}
			end;
		{?error,ErrorCode} ->
			{?error,ErrorCode}
	end.

%% 断线重连，竞猜数据
guess_con(Uid) ->
	Bin2 = msg_pebble(5000),
	Bin = case ets:lookup(?ETS_WRESTLE_GUESS, Uid) of
			  [#wrestle_guess{pick_list = [{_Uid1,Name1},{_Uid2,Name2}],rmb = Rmb}|_] ->
				  msg_guess_state(?CONST_WRESTLE_GUESS_SUCCESS,Name1,Name2,Rmb);
			  _ ->
				  msg_guess_state(?CONST_WRESTLE_GUESS_NOT,<<>>,<<>>,0)
		  end,
	{?ok,<<Bin/binary,Bin2/binary>>}.

%% 离开面板
drop(Uid) ->
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI) of
		[#wrestle_con{drop = DropList} = Wrestle|_] ->
			DropList2 = lists:delete(Uid, DropList),
			ets:insert(?ETS_WRESTLE_CONTROL, Wrestle#wrestle_con{drop = DropList2});
		_ ->
			case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE) of
				[#wrestle_con{drop = DropList} = Wrestle|_] ->
					DropList2 = lists:delete(Uid, DropList),
					ets:insert(?ETS_WRESTLE_CONTROL, Wrestle#wrestle_con{drop = DropList2});
				_->
					?skip
			end
	end.

%% 进来记录一下数据
set_drop(Uid,DropList,Type) ->
	case lists:member(Uid, DropList) of
		?true ->
			?skip;
		_ ->
			case Type of
				?false->
					DropList2 = [Uid|DropList],
					ets:update_element(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI,[{#wrestle_con.drop,DropList2}]);
				_ ->
					DropList2 = [Uid|DropList],
					ets:update_element(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE,[{#wrestle_con.drop,DropList2}])
			end
	end.
	
%% 外部调用增加竞技水晶
add_pebble(_LogSrc,#player{info = Info} = Player, PebbleValue) ->
	PebbleValue2 = Info#info.pebble + PebbleValue,
    Info2 = Info#info{pebble = PebbleValue2},
	Player2 = Player#player{info = Info2},
	Bin = msg_pebble(PebbleValue2),
	{?ok,Player2,Bin}.

%% 竞技水晶奖池
set_tote(Rmb) ->
	case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE) of
		[#wrestle_con{pebble = Pebble}|_] ->
			 Pebble2 = Pebble + Rmb,
			 ets:update_element(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE, [{#wrestle_con.pebble,Pebble2}]),
			 Pebble2;
		_ ->
			 Rmb
	end.

%% 全部分数
get_all_score(Key) ->
	List         = ets:select(?ETS_WRESTLE, ets:fun2ms(fun(R) when R#wrestle.group_id==Key-> R end)),	
	List2     = lists:keysort(#wrestle.score, List),
	{_,List3} = set_pos(List2),
    Bin = iolist_to_binary([msg_xxxxx(W#wrestle.pos,W#wrestle.name,W#wrestle.success,W#wrestle.fail,W#wrestle.score)||W<-List3]),
	msg_score_msg(List3,Bin).

%% 设置排序pos位
set_pos(Uidlist) ->
	Fun = fun(W,{Key,Acc}) ->
			  W2 = W#wrestle{pos = Key},
			  KeyAcc = Key + 1,
			  {KeyAcc,[W2|Acc]}
		  end,
	lists:foldr(Fun, {1,[]}, Uidlist).

%% 设置分组功能
divide(N) ->
	wrestle_mod:divide(N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% msg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 返回竞技场数据 [54802]
msg_areank_rank(Rank)->
    RsList = app_msg:encode([{?int16u,Rank}]),
    app_msg:msg(?P_WRESTLE_AREANK_RANK, RsList).

% 报名状态 [54804]
msg_apply_state()->
    app_msg:msg(?P_WRESTLE_APPLY_STATE,<<>>).

%% 各种倒计时 [54808]
msg_time(State,StartTime,EndTime)->
    RsList = app_msg:encode([{?int8u,State},
        {?int32u,StartTime},{?int32u,EndTime}]),
    app_msg:msg(?P_WRESTLE_TIME, RsList).

% 玩家信息块 [54810]
msg_player(Uid,Name,NameColor,Lv,Power,Score,NowCount,AllCount,Uname,Success,Fail)->
    RsList = app_msg:encode([{?int32u,Uid},
        {?string,Name},{?int8u,NameColor},
        {?int16u,Lv},{?int32u,Power},
        {?int32u,Score},{?int16u,NowCount},
        {?int16u,AllCount},{?string,Uname},
        {?int16u,Success},{?int16u,Fail}]),
    app_msg:msg(?P_WRESTLE_PLAYER, RsList).

% 积分榜返回 [54818]
msg_score_msg(List,Bin)->
    Rs = app_msg:encode([{?int16u,length(List)}]),
    app_msg:msg(?P_WRESTLE_SCORE_MSG, <<Rs/binary,Bin/binary>>).

msg_xxxxx(Pos,Name,Success,
    Fail,Score)->
    app_msg:encode([{?int8u,Pos},
        {?string,Name},{?int16u,Success},
        {?int16u,Fail},{?int32u,Score}]).
 
%% 竞猜状态 [54900]
msg_guess_state(State,Name1,Name2,Rmb)->
    RsList = app_msg:encode([{?int8u,State},
        {?string,Name1},{?string,Name2},{?int32u,Rmb}]),
    app_msg:msg(?P_WRESTLE_GUESS_STATE, RsList).

% 争霸信息返回 [54920]
msg_zhengba_request(Name,Lv,Power)->
    RsList = app_msg:encode([{?string,Name},
        {?int32u,Lv},{?int32u,Power}]),
    app_msg:msg(?P_WRESTLE_ZHENGBA_REQUEST, RsList).

% 竞技水晶更新 [54930]
msg_pebble(Pebble)->
    RsList = app_msg:encode([{?int32u,Pebble}]),
    app_msg:msg(?P_WRESTLE_PEBBLE, RsList).

% 决赛信息2 [54940]
msg_final_rep(Type,Turn,List)->
    BinAcc = app_msg:encode([{?int8u,Type},
        {?int16u,Turn},{?int16u,length(List)}]),
	Fun = fun({Index,Uid,Name,Pro,Power,IsFail,FailTurn},Acc) ->
				  Bin = msg_final_rep_msg(Index,Uid,Name,Pro,Power,IsFail,FailTurn),
				  <<Acc/binary,Bin/binary>>
		  end,
	RsList = lists:foldl(Fun, BinAcc, List),
    app_msg:msg(?P_WRESTLE_FINAL_REP, RsList).

% 决赛信息块 [54945]
msg_final_rep_msg(Index,Uid,Name,Pro,Power,IsFail0,FailTurn)->
   IsFail = ?IF(IsFail0 == ?false,0,1),
   app_msg:encode([{?int16u,Index},
        {?int32u,Uid},{?string,Name},{?int8u,Pro},{?int32u,Power},
        {?int8u,IsFail},{?int16u,FailTurn}]).
    
