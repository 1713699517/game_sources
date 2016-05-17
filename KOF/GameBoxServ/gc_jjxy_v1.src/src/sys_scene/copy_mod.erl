%% Author: mirahs
%% Created: 2011-12-17
%% Description: TODO: Add description to copy_mod
-module(copy_mod).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([
		 init_copy_srv/2,
		 init_copy_data/1,
		 
		 get_goods/1,
		 
		 interval_handle/1,
		 do_broadcast/2,
		 timing_handle/2,
		 times_carom_handle/3,
		 times_hit_handle/3,
		 mons_kill_handle/3,
		 war_harm_handle/2,
		 player_list_handle/2,
		 player_list_new_handle/2,
		 die_handle/2,
		 relive_ok_handle/2,
		 die_partner_handle/2,
		 notice_over_handle/5,
		 start_handle/2,
		 move_handle/6,
		 move_new_handle/6,

		 player_send_msg/2,
		 update_copy/1,
		 delete_copy/1,
		 
		 update_pid/1,
		 update_pid_cb/2,
		 copy_over_scene_cb/2,
		 copy_over_update_cb/2,
		 copy_state_change_cb/2,
		 
		 move_monster_handle/2,
		 switch_in_handle/1,
		 exit_handle/2,

		 set_posxy_handle/6,
		 monster_list_handle/2,
		 monster_knock_handle/3,
		 reward_copy_gm/3,
		 
		 change_war_state_handle/2,
		 change_level_handle/3,
		 change_team_leader_handle/2,
		 change_clan_handle/4,
		 change_mount_handle/4
		]).

%%
%% API Functions
%%
init_copy_srv(CopyId,IsTeam) ->
	Copy	= init_copy_data(CopyId),
	Seconds = util:seconds(),
	Copy2	= Copy#copy{state=?CONST_COPY_STATE_PLAY,is_team=IsTeam,ctime=Seconds},
	Copy3	= refresh_copy_map(Copy2),
	put(user_id_list,[]),
	% update_copy(Copy3),
	Copy3.

