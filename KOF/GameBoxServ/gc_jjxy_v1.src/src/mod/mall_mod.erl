%% Author: youxi
%% Created: 2012-11-27
%% Description: TODO: Add description to mall_mod
-module(mall_mod).

%%
%% Include files
%%
-include("comm.hrl").
%%
%% Exported Functions
%%
-export([
		 ask/4, 
		 buy/7, 
		 get_buy_role/2,
		 discount/3,
		 if_check_time/2,
		 set_goods_daliy/0
		 ]).


%%
%% API Functions
%% 请求处理面板 
ask(Uid,Lv, ID, ClassId) ->
	case ID of
		?CONST_MALL_TYPE_ID_ORDINARY ->
			case goodsrequest(Uid,Lv, ID, ClassId) of   
				{?ok, Mallgoods} ->
					Bin = app_msg:encode([{?int16u,ID},{?int16u,ClassId},{?int16u,length(Mallgoods)}]),
					Bin2 = shop_msg(ID,ClassId,Mallgoods),
					Endtime = get_endtime(ID),
					Bin3 = app_msg:encode([{?int32u, Endtime}]),
					BinMsg = app_msg:msg(?P_SHOP_REQUEST_OK, <<Bin/binary,Bin2/binary,Bin3/binary>>),
					{?ok, BinMsg};
				{?error, ErrorCode} ->
					{?error, ErrorCode}
			end;
		?CONST_MALL_TYPE_ID_DISCOUNT ->
			ask2(Uid,Lv, ID, ClassId)
	end.

