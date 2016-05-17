%% Author  : mirahs
%% Created: 2012-6-20
%% Description: TODO: Add description to team_api
-module(magic_equip_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 protect_get_rmb/1,
		 enhanced/7,
		 bless_get/3,
		 advance/5,
		 need_rmb/4,
		 need_rmb_msg/4,
		 make_take/6,
		 make_take2/6,
		 mall_get/1,
		 advanced_up/3,
		 bless_gailv/1,
		 equip_make_get/1,
		 find_stren_pos/6,
		 find_stren_pos2/2,
		 jinjie/10,
		 equip_make_get2/1,
		 make_set/8,
		 make_set/9,
		 protect_get/3,
		 refresh_attr/5,
		 stren/15,
		 stren_goods_odds/3,
		 stren_goods_odds/6,
		 stren_lose/4,
		 stren_up/4,
		 goods_get_goods_id/1,
		 
		 ask_next_attr/4,
		 
		 msg_stren_max/0,
		 msg_enhanced_reply/4,
		 msg_need_money_reply/3,
		 msg_attr_reply/6,
		 msg_msg_item_xxx/2,
		 msg_attr/2
		]).

need_rmb(Type,TypeC,Id, Idx) ->
	Bag= role_api_dict:bag_get(),
	Equip = role_api_dict:equip_get(),
	Inn = role_api_dict:inn_get(),
	case make_take2(Bag, Equip, Inn, TypeC, Id, Idx) of
		{?ok, Goods} ->
			?MSG_ECHO("----------------------~n",[]),
			#goods{class=Class,type_sub=TypeSub,name_color=Color,type = Type2 ,exts = Exts} = Goods,
			#g_eq{streng = Lv} = Exts,  %% 强化等级
			?MSG_ECHO("----------------------------~w~n",[{Lv,Color,Type2,TypeSub,Class}]),
			case make_api:data_stren_get(Lv+1, Color, Type2, TypeSub, Class) of
				DataStren when is_record(DataStren, d_equip_stren) ->
					#d_equip_stren{item1 = Item1, count1 = Count1, rep_t1 = Rep1} = DataStren,
					case Type =:= 1 of 
						?true ->
							Count4 = bag_api:goods_id_count_get(Item1),
							Count= ?IF(Count4<Count1,Count4-Count1,0),
							{0,0,Count * Rep1};
						_ ->
							Count4 = bag_api:goods_id_count_get(Item1),
							Count= ?IF(Count4<Count1,Count1-Count4,0),
							NeedRmb1 = Count * Rep1,
							GetRmb1 = mall_get(42),
							BlessId = ?CONST_MAGIC_EQUIP_STORY_STONE_ID,
							Count5 = bag_api:goods_id_count_get(BlessId),
							Count6 = ?IF(Count5>0,0,1),
							NeedRmb2 = Count6 * GetRmb1,
							case Lv >= 7 of
								?true ->
									{GetRmb2,ProtectId}=protect_get_rmb(Class),
									Count7 = bag_api:goods_id_count_get(ProtectId),
									Count8 = ?IF(Count7>0,0,1),
									NeedRmb3 = Count8 * GetRmb2;
								_ ->
									NeedRmb3 = 0
							end,
							{NeedRmb2,NeedRmb3,NeedRmb1+NeedRmb2+NeedRmb3}
					end;
				_ ->
					{0,0,0}
			end;
		_ ->
			{0,0,0}
	end.

need_rmb_msg(Type, TypeC, Id, Idx) ->
	{Rmb1,Rmb2,Rmb3}= need_rmb(Type, TypeC, Id, Idx),
	msg_need_money_reply(Rmb1,Rmb2,Rmb3).


