%% Author: Administrator
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_practice
-module(chat_gateway).

%%
%% Include files
%%
-include("../include/comm.hrl"). 
%%
%% Exported Functions
%%
-export([gateway/3,
		 gm_cmd/3,
		 lv_cb/2]).
%%
%% API Functions
%%
gateway(?P_CHAT_SEND, Player=#player{socket=Socket,uname=Name,lv=Lv,sex=Sex,
									 pro=Pro,country=Country,uid=Uid},Bin) ->
	{ChannelId,PUid,ArgsType,TeamId,CopyId,Msg,List}=chat_api:decode(Bin),
	{PPro,PLv} = chat_api:uid2lv2pro(PUid),
	?MSG_ECHO("--------------~w~n",[{ChannelId,PUid,ArgsType,TeamId,CopyId,Msg,List}]),
	GoodsBin=chat_api:goods_data(List),
	BinMsg=chat_api:msg_rece(ChannelId,Uid,Name,Sex,Pro,Lv,Country,[],ArgsType,GoodsBin,TeamId,CopyId,Msg,PUid,<<>>,PPro,PLv),
	case PUid of
		0->
			case ChannelId of
				?CONST_CHAT_PM ->
					?skip;
				_ ->
					chat_api:do_chat(ChannelId,Player,BinMsg)
			end;
		_->
			%% 			friend_api:recent_add(Uid,PUid),
			chat_api:do_chat(?CONST_CHAT_PM,Player,{PUid,BinMsg}),
			app_msg:send(Socket, BinMsg)
	end,
	{?ok,Player};

gateway(?P_CHAT_NAME, Player=#player{socket=Socket,uname=Name,lv=Lv,sex=Sex,
									 pro=Pro,country=Country,uid=Uid},Bin) ->
	{SName,Msg,List}=chat_api:pm_decode(Bin),
	case role_api:uname_to_player(SName) of
		?null-> 
			BinMsg=chat_api:msg_office_player(),
			app_msg:send(Socket, BinMsg);
		#player{uid=PUid,lv= PLv, pro= PPro}->
			?MSG_ECHO("==============~w~n",[{PUid,PLv,PPro}]),
			friend_api:add_recent(PUid),
			friend_api:add_recent2(PUid,Uid),
			GoodsBin=chat_api:goods_data(List),
			BinMsg=chat_api:msg_rece(?CONST_CHAT_PM,Uid,Name,Sex,Pro,Lv,Country,[],?CONST_CHAT_GOODS,GoodsBin,0,0,Msg,PUid,SName,PPro,PLv),
%% 			friend_api:recent_add(Uid,PUid),
			chat_api:do_chat(?CONST_CHAT_PM,Player,{PUid,BinMsg}),
			app_msg:send(Socket, BinMsg)
	end,
	{?ok,Player};

