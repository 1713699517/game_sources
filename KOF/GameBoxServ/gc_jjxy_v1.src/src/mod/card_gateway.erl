%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :Mod Funs(gamecore.cn) dreamxyp@gmail.com
%%%
%%% Created : 2012-12-18
%%% -------------------------------------------------------------------
-module(card_gateway).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% MOD exports
-export([gateway/3]). 


%% ====================================================================
%% gateway functions
%% ====================================================================


gateway(?P_CARD_GETS, Player=#player{uid=Uid}, Binary) ->
	{Ids} = app_msg:decode({?string},Binary),
	case card_api:gets(Ids,Uid) of
		{?ok,GoodsId} ->
			GoodsGive = 
				if
					is_record(GoodsId, give) ->
						GoodsId;
					?true ->
						#give{goods_id 		= GoodsId,		% 物品ID
							  count			= 1,			% 数量
							  streng 		= 0,			% [BN]强化等级
							  name_color	= 1,			% 物品名称的颜色
							  bind	  		= 1,			% 是否绑定(0:不绑定 1:绑定)
							  expiry_type	= 0,			% 有效期类型，0:不失效，1：秒，  2：天，请多预留几个以后会增加
							  expiry		= 0				%   有效期，到期后自动消失，并发系统邮件通知
							 }
				end,					
			% ?MSG_ECHO("5555555555555555~n~p~n", [GoodsId]),
			Goods = bag_api:goods(GoodsGive),
			Bag   = role_api_dict:bag_get(),
			case bag_api:goods_set([gateway,[],<<"新手卡">>],Player,Bag,[Goods]) of
				{?error, ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Player#player.socket, BinMsg),
					{?ok, Player};
				{?ok, Player2,Bag2,GoodBin,BinMsg} ->
					role_api_dict:bag_set(Bag2),
					BinMsg2 = card_api:msg_succeed([Goods]),
					app_msg:send(Player#player.socket, <<GoodBin/binary,BinMsg/binary,BinMsg2/binary>>),
					{?ok, Player2}
			end;
		{?error,ErrorCode} -> 
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, BinMsg),
			{?ok, Player}
	end;
 
gateway(?P_CARD_SALES_ASK, #player{socket = Socket} = Player, _Binary) ->
	{Player2,StartListData,Rece}=card_api:sales_ask(Player),
	BinMsg=card_api:msg_sales_data(StartListData),
	RBinMsg=card_api:msg_rece(?IF(Rece==?undefined,[],Rece)),
	app_msg:send(Socket, <<BinMsg/binary,RBinMsg/binary>>), 
	{?ok,Player2};

gateway(?P_CARD_SALES_GET, #player{socket = Socket} = Player, Binary) ->
	{Id,IdStep} = app_msg:decode({?int16u,?int16u},Binary),
	case card_api:sales_get(Player,Id,IdStep) of
		{?ok, Player2, BinMsg} ->
			case BinMsg of
				<<>> ->
					{?ok, Player2};
				_->
					BinMsg2=card_api:msg_get_ok(),
					app_msg:send(Socket, <<BinMsg/binary,BinMsg2/binary>>),
					{?ok, Player2}
			end; 
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

gateway(ProtocolCode, Player, Binary) ->
	?MSG_ERROR("?error In ProtocolCode:~p Player:~p Binary:~w~n",[ProtocolCode, Player, Binary]),
	{?ok, Player}.