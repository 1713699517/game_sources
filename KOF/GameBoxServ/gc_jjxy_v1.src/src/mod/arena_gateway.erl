    %% Author: Kevin
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_friend
-module(arena_gateway).

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


%% 进入封神台  
gateway(?P_ARENA_JOIN,Player=#player{socket=Socket},_Bin) ->
	case arena_api:arena_join(Player) of
		{?error,ErrorCode}->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player};
		_->
			{?ok,Player}
	end;

%%挑战 
gateway(?P_ARENA_BATTLE,Player=#player{socket=Socket,uid=Puid},Bin) ->
	{Uid,Rank} = app_msg:decode({?int32u,?int16u},Bin),
	Arena=role_api_dict:arena_get(),
	Time    = util:seconds(),
	case Puid == Uid of
		?true->
			BinMsg = system_api:msg_error(?ERROR_ARENA_ARENA_ING),
			app_msg:send(Socket, BinMsg),
			{?ok,Player};
		_->
			case abs(Time - Arena#arena.time) >= 60*?CONST_ARENA_LOSE_TIME of
				?true->
					case Arena#arena.surplus>0 of
						?true->
							case war_api:war_player(Socket,Uid,Rank) of
								{?error,Error}->
									BinMsg = system_api:msg_error(Error),
									app_msg:send(Socket, BinMsg),
									{?ok,Player};
								_->
									Arena2=Arena#arena{surplus=Arena#arena.surplus-1},
									role_api_dict:arena_set(Arena2),
									active_api:check_link(Puid,?CONST_ACTIVITY_LINK_105),
									{?ok,Player}
							end;
						_->
							BinMsg = system_api:msg_error(?ERROR_ARENA_NOT_COUNT),
							app_msg:send(Socket, BinMsg),
							{?ok,Player}
					end;
				_->
					BinMsg = system_api:msg_error(?ERROR_ARENA_NOT_COUNT),
					app_msg:send(Socket, BinMsg),
					{?ok,Player}
			end
	end;

%%挑战结束 
gateway(?P_ARENA_FINISH,Player,Bin) ->
	{_Uid,Ranking,Res} = app_msg:decode({?int32u,?int32u,?int8u},Bin),
	arena_srv:arena_war_cast(Player, Ranking,Res),
	{?ok, Player};

%%购买挑战次数 
gateway(?P_ARENA_BUY,Player=#player{socket=Socket},_Bin) ->
	Arean=role_api_dict:arena_get(),
	BinMsg=arena_api:msg_result2(Arean#arena.buy_count+1),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%%确定购买 
gateway(?P_ARENA_BUY_YES,Player=#player{socket=Socket},_Bin) ->
	Arean=role_api_dict:arena_get(),
	case arena_api:arena_buy_count(Player,Arean) of
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player};
		{?ok,Player2,Arean2,Surplus,Bin} ->
			?MSG_ECHO("====================== ~w~n",[Surplus]),
			BinMsg=arena_api:msg_buy_ok(Surplus),
			app_msg:send(Socket, <<BinMsg/binary,Bin/binary>>),
			role_api_dict:arena_set(Arean2),
			{?ok, Player2}
	end;

%%退出封神台 
gateway(?P_ARENA_EXIT,Player=#player{socket=Socket},_Bin) ->
	BinMsg  = arena_api:msg_ok(),
	app_msg:send(Socket,BinMsg),
	{?ok,Player};  

%%请求封神台排行榜 
gateway(?P_ARENA_KILLER,Player=#player{socket=Socket,uid=Uid,lv=Lv},_Bin) ->
%% 	RnakDataList2=ets:select(?ETS_ARENA,[{'$1',[{'=<',{element,2,'$1'},20}],['$1']}]),
%% 	BinMsg = arena_api:msg_killer_data(RnakDataList2,Uid,Lv),
%% 	app_msg:send(Socket,BinMsg),
	{?ok, Player};

%%领取每日奖励 
gateway(?P_ARENA_DAY_REWARD,Player=#player{socket=Socket,lv=InfoLv},_Bin) ->
	case arena_api:arena_reward_day(Player) of 
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player};
		{Player2,Bin} ->
			RewardTime=arena_api:arena_reward_times(),
			Arena=role_api_dict:arena_get(),
			{Renown,Gold} =arena_api:arena_reward_rank(Arena#arena.ranking,InfoLv),
			TimeMsg	= arena_api:msg_reward_times(?CONST_FALSE,RewardTime,Renown,Gold),
			app_msg:send(Socket,<<Bin/binary,TimeMsg/binary>>),
			{?ok,Player2}
	end;

%% 清除CD时间
gateway(?P_ARENA_CLEAN,Player=#player{socket=Socket},_Bin) ->
	case arena_api:arena_clean(Player) of
		{?ok,Player2,BinMsg}->
			app_msg:send(Socket, BinMsg),
			{?ok, Player2};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.
