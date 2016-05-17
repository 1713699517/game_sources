%% Author  : Tom Zhang
%% Created: 2012-6-20
%% Description: TODO: Add description to lib_player
-module(role_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 encode_sys/1,
		 decode_sys/1,
		 init_fcm/1,
		 init_attr_group/1,
		 init_sys/1,
		 pay_frist/2,
		 
		 db_save/2,
		 
		 gold_add/4,
		 gold_cut/4,
		 
		 
		 relink/6,
		 relink_check/6,
		 
		 currency_add/3,
		 currency_add/4,
		 currency_cut/3,
		 currency_cut/4,
		 currency_update/2,
		 currency_refresh/2,
		
		 exp_add/4,
		 exp_cut/2,
		 
		 integral_add/3,
		 integral_cut/3,
		 
		 integral_login/1,
		 integral_login/2,
		 
		 clan_u/3,
		 
		 login_routine/6,
		 login_ok/1,
		 logout/1,
		 change_socket_update/1,
		 
		 role_copy_attr/2,

		 role_data_cb/2,
		 
		 attr_refresh_side/5,
		 attr_refresh_side/6,
		 attr_update_player/3,
		 attr_all/3,
		 attr_last/6,
		 attr_sum/2,
		 attr_one_add/2,
		 attr_one_cut/2,
		 sys_use/1,
		 sys_open/3,
		 sys_task/2,
		 sys_lv/2,
		 role_sys/2,

		 uname_to_uid/1,
		 uname_color/1,
		 uname_to_player/1,
		 
		 uid_to_player/1,
%% 		 uname_to_lv/1,
%% 		 uname_to_pro/1,
		 
		 mpid_atom_reg/1,
		 mpid_atom_unreg/1,
		 mpid_atom/1,
		 mpid/1,
		 
		 min_pro/0,
		 min_sex/0,
		 min_country/0,
		 
		 lv/1,
		 score/2,
		 
		 online_all/1,
		 online_last/1,
		 online_count/2,
		 
		 powerful_calc/1,
		 powerful_sum/1,
		 update_powerful_z/1,
		 is_red/1,
		 is_online/1,
		 is_online2/1,
		 
		%  init_player_attr/3,
		 
		 inside_rmb/0,
		 inside_rmb_one/3, 
		 inside_rmb_cb/2, 
%% 		 update_money/3,


		 
%% 		 msg_out/1,
%% 		 msg_out2/1,
		 msg_score/2,
		 msg_sys_id/1,
		 msg_sys_id_2/1,
		 msg_login_ag_err/1,
		 msg_login_ok_no_role/1,
		 msg_property_update2/3,
		 msg_attr_diff/3,
		 msg_login_ok_have/1,
		 msg_property_update/3,
		 msg_name/1,
		 msg_del_ok/1,
		 msg_del_fail/1,
		 msg_property_reve/3,
		 msg_currency/3,
		 msg_online_reward/2,
		 msg_level_gift/1,
		 msg_partner_data/2,
		 msg_xxx2/1,
		 msg_fcm_prompt/3,
		 msg_disconnect/2,
		 msg_currency/1
		 ]). 

encode_sys(Sys)->
	Sys.
decode_sys(Sys)->
	Sys.


