%% Author: tanwer
%% Created: 2013-08-20
%% Description: TODO: Add description to clan_boss_api
-module(clan_boss_api).

%%
%% Include files
%%
-include("../include/comm.hrl"). 

-define(CLAN_BOSS_ALL(Clan),		ets:select(?ETS_CLAN_BOSS_RANK, [{'$1',[{'=:=',{element,3,'$1'},{const,Clan}}],['$1']}])).

%%
%% Exported Functions
%% 

-export([
		 init/1,
		 
		 % Api
		 clan_id_get/1,
		 
		 boss_harm/2,
		 clan_boss_state/2,
		 
		 % local_fun
		 open_active/1,
		 join_active/1,
		 
		 % local_mod
		 open_active_handl/1,
		 boss_harm_updata_handl/3,
		 open_active_cb/2,
		 boss_monster/3,
		 
		 % test
		 get_buff_spend/1,
		 get_rank_self/2,
		 start_active/3,
		 active_over/2,
		 add_integer/3,
		 boss_die_rs_rmb/1,
		 boss_rmb_attr/1,
		 interval_reward/2,
		 kill_boss_man/4,
		 rank_self/2,
		 send_to_map/2,
		 add_buff_attr/2,
		 ask_relive/1,
		 get_boss_pub/1,
%% 		 mysql_update/1,
		 
		 %%　帮派活动消息
		set_old/1,
		 msg_buff_data/3,
		 msg_died_state/2,
		 msg_harm_data/2,
		 msg_rank_data/1,
		 msg_role_data/5,
		 msg_active_state/4,
		 msg_time_down/2,
		 msg_join_data/3,
		 msg_ok_relive/0

		]).

init(ClanId) ->
	#clan_boss_pub{clan_id=ClanId}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Api

clan_id_get(Uid) ->
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId} ->
			{?ok,ClanId};
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end.

%% 活动状态	  [{活动ID,	 帮派限制等级,	已完成次数, 总次数,	 开启状态}|_]
%% retrun	: [{ActiveId,LimiteClanlv,Times,AllTimes,State}|_]
clan_boss_state(ClanId,ClanLv) ->
	#d_clan{boss_times=AllTimes} = data_clan_level:get(ClanLv),
	case clan_active_api:state(?CONST_CLAN_ACTIVE_CLANBOSS) of
		0 ->
			{?CONST_CLAN_ACTIVE_CLANBOSS,?CONST_CLAN_CLAN_BOSS_LIMIT_LV,0,AllTimes,2};
		_ ->
			if AllTimes=:=0 ->
				   {?CONST_CLAN_ACTIVE_CLANBOSS,?CONST_CLAN_CLAN_BOSS_LIMIT_LV,0,AllTimes,2};
			   ?true ->
				   case get_boss_pub(ClanId) of
					   #clan_boss_pub{open_times=OpenTimes,end_time=EndTime,date=Date} ->
						   Now = util:seconds(),
						   CheckTime = util:is_same_date(Now, Date),
						   State =
							   if Now =< EndTime -> 1;
								  CheckTime =:= ?true ->
									  case OpenTimes < AllTimes of
										  ?true -> 0;
										  _ ->  2
									  end;
								  ?true ->  2
							   end,
						   {?CONST_CLAN_ACTIVE_CLANBOSS, ?CONST_CLAN_CLAN_BOSS_LIMIT_LV, OpenTimes, AllTimes,State};
					   _ ->
						   {?CONST_CLAN_ACTIVE_CLANBOSS, ?CONST_CLAN_CLAN_BOSS_LIMIT_LV, 0, AllTimes,0}
				   end
			end
	end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% local_fun

%% 请求开启帮派BOSS
open_active_handl(MPid) ->
	util:pid_send(MPid, ?MODULE, open_active_cb, ?null).

