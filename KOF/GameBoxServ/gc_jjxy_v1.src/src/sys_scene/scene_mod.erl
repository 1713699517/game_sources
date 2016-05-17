%% Author: Administrator
%% Created: 2011-8-8
%% Description: TODO: Add description to scenes_mod
-module(scene_mod).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
-export([init_map_srv/2,
		 init_ets_map/4,
		 
		 interval_handle/3,
		 record_player_s/1,
		 record_monster_s/2,
		 get_player/1,
		 do_broadcast/1,
		 do_broadcast/2,
		 do_broadcast_handle/2,
		 
		 
		 player_list_new/1,
		 partner_list_new/2,
		 
		 delete_map_data/1,
		 find_map_bornxy/2,
		 players_set/2,
		 update_spid/1, 
		 update_spid_cb/2,
		 
		 move_monster/2,
		 war_over_refresh_monster_handle/2,
		 war_harm_handle/3,
		 enter_city_handle/0,
		 replace_gmonster/2,
		 
		 enter_cast_handle/4, 
		 exit_handle/2,
		 move_handle/6,
		 move_new_handle/6,
		 move_handle_cb/2,
		 get_map_uidlist/0,
		 
		 change_war_state_handle/2,
		 
		 player_list_handle/2,
		 player_list_new_handle/2,
		 find_map_info_handle/2,
		 monster_list_handle/2,
		 monster_knock_handle/3,
		 monster_list_all_handle/2,
		 del_player_handle/3,
		 get_player_handle/0,
		 broadcast_lose_handle/1,
		 
		 add_monster_handle/2,
		 
		 change_clan_handle/4,
		 change_level_handle/3,
		 change_vip_handle/3,
		 change_team_leader_handle/2,
		 change_mount_handle/4
		]).

%% 初始化地图
init_map_srv(MapId, Suffix) -> 
	Pid = self(),
	% 根据地图id和地图后缀找地图进程
	MS = [{'$1',[{'andalso',{'=:=',{element,3,'$1'},{const,MapId}},
				  {'=:=',{element,4,'$1'},{const,Suffix}}}],['$1']}],
	case ets:select(?ETS_SCENE, MS) of
		[] ->
			#d_scene{scene_id=MapId,scene_type=Type,monsters=Dmonsters,collect=Collect} = data_scene:scene(MapId),
			Monsters = 
				case Type of
					10 ->%?CONST_MAP_TYPE_BOSS
						[];
					_ ->
						Dmonsters
				end,
			Map	= init_ets_map(MapId,Type,Monsters,Collect), 
			Map2= Map#map{pid=Pid,suffix=Suffix},
			ets:insert(?ETS_SCENE, Map2);
		[Map|_] ->
			Map2 = Map#map{pid=Pid, suffix=Suffix},
			case Map#map.pid of
				?null ->
					?ok;
				0 ->
					?ok;
				PidOld
				  -> ets:delete(?ETS_SCENE, PidOld)
			end,
			ets:insert(?ETS_SCENE, Map2)
	end,
	put(user_id_list, []),
	{?ok, Map2}.

init_ets_map(MapId,Type,Monsters,Collect) ->
	Map = #map{map_id=MapId,type=Type},
	Map1= init_ets_map_monster(Map,Monsters),
	Map2= init_ets_map_collect(Map1,Collect),
	Map2.