%% Type (强化还是一键强化) TypeC 容器类型(背包还是在武将身上) Id 武将id MagicIdx 神器idx Bless 祝福石 Protection 保护石
enhanced(Player, Type, TypeC, Id, MagicIdx, BlessId, ProtectId) ->
	Bag= role_api_dict:bag_get(),
	Equip= role_api_dict:equip_get(),
	Inn= role_api_dict:inn_get(),
	case make_take(Bag,Equip,Inn,TypeC, Id, MagicIdx) of
		{?ok,Bag2,Equip2,Inn2,GoodsTake,Bin} ->
			#goods{name_color=Color,class=Class,type=Type2,type_sub=Typesub,exts=Exts}=GoodsTake,
			case lists:member(Type2, ?EQUIP_TYPE_LIST) of
				?true->
					#g_eq{streng = StrenLv} = Exts,
					case make_api:data_stren_get(StrenLv + 1, Color, Type2, Typesub, Class) of
						DataStren when is_record(DataStren, d_equip_stren) ->
							case stren(Player, Bag2, Equip2, Inn2, Type, TypeC, Id, MagicIdx, GoodsTake, DataStren,BlessId,ProtectId,StrenLv + 1,Class, Bin) of
								{?ok,Player4,Bag4,Equip4,Inn4,Bin2}->
									role_api_dict:bag_set(Bag4),
									role_api_dict:equip_set(Equip4),
									role_api_dict:inn_set(Inn4),
									{?ok,Player4,Bin2};
								{?error,Erroe}->
									{?error,Erroe}
							end;
						_ ->% 无数据,不可强化
							{?error, ?ERROR_MAKE_STREN_BAN}
					end;
				
				_->
					{?error, ?ERROR_MAKE_STREN_BAN}
			end;
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.

advance(Player, TypeC, Id, Idx, _HolyWaterId) ->
	Bag= role_api_dict:bag_get(),
	Equip= role_api_dict:equip_get(),
	Inn= role_api_dict:inn_get(),
	case make_take(Bag,Equip,Inn,TypeC, Id, Idx) of
		{?ok,Bag2,Equip2,Inn2,Goods1,Bin} ->
			#goods{goods_id= GoodsId,name_color=Color,class=Class,type=Type2,type_sub=Typesub,exts=Exts}=Goods1,
			case lists:member(Type2, ?EQUIP_TYPE_LIST) of
				?true->
					#g_eq{streng = StrenLv } = Exts,
					case StrenLv >= ?CONST_MAGIC_EQUIP_STRENGTHEN_LV of 
						?true ->
							{HolyWaterId,Count1,Ct,Rmb}= equip_make_get2(GoodsId),
							GoodsList0=[{HolyWaterId,Count1}],
							%% 消耗圣水 							
							case bag_api:goods_get([advanced,[],<<"神器进阶">>], Player, Bag2, GoodsList0) of
								{?ok,Player2,Bag3,Bin2}->
									case role_api:currency_cut([advance, [], <<"神器进阶消耗">>], Player2, [{Ct, Rmb}]) of
										{?ok,Player3,RmbBin} ->
											case make_api:data_stren_get(StrenLv -?CONST_MAGIC_EQUIP_LV_DOWN, Color+1, Type2, Typesub, Class+1) of
												DataStren when is_record(DataStren, d_equip_stren)->
													Bin3 = <<Bin/binary,RmbBin/binary,Bin2/binary>>,
													case jinjie(Player3, Bag3, Equip2,Inn2 , TypeC, Id, Idx, Goods1, DataStren, Bin3) of
														{?ok,Player4,Bag4,Equip4,Inn4,Bin4}->
															role_api_dict:bag_set(Bag4),
															role_api_dict:equip_set(Equip4),
															role_api_dict:inn_set(Inn4),
															{?ok,Player4,Bin4};
														{?error,Erroe}->
															{?error,Erroe}
													end;
												_ ->% 无数据,不可强化
													{?error, ?ERROR_MAKE_STREN_BAN}
											end;
										{?error,Error}->
											{?error,Error}
									end;
								{?error,Error}->
									{?error,Error}
							end;
						_ ->
							{?error, ?ERROR_MAGIC_EQUIP_LACK_LV}  %% 不够等级
					end;
				_->
					{?error, ?ERROR_MAKE_STREN_BAN}
			end;
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.

