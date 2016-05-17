%% Author  : mirahs
%% Created: 2012-6-20
%% Description: TODO: Add description to team_api
-module(weagod_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 encode_weagod/1,
		 decode_weagod/1,
		 
		 init/1,
		 refresh/0,
		 login/0,
		 level_up/1,
		 vip_up/2,
		 request_weagod/2,
		 money_get/1,
		 pl_money_get/1,
		 money_auto_get/1,
		 check_gold_cb/2,
		 gold_get/1,
		 money_auto_get_open_close/1,
		 
		 msg_weagod_reply/1,
		 msg_weagod_reply/0,
		 msg_success/1
		]).

encode_weagod(Weagod) ->
	Weagod.

decode_weagod(Weagod) when is_record(Weagod,weagod) -> 
	Weagod;
decode_weagod(_Weagod) ->
	init_weagod(1).

init_weagod(Lv) ->
	Date = util:date(),
	case data_weagod:get(Lv) of
		#d_weagod{auto_money=AutoMoney} ->
			#weagod{date=Date,auto=?CONST_FALSE,automoney=AutoMoney,times=0};
		_ ->
			#weagod{date=Date,auto=?CONST_FALSE,times=0}
	end.

%% 初始化招财
init(#player{lv=Lv}=Player) ->
	Weagod = init_weagod(Lv),
	role_api_dict:weagod_set(Weagod),
	{Player,Weagod}.

refresh() ->
	login().

login() ->
	Date = util:date(),
	Weagod = role_api_dict:weagod_get(),
	NewWeagod =
		case Weagod#weagod.date =:= Date of
			?true ->
				Weagod;
			_ ->
				Weagod#weagod{date=Date,times=0}
		end,
	role_api_dict:weagod_set(NewWeagod).

level_up(NewLv) ->
	Weagod = role_api_dict:weagod_get(),
	NewWeagod =
		case data_weagod:get(NewLv) of
			#d_weagod{auto_money=AutoMoney} ->
				Weagod#weagod{automoney=AutoMoney};
			_ ->
				Weagod
		end,
	role_api_dict:weagod_set(NewWeagod).

vip_up(Lv,Vip) ->
	request_weagod(Lv,Vip).

request_weagod(Lv,Vip) ->
	refresh(),
	#weagod{times=UsedTimes,auto= Auto, automoney= AutoMoney} = role_api_dict:weagod_get(),
	VipTimes= vip_api:check_fun(Vip#vip.lv, #d_vip.bowl_max),
	%% ?MSG_ECHO("-------------------~w~n",[VipTimes]),
	Vip0Times = ?CONST_WEAGOD_VIP0,
	Times = ?CONST_WEAGOD_FREE_TIMES + Vip0Times+ VipTimes - UsedTimes,
	if UsedTimes <?CONST_WEAGOD_FREE_TIMES ->
		   NeedRmb= 0;
	   ?true ->
		   NeedRmb= (UsedTimes- ?CONST_WEAGOD_FREE_TIMES+ 1)* 2
	end,
	GetGold = gold_get(Lv),
	msg_weagod_reply({Times, Auto, AutoMoney, NeedRmb, GetGold}).

%%%%%%%%%====================     招财          ==========================
money_get(#player{socket=Socket,lv=Lv,vip = Vip, uid = Uid}=Player) ->
	Weagod= role_api_dict:weagod_get(),
	#weagod{times=UsedTimes,auto=Auto,automoney=AutoMoney} = Weagod,
	Vip0Times = ?CONST_WEAGOD_VIP0,
	VipTimes= vip_api:check_fun(Vip#vip.lv, #d_vip.bowl_max),
	AllTimes = VipTimes+ Vip0Times+ ?CONST_WEAGOD_FREE_TIMES,
	Type = ?CONST_WEAGOD_SINGLE_TYPE,
	case Lv >= ?CONST_WEAGOD_OPEN_LV of
		?true ->
			if
				%% 还有剩余免费次数
				UsedTimes < ?CONST_WEAGOD_FREE_TIMES ->
					Rmb = 0,
					NewUsedTimes = UsedTimes +1,
					GetGold = gold_get(Lv),
					role_api_dict:weagod_set(Weagod#weagod{times=NewUsedTimes}),
					{Player2,Bin1} = role_api:currency_add([get_money,[],<<"招财奖励">>], Player, [{?CONST_CURRENCY_GOLD,GetGold}]),
					NextRmb =
						case NewUsedTimes >= ?CONST_WEAGOD_FREE_TIMES of
							?true ->
								(NewUsedTimes - ?CONST_WEAGOD_FREE_TIMES + 1) * 2;
							_ ->
								0
						end,
					active_api:check_link(Uid, ?CONST_ACTIVITY_LINK_106),
					stat_api:logs_weagod(Uid, Type, GetGold, Rmb, AllTimes- NewUsedTimes),
					Bin2 = msg_weagod_reply({AllTimes - NewUsedTimes, Auto, AutoMoney, NextRmb,GetGold}),
					Bin3= msg_success(Type),
					app_msg:send(Socket, <<Bin1/binary,Bin2/binary,Bin3/binary>>),
					{?ok,Player2};
				%% 没有剩余免费次数，但还有剩余招财次数
				UsedTimes < AllTimes ->
					NeedRmb = (UsedTimes- ?CONST_WEAGOD_FREE_TIMES+ 1) * 2,
					case role_api:currency_cut([ money_get, [], <<"单次招财">>], Player, [{?CONST_CURRENCY_RMB, NeedRmb}]) of
						{?ok,Player2,Bin1} ->
							NewUsedTimes = UsedTimes +1,
							GetGold = gold_get(Lv),
							role_api_dict:weagod_set(Weagod#weagod{times=NewUsedTimes}),
							NextRmb = (NewUsedTimes - ?CONST_WEAGOD_FREE_TIMES + 1) * 2,
							{Player3,Bin2} = role_api:currency_add([get_money,[],<<"单次招财奖励">>], Player2, [{?CONST_CURRENCY_GOLD,GetGold}]),
							active_api:check_link(Uid, 106),
							stat_api:logs_weagod(Uid, Type, GetGold, NeedRmb, AllTimes- NewUsedTimes),
							Bin3 = msg_weagod_reply({AllTimes - NewUsedTimes, Auto, AutoMoney, NextRmb,GetGold}),
							Bin4= msg_success(Type),
							app_msg:send(Socket, <<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary>>),
							{?ok,Player3};
						_ ->
							{?error,?ERROR_RMB_LACK}
					end;
				?true ->
					{?error,?ERROR_WEAGOD_NO_TIMES}
			end;
		_ ->
			{?error,?ERROR_WEAGOD_LV_LACK}
	end.




pl_money_get(#player{socket=Socket,uid = Uid, vip= Vip,lv= Lv}=Player) ->
	Weagod =role_api_dict:weagod_get(),
	#weagod{times=UsedTimes,auto=Auto,automoney=AutoMoney} = Weagod,
	Vip0Times = ?CONST_WEAGOD_VIP0,
	VipTimes= vip_api:check_fun(Vip#vip.lv, #d_vip.bowl_max),
	AllTimes = ?CONST_WEAGOD_FREE_TIMES + Vip0Times+ VipTimes,
	Type= ?CONST_WEAGOD_PL_TYPE,
	case Lv >= ?CONST_WEAGOD_OPEN_LV of
		?true ->
			if UsedTimes < AllTimes ->
				   %% 已经没有剩余免费次数
				   %%  取剩余招财次数如果小于20次，取最大次数招，如果大于等于20次 则取20次
				   case UsedTimes >= ?CONST_WEAGOD_FREE_TIMES of 
					   ?true ->
						   LeaveTimes = AllTimes - UsedTimes,
						   case LeaveTimes >= ?CONST_WEAGOD_PL_TIMES of
							   ?true ->
								   GetTimes = ?CONST_WEAGOD_PL_TIMES;
							   _ ->
								   GetTimes = LeaveTimes
						   end,
						   NeedRmb= pl_rmb_need(UsedTimes, GetTimes),
						   case role_api:currency_cut([pl_money_get, [], <<"批量招财">>], Player, [{?CONST_CURRENCY_RMB, NeedRmb}]) of
							   {?ok,Player2,Bin1} ->
								   NewUsedTimes = UsedTimes +GetTimes,
								   GetGold = gold_get(Lv) *GetTimes,
								   role_api_dict:weagod_set(Weagod#weagod{times=NewUsedTimes}),
								   NextRmb = (NewUsedTimes - ?CONST_WEAGOD_FREE_TIMES + 1) * 2,
								   {Player3,Bin2} = role_api:currency_add([pl_money_get,[],<<"批量招财奖励">>], Player2, [{?CONST_CURRENCY_GOLD,GetGold}]),
								   pl_active(Uid, GetTimes),
								   stat_api:logs_weagod(Uid, Type, GetGold, NeedRmb, AllTimes- NewUsedTimes),
								   Bin3 = msg_weagod_reply({AllTimes - NewUsedTimes, Auto, AutoMoney, NextRmb,gold_get(Lv)}),
								   Bin4= msg_success(Type),
								   app_msg:send(Socket, <<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary>>),
								   {?ok,Player3};
							   _ ->
								   {?error,?ERROR_RMB_LACK}
						   end;
					   
					   %%还有剩余免费次数
					   _ ->
						   LeaveTimes = AllTimes - UsedTimes,
						   case LeaveTimes >= ?CONST_WEAGOD_PL_TIMES of
							   ?true ->
								   GetTimes = ?CONST_WEAGOD_PL_TIMES;
							   _ ->
								   GetTimes = LeaveTimes
						   end,
						   FreeTimes= ?CONST_WEAGOD_FREE_TIMES- UsedTimes,
						   MoneyTimes= GetTimes- FreeTimes,
						   %%  未用完剩余次数，全部免费招财
						   if 
							   MoneyTimes =< 0 ->
								   NewUsedTimes= UsedTimes+ GetTimes,
								   GetGold= gold_get(Lv)* GetTimes,
								   role_api_dict:weagod_set(Weagod#weagod{times=NewUsedTimes}),
								   {Player2,Bin1} = role_api:currency_add([pl_money_get,[],<<"招财奖励">>], Player, [{?CONST_CURRENCY_GOLD,GetGold}]),
								   NextRmb= (NewUsedTimes- ?CONST_WEAGOD_FREE_TIMES+ 1)* 2,
								   pl_active(Uid, GetTimes),
								   stat_api:logs_weagod(Uid, Type, GetGold, 0, AllTimes- NewUsedTimes),
								   Bin2 = msg_weagod_reply({AllTimes - NewUsedTimes, Auto, AutoMoney, NextRmb,gold_get(Lv)}),
								   Bin3= msg_success(Type),
								   app_msg:send(Socket, <<Bin1/binary,Bin2/binary,Bin3/binary>>),
								   {?ok,Player2};
							   %% 剩余免费次数不足一次批量招财，已用完剩余的免费次数
							   ?true ->
								   NeedRmb= pl_rmb_need(UsedTimes, MoneyTimes),
								   case role_api:currency_cut([pl_money_get, [], <<"批量招财">>], Player, [{?CONST_CURRENCY_RMB, NeedRmb}]) of
									   {?ok,Player2,Bin1} ->
										   NewUsedTimes = UsedTimes +GetTimes,
										   GetGold = gold_get(Lv)*GetTimes,
										   role_api_dict:weagod_set(Weagod#weagod{times=NewUsedTimes}),
										   NextRmb = (NewUsedTimes - ?CONST_WEAGOD_FREE_TIMES + 1) * 2,
										   {Player3,Bin2} = role_api:currency_add([pl_money_get,[],<<"批量招财奖励">>], Player2, [{?CONST_CURRENCY_GOLD,GetGold}]),
										   pl_active(Uid, GetTimes),
										   stat_api:logs_weagod(Uid, Type, GetGold, NeedRmb, AllTimes- NewUsedTimes),
										   Bin3 = msg_weagod_reply({AllTimes - NewUsedTimes, Auto, AutoMoney, NextRmb,gold_get(Lv)}),
										   Bin4= msg_success(Type),
										   app_msg:send(Socket, <<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary>>),
										   {?ok,Player3};
									   _ ->
										   {?error,?ERROR_RMB_LACK}
								   end
						   end
				   end;
			   ?true ->
				   {?error,?ERROR_WEAGOD_NO_TIMES}
			end;
		_ ->
			{?error,?ERROR_WEAGOD_LV_LACK}
	end.


%%%%%%%%%%%%%%%%%%%%%%%%% 开启或者关闭自动招财功能

money_auto_get_open_close(Player= #player{lv= Lv,vip=Vip}) ->
	Weagod =role_api_dict:weagod_get(),
	#weagod{auto=Auto} = Weagod,
%% 	?MSG_ECHO("--------------~w~n",[Vip#vip.lv]),
	case Vip#vip.lv >= ?CONST_WEAGOD_AUTO_VIP of
		?true ->
			if
				Auto == 1 ->
					NewAuto = 0,
					role_api_dict:weagod_set(Weagod#weagod{auto=NewAuto}),
					{?ok,Player};
				?true ->
					NewAuto = 1,
					role_api_dict:weagod_set(Weagod#weagod{auto=NewAuto}),
					Player2= case Lv >=?CONST_WEAGOD_OPEN_LV of
								 ?true ->
									 money_auto_get(Player);
								 _ ->
									 Player
							 end,
					{?ok,Player2}
			end;
		_ ->
			{?error,?ERROR_WEAGOD_NO_ENOUGH_VIP6}
	end.

check_gold_cb(Player,_) ->
	#weagod{auto=Auto} =role_api_dict:weagod_get(),
	case Auto == 1 of
		?true ->
			money_auto_get(Player);
		_ ->
			Player
	end.

%%%%%%%%%%%%%%%%%%%%%  已经启动自动招财，判断是否需要招财
money_auto_get(#player{socket=Socket,uid=Uid,lv=Lv,money=Money,vip= Vip}=Player) ->
	Weagod =role_api_dict:weagod_get(),
	#weagod{times=UsedTimes,auto=Auto,automoney=AutoMoney} = Weagod,
	VipTimes= vip_api:check_fun(Vip#vip.lv, #d_vip.bowl_max),
	#money{gold=Gold} = Money,
	Vip0Times = ?CONST_WEAGOD_VIP0,
	AllTimes =  VipTimes+ Vip0Times+ ?CONST_WEAGOD_FREE_TIMES,
	Type = ?CONST_WEAGOD_AUTO_TYPE,
	%% ?MSG_ECHO("-----------------~w~n",[Auto]),
	case Auto =:= 1 of
		?true ->
			if
				Gold< AutoMoney ->
					if
						UsedTimes < ?CONST_WEAGOD_FREE_TIMES ->
							NewUsedTimes = UsedTimes +1,
							GetGold = gold_get(Lv),
							NextRmb = (NewUsedTimes - ?CONST_WEAGOD_FREE_TIMES + 1) * 2,
							role_api_dict:weagod_set(Weagod#weagod{times=NewUsedTimes}),
							active_api:check_link(Uid, ?CONST_ACTIVITY_LINK_106),
							stat_api:logs_weagod(Uid, Type, GetGold, 0, AllTimes- NewUsedTimes),
							{Player2,Bin1} = role_api:currency_add([money_auto_get,[],<<"自动招财奖励">>], Player, [{?CONST_CURRENCY_GOLD,GetGold}]),
							Bin2 = msg_weagod_reply({AllTimes - NewUsedTimes, Auto, AutoMoney, NextRmb,GetGold}),
							app_msg:send(Socket, <<Bin1/binary,Bin2/binary>>),
							money_auto_get(Player2);
						UsedTimes < AllTimes ->
							NeedRmb = (UsedTimes -?CONST_WEAGOD_FREE_TIMES+1)* 2,
							case role_api:currency_cut([money_auto_get, [], <<"自动招财">>], Player, [{?CONST_CURRENCY_RMB, NeedRmb}]) of
								{?ok,Player2,Bin1} ->
									NewUsedTimes = UsedTimes +1,
									GetGold = gold_get(Lv),
									role_api_dict:weagod_set(Weagod#weagod{times=NewUsedTimes}),
									NextRmb = (NewUsedTimes - ?CONST_WEAGOD_FREE_TIMES + 1) * 2,
									active_api:check_link(Uid, ?CONST_ACTIVITY_LINK_106),
									stat_api:logs_weagod(Uid, Type, GetGold, NeedRmb, AllTimes- NewUsedTimes),
									{Player3,Bin2} = role_api:currency_add([money_auto_get,[],<<"自动招财奖励">>], Player2, [{?CONST_CURRENCY_GOLD,GetGold}]),
									Bin3 = msg_weagod_reply({AllTimes - NewUsedTimes, Auto, AutoMoney, NextRmb,GetGold}),
									app_msg:send(Socket, <<Bin1/binary,Bin2/binary,Bin3/binary>>),
									money_auto_get(Player3);
								_ ->
									Player
							end;
						?true ->
							Player
					end;
				?true ->
					Player
			end;
		_ ->
			Player
	end.


%%计算批量招财所需人民币
pl_rmb_need(UsedTimes, Times) ->
	if UsedTimes <?CONST_WEAGOD_FREE_TIMES ->
		   UsedTimes2 = ?CONST_WEAGOD_FREE_TIMES;
	   ?true ->
		   UsedTimes2 = UsedTimes
	end,
	NeedRmb = ((UsedTimes2- ?CONST_WEAGOD_FREE_TIMES +1)+ (UsedTimes2+ Times- ?CONST_WEAGOD_FREE_TIMES))* Times,
	if NeedRmb >= 0 ->
		   NeedRmb;
	   ?true ->
		   0
	end.

gold_get(Lv) ->
	case data_weagod:get(Lv) of
		#d_weagod{money=Dgold} ->
			Dgold;
		_ ->
			0
	end.

pl_active(Uid, 0) ->
	?skip;

pl_active(Uid,Time) ->
	active_api:check_link(Uid, ?CONST_ACTIVITY_LINK_106),
	pl_active(Uid,Time-1).



%%%%%%%%%%%%%%%%%%%%%%%%%%  msg xxxxxxxxxxx  %%%%%%%%%%%%%%%%%%%%%%%%%%%

% 招财面板返回 [32020
msg_weagod_reply({Times, IsAuto, AutoGold, NextRmb, NextGold}) ->
	BinData = app_msg:encode([{?int16u,Times},{?int8u,IsAuto},{?int32u,AutoGold},{?int32u,NextRmb},{?int32u,NextGold}]),
	app_msg:msg(?P_WEAGOD_REPLY, BinData).
% 金元不足，返回错误
msg_weagod_reply() ->
	app_msg:msg(?ERROR_RMB_LACK, <<>>).

% 招财成功返回 [32060]
msg_success(Type)->
    RsList = app_msg:encode([{?int8u,Type}]),
    app_msg:msg(?P_WEAGOD_SUCCESS, RsList).




