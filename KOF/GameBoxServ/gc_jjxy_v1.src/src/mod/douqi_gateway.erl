%% Author: tanwer
%% Created: 2013-7-30
%% Description: TODO: Add description to douqi_gateway
-module(douqi_gateway).

%%
%% Include files
%%
-include("comm.hrl").
%%
%% Exported Functions
%%
-export([gateway/3]).

%%
%% API Functions

%% 请求装备斗气界面
gateway(?P_SYS_DOUQI_ASK_USR_GRASP, Player, _Bin) ->
	case douqi_api:ask_equip_douqi(Player#player.lv) of
		{?ok,BinMsg} ->
			?ok;
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode)
	end,
	app_msg:send(Player#player.socket, BinMsg),
	{?ok, Player};

%% 请求领悟斗气界面
gateway(?P_SYS_DOUQI_ASK_GRASP_DOUQI, Player, _Bin) ->
	case douqi_api:ask_grasp_douqi(Player#player.vip#vip.lv) of
		{ok,BinMsg} ->
			ok;
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode)
	end,
	app_msg:send(Player#player.socket, BinMsg),
	{?ok, Player};

%% 请求开始领悟
gateway(?P_SYS_DOUQI_ASK_START_GRASP, Player, Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	case douqi_api:ask_start_grasp(Player,Type) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, BinMsg),
			{?ok, Player};
		{?ok,Player2,BinMsg} ->
			app_msg:send(Player#player.socket, BinMsg),
			{?ok,Player2}
	end;

%% 请求一键吞噬
gateway(?P_SYS_DOUQI_ASK_EAT, Player, Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	case douqi_api:eat_storage(Player#player.uid,Type) of
		{ok,BinMsg} ->
			ok;
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode)
	end,
	app_msg:send(Player#player.socket, BinMsg),
	{?ok, Player};

%% 请求拾取斗气
gateway(?P_SYS_DOUQI_ASK_GET_DQ, Player, Bin) ->
	{LanId} = app_msg:decode({?int8u},Bin),
	case douqi_api:ask_pickup(LanId) of
		{ok,BinMsg} ->
			ok;
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode)
	end,
	app_msg:send(Player#player.socket, BinMsg),
	{?ok, Player};


%% 请求分解斗气
gateway(?P_SYS_DOUQI_DQ_SPLIT, Player, Bin) -> %% 功能暂时关闭
%% 	{Role, LanId} = app_msg:decode({?int16u,?int8u},Bin),
%% 	case douqi_api:ask_split(Player#player.uid,Role, LanId) of
%% 		{?ok,BinMsg} ->
%% 			?ok;
%% 		{?error,ErrorCode} ->
%% 			BinMsg=system_api:msg_error(ErrorCode)
%% 	end,
	BinMsg=system_api:msg_error(?ERROR_DOUQI_NOT_START),
	app_msg:send(Player#player.socket, BinMsg),
	{?ok, Player};

%% 请求移动斗气位置
gateway(?P_SYS_DOUQI_ASK_USE_DOUQI, Player, Bin) ->
	{RoleId,DqId,LanidStart,LanidEnd} = app_msg:decode({?int16u,?int32u,?int8u,?int8u},Bin), ?MSG_ECHO("99999 ~w~n~n",[{RoleId,LanidStart}]),
	case LanidStart=:=LanidEnd of
		?true -> 
			{?ok, Player};
		_ ->
			DouQi=role_api_dict:douqi_get(),
			#douqi{sto_equip=StoEquip0}=DouQi,
			{StoEquip, OtherEq} =
				lists:foldl(fun(#dq_data{lan_id=LanId0,role_id=RoleId0}=DQ0,{UsrAcc,OthAcc}) -> 
									if LanId0 >= ?CONST_DOUQI_BAG_START ->
										   {[DQ0|UsrAcc],OthAcc};
									   RoleId0 =:= RoleId ->
										   {[DQ0|UsrAcc],OthAcc};
									   ?true ->
										   {UsrAcc,[DQ0|OthAcc]}
									end
							end, {[],[]}, StoEquip0),
			case douqi_api:ask_use_douqi(Player,RoleId,DqId,LanidEnd,StoEquip) of
				{?ok,Player2,NewDq,NewStoEquip} ->
					role_api_dict:douqi_set(DouQi#douqi{sto_equip=NewStoEquip++OtherEq}),
					BinMsg=douqi_api:msg_ok_use_douqi(RoleId, DqId, LanidStart, NewDq#dq_data.lan_id, [NewDq]),
					app_msg:send(Player2#player.socket, BinMsg),
					{?ok,Player2};
				{?ok,Player2,NewDq} ->
					BinMsg=douqi_api:msg_ok_use_douqi(RoleId, DqId, LanidStart, LanidEnd, [NewDq]),
					app_msg:send(Player2#player.socket, BinMsg),
					{?ok,Player2};
				{?error,ErrorCode} ->
					BinMsg=system_api:msg_error(ErrorCode),
					app_msg:send(Player#player.socket, BinMsg),
					{?ok, Player}
			end
	end;

%% 请求整理斗气
gateway(?P_SYS_DOUQI_ASK_CLEAR_STORAG, Player, _Bin) ->
	DouQi=role_api_dict:douqi_get(),
	#douqi{sto_equip=StoEquip0}=DouQi,
	Fun = fun(#dq_data{lan_id=LanId}=Dq,{Acc,EAcc}) -> 
				  ?IF(LanId < ?CONST_DOUQI_BAG_START, {Acc,[Dq|EAcc]}, {[Dq|Acc],EAcc})
		  end,
	{StoEquip,Equip} = lists:foldl(Fun, {[],[]}, StoEquip0),
	StoEquip2=douqi_api:clear_storage(StoEquip),
	Fun2 = fun(Dq,{Acc,N}) -> 
				   {[Dq#dq_data{lan_id=N}|Acc], N+1}
		   end,
	{StoEquip3,_}= lists:foldl(Fun2, {[],?CONST_DOUQI_BAG_START}, StoEquip2),
	role_api_dict:douqi_set(DouQi#douqi{sto_equip=StoEquip3++Equip}),
	BinMsg=douqi_api:msg_storage_data(?CONST_DOUQI_STORAGE_TYPE_EQUIP, lists:reverse(StoEquip3)),
	app_msg:send(Player#player.socket, BinMsg),
	{?ok, Player};

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

