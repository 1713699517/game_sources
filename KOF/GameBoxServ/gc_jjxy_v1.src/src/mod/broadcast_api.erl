%% Author: kevin
%% Created: 2012-11-15
%% Description: TODO: Add description to activity_api
-module(broadcast_api).

%%
%% Include files
%%
-include("../include/comm.hrl").
%%     
%%
-export([%msg_broadcast_chat_note/1,
		 msg_broadcast_sys_open/0,
		 msg_broadcast_sys_stop/1,
		 msg_broadcast_arena_win_count/2,
		 msg_broadcast_arena_s/3,
		 msg_broadcast_arena_one/2,
		 msg_broadcast_inn_recruit/3,
		 msg_broadcast_world_start/1,
		 msg_broadcast_world_rey/0,
		 msg_broadcast_world_show/1,
		 msg_broadcast_world_die/3,
		 msg_broadcast_world_end/0,
		 msg_broadcast_partner/1,
		 msg_broadcast_magic/2,
		 msg_broadcast_hero/2,
		 msg_broadcast_frend/2,
		 msg_broadcast_career/2,
%% 		 msg_broadcast_equip/2,
		 msg_broadcast_shoot/2,
		 msg_broadcast_douqi/2,
		 msg_broadcast_vip_lv/2
		 ]).


%% 欢迎进入拳皇咆哮！！！
msg_broadcast_sys_open()->
	Pos=data_broadcast:get(?CONST_BROAD_ID_SERVER_OPEN),
	BroadcastId = ?CONST_BROAD_ID_SERVER_OPEN,
	MsgList 	= [],
	msg_broadcast(Pos,BroadcastId,MsgList). 

%% 为更好服务大家，此服将于#分钟后进行维护更新，给您带来的不便敬请谅解！
msg_broadcast_sys_stop(Time)->
	Pos=data_broadcast:get(?CONST_BROAD_ID_SERVER_CLOSE),
	BroadcastId = ?CONST_BROAD_ID_SERVER_CLOSE,
	MsgList 	= [{?CONST_BROAD_NUMBER,Time}],
	msg_broadcast(Pos,BroadcastId,MsgList). 


%% #达成了竞技场#连斩，GM也无法阻止TA了！
msg_broadcast_arena_win_count({ Uid,Name,Lv,NameColor,Pro},Count)->
	?MSG_ECHO("--------Win Count -------~w~n~n~n~n~n~n~n~n~n~n~n~n~n~n~n",[Count]),
	Pos=data_broadcast:get(?CONST_BROAD_ID_ARENA_10),
	BroadcastId=if
					Count =:= ?CONST_ARENA_WIN_LINK_10 -> ?CONST_BROAD_ID_ARENA_10;
					Count =:= 20 -> ?CONST_BROAD_ID_ARENA_20;
					Count =:= 30 -> ?CONST_BROAD_ID_ARENA_30;
					Count =:= ?CONST_ARENA_WIN_LINK_50 -> ?CONST_BROAD_ID_ARENA_50;
					Count =:= ?CONST_ARENA_WIN_LINK_100 -> ?CONST_BROAD_ID_ARENA_100;
					?true->?CONST_BROAD_ID_ARENA_10
				end,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_NUMBER,Count}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% #在竞技终结了#的#连胜！
msg_broadcast_arena_s({ Uid,Name,Lv,NameColor,Pro},{ PUid,PName,PLv,PNameColor,PPro},Count)->
	Pos=data_broadcast:get(?CONST_BROAD_ID_ARENA_S_10),
	BroadcastId=?CONST_BROAD_ID_ARENA_S_10,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_PLAYER_NAME, PUid,PName,PLv,PNameColor,PPro},
				 {?CONST_BROAD_NUMBER,Count}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% #击败了#，成为KO榜第一！
msg_broadcast_arena_one({ Uid,Name,Lv,NameColor,Pro},{ PUid,PName,PLv,PNameColor,PPro})->
	?MSG_ECHO("--------No1-------~n",[]),
	Pos=data_broadcast:get(?CONST_BROAD_ID_ARENA_ONE),
	BroadcastId=?CONST_BROAD_ID_ARENA_ONE,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_PLAYER_NAME, PUid,PName,PLv,PNameColor,PPro}],
	
	msg_broadcast(Pos,BroadcastId,MsgList).

