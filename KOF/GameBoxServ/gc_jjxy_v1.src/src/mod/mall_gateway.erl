%% Author: Administrator
%% Created: 2012-11-13
%% Description: TODO: Add description to energy_gateway
-module(mall_gateway).

%%
%% Include files
%%
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([gateway/3]).


%% 请求店铺数据列表
gateway(?P_SHOP_REQUEST, #player{socket = Socket,lv = Lv,uid = Uid} = Player, Bin) ->
	{FunId,ID,Class} = 
		case app_msg:decode({?int16u,?int16u},Bin) of
			{10, R} ->
				{?CONST_FUNC_OPEN_SHOP, 10, R};
			{20, R} ->
				{?CONST_FUNC_OPEN_CHAPER_SHOP, 20, R};
			{A, B} ->
				{0, A, B}
		end,
	BinMsg = 	
		case is_funs_api:check_fun(FunId) of
			?CONST_TRUE ->
				case mall_mod:ask(Uid,Lv, ID, Class) of
					{?ok, BinMsg0} ->
						BinMsg0;
					{?error, ErrorCode} ->
						system_api:msg_error(ErrorCode)
				end;
			_ ->
				system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN)
		end,
	app_msg:send(Socket, BinMsg),
	{?ok,Player};

%% 请求购买物品
gateway(?P_SHOP_BUY, #player{socket = Socket} = Player, Bin) ->
	{Id, ClassId, Idx, GoodsId, BuyCount,Ctype} = app_msg:decode({?int16u,?int16u,?int16u,?int16u,?int16u,?int16u},Bin),
	case BuyCount > 0 of
		?true ->
			case mall_mod:buy(Player, Id, ClassId, Idx, GoodsId, BuyCount,Ctype)  of  
				{?ok, Player2, Bin2} ->
					app_msg:send(Socket, <<Bin2/binary>>),
					{?ok,Player2};
				{?error, ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg),
					{?ok,Player}
			end;
		_ ->
			BinMsg = system_api:msg_error(?ERROR_MALL_NOT_EQUAL),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	
	end;

%% 请求积分数据
gateway(?P_SHOP_ASK_INTEGRAL, #player{socket = Socket, info = #info{integral = Integral}} = Player, _Bin) ->
	BinMsg = mall_api:msg_integral_back(Integral),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};	

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

