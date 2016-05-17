%% Author  : mirahs
%% Created: 2012-6-20
%% Description: TODO: Add description to team_api
-module(shoot_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 init/0,
		 init/1,
		 decode_shoot/1,
		 encode_shoot/1,
		 login/0,
		 refresh/0,
		 
		 request_shoot/0,
		 reward_history/2,
		 get_uid_to_name/1,
		 shooted/2,
		 reward_award/3,
		 reward_money/1,
		
		 gives2goods/1,
		 		 
		 msg_award_info/3,
		 msg_head_info/3,
		 msg_reply/9
		]).

encode_shoot(ShootDate) ->
	ShootDate.

decode_shoot(ShootDate) ->
	case is_record(ShootDate,shoot) of
		?true ->
			ShootDate;
		_ ->
			init()
	end.

%% 初始化签到信息
init(Player) -> 
	Shoot= init(),
	{Player,Shoot}.

init() ->
	Date = util:date(),
	Shoot= #shoot{free_time =?CONST_ARROW_DAILY_FREE_TIMES, purchase_time= ?CONST_ARROW_DAILY_BUY_LIMIT_TIMES, head=[],date= Date},
	role_api_dict:shoot_set(Shoot),
	Shoot.

refresh() ->
	login().

login() ->
	Date = util:date(),
	Shoot = role_api_dict:shoot_get(),
	case Shoot#shoot.date of
		Date ->
			?skip;
		_ ->
			NewShoot = #shoot{free_time =?CONST_ARROW_DAILY_FREE_TIMES, purchase_time = ?CONST_ARROW_DAILY_BUY_LIMIT_TIMES, head=[], date=Date},
			role_api_dict:shoot_set(NewShoot)
	end.



request_shoot() ->
	refresh(),
	#shoot{free_time= FreeTime, purchase_time= PurchaseTime, head = Head} = role_api_dict:shoot_get(),
	#shoot_data{money= Money, last_award= LastAward, history= History}= shoot_mod:shoot_data_get(),
	History2= lists:reverse(History),
	case LastAward =/= ?null of
		?true ->
			{_,Uname,LastMoney} = LastAward;
		_ -> 
			Uname= <<>>,
			LastMoney = 0
	end,

	Fun1 = fun({head, PositionAcc, _IsShooted, TypeAcc, AwardAcc},{Count1, Bin1}) ->
				  BinAcc1 = msg_head_info(PositionAcc, TypeAcc, AwardAcc),
				  {Count1+1,<<BinAcc1/binary,Bin1/binary>>}
		  end,
	{Count,HeadInfoBin} = lists:foldl(Fun1,{0,<<>>}, Head),
	HeadCountBin = app_msg:encode([{?int16u,Count}]),
	
	
	Fun2 = fun({s_history,UidAcc,GoodsIdAcc,NumAcc,_S},{Count2,Bin2}) ->
				  NameAcc = get_uid_to_name(UidAcc),
				  BinAcc2 = msg_award_info(NameAcc, GoodsIdAcc,NumAcc),
				  {Count2+1,<<BinAcc2/binary,Bin2/binary>>}
		  end,
	{Count3,AwardInfoBin} = lists:foldl(Fun2,{0,<<>>}, History2),
	
	%% ?MSG_ECHO("-----------------~w~n",[{Count3,AwardInfoBin}]),
	AwardCountBin = app_msg:encode([{?int16u,Count3}]),
	msg_reply(FreeTime,PurchaseTime,Money,Uname,LastMoney,HeadCountBin,HeadInfoBin,AwardCountBin,AwardInfoBin).