%% #大展宏图，将名将#招至麾下。
msg_broadcast_inn_recruit({ Uid,Name,Lv,NameColor,Pro},PartnerId,Color)->
	Pos=data_broadcast:get(?CONST_BROAD_INN_RECRUIT),
	BroadcastId=?CONST_BROAD_INN_RECRUIT,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_PARTNER_ID,PartnerId,Color}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% 波涛暗涌如潮，战斗一触即发,三界Boss将在#分钟后出现，请大家做好迎战准备。
msg_broadcast_world_start(Time)->
	?MSG_ECHO("--------------Time   ------~w~n",[Time]),
	Pos=data_broadcast:get(?CONST_BROAD_ID_WORLD_START),
	BroadcastId=?CONST_BROAD_ID_WORLD_START,
	MsgList	   =[{?CONST_BROAD_NUMBER,Time}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% 你听到了如海潮般狂怒的呼啸吗，你感受到了似烈火般灼热的燃烧吗，
%% 三界Boss将在1分钟后出现，请大家提前进入场景。
msg_broadcast_world_rey()->
    ?MSG_ECHO("--------------One minute   ------~n",[]),	
	Pos=data_broadcast:get(?CONST_BROAD_ID_WORLD_REY),
	BroadcastId=?CONST_BROAD_ID_WORLD_REY,
	MsgList	   =[],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% 沧海一声笑，大地一阵吼，世界Boss#出现了！
msg_broadcast_world_show(BossId)->
	Pos=data_broadcast:get(?CONST_BROAD_ID_WORLD_SHOW),
	BroadcastId=?CONST_BROAD_ID_WORLD_SHOW,
	MsgList	   =[{?CONST_BROAD_MONSTERID,BossId}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% #给予了世界boss#最后一击，获得了#美刀。
msg_broadcast_world_die({ Uid,Name,Lv,NameColor,Pro},BossId,
						{Gold,Rmb,Star,Renown,ClanValue,GoodsList})->
	?MSG_ECHO("--------------world boss   ------~w~n",[Gold]),
	Pos=data_broadcast:get(?CONST_BROAD_ID_WORLD_DIE),
	BroadcastId=?CONST_BROAD_ID_WORLD_DIE,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_MONSTERID,BossId},
				 {?CONST_BROAD_REWARD,Gold,Rmb,Star,Renown,ClanValue,GoodsList}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% 世界Boss已撤离，请等待下一次挑战。
msg_broadcast_world_end()->
	Pos=data_broadcast:get(?CONST_BROAD_ID_WORLD_END),
	BroadcastId=?CONST_BROAD_ID_WORLD_END,
	MsgList	   =[],
	msg_broadcast(Pos,BroadcastId,MsgList).

%%你获得了极品伙伴不知火舞。
msg_broadcast_partner({ Uid,Name,Lv,NameColor,Pro})->
	Pos=data_broadcast:get(?CONST_BROAD_ID_INN_CARD),
	BroadcastId=?CONST_BROAD_ID_INN_CARD,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro}],
	msg_broadcast(Pos,BroadcastId,MsgList).
	
%% 天雷滚滚，风云变色。#经过千锤百炼，终于锻造出极品法宝#，脸上洋溢着幸福的微笑。
msg_broadcast_magic({ Uid,Name,Lv,NameColor,Pro},Goods)->
	Pos=data_broadcast:get(?CONST_BROAD_ID_TALISMAN),
	BroadcastId=?CONST_BROAD_ID_TALISMAN,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_GOODSID,Goods}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% 天雷滚滚，风云变色。#经过千锤百炼，终于锻造出极品装备#，脸上洋溢着幸福的微笑。
%% msg_broadcast_equip({ Uid,Name,Lv,NameColor,Pro},Goods)->
%% 	Pos=data_broadcast:get(?CONST_BROAD_ID_EQUIPMENT),
%% 	BroadcastId=?CONST_BROAD_ID_EQUIPMENT,
%% 	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
%% 				 {?CONST_BROAD_GOODSID,Goods}],
%% 	msg_broadcast(Pos,BroadcastId,MsgList).

