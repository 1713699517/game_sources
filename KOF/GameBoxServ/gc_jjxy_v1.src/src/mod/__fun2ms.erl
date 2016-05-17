%% Author: Administrator
%% Created: 2012-9-10
%% Description: TODO: Add description to fun2ms
-module('__fun2ms').

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
-compile(export_all).


%% role:get_carrer_people
%% get_carrer_people(Pro)->
%% 	MS=ets:fun2ms(fun(R)->R#ets_online.pro == Pro end),
%% 	io:format("~p~n",[MS]).

%% role:get_name_to_uid
%% fun2ms:get_carrer_name(22)
%% get_carrer_name(Name)->
%% 	MS=ets:fun2ms(fun(R) when R#player.uname =:= Name->R end),
%% 	io:format("~p~n",[MS]).

%% fun2ms:get_arena_rank()
get_arena_rank(Uid) ->
	MS = ets:fun2ms(fun(RnakData) when RnakData#rank_data.uid =:= Uid ->RnakData end),
	io:format("~p~n",[MS]).

%% fun2ms:get_arena_rank()
get_arena_ranking(Uid) ->
	MS = ets:fun2ms(fun(RnakData) when RnakData#rank_data.uid =:= Uid ->RnakData#rank_data.rank end),
	io:format("~p~n",[MS]).

%% arena_api:gateway
get_arena_data() ->
	MS = ets:fun2ms(fun(RnakData) when RnakData#rank_data.rank  =< 20 ->RnakData end),
	io:format("~p~n",[MS]).


%% arena_api:rank_data
get_rank_data(Ranking,PRanking) ->
	MS = ets:fun2ms(fun(RnakData) when 
						 RnakData#rank_data.rank < PRanking andalso
												RnakData#rank_data.rank >= Ranking ->RnakData end),
	io:format("~p~n",[MS]).

%% 根据Uid、类型、日期查找邮件
%% mail_mod:select_mail
select_mail(Uid,PasTime) ->
	MS=ets:fun2ms(fun(Mail) when (Mail#mail.recv_uid == Uid orelse Mail#mail.send_uid==Uid)
										andalso Mail#mail.date < PasTime -> Mail end),
	io:format("~p~n",[MS]).


%% scene_mod:init_map_srv
%% 根据地图id和地图后缀找地图
init_map_srv(MapId, Suffix) ->
	MS=ets:fun2ms(fun(Map) when Map#map.map_id =:= MapId andalso Map#map.suffix =:= Suffix -> Map end),
	io:format("~p~n",[MS]).

%% scene_mod_manager:map_suffix
%% 根据地图id寻找地图 后缀
map_suffix(MapId) ->
	MS = ets:fun2ms(fun(Map) when Map#map.map_id =:= MapId -> Map#map.suffix end),
	io:format("~p~n",[MS]). 

%% scene_mod_manager:select_handle
%% 根据地图id找地图(地图id、人数、类型限制)
select_handle(MapId) ->
	MS = ets:fun2ms(fun(Map) when Map#map.map_id =:= MapId andalso Map#map.type =:= ?CONST_MAP_TYPE_CITY andalso Map#map.counter < ?CONST_MAP_MAP_MAX_COUNT -> Map end),
	io:format("~p~n",[MS]).

check_map_pid(MapId) ->
	MS = ets:fun2ms(fun(Map) when Map#map.map_id =:= MapId -> Map#map.pid end),
	MS.

check_map_pid(MapId,Suffix) ->
	MS = ets:fun2ms(fun(Map) when Map#map.map_id =:= MapId andalso Map#map.suffix =:= Suffix-> Map#map.pid end),
	MS.

%% friend_api:sys_recommend
%% 查找在线ets表的uid
%% select_uid() ->
%% 	MS = ets:fun2ms(fun(OnLine) -> OnLine#ets_online.uid end),
%% 	io:format("~p~n",[MS]).

%% scene_mod_manager:select_boss_map
%% 根据地图id寻找地图进程
select_boss_map(MapId) ->
	MS = ets:fun2ms(fun(Map) when Map#map.map_id =:= MapId andalso Map#map.type =:= ?CONST_MAP_TYPE_BOSS -> Map#map.pid end),
	io:format("~p~n",[MS]).

%% 根据取经战役找出队伍
find_team(BattleId) ->
	MS = ets:fun2ms(fun(Team) when Team#team.copy_id =:= BattleId andalso length(Team#team.mem) < ?CONST_TEAM_MAX andalso Team#team.state =/= ?CONST_TEAM_STATE_WARING -> Team#team.team_id end),
	MS.

%% 怪物攻城地图
select_defend_mons_map(MapId) ->
	MS = ets:fun2ms(fun(Map) when Map#map.map_id =:= MapId -> Map#map.pid end),
	io:format("~p~n",[MS]).
	
%% 取出 收or发or保 邮箱邮件
get_mails_getall(Uid) -> % 取出玩家所有的邮件
	MS=ets:fun2ms(fun(Mail) when Mail#mail.recv_uid =:= Uid orelse Mail#mail.send_uid=:=Uid -> Mail end),
	io:format("~p~n",[MS]).

%% 获取帮派成员列表
clan_get_members(ClanId) ->
	MS=ets:fun2ms(fun(ClanMem) when ClanMem#clan_mem.clan_id == ClanId -> ClanMem end),
	MS.

%% 帮派战场景地图
clan_war_map(MapID) ->
	MS=ets:fun2ms(fun(Map) when Map#map.map_id =:= MapID andalso Map#map.counter =/= 0 -> Map end),
	MS.

%% 帮派战场景地图满足条件pid
clan_war_scene(MapID, MaxCount) ->
	MS=ets:fun2ms(fun(Map) when Map#map.map_id =:= MapID andalso Map#map.counter < MaxCount -> Map end),
	MS.

%% 查询天宫之战地图进程
skywar_map(MapId) ->
	MS = ets:fun2ms(fun(Map) when Map#map.map_id =:= MapId ->
							Map#map.pid
					end),
	MS.

%% 查找符合阵营天宫之战玩家数据
skywar_camp_role(Camp) ->
	MS = ets:fun2ms(fun(SkywarRole) when SkywarRole#skywar_role.camp =:= Camp,SkywarRole#skywar_role.die==0 ->
							SkywarRole
					end),
	MS.


%% 查找符合阵营天宫之战帮派数据
skywar_camp_clan(Camp) ->
	MS = ets:fun2ms(fun(SkywarClan) when SkywarClan#skywar_clan.camp =:= Camp ->
							SkywarClan
					end),
	MS.
	

%% 从ets表取出玩家的 日志
get_logs_data(UID) ->
	MS=ets:fun2ms(fun(R) when R#logs.uid =:= UID -> R end),
	MS.	


%% t() ->
%% 	L = ets:tab2list(?ETS_ONLINE),
%% 	lists:foreach(fun(#ets_online{mpid = Mpid}) ->
%% 						  role_api:progress_send(Mpid, ?MODULE, t_cb, [])
%% 				  end, L).

t_cb(Player, []) ->
	task_api:refresh(Player).
	
	

	
	
	