%  左边X,	   右边X,   复活点X                    怪物列表                           物品奖励列表 
% [{0,     1200,    0,       [{101,0,1,79,96},{101,0,1,11,65},{101,0,1,38,29}],  []}
init_ets_map_monster(Map,[]) ->
	Map;
init_ets_map_monster(#map{map_id=MapId}=Map,Dmonsters) ->
	AllMonsters = [{Lx,Rx,Rbx,record_monster_s(Mons,MapId),Gives}|| {Lx,Rx,Rbx,Mons,Gives} <- Dmonsters],
	ScreenSum = length(AllMonsters),
	ScreenNow = 1,
	% ?MSG_ECHO("-------------------~w~n",[{ScreenSum,AllMonsters}]),
	{Slx,Srx,Srex,Smonsters,Sgives} = lists:nth(ScreenNow, AllMonsters),
	Map#map{screen_sum=ScreenSum,screen_now=ScreenNow,monsters=Smonsters,lx=Slx,rx=Srx,reborn_x=Srex,
			screen_gives=Sgives,monsters_all=AllMonsters}.

%% init_ets_map_monster(#map{map_id=MapId}=Map,Monster_gs) ->
%% 	Monster_s = record_monster_s(Monster_gs,MapId),
%% 	Map#map{monsters=Monster_s}.

init_ets_map_collect(Map,Collect) ->
	init_ets_map_collect(Map,Collect,[]).

init_ets_map_collect(Map,[],Acc) ->
	Map#map{collect = Acc};
init_ets_map_collect(Map,[{CollectId,X,Y,Time,Interval,Sum} | CollectLists],Acc) ->
	CollectMid 	= idx_api:monster_mid(),
	init_ets_map_collect(Map,CollectLists,[{CollectMid,CollectId,X,Y,Time,Interval,Sum} | Acc]).

record_monster_s(MonsterS,MapId) ->
	record_monster_gs(MonsterS,MapId,[]).

record_monster_gs([],_MapId,Acc) ->
	Acc;
record_monster_gs([{MonsterId,Interval,Sum,X,Y} | MonstersList],MapId,Acc)->
	case monster_api:make(MonsterId, MapId) of
		{MonsterMid,MakeMonsterId,Hp,AiId,MonsterType,Delay,Steps} ->
			Monster = #monster{
								   monster_mid	= MonsterMid,		% 怪物生成id
								   monster_id	= MakeMonsterId,	% 怪物Id
								   monster_type	= MonsterType,		% 怪物类型
								   scene_id		= MapId,			% 怪物所在场景id
								   ai_id		= AiId,				% 怪物Ai
								   delay		= Delay,			% 副本AI延迟时间
								   
								   
								   steps		= Steps,			% 怪物等阶
								   hp			= Hp,				% 当前血量
								   hp_max		= Hp,				% 最大血量
								   origin_x		= X,				% X原点
								   origin_y		= Y,				% Y原点
								   interval		= Interval,			% 怪物 刷新间隔
								   sum      	= Sum				% 怪物 刷新总数
								  },
			record_monster_gs(MonstersList,MapId,[Monster | Acc]);
		_ ->
			record_monster_gs(MonstersList,MapId,Acc)
	end.
			
%% 地图重起，把地图上的玩家spid都更新一次 
update_spid(#map{map_id=MapId,pid=Pid}) ->
	Players = get_map_players(), 
	update_spid(Players, MapId, Pid).

update_spid([], _MapId, _SPid) ->
	?ok;
update_spid([#player_s{mpid=Mpid}|Players], MapId, SPid) ->
	util:pid_send(Mpid, ?MODULE, update_spid_cb, {MapId, SPid}),
	update_spid(Players, MapId, SPid).

update_spid_cb(#player{info=Info}=Player, {MapId, SPid}) ->
	Info2 = Info#info{map_id=MapId},
	Player#player{spid=SPid,info=Info2}.

%% 更新地图数据
update_map_data(Map) ->
	ets:insert(?ETS_SCENE,Map).

%% 更新地图玩家数据
update_map_player(Mplayer) ->
	ets:insert(?ETS_MAP_PLAYER,Mplayer).

%% 删除地图进程
delete_map_data(Mpid) ->
	?TRY_FAST(ets:delete(?ETS_SCENE,Mpid),?skip).

%% 获取地图玩家列表
get_map_players() ->
	Uids = get_map_uidlist(),
	Fun = fun(Uid,Acc) ->
				  case get_player(Uid) of
					  PlayerS when is_record(PlayerS,player_s) ->
						  [PlayerS | Acc];
					  _ ->
						  Acc
				  end
		  end,
	lists:foldl(Fun, [], Uids).

%% 获取地图玩家Uid列表
get_map_uidlist() ->
	case get(user_id_list) of
		?undefined ->
			[];
		R ->
			R
	end.

%% 获取地图单个玩家信息
get_player(Uid) ->
	case ets:lookup(?ETS_MAP_PLAYER,Uid) of
		[Player] ->
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 定时
interval_handle(Map,Flag,Ctime)->
	case Map#map.type of
		?CONST_MAP_TYPE_CITY ->
			iterval_map_check2(Map, ?CONST_MAP_MAP_TIME_SLOT);
		_ ->
			% 怪物刷新
			Map2 = interval_monster_refresh(Map),
			Map3 = interval_ai(Map2,Flag,Ctime),
			% 定时地图关闭 
			interval_map_check(Map3)
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
interval_ai(Map=#map{map_id=MapId,type=MapType,monsters=Monsters},Flag,Ctime)->
	case data_scene:scene(MapId) of
		#d_scene{material_id=MaterialId}->
			case data_scene:material(MaterialId) of
				#d_material{move_height=ImageHeight,tile_width=ImageWidth}->
					ImageWidth2=round(ImageWidth),
					Fun=fun(Monster,MonsterList)->
								Monster2=monster_ai(Monster,ImageHeight,ImageWidth2,MapType,Flag,Ctime),
								[Monster2|MonsterList]
						end,
					Monsters2=lists:foldl(Fun,[],Monsters),
					Map#map{monsters=Monsters2};
				_->
					Map
			end;
		_->
			Map
	end.

%% 怪物行为
monster_ai(Monster=#monster{pos_x=PosX,pos_y=PosY},ImageHeight,ImageWidth,MapType,Flag,Ctime)->
	Time=util:seconds(),
	#monster{ai_id=AiId,attack_interval=AttTime,delay=Delay,knock_down=KnockDown}=Monster,
	case Time-Ctime >Delay of
		?true->
			case data_battle_ai:get(AiId) of
				#d_battle_ai{attack_interval=AttackInterval,rand_type=RandType,rand_x=RandX,
							 rand_y=RandY,attack_skill=AttackSkill,get_up_skill=GetUpSkill,
							 get_up_rand=GetUpRand}->
					case KnockDown of
						?true->
							monster_get_up(Monster,GetUpSkill,GetUpRand);
						_->
							Time=util:seconds(),
							%% 1.找目标
							case PlayerSList=get_map_players() of
								[]->
									Monster;
								_->
									PxyS=[{MPosX,MPosY}||#player_s{pos_x=MPosX,pos_y=MPosY}<-PlayerSList],
									PxyS2=[{(PosX-X)*(PosX-X)+(PosY-Y)*(PosY-Y),X,Y}||{X,Y}<-PxyS],
									{_,NewX,NewY}=lists:min(PxyS2),
									case Time-AttTime>=AttackInterval of
										?true->
											case monster_skill(AttackSkill,Monster,NewX,NewY,ImageHeight,ImageWidth) of
												{?false,Monster2}->
													Monster2;
												Monster2->
													Monster2#monster{attack_interval=Time}
											end;
										_->
											ImageHeight2=util:rand(?IF(PosX-RandX=<0,0,PosX-RandX),PosX+RandX),
											ImageWidth2 =util:rand(?IF(PosY-RandY=<0,0,PosY-RandY),PosY+RandY),
											case MapType of
												?CONST_MAP_TYPE_BOSS->
													monster_move(Monster,ImageHeight2,ImageWidth2);
												_->
													case Flag of
														?true->
															Monster2=monster_reaction(RandType,RandX,RandY,Monster,ImageHeight2,ImageWidth2),
															Monster2#monster{reaction_time=Time};
														_->Monster
													end
											end
									end
							end
					end;
				_->
					Monster
			end;
		_->
			Monster
	end.


%% 怪物起身策略
monster_get_up(Monster,GetUpSkill,GetUpRand)->
	case util:rand_odds(GetUpRand,?CONST_PERCENT) of
		?true->
			GetUpSkill2=[{{SkillId,SkillId2,SkillId3,DJUx,DJUy},Odds}||{SkillId,SkillId2,SkillId3,Odds,{DJUx,DJUy,_}}<-GetUpSkill],
			[{LSkillId,LSkillId2,LSkillId3,_LDJUx,_LDJUy}|_]=util:odds_list_count(GetUpSkill2,1),
			monster_skill2(Monster,LSkillId,LSkillId2,LSkillId3);
		_->
			Monster#monster{knock_down=?false}
	end.


%% 怪物行走
monster_move(Monster,ImageHeight,ImageWidth)->
	Monster2=Monster#monster{pos_x=ImageWidth,pos_y=ImageHeight},
	BinMsg=scene_api:msg_move_rece(Monster2,?CONST_MAP_MOVE_MOVE),
	do_broadcast(BinMsg),
	Monster2.

%% 怪物思考
monster_reaction(RandType,RandX,RandY,Monster=#monster{pos_x=PosX,pos_y=PosY},ImageHeight,ImageWidth)->
	case util:rand_list(RandType) of
		?CONST_BATTLE_RAND_TYPE_2-> %% 左右
			X=util:rand(PosX,RandX),
			{Lx,Ly}=?IF(PosX+X>ImageWidth,{?IF(PosX-X=<0,0,PosX-X),PosY},{?IF(PosX+X>=ImageWidth,ImageWidth,PosX+X),PosY}),
			monster_move(Monster,Ly,Lx);
		?CONST_BATTLE_RAND_TYPE_3-> %%上下
			Y=util:rand(PosY,RandY),
			{Lx,Ly}=?IF(PosY+Y>ImageHeight,{PosX,?IF(PosY-Y=<0,0,PosY-Y)},{PosX,?IF(PosY+Y>=ImageHeight,ImageHeight,PosY+Y)}),
			monster_move(Monster,Ly,Lx);
		?CONST_BATTLE_RAND_TYPE_4->
			monster_move(Monster,ImageHeight,ImageWidth);
		_-> %% 范围
			case PlayerSList=get_map_players() of
				[]->
					Monster;
				_->
					PxyS=[{MPosX,MPosY}||#player_s{pos_x=MPosX,pos_y=MPosY}<-PlayerSList],
					PxyS2=[{(PosX-X)*(PosX-X)+(PosY-Y)*(PosY-Y),X,Y}||{X,Y}<-PxyS],
					{_,NewX,NewY}=lists:min(PxyS2),
					monster_move(Monster,NewY,NewX)
			end
	end.
	
%% 怪物释放技能
monster_skill(AttackSkill,Monster=#monster{pos_x=MPosX,pos_y=MPosY},NewX,NewY,ImageHeight,ImageWidth)->
	AttackSkill2=[{{SkillId,SkillId2,SkillId3,DJUx,DJUy},Odds}||{SkillId,SkillId2,SkillId3,Odds,{DJUx,DJUy,_}}<-AttackSkill],
	[{LSkillId,LSkillId2,LSkillId3,LDJUx,LDJUy}|_]=util:odds_list_count(AttackSkill2,1),
	case (MPosX-NewX)*(MPosX-NewX)+(MPosY-NewY)*(MPosY-NewY)=<LDJUx*LDJUx of
		?true->
			case abs(NewY-MPosY)=<LDJUy of
				?true->
					monster_skill2(Monster,LSkillId,LSkillId2,LSkillId3);
				_->
					MoveX=MPosX,
					MoveY=NewY-MPosY+MPosY,
					Monster2=monster_move(Monster,MoveY,MoveX),
					{?false,Monster2}
			end;
		_->
			MaxX=?IF(NewX+LDJUx>=ImageWidth,ImageWidth,NewX+LDJUx),
			MaxY=?IF(NewY+LDJUy>=ImageHeight,ImageHeight,NewY+LDJUy),
%% 			MinX=?IF(NewX-LDJUx=<0,0,NewX-LDJUx),
			MinY=?IF(NewY-LDJUy=<0,0,NewY-LDJUy),
			LastX=MaxX,
			LastY=util:rand(MinY,MaxY),
			Monster2=monster_move(Monster,LastY,LastX),
			{?false,Monster2}
	end.
			
%% 怪物攻击
monster_skill2(Monster=#monster{monster_mid=MonsterMid},LSkillId,LSkillId2,LSkillId3)->
	Bin1=?IF(LSkillId==0,<<>>,war_api:msg_skill(?CONST_MONSTER,0,MonsterMid,LSkillId,1)),
	Bin2=?IF(LSkillId2==0,<<>>,war_api:msg_skill(?CONST_MONSTER,0,MonsterMid,LSkillId2,1)),
	Bin3=?IF(LSkillId3==0,<<>>,war_api:msg_skill(?CONST_MONSTER,0,MonsterMid,LSkillId3,1)),
	do_broadcast(<<Bin1/binary,Bin2/binary,Bin3/binary>>),
	Monster#monster{knock_down=?false}.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 怪物刷新
interval_monster_refresh(Map=#map{map_id=MapId,monsters=Monsters,monsters_pos_temp=MonstersTemp}) ->
	{Monsters2, MonstersTemp2}	= interval_monster_refresh(MapId, MonstersTemp, Monsters, []),
	Map#map{monsters=Monsters2, monsters_pos_temp=MonstersTemp2}.

interval_monster_refresh(MapId, [Monster|MonstersTemp], Monsters, MonstersTempAcc) ->
	case Monster#monster.interval_temp >= Monster#monster.interval of
		?true ->
			case Monster#monster.sum of
				-1 ->
					Monster2		= Monster#monster{interval_temp=0},
					Monsters2		= [Monster2|Monsters],
					MonstersTempAcc2= MonstersTempAcc,
					BinMsg			= scene_api:msg_monster_data(Monster2),
					UserIdList		= get_map_uidlist(),
					do_broadcast(UserIdList, BinMsg);
				1 ->
					Monsters2		= Monsters,
					MonstersTempAcc2= MonstersTempAcc;
				Sum ->
					Monster2		= Monster#monster{interval_temp=0, sum=Sum - 1},
					Monsters2		= [Monster2|Monsters],
					MonstersTempAcc2= MonstersTempAcc,
					BinMsg			= scene_api:msg_monster_data(Monster2),
					Suids			= get_map_uidlist(),
					do_broadcast(Suids, BinMsg)
			end;
		_ ->
			Monsters2		 = Monsters,
			MonstersTempAcc2 = [Monster#monster{interval_temp=Monster#monster.interval_temp + ?CONST_MAP_INTERVAL_SECONDS}|MonstersTempAcc]
	end,
	interval_monster_refresh(MapId, MonstersTemp, Monsters2, MonstersTempAcc2);
interval_monster_refresh(_MapId, [], Monsters, MonstersTempAcc) ->
	{Monsters, MonstersTempAcc}.

% 定时地图关闭
interval_map_check(Map) ->
	if Map#map.type =:= ?CONST_MAP_TYPE_COPY_NORMAL 
				   orelse Map#map.type =:= ?CONST_MAP_TYPE_COPY_CLAN 
				   orelse Map#map.type =:= ?CONST_MAP_TYPE_COPY_FIGHTERS 
				   orelse Map#map.type =:= ?CONST_MAP_TYPE_COPY_HERO
				   orelse Map#map.type =:= ?CONST_MAP_TYPE_COPY_FIEND ->
		   Map;
	   Map#map.type =:= ?CONST_MAP_TYPE_CITY ->
		   {?noreply, Map};
		   %iterval_map_check2(Map, ?CONST_MAP_MAP_TIME_SLOT * 2);
	   Map#map.type =:= ?CONST_MAP_TYPE_BOSS ->
		   %已调关闭接口
		   {?noreply, Map};
	   Map#map.type =:= ?CONST_MAP_TYPE_INVITE_PK ->
		   iterval_map_check2(Map, 180);
	   Map#map.type =:= ?CONST_MAP_TYPE_CLAN_BOSS ->
		   %还没调接口
		   {?noreply, Map};
	   Map#map.type =:= ?CONST_MAP_TYPE_CHALLENGEPANEL ->
		   %这个没开场景
		   {?noreply, Map};
	   Map#map.type =:= ?CONST_MAP_TYPE_KOF ->
		   iterval_map_check2(Map, ?CONST_WRESTLE_ACTIVE_TIME);
	   ?true ->
		   {?noreply, Map}
	end.

iterval_map_check2(Map, CheckTime) ->
	TimerSwitch = Map#map.timer_switch + ?CONST_MAP_INTERVAL_SECONDS,
	case Map#map.timer_switch > CheckTime of
		?true ->
			Uids = get_map_uidlist(),
			NewUids = [Uid ||Uid <- Uids,role_api:is_online2(Uid) =:= ?true],
			case NewUids of 
				[] ->
					{?stop, ?normal, Map#map{timer_switch=TimerSwitch}};
				_ ->
					case Map#map.type of
						?CONST_MAP_TYPE_BOSS ->
							[util:pid_send(Uid,scene_api,enter_city_cb,?null) || Uid <- Uids],
							{?stop, ?normal, Map#map{timer_switch=TimerSwitch}};
						_ ->
							put(user_id_list,NewUids),
							{?noreply, Map#map{timer_switch=TimerSwitch}}
					end
			end;
		_ ->
			{?noreply, Map#map{timer_switch=TimerSwitch}}
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 单人、多人进入场景回调函数
%% enter_handle(Flag,Login,PlayerSList,Map,X,Y)
%% Flag true:本场景 false:过场景   Login:是否登陆进场景
enter_cast_handle(#map{map_id=MapId,type=MapType}=Map, PlayerSList, X, Y) ->
	Fun = fun(#player_s{uid=Uid,socket=Socket,hp_now=HpNow,hp_max=HpMax}=PlayerS) ->
				  Uids	= get_map_uidlist(),
				  Uids2 = case lists:member(Uid, Uids) of
							  ?true ->
								  Uids;
							  _ ->
								  [Uid|Uids]
						  end,
				  put(user_id_list,Uids2),
				  ?IF(MapType==?CONST_MAP_TYPE_INVITE_PK,war_api:war_time(self()),?skip),
				  {NewHpNow,NewHpMax} = enter_handle_pk_hp(MapType,HpNow,HpMax),
				  PlayerSNew = PlayerS#player_s{pos_x 		= X, 		pos_y		= Y,
												begin_x 	= X, 		begin_y		= Y,
												hp_now		= NewHpNow,	hp_max		= NewHpMax,
												pos_pixel_x = X * ?CONST_MAP_MAP_TILE_PIXEL,
												pos_pixel_y = Y * ?CONST_MAP_MAP_TILE_PIXEL,
												walk		= ?CONST_FALSE,
												distance	= 0,
												distance2 	= 0},
				  ets:insert(?ETS_MAP_PLAYER, PlayerSNew),
				  BinMsg5025	= scene_api:msg_role_data(PlayerSNew, ?CONST_MAP_ENTER_NULL),
				  BinMsg5015	= scene_api:msg_enter_ok(PlayerSNew, MapId, ?CONST_MAP_ENTER_NULL),
				  BinTitle	= title_api:title(Uid),
				  
				  BinPlayers = player_list_new([PlayerSNew]),
				  BinPartners= partner_list_new([PlayerSNew],MapType),
				  
				  app_msg:send(Socket,BinMsg5015),
				  do_broadcast(Uids, <<BinMsg5025/binary, BinTitle/binary,BinPlayers/binary,BinPartners/binary>>)		
		  end,
	lists:foreach(Fun, PlayerSList),
	OverSuids	= get_map_uidlist(),
	Map2 		= Map#map{counter=length(OverSuids)},
	update_map_data(Map2),
	{?noreply, Map2}.

%% enter_handle_wrestle(MapType,Socket) ->
%% 	case MapType of
%% 		?CONST_MAP_TYPE_KOF ->
%% 			case ets:lookup(?ETS_WRESTLE_CONTROL, ?CONST_ACTIVITY_WRESTLE_YUSAI) of
%% 				[#wrestle_con{state = Active}|_] ->
%% 					Bin = wrestle_api:msg_time(Active,?CONST_WRESTLE_DAOSHI_START_ING,?CONST_WRESTLE_ACTIVE_TIME),
%% 					app_msg:send(Socket, Bin);
%% 				_ ->
%% 					?skip
%% 			end;
%% 		_->
%% 			?skip
%% 	end.

enter_handle_pk_hp(MapType,HpNow,HpMax) ->
	case MapType of
		?CONST_MAP_TYPE_INVITE_PK ->
			{round(HpNow * ?CONST_ARENA_ATTR_HP_TIMES),round(HpMax * ?CONST_ARENA_ATTR_HP_TIMES)};
		_ ->
			{HpNow,HpMax}
	end.

%% 退出场景回调函数
exit_handle(Uid, Map) ->
	BinMsg	= scene_api:msg_out(Uid,?CONST_PLAYER, ?CONST_MAP_OUT_NULL,0),
	Uids	= get_map_uidlist(),
	Uids2	=
		case lists:member(Uid, Uids) of
			?true ->
				case Map#map.type of
					?CONST_MAP_TYPE_INVITE_PK ->
						PlayerS = get_map_players(),
						war_api:war_pk_escape(Uid,PlayerS);
					_ ->
						?skip
				end,
				lists:delete(Uid,Uids);
			_ ->
				Uids
		end,
	put(user_id_list, Uids2),
	Map2 = Map#map{counter=length(Uids2)},
	do_broadcast(Uids2, BinMsg),
	update_map_data(Map2),
	NoOffMaps = [?CONST_MAP_TYPE_CITY,?CONST_MAP_TYPE_BOSS,?CONST_MAP_TYPE_CLAN_BOSS],
	case lists:member(Map#map.type,NoOffMaps) of
		?true ->
			{?noreply,Map2};
		_ ->
			case Uids of
				[] ->
					{?stop,?normal,Map2};
				_ ->
					{?noreply,Map2}
			end
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
move_handle(Uid,Type,MoveType,PosX,PosY,OwnerUid) ->
	% ?MSG_ECHO("==============================~w~n",[{Uid,Type,MoveType,PosX,PosY,OwnerUid}]),
	Uids = get_map_uidlist(),
	case lists:member(Uid, Uids) of
		?true ->
			case get_player(Uid) of
				PlayerS when is_record(PlayerS,player_s) ->
					case Type of
						?CONST_PLAYER ->
							PlayerSNew = PlayerS#player_s{pos_x=PosX,pos_y=PosY,begin_x=PosX,begin_y=PosY,
														  pos_pixel_x=PosX * ?CONST_MAP_MAP_TILE_PIXEL,
														  pos_pixel_y=PosY * ?CONST_MAP_MAP_TILE_PIXEL},
							BinMsg = scene_api:msg_move_rece(Type,Uid,MoveType,PosX,PosY,0),
							do_broadcast(BinMsg),
							update_map_player(PlayerSNew);
						_ ->
							Partners = PlayerS#player_s.partners,
							NewPartners =
								case lists:keytake(Uid, #partner_s.partner_id, Partners) of
									{value,Partner,PartnersTmp} ->
										[Partner#partner_s{pos_x=PosX,pos_y=PosY}|PartnersTmp];
									_ ->
										Partners
								end,
							PlayerSNew = PlayerS#player_s{partners=NewPartners},
							BinMsg = scene_api:msg_move_rece(Type,Uid,MoveType,PosX,PosY,OwnerUid),
							do_broadcast(BinMsg),
							update_map_player(PlayerSNew)
					end;
				_ ->
					?skip
			end;
		_ ->
			?skip
	end.

move_new_handle(Uid,Type,MoveType,PosX,PosY,OwnerUid) ->
	BinMsg = scene_api:msg_move_rece(Type,Uid,MoveType,PosX,PosY,OwnerUid),
	do_broadcast(BinMsg).

move_handle_cb(#player{info=Info}=Player, {X,Y}) ->
	Player#player{info=Info#info{pos_x=X,pos_y=Y}}.

%% 	if abs(X - PosX) < 5 orelse abs(Y - PosY) < 5 -> ?true; ?true -> ?false end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 请求场景角色数据列表
player_list_handle(Uid,MapType) ->
	Players	= get_map_players(),
	case lists:keytake(Uid,#player_s.uid,Players) of
		{value,#player_s{socket=Socket},PlayerTmp} ->
			player_list(PlayerTmp, Socket, MapType, <<>>);
		_ ->
			?skip
	end.

player_list([PlayerS|PlayerSList], Socket, MapType, Acc) ->
	BinMsg = scene_api:msg_role_data(PlayerS, ?CONST_MAP_ENTER_NULL),
	BinPartners =
		case MapType of
			?CONST_MAP_TYPE_CITY ->
				<<>>;
			_ ->
				scene_api:msg_partner_data(PlayerS#player_s.uid, PlayerS#player_s.partners,PlayerS#player_s.team_id)
		end,
	?MSG_ECHO("===================~w~n",[{PlayerS#player_s.uid,BinPartners}]),
	BinTitle	= title_api:title(PlayerS#player_s.uid),
	player_list(PlayerSList, Socket, MapType, <<Acc/binary, BinMsg/binary, BinPartners/binary, BinTitle/binary>>);
player_list([], Socket, _MapType, Acc) ->
	case Acc of
		<<>> ->
			?skip;
		_ ->
			app_msg:send(Socket, Acc)
	end.

%% 请求场景角色列表(NEW)
player_list_new_handle(Uid,MapType) ->
	Players	= get_map_players(),
	case lists:keytake(Uid,#player_s.uid,Players) of
		{value,#player_s{socket=Socket},PlayerTmp} ->
			BinPlayers = player_list_new(PlayerTmp),
			BinPartners= partner_list_new(PlayerTmp,MapType),
			app_msg:send(Socket, <<BinPlayers/binary,BinPartners/binary>>);
			%player_list(PlayerTmp, Socket, MapType, <<>>);
		_ ->
			?skip
	end.

player_list_new(Players) ->
	Fun = fun(PlayerS,AccBin) ->
				  BinPlayer = scene_api:msg_role_data_new(PlayerS, ?CONST_MAP_ENTER_NULL),
				  <<AccBin/binary,BinPlayer/binary>>
		  end,
	BinData = lists:foldl(Fun, app_msg:encode([{?int16u,length(Players)}]), Players),
	app_msg:msg(?P_SCENE_PLAYER_LIST, BinData).

partner_list_new(_PlayerTmp,?CONST_MAP_TYPE_CITY) ->
	<<>>;
partner_list_new([],_MapType) ->
	<<>>;
partner_list_new(Players,_MapType) ->
	Fun = fun(PlayerS,{AccCount,AccBin}) ->
				  {PartnerCount,BinPartner} = scene_api:msg_partner_data_new(PlayerS#player_s.uid, PlayerS#player_s.partners,PlayerS#player_s.team_id,0,<<>>),
				  {AccCount + PartnerCount, <<AccBin/binary,BinPartner/binary>>}
		  end,
	{Count,Bin1} = lists:foldl(Fun, {0,<<>>}, Players),
	BinCount = app_msg:encode([{?int16u,Count}]),
	app_msg:msg(?P_SCENE_PARTNER_LIST, <<BinCount/binary,Bin1/binary>>).

%% 请求场景怪物数据
monster_list_handle(#map{monsters=Monsters,type=MapType},Uid) ->
	case MapType of
		?CONST_MAP_TYPE_BOSS ->
			Monsters2=world_boss_api:boss_hp_updata(Monsters),
			BinMons = scene_api:msg_idx_monster(0,Monsters2),
			player_send_msg(Uid, BinMons);
		?CONST_MAP_TYPE_CLAN_BOSS ->
			BinMons = scene_api:msg_idx_monster(0,Monsters),
			player_send_msg(Uid, BinMons);
		_ ->
			?skip
	end.

monster_knock_handle(#map{monsters=Monsters} = Map, Gmid, _Gid) ->
	case lists:keytake(Gmid, #monster.monster_mid, Monsters) of
		{value, Monster, Tmp} ->
			case Monster#monster.knock_down of
				?true ->
					Map;
				_ ->
					NewMonster = Monster#monster{knock_down=?true},
					Map#map{monsters=[NewMonster|Tmp]}
			end;
		_ ->
			Map
	end.

monster_list_all_handle(#map{map_id=MapId,monsters=Monsters},BinMsg) ->
	BinMons = scene_api:msg_monster_data(MapId, Monsters, <<>>),
	Suids	=get_map_uidlist(),
	do_broadcast(Suids, <<BinMsg/binary,BinMons/binary>>).

%% 查找地图信息
find_map_info_handle(#map{map_id=MapId},Country) ->
	#d_scene{scene_type=SceneType,born=Born} = data_scene:scene(MapId),
	{X,Y}	= find_map_bornxy(Born,Country),
	{MapId,X,Y,SceneType}.

%% 请求场景玩家列表
get_player_handle() ->
	get_map_players().

%% 删除掉线玩家
del_player_handle(_State,Sid,Uid) ->
	Suids	= get_map_uidlist(), 
	NewSuids= lists:delete({Sid,Uid},Suids),
	put(user_id_list, NewSuids).

add_monster_handle(#map{map_id=MapId}=Map,MonsInfo) ->
	%?MSG_ECHO("_------------------~w~n",[MonsInfo]),
	MonsterInfo = record_monster_s(MonsInfo,MapId),
	%?MSG_ECHO("_------------------~w~n",[MonsterInfo]),
	BinMons = scene_api:msg_idx_monster(0, MonsterInfo),
	%?MSG_ECHO("_------------------~w~n",[MonsterInfo]),
	do_broadcast(BinMons),
	%?MSG_ECHO("_------------------~w~n",[MonsterInfo]),
	Map#map{monsters=MonsterInfo}.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 场景广播--帮派
change_clan_handle(Map, Uid, ClanId,ClanName) ->
	Uids = get_map_uidlist(),
	case lists:member(Uid,Uids) of
		?true ->
			case get_player(Uid) of
				PlayerS when is_record(PlayerS,player_s) ->
					if PlayerS#player_s.clan =:= ClanId andalso PlayerS#player_s.clan_name =:= ClanName ->
						   Map;
					   ?true ->
						   PlayerS2 = players_set(PlayerS, [{clan, ClanId}, {clan_name, ClanName}]),
						   update_map_player(PlayerS2),
						   BinMsg	= scene_api:msg_change_clan(Uid, ClanId,ClanName),
						   do_broadcast(Uids, BinMsg),
						   Map
					end;
				_ ->
					Map
			end;
		_ ->
			Map
	end.

% 场景广播--战斗状态
change_war_state_handle(Map,SidUidStates) ->
	{Map2, BinMsg} 	= change_war_state_handle2(Map,SidUidStates,<<>>),
	Suids	= get_map_uidlist(),
	do_broadcast(Suids, BinMsg),
	Map2.

change_war_state_handle2(Map, [{Sid,Uid,StateNew}|SidUidStates], AccBin)->
	MapPlayers = get_map_players(),
	Map2	= case lists:keytake(Uid, #player_s.uid, MapPlayers) of
				  {value, PlayerS, _Players} ->
					  BinData	= scene_api:msg_change_war(Sid, Uid, StateNew),
					  PlayerS2 	= players_set(PlayerS, is_war, StateNew),
					  update_map_player(PlayerS2),
					  Map;
				  _ ->
					  BinData	= <<>>,
					  Map
			  end,
	change_war_state_handle2(Map2, SidUidStates, <<AccBin/binary, BinData/binary>>);
change_war_state_handle2(Map, [], AccBin)->
	{Map, AccBin}.

% 场景广播--改变坐骑
change_mount_handle(Map,Uid,Mount,Speed) ->
	MapPlayers = get_map_players(),
	case lists:keytake(Uid, #player_s.uid, MapPlayers) of
		{value, PlayerS, _Players} ->
			if PlayerS#player_s.skin_mount =:= Mount -> 
				   Map;
			   ?true ->
				   PlayerS2 = players_set(PlayerS, [{skin_mount, Mount},{speed, Speed}]),
				   update_map_player(PlayerS2),
				   BinMsg	= scene_api:msg_change_mount(Uid, Mount, Speed),
				   Suids	= get_map_uidlist(),
				   do_broadcast(Suids, BinMsg),
				   Map
			end;
		?false ->
			Map
	end.

% 场景广播--升级
change_level_handle(Map, Uid, Lv) ->
	Uids = get_map_uidlist(),
	case lists:member(Uid,Uids) of
		?true ->
			case get_player(Uid) of
				PlayerS when is_record(PlayerS,player_s) ->
					case PlayerS#player_s.lv of
						Lv ->
							Map;
						_ ->
							PlayerS2 = players_set(PlayerS, lv, Lv),
							update_map_player(PlayerS2),
							BinMsg	= scene_api:msg_level_up(Uid, Lv),
							do_broadcast(Uids, BinMsg),
							Map
					end;
				_ ->
					Map
			end;
		_ ->
			Map
	end.

% 场景广播--VIP
change_vip_handle(Map, Uid, VipLv) ->
	Uids = get_map_uidlist(),
	case lists:member(Uid,Uids) of
		?true ->
			case get_player(Uid) of
				PlayerS when is_record(PlayerS,player_s) ->
					case PlayerS#player_s.vip of
						VipLv ->
							Map;
						_ ->
							PlayerS2 = players_set(PlayerS, vip, VipLv),
							update_map_player(PlayerS2),
							BinMsg	= scene_api:msg_vip_up(Uid, VipLv),
							do_broadcast(Uids, BinMsg),
							Map
					end;
				_ ->
					Map
			end;
		_ ->
			Map
	end.

% 场景广播--改变组队
change_team_leader_handle(NewLeaderUid,OldLeaderUid) ->
	MapPlayers = get_map_players(),
	case lists:keytake(NewLeaderUid, #player_s.uid, MapPlayers) of
		{value, PlayerS, Players2} ->
			PlayerS2 = players_set(PlayerS, [{leader_uid, NewLeaderUid}]),
			update_map_player(PlayerS2),
			Players3 = [PlayerS2|Players2];
		?false ->
			Players3 = MapPlayers
	end,
	case lists:keyfind(OldLeaderUid, #player_s.uid, Players3) of
		PlayerS3 when is_record(PlayerS3,player_s) ->
			PlayerS4 = players_set(PlayerS3, [{leader_uid, NewLeaderUid}]),
			update_map_player(PlayerS4);
		?false ->
			?skip
	end,
	BinMsg	= scene_api:msg_change_team(NewLeaderUid,OldLeaderUid),
	Suids	= get_map_uidlist(),
	do_broadcast(Suids, BinMsg).

move_monster(Map,MonsterGMid) ->
	MonsterPos	= Map#map.monsters,
	MonsterTmp	= Map#map.monsters_pos_temp,
	case have_check(MonsterPos,MonsterGMid) of
		?false ->
			Map2	= Map;
		Monster_gs ->
			{MonsterPos2,MonsterTmp2} =
				if
					Monster_gs#monster.share =:= ?CONST_TRUE ->
						{MonsterPos, MonsterTmp};
					?true ->
						{lists:delete(Monster_gs, MonsterPos), [Monster_gs|MonsterTmp]}
				end,
			Map2	= Map#map{monsters = MonsterPos2, monsters_pos_temp = MonsterTmp2}
	end,
	Map2.

% 是否存在
have_check([H|T],Mid) when is_record(H, monster) ->
	if H#monster.monster_mid =:= Mid ->
		   H;
	   ?true ->
		   have_check(T,Mid)
	end;
have_check([_H|T],Mid) ->
	have_check(T,Mid);
have_check([],_Mid) ->
	?false.

update_task_monster(Map,MonsMid,Uids) ->
	Fun = fun(Uid) ->
				  case lists:keyfind(MonsMid, #monster.monster_mid, Map#map.monsters) of
					  Monster when is_record(Monster,monster) ->
						  case get_player(Uid) of
							  #player_s{mpid=_Mpid} ->
								  ?skip;
%% 								  task_api:check_cast(Mpid,?CONST_TASK_TARGET_KILL, {Map#map.map_id,[{Monster#monster.monster_id,1}]});
							  _ ->
								  ?skip
						  end;
					  _ ->
						  ?skip
				  end
		  end,
	lists:foreach(Fun, Uids).

%% 战斗结束刷新怪物
war_over_refresh_monster_handle(Map, MonsMid) ->
	Uids = get_map_uidlist(),
	update_task_monster(Map,MonsMid,Uids),
	war_over_refresh_monster_handle2(Map,MonsMid).

%% 怪物被杀离开场景
war_over_refresh_monster_handle2(Map=#map{monsters=MonsterPos,monsters_pos_temp=MonsterTmp}, MonsMid) ->
	case have_check(MonsterPos,MonsMid) of
		?false ->
			Map2 = Map;
		Monster_gs ->
			%?MSG_ECHO("-----------------~w~n",[MonsterTmp]),
			{MonsterPos2,MonsterTmp2} = {lists:delete(Monster_gs, MonsterPos), [Monster_gs|MonsterTmp]},
			%?MSG_ECHO("-----------------~w~n",[MonsterTmp2]),
			Map2 = Map#map{monsters=MonsterPos2, monsters_pos_temp=MonsterTmp2}
	end,
	Uids	= get_map_uidlist(),
	BinMsg	= scene_api:msg_out(MonsMid,?CONST_MONSTER, ?CONST_MAP_OUT_NULL,0),
	do_broadcast(Uids, BinMsg),
	Map2.

%% Type: 玩家|伙伴|怪物
%% Uid:  Uid|0|怪物mid
%% PId:	 Uid|Pid|0
%% Sta:  见常量
%% Har:  伤害
war_harm_handle(#map{type=MapType}=Map,{Type,Uid,PartnerId,State,Harm},CopyId) ->
	{NewMap,NewFlag} = 
		case Type of
			?CONST_PLAYER ->
				Map2 = war_harm_Player(Map,Type,Uid,PartnerId,State,Harm,CopyId),
				{Map2,?false};
			?CONST_PARTNER ->
				Map2 = war_harm_partner(Map,Type,Uid,PartnerId,State,Harm),
				{Map2,?false};
			?CONST_MONSTER ->
				war_harm_monster(Map,Type,Uid,PartnerId,State,Harm)
		end,
	?MSG_ECHO("=============== ",[]),
	case MapType of
		?CONST_MAP_TYPE_INVITE_PK ->
			PlayerS = get_map_players(),
			war_api:war_pk_res(PlayerS);
		_ ->
			?skip
	end,
	{NewMap,NewFlag}.

%% 玩家伤害
war_harm_Player(#map{type=MapType}=Map,Type,Uid,PartnerId,State,Harm,CopyId) ->
	?MSG_ECHO("------------------~w~n",[{Type,Uid,PartnerId,State,Harm,CopyId}]),
	Uids = get_map_uidlist(),
	case lists:member(Uid, Uids) of
		?true ->
			%?MSG_ECHO("------------------~w~n",[{Type,Uid,PartnerId,State,Harm,CopyId}]),
			case get_player(Uid) of
				#player_s{hp_now=HpNow,relive_times=Times}=PlayerS ->
					%?MSG_ECHO("------------------~w~n",[{Type,Uid,PartnerId,State,Harm,CopyId}]),
					case HpNow - Harm of
						NewHpNow when NewHpNow > 0 ->
							?MSG_ECHO("-------------~w~n",[{HpNow,Harm,NewHpNow}]),
							%?MSG_ECHO("------------------~w~n",[{Type,Uid,PartnerId,State,Harm,CopyId}]),
							PlayerSNew = PlayerS#player_s{hp_now=NewHpNow},
							ets:insert(?ETS_MAP_PLAYER, PlayerSNew),
							BinMsg = scene_api:msg_hp_update(Type,Uid,PartnerId,State,NewHpNow),
							do_broadcast(Uids,BinMsg);
						_ ->
							?MSG_ECHO("------------------~w~n",[{Type,Uid,PartnerId,State,Harm,CopyId}]),
							?IF(MapType =:= ?CONST_MAP_TYPE_KOF, wrestle_api:lie_exit_kof(Uid), ?skip),
							copy_can_relive(MapType,CopyId,Uid,Times),
							PlayerSNew = PlayerS#player_s{die=?true,hp_now=0},
							ets:insert(?ETS_MAP_PLAYER, PlayerSNew),
							BinMsg	= scene_api:msg_out(Uid,?CONST_PLAYER, ?CONST_MAP_OUT_DIE,0),
							do_broadcast(Uids,BinMsg)
					end;
				_ ->
					?MSG_ERROR("This user no ets data !!!==~w~n",[{Uid,Uids}]),
					?skip
			end;
		_ ->
			?MSG_ERROR("This user not in scene !!!==~w~n",[{Uid,Uids}]),
			?skip
	end,
	Map.

copy_can_relive(MapType,CopyId,Uid,Times) ->
	case lists:member(MapType, ?COPY_TYPES) of
		?true ->
			case data_scene_copy:get(CopyId) of
				#d_copy{relive_lim=ReTimes} ->
					case Times < ReTimes of
						?true ->
							BinMsg = copy_api:msg_relive(10),
							player_send_msg(Uid, BinMsg);
						_ ->
							BinMsg = copy_api:msg_fail(),
							player_send_msg(Uid, BinMsg)
					end;
				_ ->
					?skip
			end;
		_ ->
			?skip
	end.

%% 伙伴伤害
war_harm_partner(Map,Type,Uid,PartnerId,State,Harm) ->
	?MSG_ECHO("---------------~w~n",[{Uid,PartnerId,State,Harm}]),
	Uids = get_map_uidlist(),
	case lists:member(Uid, Uids) of
		?true ->
			case get_player(Uid) of
				#player_s{partners=Partners}=PlayerS ->
					case lists:keytake(PartnerId,#partner_s.partner_id,Partners) of
						{value,#partner_s{die=?true},_TmpPartners} ->
							?MSG_ERROR("Partner is died !!!==~w~n",[{Uid,PartnerId}]),
							?skip;
						{value,#partner_s{partner_id=PartnerId,hp=NowHp,hp_max=MaxHp}=Partner,TmpPartners} ->
							?MSG_ECHO("================~w~n",[{NowHp,Harm}]),
							case NowHp - Harm of
								NewNowHp when NewNowHp > 0 ->
									?MSG_ECHO("-------------~w~n",[{NowHp,MaxHp,Harm,NewNowHp}]),
									NewPartners = [Partner#partner_s{hp=NewNowHp}|TmpPartners],
									NewPlayerS	= PlayerS#player_s{partners=NewPartners},
									ets:insert(?ETS_MAP_PLAYER, NewPlayerS),
									BinMsg = scene_api:msg_hp_update(Type,Uid,PartnerId,State,NewNowHp),
									do_broadcast(Uids,BinMsg);
								_ ->
									?MSG_ECHO("================~w~n",[{NowHp,Harm}]),
									NewPartners = [Partner#partner_s{hp=0,die=?true}|TmpPartners],
									NewPlayerS	= PlayerS#player_s{partners=NewPartners},
									ets:insert(?ETS_MAP_PLAYER, NewPlayerS),
									BinMsg	= scene_api:msg_out(PartnerId,?CONST_PARTNER, ?CONST_MAP_OUT_DIE,Uid),
									do_broadcast(Uids,BinMsg)
							end;
						_ ->
							?MSG_ERROR("No This Partner !!!==~w~n",[{Uid,PartnerId,Partners}]),
							?skip
					end;
				_ ->
					?MSG_ERROR("This user no ets data !!!==~w~n",[{Uid,Uids}]),
					?skip
			end;
		_ ->
			?MSG_ERROR("This user not in scene !!!==~w~n",[{Uid,Uids}]),
			?skip
	end,
	Map.

%% 怪物伤害
war_harm_monster(Map,Type,MonsterMid,MonsterId,State,Harm) ->
	%?MSG_ECHO("------------------~w~n",[{Type,MonsterMid,MonsterId,State,Harm}]),
	case lists:keytake(MonsterMid,#monster.monster_mid,Map#map.monsters) of
		{value,Monster,MonsterTmp} ->
			case Monster#monster.hp - Harm of
				NowHp when NowHp > 0 ->
					Monster2 = Monster#monster{hp=NowHp},
					Monsters2= [Monster2|MonsterTmp],
					BinMsg = scene_api:msg_hp_update(Type,MonsterMid,MonsterId,State,NowHp),
					do_broadcast(BinMsg),
					{Map#map{monsters=Monsters2},?false};
				_ ->
					Monsters2= MonsterTmp,
					BinMsg	= scene_api:msg_out(MonsterMid,?CONST_MONSTER, ?CONST_MAP_OUT_DIE,0),
					do_broadcast(BinMsg),
					Map2 = Map#map{monsters=Monsters2,monsters_pos_temp=[Monster|Map#map.monsters_pos_temp]},
					case Monster#monster.steps of
						?CONST_MONSTER_RANK_BOSS_SUPER ->
							{Map2,?true};
						_ ->
							{Map2,?false}
					end
			end;
		_ ->
			%?MSG_ERROR("This monster not in scene !!!==~w~n",[{MonsterMid,MonsterId,Map#map.monsters}]),
			{Map,?false}
	end.

%% 把玩家拉回城
enter_city_handle() ->
	Uids = get_map_uidlist(),
	[util:pid_send(Uid,scene_api,enter_city_cb,?null) || Uid <- Uids].

%% 把所有怪物的hp替换成Attr的hp
replace_gmonster(Map, GmonsInfo) ->
	NewMonsterGs =
		case record_monster_s(GmonsInfo,Map#map.map_id) of
			[] ->
				Map#map.monsters;
			OverGs ->
				OverGs
		end,
	Map#map{monsters = NewMonsterGs}.

%% 地图广播回调函数
do_broadcast_handle(Uid,BinMsg) ->
	Uids = get_map_uidlist(),
	do_broadcast(lists:delete(Uid, Uids),BinMsg).

do_broadcast(BinMsg) ->
	Uids = get_map_uidlist(),
	do_broadcast(Uids,BinMsg).

do_broadcast(Uids,BinMsg) ->
	UidsLists = util:lists_split(Uids, 30),
	[spawn(fun() -> do_broadcast2(Uids1,BinMsg) end) || Uids1 <- UidsLists].

do_broadcast2([Uid|Uids],BinMsg) ->
	case ets:lookup(?ETS_MAP_PLAYER, Uid) of
		[#player_s{socket=Socket}] ->
			app_msg:send(Socket, BinMsg);
		_ ->
			?skip
	end,
	do_broadcast2(Uids,BinMsg);
do_broadcast2([],_BinMsg) ->
	?skip.

broadcast_lose_handle(Key)->
	Suids	= get_map_uidlist(),
	case lists:member(Key,Suids) of
		?true ->
			case ets:lookup(?ETS_MAP_PLAYER,Key) of
				[] ->
					NewSuids = lists:delete(Key,Suids),
					put(user_id_list, NewSuids),
					?ok;
				[PlayerS] ->
					SendLose = PlayerS#player_s.send_lose,
					if
						SendLose >= ?CONST_MAP_MAP_SEND_LOSE_MAX ->
							NewSuids = lists:delete(Key,Suids),
							put(user_id_list, NewSuids),
							?ok;
						?true ->
							put(user_id_list, Suids),
							?ok
					end
			end;
		_ ->
			NewSuids = lists:delete(Key,Suids),
			put(user_id_list, NewSuids),
			?ok
	end.

players_set(PlayerS, []) -> PlayerS;
players_set(PlayerS, [{Key, Value}|List]) ->
	PlayerS2 = players_set(PlayerS, Key, Value),
	players_set(PlayerS2, List).

players_set(PlayerS, Key, Value) ->
	case Key of
		uid			-> PlayerS#player_s{uid		 		= Value};
		socket 		-> PlayerS#player_s{socket 			= Value};
		mpid 		-> PlayerS#player_s{mpid 			= Value};
                 				
		name       	-> PlayerS#player_s{name 			= Value};
		name_color 	-> PlayerS#player_s{name_color 		= Value};
		sex         -> PlayerS#player_s{sex 			= Value};
		pro         -> PlayerS#player_s{pro 			= Value};
		lv          -> PlayerS#player_s{lv 				= Value};

		is_war		-> PlayerS#player_s{is_war 			= Value};
		is_mount	-> PlayerS#player_s{is_mount 		= Value};
		leader_uid	-> PlayerS#player_s{leader_uid		= Value};
		pos_x		-> PlayerS#player_s{pos_x 			= Value};
		pos_y		-> PlayerS#player_s{pos_y 			= Value};
		speed		-> PlayerS#player_s{speed 			= Value};
		dir			-> PlayerS#player_s{dir 			= Value};
		distance2	-> PlayerS#player_s{distance2 		= Value};
		
		skin_mount	-> PlayerS#player_s{skin_mount 		= Value};
		
		country     -> PlayerS#player_s{country 		= Value};
		country_post-> PlayerS#player_s{country_post 	= Value};
		clan        -> PlayerS#player_s{clan 			= Value};
		clan_name   -> PlayerS#player_s{clan_name 		= Value};
		clan_post	-> PlayerS#player_s{clan_post 		= Value};
		vip      	-> PlayerS#player_s{vip 			= Value}
	end. 

record_player_s(#player{uid=Uid,mpid=Mpid,team_id=TeamId,team_leader=TeamLeader,uname=Uname,uname_color=UnameColor,
						socket=Socket,sex=Sex,pro=Pro,lv=Lv,country=Country,is=Is,info=Info,vip=Vip}=Player) ->
	Partners = war_api:war_partner_hp(),
	?MSG_ECHO("=====================~w~n",[Partners]),
	Hp = war_api:war_hp(Player),
	{Clan,ClanName} = clan_api:clan_id_name(Uid),
	SkinMount = if Is#is.is_mount =:= ?CONST_TRUE -> Info#info.skin_mount; ?true -> 0 end,
	SkinPet = 0,
	#player_s{
			  uid				= Uid,						% 用户ID
			  mpid        		= Mpid,       				% 进程ID
			  vip				= Vip#vip.lv,				% VIP等级

			  sex				= Sex,						% 性别
			  pro				= Pro,						% 职业
			  lv				= Lv,						% 等级
			  is_war			= Is#is.is_war,				% 是否在战斗
			  is_guide			= Is#is.is_guide,			% 是否是新手指导员
			  
			  socket			= Socket,					% Socket
			  name       		= Uname,         			% 昵称char[16]
			  name_color		= UnameColor,				% 名字颜色

			  leader_uid		= TeamLeader,
			  hp_now			= Hp,
			  hp_max			= Hp,
			  team_id			= TeamId,					% 队伍ID
			  partners			= Partners,					% 出战伙伴列表
			  
			  begin_x			= Info#info.pos_x,			% X开始坐标
			  begin_y			= Info#info.pos_y,			% Y开始坐标
			  pos_x				= Info#info.pos_x,			% X坐标
			  pos_y				= Info#info.pos_y,			% Y坐标
			  pos_pixel_x		= Info#info.pos_x * 20,		% X像素坐标
			  pos_pixel_y		= Info#info.pos_y * 20,		% Y像素坐标				 
			  
			  speed				= Info#info.speed,			% 移动速度
		      dir				= Info#info.dir,			% 方向 
			  distance2			= 0,						% 距离*距离（距离平方）
			  walk				= ?CONST_FALSE,				% 是否行走状态（?CONST_FALSE:站  ?CONST_TRUE:走）
			  
			  skin_mount		= SkinMount,				% 坐骑
			  skin_weapon		= Info#info.skin_weapon,	% 武器皮肤
			  skin_armor		= Info#info.skin_armor,		% 衣服皮肤
			  skin_pet			= SkinPet,					% 魔宠皮肤
			  
			  country     		= Country,        			% 国家：显示玩家的国家
			  country_post		= 0,   						% 国家：职位
			  clan        		= Clan,           			% 家族：显示玩家的家族
			  clan_name			= ClanName,					% 家族：显示玩家的家族名称
			  clan_post			= 0							% 家族：职位
			 }.

%% 获取地图出生点
find_map_bornxy(Born,Country) when is_list(Born) ->
	case lists:keytake(0,1,Born) of
		{value,{0,X,Y},_Temp} ->
			{X,Y};
		_ ->
			case lists:keyfind(Country,1,Born) of
				{Country,X,Y} ->
					{X,Y};
				_ ->
					{?CONST_MAP_DEFAULT_POSX,?CONST_MAP_DEFAULT_POSY}
			end
	end;
find_map_bornxy(MapId,Country) ->
	case data_scene:scene(MapId) of
		#d_scene{born=Born} ->
			find_map_bornxy(Born,Country);
		_ ->
			{?CONST_MAP_DEFAULT_POSX,?CONST_MAP_DEFAULT_POSY}
	end.