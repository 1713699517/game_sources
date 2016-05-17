%% Author: tanwer
%% Created: 2013-06-26
%% Description: TODO: Add description to clan_mod
-module(clan_mod).

%%
%% Include files
%%
-include("../include/comm.hrl"). 

%%
%% Exported Functions
%%
%% -export([
%% 		 %%　调试用，
%% 		 check_date/1,
%% 		 check_date_times/2,
%% 		 clan_groudup_acc/2,
%% 		 data2bin_rankpage/1,
%% 		 get_clanskill_lv/2,
%% 		 ref_clan_rank/1,
%% 		 ref_rank_acc/3,
%% 		 get_water_cast/3
%% 		]).


-export([
		 request_other_clan/1,
		 request_self_clan/1,
		 
		 join_clan_handl/2,
		 role_clan_change_cb/2,
		 cancel_clan_handl/2,
		 out_clan/3,
		 request_audit_handl/4,
		 join_clan_cb/2,
		 not_join_cb/2,
		 
		 clan_groudup/1,
		 insert_new_clan/1,
		 delete_member/1,
		 insert_new_member/1,
		 set_post_acc/4,
		 set_out_clan/3,
		 delete_member_cb/2,
		 is_master/1,
		 have_clan/2,
		 chack_outclan_time/1,
		 
		 get_clan4id/1,
		 get_clan_mem/1,
		 get_clan_memlists/1,
		 get_allclan/0,
		 get_attr/4,
		 get_clan_skill/1,
		 join_attr/1
		 
		]).




%%　帮派升级
%%　{NewLv,NewDevoteUp,NewMax,NewExpPlus,NewGoldPuls}
clan_groudup(Devote) ->
	NewLv=clan_groudup_acc(0,Devote),
	case data_clan_level:get(NewLv) of
		#d_clan{devote_up=DevoteUp,max=Max,exp_plus=ExpPlus,gold_plus=GoldPuls} ->
			{NewLv,DevoteUp,Max,ExpPlus,GoldPuls};
		_ ->
			#d_clan{devote_up=DevoteUp} =data_clan_level:get(1),
			{0,DevoteUp,?CONST_CLAN_NEW_CLAN_MAX,0,0}
	end.
clan_groudup_acc(Lv,Value) ->
	case data_clan_level:get(Lv+1) of
		#d_clan{devote=Devote,devote_up=DevoteUp} ->
			if Value >= DevoteUp ->
				   clan_groudup_acc(Lv+1,Value);
			   Value >= Devote ->
				   Lv+1;
			   ?true ->
				   Lv
			end;
		_ ->
			Lv
	end.

