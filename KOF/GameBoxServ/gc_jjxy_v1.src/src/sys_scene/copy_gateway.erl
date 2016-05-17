%% Author: mirahs
%% Created: 2011-12-17
%% Description: TODO: Add description to copy_gateway
-module(copy_gateway).

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
%% 请求普通副本
%% gateway(?P_COPY_REQUEST, #player{socket=Socket,lv=Lv}=Player, Binary) ->
%% 	{ChapId} = app_msg:decode({?int16u},Binary),
%% 	?MSG_ECHO("----------------~w~n",[ChapId]),
%% 	Chaps	= data_copy_chap:gets_normal(),
%% 	case lists:member(ChapId,Chaps) orelse ChapId =:= 0 of
%% 		?true ->
%% 			ChapCopy = role_api_dict:copy_get(),
%% 			{Chap,NextChap,MyChap,NewChapCopy} = copy_api:chap_info(Lv,ChapId,Chaps,ChapCopy),
%% 			role_api_dict:copy_set(NewChapCopy),
%% 			BinMsg1	= copy_api:msg_chap_data(Chap,NextChap,MyChap),
%% 			BinMsg2 = copy_api:msg_chap_data_new(Chap,NextChap,MyChap),
%% 			app_msg:send(Socket, <<BinMsg1/binary,BinMsg2/binary>>);
%% 		_ ->
%% 			BinMsg	= system_api:msg_error(?ERROR_HERO_NO_CHAP),
%% 			app_msg:send(Socket, BinMsg)
%% 	end,
%% 	{?ok,Player};

%% 请求普通副本
gateway(?P_COPY_REQUEST, #player{socket=Socket,lv=Lv}=Player, Binary) ->
	{ChapId} = app_msg:decode({?int16u},Binary),
	?MSG_ECHO("=====================~w~n",[ChapId]),
	case ChapId of
		0 ->
			case copy_api:chap_info_new(Lv) of
				{?ok,BinMsg} ->
					app_msg:send(Socket, BinMsg);
				{?error,ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg)
			end;
		_ ->
			case copy_api:chap_info_new(ChapId,Lv) of
				{?ok,BinMsg} ->
					app_msg:send(Socket, BinMsg);
				{?error,ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg)
			end
	end,
	{?ok,Player};

%% 创建并进入副本
gateway(?P_COPY_CREAT, #player{socket=Socket,info=Info}=Player, Binary) ->
	{CopyId} = app_msg:decode({?int16u},Binary),
	?MSG_ECHO("----------------~w~n",[CopyId]),
	case bag_api:check_bag() of
		?false ->
			case copy_api:check_copy_data(CopyId) of
				{?ok,_KeyId,CopyType,UseEnergy} ->
					case CopyId of
						?CONST_COPY_FIRST_COPY ->
							Player2 = copy_api:copy_start_first(Player,CopyId,CopyType),
							{?ok,Player2};
						_ ->
							case Info#info.map_type of
								?CONST_MAP_TYPE_CITY ->
									case energy_api:check_energy_copy(Player, UseEnergy) of
										?ok ->
											NewPlayer = copy_api:copy_start(Player,CopyId,CopyType,UseEnergy),
											{?ok,NewPlayer};
										{?error,Player2,BinMsg} ->
											app_msg:send(Socket, BinMsg),
											{?ok,Player2}
									end;
								_ ->
									{?ok,Player}
							end
					end;
				{?error,ErrorCode} ->
					BinMsg	= system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg),
					{?ok,Player}
			end;
		_ ->
			BinMsg = system_api:msg_error(?ERROR_COPY_BAG_FULL),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 副本开始计时
gateway(?P_COPY_TIMING, Player, Binary) ->
	{Type} = app_msg:decode({?int8u},Binary),
	?MSG_ECHO("----------------~w~n",[Type]),
%% 	copy_api:timing(Player,Type),
	{?ok,Player};

%% 通知副本完成
gateway(?P_COPY_NOTICE_OVER, #player{spid=Spid,uid=Uid}=Player, Binary) ->
	{HitTimes,CaromTimes,MonsHp} = app_msg:decode({?int16u,?int16u,?int32u},Binary),
	?MSG_ECHO("----------------~w~n",[{HitTimes,CaromTimes,MonsHp}]),
	copy_api:notice_over(Uid,Spid,HitTimes,CaromTimes,MonsHp),
	{?ok,Player};

%% 退出副本
gateway(?P_COPY_COPY_EXIT, #player{socket=Socket,info=Info}=Player, _Binary) ->
	Player2 =
		case lists:member(Info#info.map_type, ?COPY_MAP_TYPES) of
			?true ->
				copy_api:exit_copy(Player);
			_ ->
				BinMsg = system_api:msg_error(?ERROR_UNKNOWN),
				app_msg:send(Socket, BinMsg),
				Player
		end,
	{?ok, Player2};

%% 开始挂机
gateway(?P_COPY_UP_START, #player{socket=Socket}=Player, Binary) ->
	{CopyId,UseAll,Num} = app_msg:decode({?int16u,?int8u,?int16u},Binary),
	?MSG_ECHO("----------------~w~n",[{CopyId,UseAll,Num}]),
	case copy_api:up_start(Player,CopyId,UseAll,Num) of 
		{?ok,NewPlayer} ->
			{?ok,NewPlayer};
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 加速挂机
gateway(?P_COPY_UP_SPEED, Player, _Binary) ->
	?MSG_ECHO("----------------~n",[]),
	NewPlayer = copy_api:up_speed(Player),
	{?ok,NewPlayer};

%% 登陆请求是否挂机
gateway(?P_COPY_IS_UP, Player, _Binary) ->
	?MSG_ECHO("----------------~n",[]),
	NewPlayer = copy_api:up_login(Player),
	{?ok,NewPlayer};

%% 停止挂机
gateway(?P_COPY_UP_STOP, #player{uid=Uid}=Player, _Binary) ->
	?MSG_ECHO("----------------~n",[]),
	copy_api:up_stop(Uid),
	{?ok,Player};

%% 领取章节评价奖励 
gateway(?P_COPY_CHAP_REWARD, Player, Binary) ->
	{Type,ChapId} = app_msg:decode({?int8u,?int16u},Binary),
	case Type of
		?CONST_COPY_TYPE_NORMAL ->
			Player2 = copy_api:chap_reward(Player,ChapId),
			{?ok,Player2};
		?CONST_COPY_TYPE_HERO ->
			Player2 = hero_api:chap_reward(Player,ChapId),
			{?ok,Player2};
		?CONST_COPY_TYPE_FIEND ->
			Player2 = fiend_api:chap_reward(Player,ChapId),
			{?ok,Player2};
		_ ->
			{?ok,Player}
	end;

gateway(ProtocolCode, Player, Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.