%% Author: Administrator
%% Created: 2012-6-25
%% Description: TODO: Add description to lib_chat
-module(chat_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
%%
%% Exported Functions
%%
-export([decode/1,pm_decode/1,
		 goods_data/1,
		 do_chat/3,
		 uid2lv2pro/1,
		 
		 msg_office_player/0,
		 msg_rece/17,
		 send_to_map/2,
		 send_to_all/1]).

%%
%% API Functions
%%
uid2lv2pro(Uid) ->
	case Uid == 0 of
		?true ->
			{1,1};
		_ ->
			case role_api:uid_to_player(Uid) of
				?null ->
					{1,1};
				#player{lv= Lv,pro= Pro} ->
					{Pro,Lv}
			end
	end.


goods_data(List)->
	Bag= role_api_dict:bag_get(),
	Equip= role_api_dict:equip_get(),
	Inn= role_api_dict:inn_get(),
	Fun=fun({Type,Id,Idx},{Acc, Len})->
				case make_mod:make_take(Bag,Equip,Inn,Type, Id, Idx) of
					{?ok,_Bag,_Equip,_Inn,Goods,_Bin}->
						Rs=bag_api:msg_goods(Goods),
						{<<Acc/binary,Rs/binary>>, Len + 1};
					_->
						{Acc, Len}
				end
		end,
	%% 1  0  1
	{RsList, Length}= lists:foldl(Fun, {<<>>, 0},List),
	RsList0 = app_msg:encode([{?int16u, Length}]),
	<<RsList0/binary, RsList/binary>>.
%% <<Type:8/big-integer-unsigned, Uid:32/big-integer-unsigned,MsgLen:16/big-integer-unsigned,
%% 		 Msg:MsgLen/binary, GoodsCount:16/big-integer-unsigned,Binary/binary>> = <<6,0,8,64,0,0,0,0,1,1,0,0,0,0,0,1>>

decode(<<Type:8/big-integer-unsigned, Uid:32/big-integer-unsigned,
		 MsgLen:16/big-integer-unsigned,Msg:MsgLen/binary,ArgType:8/big-integer-unsigned,TeamId:16/big-integer-unsigned,CopyId:16/big-integer-unsigned,
		  GoodsCount:16/big-integer-unsigned,Binary/binary>>) ->
	case GoodsCount of
		0 ->
			{Type,Uid,ArgType,TeamId,CopyId,Msg,[]};
		_->
			GoodsList=decode(Binary,GoodsCount,[]),
			{Type,Uid,ArgType,TeamId,CopyId,Msg,GoodsList}
	end.
%% 	{List, Msg} = decode(Binary, GoodsCount, []),
%% 	{Type,Uid,List,Msg}.
%% {Option} = app_msg:decode({?int8u},Bin), 
%% <<Bin:56/binary, Binary/binary>>=<<1,0,0,0,0,0,1>>.
decode(_, 0, Acc) ->Acc;
decode(<<Bin:7/binary, Binary/binary>>, GoodsCount, Acc) ->
	Data = app_msg:decode({?int8u,?int32u,?int16u},Bin),
	decode(Binary, GoodsCount - 1, [Data|Acc]).

pm_decode(<<NameMsgLen:8/big-integer-unsigned,NameMsg:NameMsgLen/binary,
			MsgLen:16/big-integer-unsigned,Msg:MsgLen/binary,
			GoodsCount:16/big-integer-signed, Binary/binary>>) ->
	case GoodsCount of
		0 ->
			{NameMsg,Msg,[]};
		_->
			GoodsList=pm_decode(Binary,GoodsCount,[]),
			{NameMsg,Msg,GoodsList}
	end.
pm_decode(<<Bin:3/binary, Binary/binary>>, GoodsCount, Acc) ->
	Data = app_msg:decode({?int8u,?int32u,?int16u},Bin),
	pm_decode(Binary, GoodsCount - 1, [Data|Acc]).


%%
%% Local Functions
%%
send_to_pm(Bin,ToUid)->
	broad_cast([ToUid],Bin).

send_to_map(Bin,Spid)->
	PlayerIDList=scene_api:uid_list(Spid),
	?MSG_ECHO("PlayerIDList:: ~w~n",[PlayerIDList]),
	broad_cast(PlayerIDList,Bin).

send_to_clan(Bin,Uid)->
	PlayerIDList=clan_api:clan_member_uid(Uid),
	broad_cast(PlayerIDList,Bin).

send_to_all(Bin)->
%% 	?MSG_ECHO("========start============~n",[]),
%% 	Time1= util:seconds(),
	EtsOnLines=ets:tab2list(?ETS_ONLINE),
%% 	?MSG_ECHO("==================================~w~n",[length(EtsOnLines)]),
	OnlinesLists= util:lists_split(EtsOnLines, ?CONST_BROAD_MAX_PLAYER),
	[broad_cast(OnlinesList,Bin)||OnlinesList<-OnlinesLists].
%% 	Time2= util:seconds(),
%% 	Time=Time2-Time1,
%% 	?MSG_ECHO("==============AllTime===============~w~n",[Time]).


%% send_to_all(Bin,MyID) ->
%% 	MS=ets:fun2ms(fun(#ets_online{uid=ID}) when ID =/= MyID -> ID end),
%% 	PlayerIDList=ets:select(?ETS_ONLINE,MS),
%% 	broad_cast(PlayerIDList,Bin).

%% send_to_clan(ClanID,Bin) ->
%% 	[{_,PlayerIDList}]=ets:lookup(?ETS_ONLINE_CLAN, ClanID),
%% 	broad_cast(PlayerIDList,Bin).


%% 世界
do_chat(?CONST_CHAT_WORLD, _Player, BinMsg) ->
	?MSG_ECHO("-------------~n",[]),
	send_to_all(BinMsg), 
	ok;

%% 当前
do_chat(?CONST_CHAT_MAP, #player{spid=Spid}, BinMsg) ->
	send_to_map(BinMsg,Spid),
	ok;

%% 队伍
do_chat(?CONST_CHAT_TEAM, _Player, _BinMsg) ->
	ok;

%% 帮派
do_chat(?CONST_CHAT_CLAN, #player{uid=Uid}, BinMsg) ->
	send_to_clan(BinMsg,Uid),
	ok;

%% 国家
do_chat(?CONST_CHAT_COUNTRY, _Player, _BinMsg) ->
	ok;

%% 系统
do_chat(?CONST_CHAT_SYSTEM, _Player, _BinMsg) ->
	ok;

%% 小喇叭
do_chat(?CONST_CHAT_SUONA, _Player, _BinMsg) ->
	ok;

%% 传闻
do_chat(?CONST_CHAT_HEARSAY, _Player, _BinMsg) ->
	ok;

%% 私聊
do_chat(?CONST_CHAT_PM, _Player, {ToUid, BinMsg}) ->
	send_to_pm(BinMsg,ToUid),
	ok;

do_chat(_Type, _BinMsg, _BinMsg) ->
	ok.
	
broad_cast(PlayerIDList,Bin)->
%% 	?MSG_ECHO("====================~w~n",[length(PlayerIDList)]),
%% 	Time1= util:seconds(),
	Fun= fun() ->
				 [app_msg:send(PlayerID#player.socket,Bin)||PlayerID<-PlayerIDList]
		 end,
	spawn(Fun).
%% 	Time2= util:seconds(),
%% 	Time=Time1-Time2,
%% 	?MSG_ECHO("=============================~w~n",[Time]).

%% 	[app_msg:send(PlayerID,Bin)||PlayerID<-PlayerIDList].

% app_msg:encode([{int32u,123123}]).
% 收到频道聊天 [9530]
msg_rece(ChannelId,Uid,Name,Sex,Pro,Lv,Country,_TitleList,ArgsType,GoodsBin,TeamId,CopyId,Msg,PUid,PName,PPro,PLv)->
	Rs=app_msg:encode([{?int8u,ChannelId},{?int32u,Uid},{?string,Name},{?int8u,Sex},{?int8u,Pro},
					   {?int16u,Lv},{?int8u,Country},{?int32u,PUid},{?string,PName},{?int8u,PPro},{?int16u,PLv}]),
	Rs1=app_msg:encode([{?int16u, 0}]),
	Rs2=app_msg:encode([{?stringl,Msg}]),
	Rs3=app_msg:encode([{?int8u, ArgsType}]),
	Rs4=app_msg:encode([{?int16u, TeamId},{?int16u, CopyId}]),
    app_msg:msg(?P_CHAT_RECE, <<Rs/binary,Rs1/binary,Rs2/binary,Rs3/binary,Rs4/binary,GoodsBin/binary>>).

% 玩家不在线 [9527]
msg_office_player()->
    app_msg:msg(?P_CHAT_OFFICE_PLAYER,<<>>).