refresh_copy_map(#copy{gate_now=GateNow,details=Maps}=Copy) ->
	Map	= element(GateNow, Maps),
	Pid = self(),
	Map2= Map#map{pid=Pid},
	Maps2= setelement(GateNow, Maps, Map2),
	Copy#copy{pid=Pid,details=Maps2}.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 获取副本玩家列表
get_copy_players() ->
	Uids = get_copy_uidlist(),
	Fun = fun(Uid,Acc) ->
				  case get_player(Uid) of
					  PlayerS when is_record(PlayerS,player_s) ->
						  [PlayerS | Acc];
					  _ ->
						  Acc
				  end
		  end,
	lists:foldl(Fun, [], Uids).

%% 获取副本玩家Uid列表
get_copy_uidlist() ->
	case get(user_id_list) of
		?undefined ->
			[];
		R ->
			R
	end.

%% 获取副本单个玩家信息
get_player(Uid) ->
	case ets:lookup(?ETS_MAP_PLAYER,Uid) of
		[Player] when is_record(Player,player_s) ->
			Player;
		_ ->
			?null
	end.

%% 给玩家发消息
player_send_msg(Uid,BinMsg) ->
	case get_player(Uid) of
		#player_s{socket=Socket} ->
			app_msg:send(Socket, BinMsg);
		_ ->
			?skip
	end.

%% 更新副本数据
update_copy(Copy) ->
	ets:insert(?ETS_COPY, Copy).

%% 删除副本数据
delete_copy(Pid) ->
	ets:delete(?ETS_COPY, Pid).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 定时
interval_handle(#copy{gate_now=GateNow,details=Maps,state=State,is_team=IsTeam,ctime=Ctime}=Copy) ->
	case IsTeam of
		?CONST_TRUE ->
			Map 	= element(GateNow, Maps),
			Map2	= scene_api:ext_interval_handle(Map,?true,Ctime),
			Map3	= interval_copy_scene(Map2,State),
			Maps2	= setelement(GateNow, Maps, Map3),
			Copy2	= Copy#copy{details=Maps2},
			Copy3	= interval_time_update(Copy2),
			Copy4	= interval_handle_way_copy(Copy3),
			interval_copy_check(Copy4);
		_ ->
			Map 	= element(GateNow, Maps),
			Map2	= interval_copy_scene(Map,State),
			Maps2	= setelement(GateNow, Maps, Map2),
			Copy2	= Copy#copy{details=Maps2},
			Copy3	= interval_time_update(Copy2),
			interval_copy_check(Copy3)
	end.

interval_copy_scene(#map{time=Time}=Map,State) ->
	case State of
		?CONST_COPY_STATE_READY ->
			Map;
		?CONST_COPY_STATE_STOP ->
			Map;
		_ ->
			NewTime = Time + ?CONST_MAP_INTERVAL_SECONDS,
			Map#map{time=NewTime}
	end.

interval_handle_way_copy(#copy{state=State,gate=Gate,gate_now=GateNow,gate_over=GateOver,details=Maps}=Copy) ->
 	%?MSG_ECHO("-------------------~w~n",[{State,Gate,GateNow,GateOver}]),
	Map	= element(GateNow, Maps),
%% 	?MSG_ECHO("--------------~w~n",[{Map#map.screen_now,Map#map.screen_sum,length(Map#map.monsters_all)}]),
	case State of
		?CONST_COPY_STATE_READY ->
			Copy;
		?CONST_COPY_STATE_PLAY ->
			case check_scene_over(Map) of
				?true ->
					Copy2 = Copy#copy{gate_over=GateOver+1},
					BinMsg= copy_api:msg_scene_over(),
					Uids	 = get_copy_uidlist(),
					do_broadcast(Uids, BinMsg),
					Copy2#copy{state=?CONST_COPY_STATE_PAUSE};
				{?false,Map1} ->
					Maps1 = setelement(GateNow,Maps,Map1),
					Copy#copy{details=Maps1};
				faild ->
					BinMsg = copy_api:msg_fail(),
					Uids	= get_copy_uidlist(),
					do_broadcast(Uids,BinMsg),
					Copy#copy{state=?CONST_COPY_STATE_OVER}
			end;
		?CONST_COPY_STATE_PAUSE ->
			case GateOver >= Gate of
				?true ->
					copy_over_update(Copy),
					Copy#copy{state=?CONST_COPY_STATE_OVER};
				_ ->
					Copy
			end;
		?CONST_COPY_STATE_OVER ->
			Copy;
		?CONST_COPY_STATE_STOP ->
			Copy;
		?CONST_COPY_STATE_TIMEOUT ->
			Copy;
		_ ->
			Copy
	end.

check_scene_over(#map{pass_type=PassType,pass_value=PassValue,time=Time,monsters=Monster,war_s=Wars,screen_now=Snow,screen_sum=Ssum}=Map) ->
%%  	?MSG_ECHO("----------------~w~n",[{PassType,Snow,Ssum,length(Monster)}]),
	case PassType of
		?CONST_COPY_PASS_NORMAL ->
			case Monster of
				[] ->
				   case Snow >= Ssum of
					   ?true ->
						  ?true;
					  _ ->
						  Map2 = fresh_map_monsters(Map),
						  {?false,Map2}
				   end;
			   _ ->
				   {?false,Map}
			end;
		?CONST_COPY_PASS_BOSS ->
			{?false,Map};
		?CONST_COPY_PASS_ALIVE ->
			case Time >= PassValue of
				?true ->
				   ?true;
			   _ ->
				   case  Monster of
					   [] ->
						  case Snow >= Ssum of
							  ?true ->
								 ?true;
							 _ ->
								 Map2 = fresh_map_monsters(Map),
								 {?false,Map2}
						  end;
					  _ ->
						  {?false,Map}
				   end
			end;
		?CONST_COPY_PASS_TIME ->
			case Time =< PassValue of
				?true ->
				  case Monster of
					  [] ->
						 case Snow >= Ssum of
							 ?true ->
								?true;
							_ ->
								Map2 = fresh_map_monsters(Map),
								{?false,Map2}
						 end;
					_ ->
						 {?false,Map}
				  end;
			   _ ->
				   faild
			end;
		?CONST_COPY_PASS_COMBO ->
			case Monster of
				[] ->
				   case Snow >= Ssum of
					   ?true ->
						  case check_combo(Wars,PassValue) of
							  ?true ->
								  ?true;
							  _ ->
								  faild
						  end;
					  _ ->
						  Map2 = fresh_map_monsters(Map),
						  {?false,Map2}
				   end;
			   _ ->
				   {?false,Map}
			end
	end.

check_combo(Wars,PassValue) ->
	?MSG_ECHO("------------~w~n",[{Wars,PassValue}]),
	case Wars of
		[] ->
			?MSG_ECHO("------------~w~n",[{Wars,PassValue}]),
			?false;
		_ ->
			?MSG_ECHO("------------~w~n",[{Wars,PassValue}]),
			CaromTimes = [War#war_s.carom_times || War <- Wars],
			case lists:max(CaromTimes) >= PassValue of
				?true ->
					?MSG_ECHO("------------~w~n",[{Wars,PassValue}]),
					?true;
				_ ->
					?MSG_ECHO("------------~w~n",[{Wars,PassValue}]),
					?false
			end
	end.

fresh_map_monsters(#map{screen_now=Snow,monsters_all=MonsterAll}=Map) ->
	NewSnow = Snow + 1,
	{Slx,Srx,Srex,Smonsters,Sgives} = lists:nth(NewSnow, MonsterAll),
	BinMsg = scene_api:msg_idx_monster(NewSnow, Smonsters),
	Uids = get_copy_uidlist(),
	do_broadcast(Uids, BinMsg),
	Map#map{screen_now=NewSnow,monsters=Smonsters,lx=Slx,rx=Srx,reborn_x=Srex,screen_gives=Sgives,monsters_pos_temp=[]}.

%% 时间更新
interval_time_update(#copy{time_life=TimeLife}=Copy) ->
	TimeLife2 = TimeLife + ?CONST_MAP_INTERVAL_SECONDS,
	Copy#copy{time_life=TimeLife2}.

interval_copy_check(#copy{timer_switch=OldTimer}=Copy) ->
	TimerSwitch = OldTimer + ?CONST_COPY_INTERVAL_SECONDS,
	case TimerSwitch >= ?CONST_COPY_TIME_SLOT of
		?true ->
			interval_copy_check2(),
			Uids = get_copy_uidlist(),
			case Uids of
				[] ->
					{?stop, ?normal, Copy#copy{timer_switch=TimerSwitch}};
				_ ->
					{?noreply,Copy#copy{timer_switch=TimerSwitch}}
			end;
		_ ->
			{?noreply,Copy#copy{timer_switch=TimerSwitch}}
	end.

interval_copy_check2() ->
	Uids = get_copy_uidlist(),
	Fun = fun(Uid,Acc) ->
				  case role_api:is_online(Uid) of
					  ?true ->
						  [Uid | Acc];
					  _ ->
						  Acc
				  end
		  end,
	NewUids = lists:foldl(Fun, [], Uids),
	put(user_id_list,NewUids).

timing_handle(#copy{id=CopyId,gate=Gate,gate_now=GateNow,state=State,details=Maps}=Copy, ?CONST_COPY_TIMING_START) ->
	case State =:= ?CONST_COPY_STATE_READY orelse State =:= ?CONST_COPY_STATE_STOP of
		?true ->
			Bin7710	= copy_api:msg_enter_scene_info(CopyId, Gate, GateNow),
			Uids	= get_copy_uidlist(),
			#map{pass_type=Ptype,pass_value=Pvalue,time=SceneTime} = element(GateNow,Maps),
			Stime = round(Pvalue-SceneTime),
			Bin7060 =
				case Ptype of
					?CONST_COPY_PASS_ALIVE ->
						copy_api:msg_scene_time(Stime);
					?CONST_COPY_PASS_TIME ->
						copy_api:msg_scene_time(Stime);
					_ ->
						<<>>
				end,
			do_broadcast(Uids,<<Bin7710/binary,Bin7060/binary>>),
			Copy#copy{state=?CONST_COPY_STATE_PLAY};
		_ ->
			Copy
	end;
timing_handle(Copy, ?CONST_COPY_TIMING_STOP) ->
	Copy#copy{state=?CONST_COPY_STATE_STOP}.

times_carom_handle(#copy{gate_now=GateNow,details=Maps}=Copy,Uid,Times) ->
	Map = element(GateNow,Maps),
	Wars= Map#map.war_s,
	NewWars =
		case lists:keytake(Uid,#war_s.uid,Wars) of
			{value,War,Tmp} ->
				OldTimes = War#war_s.carom_times,
				NewTimes = ?IF(Times>OldTimes,Times,OldTimes),
				[War#war_s{carom_times=NewTimes}|Tmp];
			_ ->
				[#war_s{uid=Uid,carom_times=Times}|Wars]
		end,
	Map1 = Map#map{war_s=NewWars},
	Maps1= setelement(GateNow,Maps,Map1),
	Copy#copy{details=Maps1}.

times_hit_handle(#copy{gate_now=GateNow,details=Maps}=Copy,Uid,Times) ->
	Map = element(GateNow,Maps),
	Wars= Map#map.war_s,
	NewWars =
		case lists:keytake(Uid,#war_s.uid,Wars) of
			{value,War,Tmp} ->
				[War#war_s{hit_times=War#war_s.hit_times+Times}|Tmp];
			_ ->
				[#war_s{uid=Uid,hit_times=Times}|Wars]
		end,
	Map1 = Map#map{war_s=NewWars},
	Maps1= setelement(GateNow,Maps,Map1),
	Copy#copy{details=Maps1}.

mons_kill_handle(#copy{type=Type,gate_now=GateNow,details=Maps}=Copy,Uid,MonsMid) ->
	Map = element(GateNow,Maps),
	case lists:keyfind(MonsMid,#monster.monster_mid,Map#map.monsters) of
		#monster{monster_id=MonsId} ->
			Wars= Map#map.war_s,
			NewWars =
				case lists:keytake(Uid,#war_s.uid,Wars) of
					{value,War,Tmp} ->
						[War#war_s{kill_times=War#war_s.kill_times+1}|Tmp];
					_ ->
						[#war_s{uid=Uid,kill_times=1}|Wars]
				end,
			NewMap = scene_mod:war_over_refresh_monster_handle(Map#map{war_s=NewWars},MonsMid),
			NewMaps = setelement(GateNow,Maps,NewMap),
			Copy2 = Copy#copy{details=NewMaps},
			case Type =:= ?CONST_COPY_PASS_NORMAL andalso check_boss(MonsId) =:= ?true of
				?true ->
					copy_over_update(Copy),
					Copy2#copy{state=?CONST_COPY_STATE_OVER};
				_ ->
					Copy2
			end;		
		_ ->
			Copy
	end.

war_harm_handle(#copy{id=CopyId,gate_now=GateNow,details=Maps,gate_over=GateOver}=Copy,HarmData) ->
	Map = element(GateNow,Maps),
	case scene_mod:war_harm_handle(Map,HarmData,CopyId) of
		{Map2,?false} ->
			Maps2 = setelement(GateNow,Maps,Map2),
			Copy#copy{details=Maps2};
		{Map2,?true} ->
			Maps2 = setelement(GateNow,Maps,Map2),
			?MSG_ECHO("---------------~w~n",[GateOver]),
			Copy2 = Copy#copy{gate_over=GateOver+1,details=Maps2},
			BinMsg= copy_api:msg_scene_over(),
			Uids  = get_copy_uidlist(),
			do_broadcast(Uids, BinMsg),
			Copy2#copy{state=?CONST_COPY_STATE_PAUSE}
	end.

player_list_handle(#copy{gate_now=GateNow,details=Maps}, Uid) ->
	Map = element(GateNow,Maps),
	scene_mod:player_list_handle(Uid,Map#map.type).

player_list_new_handle(#copy{gate_now=GateNow,details=Maps}, Uid) ->
	Map = element(GateNow,Maps),
	scene_mod:player_list_new_handle(Uid,Map#map.type).

die_handle(#copy{relive_lim=ReliveLim},Uid) ->
	DieBinMsg = scene_api:msg_out(Uid,?CONST_PLAYER,?CONST_MAP_OUT_DIE,0),
	Uids = get_copy_uidlist(),
	do_broadcast(lists:delete(Uid, Uids), DieBinMsg),
	case lists:member(Uid, Uids) of
		?true ->
			case get_player(Uid) of
				#player_s{die=Die,relive_times=Times}=PlayerS ->
					case Die of
						?false ->
							case Times < ReliveLim of
								?true ->
									BinMsg = copy_api:msg_relive(10),
									player_send_msg(Uid, BinMsg);
								_ ->
									BinMsg = copy_api:msg_fail(),
									player_send_msg(Uid, BinMsg)
							end,
							NewPlayerS = PlayerS#player_s{die=?true},
							ets:insert(?ETS_MAP_PLAYER, NewPlayerS);
						_ ->
							?skip
					end;
				_ ->
					?skip
			end;
		_ ->
			?skip
	end.

relive_ok_handle(_Copy,#player_s{uid=Uid}=PlayerS) ->
	Uids = get_copy_uidlist(),
	case lists:member(Uid, Uids) of
		?true ->
			BinMsg = scene_api:msg_role_data(PlayerS, ?CONST_MAP_ENTER_NULL),
			do_broadcast(lists:delete(Uid, Uids), BinMsg);
		_ ->
			?skip
	end.

die_partner_handle(Uid,PartnerId) ->
	Uids = get_copy_uidlist(),
	case lists:member(Uid, Uids) of
		?true ->
			case get_player(Uid) of
				#player_s{partners=Partners} ->
					case lists:keyfind(PartnerId,#partner.partner_id,Partners) of
						#partner{} ->
							BinMsg = scene_api:msg_out(PartnerId,?CONST_PARTNER,?CONST_MAP_OUT_DIE,Uid),
							do_broadcast(Uids, BinMsg);
						_ ->
							?skip
					end;
				_ ->
					?skip
			end;
		_ ->
			?skip
	end.

notice_over_handle(#copy{state=State,is_team=IsTeam}=Copy,Uid,Hits,Caroms,MonsHp) ->
	?MSG_ECHO("-----------~w~n",[{IsTeam,State,Uid,Hits,Caroms,MonsHp}]),%{0,2,4516,344,40,92629}
	case State of
		?CONST_COPY_STATE_PLAY ->
			UidList =get_copy_uidlist(),
			case lists:member(Uid, UidList) of
				?true ->
					Copy2 = player_wars(Copy,Uid,Hits,Caroms,MonsHp),
					case IsTeam of
						?CONST_FALSE ->
							notice_over_noteam(Copy2,Uid);
						_ ->
							notice_over_team(Copy2)
					end;
				_ ->
					Copy
			end;
		_ ->
			Copy
	end.

notice_over_noteam(#copy{id=CopyId,type=CopyType,time_copy=TimeCopy,time_life=Time,details=Maps,
						 gate=Gate,gate_now=GateNow,gate_over=GateOver}=Copy,Uid) ->
	Map = element(GateNow,Maps),
	case check_notice_over_scene(Map) of
		?true ->
			?IF(CopyType =:= ?CONST_COPY_TYPE_FIGHTERS, util:pid_send(Uid,?MODULE,copy_over_scene_cb,{CopyId,GateNow}), ?skip),
			NewGateOver = GateOver + 1,
			case NewGateOver >= Gate of
				?true ->
					case TimeCopy =:= 0 orelse TimeCopy < Time of
						?true ->
							copy_over_update(Copy),
							Copy#copy{state=?CONST_COPY_STATE_OVER};
						_ ->
							BinMsg	= copy_api:msg_fail(),
							Uids	= get_copy_uidlist(),
							do_broadcast(Uids,BinMsg),
							Copy#copy{state=?CONST_COPY_STATE_OVER}
					end;
				_ ->
					BinMsg= copy_api:msg_scene_over(),
					Uids	 = get_copy_uidlist(),
					do_broadcast(Uids, BinMsg),
					Copy#copy{gate_over=NewGateOver,state=?CONST_COPY_STATE_PAUSE}
			end;
		_ ->
			BinMsg	= copy_api:msg_fail(),
			Uids	= get_copy_uidlist(),
			do_broadcast(Uids,BinMsg),
			Copy#copy{state=?CONST_COPY_STATE_OVER}
	end.

check_notice_over_scene(#map{pass_type=PassType,pass_value=PassValue,time=Time,monsters=Monster,war_s=Wars,screen_now=Snow,screen_sum=Ssum}) ->
	?MSG_ECHO("------------~w~n",[{PassType,PassValue,Time,Snow,Ssum,Monster}]),
	case PassType of
		?CONST_COPY_PASS_TIME ->
			case Time =< PassValue of
				?true ->
					?true;
				_ ->
					?false
			end;
		?CONST_COPY_PASS_COMBO ->
			case check_combo(Wars,PassValue) of
				?true ->
					?MSG_ECHO("------------~w~n",[{PassType,PassValue,Time,Snow,Ssum}]),
					?true;
				_ ->
					?MSG_ECHO("------------~w~n",[{PassType,PassValue,Time,Snow,Ssum}]),
					?false
			end;
		_ ->
			?true
	end.

%% check_notice_over_scene(#map{pass_type=PassType,pass_value=PassValue,time=Time,monsters=Monster,war_s=Wars,screen_now=Snow,screen_sum=Ssum}) ->
%% 	?MSG_ECHO("------------~w~n",[{PassType,PassValue,Time,Snow,Ssum,Monster}]),
%% 	case PassType of
%% 		?CONST_COPY_PASS_NORMAL ->
%% 			?true;
%% 		?CONST_COPY_PASS_BOSS ->
%% 			?true;
%% 		?CONST_COPY_PASS_ALIVE ->
%% 			case Time >= PassValue of
%% 				?true ->
%% 					?true;
%% 				_ ->
%% 					?false
%% 			end;
%% 		?CONST_COPY_PASS_TIME ->
%% 			case Time =< PassValue of
%% 				?true ->
%% 					?true;
%% 				_ ->
%% 					?false
%% 			end;
%% 		?CONST_COPY_PASS_COMBO ->
%% 			case check_combo(Wars,PassValue) of
%% 				?true ->
%% 					?MSG_ECHO("------------~w~n",[{PassType,PassValue,Time,Snow,Ssum}]),
%% 					?true;
%% 				_ ->
%% 					?MSG_ECHO("------------~w~n",[{PassType,PassValue,Time,Snow,Ssum}]),
%% 					?false
%% 			end
%% 	end.

notice_over_team(Copy) ->
	Copy2 = interval_handle_way_copy(Copy),
	Copy2.

copy_over_scene_cb(Player,{CopyId,GateNow}) ->
	#d_copy{scene=Scene} = data_scene_copy:get(CopyId),
	SceneId = lists:nth(GateNow, Scene),
	case data_scene:scene(SceneId) of
		#d_scene{war_reward=Reward} ->
			Goods = get_goods(Reward),
			Bag = role_api_dict:bag_get(),
			case bag_api:goods_set([copy_over_update_cb,[],<<"副本奖励">>],Player,Bag,Goods) of
				{?ok,Player2,Bag2,GoodsBin,BinMsg} ->
					role_api_dict:bag_set(Bag2),
					app_msg:send(Player#player.socket,<<GoodsBin/binary,BinMsg/binary>>),
					Player2;
				{?error,ErrorCode} ->
					BinMsg	= system_api:msg_error(ErrorCode),
					app_msg:send(Player#player.socket, BinMsg),
					Player
			end;
		_ ->
			Player
	end.

player_wars(#copy{gate_now=GateNow,details=Maps}=Copy,Uid,Hits,Caroms,MonsHp) ->
	Map = element(GateNow,Maps),
	Wars= Map#map.war_s,
	NewWars =
		case lists:keytake(Uid,#war_s.uid,Wars) of
			{value,War,Tmp} ->
				?MSG_ECHO("-------------------~n",[]),
				[War#war_s{hit_times=Hits,carom_times=Caroms,monster_hp=MonsHp}|Tmp];
			_ ->
				?MSG_ECHO("-------------------~n",[]),
				[#war_s{uid=Uid,hit_times=Hits,carom_times=Caroms,monster_hp=MonsHp}|Wars]
		end,
	Map1 = Map#map{war_s=NewWars},
	Maps1= setelement(GateNow,Maps,Map1),
	Copy#copy{details=Maps1}.

get_copy_monster_hp(Maps) ->
	Fun = fun(#map{monsters_all=MonsAll},AccHp) ->
				  Monsters = [Monster || {_Lx,_Rx,_Rbx,Monster,_Gives} <- MonsAll],
				  Hp = get_copy_monster_hp(Monsters,0),
				  AccHp + Hp
		  end,
	lists:foldl(Fun, 0, Maps).

get_copy_monster_hp([],AccHp) ->
	AccHp;
get_copy_monster_hp([MonsterList|MonstersList],AccHp) ->
	Fun = fun(#monster{hp_max=HpMax},AccHp1) ->
				   AccHp1 + HpMax
		   end,
	Hp = lists:foldl(Fun, 0, MonsterList),
	get_copy_monster_hp(MonstersList,AccHp+Hp).

copy_get_score(ScoreId,Hits,Time,Caroms,Kills) ->
	% {1002,10,202,36,1}
	?MSG_ECHO("-------------------~w~n",[{ScoreId,Hits,Time,Caroms,Kills}]),
	HitsScore	= copy_get_score(ScoreId,?CONST_COPY_SCORE_HITS,Hits),
	TimeScore	= copy_get_score(ScoreId,?CONST_COPY_SCORE_TIME,Time),
	CaromScore	= copy_get_score(ScoreId,?CONST_COPY_SCORE_CAROM,Caroms),
	KillScore	= copy_get_score(ScoreId,?CONST_COPY_SCORE_KILL,Kills),
	AllScore	= round(HitsScore+TimeScore+CaromScore+KillScore),
	Eva			= copy_get_score(ScoreId,?CONST_COPY_SCORE_REWARD,AllScore),
	% {30000,100,100,100,3}
	?MSG_ECHO("-------------------~w~n",[{HitsScore,TimeScore,CaromScore,KillScore,Eva}]),
	{HitsScore,TimeScore,CaromScore,KillScore,Eva}.

copy_get_score(ScoreId,?CONST_COPY_SCORE_HITS,Hits) ->
	Levels = data_copy_score:gets_unscatch(),
	case copy_get_score_acc(ScoreId,?CONST_COPY_SCORE_HITS,Hits,Levels) of
		Num when Num > 0 ->
			Num;
		_ ->
			Level = lists:min(Levels),
			case data_copy_score:get(ScoreId, ?CONST_COPY_SCORE_HITS, Level) of
				#d_copy_score{value=Value} ->
					Value;
				_ ->
					0
			end
	end;
copy_get_score(ScoreId,?CONST_COPY_SCORE_TIME,Time) ->
	Levels = data_copy_score:gets_time(),
	case copy_get_score_acc(ScoreId,?CONST_COPY_SCORE_TIME,Time,Levels) of
		Num when Num > 0 ->
			Num;
		_ ->
			Level = lists:min(Levels),
			case data_copy_score:get(ScoreId, ?CONST_COPY_SCORE_TIME, Level) of
				#d_copy_score{value=Value} ->
					Value;
				_ ->
					0
			end
	end;
copy_get_score(ScoreId,?CONST_COPY_SCORE_CAROM,Caroms) ->
	Levels = data_copy_score:gets_combo(),
	case copy_get_score_acc(ScoreId,?CONST_COPY_SCORE_CAROM,Caroms,Levels) of
		Num when Num > 0 ->
			Num;
		_ ->
			Level = lists:min(Levels),
			case data_copy_score:get(ScoreId, ?CONST_COPY_SCORE_CAROM, Level) of
				#d_copy_score{value=Value} ->
					Value;
				_ ->
					0
			end
	end;
copy_get_score(ScoreId,?CONST_COPY_SCORE_KILL,Kills) ->
	Levels = data_copy_score:gets_kill(),
	case copy_get_score_acc(ScoreId,?CONST_COPY_SCORE_KILL,Kills,Levels) of
		Num when Num > 0 ->
			Num;
		_ ->
			Level = lists:min(Levels),
			case data_copy_score:get(ScoreId, ?CONST_COPY_SCORE_KILL, Level) of
				#d_copy_score{value=Value} ->
					Value;
				_ ->
					0
			end
	end;
copy_get_score(ScoreId,?CONST_COPY_SCORE_REWARD,AllScore) ->
	Levels = data_copy_score:gets_score(),
	case copy_get_score_acc(ScoreId,?CONST_COPY_SCORE_REWARD,AllScore,Levels) of
		Num when Num > 0 ->
			Num;
		_ ->
			Level = lists:min(Levels),
			case data_copy_score:get(ScoreId, ?CONST_COPY_SCORE_REWARD, Level) of
				#d_copy_score{value=Value} ->
					Value;
				_ ->
					0
			end
	end.

%% copy_get_score_acc(_ScoreId,Type,_Value,[]) when Type =:= ?CONST_COPY_SCORE_REWARD ->
%% 	1;
copy_get_score_acc(_ScoreId,_Type,_Value,[]) ->
	0;
copy_get_score_acc(ScoreId,Type,Value,[Level|Levels]) ->
	case data_copy_score:get(ScoreId,Type, Level) of
		#d_copy_score{start_score=StartScore,end_score=EndScore,value=Dvalue} ->
			case Value >= StartScore andalso Value =< EndScore of
				?true ->
					Dvalue;
				_ ->
					copy_get_score_acc(ScoreId,Type,Value,Levels)
			end;
		_ ->
			copy_get_score_acc(ScoreId,Type,Value,Levels)
	end.

check_boss(MonsId) ->
	case data_scene_monster:get(MonsId) of
		#d_monster{steps=1} ->
			?true;
		_ ->
			?false
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
copy_monster_addhp(?CONST_TRUE, Maps, Counts) ->
	AddHp = 
		case Counts of
			1 ->
				?CONST_COPY_HP_UP_ONE;
			2 ->
				?CONST_COPY_HP_UP_TWO;
			3 ->
				?CONST_COPY_HP_UP_THREE;
			_ ->
				?CONST_COPY_HP_UP_ONE
		end,
	copy_monster_addhp_acc(Maps, AddHp);
copy_monster_addhp(_IsTeam, Maps, _Counts) ->
	Maps.

copy_monster_addhp_acc(Maps1, AddHp) ->
	Maps2 = tuple_to_list(Maps1),
	Fun = fun(#map{monsters=Monsters1,monsters_all=MonsterAll1}=Map, AccMap) ->
				  Monsters	= copy_monster_addhp_monsters(Monsters1, AddHp, []),
				  MonsterAll= copy_monster_addhp_all(MonsterAll1, AddHp, []),
				  AccMap ++ [Map#map{monsters=Monsters,monsters_all=MonsterAll}]
		  end,
	Maps3 = lists:foldl(Fun, [], Maps2),
	list_to_tuple(Maps3).

copy_monster_addhp_monsters([Monster1|Monsters], AddHp, AccMonster) ->
	MonsterHp	= round(Monster1#monster.hp * AddHp),
	MonsterHpMax= round(Monster1#monster.hp_max * AddHp),
	Monster		= Monster1#monster{hp=MonsterHp,hp_max=MonsterHpMax},
	copy_monster_addhp_monsters(Monsters, AddHp, [Monster|AccMonster]);
copy_monster_addhp_monsters([], _AddHp, AccMonster) ->
	AccMonster.

copy_monster_addhp_all([{Slx,Srx,Srex,Smonsters1,Sgives}|MonsterAlls], AddHp, AccMonsterAll) ->
	Smonsters = copy_monster_addhp_monsters(Smonsters1, AddHp, []),
	copy_monster_addhp_all(MonsterAlls, AddHp, AccMonsterAll ++ [{Slx,Srx,Srex,Smonsters,Sgives}]);
copy_monster_addhp_all([], _AddHp, AccMonsterAll) ->
	AccMonsterAll.
	
%% 开始副本
start_handle(#copy{id=CopyId,details=Maps1,gate_now=GateNow,is_team=IsTeam}=Copy, PlayerS) ->
	Maps= copy_monster_addhp(IsTeam, Maps1, length(PlayerS)),
	[#player_s{country=Country}|_] = PlayerS,
	Map = element(GateNow, Maps),
	#map{map_id=MapId,type=MapType} = Map,
	{X,Y}	= scene_api:ext_find_map_bornxy(MapId,Country),
	Map1 	= start_handle(PlayerS, Map, X, Y,IsTeam),
	Maps2	= setelement(GateNow, Maps, Map1),
	Copy2 	= Copy#copy{details=Maps2},
	
	SPid	= self(),
	Reply	= {CopyId, X, Y, MapId, SPid, MapType},
	{reply, Reply, Copy2}.

start_handle(PlayerSList, #map{map_id=MapId,pass_type=PassType,pass_value=PassValue,time=SceneTime}=Map, X, Y,_IsTeam) ->
	Stime = round(PassValue-SceneTime),
	Bin7060 =
		case PassType of
			?CONST_COPY_PASS_ALIVE ->
				copy_api:msg_scene_time(Stime);
			?CONST_COPY_PASS_TIME ->
				copy_api:msg_scene_time(Stime);
			_ ->
				<<>>
		end,
	F = fun(#player_s{socket=Socket,uid=Uid,partners=Partners,team_id=TeamId}=PlayerS) ->
				Uids	= get_copy_uidlist(),
				Uids2= case lists:member(Uid, Uids) of
								  ?true ->
									  Uids;
								  _ ->
									  [Uid|Uids]
				  			end,
				put(user_id_list, Uids2),
				PlayerSNew = PlayerS#player_s{pos_x 		= X, 		pos_y		= Y,
											  begin_x 		= X, 		begin_y		= Y,
											  pos_pixel_x 	= X * ?CONST_MAP_MAP_TILE_PIXEL,
											  pos_pixel_y 	= Y * ?CONST_MAP_MAP_TILE_PIXEL,
											  walk			= ?CONST_FALSE,
											  distance		= 0,
											  distance2 	= 0},
				BinPartners = scene_api:msg_partner_data(Uid, Partners,TeamId),
				ets:insert(?ETS_MAP_PLAYER, PlayerSNew),
				%% (5025)地图玩家数据（把本人的数据发送给别的玩家）
				BinMsg5025	= scene_api:msg_role_data(PlayerSNew, ?CONST_MAP_ENTER_NULL),
				%% (5015)进入场景（把本人的数据发送给自己）
				EnterType = ?CONST_MAP_ENTER_COPY,
				BinMsg5015	= scene_api:msg_enter_ok(PlayerSNew, MapId, EnterType),
				
				BinPlayersN = scene_mod:player_list_new([PlayerSNew]),
				BinPartnersN= scene_mod:partner_list_new([PlayerSNew],Map#map.type),
				
				
				app_msg:send(Socket, <<BinMsg5015/binary,Bin7060/binary>>),
				do_broadcast(Uids2, <<BinMsg5025/binary,BinPartners/binary,BinPlayersN/binary,BinPartnersN/binary>>)
		end,
	lists:foreach(F, PlayerSList),
	OverUids = get_copy_uidlist(),
	Map#map{counter=length(OverUids)}.

switch_in_handle(#copy{gate_now=GateNow,state=State,details=Maps,is_team=IsTeam}=Copy) ->
	case State of
		?CONST_COPY_STATE_PAUSE ->
			GateNew	= GateNow + 1,
			Map 		= element(GateNew, Maps),
			SPid		= self(),
			PlayerSList = get_copy_players(),
			[PlayerS|_] = PlayerSList,
			Country	= PlayerS#player_s.country,
			#map{map_id=MapId,type=MapType} = Map,
			{X,Y}	= scene_api:ext_find_map_bornxy(MapId, Country),
			
			Map2 	= switch_in_handle(PlayerSList, Map, X, Y,IsTeam),
			Maps2	= setelement(GateNew, Maps, Map2),
			Copy2 	= Copy#copy{details=Maps2, state=?CONST_COPY_STATE_PLAY, gate_now=GateNew},
			
			Reply	= {X, Y, MapId, SPid, MapType},
			{Reply, Copy2};
		_ ->% 当前场景目标未完成
			Reply		= {?error, ?ERROR_COPY_NOT_COMPLETE},
			Copy2		= Copy
	end,
	{reply, Reply, Copy2}.

switch_in_handle(PlayerSList, Map=#map{map_id=MapId,pass_type=PassType,pass_value=PassValue,time=SceneTime}, X, Y,_IsTeam) ->
	Stime = round(PassValue-SceneTime),
	Bin7060 =
		case PassType of
			?CONST_COPY_PASS_ALIVE ->
				copy_api:msg_scene_time(Stime);
			?CONST_COPY_PASS_TIME ->
				copy_api:msg_scene_time(Stime);
			_ ->
				<<>>
		end,
	F = fun(#player_s{socket=Socket,uid=Uid,partners=Partners,team_id=TeamId}=PlayerS) ->
				Uids = get_copy_uidlist(),
				Uids2= case lists:member(Uid, Uids) of
							?true ->
								Uids;
							_ ->
								[Uid|Uids]
						end,
				put(user_id_list, Uids2),
				PlayerSNew = PlayerS#player_s{pos_x 		= X, 		pos_y		= Y,
											  begin_x 		= X, 		begin_y		= Y,
											  pos_pixel_x 	= X * ?CONST_MAP_MAP_TILE_PIXEL,
											  pos_pixel_y 	= Y * ?CONST_MAP_MAP_TILE_PIXEL,
											  walk			= ?CONST_FALSE,
											  distance		= 0,
											  distance2 	= 0},
				BinPartners = scene_api:msg_partner_data(Uid, Partners,TeamId),
				ets:insert(?ETS_MAP_PLAYER, PlayerSNew),
				BinMsg5025	= scene_api:msg_role_data(PlayerSNew, ?CONST_MAP_ENTER_NULL),
				EnterType = ?CONST_MAP_ENTER_COPY,
				BinMsg5015	= scene_api:msg_enter_ok(PlayerSNew, MapId, EnterType),
				
				BinPlayersN = scene_mod:player_list_new([PlayerSNew]),
				BinPartnersN= scene_mod:partner_list_new([PlayerSNew],Map#map.type),
				
				app_msg:send(Socket, <<BinMsg5015/binary,Bin7060/binary>>),
				do_broadcast(Uids2,<<BinMsg5025/binary,BinPartners/binary,BinPlayersN/binary,BinPartnersN/binary>>)
		end,
	lists:foreach(F, PlayerSList),
	OverUids = get_copy_uidlist(),
	Map#map{counter=length(OverUids)}.

%% 把怪物组从永久列表移到临时列表
move_monster_handle(#copy{details=Maps,gate_now=GateNow}=State,MGid) ->
	Map	 = element(GateNow,Maps),
	Map2 = scene_mod:move_monster(Map,MGid),
	Maps2= setelement(GateNow,Maps,Map2),
	State#copy{details = Maps2}. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 副本重起，把副本中的玩家pid都更新一次 
update_pid(#copy{gate_now=GateNow, details=Details}) ->
	Map 	= element(GateNow, Details),
	PlayerS	= get_copy_players(),
	update_pid(PlayerS, Map#map.map_id, Map#map.pid).

update_pid([PlayerS|Players], MapId, Pid) ->
	util:pid_send(PlayerS#player_s.mpid, ?MODULE, update_pid_cb, {MapId, Pid}),
	update_pid(Players, MapId, Pid);
update_pid([], _MapId, _Pid) ->
	?ok.

update_pid_cb(#player{team_id=TeamId,info=Info}=Player, {MapId, Pid}) ->
	case TeamId of
		0 ->
			?ok;
		_ ->
			team_api:scene_set(TeamId, MapId, Pid)
	end,
	Info2 = Info#info{map_id=MapId},
	Player#player{spid=Pid,info=Info2}.

move_handle(Uid, Type,MoveType,PosX, PosY,OwnerUid) ->
	scene_api:ext_move_handle(Uid, Type, MoveType, PosX, PosY, OwnerUid).

move_new_handle(Uid, Type,MoveType,PosX, PosY,OwnerUid) ->
	scene_api:ext_move_new_handle(Uid, Type, MoveType, PosX, PosY, OwnerUid).

%% 请求副本怪物数据
monster_list_handle(#copy{id=_CopyId,details=Maps,gate_now=GateNow,is_team=IsTeam},Uid) ->
	#map{screen_now=Snow,monsters=Monsters} = element(GateNow, Maps),
	case IsTeam of
		?CONST_TRUE ->
			BinMsg = scene_api:msg_idx_monster(Snow,Monsters),
			player_send_msg(Uid, BinMsg);
		_ ->
			?skip
	end.

monster_knock_handle(#copy{details=Maps,gate_now=GateNow} = Copy, Gmid, Gid) ->
	Map = element(GateNow, Maps),
	Map1= scene_api:ext_monster_knock_handle(Map, Gmid, Gid),
	Maps2 = setelement(GateNow, Maps, Map1),
	Copy#copy{details=Maps2}.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 广播场景中角色等级改变
change_level_handle(#copy{details=Maps,gate_now=GateNow}=Copy, Uid, Level) ->
	Map 	= element(GateNow, Maps),
	Map2 	= scene_api:ext_change_level_handle(Map, Uid, Level),
	Maps2	= setelement(GateNow, Maps, Map2),
	Copy#copy{details=Maps2}.

change_clan_handle(Copy=#copy{details=Maps,gate_now=GateNow}, Uid, ClanId, ClanName) ->
	Map 	= element(GateNow, Maps),
	Map2 	= scene_mod:change_clan_handle(Map, Uid, ClanId,ClanName),
	Maps2	= setelement(GateNow, Maps, Map2),
	Copy#copy{details = Maps2}.

%% 广播场景中角色组队队长状态改变
change_team_leader_handle(NewLeaderUid, OldLeaderUid) ->
	scene_api:ext_change_team_leader_handle(NewLeaderUid, OldLeaderUid).

%% 广播场景中角色的坐骑
change_mount_handle(#copy{details=Maps,gate_now=GateNow}=Copy, Uid, Mount, Speed) ->
	Map 	= element(GateNow, Maps),
	Map2 	= scene_api:ext_change_mount_handle(Map, Uid, Mount, Speed),
	Maps2	= setelement(GateNow, Maps, Map2),
	Copy#copy{details = Maps2}.

change_war_state_handle(#copy{details=Maps,gate_now=GateNow}=Copy,UidAndState) ->
	Map 	= element(GateNow, Maps),
	Map2 	= scene_api:ext_change_war_state_handle(Map, UidAndState),
	Maps2	= setelement(GateNow, Maps, Map2),
	Copy#copy{details = Maps2}.

set_posxy_handle(#copy{details=Maps,gate_now=GateNow}=Copy,Sid,Uid,X,Y,Mtype) ->
	Map 	= element(GateNow, Maps),
	Map2	= scene_mod:set_posxy(Map,Sid,Uid,X,Y,Mtype),
	Maps2	= setelement(GateNow, Maps, Map2),
	Copy#copy{details = Maps2}.

%% 退出副本回调函数
exit_handle(Uid, #copy{gate_now=GateNow,details=Maps}=Copy) ->
	Map 	= element(GateNow, Maps),
	Uids2	= get_copy_uidlist(),
	Uids	= 
		case lists:member(Uid,Uids2) of
			?true ->
				lists:delete(Uid,Uids2);
			_ ->
				Uids2
		end,
	put(user_id_list,Uids),
	Map2 	= Map#map{counter=length(Uids)},
	BinMsg	= scene_api:msg_out(Uid,?CONST_PLAYER,?CONST_MAP_OUT_NULL,0),
	BinPar =
		case get_player(Uid) of
			#player_s{partners=Partners} ->
				?MSG_ECHO("------------------~w~n",[Partners]),
				scene_api:msg_out(Partners,?CONST_PARTNER,?CONST_MAP_OUT_NULL,Uid,<<>>);
			_ ->
				<<>>
		end,
	do_broadcast(Uids, <<BinMsg/binary,BinPar/binary>>),
	Maps2	= setelement(GateNow, Maps, Map2),
	Copy2	= Copy#copy{details=Maps2},
	case Uids of
		[] ->
			{?stop,?normal,Copy2};
		_ ->
			{?noreply,Copy2}
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
copy_over_update(#copy{id=CopyId,type=CopyType,time_life=Time,details=Maps,use_energy=UseEnergy,score_id=ScoreId}) ->
	MapsList = tuple_to_list(Maps),
	AllMonsHp = get_copy_monster_hp(MapsList),
	Uids = get_copy_uidlist(),
	Fun	= fun(Uid) ->
				  case get_player(Uid) of
					  #player_s{mpid=Mpid} ->
						  {Hits,Caroms,MonsHp} = get_copy_alltimes(Uid,MapsList),
						  Kills = round((MonsHp/AllMonsHp)*?CONST_PERCENT),
						  {HitsScore,TimeScore,CaromScore,KillScore,Eva} = copy_get_score(ScoreId,Hits,Time,Caroms,Kills),
						  util:pid_send(Mpid,?MODULE,copy_over_update_cb,{CopyId,CopyType,HitsScore,TimeScore,CaromScore,KillScore,Eva,UseEnergy}),
						  case CopyType of
							  ?CONST_COPY_TYPE_NORMAL ->
								  util:pid_send(Mpid,?MODULE,copy_state_change_cb,{CopyId,Eva});
							  ?CONST_COPY_TYPE_HERO ->
								  util:pid_send(Mpid,hero_api,copy_state_change_cb,{CopyId,Eva});
							  ?CONST_COPY_TYPE_FIEND ->
								  util:pid_send(Mpid,fiend_api,copy_state_change_cb,{CopyId,Eva});
							  ?CONST_COPY_TYPE_FIGHTERS ->
								  util:pid_send(Mpid,fighters_api,copy_state_change_cb,CopyId);
							  _ ->
								  ?skip
						  end,
%% 						  ?MSG_ECHO("======================~w~n",[{Hits,Caroms,MonsHp}]),
						  task_daily_api:check_cast(Mpid,?CONST_TASK_DAILY_REFRESH_COPY, CopyId), 
						  task_daily_api:check_cast(Mpid,?CONST_TASK_DAILY_LINK_COPYS, CopyId, Caroms), 
						  task_api:check_cast(Mpid,?CONST_TASK_TARGET_COPY, CopyId);
					  _ ->
						  ?skip
				  end
		  end,
	lists:foreach(Fun, Uids).

copy_over_update_cb(#player{socket=Socket,uid=Uid}=Player,{CopyId,CopyType,HitsScore,TimeScore,CaromScore,KillScore,Eva,UseEnergy}) ->
	%?MSG_ECHO("----------------------~w~n",[{CopyId,CopyType,HitsScore,TimeScore,CaromScore,KillScore,Eva,UseEnergy}]),
	stat_api:logs_copy(Uid,CopyId,util:seconds(),?CONST_TRUE,CopyType),
	case data_copy_reward:get(CopyId) of
		Dreward when is_record(Dreward,d_copy_reward) ->
			{Exp,Gold,Power,Goods} = get_copy_egg(Dreward,Eva),
			Player2	= role_api:exp_add(Player, Exp,copy_over_update_cb,<<"副本奖励:",(util:to_binary(CopyId))/binary>>),
			{Player3,Bin1} = role_api:currency_add([copy_over_update_cb,[],<<"副本奖励">>],Player2,[{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_ADV_SKILL,Power}]),
			Bag = role_api_dict:bag_get(),
			{Player5,Bag2,Bin2} =
				case bag_api:goods_set([copy_over_update_cb,[],<<"副本奖励">>],Player3,Bag,Goods) of
					{?ok,Player4,BagTmp,GoodsBin,BinTmp} ->
						{Player4,BagTmp,<<GoodsBin/binary,BinTmp/binary>>};
					{?error,ErrorCode} ->
						BinTmp	= system_api:msg_error(ErrorCode),
						{Player3,Bag,BinTmp}
				end,
			role_api_dict:bag_set(Bag2),
			{Player6,Bin4} =
				case energy_api:energy_use([copy_over_update_cb,UseEnergy,<<"副本通关消耗">>], Player5, UseEnergy) of
					{?ok,EnergyPlayer,EnergyBin} ->
						{EnergyPlayer,EnergyBin};
					{?error,ErrorCode1} ->
						{Player5,system_api:msg_error(ErrorCode1)}
				end,
			Bin3 = copy_api:msg_over(CopyId,CopyType,HitsScore,TimeScore,CaromScore,KillScore,Eva,Exp,Gold,Power,Goods),
			app_msg:send(Socket, <<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary>>),
			Player6;
		_ ->
			BinMsg = copy_api:msg_over(CopyId,CopyType,HitsScore,TimeScore,CaromScore,KillScore,Eva,0,0,0,[]),
			app_msg:send(Socket, BinMsg),
			Player
	end.

get_copy_egg(#d_copy_reward{a_exp=Aexp,a_money=Agold,a_goods=Agoods,a_power=Apower,b_exp=Bexp,
							b_money=Bgold,b_goods=Bgoods,b_power=Bpower,c_exp=Cexp,c_money=Cgold,
							c_goods=Cgoods,c_power=Cpower},Eva) ->
	case Eva of
		?CONST_COPY_EVA_A ->
			{Aexp,Agold,Apower,get_goods(Agoods)};
		?CONST_COPY_EVA_B ->
			{Bexp,Bgold,Bpower,get_goods(Bgoods)};
		?CONST_COPY_EVA_C ->
			{Cexp,Cgold,Cpower,get_goods(Cgoods)};
		_ ->
			{0,0,0,[]}
	end.

get_goods(Goods) ->
	Fun = fun({GoodsId,GoodsCount,Odds},AccGoods) ->
				  case util:rand_odds(Odds, ?CONST_PERCENT) of
					  ?true ->
						  [{GoodsId,GoodsCount}|AccGoods];
					  _ ->
						  AccGoods
				  end
		  end,
	lists:foldl(Fun, [], Goods).

get_copy_alltimes(Uid,Maps) ->
	Fun = fun(Wars,{AccHit,AccCarom,AccMonsHp}) ->
				  case lists:keyfind(Uid, #war_s.uid, Wars) of
					  #war_s{hit_times=HitTimes,carom_times=CaromTimes,monster_hp=MonsterHp} ->
						  {AccHit+HitTimes,AccCarom+CaromTimes,AccMonsHp+MonsterHp};
					  _ ->
						  {AccHit,AccCarom,AccMonsHp}
				  end
		  end,
	MapWars = [Map#map.war_s || Map <- Maps],
	lists:foldl(Fun, {0,0,0}, MapWars).

copy_state_change_cb(Player,{CopyId,Eva}) ->
	ChapCopy = role_api_dict:copy_get(),
	#chapcopy{copys=Save} = ChapCopy,
	NewSave =
		case lists:keytake(CopyId, #copysave.id, Save) of
			{value,CopyS,Tmp} ->
				NewEva = ?IF(Eva > CopyS#copysave.evaluation, Eva, CopyS#copysave.evaluation),
				[CopyS#copysave{is_pass=?CONST_TRUE,evaluation=NewEva} | Tmp];
			_ ->
				Save
		end,
	role_api_dict:copy_set(ChapCopy#chapcopy{copys=NewSave}),
	Player.

%% 副本场景广播
do_broadcast(Uids, BinMsg) ->
	scene_api:ext_broadcast_handle(Uids, BinMsg).

reward_copy_gm(#player{socket = Socket} = Player,CopyId,?CONST_COPY_EVA_B) ->
	case data_copy_reward:get(CopyId) of
		Dreward when is_record(Dreward,d_copy_reward) ->
			{Exp,Gold,Power,Goods} = get_copy_egg(Dreward,?CONST_COPY_EVA_B),
			?MSG_ECHO("======~w~n",[{Exp,Gold,Power,Goods}]),
			Player2	= role_api:exp_add(Player, Exp,copy_over_update_cb,<<"副本奖励:",(util:to_binary(CopyId))/binary>>),
			?MSG_ECHO("======~w~n",[(Player2#player.info)#info.exp]),
			{Player3,Bin1} = role_api:currency_add([copy_over_update_cb,[],<<"副本奖励">>],Player2,[{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_ADV_SKILL,Power}]),
			Bag = role_api_dict:bag_get(),
			{Player5,Bag2,Bin2} =
				case bag_api:goods_set([copy_over_update_cb,[],<<"副本奖励">>],Player3,Bag,Goods) of
					{?ok,Player4,BagTmp,GoodsBin,BinTmp} ->
						{Player4,BagTmp,<<GoodsBin/binary,BinTmp/binary>>};
					{?error,ErrorCode} ->
						BinTmp	= system_api:msg_error(ErrorCode),
						{Player3,Bag,BinTmp}
				end,
			
			role_api_dict:bag_set(Bag2),
%% 			Bin3 = copy_api:msg_over(CopyId,CopyType,HitsScore,TimeScore,CaromScore,KillScore,Eva,Exp,Gold,Power,Goods),
			app_msg:send(Socket, <<Bin1/binary,Bin2/binary>>),
			Player5;
		_ ->
%% 			BinMsg = copy_api:msg_over(CopyId,CopyType,HitsScore,TimeScore,CaromScore,KillScore,Eva,0,0,0,[]),
%% 			app_msg:send(Socket, BinMsg),
			Player
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 初始化副本数据
init_copy_data(CopyId) ->
	CopyData= data_scene_copy:get(CopyId),
	Copy = record_copy(CopyData),
	Copy.

record_copy(#d_copy{scene=SceneList,copy_id=CopyId,time=Time,use_energy=UseEnergy,copy_type=CopyType,
					score_id=ScoreId,relive_lim=ReTimes}) ->
	Details = list_to_tuple([record_c_detail(X) || X <- SceneList]),
	Gate = tuple_size(Details),
	#copy{
		  	id			= CopyId,			% 副本Id
		  	details		= Details,			% 副本细节
			type		= CopyType,			% 副本类型
			relive_lim	= ReTimes,			% 可以复活次数
			use_energy	= UseEnergy,		% 通关消耗体力
			time_copy	= Time,				% 副本规定时间(单机时,如果副本生存时间小于这个值,则有作弊)
			score_id	= ScoreId,			% 评分Id
		  	gate		= Gate,				% 关卡数量
		  	gate_now	= 1,				% 当前关卡数
		  	gate_over	= 0 				% 当前完成关卡数
		 }.

%% 场景ID
record_c_detail(SceneId) ->
	#d_scene{scene_id=MapId,scene_type=MapType,monsters=Dmonsters,pass_type=Ptype,pass_value=Pvalue,collect=Dcollect}= data_scene:scene(SceneId),
	Map = scene_api:ext_init_map(MapId,MapType,Dmonsters,Dcollect),
	Map#map{pass_type=Ptype,pass_value=Pvalue}.