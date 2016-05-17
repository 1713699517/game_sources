%% Author: Kevin
%% Created: 2012-10-16
%% Description: TODO: Add description to pp_friend
-module(treasure_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([
		 encode_treasure/1,
		 decode_treasure/1,
		 init/1,
		 interval/0,
		 
		 request/2,
		 make/3,
		 
		 purchase/2,
		
		 
		 is_copy/1,
		 %%%%%%%%%%%%%%%%%%%
         check_goods_in/1,
		 %%%%%%%%%%%%%%%%%%%

		 shop_request/0,
		 treasure_money_refresh/1,
		 
		 
		 msg_attribute/2,
		 msg_shop_info/2,
		 msg_purchase_state/1
		 
	     ]).


encode_treasure(Treasure) -> 
	Treasure.

decode_treasure(Treasure) ->
	case is_record(Treasure,treasure) of
		?true->
			case Treasure#treasure.shop_time of
				{_H,_I,_S} ->
					Treasure#treasure{shop_time=0};
				_ ->
					Treasure
			end;
		_->
			#treasure{level_id = 101,complete_list = [],shop_time = 0}
	end.

%%
%% API Functions
%%
%% 初始化接口

init(Player)->
%%    Now = util:seconds(),
   BinData = #treasure{level_id = 101,shop_time = 0},
   {Player,BinData}.

%%  定时回调接口
interval() -> ?ok.
%% 	?MSG_ECHO("=================================~n",[]),
%% 	OnlineList = ets:tab2list(?ETS_ONLINE),
%% 	[util:pid_send(Player#player.uid, {?MODULE,check_uid,[Player]})|| Player <- OnlineList].

%% %% 扫描接口
%% check_uid(#player{socket = Socket,uid = Uid} = Player) ->
%% 	Treasure = role_api_dict:treasure_get(Uid),
%% 	Treasure2 = Treasure#treasure{shop_time = {5,0,0},is_refresh = ?CONST_FALSE},
%% 	role_api_dict:treasure_set(Uid, Treasure2),
%% 	{?ok,Player2,Bin} = treasure_refresh(Player,?CONST_TREASURE_STORE_TREASURE_TIME),
%% 	app_msg:send(Socket, Bin),
%% 	Player2.
    

%% 初始化面板请求
request(#player{lv = Lv,uid = Uid} = Player,LevelId)->
	#treasure{level_id = LevelId0,complete_list = CompList} = role_api_dict:treasure_get(),
	case LevelId of 
		0 ->
			ItemsList = (data_hidden_treasure:get(LevelId0))#d_hidden_treasure.all_items,
			ItemsList2 = check_complete(ItemsList,CompList), 
			Bin = msg_request_info(LevelId0, ItemsList2),
			{?ok,Player,Bin};
        _ ->
			case data_hidden_treasure:get(LevelId) of
				Hidden_treasure when is_record(Hidden_treasure,d_hidden_treasure) ->
					case Lv >= Hidden_treasure#d_hidden_treasure.open_lv of
						?true ->
							GoodsId = hd(CompList),
							stat_api:logs_treasure(Uid,LevelId,LevelId,GoodsId),
							ItemsList = Hidden_treasure#d_hidden_treasure.all_items,
							ItemsList2 = check_complete(ItemsList,CompList),
							Bin = msg_request_info(LevelId, ItemsList2),
							{?ok,Player,Bin};
						_ ->
							{?error,?ERROR_TREASURE_LV_ENGTHOU}
					end;
				_ ->
					{?error,?ERROR_TREASURE_ERROR_ID}
			end
	end.

%% 检查是否完成
check_complete(ItemsList,CompList) ->
	Fun = fun(Id) ->
				  case lists:member(Id, CompList) of
					  ?true ->
						  {Id, 1};
					  _ ->
						  {Id, 0}
				  end
		  end,
	lists:map(Fun, ItemsList).
	   
%% 处理打造请求
make(Player,Type,GoodsId)->
	case data_hidden_make:get(GoodsId) of
		#d_hidden_make{make = MakeList,level = LevelId} ->
			GoodsList = [{Item,Count}||{Item,Count,_Rmb,_CopId}<- MakeList],  
			RmbItemList = [Rmb||{_Item,_Count,Rmb,_CopId}<- MakeList],
			case Type of 
				0 -> %% 普通打造
					comm_make(Player,GoodsId,LevelId,GoodsList,?CONST_FALSE);
				1 -> %% 一键打造 
					key_make(Player,GoodsId,LevelId,GoodsList,RmbItemList)
			end;
		_ ->
			{?error,?ERROR_TREASURE_NOT_GOODS}
	end.
				
%% 一键打造 
key_make(#player{vip = Vip} = Player,GoodsId, LevelId,GoodsList, RmbItemList)->
	case Vip#vip.lv >= ?CONST_TREASURE_ONCE_MAKE_VIP of
		?true ->
			Rmb = cut_money(GoodsList, RmbItemList),
			case Rmb =:= 0 of 
				?true ->
					{?ok, Player2, Bin} = comm_make(Player,GoodsId, LevelId,GoodsList,?CONST_FALSE),
					{?ok, Player2, Bin};
				_ ->
					case role_api:currency_cut([key_make, [], <<"藏宝阁打造">>],Player,[{?CONST_CURRENCY_RMB,Rmb}]) of
						{?ok,Player2,Bin2}->
							GoodsList2 = bag_left(GoodsList),
							{?ok,Player3,Bin} = comm_make(Player2,GoodsId, LevelId,GoodsList2,?CONST_TRUE),
							{?ok,Player3,<<Bin/binary,Bin2/binary>>};
						{?error,Error} ->
							{?error,Error}
					end
			end;
		_->
			{?error,?ERROR_TREASURE_VIP_NOT_ENOUGH}
	end.

%% 减少钱
cut_money(GoodsList,RmbItemList) ->
	%% 所需数量-背包拥有数量
    Fun = fun({Item,Count}, Acc) ->
				  SCount = bag_api:goods_id_count_get(Item),
				  Differ = case Count =< SCount of
							   ?true ->
								   0;
							   ?false ->
								   Count - SCount
						   end,
				  [Differ|Acc]
		  end,
	DifferList = lists:foldr(Fun, [], GoodsList),
	RmbList = lists:zipwith(fun(X,Y) -> X * Y end, DifferList, RmbItemList),
	lists:sum(RmbList).

%% 背包剩余数量
bag_left(GoodsList) ->
	Fun = fun({Item,_Count}, Acc) ->
				  SCount = bag_api:goods_id_count_get(Item),
				  [{Item,SCount}|Acc]
		  end,
	lists:foldl(Fun, [], GoodsList).

%% 开始处理打造请求
comm_make(Player,GoodsId, LevelId,GoodsList,Bool) ->
	Bag = role_api_dict:bag_get(),
	case bag_api:goods_get([key_make,[],<<"藏宝阁数据打造扣物品">>], Player, Bag, GoodsList) of
		{?ok,Player2,Bag2,Bin2} ->
			role_api_dict:bag_set(Bag2),
	        {?ok,Player3,Bin} = make_update(Player2,GoodsId,LevelId),
			{?ok,Player3,<<Bin/binary,Bin2/binary>>};
	 	_ ->
			case Bool of
				?CONST_TRUE ->
					?MSG_ECHO("~w~n",[Bool]),
					{?ok,Player2,Bin} = make_update(Player,GoodsId,LevelId),
			        {?ok,Player2,Bin};
				_ ->
			        Bin = msg_attribute(GoodsId,0),
			        {?ok,Player,Bin}
			end
	end.

%% 处理打造请求
make_update(Player,GoodsId,LevelId) ->
	Treasure      = role_api_dict:treasure_get(),
	#treasure{complete_list = CompleteList} = Treasure,
	CompleteList2 = [GoodsId|CompleteList],
	Treasure2     = Treasure#treasure{complete_list = CompleteList2,level_id = LevelId},
	role_api_dict:treasure_set(Treasure2),
	card_api:sales_notice(Player),
	Bin           = msg_attribute(GoodsId,1),
	Player2       = check_attr(GoodsId,CompleteList2,Player),
	{?ok,Player2,Bin}.

%% 属性加成检查
check_attr(GoodsId,CompleteList2,Player) ->
	#d_hidden_line{keyid = KeyList} = data_hidden_line:get(GoodsId),
	Fun = fun(KeyId,Acc) ->
				  Treasure = role_api_dict:treasure_get(),
				  #treasure{activated = ActivList} = Treasure,
				  case lists:member(KeyId, ActivList) of
					  ?true ->
						  Acc;
					  ?false ->
						  #d_hidden_treasure{linking_items = LinkingList,attr = Attr0} = data_hidden_treasure:get(KeyId),
						  case lists:all(fun(Id) ->lists:member(Id,CompleteList2) end, LinkingList) of 
							  ?true ->
								  #attr_group{treasure = TAttr} = role_api_dict:attr_group_get(),
								  Attr = role_api:attr_sum(TAttr,[Attr0]),
								  Treasure2 =  Treasure#treasure{activated = [KeyId|ActivList]},
								  role_api_dict:treasure_set(Treasure2),
								  role_api:attr_update_player(Player, treasure, Attr);
							  _ ->
								  Acc
						  end
				  end
		  end,
	lists:foldl(Fun, Player, KeyList).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  商店

%% 请求商店面板
shop_request() ->
	Treasure  = role_api_dict:treasure_get(),
	Treasure2 = case Treasure#treasure.shop_time of
				{_H,_I,_S} ->
					Treasure#treasure{shop_time = 0};
				_ ->
					Treasure
	end,
	shop_request(Treasure2).
shop_request(#treasure{shop_time = ShopTime, shoplist = GoodsList,is_refresh = RefResh} = Treasure)->
	Now = util:seconds(),
	T2 = ?CONST_TREASURE_STORE_TREASURE_TIME - util:second_today_current() rem 3600,
	case Now - ShopTime of
		T when T > 0 andalso T < 3599 ->
			BinMsg	 = msg_shop_info(T2, GoodsList);
		_ ->		
			OddsList = data_hidden_store:get_ids(),
			RefGoods = util:odds_list_count(OddsList, 6),
			RefGoods2 = get_data(RefGoods),	
			RefResh2 =  case util:time() of {5,_,_} -> 0; _-> RefResh end,
			RefTime  = util:second_today_current() rem 3600,
			role_api_dict:treasure_set(Treasure#treasure{shop_time = Now - RefTime,shoplist = RefGoods2,is_refresh = RefResh2}),
			BinMsg	 = msg_shop_info(T2,RefGoods2)
	end,
	{?ok,BinMsg}.

get_data(RefGoods)->
	Fun = fun
			 (GoodsId,Acc) ->
				  #d_hidden_store{goods_id = Gid,goods_count = Gc,price = Price,price_type = Ptype} = data_hidden_store:get(GoodsId),
				  [{Gid,Gc,{Price,Ptype},1}|Acc]
		  end,
	lists:foldl(Fun, [], RefGoods).

%% 金元刷新
treasure_money_refresh(Player) ->
	case role_api:currency_cut([vip_refresh_shop, [], <<"精元刷新">>],Player,[{?CONST_CURRENCY_GOLD,?CONST_TREASURE_STORE_REFRESH_RMB}]) of
		{?ok,Player2,BinCast}->
			Treasure = role_api_dict:treasure_get(),
			OddsList = data_hidden_store:get_ids(),
			RefGoods = util:odds_list_count(OddsList, 6),
			RefGoods2 = get_data(RefGoods),
			Treasure2= Treasure#treasure{shoplist = RefGoods2,is_refresh = Treasure#treasure.is_refresh + 1},
			role_api_dict:treasure_set(Treasure2),
			active_api:check_link(Player#player.uid, ?CONST_ACTIVITY_LINK_109),
			{?ok,BinMsg} = shop_request(Treasure2),
			{?ok,Player2,<<BinCast/binary,BinMsg/binary>>};
		{?error,Error} ->
			{?error,Error}
	end.

%% 处理购买请求
purchase(Player,GoodsId)->
	Treasure = role_api_dict:treasure_get(),
	#treasure{shoplist=GoodsList} = Treasure,
	case lists:keytake(GoodsId, 1, GoodsList) of
		{value, {GoodsId, GoodsCount, {Ptype,Price}, 1}, TupleList2} ->
			case role_api:currency_cut([purchase,[],<<"藏宝阁商店消费">>],Player, [{Ptype,Price}]) of
				{?ok,Player2,BinCast} ->
					case bag_api:goods_set([key_make, [], <<"藏宝阁打造">>], Player2, [{GoodsId,GoodsCount}]) of
						{?ok,Player3,SetBin,LogBin} ->
							BinMsg = msg_purchase_state(?CONST_TRUE),
							Treasure2 = Treasure#treasure{shoplist=[{GoodsId,GoodsCount,{Ptype,Price},0}|TupleList2]},
							role_api_dict:treasure_set(Treasure2),
							{?ok,Player3,<<BinCast/binary,SetBin/binary,LogBin/binary,BinMsg/binary>>};
						{?error,ErrorCode} ->
							{?error,ErrorCode}
					end;
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		_ ->
			{?error,?ERROR_TREASURE_NOT_REPEAT_BUY}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  以上商店

%% 对外接口，请求时候为珍宝打造物品
check_goods_in(GoodIds) ->
	Treasure  = role_api_dict:treasure_get(),
	#treasure{complete_list = CompleteList} = Treasure,
	lists:all(fun(GoodId) ->lists:member(GoodId, CompleteList) end, GoodIds).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% local function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 检测副本是否开启
is_copy(CopyId)->
	case copy_api:check_over(CopyId) of
		?true ->
			Bin = msg_copy_state(?CONST_TRUE),
			{?ok,Bin};
		_ ->
			Bin = msg_copy_state(?CONST_FALSE),
			{?ok,Bin}
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%msg data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 处理藏宝阁面板请求 [47210]
msg_request_info(LevelId,List)->
    RsList = app_msg:encode([{?int32u,LevelId},{?int16u,length(List)}]),
	Fun = fun({GoodsId,State},Acc) ->
				  Bin = app_msg:encode([{?int32u,GoodsId},{?int8u,State}]),
				  <<Acc/binary,Bin/binary>>
		  end,
	RsList2 = lists:foldl(Fun, RsList, List),
    app_msg:msg(?P_TREASURE_REQUEST_INFO, RsList2).

% 触发属性加成 [47230]
msg_attribute(Id,State)->
    RsList = app_msg:encode([{?int32u,Id},{?bool,State}]),
    app_msg:msg(?P_TREASURE_ATTRIBUTE, RsList).

% 返回商店面板数据 [47285]
msg_shop_info(Time,List0)->
	List = lists:keysort(1, List0),
    RsList = app_msg:encode([{?int32u,Time},{?int16u,length(List)}]),
	F = fun
		   ({GoodsId,GoodsCount,_,State},Acc)->
				GoodsIdBin = app_msg:encode([{?int32u,GoodsId},{?int32u,GoodsCount},{?int8u,State}]),
				<<Acc/binary,GoodsIdBin/binary>>;
		   ({GoodsId,GoodsCount,State},Acc)->
				GoodsIdBin = app_msg:encode([{?int32u,GoodsId},{?int32u,GoodsCount},{?int8u,State}]),
				<<Acc/binary,GoodsIdBin/binary>>
		end,	
	BiList = lists:foldl(F, RsList, List),
    app_msg:msg(?P_TREASURE_SHOP_INFO_NEW, BiList).

% 购买成功与否 [47300]
msg_purchase_state(State)->
    RsList = app_msg:encode([{?int8u,State}]),
    app_msg:msg(?P_TREASURE_PURCHASE_STATE, RsList).

% 副本开启状态 [47320]
msg_copy_state(State)->
    RsList = app_msg:encode([{?int8u,State}]),
    app_msg:msg(?P_TREASURE_COPY_STATE, RsList).
	
