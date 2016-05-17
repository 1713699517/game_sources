%% Author  : Kevin
%% Created: 2012-9-5
%% Description: TODO: Add description to role_mod
-module(world_boss_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-define(CONST_BOSS_ID,                	boss_id).
-define(CONST_BOSS_HP,                  	boss_hp).
-define(CONST_BOSS_MAP,                 	map_id).		% 场景Id
-define(CONST_BOSS_WAR_HARM,           	war_harm).	% 玩家伤害
%%
%% Exported Functions
%%

-export([encode_world_boss/1,
		 decode_world_boss/1,
		 
		 init/1,
		 
		 boss_clear/1,
		 boss_enjoy/1,
		 boss_monster/1,
		 boss_harm/2,
		 boss_harm_updata_cast_handle/7,
		 boss_rmb_attr/2,
		 boss_die_rs_rmb/1,
		 boss_die_exit/0,
		 player_hp_update_cb/2,
%% 		 monster_hp_update_cb/2,
		 hp_self/1,
		 boss_hp_updata/1,
		 
		 
		 
		 msg_map_data/2,
		 msg_vip_rmb/0,
		 msg_dps/3,
		 msg_self_hp/1,
		 msg_war_rs/2,
		 msg_revive_ok/0,
		 msg_rmb_use/2,
		 msg_addition/1
		]).


encode_world_boss(WroldBoss) ->
	WroldBoss.

decode_world_boss(WroldBoss) ->
	WroldBoss.


init(Player)->
	{Player,#world_boss{}}.

%%
%% Local Functions
%%

%% 更新Boss血量
boss_hp_updata(Monsters)->
	case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_ID) of
		[]->Monsters;
		[{_,BossId}|_]->
			case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_HP) of
				[{_,{Hp,_HpMax}}|_]->
					case lists:keytake(BossId,#monster.monster_id,Monsters) of
						{value,Monster,Monsters2}->
							Monster2=Monster#monster{hp=Hp},
							[Monster2|Monsters2];
						_->
							Monsters
					end;
				_->
					Monsters
			end
	end.

%% 刷新怪物
boss_monster(Arg)->
	?MSG_ECHO("===================== shuai xin  guai  wu ==================",[]),
	RankDataList= ets:select(?ETS_ARENA, [{'$1',[{'=<',{element,2,'$1'},20}],['$1']}]),
	Lv=trunc(lists:sum([Lv||#rank_data{lv=Lv}<-RankDataList])/20),
	BossDate=data_world_boss_lv:get(Lv,Arg),
	[{BossId,_,_,_,_}|_]=BossDate,
	BinMsg=broadcast_api:msg_broadcast_world_show(BossId),
	chat_api:send_to_all(BinMsg),
	#d_monster{attr=Attr}=data_scene_monster:get(BossId),
	ets:delete_all_objects(?ETS_WORLD_BOSS),
	ets:insert(?ETS_WORLD_BOSS,[{?CONST_BOSS_ID,BossId},
								{?CONST_BOSS_HP,{Attr#attr.hp,Attr#attr.hp}},
								{?CONST_BOSS_MAP,?CONST_BOSS_HUMAN_SENCE},
								{?CONST_BOSS_WAR_HARM,[]}]),
	scene_api:world_add_monster(?CONST_BOSS_HUMAN_SENCE,BossDate).

%% 取出当前时段世界BOSS的时间段
boss_get_time()->
	Fun=fun(ActiveId,Acc)->
				case active_api:get_active_data(ActiveId) of
					?null ->
						Acc;
					[StartTime,EndTime]->
						Time=util:seconds(),
						if
							{StartTime,EndTime}=={0,0} 
								orelse (Time>=StartTime-60 andalso Time=<EndTime) ->
								[{StartTime,EndTime}|Acc];
							?true->
								Acc
						end
				end
		end,
	lists:foldl(Fun,[],?WORLD_BOSS_ACTIVE).


%% 验证是否可以进入
boss_clear(#player{lv=Lv})->
	case Lv>=?CONST_BOSS_ENJOY_LV of
		?true->
			case boss_get_time() of
				[]->
					{?error,?ERROR_WORLD_BOSS_NOT_START};
				[{StartTime,_EndTime}|_]->
					Time=util:seconds(),
					case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_ID) of
						[]->
							?IF(Time-StartTime+?CONST_TSP_INTERVAL=<?CONST_TSP_INTERVAL,?true,{?error,?ERROR_WORLD_BOSS_NOT_START});
						_->
							?true
					end
			end;
		_->
			{?error,?ERROR_LV_LACK}
	end.
			
%% 请求世界boss数据
boss_enjoy(Player=#player{uid=Uid,vip=Vip})->
	case boss_get_time() of
		[]->
			{?error,?ERROR_WORLD_BOSS_NOT_START};
		[{StartTime,EndTime}|_]->
			WorldBoss0=role_api_dict:world_boss_get(),
			WorldBoss=?IF(WorldBoss0#world_boss.data==[StartTime,EndTime],WorldBoss0,#world_boss{data=[StartTime,EndTime]}),
			role_api_dict:world_boss_set(WorldBoss),
			BinMsg=msg_map_data(StartTime,EndTime),
			VipBinMsg=?IF(Vip>=6,msg_vip_rmb(),<<>>),
			case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_WAR_HARM) of
				[]->
					{Player,<<VipBinMsg/binary,BinMsg/binary>>};
				[{_,WarList}|_]->
					NBossRanks=lists:keysort(#boss_dps.harm,WarList),
					NBossRanks2=lists:sublist(NBossRanks,10),
					RHarm=harm_self(Uid, WarList),
					BinTime=die_time(WorldBoss#world_boss.s_time,WorldBoss#world_boss.die_count),
					Hp=hp_self(Player),
					BinHp=msg_self_hp(Hp), 
					BinRank=msg_dps(Uid,RHarm,NBossRanks2),
					BinMsg=msg_map_data(StartTime,EndTime),
					{Player,<<BinHp/binary,BinTime/binary,BinMsg/binary,VipBinMsg/binary,BinRank/binary>>}
			end
	end.

%% 往家死亡复活剩余时时间
die_time(WorldBossTime,WorldBossCount)->
	Time=util:seconds(),
	case ?CONST_TSP_INTERVAL- abs(Time-WorldBossTime) of
		SS when SS>0 ->
			RMB=world_boss_api:boss_die_rs_rmb(WorldBossCount),
			msg_war_rs(SS,RMB);
		_->
			<<>>
	end.
%% 取出血量
hp_self(Player=#player{uid=Uid})->
	Hp=war_api:war_hp(Player),
	case ets:lookup(?ETS_WORLD_BOSS,Uid) of
		[]->
			ets:insert(?ETS_WORLD_BOSS,{Uid,Hp}),
			Hp;
		[{_,SHp}|_]->
			?IF(SHp>=Hp,Hp,SHp)
	end.

%% 取出自己的伤害值
harm_self(Uid,WarList)->
	case lists:keyfind(Uid,2,WarList) of
		#boss_dps{harm=Harm}->
			Harm;
		_-> 0
	end.
			

%% 造成伤害校正，更新boss血量	
boss_harm(#player{uid=Uid,lv=InfoLv,uname=Name,pro= Pro, info=Info,spid=SPid},WarB)->
	case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_ID) of
		[]->
			?skip;
		_->
			world_boss_srv:boss_harm_updata_cast(Info#info.map_id,SPid,Uid,InfoLv,Name,Pro,WarB)		
	end.

%% 列队更新信息
boss_harm_updata_cast_handle(_MapId,SPid,Uid,Lv,Name,Pro,{FoeType,Mid,Id,Stata,Harm})->
	case FoeType of
		?CONST_PLAYER->
			Hp=player_hp_update(Mid,Uid,Harm),
			BinMsg=scene_api:msg_hp_update(FoeType,Mid,Id,Stata,Hp),
			scene_api:broadcast_scene(SPid, BinMsg);
		?CONST_MONSTER->
			{Hp,DpsRankMsg}=monster_hp_update(Uid,Lv,Name,Pro,Id,Harm),
			BinMsg=scene_api:msg_hp_update(FoeType,Mid,Id,Stata,Hp),
			scene_api:broadcast_scene(SPid, <<BinMsg/binary,DpsRankMsg/binary>>);
		_->
			?skip
	end.

monster_hp_update(Uid,Lv,Name,Pro,BossId,Harm)->
	case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_HP) of
		[{_,{SHp,MaxHp}}|_]->
			{PHarm,HarmList}=boss_harm_self(Uid,Harm),
			?MSG_ECHO("============= ~w~n",[{SHp,Harm}]),
			case SHp>0 of
				?true->
					case SHp-Harm =< 0 of
						?true->
							BossDps=#boss_dps{uid=Uid,name=Name,lv=Lv,harm=PHarm,kill_boss=?CONST_TRUE},
							ets:insert(?ETS_WORLD_BOSS,{?CONST_BOSS_HP,{0,MaxHp}}),
							ets:insert(?ETS_WORLD_BOSS,{?CONST_BOSS_WAR_HARM,[BossDps|HarmList]}),
							stat_api:logs_boss(Uid,BossId),
							[_Hurt,_Money,_MoneyMax,KillMoney]=data_world_boss_reward:get(Lv),
							Reward={KillMoney,0,0,0,0,[]},
							BinMsg=broadcast_api:msg_broadcast_world_die({Uid,Name,Lv,Pro,0},BossId,Reward),
							chat_api:send_to_all(<<BinMsg/binary,BinMsg/binary>>),
							active_api:close_active(?CONST_ACTIVITY_WORLD_BOSS),
							{0, <<>>};
						_->
							BossHp=SHp-Harm,
							BossDps=#boss_dps{uid=Uid,name=Name,lv=Lv,harm=PHarm,kill_boss=?CONST_FALSE},
							HarmList2=[BossDps|HarmList],
							ets:insert(?ETS_WORLD_BOSS,{?CONST_BOSS_HP,{BossHp,MaxHp}}),
							ets:insert(?ETS_WORLD_BOSS,{?CONST_BOSS_WAR_HARM,HarmList2}),
							DpsRankMsg=monster_harm_update(Uid),
							{BossHp,DpsRankMsg}
					end;
				_->
					{0, <<>>}
			end;
		_->
			{0, <<>>}
	end.
					
player_hp_update(Mid,Uid,Harm)->
	case ets:lookup(?ETS_WORLD_BOSS,Mid) of
		[]->util:pid_send(Uid,?MODULE,player_hp_update_cb,?null),0;
		[{_,Hp}|_] when Hp=<0->
			ets:delete(?ETS_WORLD_BOSS,Mid),
			util:pid_send(Uid,?MODULE,player_hp_update_cb,?null),0;
		[{_,Hp}|_]->
			case Hp-Harm =< 0 of
				?true->
					ets:delete(?ETS_WORLD_BOSS,Mid),
					util:pid_send(Uid,?MODULE,player_hp_update_cb,?null),
					0;
				_->
					ets:insert(?ETS_WORLD_BOSS,{Mid,Hp-Harm}),
					Hp-Harm
			end
	end.

player_hp_update_cb(Player=#player{socket=Socket},_)->
	Time=util:seconds(),
%% 	WarList=
%% 		case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_WAR_HARM) of
%% 			[]->[];
%% 			[{_,WarList0}|_]->
%% 				WarList0
%% 		end,
%% 	Harm=harm_self(Uid,WarList),
%% 	Hp=hp_self(Player),
%% 	ets:insert(?ETS_WORLD_BOSS,{uid,Hp}),
	WorldBoss=role_api_dict:world_boss_get(),
	RMB=world_boss_api:boss_die_rs_rmb(WorldBoss#world_boss.die_count),
	BinMsg=msg_war_rs(?CONST_BOSS_RELIVE_TIME,RMB),
	WorldBoss2=WorldBoss#world_boss{s_time=Time},
	role_api_dict:world_boss_set(WorldBoss2),
	app_msg:send(Socket,BinMsg),
	Player.
			
monster_harm_update(Uid)->
	case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_WAR_HARM) of
		[]->
			<<>>;
		[{_,WarList}|_]->
			NBossRanks=lists:keysort(#boss_dps.harm,WarList),
			NBossRanks2=lists:sublist(NBossRanks,10),
			RHarm=harm_self(Uid,WarList),
			msg_dps(Uid,RHarm,NBossRanks2)
	end.

%% 更新自己的伤害值
boss_harm_self(Uid,Harm)->
	case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_WAR_HARM) of
		[{_,HarmList}|_]->
			case lists:keytake(Uid,#boss_dps.uid,HarmList) of
				{value,#boss_dps{harm=PHarm},HarmList2}->
					{PHarm+Harm,HarmList2};
				_->
					{Harm,HarmList}
			end;
		_->
			{Harm,[]}
	end.
	
%% Boss死亡更新信息
boss_die_exit()->
	BinMsg=broadcast_api:msg_broadcast_world_end(),
	chat_api:send_to_all(BinMsg),
	case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_MAP)of
		[{_,MapId}|_]->
			scene_api:enter_city(MapId),
			case ets:lookup(?ETS_WORLD_BOSS,?CONST_BOSS_WAR_HARM) of
				[]->RewardList2=[];
				[{_,RewardList}|_]->RewardList2=RewardList
			end,
			ets:delete_all_objects(?ETS_WORLD_BOSS),
			interval_reward(RewardList2),
			scene_api:stop_map(MapId);
		_->
			?skip
	end.
		
interval_reward(RewardList)->
	RewardList2=lists:keysort(#boss_dps.harm,RewardList),
	RewardList3=lists:reverse(RewardList2),
	Fun=fun(BossDps,Rank)->
				GoodsList=?IF(Rank=<3,data_world_boss_rank:get(Rank),[]),
				#boss_dps{uid=RecvUids,lv=Lv,harm=Harm,kill_boss=Flag}=BossDps,
				[Hurt,Money,MoneyMax,KillMoney]=data_world_boss_reward:get(Lv),
				Gold=trunc(erlang:min((Harm/Hurt)*Money,MoneyMax)),
				Title= <<"世界BOSS奖励">>,
				Content= mail_api:get_content(?CONST_ACTIVITY_MAIL_WOLD_BOSS,[Harm,Gold,Rank]),
				mail_api:send_mail_uids([RecvUids], Title, Content, GoodsList, [{?CONST_CURRENCY_GOLD,Gold}]),
				case Flag==?CONST_TRUE of
					?true->
						Title2= <<"世界BOSS击杀奖励">>,
						Content2= mail_api:get_content(?CONST_ACTIVITY_MAIL_KILL_BOSS,[KillMoney]),
						mail_api:send_mail_uids([RecvUids], Title2, Content2, [], [{?CONST_CURRENCY_GOLD,KillMoney}]);
					_->
						?skip
				end,
				Rank+1
		end,
%% 	Rank2=lists:foldl(Fun,1,RewardList3),
	spawn(fun()-> lists:foldl(Fun,1,RewardList3) end).
%% 	?MSG_ERROR("jiang li fa song ren shu : ~w~n",[Rank2]).

			



%% 金元鼓舞
boss_rmb_attr(Type,Player)->
	WorldBoss=role_api_dict:world_boss_get(),
	#world_boss{buy_count=BuyCount,buff=Buff}=WorldBoss,
	case boss_rmb_attr_full(Buff) of
		?true->
	case data_world_boss_attr:get(BuyCount+1) of 
		?null ->
			{?error,?ERROR_WORLD_BOSS_NOT_LIMIT}; %% 购买次数以达上限
		[RMB,Attrs]->
			case Type of
				0->
					BinMsg=msg_rmb_use(BuyCount+1,RMB),
					{Player,BinMsg};
				1->
					case role_api:currency_cut([boss_rmb_attr,[],<<"">>],Player, [{?CONST_CURRENCY_RMB,RMB}]) of 
						{?error,ErrorCode} ->
							{?error,ErrorCode};
						{?ok,Player2,MoneyBin}->
							WorldBoss2=boss_war_buff(WorldBoss,Attrs),
							WorldBoss3=WorldBoss2#world_boss{buy_count=BuyCount+1},
							BinMsg=msg_addition(WorldBoss3#world_boss.buff),
							role_api_dict:world_boss_set(WorldBoss3),
							{Player2,<<MoneyBin/binary,BinMsg/binary>>}
					end
			end
	end;
		_-> 
			{?error,?ERROR_WORLD_BOSS_NOT_ATTR} %% 您加成已到上限不能购买
	end.
	
%% 检查BUFF是否已满
boss_rmb_attr_full(OtherBuff)->
	case lists:keyfind(?CONST_ATTR_CRIT,1,OtherBuff) of
		{_,Value}->
			case lists:keyfind(?CONST_ATTR_ATTACK,1,OtherBuff) of
				{_,Value2}->
					Value+Value2<?CONST_BOSS_CRIT_ADD_LIMIT+?CONST_BOSS_ATTACK_ADD_LIMIT;
				_->
					?true
			end;
		_->
			?true
	end.

%% 加BUff
boss_war_buff(WorldBoss=#world_boss{buff=OtherBuff},AttrList)->
	Fun2=fun({AType,AValue},AWorldBuff)->
				 case lists:keytake(AType,1,AWorldBuff) of
					 {value,{_,TValue},AWorldBuff2}->
						 if
							 AType=:=?CONST_ATTR_CRIT ->
								 NValue=?IF(AValue+TValue>=?CONST_BOSS_CRIT_ADD_LIMIT,
											?CONST_BOSS_CRIT_ADD_LIMIT,AValue+TValue);
							 AType=:=?CONST_ATTR_ATTACK->
								 NValue=?IF(AValue+TValue>=?CONST_BOSS_ATTACK_ADD_LIMIT,
											?CONST_BOSS_ATTACK_ADD_LIMIT,AValue+TValue);
							 ?true->
								 NValue=AValue+TValue
						 end,	 
						 [{AType,NValue}|AWorldBuff2];
					 _->
						 [{AType,AValue}|AWorldBuff]
				 end
		 end,	
	NOtherBuff=lists:foldr(Fun2,OtherBuff,AttrList),
	WorldBoss#world_boss{buff=NOtherBuff}.


%% 死亡次数获取钻石消耗
boss_die_rs_rmb(D)->
	case D > ?CONST_BOSS_TIMES_RELIVE of
		?true->
			data_world_boss_relive:get(0);
		?false->
			data_world_boss_relive:get(D+1)
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% msg_xxxx?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 返回地图数据 [37020]
msg_map_data(Time,Stime)->
    RsList = app_msg:encode([{?int32u,Time},
        {?int32u,Stime}]),
    app_msg:msg(?P_WORLD_BOSS_MAP_DATA, RsList).

% 是否开启鼓舞 [37051]
msg_vip_rmb()->
    app_msg:msg(?P_WORLD_BOSS_VIP_RMB,<<>>).


% 自己伤害 [37053]
msg_self_hp(Hp)->
    RsList = app_msg:encode([{?int32u,Hp}]),
    app_msg:msg(?P_WORLD_BOSS_SELF_HP, RsList).

% DPS排行 [37060]
msg_dps(Uid,SelfHarm,Data)->
	Rs=app_msg:encode([{?int32u,Uid},{?int32u,SelfHarm},{?int16u,length(Data)}]),
	Data2=lists:keysort(#boss_dps.harm,Data),
	Data3=lists:reverse(Data2),
    RsList = msg_dps2(Data3,Rs,1),
    app_msg:msg(?P_WORLD_BOSS_DPS, RsList).

msg_dps2([],Rs,_Rank)->Rs;
msg_dps2([BossDps|Data],Rs,Rank)->
	#boss_dps{uid=Uid,name=Name,harm=Harm}=BossDps,
	Rs2=app_msg:encode([{?int32u,Uid},{?string,Name},
						{?int16u,Rank},{?int32u,Harm}]),
	Rs3= <<Rs/binary,Rs2/binary>>,
	msg_dps2(Data,Rs3,Rank+1).

% 返回结果 [37090]
msg_war_rs(Time,Rmb)->
    RsList = app_msg:encode([{?int32u,Time},
        {?int16u,Rmb}]),
    app_msg:msg(?P_WORLD_BOSS_WAR_RS, RsList).


% 复活成功 [37120]
msg_revive_ok()->
    app_msg:msg(?P_WORLD_BOSS_REVIVE_OK,<<>>).

	% 返回消耗信息 [37160]
msg_rmb_use(Count,Rmb)->
    RsList = app_msg:encode([{?int8u,Count},
        {?int32u,Rmb}]),
    app_msg:msg(?P_WORLD_BOSS_RMB_USE, RsList).


% 随机加成 [37130]
msg_addition(OtherList)->
	Rs=app_msg:encode([{?int16u,length(OtherList)}]),
	Fun=fun({Type,Value},Rs2)->
				Rs3=app_msg:encode([{?int8u,Type},{?int32u,Value}]),
				<<Rs2/binary,Rs3/binary>>
		end,
	RsList=lists:foldl(Fun,Rs,OtherList),
    app_msg:msg(?P_WORLD_BOSS_ADDITION, RsList).