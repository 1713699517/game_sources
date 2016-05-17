%% Author: youxi
%% Created: 2012-10-10
%% Description: TODO: Add description to goods_api
-module(bag_api).

%%
%% Include files
%%
-include("comm.hrl").

%%
%% Exported Functions 
%%
-export([encode_bag/1,
		 decode_bag/1,
		 
		 encode_equip/1,
		 decode_equip/1,
		 
		 encode_times_goods/1,
		 decode_times_goods/1,
		 
		 encode_once_goods/1,
		 decode_once_goods/1,
		 
		 init_bag/1,
		 init_equip/1,
		 init_equip/2,
		 bag_max/2,
		 bag_max_updata/1,
		 goods_set/3,
		 goods_set/4,
		 goods_get/4,
		 goods_get_idx/4,
		 
		 goods_id_count_get/1,
		 remove/2,
		 enlargh/1,
		 enlargh_vip/2,
		 
		 clear_up/1,
		 
		 check_bag/0,
		 check_bag/2,
		 check_bag_goods/1,
		 
		 activity_state_give/1,
		 activity_state_init/0,
		 
		 magic_check/4,
		 
		 goods_to_give/1,
		 
		 goods_list/2,
		 goods/1,
		 goods_use/5,
		 goods_use/6,
		
		 get_temp/2,
		 take_filter/2,
		 take_filter/3,
		 take/2,
		 take/3,
		 take2/3,
		 take2/4,
		 read/2,
		 get_goods_count/1,
		 goods_virtual/4,
		 
%% 		 equip_list/3,
		 
		 equip_on/6,
		 equip_off/6,
		 equip_ask/3,
		 equip_ask_cb/2,
		 check_full/1,
		 
		 get_eq_id/1,
		 get_weapon/1,
		 
		 one2list/1,
		 
		 sell/3,
		 decode_sell/1,
		 
		 score_equip/1,
		 score_attr/1,
		 ask_shop/1,
		 buy_shop/4,
		 
		 player_create_attr/2,
		 player_attr_calc/2,
		 partner_attr_calc/2,
		 
		 key_odds/2,
%% 		 rand_odds/2,
		 check_odds_goods/5,
		 
		 swap_click/3,
		 
		 check_temp/2,
		 
		 
		 change_skill/4,
%% 		 change_skill_cb/2,
		 change_skill_cb2/3,
		 equip_attr_calc/1,
		 
		 msg_exts/2,
		 msg_goods/1,
		 msg_reverse/4,
		 msg_remove/3,
		 msg_change/3,
		 msg_change_notice/3,
		 msg_enlarge_cost/3,
		 msg_enlarge/1,
		 msg_equip_back/3,
		 msg_sell_ok/0,
		 msg_shop_buy_ok/0,
		 msg_acty_use_state/2,
		 msg_p_exp_ok/0,
		 msg_times_xxx2/1]).


