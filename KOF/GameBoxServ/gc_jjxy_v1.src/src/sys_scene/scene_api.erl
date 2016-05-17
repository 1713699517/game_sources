%% Author: Administrator
%% Created: 2011-8-7
%% Description: TODO: Add description to scenes_api
-module(scene_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([
		 interval/0,
		 reg_name/2,
		 broadcast_scene/2,
		 broadcast_scene/3,
		 broadcast_scene_cb/2,
		 
		 set_map_xy/1,
		 set_map_xy_cb/2,
		 
		 relink/1,
		 
		 times_carom/3,
		 times_hit/3,
		 die/2,
		 die_partner/3,
		 relive/1,
		 
		 enter_map/4,
		 enter_login/1,
		 enter_door/2,
		 enter_last_city/1,
		 check_map_xy/3,
		 enter/7,
		 enter_fly/4,
		 
		 player_list/1,
		 player_list_new/1,
		 
		 collect_list/1,
		 map_uid/1,
		 player_list2/1,
		 exit_scene/1,	
		 exit_scene/3,
		 move/7,
		 move_new/7,
		 
		 map_doors/1,
		 
		 war_harm/2,
		 ko_hps_get/1,
		 set_player_posxy/3,
		 
		 world_add_monster/2,
		 clan_add_monster/3,
		 uid_list/1,
		 enter_city/1,
		 enter_city_cb/2,
		 stop_map/1,
		 stop_map_kof/2,
		 stop_map_pk_call/2,
		 
		 mons_kill/3,
		 move_monster/3,
		 monster_list/2,
		 monster_knock/3,
		 
		 ext_record_player_s/1,
		 ext_record_monster_s/4,
		 ext_record_scene_data/2,
		 ext_broadcast_handle/2,
		 ext_init_map/4,
		 ext_interval_handle/3,
		 ext_move_handle/6,
		 ext_move_new_handle/6,
		 ext_player_list_handle/3,
		 ext_monster_knock_handle/3,
		 ext_change_war_state_handle/2,
		 ext_war_over_refresh_monster/3,
		 ext_exit_handle/3,
		 ext_find_map_bornxy/2,
		 
		 ext_change_level_handle/3,
		 ext_change_team_leader_handle/2,
		 ext_change_mount_handle/4,
		 
		 change_clan/4,
		 change_level/2,
		 change_vip/2,
		 change_team_leader/3,		
		 change_mount/3,
		 change_war_state/2]).
		 
-export([msg_enter_ok/3,	 	msg_move_rece/2,	  
		 msg_set_player_xy/3,	msg_role_data/2,
		 msg_role_data_new/2,
		 msg_change_clan/3,		msg_level_up/2,
		 msg_change_team/2,		msg_move_rece/6,
		 msg_change_mount/3,	msg_change_war/2,
		 msg_monster_data/1,	msg_monster_data/3,
		 msg_out/4,				msg_idx_monster/2,
		 msg_move_rece/1,		msg_partner_data/3,
		 msg_partner_data_new/5,
		 msg_out/5,				msg_relive_ok/0,
		 msg_hp_update/5,		msg_vip_up/2]).

-export([
		 check_scenes_mount/1,
		 check_scenes_ride/1
		]).

%% 定时调用
interval() ->
	MapWorker = scene_sup:which_children(),
	interval(MapWorker).
interval([]) ->
	?ok;
interval([{?undefined,Pid,worker,[scene_srv]}|MapWorker]) ->
	scene_srv:interval_cast(Pid),
	interval(MapWorker).

%% reg_name(MapID, Suffix) -> atom()
reg_name(MapID, Suffix) ->
	erlang:list_to_atom("scene_" ++ erlang:integer_to_list(MapID) ++ "_" ++ erlang:integer_to_list(Suffix)).


%% 地图广播
broadcast_scene(_SPid, <<>>) ->
	?skip;
broadcast_scene(SPid, BinMsg) when erlang:is_pid(SPid) ->
	scene_srv:broadcast_cast(SPid, 0, BinMsg);
broadcast_scene(Uid, BinMsg) when erlang:is_integer(Uid) ->
	util:pid_send(Uid, ?MODULE, broadcast_scene_cb, BinMsg);
broadcast_scene(SPid, BinMsg) ->
	?MSG_ERROR("{SPid, BinMsg} : ~p~n", [{SPid, BinMsg}]),
	?ok.

broadcast_scene_cb(#player{spid=Spid}=Player, BinMsg) ->
	scene_srv:broadcast_cast(Spid, 0, BinMsg),
	Player.

%% 地图pid广播所有场景玩家(除这个Uid)
broadcast_scene(SPid,Uid, BinMsg) when erlang:is_pid(SPid) ->
	scene_srv:broadcast_cast(SPid, Uid, BinMsg);
broadcast_scene(SPid, Uid, BinMsg) ->
	?MSG_ERROR("{SPid, Uid, BinMsg} : ~p~n", [{SPid, Uid, BinMsg}]),
	?ok.

set_map_xy(Uid) ->
	MapId	= 1010,
	X		= 27,
	Y		= 59,
	MapLv	= 0,
	MapType	= ?CONST_MAP_TYPE_CITY,
	util:pid_send(Uid, ?MODULE, set_map_xy_cb, {MapId,MapLv,X,Y,MapType}).

set_map_xy_cb(Player,{MapId,MapLv,X,Y,MapType}) ->
	case enter(Player, MapId,MapLv,X,Y,MapType,0) of
		{?ok, NewPlayer} ->
			NewPlayer;
		{?error, _ErrorCode} ->
			Player
	end.

relink(#player{spid=Spid,uid=Uid,info=Info}=Player) ->
	case lists:member(Info#info.map_type, ?COPY_MAP_TYPES) of
		?true ->
			copy_api:exit(Spid, Uid),
			case Info#info.copy_id of
				?CONST_COPY_FIRST_COPY ->
					role_api:role_copy_attr(Player, ?null);
				_ ->
					?skip
			end;
		_ ->
			?skip
	end,
	enter_login(Player).

% 连击次数
times_carom(Spid,Uid,Times) ->
	copy_srv:times_carom_cast(Spid,Uid,Times).


% 被击次数
times_hit(Spid,Uid,Times) ->
	copy_srv:times_hit_cast(Spid,Uid,Times).

% 死亡
die(Spid,Uid) ->
	scene_srv:die_cast(Spid,Uid).

% 伙伴死亡
die_partner(Spid,Uid,PartnerId) ->
	scene_srv:die_partner_cast(Spid,Uid,PartnerId).

% 玩家请求复活
relive(#player{uid=Uid,info=Info}=Player) ->
	case lists:member(Info#info.map_type, ?COPY_TYPES) of
		?true ->
			case data_scene_copy:get(Info#info.copy_id) of
				#d_copy{relive_lim=ReTimes} ->
					case scene_mod:get_player(Uid) of
						#player_s{die=Die,relive_times=Times}=PlayerS ->
							case Die of
								?true ->
									case Times < ReTimes of
										?true ->
											relive_ok(Player,PlayerS);
										_ ->
											{?error,?ERROR_UNKNOWN}
									end;
								_ ->
									{?error,?ERROR_UNKNOWN}
							end;
						_ ->
							{?error,?ERROR_UNKNOWN}
					end;
				_ ->
					{?error,?ERROR_UNKNOWN}
			end;
		_ ->
			{?error,?ERROR_UNKNOWN}
	end.

relive_ok(#player{spid=Spid,socket=Socket}=Player,#player_s{relive_times=Times,hp_max=HpMax}=PlayerS) ->
	Rmb = 10,
	case role_api:currency_cut([relive_ok,[],<<"复活消耗">>],Player,[{?CONST_CURRENCY_RMB,Rmb}]) of
		{?ok,Player2,Bin1} ->
			NewPlayerS = PlayerS#player_s{die=?false,relive_times=Times+1,hp_now=HpMax},
			ets:insert(?ETS_MAP_PLAYER, NewPlayerS),
			Bin2 = msg_relive_ok(),
			app_msg:send(Socket, <<Bin1/binary,Bin2/binary>>),
			copy_srv:relive_ok_cast(Spid,NewPlayerS),
			{?ok,Player2};
		{?error,ErrorCode} ->
			{?error,ErrorCode}
	end.

%% HarmData: {Type,Uid,PartnerId,State,Harm}
%% Type: 玩家|伙伴|怪物
%% Uid:  Uid|0|怪物mid
%% PId:	 Uid|Pid|0
%% Sta:  见常量
%% Har:  伤害
war_harm(Spid,HarmData) -> 
	?MSG_ECHO("------------------~w~n",[{Spid,HarmData}]),
	scene_srv:war_harm_cast(Spid,HarmData).

ko_hps_get(Uids) ->
	Fun = fun(Uid,HpAcc) ->
				  case scene_mod:get_player(Uid) of
					  #player_s{hp_now=Hp} ->
						  HpAcc ++ [{Uid,Hp}];
					  _ ->
						  HpAcc
				  end
		  end,
	lists:foldl(Fun, [], Uids).

set_player_posxy(#player{uid=Uid,spid=SPid,info=Info,country=Country}=Player,Flag,Mtype) ->
	case Flag of
		?CONST_TRUE ->
			Player;
		?CONST_FALSE ->
			case Mtype of
				?CONST_MAP_TYPE_COPY_HERO ->
					Player;
				_ ->
					Dscene	= data_scene:scene(Info#info.map_id),
					{NewX,NewY}	= scene_mod:find_map_bornxy(Dscene#d_scene.born,Country),
					Info2 = Info#info{pos_x=NewX, pos_y=NewY},
					if Mtype =:= ?CONST_MAP_TYPE_COPY_NORMAL ->
						   copy_srv:set_player_posxy_cast(SPid,Uid,NewX,NewY,Mtype),
						   Player#player{info=Info2};
					   Mtype =:= ?CONST_MAP_TYPE_COPY_HERO ->
						   hero_srv:set_player_posxy_cast(SPid,Uid,NewX,NewY,Mtype),
						   Player#player{info=Info2};
					   ?true ->
						   scene_srv:set_player_posxy(SPid,Uid,NewX,NewY,Mtype),
						   Player#player{info=Info2}
					end
			end
	end.

world_add_monster(MapId,MonsInfo) ->
	case scene_mod_manager:select_handle(MapId, 0, ?CONST_MAP_TYPE_BOSS) of
		?null ->
			?skip;
		Pid ->
			scene_srv:add_monster_cast(Pid,MonsInfo)
	end.

clan_add_monster(MapId,ClanId,MonsInfo) ->
	case scene_mod_manager:select_handle(MapId, ClanId, ?CONST_MAP_TYPE_CLAN_BOSS) of
		?null ->
			?skip;
		Pid ->
			scene_srv:add_monster_cast(Pid,MonsInfo)
	end.

uid_list(Spid) when is_pid(Spid) ->
	scene_srv:uid_list_call(Spid);
uid_list(MapId) ->
	case scene_mod_manager:get_spids(MapId) of
		[] ->
			[];
		[Spid|_] ->
			scene_srv:uid_list_call(Spid)
	end.

enter_city(MapId) ->
	case scene_mod_manager:get_spids(MapId) of
		[] ->
			?skip;
		Spids ->
			[scene_srv:enter_city_cast(Spid) || Spid <- Spids]
	end.

enter_city_cb(#player{info=Info}=Player,_) ->
	#info{map_last=MapId,pos_x_last=X,pos_y_last=Y} = Info,
	case data_scene:scene(MapId) of
		#d_scene{scene_type=SceneType,lv=MapLv} ->
			case enter(Player, MapId, MapLv, X, Y, SceneType, 0) of
				{?ok, Player2} ->
					Player2;
				{?error, _ErrorCode} ->
					Player
			end;
		_ ->
			Player
	end.

stop_map(MapId) ->
	SpidList = scene_mod_manager:get_spids(MapId),
	[scene_srv:stop_map_cast(Spid) || Spid <- SpidList].

stop_map_kof(MapId, Suffix) ->
	case data_scene:scene(MapId) of
		#d_scene{scene_type=?CONST_MAP_TYPE_KOF} ->
			SpidList = scene_mod_manager:get_spids(MapId, Suffix),
			[scene_srv:stop_map_cast(Spid) || Spid <- SpidList];
		_ ->
			?skip
	end.

stop_map_pk_call(MapId, Suffix) ->
	case data_scene:scene(MapId) of
		#d_scene{scene_type=?CONST_MAP_TYPE_INVITE_PK} ->
			SpidList = scene_mod_manager:get_spids(MapId, Suffix),
			[scene_srv:stop_map_call(Spid) || Spid <- SpidList];
		_ ->
			?skip
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 进入地图
enter_map(Player,MapId,Pos,Suffix) ->
	Player2 = enter_fly(Player,MapId,Pos,Suffix),
	Player2.

% 角色登录进地图
enter_login(#player{socket=Socket,info=Info}=Player) ->
	#info{map_id=MapId,pos_x=X,pos_y=Y,map_last=MapIdLast,pos_x_last=XLast,pos_y_last=YLast} = Info,
	PlayerSList = [scene_mod:record_player_s(Player)],  
	% 根据当前MapId来找地图进程
	case scene_mod_manager:select_handle(MapId,0,?CONST_MAP_TYPE_CITY) of
		?null ->% 地图不存在
			% 根据上次退出前的MapId来找地图进程
			case scene_mod_manager:select_handle(MapIdLast,0,?CONST_MAP_TYPE_CITY) of
				?null ->
					{DefaultMapId,DefaultPosx,DefaultPosy} = {?CONST_MAP_DEFAULT_MAP,?CONST_MAP_DEFAULT_POSX,?CONST_MAP_DEFAULT_POSY},
					case scene_mod_manager:select_handle(DefaultMapId,0,?CONST_MAP_TYPE_CITY) of
						?null ->
							BinMsg = system_api:msg_error(?ERROR_SCENES_MAP_NULL),
							app_msg:send(Socket, BinMsg),
							Player;
						DefaultPid ->
							enter_cast(DefaultPid, PlayerSList, DefaultPosx, DefaultPosy),
							MapType = map_type(DefaultMapId),
							Info2 = Info#info{pos_x=DefaultPosx, pos_y=DefaultPosx, map_id=DefaultMapId, map_type=MapType},
							Player#player{spid=DefaultPid,info=Info2}
					end;
				PidLast	->
					enter_cast(PidLast, PlayerSList, XLast, YLast),
					MapType = map_type(MapIdLast),
					Info2 = Info#info{pos_x=X, pos_y=Y, map_id=MapIdLast, map_type=MapType},
					Player#player{spid=PidLast,info=Info2}
			end;
		Pid   ->
			enter_cast(Pid, PlayerSList, X, Y),
			MapType = map_type(MapId),
			Info2	= Info#info{pos_x = X, pos_y = Y, map_id = MapId,
								pos_x_last 	= Info#info.pos_x,
								pos_y_last 	= Info#info.pos_y,
								map_last   	= Info#info.map_id,
								map_type	= MapType},
			Player#player{spid=Pid,info=Info2}
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
enter_door(#player{socket=Socket,info=Info,country=Country}=Player, DoorId) ->
	Doors = map_doors(Info#info.map_id),
	case lists:member(DoorId,Doors) of
		?true ->
			case data_scene_door:get(DoorId) of
				#d_scene_door{type=?CONST_MAP_DOOR_MAP,transfer_id=DmapId} ->
					case data_scene:scene(DmapId) of
						#d_scene{scene_type=DsceneType,born=Dborn,lv=MapLv} ->
							{X,Y} = scene_mod:find_map_bornxy(Dborn, Country),
							case enter(Player, DmapId, MapLv, X, Y, DsceneType, 0) of
								{?ok, NewPlayer} ->
									NewPlayer;
								{?error, ErrorCode} ->
									BinMsg = system_api:msg_error(ErrorCode),
									app_msg:send(Socket, BinMsg),
									Player
							end;
						_ ->
							?MSG_ERROR("--------NO Data~n",[]),
							Player
					end;
				_ ->
					?MSG_ERROR("--------NO Data OR Type Error~n",[]),
					Player
			end;
		_ ->
			?MSG_ERROR("--------NO DoorId In Data~n",[]),
			Player 
	end.

%% 回到上一个城镇地图
%% arg		: Player
%% return	: NewPlayer
enter_last_city(#player{socket=Socket,uid=Uid,info=Info}=Player) ->
	#info{map_last=MapId,pos_x_last=X,pos_y_last=Y,map_type=CurMapType} = Info,
	?IF(CurMapType =:= ?CONST_MAP_TYPE_KOF, wrestle_api:lie_exit_kof(Uid), ?skip),
	case data_scene:scene(MapId) of
		#d_scene{scene_type=SceneType,lv=MapLv} ->
			Suffix = 0,
			case enter(Player, MapId, MapLv, X, Y, SceneType, Suffix) of
				{?ok,Player2} ->
					Player2;
				{?error,ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg),
					Player
			end;
		_ ->
			Player
	end.

check_map_xy(MapId,X,Y) ->
	case data_scene:scene(MapId) of
		Dscene when is_record(Dscene,d_scene) ->
			case data_scene:material(Dscene#d_scene.material_id) of
				DmateRial when is_record(DmateRial,d_material) ->
					#d_material{tile_width=TW,tile_height=TH,path=Path} = DmateRial,
					case check_map_xy_check(Path, TW, X, Y) of
						?true ->
							{X,Y};
						?false ->
							check_map_xy_rand(Path,TW,TH,0)
					end;
				_ ->
					{?CONST_MAP_DEFAULT_POSX,?CONST_MAP_DEFAULT_POSY}
			end;
		_ ->
			{?CONST_MAP_DEFAULT_POSX,?CONST_MAP_DEFAULT_POSY}
	end.

check_map_xy_check(Path,TW,X,Y)->
	Pos = (Y-1)*(TW+1) + X, 
	if
		Pos >= byte_size(Path) orelse Pos =< 0 ->
			?false;
		?true ->
			case binary:at(Path,Pos) of
				$\n -> ?false;
				$0  -> ?false;
				_P  -> ?true
			end
	end.

check_map_xy_rand(_Path,_TW,_TH,Count) when Count > 100 -> 
	{?CONST_MAP_DEFAULT_POSX,?CONST_MAP_DEFAULT_POSY};
check_map_xy_rand(Path,TW,TH,Count) ->
	X = util:rand(1, TW),
	Y = util:rand(1, TH),
	case check_map_xy_check(Path, TW, X, Y) of
		?true ->
			{X,Y};
		?false ->
			check_map_xy_rand(Path,TW,TH,Count+1)
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 飞地图
enter_fly(#player{socket=Socket}=Player,MapId,Pos,Suffix) ->
	case fly_check(Player,MapId,Pos,Suffix) of
		{?ok,MapType,MapLv,X,Y,NewSuffix} ->
			case enter(Player, MapId, MapLv, X, Y, MapType, NewSuffix) of
				{?ok, NewPlayer} ->
					NewPlayer;
				{?error, ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg),
					Player
			end;
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			Player
	end.

fly_check(Player,MapId,Pos,Suffix) ->
	case data_scene:scene(MapId) of
		#d_scene{scene_type=MapType,born=Born,lv=MapLv} ->
			case MapType of
				?CONST_MAP_TYPE_BOSS ->
					case world_boss_api:boss_clear(Player) of
						?true ->
							{X,Y} = scene_mod:find_map_bornxy(Born, Pos),
							{?ok,MapType,MapLv,X,Y,Suffix};
						{?error,ErrorCode} ->
							{?error,ErrorCode}
					end;
				?CONST_MAP_TYPE_CLAN_BOSS ->
					case clan_boss_api:clan_id_get(Player#player.uid) of
						{?ok,ClanId} ->
							{X,Y} = scene_mod:find_map_bornxy(Born, Pos),
							{?ok,MapType,MapLv,X,Y,ClanId};
						{?error,ErrorCode} ->
							{?error,ErrorCode}
					end;
				_ ->
					{X,Y} = scene_mod:find_map_bornxy(Born, Pos),
					{?ok,MapType,MapLv,X,Y,Suffix}
			end;
		_ ->
			{?error, ?ERROR_SCENES_MAP_NULL}
	end.

%% {?ok, NewPlayer} | {?error, ErrorCode}
enter(#player{spid=Spid,lv=Lv,info=Info}=Player,MapId,MapLv,X,Y,MapType,Suffix) ->
	case Lv >= MapLv of
		?true ->
			case enter_check(MapId,Info#info.map_id,MapType,Spid,Suffix) of
				{?error, ErrorCode} ->
					{?error, ErrorCode};
				{Flag, Pid} ->
					PlayerS	= [scene_mod:record_player_s(Player)],
					enter_cast(Pid, PlayerS, X, Y),
					?IF(Flag =:= ?false, exit_scene(Player), ?skip),
					{MapLast,XLast,YLast} = last_info(Info),
					Info2 = Info#info{pos_x=X, pos_y=Y, map_id=MapId, pos_x_last=XLast,pos_y_last=YLast,map_last=MapLast, map_type=MapType},
					{?ok, Player#player{spid=Pid,info=Info2}}
			end;
		_ ->
			{?error, ?ERROR_SCENES_LV_LACK}
	end.

enter_check(MapId,MyMapId,MapType,Spid,Suffix) ->
	case MapId of
		MyMapId ->
			{?true, Spid};
		_ ->
			case scene_mod_manager:select_handle(MapId,Suffix,MapType) of
				PidTemp when is_pid(PidTemp) ->
					{?false, PidTemp};
				_ ->
					{?error, ?ERROR_SCENES_MAP_NULL}
			end
	end.

last_info(#info{map_id=MapId,pos_x=Posx,pos_y=Posy,map_last=MapLast,pos_x_last=PosXlast,pos_y_last=PosYlast}) ->
	case data_scene:scene(MapId) of
		#d_scene{scene_type=?CONST_MAP_TYPE_CITY} ->
			{MapId,Posx,Posy};
		_ ->
			{MapLast,PosXlast,PosYlast}
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
enter_cast(Pid, PlayerS, X, Y) ->
	scene_srv:enter_cast(Pid, PlayerS, X, Y).

%% 请求场景Uid列表
map_uid(SPid)->
	scene_srv:uid_list_call(SPid).

%% 请求场景角色数据列表
player_list(#player{uid=Uid,spid=Spid}) ->
	scene_srv:player_list_cast(Spid,Uid).

%% 请求场景玩家列表(NEW)
player_list_new(#player{uid=Uid,spid=Spid}) ->
	scene_srv:player_list_new_cast(Spid,Uid).

player_list2(#player{uid=Uid,spid=SPid})->
	scene_srv:player_list_call(SPid,Uid).

%% 请求场景采集怪物数据
collect_list(#player{uid=Uid,spid=SPid,info=Info})->
	case Info#info.map_type of
		?CONST_MAP_TYPE_COPY_HERO ->
			hero_srv:collect_list_cast(SPid,Uid);
		_ ->
			?skip
	end.

%% 退出场景
exit_scene(#player{uid=Uid,spid=SPid,info=Info}) ->
	exit_scene(Uid, SPid, Info).
exit_scene(Uid, SPid, #info{map_type=MapType}) when is_pid(SPid) ->
	case MapType of
		?CONST_MAP_TYPE_COPY_NORMAL ->
			copy_api:exit(SPid, Uid);
		?CONST_MAP_TYPE_COPY_HERO ->
			copy_api:exit(SPid, Uid);
		?CONST_MAP_TYPE_COPY_FIEND ->
			copy_api:exit(SPid, Uid);
		?CONST_MAP_TYPE_COPY_FIGHTERS ->
			copy_api:exit(SPid, Uid);
		_ ->
			scene_srv:exit_cast(SPid, Uid)
	end;
exit_scene(_Uid, _SPid, _SceneData) ->
	?ok.

move(Uid,Type,Spid,MoveType,PosX,PosY,OwnerUid)->
    scene_srv:move_cast(Spid,Uid,Type,MoveType,PosX,PosY,OwnerUid).

move_new(Uid,Type,Spid,MoveType,PosX,PosY,OwnerUid) ->
    scene_srv:move_new_cast(Spid,Uid,Type,MoveType,PosX,PosY,OwnerUid).

% 杀怪
mons_kill(Spid,Uid,MonsMid) ->
	copy_srv:mons_kill_cast(Spid,Uid,MonsMid).

move_monster(Pid,MGid,Mtype) ->
	case Mtype of
		?CONST_MAP_TYPE_COPY_NORMAL ->
			copy_srv:move_monster_cast(Pid, MGid);
		_ ->
			scene_srv:move_monster_cast(Pid, MGid)
	end.

%% 请求场景怪物数据
monster_list(SPid,Uid)->
	scene_srv:monster_list_cast(SPid,Uid).

% 怪物被击倒
monster_knock(Spid,Gmid,Gid) ->
	scene_srv:monster_knock_cast(Spid,Gmid,Gid).

% 场景广播--帮派
change_clan(SPid,Uid,ClanId,ClanName) ->
	scene_srv:change_clan_cast(SPid,Uid,ClanId,ClanName).

%% 战斗状态更新
change_war_state(ScenePid, UidSidStates) ->
	scene_srv:change_war_state_cast(ScenePid, UidSidStates).

% 场景广播--改变坐骑
change_mount(#player{uid=Uid,spid=SPid,info=Info}, Mount, Speed)->
	case Info#info.map_type of
		?CONST_MAP_TYPE_COPY_NORMAL ->
			?ok;
		?CONST_MAP_TYPE_COPY_HERO ->
			?ok;
		?CONST_MAP_TYPE_COPY_FIEND ->
			?ok;
		_ ->
			scene_srv:change_mount_cast(SPid, Uid, Mount, Speed)
	end.

% 场景广播--升级
change_level(#player{uid=Uid, spid=SPid}, Lv)->
	scene_srv:change_level_cast(SPid, Uid, Lv).

% 场景广播--VIP
change_vip(#player{uid=Uid, spid=SPid}, VipLv)->
	scene_srv:change_vip_cast(SPid, Uid, VipLv).

% 场景广播--改变组队
change_team_leader(Spid, NewLeaderUid, OldLeaderUid) ->
	scene_srv:change_team_leader_cast(Spid, NewLeaderUid, OldLeaderUid).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 进入场景 [5030]
msg_enter_ok(#player_s{uid=Uid,pos_x=PosX,pos_y=PosY,speed=Speed,dir=Dir,distance=Distance,
					   hp_now=HpNow,hp_max=HpMax,team_id=TeamId}, MapId, Type) ->
	msg_enter_ok(Uid,PosX,PosY,Speed,Dir,Distance,Type,MapId,TeamId,HpNow,HpMax).

msg_enter_ok(Uid,PosX,PosY,Speed,Dir,Distance,EnterType,MapId,TeamId,HpNow,HpMax)->
	RsList = app_msg:encode([{?int32u,Uid},{?int16u,MapId},{?int16u,PosX},{?int16u,PosY},{?int16u,Speed},{?int8u,Dir},
							 {?int16u,Distance},{?int8u,EnterType},{?int32u,TeamId},{?int32u,HpNow},{?int32u,HpMax}]),
    app_msg:msg(?P_SCENE_ENTER_OK, RsList).

% 地图玩家数据 [5025]
msg_role_data(#player_s{uid=Uid,name=Name,name_color=NameColor,sex=Sex,pro=Pro,lv=Lv,is_war=IsWar,is_guide=IsGuide,pos_x=PosX,
						pos_y=PosY,speed=Speed,dir=Dir,distance=Distance,country=Country,vip=Vip,skin_pet=SkinPet,
						country_post=CountryPost,clan=Clan,clan_name=ClanName,clan_post=ClanPost,skin_mount=SkinMount,
						skin_armor=SkinArmor,skin_weapon=SkinWeapon,team_id=TeamId,hp_now=HpNow,hp_max=HpMax}, Type) ->
	BinMsg = app_msg:encode([{?int8u, Type},		{?int32u,Uid},
							 {?string,Name},		{?int8u, NameColor},
							 {?int8u, Sex},			{?int8u, Pro},
							 {?int16u,Lv},			{?int8u, IsWar},
							 {?int8u, IsGuide},		{?int32u,TeamId},
							 {?int16u,PosX},		{?int16u,PosY},
							 {?int16u,Speed},		{?int8u, Dir},
							 {?int8u, Distance},	{?int8u, Country},
							 {?int8u, CountryPost},	{?int16u,Clan},
							 {?string,ClanName},	{?int8u, ClanPost},
							 {?int8u, Vip},			{?int16u,SkinMount},
							 {?int16u,SkinArmor},	{?int16u,SkinWeapon},
							 {?int16u,SkinPet},		{?int32u,HpNow},
							 {?int32u,HpMax}]),
	app_msg:msg(?P_SCENE_ROLE_DATA, BinMsg).

% 地图玩家数据(NEW)
msg_role_data_new(#player_s{uid=Uid,name=Name,name_color=NameColor,sex=Sex,pro=Pro,lv=Lv,is_war=IsWar,is_guide=IsGuide,pos_x=PosX,
						pos_y=PosY,speed=Speed,dir=Dir,distance=Distance,country=Country,vip=Vip,skin_pet=SkinPet,
						country_post=CountryPost,clan=Clan,clan_name=ClanName,clan_post=ClanPost,skin_mount=SkinMount,
						skin_armor=SkinArmor,skin_weapon=SkinWeapon,team_id=TeamId,hp_now=HpNow,hp_max=HpMax}, Type) ->
	BinMsg = app_msg:encode([{?int8u, Type},		{?int32u,Uid},
							 {?string,Name},		{?int8u, NameColor},
							 {?int8u, Sex},			{?int8u, Pro},
							 {?int16u,Lv},			{?int8u, IsWar},
							 {?int8u, IsGuide},		{?int32u,TeamId},
							 {?int16u,PosX},		{?int16u,PosY},
							 {?int16u,Speed},		{?int8u, Dir},
							 {?int8u, Distance},	{?int8u, Country},
							 {?int8u, CountryPost},	{?int16u,Clan},
							 {?string,ClanName},	{?int8u, ClanPost},
							 {?int8u, Vip},			{?int16u,SkinMount},
							 {?int16u,SkinArmor},	{?int16u,SkinWeapon},
							 {?int16u,SkinPet},		{?int32u,HpNow},
							 {?int32u,HpMax}]),
	BinMsg.

% 怪物数据(刷新) [5030] 
msg_monster_data(#monster{monster_mid=MonsterMid,monster_id=MonsterId,pos_x=PosX,pos_y=PosY,origin_x=OriginX,origin_y=OriginY,
						  speed=Speed,dir=Dir,hp=Hp,hp_max=HpMax}) ->
	{PosX1,PosY1} = ?IF(PosX=<0 orelse PosY=<0,{OriginX,OriginY},{PosX,PosY}),
	msg_monster_data(MonsterMid,MonsterId,PosX1,PosY1,Speed,Dir,Hp,HpMax).

msg_monster_data(MonsterMid,MonsterId,PosX,PosY,Speed,Dir,Hp,HpMax)->
	RsList = msg_monster_idx_data(MonsterMid,MonsterId,PosX,PosY,Speed,Dir,Hp,HpMax),
	app_msg:msg(?P_SCENE_MONSTER_DATA, RsList).

msg_monster_data(MapId, [Monster|MonsterList], AccBin) ->
	BinMsg = msg_monster_data(Monster),
	msg_monster_data(MapId, MonsterList, <<AccBin/binary, BinMsg/binary>>);
msg_monster_data(_MapId, [], AccBin) ->
	AccBin.

msg_idx_monster(Snow,Monsters) ->
	Bin1 = app_msg:encode([{?int16u,Snow},{?int16u,length(Monsters)}]),
	Fun = fun(#monster{monster_mid=MonsterMid,monster_id=MonsterId,pos_x=PosX,pos_y=PosY,origin_x=OriginX,origin_y=OriginY,
						  speed=Speed,dir=Dir,hp=Hp,hp_max=HpMax},AccBin) ->
				  {PosX1,PosY1} = ?IF(PosX=<0 orelse PosY=<0,{OriginX,OriginY},{PosX,PosY}),
				  Fbin = msg_monster_idx_data(MonsterMid,MonsterId,PosX1,PosY1,Speed,Dir,Hp,HpMax),
				  <<AccBin/binary,Fbin/binary>>
		  end,
	BinData = lists:foldl(Fun, Bin1, Monsters),
	app_msg:msg(?P_SCENE_IDX_MONSTER, BinData).

msg_monster_idx_data(MonsterMid,MonsterId,PosX,PosY,Speed,Dir,Hp,HpMax) ->
	app_msg:encode([{?int32u,MonsterMid},{?int16u,MonsterId},{?int16u,PosX},{?int16u,PosY},
					{?int16u,Speed},{?int8u,Dir},{?int32u,Hp},{?int32u,HpMax}]).
				  

% 行走数据(地图广播) [5041]
msg_move_rece(#player_s{uid=Uid,pos_x=PosX,pos_y=PosY},MoveType) ->
	msg_move_rece(?CONST_PLAYER,Uid,MoveType,PosX,PosY,0);
msg_move_rece(#monster{monster_mid=MonsterMid,pos_x=PosX,pos_y=PosY},MoveType) ->
	msg_move_rece(?CONST_MONSTER,MonsterMid,MoveType,PosX,PosY,0).

msg_move_rece(BinData) ->
	app_msg:msg(?P_SCENE_MOVE_RECE, BinData).

msg_move_rece(Type,Uid,MoveType,PosX,PosY,OwnerUid)->
	Time = util:seconds(),
	RsList = app_msg:encode([{?int8u,Type},{?int32u,Uid},{?int8u,MoveType},{?int16u,PosX},{?int16u,PosY},{?int32u,OwnerUid},{?int32u,Time}]),
	app_msg:msg(?P_SCENE_MOVE_RECE, RsList). 

% 强设玩家坐标 [5080]
msg_set_player_xy(Uid,PosX,PosY)->
    RsList = app_msg:encode([{?int32u,Uid},{?int16u,PosX},{?int16u,PosY}]),
    app_msg:msg(?P_SCENE_SET_PLAYER_XY, RsList).

% 离开场景 [5110]
msg_out(Uid,IdType,OutType,OwnerUid) when is_integer(Uid)->
    RsList = app_msg:encode([{?int8u,IdType},{?int32u,Uid},{?int8u,OutType},{?int32u,OwnerUid}]),
    app_msg:msg(?P_SCENE_OUT, RsList).

msg_hp_update(Type,Uid,PartnerId,State,NowHp) ->
	?MSG_ECHO("------------~w~n",[{Type,Uid,PartnerId,State,NowHp}]),
	BinData = app_msg:encode([{?int8u,Type},{?int32u,Uid},{?int32u,PartnerId},
							  {?int8u,State},{?int32u,NowHp}]),
	app_msg:msg(?P_SCENE_HP_UPDATE, BinData).

msg_out([],_IdType,_OutType,_OwnerUid,AccBin) ->
	AccBin;
msg_out([#partner_s{partner_id=PartnerId}|Partners],IdType,OutType,OwnerUid,AccBin) ->
	BinMsg = msg_out(PartnerId,IdType,OutType,OwnerUid),
	msg_out(Partners,IdType,OutType,OwnerUid,<<AccBin/binary,BinMsg/binary>>).

% 场景广播--帮派 [5095]
msg_change_clan(Uid, ClanId,ClanName) ->
	RsList = app_msg:encode([{?int32u,Uid},{?int16u,ClanId},{?string,ClanName}]),
	app_msg:msg(?P_SCENE_CHANGE_CLAN, RsList).

% 场景广播--升级 [5051]
msg_level_up(Uid,Level)->
    RsList = app_msg:encode([{?int32u,Uid},{?int16u,Level}]),
    app_msg:msg(?P_SCENE_LEVEL_UP, RsList).

% 场景广播--VIP
msg_vip_up(Uid,VipLv)->
    RsList = app_msg:encode([{?int32u,Uid},{?int16u,VipLv}]),
    app_msg:msg(?P_SCENE_CHANGE_VIP, RsList).

% 场景广播--改变组队 [5052]
msg_change_team(NewLeaderUid,OldLeaderUid)->
    RsList = app_msg:encode([{?int32u,NewLeaderUid},{?int32u,OldLeaderUid}]),
    app_msg:msg(?P_SCENE_CHANGE_TEAM, RsList).

% 场景广播--改变坐骑 [5355]
msg_change_mount(Uid,Mount,Speed)->
    RsList = app_msg:encode([{?int32u,Uid},{?int16u,Mount},{?int16u,Speed}]),
    app_msg:msg(?P_SCENE_CHANGE_MOUNT, RsList).

% 场景广播--改变战斗状态
msg_change_war(Uid,StateNew)->
    RsList = app_msg:encode([{?int32u,Uid},{?int8u,StateNew}]),
    app_msg:msg(?P_SCENE_CHANGE_STATE, RsList).

% 伙伴属性 [1109]
msg_partner_data(Uid,Partners,TeamId) ->
	msg_partner_data(Uid,Partners,TeamId,<<>>).

msg_partner_data(_Uid,[],_TeamId,AccBinMsg) ->
	AccBinMsg;
msg_partner_data(Uid,[#partner_s{partner_id=PartnerId,lv=Lv,hp=HpNow,hp_max=HpMax,die=Die}|Partners],TeamId,AccBin) when HpNow > 0 andalso Die =/= ?true ->
	RsList = app_msg:encode([{?int32u,Uid},{?int16u,PartnerId},{?int16u,Lv},
							 {?int32u,TeamId},{?int32u,HpNow},{?int32u,HpMax}]),
	BinMsg = app_msg:msg(?P_SCENE_PARTNER_DATA, RsList),
	msg_partner_data(Uid,Partners,TeamId,<<AccBin/binary,BinMsg/binary>>);
msg_partner_data(Uid,[_|Partners],TeamId,AccBinMsg) ->
	msg_partner_data(Uid,Partners,TeamId,AccBinMsg).

msg_partner_data_new(_Uid,[],_TeamId,AccCount,AccBin) ->
	{AccCount,AccBin};
msg_partner_data_new(Uid,[#partner_s{partner_id=PartnerId,lv=Lv,hp=HpNow,hp_max=HpMax,die=Die}|Partners],TeamId,AccCount,AccBin) when HpNow > 0 andalso Die =/= ?true ->
	RsList = app_msg:encode([{?int32u,Uid},{?int16u,PartnerId},{?int16u,Lv},
							 {?int32u,TeamId},{?int32u,HpNow},{?int32u,HpMax}]),
	msg_partner_data_new(Uid,Partners,TeamId,AccCount+1,<<AccBin/binary,RsList/binary>>);
msg_partner_data_new(Uid,[_|Partners],TeamId,AccCount,AccBinMsg) ->
	msg_partner_data_new(Uid,Partners,TeamId,AccCount,AccBinMsg).

% 复活成功
msg_relive_ok() ->
	app_msg:msg(?P_SCENE_RELIVE_OK, <<>>).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ext_interval_handle(Map,Flag,Ctime) ->
	scene_mod:interval_handle(Map,Flag,Ctime).

ext_init_map(MapId,MapType,Dmonsters,Dcollect) ->
	scene_mod:init_ets_map(MapId,MapType,Dmonsters,Dcollect).

ext_record_player_s(Player) ->
	scene_mod:record_player_s(Player).

ext_player_list_handle(Map, Sid, Uid) ->
	scene_mod:player_list_handle(Map, Sid, Uid).

ext_monster_knock_handle(Map, Gmid, Gid) ->
	scene_mod:monster_knock_handle(Map, Gmid, Gid).

ext_record_monster_s(MonsterS,AttrRatioCount, PercentRatioLv,MapId) ->
	scene_mod:record_monster_s(MonsterS,AttrRatioCount, PercentRatioLv,MapId).

ext_record_scene_data(Map,Country) ->
	scene_mod:record_scene_data(Map,Country).

ext_broadcast_handle(UidList, BinMsg) ->
	scene_mod:do_broadcast(UidList, BinMsg).

ext_move_handle(Uid,Type,MoveType,PosX,PosY,OwnerUid) ->
	scene_mod:move_handle(Uid,Type,MoveType,PosX,PosY,OwnerUid).

ext_move_new_handle(Uid,Type,MoveType,PosX,PosY,OwnerUid) ->
	scene_mod:move_new_handle(Uid,Type,MoveType,PosX,PosY,OwnerUid).

ext_change_war_state_handle(Map,UidAndState) ->
	scene_mod:change_war_state_handle(Map,UidAndState).

ext_war_over_refresh_monster(Map, Flag, MonsterMids) ->
	scene_mod:war_over_refresh_monster_handle(Map, Flag, MonsterMids).

ext_change_level_handle(Map, Uid, Level) ->
	scene_mod:change_level_handle(Map, Uid, Level).

ext_change_team_leader_handle(NewLeaderUid,OldLeaderUid) ->
	scene_mod:change_team_leader_handle(NewLeaderUid,OldLeaderUid).

ext_change_mount_handle(Map, Uid, Mount, Speed) ->
	scene_mod:change_mount_handle(Map, Uid, Mount, Speed).

ext_exit_handle(Map, Sid, Uid) ->
	scene_mod:exit_handle(Sid, Uid, Map).

ext_find_map_bornxy(Born,Country) ->
	scene_mod:find_map_bornxy(Born,Country).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 坐骑属性加成 -> ok | {error, ErrorCode}
check_scenes_mount(MapId) ->
	case data_scene:scene(MapId) of
		#d_scene{is_mount=?CONST_TRUE} ->
			?ok;
		#d_scene{is_mount=?CONST_FALSE} ->
			{?error, ?ERROR_FLAG_MOUNT_BAN};
		_ ->
			{?error, ?ERROR_SCENES_MAP_NULL}
	end.

%% 是否可以坐骑 -> ok | {error, ErrorCode}
check_scenes_ride(MapId) ->
	case data_scene:scene(MapId) of
		#d_scene{is_ride=?CONST_TRUE} ->
			?ok;
		#d_scene{is_ride=?CONST_FALSE} ->
			{?error, ?ERROR_FLAG_MOUNT_BAN};
		_ ->
			{?error, ?ERROR_SCENES_MAP_NULL}
	end.

%% 找地图传送点信息 -> List
map_doors(MapId) ->
	case data_scene:scene(MapId) of
		#d_scene{door=Doors} ->
			[DoorId || {DoorId,_X,_Y} <- Doors];
		_ ->
			[]
	end.

map_type(MapId) ->
	#d_scene{scene_type=MapType} = data_scene:scene(MapId),
	MapType.