ask_next_attr(TypeSub, Lv, Color, Class)->
	case data_equip_stren:get(TypeSub, Lv+1, Color, Class) of
		#d_equip_stren{attr=Attr,odds=Odds,money=Money,
					   item1		= Item1, 
					   count1       = Count1,              
					   item2        = Item2,   
					   count2       = Count2, 
					   item3        = Item3,   
					   count3       = Count3} ->
			Item =[{Item1,Count1},{Item2,Count2},{Item3,Count3}],
			Item0= [R||R<-Item,R=/={0,0}],
			[_|AttrList]=tuple_to_list(Attr),
			F=fun(AttrValue,{Indxs,Idx})->
					  ?IF(AttrValue==0,{Indxs,Idx+1},{[Idx|Indxs],Idx+1})
			  end,
			{Indxs2,_}=lists:foldl(F,{[],1},AttrList),
			AttrTypeIdxS=[lists:nth(AttrIdx,?ATTR_TYPE_POS)||AttrIdx<-Indxs2],
			L=[{AttrType,element(NAttrIdx,Attr)}||{AttrType,NAttrIdx}<-AttrTypeIdxS],
			Fun1= fun({Type, TypeValue},Acc) ->
						  AttrAcc= msg_attr(Type, TypeValue),
						  <<AttrAcc/binary,Acc/binary>>
				  end,
			AttrList2= lists:foldl(Fun1, <<>>,L),	
			
			Fun2=fun({I1,C1},Acc2) ->
						 ItemAcc= msg_msg_item_xxx(I1, C1),
						 <<ItemAcc/binary,Acc2/binary>>
				 end,
			ItemList= lists:foldl(Fun2, <<>>, Item0),
			
			?MSG_ECHO("==================~w~n",[{Money, Odds,length(L),length(Item0)}]),
			msg_attr_reply(Money, Odds,length(L), AttrList2,length(Item0), ItemList);
		_ ->
			msg_stren_max()
	end.

%% 开始进阶
jinjie(Player,Bag,Equip,Inn,TypeC, Id, Idx, Goods, _DataStren, Bin) ->
	case stren_goods_odds(Player, Bag, Goods) of
		{Flag,Player3,Bag3,GoodsBin,GoodsStren} ->
			?MSG_ECHO("--------------------~n",[]),
			case make_set(Player3, Bag3,Equip,Inn,GoodsStren,TypeC, Id, Idx, Bin) of
				{?ok,Player4,Bag4,Equip2,Inn2,Bin0}->
					Bin3 = 
						case find_stren_pos(Bag4,Equip2,Inn2,TypeC,Id,GoodsStren) of
							{?true, Index} ->%% 在背包中
								?MSG_ECHO("-----------~w~n",[index]),
								msg_enhanced_reply(Flag,?CONST_GOODS_CONTAINER_BAG,0,Index);
							?false ->% 在原来的地方
								?MSG_ECHO("-----------~w~n",[index]),
								msg_enhanced_reply(Flag,?CONST_GOODS_CONTAINER_BAG,Id,Idx)
						end,
					{?ok,Player5,Equip4,Inn4} = refresh_attr(Equip2,Inn2,TypeC,Id,Player4),
					{?ok, Player5,Bag4,Equip4,Inn4, <<Bin0/binary,Bin3/binary,GoodsBin/binary>>};
				{?error, ErrorCode11}->
					{?error, ErrorCode11}
			end;
		{?error, ErrorCode}->
			{?error, ErrorCode}
	end.

