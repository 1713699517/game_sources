%% Author: youxi
%% Created: 2012-11-27
%% Description: TODO: Add description to mall_api
-module(mall_api).

%%
%% Include files
%%
-include("comm.hrl").
%%
%% Exported Functions
%%
-export([
		 encode_mall/1,
		 decode_mall/1,
		 init/1,
		 msg_info/7,
		 msg_info_new/8,
		 msg_buy_succ/0, 
		 msg_integral_back/1]).

%%
%% API Functions
%%
encode_mall(DictMallShop) ->
	DictMallShop.

decode_mall(DictMallShop) when is_record(DictMallShop,mall_shop) ->
	DictMallShop;
decode_mall(_FiendData) ->
	#mall_shop{shoplistc = [],buy_time = util:seconds()}.

init(Player) ->
	MallShop = #mall_shop{shoplistc = [],buy_time = util:seconds()},
	{Player,MallShop}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%msg %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 店铺物品信息块 [34501]
msg_info(Idx,Goods,CType,SPrice,VPrice,TotalRemaindNum,GoodsNum)->
	RsList = app_msg:encode([{?int16u,Idx}]),
	RsList2 = bag_api:msg_goods(Goods),
	RsList3 = app_msg:encode([{?int8u,CType},{?int32u,SPrice},{?int32u,VPrice},{?int16,TotalRemaindNum},{?int16u,GoodsNum}]),
	<<RsList/binary,RsList2/binary,RsList3/binary>>.

% 店铺物品信息块 [34502]
msg_info_new(Idx,State,Goods,Type,SPrice,VPrice,EtraType,EtraValue)->
	State2 = ?IF(State == ?false,1,0),
    RsList = app_msg:encode([{?int16u,Idx},{?int8u,State2}]),
    RsList2 = bag_api:msg_goods(Goods),
	RsList3 = app_msg:encode([{?int8u,Type},{?int32u,SPrice},{?int32u,VPrice},{?int8u,EtraType},{?int16u,EtraValue}]),
    <<RsList/binary,RsList2/binary,RsList3/binary>>.

% 购买成功 [34516]
msg_buy_succ() ->
    app_msg:msg(?P_SHOP_BUY_SUCC,<<>>).

% 玩家积分数据 [34522]
msg_integral_back(Integral)->
    RsList = app_msg:encode([{?int32u,Integral}]),
    app_msg:msg(?P_SHOP_INTEGRAL_BACK, RsList).