%% 打包物品数据
shop_msg(_ID, _ClassId,Mallgoods) ->
	Fun = fun(#d_mall_goods{id = Idx,give = Give,currency = Ctype,s_price = Sprice,o_price = Vprice,swap_count = Goods_num} = Mallgoods, Acc) ->
				  Goods = bag_api:goods(Give),
				  LackCount = get_goods_lack(Mallgoods),
				  Acc2 = mall_api:msg_info(Idx, Goods, Ctype, Vprice, Sprice, LackCount,Goods_num),
				  <<Acc/binary,Acc2/binary>>						  
		  end,
	lists:foldl(Fun, <<>>, Mallgoods).

ask2(Uid,Lv, ID, ClassId) ->
	case goodsrequest(Uid,Lv, ID, ClassId) of
				{?ok, Mallgoods} ->
					Bin     = app_msg:encode([{?int16u,ID},{?int16u,ClassId},{?int16u,length(Mallgoods)}]),
					Bin2    = shop_msg2(Uid,Mallgoods),
					Endtime = get_endtime(ID),
					Bin3    = app_msg:encode([{?int32u, Endtime}]),
					BinMsg  = app_msg:msg(?P_SHOP_REQUEST_OK_NEW, <<Bin/binary,Bin2/binary,Bin3/binary>>),
					{?ok, BinMsg};
				{?error, ErrorCode} ->
					{?error, ErrorCode}
   end.

%% 打包物品数据
shop_msg2(Uid,Mallgoods) ->
	Fun = fun(#d_mall_goods{id = Idx,give = Give,currency = Ctype,s_price = Sprice,o_price = Vprice,ext_k = ExtType,ext_v = ExtValue}, Acc) ->
				  Goods = bag_api:goods(Give),			  
				  case ExtType of
					  ?CONST_MALL_TYPE_ODDS ->
						  State = get_goods_state(Uid,Idx),
						  ?MSG_ECHO("==================~w~n",[{State,Goods}]),
						  Acc2 = mall_api:msg_info_new(Idx,State,Goods,Ctype,Vprice, Sprice, 0,0),
						  <<Acc/binary,Acc2/binary>>;
					  _ ->
						  State2 = get_goods_state(Uid,Idx),
						  ?MSG_ECHO("======================~w~n",[{State2,Goods}]),
						  Acc2 = mall_api:msg_info_new(Idx, State2,Goods,Ctype,Vprice, Sprice, ExtType,ExtValue),
						  <<Acc/binary,Acc2/binary>>
				  end
		  end,
	lists:foldl(Fun, <<>>, Mallgoods).

%% 得到物品是否可以购买的状态
get_goods_state(_Uid,Idx)->
	R = role_api_dict:mall_shop_get(),
	#mall_shop{shoplistc = ShopListc} = R,
	lists:member(Idx, ShopListc).
	
%% 设置物品是否可以购买的状态
set_goods_state(_Uid,Idx,Time)->
	R = role_api_dict:mall_shop_get(),
	#mall_shop{shoplistc = ShopListc} = R,
	case lists:member(Idx, ShopListc) of
		?true ->
			R2 = R#mall_shop{buy_time = Time};
		_ ->
			R2 = R#mall_shop{shoplistc = [Idx|ShopListc],buy_time = Time}
	end,
	role_api_dict:mall_shop_set(R2).
	

%% 删除物品状态
delete_goods_state(_Uid,Idx)->
	R = role_api_dict:mall_shop_get(),
	#mall_shop{shoplistc = ShopListc} = R,
	ShopListc2 = lists:delete(Idx, ShopListc),
	R2 = R#mall_shop{shoplistc = ShopListc2},
	role_api_dict:mall_shop_set(R2).
	

%% 设置每日物品
set_goods_daliy()->
	List  = data_mall:data_ids(2020),
	List2 = set_goods_odd(List),
	[GoodsIndx] = util:odds_list_count(List2, 1),
	Time = util:seconds(),
	db_api:insert_data2ets(?CONST_PUBLIC_KEY_MALL, [{goodsIndex,GoodsIndx},{time,Time}]).
set_goods_odd(List) -> %% 设置物品概率
	Fun = fun(Index,Acc) ->
				  #d_mall_goods{ext_v = ExtValue} = data_mall:data(Index),
				  [{Index,ExtValue}|Acc]
		  end,
	lists:foldl(Fun, [], List).

%% 得到每日物品
get_goods_daliy()->
	case db_api:get_data2ets(?CONST_PUBLIC_KEY_MALL,  [goodsIndex,time]) of
		[Index,Time] ->
			[Index,Time];
		_->
			[0,0]
	end.

get_buy_goods_time()->
    R = role_api_dict:mall_shop_get(),	
    #mall_shop{buy_time = BuyTime} = R,
	BuyTime.

check_daily_delete(Uid,Idx) ->
	Now = util:seconds(),
	Time = get_buy_goods_time(),
	case util:is_same_date(Time, Now) of
		?true ->
			?skip;
		_ ->
            delete_goods_state(Uid,Idx)
	end.
	
%% 商店开服请求
%% reg:lv id classid
goodsrequest(Uid,Lv, ID, ClassId) ->
	case ClassId of
		?CONST_MALL_TYPE_SUB_DISCOUNT ->
			[Idx,Time] = get_goods_daliy(),
			Now = util:seconds(),
			case util:is_same_date(Time, Now) of
				?true ->
					Data = data_mall:data(Idx),
					check_daily_delete(Uid,Idx),
					{?ok,[Data]};
				_ ->
					set_goods_daliy(),
					[Idx2,_Time2] = get_goods_daliy(),
					Data2 = data_mall:data(Idx2),
					delete_goods_state(Uid,Idx2),
					?MSG_ECHO("=====================~w~n",[{Idx2,Data2}]),
					{?ok,[Data2]}
			end;
		_->
			case data_mall:name(ID) of
				#d_mall_name{} = Dmallname ->
					case check_time(ID, ClassId, Lv, Dmallname) of
						?ok ->
							case data_mall:data_ids(ClassId) of
								Ids when is_list(Ids) ->
									Fun = fun(Id,Acc) ->
												  Data = data_mall:data(Id),
												  case check_goods(Lv, Data) of
													  ?true ->
														  [Data|Acc];
													  ?false ->
														  Acc
												  end							   
										  end,
									Dgoods = lists:foldl(Fun, [], Ids),
									Dgoods2 = lists:sort(fun(#d_mall_goods{give = Give},#d_mall_goods{give = Give2}) ->
																 Give#give.goods_id > Give2#give.goods_id
														 end, Dgoods),
									?MSG_ECHO("=========================~w~n",[Dgoods2]),
									{?ok, Dgoods2};
								_ ->
									{?error, ?ERROR_BADARG}    % 不存在
							end;
						{?error, ErrorCode} ->
							{?error, ErrorCode}
					end;
				_ ->
					{?error, ?ERROR_BADARG}
			end
	end.

%% 
check_time(ID, Class, Lv, Dmallname) ->
	case if_check_time(ID, Class) of
		?false ->
			do_check_time(Lv, Dmallname);
		?true ->
%% 			check_state(ID, Class, Lv)
            ?ok	        
	end.

if_check_time(ID, Class) ->
	List = [{?CONST_MALL_TYPE_ID_YUQING, ?CONST_MALL_TYPE_SUB_YUQING},
			{?CONST_MALL_TYPE_ID_CANGBAO, ?CONST_MALL_TYPE_SUB_CANGBAO},
			{?CONST_MALL_TYPE_ID_COLLECT, ?CONST_MALL_TYPE_SUB_COLLECT},
			{?CONST_MALL_TYPE_ID_PAY_POINT, ?CONST_MALL_TYPE_SUB_PAY_POINT}],
	lists:member({ID, Class}, List).

do_check_time(Lv0, #d_mall_name{open_lv = Lv, 
								open_type = Type, 
								open_arg = Arg, 
								open_start = {HS,MS}, 
								open_end = {HE,ME}}) when Lv0 >= Lv ->
	case 
		case Type of
			 0 ->
				 ?true;
			 1 ->
				 Week = util:week(),
				 is_list(Arg) andalso (Arg == [] orelse lists:member(Week, Arg));
			 _ ->
				 WorkDay = db:config_work_day(),
				 check_time_work(Arg, WorkDay)
		 end of
		?true ->
			Time = util:time(),
			F = fun(T) -> calendar:time_to_seconds(T) end,
			case F(Time) >= F({HS,MS,0}) andalso F(Time) =< F({HE,ME,0}) of
				?true ->
					?ok;
				?false ->
					{?error, ?ERROR_SHOP_NOT_TIME}    % 非开放时间
			end;
		?false ->
			{?error, ?ERROR_SHOP_NOT_DATE}           % 非开放日期
	end;

do_check_time(_, _) ->
	{?error, ?ERROR_SHOP_LV_LACK}.    % level lack

check_time_work([], _WordDay) ->
	?false;
check_time_work([WorkDay|_Arg], WorkDay) ->
	?true;
check_time_work([{0,V}|_Arg], WorkDay) when WorkDay >= V ->
	?true;
check_time_work([_|Arg], WorkDay) ->
	check_time_work(Arg, WorkDay).

check_goods(Lv0, #d_mall_goods{lv = Lv}) ->
	Lv0 >= Lv.

%% 商品打折处理价格
discount(ID, ClassId, Price) ->
	case data_mall:classs(ClassId) of
		#d_mall_class{is_discount = ?CONST_TRUE} ->
			#d_mall_name{vip_discount = Discount} = data_mall:name(ID),
			util:ceil(Discount * Price / ?CONST_PERCENT);
		_ ->
			Price
	end.

%% 处理购买请求 
buy(#player{uid = Uid} = Player, Id, ClassId, Idx, _GoodsId, BuyCount,Ctype) ->
	case Id of
		?CONST_MALL_TYPE_ID_ORDINARY ->
			Lv0 = Player#player.lv,
			case data_mall:name(Id) of
				#d_mall_name{} = Dmall ->
					case check_time(Id, ClassId, Lv0, Dmall) of % 检查商城时间和等级是否符合条件
						?ok -> 
							case data_mall:data(Idx) of
								#d_mall_goods{} = Dmgoods -> 
									%% 检查出售物品是否符合条件:物品全局出售总数量、个人最多购买数量
									case check_goods_count(Uid, BuyCount, Dmgoods) of
										?ok ->
											do_buy(Player, BuyCount, Dmgoods,Ctype);  
										{?error, ErrorCode} ->
											{?error, ErrorCode}
									end;
								_ ->
									{?error, ?ERROR_BADARG}
							end;
						{?error, ErrorCode} ->
							{?error, ErrorCode}
					end;
				_ ->
					{?error, ?ERROR_GOODS_NOT_EXIST}
			end;
		?CONST_MALL_TYPE_ID_DISCOUNT ->
			?MSG_ECHO("==================~w~n",[{}]),
			buy2(Player, Id, ClassId, Idx, _GoodsId, BuyCount)
	end.

%% 超值特惠商店购买
buy2(#player{uid = Uid} = Player, Id, ClassId, Idx, _GoodsId, BuyCount) ->
	Lv0 = Player#player.lv,
	case data_mall:name(Id) of
		#d_mall_name{} = Dmall ->
			case get_goods_state(Uid,Idx) of
				?false ->
					case check_time(Id, ClassId, Lv0, Dmall) of % 检查商城时间和等级是否符合条件
						?ok -> 
							case data_mall:data(Idx) of
								#d_mall_goods{} = Dmgoods -> 
									%% 检查出售物品是否符合条件:物品全局出售总数量、个人最多购买数量
									case check_goods_count(Uid, BuyCount, Dmgoods) of
										?ok ->
											?MSG_ECHO("==================~w~n",[{Uid,Id, ClassId, Idx,BuyCount}]),
											do_buy2(Player, BuyCount, Idx, Dmgoods); 
										{?error, ErrorCode} ->
											{?error, ErrorCode}
									end;
								_ ->
									{?error, ?ERROR_BADARG}
							end;
						{?error, ErrorCode} ->
							{?error, ErrorCode}
					end;
				_->
					{?error,?ERROR_MALL_BUY_HAVE}
			end;
		_ ->
			{?error, ?ERROR_GOODS_NOT_EXIST}
	end.

do_buy2(#player{uid = Uid,lv = Lv,vip = Vip} = Player, BuyCount,Idx,Dmgoods) ->
	#d_mall_goods{currency = Ctype,s_price = SPrice,give = Give,ext_k = ExtType,ext_v = ExtValue} = Dmgoods,
	case check_do_buy2(Lv,Vip,ExtType,ExtValue) of
		?true ->
			Pred = fun({T,V}) -> T =/= 0 andalso V =/= 0 end,				
			CL = lists:filter(Pred, [{Ctype,SPrice}]),
			Bag = role_api_dict:bag_get(),
			case role_api:currency_cut([do_buy2,[],<<"优惠商店购买">>],Player, CL) of   
				{?ok, Player2, Bin1} ->									
					case bag_api:goods(Give) of
						#goods{} = Goods ->
							case bag_api:goods_set([do_buy2,[],<<"商城购买的物品">>],Player2,Bag,[Goods#goods{count = BuyCount}]) of     
								{?ok, Player3,Bag2,GoodsBin,Bin2} ->
									set_goods_count(Uid, BuyCount, Dmgoods),
									?MSG_ECHO("=================~w~n",[{Idx,BuyCount}]),
									role_api_dict:bag_set(Bag2),
									Now = util:seconds(),
									set_goods_state(Uid,Idx,Now),
									Bin3 = mall_api:msg_buy_succ(),
									{?ok, Player3, <<Bin1/binary,GoodsBin/binary,Bin2/binary,Bin3/binary>>};
								{?error, ErrorCode} ->
									{?error, ErrorCode}
							end;
						_ ->
							{?error, ?ERROR_UNKNOWN}
					end;
				{?error, ErrorCode} ->
					{?error, ErrorCode}
			end;
		{?error,ErrorCode}->
			{?error,ErrorCode};
		_ ->
			{?error,?ERROR_UNKNOWN}
	end.

%% 超值商店检查是否可以购买
check_do_buy2(Lv,Vip,ExtType,ExtValue) ->
	case ExtType of
		?CONST_MALL_TYPE_LV ->	
			?IF(Lv >= ExtValue,?true,{?error,?ERROR_LV_LACK});
		?CONST_MALL_TYPE_VIP ->
			?IF(Vip#vip.lv >= ExtValue,?true,{?error,?ERROR_VIP_LV_LACK});
		_->
			?true
	end.
	
%% 处理购买请求
do_buy(#player{uid = Uid} = Player0, BuyCount, Dmgoods,Ctype0) ->
	#d_mall_goods{mall_id = Mid,currency = Ctype, s_price = VPrice,o_price = OPrice, swap_goods_id = Sgid, swap_count = Scount, lv = Lv, give = Give, ext_k = Extk} = Dmgoods,
	case check_once(Player0, Give#give.goods_id, Extk) of
		{?ok, Player} ->
			Count = calculate_count(Extk,BuyCount),
			case Player#player.lv >= Lv of
				?true ->
                    PriceSum = calculate_price(Player,Mid,VPrice,OPrice,Count),				
					Pred = fun({T,V}) -> T =/= 0 andalso V =/= 0 end,				
					CL = lists:filter(Pred, [{Ctype,PriceSum}]),
					IL = lists:filter(Pred, [{Sgid,Scount * Count}]),
					Bag = role_api_dict:bag_get(),
					case Ctype0 of
						?CONST_CONST_CURRENCY_SYMBOL ->
							case bag_api:goods_get([do_buy,[],<<"购买商城物品">>],Player,Bag,IL) of
								{?ok,Player2, Bag2, Bin} ->
									case bag_api:goods(Give) of
										#goods{} = Goods ->
											case bag_api:goods_set([do_buy,[],<<"商城购买的物品">>],Player2,Bag2,[Goods#goods{count = Count}]) of     
												{?ok, Player3,Bag3,GoodsBin,Bin2} ->
													?MSG_ECHO("=777777777777777777777777777777777777777777777777==~n",[]),
													set_goods_count(Uid, Count, Dmgoods),
													role_api_dict:bag_set(Bag3),
													Bin3 = mall_api:msg_buy_succ(),
													?MSG_ECHO("=777777777777777777777777777777777777777777777777==~n",[]),
													{?ok, Player3, <<Bin/binary,GoodsBin/binary,Bin2/binary,Bin3/binary>>};
												{?error, ErrorCode} ->
													{?error, ErrorCode}
											end;
										_ ->
											?MSG_ECHO("===========~n",[]),
											{?error, ?ERROR_UNKNOWN}
									end;
                             _ ->
								 ?MSG_ECHO("===========~n",[]),
								 {?error, ?ERROR_GOODS_LACK}
							end;
						_ ->
							case role_api:currency_cut([do_buy,[],<<"购买商城物品">>],Player, CL) of   
								{?ok, Player2, Bin1} ->									
									case bag_api:goods(Give) of
										#goods{} = Goods ->
											case bag_api:goods_set([do_buy,[],<<"商城购买的物品">>],Player2,Bag,[Goods#goods{count = Count}]) of     
												{?ok, Player3,Bag2,GoodsBin,Bin2} ->
													set_goods_count(Uid, Count, Dmgoods),
													role_api_dict:bag_set(Bag2),
													Bin3 = mall_api:msg_buy_succ(),
													{?ok, Player3, <<Bin1/binary,GoodsBin/binary,Bin2/binary,Bin3/binary>>};
												{?error, ErrorCode} ->
													{?error, ErrorCode}
											end;
										_ ->
											?MSG_ECHO("===========~n",[]),
											{?error, ?ERROR_UNKNOWN}
									end;
								{?error, ErrorCode} ->
									?MSG_ECHO("===========~w~n",[Player#player.money]),
									{?error, ErrorCode}
							end
					end;
				?false ->
					?MSG_ECHO("===========~n",[]),
					{?error, ?ERROR_LV_LACK}
			end;
		{?error, ErrorCode} ->
			?MSG_ECHO("===========~n",[]),
			{?error, ErrorCode}
	end.



%% 查询是否为一次性物品
check_once(Player, Gid, ?CONST_MALL_TYPE_ONCE) ->
	Store = role_api_dict:store_get(),
	OnceGoods = Store#store.once_goods,
	case lists:member(Gid, OnceGoods) of
		?true ->
			{?error, ?ERROR_MALL_BUY_HAVE};
		?false ->
			Store2 = Store#store{once_goods = [Gid|OnceGoods]},
			role_api_dict:store_set(Store2),
			{?ok, Player}
	end;

check_once(Player, _, _) ->
	{?ok, Player}.

%% 计算价格
calculate_price(Player,Mid,VPrice,OPrice,Count) ->
   #d_mall_name{vip = Vip} = data_mall:name(Mid),
    case (Player#player.vip)#vip.lv >= Vip of
				?true ->
					VPrice * Count;
				?false ->
					OPrice * Count
	end.

%% 计算数量
calculate_count(Extk,BuyCount) ->
	case Extk of
		?CONST_MALL_TYPE_ONCE ->
			1;
		_ ->
			BuyCount
	end.

%% 检查是否可以购买
%% return : ok | {?error, ErrorCode}
check_goods_count(Uid, Count, Dgoods) ->
	case get_goods_lack(Dgoods) of
		-1 ->% 不限数量
			check_goods_limit(Uid, Count, Dgoods);
		Lack ->% 剩余数量
			case Lack >= Count of
				?true ->
					check_goods_limit(Uid, Count, Dgoods);
				?false ->
					{?error, ?ERROR_MALL_MAX_GLOBAL}
			end
	end.

check_goods_limit(Uid, Count, #d_mall_goods{id = Id, limit = Limit}) ->
	case Limit of
		0 ->
			?ok;
		_ ->
			Buy = get_buy_role(Uid, Id),
			case Count + Buy =< Limit of
				?true ->% 数量满足
					?ok;
				?false ->
					{?error, ?ERROR_MALL_MAX_PERSON}
			end
	end.

%% 获取玩家当天已购买某物品数量
get_buy_role(Uid, Gid) ->
	Key = {role, Uid},
	case ets:lookup(?ETS_MALL_BUY_MAX, Key) of
		[] ->
			0;
		[{_, Date, List}] ->
			case util:date() of
				Date ->
					case lists:keyfind(Gid, 1, List) of
						{_, Count} ->
							Count;
						false ->
							0
					end;
				_ ->
					0
			end
	end.

%% 更新购买数量
set_goods_count(Uid, Count, #d_mall_goods{id = ID, limit= Limit, limit_all =LimitAll}) ->
	?IF(LimitAll == 0, ?skip, set_sell_com(ID, Count)),
	?IF(Limit == 0, ?skip, set_buy_role(Uid, ID, Count)).

%% 获取某物品已出售数量
get_sell_com(ID) ->
	get_sell_com(ID, util:date()).

get_sell_com(ID, NewDate) ->
	Key = {com,ID},
	case ets:lookup(?ETS_MALL_BUY_MAX, Key) of
		[] ->
			0;
		[{_, Date, Count}] ->
			case NewDate of
				Date ->
					Count;
				_ ->
					0
			end
	end.

%% 更新某物品已出售数量
set_sell_com(ID, Count) ->
	NewDate = util:date(),
	set_sell_com(ID, Count, NewDate).

set_sell_com(ID, Count, NewDate) ->
	Key = {com,ID},
	Object = 
		case ets:lookup(?ETS_MALL_BUY_MAX, Key) of
			[] ->
				{Key, NewDate, Count};
			[{_, Date, Count0}] ->
				case NewDate of
					Date ->
						{Key,NewDate,Count + Count0};
					_ ->
						{Key,NewDate,Count}
				end
		end,
	ets:insert(?ETS_MALL_BUY_MAX, Object).

%% 更新玩家已购买数量
set_buy_role(Uid, ID, Count) ->
	NewDate = util:date(),
	set_buy_role(Uid, ID, Count, NewDate).

set_buy_role(Uid, ID, Count, NewDate) ->
	Key = {role, Uid},
	Object = 
		case ets:lookup(?ETS_MALL_BUY_MAX, Key) of
			[] ->
				{Key, NewDate, [{ID, Count}]};
			[{_, Date, List}] ->
				case NewDate of
					Date ->
						case lists:keyfind(ID, 1, List) of
							{_, Count0} ->
								List2 = lists:keyreplace(ID, 1, List, {ID, Count0 + Count}),
								{Key, NewDate, List2};
							false ->
								{Key, NewDate, [{ID, Count}|List]}
						end;
					_ ->
						{Key, NewDate, [{ID, Count}]}
				end
		end,
	ets:insert(?ETS_MALL_BUY_MAX, Object).

%% return : LackCount
get_goods_lack(#d_mall_goods{id = ID, limit_all = LimitAll}) ->
	case LimitAll of
		0 ->
			?CONST_MALL_LIMIT;
		_ ->
			Sell = get_sell_com(ID),
			erlang:max(0, LimitAll - Sell)
	end.

get_endtime(ID) ->
	#d_mall_name{open_type = OpenType,open_start = {H0, I0}, open_end = {H,I}} = data_mall:name(ID),
	case OpenType of
		0 ->
			0;
		_ ->
			{Y,M,D} = util:date(),
			Seconds1 = util:datetime2timestamp(Y,M,D,H0,I0,0),
			Seconds2 = util:datetime2timestamp(Y,M,D,H,I,0),
			if
				Seconds2 - Seconds1 >= 86000 ->
					0;
				?true ->
					Seconds2
			end
	end.