%% 开始强化
stren(Player,Bag,Equip,Inn, Type, TypeC, Id, Idx,  GoodsTake, DataStren, BlessId, ProtectId, Lv, Class, Bin) ->
	#d_equip_stren{odds=Odds,money = Money, item1 = Item1, count1 = Count1, rep_t1 = Rep1} = DataStren,
	Count4 = bag_api:goods_id_count_get(Item1),
	Count= ?IF(Count4<Count1,Count1-Count4,0),
	NeedRmb1 = Count * Rep1,
	NewCount = Count1 -Count,
	case NewCount =:= 0 of 
		?true ->
			GoodsList1 = [];
		_ ->
			GoodsList1 = [{Item1,NewCount}]
	end,
	case role_api:currency_cut([stren, [], <<"神器强化">>], Player, [{?CONST_CURRENCY_GOLD, Money}]) of
		{?ok,Player2,GoldBin} ->
			case bag_api:goods_get([stren,[],<<"神器强化">>], Player2, Bag, GoodsList1) of
				{?ok,Player3, Bag2, Bin2} ->
					{IsGoods2, IsProtect, Player4, NeedRmb2, AddOdds, NewBag2, NewBin2} = get_rmb(Type, Player3, Bag2, BlessId, ProtectId, Class, Lv, Bin2),
					NeedRmb3= NeedRmb1 + NeedRmb2,
					case role_api:currency_cut([stren, [], <<"神器强化">>], Player4, [{?CONST_CURRENCY_RMB, NeedRmb3}]) of
						{?ok,Player6,RmbBin} ->
							case stren_goods_odds(Odds + AddOdds, Player6, NewBag2, GoodsTake,IsProtect,IsGoods2) of
								{Flag,Player7,Bag3,GoodsBin,GoodsStren} ->
									?MSG_ECHO("----------------------~w~n",[{Odds,AddOdds}]),
									case make_set(Player7,Bag3,Equip,Inn,GoodsStren,TypeC, Id, Idx, <<>>) of
										{?ok,Player8,Bag4,Equip2,Inn2,Bin3}->
											Bin4 = 
												case find_stren_pos(Bag4,Equip2,Inn2,TypeC,Id,GoodsStren) of
													{?true, Index} ->%% 在背包中
														?MSG_ECHO("-----------~w~n",[index]),
														msg_enhanced_reply(Flag,?CONST_GOODS_CONTAINER_BAG,0,Index);
													?false ->% 在原来的地方
														msg_enhanced_reply(Flag,?CONST_GOODS_CONTAINER_EQUIP,Id,Idx)
												end,
											{?ok,Player9,Equip4,Inn4} = refresh_attr(Equip2,Inn2,TypeC,Id,Player8),
											Bin6 = case make_api:stren_ask(GoodsStren) of
													   {?ok, Bin5} ->
														   Bin5;
													   {?error, _} ->
														   <<>>
												   end,
											{?ok, Player9,Bag4,Equip4,Inn4, <<GoldBin/binary,Bin/binary,NewBin2/binary,GoodsBin/binary,Bin3/binary,Bin4/binary,Bin6/binary,RmbBin/binary>>};
										{?error, ErrorCode11}->
											{?error, ErrorCode11}
									end;
								{?error, ErrorCode}->
									{?error, ErrorCode}
							end;
						{?error,ErrorCode} ->
							
							{?error, ErrorCode}
					end;
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		_ ->
			{?error,?ERROR_GOLD_LACK}
	end.



stren_goods_odds(Player,Bag,Goods)->
	case advanced_up(Player,Bag,Goods) of
		{Player2,Bag2,Bin,Goods2}->
			GoodsStren  = make_api:price_stren(Goods2),
			{?CONST_TRUE,Player2,Bag2,Bin,GoodsStren};
		{?error,Error}->{?error,Error}
	end.

