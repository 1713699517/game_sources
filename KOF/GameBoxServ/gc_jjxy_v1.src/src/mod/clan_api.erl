%% Author: tanwer
%% Created: 2013-06-26
%% Description: TODO: Add description to clan_api
-module(clan_api).

%%
%% Include files
%%
-include("../include/comm.hrl"). 

%%
%% Exported Functions
%% 
-export([init/0,msg_logs_msg_group/4,getout_clan/7,ask_apply_clan/3]).

-export([decode_clan/1,
		 encode_clan/1,
		 
		 ref_clan_rank/0,
		 init_clan/1,
		 login/1,
		 logout/1,
		 %% 内部调用接口
		 clan_id_name/1,
		 clan_name_get/1,
		 clan_id_get/1,
		 clan_lv_get/1,
		 clan_member_uid/1,
		 devote_add/3,
		 devote_cut/3,
		 check_same_clan/2,
		 ref_clan_master_lv/2,
		 
		 %%　基本面板功能实现
		 request_clan/2,
		 request_clan_list/1,
		 rebuild_clan/2,
		 clan_list/1,
		 reset_cast/2,
		 set_post/3,
		 ask_out_clan/2,
		 ask_clan_skill/1,
		 ask_study_skill/2,
		 
		 devote_add_handl/4,

		 %%　帮派基础功能消息
		 msg_ok_clan_data/6,
		 msg_ok_other_data/9,
		 msg_clan_logs/1,
		 msg_logs_msg/4,
		 msg_ok_clanlist/3,
		 msg_applied_clanlist/2,
		 msg_member_msg/9,
		 msg_ok_audit/2,
		 msg_ok_join_list/1,
		 msg_ok_member_list/1,
		 msg_ok_rebuild_clan/0,
		 msg_ok_reset_cast/0,
		 msg_user_data/6,
		 msg_ok_join_clan/2,
		 msg_ok_out_clan/0,
		 msg_clan_attr_data/5,
		 msg_ok_clan_skill/2,
		 msg_now_stamina/1
		 ]).


encode_clan(Clan) ->
	Clan.

decode_clan(Clan) ->
	?IF(is_record(Clan,clan),Clan,init()).

init() ->
	#clan{}.

init_clan(Player) ->
	Clan=
		case role_api_dict:clan_get() of
			C when is_record(C, clan) ->
				C;
			_ ->
				init()
		end,
	{Player,Clan}. 

%%　定时刷新帮派排行榜
ref_clan_rank() ->
	clan_mod:get_allclan().

