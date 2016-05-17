%% Author: mirahs
%% Created: 2013-1-6
%% Description: TODO: Add description to team_gateway
-module(magic_equip_gateway).

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
%% 请求面板 
%% gateway(?P_MAGIC_EQUIP_REQUEST, #player{socket=Socket}= Player, Bin) ->
%% 	{Type} = app_msg:decode({?int16u},Bin),
%% 	magic_equip_api:request(Type),
%% 	{?ok, Player};

%% 强化 or 一键强化 (Type == 2)
gateway(?P_MAGIC_EQUIP_ENHANCED, #player{socket= Socket}= Player, Bin) ->
	{Type,TypeC,Id,MagicIdx,Bless,Protection} = app_msg:decode({?int8u,?int8u,?int32u,?int16u,?int16u,?int16u},Bin),
	case magic_equip_api:enhanced(Player, Type, TypeC, Id, MagicIdx, Bless, Protection) of
		{?ok, Player2, BinMsg} ->
			role_api:update_powerful_z(Player2),
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 请求下一级神器
gateway(?P_MAGIC_EQUIP_ASK_NEXT_ATTR,#player{socket= Socket}= Player, Bin) ->
	?MSG_ECHO("==================~w~n",[Bin]),
	{TypeSub,Lv,Color,Class} = app_msg:decode({?int8u,?int8u,?int8u,?int8u},Bin),
	BinMsg= magic_equip_api:ask_next_attr(TypeSub, Lv, Color, Class),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};


gateway(?P_MAGIC_EQUIP_ADVANCE,#player{socket= Socket}= Player , Bin) ->
	{TypeC,Id,Idx,HolyWaterId} = app_msg:decode({?int8u,?int32u,?int16u,?int16u},Bin),
	?MSG_ECHO("==================~w~n",[{TypeC,Id,Idx,HolyWaterId}]),
	case magic_equip_api:advance(Player, TypeC, Id, Idx, HolyWaterId) of
		{?ok, Player2, BinMsg} ->
			role_api:update_powerful_z(Player2),
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

gateway(?P_MAGIC_EQUIP_NEED_MONEY,#player{socket= Socket}= Player, Bin) ->
	{Type,TypeC,Id,Idx} = app_msg:decode({?int8u,?int8u,?int32u,?int16u},Bin),
	%% ?MSG_ECHO("----------------~w~n",[{Type,TypeC,Id, Idx}]),
%% 	need_rmb(TypeC,Type2,Id, Idx)
	BinMsg= magic_equip_api:need_rmb_msg(Type,TypeC,Id,Idx),
	app_msg:send(Socket, BinMsg),
	{?ok,Player};


gateway(ProtocolCode,Player,Binary)->
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.