stren_goods_odds(Odds,#player{uid= Uid}= Player,Bag,GoodsTake, IsProtect,IsGoods)->
	Odds2 = ?IF(Odds>?CONST_PERCENT,?CONST_PERCENT,Odds),
	?MSG_ECHO("----------------~w~n",[{Odds,Odds2}]),
	case util:rand_odds(Odds2, ?CONST_PERCENT) of
		?true->
			case stren_up(Player,Bag,GoodsTake,IsGoods) of
				{Player2,Bag2,Bin,GoodsStren0}->
					GoodsStren  = make_api:price_stren(GoodsStren0),
					{?CONST_TRUE,Player2,Bag2,Bin,GoodsStren};
				{?error,Error}->{?error,Error}
			end;
		_->
			GoodsStren0=stren_lose(Uid, GoodsTake,IsProtect,IsGoods),
			GoodsStren = make_api:price_stren(GoodsStren0),
			{?CONST_FALSE,Player,Bag,<<>>,GoodsStren}
	end.

%% 强化升级
%% return: Goods
stren_up(#player{uid= Uid}= Player,Bag,#goods{goods_id=GoodsId,name_color = Color, type = Type, type_sub = Typesub, class = Class, exts = Exts} = Goods,IsGoods) ->
	#g_eq{streng = Lv0} = Exts,
	StrenLv = Lv0 + 1,
	case make_api:data_stren_get(StrenLv, Color, Type, Typesub, Class) of
		#d_equip_stren{attr = Attr} ->
			stat_api:logs_magic(Uid, GoodsId, Lv0, StrenLv, ?CONST_TRUE, IsGoods),
			Exts2=Exts#g_eq{streng = StrenLv, streng_v = Attr},
			Goods2=Goods#goods{exts=Exts2},
			{Player,Bag,<<>>,Goods2};
		_ ->
			{Player,Bag,<<>>,Goods}
	end.

%% 进阶升级
%% return: Goods
advanced_up(#player{uid=Uid,uname=Name,lv=Lv,uname_color=NameColor,pro= Pro}= Player,Bag,#goods{goods_id=GoodsId0,name_color =Color0,type =Type,type_sub=Typesub,class= Class0, exts= Exts} = Goods) ->
	#g_eq{streng = Lv0} = Exts,
	StrenLv = Lv0 - ?CONST_MAGIC_EQUIP_LV_DOWN,  %% 降三级
	Class = Class0 +1,
	Color = Color0 +1,
	GoodsId = equip_make_get(GoodsId0),
	broadcast(Uid, Name, Lv, NameColor, Pro, Color, Goods),
	case make_api:data_stren_get(StrenLv, Color, Type, Typesub, Class) of
		#d_equip_stren{attr = Attr} ->
			stat_api:logs_magic_step(Uid, GoodsId0, GoodsId, Lv0, StrenLv),
			NewGoods=bag_api:goods(GoodsId),
			NewExts	=NewGoods#goods.exts,
			NewExts2=NewExts#g_eq{streng = StrenLv, streng_v = Attr},
			NewGoods2=NewGoods#goods{exts=NewExts2},
			{Player,Bag,<<>>,NewGoods2};
		_ ->
			{Player,Bag,<<>>,Goods}
	end.

broadcast(Uid,Name,Lv,NameColor,Pro,Color, Goods) ->
	case Color >= 4 of
		?true ->
			Bin= broadcast_api:msg_broadcast_magic({Uid,Name,Lv,NameColor,Pro}, Goods),
			chat_api:send_to_all(Bin);
		_ ->
			?skip
	end.

%% 强化失败
stren_lose(Uid, Goods=#goods{goods_id = MagicId, name_color = Color, type = Type, type_sub = Typesub, class = Class, exts = Exts},IsProtect,IsGoods)->
	#g_eq{streng = StrenLv} = Exts,
	case IsProtect =:= ?CONST_TRUE of
		?true ->
			stat_api:logs_magic(Uid, MagicId, StrenLv, StrenLv, ?CONST_FALSE, ?CONST_TRUE),
			Goods;
		_ ->
			case make_api:data_stren_get(StrenLv, Color, Type, Typesub, Class) of
				#d_equip_stren{lose_lv=LoseLv} ->
					case make_api:data_stren_get(LoseLv, Color, Type, Typesub, Class) of 
						#d_equip_stren{attr=Attr}->
							stat_api:logs_magic(Uid, MagicId, StrenLv, LoseLv, ?CONST_FALSE, IsGoods),
							Exts2=Exts#g_eq{streng =LoseLv,streng_v = Attr},
							Goods#goods{exts=Exts2};
						_->
							Goods
					end;
				_->
					Goods
			end
	end.


%% 拿到idx装备（不取出）
%% return: {?ok, Bag,Equip,Inn,GoodsTake, Bin} | {?error, ErrorCode}
make_take2(Bag,Equip,Inn,Type, Id, Idx) ->
	case Type of
		?CONST_GOODS_CONTAINER_BAG ->%% 打造背包装备
			case bag_api:read(Bag, Idx) of
				{?true, Goods}->
					{?ok,Goods};
				{?error,Error}->
					{?error,Error}
			end;
		?CONST_GOODS_CONTAINER_EQUIP ->%% 打造装备栏装备
			case Id of 
				0 -> % 主将
					case lists:keytake(Idx, #goods.idx, Equip) of
						{value, #goods{} = GoodsTake, _Equip1} ->
%% 							Bin = bag_api:msg_remove(?CONST_GOODS_CONTAINER_EQUIP, 0, [Idx]),
							{?ok,GoodsTake};
						?false ->
							{?error, ?ERROR_GOODS_NOT_EXIST}
					end;
				_ ->
					#inn{partners = Partners} = Inn,
					case lists:keytake(Id, #partner.partner_id, Partners) of
						{value, #partner{equip = EquipP}, _Partners2} ->
							case lists:keytake(Idx, #goods.idx, EquipP) of
								{value, #goods{} = GoodsTake, _EquipP2} ->
%% 									Bin = bag_api:msg_remove(?CONST_GOODS_CONTAINER_EQUIP, Id, [Idx]),
%% 									Inn2 = Inn#inn{partners = [Partner#partner{equip = EquipP2}|Partners2]},
									{?ok,GoodsTake};
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
			


%% 取出idx装备
%% return: {?ok, Bag,Equip,Inn,GoodsTake, Bin} | {?error, ErrorCode}
make_take(Bag,Equip,Inn,Type, Id, Idx) ->
	case Type of
		?CONST_GOODS_CONTAINER_BAG ->%% 打造背包装备
			case bag_api:goods_get_idx(Bag,Idx,1,?CONST_FALSE) of
				{?ok,Bag2,Goods,Bin}->
					{?ok,Bag2,Equip,Inn,Goods,Bin};
				{?error,Error}->
					?MSG_ECHO("==========================~w~n",[Idx]),
					{?error,Error}
			end;
		?CONST_GOODS_CONTAINER_EQUIP ->%% 打造装备栏装备
			case Id of 
				0 -> % 主将
					case lists:keytake(Idx, #goods.idx, Equip) of
						{value, #goods{} = GoodsTake, Equip2} ->
							?MSG_ECHO("------------------~w~n",[GoodsTake]),
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
make_set(Player,Bag,Equip,Inn,GoodsMake0, Type, Id, Idx) ->
	make_set(Player,Bag,Equip,Inn,GoodsMake0, Type, Id, Idx, <<>>).

make_set(Player,Bag,Equip,Inn,GoodsMake0, Type, Id, Idx, Bin0) ->
	case Type of
		?CONST_GOODS_CONTAINER_BAG ->%% 打造背包装备
%% 			(Bag, [GoodsMake#goods{idx = Idx}])
			{?ok,Player2,Bag2,GoodsBin,_Bin}=bag_api:goods_set([stren,[],<<"神器强化">>], Player, Bag, [GoodsMake0]),
%% 			?MSG_ECHO("========================= ~w~n",[Bin]),
			{?ok,Player2,Bag2,Equip,Inn,<<Bin0/binary,GoodsBin/binary>>};
		?CONST_GOODS_CONTAINER_EQUIP ->%% 打造装备栏装备
			case Id of
				0 ->
					Equip2 = [GoodsMake0|lists:keydelete(Idx, #goods.idx, Equip)],
					Bin = bag_api:msg_change(?CONST_GOODS_CONTAINER_EQUIP, Id, [GoodsMake0]),
					{?ok,Player,Bag,Equip2,Inn,<<Bin0/binary,Bin/binary>>};
				_ ->% 伙伴身上
					case lists:keytake(Id, #partner.partner_id, Inn#inn.partners) of
						{value, #partner{equip = EquipP}=Partner,Partners} ->
							EquipP2 = [GoodsMake0|lists:keydelete(Idx, #goods.idx, EquipP)],
							Partner2 = Partner#partner{equip = EquipP2},
							Inn2 = Inn#inn{partners = [Partner2|Partners]},
							Bin = bag_api:msg_change(?CONST_GOODS_CONTAINER_EQUIP, Id, [GoodsMake0]),
							{?ok, Player,Bag,Equip, Inn2, <<Bin0/binary,Bin/binary>>};
						?false ->
							{?error, ?ERROR_INN_NO_PARTNER}
					end
			end
	end.


bless_get(Id, Player,Bag)->
	case Id =/= 0 of
		?true ->
			GoodsList0 = [{Id,1}],
			?MSG_ECHO("----------------------~w~n",[GoodsList0]),
			case bag_api:goods_get([bless_get,[],<<"神器强化">>], Player, Bag, GoodsList0) of
				{?ok,Player,NewBag,Bin} ->
					{?ok,NewBag,Bin};
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		_ ->
			?MSG_ECHO("----------------------~w~n",[Id]),
			{?error,?skip}
	end.


bless_gailv(GoodsId) ->
	Odds= goods_get_goods_id(GoodsId),
	?MSG_ECHO("----------------------~w~n",[{GoodsId, Odds}]),
	Odds.

protect_get(Id, Player,Bag) ->
	case Id =/= 0 of
		?true ->
			GoodsList0 = [{Id,1}],
			?MSG_ECHO("----------------------~w~n",[GoodsList0]),
			case bag_api:goods_get([protect,[],<<"神器强化">>], Player, Bag, GoodsList0) of
				{?ok,Player,NewBag,Bin} ->
					{?ok,NewBag,Bin};
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		_ ->
			{?error,?skip}
	end.

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
					{?ok,Player,Equip,Inn}
			end;
		_ ->
			{?ok,Player,Equip,Inn}
	end.

equip_make_get(Id) ->
	case data_equip_make:get(Id) of
		#d_equip_make{make1 = Make1} ->
			#d_make{goods = GoodsId} = Make1,
			GoodsId;
		_ ->
			0
	end.

equip_make_get2(Id) ->
	case data_equip_make:get(Id) of
		#d_equip_make{make1 = Make1} ->
			#d_make{item1 = Item1,count1 = Count1,ct=Ct, cv=Rmb} = Make1,
			?MSG_ECHO("----------------------~w~n",[{Id,Item1,Count1,Rmb}]),
			{Item1,Count1,Ct, Rmb};
		_ ->
			?MSG_ECHO("----------------------~w~n",[Id]),
			{0,0,0,0}
	end.

goods_get_goods_id(GoodsId) ->
	case data_goods:get(GoodsId) of
		#goods{exts = Exts} ->
			#g_none{as1 = Odds} = Exts,
			Odds;
		_ ->
			0
	end.


mall_get(Id) ->
	case data_mall:data(Id) of
		#d_mall_goods{s_price = Price}  ->
			?MSG_ECHO("-----------------~w~n",[{Id,Price}]),
			Price;
		_ ->
			0
	end.

protect_get_rmb(Class) ->
	if 
		Class =:= ?CONST_MAGIC_EQUIP_CLASS_STEP1 ->
			GetRmb2 = mall_get(?CONST_MAGIC_EQUIP_STEP1_MALL_ID),
			ProtectId0 = ?CONST_MAGIC_EQUIP_PRIMARY_PROTECT;
		Class =:= ?CONST_MAGIC_EQUIP_CLASS_STEP2 ->
			GetRmb2 = mall_get(?CONST_MAGIC_EQUIP_STEP2_MALL_ID),
			ProtectId0 = ?CONST_MAGIC_EQUIP_MIDDLE_PROTECT;
		Class =:= ?CONST_MAGIC_EQUIP_CLASS_STEP3 ->
			GetRmb2 = mall_get(?CONST_MAGIC_EQUIP_STEP3_MALL_ID),
			ProtectId0 = ?CONST_MAGIC_EQUIP_SENTOR_PROTECT;
		Class =:= ?CONST_MAGIC_EQUIP_CLASS_STEP4 ->
			GetRmb2 = mall_get(?CONST_MAGIC_EQUIP_STEP4_MALL_ID),
			ProtectId0 = ?CONST_MAGIC_EQUIP_EPIC_PROTECT;
		Class =:= ?CONST_MAGIC_EQUIP_CLASS_STEP5 ->
			GetRmb2 = mall_get(?CONST_MAGIC_EQUIP_STEP5_MALL_ID),
			ProtectId0 = ?CONST_MAGIC_EQUIP_STORY_PROTECT;
		?true ->
			GetRmb2 = 0,
			ProtectId0 =0
	end,
	{GetRmb2,ProtectId0}.

get_rmb(Type,Player, Bag, BlessId, ProtectId, Class, Lv, Bin) ->
	case Type =:= 1 of  
		?true ->
			{IsGoods1, NewBag, AddOdds, NewBin} = 
				case bless_get(BlessId,Player, Bag) of  %% 	祝福石  提升概率		
					{?ok,  Bag2, Bin1} ->
						{?CONST_TRUE, Bag2, bless_gailv(BlessId), <<Bin/binary,Bin1/binary>>};
					_ ->
						{?CONST_FALSE, Bag, 0, Bin}
				end,
			{IsGoods2, NewBag2, IsProtect, NewBin2} = 
				case protect_get(ProtectId, Player, NewBag) of %% 	保护石 保护不掉级		
					{?ok,Bag3,Bin2} ->
						{?CONST_TRUE, Bag3, ?CONST_TRUE, <<NewBin/binary,Bin2/binary>>};
					_ ->
						{IsGoods1, NewBag, ?CONST_FALSE, NewBin}
				end,
			{IsGoods2, IsProtect, Player, 0, AddOdds, NewBag2, NewBin2};
		_ ->
			GetRmb1 = mall_get(42),
			Count1 = bag_api:goods_id_count_get(?CONST_MAGIC_EQUIP_STORY_STONE_ID),
			Count2 = ?IF(Count1 > 0,0,1),
			GoodsList2 = ?IF(Count1 > 0,[{?CONST_MAGIC_EQUIP_STORY_STONE_ID, 1}],[]),
			NeedRmb2 = Count2 * GetRmb1,
			{GoodsList3, NeedRmb3}= 
				case Lv >= 7 of
					?true ->
						{GetRmb2,ProtectId0} = protect_get_rmb(Class),
						Count3 = bag_api:goods_id_count_get(ProtectId0),
						case Count3 > 0 of 
							?true ->
								{[{ProtectId0,1}|GoodsList2], 0};
							_ ->
								{GoodsList2, GetRmb2}
						end;
					_ ->
						{GoodsList2, 0}
				end,
			?MSG_ECHO("----------------------~w~n",[GoodsList3]),
			{Player3, NewBag2, NewBin2}= 
				case GoodsList3 =/= [] of
					?true ->
						case bag_api:goods_get([stren,[],<<"神器强化">>], Player, Bag, GoodsList3) of
							{?ok,Player2,NewBag1, Bin2} ->
								{Player2,NewBag1,Bin2};
							_ ->
								{Player,Bag,Bin}
						end;
					_ ->
						{Player,Bag,Bin}
				end,
			{?CONST_TRUE, ?CONST_TRUE, Player3, NeedRmb2+NeedRmb3, ?CONST_MAGIC_EQUIP_STORY_STONE, NewBag2, NewBin2}
	end.

% 不可强化或已达最高级 [2519]
msg_stren_max()->
    app_msg:msg(?P_MAKE_STREN_MAX,<<>>).

% 强化返回 [52240]
msg_enhanced_reply(Flag,TypeC,Id, Idx)->
    RsList = app_msg:encode([{?int8u,Flag},{?int8u,TypeC},{?int32u,Id},{?int16u,Idx}]),
    app_msg:msg(?P_MAGIC_EQUIP_ENHANCED_REPLY, RsList).

% 神器强化所需要钱数返回 [52260]
msg_need_money_reply(BlessRmb,ProtectRmb,TotalRmb)->
    RsList = app_msg:encode([{?int16u,BlessRmb},{?int16u,ProtectRmb},{?int16u,TotalRmb}]),
    app_msg:msg(?P_MAGIC_EQUIP_NEED_MONEY_REPLY, RsList).

% 属性返回 [52310]
msg_attr_reply(Money,Odds,Length1,RsList1,Length2,RsList2)->
    RsList = app_msg:encode([{?int32u,Money},{?int16u,Odds}]),
	Length3= app_msg:encode([{?int8u, Length1}]),
	Length4= app_msg:encode([{?int8u, Length2}]),
    app_msg:msg(?P_MAGIC_EQUIP_ATTR_REPLY, <<RsList/binary,Length3/binary,RsList1/binary,Length4/binary,RsList2/binary>>).

% 材料信息块 [52315]
msg_msg_item_xxx(ItemId,Count)->
    app_msg:encode([{?int16u,ItemId},{?int16u,Count}]).

% 属性值 [52320]
msg_attr(Type,TypeValue)->
    app_msg:encode([{?int16u,Type}, {?int16u,TypeValue}]).



