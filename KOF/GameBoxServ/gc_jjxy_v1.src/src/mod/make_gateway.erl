%% Author: Administrator
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_make
-module(make_gateway).

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
%% 打造
gateway(?P_MAKE_EQUIP, #player{socket = Socket} = Player, Bin) ->
	{Type,Id,Idx,Gid} = app_msg:decode({?int8u,?int32u,?int16u,?int32u},Bin),
	case make_mod:make(Player, Type, Id, Idx, Gid) of
		{?ok,NewPlayer,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok, NewPlayer};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 强化
gateway(?P_MAKE_KEY_STREN, #player{socket=Socket}=Player,Bin) ->
{StrenType,Type,Id,Idx,Discount,Dou,CostTyoe} = app_msg:decode({?int8u,?int8u,?int32u,?int16u,?bool,?bool,?int8u},Bin),
	case make_mod:stren_key(Player,StrenType,Type,Id,Idx,Discount,Dou,CostTyoe) of
		{?ok,Player2,BinMsg} ->
			role_api:update_powerful_z(Player2),
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 强化
gateway(?P_MAKE_STRENGTHEN, #player{socket=Socket,uid=Uid} = Player, Bin) ->
	{Type,Id,Idx,Discount,Double,CostType} = app_msg:decode({?int8u,?int32u,?int16u,?bool,?bool,?int8u},Bin),
	case make_mod:stren(Player, Type, Id, Idx, Discount, Double, CostType) of
		{?ok,Player2,BinMsg} ->
			role_api:update_powerful_z(Player2),
			task_daily_api:check_cast(Uid,?CONST_TASK_DAILY_STRENGTH_EQUIP,0),
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 请求强化数据       
gateway(?P_MAKE_STREN_DATA_ASK, #player{socket=Socket} = Player, Bin) ->
	{Ref,GoodsId,StrenLv,Color,Type,TypeSub,Class} = app_msg:decode({?int8u,?int16u,?int16u,?int8u,?int8u,?int8u,?int8u},Bin),
	{?ok,BinMsg} = make_api:stren_ask(Ref,GoodsId,StrenLv,Color,Type,TypeSub,Class),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 法宝升阶
gateway(?P_MAKE_MAGIC_UPGRADE, #player{socket=Socket} = Player, Bin) ->
	{Type,Id,Idx} = app_msg:decode({?int8u,?int32u,?int16u},Bin),
%% 	case make_mod:upgrade(Player, Type, Id, Idx) of
%% 		{?ok,Player2,BinMsg} ->
%% 			app_msg:send(Socket, BinMsg),
%% 			{?ok, Player2};
%% 		{?error, ErrorCode} ->
%% 			BinMsg = system_api:msg_error(ErrorCode),
%% 			app_msg:send(Socket, BinMsg),
			{?ok, Player};
%% 	end;

%% 装备洗练
gateway(?P_MAKE_WASH, #player{socket=Socket} = Player, Bin) ->
	{Type,Id,Idx,Arg} = app_msg:decode({?int8u,?int32u,?int16u,?int8u},Bin),
%% 	case make_mod:wash(Player, Type, Id, Idx, Arg) of
%% 		{?ok,Player2,BinMsg} ->
%% 			app_msg:send(Socket, BinMsg),
%% 			{?ok, Player2};
%% 		{?error, ErrorCode} ->
%% 			BinMsg = system_api:msg_error(ErrorCode),
%% 			app_msg:send(Socket, BinMsg),
			{?ok, Player};
%% 	end;

%%  是否替换洗练属性
gateway(?P_MAKE_WASH_SAVE, #player{socket=Socket} = Player, Bin) ->
	{Save,Idx} = app_msg:decode({?bool,?int16u},Bin),
%% 	case make_mod:wash_replace(Player, Idx, Save) of
%% 		{?ok,Player2,BinMsg} ->
%% 			app_msg:send(Socket, BinMsg),
%% 			{?ok, Player2};
%% 		{?error, ErrorCode} ->
%% 			BinMsg = system_api:msg_error(ErrorCode),
%% 			app_msg:send(Socket, BinMsg),
%% 			{?ok, Player}
%% 	end;
	{?ok, Player};

%%  宝石合成
gateway(?P_MAKE_MAKE_COMPOSE, #player{socket=Socket} = Player, Bin) ->
	{Type,Arg,Count} = app_msg:decode({?int8u,?int16u,?int16u},Bin),
	case make_mod:compose(Type, Player, Arg, Count) of
		{?ok,Player2,BinMsg} ->
			role_api:update_powerful_z(Player2),
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%%  宝石镶嵌
gateway(?P_MAKE_PEARL_INSET, #player{socket=Socket} = Player, Bin) ->
	{Type,Id,Idx,PearlType} = app_msg:decode({?int8u,?int32u,?int16u,?int16u},Bin),
	case make_mod:inset(Player, Type, Id, Idx, PearlType) of
		{?ok,Player2,BinMsg} ->
			role_api:update_powerful_z(Player2),
			BinOK=make_api:msg_pearl_inset_ok(),
			app_msg:send(Socket, <<BinMsg/binary,BinOK/binary>>),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%%  灵珠拆除
gateway(?P_MAKE_PEARL_REMOVE, #player{socket=Socket} = Player, Bin) ->
	{Type,Id,Idx,Pearlid} = app_msg:decode({?int8u,?int32u,?int16u,?int32u},Bin),
%% 	case make_mod:remove(Player, Type, Id, Idx, Pearlid) of
%% 		{?ok,Player2,BinMsg} ->
%% 			app_msg:send(Socket, BinMsg),
%% 			{?ok, Player2};
%% 		{?error, ErrorCode} ->
%% 			BinMsg = system_api:msg_error(ErrorCode),
%% 			app_msg:send(Socket, BinMsg),
			{?ok, Player};
%% 	end;

%%  法宝拆分
gateway(?P_MAKE_MAGIC_PART, #player{socket=Socket} = Player, Bin) ->
	{Type,Id,Idx} = app_msg:decode({?int8u,?int32u,?int16u},Bin),
%% 	case make_mod:part(Player, Type, Id, Idx) of
%% 		{?ok,Player2,BinMsg} ->
%% 			app_msg:send(Socket, BinMsg),
%% 			{?ok, Player2};
%% 		{?error, ErrorCode} ->
%% 			BinMsg = system_api:msg_error(ErrorCode),
%% 			app_msg:send(Socket, BinMsg),
			{?ok, Player};
%% 	end;

%% 装备附魔 
gateway(?P_MAKE_ENCHANT, #player{socket=Socket} = Player, Bin) ->
	{Type,Id,Idx,Arg} = app_msg:decode({?int8u,?int32u,?int8u,?int8u},Bin),
	case make_mod:make_enchant(Player,Type,Id,Idx,Arg) of
		{?ok,Player2,BinMsg} ->
			role_api:update_powerful_z(Player2),
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 请求附魔消耗
gateway(?P_MAKE_ENCHANT_S, #player{socket=Socket} = Player, _Bin) ->
	Data=util:date_Ymd(),
	{PData,Count}=role_api_dict:make_get(),
	case Data==PData of
		?true->
			BinMsg=make_api:msg_enchant_pay(Count*2);
		_->
			role_api_dict:make_set({Data,1}),
			BinMsg=make_api:msg_enchant_pay(1*2)
	end,
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.
