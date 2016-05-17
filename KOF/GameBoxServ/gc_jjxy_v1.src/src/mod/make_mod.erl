%% Author: youxi
%% Created: 2012-9-25
%% Description: TODO: Add description to make_mod
-module(make_mod).

%%
%% Include files
%%
-include("comm.hrl").
%%
%% Exported Functions
%%
-export([
%% 		 make/5, 
		 make_take/6,
		 make_set/7,
		 stren/7, 
		 stren_key/8,
		 make_enchant/5,
%% 		 upgrade/4, 
%% 		 
%% 		 wash/5, 
%% 		 wash_replace/3,
		 compose/4,
		 inset/5,
%% 		 remove/5,
%% 		 part/4,
		 refresh_attr/5]).

%%
%% API Functions
%% 打造物品(包括装备、首饰,包括法宝),即低阶打造高阶物品(通用接口),消耗物品或者货币来打造目标物品
%% return : {?ok, Player， Bin} | {?error, ErrorCode}
%% make(Player, TypeC, Id, Idx, Gid) ->
%% 	case make_take(Player, TypeC, Id, Idx) of    %% 取出要打造的装备
%% 		{?ok, Player2, #goods{goods_id = GoodsId, flag = #g_flag{make = IsMake}} = GoodsTake, Bin} ->
%% 			case IsMake of
%% 				?CONST_TRUE ->
%% 					case data_equip_make:get(GoodsId) of    %% 获取打造数据
%% 						#d_equip_make{make1 = Make1, make2 = Make2} ->  
%% 							if
%% 								Gid =:= 0 ->
%% 									{?error, ?ERROR_BADARG};
%% 								Gid =:= Make1#d_make.goods ->
%% 									make(Player2,TypeC,Id,Idx, Make1, GoodsTake, Bin);
%% 								Gid =:= Make2#d_make.goods ->
%% 									make(Player2,TypeC,Id,Idx, Make2, GoodsTake, Bin);
%% 								?true ->% 不可打造
%% 									?MSG_ERROR("{Player#player.uid,GoodsId,TypeC, Id, Idx, Gid} : ~p~n", 
%% 											   [{Player#player.uid,GoodsId,TypeC, Id, Idx, Gid}]),
%% 									{?error, ?ERROR_MAKE_MAKE_BAN}
%% 							end;
%% 						_ ->
%% 							{?error, ?ERROR_GOODS_NOT_EXIST}
%% 					end;
%% 				?CONST_FALSE ->% 不可打造
%% 					?MSG_ERROR("{Player#player.uid,GoodsId,TypeC, Id, Idx, Gid} : ~p~n", 
%% 							   [{Player#player.uid,GoodsId,TypeC, Id, Idx, Gid}]),
%% 					{?error, ?ERROR_MAKE_MAKE_BAN}
%% 			end;
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end.


%% make(Player = #player{sid = Sid, uid =Uid}, TypeC, Id, Idx, Make, #goods{} = GoodsTake, Bin) ->
%% 	case make_do(Player, Make, GoodsTake) of    %% 执行打造操作
%% 		{?ok, Player2, GoodsMake0, Bin2} ->
%% 			case make_stren_low(GoodsMake0, GoodsTake) of
%% 				{?ok, GoodsMake2} ->
%% 					GoodsMake3 = make_plus_save(GoodsMake2, GoodsTake),
%% 					GoodsMake = goods_api:score_equip(GoodsMake3),
%% 					case make_set(Player2, GoodsMake, TypeC, Id, Idx, Bin) of    %% 放入打造物品
%% 						{?ok, Player3, Bin3} ->
%% 							Bin4 = 
%% 								case find_stren_pos(Player3, TypeC, Id, GoodsMake) of
%% 									{?true, Index} ->
%% 										make_api:msg_make_ok(?CONST_GOODS_CONTAINER_BAG, 0, Index);
%% 									?false ->
%% 										make_api:msg_make_ok(?CONST_GOODS_CONTAINER_EQUIP, Id, Idx)
%% 								end,
%% 							Player4 = refresh_attr(TypeC, Id, Player3),
%% 							Player5 = target_api:listen_equip(Player4,?CONST_TARGET_MAKE_EQUIP,1),
%% 							stat_api:logs_goods(Sid,Uid,?CONST_TRUE,?MODULE,make,GoodsMake,<<"打造装备">>),
%% 							{?ok, Player5, <<Bin2/binary, Bin3/binary, Bin4/binary>>};
%% 						{?error, ErrorCode} ->
%% 							{?error, ErrorCode}
%% 					end;
%% 				{?error, ErrorCode} ->
%% 					{?error, ErrorCode}
%% 			end;
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end.


%% %% 打造如果品质高强化降等级
%% %% return  {?ok, Goods} | {?error, ErrorCode}
%% make_stren_low(#goods{name_color = Color, type = TypeOld, type_sub = Typesub, class = Class, exts = Exts} = GoodsMake,
%% 			   #goods{type = Type, exts = Exts0}) ->
%% 	LowLv = case Type of
%% 				?CONST_GOODS_EQUIP ->
%% 					?CONST_MAKE_STREN_LOW_WEA;
%% 				?CONST_GOODS_JEWELRY ->
%% 					?CONST_MAKE_STREN_LOW_JEW;
%% 				_ ->
%% 					?CONST_MAKE_STREN_LOW_MAGIC
%% 			end,
%% 	case erlang:max(Exts0#g_eq.streng - LowLv, 0) of 
%% 		0 ->
%% 			Exts2 = Exts#g_eq{streng = 0, streng_v = 0},
%% 			{?ok, GoodsMake#goods{exts = Exts2}};
%% 		StrenLv ->
%% 			case make_api:data_stren_get(StrenLv, Color, TypeOld, Typesub, Class) of
%% 				#d_stren_equip{value = Value} ->
%% 					Exts2 = Exts#g_eq{streng = StrenLv, streng_v = Value},
%% 					{?ok, GoodsMake#goods{exts = Exts2}};
%% 				_ ->
%% 					{?error, ?ERROR_MAKE_STREN_BAN}
%% 			end
%% 	end.

%% make_plus_save(#goods{lv = Lvm, exts = Extsm} = GoodsMake, #goods{exts = Exts, lv = Lv}) ->
%% 	case (Extsm#g_eq.plus) =/= (Exts#g_eq.plus) orelse Lvm =/= Lv of
%% 		?true ->
%% 			GoodsMake;
%% 		?false ->
%% 			#g_eq{plus = Plus} = Exts,
%% 			Extsm2 = Extsm#g_eq{plus = Plus},
%% 			GoodsMake#goods{exts = Extsm2}
%% 	end.


%% %% 打造装备 return:{?ok, Player, GoodsMake, Bin} | {?error, ErrorCode};
%% make_do(#player{info=Info} = Player, Make, GoodsTake) ->
%% 	#info{lv = Lv0} = Info,
%% 	#d_make{goods=Gid,lv=Lv,item1=Item1,count1=Count1,item2=Item2,count2=Count2, 
%% 			item3=Item3,count3=Count3,ct=CT, cv=CV} = Make,
%% 	case Lv == 0 orelse Lv0 >= Lv of
%% 		?true ->%% 满足打造等级条件
%% 			Fun = fun({X,Y}) -> X =/= 0 andalso Y =/= 0 end,
%% 			IL = lists:filter(Fun, [{Item1,Count1},{Item2,Count2},{Item3,Count3}]),
%% 			CL = lists:filter(Fun, [{CT,CV}]),
%% 			case make_cost(Player, CL, IL) of    %% 扣除打造所需材料与货币
%% 				{?ok, Player2, Bin} ->
%% 					GoodsMake0 = bag_api:goods(Gid),
%% 					GoodsMake = make_plus(GoodsMake0, GoodsTake),	
%% 					GoodsMake2 = make_skill(GoodsMake, GoodsTake),
%% 					make_broadcast(Player2, GoodsMake2),
%% 					{?ok, Player2, GoodsMake2, Bin};
%% 				{?error, ErrorCode} ->
%% 					{?error, ErrorCode}
%% 			end;
%% 		?false ->%% 等级不满足打造条件
%% 			{?error, ?ERROR_LV_LACK}
%% 	end.
%% 
%% make_plus(#goods{lv = Lv0, exts = G_eq} = GoodsMake, #goods{lv = LvTake, exts = Exts}) ->
%% 	G_eq2 = 
%% 		begin 
%% 			SizeN = size(G_eq#g_eq.slots),
%% 			SizeO = size(Exts#g_eq.slots),
%% 			case  SizeN < SizeO of
%% 				?true ->
%% 					G_eq;
%% 				?false ->
%% 					Slots = lists:foldl(fun(N, Acc) -> 
%% 												setelement(N, Acc, element(N, Exts#g_eq.slots)) 
%% 										end, G_eq#g_eq.slots, lists:seq(1, SizeO)),
%% 					G_eq#g_eq{slots = Slots}
%% 			end
%% 		end,
%% 	case length(Exts#g_eq.plus) =/= length(G_eq2#g_eq.plus) orelse Lv0 =/= LvTake of
%% 		?true ->
%% 			GoodsMake#goods{exts = G_eq2};
%% 		?false ->
%% 			G_eq3 = G_eq2#g_eq{plus = Exts#g_eq.plus},
%% 			GoodsMake#goods{exts = G_eq3}
%% 	end.
%% 
%% make_skill(#goods{lv = Lv, exts = ExtsM} = GoodsMake, #goods{lv = Lv, type = Type, type_sub = Typesub, exts = ExtsT}) ->
%% 	case Type == ?CONST_GOODS_EQUIP andalso ?true == lists:member(Typesub, ?EQUIP_WEAPON_TYPES) of
%% 		?true ->
%% 			GoodsMake#goods{exts = ExtsM#g_eq{wskill_id = ExtsT#g_eq.wskill_id}};
%% 		?false ->
%% 			GoodsMake
%% 	end;
%% make_skill(GoodsMake, _) ->
%% 	GoodsMake.
	


%% %% 打造金色以上广播 return : void()
%% make_broadcast(#player{sid = Sid, uid = Uid, info = Info}, #goods{type = Type, name_color = NameColor} = Goods) when NameColor >= ?CONST_COLOR_GOLD ->
%% 	case case Type of
%% 			 ?CONST_GOODS_EQUIP ->
%% 				 {?true, msg_broadcast_equip};
%% 			 ?CONST_GOODS_MAGIC ->
%% 				 {?true, msg_broadcast_magic};
%% 			 _ ->
%% 				 ?false
%% 		 end of
%% 		{?true, Func} ->
%% 			Bin = broadcast_api:Func({Sid,Uid,Info#info.name,Info#info.lv,Info#info.name_color},Goods),
%% 			chat_api:send_to_all(Bin);
%% 		?false ->
%% 			?ok
%% 	end;
%% make_broadcast(_, _) ->
%% 	?ok.


%% 取出idx装备
%% return: {?ok, Bag,Equip,Inn,GoodsTake, Bin} | {?error, ErrorCode}
make_take(Bag,Equip,Inn,Type, Id, Idx) ->
	case Type of
		?CONST_GOODS_CONTAINER_BAG ->%% 打造背包装备
			case bag_api:goods_get_idx(Bag,Idx,1,?CONST_FALSE) of
				{?ok,Bag2,Goods,Bin}->
					{?ok,Bag2,Equip,Inn,Goods,Bin};
				{?error,Error}->
					{?error,Error}
			end;
		?CONST_GOODS_CONTAINER_EQUIP ->%% 打造装备栏装备
			case Id of 
				0 ->% 主将
					case lists:keytake(Idx, #goods.idx, Equip) of
						{value, #goods{} = GoodsTake, Equip2} ->
							Bin = bag_api:msg_remove(?CONST_GOODS_CONTAINER_EQUIP, 0, [Idx]),
							{?ok,Bag,Equip2,Inn,GoodsTake,Bin};
						?false ->
							{?error, ?ERROR_GOODS_NOT_EXIST}
					end;
				_ ->
					#inn{partners = Partners} = Inn,
					case lists:keytake(Id, #partner.partner_id, Partners) of
						{value, #partner{equip = EquipP} = Partner, Partners2} ->
							case lists:keytake(Idx, #goods.idx, EquipP) of
								{value, #goods{} = GoodsTake, EquipP2} ->
									Bin = bag_api:msg_remove(?CONST_GOODS_CONTAINER_EQUIP, Id, [Idx]),
									Inn2 = Inn#inn{partners = [Partner#partner{equip = EquipP2}|Partners2]},
									{?ok,Bag,Equip,Inn2,GoodsTake,Bin};
								?false ->
									{?error, ?ERROR_GOODS_NOT_EXIST}
							end;
						?false ->%% 武将不存在
							{?error, ?ERROR_INN_NO_PARTNER}
					end
			end;
		_ ->
			{?error, ?ERROR_BADARG}
	end.	


%% 放入打造物品
%% return:{?ok, Bag,Equip,Inn, Bin} | {?error, ErrorCode}
make_set(Bag,Equip,Inn,GoodsMake0, Type, Id, Idx) ->
	make_set(Bag,Equip,Inn,GoodsMake0, Type, Id, Idx, <<>>).

make_set(Bag,Equip,Inn,#goods{type_sub = Typesub} = GoodsMake0, Type, Id, Idx, Bin0) ->
	GoodsMake = GoodsMake0#goods{idx = Typesub},
	case Type of
		?CONST_GOODS_CONTAINER_BAG ->%% 打造背包装备
			{?ok,Bag2,Bin}=bag_api:set_idx(Bag, [GoodsMake#goods{idx = Idx}]),
			{?ok,Bag2,Equip,Inn,<<Bin0/binary,Bin/binary>>};
		?CONST_GOODS_CONTAINER_EQUIP ->%% 打造装备栏装备
			%% 			CheckMagic = ?ok,
			case Id of
				0 ->
					Equip2 = [GoodsMake|lists:keydelete(Idx, #goods.idx, Equip)],
					Bin = bag_api:msg_change(?CONST_GOODS_CONTAINER_EQUIP, Id, [GoodsMake]),
					{?ok,Bag,Equip2,Inn,<<Bin0/binary,Bin/binary>>};
				_ ->% 伙伴身上
					case lists:keytake(Id, #partner.partner_id, Inn#inn.partners) of
						{value, #partner{equip = EquipP}=Partner,Partners} ->
							EquipP2 = [GoodsMake|lists:keydelete(Idx, #goods.idx, EquipP)],
							Partner2 = Partner#partner{equip = EquipP2},
							Inn2 = Inn#inn{partners = [Partner2|Partners]},
							Bin = bag_api:msg_change(?CONST_GOODS_CONTAINER_EQUIP, Id, [GoodsMake]),
							{?ok, Bag,Equip, Inn2, <<Bin0/binary,Bin/binary>>};
						?false ->
							{?error, ?ERROR_INN_NO_PARTNER}
					end
			end
	end.


%% 强化装备
stren_key(Player,StrenType,TypeC,Id,Idx,Discount,Double,CostType)->
	Bag=role_api_dict:bag_get(),
	Equip=role_api_dict:equip_get(),
	Inn	 =role_api_dict:inn_get(),
	case make_take(Bag,Equip,Inn,TypeC, Id, Idx) of
		{?ok,Bag2,Equip2,Inn2,GoodsTake,Bin} ->
			case case StrenType of
				?CONST_TRUE->
					case stren_key2(Player,Bag2,Discount,Double,GoodsTake,CostType,<<>>) of
						{?ok,_KFlag,_KPlayer,_KBag,_KGoodsBin,GoodsTake,KError}->
							{?error,KError};
						{?ok,KFlag,KPlayer0,KBag,KGoodsBin,KGoodsTake,_KError}->
							{?ok,KFlag,KPlayer0,KBag,KGoodsBin,KGoodsTake}
					end;
				_->
					stren_one(Player,Bag2,Discount,Double,GoodsTake,CostType)
			end of
				{?ok,Flag,Player2,Bag3,GoodsBin,GoodsStren}->
					case make_set(Bag3,Equip2,Inn2,GoodsStren,TypeC, Id, Idx,Bin) of
						{?ok,Bag4,Equip3,Inn3,Bin2}->
							MoneyBin=stren_money(Player#player.money,Player2#player.money),
							Bin3 = 
								case find_stren_pos(Bag4,Equip3,Inn3,TypeC,Id,GoodsStren) of
									{?true, Index} ->%% 在背包中
										make_api:msg_strengthen_ok(Flag,?CONST_GOODS_CONTAINER_BAG,0,Index);
									?false ->% 在原来的地方
										make_api:msg_strengthen_ok(Flag,?CONST_GOODS_CONTAINER_EQUIP,Id,Idx)
								end,
							{?ok,Player3,Equip4,Inn4} = refresh_attr(Equip3,Inn3,TypeC,Id,Player2),
							Bag=role_api_dict:bag_set(Bag4),
							Equip=role_api_dict:equip_set(Equip4),
							Inn	 =role_api_dict:inn_set(Inn4),
							{?ok, Player3,<<Bin/binary,Bin2/binary,Bin3/binary,MoneyBin/binary,GoodsBin/binary>>};
						{?error, ErrorCode11}->
							{?error, ErrorCode11}
					end;
				{?error,Error}->
					{?error,Error}
			end;
		{?error,Error}->
			{?error,Error}
	end.

%% 一键强化
stren_key2(Player,Bag,Discount,Double,GoodsTake,CostType,GoodsBin)->
	case stren_one(Player,Bag,Discount,Double,GoodsTake,CostType) of
		{?ok,_Flag,Player2,Bag2,NGoodsBin,GoodsStren}->
			stren_key2(Player2,Bag2,Discount,Double,GoodsStren,CostType,NGoodsBin);
		{?error,Error}->
			{?ok,?CONST_TRUE,Player,Bag,GoodsBin,GoodsTake,Error}
	end.
	
%% 强化一次
stren_one(Player=#player{lv=InfoLv,uid=Uid},Bag,Discount,Double,GoodsTake,CostType)->
	#goods{goods_id=GoodsId,name_color=Color,class=Class,type=Type,type_sub=Typesub,exts=Exts}=GoodsTake,
	case lists:member(Type, ?EQUIP_TYPE_LIST) of
		?true->
			#g_eq{streng = StrenLv} = Exts,
			case StrenLv + 1 =< InfoLv of
				?true->
					case data_stren(GoodsId,StrenLv + 1, Color, Type, Typesub, Class) of
						{?error,Error}->
							{?error,Error};
						DataStren->
							case stren2(Player,Bag,Discount,Double,GoodsTake,DataStren,CostType) of
								{?ok,Flag,Player2,Bag2,GoodsBin,GoodsStren}->
									task_daily_api:check_cast(Uid,?CONST_TASK_DAILY_STRENGTH_EQUIP,0),
									{?ok,Flag,Player2,Bag2,GoodsBin,GoodsStren};
								{?error,Erroe}->
									{?error,Erroe}
							end
					end;
				_ ->% 无数据,不可强化
					{?error, ?ERROR_KOF_TIPS_STRENGTHENING_LIMIT}
			end;
		_->
			{?error, ?ERROR_MAKE_STREN_BAN}
	end.
	
%% 扣钱信息
stren_money(Money,NMoney)->
	MoneyBin=role_api:msg_currency(NMoney),
	#money{gold=Gold,rmb=RMB,rmb_bind=RmbBind}=Money,
	#money{gold=NGold,rmb=NRMB,rmb_bind=NRmbBind}=NMoney,
	Bin=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY,?CONST_LOGS_DEL,?CONST_CURRENCY_GOLD,Gold-NGold),
	Bin2=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY,?CONST_LOGS_DEL,?CONST_CURRENCY_RMB,RMB-NRMB),
	Bin3=logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY,?CONST_LOGS_DEL,?CONST_CURRENCY_RMB_BIND,RmbBind-NRmbBind),
	<<MoneyBin/binary,Bin/binary,Bin2/binary,Bin3/binary>>.
	

data_stren(GoodsId,StrenLv, Color, Type, Typesub, Class)->
	case make_api:data_stren_get(StrenLv, Color, Type, Typesub, Class) of
		DataStren when is_record(DataStren, d_equip_stren) ->
			case data_equip_make:get(GoodsId) of
				#d_equip_make{str_need=StrNeed,lv_last=LvLast,make1=Make1}->
					case StrenLv>=StrNeed of
						?true->
							NewGoods=bag_api:goods(Make1#d_make.goods),
							#goods{name_color=NColor,class=NClass,type=NType,type_sub=NTypesub}=NewGoods,
							case make_api:data_stren_get(LvLast,NColor,NType,NTypesub,NClass) of
								NDataStren when is_record(NDataStren, d_equip_stren)->
									NDataStren;
								_->
									{?error, ?ERROR_MAKE_STREN_BAN}
							end;
						_->
							DataStren
					end;
				_->
					DataStren
			end;
		_->
			{?error, ?ERROR_MAKE_STREN_BAN}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%% 原强化装备 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 强化装备 容器类型, idx 装备索引位置 强化装备几率成功
%% RoleID 武将ID, 容器类型, 位置索引  return : {?ok, Player, BinMsg} | {?error, ErrorCode}
stren(Player=#player{lv=InfoLv},TypeC, Id, Idx, Discount, Double, CostType)->
	Bag=role_api_dict:bag_get(),
	Equip=role_api_dict:equip_get(),
	Inn	 =role_api_dict:inn_get(),
	case make_take(Bag,Equip,Inn,TypeC, Id, Idx) of
		{?ok,Bag2,Equip2,Inn2,GoodsTake,Bin} ->
			#goods{goods_id=GoodsId,name_color=Color,class=Class,type=Type,type_sub=Typesub,exts=Exts}=GoodsTake,
			case lists:member(Type, ?EQUIP_TYPE_LIST) of
				?true->
					#g_eq{streng = StrenLv} = Exts,
					
					case StrenLv + 1 =< InfoLv of
						?true->
							case data_stren(GoodsId,StrenLv + 1, Color, Type, Typesub, Class) of
								{?error,Error}->
									{?error,Error};
								DataStren->
									case stren(Player,Bag2,Equip2,Inn2,TypeC,Id,Idx,Discount,Double,GoodsTake,DataStren,CostType,Bin) of
										{?ok,Player4,Bag4,Equip4,Inn4,Bin2}->
											role_api_dict:bag_set(Bag4),
											role_api_dict:equip_set(Equip4),
											role_api_dict:inn_set(Inn4),
											{?ok,Player4,Bin2};
										{?error,Erroe}->
											{?error,Erroe}
									end
							end;
						_ ->% 无数据,不可强化
							{?error, ?ERROR_KOF_TIPS_STRENGTHENING_LIMIT}
					end;
				_->
					{?error, ?ERROR_MAKE_STREN_BAN}
			end;
		{?error,Error}->
			{?error,Error}
	end.

%%stren(Player = #player{uid =Uid}, TypeC, Id, Idx, Discount, Double, GoodsTake, DataStren, CostType, Bin) ->
stren(Player,Bag,Equip,Inn,TypeC, Id, Idx, Discount, Double, GoodsTake, DataStren, CostType, Bin) ->
	#d_equip_stren{odds=Odds,money = Money, item1 = Item1, count1 = Count1, rep_t1 = Rep1, 
				   item2 = Item2, count2 = Count2, rep_t2 = Rep2,
				   item3 = Item3, count3 = Count3, rep_t3 = Rep3} = DataStren,
	ICGL0 = [{Item1,Count1,Rep1},{Item2,Count2,Rep2},{Item3,Count3,Rep3}],
	ICGL  = [{Item,Count,Rep}||{Item,Count,Rep} <- ICGL0, Item =/= 0],
	case stren_cost(Player,Bag, Money, ICGL, Discount, Double, CostType) of
		{?ok, Player2, Bag2, GoldBin,Bin2}->
			case stren_goods_odds(Odds, Player2, Bag2, GoodsTake, Double) of
				{Flag,Player3,Bag3,GoodsBin,GoodsStren} ->
					case make_set(Bag3,Equip,Inn,GoodsStren,TypeC, Id, Idx, Bin) of
						{?ok,Bag4,Equip2,Inn2,Bin0}->
							Bin3 = 
								case find_stren_pos(Bag4,Equip2,Inn2,TypeC,Id,GoodsStren) of
									{?true, Index} ->%% 在背包中
										make_api:msg_strengthen_ok(Flag,?CONST_GOODS_CONTAINER_BAG,0,Index);
									?false ->% 在原来的地方
										make_api:msg_strengthen_ok(Flag,?CONST_GOODS_CONTAINER_EQUIP,Id,Idx)
								end,
							{?ok,Player4,Equip4,Inn4} = refresh_attr(Equip2,Inn2,TypeC,Id,Player3),
							{?ok, Player4,Bag4,Equip4,Inn4, <<Bin0/binary,GoldBin/binary,Bin2/binary,Bin3/binary,GoodsBin/binary>>};
						{?error, ErrorCode11}->
							{?error, ErrorCode11}
					end;
				{?error, ErrorCode}->
					{?error, ErrorCode}
			end;
		{?error, ErrorCode}->
			{?error, ErrorCode}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stren2(Player,Bag,Discount, Double, GoodsTake, DataStren, CostType) ->
	#d_equip_stren{odds=Odds,money = Money, item1 = Item1, count1 = Count1, rep_t1 = Rep1, 
				   item2 = Item2, count2 = Count2, rep_t2 = Rep2,
				   item3 = Item3, count3 = Count3, rep_t3 = Rep3} = DataStren,
	ICGL0 = [{Item1,Count1,Rep1},{Item2,Count2,Rep2},{Item3,Count3,Rep3}],
	ICGL  = [{Item,Count,Rep}||{Item,Count,Rep} <- ICGL0, Item =/= 0],
	case stren_cost(Player,Bag,Money, ICGL, Discount, Double, CostType) of
		{?ok, Player2, Bag2,_GoldBin,CaiLiaoBin}->
			case stren_goods_odds(Odds, Player2, Bag2, GoodsTake, Double) of
				{Flag,Player3,Bag3,GoodsBin,GoodsStren} ->
					{?ok,Flag,Player3,Bag3,<<CaiLiaoBin/binary,GoodsBin/binary>>,GoodsStren};
				{?error, ErrorCode}->
					{?error, ErrorCode}
			end;
		{?error, ErrorCode}->
			{?error, ErrorCode}
	end.

stren_goods_odds(Odds,Player,Bag,GoodsTake,Double)->
	case util:rand_odds(Odds, ?CONST_PERCENT) of
		?true->
			case stren_up(Player,Bag,GoodsTake,Double) of
				{Player2,Bag2,Bin,GoodsStren0}->
					GoodsStren  = make_api:price_stren(GoodsStren0),
					{?CONST_TRUE,Player2,Bag2,Bin,GoodsStren};
				{?error,Error}->{?error,Error}
			end;
		_->
			GoodsStren0=stren_lose(GoodsTake),
			GoodsStren = make_api:price_stren(GoodsStren0),
			{?CONST_FALSE,Player,Bag,<<>>,GoodsStren}
	end.
  

%% 强化消耗铜钱和材料(不足消耗金币代替),在特定时间内有8折优惠
%% return: {?ok, Player, Bin} | {?error, ErrorCode}
stren_cost(Player,Bag,Money, GidCountL, Discount, Double, CostType) ->
	Res = check_discount(),
	TypevL = if
				 Res ==?true ->% 打折活动时间
					 [{?CONST_CURRENCY_GOLD,round(Money * 0.8)}];
				 Discount ==?true ->
					 [{?CONST_CURRENCY_GOLD,round(Money * 0.8)},{?CONST_CURRENCY_RMB, ?CONST_MAKE_STREN_DIS_COST}];
				 ?true ->
					 [{?CONST_CURRENCY_GOLD,Money}]			
			 end,
	
	TypevL2 = case Double of
				  ?true ->
					  [{?CONST_CURRENCY_RMB, ?CONST_MAKE_STREN_DOU_COST}|TypevL];
				  ?false ->
					  TypevL
			  end,
	stren_cost2(Player, Bag, TypevL2, GidCountL, CostType).



stren_cost2(Player, Bag, TypevL, GidCountL0,_) ->
	GidCountL = lists:map(fun({Item,Count,_Rep}) -> {Item,Count} end, GidCountL0),
	case role_api:currency_cut([stren_cost,[],<<"强化消耗材料">>], Player, TypevL) of
		{?ok, Player2, GoldBin} ->
			case GidCountL of
				[]->{?ok,Player2,Bag,GoldBin,<<>>};
				_->
					case bag_api:goods_get([stren_cost,[],<<"强化消耗材料">>],Player2,Bag,GidCountL) of
						{?ok,Player3,NewBag, CaiLiaoBin} ->
							{?ok, Player3, NewBag, GoldBin,CaiLiaoBin};
						{?error,Error}->
							{?error,Error}
					end
			end;
		{?error,Error}->
			{?error,Error}
	end.

%% stren_cost2(Player, _Bag, TypevL, GidCountL, _) ->
%% 	Fun = fun({_Item,Count,Rep}, Acc) ->
%% 				  Count * Rep + Acc
%% 		  end,
%% 	Rmb = lists:foldl(Fun, 0, GidCountL),
%% 	Currency = [{?CONST_CURRENCY_RMB, Rmb}|TypevL],
%% 	role_api:currency_cut([?MODULE,stren_cost,[],<<"强化消耗材料">>], Player, Currency).


%% 查找特定物品在背包中位置 return : {?true, Idx} | false
find_stren_pos(Bag,Equip,Inn,?CONST_GOODS_CONTAINER_EQUIP = Type, ID, #goods{idx = Idx} = Goods) ->
	case make_take(Bag,Equip,Inn,Type, ID, Idx) of
		{?ok, _,_,_,_,_} ->
			?false;
		{?error, _} ->
			find_stren_pos2(Bag, Goods)
	end;

find_stren_pos(Bag,_Equip,_Inn, _, _, Goods) ->
	find_stren_pos2(Bag, Goods).

find_stren_pos2(Bag, #goods{id = Id0,goods_id=Gid0,time=Time0,expiry=Expiry0}) ->
	Pred = fun(#goods{id = Id,goods_id=Gid,time=Time,expiry=Expiry}) ->
				   Gid0 == Gid andalso Id0 == Id andalso 
					   Time0 == Time andalso Expiry0 == Expiry
					   
		   end,
	{_Bag2,GoodsTakes,_Bin} = bag_api:take_filter(Bag, Pred),
	case GoodsTakes of
		[#goods{idx = Idx}|_] ->
			{?true,Idx};
		_ ->
			?false
	end.

%% 检查是否打折时间 return : boolean()
check_discount() -> 
	?false.
%% 	check_make_acty(?CONST_ACTIVITY_STRENGTHEN, ?CONST_ACTIVITY_STRENGTHEN_WEEKEN).

%% 检查是否双倍时间 return : boolean()
check_double() ->
	?false.
%% 	check_make_acty(?CONST_ACTIVITY_STRENGTHEN, ?CONST_ACTIVITY_STRENGTHEN_WEEKEN).

check_make_acty(_ID1, _ID2) ->
	?false.
%% 	Key1 = activity_api:key(ID1),
%% 	Key2 = activity_api:key(ID2),
%% 	case global_data:get(Key1) of
%% 		?CONST_TRUE ->
%% 			case global_data:get(Key2) of
%% 				?CONST_TRUE ->
%% 					?true;
%% 				_ ->
%% 					?false 
%% 			end;
%% 		_ ->
%% 			?false
%% 	end.




%% 强化升级,特定时间内可能升两级
%% return: Goods
stren_up(Player,Bag,#goods{goods_id=GoodsId,name_color = Color, type = Type, type_sub = Typesub, class = Class, exts = Exts} = Goods, Double) ->
	#g_eq{streng = Lv0,enchant=Enchant,enchant_value=EnchantValue,slots=Slots} = Exts,
	Lvp = stren_lv(Double),
	StrenLv = Lv0 + Lvp,
	case make_api:data_stren_get(StrenLv, Color, Type, Typesub, Class) of
		#d_equip_stren{attr = Attr} ->
			%% 查看是否达到升阶
			case data_equip_make:get(GoodsId) of
				#d_equip_make{str_need=StrNeed,lv_last=LvLast,make1=Make1}->
					case StrenLv>=StrNeed of
						?true->
							case stren_make(Player,Bag,Make1) of
								{?true,Player2,Bag2,Bin}->
									NewGoods=bag_api:goods(Make1#d_make.goods),
									NewExts	=NewGoods#goods.exts,
									#goods{name_color=NColor,type=NType,type_sub=NTypesub,class=NClass}=NewGoods,
									case make_api:data_stren_get(LvLast,NColor,NType,NTypesub,NClass) of
										#d_equip_stren{attr = NAttr} ->
											NewExts2=NewExts#g_eq{streng = LvLast, streng_v = NAttr,slots=Slots,
																  enchant=Enchant,enchant_value=EnchantValue},
											NewGoods2=NewGoods#goods{exts=NewExts2};
										_->
											NewExts2=NewExts#g_eq{streng = LvLast,slots=Slots,
																  enchant=Enchant,enchant_value=EnchantValue},
											NewGoods2=NewGoods#goods{exts=NewExts2}
									end,
									{Player2,Bag2,Bin,NewGoods2};
								{?error,Error}->{?error,Error}
							end;
						_->
							Exts2=Exts#g_eq{streng = StrenLv, streng_v = Attr},
							Goods2=Goods#goods{exts=Exts2},
							{Player,Bag,<<>>,Goods2}
					end;
				_->
					Exts2=Exts#g_eq{streng = StrenLv, streng_v = Attr},
					Goods2=Goods#goods{exts=Exts2},
					{Player,Bag,<<>>,Goods2}
			end;	
		_ ->
			{Player,Bag,<<>>,Goods}
	end.

%% 强化失败
stren_lose(Goods=#goods{name_color = Color, type = Type, type_sub = Typesub, class = Class, exts = Exts})->
	#g_eq{streng = StrenLv} = Exts,
	case make_api:data_stren_get(StrenLv, Color, Type, Typesub, Class) of
		#d_equip_stren{lose_lv=LoseLv} ->
			case make_api:data_stren_get(LoseLv, Color, Type, Typesub, Class) of 
				#d_equip_stren{attr=Attr}->
					Exts2=Exts#g_eq{streng =LoseLv,streng_v = Attr},
					Goods#goods{exts=Exts2};
				_->
					Goods
			end;
		_->
			Goods
	end.
	
					
		

%% 打造，强化 消耗材料
stren_make(Player,Bag,#d_make{item1=Item1, count1=Count1, item2=Item2, count2=Count2, 
							  item3=Item3, count3=Count3, ct=Ct, cv=Cv})->
	GidCountL=[{Item1,Count1},{Item2,Count2},{Item3,Count3}],
	GidCountL2=[{I1,C1}||{I1,C1}<-GidCountL,I1=/=0 andalso C1=/=0],
	case GidCountL2 of
		[]->
			case role_api:currency_cut([stren_make,[],<<"装备强化打造">>],Player,[{Ct,Cv}]) of
				{?ok, Player3, GoldBin}->
					{?true,Player3,Bag,GoldBin};
				{?error,Error}->
					{?error,Error}
			end;
		_->
			
			case bag_api:goods_get([stren_make,[],<<"装备强化打造">>],Player,Bag,GidCountL2) of
				{?true,Player2, Bag2, GoodsBin}->
					case role_api:currency_cut([stren_make,[],<<"装备强化打造">>],Player2,[{Ct,Cv}]) of
						{?ok, Player3, GoldBin}->
							{?true,Player3,Bag2,<<GoodsBin/binary,GoldBin/binary>>};
						{?error,Error}->
							{?error,Error}
					end;
				{?error,Error}->
					{?error,Error}
			end
	end.

		
	
%% return : Lv
stren_lv(Double) ->
	case check_double() orelse Double of
		?true ->
			Rand = util:rand(0, ?CONST_PERCENT),
			?MSG_ECHO("~n~n~n~n~n~n~nRand:   ~w~n~n~n~n", [Rand]),			
			case Rand =< ?CONST_MAKE_STREN_DOUBLE_ODDS of
				?true ->% 成功
					2;
				?false ->
					1
			end;
		_ ->
			1
	end.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 法宝升阶, 花费元宝打造法宝,强化等级固定下降一级
%% return : {?ok, Player, Bin} | {?error, ErrorCode}
%% upgrade(Player, Type, Id, Idx) ->
%% 	case make_take(Player, Type, Id, Idx) of
%% 		{?ok, Player2, GoodsTake, Bin} ->%% 取出需要升阶的法宝
%% 			case upgrade_data(GoodsTake) of
%% 				{?ok, GoodsUp0, #d_magic_upgrade{vip=_Vip,cost_t=T,cost_v=V}} ->
%% 					%% 判断vip等级
%% 					case role_api:currency_cut([upgrade,[],<<"法宝升阶消耗">>],Player2, [{T,V}]) of
%% 						{?ok, Player3, Bin2} ->
%% 							GoodsUp = goods_api:score_equip(GoodsUp0),
%% 							case make_set(Player3, GoodsUp, Type, Id, Idx, Bin) of
%% 								{?ok, Player4, Bin3} ->
%% 									Bin4 = 
%% 										case find_stren_pos(Player4, Type, Id, GoodsUp) of
%% 											{?true, Index} ->%% 在背包中
%% 												make_api:msg_upgrade_ok(?CONST_GOODS_CONTAINER_BAG,0,Index);
%% 											?false ->% 在原来的地方
%% 												make_api:msg_upgrade_ok(?CONST_GOODS_CONTAINER_EQUIP,Id,Idx)
%% 										end,
%% 									Player5 = refresh_attr(Type, Id, Player4),
%% 									{?ok, Player5, <<Bin2/binary, Bin3/binary, Bin4/binary>>};
%% 								{?error, ErrorCode} ->
%% 									{?error, ErrorCode}
%% 							end;
%% 						{?error, ErrorCode} ->
%% 							{?error, ErrorCode}
%% 					end;
%% 				{?error, ErrorCode} ->
%% 					{?error, ErrorCode}
%% 			end;
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end.


%% 读取法宝升阶数据
%% {?ok, #goods{} = GoodsUp, #d_magic_upgrade = MagicUpgrade} | {?error, ErrorCode}
%% upgrade_data(#goods{goods_id=GoodsId,class=Class,type=?CONST_GOODS_MAGIC,exts = #g_eq{streng=Lv0}}) ->
%% 	case case data_equip_make:get(GoodsId) of
%% 			 #d_equip_make{make1=Make1,make2=Make2} ->
%% 				 case Make1#d_make.goods of
%% 					 0 ->%% 不可升阶
%% 						 case Make2#d_make.goods of
%% 							 0 ->%% 不可升阶
%% 								 {?error, ?ERROR_MAKE_UPGRADE_BAN};
%% 							 _ ->
%% 								 {?ok, Make2}
%% 						 end;
%% 					 _ ->
%% 						 {?ok, Make1}
%% 				 end;
%% 			 _ ->%% 找不到打造数据
%% 				 {?error, ?ERROR_MAKE_UPGRADE_BAN}
%% 		 end of
%% 		{?ok, #d_make{goods=UpID}} ->
%% 			case data_magic_upgrade:get(Class) of
%% 				#d_magic_upgrade{} = MagicUpgrade ->
%% 					GoodsUp = #goods{exts = Exts} = goods_api:goods(UpID),
%% 					StrenLv = erlang:max(0, Lv0 - 1),
%% 					GoodsUp2 = GoodsUp#goods{exts = Exts#g_eq{streng = StrenLv}},
%% 					{?ok, GoodsUp2, MagicUpgrade};
%% 				_ ->%% 找不到升阶数据
%% 					{?error, ?ERROR_MAKE_UPGRADE_BAN}
%% 			end;
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end;
%% upgrade_data(_) ->%% 不是法宝不可升阶
%% 	{?error, ?ERROR_MAKE_UPGRADE_BAN}.


%% 洗练装备
%% wash(#player{uid=Uid}=Player, Type, Id, Idx, Arg0) ->
%% 	{Arg, Count} = %% 类型, 次数
%% 		if
%% 			Arg0 =:= ?CONST_MAKE_WASH_TYPE_MUL_COM ->
%% 				{?CONST_MAKE_WASH_TYPE_COMM, ?CONST_MAKE_WASH_COUNT};
%% 			Arg0 =:= ?CONST_MAKE_WASH_TYPE_MUL_FIX ->
%% 				{?CONST_MAKE_WASH_TYPE_FIXED, ?CONST_MAKE_WASH_COUNT};
%% 			?true ->
%% 				{Arg0, 1}
%% 		end,
%% 	
%% 	case make_take(Player, Type, Id, Idx) of     %% 取出要洗练的装备,洗练出属性数据暂存,更新至前端
%% 		{?ok, _Player2, #goods{lv=Lv, name_color = Color} = GoodsTake, _Bin} ->
%% 			case wash_check(Arg, GoodsTake) of
%% 				?ok ->
%% 					case data_wash_cost:get(Arg, Lv, Color) of
%% 						#d_wash_cost{ctype = Ctype, cvalue = Cvalue} ->
%% 							case role_api:currency_cut([wash,[],<<"洗练消耗">>],Player, [{Ctype,Cvalue*Count}]) of     %% 扣除洗练消耗
%% 								{?ok, Player2, Bin} ->
%% 									case wash_attr(GoodsTake, Arg, Count) of 
%% 										{?ok, Value} ->
%% 											Tuple = {Uid,Arg0,Type,Id,Idx,GoodsTake,Value},
%% 											ets:insert(?ETS_MAKE_WASH, Tuple),
%% 											Bin2 = make_api:msg_wash_back(Arg0,Value),
%% 											{Player3, BinMsgRand} = task_api:rand_check(Player2, ?CONST_TASK_RAND_WASH, Count),
%% 											{?ok, Player3, <<Bin/binary, Bin2/binary, BinMsgRand/binary>>};
%% 										{?error, ErrorCode} ->
%% 											{?error, ErrorCode}
%% 									end;
%% 								{?error, ErrorCode} ->
%% 									{?error, ErrorCode}
%% 							end;
%% 						_ ->% 不可洗练
%% 							?MSG_ECHO("xxxxx", []),{?error, ?ERROR_MAKE_WASH_BAN}
%% 					end;
%% 				{?error, ErrorCode} ->
%% 					{?error, ErrorCode}
%% 			end;
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end.


%% %% return : [{Idx, Plus}] | SkillId
%% wash_attr(#goods{goods_id=GoodsId,type=?CONST_GOODS_EQUIP,exts=Exts,lv=Lv}, Arg, Count) ->
%% 	#g_eq{plus = Plus, wskill_id = Wskill} = Exts,
%% 	F = fun(TypeL) ->%% 返回新附加属性NewPlus :: [{Type, Color, Value, Max}|_] | []
%% 				Fi = fun(Type, Acc) ->
%% 							 case ?DATA_EQUIP_WASH_COLOR:get(Lv,Type) of
%% 								 [] ->
%% 									 Acc;
%% 								 ColorL0 ->
%% 									 ColorL = [ {{Color0,Minmax0},Odds} || {Color0,Minmax0,Odds} <- ColorL0],
%% 									 {Color,{Min,Max}} =
%% 										 case util:odds_list_count(ColorL, 1) of
%% 											 [] ->
%% 												 {V, _} = hd(ColorL),
%% 												 V;
%% 											 [V|_] ->
%% 												 V
%% 										 end,
%% 									 Value0 = util:rand(Min, Max),
%% 									 Value = 
%% 										 case lists:member(Type, ?EQUIP_TYPE_RAND_TRUNC) of
%% 											 ?true ->% 百分比属性
%% 												 round(Value0 / 10) * 10;
%% 											 ?false ->
%% 												 Value0
%% 										 end,
%% 									 [{Type,Color,Value,Max}|Acc]
%% 							 end
%% 					 end,
%% 				lists:foldr(Fi, [], TypeL)
%% 		end,
%% 	case Arg of
%% 		?CONST_MAKE_WASH_TYPE_COMM ->%% 普通洗练,洗属性类型和数值
%% 			case ?DATA_EQUIP_MIC:get(GoodsId) of
%% 				[_SlotCount,PlusCount,PlusType] ->	
%% 					{?ok, [{Idx, F(util:odds_list_count(PlusType, PlusCount))}||Idx <- lists:seq(1, Count)]};
%% 				_ ->%% 无数据
%% 					?MSG_ECHO("xxxxx", []),{?error, ?ERROR_MAKE_WASH_BAN}
%% 			end;
%% 		?CONST_MAKE_WASH_TYPE_FIXED ->%% 定向洗练,属性类型不变,洗练属性值
%% 			TypeList = [Type||{Type,_,_,_} <- Plus],
%% 			{?ok, [{Idx, F(TypeList)}||Idx <- lists:seq(1, Count)]};
%% 		?CONST_MAKE_WASH_TYPE_SKILL ->%% 技能洗练,仅仅洗练武器技能
%% 			%% 			SkillL = data_skill:get_weapon(),
%% 			SkillL = data_skill:get_weapon(),
%% 			NewSkill = util:odds_list(lists:delete(Wskill, SkillL)),
%% 			{?ok, NewSkill}
%% 	end;
%% wash_attr(_, _, _) ->%% 不可洗练
%% 	?MSG_ECHO("xxxxx", []),{?error, ?ERROR_MAKE_WASH_BAN}.
%% 
%% 
%% %% return : ok | {?error, ErrorCode}
%% wash_check(?CONST_MAKE_WASH_TYPE_SKILL, #goods{exts = Exts}) ->%% 武器技能
%% 	#g_eq{wskill_id = SkillID} = Exts,
%% 	SkillL = data_skill:get_weapon(),
%% 	case lists:member(SkillID, SkillL) of
%% 		?true ->
%% 			ok;
%% 		?false ->?MSG_ECHO("xxxxx", []),
%% 				 {?error, ?ERROR_MAKE_WASH_BAN}
%% 	
%% 	end;
%% wash_check(_Arg, #goods{exts = Exts}) ->
%% 	#g_eq{plus = Plus} = Exts,
%% 	case Plus of
%% 		[] ->% 不可洗练
%% 			?MSG_ECHO("xxxxx", []),{?error, ?ERROR_MAKE_WASH_BAN};
%% 		_ ->
%% 			ok
%% 	end.


%% 保留洗练属性
%% return : {?ok, Player, Bin} | {?error, ErrorCode}
%% wash_replace(#player{uid = Uid} = Player, Index, true) ->
%% 	case ets:lookup(?ETS_MAKE_WASH, Uid) of
%% 		[{Uid, Arg, Type, Id, Idx, GoodsTake, Data}|_] ->
%% 			case make_take(Player, Type, Id, Idx) of
%% 				{?ok, Player2, #goods{exts = Exts} = GoodsTake0, Bin} ->
%% 					case check_wash_goods(GoodsTake0, GoodsTake) of
%% 						?true ->
%% 							case case Arg of
%% 									 ?CONST_MAKE_WASH_TYPE_SKILL ->%% 武器技能
%% 										 Exts2 = Exts#g_eq{wskill_id = Data},
%% 										 GoodsWash = GoodsTake0#goods{exts = Exts2},
%% 										 {?ok, GoodsWash};
%% 									 _ ->
%% 										 case lists:keyfind(Index, 1, Data) of
%% 											 {Index, Plus} ->
%% 												 Exts2 = Exts#g_eq{plus = Plus},
%% 												 GoodsWash = GoodsTake0#goods{exts = Exts2},
%% 												 {?ok, GoodsWash};
%% 											 ?false ->% 发送索引参数错误
%% 												 {?error, ?ERROR_BADARG}
%% 										 end
%% 								 end of
%% 								{?ok, GoodsW0} ->
%% 									GoodsW = goods_api:score_equip(GoodsW0),
%% 									case make_set(Player2, GoodsW, Type, Id, Idx, Bin) of
%% 										{?ok, Player3, Bin2} ->
%% 											wash_del(Uid),
%% 											Bin3 = make_api:msg_wash_ok(Type,Id,Idx),
%% 											Player4 = refresh_attr(Type, Id, Player3),
%% 											{?ok, Player4, <<Bin2/binary,Bin3/binary>>};
%% 										{?error, ErrorCode} ->
%% 											{?error, ErrorCode}
%% 									end;
%% 								{?error, ErrorCode} ->
%% 									{?error, ErrorCode}
%% 							end;
%% 						?false ->
%% 							wash_del(Uid),
%% 							{?error, ?ERROR_UNKNOWN}
%% 					end;
%% 				{?error, ErrorCode} ->
%% 					{?error, ErrorCode}
%% 			end;
%% 		[] ->%% 无洗练数据
%% 			{?ok, Player, <<>>}
%% 	end;
%% 
%% wash_replace(#player{uid = Uid} = Player, _Idx, false) ->
%% 	wash_del(Uid),
%% 	{?ok, Player, <<>>}.
%% 
%% wash_del(Uid) ->
%% 	ets:delete(?ETS_MAKE_WASH, Uid).
%% 
%% 
%% %% 检查特定位置是否为洗练的物品 return : bool()
%% check_wash_goods(#goods{goods_id=Gid1,time=Time1}, #goods{goods_id=Gid2,time=Time2}) ->
%% 	Gid1 == Gid2 andalso Time1 == Time2.
%% 
%% 
%% 合成高阶灵珠 return: {?ok, Player2, Bin} | {?error, ErrorCode}
compose(?CONST_MAKE_COMPOSE_COMM, Player, Idx, Count) ->
	Bag=role_api_dict:bag_get(),
	case bag_api:read(Bag, Idx) of
		{?true, #goods{goods_id=Gid,type=Type}} ->
			case Type == ?CONST_GOODS_STERS of
				?true ->
					case data_goods:get(Gid) of
						#goods{exts=PExts}->
							#g_none{as2=NextPearlId}=PExts,
							case data_pearl_com:get(NextPearlId) of
								#d_pearl{goods_make=MatItem0}->
									MatItem=[{MatOneId,MatCount*Count,Re}||{MatOneId,MatCount,Re}<-MatItem0],
									Fun=fun({FMatOneId,FMatCount,FRe},{FMatItem,FMatItem2})->
												?IF(FRe==0,{[{FMatOneId,FMatCount}|FMatItem],FMatItem2},{FMatItem,[{FMatOneId,FMatCount,FRe}|FMatItem2]})
										end,
									{ZMatItem,ZMatItem2}=lists:foldl(Fun,{[],[]},MatItem),
									LogSrc=[inset,[],<<"宝石合成">>],
									case bag_api:goods_get(LogSrc,Player,Bag,ZMatItem) of
										{?ok,Player2,Bag2,GetBin}->
											case make_zmatitem2(LogSrc,Player2,Bag2,ZMatItem2,GetBin) of
												{?ok,Player3,Bag3,GetBin2}->
													case bag_api:goods(NextPearlId) of
														Goods when is_record(Goods,goods)->
															Goods2=Goods#goods{count = Count},
															case bag_api:goods_set([compose,[],<<"宝石合成">>],Player3,Bag3, [Goods2]) of
																{?ok,Player4,Bag4,GoodsBin,Bin2} ->
																	Bin3 = make_api:msg_compose_ok(),    %%% 合成成功
																	role_api_dict:bag_set(Bag4),
																	Bag4=role_api_dict:bag_get(),
																	{?ok, Player4, <<GetBin2/binary,GoodsBin/binary,Bin2/binary,Bin3/binary>>};
																{?error, ErrorCode} ->
																	{?error, ErrorCode}
															end;
														_ ->% 不能合成
															{?error, ?ERROR_MAKE_COMPOSE_BAN}
													end;
												{?error,Error}->
													{?error,Error}
											end;
										{?error,Error}->
											{?error,Error}
									end;
								_->
									{?error,?ERROR_MAKE_COMPOSE_BAN}
							end;
						_->
							{?error, ?ERROR_GOODS_NOT_EXIST}
					end;
				_->
					{?error, ?ERROR_MAKE_COMPOSE_BAN}
			end;
		_->
			{?error, ?ERROR_GOODS_NOT_EXIST}
	end.

make_zmatitem2(_LogSrc,Player,Bag,[],Bin)->{?ok,Player,Bag,Bin};
make_zmatitem2(LogSrc,Player,Bag,[{MatOneId,MatCount,Re}|ZMatItem],Bin)->
	?MSG_ECHO("================= ~w~n",[{MatOneId,MatCount,Re}]),
	case bag_api:goods_get(LogSrc,Player,Bag,[{MatOneId,MatCount}]) of
		{?ok,Player2,NewBag,Bin2}->
			make_zmatitem2(LogSrc,Player2,NewBag,ZMatItem,<<Bin/binary,Bin2/binary>>);
		_->
			[{_,Count}|_]=bag_api:get_goods_count([MatOneId]),
			Currency=[{?CONST_CURRENCY_RMB,(MatCount-Count)*Re}],
			case make_zmatitem2_re(LogSrc,Player,Currency) of
				{?ok,Player2,Bin2}->
					make_zmatitem2(LogSrc,Player2,Bag,ZMatItem,<<Bin/binary,Bin2/binary>>);
				{?error,Error}->
					{?error,Error}
			end
	end.

make_zmatitem2_re(LogSrc,Player,Currency)->
	case role_api:currency_cut(LogSrc,Player,Currency) of
		{?ok,Player2,Bin}->
			{?ok,Player2,Bin};
		{?error,Error}->
			{?error,Error}
	end.
%% 
%% compose(?CONST_MAKE_COMPOSE_ONEKEY, Player, Lv, _Count) ->% 一键合成
%% 	Seconds = util:seconds(),
%% 	case case erlang:get(make_compose) of
%% 			 {Lv, Seconds0} ->
%% 				 if
%% 					 Seconds - Seconds0 >= 5 ->
%% 						 erlang:put(make_compose, {Lv, Seconds}),
%% 						 ?ok;
%% 					 ?true ->
%% 						 ?skip
%% 				 end;
%% 			 _ ->
%% 				 erlang:put(make_compose, {Lv, Seconds}),
%% 				 ?ok
%% 		 end of
%% 		?ok ->
%% 			case Lv =< 100 of    
%% 				?true ->
%% 					case lists:seq(1, Lv) of
%% 						[] ->
%% 							{?error, ?ERROR_BADARG};
%% 						L ->
%% 							Fun = fun(Lv0, {PlayerAcc, BinAcc, Flag}) ->
%% 										  case compose2(?CONST_MAKE_COMPOSE_ONEKEY, PlayerAcc, Lv0) of
%% 											  {?ok, PlayerAcc2, BinAcc2} ->
%% 												  {PlayerAcc2, <<BinAcc/binary, BinAcc2/binary>>, ?IF(BinAcc2 == <<>>, Flag, ?true)};
%% 											  {?error, _} ->
%% 												  {PlayerAcc, BinAcc, Flag}
%% 										  end
%% 								  end,
%% 							{Player2, BinMsg, Flag2} = lists:foldl(Fun, {Player, <<>>, ?false}, L),
%% 							?IF(Flag2 == ?false, {?error, ?ERROR_MAKE_COMPOSE_NULL}, {?ok, Player2, BinMsg})
%% 					end;
%% 				_ ->
%% 					{?error, ?ERROR_BADARG}
%% 			end;
%% 		?skip ->
%% 			{?ok, Player, <<>>}
%% 	end.
%% 
%% compose2(?CONST_MAKE_COMPOSE_ONEKEY, #player{bag = Bag} = Player, Lv) ->% 一键合成
%% 	Pred = fun(#goods{type = ?CONST_GOODS_STERS,exts = #g_none{as2=Next}}) ->
%% 				   case goods_api:goods(Next) of
%% 					   #goods{exts = #g_none{as1 = Lv}} ->%% ok,满足条件
%% 						   true;
%% 					   _ ->
%% 						   false
%% 				   end;
%% 			  (_) ->
%% 				   false
%% 		   end,
%% 	case goods_api:take_filter(Bag, Pred, ?CONST_FALSE) of
%% 		{_, [], _} ->%% 没有可以合成的灵珠
%% 			{?error, ?ERROR_MAKE_COMPOSE_NULL};
%% 		{Bag2, GoodsTakes0, Bin} ->
%% 			GoodsTakes = lists:foldl(fun(#goods{goods_id=Gid,count=Count}=Goods,Acc) ->
%% 											 case lists:keytake(Gid, #goods.goods_id, Acc) of
%% 												 {value, #goods{count=Count0}=Goods0, Acc2} ->
%% 													 [Goods0#goods{count=Count0+Count}|Acc2];
%% 												 ?false ->
%% 													 [Goods|Acc]
%% 											 end
%% 									 end, [], GoodsTakes0),
%% 			compose_all(Player#player{bag = Bag2}, GoodsTakes, Bin)
%% 	end.
%% 
%% compose_all(Player, GoodsTakes, Bin) ->
%% 	case compose_all2(GoodsTakes, [], []) of
%% 		{?ok, GoodsList} ->
%% 			case goods_api:set([?MODULE,compose_all,[],<<"灵珠合成">>],Player, GoodsList, ?CONST_FALSE) of
%% 				{?ok, Player2, Bin2} ->
%% 					Bin0 = make_api:msg_compose_ok(),
%% 					{?ok, Player2, <<Bin0/binary, Bin/binary, Bin2/binary>>};
%% 				{?error, ErrorCode} ->
%% 					{?error, ErrorCode}
%% 			end;
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end.
%% 
%% compose_all2([], [], _) ->
%% 	{?error, ?ERROR_MAKE_COMPOSE_NULL};
%% compose_all2([], Com, Left) ->
%% 	{?ok, Com ++ Left};
%% compose_all2([#goods{count=Count, exts=#g_none{as2=Next}}=Goods|Takes], Com, Left) ->
%% 	Com2 = case Count div 2 of
%% 			   0 ->
%% 				   Com;
%% 			   CountNext ->
%% 				   PearlNext = goods_api:goods(Next),
%% 				   [PearlNext#goods{count = CountNext}|Com]
%% 		   end,
%% 	Left2 = case Count rem 2 of
%% 				0 ->%% 无剩余
%% 					Left;
%% 				CountLeft ->
%% 					[Goods#goods{count=CountLeft}|Left]
%% 			end,
%% 	compose_all2(Takes, Com2, Left2).


%% 镶嵌灵珠 return: {?ok, Player, Bin} | {?error, ErrorCode} 
inset(Player=#player{uid=Uid}, Type, Id, Idx, PearlType) ->
	Bag=role_api_dict:bag_get(),
	Equip=role_api_dict:equip_get(),
	Inn	 =role_api_dict:inn_get(),
	case make_take(Bag,Equip,Inn,Type, Id, Idx) of
		{?ok,Bag2,Equip2,Inn2,GoodsTake,Bin}->
			case check_inset(GoodsTake,PearlType) of
				{?ok,0,_PearlValue}->
					case data_goods:get_pearl_id(PearlType,1) of
						0->
							{?error,?ERROR_CHECK_SUM};%%类型错误
						PearlId->
							LogSrc=[inset,[],<<"镶嵌灵珠">>],
							case bag_api:goods_get(LogSrc,Player,Bag2,[{PearlId,1}]) of
								{?ok,Player2,Bag3,BinGet}->
									GoodsTake2=do_inset(GoodsTake,PearlId,PearlType),
									case make_set(Bag3,Equip2,Inn2,GoodsTake2,Type,Id,Idx) of
										{?ok,Bag4,Equip3,Inn3,Bin2}->
											{?ok,Player3,Equip4,Inn4}=refresh_attr(Equip3,Inn3,Type,Id,Player2),
											role_api_dict:bag_set(Bag4),
											role_api_dict:equip_set(Equip4),
											role_api_dict:inn_set(Inn4),
											{?ok,Player3,<<Bin/binary,Bin2/binary,BinGet/binary>>};
										{?error,Error}->
											{?error,Error}
									end;
								{?error,Error}->
									{?error,Error}
							end
					end;
				{?ok,PearlId,_PearlValue}->
					case data_goods:get(PearlId) of
						#goods{exts=PExts}->
							#g_none{as2=NextPearlId}=PExts,
							LogSrc=[inset,[],<<"宝石镶嵌">>],
							case bag_api:goods_get(LogSrc,Player,Bag2,[{NextPearlId,1}]) of
								{?ok,Player2,Bag3,GetBin}->
									GoodsTake2=do_inset(GoodsTake,NextPearlId,PearlType),
									case make_set(Bag3,Equip2,Inn2,GoodsTake2,Type,Id,Idx) of
										{?ok,Bag4,Equip3,Inn3,Bin2}->
											{?ok,Player3,Equip4,Inn4}=refresh_attr(Equip3,Inn3,Type,Id,Player2),
											role_api_dict:bag_set(Bag4),
											role_api_dict:equip_set(Equip4),
											role_api_dict:inn_set(Inn4),
											{?ok,Player3,<<Bin/binary,Bin2/binary,GetBin/binary>>};
										{?error,Error}->
											{?error,Error}
									end;
								{?error,Error}->
									{?error,Error}
							end;
						_->
							{?error,?ERROR_CHECK_SUM}
					end;		
				{?error,Error}->
					{?error,Error}
			end;
		{?error,Error}->
			{?error,Error}
	end.

%% 镶嵌珠子到装备
do_inset(GoodsTake=#goods{exts=Exts},PearlId,PearlType)->
	case data_goods:get(PearlId) of
		#goods{exts=PExts}->
			#g_eq{slots=Slots}=Exts,
			#g_none{as3=Value}=PExts,
			case lists:keytake(PearlType,1,Slots) of
				{value,_,Slots2}->
					Slots3=[{PearlType,PearlId,Value}|Slots2],
					Exts2=Exts#g_eq{slots=Slots3};
				_->
					Exts2=Exts
			end,
			GoodsTake#goods{exts=Exts2};
		_->GoodsTake
	end.
				
			
	
%% 			case bag_api:goods_get_idx(Bag2, IdxPearl, 1) of
%% 				{?ok,Bag3,Pearl,Bin2} ->
%% 					case check_inset(Equip, Pearl) of
%% 						?ok ->
%% 							LogSrc = [?MODULE, do_inset, [], <<"镶嵌灵珠">>],
%% 							case do_inset(Equip, Pearl) of
%% 								{?true, Equip20, Pearl0} ->%% 有替换灵珠
%% 									  Equip2 = goods_api:score_equip(Equip20),
%% 									  case goods_api:set([?MODULE,inset,[],<<"镶嵌替换下的灵珠">>],Player3, [Pearl0]) of
%% 										  {?ok, Player4, Bin3} ->
%% 											  inset_log(LogSrc, Sid, Uid, [Pearl]),
%% 											  inset(Player4, Type, Id, Idx, Equip2, Bin, <<Bin2/binary,Bin3/binary>>);
%% 										  {?error, ErrorCode} ->
%% 											  {?error, ErrorCode}
%% 									  end;
%% 								  {?false, Equip20} ->%% 无
%% 									  Equip2 = goods_api:score_equip(Equip20),
%% 									  inset_log(LogSrc, Sid, Uid, [Pearl]),
%% 									  inset(Player3, Type, Id, Idx, Equip2, Bin, <<Bin2/binary>>);
%% 								  {?error, ErrorCode} ->
%% 									  {?error, ErrorCode}
%% 							  end;
%% 						{?error, ErrorCode} ->
%% 							{?error, ErrorCode}
%% 					end;						
%% 				{?error, ErrorCode} ->
%% 					{?error, ErrorCode}
%% 			end;
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end.
%% 
%% inset(Player, Type, Id, Idx, Equip, Bin, BinMsg) ->
%% 	case make_set(Player, Equip, Type, Id, Idx, Bin) of
%% 		{?ok, Player2, Bin2} ->
%% 			LogSrc = [?MODULE, do_inset, [], <<"镶嵌灵珠">>],
%% 			Player3 = refresh_attr(Type, Id, Player2),
%% 			{?ok, Player3, <<Bin2/binary, BinMsg/binary>>};
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end.

%% 检查镶嵌物品是否满足条件 return : bool()
check_inset(#goods{type=Type, exts=Exts}, PearlType) ->
	case lists:member(Type, ?EQUIP_TYPE_LIST) of
		?true ->
			#g_eq{slots = Slots} = Exts,
			case lists:keyfind(PearlType,1,Slots) of
				{_,PearlId,PearlValue}->
					{?ok,PearlId,PearlValue};
				_->{?error, ?ERROR_MAKE_INET_NULL}
			end;
		_->
			{?error, ?ERROR_MAKE_INSET_BAN}
	end;
check_inset(_ , _) ->%% 不是灵珠
	{?error, ?ERROR_MAKE_INSET_BAN}.
%% 
%% 
%% %% 执行镶嵌操作 return: {?true, Equip, Pearl0} | {?false, Equip}
%% do_inset(#goods{exts = Exts} = Equip, #goods{type_sub = Typesub} = Pearl) ->
%% 	#g_eq{slots = Slots0} = Exts,
%% 	Slots = tuple_to_list(Slots0),	
%% 	case lists:keyfind(Typesub, #goods.type_sub, Slots) of
%% 		?false ->
%% 			case do_inset2(Slots0, Pearl) of
%% 				{?ok, Slots2} ->
%% 					Exts2 = Exts#g_eq{slots = Slots2},
%% 					{?false, Equip#goods{exts = Exts2}};
%% 				{?error, ErrorCode} ->
%% 					{?error, ErrorCode}
%% 			end;
%% 		Pearl0 ->
%% 			L = lists:keyreplace(Typesub, #goods.type_sub, Slots, Pearl),
%% 			Exts2 = Exts#g_eq{slots = list_to_tuple(L)},
%% 			{?true, Equip#goods{exts = Exts2}, Pearl0}
%% 	end.
%% 
%% do_inset2({}, _) ->
%% 	{?error, ?ERROR_MAKE_INET_NULL};
%% do_inset2(Slots, Pearl) ->
%% 	do_inset2(Slots, Pearl, erlang:tuple_size(Slots), 1).
%% 
%% do_inset2(Slots, Pearl, N, N) ->
%% 	case erlang:element(N, Slots) of
%% 		0 ->
%% 			Slots2 = erlang:setelement(N, Slots, Pearl),
%% 			{?ok, Slots2};
%% 		_ ->
%% 			{?error, ?ERROR_MAKE_INET_NULL}
%% 	end;
%% 
%% do_inset2(Slots, Pearl, Size, N) ->
%% 	case erlang:element(N, Slots) of
%% 		0 ->
%% 			Slots2 = erlang:setelement(N, Slots, Pearl),
%% 			{?ok, Slots2};
%% 		_ ->
%% 			do_inset2(Slots, Pearl, Size, N + 1)
%% 	end.
%% 
%% inset_log(LogSrc, Sid, Uid, GoodsList) ->
%% 	stat_api:logs_goods(Sid, Uid, ?CONST_TRUE, LogSrc, GoodsList).
%% 
%% 
%% 
%% %% 拆除灵珠 return: {?ok, Player, BinMsg} | {?error, ErrorCode}
%% remove(Player, Type, Id, Idx, PearlId) ->
%% 	case make_take(Player, Type, Id, Idx) of
%% 		{?ok, Player2, #goods{exts = Exts} = GoodsTake, Bin} ->
%% 			case is_record(Exts, g_eq) andalso is_tuple(Exts#g_eq.slots) of
%% 				?true ->
%% 					SlotsL = tuple_to_list(Exts#g_eq.slots),
%% 					case lists:keyfind(PearlId, #goods.goods_id, SlotsL) of
%% 						#goods{} = Pearl ->
%% 							SlotsL2 = lists:foldr(fun(#goods{goods_id=PearlId0},Acc)
%% 													   when PearlId == PearlId0 ->
%% 														  [0|Acc];
%% 													 (V,Acc) ->
%% 														  [V|Acc]
%% 												  end, [], SlotsL),
%% 							%% 							SlotsL2 = lists:keyreplace(PearlId, #goods.goods_id, SlotsL, 0),
%% 							Exts2 = Exts#g_eq{slots = list_to_tuple(SlotsL2)},
%% 							GoodsTake20 = GoodsTake#goods{exts = Exts2},
%% 							GoodsTake2 = goods_api:score_equip(GoodsTake20),
%% 							case make_set(Player2, GoodsTake2, Type, Id, Idx, Bin) of
%% 								{?ok, Player3, Bin2} ->
%% 									case goods_api:set([?MODULE,remove,[],<<"拆除灵珠">>],Player3, [Pearl]) of
%% 										{?ok, Player4, Bin3} ->
%% 											Player5 = refresh_attr(Type, Id, Player4),
%% 											{?ok, Player5, <<Bin2/binary,Bin3/binary>>};
%% 										{?error, ErrorCode} ->
%% 											{?error, ErrorCode}
%% 									end;
%% 								{?error, ErrorCode} ->
%% 									{?error, ErrorCode}
%% 							end;
%% 						?false ->%% 无此类型灵珠
%% 							{?error, ?ERROR_MAKE_PEARL_NULL}
%% 					end;
%% 				?false ->%% 不可拆除
%% 					{?error, ?ERROR_MAKE_TAKE_BAN}
%% 			end;
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end.
%% 
%% 
%% %% 分解法宝(可获得物品,每个物品有一个物品库,随机个数随机物品)
%% %% part(Player, Idx) -> {?ok, Player, Bin} | {?error, ErrorCode}
%% part(Player, TypeC, Id, Idx) ->
%% 	case make_take(Player, TypeC, Id, Idx) of
%% 		{?ok, Player2, Goods, Bin} ->
%% 			#goods{goods_id = GID,count = Count} = Goods,
%% 			case data_equip_make:get(GID) of
%% 				#d_equip_make{part1 = Part1, partc1 = Partc1, part2 = Part2, partc2 = Partc2} ->
%% 					case lists:foldl(fun({0,_Count0},Acc) ->
%% 											 Acc;
%% 										({ID,_Count0},Acc) ->
%% 											 [{ID,_Count0}|Acc]
%% 									 end, [], [{Part1,Partc1},{Part2,Partc2}]) of
%% 						[] ->% 不可分解
%% 							{?error, ?ERROR_MAKE_PART_BAN};
%% 						GidCountL ->
%% 							GoodsL = lists:foldl(fun({Gid,Num},Acc) ->
%% 														 case goods_api:goods(Gid) of
%% 															 #goods{} = Goods ->
%% 																 [Goods#goods{count=Num*Count}|Acc];
%% 															 _ ->
%% 																 Acc
%% 														 end
%% 												 end, [], GidCountL),
%% 							case goods_api:set([?MODULE,part,[],<<"分解">>],Player2, GoodsL) of
%% 								{?ok, Player3, Bin2} ->
%% 									Bin3 = make_api:msg_magic_part_ok(),
%% 									{?ok, Player3, <<Bin/binary, Bin2/binary, Bin3/binary>>};
%% 								{?error, ErrorCode} ->
%% 									{?error, ErrorCode}
%% 							end
%% 					end;
%% 				_ ->
%% 					{?error, ?ERROR_MAKE_PART_BAN} %% 物品不可分解
%% 			end;
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end.

make_enchant(Player,TypeC,Id,Idx,Arg)->
	Bag=role_api_dict:bag_get(),
	Equip=role_api_dict:equip_get(),
	Inn=role_api_dict:inn_get(),
	case make_take(Bag,Equip,Inn,TypeC, Id, Idx) of
		{?ok,Bag2,Equip2,Inn2,GoodsTake,Bin} ->
			#goods{type=Type,type_sub=TypeSub,exts=Exts}=GoodsTake,
			case lists:member(Type, ?EQUIP_TYPE_LIST) of
				?true->
					#g_eq{enchant=Enchant} = Exts,
					case data_equip_enchant:get(TypeSub,Enchant+1) of
						DataEnchant when is_record(DataEnchant,d_enchant)->
							case enchant(Player,Bag2,Equip2,Inn2,TypeC,Id,Idx,Arg,GoodsTake,DataEnchant,Bin) of
								{?ok,Player3,Bag3,Equip3,Inn3,Bin3}->
									role_api_dict:bag_set(Bag3),
									role_api_dict:equip_set(Equip3),
									role_api_dict:inn_set(Inn3),
									{?ok,Player3,Bin3};
								{?error,Erroe}->
									{?error,Erroe}
							end;
						_->
							{?error, ?ERROR_MAKE_STREN_BAN}
					end;
				_->
					{?error, ?ERROR_MAKE_STREN_BAN}
			end;
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.

enchant(Player,Bag,Equip,Inn,TypeC,Id,Idx,Arg,GoodsTake,DataEnchant,Bin)->
	#d_enchant{goods=GoodsId,odds=OddsList,money=Money,step_value=StepValue}=DataEnchant,
	case Arg of
		?CONST_TRUE->
			{Data,Count}=role_api_dict:make_get(),
			AData=util:date_Ymd(),
			MakeFM=?IF(Data=/=AData,{AData,1},{Data,Count+1}),
			Rmb=Count*2,
			case role_api:currency_cut([enchant,[],<<"金元附魔">>],Player,[{?CONST_CURRENCY_RMB_BIND,Rmb}]) of
				{?ok,Player2,GoldBin}->
					role_api_dict:make_set(MakeFM),
					[Bei|_]=util:odds_list_count(OddsList,1),
					Poin=10*Bei,
					enchant2(Player2,Bag,Equip,Inn,TypeC,Id,Idx,GoodsTake,DataEnchant,Poin,<<Bin/binary,GoldBin/binary>>);
				{?error,_Error}->
					{?error,?ERROR_RMB_LACK}
			end;
		_->
			[{_,BagGoodsCount}|_]=bag_api:get_goods_count([GoodsId]),
			#goods{exts=Exts}=GoodsTake,
			#g_eq{enchant_value=EnchantValue}=Exts,
			UseCount=StepValue-EnchantValue,
			Poin=?IF(BagGoodsCount>=UseCount,UseCount,BagGoodsCount),
			case role_api:currency_cut([enchant,[],<<"物品附魔">>], Player, [{?CONST_CURRENCY_GOLD,Money*Poin}]) of
				{?ok,Player2,MoneyBin}->
					case bag_api:goods_get([enchant,[],<<"物品附魔">>],Player2,Bag,[{GoodsId,Poin}]) of
						{?ok,Player3,Bag2,GoodsBin}->
							enchant2(Player3,Bag2,Equip,Inn,TypeC,Id,Idx,GoodsTake,DataEnchant,Poin,<<Bin/binary,MoneyBin/binary,GoodsBin/binary>>);
						{?error,Error}->
							{?error,Error}
					end;
				{?error,Error}->
					{?error,Error}
			end
	end.

enchant2(Player,Bag,Equip,Inn,TypeC,Id,Idx,GoodsTake,DataEnchant,Poin,Bin)->
	#goods{exts=Exts}=GoodsTake,
	#g_eq{enchant_value=EnchantValue}=Exts,
	#d_enchant{step_value=StepValue}=DataEnchant,
	{Flag,GoodsTake3}=case EnchantValue+Poin >= StepValue of
						  ?true->
							  Exts2=Exts#g_eq{enchant=Exts#g_eq.enchant+1,enchant_value=EnchantValue+Poin-StepValue},
							  GoodsTake2=GoodsTake#goods{exts=Exts2},
							  {?true,GoodsTake2};
						  _->
							  Exts2=Exts#g_eq{enchant_value=EnchantValue+Poin},
							  GoodsTake2=GoodsTake#goods{exts=Exts2},
							  {?false,GoodsTake2}
					  end,
	case make_set(Bag,Equip,Inn,GoodsTake3,TypeC, Id, Idx, Bin) of
		{?ok,Bag2,Equip2,Inn2,Bin0}->
			Bin2 = 
				case find_stren_pos(Bag2,Equip2,Inn2,TypeC,Id,GoodsTake3) of
					{?true, Index} ->%% 在背包中
						make_api:msg_enchant_ok(?CONST_GOODS_CONTAINER_BAG,0,Index);
					?false ->% 在原来的地方
						make_api:msg_enchant_ok(?CONST_GOODS_CONTAINER_EQUIP,Id,Idx)
				end,
			case Flag of
				?true->
					{?ok,Player3,Equip3,Inn3}=refresh_attr(Equip2,Inn2,TypeC,Id,Player);
				_->
					Player3=Player,
					Equip3 =Equip2,
					Inn3   =Inn2,
					{?ok,Player3,Equip3,Inn3}
			end,
			{?ok, Player3,Bag2,Equip3,Inn3,<<Bin0/binary,Bin2/binary>>};
		{?error, ErrorCode}->
			{?error, ErrorCode}
	end.


%% Local Functions
%% 装备刷新人物属性
%% return : {?ok,Player,Equip,Inn}
refresh_attr(Equip,Inn,TypeC,Id,Player) ->
	case TypeC of
		?CONST_GOODS_CONTAINER_EQUIP ->
			case Id of
				0 ->
					Player2=bag_api:player_attr_calc(Player,Equip),
					{?ok,Player2,Equip,Inn};
				_ ->
					#player{socket = Socket} = Player,
					case lists:keytake(Id, #partner.partner_id, Inn#inn.partners) of
						{value, Partner, Partners} ->
							Partner2 = bag_api:partner_attr_calc(Socket, Partner),
							Inn2 = Inn#inn{partners = [Partner2|Partners]},
							{?ok,Player,Equip,Inn2};
						?false ->
							{?ok,Player,Equip,Inn}
					end
			end;
		_ ->
			{?ok,Player,Equip,Inn}
	end.






