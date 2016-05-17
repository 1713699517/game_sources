%% Author: Kevin
%% Created: 2012-10-16
%% Description: TODO: Add description to pp_friend
-module(skill_gateway).

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
gateway(?P_SKILL_REQUEST,Player=#player{socket=Socket},_Bin)->
	case skill_api:skill_request(Player) of
		{?ok,Player,BinMsg}->
			?ok;
		{?error,Error}->
			BinMsg=system_api:msg_error(Error)
	end,
	app_msg:send(Socket, BinMsg),
	{?ok,Player};


gateway(?P_SKILL_LEARN,Player=#player{socket=Socket},Bin)->
	{SkillId,Lv} = app_msg:decode({?int32u,?int32u},Bin),
	?MSG_ECHO("=========~n",[]),
	case skill_api:skill_learn(Player,SkillId,Lv) of
		{?ok,Player2,BinMsg}->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error,Error}->
			BinError=system_api:msg_error(Error),
			app_msg:send(Socket, BinError),
			{?ok,Player}
	end;

gateway(?P_SKILL_EQUIP,Player=#player{socket=Socket},Bin)->
	{EquipPos,SkillId} = app_msg:decode({?int16u,?int32u},Bin),
	case EquipPos >4 of
		?true ->
			case skill_api:skill_equip(Player,SkillId,EquipPos) of
				{?ok,Player2,BinMsg}->
					?MSG_ECHO("================  ~w~n",[{?ok,BinMsg}] ),
					app_msg:send(Socket, BinMsg),
					{?ok,Player2};
				{?error,Error}->
					BinError=system_api:msg_error(Error),
					app_msg:send(Socket,BinError),
					{?ok,Player}
			end;
		?false ->
			{?ok,Player}
	end;			

%% 伙伴技能等级信息返回
gateway(?P_SKILL_PARTNER,Player=#player{socket=Socket},Bin)->
%% 	{Parentid} = app_msg:decode({?int32u},Bin),
   {Uid,Parentid} = app_msg:decode({?int32u,?int32u},Bin),
   case skill_api:parent_lv(Uid,Parentid) of
		{?ok,BinMsg}->
			app_msg:send(Socket, BinMsg),
			{?ok,Player};
		{?error,Error}->
			BinError=system_api:msg_error(Error),
			app_msg:send(Socket, BinError),
			{?ok,Player}
	end;

%% 伙伴等级升级
gateway(?P_SKILL_UPPARENTLV,Player=#player{socket=Socket},Bin)->
	{Parentid,SkillId,Lv} = app_msg:decode({?int32u,?int32u,?int32u},Bin),
	?MSG_ECHO("=========~n",[]),
	case skill_api:parent_lv_learn(Player,Parentid,SkillId,Lv) of
		{?ok,Player2,BinMsg}->
			app_msg:send(Socket, BinMsg),
			{?ok,Player2};
		{?error,Error}->
			BinError=system_api:msg_error(Error),
			app_msg:send(Socket, BinError),
			{?ok,Player}
	end;

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.