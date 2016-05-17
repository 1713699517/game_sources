%% Author: Kevin
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_friend
-module(moil_gateway).

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
%% 进入苦工系统  
gateway(?P_MOIL_ENJOY_MOIL,Player=#player{socket=Socket,uid=Uid,lv=InfoLv},_Bin)->
	Arena=role_api_dict:arena_get(),
	Data2=case ets:lookup(?ETS_MOIL_DATA, Uid) of
			  [] -> 
				  [];
			  [{_,Data}] -> 
				  Data
		  end,
	moil_api:moil_enjoy(Socket,Arena,InfoLv,Data2),  
	{?ok, Player};

%% 苦工系统操作 
gateway(?P_MOIL_OPER,Player=#player{socket=Socket,uid=Uid,lv=InfoLv},Bin)->
	{Type} = app_msg:decode({?int8u},Bin),
	Arena=role_api_dict:arena_get(),
	List=case Type of
		?CONST_MOIL_FUNCTION_CATCH-> 
			moil_api:moil_other((Arena#arena.moil)#moil.captrue_list,InfoLv);
		?CONST_MOIL_FUNCTION_ASKHELP->
			moil_api:moil_askhelp(Uid)
%% 		?CONST_MOIL_FUNCTION_SNATCH->
%% 			moil_api:moil_other((Arena#arena.moil)#moil.revenge_list,Info#info.lv)
	end,
	BinMsg=moil_api:msg_player_data(Type,List),
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 抓捕  
gateway(?P_MOIL_CAPTRUE,Player=#player{socket=Socket},Bin)-> 
	{Type,Uid} = app_msg:decode({?int8u,?int32u},Bin),
	Arena=role_api_dict:arena_get(),
	case (Arena#arena.moil)#moil.type_id of
		?CONST_MOIL_ID_MOIL->
			BinMsg	= system_api:msg_error(?ERROR_MOIL_NOT_MOIL),
			app_msg:send(Socket,BinMsg),
			{?ok,Player};
		_->
			case moil_api:moil_captrue_calls(Player,Type,Uid) of 
				{?error,ErrorCode}-> 
					BinMsg	= system_api:msg_error(ErrorCode),
					app_msg:send(Socket,BinMsg),
					{?ok,Player};
				{?ok,Player2}->
					{?ok, Player2}
			end
	end;


%% 抓捕结果
gateway(?P_MOIL_CALL_RES,Player,Bin)->
	{TypeId,Uid,Res} = app_msg:decode({?int8u,?int32u,?int8u},Bin),
	{?ok,Player2}=moil_api:moil_captrue_res(Player,TypeId,Uid,Res),
	{?ok,Player2};

%% 互动 
gateway(?P_MOIL_ACTIVE,Player=#player{socket=Socket},Bin)->
	{ActiveId,TUid} = app_msg:decode({?int8u,?int32u},Bin),
	case moil_api:moil_active(Player,ActiveId,TUid) of
		{?error,ErrorCode}->
			BinMsg	= system_api:msg_error(ErrorCode),
			app_msg:send(Socket,BinMsg),
			{?ok,Player};
		{?ok,Player2}-> 
			{?ok, Player2}
	end;
%% 请求压榨/活动
gateway(?P_MOIL_PRESS_START,Player=#player{socket=Socket},Bin)->
	{Type} = app_msg:decode({?int8u},Bin),
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	MoilData=moil_api:moil_press_start(Moil#moil.moil_data), 
	BinMsg=moil_api:msg_press_data(Type,MoilData),
	case Type of
		?CONST_MOIL_FUNCTION_INTER ->
			LTime=moil_api:moil_protect_time(Moil#moil.protect_time),
			TimeMsg=moil_api:msg_protect_time(LTime);
		_->
			TimeMsg= <<>>
	end,
	app_msg:send(Socket,<<BinMsg/binary,TimeMsg/binary>>),
	{?ok,Player};

%% 进入压榨界面 
gateway(?P_MOIL_PRESS_ENJOY,Player=#player{socket=Socket},Bin)->
	{MoilUid} = app_msg:decode({?int32u},Bin),
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	{Expn,Time}=moil_api:moil_press_enjoy(Moil#moil.moil_data,MoilUid), 
	BinMsg=moil_api:msg_moil_xxxx3(Expn,Time),
	app_msg:send(Socket,BinMsg),
	{?ok,Player};
	
%% 压榨/抽取/提取 
gateway(?P_MOIL_PRESS,Player=#player{socket=Socket,lv=InfoLv},Bin)->
	{Type,TUid} = app_msg:decode({?int8u,?int32u},Bin),
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil, 
	case moil_api:moil_press_full(InfoLv,Moil#moil.expn) of 
		?true->
			BinMsg	= system_api:msg_error(?ERROR_MOIL_EXP_LIMIT),
			app_msg:send(Socket,BinMsg),
			{?ok,Player};
		_->
			case moil_api:moil_press(Player,Type,TUid) of
				{?error,ErrorCode}->
					BinMsg	= system_api:msg_error(ErrorCode),
					app_msg:send(Socket,BinMsg),
					{?ok,Player};
				{?ok,Player2,{Time,PressList},Bin2}-> 
					Player3=target_api:listen_moil(Player2,1),
					BinMsg=moil_api:msg_press_rs(Type,Time,TUid,PressList),
					app_msg:send(Socket,<<BinMsg/binary,Bin2/binary>>), 
					{?ok, Player3};
				_->
					{?ok,Player}
			end
	end;

%% 打工时间到 
gateway(?P_MOIL_MOIL_TIME,Player,_Bin)->
%% 	{TUid,Tlv} = app_msg:decode({?int32u,?int16u},Bin),
%% 	Arena=role_api_dict:arena_get(),
%% 	{Exp,Moil}=moil_api:moil_time(Arena#arena.moil,TUid,Tlv),
%% 	Arena2=Arena#arena{moil=Moil},
%% 	role_api_dict:arena_set(Arena2),
	{?ok,Player};

%%释放苦工 
gateway(?P_MOIL_RELEASE,Player=#player{socket=Socket,uname=Name,uname_color=NameColor},Bin)->
	{TUid} = app_msg:decode({?int32u},Bin),
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	LastTime=util:seconds(),
	case moil_api:moil_protect(Moil#moil.protect_time,TUid,LastTime) of
		?true->
			ProtectTime=lists:keydelete(TUid,1,Moil#moil.protect_time),
			case lists:keydelete(TUid,2,Moil#moil.moil_data) of
				[]->
					?MSG_ECHO("asdsadas  ~w~n",[Moil#moil.type_id]),
					TypeId=case Moil#moil.type_id of
							   ?CONST_MOIL_ID_HOST->
								   ?CONST_MOIL_ID_FREEMAN;
%% 							   ?CONST_MOIL_ID_H_M->
%% 								   ?CONST_MOIL_ID_MOIL;
							   _->
								   Moil#moil.type_id
						   end,
					Moil2=Moil#moil{moil_data=[],type_id=TypeId,protect_time=ProtectTime},
					Arena2=Arena#arena{moil=Moil2};			
				MoilData->
					TypeId=Moil#moil.type_id,
					Moil2=Moil#moil{moil_data=MoilData,protect_time=ProtectTime},
					Arena2=Arena#arena{moil=Moil2}
			end,
			%% 释放苦工 更新苦工信息
			moil_api:moil_release(TUid), 
			logs_api:action_notice(TUid,?CONST_LOGS_2010,[{Name,NameColor}],[]),
			BinMsg=moil_api:msg_release_rs(TypeId),
			app_msg:send(Socket,BinMsg),
			role_api_dict:arena_set(Arena2),
			{?ok,Player};
		_->
			BinMsg	= system_api:msg_error(?ERROR_MOIL_PROTECT_TIME),
			app_msg:send(Socket,BinMsg),
			{?ok,Player}
	end;

%% 购买抓捕次数
gateway(?P_MOIL_BUY_CAPTRUE,Player=#player{socket=Socket},_Bin)->
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	case Moil#moil.buy_count=<0 of
		?true ->  
			BinMsg	= system_api:msg_error(?ERROR_MOIL_BUY_LIMIT),
			app_msg:send(Socket,BinMsg),
			{?ok,Player};
		_->
			case role_api:currency_cut([gateway,[],<<"">>],Player,[{?CONST_CURRENCY_RMB,?CONST_MOIL_CATCH_RMB_USE}]) of
				{?error, ErrorCode}->
					BinMsg	= system_api:msg_error(ErrorCode),
					app_msg:send(Socket,BinMsg),
					{?ok,Player};
				{?ok, Player2, Bin}->
					BinMsg=moil_api:msg_buy_ok(),
					Moil2 =Moil#moil{captrue_count=Moil#moil.captrue_count+1,buy_count=Moil#moil.buy_count-1},
					Arena2=Arena#arena{moil=Moil2},
					role_api_dict:arena_set(Arena2),
					app_msg:send(Socket,<<BinMsg/binary,Bin/binary>>),
					{?ok, Player2}
			end
	end;

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.