%% GM命令 
gateway(?P_CHAT_GM, #player{socket=Socket}= Player, <<_Len:8/big-integer-unsigned,Binary/binary>>) when ?DEBUG_GM == ?CONST_TRUE ->
	String0 = binary_to_list(Binary),
	case String0 of
		[]->{?ok,Player};	
		[_|String]->
			String2  = string:to_lower(String), 
			[Command|ArgList] = string:tokens(String2, " "),
			NewPlayer = gm_cmd(Command,ArgList,Player), 
			{?ok,NewPlayer}
	end;

%% 机器人GM命令 
gateway(9990, #player{lv= Lv,uid= Uid,mpid= MPid,is=Is,socket=Socket}= Player, <<_Len:8/big-integer-unsigned,Binary/binary>>) ->
	String0 = binary_to_list(Binary),
	Now = util:seconds(),
	case get(jiqiren) of
		?undefined->
			put(jiqiren,Now),
			case String0 of
				[]->{?ok,Player};	
				[_|String]->
					String2  = string:to_lower(String), 
					[Command|ArgList] = string:tokens(String2, " "),
					NewPlayer = gm_cmd(Command,ArgList,Player), 
					{Player2,Bin1}= strengthen(NewPlayer),
					app_msg:send(Socket, Bin1),
					{?ok,Player2}
			%% 					{Player3,Bin2}= partner(Player2),
			%% 					app_msg:send(Socket, <<Bin1/binary,Bin2/binary>>),
			%% 					{?ok,Player3}
			end;
		Time ->
			case Now - Time  =< 120* 60 of
				?true ->
					case String0 of
						[]->{?ok,Player};	
						[_|String]->
							String2  = string:to_lower(String), 
							[Command|ArgList] = string:tokens(String2, " "),
							NewPlayer = gm_cmd(Command,ArgList,Player), 
							{Player2,Bin1}= strengthen(NewPlayer),
							app_msg:send(Socket, Bin1),
							{?ok,Player2}
%% 							{Player3,Bin2}= partner(Player2),
%% 							app_msg:send(Socket, <<Bin1/binary,Bin2/binary>>),
%% 							{?ok,Player3}
					end;
				_ ->
					scene_api:exit_scene(Player),
					Is2=Is#is{is_db=?CONST_FALSE},
					util:pid_send(MPid,?exit),
					role_db:role_delete(Uid),
					%% 			?MSG_ECHO("========================~w~n",[Lv,Uid]),
					{?ok,?change_socket,Player#player{uid=0,socket=?null,is=Is2}}
			end
	end;


%% 	?MSG_ECHO("========================~w~n",[{Lv,Uid}]),
%% 	case Lv < 25 of 
%% 		?true ->
%% 			case String0 of
%% 				[]->{?ok,Player};	
%% 				[_|String]->
%% 					String2  = string:to_lower(String), 
%% 					[Command|ArgList] = string:tokens(String2, " "),
%% 					NewPlayer = gm_cmd(Command,ArgList,Player), 
%% 					{?ok,NewPlayer}
%% 			end;
%% 		_ ->
%% 			scene_api:exit_scene(Player),
%% 			Is2=Is#is{is_db=?CONST_FALSE},
%% 			util:pid_send(MPid,?exit),
%% 			role_db:role_delete(Uid),
%% %% 			?MSG_ECHO("========================~w~n",[Lv,Uid]),
%% 			{?ok,?change_socket,Player#player{uid=0,socket=?null,is=Is2}}
%% 	end;

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

%% 
%% ------------------------------------------------------
%% gm命令
%% ------------------------------------------------------
gm_cmd("make",[GoodsID0, Count0|_],Player) ->
	Bag=role_api_dict:bag_get(),
	{GoodsID, Count} = {list_to_integer(GoodsID0),list_to_integer(Count0)},
	case bag_api:goods_list(GoodsID, Count) of
		{error, _ErrroCode} ->
			Player;
		GoodsList ->
			case bag_api:goods_set([gm_cmd,[],<<"GM命令make">>],Player,Bag,GoodsList) of
				{?ok,Player2,Bag2,GoodsBin,BinMsg} ->
					role_api_dict:bag_set(Bag2),
					app_msg:send(Player#player.socket, <<GoodsBin/binary,BinMsg/binary>>),
					Player2;
				{?error, ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Player#player.socket, BinMsg),
					Player
			end
	end;

gm_cmd("fun",[Id0,State0|_], Player) ->
	{Id, State} = {list_to_integer(Id0),list_to_integer(State0)},
	is_funs_api:gm(Id, State),
	Player;

gm_cmd("bag", _,Player) ->
	Bag=role_api_dict:bag_get(),
	Bag2 = Bag#bag{list = []},
	role_api_dict:bag_set(Bag2),
	Player;

%% gm_cmd("tem", _, #player{bag = Bag} = Player) ->
%% 	Bag2 = Bag#bag{temp = []},
%% 	Player#player{bag = Bag2};

gm_cmd("date",AAA,Player) ->
	case AAA of
		[Date,Time|_] ->
			DateTime = list_to_binary([Date," ",Time]);
		[Count0|_] ->
			Count = list_to_integer(Count0),
			{{Y,M,D},_} = util:localtime(),
			DateTime = lists:concat([Y,"-",M,"-",D+Count," ","23:59:57"]);
		_R ->
			{{Y,M,D},_} = util:localtime(),
			DateTime = lists:concat([Y,"-",M,"-",D," ","23:59:57"])
	end,
	db:config_diff_time_set(DateTime),
	active_srv:gm_change_time(),
	%% 时间校正
	BinSystemTime = system_api:msg_time(util:seconds()),
	chat_api:send_to_all(BinSystemTime),
	Player;


gm_cmd("exp",[Exp|_],Player) ->
	?MSG_ECHO("Exp :::~w~n",[Exp]),
	role_api:exp_add(Player, ?TRY_FAST(list_to_integer(Exp),100),gm_cmd,<<"GM">>);

gm_cmd("exppa",[Exp0|_],Player) ->
	Exp = list_to_integer(Exp0),
	?MSG_ECHO("Exp :::~w~n",[Exp]),
	inn_api:exp_add_inn(Player, Exp,gm_cmd,<<"GM伙伴">>);
%% 	inn_api:exp_add_inn(Player, Exp, gm_cmd, <<"GM">>);

gm_cmd("lv", [Lv0|_],#player{socket = Socket,lv = Lv2,info = Info} = Player) ->	
	Lv = list_to_integer(Lv0),
	case Lv2 >= Lv of
		?true ->
			Player;
		?false ->
			NxetExp=?DATA_PLAYER_UP_EXP:get(?CONST_PLAYER,Player#player.lv),
			ExpAcc0 = NxetExp - Info#info.exp,
			ExpAdd = lists:foldl(fun(Level, Acc) ->
										 case ?DATA_PLAYER_UP_EXP:get(?CONST_PLAYER,Level) of
											 Exp when is_integer(Exp) ->
												 Acc + Exp;
											 _ ->
												 Acc
										 end
								 end, ExpAcc0, lists:seq(Lv2 + 1, Lv-1)),
			{Player2, BinMsg} = role_api:currency_add([gm_cmd,[],<<"">>],Player, [{?CONST_CURRENCY_EXP,ExpAdd}]),
			app_msg:send(Socket, BinMsg),
			Player2
	end;


gm_cmd("petlv", [Lv0|_],#player{lv = Lv2} = Player) ->
	Lv = list_to_integer(Lv0),
	Pet= role_api_dict:pet_get(),
	#pet{lv= PetLv}= Pet,
	case PetLv >= Lv of
		?true ->
			Player;
		?false ->
			Player2= pet_api:level_up(Pet, Lv, Player),
			Player2
	end;

gm_cmd("gold",[Count0|_],Player) ->
	Count = list_to_integer(Count0),
	L = [{?CONST_CURRENCY_GOLD, 	Count},
		 {?CONST_CURRENCY_RMB_BIND, Count},
		 {?CONST_CURRENCY_RMB, 		Count}],
	?MSG_ECHO("Exp :::~w~n",[gold]),
	{Player2, BinMsg} = role_api:currency_add([gm_cmd,[],<<"GM:gold">>],Player, L),
	app_msg:send(Player2#player.socket, BinMsg),
	Player2;




%% gm_cmd("soul",[Count0|_],Player)->
%% 	Count =list_to_integer(Count0),
%% 	L=[{?CONST_CURRENCY_SOUL_VIGOUR,Count},{?CONST_CURRENCY_SOUL_VIGOUR_PURPLE,Count},
%% 	   {?CONST_CURRENCY_SOUL_VIGOUR_GOLD,Count},{?CONST_CURRENCY_SOUL_VIGOUR_ORANGE,Count},
%% 	   {?CONST_CURRENCY_SOUL_VIGOUR_RED,Count}],
%% 	{Player2,Bin}=role_api:currency_add([gm_cmd,[],<<"Gm加精魄">>],Player, L),
%% 	app_msg:send(Player2#player.socket, Bin),
%% 	Player2;

%% gm_cmd("star",[Value0|_],Player)->
%% 	Value   = list_to_integer(Value0), 
%% 	{Player2,Bin} = role_api:currency_add([gm_cmd,[],<<"Gm加星魂">>],Player, [{?CONST_CURRENCY_SOUL_STAR,Value}]),
%% 	app_msg:send(Player2#player.socket, Bin),
%% 	Player2;
%% 
%% 
gm_cmd("renown",[Count0|_],Player) ->
	Count = list_to_integer(Count0),	
	{Player2,Bin} = role_api:currency_add([gm_cmd,[],<<"GM:+renown">>],Player, [{?CONST_CURRENCY_RENOWN,Count}]),
	app_msg:send(Player2#player.socket, Bin),
    ?MSG_ECHO("Exp :::~w~n",[(Player2#player.info)#info.renown]),
	Player2;
%% 
gm_cmd("energy",[Count0|_],Player) ->
	Count = list_to_integer(Count0),	
	{Player2,Bin} = role_api:currency_add([gm_cmd,Count,<<"GM:+energy">>],Player, [{?CONST_CURRENCY_ENERGY,Count}]),
	app_msg:send(Player2#player.socket, Bin),
	Player2;

gm_cmd("energyc",[Count0|_],Player) ->
	Count = list_to_integer(Count0),	
	case role_api:currency_cut([gm_cmd,Count,<<"GM:-energy">>],Player, [{?CONST_CURRENCY_ENERGY,Count}]) of 
		{?ok,Player,Bin} -> ?ok;
		{_ ,Err} ->
			Bin=system_api:msg_error(Err)
	end,
	app_msg:send(Player#player.socket, Bin),
	Player;

gm_cmd("boss",_,Player) ->
	world_boss_api:boss_monster(),
	Player;

gm_cmd("power",[Count0|_],Player) ->
	Count = list_to_integer(Count0),	
	{Player2,Bin} = role_api:currency_add([gm_cmd,[],<<"GM:+power">>],Player, [{?CONST_CURRENCY_ADV_SKILL,Count}]),
	?MSG_ECHO("=Bin==~w~n",[Bin]),
	app_msg:send(Player2#player.socket, Bin),
	Player2;

gm_cmd("copy",[CopyId0|_],Player) ->
	CopyId = list_to_integer(CopyId0),
	if CopyId =:= 0 ->
		   ?skip;
	   ?true ->
		   copy_api:copy_over_id(CopyId)
	end,
	Player;

gm_cmd("copyc",[ChapId0|_],Player) ->
	ChapId = list_to_integer(ChapId0),
	if ChapId =:= 0 ->
		   ?skip;
	   ?true ->
		   copy_api:copy_over_chap(ChapId)
	end,
	Player;
	
gm_cmd("copya",_,Player) ->
	copy_api:copy_over_all(),
	Player;

%% 
%% gm_cmd("energyd",[Count0|_],Player) ->
%% 	Count   = list_to_integer(Count0),	
%% 	{?ok,Player2,Bin} = role_api:currency_cut([gm_cmd,[],<<"GM:-energyd">>],Player, [{?CONST_CURRENCY_ENERGY,Count}]),
%% 	app_msg:send(Player2#player.socket, Bin),
%% 	Player2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% defend_book %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% gm_cmd("df",[Count0|_],Player) ->
%% 	Count   = list_to_integer(Count0),
%% 	?IF(lists:member(Count, [0,1,2,3,4]), erlang:spawn(defend_book_api, gm, [Count]), skip),
%% 	Player;
%% 
%% gm_cmd("dfm",[Count0|_],Player) ->
%% 	Count   = list_to_integer(Count0),	
%% 	?IF(lists:member(Count,data_defend_book_monster:get_ids()), erlang:spawn(defend_book_api, boss_monster, [Count]), skip),
%% 	Player;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% defend_book %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% gm_cmd("copy",[CopyId0|_],Player) ->
%% 	CopyId = list_to_integer(CopyId0),
%% 	if CopyId =:= 0 ->
%% 		   copy_api:copy_all_in(Player#player.sid,Player#player.uid);
%% 	   ?true ->
%% 		   copy_api:copy_id_in(Player#player.sid, Player#player.uid, CopyId)
%% 	end,
%% 	Player;
%% 	
%% gm_cmd("weagod",[Count0|_],Player) ->
%% 	Count	= list_to_integer(Count0),	
%% 	Player2	=weagod_api:wealth_add(Player,Count),
%% 	Player2;
%% 
%% gm_cmd("piltimes",[CopyId0|_],Player) ->
%% 	PilId	= list_to_integer(CopyId0),	
%% 	pilroad_api:reward_times_add(Player#player.sid,Player#player.uid,PilId),
%% 	Player;
%% 
%% gm_cmd("pildel",[CopyId0|_],Player) ->
%% 	PilId	= list_to_integer(CopyId0),	
%% 	pilroad_api:reward_times_del(Player#player.sid,Player#player.uid,PilId),
%% 	Player;
%% 
%% gm_cmd("plates",[Count0|_],Player) ->
%% 	Count	= list_to_integer(Count0),	
%% 	pilroad_api:plates_add(Player,Count),
%% 	Player;
%% 
gm_cmd("sys",[TaskID0|_],Player) ->
	TaskID = list_to_integer(TaskID0),
	role_api:sys_task(Player, TaskID * 10),
	Player;
%% 
%% gm_cmd("war",[State0|_],Player) ->
%% 	State = list_to_integer(State0),
%% 	?IF(lists:member(State, [1,2,3,4]), erlang:spawn(activity_api, active, [?CONST_ACTIVITY_FACTION, State, 0]), skip),
%% 	Player;
%% 
%% gm_cmd("sky",[State0, Arg0|_],Player) ->
%% 	State = list_to_integer(State0),
%% 	Arg = list_to_integer(Arg0),
%% 	?IF(lists:member(State, [0,1,2]), erlang:spawn(activity_api, active, [?CONST_ACTIVITY_SKY_WAR, State, Arg]), skip),
%% 	Player;
%% 

gm_cmd("vip",[Count0|_], Player) ->
	Count   = list_to_integer(Count0),
	if Count < 15 ->
		   #d_vip{vip_up=VipUp}=data_vip:get(Count),
		   vip_api:buy_rmb(Player,VipUp);
	   ?true ->
		   vip_api:buy_rmb(Player,Count)
	end;

gm_cmd("mail",[Count0|_], Player) ->
	Count   = list_to_integer(Count0),
	lists:foldl(fun(_,_) ->
						mail_api:mail([Player#player.uid])
				end, [], lists:seq(1, Count)),
	Player;

gm_cmd("clear", _, Player) ->
	active_api:clear_mysql(),
	Player;

%% gm_cmd("dtask", _, #player{uid = Uid} = Player) ->
gm_cmd("dtask", _, Player) ->	
    Task_Daily = role_api_dict:task_daily_get(),
	#task_daily{dTaskId = DTaskId} = Task_Daily,
	#d_task_daily{type = TargetT,copys_id = Value} = data_task_daily:get(DTaskId),
	?MSG_ECHO("~w~n",[role_api_dict:task_daily_get()]),
	task_daily_api:check(Player,TargetT,Value),
	?MSG_ECHO("~n",[]),
%% 	task_daily_api:check_cast(Uid, TargetT, Value),
%% 	Task_Daily2 = Task_Daily#task_daily{state = 1},
%% 	role_api_dict:task_daily_set(Task_Daily2),
%% 	BinMsg = msg_data(DTaskId,10,0,0),
%% 	app_msg:send(Socket, BinMsg),
	Player;

gm_cmd("bg",[Count0|_],Player) ->
	Count = list_to_integer(Count0),	
	{Player2,Bin} = role_api:currency_add([gm_cmd,[],<<"GM:+advote">>],Player, [{?CONST_CURRENCY_DEVOTE,Count}]),
	app_msg:send(Player2#player.socket, Bin),
	Player2;

gm_cmd("task",[Lv0|_],Player0) ->
	LvMax = db:config_level_max(),
	Lv = erlang:min(LvMax, erlang:abs(list_to_integer(Lv0))),
%% 	Player1 = chat_gateway:gm_cmd("lv", [integer_to_list(Lv)],Player0),
%% 	Player2 = chat_gateway:gm_cmd("gold", [integer_to_list(Lv*10000)],Player1),
	Player3 = gm_submit(Player0, 0, Lv),
	AllTasks = role_api_dict:tasks_get(),
	task_c(Player3, AllTasks, Lv);
	
	
%% 	LvMax = db:config_level_max(),
%% 	Lv = erlang:min(LvMax, erlang:abs(list_to_integer(Lv0))),	
%% 	Player2 = task_mod:submit(Player, 0, Lv, ?CONST_TRUE),
%% 	Player3 = task_c(Player2, Lv),
%% 	#tasks{tlist=Tasks} = role_api_dict:tasks_get(),
%% 	Bin = task_api:msg(?P_TASK_DATA, [Tasks]), 
%% 	app_msg:send(Player3#player.socket, Bin),
%% 	Player3;

gm_cmd("taskc",_,#player{socket = Socket, lv = Lv} = Player) ->
	AllTasks = role_api_dict:tasks_get(),
	#tasks{tlist=Tasks} = AllTasks,
	Fun = fun(#user_task{state = State} = UT, {TasksAcc, BinAcc}) ->
				  case State of
					  ?CONST_TASK_STATE_UNFINISHED ->
						  UT2 = UT#user_task{state = ?CONST_TASK_STATE_FINISHED},
						  BinAcc2 = task_api:msg(?P_TASK_DATA, [UT2]),
						  {[UT2|TasksAcc], <<BinAcc/binary, BinAcc2/binary>>};
					  _ ->
						  {[UT|TasksAcc], BinAcc}
				  end
		  end,
	{Tasks2, BinMsg} = lists:foldl(Fun, {[], <<>>}, Tasks),
	app_msg:send(Socket, BinMsg),
	role_api_dict:tasks_set(AllTasks#tasks{tlist=Tasks2}),
	gm_cmd("lv", [integer_to_list(Lv + 1)],Player);
	


gm_cmd("country", [Country0|_], #player{socket = Socket} = Player) ->
	Country = list_to_integer(Country0),
	case task_mod:choose_country(Player, Country) of
		{?ok, Player2, BinMsg} ->
			app_msg:send(Socket, BinMsg),
			Player2;
		_ ->
			Player
	end;

gm_cmd("time",_,Player) ->
	{Y0, M0, D0} = util:date(),
	{H0, I0, S0} = util:time(),
	[Y,M,D,H,I,S] = [util:to_list(T) || T <- [Y0,M0,D0,H0,I0,S0] ],
	Msg = iolist_to_binary([Y, "年", M, "月", D, "日 ", H, "时", I, "分", S, "秒"]),
	BinMsg = chat_api:msg_rece(?CONST_CHAT_SYSTEM,0,<<"">>,1,1,1,1,[],?CONST_CHAT_GOODS,<<0,0>>,0,0,Msg,0,<<"">>,1,1),
	app_msg:send(Player#player.socket, BinMsg),
	Player;

%% 设置玩家属性  自己+伙伴
gm_cmd("attr",[Type0, Value0],#player{socket = Socket, attr = Attr} = Player) ->
	Type = list_to_integer(Type0),
	Value00 = list_to_integer(Value0),
	Value = abs(util:ceil(Value00)),
	case lists:keyfind(Type, 1, ?ATTR_TYPE_POS) of
		{_, Pos} ->
			Inn = role_api_dict:inn_get(),
			Attr2 = erlang:setelement(Pos, Attr, Value),
			Acc0 = role_api:msg_property_update(0,Type,Value),
			Fun = fun(#partner{partner_id=PartId,attr = Attrp} = Partner, {PartAcc, BinAcc}) ->
						  Attrp2 = erlang:setelement(Pos, Attrp, Value),
						  BinAcc2 = role_api:msg_property_update(PartId,Type,Value),
						  {[Partner#partner{attr = Attrp2}|PartAcc], <<BinAcc/binary,BinAcc2/binary>>};
					 (_, Acc) ->
						  Acc
				  end,
			{Ps2, BinMsg} = lists:foldl(Fun, {[], Acc0}, Inn#inn.partners),
			app_msg:send(Socket, BinMsg),
			Inn2 = Inn#inn{partners = Ps2},
			role_api_dict:inn_set(Inn2),
			Player#player{attr = Attr2};
		_ ->
			BinMsg = system_api:msg_error(?ERROR_BADARG),
			app_msg:send(Socket, BinMsg),
			Player
	end;
%% 设置玩家属性 指定自己或者伙伴
gm_cmd("attr",[ID0, Type0, Value0],#player{socket = Socket, attr = Attr} = Player) ->
	ID = list_to_integer(ID0),
	Type = list_to_integer(Type0),
	Value00 = list_to_integer(Value0),
	Value = abs(util:ceil(Value00)),
	case lists:keyfind(Type, 1, ?ATTR_TYPE_POS) of
		{_, Pos} ->
			if
				ID == 0 ->
					Attr2 = erlang:setelement(Pos, Attr, Value),
					BinMsg = role_api:msg_property_update(0,Type,Value),
					app_msg:send(Socket, BinMsg),
					Player#player{attr = Attr2};
				?true ->
					Inn = role_api_dict:inn_get(),
					case lists:keytake(ID, #partner.partner_id, Inn#inn.partners) of
						{value, #partner{attr = Attrp} = Partner, Ps} ->
							Attrp2 = erlang:setelement(Pos, Attrp, Value),
							BinMsg = role_api:msg_property_update(ID,Type,Value),
							app_msg:send(Socket, BinMsg),
							Ps2 = [Partner#partner{attr = Attrp2}|Ps],
							Inn2 = Inn#inn{partners = Ps2},
							role_api_dict:inn_set(Inn2),
							Player;
						_ ->
							BinMsg = system_api:msg_error(?ERROR_BADARG),
							app_msg:send(Socket, BinMsg),
							Player
					end
			end;
		_ ->
			BinMsg = system_api:msg_error(?ERROR_BADARG),
			app_msg:send(Socket, BinMsg),
			Player
	end;

gm_cmd("lvup",[Lv0|_],Player) ->
	Lv = list_to_integer(Lv0),
    lv_up(Lv),
	Player;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%格斗之王gm%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gm_cmd("book",_,Player) ->
	wrestle_api:rbook(),
	Player;

gm_cmd("pres",_,Player) ->
	wrestle_api:control_preliminary(),
	Player;

gm_cmd("pre",[Turn0|_],Player) ->
	Turn = list_to_integer(Turn0),
	wrestle_api:control_preliminary_test(Turn),
	Player;

gm_cmd("fin",[Turn0|_],Player) ->
	Turn = list_to_integer(Turn0),
	wrestle_api:control_final_test(Turn),
	Player;
	
gm_cmd("fins",_,Player) ->
	wrestle_api:control_final(),
	Player;

gm_cmd("group",_,Player) ->
	wrestle_api:group(),
	Player;

gm_cmd("fgroup",_,Player) ->
	wrestle_api:final_group(),
	Player;
	
gm_cmd("rew",_,Player) ->
	wrestle_api:rew(),
	Player;

gm_cmd("clean",_,Player)->
	wrestle_api:clean(),
	Player;

% 制作斗气
gm_cmd("dq",[DqId0,Lv0|_], Player) ->
	{DqId, Lv} = {list_to_integer(DqId0),list_to_integer(Lv0)},
	DouQi = role_api_dict:douqi_get(),
	#douqi{sto_temp=StoTemp0} = DouQi,
	case ?CONST_DOUQI_STORAGE_NUM - length(StoTemp0) of
		N when N =< 0 ->
			BinMsg = system_api:msg_error(?ERROR_DOUQI_STORAGE_FULL),
			app_msg:send(Player#player.socket, BinMsg);
		_ ->
			case data_fight_gas_total:get({DqId,Lv}) of
				#d_fight_gas_total{next_lv_exp=NextExp,color=Color,type=Type} ->
					NewGas=#dq_data{dq_exp=NextExp-1, dq_id=idx_api:douqi_id(), dq_lv=Lv,
									dq_type=DqId, equip_type=Type, dq_color=Color},
					StoTemp=douqi_api:insert_new_gas(StoTemp0, NewGas, ?CONST_DOUQI_STORAGE_START),
					role_api_dict:douqi_set(DouQi#douqi{sto_temp=StoTemp});
				_ ->
					BinMsg = system_api:msg_error(?ERROR_DOUQI_NO_DOUQI),
					app_msg:send(Player#player.socket, BinMsg)
			end
	end,
	Player;

gm_cmd(_Command,_ArgList,Player) ->
	?MSG_ERROR("GM In Command:~p ArgList:~p ",[_Command, _ArgList]),
	Player.

%% 一键强化至当前等级
strengthen(#player{socket= Socket,money=Money}=Player) ->
	Money2= Money#money{gold= 999999,rmb=99999},
	Player2= Player#player{money=Money2},
	Idxs= [11,12,13,14,15,31,32,33],
	Idx= util:rand_list(Idxs),
	case make_mod:stren_key(Player2,1,2,0,Idx,?false,?false,0) of
		{?ok,Player3,BinMsg} ->
			{Player3,BinMsg};
		{?error,_ErrorCode} ->
			{Player2,<<>>}
	end.


%% 不知火舞
partner(#player{socket=Socket}= Player) ->
	case bag_api:goods_id_count_get(49001) >= 1 of
		?true ->
			case bag_api:goods_use(Player, ?CONST_GOODS_CONTAINER_BAG, 49001, 1, 1) of 
				{?ok,Player2,Bin} ->
					{Player2,Bin};
				_ ->
					{Player,<<>>}
			end;
		_ ->
			{Player,<<>>}
	end.

partner2(#player{socket=Socket,lv= Lv}= Player) ->
	case Lv >= 8 of
		?true ->
			case inn_api:inn_call_partner(Player, 10021) of
				{?ok,Player2,Bin}->
					inn_api:inn_use_list(),
					app_msg:send(Socket, Bin),
					{Player2,Bin};
				_ ->
					{Player,<<>>}
			end;
		_ ->
			{Player,<<>>}
	end.
	
	

%% 在线所有玩家升级
lv_up(Lv) ->
	Online = ets:tab2list(?ETS_ONLINE),	
	[util:pid_send(Uid, ?MODULE,lv_cb,[Lv])|| #player{uid = Uid}<- Online].

lv_cb(#player{lv = Lv0,socket = Socket,info = Info} = Player,[Lv]) ->
	case Lv0 >= Lv of
		?true ->
			Player;
		?false ->
			R = lists:seq(Lv0 + 1, Lv-1),
			NxetExp=?DATA_PLAYER_UP_EXP:get(?CONST_PLAYER,Player#player.lv),
			ExpAcc0 = NxetExp - Info#info.exp,
			ExpAdd = lists:foldl(fun(Level, Acc) ->
										 case ?DATA_PLAYER_UP_EXP:get(?CONST_PLAYER,Level) of
											 Exp when is_integer(Exp) ->
												 Acc + Exp;
											 _ ->    
												 Acc
										 end
								 end, ExpAcc0, lists:seq(Lv0 + 1, Lv-1)),
			{Player2, BinMsg} = role_api:currency_add([gm_cmd,[],<<"">>],Player, [{?CONST_CURRENCY_EXP,ExpAdd}]),
			app_msg:send(Socket, BinMsg),
			Player2
	end.					  
						  
						  
%% GM命令完成任务				  
gm_submit(Player, TaskId, Lv0) ->
	AllTask = role_api_dict:tasks_get(),
	gm_submit(Player, AllTask, TaskId, Lv0).

gm_submit(#player{socket=Socket} = Player, AllTask, _TaskId, Lv0) ->
	Fun = fun(#user_task{id = Id} = UT, {Acc, TaskID, B, BinaryMsg}) ->
				  case data_task:get(Id) of
					  #d_task{type = ?CONST_TASK_TYPE_MAIN, target_t = Tt, target_v = Tv, lv = Lv} ->
						  Bool = ?IF(Lv0 >= Lv, ?true, ?false),
						  case Tt == ?CONST_TASK_TARGET_OTHER andalso 
								   (erlang:element(1, Tv) == ?CONST_TASK_TO_COUNTRY orelse erlang:element(1, Tv) == ?CONST_TASK_DOWN_NEWS) 
							  of
							  ?true ->
								  UT2 = UT#user_task{state = ?CONST_TASK_STATE_UNFINISHED};
							  ?false ->
								  UT2 = UT#user_task{state = ?CONST_TASK_STATE_FINISHED}
						  
						  end,
						  BinMsg = task_api:msg(?P_TASK_DATA, [UT2]),
						  {[UT2|Acc], Id, B orelse Bool, <<BinMsg/binary, BinaryMsg/binary>>};
					  _ ->
						  {[UT|Acc], TaskID, B, BinaryMsg}
				  end
		  end,
	{Tasks2, ID, Boolean, Binmsg} = lists:foldl(Fun, {[], 0, ?false, <<>>}, AllTask#tasks.tlist),
	case ID == 0 orelse Boolean == ?false of
		?true ->
			chat_gateway:gm_cmd("lv", [integer_to_list(Lv0 + 1)],Player);
		?false ->
			app_msg:send(Socket, Binmsg),
			NewPlayer = 
				case task_mod:submit(Player, AllTask#tasks{tlist=Tasks2}, ID, ?CONST_COUNTRY_DEFAULT) of
					{?ok, Player2, Bin} ->
						app_msg:send(Socket, Bin),
						Player2;
					{?error, _ErrorCode} ->
						Player
				end,
			gm_submit(NewPlayer, ID, Lv0)
	end.						  
	
task_c(#player{socket=Socket}=Player, #tasks{tlist=Tasks} = AllTasks, Lv) ->
	Fun = fun(#user_task{id=Id,state = State} = UT, {Acc, BinAcc}) when 
			   State == ?CONST_TASK_STATE_ACCEPTABLE orelse State == ?CONST_TASK_STATE_UNFINISHED ->
				  #d_task{lv = Lv0} = data_task:get(Id),
				  if
					  Lv >= Lv0 ->
						  UT2 = UT#user_task{state = ?CONST_TASK_STATE_FINISHED},
						  Bin2 = task_api:msg(?P_TASK_DATA, [UT2]),
						  {[UT2|Acc], <<BinAcc/binary, Bin2/binary>>};
					  ?true ->
						  {[UT|Acc], BinAcc}
				  end;
			 (UT, {Acc, BinAcc}) ->
				  {[UT|Acc],BinAcc} 
		  end,
	{Tasks2, BinMsg} = lists:foldl(Fun, {[], <<>>}, Tasks),
	case BinMsg of
		<<>> ->
			Player;
		_ ->
			Fun2 = fun(#user_task{id = TaskId, state = ?CONST_TASK_STATE_FINISHED}, {PlayerAcc,BinmsgAc}) ->
						   case task_mod:submit(PlayerAcc, AllTasks#tasks{tlist=Tasks2}, TaskId, 0) of
							   {?ok, PlayerAcc2, Bs} ->
								   {PlayerAcc2, <<BinmsgAc/binary,Bs/binary>>};
							   _ ->
								   {PlayerAcc,BinmsgAc}
						   end;
					  (_, {PlayerAcc,BinmsgAc}) ->
						   {PlayerAcc,BinmsgAc}
				   end,
			{Player2, BinMsg2} = lists:foldl(Fun2, {Player, BinMsg}, Tasks2),
			AllTasksNew = role_api_dict:tasks_get(),
			app_msg:send(Socket, BinMsg2),
			task_c(Player2,  AllTasksNew, Lv)
	end.				  
						  
	




