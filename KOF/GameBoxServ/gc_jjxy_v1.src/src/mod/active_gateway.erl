%% Author: Kevin
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_friend
-module(active_gateway).

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


%% 请求活动数据
gateway(?P_ACTIVITY_REQUEST,#player{socket=Socket}=Player,_Bin) ->
	case ets:lookup(?ETS_PUBLIC_RECORDS, ?CONST_PUBLIC_KEY_ALL_ACTIVE) of
		[{_,AllActiveData}|_] ->
			?ok;
		_ ->
			AllActive = active_mod:get_allactive(),
			AllActiveData = active_mod:fun_all_active(AllActive)
	end,
	BinMsg = active_api:msg_ok_active_data(AllActiveData),
	app_msg:send(Socket, BinMsg),
	{?ok,Player};

%----------------------------------------------------------------------------------------
%% 请求活动入口数据
gateway(?P_ACTIVITY_ASK_LINK_DATA, #player{socket=Socket}=Player,_Bin) ->
	case is_funs_api:check_fun(?CONST_FUNC_OPEN_ACTIVE) of
		?CONST_TRUE ->
			#active_link{link_data=ActiveData,rewards=Rewards} = active_api:get_link_data(),
			Vitality = lists:sum([V||{_,T,All,V} <- ActiveData,T>=All]),
			BinMsg = active_api:msg_ok_link_data(Vitality, ActiveData, Rewards),
			?MSG_ECHO("0999999999999999999999 ~w~n",[{Vitality, ActiveData, Rewards}]),
			app_msg:send(Socket, BinMsg),
			{?ok,Player};
		_ ->
			BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			app_msg:send(Player#player.socket, BinMsg),
			{?ok,Player}
	end;

%% 请求领取奖励
gateway(?P_ACTIVITY_ASK_REWARDS, #player{socket=Socket}=Player,Bin) ->
	case is_funs_api:check_fun(?CONST_FUNC_OPEN_ACTIVE) of
		?CONST_TRUE ->
			{Id} = app_msg:decode({?int8u},Bin),
			case active_api:ask_rewards(Player,Id) of
				{?ok,Player2,BinMsg} ->
					app_msg:send(Socket, BinMsg),
					{?ok,Player2};
				{?error,ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg),
					{?ok,Player}
			end;
		_ ->
			BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			app_msg:send(Player#player.socket, BinMsg),
			{?ok,Player}
	end;
	
	

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.
