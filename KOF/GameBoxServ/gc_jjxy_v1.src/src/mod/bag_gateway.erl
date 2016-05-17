%% Author: Administrator
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_goods
-module(bag_gateway).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([gateway/3]). 
%%
%% API Functions
%%
% 请求背包物品信息/临时背包
gateway(?P_GOODS_REQUEST,Player=#player{socket=Socket,vip=Vip},Bin) ->  
	{Type,_Sid,Uid}=app_msg:decode({?int8u,?int16u,?int32u},Bin),
	BinMsg = 
		case case Type of
				 ?CONST_GOODS_CONTAINER_BAG ->
					 bag_api:bag_max_updata(Vip),
					 #bag{max=Max,list=List}=role_api_dict:bag_get(),
					 {?ok, Max, List};
				 _ ->
					 {?error, ?ERROR_BADARG}
			 end of
			{?ok, Max2, GoodsList} ->
				bag_api:msg_reverse(Uid,Type,Max2,GoodsList);
			{?error, ErrorCode} ->
				system_api:msg_error(ErrorCode)
		end,
	app_msg:send(Socket, BinMsg),
	{?ok,Player};

% 丢弃物品 	
gateway(?P_GOODS_LOSE,Player=#player{socket=Socket},Bin) ->
	{Index} = app_msg:decode({?int16u},Bin),
	case bag_api:remove(Player, Index) of
		{?ok, Player2, BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket,BinMsg),
			{?ok, Player}
	end;	

% 物品/装备使用
gateway(?P_GOODS_USE,#player{socket = Socket} = Player,Bin) ->
	{Type,Id, FromIndex,Count} = app_msg:decode({?int8u,?int32u,?int16u,?int16u},Bin),
	case bag_api:goods_use(Player, Type, Id, FromIndex,Count) of
		{?ok, Player2, BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

% 使用物品(指定对象)
gateway(?P_GOODS_TARGET_USE,#player{socket = Socket} = Player,Bin) ->
	{_Type,_Target,FromIdx,Count,Object} = app_msg:decode({?int8u,?int32u,?int16u,?int16u,?int32u},Bin),
	case bag_api:goods_use(Player, ?CONST_GOODS_CONTAINER_BAG, 0, FromIdx,Count,Object) of
		{?ok, Player2, BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%%请求容器扩充 
gateway(?P_GOODS_ENLARGE_REQUEST,#player{socket = Socket} = Player,Bin)->
	{Arg} = app_msg:decode({?bool}, Bin),
	Bag=role_api_dict:bag_get(),
	case Arg of
		?true ->
			case bag_api:enlargh(Player) of
				{?ok, Player2, BinMsg} ->
					app_msg:send(Socket, BinMsg),
					{?ok,Player2};
				{?error, ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg),
					{?ok,Player}
			end;
		?false ->
			#bag{count = Count} = Bag,
			BinMsg = case ?DATA_BAG:get(Count) of
						 {GoodsId, Num, _Vol} ->
							 bag_api:msg_enlarge_cost(GoodsId, Num, Count);
						 _ ->
							 system_api:msg_error(?ERROR_BAG_COUNT_MAX)
					 end,
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%%请求装备信息
gateway(?P_GOODS_EQUIP_ASK,Player,Bin)->
	{Uid, PartnerID} = app_msg:decode({?int32u,?int32u}, Bin),
	bag_api:equip_ask(Player, Uid, PartnerID),
	{?ok,Player};

%% 请求提取临时背包物品,当idx=0时一键提取临时背包所有物品 
gateway(?P_GOODS_PICK_TEMP, #player{socket = Socket} = Player, Bin) ->
	{Idx} = app_msg:decode({?int16u}, Bin),
	case bag_api:get_temp(Player, Idx) of
		{?ok, Player2, BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%%出售背包物品
gateway(?P_GOODS_SELL, #player{socket = Socket} = Player, Bin) ->
	{Idx, Count} = app_msg:decode({?int16u, ?int16u}, Bin),
	Bag=role_api_dict:bag_get(),
	case bag_api:sell(Player,Bag,[{Idx, Count}]) of
		{?ok, Player2,Bag2, BinMsg} ->
			role_api_dict:bag_set(Bag2),
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 批量出售背包物品
gateway(?P_GOODS_P_SELL, #player{socket = Socket} = Player, Bin) ->
	Data = bag_api:decode_sell(Bin),
	?MSG_ECHO("============== ~w~n",[Data]),
	Bag=role_api_dict:bag_get(),
	case bag_api:sell(Player,Bag,Data) of
		{?ok, Player2,Bag2, BinMsg} ->
			role_api_dict:bag_set(Bag2),
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 一键互换
gateway(?P_GOODS_EQUIP_SWAP, #player{socket = Socket} = Player, Bin) ->
	{Id1, Id2} = app_msg:decode({?int32u, ?int32u}, Bin),
	case bag_api:swap_click(Player, Id1, Id2) of
		{?ok, Player2, BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 领取将要获得的物品
gateway(?P_GOODS_LANTERN_GET, #player{socket = Socket} = Player, _Bin) ->
	BinMsg = case erlang:get(yuanxiao) of
				 BinMsg0 when is_binary(BinMsg0) ->
					 BinMsg0;
				 _ ->
					 <<>>
			 end,
	{Player2, BinMsg2} = bag_api:times_goods_ask2(Player),
	app_msg:send(Socket, <<BinMsg/binary,BinMsg2/binary>>),
	{?ok, Player2};

%% 请求元宵活动数据
gateway(?P_GOODS_LANTERN_ASK,#player{socket = Socket} = Player,_Bin)->
	{Player2, BinMsg} = bag_api:times_goods_ask2(Player),
	app_msg:send(Socket, BinMsg),
	{?ok, Player2};

%% 请求次数物品数据
gateway(?P_GOODS_TIMES_GOODS_ASK, #player{socket = Socket} = Player, _Bin) ->
	{Player2, BinMsg} = bag_api:times_goods_ask(Player),
	app_msg:send(Socket, BinMsg),
	{?ok, Player2};

%% 检查特定活动物品是否可使用
gateway(?P_GOODS_ACTY_USE_CHECK,#player{socket = Socket} = Player,Bin)->
	{GoodsId} = app_msg:decode({?int32u},Bin),
	State = case bag_api:activity_state_use(GoodsId) of
				?ok ->
					?true;
				{?error, _} ->
					?false
			end,
	BinMsg = bag_api:msg_acty_use_state(GoodsId, State),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

%% decode([],Acc) -> 
%% 	Acc;
%% decode([Idx,Num|L], Acc) ->
%% 	[{Idx,Num}|Acc].
