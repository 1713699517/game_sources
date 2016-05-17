%% Author: Administrator
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_war
-module(war_gateway).

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
% 战斗伤害 
gateway(?P_WAR_HARM, Player=#player{socket=Socket},Bin) ->
	{Type,OneType,OneId,OneMon,FoeType,AttrType,
	 Mid,Id,SkillId,Lv,Stata,Harm} = app_msg:decode({?int8u,?int8u,?int32u,?int32u,?int8u,?int8u,?int16u,?int32u,
											   ?int16u,?int16u,?int8u,?int32u},Bin),
	case war_api:war_all_type_harm(Player,Type,OneType,OneId,OneMon,FoeType,AttrType,Id,Mid,SkillId,Lv,Stata,Harm) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket,BinMsg),
			{?ok,Player};
		_ ->
			{?ok,Player}
	end;

%% P_WAR_HARM_NEW
gateway(?P_WAR_HARM_NEW, Player=#player{socket=Socket},Bin) ->
	{Type,OneType,OneId,OneMon,FoeType,AttrType,
	 Mid,Id,SkillId,Lv,Stata,Harm} = app_msg:decode({?int8u,?int8u,?int32u,?int32u,?int8u,?int8u,?int32u,?int32u,
											   ?int16u,?int16u,?int8u,?int32u},Bin),
	case war_api:war_all_type_harm(Player,Type,OneType,OneId,OneMon,FoeType,AttrType,Id,Mid,SkillId,Lv,Stata,Harm) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket,BinMsg),
			{?ok,Player};
		_ ->
			{?ok,Player}
	end;

		
gateway(?P_WAR_USE_SKILL,Player=#player{uid=Uid,spid=Spid},Bin)->
	{Type,Id,SkillId,SkillLv} = app_msg:decode({?int8u,?int32u,?int16u,?int8u},Bin),
	BinMsg=war_api:war_use_skill(Type,Uid,Id,SkillId,SkillLv),
	scene_api:broadcast_scene(Spid,Uid,BinMsg),
	{?ok, Player};

gateway(?P_WAR_PK,Player=#player{uid=PUid,uname=PName},Bin)-> 
	{Uid} = app_msg:decode({?int32u},Bin),
	Time=util:seconds(),
	put(war_pk,Uid),
	BinMsg=war_api:msg_pk_receive(PUid,PName,Time),
	app_msg:send(Uid,BinMsg),
	{?ok, Player};

gateway(?P_WAR_PK_CANCEL,Player,_Bin)->
	put(war_pk,?null),
	{?ok, Player};

gateway(?P_WAR_PK_REPLY,Player,Bin)->
	{Uid,Res} = app_msg:decode({?int32u,?int8u},Bin),
	war_api:war_pk(Player,Uid,Res),
	{?ok, Player};

%%怪物击倒
gateway(?P_WAR_DOWN,Player=#player{spid=Spid},Bin)->
	{MonsterId,MonsterMid} = app_msg:decode({?int32u,?int16u},Bin),
	scene_api:monster_knock(Spid,MonsterMid,MonsterId),
	{?ok, Player};
%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

