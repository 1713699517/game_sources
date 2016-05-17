%% Author: Administrator
%% Created: 2012-11-13
%% Description: TODO: Add description to energy_gateway
-module(pet_gateway).

%%
%% Include files
%%
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([gateway/3]).


%% 宠物请求
gateway(?P_PET_REQUEST, Player= #player{socket= Socket, lv= Lv}, _Bin) ->
	case Lv >= ?CONST_PET_OPEN_LV of
		?true ->
			{?ok,Player2,BinMsg}= pet_api:request(Player),
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		_ ->
			ErrorCode = ?ERROR_PET_LACK_LV,
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{ok,Player}
	end;

%% 宠物需消耗钻石数
gateway(?P_PET_NEED_RMB, Player= #player{socket= Socket}, Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	BinMsg= pet_api:need_rmb(Type),
	app_msg:send(Socket, BinMsg),
	{ok,Player};

%% 召唤式神
gateway(?P_PET_CALL, Player= #player{socket= Socket}, Bin) ->
	{Id} = app_msg:decode({?int16u},Bin),
	case pet_api:call(Id) of
		{?ok,BinMsg} ->
			app_msg:send(Socket, BinMsg);
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg)
	end,
	{?ok,Player};

%% 宠物修炼
gateway(?P_PET_XIULIAN, Player= #player{socket= Socket}, Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	case pet_api:xiuliang(Type, Player) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket,BinMsg),
			{?ok,Player}
	end;

%% 请求幻化界面
gateway(?P_PET_HUANHUA_REQUEST,Player= #player{socket= Socket},_Bin)-> 
	BinMsg= pet_api:huanhua(),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 宠物幻化
gateway(?P_PET_HUANHUA,Player= #player{socket= Socket},Bin)-> 
	{Id} = app_msg:decode({?int16u},Bin),
	BinMsg= pet_api:huanhua(Id),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