%% 请求自己帮派数据
request_self_clan(Uid) ->
	case get_clan_mem(Uid) of
		#clan_mem{devote_sum=DevoteSun,post=Post,clan_id=ClanId} ->
			case get_clan4id(ClanId) of
				#clan_public{clan_id=ClanId,clan_lv=ClanLv,clan_name=ClanName,devote=ClanAllContribute,logs=LogsData,
							 master_id=MasterUid,master_lv=MasterLv,master_name=MasterName,master_name_color=MasterColor,
							 max_member=ClanAllMembers,member=UidList,notice=Notice,up_devote=ClanUpContribute,clan_rank=ClanRank} ->
					case role_api_dict:clan_get() of
						#clan{clan_id=ClanId} ->
							ok;
						#clan{clan_skill=ClanSkill} ->
							role_api_dict:clan_set(#clan{clan_id=ClanId,clan_name=ClanName,clan_skill=ClanSkill});
						_ ->
							role_api_dict:clan_set(#clan{clan_id=ClanId,clan_name=ClanName})
					end,
					BinMsg1=clan_api:msg_ok_clan_data(ClanId, ClanName, ClanLv, ClanRank, length(UidList), ClanAllMembers),
					BinMsg2=clan_api:msg_ok_other_data(MasterUid, MasterName, MasterColor, MasterLv, DevoteSun,Post,
													   ClanAllContribute, ClanUpContribute, Notice),
					BinMsg3=clan_api:msg_clan_logs(LogsData),
					{?ok,<<BinMsg1/binary,BinMsg2/binary,BinMsg3/binary>>};
				_ ->
					#clan{clan_skill=ClanSkill}=role_api_dict:clan_get(),
					role_api_dict:clan_set(#clan{clan_skill=ClanSkill}),
					{?error,?ERROR_CLAN_NULL1}
			end;
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end.

%% 请求其他帮派数据
request_other_clan(ClanId) ->
	case get_clan4id(ClanId) of
		#clan_public{clan_id=ClanId,clan_lv=ClanLv,clan_name=ClanName,devote=ClanAllContribute,
					 master_id=MasterUid,master_lv=MasterLv,master_name=MasterName,master_name_color=MasterColor,
					 max_member=ClanAllMembers,member=UidList,notice=Notice,up_devote=ClanUpContribute,clan_rank=ClanRank} ->
			BinMsg1=clan_api:msg_ok_clan_data(ClanId, ClanName, ClanLv, ClanRank, length(UidList), ClanAllMembers),
			BinMsg2=clan_api:msg_ok_other_data(MasterUid, MasterName, MasterColor, MasterLv, 0,0,
									  ClanAllContribute, ClanUpContribute, Notice),
			{?ok,<<BinMsg1/binary,BinMsg2/binary>>};
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end.	

%% 申请加入帮派
%%　return: {?error,ErrorCode} ||　?ok
join_clan_handl(#player{uid=Uid,uname=Name,uname_color=NameColor,pro=Pro,lv=Lv,mpid=Mpid},ClanId) ->
	case clan_mod:get_clan4id(ClanId) of
		#clan_public{clan_id=ClanId,master_id=MasterUid,master_list=MasterList,apply_list=ApplyList,
					 member=MemList,max_member=Max,logs=Logs}=ClanPublic ->
			case length(MemList) < Max of
				?true ->
					Now = util:seconds(),
					NewLog={?CONST_CLAN_APPLY_JOIN, Now, [{Name, NameColor}], []},
					Logs2=lists:keysort(2, [NewLog|Logs]),
					Logs3=lists:sublist(lists:reverse(Logs2), ?CONST_CLAN_EVENT_COUNT_MAX),
					ApplyList2 = [{Uid,Name,NameColor,Lv,Pro,Now}|ApplyList],
					ClanPublic2=ClanPublic#clan_public{apply_list=ApplyList2,logs = Logs3},
					ets:insert(?ETS_CLAN_PUBLIC,ClanPublic2),
					[logs_api:action_notice(U, ?CONST_LOGS_1111, [], [])|| U <- [MasterUid|MasterList]],
					util:pid_send(Mpid, ?MODULE, role_clan_change_cb, [{?ok,Now,ClanId}]),
					?ok;
				_ ->
					BinErr = system_api:msg_error(?ERROR_CLAN_MEMBERS_FULL),
					app_msg:send(Uid, BinErr)
					
			end;
		_ ->
			BinErr = system_api:msg_error(?ERROR_CLAN_NO_EXIT),
			app_msg:send(Uid, BinErr)
	end.

%% 申请加入帮派回调更新申请列表
role_clan_change_cb(Player,[{?ok,Now,ClanId}]) ->
	Clan=role_api_dict:clan_get(),
	ClanList = [{Now,ClanId}|Clan#clan.ask_clanlist],
	role_api_dict:clan_set(Clan#clan{ask_clanlist=ClanList}),
	Player.

%% 取消入帮申请
%%　return:　?ok
cancel_clan_handl(Uid,ClanId) ->
	case clan_mod:get_clan4id(ClanId) of
		#clan_public{apply_list=ApplyList}=ClanPublic ->
			case lists:keytake(Uid, 1, ApplyList) of
				{value, _, ApplyList2} ->
					ets:insert(?ETS_CLAN_PUBLIC,ClanPublic#clan_public{apply_list=ApplyList2}),
					?ok;
				_ ->
					BinErr = system_api:msg_error(?ERROR_CLAN_APPLY_ALREADY),
					app_msg:send(Uid, BinErr)
			end;
		_ ->
			BinErr = system_api:msg_error(?ERROR_CLAN_NO_EXIT),
			app_msg:send(Uid, BinErr)
	end.

%% 审核操作
request_audit_handl({Name,NameColor}, Uid, ToUid, State) ->
	case is_master(Uid) of
		{?true,#clan_public{apply_list=ApplyList,member=Member,clan_id=ClanId,clan_name=ClanName,logs=ClanLogs,max_member=Max}=ClanPub} ->
			case length(Member) < Max of
				?true ->
					case lists:keytake(ToUid, 1, ApplyList) of
						{value, {ToUid,ToName,ToNameColor,ToLv,ToPro,_ToTime}, TupleList2} ->
							case get_clan_mem(ToUid) of
								?null ->
									case State of
										?CONST_TRUE ->
											Time=util:seconds(),
											OutTime=?IF(role_api:is_online(ToUid)=:=?true, 1, util:seconds()),
											ToClanMem= #clan_mem{clan_id=ClanId,devote_day=0,devote_sum=0,join_time=Time,
																 logout_time=OutTime,por=ToPro,lv=ToLv,uid=ToUid,name=ToName,
																 name_color=ToNameColor,post=?CONST_CLAN_POST_COMMON},
											Logs={?CONST_CLAN_EVENT_JOIN, Time, [{ToName,ToNameColor}], []},
											ClanPub2=ClanPub#clan_public{apply_list=TupleList2,member=[ToUid|Member],logs=[Logs|ClanLogs]},
											insert_new_clan(ClanPub2),
											insert_new_member(ToClanMem),
											stat_api:logs_clan(ToUid,ClanId,ClanName,?CONST_TRUE,request_audit),
											case role_api:mpid(ToUid) of
												ToPid when is_pid(ToPid)->
													util:pid_send(ToPid, ?MODULE, join_clan_cb, [ClanId,ClanName,{Name,NameColor}]);
												_ ->
													{ok, #clan{clan_skill=OldSkill}} = role_api_dict:clan_get(ToUid),
													ToClan2 = #clan{clan_id=ClanId,clan_name=ClanName,clan_skill=OldSkill},
													role_api_dict:clan_set(ToUid, ToClan2)
											end;
										_ ->
											case role_api:mpid(ToUid) of
												ToPid when is_pid(ToPid)->
													util:pid_send(ToPid, ?MODULE, not_join_cb, [ClanId,ClanName,{Name,NameColor}]);
												_ ->
													{?ok, #clan{ask_clanlist=AskList}} = role_api_dict:clan_get(ToUid),
													ToClan2 = #clan{ask_clanlist=[{Tim0,CId0}||{Tim0,CId0} <- AskList,CId0=/=ClanId]},
													role_api_dict:clan_set(ToUid, ToClan2)
											end,
											ClanPub2=ClanPub#clan_public{apply_list=TupleList2},
											ets:insert(?ETS_CLAN_PUBLIC, ClanPub2)
									end;
								_ ->
									ets:insert(?ETS_CLAN_PUBLIC, ClanPub#clan_public{apply_list=TupleList2}),
									BinErr = system_api:msg_error(?ERROR_CLAN_APPPLY_NULL),
									app_msg:send(Uid, BinErr)
							end;
						_ ->
							BinErr = system_api:msg_error(?ERROR_CLAN_APPLY_EXIST),
							app_msg:send(Uid, BinErr)
					end;
				_ -> 
					ets:insert(?ETS_CLAN_PUBLIC, ClanPub#clan_public{apply_list=[]}),
					BinErr = system_api:msg_error(?ERROR_CLAN_MEMBERS_FULL),
					app_msg:send(Uid, BinErr)
			end;
		_ ->
			BinErr = system_api:msg_error(?ERROR_CLAN_NOT_OFFICIAL),
			app_msg:send(Uid, BinErr)
	end.

%% 允许加入帮派
join_clan_cb(#player{spid=Spid,uid=Uid,socket=Socket,mpid=Mpid}=Player,[ClanId,ClanName, _]) ->
	Player2 = clan_mod:join_attr(Player),
	Clan=role_api_dict:clan_get(),
	role_api_dict:clan_set(#clan{clan_id=ClanId,clan_name=ClanName,clan_skill=Clan#clan.clan_skill}),
	task_api:check_cast(Mpid,?CONST_TASK_TARGET_OTHER, ClanId),
	scene_api:change_clan(Spid,Uid, ClanId, ClanName),
	logs_api:action_notice(Uid, ?CONST_LOGS_8005, [{ClanName,0}], []),
	BinRole= role_api:clan_u(0, ClanId, ClanName),
	app_msg:send(Socket, BinRole),
	Player2.
%% 拒绝加入帮派
not_join_cb(Player, [ClanId, _ClanName, _]) ->
	Clan = role_api_dict:clan_get(),
	#clan{ask_clanlist=AskList} = Clan,
	Clan2 = #clan{ask_clanlist=[{Tim0,CId0}||{Tim0,CId0} <- AskList,CId0=/=ClanId]},
	role_api_dict:clan_set(Clan2),
	Player.	


%% 新建|更新帮派信息
insert_new_clan(ClanPub) ->
	#clan_public{clan_id=ClanId,clan_lv=ClanLv,clan_name=ClanName,devote=Devote,
				 master_id=MasterId,master_lv=MasterLv,master_name=Name,master_name_color=NameColor,
				 max_member=MaxMembers, notice= Notice, seconds=Seconds,
				 up_devote=UpDevote,clan_rank=ClanRank,
				 member= Member0,master_list=MasterList0} = ClanPub,
%% 	Notice		= mysql_api:encode(Notice0),
	Member		= mysql_api:encode(Member0),
	MasterList	= mysql_api:encode(MasterList0),
	SQL	= <<"REPLACE INTO `clan_public` (`clan_id`,`clan_rank`,`clan_name`,`clan_lv`,`devote`,`up_devote`,`max_member`,
			`master_id`,`master_name`,`master_color`,`master_Lv`,`notice`,`member`,`master_list`,`seconds`) VALUES ",
			"('", ?B(ClanId),     			"','", ?B(ClanRank), 		"','", ?B(mysql_api:escape(ClanName)),  			"','", ?B(ClanLv),
			"','", ?B(Devote),    			"','", ?B(UpDevote), 		"','", ?B(MaxMembers), 			"','", ?B(MasterId),
			"','", ?B(Name),  				"','", ?B(NameColor), 		"','", ?B(MasterLv), 			"','", ?B(mysql_api:escape(Notice)),
			"',", Member/binary, 			",", MasterList/binary, 		",'", ?B(Seconds),"');">>,
	mysql_api:fetch_cast(SQL),
	ets:insert(?ETS_CLAN_PUBLIC, ClanPub).

%% 新建|更新成员帮派信息
insert_new_member(ClanMem) ->
	#clan_mem{clan_id=ClanId,devote_day=DevoteDay,devote_sum=DevoteSum,join_time=JoinTime,logout_time=LogoutTime,
			  lv=Lv,name=Name,name_color=NameColor,post=Post,uid=Uid}=ClanMem,
	SQL	= <<"REPLACE INTO `clan_mem` (`uid`,`clan_id`,`name`,`name_color`,`lv`,`post`,`devote_day`,`devote_sum`,`logout_time`,`join_time`) VALUES ",
			"('", ?B(Uid), 			 	"','", ?B(ClanId), 		"','", ?B(Name), 			"','", ?B(NameColor),
			"','", ?B(Lv), 				"','", ?B(Post), 		"','", ?B(DevoteDay), 		"','", ?B(DevoteSum),
			"','", ?B(LogoutTime), 		"','", ?B(JoinTime), "');">>,
	mysql_api:fetch_cast(SQL),
	ets:insert(?ETS_CLAN_MEMBER, ClanMem).

%% 删除成员帮派信息
delete_member(Uid) ->
	SQL3 = <<"DELETE FROM `clan_mem` WHERE `clan_mem`.`uid` = ",?B(Uid)," LIMIT 1 ;">>,
	mysql_api:fetch_cast(SQL3),
	ets:delete(?ETS_CLAN_MEMBER, Uid).

%% 离开帮派时间检查
%%　return:  ?true || ?false
chack_outclan_time(Time) ->
	case Time of
		0 -> ?true;
		Time -> ?IF(util:seconds() - Time >= ?CONST_CLAN_TIME_OUTCLAN*60*60, ?true, ?false)
	end.

%% 检查玩家是否是帮派管理员
%%　return:  {?true, ClanPub}|| ?false
is_master(Uid) ->
	case ets:lookup(?ETS_CLAN_MEMBER,Uid) of
		[#clan_mem{clan_id=ClanId}|_] ->
			case ets:lookup(?ETS_CLAN_PUBLIC, ClanId) of
				[#clan_public{master_id=MasterUid,master_list=MasterList,apply_list=ApplyList}=ClanPub|_] ->
					Now=util:seconds(),
					ApplyList2=[{U,N,NC,L,P,T} || {U,N,NC,L,P,T} <- ApplyList,T > Now-24*60*60],%% 检查申请者的申请是否有效
					?IF(lists:member(Uid,[MasterUid|MasterList]),{?true,ClanPub#clan_public{apply_list=ApplyList2}},?false);
				_ ->
					?false
			end;
		_ ->
			?false
	end.

%% 设置帮派成员职位
set_post_acc(ClanPub,NewLog,Logs,NewMemberList) ->
	Logs2=lists:keysort(2, [NewLog|Logs]),
	Logs3=lists:sublist(lists:reverse(Logs2), ?CONST_CLAN_EVENT_COUNT_MAX),
	insert_new_clan(ClanPub#clan_public{logs=Logs3}),
	[insert_new_member(NewClanMem)||NewClanMem <- NewMemberList].


%% 踢出成员
set_out_clan(ClanPub,NewLog,ToUid) ->
	case role_api:mpid(ToUid) of
		MPid when is_pid(MPid) ->
			util:pid_send(MPid, ?MODULE, delete_member_cb, ?null);
		_ ->
			{?ok,Clan} = role_api_dict:clan_get(ToUid),
			role_api_dict:clan_set(ToUid,#clan{ask_clanlist = [], 
											   outtime		= util:seconds(),
											   clan_skill	= Clan#clan.clan_skill})
	end,
	out_clan(ClanPub,NewLog,ToUid).

%% 删除成员帮派信息
delete_member_cb(#player{spid=Spid,uid=Uid,socket=Socket}=Player,_) ->
	Time=util:seconds(),
	Clan=role_api_dict:clan_get(),
	role_api_dict:clan_set(#clan{outtime=Time,clan_skill=Clan#clan.clan_skill}),
	BinRole=role_api:clan_u(0, 0, <<>>),
	scene_api:change_clan(Spid,Uid,0, <<>>),
	app_msg:send(Socket, BinRole),
	Player.

%% 退出帮派
out_clan(#clan_public{logs=Logs,clan_id=ClanId,clan_name=ClanName}=ClanPub,NewLog,Uid) ->
	Logs2=lists:keysort(2, [NewLog|Logs]),
	Logs3=lists:sublist(lists:reverse(Logs2), ?CONST_CLAN_EVENT_COUNT_MAX),
	stat_api:logs_clan(Uid,ClanId,ClanName,?CONST_FALSE,set_out_clan),
	insert_new_clan(ClanPub#clan_public{logs=Logs3}),
	delete_member(Uid).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%__________get_data_____________%%%%%%%%%%%%%%%%%%%%%%%%%%
%%　通过帮派Id查找帮派信息
%% return: ClanPublic || ?null
get_clan4id(ClanId) ->
	case ets:lookup(?ETS_CLAN_PUBLIC, ClanId) of
		[#clan_public{}=ClanPublic|_] ->
			ClanPublic;
		_ ->
			Sql = "SELECT `clan_id`,`clan_rank`,`clan_name`,`clan_lv`,`devote`,`up_devote`,`max_member`,`master_id`,
					`master_name`,`master_color`,`master_Lv`,`notice`,`seconds`,`member`,`master_list`,
					FROM `clan_public` where `clan_id` = " ++ util:to_list(ClanId),
			case mysql_api:select(Sql) of
				{?ok, [[ClanId,ClanRank,ClanName,ClanLv,Devote,UpDevote,Max,Mid,Mname,Mcolor,MLv,Notice,Seconds,Member,MasterList]|_]} ->
					ClanPublic = #clan_public{clan_id=ClanId,clan_name=ClanName,clan_lv=ClanLv,devote=Devote,up_devote=UpDevote,
											  max_member=Max,master_id = Mid, master_name = Mname,master_name_color=Mcolor,
											  master_lv=MLv,notice = Notice,clan_rank=ClanRank,seconds = Seconds,
											  member = mysql_api:decode(Member),
											  master_list= mysql_api:decode(MasterList)},
					ets:insert(?ETS_CLAN_PUBLIC, ClanPublic),
					ClanPublic;
				_ ->
					?null
			end
	end.

%% 通过玩家Uid查找玩家帮派信息
%% return: ClanMember || ?null
get_clan_mem(Uid) ->
	case ets:lookup(?ETS_CLAN_MEMBER, Uid) of
		[#clan_mem{}=ClanMember|_] ->
			ClanMember;
		_ ->
			SQL= "SELECT `uid`,`clan_id`,`name`,`name_color`,`lv`,`post`,`devote_day`,`devote_sum`,`logout_time`,`join_time` 
					FROM `clan_mem` where `uid` = " ++ util:to_list(Uid),
			case mysql_api:select(SQL) of
				{?ok, [[Uid,ClanId,Name,NameColor,Lv,Post,DevoteDay,DevoteSum,LogoutTime,JoinTime]|_]} ->
					ClanMember = #clan_mem{uid = Uid, clan_id = ClanId, name = Name, name_color = NameColor,
										   lv = Lv, post = Post, devote_day = DevoteDay, devote_sum = DevoteSum,
										   logout_time = LogoutTime, join_time = JoinTime},
					ets:insert(?ETS_CLAN_MEMBER, ClanMember),
					ClanMember;
				_ ->
					?null
			end
	end.
%%　玩家是否有帮派
have_clan(Uid,Clan) ->
	#clan{clan_id=ClanId0,clan_name=ClanName0}=Clan,
	case get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId} ->
			case get_clan4id(ClanId) of
				#clan_public{clan_id=ClanId,clan_name=ClanName} ->
					if ClanId0=:=ClanId andalso ClanName0=:=ClanName ->
						   ?true;
					   ?true ->
						   ?false
					end;
				_ ->
					?false
			end;
		_ ->
			?false
	end.
					
					
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 定时计划 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 查找所有的帮派信息， 刷新帮派排名
get_allclan() ->
	case ets:tab2list(?ETS_CLAN_PUBLIC) of
		[#clan_public{}|_]=AllClan ->
			AllClan2=ref_clan_rank(AllClan),
			data2bin_rankpage(AllClan2),
			ets:insert(?ETS_CLAN_PUBLIC, AllClan2),
			AllClan2;
		_ ->
			Sql = "SELECT `clan_id`,`clan_rank`,`clan_name`,`clan_lv`,`devote`,`up_devote`,`max_member`,`master_id`,`master_name`,`master_color`,`master_Lv`,`master_list`,`notice`,`member`,`seconds` FROM `clan_public`;",
			case mysql_api:select(Sql) of
				{?ok, Datas} ->
					Fun = fun([ClanId,ClanRank,ClanName,ClanLv,Devote,UpDevote,Max,Mid,Mname,Mcolor,MLv,MList,Notice,Member,Seconds], Acc) ->
								  Clan = #clan_public{clan_id=ClanId,clan_name=ClanName,clan_lv=ClanLv,devote=Devote,up_devote=UpDevote,max_member=Max, 
													  master_id = Mid, master_name = Mname,master_name_color=Mcolor,master_lv=MLv,notice = Notice,
													  member = mysql_api:decode(Member), seconds = Seconds,clan_rank=ClanRank,
													  master_list= mysql_api:decode(MList)},
								  [Clan|Acc]
						  end,
					AllClan = lists:foldl(Fun, [], Datas),
					AllClan2=ref_clan_rank(AllClan),
					data2bin_rankpage(AllClan2),
					ets:insert(?ETS_CLAN_PUBLIC, AllClan2),
					AllClan2;
				_ ->
					[]
			end
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 以上定时计划 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 刷新帮派排名
ref_clan_rank(AllClan) ->
	AllClan2=lists:keysort(#clan_public.devote, AllClan),
	AllClan3=lists:reverse(AllClan2),
	ref_rank_acc(AllClan3,[],1).

ref_rank_acc([],Acc,_Rank) -> Acc;
ref_rank_acc([H|AllClan],Acc,Rank) ->
	Acc2=[H#clan_public{clan_rank=Rank}|Acc],
	ref_rank_acc(AllClan,Acc2,Rank+1).
%% 刷新帮派排名页码	
data2bin_rankpage(AllClan) ->
%% 	AllClan2 = lists:reverse(AllClan),
%% 	AllPages = util:ceil(length(AllClan2)/?CONST_CLAN_RANK_COUNT),
%% 	F=fun(P,Acc) ->
%% 			  ClandataMsg=[{ClanId,ClanName,ClanLv,ClanRank,erlang:length(ClanMembers),ClanAllMembers} ||
%% 						   #clan_public{clan_id=ClanId,clan_lv=ClanLv,clan_rank=ClanRank,
%% 										clan_name=ClanName,member=ClanMembers,max_member=ClanAllMembers} 
%% 										   <- lists:sublist(AllClan2, (P-1)*?CONST_CLAN_RANK_COUNT+1, ?CONST_CLAN_RANK_COUNT)],
%% 			  Bin = clan_api:msg_ok_clanlist(P, AllPages, ClandataMsg),
%% 			  [{P,Bin}|Acc]
%% 	  end, 
%% 	ClanListPage=lists:foldl(F,[], lists:seq(1, AllPages)),
%% 	ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_CLANLIST_PAGE, ClanListPage}).
	AllClan2 = lists:reverse(AllClan),
	ClandataMsg=[{ClanId,ClanName,ClanLv,ClanRank,erlang:length(ClanMembers),ClanAllMembers} ||
						   #clan_public{clan_id=ClanId,clan_lv=ClanLv,clan_rank=ClanRank,
										clan_name=ClanName,member=ClanMembers,max_member=ClanAllMembers} 
										   <- AllClan2],
	Bin = clan_api:msg_ok_clanlist(1, 1, ClandataMsg),
	ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_CLANLIST_PAGE, [{1,Bin}]}).

%% 查找所有的帮派成员信息
get_clan_memlists(Uids) ->
	Now=util:date(),
	F=fun(U,Acc) -> 
			  case ets:lookup(?ETS_CLAN_MEMBER, U) of
				  [#clan_mem{time=Time}=ClanMem] ->
					  if Time==Now ->
							 [ClanMem|Acc];
						 ?true ->
							 ClanMem2=ClanMem#clan_mem{time=Now,devote_day=0},
							 ets:insert(?ETS_CLAN_MEMBER, ClanMem2),
							 [ClanMem2|Acc]
					  end;
				  _ ->
					  Acc
			  end
	  end, 
	MembList=lists:foldl(F,[], Uids),
	lists:keysort(#clan_mem.post, MembList).
	

%% 取帮派技能属性加成	及 下一级技能属性加成				
%% {NewTLv,NewAttr,NewAddValue,NewCast};
get_attr(Type,Value0,Attr,TLv) when erlang:is_record(Attr, attr) ->
	case Type of
		?CONST_ATTR_STRONG_ATT ->
			NewAttr=Attr#attr{strong_att=Value0},
			{NewTLv,UpValue,Cast}=get_clanskill_lv(#d_clan_skill.strong_att,TLv),
			{NewTLv,NewAttr,UpValue-Value0,Cast};
		?CONST_ATTR_STRONG_DEF ->
			NewAttr=Attr#attr{strong_def=Value0},
			{NewTLv,UpValue,Cast}=get_clanskill_lv(#d_clan_skill.strong_def,TLv),
			{NewTLv,NewAttr,UpValue-Value0,Cast};
		?CONST_ATTR_SKILL_ATT ->
			NewAttr=Attr#attr{skill_att=Value0},
			{NewTLv,UpValue,Cast}=get_clanskill_lv(#d_clan_skill.skill_att,TLv),
			{NewTLv,NewAttr,UpValue-Value0,Cast};
		?CONST_ATTR_SKILL_DEF ->
			NewAttr=Attr#attr{skill_def=Value0},
			{NewTLv,UpValue,Cast}=get_clanskill_lv(#d_clan_skill.skill_def,TLv),
			{NewTLv,NewAttr,UpValue-Value0,Cast};
		_ ->
			{?error,?ERROR_CHECK_SUM}
	end;
get_attr(Type,AddValue,_Attr,TLv) ->
	Attr = #attr{strong_att=0,strong_def=0,skill_att=0,skill_def=0},
	get_attr(Type,AddValue,Attr,TLv).

get_clanskill_lv(Pos,TLv) ->
	case data_clan_skill:get(TLv+2) of
		#d_clan_skill{cast=Cast}=DGet ->
			{TLv+1,erlang:element(Pos, DGet),Cast};
		_ ->
			{TLv,0,0}
	end.

%% 取帮派技能列表
get_clan_skill(Clan) ->
%% 	#attr{skill_att=SkiAtt0,skill_def=SkiDef0,strong_att=StrAtt0,strong_def=StrDef0}=Attr,
	case Clan#clan.clan_skill of 
		[{_,_,_,_,_}|_]=ClanSkill ->
			ClanSkill;
		_ ->
			DSkill=data_clan_skill:get(1),
			#d_clan_skill{skill_att=SkiAtt,skill_def=SkiDef,strong_def=StrDef,strong_att=StrAtt,cast=Cast}=DSkill,
			ClanSkill = [{?CONST_ATTR_STRONG_ATT,0,0,StrAtt,Cast},{?CONST_ATTR_STRONG_DEF,0,0,StrDef,Cast},
						 {?CONST_ATTR_SKILL_ATT,0,0,SkiAtt,Cast},{?CONST_ATTR_SKILL_DEF,0,0,SkiDef,Cast}],
			role_api_dict:clan_set(Clan#clan{clan_skill=ClanSkill}),
			ClanSkill
	end.

join_attr(Player) ->
	Clan=role_api_dict:clan_get(),
	ClanSkill = clan_mod:get_clan_skill(Clan),
	ClanSkill2 = lists:keysort(1, ClanSkill),
	[{?CONST_ATTR_STRONG_ATT,_StLv,StrAtt0,_StrAtt,_Cast},{?CONST_ATTR_STRONG_DEF,_StdLv,StrDef0,_StrDef,_Cast},
	 {?CONST_ATTR_SKILL_ATT,_SSlv,SkiAtt0,_SkiAtt,_Cast},{?CONST_ATTR_SKILL_DEF,_SSdLv,SkiDef0,_SkiDef,_Cast}]=ClanSkill2,
	AttrGro=role_api_dict:attr_group_get(),
	SkillAttr = case AttrGro#attr_group.clan of
					#attr{}=CAttr ->
						CAttr;
					_ ->
						#attr{strong_att=StrAtt0,strong_def=StrDef0,skill_att=SkiAtt0,skill_def=SkiDef0}
				end,
	role_api_dict:attr_group_set(AttrGro#attr_group{clan=SkillAttr}),
	role_api:attr_update_player(Player, clan, SkillAttr).
	
