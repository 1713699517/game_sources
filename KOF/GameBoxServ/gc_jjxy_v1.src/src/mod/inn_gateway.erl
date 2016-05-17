%% Author: Kevin
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_friend
-module(inn_gateway).

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

%%请求客栈
gateway(?P_INN_ENJOY_INN,Player=#player{socket=Socket,info=Info},_Binary)->
	Inn=role_api_dict:inn_get(),
	BinMsg=inn_api:inn_list(Info#info.renown,Inn),
	app_msg:send(Socket, BinMsg),
	{?ok,Player};


%%招募伙伴
gateway(?P_INN_CALL_PARTNER,Player=#player{socket=Socket},Binary)->
	{PartnerId} = app_msg:decode({?int16u},Binary),
	case inn_api:inn_call_partner(Player,PartnerId) of
		{?ok,Player2,BinMsg}->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error,Error}->
			BinMsg = system_api:msg_error(Error),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 离队
gateway(?P_INN_DROP_OUT,Player=#player{socket=Socket},Binary)->
	{PartnerId} = app_msg:decode({?int16u},Binary),
	case inn_api:inn_drop_out(PartnerId) of
		?ok->
			BinMsg=inn_api:msg_res_partner(?CONST_INN_OPERATION0,PartnerId);
		{?error,Error}->
			BinMsg = system_api:msg_error(Error)
	end,
	app_msg:send(Socket, BinMsg),
	{?ok,Player};
			
%% 归队
gateway(?P_INN_ENJOY,Player=#player{socket=Socket,lv=InfoLv},Binary)->
	{PartnerId} = app_msg:decode({?int16u},Binary),
	case inn_api:inn_enjoy(PartnerId,InfoLv) of
		?ok->
			BinMsg=inn_api:msg_res_partner(?CONST_INN_OPERATION1,PartnerId);
		{?error,Error}->
			BinMsg = system_api:msg_error(Error)
	end,
	app_msg:send(Socket, BinMsg),
	{?ok,Player};

%% 出战
gateway(?P_INN_WAR,Player=#player{socket=Socket,lv=InfoLv},Binary)->
	{PartnerId} = app_msg:decode({?int16u},Binary),
	case inn_api:inn_war(PartnerId,InfoLv) of
		{?ok,_Powerful}->
			role_api:update_powerful_z(Player),
			BinMsg=inn_api:msg_res_partner(?CONST_INN_OPERATION2,PartnerId),
			app_msg:send(Socket, BinMsg),
			{?ok,Player};
		{?error,Error}->
			BinMsg = system_api:msg_error(Error),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 出战休息
gateway(?P_INN_NTE_WAR,Player=#player{socket=Socket},Binary)->
	{PartnerId} = app_msg:decode({?int16u},Binary),
	case inn_api:inn_down_war(PartnerId) of
		{?ok,_Powerful}->
			role_api:update_powerful_z(Player),
			BinMsg=inn_api:msg_res_partner(?CONST_INN_OPERATION3,PartnerId),
			app_msg:send(Socket, BinMsg),
			{?ok,Player};
		{?error,Error}->
			BinMsg = system_api:msg_error(Error),
			app_msg:send(Socket, BinMsg),
			{?ok,Player}
	end;

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> 
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.