%%
%% API Functions
encode_bag(Bag = #bag{list = List, temp = Temp}) -> 
	Bag#bag{list = encode(List), temp = encode(Temp)};
encode_bag(_)->?null.

decode_bag(Bag) ->
	case Bag of
		#bag{list = List}->
			List2=goods_check(decode(List)),
			Bag#bag{list =List2, temp = []};
		_->
			Time=util:seconds(),
			#bag{max = ?CONST_GOODS_BAG_MAX,time=Time,shop_goods=[]}
	end.

encode_equip(Equip)->
	Equip.
decode_equip(Equip)->
	goods_check(Equip).

%% 物品使用次数
encode_times_goods(List) ->
	List.

decode_times_goods(List) ->
	?IF(erlang:is_list(List), List, []).


encode_once_goods(List) ->
	List.

decode_once_goods(List) ->
	?IF(erlang:is_list(List), List, []).

%% 存mysql过滤动态数据
encode(GoodsList) ->
	GoodsList.

decode(GoodsSaves) ->
	GoodsSaves.

%% 背包物品校正
goods_check(List)->
	Fun=fun(#goods{goods_id=GoodsId,id=Gid,idx=Idx,count=Count,exts=Exts},Acc)->
				case goods(GoodsId) of
					Goods2 when is_record(Goods2,goods)->
						#goods{exts=Exts2}=Goods2,
						case Exts of
							#g_eq{streng=Streng,streng_v=StrengV,baptize=Baptize,plus=Plus,
								  slots=Slots,enchant=Enchant,enchant_value=EnchantValue}->
								Exts3=Exts2#g_eq{streng=Streng,streng_v=StrengV,baptize=Baptize,plus=Plus,
												 slots=Slots,enchant=Enchant,enchant_value=EnchantValue},
								[Goods2#goods{id=Gid,idx=Idx,count=Count,exts=Exts3}|Acc];
							_->
								[Goods2#goods{id=Gid,idx=Idx,count=Count}|Acc]
						end;
					_->
						Acc
				end
		end,
	lists:foldl(Fun,[],List).

%% 初始化背包记录
%% @@spec create role init bag data 
init_bag(Player) ->
	Time=util:seconds(),
	Bag=#bag{max = ?CONST_GOODS_BAG_MAX,time=Time,shop_goods=[]},
	{Player,Bag}.

init_equip(Player=#player{pro=Pro,sex=Sex})->
	Equip=init_equip(Pro, Sex),
	{Player,Equip}.

init_equip(Pro,Sex)->
	?MSG_ECHO("================== ~w~n",[{Pro,Sex}]),
	case data_player_init:get(Pro,Sex) of
		#d_player_init{get_equip=GetEquip}->
			case goods_c(GetEquip,[]) of
				GoodsList when is_list(GoodsList)->
					Fun=fun(Goods)->
								#goods{type_sub=TypeSub}=Goods,
								Goods#goods{idx=TypeSub}
						end,
					lists:map(Fun,GoodsList);
				_->
					[]
			end;
		_->
			[]
	end.

%% vip包裹刷新
bag_max(Socket,Count)->
	Bag=role_api_dict:bag_get(),
    Bag2=Bag#bag{max=?CONST_GOODS_BAG_MAX+Count},
	BinMsg=msg_enlarge(Bag2#bag.max),
	app_msg:send(Socket, BinMsg),
	role_api_dict:bag_set(Bag2).

bag_max_updata(Vip)->
	Count=vip_api:check_fun(Vip#vip.lv,#d_vip.bag_max),
	Bag=role_api_dict:bag_get(),
	Bag2=Bag#bag{max=?CONST_GOODS_BAG_MAX+Count},
	role_api_dict:bag_set(Bag2).
 
%% 获取背包所有装备ID return : 装备ID列表(非重复)
get_eq_id(_Player) ->
	#inn{partners=Partners}=role_api_dict:info_get(),
	Equip=role_api_dict:equip_get(),
	#bag{list=List}=role_api_dict:bag_get(),
	GList = lists:foldl(fun(#partner{equip = Eq},Acc) ->
								Acc ++ Eq;
						   (Pt, Acc) ->
								?MSG_ERROR("Pt : ~p~n", [Pt]),
								Acc
						end, List ++ Equip, Partners),
	lists:foldl(fun(#goods{goods_id = Gid, type = Type}, Acc) ->
						case lists:member(Type, ?EQUIP_TYPE_LIST) of
							?true ->
								case lists:member(Gid, Acc) of
									?true ->
										Acc;
									?false ->
										[Gid|Acc]
								end;
							?false ->
								Acc
						end
				end, [], GList).

%% 去出背包指定物品数量
goods_id_count_get(GoodsId)->
	Bag=role_api_dict:bag_get(),
	#bag{list=List}=Bag,
	GoodsList=[Goods||Goods<-List,Goods#goods.goods_id==GoodsId],
	lists:sum([Count||#goods{count=Count}<-GoodsList]).

%% 返回 {?ok,Player2,Bin}|{?error,Error}
%%存放物品
goods_set(LogSrc,Player,GoodsList)->
	Bag=role_api_dict:bag_get(),
	case goods_set(LogSrc,Player,Bag,GoodsList) of
		{?ok,Player2,NewBag,SetBin,LogBin} ->
			role_api_dict:bag_set(NewBag),
			{?ok,Player2,SetBin,LogBin};
		{?error,ErrorCode} ->
			{?error,ErrorCode}
	end.

%% 返回 {?ok,Bag,Bin}|{?error,Error}
%%存放物品
goods_set(LogSrc,Player=#player{uid=Uid},Bag,GoodsList)->
	case goods_c(GoodsList,[]) of
		{?error,Error}->
			{?error,Error};
		GoodsList2->
			{Player2,NewGoodsList,VBin}=goods_virtual(Player,GoodsList2,[],<<>>),
			BagCount=bag_surplus(Bag),
			%% 查看物品所占格子数量
			BagUseCount=bag_use(Bag#bag.list,NewGoodsList),
			case BagCount >= BagUseCount of
				?true->
					{NewBag,ChangeGoodsL}=goods_set_u(NewGoodsList,BagUseCount,Bag),
					LogsGoodsList=[{Gid,Count}||#goods{goods_id=Gid,count=Count,type_sub=TypeSub}<-GoodsList2,TypeSub=/=?CONST_GOODS_IDEAL_GET],
					Bin=msg_change(?CONST_GOODS_CONTAINER_BAG,0,ChangeGoodsL),
					LogsBinMsg=logs_api:event_notice(?CONST_LOGS_TYPE_GOODS,?CONST_TRUE,LogsGoodsList),
					stat_api:logs_goods(Uid,?CONST_TRUE,LogSrc,GoodsList2),
					{?ok,Player2,NewBag,<<VBin/binary,Bin/binary>>,LogsBinMsg};
				_->
					{?error,?ERROR_BAG_FULL} %% 背包空间不足 
			end
	end.
	
goods_set_u(GoodsList,BagUseCount,Bag)->
	#bag{max=BagMax,list=BagList}=Bag,
	IdxList=goods_idxs(BagUseCount,BagMax,BagList),
	{BagList2,ChangeGoodsL}=goods_set2(IdxList,GoodsList,BagList,[]),
	{Bag#bag{list=BagList2},ChangeGoodsL}.


goods_set2([],_,BagList,ChangeGoodsL)->{BagList,ChangeGoodsL};
goods_set2(_,[],BagList,ChangeGoodsL)->{BagList,ChangeGoodsL};
goods_set2([Idx|IdxList],[Goods|GoodsList],BagList,ChangeGoodsL)->
	case Goods#goods.count>=Goods#goods.stack of
		?true->
			Goods2=Goods#goods{idx=Idx,count=Goods#goods.stack},
			BagList2=[Goods2|BagList],
			ChangeGoodsL2=[Goods2|ChangeGoodsL],
			case Goods#goods.count-Goods#goods.stack of
				0->
					goods_set2(IdxList,GoodsList,BagList2,ChangeGoodsL2);
				N->
					Goods3=Goods#goods{count=N},
					goods_set2(IdxList,[Goods3|GoodsList],BagList2,ChangeGoodsL2)
			end;
		_->
			{BagList2,ChangeGoodsL2}=goods_set3(Idx,Goods,BagList,[],ChangeGoodsL),
			goods_set2(IdxList,GoodsList,BagList2,ChangeGoodsL2)
	end.
	
goods_set3(Idx,Goods,[],NewBag,ChangeGoodsL)->
	Goods2=Goods#goods{idx=Idx},
	NewBag2=[Goods2|NewBag],
	ChangeGoodsL2=[Goods2|ChangeGoodsL],
	{NewBag2,ChangeGoodsL2};

goods_set3(Idx,Goods,[BagGoods|BagList],NewBag,ChangeGoodsL)->
	#goods{goods_id=GoodsId,count=GoodsCount}=Goods,
	#goods{goods_id=BagGoodsId,count=BagGoodsCount,stack=BagStack}=BagGoods,
	case GoodsId==BagGoodsId of
		?true->
			case BagStack-(BagGoodsCount+GoodsCount) >=0 of
				?true->
					BagGoods2=BagGoods#goods{count=BagGoodsCount+GoodsCount},
					NewBag2=[BagGoods2|BagList]++NewBag,
					ChangeGoodsL2=[BagGoods2|ChangeGoodsL],
					{NewBag2,ChangeGoodsL2};
				_->
					KGoodsCount=BagGoodsCount+GoodsCount-BagStack,
					BagGoods2=BagGoods#goods{count=BagStack},
					NewBag2=[BagGoods2|NewBag],
					ChangeGoodsL2=[BagGoods2|ChangeGoodsL],
					Goods2=Goods#goods{count=KGoodsCount},
					goods_set3(Idx,Goods2,BagList,NewBag2,ChangeGoodsL2)
			end;
		_->
			NewBag2=[BagGoods|NewBag],
			goods_set3(Idx,Goods,BagList,NewBag2,ChangeGoodsL)
	end.
	
%% 取出空格子索引
goods_idxs(IdxCount,BagMax,BagGoodsList)->
	BagIdxs=[BagIdx||#goods{idx=BagIdx} <- BagGoodsList],
	L = lists:seq(1, BagMax),
	goods_idxs2(BagIdxs,L,IdxCount,[]).

goods_idxs2(_,[],_,Acc)->Acc;
goods_idxs2(BagIdxs,[Idx|L],IdxCount,Acc)->
	case length(Acc) < IdxCount of
		?true->
			case lists:member(Idx,BagIdxs) of
				?true->
					goods_idxs2(BagIdxs,L,IdxCount,Acc);
				_->
					goods_idxs2(BagIdxs,L,IdxCount,[Idx|Acc])
			end;
		_->
			Acc
	end.

%% 剩余格子数量
bag_surplus(Bag) when is_record(Bag,bag)->
	Bag#bag.max - length(Bag#bag.list);

bag_surplus(_)->0.



%% 查看物品所占格子数量
bag_use(BagGoodsList,GoodsList)->
	Fun=fun(Goods,AccCount)->
				#goods{goods_id=GoodsId,count=Count,stack=Stack,type_sub=TypeSub}=Goods,
				case TypeSub of
					?CONST_GOODS_IDEAL_GET->
						AccCount;
					_->
						case lists:sum([BagCount||#goods{goods_id=BagGoodsId,count=BagCount}<-BagGoodsList,BagGoodsId==GoodsId]) of
							0->
								?IF(Count=<Stack,AccCount+1,util:ceil(Count/Stack)+AccCount);
							Sum->
								StackCount=?IF(Sum=<Stack,Stack-Sum,Stack-(Sum rem Stack)),
								case Count =< StackCount of
									?true->AccCount+1;
									_->
										util:ceil(((Count-StackCount)/Stack))+AccCount
								end
						end
				end
		end,
	lists:foldl(Fun,0,GoodsList).

%% 打包物品
goods_c([],Acc)->Acc;
goods_c([GoodsU|GoodsList],Acc)->
	case goods(GoodsU) of
		Goods when is_record(Goods,goods)->
			goods_c(GoodsList,[Goods|Acc]);
		{?error,Error}->
			{?error,Error}
	end.
	

%% 去出物品
%% ruturn {?ok,Bag,Bin}|{?error,Error}
goods_get(_LogSrc,Player,Bag,[])->{?ok,Player,Bag,<<>>};
goods_get(LogSrc,Player=#player{uid=Uid},Bag,GoodsList0)->
	GoodsList=[{A,B}||{A,B}<-GoodsList0,A =/= 0 andalso B =/= 0],
	?MSG_ECHO("=========goods_get :======= ~w~n",[GoodsList]),
	BagList=lists:keysort(#goods.count,Bag#bag.list),
	case goods_find(GoodsList,BagList,[],[],[]) of
		{BagList2,RGL,GGL} ->
			NewBag=Bag#bag{list=BagList2++GGL},
			Bin	=msg_remove(?CONST_GOODS_CONTAINER_BAG,0,RGL),
%% 			BinMsg=logs_api:event_notice(?CONST_LOGS_TYPE_GOODS,?CONST_FALSE,GoodsList),
			GBin=msg_change(?CONST_GOODS_CONTAINER_BAG,0,GGL),
			stat_api:logs_goods(Uid,?CONST_FALSE,LogSrc,GoodsList),
			{?ok,Player,NewBag,<<Bin/binary,GBin/binary>>};
		_->
			{?error,?ERROR_GOODS_LACK} %% 物品不足
	end.

goods_find([],BagGoodsList,Acc,DRGL,DGGL)->{BagGoodsList++Acc,DRGL,DGGL};
goods_find(_GoodsList,[],_,_,_)->?false;
goods_find(GoodsList,[BagGoods|BagGoodsList],Acc,DRGL,DGGL)->
	case goods_find2(GoodsList,BagGoods,[],[]) of
		{_RGL,GoodsList2,BagGoods}->
			goods_find(GoodsList2,BagGoodsList,[BagGoods|Acc],DRGL,DGGL);
		{_RGL,GoodsList2,BagGoods2}->
			goods_find(GoodsList2,BagGoodsList,Acc,DRGL,[BagGoods2|DGGL]);
		{RGL,GoodsList2}->
			goods_find(GoodsList2,BagGoodsList,Acc,DRGL++RGL,DGGL)
	end.

%% goods_find2([],_BagGoods,[],SGL)->
%% 	{?false,SGL};
goods_find2([],BagGoods,RGL,SGL)->
	case BagGoods#goods.count>0 of
		?true->
			{RGL,SGL,BagGoods};
		_->
			{RGL,SGL}
	end;
goods_find2([{GoodsId,Count}|GoodsList],BagGoods,RGL,SGL)->
	#goods{goods_id=BagGoodsId,count=BagCount,idx=BagIdx}=BagGoods,
	case BagGoodsId==GoodsId of
		?true->
			if
				BagCount-Count==0->
					BagGoods2=BagGoods#goods{count=0},
					RGL2=[BagIdx|RGL],
					SGL2=SGL;
				BagCount-Count<0->
					BagGoods2=BagGoods#goods{count=0},
					RGL2=[BagIdx|RGL],
					SGL2=[{GoodsId,Count-BagCount}];
				?true->
					BagGoods2=BagGoods#goods{count=BagCount-Count},
					RGL2=RGL,
					SGL2=SGL
			end,
			goods_find2(GoodsList,BagGoods2,RGL2,SGL2);
		_->
			SGL2=[{GoodsId,Count}|SGL],
			goods_find2(GoodsList,BagGoods,RGL,SGL2)
	end.

%% 丢弃物品?? return : {?ok, Player, BinMsg} | {?error, ErrorCode}
remove(Player=#player{uid=Uid}, Idx) ->
	case take(Player, Idx) of
		{?ok, Player2, #goods{flag=Flag}=Goods, BinMsg} ->
			case Flag#g_flag.destroy of
				?CONST_TRUE ->
					stat_api:logs_goods(Uid,?CONST_FALSE,?MODULE,remove,Goods,<<"丢弃物品">>),
					{?ok, Player2, BinMsg};
				?CONST_FALSE ->
					{?error, ?ERROR_FLAG_DESTROY_BAN}
			end;
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.

%% 扩充背包
enlargh(Player) ->
	Bag=role_api_dict:bag_get(),
	#bag{count = Count, max = Max} = Bag,
	case ?DATA_BAG:get(Count) of
		{GoodsId, Num, Vol} ->
			MaxTem = Max + Vol,
			Max2 = case MaxTem >= ?CONST_GOODS_BAG_MAX of
					   ?true ->
						   MaxTem;
					   ?false ->
						   ?MSG_ERROR("{Max, Vol, MaxTem} : ~p~n", [{Max, Vol, MaxTem}]),
						   ?CONST_GOODS_BAG_MAX
				   end,
			Bag2 = Bag#bag{count = Count + 1, max = Max2},
			case goods_get([?MODULE,enlargh,[],<<"扩充背包">>],Player,Bag2, [{GoodsId, Num}]) of
				{?ok,Player2,Bag3,Bin}->
					Bin2 = msg_enlarge(Max2),
					role_api_dict:bag_set(Bag3),
					{?ok, Player2, <<Bin/binary, Bin2/binary>>};
				{?false, _,_,_} ->
					{?error, ?ERROR_GOODS_LACK}
			end;
		_ ->
			{?error, ?ERROR_BAG_COUNT_MAX}
	end.

%% vip增加背包容量
enlargh_vip(Player, Value) ->
	Bag=role_api_dict:bag_get(),
	#bag{max = Max} = Bag,
	MaxTem = Value + Max,
	Max2 = case MaxTem >= ?CONST_GOODS_BAG_MAX of
			   ?true ->
				   MaxTem;
			   ?false ->
				   ?MSG_ERROR("Bag Err Change Value {Max, Value, MaxTem} : ~p~n", [{Max, Value, MaxTem}]),
				   ?CONST_GOODS_BAG_MAX
		   end,
	Bag2 = Bag#bag{max = Max2},
	BinMsg = msg_enlarge(Max2),
	role_api_dict:bag_set(Bag2),
	{Player, BinMsg}.

%% 出售物品 return:{?ok, Player, Bin} | {?error, ErrorCode}
sell(Player, Bag,IdxList) ->
	sell(Player, Bag , IdxList, [], <<>>).

sell(Player = #player{uid=Uid}, Bag, [], GoodsTakes, BinAcc) ->
	case check_sell(GoodsTakes) of
		?ok ->
			TypeValueL =
				lists:foldl(fun(#goods{count = Count, price_type = Type,price = Price}, Acc) ->
									case lists:keytake(Type, 1, Acc) of
										{value, {Type, PriceOld}, Acc2} ->
											[{Type, PriceOld + Price * Count}|Acc2];
										?false ->
											[{Type, Price * Count}|Acc]
									end
							end, [], GoodsTakes),
			{Player2, BinAcc2} = role_api:currency_add([sell,[],<<"出售物品">>],Player, TypeValueL),
			Bin3 = msg_sell_ok(),
			[stat_api:logs_goods(Uid,?CONST_FALSE,sell,Goods,<<"出售物品">>)||
			   Goods <- GoodsTakes],
			{?ok, Player2, Bag, <<BinAcc/binary, BinAcc2/binary, Bin3/binary>>};
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end;

sell(Player,Bag, [{Idx,Num}|List], GoodsTakes, BinAcc) ->
	case goods_get_idx(Bag, Idx, Num,?CONST_TRUE) of
		{?ok, Bag2, Goods, BinAcc2} ->
			sell(Player,Bag2, List, [Goods|GoodsTakes], <<BinAcc/binary, BinAcc2/binary>>);
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.

%% 检查是否可以出售
check_sell([]) ->
	ok;
check_sell([#goods{flag = Flag}|L]) ->
	case is_record(Flag, g_flag) andalso Flag#g_flag.sell == 0 of
		?true ->
			{?error, ?ERROR_BAG_SELL_BAN};
		?false ->
			check_sell(L)
	end.

%% Goods 转 Give
goods_to_give(Goods) when is_record(Goods, goods) ->
	Streng = 
		if
			is_record(Goods#goods.exts, g_eq) ->
				(Goods#goods.exts)#g_eq.streng;
			?true ->
				0
		end,
	#give{
		  goods_id 		= Goods#goods.goods_id,			% 物品ID
		  count			= Goods#goods.count,			% 数量
		  streng 		= Streng,						% [BN]强化等级
		  name_color	= Goods#goods.name_color,		% 物品名称的颜色
		  bind	  		= 1,							% 是否绑定(0:不绑定 1:绑定)
		  expiry_type	= Goods#goods.expiry_type,		% 有效期类型，0:不失效，1：秒，  2：天，请多预留几个以后会增加
		  expiry		= Goods#goods.expiry			%   有效期，到期后自动消失，并发系统邮件通知
		 };
goods_to_give(Give) when is_record(Give, give) ->
	Give;
goods_to_give(_) -> ?null.

%% 虚拟物品
goods_virtual(Player,[],NewGoodsList,Bin)->{Player,NewGoodsList,Bin};
goods_virtual(Player=#player{pro=Pro},[Goods|GoodsList],NewGoodsList,BinMsg)->
	#goods{goods_id=Gid,type_sub=TypeSub,count=Count,exts=Exts}=Goods,
	case TypeSub of
		?CONST_GOODS_IDEAL_GET->
			#g_none{as1=CT,as2=V}=Exts,
			{Player2, Bin} = role_api:currency_add([goods_use_in,[],<<"使用物品id:",(util:to_binary(Gid))/binary,",数量:",(util:to_binary(Count))/binary>>],Player,[{CT,V*Count}]),
			goods_virtual(Player2,GoodsList,NewGoodsList,<<BinMsg/binary,Bin/binary>>);
		?CONST_GOODS_LV_GOODS->
			#g_none{as1=CT}=Exts,
			case lists:keyfind(Pro,1,CT) of
				{_,GoodsId}->
					case goods({GoodsId,1}) of
						Goods2 when is_record(Goods2,goods)->
							goods_virtual(Player,GoodsList,[Goods2|NewGoodsList],BinMsg);
						_->
							goods_virtual(Player,GoodsList,NewGoodsList,BinMsg)
					end;
				_->
				goods_virtual(Player,GoodsList,NewGoodsList,BinMsg)
			end;
		_->
			goods_virtual(Player,GoodsList,[Goods|NewGoodsList],BinMsg)
	end.



%% 使用物品
%% 
goods_use(Player, Type, Id, FromIdx, Count) ->
	goods_use(Player, Type, Id, FromIdx, Count, 0).

goods_use(#player{}=Player, _Type, _Id, _FromIdx, 0, _Object) ->
	{?ok, Player, <<>>};
goods_use(#player{info=Info}=Player, Type, Id, FromIdx,Count, Object) ->
	Bag=role_api_dict:bag_get(),
	Inn=role_api_dict:inn_get(),
	Equip=role_api_dict:equip_get(),
	case Type of
		?CONST_GOODS_CONTAINER_BAG ->
			case goods_get_idx(Bag, FromIdx, Count,?CONST_TRUE) of
				{?ok, Bag2, #goods{type=Type0}=GoodsTake, Bin} ->
					case magic_check(GoodsTake#goods.type, Info, Id, GoodsTake#goods.name_color) of
						?ok ->
							case lists:member(Type0, ?EQUIP_TYPE_LIST) of
								?true ->
									case equip_on(Player,Inn,Equip,Bag2,GoodsTake,Id) of
										{?ok, Player3,Inn3,Equip3,Bag3,EquipBin} ->
											role_api_dict:bag_set(Bag3),
											role_api_dict:equip_set(Equip3),
											role_api_dict:inn_set(Inn3),
											role_api:update_powerful_z(Player3),
%% 											{?ok, Player3, EquipBin};
											{?ok, Player3, <<Bin/binary,EquipBin/binary>>};
										{?error, ErrorCode} ->
											{?error, ErrorCode}
									end;
								?false ->
									case goods_use_check(Player, GoodsTake) of
										?ok->
											case goods_use_in(Player,Id,Bag2, GoodsTake) of
												{?ok, Player3,Bag3,Bin2} ->
													role_api_dict:bag_set(Bag3),										
													{?ok, Player3,<<Bin/binary,Bin2/binary>>};
												{?error, ErrorCode} ->
													{?error, ErrorCode}
											end;
										{?error,ErrorCode}->
											{?error,ErrorCode}
									end
							end;
						{?error, ErrorCode} ->
							{?error, ErrorCode}
					end;
				{?error, ErrorCode} ->
					{?error, ErrorCode}
			end;
		?CONST_GOODS_CONTAINER_EQUIP ->
			case equip_off(Player,Inn,Equip,Bag,Id,FromIdx) of
				{?ok, Player2,Inn2,Equip2,Bag2,BinMsg}->
					role_api_dict:bag_set(Bag2),
					role_api_dict:equip_set(Equip2),
					role_api_dict:inn_set(Inn2),
					role_api:update_powerful_z(Player2),
					{?ok, Player2,BinMsg};
				{?error, ErrorCode} ->
					{?error, ErrorCode}
			end
	end.

%% 检查物品是否可以使用 return: ok | {?error, ErrorCode} 
goods_use_check(#player{sex=Sex}, #goods{sex=Sex0}) 
  when Sex0 =/= 0 andalso Sex =/= Sex0 ->
	{?error, ?ERROR_EQUIP_SEX_NOT};
goods_use_check(#player{lv=Lv}, #goods{type = Type, lv=Lv0}) 
  when Lv0 =/= 0 andalso Lv < Lv0 ->
	ErrorCode = case lists:member(Type, ?EQUIP_TYPE_LIST) of
					?true ->
						?ERROR_EQUIP_LV_NOT;
					?false ->
						?ERROR_BAG_LEVEL_SHORTAGE
				end,
	{?error, ErrorCode};
goods_use_check(#player{pro = Pro}, #goods{expiry=Expiry,pro=Pro0}) ->
	Seconds = util:seconds(),
	case Expiry == 0 orelse Expiry >= Seconds of
		?true ->
			if
				Pro0 == 0 orelse Pro0 == [] ->
					ok;
				?true ->
					case lists:member(Pro, Pro0) of
						?true ->
							ok;
						?false ->
							{?error, ?ERROR_EQUIP_PRO_NOT}
					end
			end;
		?false ->
			{?error, ?ERROR_BAG_EXPIRY_OUTDATE}
	end;


goods_use_check(#partner{sex=Sex}, #goods{sex=Sex0}) 
  when Sex0 =/= 0 andalso Sex =/= Sex0 ->
	{?error, ?ERROR_EQUIP_SEX_NOT};
goods_use_check(#partner{lv=Lv}, #goods{lv=Lv0}) 
  when Lv0 =/= 0 andalso Lv < Lv0 ->
	{?error, ?ERROR_EQUIP_LV_NOT};
goods_use_check(#partner{pro = Pro}, #goods{expiry=Expiry,pro=Pro0}) ->
	Seconds = util:seconds(),
	case Expiry == 0 orelse Expiry >= Seconds of
		?true ->
			if
				Pro0 == 0 orelse Pro0 == [] ->
					ok;
				?true ->
					case lists:member(Pro, Pro0) of
						?true ->
							ok;
						?false ->
							{?error, ?ERROR_EQUIP_PRO_NOT}
					end
			end;
		?false ->
			{?error, ?ERROR_BAG_EXPIRY_OUTDATE}
	end.

%% 钱袋
goods_use_in(Player, _Object,Bag, #goods{goods_id = Gid, type = ?CONST_GOODS_ORD, type_sub = ?CONST_GOODS_COMMON_MONEY_BAG,
									 count = Count, exts = #g_none{as1 = CT, as2 = Value}}) ->
	{Plauer2, Bin} = role_api:currency_add([goods_use_in,[],<<"使用物品id:",(util:to_binary(Gid))/binary,",数量:",(util:to_binary(Count))/binary>>],Player, [{CT, Value * Count}]),
	{?ok, Plauer2,Bag,Bin};

%% 宝盒
goods_use_in(Player, _Object,Bag, #goods{goods_id=Gid,type=?CONST_GOODS_ORD,type_sub=Typesub,count=Count,exts=GNone}) 
  when Typesub == ?CONST_GOODS_COMMON_BOX ->
	#g_none{as1=GoodsList,as2=GCount}=GNone,
	GoodsList2=util:odds_list_count(GoodsList,GCount),
	case goods_set([goods_use_in,[],<<"使用宝盒  goods_id:",(util:to_binary(Gid))/binary,",数量:",(util:to_binary(Count))/binary>>],Player,Bag, GoodsList2) of
		{?ok,Player2,Bag2,GoodsBin,Bin}->
			{?ok,Player2,Bag2,<<GoodsBin/binary,Bin/binary>>};
		{?error,Error}->
			{?error,Error}
	end;

%% 礼包
goods_use_in(Player, _Object,Bag, #goods{goods_id=Gid,type=?CONST_GOODS_ORD,type_sub=Typesub,count=Count}) 
  when Typesub == ?CONST_GOODS_COMMON_GIFT ->
	case data_goods:gift(Gid) of
		List when is_list(List) ->
			Fun = fun(_,Acc) ->
						  lists:foldl(fun({OddsList, _},AccIn) ->
											  ?MSG_ECHO("=======OddsList :  ~w~n",[OddsList]),
											  rand_odds(OddsList, AccIn)
									  end, Acc, List)
				  end,
			GoodsList = lists:foldl(Fun, [], lists:duplicate(Count, 1)),
			case goods_set([goods_use_in,[],<<"使用礼包  goods_id:",(util:to_binary(Gid))/binary,",数量:",(util:to_binary(Count))/binary>>],Player,Bag, GoodsList) of
				{?ok,Player2,Bag2,GoodsBin,Bin}->
					{?ok,Player2,Bag2,<<GoodsBin/binary,Bin/binary>>};
				{?error,Error}->
					{?error,Error}
			end;
		_ ->
			{?error, ?ERROR_UNKNOWN}
	end;

%% 主角使用的经验丹type_sub = ?CONST_GOODS_COMMON_LEAD_EXP,
goods_use_in(#player{lv=Lv} = Player, _Object, Bag,#goods{type = ?CONST_GOODS_ORD,type_sub=?CONST_GOODS_COMMON_EXP,goods_id=GoodsId, count = Count, exts = #g_none{as1 = Exp}}) ->
	LvMax = db:config_level_max(),
	if
		Lv < LvMax ->
				 Player2 = role_api:exp_add(Player, util:ceil(Exp * Count),goods_use_in,<<"使用物品id:",(util:to_binary(GoodsId))/binary,",数量:",(util:to_binary(Count))/binary>>),
				 {?ok,Player2,Bag,<<>>};
			 ?true ->
				 {?error, ?ERROR_ROLE_LV_MAX}
	end;

%% 伙伴经验丹
goods_use_in(Player, PartnerID, Bag,#goods{type = ?CONST_GOODS_ORD, type_sub = ?CONST_GOODS_COMMON_PAR_EXP, count = Count, exts = #g_none{as1 = Exp}}) ->
	case check_partner_exp(Player, PartnerID) of
		?ok ->
			case inn_api:exp_partner_ids(Player,PartnerID,util:ceil(Exp * Count)) of
				{?error, ErrorCode} ->
					{?error, ErrorCode};
				Player2 ->
					BineOk=msg_p_exp_ok(),
					{?ok, Player2,Bag,BineOk}
			end;
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end;

%% 斗气
goods_use_in(Player, _Object, Bag,#goods{type = ?CONST_GOODS_ORD,type_sub=?CONST_GOODS_WHEEL_GOODS,exts = #g_none{as1 = DouqiList}}) ->
	case douqi_api:douqi_add(DouqiList) of
		?ok->
			Bin = logs_api:event_notice(?CONST_LOGS_TYPE_DOUQI, ?CONST_LOGS_ADD, [{IdL, CountL}||{IdL,_LV,CountL} <- DouqiList]),
			{?ok,Player,Bag, Bin};
		{?error,Error}->{?error,Error}
	end;

%% 	 case douqi_api:adam_war_add(DouqiList) of
%% 		 ?ok->{?ok,Player2,Bag,<<>>};
%% 		 {?error,Error}->{?error,Error}
%% 	 end;

%% use lv goods type_sub = ?CONST_GOODS_COMMON_CLASS_BOX
%% goods_use_in(#player{uid=Uid,lv = Lv} = Player, _Object,Bag, #goods{goods_id = GoodsID, type = ?CONST_GOODS_ORD,count = Count}) ->
%% 	RangeLv = util:range_lv(Lv),
%% 	case data_lv_goods:get(GoodsID, RangeLv) of
%% 		#d_lv_goods{get_goods = GiveL} ->
%% 			Fun = fun(_, Acc) ->
%% 						  lists:foldl(fun({GiveSubL, _}, AccSub) ->
%% 											  case util:rand_odds_list(GiveSubL) of
%% 												  #give{} = Give ->
%% 													  case goods(Give) of
%% 														  #goods{} = Goods ->
%% 															  [Goods|AccSub];
%% 														  _ ->
%% 															  AccSub
%% 													  end;
%% 												  _ ->
%% 													  AccSub
%% 											  end
%% 									  end, Acc, GiveL)
%% 				  end,
%% 			GoodsList = lists:foldl(Fun, [], lists:seq(1, Count)),
%% 			case goods_set([goods_use_in,[],<<"使用等级礼包  goods_id:",(util:to_binary(GoodsID))/binary,",数量:",(util:to_binary(Count))/binary>>],Player,Bag, GoodsList) of
%% 				{?ok,Player2,Bag2,Bin}->
%% 					{?ok,Player2,Bag2,Bin};
%% 				{?error,Error}->
%% 					{?error,Error}
%% 			end;
%% 		_ ->
%% 			{?error, ?ERROR_BAG_GOODS_USE_BAN}
%% 	end;

%% vip体验卡
goods_use_in(Player, _Object,Bag,#goods{type = ?CONST_GOODS_ORD, type_sub = ?CONST_GOODS_VIP, count = Count, exts = #g_none{as1 = VipLv, as2 = T, as3 = V}}) ->
	Seconds = init_expiry(T, V * Count, util:seconds()),
	case vip_api:try_vip(Player, VipLv, Seconds) of
		{?ok,Player2,BinMsg}->
			{?ok,Player2,Bag,BinMsg};
		{?error,Error}->
			{?error,Error}
	end;

%% 伙伴卡
goods_use_in(Player, _Object, Bag,#goods{type = ?CONST_GOODS_ORD, type_sub = ?CONST_GOODS_COMMON_PARTNER_CARD,exts = #g_none{as1 = PartnerId}}) ->
	case inn_api:partner_crad(Player, PartnerId) of
		{?ok,BinMsg} ->
			{?ok, Player,Bag,BinMsg};
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end;


goods_use_in(_Player, _Object,_Bag, _GoodsTake) ->
	{?error, ?ERROR_BAG_GOODS_USE_BAN}.


check_partner_exp(#player{lv=Lv}, PartnerId) ->
	#inn{partners=Ps}=role_api_dict:inn_get(),
	case lists:keyfind(PartnerId, #partner.partner_id, Ps) of
		#partner{lv = LvPartner} ->
			if
				LvPartner < Lv ->
					?ok;
				?true ->
					{?error, ?ERROR_BAG_USE_EXP_LV}
			end;
		_ ->
			{?error, ?ERROR_INN_NO_PARTNER}
	end.


%% 穿装备? return : {?ok, Player, Bin} | {?error, ErrorCode}
equip_on(#player{socket=Socket}=Player,Inn,Equip,Bag,#goods{type_sub=Typesub} = Goods0, Id) ->
	Goods = Goods0#goods{idx = Typesub},
	Bin = msg_change(?CONST_GOODS_CONTAINER_EQUIP, Id, [Goods]),
	case Id of
		0 ->
			case goods_use_check(Player, Goods0) of
				?ok->
					{Equip2, GoodsSet} = equip_on_in(Goods, Equip),
					Bin0 = msg_remove(?CONST_GOODS_CONTAINER_EQUIP, Id, [Idx||#goods{idx = Idx} <- GoodsSet]),
					case goods_set([equip_on,[],<<"">>],Player,Bag, GoodsSet) of
%% 						{?ok, _Player2,Bag,_SetBin, _Bin2} ->
%% 							{Player,Inn,Equip2,Bag,Bin};
						{?ok, Player2,Bag2,SetBin, _Bin2} ->
							Player3 = player_attr_calc(Player2,Equip2),
							{?ok, Player3,Inn,Equip2,Bag2,<<SetBin/binary,Bin0/binary,Bin/binary>>};
						{?error, ErrorCode} ->
							{?error, ErrorCode}
					end;
				{?error, ErrorCode} ->
					{?error, ErrorCode} 
			end;		
		_ ->
			#inn{partners = Partners} = Inn,
			case lists:keytake(Id, #partner.partner_id, Partners) of
				{value, #partner{equip = EquipP} = Partner, Partners2} ->
					case goods_use_check(Partner, Goods0) of
						?ok ->
							{EquipP2, GoodsSet} = equip_on_in(Goods, EquipP),
							Bin0 = msg_remove(?CONST_GOODS_CONTAINER_EQUIP, Id, [Idx||#goods{idx = Idx} <- GoodsSet]),
							Partner2 = partner_attr_calc(Socket,Partner#partner{equip = EquipP2}),
							Inn2 = Inn#inn{partners = [Partner2|Partners2]},
							case goods_set([equip_on,[],<<"">>],Player,Bag, GoodsSet) of
								{?ok, Player2,Bag2,SetBin,Bin2} ->
									{?ok, Player2,Inn2,Equip,Bag2,<<SetBin/binary,Bin0/binary,Bin/binary,Bin2/binary>>};
								{?error, ErrorCode} ->
									{?error, ErrorCode}
							end;
						{?error, ErrorCode} ->
							{?error, ErrorCode}
					end;
				?false ->
					{?error, ?ERROR_INN_NO_PARTNER}
			end
	end.

%% return : {Equip,GoodsSets}
equip_on_in(#goods{type_sub = Typesub} = Goods, Equip) ->
	Types = case lists:member(Typesub, ?EQUIP_WEAPON_TYPES) of
				?true ->
					?EQUIP_WEAPON_TYPES;
				?false ->
					[Typesub]
			end,
	{NewEquip, GoodsSets} = 
		lists:foldl(fun(#goods{type_sub = Typesub0}=Goods0,{EquipAcc, GoodsSet}) ->
							case lists:member(Typesub0, Types) of
								?true ->
									{EquipAcc, [Goods0|GoodsSet]};
								?false ->
									{[Goods0|EquipAcc], GoodsSet}
							end
					end, {[],[]}, Equip),
	{[Goods|NewEquip],GoodsSets}.

magic_check(_, _, _, _) ->
	ok.


%% 卸下装备  return : {?ok, Player, Bin} | {?error, ErrorCode}
equip_off(#player{socket = Socket} = Player,Inn,Equip,Bag,Id,Idx) ->
	case check_bag(Bag) of
		?false ->
			Bin1 = msg_remove(?CONST_GOODS_CONTAINER_EQUIP, Id, [Idx]),
			case Id of
				0 ->
					case lists:keytake(Idx, #goods.idx, Equip) of
						{value, EquipOff, Equip2} ->
							case goods_set([equip_off,[],<<"">>],Player,Bag, [EquipOff]) of
								{?ok,Player2, Bag2,GoodsBin,_Bin2} ->
									{?ok, player_attr_calc(Player2,Equip2),Inn,Equip2,Bag2,<<Bin1/binary,GoodsBin/binary>>};
								{?error, ErrorCode} ->
									{?error, ErrorCode}
							end;
						?false -> 
							{?error, ?ERROR_GOODS_NOT_EXIST}
					end;
				_ ->
					#inn{partners = Partners} = Inn,
					case lists:keytake(Id, #partner.partner_id, Partners) of
						{value, #partner{equip = EquipP} = Partner, Partners2} ->
							case lists:keytake(Idx, #goods.idx, EquipP) of
								{value, GoodsOld, EquipP2} ->
									Partner2 = partner_attr_calc(Socket, Partner#partner{equip = EquipP2}),
									Inn2 = Inn#inn{partners = [Partner2|Partners2]},
									case goods_set([equip_off,[],<<"">>],Player,Bag, [GoodsOld]) of
										{?ok,Player2,Bag2,GoodsBin,Bin2} ->
											{?ok, Player2,Inn2,Equip,Bag2,<<Bin1/binary,GoodsBin/binary,Bin2/binary>>};
										{?error, ErrorCode} ->
											{?error, ErrorCode}
									end;
								?false ->
									{?error, ?ERROR_GOODS_NOT_EXIST}
							end;
						?false ->
							{?error, ?ERROR_INN_NO_PARTNER}
					end
			end;
		?true ->
			{?error, ?ERROR_BAG_FULL}
	end.

%% 创建角色刷新装备属性
player_create_attr(Player=#player{lv=Lv,attr=AttrOld,info=Info},Equip)->
	Attr = equip_attr_calc(Equip),
	case role_api_dict:attr_group_get() of
		AttrGroup when is_record(AttrGroup,attr_group)->
			AttrGroup2=AttrGroup#attr_group{equip=Attr},
			AttrNew=role_api:attr_all(AttrGroup2,Lv,Info#info.talent),
			role_api:attr_refresh_side(Player,AttrGroup2,AttrOld,AttrNew,<<>>,?false);
		_->
			Player
	end.

%% 刷新人物属性 return: Player
player_attr_calc(Player,Equip) ->
	Attr = equip_attr_calc(Equip),
	role_api:attr_update_player(Player, equip, Attr).

%% 刷新伙伴属性 return: Partner
partner_attr_calc(Socket, #partner{equip = Equip} = Partner) ->
	Attr = equip_attr_calc(Equip),
	inn_api:attr_update_partner(Socket, Partner, equip, Attr).


%% 刷新属性??
%% return : Attr
equip_attr_calc(Equip) ->
	Fun = fun({T, V}, A) ->
				  case lists:keyfind(T, 1, ?ATTR_TYPE_POS) of
					  {_, Index} ->
						  setelement(Index, A, V + element(Index, A));
					  ?false ->
						  A
				  end
		  end,
	F = fun(#goods{exts=#g_eq{attr_base_type=TypeValue,suit_id=_SuitID,enchant=Enchant,
							  plus=Plus,slots=Slots,streng_v = StrenVAttr}},Acc) ->
				PlusL = [{Type0, Value0}||{Type0, _Color, Value0, _Max} <- Plus],
				Acc0 = TypeValue++PlusL,
				StrenVAttr2=?IF(is_record(StrenVAttr,attr),StrenVAttr,#attr{}),
				F2=fun({_,_,TV},AccIn) when is_list(TV)->
						   AccIn ++ TV;
					  (_,AccIn)->
						   AccIn
				   end,
				TVL = lists:foldl(F2, Acc0, Slots),
				FAttr=lists:foldl(Fun,StrenVAttr2, TVL),
				#attr{hp=FAttr2Hp,strong_att=FAttr2sa,strong_def=FAttr2sd,skill_att=FAttr2ska,skill_def=FAttr2skd,
					  crit=FAttr2c,crit_res=FAttr2cr,crit_harm=FAttr2h,defend_down=FAttr2dd,reduction=FAttr2re,
					  strong=FAttr2st,magic=FAttr2ma}=FAttr,
				FAttr2=FAttr#attr{
									hp 			=	trunc(FAttr2Hp*Enchant/100+FAttr2Hp), 
									strong		=   trunc(FAttr2st*Enchant/100+FAttr2st),
									magic		=   trunc(FAttr2ma*Enchant/100+FAttr2ma),
									strong_att 	=	trunc(FAttr2sa*Enchant/100+FAttr2sa), 
									strong_def 	=	trunc(FAttr2sd*Enchant/100+FAttr2sd), 
									skill_att 	=	trunc(FAttr2ska*Enchant/100+FAttr2ska), 
									skill_def 	=	trunc(FAttr2skd*Enchant/100+FAttr2skd), 
									crit 		=	trunc(FAttr2c*Enchant/100+FAttr2c), 
									crit_res 	=	trunc(FAttr2cr*Enchant/100+FAttr2cr), 
									crit_harm 	=	trunc(FAttr2h*FAttr2h/100+FAttr2h), 
									defend_down =	trunc(FAttr2dd*Enchant/100+FAttr2dd),
									reduction	=   trunc(FAttr2re*Enchant/100+FAttr2re)
								   },
				role_api:attr_sum(FAttr2,[Acc]);
		   (_,Acc) ->
				Acc
		end,
	Attr = lists:foldl(F, #attr{}, Equip),
	Attr2 = suit_calc(Equip, Attr),
	Attr2.

%% suit_calc
suit_calc(Equip, Attr) ->
	IdCountLv = 
		lists:foldl(fun(#goods{exts = #g_eq{streng=Lv,suit_id = SuitID}},Acc) when SuitID =/= 0 ->
							case lists:keytake(SuitID, 1, Acc) of
								{value, {_, Count,LvOld}, Acc2} ->
									[{SuitID,Count + 1,erlang:min(LvOld, Lv)}|Acc2];
								?false ->
									[{SuitID,1,Lv}|Acc]
							end;
					   (_, Acc) ->
							Acc
					end, [], Equip),
	TypeVL = suit_calc2(IdCountLv),
	NewAttr = do_suit_calc(TypeVL, Attr),
	NewAttr.

do_suit_calc([], Attr) ->
	Attr;
do_suit_calc([{Type,Value0}|L], Attr) ->
	case lists:keyfind(Type, 1, ?ATTR_TYPE_POS) of
		{Type, N} ->
			Value = 
				case lists:member(Type, ?EQUIP_TYPE_RAND_TRUNC) of
					?true ->
						util:ceil(Value0 / 10) * 10;
					?false ->
						Value0
				end,
			ValueOld = element(N, Attr),
			do_suit_calc(L, setelement(N, Attr, ValueOld + Value));
		?false ->
			do_suit_calc(L, Attr)
	end.

suit_calc2(IdCountL) ->
	suit_calc2(IdCountL, []).

suit_calc2([], Acc) ->
	Acc;
suit_calc2([{SuitID, Count, Lv}|L], Acc) ->
	case suit_calc3(SuitID,Count, Lv) of
		[] ->
			suit_calc2(L, Acc);
		TypeVL ->
			suit_calc2(L, TypeVL ++ Acc)
	end.

suit_calc3(_SuitID,Count, _Lv) when Count =< 0 ->
	[];
suit_calc3(SuitID,Count, Lv) ->
	case suit_calc4(SuitID,Count, Lv) of
		TypeVL when is_list(TypeVL), TypeVL =/= [] ->
			TypeVL;
		_ ->
			suit_calc3(SuitID,Count - 1, Lv)
	end.

suit_calc4(_SuitID,_Count, Lv) when Lv < 0 ->
	[];
suit_calc4(SuitID,Count, Lv) ->
	case data_goods_suit_equip:get(SuitID,Count,Lv) of
		TypeVL when is_list(TypeVL), TypeVL =/= [] ->
			TypeVL;
		_ ->
			suit_calc4(SuitID,Count, Lv - 1)
	end.


%% 物品列表
%% return : [#goods{}|_] | {?error, ErrorCode}
goods_list(GoodsId, Count) ->
	case goods(GoodsId) of
		#goods{stack = Stack}=Goods ->
			case Count div Stack of
				0 ->
					[Goods#goods{count = Count}];
				Div ->
					L = [begin Goods0 = goods(GoodsId),
							   Goods0#goods{count = Stack}
						 end || _ <- lists:duplicate(Div, 1)],
					case Count rem Stack of
						0 ->
							L;
						Rem ->
							[begin Goodsww = goods(GoodsId),
								   Goodsww#goods{count = Rem}
							 end|L]
					end
			end;
		R ->
			R
	end.

%% io:format("Format  ~w~n", [bag_api:goods({give,1001,2,30,2,0,0,0})]).

%% 生成物品 return : #goods{} | {?error, ErrorCode}
goods(#give{goods_id=GoodsId,count=Count,streng=Streng,
			name_color=_NameColor,expiry_type=ExpiryType,expiry=Expiry0}) ->
	case goods(GoodsId) of
		#goods{exts=Exts,name_color=Color,class=Class,type=Type,type_sub=Typesub} = Goods0 ->
			Seconds = util:seconds(),
			Goods = case ExpiryType of
						?CONST_EXPIRY_PERPETUITY ->
							Goods0;
						_ ->
							Expiry = init_expiry(ExpiryType, Expiry0, Seconds),
							Goods0#goods{expiry = Expiry}
					end,							
			StrenV = ?IF(Streng == 0, 0, begin 
											 case make_api:data_stren_get(Streng, Color, Type, Typesub, Class) of
												 #d_equip_stren{attr = Value} ->
													 Value;
												 _ ->
													 0
											 end
										 end),
			Exts2 = ?IF(is_record(Exts, g_eq), Exts#g_eq{streng=Streng, streng_v = StrenV}, Exts),
			Goods2 = Goods#goods{goods_id=GoodsId,count=Count,exts=Exts2},
			Goods3 = make_api:price_stren(Goods2),
			score_equip(Goods3);
		R -> R
	end;

goods(GoodsId) when is_integer(GoodsId) ->
	case ?DATA_GOODS:get(GoodsId) of
		#goods{expiry_type = ExpiryType, expiry = Expiry0} = Goods0 ->
			ID = 0, % idx:goods(),
			Seconds = util:seconds(),
			Expiry = init_expiry(ExpiryType, Expiry0, Seconds),
			Goods = Goods0#goods{id = ID, time = Seconds, expiry = Expiry},
			Goods;
		_ ->
			{?error, ?ERROR_GOODS_NOT_EXIST}
	end;

goods({GoodsId,Count})->
		case ?DATA_GOODS:get(GoodsId) of
		#goods{expiry_type = ExpiryType, expiry = Expiry0} = Goods0 ->
			ID = 0, % idx:goods(),
			Seconds = util:seconds(),
			Expiry = init_expiry(ExpiryType, Expiry0, Seconds),
			Goods = Goods0#goods{id = ID, count=Count,time = Seconds, expiry = Expiry},
			Goods;
		_ ->
			{?error, ?ERROR_GOODS_NOT_EXIST}
	end;
goods(Goods) when is_record(Goods,goods)->
	Goods;
goods(V) ->
	?MSG_ERROR("Error Goods : ~p~n", [V]),
	{?error, ?ERROR_GOODS_NOT_EXIST}.

%% 初始化有效期字段
init_expiry(ExpiryType, Expiry, Seconds) ->
	case ExpiryType of
		?CONST_EXPIRY_PERPETUITY ->
			0;
		_ ->
			case ExpiryType of
				?CONST_EXPIRY_ECOND ->
					Expiry + Seconds;
				_ ->
					86400 * Expiry + Seconds
			end
	end.


%% 获取物品数量??
%% GoodsList:[GoodsId|_]
get_goods_count(GoodsList)->
	Bag = role_api_dict:bag_get(),
	get_goods_count(Bag#bag.list,GoodsList,[]).

get_goods_count(_BagGoodsList,[],List)->List;
get_goods_count(BagGoodsList,[GoodsId|GoodsList],List)->
	Fun=fun(Goods,Count)
			 when is_record(Goods,goods) andalso Goods#goods.goods_id=:=GoodsId ->
				Goods#goods.count+Count;
		   (_, Count) ->
				Count
		end,
	GoodsCount=lists:foldl(Fun,0,BagGoodsList),
	List2=[{GoodsId,GoodsCount}|List],
	get_goods_count(BagGoodsList,GoodsList,List2).



%% 读取物品 return:{?true, #goods{}=Goods} | false
read(Bag, Idx) ->
	#bag{list = List} = Bag,
	case lists:keyfind(Idx, #goods.idx, List) of
		#goods{} = Goods ->
			{?true, Goods};
		?false ->
			?false
	end.

%% 过滤取出物品
%% return: {Bag,GoodsTakes,Bin}
take_filter(Bag, Pred) ->
	take_filter(Bag, Pred, ?CONST_TRUE).

take_filter(#bag{list = List} = Bag, Pred, Flag) ->
	{NewList,TakeList,BinMsg} = take_filter_inside(List, Pred, ?CONST_GOODS_CONTAINER_BAG, Flag),
	{Bag#bag{list = NewList},TakeList,BinMsg}.

%% return : {List, TakeList, BinMsg}
take_filter_inside(List, Pred, Type, Flag) ->	
	Fun = fun(Goods,{AccList,AccTake,AccBin}) ->
				  case Pred(Goods) of
					  ?true ->
						  AccBin2 = msg_remove(Type,0,[Goods#goods.idx]),
						  {AccList,[Goods|AccTake],<<AccBin/binary, AccBin2/binary>>};
					  ?false ->
						  {[Goods|AccList],AccTake,AccBin}
				  end
		  end,	
	{NewList, TakeList, Bin} = lists:foldr(Fun, {[],[],<<>>}, List),
	Bin2 = <<>>,
%% 	Bin2 = ?IF(Flag == ?CONST_FALSE, <<>>, logs_api:event_notice(?CONST_LOGS_TYPE_GOODS,?CONST_LOGS_DEL,logs_goods(TakeList))),
	{NewList,TakeList,<<Bin/binary, Bin2/binary>>}.


%% 取出固定索引物品??
% @spec return : {?ok, Player, Goods, Bin} | {?error, ErrorCode}
take(Player, Idx) ->
	take(Player, Idx, ?CONST_TRUE).

take(Player, Idx, Flag) ->
	Bag=role_api_dict:bag_get(),
	#bag{list = List} = Bag,
	case lists:keytake(Idx, #goods.idx, List) of
		{value, #goods{goods_id = Gid, count = Count}=Goods, List2} ->
			Bin = msg_remove(?CONST_GOODS_CONTAINER_BAG, 0, [Idx]),
			Bin2= <<>>,
%% 			Bin2 = ?IF(Flag==?CONST_FALSE, <<>>, logs_api:event_notice(?CONST_LOGS_TYPE_GOODS,?CONST_LOGS_DEL,[{Gid,Count}])),
			Bag2=Bag#bag{list=List2},
			role_api_dict:bag_set(Bag2),
			{?ok, Player, Goods, <<Bin/binary,Bin2/binary>>};                                                                                                                                                                                                                                        
		?false ->
			{?error, ?ERROR_GOODS_NOT_EXIST}
	end.

%% 取出固定索引物品??
% @spec return : {?ok, Bag, Goods, Bin} | {?error, ErrorCode}
goods_get_idx(_Bag,_Idx,Count,_Falg) when Count =< 0 -> 
	{?error, ?ERROR_BADARG};
goods_get_idx(Bag,Idx,Count,Falg)->
	#bag{list = List} = Bag,
	case lists:keytake(Idx, #goods.idx, List) of
		{value, #goods{goods_id = Gid,count=Count0}=Goods, List2} ->
			if
				Count0 > Count ->
					GoodsLeft = Goods#goods{count = Count0 - Count},
					Bin = msg_change(?CONST_GOODS_CONTAINER_BAG, 0, [GoodsLeft]),
					Bin2= <<>>,
%% 					Bin2=?IF(Falg==?CONST_FALSE,<<>>,logs_api:event_notice(?CONST_LOGS_TYPE_GOODS,?CONST_LOGS_DEL,[{Gid,Count}])),
					Bag2 = Bag#bag{list = [GoodsLeft|List2]},
					{?ok, Bag2,Goods#goods{count=Count}, <<Bin/binary,Bin2/binary>>};
				Count0 =:= Count ->
					Bin = msg_remove(?CONST_GOODS_CONTAINER_BAG, 0, [Idx]),
					Bin2= <<>>,
%% 					Bin2=?IF(Falg==?CONST_FALSE,<<>>,logs_api:event_notice(?CONST_LOGS_TYPE_GOODS,?CONST_LOGS_DEL,[{Gid,Count}])),
					Bag2 = Bag#bag{list = List2},
					{?ok, Bag2, Goods, <<Bin/binary,Bin2/binary>>};
				Count0 < Count ->
					{?error, ?ERROR_GOODS_LACK}
			end;
		?false ->
			{?error, ?ERROR_GOODS_NOT_EXIST}
	end.

take2(_Player, _Idx, Count) when Count =< 0 ->
	{?error, ?ERROR_BADARG};
take2(Player, Idx, Count) ->
	take2(Player, Idx, Count, ?CONST_TRUE).

take2(Player, Idx, Count, Flag) ->
	Bag=role_api_dict:bag_get(),
	#bag{list = List} = Bag,
	case lists:keytake(Idx, #goods.idx, List) of
		{value, #goods{goods_id = Gid,count=Count0}=Goods, List2} ->
			if
				Count0 > Count ->
					GoodsLeft = Goods#goods{count = Count0 - Count},
					Bin = msg_change(?CONST_GOODS_CONTAINER_BAG, 0, [GoodsLeft]),
					Bin2= <<>>,
%% 					Bin2 = ?IF(Flag==?CONST_FALSE, <<>>, logs_api:event_notice(?CONST_LOGS_TYPE_GOODS,?CONST_LOGS_DEL,[{Gid,Count}])),
					Bag2 = Bag#bag{list = [GoodsLeft|List2]},
					role_api_dict:bag_set(Bag2),
					{?ok, Player, Goods#goods{count=Count}, <<Bin/binary,Bin2/binary>>};
				Count0 =:= Count ->
					Bin = msg_remove(?CONST_GOODS_CONTAINER_BAG, 0, [Idx]),
					Bin2= <<>>,
%% 					Bin2 = ?IF(Flag==?CONST_FALSE, <<>>, logs_api:event_notice(?CONST_LOGS_TYPE_GOODS,?CONST_LOGS_DEL,[{Gid,Count}])),
					Bag2 = Bag#bag{list = List2},
					role_api_dict:bag_set(Bag2),
					{?ok, Player, Goods, <<Bin/binary,Bin2/binary>>};
				Count0 < Count ->
					{?error, ?ERROR_GOODS_LACK}
			end;
		?false ->
			{?error, ?ERROR_GOODS_NOT_EXIST}
	end.

%% 临时背包物品??
get_temp(Player, 0) ->
	Bag=role_api_dict:bag_get(),
	#bag{max = Max, list = List, temp = Temp} = Bag,
	case Temp == [] orelse erlang:length(List) >= Max of
		?true ->
			{?error, ?ERROR_BAG_DEPOT_NULL};
		?false ->
			case get_temp_all(Bag#bag{temp = []}, Temp) of
				{?ok, Bag2, BinMsg} ->
					role_api_dict:bag_set(Bag2),
					BinMsg0 = msg_remove(?CONST_GOODS_CONTAINER_DEPOT, 0, idxl(Temp)),
					{?ok, Player, <<BinMsg0/binary, BinMsg/binary>>};
				{?error, ErrorCode} ->
					{?error, ErrorCode}
			end
	end;


%% return : {?ok, Player2, Bin} | {?error, ErrorCode}
get_temp(Player, Idx) ->
	Bag=role_api_dict:bag_get(),
	#bag{max = Max, list = List, temp = Temp} = Bag,
	case length(List) of
		Max ->
			{?error, ?ERROR_BAG_FULL};
		_ ->
			case lists:keytake(Idx, #goods.idx, Temp) of
				{value, Goods, Temp2} ->
					case get_temp_one(Bag#bag{temp = Temp2}, Goods) of
						{?ok, Bag2, BinMsg} ->
							role_api_dict:bag_set(Bag2),
							BinMsg2 = msg_remove(?CONST_GOODS_CONTAINER_DEPOT, 0, [Idx]),
							{?ok, Player, <<BinMsg/binary,BinMsg2/binary>>};
						{?error, ErrorCode} ->
							{?error, ErrorCode}
					end;
				?false ->
					{?error, ?ERROR_GOODS_NOT_EXIST}
			end
	end.


%% 一键提取临时背包 return : {ok, Bag, BinMsg} | {?error, ErrorCode}
get_temp_all(Bag, TempList) ->
	get_temp_all(Bag, TempList, <<>>).

get_temp_all(Bag, [], BinMsg) ->
	{?ok, Bag, BinMsg};
get_temp_all(Bag, [Goods|List], BinMsg) ->
	case get_temp_one(Bag, Goods) of
		{?ok, Bag2, BinMsg2} ->
			get_temp_all(Bag2, List, <<BinMsg/binary, BinMsg2/binary>>);
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.
											   
											  

%% 提取临时背包 return : {ok, Bag, BinMsg} | {?error, ErrorCode}
get_temp_one(#bag{list = List, max = Max} = Bag, #goods{goods_id = GoodsId, count = Count, stack = Stack} = Goods) ->
	case erlang:length(List) < Max orelse Count < Stack of
		?true ->
			{NewBag, NewGoods, BinMsg} = 
				case get_lack(Bag,GoodsId) of
					{?true, Bag2, #goods{count = CountLack} = GoodsLack, Bin} ->
						{Bag2, GoodsLack#goods{count = CountLack + Count}, Bin};
					?false ->
						{Bag, Goods, <<>>}
				end,
			GoodsList = one2list(NewGoods),
			case get_idx(idxl(NewBag#bag.list), Max, length(GoodsList)) of
				{?true, IdxList} ->
					GoodsList2 = lists:zipwith(fun(X,Y) -> X#goods{idx = Y} end, GoodsList, IdxList),
					BinMsg2 = msg_change(?CONST_GOODS_CONTAINER_BAG, 0, GoodsList2),
					NewBag2 = NewBag#bag{list = NewBag#bag.list ++ GoodsList2},
					{?ok, NewBag2, <<BinMsg/binary,BinMsg2/binary>>};
				{?false, _}->
					{?error, ?ERROR_BAG_FULL}
			end;
		?false ->
			{?error, ?ERROR_BAG_FULL}
	end.

%% 请求装备 return : {?ok, Equip} | {?error, ErrorCode}
equip_ask(#player{uid = Uidme,socket=Socket}=Player, Uid, PartnerId) ->
	case Uidme of
		Uid ->
			equip_ask_cb(Player,{Socket,PartnerId,?true});
		_ ->
			case role_api:mpid(Uid) of
				Pid when is_pid(Pid)->
					util:pid_send(Uid,?MODULE,equip_ask_cb,{Socket,PartnerId,?true});
				_->
					case role_api_dict:player_get(Uid) of
						{?ok,Player2}->
							equip_ask_cb(Player2,{Socket,PartnerId,?false});
						_->
							BinMsg=system_api:msg_error(?ERROR_USER_OFF_LINE),
							app_msg:send(Socket,BinMsg)
					end
			end
	end.
equip_ask_cb(Player=#player{uid=Uid},{Socket,PartnerId,Falg})->
	BinMsg=case case Falg of
					?true->
						Inn=role_api_dict:inn_get(),
						Equip=role_api_dict:equip_get(),
						get_equip(Equip, Inn, PartnerId);
					_->
						case role_api_dict:equip_get(Uid) of
							{?ok,NEquip} when is_list(NEquip)->
								case role_api_dict:inn_get(Uid) of
									{?ok,NInn} when is_record(NInn,inn)->
										get_equip(NEquip, NInn, PartnerId);
									_->?skip
								end;
							_->
								?skip
						end
				end of
			   {?ok,Equip2}->
				   bag_api:msg_equip_back(Uid,PartnerId,Equip2);
			   _->
				   system_api:msg_error(?ERROR_USER_OFF_LINE)
		   end,
	app_msg:send(Socket,BinMsg),
	Player.

%% %% 请求装备
%% equip_ask_cb(#player{inn = Inn,equip = Equip} = Player, {From,Ref,[PartnerId]}) ->
%% 	Reply = get_equip(Equip, Inn, PartnerId),
%% 	role_api:progress_receive(From,Ref,Reply),
%% 	Player;
%% equip_ask_cb(Player, {_From, _Ref, _}) ->
%% 	Player.

%% 请求装备
get_equip(Equip, Inn, PartnerId) ->
	case PartnerId of
		0 ->
			{?ok, Equip};
		_ ->
			#inn{partners = Partners} = Inn,
			case lists:keyfind(PartnerId, #partner.partner_id, Partners) of
				#partner{equip = EquipP} ->
					{?ok, EquipP};
				?false ->
					{?error, ?ERROR_INN_NO_PARTNER}
			end
	end.

%% 请求武器
get_weapon([]) -> [];
get_weapon([#goods{type_sub = Typesub} = Goods|L]) ->
	case lists:member(Typesub, ?EQUIP_WEAPON_TYPES) of
		?true ->
			Goods;
		?false ->
			get_weapon(L)
	end.

%%装备评分 return: new Equip
score_equip(#goods{exts = Exts} = Goods) when is_record(Exts, g_eq) ->
	{Powerful, PearlScore} = score_calc(Goods),
	Exts2 = Exts#g_eq{powerful = trunc(Powerful), pearl_score = trunc(PearlScore)},
	Goods#goods{exts = Exts2};
score_equip(Goods) ->
	Goods.

%% 评分??
score_calc(_Goods) ->
	{1000,0}.



%% 装备评分?? return: {ScEquip,ScPearl,ScJewe,ScMagic}
score_attr(GoodsList) -> 
	Acc0 = {0,0,0,0},
	Fun = fun(#goods{type=?CONST_GOODS_EQUIP}=Goods,{ScEquip,ScPearl,ScJewe,ScMagic}) ->
				  {Powerful, PearlScore} = score_calc(Goods),
				  {ScEquip+Powerful,ScPearl+PearlScore,ScJewe,ScMagic};
%% 			 (#goods{type=?CONST_GOODS_JEWELRY}=Goods,{ScEquip,ScPearl,ScJewe,ScMagic}) ->
%% 				  {Powerful, _PearlScore} = score_calc(Goods),
%% 				  {ScEquip,ScPearl,ScJewe+Powerful,ScMagic};
%% 			 (#goods{type=?CONST_GOODS_MAGIC}=Goods,{ScEquip,ScPearl,ScJewe,ScMagic}) ->
%% 				  {Powerful, _PearlScore} = score_calc(Goods),
%% 				  {ScEquip,ScPearl,ScJewe,ScMagic+Powerful};
			 (_, Acc) ->
				  Acc
		  end,
	T = lists:foldl(Fun, Acc0, GoodsList),
	L = lists:map(fun(N) -> trunc(N) end, tuple_to_list(T)),
	list_to_tuple(L).

%% 请求商店 return : {?ok, Binmsg | {?error, ErrorCode}
ask_shop(NpcID) ->
	case data_scene_shop:get(NpcID) of
		{_, PriceType, L} ->
			BinMsg = msg_shop_back(PriceType,L),
			{?ok, BinMsg};
		_ ->
			{?error, ?ERROR_BIZ_ABILITY_NULL}
	end.

%% 购买物品 return : {?ok, Player, BinMsg} | {?error, ErrorCode}
buy_shop(Player=#player{uid=Uid},NpcID,GoodsId,Count) ->
	Bag=role_api_dict:bag_get(),
	case NpcID of
		0->
			ok;
		_->
			case data_scene_shop:get(NpcID) of
				{_, PriceType, L} ->
					case find_shop_goods(GoodsId, L) of
						?null ->
							{?error, ?ERROR_GOODS_NOT_EXIST};
						{Give, Price} ->
							case goods(Give) of
								#goods{} = Goods ->
									case role_api:currency_cut([buy_shop,[],<<"购买商店物品">>],Player, [{PriceType, Price}]) of
										{?ok, Player2, BinMsg} ->
											case goods_set([buy_shop,[],<<"购买商店物品">>],Player2,Bag, [Goods#goods{count = Count}]) of
												{?ok, Player3,Bag2,GoodsBin,BinMsg2} ->
													BinMsg3 = msg_shop_buy_ok(),
													role_api_dict:bag_set(Bag2),
													{?ok, Player3, <<BinMsg/binary,GoodsBin/binary,BinMsg2/binary,BinMsg3/binary>>};
												{?error, ErrorCode} ->
													{?error, ErrorCode}
											end;
										{?error, ErrorCode} ->
											{?error, ErrorCode}
									end;
								_ ->
									{?error, ?ERROR_UNKNOWN}
							end
					end;
				_ ->
					{?error, ?ERROR_BIZ_ABILITY_NULL}
			end
	end.

find_shop_goods(_GoodsId, []) ->
	null;
find_shop_goods(GoodsId, [{#give{goods_id=GoodsId} = Give,Price}|_L]) ->
	{Give, Price};
find_shop_goods(GoodsId, [_|L]) ->
	find_shop_goods(GoodsId, L).






%% 检查背包是否已满 return: bool
check_full(#bag{list = List, max = Max, temp = Temp}) ->
	length(List) >= Max andalso length(Temp) >= ?CONST_GOODS_TEMP_BAG.

%% 获取剩余量?? return : {?true, Bag, Goods, Bin} | false
get_lack(Bag,GoodsId) ->
	Pred = fun(#goods{goods_id=GoodsId0,count=Count,stack=Stack}) ->
				   GoodsId0 == GoodsId andalso Count =/= Stack
		   end,
	
	{Bag2,GoodsTakes,Bin} = take_filter(Bag, Pred, ?CONST_FALSE),
	case GoodsTakes of
		[Goods|_] ->
			CountSum = lists:sum([Count0||#goods{count=Count0} <- GoodsTakes]),
			{?true, Bag2, Goods#goods{count=CountSum}, Bin};
		[] ->
			?false
	end.


%% 索引列表
idxl(GoodsList) ->
	[Idx||#goods{idx=Idx} <- GoodsList].

%% return: {?true, IdxList} | {?false, IdxList}
get_idx(IdxList,Max,Count) ->
	L = lists:seq(1, Max),
	get_idx(IdxList, L, Count, []).

get_idx(_IdxList, [], _Count, IdxAcc) ->
	{?false, IdxAcc};
get_idx(IdxList, [Idx|L], Count, IdxAcc) ->
	case lists:member(Idx, IdxList) of
		?true ->
			get_idx(IdxList, L, Count, IdxAcc);
		?false ->
			IdxAcc2 = [Idx|IdxAcc],
			case length(IdxAcc2) >= Count of
				?true ->
					{?true, IdxAcc2};
				?false ->
					get_idx(IdxList, L, Count, IdxAcc2)
			end
	end.

%% 随机物品key
key_odds(Type, GoodsID) ->
	{Type, GoodsID}.

%%检查随机物品??
check_odds_goods(_Type, 0, _Day, _GoodsID, _Count0) ->
	?CONST_TRUE;
check_odds_goods(Type, Max, Day, GoodsID, Count0) ->
	Key = key_odds(Type, GoodsID),
	Seconds0 = util:seconds(),
	case ets:lookup(?ETS_GOODS_OUTPUT_MAX, Key) of
		[] ->
			ets:insert(?ETS_GOODS_OUTPUT_MAX, {Key, 1, Seconds0}),
			?CONST_TRUE;
		[{Key, Count, Seconds}|_] ->
			case util:diff_days_new(Seconds, Seconds0) > Day of
				?true ->
					ets:insert(?ETS_GOODS_OUTPUT_MAX, {Key, 1, Seconds0}),
					?CONST_TRUE;
				?false ->
					case Max < (NewCount = Count0 + Count) of
						?true ->
							?CONST_FALSE;
						?false ->
							ets:insert(?ETS_GOODS_OUTPUT_MAX, {Key, NewCount, Seconds0}),
							?CONST_TRUE
					end
			end
	end.


attr_base(AttrBaseValue,StrenVAttr)->
	Fun = fun({T, V}, A) ->
				  case lists:keyfind(T, 1, ?ATTR_TYPE_POS) of
					  {_, Index} ->
						  setelement(Index, A, V + element(Index, A));
					  ?false ->
						  A
				  end
		  end,
	FAttr=lists:foldl(Fun,#attr{},AttrBaseValue),
	FAttr2=role_api:attr_sum(FAttr,[StrenVAttr]),
	Type2=[TT||{TT,_VV}<-AttrBaseValue],
	F=fun(TTT,Acc)->
			  case lists:keyfind(TTT, 1, ?ATTR_TYPE_POS) of
					  {_, Index} ->
						  VV=element(Index,FAttr2),
						  [{TTT,VV}|Acc];
					  ?false ->
						  Acc
				  end 
	  end,
	lists:foldl(F,[],Type2).


%% 列表?? return : GoodsList :: [#goods{}=Goods|_]
one2list(GoodsList) when is_list(GoodsList) ->
	lists:foldl(fun(Goods, Acc) ->
						Acc ++ one2list(Goods)
				end, [], GoodsList);
%% 	lists:merge([ one2list(Goods) || Goods <- GoodsList]);
one2list(#goods{count=Count,stack=Stack}=Goods) ->
	if
		Count >= Stack ->
			N = Count div Stack,
			L = lists:duplicate(N, Goods#goods{count=Stack}),
			case Count rem Stack of
				0 ->
					L;
				Rem ->
					L ++ [Goods#goods{count=Rem}]
			end;
		?true ->
			[Goods]
	end;
one2list(Err) ->
	?MSG_ERROR("Err Goods Data : ~w~n", [Err]),
	[].

%% 检查背包 return : true ?·2??? | false ??a???
check_bag() ->
	Bag=role_api_dict:bag_get(),
	erlang:length(Bag#bag.list) =:= Bag#bag.max.

check_bag(Bag) ->
	erlang:length(Bag#bag.list) =:= Bag#bag.max.

check_bag(Bag, Count) ->
	Left = erlang:abs(Bag#bag.max - erlang:length(Bag#bag.list)),
	Left >= Count.

check_bag_goods(GoodsList)->
	GoodsList2=[goods(Goods)||Goods <- GoodsList],
	Bag=role_api_dict:bag_get(),
	BagUseCount=bag_use(Bag#bag.list,GoodsList2),
	Left = erlang:abs(Bag#bag.max - erlang:length(Bag#bag.list)),
	?IF(Left>=BagUseCount,?true,{?error,?ERROR_BAG_FULL}).

%% rand_odds
%% return : [#goods{}|_] | []
rand_odds([], Acc) ->
	Acc;
rand_odds(OddsList, Acc) ->
	case util:odds_list(OddsList) of
		?null ->
			Acc;
		{Give = #give{goods_id = GoodsID}, {Max, Day}} ->
			%%?ODDS_GOODS_MAX_GIFT
			case check_odds_goods(100, Max, Day, GoodsID, 1) of 
				?CONST_TRUE ->
					case goods(Give) of
						#goods{} = Goods ->
							[Goods|Acc];
						_ ->
							Acc
					end;
				?CONST_FALSE ->
					rand_odds(lists:keydelete(Give, 1, OddsList), Acc)
			end;
		Err ->
			?MSG_ERROR("ERror Data : ~w~n", [Err]),
			Acc
	end.

%% 一键互换 return : {ok, Player, BinMsg} | {error, ErrorCode}
swap_click(#player{uid = Uid} = Player, ID1, ID2) ->
	case swap_get(Player, ID1) of
		?null ->
			{?error, ?ERROR_BADARG};
		{Equip1, UnameColor} ->
			case swap_get(Player, ID2) of
				?null ->
					{?error, ?ERROR_BADARG};
				{Equip2, Info2} ->
					{EquipN1,EquipN2,IdxS} = swap_click2(ID1, UnameColor, Equip1, ID2, Info2, Equip2),
					{EquipNN2,EquipNN1,_IdxL} = swap_click2(ID2, Info2, EquipN2, ID1, UnameColor, EquipN1, [],[],IdxS),
					{EquipNNN1,EquipNNN2} = swap_weapon(ID1, UnameColor, EquipNN1, ID2, Info2, EquipNN2),
					case swap_set(Player, ID1, EquipNNN1) of
						{?ok, Player2} ->
							case swap_set(Player2, ID2, EquipNNN2) of
								{?ok, Player3} ->
									{?ok, EquipF1} = equip_ask(Player3, Uid, ID1),
									{?ok, EquipF2} = equip_ask(Player3, Uid, ID2),
									BinaryMsg1 = msg_equip_back(Uid,ID1,EquipF1),
									BinaryMsg2 = msg_equip_back(Uid,ID2,EquipF2),
									BinOK = msg_swap_ok(),
									BinAll = <<BinaryMsg1/binary, BinaryMsg2/binary, BinOK/binary>>,
									Player4 = make_api:refresh_attr(?CONST_GOODS_CONTAINER_EQUIP, ID1, Player3),
									Player5 = make_api:refresh_attr(?CONST_GOODS_CONTAINER_EQUIP, ID2, Player4),
									{?ok, Player5, BinAll};
								{?error, ErrorCode} ->
									{?error, ErrorCode}
							end;
						{?error, ErrorCode} ->
							{?error, ErrorCode}
					end
			end
	end.

swap_click2(ID1, Info1, Equip1, ID2, Info2, Equip2) ->
	swap_click2(ID1, Info1, Equip1, ID2, Info2, Equip2, [], [], []).

swap_click2(_ID1, _Info1, [], _ID2, _Info2, Equip2, Acc, IdxS, _IdxCheck) ->
	{Acc, Equip2, IdxS};
swap_click2(ID1, Info1, [#goods{type_sub = Idx} = Goods|Equip1], ID2, Info2, Equip2, Acc, IdxS, IdxCheck) ->
	case lists:member(Idx, ?EQUIP_WEAPON_TYPES) of
		?false ->
			case lists:member(Idx, IdxCheck) of
				?false ->
					case lists:keytake(Idx, #goods.idx, Equip2) of
						{value, Goods2, NewEquip2} ->
							case ?ok == goods_use_check(Info1, Goods2) andalso ?ok == goods_use_check(Info2, Goods) 
									 andalso ?ok == magic_check(Goods2#goods.type, Info1, ID1, Goods2#goods.name_color) 
									 andalso ?ok == magic_check(Goods#goods.type, Info2, ID2, Goods#goods.name_color) of
								?true ->
									swap_click2(ID1, Info1, Equip1, ID2, Info2, [Goods|NewEquip2], [Goods2|Acc], [Idx|IdxS], IdxCheck);
								?false ->
									swap_click2(ID1, Info1, Equip1, ID2, Info2, Equip2, [Goods|Acc], IdxS, IdxCheck)
							end;
						?false ->
							case ?ok == goods_use_check(Info2, Goods) andalso ?ok == magic_check(Goods#goods.type, Info2, ID2, Goods#goods.name_color) of
								?true ->
									swap_click2(ID1, Info1, Equip1, ID2, Info2, [Goods|Equip2], Acc, [Idx|IdxS], IdxCheck);
								?false ->
									swap_click2(ID1, Info1, Equip1, ID2, Info2, Equip2, [Goods|Acc], IdxS, IdxCheck)
							end
					end;
				?true ->
					swap_click2(ID1, Info1, Equip1, ID2, Info2, Equip2, [Goods|Acc], IdxS, IdxCheck)
			end;
		?true ->
			swap_click2(ID1, Info1, Equip1, ID2, Info2, Equip2, [Goods|Acc], IdxS, IdxCheck)
	end.

swap_weapon(ID1, Info1, Equip1, ID2, Info2, Equip2) ->
	case get_weapon(Equip1) of
		[] ->
			case get_weapon(Equip2) of
				[] ->
					{Equip1, Equip2};
				#goods{} = Goods ->
					case ?ok == goods_use_check(Info1, Goods) andalso ?ok == magic_check(Goods#goods.type, Info1, ID1, Goods#goods.name_color) of
						?true ->
							{[Goods|Equip1], lists:delete(Goods, Equip2)};
						?false ->
							{Equip1, Equip2}
					end
			end;
		#goods{} = Goods ->
			case get_weapon(Equip2) of
				[] ->
					case ?ok == goods_use_check(Info2, Goods) andalso ?ok == magic_check(Goods#goods.type, Info2, ID2, Goods#goods.name_color) of
						?true ->
							{lists:delete(Goods, Equip1), [Goods|Equip2]};
						_ ->
							{Equip1, Equip2}
					end;
				#goods{} = Goods2->
					case ?ok == goods_use_check(Info1, Goods2) andalso ?ok == goods_use_check(Info2, Goods)
							 andalso ?ok == magic_check(Goods2#goods.type, Info1, ID1, Goods2#goods.name_color) 
							 andalso ?ok == magic_check(Goods#goods.type, Info2, ID2, Goods#goods.name_color) of								
						?true ->
							{[Goods2|lists:delete(Goods, Equip1)], [Goods|lists:delete(Goods2, Equip2)]};
						?false ->
							{Equip1, Equip2}
					end
			end 
	end.

swap_get(Player, ID) ->
	case ID of
		0 ->
			Equip=role_api_dict:equip_get(),
			{Equip, Player#player.uname_color};
		_ ->
			Inn = role_api_dict:inn_get(),
			Partners = Inn#inn.partners,
			case lists:keyfind(ID, #partner.partner_id, Partners) of
				#partner{equip = Equip} = Partner ->
					{Equip, Partner};
				?false ->
					?null
			end
	end.

swap_set(Player,ID,Equip) ->
	case ID of
		0 ->
			role_api_dict:equip_set(Equip),
			{?ok, Player};
		_ ->
			Inn = role_api_dict:inn_get(),
			Partners = Inn#inn.partners,
			case lists:keytake(ID, #partner.partner_id, Partners) of
				{value, Partner, Partners2} ->
					Inn2 = Inn#inn{partners = [Partner#partner{equip = Equip}|Partners2]},
					role_api_dict:inn_set(Inn2),
					{?ok, Player};
				?false ->
					{?error, ?ERROR_BADARG}
			end
	end.


%% check_temp return: Player
check_temp(Player, []) ->
	case role_api_dict:bag_get() of
		Bag when is_record(Bag, bag)->
			case Bag#bag.temp of
				[] ->
					Player;
				Temp ->
					Seconds = util:seconds(),
					{Temp2, IdxL} = lists:foldl(fun(#goods{idx = Idx, time = Time} = Goods, {TempAcc, IdxAcc}) ->
														case Time =/= 0 andalso Seconds - Time > ?CONST_BAG_TEMP_EXPIRY of
															?true ->
																{TempAcc, [Idx|IdxAcc]};
															?false ->
																{[Goods|TempAcc], IdxAcc}
														end
												end, {[], []}, Temp),
					Bag2 = Bag#bag{temp = Temp2},
					case IdxL of
						[] ->
							?skip;
						_ ->
							BinMsg = msg_remove(?CONST_GOODS_CONTAINER_DEPOT, 0, IdxL),
							app_msg:send(Player#player.socket, BinMsg)
					end,
					role_api_dict:bag_set(Bag2),
					Player
			end;
		_->
			Player
	end.

	
%% 物品日志优化,合并数量 return : GidCountList
%% logs_goods
logs_goods(GoodsList0) ->
	GoodsList = logs_goods_sort(GoodsList0),
	Fun = fun(#goods{goods_id = Gid, count = Count}, Acc) ->
				  case lists:keytake(Gid, 1, Acc) of
					  {value, {Gid, Count0}, Acc2} ->
						  [{Gid, Count0 + Count}|Acc2];
					  ?false ->
						  [{Gid, Count}|Acc]
				  end;
			 ({Gid,Count},Acc) ->
				  case lists:keytake(Gid, 1, Acc) of
					  {value, {Gid, Count0}, Acc2} ->
						  [{Gid, Count0 + Count}|Acc2];
					  ?false ->
						  [{Gid, Count}|Acc]
				  end;
			 (Err, Acc) ->
				  ?MSG_ERROR("Err : ~p~n", [Err]),
				  Acc
		  end,
	lists:foldl(Fun, [], GoodsList).

logs_goods_sort([#goods{}|_]=GoodsList) ->
	lists:keysort(#goods.goods_id, GoodsList);
logs_goods_sort([{_,_}|_]=GoodsList) ->
	lists:keysort(1, GoodsList);
logs_goods_sort(GoodsList) ->
	GoodsList.

%% 活动 掉落数据配制
%% 返回: 真正掉落的[#give{},...] 列表 可能是多个 也可以是空
activity_state_give(Gives)->
	case Gives of
		[] -> 
			[];
		_  -> 
			Activitys  = ets:lookup_element(?ETS_S_CONFIG, activity_state, 2),
			activity_state_give(Gives,Activitys,[])
	end.
activity_state_give([],_Activitys,RsGives)->
	RsGives;
activity_state_give([Give|Gives],Activitys,RsGives)->
	GoodsId    = Give#give.goods_id,
	GoodsIds2  = [ data_activity_flop_config:flop(GoodsId) | [ data_activity_flop_config:get(GoodsId,ActivityId) || ActivityId <- Activitys] ],
	case [ #give{goods_id=GoodsId2,
			count=Give#give.count,
			streng=Give#give.streng,
			name_color=Give#give.name_color, 
			bind=Give#give.bind,
			expiry_type=Give#give.expiry_type,
			expiry=Give#give.expiry} || GoodsId2 <- GoodsIds2,GoodsId2 > 0] of
		[] ->
			activity_state_give(Gives,Activitys,RsGives);
		RsGives2 ->
			activity_state_give(Gives,Activitys,RsGives2++RsGives)
	end.
		

%% 活动 状态
activity_state_init()->
	List  = data_activity_state:get(),
	Now   = util:seconds(),
	Activitys  = [ ActivityId ||  {ActivityId,B,E} <- List,B < Now andalso B /= 0,E > Now orelse E == 0],
	ets:insert(?ETS_S_CONFIG, {activity_state,Activitys}),
	?ok.


change_skill(Uid, ID, StrenLv, Skill) ->
	role_api:progress_callback(Uid, ?MODULE, change_skill_cb, [ID, StrenLv, Skill]).
	

change_skill_cb2(List, Pred, Skill) ->
	change_skill_cb2(List, Pred, Skill, []).

change_skill_cb2([], _Pred, _Skill, _Acc) ->
	?false;
change_skill_cb2([Goods=#goods{exts=Exts}|List], Pred, Skill, Acc) ->
	case Pred(Goods) of
		?true ->
			Goods2 = Goods#goods{exts=Exts#g_eq{wskill_id=Skill}},
			List2 = [Goods2|List] ++ Acc,
			BinMsg = msg_change(?CONST_GOODS_CONTAINER_BAG,0,[Goods2]),
			{?true, List2, BinMsg};
		?false ->
			change_skill_cb2(List, Pred, Skill, [Goods|Acc])
	end.
	
	
%% clear_up
clear_up(#bag{list = List} = Bag) ->
	List2 = clear_up(List),
	Bag#bag{list = List2};

clear_up(List) ->
	clear_up(List, []).

clear_up([], Acc) ->
	Acc;
clear_up([#goods{goods_id = Gid, exts = Exts, count = Count, stack = Stack, expiry = Expiry} = Goods|List], Acc) ->
	if
		Stack =< 1 orelse erlang:is_record(Exts, g_eq) orelse Stack =:= Count orelse Expiry /= 0 ->
			clear_up(List, [Goods|Acc]);
		?true ->
			Pred = fun(#goods{goods_id = GoodsId, count = Countp, stack = Stackp}) ->
						   GoodsId =:= Gid andalso Countp /= Stackp;
					  (_Skip) ->
						   ?false
				   end,
			case lists:filter(Pred, Acc) of
				[#goods{count = Count0} = GoodsAcc] ->
					Acc2 = lists:delete(GoodsAcc, Acc) ++ one2list(GoodsAcc#goods{count = Count0 + Count}),
					clear_up(List, Acc2);
				_ ->
					clear_up(List, [Goods|Acc])
			end
	end.

decode_sell(<<GoodsCount:16/big-integer-unsigned,Binary/binary>>) ->
	case GoodsCount of
		0->[];
		_->
			decode_sell(Binary,GoodsCount,[])
	end.

decode_sell(_, 0, Acc) ->Acc;
decode_sell(<<Idx:16/big-integer-unsigned,Count:16/big-integer-unsigned,Binary/binary>>, GoodsCount, Acc) ->
	?MSG_ECHO("=========== ~w~n",[{Idx,Count}]),
	decode_sell(Binary, GoodsCount - 1, [{Idx,Count}|Acc]).
%%
%% Local Functions
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% msg_xxxx?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 物品信息块?? [2001]
msg_goods(Goods) when is_record(Goods,goods)->
	#goods{idx=Index,goods_id=GoodsId,count=Count,expiry=Expiry,type=GoodsType,time=Time,price=Price,exts=Exts}=Goods,
	RsList =app_msg:encode([{?bool,?true},{?int16u,Index},{?int16u,GoodsId},{?int16u,Count},
							{?int32u,Expiry},{?int32u,Time},{?int32u,Price},{?int8u,GoodsType}]),	
	RsList2=msg_exts(GoodsType,Exts),
	<<RsList/binary,RsList2/binary>>;

msg_goods(_) ->
	<<>>.

msg_exts(_GoodsType,Exts) when is_record(Exts,g_eq)->
	#g_eq{suit_id=SuitId,wskill_id=WskillId,streng=Strengthen,streng_v=StrenVAttr,slots=Slots,
		  attr_base_type=AttrBaseTypeValue,plus=Plus,enchant=Enchant,enchant_value=EnchantV}=Exts,
	PlusCount =length(Plus),
	AttrBaseList=attr_base(AttrBaseTypeValue, StrenVAttr),
	AttrBaseCount=length(AttrBaseList),
	RsList =app_msg:encode([{?int32u,10000},{?int32u,0},{?int16u,SuitId},{?int16u,WskillId},{?int16u,AttrBaseCount}]),
	AttrBaseFun=fun({T,V},AttrAcc)->
					AttrAcc2=app_msg:encode([{?int16u,T},{?int32u,V}]),
					<<AttrAcc/binary,AttrAcc2/binary>>
				end,			
	RsList2=lists:foldl(AttrBaseFun,RsList,AttrBaseList),
	RsList3=app_msg:encode([{?int8u,Strengthen},{?int16u,PlusCount}]),
	RsList4= <<RsList2/binary,RsList3/binary>>,
	Fun=fun({PlusType,PlusColour,PlusCurrent,PlusMax},Acc)->
				Acc2=app_msg:encode([{?int8u,PlusType},{?int8u,PlusColour},
									 {?int16u,PlusCurrent},{?int16u,PlusMax}]),
				<<Acc/binary,Acc2/binary>>
		end,
	RsList5=lists:foldl(Fun,RsList4,Plus),
	SlotsCount=length(Slots),
	RsList6=app_msg:encode([{?int16u,SlotsCount}]),
	Fun2=fun({_,0,0},Acc3) ->
				 Bin=app_msg:encode([{?bool, ?false}]),
				 <<Acc3/binary,Bin/binary>>;
			({_Type,PearlId,TypeValueL},Acc3)->
				 BinI1 = app_msg:encode([{?bool, ?true},{?int16u, PearlId},{?int16u, length(TypeValueL)}]),
				 BinI2 = iolist_to_binary([app_msg:encode([{?int8u, TypeI},{?int32u, ValueI}])|| {TypeI, ValueI} <- TypeValueL]),
				 <<Acc3/binary,BinI1/binary,BinI2/binary>>
		 end,
	RsList7=lists:foldl(Fun2, <<RsList5/binary,RsList6/binary>>,Slots),
	RsList8=app_msg:encode([{?int8u,Enchant},{?int32u,EnchantV}]),
	<<RsList7/binary,RsList8/binary>>;
%% msg_exts(?CONST_GOODS_STERS,None) when is_record(None,g_none) ->
%% 	#g_none{as4 = TVL} = None,
%% 	Acc0 = app_msg:encode([{?int16u, length(TVL)}]),
%% 	lists:foldl(fun({Type, Value}, Acc) ->
%% 						Acc2 = app_msg:encode([{?int8u, Type},{?int32u, Value}]),
%% 						<<Acc/binary, Acc2/binary>>
%% 				end, Acc0, TVL);
msg_exts(_GoodsType,None) when is_record(None,g_none) ->
	app_msg:encode([{?int32u,None#g_none.ad1},
					{?int32u,None#g_none.ad2},
					{?int32u,None#g_none.ad3},
					{?int32u,None#g_none.ad4}]).

% 背包返回 [2020]
msg_reverse(Uid,Type,Maximum,GoodsList)->
	RsList = app_msg:encode([{?int32u,Uid},{?int8u,Type},{?int16u,Maximum},
							 {?int16u,length(GoodsList)}]),
	Fun=fun(Goods,Acc) when is_record(Goods,goods)->
				Acc2 = msg_goods(Goods),
				<<Acc/binary,Acc2/binary>>
		end,
	RsList2= lists:foldl(Fun,RsList,GoodsList),
	app_msg:msg(?P_GOODS_REVERSE,RsList2).

% 消除物品 [2040]
msg_remove(_Type,_Id,[])->
	<<>>;
msg_remove(Type,Id,IndexL)->
	Acc0 = app_msg:encode([{?int8u,Type},{?int32u,Id},{?int16u,length(IndexL)}]),
	BinData = lists:foldl(fun(Idx, Acc) ->
								  Acc2 = app_msg:encode([{?int16u, Idx}]),
								  <<Acc/binary,Acc2/binary>>
						  end, Acc0, IndexL),
	app_msg:msg(?P_GOODS_REMOVE, BinData).

% 得到物品 [2050]
msg_change(_Type,_Id,[])-><<>>;
msg_change(Type,Id,GoodsList)->
	RsList = app_msg:encode([{?int8u,Type},{?int32u,Id},{?int16u,length(GoodsList)}]),
	Fun=fun(Goods,Acc) when is_record(Goods,goods)->
				Acc2 = msg_goods(Goods),
				<<Acc/binary,Acc2/binary>>
		end,
	RsList2= lists:foldl(Fun,RsList,GoodsList),
	app_msg:msg(?P_GOODS_CHANGE, RsList2).

% [2060]
msg_change_notice(Switchs,Type,GoodsList)->
	Fun=fun({GoodsId,GoodsCount},Acc)->
				BinMsg=app_msg:encode([{?int32u,GoodsId},{?int16u,GoodsCount}]),
				<<Acc/binary,BinMsg/binary>>
		end,
	RsList=lists:foldl(Fun,app_msg:encode([{?bool,Switchs},{?int8u,Type},{?int16u,length(GoodsList)}]),GoodsList),
	app_msg:msg(?P_GOODS_CHANGE_NOTICE, RsList). 


% 扩充消耗?? [2227]
msg_enlarge_cost(GoodsId,Count,EnlarghC)->
	RsList = app_msg:encode([{?int32u,GoodsId},{?int16u,Count},{?int16u,EnlarghC}]),
	app_msg:msg(?P_GOODS_ENLARGE_COST, RsList).

% 背包扩充 [2230]
msg_enlarge(Max)->
	app_msg:msg(?P_GOODS_ENLARGE,app_msg:encode([{?int16u, Max}])).

%% 装备信息返回 [2242]??
msg_equip_back(Uid,Partner,Equip) ->
	Acc0 = app_msg:encode([{?int32u,Uid},{?int32u,Partner},{?int16u, length(Equip)}]),
	Bin = lists:foldl(fun(#goods{}=Goods,Acc) ->
							  Acc2 = msg_goods(Goods),
							  <<Acc/binary,Acc2/binary>>
					  end, Acc0, Equip),
	app_msg:msg(?P_GOODS_EQUIP_BACK,Bin).


% 出售成功 [2262]
msg_sell_ok()->
	app_msg:msg(?P_GOODS_SELL_OK,<<>>).

% 一键互换成功 [2272]
msg_swap_ok()->
	app_msg:msg(?P_GOODS_SWAP_OK,<<>>).

% 商店数据返回 [2310]
msg_shop_back(PriceType,L)->
	RsList = app_msg:encode([{?int8u,PriceType},{?int16u,length(L)}]),
	RsList2 = iolist_to_binary([app_msg:encode([{?int32u, Gid}, {?int32u, Price}])|| {#give{goods_id = Gid},Price} <- L]),
	app_msg:msg(?P_GOODS_SHOP_BACK, <<RsList/binary,RsList2/binary>>).

% 购买成功?? [2321]
msg_shop_buy_ok()->
	app_msg:msg(?P_GOODS_SHOP_BUY_OK,<<>>).


% 元宵节活动将会获得的物品索引(0~11) [2327]
msg_lantern_index(Index)->
    RsList = app_msg:encode([{?int8u,Index}]),
    app_msg:msg(?P_GOODS_LANTERN_INDEX, RsList).


% 元宵活动数据返回 [2331]
msg_lantern_back({GoodsId, CountUse,T,V,Idx,Sum}, Logs, GiveList)->
	RsList1 = msg_times_xxx1(GoodsId,CountUse,T,V,Idx,Sum),
	msg_lantern_back2(RsList1, Logs, GiveList).

msg_lantern_back2(RsList1, Logs, GiveList) ->
	Len2 = erlang:length(Logs),
	Acc2 = app_msg:encode([{?int16u, Len2}]),
	Fun2 = fun(#times_goods_logs{uid=Uid, name=Name, name_color=NameColor, gid_use=GidUse, count_use=CountUse, 
								 gid_get=GidGet, count_get=CountGet, seconds=Seconds}, Acc) ->
				   Acc22 = msg_times_xxx2(Uid,Name,NameColor,GidUse,CountUse,GidGet,CountGet,Seconds),
				   <<Acc/binary,Acc22/binary>>
		   end,
	RsList2 = lists:foldl(Fun2, Acc2, Logs),
	msg_lantern_back3(<<RsList1/binary,RsList2/binary>>, GiveList).
	
msg_lantern_back3(RsList1, GiveList) ->
	Len2 = erlang:length(GiveList),
	Acc2 = app_msg:encode([{?int16u, Len2}]),
	Fun2 = fun({#give{goods_id = GoodsId, count = Count}, _}, Acc) ->
				   Acc22 = msg_times_xxx3(GoodsId,Count),
				   <<Acc/binary,Acc22/binary>>
		   end,
	RsList2 = lists:foldl(Fun2, Acc2, GiveList),
	
    app_msg:msg(?P_GOODS_LANTERN_BACK, <<RsList1/binary,RsList2/binary>>).



% 次数物品数据返回 [2332]
msg_times_goods_back(GidCountL, Logs)->
	Len1 = erlang:length(GidCountL),
	Acc1 = app_msg:encode([{?int16u, Len1}]),
	Fun1 = fun({GoodsId, CountUse,T,V,Idx,Sum}, Acc) ->
				   Acc12 = msg_times_xxx1(GoodsId,CountUse,T,V,Idx,Sum),
				   <<Acc/binary,Acc12/binary>>
		   end,
	RsList1 = lists:foldl(Fun1, Acc1, GidCountL),
	msg_times_goods_back2(RsList1, Logs).

msg_times_goods_back2(RsList1, Logs) ->
	Len2 = erlang:length(Logs),
	Acc2 = app_msg:encode([{?int16u, Len2}]),
	Fun2 = fun(#times_goods_logs{uid=Uid, name=Name, name_color=NameColor, gid_use=GidUse, count_use=CountUse, 
								 gid_get=GidGet, count_get=CountGet, seconds=Seconds}, Acc) ->
				   Acc22 = msg_times_xxx2(Uid,Name,NameColor,GidUse,CountUse,GidGet,CountGet,Seconds),
				   <<Acc/binary,Acc22/binary>>
		   end,
	RsList2 = lists:foldl(Fun2, Acc2, Logs),
	
    app_msg:msg(?P_GOODS_TIMES_GOODS_BACK, <<RsList1/binary,RsList2/binary>>).


% 次数物品数据块 [2333]
msg_times_xxx1(GoodsId,Count,CostType,CostValue,Idx,Sum)->
	app_msg:encode([{?int32u,GoodsId},{?int16u,Count},{?int8u,CostType},
					{?int32u,CostValue},{?int16u,Idx},{?int16u,Sum}]).


% 次数物品日志数据块 [2334]
msg_times_xxx2(#times_goods_logs{uid=Uid, name=Name, name_color=NameColor, gid_use=GidUse, count_use=CountUse, 
								 gid_get=GidGet, count_get=CountGet, seconds=Seconds}) ->
	msg_times_xxx2(Uid,Name,NameColor,GidUse,CountUse,GidGet,CountGet,Seconds).

% 次数物品日志数据块 [2334]
msg_times_xxx2(Uid,Name,NameColor,GidUse,CountUse,GidGet,CountGet,Seconds)->
	app_msg:encode([{?int32u,Uid},{?string,Name},{?int8u,NameColor},
					{?int32u,GidUse},{?int16u,CountUse},{?int32u,GidGet},
					{?int16u,CountGet},{?int32u,Seconds}]).

% 元宵活动物品信息块 [2335]
msg_times_xxx3(GoodsId,Count)->
    app_msg:encode([{?int16u,GoodsId},{?int16u,Count}]).


% 特定活动物品是否可使用 [2338]
msg_acty_use_state(GoodsId,State)->
    RsList = app_msg:encode([{?int32u,GoodsId},{?bool,State}]),
    app_msg:msg(?P_GOODS_ACTY_USE_STATE, RsList).

% 伙伴经验丹使用成功 [2081]
msg_p_exp_ok()->
    app_msg:msg(?P_GOODS_P_EXP_OK,<<>>).

	
	
	
	
	
	
	
	
	
	
