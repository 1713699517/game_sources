%% Author: youxi
%% Created: 2012-9-25
%% Description: TODO: Add description to make_api
-module(make_api).

%%
%% Include files
%%
-include("comm.hrl").
%%
%% Exported Functions
%%
-export([
		 encode_make/1,
		 decode_make/1,
		 init/1,
		 make/5,stren/6, 
		 make_take/4,
		 make_set/5,
		 msg_make_ok/3,
		 refresh_attr/3,
		 stren_ask/1,
		 stren_ask/4,
		 stren_ask/7,
		 data_stren_get/5,
		 price_stren/1,
		 
		 msg_pearl_inset_ok/0,
		 msg_stren_max/0,
		 msg_strengthen_ok/4,
		 msg_upgrade_ok/3,
		 msg_wash_back/2,
		 msg_wash_ok/3,
		 msg_compose_ok/0,
		 msg_magic_part_ok/0,
		 msg_enchant_ok/3,
		 msg_enchant_pay/1]).

%%
%% API Functions
%%

encode_make(SUM)->
	SUM.
decode_make(SUM)->
	SUM.

init(Player)->
	Data=util:date_Ymd(),
	{Player,{Data,1}}.

make(Player, Type, Id, Idx, Gid) ->
	make_mod:make(Player, Type, Id, Idx, Gid).

stren(Player, Type, Id, Idx, Discount, Double) ->
	make_mod:stren(Player, Type, Id, Idx, Discount, Double).

make_take(Player, Type, Id, Idx) ->
	make_mod:make_take(Player, Type, Id, Idx).

make_set(Player, GoodsMake, Type, Id, Idx) ->
	make_mod:make_set(Player, GoodsMake, Type, Id, Idx).


refresh_attr(TypeC, Id, Player) ->
	make_mod:refresh_attr(TypeC, Id, Player).

stren_ask(GoodsTake) ->
	case GoodsTake of
		#goods{goods_id=GoodsIs,type = Type, type_sub = Typesub, name_color = Color, class = Class, exts = #g_eq{streng = StrenLv0}} ->
			StrenLv = StrenLv0 + 1,
			stren_ask(0,GoodsIs,StrenLv,Color,Type,Typesub,Class);	
		_ ->
			{?ok,<<>>}
	end.

stren_ask(Player, Type, Id, Idx) ->
	case make_take(Player, Type, Id, Idx) of
		{?ok, _Player2, GoodsTake, _Bin} ->
			stren_ask(GoodsTake);
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.