%% #运气极佳，获得了至尊大奖，#美刀。
msg_broadcast_shoot({Uid,Name,Lv,NameColor,Pro},Gold) ->
	Pos=data_broadcast:get(?CONST_BROAD_TOP_PRIZE),
	BroadcastId=?CONST_BROAD_TOP_PRIZE,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_REWARD,Gold,0,0,0,0,[]}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% #在领悟斗气中，运气爆发，获得了#。
msg_broadcast_douqi({ Uid,Name,Lv,NameColor,Pro},DouqiId) ->
	Pos=data_broadcast:get(?CONST_BROAD_COMPREHEND_GOLDEN_ORANGE),
	BroadcastId=?CONST_BROAD_COMPREHEND_GOLDEN_ORANGE,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_DOUQI_ID,DouqiId}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% #英勇善战，成功升级到VIP#。
msg_broadcast_vip_lv({ Uid,Name,Lv,NameColor,Pro},VipLv) ->
	Pos=data_broadcast:get(?CONST_BROAD_VIP_5),
	BroadcastId=?CONST_BROAD_VIP_5,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_VIP_LV,VipLv}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% #英勇善战，击败了#。
msg_broadcast_hero({ Uid,Name,Lv,NameColor,Pro},CopyId) ->
	Pos=data_broadcast:get(?CONST_BROAD_COPY_HERO),
	BroadcastId=?CONST_BROAD_COPY_HERO,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_COPY_ID,CopyId}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% #以一敌百，击败了#。
msg_broadcast_frend({ Uid,Name,Lv,NameColor,Pro},CopyId) ->
	Pos=data_broadcast:get(?CONST_BROAD_COPY_FREND),
	BroadcastId=?CONST_BROAD_COPY_FREND,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_COPY_ID,CopyId}],
	msg_broadcast(Pos,BroadcastId,MsgList).

%% #越战越勇，通过了拳皇生涯 - #。
msg_broadcast_career({ Uid,Name,Lv,NameColor,Pro},CopyId) ->
	Pos=data_broadcast:get(?CONST_BROAD_COPY_CAREER),
	BroadcastId=?CONST_BROAD_COPY_CAREER,
	MsgList	   =[{?CONST_BROAD_PLAYER_NAME, Uid,Name,Lv,NameColor,Pro},
				 {?CONST_BROAD_COPY_ID,CopyId}],
	msg_broadcast(Pos,BroadcastId,MsgList).


%% 
%% Local Functions
%%
% 游戏广播 [810]
%% 广播字段类型--角色名字  	1 CONST_BROAD_PLAYER_NAME 	-> MsgList = [{?CONST_BROAD_PLAYER_NAME, Uid,Uname,Lv}]
%% 广播字段类型--家族名字  	2 CONST_BROAD_CLAN_NAME	 	-> MsgList = [{?CONST_BROAD_CLAN_NAME,ClanName}]
%% 广播字段类型--团队名字 	3 CONST_BROAD_GROUP_NAME	-> MsgList = [{?CONST_BROAD_GROUP_NAME,GroupName}]
%% 广播字段类型--普通数字 	51 CONST_BROAD_NUMBER		-> MsgList = [{?CONST_BROAD_NUMBER,Number}]
%% 广播字段类型--地图ID  	52 CONST_BROAD_MAPID		-> MsgList = [{?CONST_BROAD_MAPID,MapId}]
%% 广播字段类型--阵营ID  	53 CONST_BROAD_COUNTRYID	-> MsgList = [{?CONST_BROAD_COUNTRYID,CountryId}]
%% 广播字段类型--物品ID  	54 CONST_BROAD_GOODSID		-> MsgList = [{?CONST_BROAD_GOODSID,Goods}]
%% 广播字段类型--怪物ID  	55 CONST_BROAD_MONSTERID 	-> MsgList = [{?CONST_BROAD_MONSTERID,MonsterId}]
%% 广播字段类型--怪物ID  	56 CONST_BROAD_CIRCLE_CHAP 	-> MsgList = [{?CONST_BROAD_MONSTERID,ChapId,Color}]
%% 广播字段类型--怪物ID  	57 CONST_BROAD_REWARD	 	-> MsgList = [{?CONST_BROAD_MONSTERID,Gold,Rmb,Star,Renown,ClanValue,BinMsg}]
%% 广播字段类型--怪物ID  	58 CONST_BROAD_PILROAD_ID 	-> MsgList = [{?CONST_BROAD_MONSTERID,PilroadId}]
msg_broadcast(Position,BroadcastId,MsgList)->
    BinData1 = app_msg:encode([{?int16u,BroadcastId},{?int8u,Position},{?int16u,length(MsgList)}]),
	BinData2 = msg_broadcast(MsgList,<<>>), 
