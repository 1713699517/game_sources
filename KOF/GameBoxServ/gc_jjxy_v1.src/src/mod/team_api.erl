%% Author  : mirahs
%% Created: 2012-6-20
%% Description: TODO: Add description to team_api
-module(team_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 login/1,
		 logout/1,
		 exit_team/1,
		 exit_off/1,
		 exit_off_line/1,
		 player_set/2,
		 player_set_cb/2,
		 
		 mem_mpids/1,
		 mem_uids/1,
		 team_set/2,
		 team_data_get/1,
		 
		 request_team/1,
		 request_pass/1,
		 team_live/2,
		 
		 msg_team_reply/2,
		 msg_pass_reply/2,
		 msg_team_info/1,
		 msg_team_info_new/1,
		 msg_new_leader/0,
		 msg_exit_notice/1,
		 msg_apply_notice/3,
		 msg_invite_notice/5,
		 msg_team_live_rep/2
		]).

login(Player) ->
	Player#player{team_id=0,team_leader=0,team_type=0}.

logout(Player) ->
	exit_off(Player).

exit_team(Player) ->
	exit_off(Player).

%% 掉线退出队伍
exit_off(#player{uid=Uid,team_id=TeamId}=Player) ->
	case TeamId of
		0 ->
			Player;
		_ ->
			team_mod:exit_off(TeamId, Uid),
			Player2 = player_set(Player, [{team_id, 0},{team_leader, 0}]),
			Player2
	end.

%% 断线重连
exit_off_line(Player) ->
	exit_off(Player).

%% 设定玩家属性
player_set(Mpid,List) when is_pid(Mpid) orelse is_number(Mpid) ->
	util:pid_send(Mpid, ?MODULE, player_set_cb, List);
player_set(Player, []) ->
	Player;
player_set(Player, [{Key, Value}|List]) ->
	Player2 = player_set(Player, Key, Value),
	player_set(Player2, List).

player_set_cb(Player,List)->
	player_set(Player, List).

player_set(Player, Key, Value) ->
	case Key of
		team_id ->
			Player#player{team_id=Value};
		team_leader ->
			Player#player{team_leader=Value};
		_ ->
			Player
	end.

%% 队伍成员的Mpid(包括队长,队长在最前面)
mem_mpids(TeamId) ->
	case team_data_get(TeamId) of
		#team{uid=LeaderUid,mpid=LeaderMpid,mem=Mem} ->
			F = fun(#team_m{uid=Uid,mpid=Mpid}, Acc) when Uid =/= LeaderUid ->
						[Mpid|Acc];
				   (_, Acc) ->
						Acc
				end,
			Mpids = lists:foldl(F, [], Mem),
			[LeaderMpid|Mpids];
		_ ->
			[]
	end.

%% 队伍成员的Uid(包括队长,队长在最前面)
mem_uids(TeamId) ->
	case team_data_get(TeamId) of
		#team{uid=LeaderUid,mem=Mem} ->
			F = fun(#team_m{uid=Uid}, Acc) when Uid =/= LeaderUid ->
						[Uid|Acc];
				   (_M, Acc) ->
						Acc
				end,
			SidUids	= lists:foldl(F, [], Mem),
			[LeaderUid | SidUids];
		_ ->
			[]
	end.

%% 队伍状态设置
team_set(TeamId,DataList) ->
	case team_data_get(TeamId) of
		#team{state=?CONST_TEAM_STATE_TEAMING,copy_type=CopyType}=Team ->
			team_mod:team_notice_fresh(CopyType),
			Team2 = team_set_acc(Team,DataList),
			team_mod:update_team(Team2);
		#team{state=?CONST_TEAM_STATE_WARING}=Team ->
			Team2 = team_set_acc(Team,DataList),
			team_mod:update_team(Team2);
		_ ->
			?skip
	end.

team_set_acc(Team,[{Key,Data}|DataList]) ->
	Team2 =
		case Key of
			map ->
				Team#team{map=Data};
			spid ->
				Team#team{spid=Data};
			state ->
				Team#team{state=Data};
			copy_id ->
				Team#team{copy_id=Data};
			copy_type ->
				Team#team{copy_type=Data}
		end,
	team_set_acc(Team2,DataList);
team_set_acc(Team,[]) ->
	Team.

%% 查找队伍数据
team_data_get(TeamId) ->
	case ets:lookup(?ETS_TEAM, TeamId) of
		[Team] ->
			Team;
		_ ->
			?null
	end.

request_team(Type) ->
	case lists:member(Type, ?TEAM_TYPES) of
		?true ->
			TeamList1 = ets:tab2list(?ETS_TEAM),
			TeamList = [Team || Team <- TeamList1,Team#team.state =/= ?CONST_TEAM_STATE_WARING],
			BinMsg = msg_team_reply(TeamList,Type),
			{?ok,BinMsg};
		_ ->
			{?error,?ERROR_UNKNOWN}
	end.

request_pass(Type) ->
	Ids= pass_copy_get(Type),
	BinMsg = msg_pass_reply(Ids,Type),
	BinMsg.

pass_copy_get(Type) ->
	case Type of
		?CONST_COPY_TYPE_NORMAL ->
			#chapcopy{copys=Copys} = role_api_dict:copy_get(),
			[CopyId || #copysave{id=CopyId} <- Copys];
		?CONST_COPY_TYPE_HERO ->
			#hero{copys=Copys} = role_api_dict:hero_get(),
			[CopyId || #herosave{id=CopyId} <- Copys];
		?CONST_COPY_TYPE_FIEND ->
			#fiend{copys=Copys} = role_api_dict:fiend_get(),
			[CopyId || #fiendsave{id=CopyId} <- Copys];
		_ ->
			[]
	end.

team_live(TeamId,Type) ->
	Rep =
		case team_data_get(TeamId) of
			#team{mem=Mem} ->
				case length(Mem) >= ?CONST_TEAM_MAX of
					?true ->
						?CONST_FALSE;
					_ ->
						?CONST_TRUE
				end;
			_ ->
				?CONST_FALSE
		end,
	BinMsg = msg_team_live_rep(Rep,Type),
	BinMsg.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
msg_team_reply(TeamList,Type) ->
	Fun = fun(#team{team_id=TeamId,copy_id=CopyId,copy_type=CopyType,name=Name,lv=Lv,mem=Mem},{AccBin,AccNum}) when CopyType =:= Type ->
				  BinF = app_msg:encode([{?int32u,TeamId},{?int16u,CopyId},{?string,Name},{?int16u,Lv},{?int16u,length(Mem)}]),
				  {<<AccBin/binary,BinF/binary>>,AccNum+1};
			 (_,{AccBin,AccNum}) ->
				  {AccBin,AccNum}
		  end,
	{Bin1,Num} = lists:foldl(Fun, {<<>>,0}, TeamList),
	Bin = app_msg:encode([{?int8u,Type},{?int16u,Num}]),
	BinData = <<Bin/binary,Bin1/binary>>,
	app_msg:msg(?P_TEAM_REPLY, BinData).

msg_pass_reply(Ids,Type) ->
	Fun = fun(CopyId,AccBin) ->
				  BinF = app_msg:encode([{?int16u,CopyId}]),
				  <<AccBin/binary,BinF/binary>>
		  end,
	BinData = lists:foldl(Fun, app_msg:encode([{?int8u,Type},{?int16u,length(Ids)}]), Ids),
	app_msg:msg(?P_TEAM_PASS_REPLY, BinData).

msg_team_info(#team{team_id=TeamId,copy_id=CopyId,uid=LeaderUid,mem=Mem}) ->
	Bin = app_msg:encode([{?int32u,TeamId},{?int16u,CopyId},{?int32u,LeaderUid},{?int16u,length(Mem)}]),
	Fun = fun(#team_m{uid=Uid,name=Name,name_color=NameColor,lv=Lv,pos=Pos,power=Power,clan_name=ClanName},AccBin) ->
				  BinF = app_msg:encode([{?int32u,Uid},{?string,Name},{?int8u,NameColor},{?int16u,Lv},{?int8u,Pos},{?int32u,Power},{?string,ClanName}]),
				  <<AccBin/binary,BinF/binary>>
		  end,
	BinData = lists:foldl(Fun, Bin, Mem),
	app_msg:msg(?P_TEAM_TEAM_INFO, BinData).

msg_team_info_new(#team{team_id=TeamId,copy_id=CopyId,uid=LeaderUid,mem=Mem}) ->
	Bin = app_msg:encode([{?int32u,TeamId},{?int16u,CopyId},{?int32u,LeaderUid},{?int16u,length(Mem)}]),
	Fun = fun(#team_m{uid=Uid,name=Name,name_color=NameColor,lv=Lv,pos=Pos,power=Power,clan_name=ClanName,pro=Pro},AccBin) ->
				  BinF = app_msg:encode([{?int32u,Uid},{?string,Name},{?int8u,NameColor},{?int16u,Lv},{?int8u,Pos},{?int32u,Power},{?string,ClanName},{?int8u,Pro}]),
				  <<AccBin/binary,BinF/binary>>
		  end,
	BinData = lists:foldl(Fun, Bin, Mem),
	app_msg:msg(?P_TEAM_TEAM_INFO_NEW, BinData).

msg_new_leader() ->
	app_msg:msg(?P_TEAM_NEW_LEADER, <<>>).

msg_exit_notice(Reason) ->
	BinData = app_msg:encode([{?int8u,Reason}]),
	app_msg:msg(?P_TEAM_LEAVE_NOTICE, BinData).

msg_apply_notice(Uid,Name,NameColor) ->
	BinData = app_msg:encode([{?int32u,Uid},{?string,Name},{?int8u,NameColor}]),
	app_msg:msg(?P_TEAM_APPLY_NOTICE, BinData).

msg_invite_notice(Type,Uname,UnameColor,CopyId,TeamId) ->
	BinData = app_msg:encode([{?int8u,Type},{?string,Uname},{?int8u,UnameColor},{?int16u,CopyId},{?int32u,TeamId}]),
	app_msg:msg(?P_TEAM_INVITE_NOTICE, BinData).

msg_team_live_rep(Rep,Type) ->
	BinData = app_msg:encode([{?int8u,Rep},{?int8u,Type}]),
	app_msg:msg(?P_TEAM_LIVE_REP, BinData).