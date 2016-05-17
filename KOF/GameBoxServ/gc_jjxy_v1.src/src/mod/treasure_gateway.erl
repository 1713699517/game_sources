%% Author: Kevin
%% Created: 2012-10-16
%% Description: TODO: Add description to pp_friend
-module(treasure_gateway).

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
%% 处理请求面板
gateway(?P_TREASURE_LEVEL_ID,#player{socket = Socket} = Player,Bin)->
	{LevelId} = app_msg:decode({?int32u},Bin),
	case treasure_api:request(Player, LevelId) of
		{?ok,Player,BinMsg}->
			?ok;
		{?error,Error} ->
			BinMsg = system_api:msg_error(Error),
			BinMsg
	end,
	app_msg:send(Socket,BinMsg),
	{?ok,Player};

%物品打造数据请求
gateway(?P_TREASURE_GOODS_ID,#player{socket = Socket} = Player,Bin)->
	{Type,_LevelId,GoodsId} = app_msg:decode({?int8u,?int8u,?int32u},Bin),
	case treasure_api:make(Player,Type,GoodsId)   of  
      {?ok,Player2,BinMsg} ->
		  app_msg:send(Socket,BinMsg),
	      {?ok,Player2};
      {?error,ErrorCode} ->
		  BinCode = system_api:msg_error(ErrorCode),
	      app_msg:send(Socket,BinCode),
		  {?ok,Player}
	end;
	
%% 请求商店面板
gateway(?P_TREASURE_SHOP_REQUEST,#player{socket = Socket}=Player,_Bin)->
	case treasure_api:shop_request() of
		{?ok,BinMsg} ->
			?ok;
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode)
	end,
	app_msg:send(Socket,BinMsg),
	{?ok,Player};

%% 请求刷新面板
gateway(?P_TREASURE_MONEY_REFRESH,#player{socket = Socket} = Player,_Bin)->
	case treasure_api:treasure_money_refresh(Player) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket,BinMsg),
	        {?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
	        app_msg:send(Socket, BinMsg),
            {?ok,Player}
	end;

%% 定时刷新
gateway(?P_TREASURE_INTERVAL_REFRESH,#player{socket = Socket} = Player,_Bin)->
	{?ok,BinMsg} = treasure_api:shop_request(),
	app_msg:send(Socket,BinMsg),
	{?ok,Player};
		


%% 请求购买 
gateway(?P_TREASURE_PURCHASE,#player{socket = Socket} = Player,Bin) ->
	{GoodsId} = app_msg:decode({?int32u},Bin),
	case treasure_api:purchase(Player,GoodsId) of 
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket,BinMsg),
	        {?ok,Player2};
		{?error,Error} ->
			ErrorCode = system_api:msg_error(Error),
			app_msg:send(Socket,ErrorCode),
	        {?ok,Player}
	end;

%% 副本id
gateway(?P_TREASURE_IS_COPY,#player{socket = Socket} = Player,Bin) ->
	{CopyId} = app_msg:decode({?int32u},Bin),
	{?ok,BinMsg} = treasure_api:is_copy(CopyId), 	
    app_msg:send(Socket,BinMsg),
	{?ok,Player};
	
	


%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.