%% 初始化FCM
init_fcm(Player)->
	{Player,#fcm{}}.

%% 初始化复合属性
init_attr_group(Player=#player{pro=Pro,sex=Sex})->
	case data_player_init:get(Pro,Sex) of
		#d_player_init{attr=LvAttr,talent=Talent,lv=Lv} ->
			AttrGroup=#attr_group{lv=LvAttr},
			Attr	 = role_api:attr_all(AttrGroup, Lv, Talent),
			{Player#player{attr=Attr,lv=Lv},AttrGroup};
		_->
			{Player,#attr_group{}}
	end.

%% 初始化系统开放
init_sys(Player=#player{lv=Lv})->
	case data_sys_open:get(?CONST_SYS_LV,Lv) of
		?null->{Player,#sys{}};
		Lvsys->
			Lvsys2=[{LvSysId,?CONST_TRUE}||LvSysId<-Lvsys],
			{Player,#sys{lv_sys=Lvsys2}}
	end.


%% 任务sys更新
sys_task(#player{socket=Socket},TaskId)->
	Sys=role_api_dict:sys_get(),
	TaskSys=sys_open(?CONST_SYS_TASK,trunc(TaskId/10),Sys#sys.task_sys),
	Sys2=Sys#sys{task_sys=TaskSys},
	role_sys(Socket,Sys2),
	role_api_dict:sys_set(Sys2).

sys_lv(Socket,Lv)->
	Sys=role_api_dict:sys_get(),
	LvSys=sys_open(?CONST_SYS_LV,Lv,Sys#sys.lv_sys),
	Sys2=Sys#sys{lv_sys=LvSys},
	role_sys(Socket,Sys2),
	role_api_dict:sys_set(Sys2).

%% 系统开放
sys_open(Type,V,Sys) when is_list(Sys)->
	Sys2=[SysId||{SysId,_}<-Sys],
	List = data_sys_open:get(Type,V),
	case data_sys_open:get(Type,V) of
		?null->
			Sys;
		List->
			case List--Sys2 of
				[]->
					Sys;
				NewList->
					NewList2=[{NewId,?CONST_FALSE}||NewId<-NewList],
					NewList2++Sys
			end
	end;
sys_open(_Type,_V,Sys)->Sys.

%% 系统开放
role_sys(Socket,Sys)->
	#sys{lv_sys=LVsys,task_sys=TaskSys}=Sys,
	{LVsys2,TaskSys2}=role_sys_jr(LVsys,TaskSys),
	Sys2=Sys#sys{lv_sys=LVsys2,task_sys=TaskSys2},
	BinMsg=msg_sys_id_2(LVsys2++TaskSys2),
	role_api_dict:sys_set(Sys2),
	app_msg:send(Socket, BinMsg).

role_sys_jr([],[])->{[],[]};
role_sys_jr([],[TaskSysId|TaskSys])->
	TaskSys2=?IF(is_integer(TaskSysId),[{TaskSysId2,?CONST_FALSE}||TaskSysId2<-[TaskSysId|TaskSys]],[TaskSysId|TaskSys]),
	{[],TaskSys2};
role_sys_jr([LvSysId|LVsys],[])->
	LVsys2=?IF(is_integer(LvSysId),[{LvSysId2,?CONST_FALSE}||LvSysId2<-[LvSysId|LVsys]],[LvSysId|LVsys]),
	{LVsys2,[]};
role_sys_jr([LvSysId|LVsys],[TaskSysId|TaskSys])->
	LVsys2=?IF(is_integer(LvSysId),[{LvSysId2,?CONST_FALSE}||LvSysId2<-[LvSysId|LVsys]],[LvSysId|LVsys]),
	TaskSys2=?IF(is_integer(TaskSysId),[{TaskSysId2,?CONST_FALSE}||TaskSysId2<-[TaskSysId|TaskSys]],[TaskSysId|TaskSys]),
	{LVsys2,TaskSys2}.
		
	
%% 系统功能使用
sys_use(SysId)->
	Sys=role_api_dict:sys_get(),
	#sys{lv_sys=LVsys,task_sys=TaskSys}=Sys,
	LVsys2=sys_state(SysId,LVsys),
	TaskSys2=sys_state(SysId,TaskSys),
	Sys2=#sys{lv_sys=LVsys2,task_sys=TaskSys2},
	role_api_dict:sys_set(Sys2).
	
sys_state(SysId,SysList)->
	case lists:keytake(SysId,1,SysList) of
		{value,_,SysList2}->
			[{SysId,?CONST_TRUE}|SysList2];
		_->
			SysList
	end.
		
%% 
%% sys_jianrong([SysId|_])->
%% 	is_integer(SysId).
%% 	
		
		
		
%% 家族更新
clan_u(Id,ClanId,ClanName)->
	BinMsg=msg_property_update(Id,?CONST_ATTR_CLAN,ClanId),
	BinMsg2=msg_property_update2(Id,?CONST_ATTR_CLAN_NAME,ClanName),
	<<BinMsg/binary,BinMsg2/binary>>.
	
%% fcm(Player=#player{fcm=Fcm},Now) when is_record(Fcm, fcm)->
%% 	Fcm2 = case Fcm#fcm.fcm of
%% 			   ?CONST_FALSE ->
%% 				   Fcm;
%% 			   ?CONST_TRUE  ->
%% 				   if
%% 					   Now - Fcm#fcm.fcm_nt > 0 ->
%% 						   {FcmState,FcmNt,FcmBinMsg} = role_mod:fcm_side(Fcm#fcm.fcm_init,Fcm#fcm.login,Now), 
%% 						   app_msg:send(Player#player.socket,FcmBinMsg),
%% 						   Fcm#fcm{fcm_state=FcmState,fcm_nt=FcmNt};
%% 					   ?true ->
%% 						   Fcm
%% 				   end
%% 		   end,
%% 	% 定时 存player数据
%% 	Fcm3 = if
%% 			   abs(Now - Fcm2#fcm.save) > ?CONST_DB_SAVE andalso Player#player.is_db =:= ?CONST_TRUE ->
%% 				   ?MSG_ECHO("mongo_data:player_save Sid:~p, Uid:~p ",[Player#player.sid, Player#player.uid]),
%% 				   % mongo_data:player_save(Player#player.sid, Player#player.uid, Player),
%% 				   role_mod:db_save(Player, ?CONST_FALSE),
%% 				   Fcm2#fcm{save = Now + ?CONST_DB_SAVE};
%% 			   ?true ->
%% 				   Fcm2
%% 		   end,
%% 	% 定时与客户端时间同步
%% 	if
%% 		abs(Now - Fcm3#fcm.tsp) > ?CONST_TSP_INTERVAL ->
%% 			Fcm4 = Fcm3#fcm{tsp = Now + ?CONST_TSP_INTERVAL},
%% 			BinSystemTime 	= system_api:msg_time(Now),
%% 			app_msg:send(Player#player.socket, BinSystemTime),
%% 			Player#player{fcm=Fcm4};
%% 		?true ->
%% 			Player#player{fcm=Fcm3}
%% 	end;
%% fcm(Player,_Now)->
%% 	Player.


%% 修改玩家名字
%% change_name(Uid, Uname) ->
%% 	Ref = erlang:make_ref(),
%% 	role_api:progress_send(Uid, ?MODULE, change_name_cb, [self(),Ref,Uname]),
%% 	receive
%% 		{?ok,Ref} ->
%% 			{?ok, callback}
%% 	after 5000 ->
%% 			ets:update_element(?ETS_ONLINE, Uid, [{#ets_online.uid, Uname}]),
%% 			mysql_api:update(app_tool:sid(), user, [{uname,Uname}], "uid="++util:to_list(Uid))
%% 	end.
%% 
%% 
%% %% callback change player name
%% change_name_cb(#player{socket = Socket} = Player, [From,Ref,Uname]) ->
%% 	Info=role_dict:info_get(),
%% 	Info2 = Info#info{name = Uname},
%% 	From!{?ok, Ref},
%% 	BinMsg = msg_property_update2(0, ?CONST_ATTR_NAME, Uname),
%% 	app_msg:send(Socket, BinMsg),
%% 	Player#player{info = Info2}.



			
update_name(Sid,Uid,Name)->
%% 	case get_pid(Uid) of 
%% 		Mpid when is_pid(Mpid)->
%% 			progress_send(Mpid,?MODULE,update_name_cb,Name);
%% 		_->
%% 			case player_data_offline(Sid, Uid) of
%% 				{?ok,Player} when is_record(Player,player)->
%% 					Player2=update_name_cb(Player,Name),
%% 					db_save(Player2);
%% 				_->?skip
%% 			end
%% 	end.
	?ok.
					
update_name_cb(Player,Name)->Player.
%% 	Info2=Info#info{name=Name},
%% 	Player#player{info=Info2}.
		
%% 	case Lv=:=YLv of
%% 		?true->?null;
%% 		_->
%% 		 data_level_gift:get(Lv)
%% 	end.
%% 	case data_level_gift:get(Lv) of
%% 		GiveList when is_list(GiveList)-> ?null;
%% 		GiveList ->
%% 			LogSrc=[?MODULE,online_rewardlv,[],<<"在线等级奖励">>],
%% 			case goods_api:set(LogSrc,Player,GiveList) of
%% 				{?ok,Player2,Bin}->
%% 					app_msg:send(Socket,Bin),
%% 					online_rewardlv(Player2,Lv);
%% 				{?error,ErrorCode}->
%% 					BinMsg = system_api:msg_error(ErrorCode),
%% 					app_msg:send(Socket, BinMsg),
%% 					Player
%% 			end
%% 	end.


%% 登录成功返回数据 
login_ok(#player{money=Money,socket=Socket,info=Info,uid=Uid}=Player) ->
	#money{gold=Gold,rmb=Rmb,rmb_bind=BindRmb}=Money,
	Sys=role_api_dict:sys_get(),
	role_api:role_sys(Socket,Sys),
	%% 登录角色信息
	BinMsg 		 = msg_login_ok_have(Player), 
	%% 时间校正
	BinSystemTime= system_api:msg_time(util:seconds()),
	copy_api:login(),
	hero_api:login(),
	fiend_api:login(),
	fighters_api:login(),
	shoot_api:login(),
	title_api:login(Uid),
	logs_api:login(Player),
	mail_api:login(Player),
	weagod_api:login(),
	clan_api:login(Player),
	sign_api:login(),
	flsh_api:login(Socket),
	task_api:login_task(Player),
	energy_api:login(Player),
	card_api:sales_notice(Player),
    task_daily_api:task_daily_login(Player),
	inn_api:updata_partner_init(Socket),
	InnPowerful=inn_api:inn_powerful(),
	Powerful2=Info#info.powerful+InnPowerful,
	BinZPowerful=msg_property_update(0,?CONST_ATTR_ALLS_POWER,Powerful2),
	% Player2 = copy_api:up_login(Player),
	BinMoney	 = msg_currency(Gold,Rmb,BindRmb),
	app_msg:send(Socket, <<BinMsg/binary,BinSystemTime/binary,BinMoney/binary,BinZPowerful/binary>>),
	?MSG_ECHO("~n**********************Player:~p Loginip: ~p**********************~n", [Player#player.uid,util:ip(Socket)]),
	Player;
login_ok(Player) ->
	Player.


logout(Player=#player{info=Info})->
	Fcm =role_api_dict:fcm_get(),
	if
		is_record(Info, info) andalso is_record(Fcm, fcm)->
			scene_api:exit_scene(Player),
			mail_api:logout(Player),
			clan_api:logout(Player),
			wrestle_api:off_line(Player),
			Player2 = copy_api:logout(Player),
			Player3 = hero_api:logout(Player2),
			Player4 = fiend_api:logout(Player3),
			Player5 = team_api:logout(Player4),
			role_db:role_save(Player5, ?CONST_TRUE),
%% 			GoddsList2=logout_bag(),
%% 			?MSG_ERROR("tui chu beibao wupin id ~w~n",[GoddsList2]),
			role_db:ets_online_delete(Player#player.uid),
			?MSG_ECHO("---------------------shu ju yi bao cun logout Uid:~w ip: ~p Save Ok!! ",[Player#player.uid,(Player#player.io)#io.login_ip]),
			?ok;
		?true->
			?skip
	end;
logout(_Player)->
	?skip.

%% 退出显示背包物品和数量
logout_bag()->
	Bag=role_api_dict:bag_get(),
	#bag{list=GoddsList}=Bag,
	Fun=fun(#goods{goods_id=ID,count=Count},Acc)->
				case lists:keytake(ID,1,Acc) of
					{_,{_,Count2},Acc2}->
						[{ID,Count+Count2}|Acc2];
					_->
						[{ID,Count}|Acc]
				end;
		   (_,Acc)->
				Acc
		end,
	lists:foldl(Fun,[],GoddsList).



%% 加经验
%% 返回:Player
exp_add(Player, V,_LogMethod,_LogRemark) when V =< 0 ->
	Player;
exp_add(Player=#player{socket=Socket}, SrcExp,LogMethod,LogRemark) ->
	Fcm = role_api_dict:fcm_get(),
	V	= 
		case Fcm#fcm.fcm_state of
			?CONST_FCM_NORMAL ->
				SrcExp;
			?CONST_FCM_HALF ->
				util:floor(SrcExp/2);
			?CONST_FCM_NOTHING ->
				0
		end,
	%% --
	BinMsg = logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_ADD, ?CONST_CURRENCY_EXP, V),
	app_msg:send(Socket, BinMsg),
	Player2=exp_add_acc(Player, V,LogMethod,LogRemark),
	inn_api:exp_add_inn(Player2,V,LogMethod,LogRemark).

exp_add_acc(Player, V,_LogMethod,_LogRemark) when V =< 0 -> 
	Player;
exp_add_acc(Player=#player{socket=Socket,info=Info,lv=Lv,uid=Uid},Exp,LogMethod,LogRemark)->
	stat_api:logs_exp(Uid, Lv, LogMethod, Exp, Exp + Info#info.exp, <<"lv:",?B(Lv),"->",?B(LogRemark) >>),
	NextExp = ?DATA_PLAYER_UP_EXP:get(?CONST_PLAYER,Lv),  
	ExpLack = abs(NextExp - Info#info.exp),
	NewExp  = Exp + Info#info.exp,
	BinMsg  = role_api:msg_property_update(0,?CONST_ATTR_EXP,NewExp),  
	case Exp >= ExpLack of  
		?true->
			LvMax = db:config_level_max(),
			if
				is_integer(LvMax),LvMax =/= 0,Lv >= LvMax ->
					Info2=Info#info{exp=erlang:min(NewExp, NextExp)},
					app_msg:send(Socket, BinMsg),
					Player#player{info=Info2};
				?true ->
					Player2 = role_mod:level_up(Player),
					top_api:top_lv_updata(Player2),
					card_api:sales_notice(Player2),
%% 					role_mod:onlin_reward_lv(Uid,(Player2#player.info)#info.lv),
					logs_api:lv_notice(Uid, Player2#player.lv),
					clan_api:ref_clan_master_lv(Uid, Player2#player.lv),
					exp_add_acc(Player2, Exp - ExpLack,LogMethod,LogRemark)
			end;				
		?false-> 
			Info2=Info#info{exp=NewExp},
			app_msg:send(Socket, BinMsg),
			Player#player{info=Info2}
	end.

%% 减经验 
%% 返回: {true, Player} | false
exp_cut(Player=#player{info=Info,lv=Lv},Exp)->
	case Info#info.exp >= Exp of
		?true->
			stat_api:logs_exp(Player#player.uid,Lv,?MODULE, exp_cut, -Exp, Info#info.exp-Exp, <<"lv:",(util:to_binary(Lv))/binary>>),
			Info2 =Info#info{exp=Info#info.exp-Exp},
			{?true,Player#player{info=Info2}};
		?false->
			?false 
	end.


%% 内部加	钱币(仅限铜钱、金币、元宝、礼券之类)
%% 返回: {Player, BinMsg}
gold_add(Player=#player{uid=Uid,lv=Lv,money=Money},Type,Value0, LogSrc) when is_integer(Value0) andalso Value0 > 0 ->
	Value = util:ceil(Value0),
	{Money2,_Balance} =
		case Type of
			?CONST_CURRENCY_GOLD ->
				NewGold = Money#money.gold+Value,
				currency_update(Uid, [{gold,NewGold}]),
				stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_GOLD, Value, NewGold, LogSrc),
				{Money#money{gold=NewGold},NewGold};
			?CONST_CURRENCY_RMB_BIND->
				NewRmb = Money#money.rmb_bind+Value,
				currency_update(Uid, [{rmb_bind,NewRmb}]),
				stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_RMB_BIND, Value, NewRmb, LogSrc),
				{Money#money{rmb_bind=NewRmb},NewRmb};
			?CONST_CURRENCY_RMB ->
				NewRmb = Money#money.rmb+Value,
				currency_update(Uid, [{rmb,NewRmb}]),
				stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_RMB, Value, NewRmb, LogSrc),
				{Money#money{rmb=NewRmb},NewRmb}
		end, 
	BinMsg = msg_currency(Money2),
	{Player#player{money=Money2}, BinMsg};
gold_add(Player,_Type,_Value, _LogSrc) ->
	{Player, <<>>}.

%% 扣钱币(仅限铜钱、金币、元宝、礼券之类)
%% 返回: {true, Player, BinMsg} | false
gold_cut(Player=#player{mpid=Mpid,uid=Uid,lv=Lv,money=Money},Type,Value0, LogSrc) when Value0 > 0 ->
	Value = util:ceil(Value0),
	case Type of
		?CONST_CURRENCY_GOLD ->
			if
				Money#money.gold < Value ->
					{?error,?ERROR_GOLD_LACK};
				?true->
					Balance = Money#money.gold - Value,
					Money2  = Money#money{gold=Balance},
					BinMsg  = msg_currency(Money2),
					currency_update(Uid, [{gold,Balance}]),
					stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_GOLD, -Value, Balance, LogSrc),
					util:pid_send(Mpid, weagod_api, check_gold_cb, ?null),
					?MSG_ECHO("BinMsg=~w~n",[BinMsg]),
					{?true,Player#player{money=Money2},BinMsg}
			end;
		T when T==?CONST_CURRENCY_RMB orelse T==?CONST_CURRENCY_RMB_BIND->
			case if
					 Money#money.rmb < Value ->
						 if
							 Money#money.rmb_bind + Money#money.rmb < Value ->
								 {?error,?ERROR_RMB_LACK};
							 ?true->
								 Balance= Money#money.rmb_bind-(Value-Money#money.rmb),
								 Money2=Money#money{rmb=0,rmb_bind=Balance},
								 BinMsg = msg_currency(Money2),
								 currency_update(Uid, [{rmb,0},{rmb_bind,Balance}]),
								 ?IF(Money#money.rmb=<0,?skip,stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_RMB, -Money#money.rmb, 0, LogSrc)),
								 stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_RMB_BIND, -Value-Money#money.rmb, Balance, LogSrc),
								 {?true,Player#player{money=Money2},BinMsg}
						 end;
					 ?true->
						 Balance = Money#money.rmb - Value,
						 Money2=Money#money{rmb=Balance},
						 BinMsg = msg_currency(Money2),
						 currency_update(Uid, [{rmb,Balance}]),
						 stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_RMB, -Value, Balance, LogSrc),
						 {?true,Player#player{money=Money2},BinMsg}
				 end of
				{?true, Player2, Binmsg} ->
					Integral = util:ceil(Value * ?CONST_MALL_EXCHANGE_RATE / ?CONST_PERCENT),
					Player3  = integral_add(LogSrc, Player2, Integral),
					{?true, Player3, Binmsg};
				{?error, ErrorCode} ->
					{?error, ErrorCode}
			end
	end;
gold_cut(_Player,_Type,_Value, _LogSrc) ->
	{?error,?ERROR_CURRENCY_LACK}.	


%% integral_add(LogSrc, #player{uid=Uid,lv=Lv,info=Info} = Player, Value0) when Value0 > 0 ->
%% 	case collect_api:get_state(99999) of
%% 		?CONST_TRUE ->
%% 			Value 		= util:ceil(Value0),
%% 			NewIntegral = Info#info.integral + Value,
%% 			Info2 		= Info#info{integral = NewIntegral, integral_time = util:seconds()},
%% 			stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_PAY_POINT, Value, NewIntegral, LogSrc),
%% 			Player#player{info = Info2};
%% 		_ ->
%% 			Player
%% 	end;

integral_add(LogSrc, Player, Value) ->
%% 	?MSG_ERROR("Err {LogSrc,Value} : ~p~n", [{LogSrc,Value}]),
	Player.


%% return : {?ok, Player} | {?error, ErrorCode}
integral_cut(LogSrc, #player{lv=Lv,uid=Uid,info=Info} = Player, Value0) when Value0 > 0 ->
	Value = util:ceil(Value0),
	if
		Info#info.integral >= Value ->
			NewIntegral = Info#info.integral - Value,
			Info2 = Info#info{integral = NewIntegral},
			stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_PAY_POINT, -Value, NewIntegral, LogSrc),
			{?ok, Player#player{info = Info2}};
		?true ->
			{?error, ?ERROR_INTEGRAL_LACK}
	end;
integral_cut(LogSrc, #player{uid = Uid}, Value) ->
	?MSG_ERROR("Err {Uid, Value, LogSrc} : ~p~n", [{Uid, Value, LogSrc}]),
	{?error, ?ERROR_BADARG}.


integral_login(#player{info = Info} = Player) ->
	case Info#info.integral of
		0 ->
			Player;
		_ ->
			State = collect_api:get_state(?CONST_FALSE),
			integral_login(Player, State)
	end.

integral_login(#player{info = #info{integral = 0}} = Player, _State) ->
	Player;

integral_login(#player{info = Info} = Player, ?CONST_TRUE) ->
	case collect_api:find_date(?CONST_FALSE) of
		{0,0} ->
			Player;
		{SecondsS,_SecondsE} ->
			if
				Info#info.integral_time == 0 orelse
							  Info#info.integral_time < SecondsS ->
					Info2 = Info#info{integral = 0, integral_time = 0},
					Player#player{info = Info2};
				?true ->
					Player
			end
	end;

integral_login(#player{info = Info} = Player, _) ->
	Info2 = Info#info{integral = 0, integral_time = 0},
	Player#player{info = Info2}.


%% Currency:[{Type,value}]
%% LogSrc :: [Module, Func, Item, Remark]
%% 增加货币      例子：role_api:currency_add([arena_reward_day,[],<<"封神台每日奖励">>],
%% 												Player,[{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_RENOWN,Renown}]),
%% 返回: {Player, Bin}
currency_add(LogSrc, Player, Currency0) ->
	Currency = [{T, V} || {T, V} <- Currency0, T =/= 0 andalso V =/= 0 ],
	{Player2, BinAcc, LogBin} = currency_add(Player, Currency, <<>>, <<>>, LogSrc),
	{Player2, <<BinAcc/binary,LogBin/binary>>}.
%% Currency:[{Type,value}]
%% LogSrc :: [Module, Func, Item, Remark]
%% 增加货币      例子：role_api:currency_add([arena_reward_day,[],<<"封神台每日奖励">>],
%% 												Player,[{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_RENOWN,Renown}]),
%% 返回: {Player, Bin}  不飘日志提示
currency_add(LogSrc, Player, Currency0, ?false) ->
	Currency = [{T, V} || {T, V} <- Currency0, T =/= 0 andalso V =/= 0 ],
	{Player2, BinAcc, _LogBin} = currency_add(Player, Currency, <<>>, <<>> , LogSrc),
	{Player2, BinAcc}.

currency_add(Player, [], BinAcc, LogBin, _LogSrc) ->
	{Player, BinAcc, LogBin};
currency_add(Player=#player{info=Info,uid=Uid}, [{CT,CV}|Currency], BinAcc, LogBin, LogSrc) when CV=/=0  ->
	case CT of
		T when T == ?CONST_CURRENCY_GOLD 
		orelse T == ?CONST_CURRENCY_RMB 
		orelse T == ?CONST_CURRENCY_RMB_BIND ->% 加钱币
			{Player2, BinMsg} = gold_add(Player, CT, CV, LogSrc), 
			BinMsg2 = logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY,?CONST_LOGS_ADD, CT, CV),
			currency_add(Player2, Currency, <<BinAcc/binary,BinMsg/binary>>, <<LogBin/binary,BinMsg2/binary>>, LogSrc);
		?CONST_CURRENCY_RENOWN ->% 加声望
			Info2=Info#info{renown=Info#info.renown+erlang:abs(CV)},
			Player2 = Player#player{info=Info2},
			BinMsg=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_ADD, CT, CV),
			currency_add(Player2, Currency, BinAcc, <<LogBin/binary,BinMsg/binary>>, LogSrc);
		?CONST_CURRENCY_ENERGY ->% 加精力
			energy_api:energy_add(LogSrc,Player, erlang:abs(CV)),
			BinMsg=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_ADD, CT, CV),
			currency_add(Player, Currency, BinAcc, <<LogBin/binary,BinMsg/binary>>, LogSrc);
		?CONST_CURRENCY_EXP ->% 加经验 0
			[Func, _Item, Remark] = LogSrc,
			Fcm	= role_api_dict:fcm_get(),
			Exp	= 
				case Fcm#fcm.fcm_state of
					?CONST_FCM_NORMAL ->
						erlang:abs(CV);
					?CONST_FCM_HALF ->
						util:floor(erlang:abs(CV)/2);
					?CONST_FCM_NOTHING ->
						0
				end,
			Player2 = exp_add_acc(Player, Exp, Func, Remark),
			Player3 = inn_api:exp_add_inn(Player2,erlang:abs(CV), Func, Remark),
			BinMsg  = logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_ADD, CT, Exp),
			currency_add(Player3, Currency, BinAcc, <<LogBin/binary,BinMsg/binary>>, LogSrc);
		?CONST_CURRENCY_DEVOTE ->% 加帮贡
			clan_api:devote_add(LogSrc, Uid, erlang:abs(CV)),
			BinMsg=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_ADD, CT, CV),
			currency_add(Player, Currency, BinAcc, <<LogBin/binary,BinMsg/binary>>, LogSrc);
		?CONST_CURRENCY_ADV_SKILL -> %战功
            {?ok,Player2,BinMsg1} = skill_api:add_power(LogSrc,Player, CV),
			BinMsg2 = logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_ADD, CT, CV),  
			currency_add(Player2, Currency, <<BinAcc/binary,BinMsg1/binary>>, <<LogBin/binary,BinMsg2/binary>>, LogSrc);
		?CONST_COMPETITIVE_PEBBLE -> %竞技水晶
			{?ok,Player2,BinMsg1} = wrestle:add_pebble(LogSrc,Player, CV),
 			BinMsg2=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_ADD, CT, CV),
			?MSG_ECHO("BinMsg2=~w~n",[BinMsg1]),
			currency_add(Player2, Currency, <<BinAcc/binary,BinMsg1/binary>>, <<LogBin/binary,BinMsg2/binary>>, LogSrc);				
		?CONST_CURRENCY_PAY_POINT ->
			Player2 = integral_add(LogSrc, Player, CV),
			currency_add(Player2, Currency, BinAcc, LogBin, LogSrc);
		_ ->
			currency_add(Player, Currency, BinAcc, LogBin, LogSrc)
	end;
currency_add(Player, [{_CT,_CV}|Currency], BinAcc, LogBin, LogSrc) ->
	currency_add(Player, Currency, BinAcc, LogBin, LogSrc).

	

%% LogSrc :: [Module, Func, Item, Remark]
%% 扣减货币 
%% 返回: {ok, Player, Bin} | {error, ErrorCode}
currency_cut(LogSrc, Player, Currency0) ->
	Currency = [{T, V} || {T, V} <- Currency0, T =/= 0 andalso V =/= 0 andalso V>0],
	case currency_cut(Player, Currency, <<>>, <<>>, LogSrc) of
		{?ok, Player2, BinAcc, BinLog} ->
			{?ok, Player2, <<BinAcc/binary, BinLog/binary>>};
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.
currency_cut(LogSrc, Player, Currency0, ?false) ->
	Currency = [{T, V} || {T, V} <- Currency0, T =/= 0 andalso V =/= 0 andalso V>0],
	case currency_cut(Player, Currency, <<>>, <<>>, LogSrc) of
		{?ok, Player2, BinAcc, _BinLog} ->
			{?ok, Player2, BinAcc};
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.

currency_cut(Player, [], BinAcc, BinLog, _LogSrc) ->
	{?ok, Player, BinAcc, BinLog};
currency_cut(Player, [{Type,CV}|Currency], BinAcc, BinLog, LogSrc) ->
	case Type of
		T when T == ?CONST_CURRENCY_GOLD 
				   orelse T == ?CONST_CURRENCY_RMB orelse T == ?CONST_CURRENCY_RMB_BIND ->
			case gold_cut(Player, Type, CV, LogSrc) of
				{?true, Player2, BinMsg} ->
					BinMsg2=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_DEL, Type, CV),
					currency_cut(Player2, Currency, <<BinAcc/binary,BinMsg/binary>> ,<<BinLog/binary,BinMsg2/binary>>, LogSrc);
				{?error, ErrorCode}->
					{?error, ErrorCode}
			end;
		?CONST_CURRENCY_ENERGY ->% 扣精力
			case energy_api:energy_use(LogSrc,Player, erlang:abs(CV)) of
				{?ok,Player2,BinMsg}  ->
					BinMsg2=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_DEL, Type, CV),
					currency_cut(Player2, Currency, <<BinAcc/binary,BinMsg/binary>> ,<<BinLog/binary,BinMsg2/binary>>, LogSrc);
				{?error, ErrorCode}->
					{?error, ErrorCode}
			end;
		?CONST_CURRENCY_DEVOTE ->% 消耗帮贡
			case clan_api:devote_cut(LogSrc, Player, CV) of
				{?ok,Player2,BinMsg} ->
					BinMsg2=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_DEL, Type, CV),
					currency_cut(Player2, Currency, <<BinAcc/binary,BinMsg/binary>> ,<<BinLog/binary,BinMsg2/binary>>, LogSrc);
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		?CONST_CURRENCY_ADV_SKILL -> %战功
            {?ok,Player2,BinMsg1} = skill_api:cut_power(LogSrc,Player, CV),
			BinMsg2=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_DEL, Type, CV),
			currency_cut(Player2, Currency, <<BinAcc/binary,BinMsg1/binary>> ,<<BinLog/binary,BinMsg2/binary>>, LogSrc);
		?CONST_CURRENCY_PAY_POINT ->
			case integral_cut(LogSrc, Player, CV) of
				{?ok, Player2} ->
					currency_cut(Player2, Currency, BinAcc, BinLog, LogSrc);
				{?error, ErrorCode} ->
					{?error, ErrorCode}
			end;					
		_ ->
			currency_cut(Player, Currency, BinAcc, BinLog, LogSrc)
	end.
 
%% currency_update 
currency_update(Uid, DataList) ->
	DataStr = lists:map(fun({Field, {binary,Data} }) ->
								"`"++util:to_list(Field)++"`  =  "++mysql_api:escape(Data)++"";
						   ({Field,Data})->
								 "`"++util:to_list(Field)++"` = '"++mysql_api:escape(Data)++"'"
						end,DataList),
	Query= util:list_to_string(DataStr, "UPDATE user SET ", ",", "WHERE uid=" ++ util:to_list(Uid)),
	?MSG_ECHO("======= ~w~n",[Query]),
	mysql_api:fetch_cast(Query).

%% 读出MYSQL里的金币
%% 返回: Money#money{}
currency_refresh(Uid,Money) when is_record(Money,money)->
	case mysql_api:select("SELECT `gold`, `rmb`, `rmb_bind`,`rmb_total` FROM user Where uid=" ++ util:to_list(Uid)) of
	%% case mysql_api:select(Sid, [gold, rmb, rmb_bind,rmb_total], user) of
		{?ok, [[Gold, Rmb, RmbBind,RmbTotal|_]|_]} ->
			% ?MSG_ECHO("~p",[{Gold, Rmb, RmbBind,RmbTotal}]),
			Money0	= Money#money{gold = Gold, rmb_bind = RmbBind, rmb = Rmb,rmb_total=RmbTotal},
			Money1  = role_db:money(Uid, Money0),
			Money1;
		_Any ->
			% ?MSG_ECHO("~p",[_Any]), 
			Money
	end;
currency_refresh(Uid,_Money) ->
	currency_refresh(Uid,#money{gold = 0, rmb_bind = 0, rmb = 0,rmb_total=0,rmb_consume=0}). 




%% soul_type(?CONST_CURRENCY_SOUL_VIGOUR) ->
%% 	?CONST_COLOR_BLUE;
%% soul_type(?CONST_CURRENCY_SOUL_VIGOUR_PURPLE) ->
%% 	?CONST_COLOR_VIOLET;
%% soul_type(?CONST_CURRENCY_SOUL_VIGOUR_GOLD) ->
%% 	?CONST_COLOR_GOLD;
%% soul_type(?CONST_CURRENCY_SOUL_VIGOUR_ORANGE) ->
%% 	?CONST_COLOR_ORANGE;
%% soul_type(?CONST_CURRENCY_SOUL_VIGOUR_RED) ->
%% 	?CONST_COLOR_RED;
%% soul_type(L) ->
%% 	L.

%% 加入阵营
sign_country(Player,Country)->
	Player#player{country = Country}.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 属性改变重新计算最终值
attr_all(AttrGroup,Lv,Talent)->
	#attr_group{lv=LvAttr,matrix=MatrixAttr,pet=PetAttr,honor=HonorAttr,renown=RenownAttr,mount = MountAttr,douqi=DouQi,
				society=SocietyAttr,equip=EquipAttr,treasure = TreasureAttr,clan=Clan}=AttrGroup,
	Attr=attr_sum(#attr{},[LvAttr,MatrixAttr,PetAttr,HonorAttr,RenownAttr,MountAttr,DouQi,SocietyAttr,EquipAttr,TreasureAttr,Clan]),
	#attr{hp_gro=HpGro,strong_gro=StrongGro,magic_gro=MagicGro}=Attr, 
	attr_last(Attr,Lv,Talent,HpGro,StrongGro,MagicGro).
  
attr_sum(Attr,AttrList) when is_record(Attr,attr)-> 
	AttrList2=[Attr0||Attr0<-AttrList,is_record(Attr0,attr)],
	Fun=fun(TypeAttr,Attr0) when is_record(TypeAttr,attr) ->
				#attr{sp =Sp, 		           sp_up =SpSpeed,	      anima =Anima,          hp =Hp, 
					  hp_gro =HpGro,           strong =Strong,        strong_gro =StrongGro, magic =Magic, 
					  magic_gro =MagicGro, 	   strong_att =StrongAtt, strong_def =StrongDef, skill_att =SkillAtt, 
					  skill_def =SkillDef,     crit =Crit, 	          crit_res =CritRes,     crit_harm =CritHarm, 
					  defend_down =DefendDown, light =Light,          light_def =LightDef,   dark =Dark, 
					  dark_def =DarkDef,       god =God,              god_def =GodDef,       bonus =Bonus, 
					  reduction =Reduction,    imm_dizz =ImmDizz}=Attr0,
				
				#attr{sp =TypeSp, 		           sp_up =TypeSpSpeed,     	  anima =TypeAnima,          hp =TypeHp, 
					  hp_gro =TypeHpGro,           strong =TypeStrong,        strong_gro =TypeStrongGro, magic =TypeMagic, 
					  magic_gro =TypeMagicGro, 	   strong_att =TypeStrongAtt, strong_def =TypeStrongDef, skill_att =TypeSkillAtt, 
					  skill_def =TypeSkillDef,     crit =TypeCrit, 	          crit_res =TypeCritRes,     crit_harm =TypeCritHarm, 
					  defend_down =TypeDefendDown, light =TypeLight,          light_def =TypeLightDef,   dark =TypeDark, 
					  dark_def =TypeDarkDef,       god =TypeGod,              god_def =TypeGodDef,       bonus =TypeBonus, 
					  reduction =TypeReduction,    imm_dizz =TypeImmDizz}=TypeAttr,
				Attr0#attr{
						   sp 			=	Sp 		 	+ 	TypeSp, 
						   sp_up	 		=	SpSpeed	 	+ 	TypeSpSpeed, 
						   anima 		=	Anima		+	TypeAnima, 
						   hp 			=	Hp			+	TypeHp, 
						   hp_gro  		=	HpGro		+	TypeHpGro, 
						   strong 		=	Strong		+	TypeStrong, 
						   strong_gro 	=	StrongGro	+	TypeStrongGro, 
						   magic 		=	Magic		+	TypeMagic, 
						   magic_gro 	=	MagicGro		+	TypeMagicGro, 
						   strong_att 	=	StrongAtt	+	TypeStrongAtt,
						   strong_def 	=	StrongDef	+	TypeStrongDef,
						   skill_att 	=	SkillAtt		+	TypeSkillAtt,
						   skill_def 	=	SkillDef		+	TypeSkillDef,
						   crit 			=	Crit			+	TypeCrit, 
						   crit_res 		=	CritRes		+	TypeCritRes, 
						   crit_harm 	=	CritHarm		+	TypeCritHarm, 
						   defend_down 	=	DefendDown	+	TypeDefendDown, 
						   light 		=	Light		+	TypeLight, 
						   light_def 	=	LightDef		+	TypeLightDef, 
						   dark 			=	Dark			+	TypeDark, 
						   dark_def 		=	DarkDef		+	TypeDarkDef, 
						   god 			=	God			+	TypeGod, 
						   god_def 		=	GodDef		+	TypeGodDef, 
						   bonus 		=	Bonus		+	TypeBonus, 
						   reduction 	=	Reduction	+	TypeReduction, 
						   imm_dizz 		=	ImmDizz		+	TypeImmDizz
						  }
		end,
	lists:foldl(Fun, Attr, AttrList2);
attr_sum(_,AttrList)->attr_sum(#attr{},AttrList).

%% attr_sum(Attr,AttrList) when is_record(Attr,attr)-> 
%% 	AttrList2=[Attr0||Attr0<-AttrList,is_record(Attr0,attr)],
%% 	Fun=fun(TypeAttr,Attr0) when is_record(TypeAttr,attr) ->
%% 				attr_add_attr2(TypeAttr,Attr0)
%% 		end,
%% 	lists:foldl(Fun, Attr, AttrList2);
%% attr_sum(_,AttrList)->
%% 	attr_sum(#attr{},AttrList).
%% 
%% attr_add_attr2(TypeAttr,Attr0) ->
%% 	attr_add_attr2(TypeAttr,Attr0,2).
%% attr_add_attr2(TypeAttr,_Attr0,N) when N>erlang:size(TypeAttr) ->TypeAttr;
%% attr_add_attr2(TypeAttr,Attr0,N) ->
%% 	OneAttrO=erlang:element(N, TypeAttr),
%% 	OneAttrN=erlang:element(N, Attr0),
%% 	TypeAttr2=erlang:setelement(N, TypeAttr, OneAttrO+OneAttrN),
%% 	attr_add_attr2(TypeAttr2,Attr0,N+1).
	

%% data_player_grow:grow(44, 1, 1.3).
attr_last(Attr,Lv,Talent,HpGro,StrongGro,MagicGro)->
	Hp			=	?DATA_PLAYER_GROW:grow(?CONST_ATTR_HP,				Lv,		HpGro),
	Strong		=	?DATA_PLAYER_GROW:grow(?CONST_ATTR_STRONG,		    Lv,		StrongGro),
	Magic		=	?DATA_PLAYER_GROW:grow(?CONST_ATTR_MAGIC,		    Lv,	 	MagicGro),
	Attr2 		= 	Attr#attr{
							  hp			=	Attr#attr.hp			+	Hp,
							  strong		=	Attr#attr.strong		+	Strong,
							  magic			=	Attr#attr.magic			+	Magic
							 },
	Attr3=Attr2#attr{strong_att=Attr2#attr.strong_att+Attr2#attr.strong*2,
					 strong_def=Attr2#attr.strong_def+Attr2#attr.strong*1,
					 skill_att=Attr2#attr.skill_att+Attr2#attr.magic*1,
					 skill_def=Attr2#attr.skill_def+Attr2#attr.magic*1
					 },
	attr_last_talent(Attr3,Talent).

attr_last_talent(Attr0,_Talent)->Attr0.
%% 	TypeList = ?DATA_PLAYER_TALENT:get(Talent),
%% %% 	?MSG_ECHO("Attr0::~p~n,TypeList:::~p~n",[Attr0,TypeList]),
%% 	Fun=fun({Type,Arg},Attr)->
%% 				case Type of
%% 					?CONST_ATTR_SP ->
%% 						Sp=?TALENT(Attr#attr.sp,Arg),
%% 						Attr#attr{sp=Sp};
%% 					?CONST_ATTR_SP_UP ->
%% 						SpUp=?TALENT(Attr#attr.sp_up,Arg),
%% 						Attr#attr{sp_up=SpUp};
%% 					?CONST_ATTR_ANIMA ->
%% 						Anima=?TALENT(Attr#attr.anima,Arg),
%% 						Attr#attr{anima=Anima};
%% 					?CONST_ATTR_HP ->
%% 						Hp=?TALENT(Attr#attr.hp,Arg),
%% 						Attr#attr{hp=Hp};
%% 					?CONST_ATTR_HP_GRO ->
%% 						HpGro=?TALENT(Attr#attr.hp_gro,Arg),
%% 						Attr#attr{hp_gro=HpGro};
%% 					?CONST_ATTR_STRONG ->
%% 						Strong=?TALENT(Attr#attr.strong,Arg),
%% 						Strong2=trunc(Attr#attr.strong*Arg/?CONST_PERCENT),
%% 						Attr#attr{strong=Strong,strong_att=Attr#attr.strong_att+Strong2*2,
%% 								  strong_def=Attr#attr.strong_att+Strong2*1};
%% 					?CONST_ATTR_STRONG_GRO ->
%% 						StrongGro=?TALENT(Attr#attr.strong_gro,Arg),
%% 						Attr#attr{strong_gro=StrongGro};
%% 					?CONST_ATTR_MAGIC ->
%% 						Magic=?TALENT(Attr#attr.magic,Arg),
%% 						Magic2=trunc(Attr#attr.magic*Arg/?CONST_PERCENT),
%% 						Attr#attr{magic=Magic,skill_att=Attr#attr.skill_att+Magic2*1,
%% 								  skill_def=Attr#attr.skill_def+Magic2*1};
%% 					?CONST_ATTR_MAGIC_GRO ->
%% 						MagicGro=?TALENT(Attr#attr.magic_gro,Arg),
%% 						Attr#attr{magic_gro=MagicGro};
%% 					?CONST_ATTR_STRONG_ATT ->
%% 						StrongAtt=?TALENT(Attr#attr.strong_att,Arg),
%% 						Attr#attr{strong_att=StrongAtt};
%% 					?CONST_ATTR_STRONG_DEF ->
%% 						StrongDef=?TALENT(Attr#attr.strong_def,Arg),
%% 						Attr#attr{strong_def=StrongDef};
%% 					?CONST_ATTR_SKILL_ATT ->
%% 						SkillAtt=?TALENT(Attr#attr.skill_att,Arg),
%% 						Attr#attr{skill_att=SkillAtt};
%% 					?CONST_ATTR_SKILL_DEF ->
%% 						SkillDef=?TALENT(Attr#attr.skill_def,Arg),
%% 						Attr#attr{skill_def=SkillDef};
%% 					?CONST_ATTR_CRIT ->
%% 						Crit=?TALENT(Attr#attr.crit,Arg),
%% 						Attr#attr{crit=Crit};
%% 					?CONST_ATTR_RES_CRIT ->
%% 						CritRes=?TALENT(Attr#attr.crit_res,Arg),
%% 						Attr#attr{crit_res=CritRes};
%% 					?CONST_ATTR_CRIT_HARM -> 
%% 						CritHarm=?TALENT(Attr#attr.crit_harm,Arg),
%% 						Attr#attr{crit_harm=CritHarm};
%% 					?CONST_ATTR_DEFEND_DOWN ->
%% 						DefendDown=?TALENT(Attr#attr.defend_down,Arg),
%% 						Attr#attr{defend_down=DefendDown};
%% 					?CONST_ATTR_LIGHT ->
%% 						LigHt=?TALENT(Attr#attr.light,Arg),
%% 						Attr#attr{light=LigHt};
%% 					?CONST_ATTR_LIGHT_DEF ->
%% 						LigHtDef=?TALENT(Attr#attr.light_def,Arg),
%% 						Attr#attr{light_def=LigHtDef};
%% 					?CONST_ATTR_DARK ->
%% 						Dark=?TALENT(Attr#attr.dark,Arg),
%% 						Attr#attr{dark=Dark};
%% 					?CONST_ATTR_DARK_DEF ->
%% 						DarkDef=?TALENT(Attr#attr.dark_def,Arg), 
%% 						Attr#attr{dark_def=DarkDef};
%% 					?CONST_ATTR_GOD->
%% 						God=?TALENT(Attr#attr.god,Arg), 
%% 						Attr#attr{god=God};
%% 					?CONST_ATTR_GOD_DEF->
%% 						GodDef=?TALENT(Attr#attr.god_def,Arg), 
%% 						Attr#attr{god_def=GodDef};
%% 					?CONST_ATTR_BONUS->
%% 						Bonus=?TALENT(Attr#attr.bonus,Arg), 
%% 						Attr#attr{bonus=Bonus};
%% 					?CONST_ATTR_REDUCTION->
%% 						Reduction=?TALENT(Attr#attr.reduction,Arg), 
%% 						Attr#attr{reduction=Reduction};
%% 					?CONST_ATTR_IMM_DIZZ->
%% 						ImmDizz=?TALENT(Attr#attr.imm_dizz,Arg), 
%% 						Attr#attr{imm_dizz=ImmDizz};
%% 					_->
%% 						Attr
%% 				end
%% 		end,
%% 	lists:foldl(Fun, Attr0, TypeList).
		

%% 单个属性增加
attr_one_add(Attr0,TypeList)->
	Fun=fun({Type,Arg},Attr)->
				case Type of
					?CONST_ATTR_SP ->
						Attr#attr{sp=Attr#attr.sp+Arg};
					?CONST_ATTR_SP_UP ->
						Attr#attr{sp_up=Attr#attr.sp_up+Arg};
					?CONST_ATTR_ANIMA ->
						Attr#attr{anima=Attr#attr.anima+Arg};
					?CONST_ATTR_HP ->
						Attr#attr{hp=Attr#attr.hp+Arg};
					?CONST_ATTR_HP_GRO ->
						Attr#attr{hp_gro=Attr#attr.hp_gro+Arg};
					?CONST_ATTR_STRONG ->
						Attr#attr{strong=Attr#attr.strong+Arg};
					?CONST_ATTR_STRONG_GRO ->
						Attr#attr{strong_gro=Attr#attr.strong_gro+Arg};
					?CONST_ATTR_MAGIC ->
						Attr#attr{magic=Attr#attr.magic+Arg};
					?CONST_ATTR_MAGIC_GRO ->
						Attr#attr{magic_gro=Attr#attr.magic_gro+Arg};
					?CONST_ATTR_STRONG_ATT ->
						Attr#attr{strong_att=Attr#attr.strong_att+Arg};
					?CONST_ATTR_STRONG_DEF ->
						Attr#attr{strong_def=Attr#attr.strong_def+Arg};
					?CONST_ATTR_SKILL_ATT ->
						Attr#attr{skill_att=Attr#attr.skill_att+Arg};
					?CONST_ATTR_SKILL_DEF ->
						Attr#attr{skill_def=Attr#attr.skill_def+Arg};
					?CONST_ATTR_CRIT ->
						Attr#attr{crit=Attr#attr.crit+Arg};
					?CONST_ATTR_RES_CRIT ->
						Attr#attr{crit_res=Attr#attr.crit_res+Arg};
					?CONST_ATTR_CRIT_HARM -> 
						Attr#attr{crit_harm=Attr#attr.crit_harm+Arg};
					?CONST_ATTR_DEFEND_DOWN ->
						Attr#attr{defend_down=Attr#attr.defend_down+Arg};
					?CONST_ATTR_LIGHT ->
						Attr#attr{light=Attr#attr.light+Arg};
					?CONST_ATTR_LIGHT_DEF ->
						Attr#attr{light_def=Attr#attr.light_def+Arg};
					?CONST_ATTR_DARK ->
						Attr#attr{dark=Attr#attr.dark+Arg};
					?CONST_ATTR_DARK_DEF ->
						Attr#attr{dark_def=Attr#attr.dark_def+Arg};
					?CONST_ATTR_GOD->
						Attr#attr{god=Attr#attr.god+Arg};
					?CONST_ATTR_GOD_DEF->
						Attr#attr{god_def=Attr#attr.god_def+Arg};
					?CONST_ATTR_BONUS->
						Attr#attr{bonus=Attr#attr.bonus+Arg};
					?CONST_ATTR_REDUCTION->
						Attr#attr{reduction=Attr#attr.reduction+Arg};
					?CONST_ATTR_IMM_DIZZ->
						Attr#attr{imm_dizz=Attr#attr.imm_dizz+Arg};
					_->
						Attr
				end
		end,
	Attr2=lists:foldl(Fun, Attr0, TypeList),
	Attr2#attr{strong_att=Attr2#attr.strong_att+Attr2#attr.strong*2,
			   strong_def=Attr2#attr.strong_def+Attr2#attr.strong*1,
			   skill_att=Attr2#attr.skill_att+Attr2#attr.magic*1,
			   skill_def=Attr2#attr.skill_def+Attr2#attr.magic*1
			  }.

%% attr_one_add(Attr0,TypeList)->
%% 	Fun = fun({Type,Arg},Attr)->
%% 				  case util:post_tuple(Type, ?ATTR_ARG) of
%% 					  0 -> Attr;
%% 					  N ->
%% 						  OneAttr=erlang:element(N, Attr),
%% 						  erlang:setelement(N, Attr, OneAttr+Arg)
%% 				  end
%% 		  end,
%% 	Attr2=lists:foldl(Fun, Attr0, TypeList),
%% 	Attr2#attr{strong_att=Attr2#attr.strong_att+Attr2#attr.strong*2,
%% 			   strong_def=Attr2#attr.strong_def+Attr2#attr.strong*1,
%% 			   skill_att=Attr2#attr.skill_att+Attr2#attr.magic*1,
%% 			   skill_def=Attr2#attr.skill_def+Attr2#attr.magic*1
%% 			  }.

%% 单个属性减少
attr_one_cut(Attr0,TypeList)->
	Fun=fun({Type,Arg},Attr)->
				case Type of
					?CONST_ATTR_SP ->
						Attr#attr{sp=?IF((Attr#attr.sp-Arg)=<0,0,Attr#attr.sp-Arg)};
					?CONST_ATTR_SP_UP ->
						Attr#attr{sp_up=?IF((Attr#attr.sp_up-Arg)=<0,0,Attr#attr.sp_up-Arg)};
					?CONST_ATTR_ANIMA ->
						Attr#attr{anima=?IF((Attr#attr.anima-Arg)=<0,0,Attr#attr.anima-Arg)};
					?CONST_ATTR_HP ->
						Attr#attr{hp=?IF((Attr#attr.hp-Arg)=<0,0,Attr#attr.hp-Arg)};
					?CONST_ATTR_HP_GRO ->
						Attr#attr{hp_gro=?IF((Attr#attr.hp_gro-Arg)=<0,0,Attr#attr.hp_gro-Arg)};
					?CONST_ATTR_STRONG ->
						Attr#attr{strong=?IF((Attr#attr.strong-Arg)=<0,0,Attr#attr.strong-Arg)};
					?CONST_ATTR_STRONG_GRO ->
						Attr#attr{strong_gro=?IF((Attr#attr.strong_gro-Arg)=<0,0,Attr#attr.strong_gro-Arg)};
					?CONST_ATTR_MAGIC ->
						Attr#attr{magic=?IF((Attr#attr.magic-Arg)=<0,0,Attr#attr.magic-Arg)};
					?CONST_ATTR_MAGIC_GRO ->
						Attr#attr{magic_gro=?IF((Attr#attr.magic_gro-Arg)=<0,0,Attr#attr.magic_gro-Arg)};
					?CONST_ATTR_STRONG_ATT ->
						Attr#attr{strong_att=?IF((Attr#attr.strong_att-Arg)=<0,0,Attr#attr.strong_att-Arg)};
					?CONST_ATTR_STRONG_DEF ->
						Attr#attr{strong_def=?IF((Attr#attr.strong_def-Arg)=<0,0,Attr#attr.strong_def-Arg)};
					?CONST_ATTR_SKILL_ATT ->
						Attr#attr{skill_att=?IF((Attr#attr.skill_att-Arg)=<0,0,Attr#attr.skill_att-Arg)};
					?CONST_ATTR_SKILL_DEF ->
						Attr#attr{skill_def=?IF((Attr#attr.skill_def-Arg)=<0,0,Attr#attr.skill_def-Arg)};
					?CONST_ATTR_CRIT ->
						Attr#attr{crit=?IF((Attr#attr.crit-Arg)=<0,0,Attr#attr.crit-Arg)};
					?CONST_ATTR_RES_CRIT ->
						Attr#attr{crit_res=?IF((Attr#attr.crit_res-Arg)=<0,0,Attr#attr.crit_res-Arg)};
					?CONST_ATTR_CRIT_HARM -> 
						Attr#attr{crit_harm=?IF((Attr#attr.crit_harm-Arg)=<0,0,Attr#attr.crit_harm-Arg)};
					?CONST_ATTR_DEFEND_DOWN ->
						Attr#attr{defend_down=?IF((Attr#attr.defend_down-Arg)=<0,0,Attr#attr.defend_down-Arg)};
					?CONST_ATTR_LIGHT ->
						Attr#attr{light=?IF((Attr#attr.light-Arg)=<0,0,Attr#attr.light-Arg)};
					?CONST_ATTR_LIGHT_DEF ->
						Attr#attr{light_def=?IF((Attr#attr.light_def-Arg)=<0,0,Attr#attr.light_def-Arg)};
					?CONST_ATTR_DARK ->
						Attr#attr{dark=?IF((Attr#attr.dark-Arg)=<0,0,Attr#attr.dark-Arg)};
					?CONST_ATTR_DARK_DEF ->
						Attr#attr{dark_def=?IF((Attr#attr.dark_def-Arg)=<0,0,Attr#attr.dark_def-Arg)};
					?CONST_ATTR_GOD->
						Attr#attr{god=?IF((Attr#attr.god-Arg)=<0,0,Attr#attr.god-Arg)};
					?CONST_ATTR_GOD_DEF->
						Attr#attr{god_def=?IF((Attr#attr.god_def-Arg)=<0,0,Attr#attr.god_def-Arg)};
					?CONST_ATTR_BONUS->
						Attr#attr{bonus=?IF((Attr#attr.bonus-Arg)=<0,0,Attr#attr.bonus-Arg)};
					?CONST_ATTR_REDUCTION->
						Attr#attr{reduction=?IF((Attr#attr.reduction-Arg)=<0,0,Attr#attr.reduction-Arg)};
					?CONST_ATTR_IMM_DIZZ->
						Attr#attr{imm_dizz=?IF((Attr#attr.imm_dizz-Arg)=<0,0,Attr#attr.imm_dizz-Arg)};
					_->
						Attr
				end
		end,
	Attr2=lists:foldl(Fun, Attr0, TypeList),
	Attr2#attr{strong_att=Attr2#attr.strong_att+Attr2#attr.strong*2,
			   strong_def=Attr2#attr.strong_def+Attr2#attr.strong*1,
			   skill_att=Attr2#attr.skill_att+Attr2#attr.magic*1,
			   skill_def=Attr2#attr.skill_def+Attr2#attr.magic*1
			  }.
%% %% 单个属性减少
%% attr_one_cut(Attr0,TypeList)->
%% 	Fun = fun({Type,Arg},Attr)->
%% 				  case util:post_tuple(Type, ?ATTR_ARG) of
%% 					  0 -> Attr;
%% 					  N ->
%% 						  OneAtt=erlang:element(N, Attr),
%% 						  NewAtt=?IF(OneAtt-Arg>0,OneAtt-Arg,0),
%% 						  erlang:setelement(N, Attr, NewAtt)
%% 				  end
%% 		  end,
%% 	Attr2=lists:foldl(Fun, Attr0, TypeList),
%% 	Attr2#attr{strong_att=Attr2#attr.strong_att+Attr2#attr.strong*2,
%% 			   strong_def=Attr2#attr.strong_def+Attr2#attr.strong*1,
%% 			   skill_att=Attr2#attr.skill_att+Attr2#attr.magic*1,
%% 			   skill_def=Attr2#attr.skill_def+Attr2#attr.magic*1
%% 			  }.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 各种系统属性更新
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 升级属性
attr_update_player(Player=#player{lv=Lv,attr=AttrOld,info=Info},lv,Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{lv=Attr},
			AttrNew=attr_all(AttrGroup2,Lv,Info#info.talent),
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>,?false);
		_->Player
	end;

%% 星阵图
attr_update_player(Player=#player{lv=Lv,attr=AttrOld,info=Info},matrix,Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{matrix=Attr},
			AttrNew=attr_all(AttrGroup2,Lv,Info#info.talent),
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>);
		_->Player
	end;

%% 宠物
attr_update_player(Player=#player{lv=Lv,attr=AttrOld,info=Info},pet,Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{pet=Attr},
			AttrNew=attr_all(AttrGroup2,Lv,Info#info.talent),
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>);
		_->Player
	end;

%% 坐骑
attr_update_player(Player=#player{lv=Lv,attr=AttrOld,info=Info},mount,Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{mount=Attr},
			AttrNew=attr_all(AttrGroup2,Lv,Info#info.talent),
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>); 
		_->Player
	end;

%% 荣誉
attr_update_player(Player=#player{lv=Lv,attr=AttrOld,info=Info},honor,Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{honor=Attr},
			AttrNew=attr_all(AttrGroup2,Lv,Info#info.talent),
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>);
		_->Player
	end;

%% 声望
attr_update_player(Player=#player{lv=Lv,attr=AttrOld,info=Info},renown,Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{renown=Attr},
			AttrNew=attr_all(AttrGroup2,Lv,Info#info.talent),
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>);
		_->Player
	end;

%% 帮派
attr_update_player(Player=#player{lv=Lv,attr=AttrOld,info=Info},clan,Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{clan=Attr},
			AttrNew=attr_all(AttrGroup2,Lv,Info#info.talent),
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>);
		_->Player
	end;

%% 斗气
attr_update_player(Player=#player{lv=Lv,attr=AttrOld,info=Info},douqi,Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{douqi=Attr},
			AttrNew=attr_all(AttrGroup2,Lv,Info#info.talent),
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>);
		_->Player
	end;

%% 好友
attr_update_player(Player=#player{lv=Lv,attr=AttrOld,info=Info},society,Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{society=Attr},
			AttrNew=attr_all(AttrGroup2,Lv,Info#info.talent), 
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>);
		_->Player
	end;

%% 装备
attr_update_player(Player=#player{lv=Lv,attr=AttrOld,info=Info},equip,Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{equip=Attr},
			AttrNew=attr_all(AttrGroup2,Lv,Info#info.talent),
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>);
		_->
			Player
	end;

%% %% 珍宝阁
attr_update_player(Player = #player{lv = Lv,attr = AttrOld,info = Info}, treasure, Attr)->
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2 = AttrGroup#attr_group{treasure = Attr},
			AttrNew = attr_all(AttrGroup2,Lv,Info#info.talent),
			attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>);
		_->
			Player
	end;

attr_update_player(Player,_Type,_Attr)->
	Player.

attr_refresh_side(Player=#player{mpid=Mpid,uid=Uid,info=Info},AttrGroup,AttrOld,AttrNew,BinMsg)->
%% 	?MSG_ECHO("~nAttrOld:: ~w~n AttrNew::~w~n",[AttrOld,AttrNew]),
	BinDiff		= msg_attr_diff(0,AttrOld, AttrNew),
	role_api_dict:attr_group_set(AttrGroup),
%% 	BinScore 	= msg_score(0, Equip),
	case <<BinDiff/binary,BinMsg/binary>> of
		<<>>   -> 
			Player;
		BinMsg2 ->
			Powerful=powerful_calc(AttrNew),
			InnPowerful=inn_api:inn_powerful(),
			Powerful2=Powerful+InnPowerful,
			BinLogs=logs_api:attr_change(AttrOld,AttrNew),
			BinZPowerful=msg_property_update(0,?CONST_ATTR_ALLS_POWER,Powerful2),
			BinPowerful=msg_property_update(0,?CONST_ATTR_POWERFUL, Powerful),
			app_msg:send(Mpid, <<BinMsg2/binary,BinPowerful/binary,BinZPowerful/binary,BinLogs/binary>>),
			Info2=Info#info{hp=AttrNew#attr.hp,powerful=Powerful},
			Player2=Player#player{attr=AttrNew,info=Info2},
			arena_api:arena_update_powerful(Uid,Powerful2),
			top_api:top_power_updata(Player2),
			Player2
	end.
attr_refresh_side(Player=#player{mpid=Mpid,uid=Uid,info=Info},AttrGroup,AttrOld,AttrNew,BinMsg,_Falg)->
	BinDiff		= msg_attr_diff(0,AttrOld, AttrNew),
	role_api_dict:attr_group_set(AttrGroup),
	case <<BinDiff/binary,BinMsg/binary>> of
		<<>>   -> 
			Player;
		BinMsg2 ->
			Powerful=powerful_calc(AttrNew),
			InnPowerful=inn_api:inn_powerful(),
			Powerful2=Powerful+InnPowerful,
			BinZPowerful=msg_property_update(0,?CONST_ATTR_ALLS_POWER,Powerful2),
			BinPowerful=msg_property_update(0,?CONST_ATTR_POWERFUL,Powerful),
			app_msg:send(Mpid, <<BinMsg2/binary,BinPowerful/binary,BinZPowerful/binary>>),
			Info2=Info#info{hp=AttrNew#attr.hp,powerful=Powerful},
			Player2=Player#player{attr=AttrNew,info=Info2},
			arena_api:arena_update_powerful(Uid,Powerful2),
			top_api:top_power_updata(Player2),
			Player2
	end.

%% 战斗里更新
update_powerful_z(Player=#player{socket=Socket,uid=Uid,info=Info})->
	InnPowerful=inn_api:inn_powerful(),
	Powerful2=InnPowerful+Info#info.powerful,
	BinPowerful=msg_property_update(0,?CONST_ATTR_ALLS_POWER,Powerful2),
%% 	Info2=Info#info{powerful=Powerful2},
	app_msg:send(Socket,BinPowerful),
%% 	Player2=Player#player{info=Info2},
	arena_api:arena_update_powerful(Uid,Powerful2),
	top_api:top_power_updata(Player).

%% 人物总战斗力
powerful_sum(#player{info=Info})->
	InnPowerful=inn_api:inn_powerful(),
	InnPowerful+Info#info.powerful.
	
	


%% 计算属性战斗力
powerful_calc(Attr) ->
	L	= powerful_ratio(Attr),
	erlang:round(lists:sum(L)). 

powerful_ratio(Attr) ->
	Attr2=#attr{
					hp 				=	?CONST_ATTR_SCORE_HP  *	Attr#attr.hp, 
					strong_att 		=	?CONST_ATTR_SCORE_STRONG_ATT  *	Attr#attr.strong_att, 
					strong_def 		=	?CONST_ATTR_SCORE_STRONG_DEF  *	Attr#attr.strong_def, 
					skill_att 		=	?CONST_ATTR_SCORE_SKILL_ATT  *	Attr#attr.skill_att, 
					skill_def 		=	?CONST_ATTR_SCORE_SKILL_DEF  *	Attr#attr.skill_def, 
					crit 			=	?CONST_ATTR_SCORE_CRIT  *	Attr#attr.crit, 
					crit_res 		=	?CONST_ATTR_SCORE_RES_CRIT  *	Attr#attr.crit_res, 
					crit_harm 		=	?CONST_ATTR_SCORE_CRIT_HARM  *	Attr#attr.crit_harm, 
					defend_down 		=	?CONST_ATTR_SCORE_DEFEND_DOWN  *	Attr#attr.defend_down, 
					bonus 			=	?CONST_ATTR_SCORE_BONUS  *	Attr#attr.bonus, 
					reduction 		=	?CONST_ATTR_SCORE_REDUCTION  *	Attr#attr.reduction
			 }, 
	AList=tuple_to_list(Attr2),
	[_|AList2]=AList,
	AList2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%登陆操作%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%短线重莲限制
relink_check(Player,FcmInit,Sid,Uid,Os,Versions)->
	case mpid(Uid) of
		Pid when is_pid(Pid)->
			ets:insert(?ETS_S_GLOBAL,{{relink,Uid},util:seconds()}),
			Msg={inet_async,?undefined,Uid,{?error,closed}},
			?MSG_ERROR("duan xian cheng lian zi dong duan kai",[]),
			util:pid_send(Pid,Msg),
			relink(Player,FcmInit,Sid,Uid,Os,Versions);
		_->
			login_routine(Player,FcmInit,Sid,Uid,Os,Versions)
	end.

%%%%%%%%%%%%%断线重连操作%%%%%%%%%%%%%%%%%%%%%%%%%%%%
relink(Player=#player{socket=NewSocket,mpid=MPid,is=Is},FcmInit,Sid,Uid,Os,Versions)->
	case role_mod:login_again(NewSocket,MPid,Uid,Os) of
		{?ok, ?change_socket}->
			Is2=Is#is{is_db=?CONST_FALSE},
			?MSG_ERROR("duan xian chen gong ~w~n",[Uid]),
			{?ok,?change_socket,Player#player{uid=0,socket=?null,is=Is2}};
		_->
			?MSG_ERROR("duan xian cuo wu chong xin deng lu  ~w~n",[Uid]),
			login_routine(Player, FcmInit, Sid, Uid, Os, Versions)
	end.

%%%%%%%%%%%%%常规登陆操作%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
login_routine(Player=#player{socket=Socket,mpid=Mpid,is=Is},FcmInit,Sid,Uid,Os,Versions)->
	crond_api:reg(self(), ?LOOP_TIME_PLAYER),
	Fcm	= fcm_api:record_fcm(FcmInit, Socket),
	case role_mod:login(Socket,Mpid,Fcm,Uid,Sid) of
		{?ok,?null} ->
			mpid_atom_reg(Uid),
			%% 登录无角色信息
			Is2			 = Is#is{is_db=?CONST_FALSE},
			Player2		 = Player#player{uid=Uid,is=Is2},
			%% 时间校正 发职业
			Pro			 = role_api:min_pro(),
			BinMsg		 = role_api:msg_login_ok_no_role(Pro),
			BinSystemTime= system_api:msg_time(util:seconds()),
			app_msg:send(Socket, <<BinMsg/binary,BinSystemTime/binary>>),
			{?ok,Player2};
		{?ok,Player2}->
			mpid_atom_reg(Uid), 
			Is2			 = Is#is{is_db=?CONST_TRUE},
			IoDB		 = Player2#player.io,
			Io2			 = IoDB#io{os		  = Os,
								   versions	  = Versions,
								   login_ip	  = util:ip(Socket),
								   login_time = util:seconds() },
			Player3		 = Player2#player{socket=Socket,mpid=Mpid},
			Player4 	 = role_api:login_ok(Player3),
			Sys=role_api_dict:sys_get(),
			role_sys(Socket,Sys),
			role_db:ets_online_update(Player4),
			sys_set_api:sys_set_login(Socket),
			%% 时间校正
			BinSystemTime= system_api:msg_time(util:seconds()),
			app_msg:send(Socket, BinSystemTime),
			{?ok, Player4#player{io=Io2,is =Is2,uname_color=?CONST_COLOR_GOLD}};
		{?error,ErrorCode} when is_integer(ErrorCode)->
			BinMsg		 = system_api:msg_error(?ERROR_BUSY_MYSQL),
			app_msg:send(Socket,BinMsg),
			util:pid_send(Mpid, ?exit), %% 退出
			{?ok,Player#player{uid=0}};
		_->
			BinMsg		 = system_api:msg_error(?ERROR_BUSY_MYSQL),
			app_msg:send(Socket,BinMsg),
			util:pid_send(Mpid, ?exit), %% 退出
			{?ok,Player#player{uid=0}}
	end.

%%%%%%%%%%%%%%%%%断线重连后操作%%%%%%%%%%%%%%%%%%
change_socket_update(Player=#player{socket=NewSocket,uid=Uid})->
	BinMsg=role_api:msg_login_ag_err(?CONST_TRUE),
	app_msg:send(NewSocket, BinMsg),
	Player2 = scene_api:relink(Player),
	Player3=login_ok(Player2),
	ets:update_element(?ETS_MAP_PLAYER, Uid, 		[{#player_s.socket, NewSocket}]),
	ets:update_element(?ETS_ONLINE, 	Uid, 		[{#player.mpid, self()}]),
	ets:update_element(?ETS_ONLINE, 	Uid, 		[{#player.socket,NewSocket}]),
	Player3.
%% relink(#player{socket = NewSocket,uid = Uid, money = Money,info=Info} = Player) ->
%% 	Tasks	= role_api_dict:tasks_get(),
%% 	BinMsg 	= msg_login_ag_err(?CONST_TRUE),
%% 	PlayerS = scene_mod:record_player_s(Player),
%% 	{Player2, BinMsg5015} = 
%% 		if
%% 			Info#info.map_type == 1 ->
%% 				?IF(Info#info.map_type == 1, skywar_api:break_line(Uid), ?skip),
%% 				{scene_api:enter_login(Player), <<>>};
%% 			?true ->
%% 				{Player,scene_api:msg_enter_ok(PlayerS, Info#info.map_id, ?CONST_MAP_ENTER_NULL,?CONST_FALSE)}
%% 		end,
%% %% 	BinTaskClear = <<>>, %task_api:msg_clear(),
%% %% 	BinTask 	 = task_api:msg(?P_TASK_DATA, [Tasks]),
%% 	BinCurrency  = role_api:msg_currency(Money#money.gold, Money#money.rmb, Money#money.rmb_bind),
%% %% 	app_msg:send(NewSocket, <<BinMsg/binary,BinMsg5015/binary, BinTaskClear/binary, BinTask/binary, BinCurrency/binary>>),
%% 	ets:update_element(?ETS_MAP_PLAYER, Uid, 		[{#player_s.socket, NewSocket}]),
%% 	ets:update_element(?ETS_ONLINE, 	Uid, 		[{#player.mpid, self()}]),
%% 	Player2.
%% 	war_api:war_type(Player2).

%%副本属性替换
role_copy_attr(Player=#player{socket=Socket},Attr)->
	BinMsg=msg_property_reve(Player,?true,Attr),
	app_msg:send(Socket,BinMsg).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%　查看玩家属性
role_data_cb(Player=#player{uid=Uid},{Socket,Type,Falg})->
	case Type of
		0 ->
			BinMsg = msg_property_reve(Player,Falg,?null), 
			app_msg:send(Socket, BinMsg),
			Player;
		PartnerId ->
			{_,Inn}=?IF(Falg==?true,{?ok,role_api_dict:inn_get()},role_api_dict:inn_get(Uid)),
			case lists:keyfind(PartnerId,#partner.partner_id,Inn#inn.partners) of
				Partner when is_record(Partner,partner)->
					BinMsg = role_api:msg_partner_data(Player#player.uid,Partner), 
					app_msg:send(Socket,BinMsg),
					Player;
				_->
					BinMsg = role_api:msg_del_fail(?ERROR_INN_NO_PARTNER),
					app_msg:send(Socket,BinMsg),
					Player
			end
	end.


% {ScoreEq,ScorePear,ScoreJew,ScoreMag} = role_api:get_score(ID, Equip)
score(_ID, Equip) ->goods_api:score_attr(Equip).
%% 	Key = case ID of
%% 			  0 ->
%% 				  score_role;
%% 			  _ ->
%% 				  {score_partner, ID}
%% 		  end,
%% 	case erlang:get(Key) of
%% 		?undefined ->
%% 			S = goods_api:score_attr(Equip),
%% 			erlang:put(Key, S),
%% 			S;
%% 		S ->
%% 			S
%% 	end.


	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mpid_atom(Uid)->
	util:list_to_atom("u_"++integer_to_list(Uid)).
%% 注册别名
mpid_atom_reg(Uid)->?MSG_ECHO("~p~n", [Uid]),
	RegName = mpid_atom(Uid),
	case whereis(RegName) of
		?undefined -> ?skip;
		_          -> erlang:unregister(RegName)
	end,
	erlang:register(RegName, self()).
%% 注销别名注册
mpid_atom_unreg(Uid) ->
	RegName = mpid_atom(Uid),
	case whereis(RegName) of
		?undefined -> ?skip;
		_          -> erlang:unregister(RegName)
	end.
%% 
mpid(Uid)->
	RegName = mpid_atom(Uid),
	erlang:whereis(RegName).			

uname_to_uid(Name)->
	MS=[{'$1',[{'=:=',{element,6,'$1'},{const,Name}}],['$1']}],
%% 		[{'$1',[{'=:=',{element,2,'$1'},{const,1111}}],['$1']}]
%% 	MS=ets:fun2ms(fun(R) when R#player.uname =:= Name->R end),
	EtsOnline=ets:select(?ETS_ONLINE,MS),
	case EtsOnline of
		[] -> ?null;
		[Online|_] ->Online#player.uid
	end.

uid_to_player(Uid)->
	MS=[{'$1',[{'=:=',{element,2,'$1'},{const,Uid}}],['$1']}],
%% 	MS=ets:fun2ms(fun(R) when R#player.uid =:= UID-> R end),
	EtsOnline=ets:select(?ETS_ONLINE,MS),
	case EtsOnline of
		[] -> ?null;
		[Online|_] ->Online
	end.

uname_to_player(Name)->
	MS=[{'$1',[{'=:=',{element,6,'$1'},{const,Name}}],['$1']}],
%% 	MS=ets:fun2ms(fun(R) when R#player.uname =:= Name->R end),
	EtsOnline=ets:select(?ETS_ONLINE,MS),
	case EtsOnline of
		[] -> ?null;
		[Player|_] ->Player
	end.

%% uname_to_lv(Name)->
%% 	MS=[{'$1',[{'=:=',{element,6,'$1'},{const,Name}}],['$1']}],
%% 	%% 	MS=ets:fun2ms(fun(R) when R#player.uname =:= Name->R end),
%% 	EtsOnline=ets:select(?ETS_ONLINE,MS),
%% 	case EtsOnline of
%% 		[] -> 1;
%% 		[Online|_] ->Online#player.lv
%% 	end.
%% 
%% uname_to_pro(Name)->
%% 	MS=[{'$1',[{'=:=',{element,6,'$1'},{const,Name}}],['$1']}],
%% 	%% 	MS=ets:fun2ms(fun(R) when R#player.uname =:= Name->R end),
%% 	EtsOnline=ets:select(?ETS_ONLINE,MS),
%% 	case EtsOnline of
%% 		[] -> 1;
%% 		[Online|_] ->Online#player.pro
%% 	end.

%% 取人物颜色
uname_color(Uid)-> ?CONST_COLOR_GREEN .
%% 	case player_data_base(Sid, Uid) of
%% 		{?ok,#player{info=Info}}->
%% 			Info#info.name_color;
%% 		_->
%% 			?CONST_COLOR_GREEN 
%% 	end.


%% 取人物等级
lv(Uid)->1.
%% 	case player_data_base(Sid, Uid) of
%% 		{?ok,#player{info=Info}}->
%% 			Info#info.lv;
%% 		_->0
%% 	end.

%% 取服务器人最少的职业
min_pro()->
	SQL = "SELECT COUNT(  `uid` ) AS cc, `pro` FROM  `user` where `pro` > 0 GROUP BY  `pro` ORDER BY cc asc LIMIT 0 , 1;",
	case mysql_api:select(SQL) of
		{?ok, [[_, MinPro]|_]} ->
			MinPro;
		_ ->
			util:rand_list(?ROLE_PRO)
	end.

%% 取服务器人最少的性别
min_sex() ->
	SQL = "SELECT COUNT(  `uid` ) AS cc, `sex` FROM  `user` where `sex` > 0 GROUP BY  `sex` ORDER BY cc asc LIMIT 0 , 1;",
	case mysql_api:select(SQL) of
		{?ok, [[_, MinSex]|_]} ->
			MinSex;
		_ ->
			util:rand_list([?CONST_SEX_GG,?CONST_SEX_MM])
	end.

min_country() ->
	SQL = "SELECT COUNT(  `uid` ) AS cc, `country` FROM  `user` where `country` > 0 GROUP BY  `country` ORDER BY cc asc LIMIT 0 , 1;",
	case mysql_api:select(SQL) of
		{?ok, [[_, MinCountry]|_]} ->
			MinCountry;
		_ ->
			util:rand_list([?CONST_COUNTRY_ONE,?CONST_COUNTRY_FAIRY,?CONST_COUNTRY_MAGIC])
	end.

online()->
	Online = ets:info(?ETS_ONLINE, size),
	{?ok,Online}.

online_count(Pos, Value) ->
	MatchSpec = ets:fun2ms(fun(EtsOnline) -> element(Pos, EtsOnline) =:= Value end),
	ets:select_count(?ETS_ONLINE, MatchSpec).
 
%% 在线时长 总时长
online_all(Io) ->
	Online = ?IF(is_record(Io,io),Io#io.online,0),
	Online + online_last(Io).

%% 本次在线时长
online_last(Io) ->
	Time   = util:seconds(),
	?IF(is_record(Io,io) andalso Time -Io#io.login_time > 0,Time -Io#io.login_time,0).


%% get_pro_people(Pro)->
%% 	MS=[{'$1',[],[{'==',{element,6,'$1'},{const,Pro}}]}],
%% 	ets:select_count(?ETS_ONLINE,MS).

is_online(Uid)->
	case mpid(Uid) of
		Pid when is_pid(Pid)->
			?true;
		_->
			?false
	end.

is_online2(Uid)->
	case ets:lookup(?ETS_ONLINE,Uid) of
		[Player|_]when is_record(Player,player)->
			is_pid(Player#player.mpid);
		_->
			?false
	end.

%% 角色是否红名
is_red(Player) ->
	if
		(Player#player.info)#info.slaughter < ?CONST_RED_NAME ->
			?CONST_PLAYER_FLAG_NORMAL; 
		?true ->
			?CONST_PLAYER_FLAG_RED
	end.	

%% 保存数据
%% 参数Way: ?CONST_TRUE  :退出时保存
%%         ?CONST_FALSE :中间定时保存
db_save(Player,Way)->
	role_db:role_save(Player, Way).


%% 每周二固定给内部号发放绑定金元
inside_rmb() ->
	case mysql_api:select([uid,sid,bind_rmb], cp_inside_user) of
		{?ok, []} ->
			?skip;
		{?ok, InsideL} ->
			Fun = fun([Uid, Sid, BindRmb]) ->
						  inside_rmb_one(Uid, Sid, BindRmb)  
				  end,
			lists:foreach(Fun, InsideL);
		Err ->
			?MSG_ERROR("Err : ~p~n", [Err])
	end.

inside_rmb_one(Uid, Sid, BindRmb) ->
	case is_online(Uid) of
		?true ->
			util:pid_send(Uid, ?MODULE, inside_rmb_cb, BindRmb);
		_ ->
			case mysql_api:select("select `rmb_bind`,`rmb_total`,`lv` from user where uid=" ++ util:to_list(Uid)) of
				{?ok, [[BindRmb0,RmbTotal,Lv]]} ->
					Value = BindRmb0 + BindRmb,
					stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_RMB_BIND, BindRmb, Value, [inside_rmb_one,[],<<"内部号发放金元">>]),
					mysql_api:update(user, [{rmb_bind,Value},{rmb_total,RmbTotal+BindRmb}], "uid=" ++ util:to_list(Uid));
				Any ->
					?MSG_ERROR("inside role is no exits : ~p~n", [{Uid, Sid, BindRmb, Any}]),
					?skip
			end
	end.

%% 固定给内部号发放绑定金元
inside_rmb_cb(Player, BindRmb) ->
	{Player2, BinMsg} = currency_add([inside_rmb_cb,[],<<"内部号发放金元">>], Player, [{?CONST_CURRENCY_RMB_BIND, BindRmb}]),
	app_msg:send(Player2#player.socket, BinMsg),
	Player2.

%% 是否首充
pay_frist(Player=#player{socket=Socket,uid=Uid},Rmb)->
	case mysql_api:select("SELECT `oid`,`uid`,`pay`,`time` FROM `logs_pay` WHERE `uid` =" ++ util:to_list(Uid)) of
		{?ok,[_R]}->
			{Player2,Bin}=currency_add([pay_frist,[],<<"首充赠送绑定钻石">>],Player,[{?CONST_CURRENCY_RMB_BIND,Rmb*(?CONST_CARD_PAY_MULTIPLE-1)}]),
			app_msg:send(Socket, Bin),
			Player2;
		_R->
			Player
	end.

%%%%%
%% msg_attr_diff(Id,AttrOld,AttrNew)->
%% 	msg_attr_diff(Id, AttrOld, AttrNew, 1, <<>>).
%% msg_attr_diff(_Id,_AttrOld,_AttrNew,N,BinAcc) when N > erlang:size(?ATTR_ARG) -> BinAcc;
%% msg_attr_diff(Id,AttrOld,AttrNew,N,BinAcc)->
%% 	AttrO=erlang:element(N, AttrOld),
%% 	AttrN=erlang:element(N, AttrNew),
%% 	Bin = ?IF(AttrO=/=AttrN, msg_property_update(Id, erlang:element(N, ?ATTR_ARG), AttrN), <<>>),
%% 	msg_attr_diff(Id,AttrOld,AttrNew,N+1,<<BinAcc/binary,Bin/binary>>).


msg_attr_diff(Id,AttrOld,AttrNew)->
	Bin1 = if AttrOld#attr.sp				=/= AttrNew#attr.sp	 		-> 
				  msg_property_update(Id,?CONST_ATTR_SP, AttrNew#attr.sp);
			  ?true 							  					-> <<>> end,
	Bin2 = if AttrOld#attr.sp_up			=/= AttrNew#attr.sp_up		-> 
				  msg_property_update(Id,?CONST_ATTR_SP_UP, AttrNew#attr.sp_up);
			  ?true 							  					-> <<>> end,
	Bin3 = if AttrOld#attr.anima			=/= AttrNew#attr.anima		-> 
				  msg_property_update(Id,?CONST_ATTR_ANIMA, AttrNew#attr.anima);
			  ?true 							  					-> <<>> end,
	Bin4 = if AttrOld#attr.hp				=/= AttrNew#attr.hp			-> 
				  msg_property_update(Id,?CONST_ATTR_HP, AttrNew#attr.hp);
			  ?true 							  					-> <<>> end,
	Bin5 = if AttrOld#attr.hp_gro			=/= AttrNew#attr.hp_gro		-> 
				  msg_property_update(Id,?CONST_ATTR_HP_GRO, AttrNew#attr.hp_gro);
			  ?true 							  					-> <<>> end,
	Bin6 = if AttrOld#attr.strong			=/= AttrNew#attr.strong		-> 
				  msg_property_update(Id,?CONST_ATTR_STRONG, AttrNew#attr.strong);
			  ?true 							  					-> <<>> end,
	Bin7 = if AttrOld#attr.strong_gro		=/= AttrNew#attr.strong_gro	-> 
				  msg_property_update(Id,?CONST_ATTR_STRONG_GRO, AttrNew#attr.strong_gro);
			  ?true 							  					-> <<>> end,
	Bin8 = if AttrOld#attr.magic			=/= AttrNew#attr.magic		-> 
				  msg_property_update(Id,?CONST_ATTR_MAGIC, AttrNew#attr.magic);
			  ?true 							  					-> <<>> end,
	Bin9 = if AttrOld#attr.magic_gro		=/= AttrNew#attr.magic_gro	-> 
				  msg_property_update(Id,?CONST_ATTR_MAGIC_GRO, AttrNew#attr.magic_gro);
			  ?true 							  					-> <<>> end,
	Bin10 = if AttrOld#attr.strong_att		=/= AttrNew#attr.strong_att	-> 
				  msg_property_update(Id,?CONST_ATTR_STRONG_ATT, AttrNew#attr.strong_att);
			  ?true 							  					-> <<>> end,
	Bin11 = if AttrOld#attr.strong_def		=/= AttrNew#attr.strong_def	-> 
				  msg_property_update(Id,?CONST_ATTR_STRONG_DEF, AttrNew#attr.strong_def);
			  ?true 							  					-> <<>> end,
	Bin12 = if AttrOld#attr.skill_att		=/= AttrNew#attr.skill_att	-> 
				  msg_property_update(Id,?CONST_ATTR_SKILL_ATT, AttrNew#attr.skill_att);
			  ?true 							  					-> <<>> end,
	Bin13 = if AttrOld#attr.skill_def		=/= AttrNew#attr.skill_def	-> 
				  msg_property_update(Id,?CONST_ATTR_SKILL_DEF, AttrNew#attr.skill_def);
			  ?true 							  					-> <<>> end,
	Bin14 = if AttrOld#attr.crit				=/= AttrNew#attr.crit		-> 
				  msg_property_update(Id,?CONST_ATTR_CRIT, AttrNew#attr.crit);
			  ?true 							  					-> <<>> end,
	Bin15 = if AttrOld#attr.crit_res			=/= AttrNew#attr.crit_res	-> 
				  msg_property_update(Id,?CONST_ATTR_RES_CRIT, AttrNew#attr.crit_res);
			  ?true 							  					-> <<>> end,
	Bin16 = if AttrOld#attr.crit_harm		=/= AttrNew#attr.crit_harm	-> 
				  msg_property_update(Id,?CONST_ATTR_CRIT_HARM, AttrNew#attr.crit_harm);
			  ?true 							  					-> <<>> end,
	Bin17 = if AttrOld#attr.defend_down		=/= AttrNew#attr.defend_down-> 
				  msg_property_update(Id,?CONST_ATTR_DEFEND_DOWN, AttrNew#attr.defend_down);
			  ?true 							  					-> <<>> end,
	Bin18 = if AttrOld#attr.light			=/= AttrNew#attr.light		-> 
				  msg_property_update(Id,?CONST_ATTR_LIGHT, AttrNew#attr.light);
			  ?true 							  					-> <<>> end,
	Bin19 = if AttrOld#attr.light_def		=/= AttrNew#attr.light_def	-> 
				  msg_property_update(Id,?CONST_ATTR_LIGHT_DEF, AttrNew#attr.light_def);
			  ?true 							  					-> <<>> end,
	Bin20 = if AttrOld#attr.dark				=/= AttrNew#attr.dark		-> 
				  msg_property_update(Id,?CONST_ATTR_DARK, AttrNew#attr.dark);
			  ?true 							  					-> <<>> end,
	Bin21 = if AttrOld#attr.dark_def			=/= AttrNew#attr.dark_def	-> 
				  msg_property_update(Id,?CONST_ATTR_DARK_DEF, AttrNew#attr.dark_def);
			  ?true 							  					-> <<>> end,
	Bin22 = if AttrOld#attr.god				=/= AttrNew#attr.god		-> 
				  msg_property_update(Id,?CONST_ATTR_GOD, AttrNew#attr.god);
			  ?true 							  					-> <<>> end,
	Bin23 = if AttrOld#attr.god_def			=/= AttrNew#attr.god_def	-> 
				  msg_property_update(Id,?CONST_ATTR_GOD_DEF, AttrNew#attr.god_def);
			  ?true 							  					-> <<>> end,
	Bin24 = if AttrOld#attr.bonus 			=/= AttrNew#attr.bonus 		-> 
				  msg_property_update(Id,?CONST_ATTR_BONUS, AttrNew#attr.hp);
			  ?true 							      				-> <<>> end,
	Bin25 = if AttrOld#attr.reduction 		=/= AttrNew#attr.reduction 	-> 
				  msg_property_update(Id,?CONST_ATTR_REDUCTION, AttrNew#attr.reduction);
			  ?true 							        			-> <<>> end,
	Bin26 = if AttrOld#attr.imm_dizz 		=/= AttrNew#attr.imm_dizz 	-> 
				  msg_property_update(Id,?CONST_ATTR_IMM_DIZZ, AttrNew#attr.imm_dizz);
			   ?true 							        			-> <<>> end,
	<<Bin1/binary, Bin2/binary, Bin3/binary, Bin4/binary, Bin5/binary,Bin6/binary, Bin7/binary, Bin8/binary, Bin9/binary, Bin10/binary,Bin11/binary,
	  Bin12/binary,Bin13/binary,Bin14/binary,Bin15/binary,Bin16/binary,Bin17/binary,Bin18/binary,Bin19/binary,Bin20/binary,Bin21/binary,Bin22/binary,
	  Bin23/binary,Bin24/binary,Bin25/binary,Bin26/binary>>.

%% 装备评分
msg_score(ID, Equip) ->
	{ScEquip,ScPearl,ScJewe,ScMagic} = goods_api:score_attr(Equip),
	Bin1 = msg_property_update(ID,?CONST_ATTR_SCORE_EQ, ScEquip),
	Bin2 = msg_property_update(ID,?CONST_ATTR_SCORE_JEW, ScJewe),
	Bin3 = msg_property_update(ID,?CONST_ATTR_SCORE_MAG, ScMagic),
	Bin4 = msg_property_update(ID,?CONST_ATTR_SCORE_PEA, ScPearl),
%% 	Key = case ID of
%% 			  0 ->
%% 				  score_role;
%% 			  _ ->
%% 				  {score_partner, ID}
%% 		  end,
%% 	erlang:put(Key, {ScEquip,ScPearl,ScJewe,ScMagic}),
	<<Bin1/binary, Bin2/binary, Bin3/binary, Bin4/binary>>.


%% online_count(Pos, Value)->
%% 	%% Online = ets:info(?ETS_ONLINE, size),
%% 	MatchSpec = ets:fun2ms(fun(EtsOnline) -> element(Pos, EtsOnline) =:= Value end),
%% 	ets:select_count(?ETS_ONLINE, MatchSpec).

	
% 断线重连失败 [1012]
msg_login_ag_err(Result)->
	BinData = app_msg:encode([{?int8u, Result}]),
    app_msg:msg(?P_ROLE_LOGIN_AG_ERR,BinData).

% 登录成功(没有角色) [1023]
msg_login_ok_no_role(Pro)->
    RsList = app_msg:encode([{?int8u,Pro}]),
    app_msg:msg(?P_ROLE_LOGIN_OK_NO_ROLE, RsList).

% 创建/登录(有角色)成功 [1021]
msg_login_ok_have(#player{uid=Uid,uname=Name,sex=Sex,pro=Pro,lv=Lv,country=Country,info=Info}) ->
	?MSG_ECHO("Sex _ Pro ~w __ ~w  _~w ~n",[Sex,Pro,Info#info.skin_armor]),
%% 	RedName = is_red(Player),
	BinMsg  = app_msg:encode([{?int32u,Uid},{?string,Name},
							  {?int8u,Sex},{?int8u,Pro},
							  {?int16u,Lv},{?int8u,Country},
							  {?int8u,0},{?int16u,Info#info.skin_armor}]),
	app_msg:msg(?P_ROLE_LOGIN_OK_HAVE, BinMsg).


% 销毁角色(成功) [1061]
msg_del_ok(Uid)-> 
    RsList = app_msg:encode([{?int32u,Uid}]),
    app_msg:msg(?P_ROLE_DEL_OK, RsList).

% 销毁角色(失败) [1063]
msg_del_fail(ErrorCode)->
    RsList = app_msg:encode([{?int16u,ErrorCode}]),
    app_msg:msg(?P_ROLE_DEL_FAIL, RsList).

% 返回名字 [1025]
msg_name(Name)->
    RsList = app_msg:encode([{?stringl,Name}]),
    app_msg:msg(?P_ROLE_NAME, RsList).

% 玩家属性 [1108]
msg_property_reve(#player{uid=Uid,uname=Name,uname_color=NameColor,sex=Sex,pro=Pro,country=Country,lv=Lv,attr=Attr,info=Info},Falg,CopyAttr)->
	#info{exp=Exp,powerful=Powerful,skin_weapon=SkinWeapon,skin_armor=SkinArmor,renown=Renown}=Info,
	{_,Inn}=?IF(Falg==?true,{?ok,role_api_dict:inn_get()},role_api_dict:inn_get(Uid)),
	ClanId=clan_api:clan_id_get(Uid),
	ClanName=clan_api:clan_name_get(Uid),?MSG_ECHO("clan_name_getclan_name_getclan_name_getclan_name_get:~w~n",[{ClanName,ClanId}]),
	Rank=arena_api:arena_get_rank(Uid),
	RsList=app_msg:encode([{?int32u,Uid},{?string,Name},{?int8u,NameColor},
						   {?int8u,Pro},{?int8u,Sex},{?int16u,Lv},{?int32u,Renown},{?int16u,Rank},{?int8u,Country},
						   {?int16u,ClanId},{?string,ClanName}]),
	RsList2=?IF(CopyAttr==?null,msg_xxx2(Attr),msg_xxx2(CopyAttr)),
	Expn=?DATA_PLAYER_UP_EXP:get(?CONST_PLAYER,Lv), 
	RsList3=app_msg:encode([{?int32u,Powerful},{?int32u,Exp},
							{?int32u,Expn},{?int16u,SkinWeapon},
							{?int16u,SkinArmor}]), 
	Fun=fun(Partner,List) when is_record(Partner,partner) -> 
				case Partner#partner.state=/=?CONST_INN_STATA2 of
					?true->
						[{?int16u,Partner#partner.partner_id}|List];
					_->
						List
				end
		end,
	PartnerList=lists:foldl(Fun,[],Inn#inn.partners), 
	PartnerCount=[{?int16u,length(PartnerList)}]++PartnerList,
	RsList4=app_msg:encode(PartnerCount),
    app_msg:msg(?P_ROLE_PROPERTY_REVE,<<RsList/binary,RsList2/binary,RsList3/binary,RsList4/binary>>).
 
% 伙伴属性 [1109] 
msg_partner_data(Uid,Partner)->
	#partner{partner_id=PartnerId,lv=Lv,exp=Exp0,state=State,pro=Pro,attr=Attr,powerful=Powerful}=Partner,
	RsList0= msg_xxx2(Attr),
%% 	DPartner = ?DATA_PARTNER_INIT:get(PartnerId),
	Exp=Exp0,
	Expn=?DATA_PLAYER_UP_EXP:get(?CONST_PARTNER,Lv),
	RsList = app_msg:encode([{?int32u,Uid},{?int16u,PartnerId},
							 {?int8u,Pro},{?int8u,Lv},
							 {?int32u,Exp},{?int32u,Expn},
							 {?int32u,Powerful},{?int8u,State}]),
    app_msg:msg(?P_ROLE_PARTNER_DATA, <<RsList/binary,RsList0/binary>>).

%% lists:foldl(Fun, Acc0, List)
% 玩家单个属性更新 [1130]
msg_property_update(Id,Type,Value)->
    RsList = app_msg:encode([{?int32u,Id},{?int8u,Type},{?int32u,Value}]),
    app_msg:msg(?P_ROLE_PROPERTY_UPDATE, RsList).
% 玩家单个属性更新[字符串] [1131]
msg_property_update2(Id,Type,Value)->
    RsList = app_msg:encode([{?int32u,Id},{?int8u,Type},{?string,Value}]),
    app_msg:msg(?P_ROLE_PROPERTY_UPDATE2, RsList).

% 属性信息块 [2002]
msg_xxx2(Attr) when is_record(Attr,attr)->
	#attr{sp =Sp, sp_up =SpSpeed, anima =Anima, hp =Hp, hp_gro =HpGro, strong =Strong,strong_att=StrongAtt,
		  strong_def=StrongDef,strong_gro =StrongGro, magic =Magic, magic_gro =MagicGro,skill_att=SkillAtt,
		  skill_def=SkillDef,crit =Crit, 
		  crit_res =CritRes, crit_harm =CritHarm, defend_down =Defend_down, light =Light, light_def =LightDef, 
		  dark =Dark, dark_def =DarkDef, god =God, god_def =GodDef, bonus =Bonus, reduction =Reduction, 
		  imm_dizz =ImmDizz}=Attr,
	app_msg:encode([{?bool,?true},
					{?int16u,Sp},{?int32u,SpSpeed},
					{?int32u,Anima},{?int32u,Hp},
					{?int16u,HpGro},{?int32u,Strong},
					{?int16u,StrongGro},{?int32u,Magic},
					{?int16u,MagicGro},{?int32u,StrongAtt},
					{?int16u,StrongDef},{?int32u,SkillAtt},
					{?int16u,SkillDef},{?int16u,Crit},
					{?int16u,CritRes},{?int16u,CritHarm},
					{?int16u,Defend_down},{?int16u,Light},
					{?int16u,LightDef},{?int16u,Dark},
					{?int16u,DarkDef},{?int16u,God},
					{?int16u,GodDef},{?int16u,Bonus},
					{?int16u,Reduction},{?int16u,ImmDizz}]);
msg_xxx2(_)-> 
	app_msg:encode([{?bool,?false}]).

% 货币 [1022]
msg_currency(#money{gold = Gold, rmb = Rmb, rmb_bind = BindRmb})->
	msg_currency(Gold,Rmb,BindRmb).

% 货币 [1022]
msg_currency(Gold,Rmb,BindRmb)->
	?IF(Gold < 0 orelse Rmb < 0 orelse BindRmb < 0, ?MSG_ERROR("{Gold,Rmb,BindRmb} ~p~n", [{Gold,Rmb,BindRmb}]), ?skip),
    RsList = app_msg:encode([{?int32u,Gold},{?int32u,Rmb},{?int32u,BindRmb}]),
    app_msg:msg(?P_ROLE_CURRENCY, RsList).

% 防沉迷
	% 防沉迷提示 [9020]
msg_fcm_prompt(Show,State,Time)->
    RsList = app_msg:encode([{?bool,Show},{?int8u,State},{?int32u,Time}]),
    app_msg:msg(?P_FCM_PROMPT, RsList).


% 开启的系统ID [1270]
msg_sys_id(SysList)->
	Fun=fun(SysId,Acc)->
				Rs=app_msg:encode([{?int16u,SysId}]),
				<<Acc/binary,Rs/binary>>
		end,
	RsList=lists:foldl(Fun,app_msg:encode([{?int16u,length(SysList)}]),SysList),
    app_msg:msg(?P_ROLE_SYS_ID, RsList).

% 开启的系统ID [1271]
msg_sys_id_2(SysList)->
	Count=app_msg:encode([{?int16u,length(SysList)}]),
	Fun=fun({SysId,State},{Acc,Acc2})->
				Rs=app_msg:encode([{?int16u,SysId},{?int8u,State}]),
				Rs2=app_msg:encode([{?int16u,SysId}]),
				{<<Acc/binary,Rs/binary>>,<<Acc2/binary,Rs2/binary>>};
		   (SysId,{Acc,Acc2})->
				Rs=app_msg:encode([{?int16u,SysId},{?int8u,?CONST_TRUE}]),
				Rs2=app_msg:encode([{?int16u,SysId}]),
				{<<Acc/binary,Rs/binary>>,<<Acc2/binary,Rs2/binary>>}
		end,
	{RsList1,RsList2}=lists:foldl(Fun,{Count,Count},SysList),
    B1=app_msg:msg(?P_ROLE_SYS_ID_2, RsList1),
	B2=app_msg:msg(?P_ROLE_SYS_ID, RsList2),
	<<B1/binary,B2/binary>>.

% 在线奖励 [1340]
msg_online_reward(NextTime,Time)->
    RsList = app_msg:encode([{?int8u,NextTime},{?int32u,Time}]),
    app_msg:msg(?P_ROLE_ONLINE_REWARD, RsList).

% 等级礼包 [1341]
msg_level_gift(Leveled)->
    RsList = app_msg:encode([{?int8u,Leveled}]),
    app_msg:msg(?P_ROLE_LEVEL_GIFT, RsList).

% 服务器将断开连接 [502]
msg_disconnect(ErrorCode,Msg)->
    RsList = app_msg:encode([{?int16u,ErrorCode},
        {?stringl,Msg}]),
    app_msg:msg(?P_SYSTEM_DISCONNECT, RsList).