%% 刷新帮主信息
ref_clan_master_lv(Uid,Lv) ->
	case clan_mod:is_master(Uid) of
		{?true, #clan_public{master_id=Uid}=ClanPub}->
			clan_mod:insert_new_clan(ClanPub#clan_public{master_lv=Lv}),
			clan_mod:get_allclan();
		_ ->
			ok
	end.
	

%% 登陆检查
login(#player{uid=Uid,uname=Name,uname_color=NameColor,lv=Lv}) ->
	Now = util:date(),
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{time=Time,clan_id=ClanId}=ClanMember ->
			if Now=:=Time ->
				   ClanMember2=ClanMember#clan_mem{logout_time=1,lv=Lv,name=Name,name_color=NameColor};
			   ?true ->
				   ClanMember2=ClanMember#clan_mem{logout_time=1,lv=Lv,name=Name,name_color=NameColor,devote_day=0,time=Now}
			end,
			clan_mod:insert_new_member(ClanMember2),
			case role_api_dict:clan_get() of
				#clan{clan_id=ClanId} ->
					ok;
				#clan{clan_skill=ClanSkill} ->
					role_api_dict:clan_set(#clan{clan_skill=ClanSkill,clan_id=ClanId});
				_ ->
					role_api_dict:clan_set(#clan{clan_id=ClanId})
			end;
		_ -> 
			?ok
	end.

%% 退出更新
logout(#player{uid=Uid,uname=Name,uname_color=NameColor,lv=Lv}) ->
	Now = util:seconds(),
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{}=ClanMember ->
			ClanMember2=ClanMember#clan_mem{logout_time=Now,lv=Lv,name=Name,name_color=NameColor},
			clan_mod:insert_new_member(ClanMember2);
		_ -> 
			?ok
	end.

%%------------------------------------------------------------------------------------------- 内部调用

%%判断两个玩家是否在同一个帮派
%% reg: ?true | ?false
check_same_clan(Uid1,Uid2) ->
	case ets:lookup(?ETS_CLAN_MEMBER, Uid1) of
		[#clan_mem{clan_id=ClanId1}|_] ->
			case ets:lookup(?ETS_CLAN_MEMBER, Uid2) of
				[#clan_mem{clan_id=ClanId1}|_] ->
					?true;
				_ ->
					?false
			end;
		_ -> 
			?false
	end.

%% 帮派成员UID
%% reg： UidList :: [Uid|_]
clan_member_uid(Uid) ->
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId} ->
			case ets:lookup(?ETS_CLAN_PUBLIC, ClanId) of
				[#clan_public{member=Member}|_] ->
					Member;
				_ ->
					[]
			end;
		_ ->
			[]
	end.

%% 取帮派名字,ID
clan_id_name(Uid) ->
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId} ->
			case clan_mod:get_clan4id(ClanId) of
				#clan_public{clan_name=ClanName} ->
					{ClanId,ClanName};
				_ ->
					{0, <<>>}
			end;
		_ ->
			{0, <<>>}
	end.


%% 取帮派名字	
%%　return : <<>> | Name
clan_name_get(Uid) ->
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId} ->
			case clan_mod:get_clan4id(ClanId) of
				#clan_public{clan_name=ClanName} ->
					ClanName;
				_ ->
					<<>>
			end;
		_ ->
			<<>>
	end.

%% 取玩家帮派ID
%%　reg: ClanId | 0
clan_id_get(Uid) ->
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId} ->
			ClanId;
		_ ->
			0
	end.

%% 取玩家帮派等级
%%　reg: ClanLv | 0
clan_lv_get(Uid) ->
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId} ->
			case clan_mod:get_clan4id(ClanId) of
				#clan_public{clan_lv=ClanLv} ->
					ClanLv;
				_ ->
					0
			end;
		_ ->
			0
	end.


%% 增加帮贡接口
%%　?ok
devote_add(LogSrc,Uid, Value) ->
	Clan=role_api_dict:clan_get(), 
	clan_srv:devote_add_cast(LogSrc, Uid, Clan, Value).
	
%% 增加帮贡接口
%%　?ok
devote_add_handl(LogSrc, Uid, #clan{clan_id=ClanId}=Clan,Value) ->
	Date=util:date(),
	case clan_mod:get_clan4id(ClanId) of
		#clan_public{devote=Devote}=ClanPub ->
			{NewLv,DevoteUp,MemberMax,_ExpPlus,_GoldPlus}=clan_mod:clan_groudup(Devote+Value),
			ClanPub2=ClanPub#clan_public{clan_lv=NewLv,max_member=MemberMax,up_devote=DevoteUp,devote=Devote+Value},
			clan_mod:insert_new_clan(ClanPub2),
			case clan_mod:get_clan_mem(Uid) of
				#clan_mem{devote_day=DevoteDay,devote_sum=DevoteSum,time=Time}=ClanMem ->
					ClanMem2=
						if Time==Date ->
							   ClanMem#clan_mem{devote_day=DevoteDay+Value,devote_sum=DevoteSum+Value};
						   ?true ->
							   ClanMem#clan_mem{devote_day=Value,devote_sum=DevoteSum+Value,time=Date}
						end,
					[Method,UseValue,Remark] = LogSrc,
					stat_api:logs_devote(Uid, ClanId, Method, UseValue, ClanMem2#clan_mem.devote_sum-Clan#clan.stamina, Remark),
					clan_mod:insert_new_member(ClanMem2),
					?ok;
				_ ->
					?ok
			end;
		_ ->
			?ok
	end.

%% 消耗帮派贡献
devote_cut(LogSrc, #player{uid=Uid}=Player, Value) ->
	Clan=role_api_dict:clan_get(), 
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{devote_sum=DevoteSum,clan_id=ClanId} ->
			case Clan#clan.stamina + Value of
				Stamina2 when Stamina2 > DevoteSum ->
					{?error,?ERROR_CLAN_NO_STAMINA};
				Stamina2 ->
					[Method,UseValue,Remark] = LogSrc,
					stat_api:logs_devote(Uid, ClanId, Method, -UseValue, DevoteSum-Stamina2, Remark),
					Clan2=Clan#clan{stamina=Stamina2},
					role_api_dict:clan_set(Clan2),
					BinMsg=msg_now_stamina(DevoteSum-Stamina2),
					{?ok,Player,BinMsg}
			end;
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end.

	
%%------------------------------------------------------------------------------------------------------ 内部调用
	
%% 帮派面板 【0自己|| Id 其他帮派】
%%　return: {?error,ErrorCode} ||　?ok
request_clan(Uid,ClanId) ->
	case ClanId of
		0 -> 
			clan_mod:request_self_clan(Uid);
		_ ->
			clan_mod:request_other_clan(ClanId)
	end.

%% 创建帮派
%%　return: {?error,ErrorCode} ||　{?ok,Player2,BinMsg}
rebuild_clan(#player{uid=Uid,lv=Lv,uname=Name,uname_color=NameColor,pro=Pro,spid=Spid}=Player,ClanName) ->
	if Lv >= ?CONST_CLAN_LV_LIMIT ->
		   Clan=role_api_dict:clan_get(),
		   case Clan#clan.clan_id of
			   0 ->
				   case clan_mod:chack_outclan_time(Clan#clan.outtime) of
					   ?true ->
						   case idx_api:clan_id() of
							   ClanId when is_integer(ClanId) ->
								    % ets:fun2ms(fun(R) when R#clan_public.clan_name == ClanName -> R#clan_public.master_name end),
								   MS= [{'$1',[{'==',{element,4,'$1'},{const,ClanName}}],[{element,9,'$1'}]}],
								   case ets:select(?ETS_CLAN_PUBLIC, MS) of
									   [] -> 
										   LogSrc = [rebuild_clan, [], <<"创建帮派">>],
										   case role_api:currency_cut(LogSrc, Player, [{?CONST_CURRENCY_GOLD, ?CONST_CLAN_CREATE_COST*10000}]) of
											   {?ok, Player2, Bin} -> 
												   ClanRank = ets:info(?ETS_CLAN_PUBLIC, size) + 1,
												   Now=util:seconds(),
												   {_NewLv,ClanUpContribute,ClanAllMembers,_ExpAdd,_GlodAdd}=clan_mod:clan_groudup(0),
												   ClanPub= #clan_public{clan_id=ClanId,clan_lv=1,clan_name=ClanName,devote=0,
																		 master_id=Uid,master_lv=Lv,master_name=Name,master_name_color=NameColor,
																		 max_member=ClanAllMembers,member= [Uid], notice= <<>> ,logs=[],
																		 up_devote=ClanUpContribute,clan_rank=ClanRank,seconds=Now},
												   ClanMem= #clan_mem{clan_id=ClanId,devote_day=0,devote_sum=0,join_time=Now,
																	  logout_time=1,por=Pro,lv=Lv,name=Name,name_color=NameColor,
																	  post=?CONST_CLAN_POST_MASTER,uid=Uid},
												   clan_mod:insert_new_clan(ClanPub),
												   clan_mod:insert_new_member(ClanMem),
												   role_api_dict:clan_set(Clan#clan{clan_id=ClanId,clan_name=ClanName,outtime=0,ask_clanlist=[]}),
												   task_api:check_cast(Uid,?CONST_TASK_TARGET_OTHER, ClanId),
												   BinMsg = msg_ok_rebuild_clan(),
												   BinRole=role_api:clan_u(0, ClanId, ClanName),
												   scene_api:change_clan(Spid,Uid, ClanId, ClanName),
												   {?ok,Player2,<<Bin/binary,BinMsg/binary,BinRole/binary>>};
											   {?error, ErrorCode} ->
												   {?error, ErrorCode}
										   end;
									   _ ->
										   {?error, ?ERROR_CLAN_NAME_EXIST}
								   end;
							   _ ->
								   {?error, ?ERROR_CLAN_FULL_CLAN}
						   end;
					   _ ->
						   {?error, ?ERROR_CLAN_OUTTIME_MIN}
				   end;
			   _ ->
				   {?error, ?ERROR_CLAN_EXIST}
		   end;
	   ?true ->
		   {?error, ?ERROR_LV_LACK}
	end.

%% 帮派列表
%%　return: {?error,ErrorCode} ||　{?ok,BinMsg}
request_clan_list(Page) ->
	case db_api:get_data2ets(?CONST_PUBLIC_KEY_CLANLIST_PAGE, [Page]) of
		[BinPage] when is_binary(BinPage) ->
			{?ok,BinPage};
		_ ->
			case clan_mod:get_allclan() of
				[] ->
					BinPage = msg_ok_clanlist(0, 0, []),
					{?ok,BinPage};
				_ ->
					request_clan_list(Page)
			end
	end.

%% 申请加入帮派
ask_apply_clan(#player{lv=Lv,uid=Uid}=Player, ClanId, 1) ->
	if Lv >= ?CONST_CLAN_LV_LIMIT ->  
		   case clan_mod:get_clan_mem(Uid) of
			   #clan_mem{} ->
				   {?error,?ERROR_CLAN_EXIST};
			   _ ->
				   Now = util:seconds(),
				   Clan=role_api_dict:clan_get(),
				   case clan_mod:chack_outclan_time(Clan#clan.outtime) of
					   ?true ->
						   ClanList=lists:foldl(fun({TIME,ID},Acc) -> 
														?IF(Now-TIME >= 24*60*60, Acc,[{TIME,ID}|Acc]) 
												end, [], Clan#clan.ask_clanlist),
						   if erlang:length(ClanList) < ?CONST_CLAN_JOIN_MAX_CALL ->
								  case lists:keyfind(ClanId, 2, ClanList) of
									  ?false ->
										  clan_srv:join_clan_cast(Player,ClanId);
									  _ ->
										  {?error,?ERROR_CLAN_APPLY_ALREADY}
								  end;
							  ?true ->
								  {?error,?ERROR_CLAN_APPLY_FULL}
						   end;
					   _ ->
						   {?error,?ERROR_CLAN_OUTTIME_MIN}
				   end
		   end;
	   ?true ->
		   {?error,?ERROR_LV_LACK}
	end;
%% 取消 加入帮派
ask_apply_clan(#player{uid=Uid}, ClanId, 0) ->
	Clan=role_api_dict:clan_get(),
	case lists:keytake(ClanId, 2, Clan#clan.ask_clanlist) of
		{value, _, AskClanList2} ->
			role_api_dict:clan_set(Clan#clan{ask_clanlist=AskClanList2}),
			clan_srv:cancel_clan_cast(Uid,ClanId);
		_ ->
			{?error,?ERROR_CLAN_APPLY_ALREADY}
	end;
ask_apply_clan(_Player, _ClanId, Err) ->
	?MSG_ERROR("bad_arg_err : ~w~n",[Err]),
	{?error,?ERROR_BADARG}.


%% 入帮申请列表
%%　return: {?error,ErrorCode} ||　{?ok,BinMsg}
clan_list(Uid) ->
	case clan_mod:is_master(Uid) of
		{?true,#clan_public{apply_list=ApplyList}} ->
			{?ok,msg_ok_join_list(ApplyList)};
		_ ->
			{?error,?ERROR_CLAN_NOT_OFFICIAL}
	end.


					
%% 修改帮派公告		
%%　return: {?error,ErrorCode} ||　{?ok,BinMsg}						
reset_cast(Uid,String) ->
	if size(String) =< ?CONST_CLAN_NOTICE_MAX*3 ->
		   case clan_mod:is_master(Uid) of
			   {?true,ClanPub} ->
				   clan_mod:insert_new_clan(ClanPub#clan_public{notice=String}),
				   BinMsg=msg_ok_reset_cast(),
				   {?ok,BinMsg};
			   _ ->
				   {?error,?ERROR_CLAN_NOT_OFFICIAL}
		   end;
	   ?true ->
		   {?error,?ERROR_CLAN_NOTICE_LENGTH}
	end.
									
			
%% 设置成员职位		
%%　return: {?error,ErrorCode} ||　{?ok,BinMsg}	
set_post(#player{lv=Lv,uname_color=NameColor,uname=Name,uid=Uid},ToUid,Post) ->
	Time=util:seconds(),
	case clan_mod:is_master(Uid) of
		{?true, ClanPub} ->
		#clan_public{master_id=MasterUid,master_name=Mname,master_name_color=MColor,clan_name=ClanName,
					  master_list=MasterList,logs=Logs,clan_id=ClanId,member=Member}=ClanPub,
			case lists:member(ToUid, Member) of
				?true -> 
					ToMember=clan_mod:get_clan_mem(ToUid),
					#clan_mem{name=ToName,name_color=ToColor,devote_sum=DelDevote,lv=ToLv}=ToMember,
					if MasterUid =:= Uid andalso Uid=/=ToUid ->
						   case Post of
							   ?CONST_CLAN_POST_MASTER -> %转让帮主
								   MMember2= 
									   case clan_mod:get_clan_mem(Uid) of
										   #clan_mem{}=MMember ->
											   MMember#clan_mem{post=?CONST_CLAN_POST_COMMON,lv=Lv,name_color=NameColor};
										   _ ->
											   #clan_mem{clan_id=ClanId,uid=Uid,post=?CONST_CLAN_POST_COMMON,
														 lv=Lv,name_color=NameColor,name=Name}
									   end,
								   NewLog= {?CONST_CLAN_EVENT_TRANS, Time, [{Mname,MColor},{ToName,ToColor}], []},
								   ClanPub2=ClanPub#clan_public{master_id=ToUid,master_list=[U||U <- MasterList,U=/=ToUid],
																master_name=ToName,master_name_color=ToColor,master_lv=ToLv},
								   NewMemberList= [ToMember#clan_mem{post=Post},MMember2],
								   clan_mod:set_post_acc(ClanPub2,NewLog,Logs,NewMemberList),
								   stat_api:logs_wang(ClanId,ClanName,Uid,ToUid,set_post),
								   clan_mod:get_allclan(),
%% 								   logs_api:action_notice(ToUid, ?CONST_LOGS_8005,[{Mname,MColor},{ToName,ToColor}],[]),
								   ?ok;
							   ?CONST_CLAN_POST_SECOND -> %提升副帮主
								   case lists:member(ToUid, MasterList) of
									   ?true ->
										   {?error,?ERROR_CLAN_APPLY_ALREADY};
									   _ -> 
										   if length(MasterList) >= ?CONST_CLAN_COUNT_SECOND ->
												  {?error,?ERROR_CLAN_POST_FULL};
											  ?true -> 
												  NewLog= {?CONST_CLAN_EVENT_POST_UP, Time, [{ToName,ToColor}], []},
												  ClanPub2=ClanPub#clan_public{master_list=[ToUid|MasterList]},
												  clan_mod:set_post_acc(ClanPub2,NewLog,Logs,[ToMember#clan_mem{post=Post}]),
												  ?ok
										   end
								   end;
							   ?CONST_CLAN_POST_COMMON -> % 降职为平民 
								   case lists:member(ToUid, MasterList) of
									   ?true ->
										   NewLog= {?CONST_CLAN_EVENT_POST_DOWN, Time, [{ToName,ToColor},{Name,NameColor}], []},
										   ClanPub2=ClanPub#clan_public{master_list=[U||U <- MasterList,U=/=ToUid]},
										   clan_mod:set_post_acc(ClanPub2,NewLog,Logs,[ToMember#clan_mem{post=Post}]),
										   ?ok;
									   _ -> 
										   {?error,?ERROR_CLAN_EXIST}
								   end;
							   ?CONST_CLAN_POST_OUT -> % 踢出帮派
								   getout_clan({NameColor,Name},{ToUid,ToName,ToColor},Time,Post,ToMember,ClanPub,DelDevote),
								   clan_mod:get_allclan(),
								   ?ok;
							   Err -> 
								   ?MSG_ERROR("---bad_arg:: ~w~n",[Err]),
								   {?error,?ERROR_CHECK_SUM}
						   end;
					   ?true -> 
						   Bool = lists:member(ToUid, [MasterUid|MasterList]),
						   if  Bool == ?false ->
								  if  Post== ?CONST_CLAN_POST_OUT -> % 踢出帮派 
										  getout_clan({NameColor,Name},{ToUid,ToName,ToColor},Time,Post,ToMember,ClanPub,DelDevote),
										  clan_mod:get_allclan(),
										  ?ok;
									  ?true -> 
										  {?error,?ERROR_CLAN_NOT_POWER}
								  end;
							  ?true -> 
								  {?error,?ERROR_CLAN_NOT_POWER}
						   end
					end;
				_ -> 
					{?error,?ERROR_CLAN_NOT_EXIST}
			end;
		_ ->
			{?error,?ERROR_CLAN_NOT_POWER}
	end.

			
% 踢出帮派 			
getout_clan({NameColor,Name},{ToUid,ToName,ToColor},Time,Post,ToMember,ClanPub,DelDevote) ->
	#clan_public{master_list=MasterList,logs=Logs,clan_id=ClanId,member=Member}=ClanPub,
	NewLog= {?CONST_CLAN_EVENT_KICK, Time, [{ToName,ToColor},{Name,NameColor}], []},
	ClanPub2=
		case lists:member(ToUid, MasterList) of 
			?true ->
				ClanPub#clan_public{master_list=[MU||MU <- MasterList,MU=/=ToUid],member=[U||U <- Member,U=/=ToUid]};
			_ ->
				ClanPub#clan_public{member=[U||U <- Member,U=/=ToUid]}
		end,
	clan_mod:set_out_clan(ClanPub2,NewLog,ToUid).

	
%% 请求退出帮派
%%　return: {?error,ErrorCode} ||　?ok
ask_out_clan({Uid,Name,NameColor}, _Type) ->
	Clan=role_api_dict:clan_get(),
	case clan_mod:get_clan4id(Clan#clan.clan_id) of
		#clan_public{clan_id=ClanId,master_id=MasterUid,master_list=MasterList,member=Member,devote=Devote}=ClanPublic ->
			case clan_mod:get_clan_mem(Uid) of
				#clan_mem{devote_sum=DelDevotte}=ClanMember ->
					if Uid=:=MasterUid ->
						   Member2=[U || U <- Member,U=/=Uid],
						   if Member2 =/= [] ->
								  MasterList2=[Mu||Mu <- MasterList,Mu=/=Uid],
								  OtherMems=?IF(MasterList2 =/= [],MasterList2,Member2),
								  OtherMemData=clan_mod:get_clan_memlists(OtherMems),
								  OtherMemData2=lists:keysort(#clan_mem.devote_sum, OtherMemData),
								  MemberNewMaster = lists:last(OtherMemData2),
								  #clan_mem{name=OneName,name_color=OneColor,uid=OneUid,lv=OneLv} = MemberNewMaster,
								  NewLog= {?CONST_CLAN_EVENT_OUT,util:seconds(),[{Name,NameColor}],[]},
								  NewClanPub=ClanPublic#clan_public{master_id=OneUid,master_lv=OneLv,
																	master_name=OneName,master_name_color=OneColor,
																	master_list=MasterList2,member=Member2},
								  clan_mod:insert_new_member(MemberNewMaster#clan_mem{post=?CONST_CLAN_POST_MASTER}),
								  clan_mod:out_clan(NewClanPub, NewLog, Uid);
							  ?true ->
								  SQL2	= <<"DELETE FROM `clan_public` WHERE `clan_public`.`clan_id` = ",
											(util:to_binary(ClanId))/binary," LIMIT 1 ;">>,
								  mysql_api:fetch_cast(SQL2),
								  ets:delete(?ETS_CLAN_PUBLIC, ClanId),
								  clan_mod:delete_member(Uid)
						   end;
					   ?true ->
						   NewLog= {?CONST_CLAN_EVENT_OUT,util:seconds(),[{Name,NameColor}],[]},
						   NewClanPub=ClanPublic#clan_public{master_list= [MastU||MastU <- MasterList,MastU=/= Uid],
															 member=[MemU || MemU <- Member, MemU=/= Uid]},
						   clan_mod:out_clan(NewClanPub, NewLog, Uid)
					end,
					role_api_dict:clan_set(#clan{outtime=util:seconds(),clan_skill=Clan#clan.clan_skill});
				_ ->
					{?error,?ERROR_CLAN_NOT_POWER}
			end;
		_ ->
			{?error,?ERROR_CLAN_NO_EXIT}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  帮派技能-----
%% 请求帮派技能面板
%%　return: {?error,ErrorCode} ||　{?ok,BinMsg}	
ask_clan_skill(Uid) ->
	Clan=role_api_dict:clan_get(),
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{devote_sum=Devote} ->
			ClanSkill=clan_mod:get_clan_skill(Clan),
			BinMsg=msg_ok_clan_skill(Devote - Clan#clan.stamina, ClanSkill),
			{?ok,BinMsg};
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end.

%% 请求学习帮派技能
%%　return: {?error,ErrorCode} ||　{?ok,Player2,BinMsg}	
ask_study_skill(#player{uid=Uid}=Player,Type) ->
	Clan=role_api_dict:clan_get(),
	case Clan#clan.clan_id of
		ClanId when ClanId=/= 0 ->
			case clan_mod:get_clan_mem(Uid) of
				#clan_mem{clan_id=ClanId,devote_sum=DevoteSum} ->
					ClanSkill=clan_mod:get_clan_skill(Clan),
					case lists:keytake(Type, 1, ClanSkill) of
						{value, {Type,TLv,Value,AddValue,Cast}, TupleList2} ->
							case Clan#clan.stamina + Cast of
								Stamina2 when Stamina2 =< DevoteSum ->
									AttrGro=role_api_dict:attr_group_get(),
									NewValue = Value+AddValue,
									case clan_mod:get_attr(Type,NewValue,AttrGro#attr_group.clan, TLv)of
										{NewTLv,NewAttr,NewAddValue,NewCast} ->
											Player2=role_api:attr_update_player(Player, clan, NewAttr),
											ClanSkill2=[{Type,NewTLv,NewValue,NewAddValue,NewCast}|TupleList2],
											Clan2=Clan#clan{stamina=Stamina2,clan_skill=ClanSkill2},
											role_api_dict:clan_set(Clan2),
											BinMsg1=msg_now_stamina(DevoteSum-Stamina2),
											BinMsg2=msg_clan_attr_data(Type, NewTLv, NewValue, NewAddValue, NewCast),
											stat_api:logs_devote(Uid, ClanId, ask_study_skill, -Cast, DevoteSum-Stamina2, <<"学习帮派技能">>),
											stat_api:logs_clan_skill(Uid, ClanId, ask_study_skill, Type),
											{?ok,Player2,<<BinMsg1/binary,BinMsg2/binary>>};
										{?error,ErrorCode} ->
											{?error,ErrorCode}
									end;
								_ ->
									{?error,?ERROR_CLAN_NO_STAMINA}
							end;
						_ ->
							{?error,?ERROR_CHECK_SUM}
					end;
				_ ->
					Clan2 = #clan{clan_skill=Clan#clan.clan_skill},
					role_api_dict:clan_set(Clan2),
					{?error,?ERROR_CLAN_NULL1}
			end;
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%_________________msg____________________
% 返加帮派基础数据1 [33020]
msg_ok_clan_data(ClanId,ClanName,ClanLv,
				 ClanRank,ClanMembers,ClanAllMembers)->
    RsList = app_msg:encode([{?int32u,ClanId},
        {?string,ClanName},{?int8u,ClanLv},
        {?int16u,ClanRank},{?int16u,ClanMembers},
        {?int16u,ClanAllMembers}]),
    app_msg:msg(?P_CLAN_OK_CLAN_DATA, RsList).


% 返加帮派基础数据2 [33023]
msg_ok_other_data(MasterUid,MasterName,MasterNameColor,
				  MasterLv,MemberContribute,MemberPower,ClanAllContribute,
				  ClanContribute,ClanBroadcast)->
	RsList = app_msg:encode([{?int32u,MasterUid},
							 {?string,MasterName},{?int8u,MasterNameColor},
							 {?int16u,MasterLv},{?int32u,MemberContribute},
							 {?int8u,MemberPower},{?int32u,ClanAllContribute},
							 {?int32u,ClanContribute},{?stringl,ClanBroadcast}]),
	app_msg:msg(?P_CLAN_OK_OTHER_DATA, RsList).


% 返加帮派日志数据3 [33025]
msg_clan_logs(LogsData)->
	Rs = app_msg:encode([{?int16u,length(LogsData)}]),
	RsList = lists:foldl(fun({Type,Time,StringMsg,IntMsg},Acc) -> 
								 Bin=msg_logs_msg_group(Type,Time,StringMsg,IntMsg),
								 <<Acc/binary,Bin/binary>>
						 end, Rs, LogsData),
	app_msg:msg(?P_CLAN_CLAN_LOGS, RsList).

msg_logs_msg_group(Type,Time,StringMsg,IntMsg)->
	F=fun({Name,NameColor},Acc) -> 
			  Bin = app_msg:encode([{?string,Name},{?int8u,NameColor}]),
			  <<Acc/binary,Bin/binary>>;
		 (Value,Acc) ->
			  Bin = app_msg:encode([{?int32u,Value}]),
			  <<Acc/binary,Bin/binary>>
	  end,
	Rs1 = app_msg:encode([{?int8u,Type},{?int32u,Time},{?int16u,length(StringMsg)}]),
	Rs2 = app_msg:encode([{?int16u,length(IntMsg)}]),
	RsList1 = lists:foldl(F, Rs1, StringMsg),
	RsList2 = lists:foldl(F, Rs2, IntMsg),
	<<RsList1/binary,RsList2/binary>>.


% 帮派日志数据块 [33026]
msg_logs_msg(Type,Time,StringMsg,IntMsg)->
	F=fun({Name,NameColor},Acc) -> 
			  Bin = app_msg:encode([{?string,Name},{?int8u,NameColor}]),
			  <<Acc/binary,Bin/binary>>;
		 (Value,Acc) ->
			  Bin = app_msg:encode([{?int32u,Value}]),
			  <<Acc/binary,Bin/binary>>
	  end,
	Rs1 = app_msg:encode([{?int8u,Type}, {?int32u,Time},{?int16u,length(StringMsg)}]),
	Rs2 = app_msg:encode([{?int16u,length(IntMsg)}]),
	RsList1 = lists:foldl(F, Rs1, StringMsg),
	RsList2 = lists:foldl(F, Rs2, IntMsg),
	app_msg:msg(?P_CLAN_LOGS_MSG, <<RsList1/binary,RsList2/binary>>).

% 帮派列表返回 [33040]
msg_ok_clanlist(Page,AllPages,ClandataMsg)->
	Rs = app_msg:encode([{?int16u,Page},{?int16u,AllPages},{?int16u,length(ClandataMsg)}]),
	RsList = lists:foldl(fun({ClanId,ClanName,ClanLv,ClanRank,ClanMembers,ClanAllMembers},Acc) ->
								 Bin=app_msg:encode([{?int32u,ClanId},{?string,ClanName},
													 {?int8u,ClanLv},{?int16u,ClanRank},
													 {?int16u,ClanMembers},{?int16u,ClanAllMembers}]),
								 <<Acc/binary,Bin/binary>>
						 end,Rs,ClandataMsg),
	app_msg:msg(?P_CLAN_OK_CLANLIST, RsList).
    

% 已申请帮派列表 [33045]
msg_applied_clanlist(Is, ClanList)->
	Rs = app_msg:encode([{?int8u,Is},{?int16u,length(ClanList)}]),
	RsList = lists:foldl(fun(ClanId,Acc) ->
								 Bin = app_msg:encode([{?int32u,ClanId}]),
								 <<Acc/binary,Bin/binary>>
						 end, Rs, ClanList),
	app_msg:msg(?P_CLAN_APPLIED_CLANLIST, RsList).

% 创建成功 [33060]
msg_ok_rebuild_clan()->
    app_msg:msg(?P_CLAN_OK_REBUILD_CLAN,<<>>).

% 返回入帮申请列表 [33080]
msg_ok_join_list(UserData)->
	Rs	= app_msg:encode([{?int16u,length(UserData)}]),
	F	= fun({Uid,Name,NameColor,Lv,Pro,Time},Acc) ->
			  Bin=app_msg:encode([{?int32u,Uid}, {?string,Name},{?int8u,NameColor},
								  {?int16u,Lv},{?int8u,Pro}, {?int32u,Time}]),
			  <<Acc/binary,Bin/binary>>
	  end, 
	RsList	= lists:foldl(F,Rs, UserData),
	app_msg:msg(?P_CLAN_OK_JOIN_LIST, RsList).

% 入帮申请玩家信息块 [33085]
msg_user_data(Uid,Name,NameColor,Lv,Pro,Time)->
    RsList = app_msg:encode([{?int32u,Uid},
        {?string,Name},{?int8u,NameColor},
        {?int16u,Lv},{?int8u,Pro},
        {?int32u,Time}]),
    app_msg:msg(?P_CLAN_USER_DATA, RsList).


% 返回审核结果 [33095]
msg_ok_audit(Uid,State)->
    RsList = app_msg:encode([{?int32u,Uid},{?int8u,State}]),
    app_msg:msg(?P_CLAN_OK_AUDIT, RsList).


% 返回修改公告结果 [33120]
msg_ok_reset_cast()->
    app_msg:msg(?P_CLAN_OK_RESET_CAST,<<>>).


% 返回帮派成员列表 [33140]
msg_ok_member_list(MemberMsg)->
	Rs		= app_msg:encode([{?int16u,length(MemberMsg)}]),
	F=fun(ClanMem,Acc) ->
			  #clan_mem{devote_day=TodayGx,devote_sum=AllGx,logout_time=Time,por=Pro,
						post=Post,name=Name,name_color=NameColor,uid=Uid,lv=Lv}=ClanMem,
			  Bin=app_msg:encode([{?int32u,Uid},
								  {?string,Name},{?int8u,NameColor},
								  {?int16u,Lv},{?int8u,Pro},
								  {?int8u,Post},{?int32u,TodayGx},
								  {?int32u,AllGx},{?int32u,Time}]),
			  <<Acc/binary,Bin/binary>>
	  end,
	RsList	= lists:foldl(F,Rs, MemberMsg),
	app_msg:msg(?P_CLAN_OK_MEMBER_LIST, RsList).

% 成员数据信息块 [33145]
msg_member_msg(Uid,Name,NameColor,Lv,Pro,Post,TodayGx,AllGx,Time)->
	RsList = app_msg:encode([{?int32u,Uid},
							 {?string,Name},{?int8u,NameColor},
							 {?int16u,Lv},{?int8u,Pro},
							 {?int8u,Post},{?int32u,TodayGx},
							 {?int32u,AllGx},{?int32u,Time}]),
	app_msg:msg(?P_CLAN_MEMBER_MSG, RsList).

% 申请成功 [33040]
msg_ok_join_clan(Type,ClanId)->
    RsList = app_msg:encode([{?int8u,Type},{?int32u,ClanId}]),
    app_msg:msg(?P_CLAN_OK_JOIN_CLAN, RsList).

% 退出帮派成功 [33160]
msg_ok_out_clan()->
    app_msg:msg(?P_CLAN_OK_OUT_CLAN,<<>>).

% 返回帮派技能面板数据 [33210]
msg_ok_clan_skill(Stamina,AttrMsg)->
	Rs = app_msg:encode([{?int32u,Stamina},{?int16u,length(AttrMsg)}]),
	RsList=lists:foldl(fun({Type,SkillLv,Value,AddValue,Cast},Acc) -> 
							   Bin = app_msg:encode([{?int8u,Type},{?int8u,SkillLv},{?int32u,Value},
													 {?int16u,AddValue},{?int32u,Cast}]),
							   <<Acc/binary,Bin/binary>>
					   end, Rs, AttrMsg),
	app_msg:msg(?P_CLAN_OK_CLAN_SKILL, RsList).

% 帮派技能属性数据块【33215】
msg_clan_attr_data(Type,SkillLv,Value,AddValue,Cast)->
	RsList = app_msg:encode([{?int8u,Type},{?int8u,SkillLv},{?int32u,Value},
							 {?int16u,AddValue},{?int32u,Cast}]),
	app_msg:msg(?P_CLAN_CLAN_ATTR_DATA, RsList).

% 玩家现有体能值 [33305]
msg_now_stamina(Stamina)->
    RsList = app_msg:encode([{?int32u,Stamina}]),
    app_msg:msg(?P_CLAN_NOW_STAMINA, RsList).