shooted(#player{socket = Socket, uid=Uid,uname=Uname,uname_color=NameColor,lv=Lv,pro= Pro}=Player, Position ) ->
	Shoot= role_api_dict:shoot_get(),
	#shoot{head=Heads,free_time=FreeTime,purchase_time=PurchaseTime,date= Date}= Shoot,
	#shoot_data{money= Money}= shoot_mod:shoot_data_get(),
	Typec = typec_get(FreeTime),
	{d_arrow_daily_odds,_,List} = data_arrow_daily_odds:get(Typec),
	[Type] = util:odds_list_count(List, 1),
	%%?MSG_ECHO("--------------~w~n",[{Typec,Type,FreeTime,PurchaseTime}]),
	{d_arrow_daily_odds,_,List1}= data_arrow_daily_odds:get(Type),
	[Gives] = util:odds_list_count(List1, 1),
	Bag = role_api_dict:bag_get(),
	AccMoney = Money + ?CONST_ARROW_DAILY_MONEY_UES,
	case FreeTime > 0 of
		?true ->
			case role_api:currency_cut([shooted,[],<<"射箭花费美刀">>], Player, [{?CONST_CURRENCY_GOLD,?CONST_ARROW_DAILY_MONEY_UES}]) of 
				{?ok,NewPlayer,BinCut} ->
					case Type =:= 1 of 
						?true ->
							shoot_reward1(NewPlayer, Gives, Bag, AccMoney, FreeTime, Type, Position, Heads, PurchaseTime, Date , BinCut);
						?false ->
							shoot_reward2(NewPlayer, Gives, AccMoney, Money, FreeTime, Type, Position, Heads, PurchaseTime, Date , BinCut)
					end;
				{?error,ErrorCode}-> 
					BinMsg=system_api:msg_error(ErrorCode),
					app_msg:send(Socket,BinMsg),
					{?ok,Player}
			end;
		_ ->
			case PurchaseTime > 0 of
				?true ->
					Rmb= ?CONST_ARROW_DAILY_ADD_RMB_USE,
					?MSG_ECHO("--------------~w~n",[AccMoney]),
					case role_api:currency_cut([ shooted, [], <<"每日一箭">>], Player, [{?CONST_CURRENCY_RMB, Rmb}]) of
						{?ok,Player2,Bin1} ->
							case Type =:= 3 of 
								?true ->
									Goods = gives2goods([Gives]),
									case bag_api:goods_set([shooted,[],<<"射箭奖励">>], Player2, Bag, Goods) of
										{?ok,Player3,NewBag,Bin2,Bin3} ->
											reward_money(round(AccMoney)),
											role_api_dict:bag_set(NewBag),
%% 											reward_money(round(Money)),
											NewPurchaseTime = PurchaseTime -1,
											NewHead= #head{position=Position, type=Type, award=Gives#give.goods_id, is_shoot= ?CONST_TRUE},
											NewHeads = [NewHead|Heads],
											NewShoot= #shoot{ free_time= FreeTime, purchase_time= NewPurchaseTime, head=NewHeads,date= Date},
											role_api_dict:shoot_set(NewShoot),
											active_api:check_link(Uid, ?CONST_ACTIVITY_LINK_111),
											stat_api:logs_shoot(Uid, FreeTime, FreeTime, PurchaseTime, NewPurchaseTime),
%% 											reward_history(Uid,Gives#give.goods_id),
											shoot_mod:reward_history2(Uid, Gives#give.goods_id,Gives#give.count),
											%% ?MSG_ECHO("--------------~n",[]),
											Bin4 = request_shoot(),
											app_msg:send(Socket, <<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary>>),
											{?ok,Player3};
										{?error,ErrorCode} ->
											BinMsg	= system_api:msg_error(ErrorCode),
											app_msg:send(Socket, BinMsg),
											{?ok,Player}
									end;
								?false ->
									NewPurchaseTime = PurchaseTime -1,
									GetMoney= get_money(Gives, Money, Money,Uid, Uname,NameColor,Lv,Pro),
									{Player3,Bin2} = role_api:currency_add([shooted,[],<<"每日一箭奖励">>], Player2, [{?CONST_CURRENCY_GOLD,GetMoney}]),
									NewHead= #head{position=Position, type=Type, award=Gives, is_shoot= ?CONST_TRUE},
									NewHeads = [NewHead|Heads],
									NewShoot= #shoot{ free_time= FreeTime, purchase_time= NewPurchaseTime, head=NewHeads,date= Date},
									active_api:check_link(Uid, 111),
									stat_api:logs_shoot(Uid, FreeTime, FreeTime, PurchaseTime, NewPurchaseTime),
									role_api_dict:shoot_set(NewShoot),
									Bin3 = request_shoot(),
									app_msg:send(Socket, <<Bin1/binary,Bin2/binary,Bin3/binary>>),
									{?ok,Player3}
							end;
						{?error, ErrorCode} ->
							BinMsg=system_api:msg_error(ErrorCode),
							app_msg:send(Socket,BinMsg),
							{?ok,Player}
					end;
				_ ->
					ErrorCode= ?ERROR_ARROW_DAILY_NO_TIMES,
					BinMsg=system_api:msg_error(ErrorCode),
					app_msg:send(Socket,BinMsg),
					{?ok,Player}
			end
	end.
		

typec_get(FreeTime) ->
	case FreeTime > 0 of
		?true ->
			?CONST_ARROW_DAILY_TYPE_GOLD;
		_ ->
			?CONST_ARROW_DAILY_TYPE_RMB
	end.

get_money(GoodsId, Money, AccMoney,Uid, Uname,NameColor,Lv,Pro) ->
	if 
		GoodsId =:= 100 -> GetMoney = AccMoney ,
						   reward_award(Uid,Uname,GetMoney),
						   Msg= broadcast_api:msg_broadcast_shoot({Uid,Uname,Lv,NameColor,Pro}, GetMoney),
						   chat_api:send_to_all(Msg),
						   reward_money(round(?CONST_ARROW_DAILY_MIN_REWARD)),
						   GetMoney;
		GoodsId =:= 101 -> GetMoney = round((AccMoney * 500)/?CONST_PERCENT),
						   NewMoney = Money - GetMoney,
						   shoot_mod:reward_history2(Uid, 101,1),
						   case NewMoney < ?CONST_ARROW_DAILY_MIN_REWARD of
							   ?true ->
								   NewMoney2 = ?CONST_ARROW_DAILY_MIN_REWARD;
							   _ ->
								   NewMoney2 = NewMoney
						   end,
						   reward_money(round(NewMoney2)),
						   GetMoney;
		GoodsId =:= 102 -> GetMoney = round((AccMoney * 1000)/?CONST_PERCENT),
						   NewMoney = Money - GetMoney,
						   shoot_mod:reward_history2(Uid, 102,1),
						   case NewMoney < ?CONST_ARROW_DAILY_MIN_REWARD of
							   ?true ->
								   NewMoney2 = ?CONST_ARROW_DAILY_MIN_REWARD;
							   _ ->
								   NewMoney2 = NewMoney
						   end,
						   reward_money(round(NewMoney2)),
						   GetMoney
	end.

shoot_reward1(Player= #player{uid= Uid, socket= Socket}, Gives, Bag, AccMoney, FreeTime, Type, Position, Heads, PurchaseTime, Date , BinCut) ->
	Goods = gives2goods([Gives]),
	%% ?MSG_ECHO("--------------~w~n",[Goods]),
	case bag_api:goods_set([shooted,[],<<"射箭奖励">>], Player, Bag, Goods) of
		{?ok, Player2,NewBag,GoodsBin,BinTmp} ->
			reward_money(round(AccMoney)),
			NewFreeTime = FreeTime -1,
			NewHead= #head{position=Position, type=Type, award=Gives#give.goods_id, is_shoot= ?CONST_TRUE},
			NewHeads = [NewHead|Heads],
			NewShoot= #shoot{ free_time= NewFreeTime, purchase_time= PurchaseTime, head=NewHeads,date= Date},
			role_api_dict:shoot_set(NewShoot),
%% 			reward_history(Uid,Gives#give.goods_id),
			shoot_mod:reward_history2(Uid, Gives#give.goods_id,Gives#give.count),
			role_api_dict:bag_set(NewBag),
			active_api:check_link(Uid, ?CONST_ACTIVITY_LINK_111),
			stat_api:logs_shoot(Uid, FreeTime, NewFreeTime, PurchaseTime, PurchaseTime),
			BinMsg = request_shoot(),
			app_msg:send(Socket, <<GoodsBin/binary,BinTmp/binary,BinMsg/binary,BinCut/binary>>),		
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinTmp	= system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinTmp),
			{?ok,Player}
	end.

shoot_reward2(Player= #player{uid= Uid, socket= Socket, uname= Uname,uname_color=NameColor,lv=Lv,pro= Pro}, Gives, AccMoney, Money, FreeTime, Type, Position, Heads, PurchaseTime, Date , BinCut)->
	NewFreeTime = FreeTime -1,
	GoodsId = Gives,
	GetMoney= get_money(GoodsId, Money, AccMoney, Uid, Uname,NameColor,Lv,Pro),
	%% ?MSG_ECHO("-----------------~w~n",[GetMoney]),
	{Player2,BinTmp} = role_api:currency_add([shooted,[],<<"射箭奖励">>], Player, [{?CONST_CURRENCY_GOLD,GetMoney}]),
	NewHead= #head{position=Position, type=Type, award=GoodsId, is_shoot= ?CONST_TRUE},
	NewHeads = [NewHead|Heads],
	NewShoot= #shoot{ free_time= NewFreeTime, purchase_time= PurchaseTime, head=NewHeads,date= Date},
	active_api:check_link(Uid, ?CONST_ACTIVITY_LINK_111),
	stat_api:logs_shoot(Uid, FreeTime, NewFreeTime, PurchaseTime, PurchaseTime),
	role_api_dict:shoot_set(NewShoot),
	BinMsg = request_shoot(),
	app_msg:send(Socket, <<BinCut/binary,BinTmp/binary,BinMsg/binary>>),
	{?ok,Player2}.

gives2goods(Gives) ->
	Fun = fun(Give,AccGoods) ->
				  case bag_api:goods(Give) of
					  Goods when is_record(Goods,goods) ->
						  [Goods|AccGoods];
					  _ ->
						  AccGoods
				  end
		  end,
	lists:foldl(Fun, [], Gives).

reward_money(Money) ->
	shoot_srv:reward_money_cast(Money).

reward_history(Uid,GoodsId) ->
	shoot_srv:reward_history_cast(Uid,GoodsId).

reward_award(Uid,Uname,Money) ->
	shoot_srv:reward_all_cast(Uid, Uname, Money).

%% 根据玩家Uid找到玩家名字
get_uid_to_name(Uid) ->
	case role_api_dict:player_get(Uid) of 
		{?ok,#player{uname=Uname}} ->
			Uname;
		_ ->
			<<>>
	end.


% 每日一箭返回 [51220]
msg_reply(FreeTime,PurchaseTime,Money,Name,LastAward,Bin1,Bin2,Bin3,Bin4)->
	%% ?MSG_ECHO("~w~n",[{FreeTime,PurchaseTime,Money,Name,LastAward,Bin1,Bin2,Bin3,Bin4}]),
    RsList = app_msg:encode([{?int16u,FreeTime},{?int16u,PurchaseTime},{?int32u,Money},{?string,Name},{?int32u,LastAward}]),
	%% ?MSG_ECHO("---------------------~w~n",[RsList]),
    app_msg:msg(?P_SHOOT_REPLY, <<RsList/binary,Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary>>).

% 头像信息块 [51230]	
msg_head_info(Position,Type,Award)->
    app_msg:encode([{?int16u,Position},{?int8u,Type},{?int16u,Award}]).


% 获取其他玩家获奖信息块 [51240]
msg_award_info(Uname,Reward,Count)->
    app_msg:encode([{?string,Uname},
        {?int16u,Reward},{?int16u,Count}]).