%% 	?MSG_ECHO("------------~p~n",[MsgList]),
	app_msg:msg(?P_SYSTEM_BROADCAST, <<BinData1/binary, BinData2/binary>>).

msg_broadcast([{?CONST_BROAD_PLAYER_NAME, Uid,Uname,Lv,NameColor,Pro}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_PLAYER_NAME},{?int32u,Uid},
							  {?string,Uname},{?int16u,Lv},{?int8u,NameColor},{?int16u,Pro}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_CLAN_NAME,ClanName}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_CLAN_NAME},{?string,ClanName}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_GROUP_NAME,GroupName}|MsgList],BinAcc) -> 
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_GROUP_NAME},{?string,GroupName}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_STRING,String}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_STRING},{?string,String}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_NUMBER,Number}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_NUMBER},{?int32u,Number}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_MAPID,MapId}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_MAPID},{?int16u,MapId}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_COUNTRYID,CountryId}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_COUNTRYID},{?int8u,CountryId}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_GOODSID,Goods}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_GOODSID}]),
	BinGoods= bag_api:msg_goods(Goods),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary, BinGoods/binary>>);
msg_broadcast([{?CONST_BROAD_MONSTERID,MonsterId}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_MONSTERID},{?int16u,MonsterId}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_CIRCLE_CHAP,ChapId}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_CIRCLE_CHAP},{?int16u,ChapId}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
%% msg_broadcast([{?CONST_BROAD_REWARD,Gold}|MsgList],BinAcc) ->
%% 	BinData = app_msg:encode([{?int8u,?CONST_BROAD_REWARD},{?int32u,Gold}]),
%% 	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>); 
msg_broadcast([{?CONST_BROAD_REWARD,Gold,Rmb,Star,Renown,ClanValue,GoodsList}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_REWARD},{?int32u,Gold},{?int32u,Rmb},{?int32u,Star},
							  {?int32u,Renown},{?int32u,ClanValue},{?int16u,length(GoodsList)}]),
	Fun=fun(Goods,BinData0)->
				case is_record(Goods,goods) of
					?true->
						BinGoods=goods_api:msg_goods(Goods),
						<<BinData0/binary,BinGoods/binary>>;
					_->
						BinData0
				end
		end,
	Rs=lists:foldl(Fun,BinData,GoodsList),
	msg_broadcast(MsgList,<<BinAcc/binary,Rs/binary>>);
msg_broadcast([{?CONST_BROAD_PILROAD_ID,PilroadId}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_PILROAD_ID},{?int16u,PilroadId}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>); 
msg_broadcast([{?CONST_BROAD_NAME_COLOR,Color}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_NAME_COLOR},{?int8u,Color}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_STARID,StarId}|MsgList],BinAcc) ->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_STARID},{?int16u,StarId}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_PARTNER_ID,PartnerId,Color}|MsgList],BinAcc)->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_PARTNER_ID},{?int16u,PartnerId},{?int8u,Color}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_COPY_ID,CopyId}|MsgList],BinAcc)->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_COPY_ID},{?int16u,CopyId}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_DOUQI_ID,DouqiId}|MsgList],BinAcc)->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_DOUQI_ID},{?int16u,DouqiId}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([{?CONST_BROAD_VIP_LV,VipLv}|MsgList],BinAcc)->
	BinData = app_msg:encode([{?int8u,?CONST_BROAD_VIP_LV},{?int8u,VipLv}]),
	msg_broadcast(MsgList,<<BinAcc/binary, BinData/binary>>);
msg_broadcast([],BinAcc) -> BinAcc.
	
	
	
	
	

