%% Author  : Kevin
%% Created: 2012-9-5
%% Description: TODO: Add description to role_mod
-module(war_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


%%
%% Exported Functions
%%

-export([
%% 		 war_player/1
		 war_harm/6, 
		 war_player/3,
		 war_player_cb/2,
		 war_all_type_harm/13,
		 war_all_type_harm_cb/2,
		 war_use_skill/5,
		 war_hp/1,
		 war_partner_hp/0,
		 war_pk/3,
		 war_pk_cb/2,
		 war_pk_cb2/2,
		 war_time/1,
		 war_pk_res/1,
		 war_pk_escape/2,
		 b/1,
		 b/3,
		 c/2,
		 msg_pk_time/2,
		 msg_skill/5,
		 msg_pk_receive/3,
%% 		 msg_monster_attr/2,
		 msg_player_war/10,
		 msg_pk_lose/1
		]).



%%
%% Local Functions
%%

war_hp(#player{attr=Attr})->
	Attr#attr.hp.

war_partner_hp()->
	#inn{partners=Partners}=role_api_dict:inn_get(),
	[#partner_s{partner_id=PartnerId,lv=Lv,hp=PAttr#attr.hp,hp_max=PAttr#attr.hp}||#partner{partner_id=PartnerId,state=State,lv=Lv,attr=PAttr}<-Partners,
								   State==?CONST_INN_STATA3].

%% 伤害校正  
war_harm(AttrType,SkillId,Lv,Harm,Attr,FoeAttr)->
	?true.
%% 	HarmP=skill_api:skill_harm_get(SkillId,Lv),
%% 	case AttrType of
%% 		?CONST_TRUE->
%% 			NHarm=?EXPRESSION_WAR_HARM(?CONST_BATTLE_FORMULA_A,Attr#attr.skill_att,
%% 									   ?CONST_BATTLE_FORMULA_B,FoeAttr#attr.skill_def,
%% 									   ?CONST_BATTLE_FORMULA_C,Attr#attr.defend_down,
%% 									   HarmP,Attr#attr.bonus,FoeAttr#attr.reduction,
%% 									   ?CONST_BATTLE_FORMULA_F);
%% 		_->
%% 			NHarm=?EXPRESSION_WAR_HARM(?CONST_BATTLE_FORMULA_A,Attr#attr.strong_att,
%% 									   ?CONST_BATTLE_FORMULA_B,FoeAttr#attr.strong_def,
%% 									   ?CONST_BATTLE_FORMULA_C,Attr#attr.defend_down,
%% 									   HarmP,Attr#attr.bonus,FoeAttr#attr.reduction,
%% 									   ?CONST_BATTLE_FORMULA_E)
%% 	end,
%% 	?MSG_ECHO("=================== ~w~n",[{Harm,NHarm,(Harm-NHarm*2)}]),
%% 	(Harm-NHarm*2)<500.

%% 自动战斗挑战对手信息
war_player(Socket,Uid,Rank)->
	case role_api:mpid(Uid) of
		Pid when is_pid(Pid) ->
			util:pid_send(Uid,?MODULE,war_player_cb,{Socket,Rank});
		_->
			case role_api_dict:player_get(Uid) of
				{?ok,Player} when is_record(Player,player)->
					war_player_cb(Player,{Socket,Rank});
				_->
					{?error,?ERROR_NOT_PLAYER}
			end
	end.
%% 战斗信息
war_player_cb(Player=#player{uid=Uid,uname=Name,lv=Lv,pro=Pro,sex=Sex,info=Info,attr=Attr},{Socket,Rank})->
	#info{skin_weapon=SkinWeapon,skin_armor=SkinArmor}=Info,
	Skills= skill_api:skillIds_equip(Uid),
	BinMsg=msg_player_war(Uid,Name,Lv,Pro,Sex,SkinWeapon,SkinArmor,Rank,Attr,Skills),
	BinMsg2=arena_api:msg_war_data(BinMsg),
	app_msg:send(Socket, BinMsg2),
	Player.
	
%% 战斗伤害的校正
%% Type     战斗类型     	 ：?CONST_WAR_PARAS_1_
%% OneType  攻击方类型   	 ：?CONST_PLAYER | ?CONST_PARTNER | ?CONST_MONSTER
%% OneId	    攻击方id		 ：主角攻击为0，伙伴攻击为 伙伴ID
%% FoeType  被攻击方类型  	 ：?CONST_PLAYER | ?CONST_PARTNER | ?CONST_MONSTER
%% AttrType 攻击类型		 ：技能攻击或者普通攻击
%% id		被攻击方ID	 ：玩家uid|怪物ID|伙伴id
%% Mid		被攻击放唯一ID	 ：玩家为0|怪物唯一ID|伙伴为主人Uid
%% State		攻击状态		 ：见常量 ?CONST_WAR_DISPLAY_
war_all_type_harm(Player=#player{attr=Attr},Type,OneType,_OneId,OneMon,FoeType,AttrType,Id,Mid,SkillId,Lv,Stata,Harm)->
	WarB={FoeType,Mid,Id,Stata,Harm},
	case OneType of
		?CONST_PLAYER->
			war_attr_obj(Player,Type,FoeType,Attr,AttrType,SkillId,Lv,Harm,Mid,Id,WarB);
		?CONST_PARTNER->
			#inn{partners=Partners}=role_api_dict:inn_get(),
			case lists:keyfind(OneMon,#partner.partner_id,Partners) of
				#partner{attr=PartnerAttr}->
					war_harm_obj2(Player,Type,AttrType,SkillId,Lv,Harm,WarB,PartnerAttr,Attr);
				_->
					?skip
			end;
		?CONST_MONSTER->
			#d_monster{attr=MonsterAttr}=data_scene_monster:get(OneMon),
			war_harm_obj2(Player,Type,AttrType,SkillId,Lv,Harm,WarB,MonsterAttr,Attr);
		_->
			?skip
	end.

war_attr_obj(Player,Type,FoeType,Attr,AttrType,SkillId,Lv,Harm,Mid,Id,WarB)->
	case FoeType of
		?CONST_PLAYER->
			util:pid_send(Mid,?MODULE,war_all_type_harm_cb,{Type,Attr,AttrType,SkillId,Lv,Harm,WarB});
		?CONST_PARTNER->
			util:pid_send(Mid,?MODULE,war_all_type_harm_cb,{Id,Type,Attr,AttrType,SkillId,Lv,Harm,WarB});
		?CONST_MONSTER->
			case data_scene_monster:get(Id) of
				#d_monster{attr=MonsterAttr}->
					war_harm_obj(Player,Type,Mid,AttrType,SkillId,Lv,Harm,WarB,Attr,MonsterAttr);
				_->
					?MSG_ECHO("====== mei you guai wu shuju ~w~n ",[Id]),
					?skip
			end;
		_->
			?skip
	end.

war_all_type_harm_cb(Player=#player{attr=PAttr},{Type,Attr,AttrType,SkillId,Lv,Harm,WarB})->
	war_harm_obj(Player,Type,0,AttrType,SkillId,Lv,Harm,WarB,Attr,PAttr),
	Player;
war_all_type_harm_cb(Player,{Id,Type,Attr,AttrType,SkillId,Lv,Harm,WarB})->
	#inn{partners=Partners}=role_api_dict:inn_get(),
	case lists:keyfind(Id,#partner.partner_id,Partners) of
		#partner{attr=PartnerAttr}->
			?MSG_ECHO("============= ",[]),
			war_harm_obj(Player,Type,0,AttrType,SkillId,Lv,Harm,WarB,Attr,PartnerAttr);
		R->
			?MSG_ECHO("=========== ~w~n",[R]),
			?skip
	end,
	Player.

war_harm_obj(Player,Type,_Mid,AttrType,SkillId,Lv,Harm,WarB,Attr,MonsterAttr)->
	war_harm_obj2(Player,Type,AttrType,SkillId,Lv,Harm,WarB,Attr,MonsterAttr).

war_harm_obj2(Player=#player{spid=Spid},Type,AttrType,SkillId,Lv,Harm,WarB,Attr,MonsterAttr)->
	case war_harm(AttrType,SkillId,Lv,Harm,Attr,MonsterAttr) of
		?true->
			case Type of
				?CONST_WAR_PARAS_1_WORLD_BOSS->
					world_boss_api:boss_harm(Player,WarB),
					Player;
				?CONST_WAR_PARAS_1_CLAN2 ->
					clan_boss_api:boss_harm(Player,WarB),
					Player;
				?CONST_WAR_PARAS_1_TEAM->
					scene_api:war_harm(Spid,WarB);
				?CONST_WAR_PARAS_1_PK->
					scene_api:war_harm(Spid,WarB);
				_->
					?skip
			end;
		_->
			?skip
	end.


%% 技能广播
war_use_skill(Type,Uid,Id,SkillId,SkillLv)->
	case Type of
		?CONST_PARTNER->
			msg_skill(Type,Uid,Id,SkillId,SkillLv);
		_->
			msg_skill(Type,0,Uid,SkillId,SkillLv)
	end.

%% ｐｋ
war_pk(#player{mpid=MPid},Uid,Res)->
	case Res of
		?CONST_TRUE->
			util:pid_send(Uid,?MODULE,war_pk_cb,{MPid,Uid});
		_->
			?skip
	end.

war_pk_cb(Player=#player{mpid=PMPid,info=Info},{MPid,MapSuffix})->
	case get(war_pk) of
		P when is_integer(P)->
			case is_pid(MPid) of
				?true->
					case Info#info.map_type of
						?CONST_MAP_TYPE_CITY->
							scene_api:stop_map_pk_call(?CONST_INVITE_PK_SENCE, MapSuffix),
							Player2 = scene_api:enter_map(Player,?CONST_INVITE_PK_SENCE,?CONST_INVITE_PK_LEFT,MapSuffix),
							util:pid_send(MPid,?MODULE,war_pk_cb2,{PMPid,MapSuffix}),
							Player2;
						_->
							BinMsg=system_api:msg_error(?ERROR_WAR_NOT_PK_SAFE),
							app_msg:send(MPid,BinMsg),
							Player
					end;
				_->
					Player
			end;
		_->
			Player
	end.

war_pk_cb2(Player=#player{info=Info},{PMPid,MapSuffix})->
	case Info#info.map_type of
		?CONST_MAP_TYPE_CITY->
			Player2=scene_api:enter_map(Player,?CONST_INVITE_PK_SENCE,?CONST_INVITE_PK_RIGHT,MapSuffix),
			Player2;
		_->
			BinMsg=system_api:msg_error(?ERROR_WAR_NOT_HER_FOE),
			app_msg:send(PMPid,BinMsg),
			Player
	end.

war_time(Spid)->
	StartTime=util:seconds(),
	EndTime	 =StartTime+3*60,
	BinMsg=msg_pk_time(StartTime,EndTime),
	put(war_time_pk,StartTime),
	?MSG_ECHO("================war_time_pk ",[]),
	scene_api:broadcast_scene(Spid, BinMsg).

%% PK胜利或者失败
war_pk_res(PlayerSList)->
	case get(war_time_pk) of
		?undefined->
			LosUids=war_pk_die(PlayerSList,?false),
			[scene_mod:do_broadcast(msg_pk_lose(LosUid))||LosUid<-LosUids];
		StartTime->
			Time=util:seconds(),
			if
				Time - StartTime =< 180 ->
					LosUids=war_pk_die(PlayerSList,?false);
				?true->
					LosUids=war_pk_die(PlayerSList,?true)
			end,
			[scene_mod:do_broadcast(msg_pk_lose(LosUid))||LosUid<-LosUids]
	end.
					

%%PK逃跑广播
war_pk_escape2(Uid,PlayerSList)->
	LosUids=war_pk_die(PlayerSList,?false),
	case length(lists:delete(Uid,LosUids)) > 0 of
		?true->
			?skip;
		_->
			scene_mod:do_broadcast_handle(Uid,msg_pk_lose(Uid))
	end.

%%PK逃跑广播
war_pk_escape(Uid,PlayerSList)->
	case get(war_time_pk) of
		?undefined->
			war_pk_escape2(Uid,PlayerSList);
		StartTime->
			Time=util:seconds(),
			if
				Time - StartTime =< 180 ->
					war_pk_escape2(Uid,PlayerSList);
				?true->
					?skip
			end
	end.


war_pk_die(PlayerSList,Flag)->
	case Flag of
		?false->
			war_pk_die2(PlayerSList);
		_->
			case war_pk_die2(PlayerSList) of
				[]->
					war_pk_die3(PlayerSList);
				List->
					List
			end
	end.
			
war_pk_die2(PlayerSList)->
	Fun=fun(#player_s{uid=Uid,hp_now=Hp,partners=Partners},LosAcc)->
				case Hp =< 0 of
					?true->
						case lists:sum([ParHp||{_,_,ParHp,_}<-Partners]) =< 0 of
							?true->
								[Uid|LosAcc];
							_->
								LosAcc
						end;
					_->
						LosAcc
				end
		end,
	lists:foldl(Fun,[],PlayerSList).

war_pk_die3(PlayerSList)->
	Fun=fun(#player_s{uid=Uid,hp_now=Hp,partners=Partners},Acc)->
				Hp2=Hp + lists:sum([ParHp||{_,_,ParHp,_}<-Partners]),
				[{Uid,Hp2}|Acc]
		end,
	HpAcc=lists:foldl(Fun,[],PlayerSList),
	[{Uid,_}|_]=lists:keysort(2,HpAcc),
	[Uid].

b(N)->
%% 	NC=trunc(N/?CONST_WRESTLE_GROUNP_COUNT),
%% 	NC2=lists:duplicate(?CONST_WRESTLE_GROUNP_COUNT,NC),
%% 	NR=N rem ?CONST_WRESTLE_GROUNP_COUNT,
%% 	GP=b(NC2,NR,[]),
    GP = wrestle_api:divide(N),
	List=[lists:seq(1,G)||G<-GP],
	PP=[c(L,[])||L<-List],
	[p(PA,[],[],[],[])||PA<-PP].
 

b(NC,0,Acc)->lists:append(Acc,NC);
b([N|NC],NR,Acc)->
	b(NC,NR-1,[N+1|Acc]).

c([],Acc)->
	Acc;
c([L|LS],Acc)->	
	D=c(L,LS,[]),
	c(LS,D++Acc).

c(_L,[],Acc)->
	Acc;
c(L,[L1|LS],Acc)->
	c(L,LS,[{L,L1}|Acc]).

p([],Acc,_All,[],Use)->
	[Acc|Use];
p([],Acc,All,Sa,Use)->
	p(Sa,[],All,[],[Acc|Use]);
p([P|PP],Acc,All,Sa,Use)->
	case ca(P,All) of
		?true->
			p(PP,Acc,All,Sa,Use);
		_->
			case ca2(P,Acc) of
				?true->
					p(PP,[P|Acc],[P|All],Sa,Use);
				_->
					p(PP,Acc,All,[P|Sa],Use)
			end
	end.

ca(_,[])->
	?false;
ca(P,[A|All])->
	?IF(P==A,?true,ca(P,All)).

ca2(_,[])->
	?true;
ca2({A,B},[{C,D}|Acc])->
	if
		A==C orelse A==D->?false;
		B==C orelse B==D->?false;
		?true->ca2({A,B},Acc)
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% msg_xxxx?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 战斗数据块 [6010]
msg_player_war(Uid,Name,Lv,Pro,Sex,SkinWeapon,SkinArmor,Rank,Attr,Skills)->
    RsList1 = app_msg:encode([{?int32u,Uid},{?string,Name},{?int8u,Lv},{?int8u,Pro},{?int8u,Sex},
							  {?int16u,SkinWeapon},{?int16u,SkinArmor},{?int16u,Rank}]),
	RsList2 = role_api:msg_xxx2(Attr),
	RsList3 = app_msg:encode([{?int16u,length(Skills)}]),
	Fun=fun({Idx,SkillId,SkillLv},Acc)->
				RsListE = app_msg:encode([{?int16u,Idx},{?int32u,SkillId},{?int16u,SkillLv}]),
				<<Acc/binary,RsListE/binary>>
		end,
	lists:foldl(Fun, <<RsList1/binary,RsList2/binary,RsList3/binary>>,Skills).


% 释放技能广播 [6030]
msg_skill(Type,Uid,Id,SkillId,SkillLv)->
    RsList = app_msg:encode([{?int8u,Type},{?int32u,Uid},{?int32u,Id},{?int16u,SkillId},{?int8u,SkillLv}]),
    app_msg:msg(?P_WAR_SKILL, RsList).


% 接收PK邀请 [6060]
msg_pk_receive(Uid,PName,Time)->
    RsList = app_msg:encode([{?int32u,Uid},{?string,PName},{?int32u,Time}]),
    app_msg:msg(?P_WAR_PK_RECEIVE, RsList).

% PK结束死亡广播 [6080]
msg_pk_lose(Uid)->
    RsList = app_msg:encode([{?int32u,Uid}]),
    app_msg:msg(?P_WAR_PK_LOSE, RsList).

	% PK时间 [6061]
msg_pk_time(StartTime,EndTime)->
    RsList = app_msg:encode([{?int32u,StartTime},
        {?int32u,EndTime}]),
    app_msg:msg(?P_WAR_PK_TIME, RsList).
