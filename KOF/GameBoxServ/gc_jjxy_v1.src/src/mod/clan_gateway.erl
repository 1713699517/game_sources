%% Author: tanwer
%% Created: 2013-6-26
%% Description: TODO: Add description to clan_gateway
-module(clan_gateway).

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
%% 请求帮派面板
gateway(?P_CLAN_ASK_CLAN, #player{socket=Socket,uid=Uid}=Player,Bin) ->
	{ClanId} = app_msg:decode({?int32u},Bin),
	case clan_api:request_clan(Uid,ClanId) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode);
		{?ok,BinMsg} ->
			?ok
	end,
	app_msg:send(Socket, BinMsg),
	{?ok, Player};
			
%% 请求帮派列表
gateway(?P_CLAN_ASL_CLANLIST, #player{socket=Socket}=Player,Bin) ->
	{Page} = app_msg:decode({?int16u},Bin),
	case clan_api:request_clan_list(Page) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg);
		{?ok,BinMsg} ->
			Clan=role_api_dict:clan_get(),
			Is = ?IF(clan_mod:chack_outclan_time(Clan#clan.outtime)=:=?true,0,1),
			case Clan#clan.ask_clanlist of
				[] ->
					BinMsg2=clan_api:msg_applied_clanlist(Is,[]) ;
				ClanList ->
					Now=util:seconds(),
					ClanIDList2= [ID || {TIME,ID} <- ClanList, Now-TIME<24*60*60],
					BinMsg2=clan_api:msg_applied_clanlist(Is,ClanIDList2)
			end,
			app_msg:send(Socket, <<BinMsg/binary,BinMsg2/binary>>)
	end,
	{?ok, Player};

%% 请求创建帮派
gateway(?P_CLAN_ASK_REBUILD_CLAN, #player{socket=Socket}=Player,Bin) ->
	{ClanName} = app_msg:decode({?string},Bin),
	case size(ClanName) =< ?CONST_CLAN_TITLE_MAX * 3 andalso size(ClanName) > 0 of
		?true ->
			case clan_api:rebuild_clan(Player,ClanName) of
				{?error,ErrorCode} ->
					BinMsg=system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg),
					{?ok, Player};
				{?ok,Player2,BinMsg} ->
					clan_mod:get_allclan(),
					app_msg:send(Socket, BinMsg),
					{?ok, Player2}
			end;
		_ ->
			BinMsg=system_api:msg_error(?ERROR_CLAN_TITLE_MAX),
			app_msg:send(Socket, BinMsg),
			{?ok, Player}
	end;

%% 请求|取消加入帮
gateway(?P_CLAN_ASK_CANCEL, #player{socket=Socket}=Player,Bin) ->
	{Type,ClanId} = app_msg:decode({?int8u,?int32u},Bin),
	case clan_api:ask_apply_clan(Player, ClanId, Type) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode);
		?ok ->
			BinMsg=clan_api:msg_ok_join_clan(Type, ClanId)
	end,
	app_msg:send(Socket, BinMsg),
	{?ok, Player}; 

%% 请求入帮申请列表
gateway(?P_CLAN_ASK_JOIN_LIST, #player{socket=Socket,uid=Uid}=Player,_Bin) ->
	case clan_api:clan_list(Uid) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode);
		{?ok,BinMsg} ->
			?ok
	end,
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 请求审核操作
gateway(?P_CLAN_ASK_AUDIT, #player{uid=Uid,uname=Name,uname_color=NameColor}=Player,Bin) ->
	{ToUid,State} = app_msg:decode({?int32u,?int8u},Bin), 
	clan_srv:request_audit_cast({Name,NameColor}, Uid, ToUid, State),
	{?ok, Player};

%% 请求修改帮派公告
gateway(?P_CLAN_ASK_RESET_CAST, #player{socket=Socket,uid=Uid}=Player,Bin) ->
	{String} = app_msg:decode({?stringl},Bin),
	case clan_api:reset_cast(Uid,String) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode);
		{?ok,BinMsg} ->
			?ok
	end,
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 请求帮派成员列表
gateway(?P_CLAN_ASK_MEMBER_MSG, #player{socket=Socket}=Player,_Bin) ->
	Clan=role_api_dict:clan_get(),
	case clan_mod:get_clan4id(Clan#clan.clan_id) of
		#clan_public{member=Member} ->
			MemDate=clan_mod:get_clan_memlists(Member),
			BinMsg=clan_api:msg_ok_member_list(MemDate);
		?null ->
			BinMsg=system_api:msg_error(?ERROR_CLAN_NULL1)
	end,
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 请求设置成员职位
gateway(?P_CLAN_ASK_SET_POST, Player,Bin) ->
	{ToUid,Post} = app_msg:decode({?int32u,?int8u},Bin),
	case clan_api:set_post(Player,ToUid,Post) of 
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode);
		?ok ->
			Clan=role_api_dict:clan_get(),
			case clan_mod:get_clan4id(Clan#clan.clan_id) of
				#clan_public{member=Member} ->
					MemDate=clan_mod:get_clan_memlists(Member),
					BinMsg=clan_api:msg_ok_member_list(MemDate);
				_ ->
					BinMsg=system_api:msg_error(?ERROR_SELECT_DELAY)
			end
	end,
	app_msg:send(Player#player.socket, BinMsg),
	{?ok, Player};

%% 请求退出|解散帮派
gateway(?P_CLAN_ASK_OUT_CLAN, Player, Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	#player{socket=Socket,uid=Uid,uname=Name,uname_color=NameColor}=Player,
	case clan_api:ask_out_clan({Uid,Name,NameColor},Type) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode);
		_ ->
			clan_mod:get_allclan(),
			BinRole	= role_api:clan_u(0, 0, <<>>),
			BinOut	= clan_api:msg_ok_out_clan(),
			BinMsg	= <<BinRole/binary,BinOut/binary>>
	end,
	app_msg:send(Socket, BinMsg),
	{?ok, Player};


%% 请求帮派技能面板
gateway(?P_CLAN_ASK_CLAN_SKILL, #player{socket=Socket,uid=Uid}=Player,_Bin) ->
	case clan_api:ask_clan_skill(Uid) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode);
		{?ok,BinMsg} ->
			?ok
	end,
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 请求学习帮派技能
gateway(?P_CLAN_STUDY_SKILL, #player{socket=Socket}=Player,Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	case clan_api:ask_study_skill(Player,Type) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),	
			app_msg:send(Socket, BinMsg),
			{?ok, Player};
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			{?ok, Player2}
	end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 帮派活动
%% 请求帮派活动面板
gateway(?P_CLAN_ASK_CLAN_ACTIVE, #player{socket=Socket,uid=Uid,vip=Vip}=Player,_Bin) ->
	case clan_active_api:ask_clan_active(Uid,Vip#vip.lv) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode);
		{?ok,BinMsg} -> ?ok
	end,
	app_msg:send(Socket, BinMsg),
	{?ok, Player};

%% 请求浇水
gateway(?P_CLAN_ASK_WATER, #player{socket=Socket,uid=Uid}=Player,_Bin) ->
	case clan_active_api:ask_cat_data(Uid) of 
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode);
		{?ok,BinMsg} ->?ok
	end,
	app_msg:send(Socket, BinMsg),
	{?ok, Player};


%% 请求开始浇水|摇钱
gateway(?P_CLAN_START_WATER, #player{socket=Socket,uid=Uid}=Player,Bin) ->
	{Type,TypeAct} = app_msg:decode({?int8u,?int8u},Bin),
	?MSG_ECHO("00000000000000000000::~w~n",[{Type,TypeAct}]),
	case clan_active_api:start_clan_cat(Player,Type,TypeAct) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),	
			app_msg:send(Socket, BinMsg),
			{?ok, Player};
		{?ok,Player2,BinMsg} ->
			{?ok,BinMsg2} = clan_active_api:ask_cat_data(Uid),
			app_msg:send(Socket, <<BinMsg/binary,BinMsg2/binary>>),
			{?ok, Player2}
	end;


%% 请求开始体能训练
gateway(?P_CLAN_ASK_START_STR, #player{socket=Socket}=Player,Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	case clan_active_api:start_strength(Player,Type) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),	
			app_msg:send(Socket, BinMsg),
			{?ok, Player};
		{?ok,Player2,BinMsg} ->
			BinMsg2=clan_active_api:msg_ok_start_water(Type),
			app_msg:send(Socket, <<BinMsg/binary,BinMsg2/binary>>),
			{?ok, Player2}
	end;

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.