stren_ask(Ref,GoodsId,StrenLv,Color,Type,Typesub,Class) ->
	{GoodsId2,StrenLv2,Color2,Type2,Typesub2,Class2}=
		case data_equip_make:get(GoodsId) of
				#d_equip_make{str_need=StrNeed,lv_last=LvLast,make1=Make1}->
					case StrenLv+1>=StrNeed of
						?true->
							NewGoods=bag_api:goods(Make1#d_make.goods),
							#goods{goods_id=NGoodsId,name_color=NColor,type=NType,type_sub=NTypeSub,class=NClass}=NewGoods,
							{NGoodsId,LvLast,NColor,NType,NTypeSub,NClass};
						_->
							{GoodsId,StrenLv+1,Color,Type,Typesub,Class}
					end;
				_->
					{GoodsId,StrenLv+1,Color,Type,Typesub,Class}
			end,
	case data_stren_get(StrenLv2,Color2,Type2,Typesub2,Class2) of
		#d_equip_stren{attr=Attr,money=Money} ->
			[_|AttrList]=tuple_to_list(Attr),
			F=fun(AttrValue,{Indxs,Idx})->
					  ?IF(AttrValue==0,{Indxs,Idx+1},{[Idx|Indxs],Idx+1})
					  end,
			{Indxs2,_}=lists:foldl(F,{[],1},AttrList),
			AttrTypeIdxS=[lists:nth(AttrIdx,?ATTR_TYPE_POS)||AttrIdx<-Indxs2],
			L=[{AttrType,element(NAttrIdx,Attr)}||{AttrType,NAttrIdx}<-AttrTypeIdxS],
			BinMsg = msg_stren_data_back(Ref,GoodsId2,StrenLv2,Color2,Money,L),
			{?ok, BinMsg};
		_->
			BinMsg = msg_stren_max(),
			{?ok, BinMsg}
	end.


%% 强化数据读取
data_stren_get(StrenLv, Color, Type, Typesub, Class) ->
	case case Type of
			 ?CONST_GOODS_EQUIP ->
				 data_equip_stren;
			 ?CONST_GOODS_WEAPON->
				 data_equip_stren;
			 ?CONST_GOODS_MAGIC ->
				 data_equip_stren;
			 _ ->
				 []
		 end of
		[] ->
			[];
		Module ->
			Module:get(Typesub,StrenLv, Color, Class)
	end.

%% 更新物品价格(强化等级变动时)
price_stren(#goods{goods_id = Gid, name_color = Color, class = Class, type = Type, type_sub = Typesub, exts = Exts} = Goods) ->
	case Exts of
		#g_eq{streng = StrenLv} when StrenLv =/= 0 ->
			case data_stren_get(StrenLv, Color, Type, Typesub, Class) of
				#d_equip_stren{sell_price = SellPrice} ->
					case data_goods:get(Gid) of
						#goods{price = Price} ->
							Goods#goods{price = Price + SellPrice};
						_ ->
							Goods
					end;
				_ ->
					Goods
			end;
		_ ->
			Goods
	end;
price_stren(Goods) ->
	Goods.

%%
%% Local Functions
%%
% 打造成功 [2512]
msg_make_ok(Type,Id,Idx)->
    RsList = app_msg:encode([{?int8u,Type},{?int32u,Id},{?int16u,Idx}]),
    app_msg:msg(?P_MAKE_MAKE_OK, RsList).


% 下一级装备强化数据返回 [2517]
msg_stren_data_back(Ref,GoodsId,Lv,Color,CostCoin,List)->
    Acc0 = app_msg:encode([{?int8u,Ref},
        {?int16u,GoodsId},{?int16u,Lv},
        {?int8u,Color},{?int32u,CostCoin},
        {?int16u,length(List)}]),
	Fun = fun({Type,TypeValue}, Acc) ->
				 Acc2 = msg_stren_cost_xxx(Type,TypeValue),
				 <<Acc/binary, Acc2/binary>>
		  end,
	RsList = lists:foldl(Fun, Acc0, List),
    app_msg:msg(?P_MAKE_STREN_DATA_BACK, RsList).

% 强化消耗材料信息块 [2518]
msg_stren_cost_xxx(Type,TypeValue)->
    app_msg:encode([{?int16u,Type},{?int16u,TypeValue}]).

% 不可强化或已达最高级 [2519]
msg_stren_max()->
    app_msg:msg(?P_MAKE_STREN_MAX,<<>>).

% 装备强化成功 [2520]
msg_strengthen_ok(Flag,Type,Id,Idx)->
	RsList = app_msg:encode([{?int8u,Flag},{?int8u,Type},{?int32u,Id},{?int8u,Idx}]),
	app_msg:msg(?P_MAKE_STRENGTHEN_OK, RsList).

% 法宝升阶成功 [2525]
msg_upgrade_ok(Type,Id,Idx)->
    RsList = app_msg:encode([{?int8u,Type},{?int32u,Id},{?int16u,Idx}]),
    app_msg:msg(?P_MAKE_UPGRADE_OK, RsList).

% 洗练数据返回 [2532]
msg_wash_back(?CONST_MAKE_WASH_TYPE_SKILL=Arg,SkillId)->
	RsList = app_msg:encode([{?int8u,Arg},{?int32u,SkillId}]),
	app_msg:msg(?P_MAKE_WASH_BACK, RsList);

msg_wash_back(Arg,List)->
	Acc0 = app_msg:encode([{?int8u,Arg},{?int16u,length(List)}]),
	RsList = lists:foldl(fun({Idx, Plus}, Acc) ->
								 Acc2 = app_msg:encode([{?int16u,Idx}]),
								 Acc3 = msg_wash_back2(Plus),
								 <<Acc/binary,Acc2/binary,Acc3/binary>>
						 end, Acc0, List),
	app_msg:msg(?P_MAKE_WASH_BACK, RsList).

msg_wash_back2(Plus) ->
	Acc0 = app_msg:encode([{?int16u, length(Plus)}]),
	lists:foldl(fun({Type,Color,Value,Max},Acc) ->
						Acc2 = app_msg:encode([{?int8u,Type},{?int8u,Color},
											   {?int32u,Value},{?int32u,Max}]),
						<<Acc/binary, Acc2/binary>>
				end, Acc0, Plus).
	
% 保留洗练属性成功 [2542]
msg_wash_ok(Type,Id,Idx) ->
    RsList = app_msg:encode([{?int8u,Type},{?int32u,Id},{?int16u,Idx}]),
    app_msg:msg(?P_MAKE_WASH_OK, RsList).

% 灵珠合成成功 [2552]
msg_compose_ok()->
    app_msg:msg(?P_MAKE_COMPOSE_OK,<<>>).

% 法宝拆分成功 [2582]
msg_magic_part_ok()->
    app_msg:msg(?P_MAKE_MAGIC_PART_OK,<<>>).

% 附魔成功 [2600]
msg_enchant_ok(Type,Id,Idx)->
    RsList = app_msg:encode([{?int8u,Type},{?int32u,Id},{?int16u,Idx}]),
	app_msg:msg(?P_MAKE_ENCHANT_OK, RsList).

% 附魔消耗 [2620]
msg_enchant_pay(Rmb)->
    RsList = app_msg:encode([{?int32u,Rmb}]),
    app_msg:msg(?P_MAKE_ENCHANT_PAY, RsList).

% 镶嵌宝石成功 [2561]
msg_pearl_inset_ok()->
    app_msg:msg(?P_MAKE_PEARL_INSET_OK,<<>>).