open_active_cb(#player{uid=Uid,vip=Vip,socket=Socket}=Player,_) ->
	case open_active(Player) of
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, BinMsg),
			Player;
		{?ok,Player2,BinMsg} ->
			case clan_active_api:ask_clan_active(Uid,Vip#vip.lv) of
				{?error,ErrorCode2} ->
					BinMsg2=system_api:msg_error(ErrorCode2);
				{?ok,BinMsg2} -> ?ok
			end,
			app_msg:send(Socket, <<BinMsg/binary,BinMsg2/binary>>),
			Player2
	end.

%% 请求开启帮派BOSS
open_active(#player{uid=Uid}=Player) ->
	case clan_mod:is_master(Uid) of
		{?true, #clan_public{clan_id=ClanId,member=Member, clan_lv=ClanLv}} ->
			case ClanLv >= ?CONST_CLAN_CLAN_BOSS_LIMIT_LV of
				?true ->  
					start_active(Player, Member,ClanBossP=init(ClanId));
%% 					case get_boss_pub(ClanId) of
%% 						?null ->
%% 							ClanBossP=init(ClanId),
%% 							start_active(Player, Member, ClanBossP);
%% 						#clan_boss_pub{open_times=OpenTimes,end_time=EndTime,date=Date}=ClanBossP ->
%% 							Now = util:seconds(),
%% 							CheckTime = util:is_same_date(Now, Date),
%% 							if Now =< EndTime ->
%% 								   join_active(Player);
%% 							   CheckTime =:= ?true ->
%% 								   #d_clan{boss_times=BossTimes} = data_clan_level:get(ClanLv),
%% 								   case OpenTimes < BossTimes of
%% 									   ?true ->
%% 										   start_active(Player, Member, ClanBossP);
%% 									   _ ->
%% 										   {?error,?ERROR_CLAN_NO_COUNT}
%% 								   end;
%% 							   ?true ->
%% 								   start_active(Player, Member, ClanBossP)
%% 							end
%% 					end;
				_ ->
					{?error,?ERROR_CLAN_CLANBOSS_LV_LOW}
			end;
		?false -> 
			{?error,?ERROR_CLAN_NOT_OFFICIAL}
	end.

set_old([Old]) ->
	active_api:temp_active(Old).

%% 开启活动
%% start_active(Player, Member, ClanBossP) ->
%% 	#player{uid=Uid,uname=Name,uname_color=NameColor}=Player,
%% 	LogSrc = [start_active_cast, ?CONST_CLAN_CLAN_BOSS_SPEND, <<"招唤社团BOSS">>], % [Method,UseValue,Remark]
%% 	case role_api:currency_cut(LogSrc, Player, [{?CONST_CURRENCY_RMB,?CONST_CLAN_CLAN_BOSS_SPEND}]) of
%% 		{?ok, Player2, Bin} -> 
%% 			#clan_boss_pub{clan_id=ClanId} = ClanBossP,
%% 			{{Y,M,D},{H,I,S}} = util:localtime(),
%% 			case util:seconds2localtime(util:seconds() + 1800) of
%% 				{{Y,M,D},{H2,I2,S2}} ->
%% %% 					AllActive = active_mod:get_allactive(),
%% %% 					Old = [{ID0,T0,A0,B0,C0,D0,E0,F0}|| {ID0,T0,A0,B0,C0,D0,E0,F0} <- AllActive,ID0=:=3001],
%% %% 					timer:apply_after(1820, ?MODULE, set_old, [Old]),
%% 					active_api:temp_active({3001,4,[],[],[{H,I,S+2,1,30},{H2,I2,S2,0,0}],30,1,1}),
%% 					[ets:delete(?ETS_CLAN_BOSS_RANK, U) || U <- Member],
%% 					EndTime = util:seconds() + ?CONST_CLAN_BOSS_TIME + 60,
%% 					ClanBossP2=ClanBossP#clan_boss_pub{open_times	= ClanBossP#clan_boss_pub.open_times + 1,
%% 													   end_time		= EndTime,
%% 													   boss_data	= [],
%% 													   open_data	= [Uid,Name,NameColor]},
%% 					ets:insert(?ETS_CLAN_BOSS_PUB, ClanBossP2),
%% 					mysql_update(ClanBossP2),
%% 					[logs_api:action_notice(ToUid,?CONST_LOGS_2033,[{Name,NameColor}],[]) 
%% 					   || ToUid <- Member, ToUid =/= Uid],
%% 					{?ok, Player2, Bin};
%% 				_ ->
%% 					{?error, ?ERROR_SKYWAR_DO_BAN}
%% 			end;
%% 		{?error, ErrorCode} ->
%% 			{?error, ErrorCode}
%% 	end;
	
start_active(Player, Member, ClanBossP) ->
	LogSrc = [start_active_cast, ?CONST_CLAN_CLAN_BOSS_SPEND, <<"招唤社团BOSS">>], % [Method,UseValue,Remark]
	case role_api:currency_cut(LogSrc, Player, [{?CONST_CURRENCY_RMB,?CONST_CLAN_CLAN_BOSS_SPEND}]) of
		{?ok, Player2, Bin} -> 
			[ets:delete(?ETS_CLAN_BOSS_RANK, U) || U <- Member],
			#player{uid=Uid,uname=Name,uname_color=NameColor,lv=Lv}=Player2,
%% 			#clan_mem{clan_id=ClanId,post=Post}=Member,
			EndTime = util:seconds() + ?CONST_CLAN_BOSS_TIME + 60,
			ClanBossP2=ClanBossP#clan_boss_pub{
											   start_time	= util:seconds()+60,
											   end_time		= EndTime,
											   open_data		= [Uid,Name,NameColor,3],
											   boss_data		= [],
											   clan_player	= [],
											   clan_all_hp	= []},
			?MSG_ECHO("================= zhun bei  kai qi  ==============",[]),
%% 			ets:insert(?ETS_CLAN_BOSS_PUB, ClanBossP2),
%% 			mysql_update(ClanBossP2),
			timer:apply_after(60*1000, ?MODULE, boss_monster, [ClanBossP2,Lv,Name]),
			[logs_api:action_notice(ToUid,?CONST_LOGS_2033,[{Name,NameColor}],[]) 
			   || ToUid <- Member, ToUid =/= Uid],
			{?ok, Player2, Bin};
%% 			join_active(Player2);

		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.

%% 刷新怪物
boss_monster(ClanBossP,Lv,Name)->
	?MSG_ECHO("================= boss  updata ==============",[]),
	BossDate=data_clan_boss_lv:get(Lv),
	[{BossId,_,_,_,_}|_]=BossDate,
	#d_monster{attr=BoosAttr} = data_scene_monster:get(BossId),
%% 	#d_monster{attr=BoosAttr}=BossDate,
	ClanBossP2=ClanBossP#clan_boss_pub{boss_data = [BossId,Lv,Name,BoosAttr#attr.hp,BoosAttr#attr.hp]},
	ets:insert(?ETS_CLAN_BOSS_PUB, ClanBossP2),
	scene_api:clan_add_monster(?CONST_CLAN_BOSS_SCENE, ClanBossP#clan_boss_pub.clan_id, BossDate).
			

%% 参加活动
join_active(Player=#player{uid=Uid,vip=Vip})->
	case ets:lookup(?ETS_CLAN_MEMBER,Uid) of
		[#clan_mem{clan_id=ClanId}|_] ->
			case ets:lookup(?ETS_CLAN_BOSS_PUB,ClanId) of
				[]->
					{?error,110};
				[#clan_boss_pub{start_time=StartTime,end_time=EndTime,
								boss_data=BossDate,clan_player=ClanPlayer,
								clan_all_hp=ClanAllHp}=ClanBossPub|_]->
					case BossDate of
						[]->
							{Player,<<>>};
						_->
							NBossRanks=lists:keysort(#boss_dps.harm,ClanPlayer),	
							NBossRanks2=lists:sublist(NBossRanks,10),
							RHarm=harm_self(Uid,ClanPlayer),
							{Hp,ClanAllHp2}=hp_self(Player,ClanAllHp),
							BinHp=world_boss_api:msg_self_hp(Hp), 
							BinRank=world_boss_api:msg_dps(RHarm,NBossRanks2),
							VipBinMsg=?IF(Vip>=6,world_boss_api:msg_vip_rmb(),<<>>),
							BinMsg=world_boss_api:msg_map_data(StartTime,EndTime),
							ClanBossPub2=ClanBossPub#clan_boss_pub{clan_all_hp=ClanAllHp2},
							ets:insert(?ETS_CLAN_BOSS_PUB,ClanBossPub2),
							{Player,<<BinHp/binary,BinMsg/binary,VipBinMsg/binary,BinRank/binary>>}
					end
			end;
		_->
			{?error,110}
	end.

hp_self(#player{uid=Uid,attr=Attr},ClanAllHp)->
	case lists:keyfind(Uid,1,ClanAllHp) of
		[{_,Hp}|_]->
			{Hp,ClanAllHp};
		_->
			{Attr#attr.hp,[{Uid,Attr#attr.hp}|ClanAllHp]}
	end.
			
harm_self(Uid,ClanPlayer)->
	case lists:keyfind(Uid,#boss_dps.uid,ClanPlayer) of
		#boss_dps{harm=Harm}->
			Harm;
		_->
			0
	end.
		
%% %% 参加活动
%% %%　retrun: {?error, ErrorCode} | {?ok,Player2,BinMsg}
%% join_active(#player{uid=Uid}=Player) ->
%% 	ClanId = clan_api:clan_id_get(Uid),
%% 	case ets:lookup(?ETS_CLAN_BOSS_PUB, ClanId) of
%% 		[#clan_boss_pub{clan_id	= ClanId,
%% 						end_time = EndTime,
%% 						boss_data = BossData,
%% 						open_data = [_ToUid,ToName,_ToNameColor]}|_] ->
%% 			case scene_api:clan_enter(Player, ?CONST_CLAN_BOSS_MAPID, ClanId) of
%% 				{?ok, NewPlayer} ->
%% 					BinDTime = %% 倒计时
%% 						case EndTime - util:seconds() of
%% 							Times when Times > ?CONST_CLAN_BOSS_TIME ->
%% 								msg_time_down(0,Times-?CONST_CLAN_BOSS_TIME);
%% 							Times when Times =< 60 ->
%% 								msg_time_down(1,Times);
%% 							Times -> <<>> 
%% 						end,
%% 					BinJoin = %%　活动Boss状态
%% 						case BossData of
%% 							[] -> msg_active_state(Times, ?CONST_CLAN_BOSS_MAPID, ClanId, 0);
%% 							[BossId,_Lv,BoosAttr] when BoosAttr#attr.hp > 0 ->
%% 								BinState = msg_active_state(Times, ?CONST_CLAN_BOSS_MAPID, ClanId, 1),
%% 								BinBoss	= msg_join_data(BossId, BoosAttr#attr.hp, ToName),
%% 								<<BinState/binary,BinBoss/binary>>;
%% 							[BossId,_Lv,_BoosAttr] ->
%% 								BinState = msg_active_state(Times, ?CONST_CLAN_BOSS_MAPID, ClanId, 2),
%% 								BinBoss	= msg_join_data(BossId, 0, ToName),
%% 								<<BinState/binary,BinBoss/binary>>
%% 						end,
%% 					case ets:lookup(?ETS_CLAN_BOSS_RANK, Uid) of
%% 						[#clan_boss_rank{}=RankSelf|_] ->
%% 							RankSelf2	= RankSelf#clan_boss_rank{buff=[],buff_times=0};
%% 						_ -> 
%% 							RankSelf2	= get_rank_self(Player, ClanId)
%% 					end,
%% 					ets:insert(?ETS_CLAN_BOSS_RANK, RankSelf2),
%% 					{RankData10, RSelf} = rank_self(Uid, ClanId),
%% 					BinRank		= msg_rank_data(RankData10),
%% 					#clan_boss_rank{name=Name,name_color=NameColor,integer=Integer,uid=Uid} = RankSelf2,
%% 					BinRanksef	= msg_role_data(Uid,Name,NameColor,Integer, RSelf),
%% 					[Spend,{_,_}] = data_clan_boss_attr:get(1),
%% 					BinBuf		= msg_buff_data(0, Spend, []),
%% 					BinMsg		=  <<BinDTime/binary, BinJoin/binary, BinBuf/binary, BinRank/binary, BinRanksef/binary>>,
%% 					{?ok, NewPlayer, BinMsg};
%% 				{?error, ErrorCode} -> 
%% 					{?error, ErrorCode}
%% 			end;
%% 		_ ->
%% 			{?error, ?ERROR_CLAN_NOT_START}
%% 	end.

%% 战斗
boss_harm(#player{spid=Spid,uid=Uid,uname=Name,uname_color=NameColor,lv=Lv,pro=Pro},WarB)->
	?MSG_ECHO("=========== ~w~n",[Uid]),
	clan_srv:boss_harm_updata_cast({Uid,Lv,Name,NameColor,Pro},WarB,Spid).
	
boss_harm_updata_handl({Uid,Lv,Name,_NameColor},{FoeType,Mid,Id,Stata,Harm},SPid) ->
	ClanId = clan_api:clan_id_get(Uid),
	?MSG_ECHO("=========== ~w~n",[FoeType]),
	case ets:lookup(?ETS_CLAN_BOSS_PUB, ClanId) of
		[#clan_boss_pub{clan_all_hp=ClanAllHp,boss_data=BossData,clan_player=ClanPlayer}=ClanBossP|_] ->
			case FoeType of
				?CONST_PLAYER->
					{Hp,ClanAllHp2}=player_hp_update(Mid,Harm,ClanAllHp),
					ClanBossP2=ClanBossP#clan_boss_pub{clan_all_hp=ClanAllHp2},
					ets:insert(?ETS_CLAN_BOSS_PUB,ClanBossP2),
					BinMsg=scene_api:msg_hp_update(FoeType,Mid,Id,Stata,Hp),
					scene_api:broadcast_scene(SPid, BinMsg);
				?CONST_MONSTER->
					{BossHp,ClanPlayer2,BossData2,Bin}=monster_hp_update(Uid,Lv,Name,Harm,ClanPlayer,BossData),
					ClanBossP2=ClanBossP#clan_boss_pub{clan_player=ClanPlayer2,boss_data=BossData2},
					ets:insert(?ETS_CLAN_BOSS_PUB,ClanBossP2),
					BinMsg=scene_api:msg_hp_update(FoeType,Mid,Id,Stata,BossHp),
					scene_api:broadcast_scene(SPid, <<BinMsg/binary,Bin/binary>>);
				_->
					?MSG_ECHO("=========== ~w~n",[FoeType]),
					?skip
			end;
		_->
			?skip
	end.

player_hp_update(Mid,Harm,ClanAllHp)->
	case lists:keytake(Mid,1,ClanAllHp) of
		{value,{_,Hp},ClanAllHp2}->
			case Hp-Harm =< 0 of
				?true->
					{0,ClanAllHp2};
				_->
					{Hp-Harm,[{Mid,Hp-Harm}|ClanAllHp2]}
			end;
		_->
			{0,ClanAllHp}
	end.

monster_hp_update(Uid,Lv,Name,Harm,ClanPlayer,[BossId,BossLv,Name,SHp,MaxHp])->
	{PHarm,ClanPlayer2}=boss_harm_self(Uid,Harm,ClanPlayer),
	case SHp>0 of
		?true->
			case SHp-Harm =< 0 of
				?true->
					?MSG_ECHO("guan wu si wang  ~w~n",[{Uid,Lv,Name,BossId,0}]),
					BossDps=#boss_dps{uid=Uid,name=Name,lv=Lv,harm=PHarm,kill_boss=?CONST_TRUE},
					BossData=[BossId,BossLv,Name,0,MaxHp],
					ClanPlayer3=[BossDps|ClanPlayer2],
%% 					boss_die_exit(),
					{0,ClanPlayer3,BossData,<<>>};
				_->
					?MSG_ECHO("guan wu shou dao shang hai  ~w~n",[{Uid,Lv,Name,BossId,Harm}]),
					BossHp=SHp-Harm,
					BossDps=#boss_dps{uid=Uid,name=Name,lv=Lv,harm=PHarm,kill_boss=?CONST_FALSE},
					BossData=[BossId,BossLv,Name,BossHp,MaxHp],
					ClanPlayer3=[BossDps|ClanPlayer2],
					
					NBossRanks=lists:keysort(#boss_dps.harm,ClanPlayer3),
					NBossRanks2=lists:sublist(NBossRanks,10),
					RHarm=harm_self(Uid,ClanPlayer3),
					BinRank=world_boss_api:msg_dps(RHarm,NBossRanks2),
					{BossHp,ClanPlayer3,BossData,BinRank}
			end;
		_->
			BossData=[BossId,BossLv,Name,SHp,MaxHp],
			{0,ClanPlayer2,BossData}
	end.

boss_harm_self(Uid,Harm,ClanPlayer)->
	case lists:keytake(Uid,#boss_dps.uid,ClanPlayer) of
		{value,#boss_dps{harm=PHarm},ClanPlayer2}->
			{PHarm+Harm,ClanPlayer2};
		_->
			{Harm,ClanPlayer}
	end.
			



%% 			case BossData of
%% 				[BossId,BossLv,BoosAttr] ->
%% 					case BoosAttr#attr.hp - Harm of
%% 						NewHp when NewHp > 0 ->
%% 							BoosAttr2=BoosAttr#attr{hp=NewHp},
%% 							{RankData20,RSelf,Integer2} = add_integer({Uid,Lv,Name,NameColor},Harm,ClanId),
%% 							ClanBossP2=ClanBossP#clan_boss_pub{boss_data= [BossId,BossLv,BoosAttr2]},
%% 							ets:insert(?ETS_CLAN_BOSS_PUB, ClanBossP2),
%% 							BinSelf	= msg_role_data(Uid, Name, NameColor, Integer2, RSelf),
%% 							app_msg:send(Uid,BinSelf),
%% 							BinBoss	= msg_join_data(BossId, NewHp, ToName),
%% 							BinRank	= msg_rank_data(RankData20),
%% 							send_to_map(<<BinBoss/binary,BinRank/binary>>,ClanId);
%% 						NewHp when NewHp =< -Harm -> ok;
%% 						NewHp ->
%% 							BoosAttr2=BoosAttr#attr{hp=0},
%% 							{RankData20,RSelf,Integer2} = add_integer({Uid,Lv,Name,NameColor},Harm+NewHp,ClanId),
%% 							ClanBossP2=ClanBossP#clan_boss_pub{boss_data= [BossId,BossLv,BoosAttr2]},
%% 							ets:insert(?ETS_CLAN_BOSS_PUB, ClanBossP2),
%% 							BinSelf	= msg_role_data(Uid, Name, NameColor, Integer2, RSelf),
%% 							app_msg:send(Uid,BinSelf),
%% 							BinBoss	= msg_join_data(BossId, NewHp, ToName),
%% 							BinRank	= msg_rank_data(RankData20),
%% 							send_to_map(<<BinBoss/binary,BinRank/binary>>,ClanId),
%% 							kill_boss_man({Uid,Name,NameColor}, ClanId, SkillId, ToName)
%% 					end;
%% 				_ -> ok
%% 			end;
%% 		_ -> ok
%% 	end.
						
%% 击杀特效+击杀奖励		scene_api:uid_list_clan(?CONST_CLAN_BOSS_MAPID,ClanId)					
kill_boss_man({Uid,Name,NameColor},ClanId, SkillId, ToName)-> 
	%% $在帮派Boss战役中奋力一击 #，成功击杀了BOSS $ ，成为咱帮的帮派英雄。
	[logs_api:action_notice(ToUid, ?CONST_LOGS_CLAN_BOSS_KILLER, 
							[{Name,NameColor}, {<<"狂化的_",ToName/binary>>, ?CONST_COLOR_RED}], [SkillId])
	|| ToUid <- clan_api:clan_member_uid(Uid)],
	active_over(ClanId,Uid).

%% 活动结束，回城
active_over(ClanId,KillUid) ->
	scene_api:stop_map(?CONST_CLAN_BOSS_MAPID,ClanId),
	RankLists = ?CLAN_BOSS_ALL(ClanId),
	interval_reward(RankLists, KillUid).
			
interval_reward(RankLists, KillUid) ->
	Fun = fun(#clan_boss_rank{integer=Integer,lv=Lv,uid=Uid}) ->
				  [Hurt,Money,MoneyMax,KillMoney,Devote]=data_clan_boss_reward:get(Lv),
				  Gold=trunc(erlang:min((Integer/Hurt)*Money,MoneyMax)),
				  Gold2=?IF(Uid=:=KillUid, Gold+KillMoney, Gold),
				  Title= <<"社团BOSS奖励">>,
				  Content= mail_api:get_content(1001, [Integer,Gold2,Devote]),
				  %%　"你参于了 帮派BOSS活动 造成了 ~p 点伤害 \n  奖励：银元 +~p，帮派贡献 +~p"
				  mail_api:send_mail_uids([Uid],Title,Content, [], [{?CONST_CURRENCY_GOLD,Gold2},{?CONST_CURRENCY_DEVOTE,Devote}])
		  end,
	lists:map(Fun, RankLists).


%% 金元鼓舞
boss_rmb_attr(Player)->
	case ets:lookup(?ETS_CLAN_BOSS_RANK, Player#player.uid) of
		[#clan_boss_rank{buff_times=BuffTimes,buff=Buff}=RankSelf|_] ->
			case data_clan_boss_attr:get(BuffTimes+1) of 
				?null ->
					{?error,?ERROR_WORLD_BOSS_NOT_LIMIT}; %% 购买次数以达上限
				[RMB,Attrs]->
					case role_api:currency_cut([boss_rmb_attr,[],<<"帮派BOSS 金元鼓舞">>],Player, [{?CONST_CURRENCY_RMB,RMB}]) of 
						{?error,ErrorCode} ->
							{?error,ErrorCode};
						{?ok,Player2,MoneyBin}->
							Buff2=add_buff_attr(Buff,Attrs),
							RankSelf2=RankSelf#clan_boss_rank{buff_times=BuffTimes+1,buff=Buff2},
							ets:insert(?ETS_CLAN_BOSS_RANK, RankSelf2),
							Spend = 
								case data_clan_boss_attr:get(BuffTimes+2) of
									?null -> 0;
									[RMB2,_]-> RMB2
								end,
							BinMsg=msg_buff_data(BuffTimes+1,Spend,Buff2),
							{Player2,<<MoneyBin/binary,BinMsg/binary>>}
					end
			end;
		Err -> ?MSG_ERROR(" +++ not in war ~w~n",[Err]),
			{?error,?ERROR_CLAN_WAR_SELF_DIE}
	end.

%% 加BUff
add_buff_attr(Buff,AttrList)->
	Fun = fun({AType,AValue},BuffAcc)->
				  case lists:keytake(AType,1,BuffAcc) of
					  {value,{AType,TValue},BuffAcc2}->
						  NValue=
							  if
								  AType=:=?CONST_ATTR_CRIT ->
									  AValue+TValue;
								  AType=:=?CONST_ATTR_ATTACK->
									  AValue+TValue;
								  ?true->
									  AValue+TValue
							  end,	 
						  [{AType,NValue}|BuffAcc2];
					  _->
						  [{AType,AValue}|BuffAcc]
				  end
		  end,	
	lists:foldr(Fun, Buff, AttrList).


%% 请求复活	
ask_relive(#player{uid=Uid}=Player) ->
	case ets:lookup(?ETS_CLAN_BOSS_RANK, Uid) of
		[#clan_boss_rank{relive_tims=ReliveTimes}|_] ->
			Spend =  boss_die_rs_rmb(ReliveTimes),
			LogSrc= [ask_relive, Spend, <<"社团BOSS复活">>],
			case role_api:currency_cut(LogSrc, Player, [{?CONST_CURRENCY_RMB,Spend}]) of
				{?ok,Player2,Bin} ->
					Bin2 = msg_ok_relive(),
					{?ok,Player2,<<Bin/binary,Bin2/binary>>};
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		Err -> ?MSG_ERROR(" +++ not in war ~w~n",[Err]),
			  {?error,?ERROR_CLAN_WAR_SELF_DIE}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% local_mod

%%　取帮派Boss公共数据
get_boss_pub(ClanId) ->
	case ets:lookup(?ETS_CLAN_BOSS_PUB, ClanId) of
		[#clan_boss_pub{}=ClanBossP|_] ->
			ClanBossP;
		_ ->
			SQL = "SELECT `times`, `date` FROME `clan_boss` WHERE `ckan_id` = " ++util:to_list(ClanId),
			case mysql_api:select(SQL) of
				{ok,[[Times,Date]]} ->
					case util:is_same_date(Date, util:seconds()) of
						?true ->
							ClanBossP =	init(ClanId),
							ClanBossP2 = ClanBossP#clan_boss_pub{open_times=Times},
							ets:insert(?ETS_CLAN_BOSS_PUB, ClanBossP2),
							ClanBossP2;
						_ ->
							?null
					end;
				_ ->
					?null
			end
	end.

%% %% 更新数据库
%% mysql_update(#clan_boss_pub{clan_id=ClanId,open_times=OpenTimes,date=Date}) ->
%% 	SQL	= <<"REPLACE INTO `clan_boss` (`clan_id`,`times`,`date`) VALUES ",
%% 			 "('", ?B(ClanId),  "','", ?B(OpenTimes),  "','", ?B(Date), "');">>,
%% 	mysql_api:fetch_cast(SQL).
	

%% 活动地图广播
send_to_map(BinMsg,ClanId) ->
	UidList = scene_api:uid_list_clan(?CONST_CLAN_BOSS_MAPID,ClanId),
	erlang:spawn([app_msg:send(Uid, BinMsg) || Uid <- UidList]).

%% 个人排行 {RankData20, RSelf} = rank_self(Uid,Clan),
%% 	MS = ets:fun2ms(fun(R) when R#clan_boss_rank.clan_id =:= ClanId -> R end),
rank_self(Uid,ClanId) ->
	RankLists	= ?CLAN_BOSS_ALL(ClanId),
	RankLists2	= lists:keysort(#clan_boss_rank.integer, RankLists),
	Fun			= fun(#clan_boss_rank{uid=Uid0}=R,{Acc,Rank,RankSelf}) ->
						  RankSelf2 = ?IF(Uid =:= Uid0, Rank, RankSelf),
						  case Rank < ?CONST_CLAN_BOSS_RANK_COUNT of
							  ?true ->
								  {[{R, Rank}|Acc], Rank+1, RankSelf2};
							  _ ->
								  {Acc, Rank+1, RankSelf2}
						  end
				  end,
	{Rank20, Rank, RankSelf2} = lists:foldl(Fun,  {[],1,0}, RankLists2),
	{Rank20, ?IF(RankSelf2=:=0, Rank+1,RankSelf2)}.

%% 更新玩家的积分 {RankData20,RSelf,Integer2} = add_integer({Uid,Lv,Name,NameColor},Harm,ClanId), 
add_integer({Uid,Lv,Name,NameColor},Harm,ClanId) ->
	case ets:lookup(?ETS_CLAN_BOSS_RANK, Uid) of
		[#clan_boss_rank{integer=Integer}=RankSelf|_] ->
			?ok;
		_ ->
			Integer = 0,
			RankSelf = #clan_boss_rank{clan_id=ClanId, lv=Lv,
									   name=Name,name_color=NameColor,uid=Uid}
	end,
	RankSelf2	= RankSelf#clan_boss_rank{integer=Integer+Harm},
	ets:insert(?ETS_CLAN_BOSS_RANK, RankSelf2),
	{RankData20, RSelf} = rank_self(Uid, ClanId),
	{RankData20,RSelf,Integer+Harm}.

%% 初始化玩家排行信息 RankSelf
get_rank_self(Player,ClanId) ->
	#player{uname = Name, uname_color = NameColor, uid = Uid, lv = Lv} = Player,
	#clan_boss_rank{uid		= Uid,
					clan_id = ClanId,
					name	= Name,
					name_color=NameColor,
					lv		= Lv,
					integer=0, buff=[],buff_times=0,relive_tims=0}.
%% 取Buff花费 SpendBuf
get_buff_spend(Times) ->
	case data_clan_boss_attr:get(Times) of
		[Rmb,[{TypeBuf,Value}]] ->
			[Rmb,[{TypeBuf,Value}]];
		_ ->
			?null
	end.


%% 死亡次数获取钻石消耗
boss_die_rs_rmb(D)->
	case D > ?CONST_BOSS_TIMES_RELIVE of
		?true->
			data_clan_boss_relive:get(0);
		?false->
			data_clan_boss_relive:get(D+1)
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---Msg----%

% 活动倒计时 [54205]
msg_time_down(Type,Time)->
    RsList = app_msg:encode([{?int8u,Type},{?int16u,Time}]),
    app_msg:msg(?P_CLAN_BOSS_TIME_DOWN, RsList).

% 伤害数据 [54210]
msg_harm_data(Harm,BossHp)->
    RsList = app_msg:encode([{?int32u,Harm},{?int32u,BossHp}]),
    app_msg:msg(?P_CLAN_BOSS_HARM_DATA, RsList).

% 界面信息返回--活动状态 [54235]
msg_active_state(ActiveTime,MapId,ClanId,IsBoss)->
    RsList = app_msg:encode([{?int16u,ActiveTime},{?int16u,MapId},
							 {?int32u,ClanId},{?int8u,IsBoss}]),
    app_msg:msg(?P_CLAN_BOSS_ACTIVE_STATE, RsList).

% 界面信息返回--BOSS信息 [54240]
msg_join_data(BossId,BossHp,BossName)->
    RsList = app_msg:encode([{?int16u,BossId},
        {?int32u,BossHp},{?string,BossName}]),
    app_msg:msg(?P_CLAN_BOSS_JOIN_DATA, RsList).

% 界面信息返回--排行榜信息 [54250]
msg_rank_data(RoleMsg)->
	Rs	= app_msg:encode([{?int16u,length(RoleMsg)}]),
	Fun = fun({BossRole,Rank},Acc) ->
				  #clan_boss_rank{uid=Uid,name=Name,name_color=NameColor,integer=Integer} = BossRole,
				  Bin= app_msg:encode([{?int32u,Uid},{?string,Name},{?int8u,NameColor},
							 {?int32u,Integer},{?int16u,Rank}]),
				  <<Acc/binary,Bin/binary>>
		  end,
	RsList	= lists:foldl(Fun, Rs, RoleMsg),
	app_msg:msg(?P_CLAN_BOSS_RANK_DATA, RsList).

% 玩家信息块 [54255]
msg_role_data(Uid,Name,NameColor,Integer,Rank)->
	RsList = app_msg:encode([{?int32u,Uid},{?string,Name},{?int8u,NameColor},
							 {?int32u,Integer},{?int16u,Rank}]),
	app_msg:msg(?P_CLAN_BOSS_ROLE_DATA, RsList).

% 鼓舞属性加成 [54260]
msg_buff_data(Times,Spend,BuffMsg)->
	Rs		= app_msg:encode([{?int8u,Times},{?int16u,Spend},
							  {?int16u,length(BuffMsg)}]),
	RsList	= lists:foldl(fun({Type,Value},Acc) ->
								  Bin=app_msg:encode([{?int8u,Type},{?int32u,Value}]),
								  <<Acc/binary,Bin/binary>>
						  end, Rs, BuffMsg),
	app_msg:msg(?P_CLAN_BOSS_BUFF_DATA, RsList).

% 状态返回 [54290]
msg_died_state(Time,Spend)->
    RsList = app_msg:encode([{?int16u,Time},{?int16u,Spend}]),
    app_msg:msg(?P_CLAN_BOSS_DIED_STATE, RsList).

% 复活成功 [54305]
msg_ok_relive()->
    app_msg:msg(?P_CLAN_BOSS_OK_RELIVE,<<>>).


