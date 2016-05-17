%% Author  : mirahs
%% Created: 2012-9-5
%% Description: TODO: Add description to team_mod
-module(team_mod).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
%%
%% Exported Functions
%%
-export([
		 exit_off/2,
		 team_notice_fresh/1,
		 team_notice_fresh_cb/2,
		 creat/2,
		 join/2,
		 leave/1,
		 kick/2,
		 leader_set/2,
		 leader_apply/1,
		 invite/3,
		 
		 update_team/1
		 ]).

exit_off(TeamId,Uid) ->
	case team_api:team_data_get(TeamId) of
		?null ->
			?skip;
		Team ->
			leave_acc(Team,Uid)
	end.

team_notice_fresh(CopyType) ->
	Onlines = ets:tab2list(?ETS_ONLINE),
	[util:pid_send(Uid, ?MODULE, team_notice_fresh_cb, CopyType) || #player{uid=Uid} <- Onlines].

team_notice_fresh_cb(#player{socket=Socket,team_type=TeamType,info=Info}=Player,CopyType) ->
	?MSG_ECHO("-----------------------~w~n",[{CopyType,Info#info.map_type}]),
	case lists:member(TeamType, ?TEAM_TYPES) of
		?true ->
			case Info#info.map_type of
				?CONST_MAP_TYPE_CITY ->
					case TeamType of
						CopyType ->
							case team_api:request_team(TeamType) of
								{?ok,BinMsg} ->
									app_msg:send(Socket, BinMsg);
								_ ->
									?skip
							end;
						_ ->
							?skip
					end;
				_ ->
					?skip
			end;
		_ ->
			?skip
	end,
	Player.

creat(#player{uid=Uid,spid=Spid,team_id=MyTeamId,info=Info}=Player,CopyId) ->
	?MSG_ECHO("=====================~w~n",[MyTeamId]),
	case MyTeamId of
		0 ->
			case team_copy_check(CopyId) of
				{?ok,CopyType} ->
					TeamId = idx_api:team_id(),
					LeaderInfo = record_team_m(Player),
					team_init(TeamId,CopyId,CopyType,LeaderInfo,Info#info.map_id,Spid),
					team_notice_fresh(CopyType),
					Player1 = team_api:player_set(Player, [{team_id,TeamId},{team_leader,Uid}]),
					{?ok,Player1};
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		_ ->
			{?error,?ERROR_TEAM_CREATE_HAVE_TEAM}
	end.

team_copy_check(CopyId) ->
	case data_scene_copy:get(CopyId) of
		#d_copy{copy_type=?CONST_COPY_TYPE_HERO} ->
			#hero{copys=Save,times=Times} = role_api_dict:hero_get(),
			case Times > 0 of
				?true ->
					case lists:keyfind(CopyId,#herosave.id,Save) of
						#herosave{} ->
							{?ok,?CONST_COPY_TYPE_HERO};
						_ ->
							{?error,?ERROR_COPY_NOT_COPY}
					end;
				_ ->
					{?error,?ERROR_TEAM_NO_TIMES}
			end;
		#d_copy{copy_type=?CONST_COPY_TYPE_FIEND} ->
			#fiend{copys=Save} = role_api_dict:fiend_get(),
			case lists:keyfind(CopyId,#fiendsave.id,Save) of
				#fiendsave{times=Times,times_day=TimesDay} ->
					case TimesDay =:= 0 orelse Times < TimesDay of
						?true ->
							{?ok,?CONST_COPY_TYPE_FIEND};
						_ ->
							{?error, ?ERROR_TEAM_NO_TIMES}
					end;
				_ ->
					{?error,?ERROR_COPY_NOT_COPY}
			end;
		_ ->
			?MSG_ERROR("This Copy can not team: ~w~n",[CopyId]),
			{?error,?ERROR_UNKNOWN}
	end.

team_init(TeamId,CopyId,CopyType,#team_m{uid=Uid,mpid=Mpid,socket=Socket,name=Name,lv=Lv}=TeamLeader,MapId,Spid) ->
	case team_api:team_data_get(TeamId) of
		?null ->
			Team = #team{
						   team_id	= TeamId,			%% 队伍Id
						   copy_id	= CopyId,			%% 队伍副本Id
						   copy_type= CopyType,			%% 队伍副本类型
						   uid		= Uid,				%% 队长Uid
						   mpid	 	= Mpid,				%% 队长Mpid
						   socket	= Socket,			%% 队长Socket
						   name		= Name,				%% 队长姓名
						   lv		= Lv,				%% 队长等级
						   map		= MapId,			%% 队伍所在地图Id
						   spid		= Spid,				%% 队伍所在地图进程Id
						   state	= ?CONST_TEAM_STATE_TEAMING, %% 队伍状态
						   mem	 	= [TeamLeader#team_m{pos=1}]
						  },
			refresh(Team);
		Team ->
			Team2 = Team#team{team_id=TeamId},
			refresh(Team2)
	end.

join(#player{team_id=MyTeamId}=Player,TeamId) ->
	case MyTeamId of
		0 ->
			case team_api:team_data_get(TeamId) of
				?null ->
					{?error,?ERROR_TEAM_NULL};
				#team{state=?CONST_TEAM_STATE_TEAMING,uid=LeaderUid,mem=Mem,copy_id=CopyId,copy_type=CopyType}=Team ->
					case join_check_copy(CopyType, CopyId) of
						?ok ->
							if length(Mem) < ?CONST_TEAM_MAX ->
								   join_acc(Player,Team),
								   team_notice_fresh(Team#team.copy_type),
								   Player1 = team_api:player_set(Player, [{team_id, TeamId},{team_leader, LeaderUid}]),
								   {?ok,Player1};
							   ?true ->
								   {?error,?ERROR_TEAM_FULL}
							end;
						{?error,ErrorCode} ->
							{?error,ErrorCode}
					end;
				_ ->
					{?error,?ERROR_TEAM_WARING}
			
			end;
		_ ->
			{?error,?ERROR_TEAM_JOIN_HAVE_TEAM}
	end.

join_check_copy(?CONST_COPY_TYPE_HERO, _CopyId) ->
	#hero{times=Times} = role_api_dict:hero_get(),
	case Times > 0 of
		?true ->
			?ok;
		_ ->
			{?error,?ERROR_TEAM_NO_TIMES}
	end;
join_check_copy(?CONST_COPY_TYPE_FIEND, CopyId) ->
	#fiend{team_ids=TeamIds,copys=Copys} = role_api_dict:fiend_get(),
	case lists:keyfind(CopyId,#fiendsave.id,Copys) of
		#fiendsave{times=Times,times_day=TimesDay} ->
			case TimesDay =:= 0 orelse Times < TimesDay of
				?true ->
					?ok;
				_ ->
					{?error, ?ERROR_TEAM_NO_TIMES}
			end;
		_ ->
			case lists:member(CopyId, TeamIds) of
				?true ->
					{?error, ?ERROR_TEAM_NO_TIMES};
				_ ->
					?ok
			end
	end;
join_check_copy(_CopyType, _CopyId) ->
	{?error,?ERROR_UNKNOWN}.


join_acc(#player{uid=Uid}=Player,#team{mem=Mem}=Team) ->
	[Pos|_]	= team_pos_get(Mem,?TEAM_POS),
	TeamMem1= record_team_m(Player),
	TeamMem	= TeamMem1#team_m{pos=Pos},
	case get_team_mem(Mem, Uid) of
		?null ->
			Team2 = Team#team{mem=[TeamMem|Mem]},
			refresh(Team2);
		M ->
			NewMem	= lists:delete(M, Mem),
			Team2	= Team#team{mem=[TeamMem|NewMem]},
			refresh(Team2)
	end.

team_pos_get([#team_m{pos=Pos}|T],TeamPos) ->
	team_pos_get(T,lists:delete(Pos, TeamPos));
team_pos_get([],TeamPos) ->
	TeamPos.

leave(#player{uid=Uid,team_id=TeamId}=Player) ->
	case TeamId of
		0 ->
			?skip;
		_ ->
			case team_api:team_data_get(TeamId) of
				?null ->
					?skip;
				Team ->
					leave_acc(Team,Uid),
					team_notice_fresh(Team#team.copy_type)
			end
	end,
	Player1 = team_api:player_set(Player, [{team_id, 0},{team_leader, 0}]),
	Player1.

leave_acc(#team{team_id=TeamId,spid=Spid,mem=Mem,uid=LeaderUid}=Team,Uid) ->
	case get_team_mem(Mem, Uid) of
		?null ->
			case Mem of
				[] ->
					delete_team(TeamId),
					team_notice_fresh(Team#team.copy_type);
				_ ->
					?skip
			end;
		#team_m{socket=MemSocket}=Member when LeaderUid =:= Uid ->
			BinMsg2 = team_api:msg_exit_notice(?CONST_TEAM_OUT_EXIT),
			app_msg:send(MemSocket, BinMsg2),
			case lists:delete(Member, Mem) of
				[] ->
					delete_team(TeamId),
					team_notice_fresh(Team#team.copy_type);
				Mem2 ->
					[#team_m{uid=NewUid,mpid=NewMpid,socket=NewSocket,name=NewName,lv=Lv}|_] = Mem2,
					Team2	= Team#team{
										uid		= NewUid,		%% 队长Uid
										mpid	= NewMpid,		%% 队长Mpid
										socket	= NewSocket, 	%% 队长Socket
										name	= NewName,		%% 队长姓名
										mem		= Mem2,
										lv		= Lv
									   },
					BinMsg = team_api:msg_new_leader(),
					app_msg:send(NewSocket, BinMsg),
					scene_notice(Spid,NewUid,Uid),
					refresh(Team2),
					team_notice_fresh(Team#team.copy_type)
			end;
		#team_m{socket=MemSocket}=Member ->
			BinMsg	= team_api:msg_exit_notice(?CONST_TEAM_OUT_EXIT),
			app_msg:send(MemSocket, BinMsg),
			case lists:delete(Member, Mem) of
				[] ->
					delete_team(TeamId),
					team_notice_fresh(Team#team.copy_type);
				NewMem ->
					Team2	= Team#team{mem=NewMem},
					refresh(Team2),
					team_notice_fresh(Team#team.copy_type)
			end
	end.

kick(#player{socket=Socket,uid=Uid,team_id=TeamId},MemUid) ->
	case TeamId of
		0 ->
			BinMsg = system_api:msg_error(?ERROR_TEAM_NO_TEAM),
			app_msg:send(Socket, BinMsg);
		_ ->
			case team_api:team_data_get(TeamId) of
				#team{uid=Uid,mem=Mem}=Team ->
					case get_team_mem(Mem, MemUid) of
						?null ->
							BinMsg = system_api:msg_error(?ERROR_TEAM_NO_MEMBER),
							app_msg:send(Socket, BinMsg);
						#team_m{socket=Msocket,mpid=Mmpid}=M ->
							BinMsg	= team_api:msg_exit_notice(?CONST_TEAM_OUT_KICK),
							app_msg:send(Msocket, BinMsg),
							team_api:player_set(Mmpid, [{team_id,0},{team_leader,0}]),
							NewMem	= lists:delete(M, Mem),
							Team2	= Team#team{mem=NewMem},
							refresh(Team2),
							team_notice_fresh(Team#team.copy_type)
					end;
				#team{} ->
					BinMsg = system_api:msg_error(?ERROR_TEAM_NOT_LEADER),
					app_msg:send(Socket, BinMsg);
				_ ->
					BinMsg = system_api:msg_error(?ERROR_TEAM_NULL),
					app_msg:send(Socket, BinMsg)
			end
	end.

leader_set(#player{uid=Uid,team_id=TeamId}=Player,MemUid) ->
	case TeamId of
		0 ->
			{?error,?ERROR_TEAM_NO_TEAM};
		_ ->
			case team_api:team_data_get(TeamId) of
				#team{uid=Uid,mem=Mem}=Team ->
					case get_team_mem(Mem, MemUid) of
						?null ->
							{?error,?ERROR_TEAM_NO_MEMBER};
						#team_m{mpid=Nmpid,socket=Nsocket,name=Nname} ->
							Team2 = Team#team{
											  uid		= MemUid,		%% 队长Uid
											  mpid	 	= Nmpid,		%% 队长Mpid
											  socket	= Nsocket,		%% 队长Socket
											  name		= Nname			%% 队长姓名
											 },
							refresh(Team2),
							team_notice_fresh(Team#team.copy_type),
							team_api:player_set(Nmpid, [{team_id,TeamId},{team_leader,MemUid}]),
							Player2 = team_api:player_set(Player, [{team_id, TeamId},{team_leader, MemUid}]),
							{?ok,Player2}
					end;
				#team{} ->
					{?error,?ERROR_TEAM_NOT_LEADER};
				_ ->
					{?error,?ERROR_TEAM_NULL}
			end
	end.

leader_apply(#player{socket=Socket,uid=Uid,team_id=TeamId,uname=Name,uname_color=NameColor}) ->
	case TeamId of
		0 ->
			BinMsg = system_api:msg_error(?ERROR_TEAM_NO_TEAM),
			app_msg:send(Socket, BinMsg);
		_ ->
			case team_api:team_data_get(TeamId) of
				#team{uid=Uid} ->
					BinMsg = system_api:msg_error(?ERROR_TEAM_IS_LEADER),
					app_msg:send(Socket, BinMsg);
				#team{socket=LeaderSocket} ->
					BinMsg = team_api:msg_apply_notice(Uid,Name,NameColor),
					app_msg:send(LeaderSocket, BinMsg);
				_ ->
					BinMsg = system_api:msg_error(?ERROR_TEAM_NULL),
					app_msg:send(Socket, BinMsg)
			end
	end.

invite(#player{team_id=TeamId,uid=Uid,uname=Uname,uname_color=UnameColor},InviteUid,InviteType) ->
	case TeamId of
		0 ->
			{?error,?ERROR_TEAM_NO_TEAM};
		_ ->
			case team_api:team_data_get(TeamId) of
				#team{uid=Uid,copy_id=CopyId} ->
					case role_api:is_online2(InviteUid) of
						?true ->
							invite_acc(Uid,Uname,UnameColor,TeamId,CopyId,InviteUid,InviteType);
						_ ->
							{?error,?ERROR_USER_OFF_LINE}
					end;
				#team{} ->
					{?error,?ERROR_TEAM_NOT_LEADER};
				_ ->
					{?error,?ERROR_TEAM_NULL}
			end
	end.

invite_acc(Uid,Uname,UnameColor,TeamId,CopyId,InviteUid,InviteType) ->
	case InviteType of
		?CONST_TEAM_INVITE_FRIEND ->
			case friend_api:check_is_friend(InviteUid,?CONST_FRIEND_FRIEND) of
				?true ->
					BinMsg = team_api:msg_invite_notice(?CONST_TEAM_INVITE_FRIEND,Uname,UnameColor,CopyId,TeamId),
					app_msg:send(InviteUid, BinMsg),
					?ok;
				_ ->
					{?error,?ERROR_UNKNOWN}
			end;
		?CONST_TEAM_INVITE_CLAN ->
			case clan_api:check_same_clan(Uid,InviteUid) of
				?true ->
					BinMsg = team_api:msg_invite_notice(?CONST_TEAM_INVITE_CLAN,Uname,UnameColor,CopyId,TeamId),
					app_msg:send(InviteUid, BinMsg),
					?ok;
				_ ->
					{?error,?ERROR_UNKNOWN}
			end;
		_ ->
			{?error,?ERROR_UNKNOWN}
	end.

%% 组队场景通知
scene_notice(Spid, NewLeaderUid, OldLeaderUid) ->
	scene_api:change_team_leader(Spid, NewLeaderUid, OldLeaderUid).
	
%% 检查队员是否在队伍中
get_team_mem([#team_m{uid=Uid}=M|_Mem], Uid) ->
	M;
get_team_mem([_M|Mem],Uid) ->
	get_team_mem(Mem,Uid);
get_team_mem([], _Uid) ->
	?null.

record_team_m(#player{mpid=Mpid,uid=Uid,socket=Socket,uname=Name,uname_color=NameColor,lv=Lv,pro=Pro,info=Info}) ->
	#info{powerful=Power} = Info,
	ClanName=clan_api:clan_name_get(Uid),
	#team_m{
			uid			= Uid,		%% 队伍成员Uid
			mpid		= Mpid,		%% 队伍成员Mpid
			socket		= Socket,	%% 队伍成员Socket
			name		= Name,		%% 队伍成员姓名
			name_color	= NameColor,%% 队伍成员姓名颜色
			clan_name	= ClanName,	%% 社团名字
			lv			= Lv,		%% 队伍成员等级
			pro			= Pro,		%% 队伍成员职业
			power		= Power		%% 队伍成员战斗力
		   }.

%% 队伍数据刷新
refresh(Team=#team{team_id=TeamId,uid=Uid,mem=Mem}) ->
	update_player(Mem, [{team_id,TeamId},{team_leader,Uid}]),
	BinMsg	= team_api:msg_team_info(Team),
	BinNew	= team_api:msg_team_info_new(Team),
	broadcast_handle(Mem, <<BinMsg/binary,BinNew/binary>>),
	update_team(Team).

update_team(Team) ->
	ets:insert(?ETS_TEAM, Team).

delete_team(TeamId) ->
	ets:delete(?ETS_TEAM, TeamId).

%% 更新队伍成员player数据
update_player(Mpid, Datas) when is_pid(Mpid) ->
	team_api:player_set(Mpid, Datas);
update_player([#team_m{mpid=Mpid}|Members], Datas) ->
	team_api:player_set(Mpid, Datas),
	update_player(Members, Datas);
update_player([], _) ->
	?ok.

%% 回调函数--队伍广播
broadcast_handle([#team_m{socket=Socket}|Members], BinMsg) ->
	app_msg:send(Socket, BinMsg),
	broadcast_handle(Members, BinMsg);
broadcast_handle([], _BinMsg) ->
	?ok.