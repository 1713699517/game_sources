%%% -------------------------------------------------------------------
%%% Author  : mirahs
%%% Description :
%%%
%%% Created : 2011-8-7
%%% -------------------------------------------------------------------
-module(scene_srv). 

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% 调用导出
-export([enter_cast/4,
		 uid_list_call/1,
		 get_map_info_call/2,
		 defend_monster_list_call/1,
		 replace_defend_monster_call/2,
		 stop_map_call/1,
		 
		 interval_cast/1,
		 die_cast/2,
		 die_partner_cast/3,
		 exit_cast/2,
		 move_cast/7,
		 move_new_cast/7,
		 broadcast_cast/3,
		 player_list_cast/2,
		 player_list_new_cast/2,
		 monster_list_cast/2,
		 monster_knock_cast/3,
		 move_monster_cast/2,
		 world_boss_hp_cast/2,
		 add_monster_cast/2,
		 set_player_posxy/5,
		 
		 war_harm_cast/2,
		 enter_city_cast/1,
		 change_war_state_cast/2,
		 replace_gmonster/2,
		 stop_map_cast/1, 
		 
		 change_clan_cast/4,
		 change_level_cast/3,
		 change_vip_cast/3,
		 change_team_leader_cast/3,
		 change_mount_cast/4]).
%% --------------------------------------------------------------------
%% 以下系统默认导出(勿删)
-export([start_link/3,init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
%% 以下系统默认函数(勿删)
start_link(_SrvName, Cores, InitData) ->
	app_link:gen_server_start_link_noname(?MODULE, [Cores,InitData], Cores).
init([Cores,{MapId, Suffix}])     ->
	process_flag(?trap_exit, ?true),
	Reply = do_init(MapId, Suffix),
	?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
	Reply.
handle_call(Request, From, State) -> 
	?TRY_DO(do_call(Request,From,State) ).
handle_cast(Msg,  State) -> 
	?TRY_DO(do_cast(Msg,State) ).
handle_info(Info, State) -> 
	?TRY_DO(do_info(Info,State)).
terminate(Reason,State)  -> 
	?TRY_DO(do_terminate(State)),
	case Reason of 
		?normal -> ?skip;
		_ 		-> ?MSG_ERROR("Terminate Reason:~w State:~w ",[Reason,State])
	end.
code_change(_OldVsn, State, _Extra) -> {?ok, State}.
%% --------------------------------------------------------------------
%%% DO 内部处理
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: do_init/1
%% Description: 初始化状态
%% Returns: {?ok, State}          |
%%          {?ok, State, Timeout} |
%%          ?ignore               |
%%          {?stop, Reason}
%% --------------------------------------------------------------------
do_init(MapId, Suffix) ->
	RegName = scene_api:reg_name(MapId, Suffix), 
	case erlang:whereis(RegName) of
		?undefined ->
			?ok;
		_ ->
			erlang:unregister(RegName)
	end,
	erlang:register(RegName, self()),
			
	%% 初始化State
	{?ok, Map} = scene_mod:init_map_srv(MapId, Suffix),
	scene_mod:update_spid(Map),
	{?ok, Map}.








%% --------------------------------------------------------------------
%% Function: do_call/3
%% Description: 等待Call处理
%% Returns: {?reply, Reply, State}          |
%%          {?reply, Reply, State, Timeout} |
%%          {?noreply, State}               |
%%          {?noreply, State, Timeout}      |
%%          {?stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {?stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% do_call(Request,From,State)-> %% 示列
%% 	{?reply,?ok,State};
do_call({enter_boss, Flag, Login, PlayerSList, X, Y,Mtype}, _From, State) ->
	scene_mod:enter_boss_handle(Flag, Login, PlayerSList, State, X, Y,Mtype);
do_call({uid_list}, _From, State) -> 
	Reply = scene_mod:get_map_uidlist(), 
    {reply, Reply, State};
do_call(monster_list_defend, _From, State) -> 
	Reply = scene_mod:monster_list_defend_handle(State), 
    {reply, Reply, State};
do_call({replace_defend_monster,GmonsInfo}, _From, State) -> 
	{Reply,State2} = scene_mod:replace_defend_monster_handle(State,GmonsInfo), 
    {reply, Reply, State2};
do_call({map_info,Country}, _From, State) -> 
	Reply = scene_mod:find_map_info_handle(State,Country), 
    {reply, Reply, State};

do_call({getew,?null}, _From, State) -> 
	Reply=scene_mod:get_map_uidlist(),
    {reply, Reply, State};

do_call(stop_call, _From, State) ->
    {?stop, ?normal, ?ok, State};

do_call(Request,From,State)->    %% 默认处理(勿删)
	?MSG_ERROR("Call Request:~p From:~w State:~w", [Request, From, State]),
	{?reply,?ok,State}.





%% --------------------------------------------------------------------
%% Function: do_cast/2
%% Description: 异步Cast处理
%% Returns: {?noreply, State}          |
%%          {?noreply, State, Timeout} |
%%          {?stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% do_cast(Msg,State) ->  %% 示列
%% 	{?noreply,State};

do_cast(interval, State) ->
	scene_mod:interval_handle(State,?false,0);
do_cast({enter, PlayerSList, X, Y}, State) ->
	scene_mod:enter_cast_handle(State, PlayerSList, X, Y);
do_cast({move,Uid,Type,MoveType,PosX,PosY,OwnerUid}, State) ->
	scene_mod:move_handle(Uid,Type,MoveType,PosX,PosY,OwnerUid),
    {?noreply, State};
do_cast({move_new,Uid,Type,MoveType,PosX,PosY,OwnerUid}, State) ->
	scene_mod:move_new_handle(Uid,Type,MoveType,PosX,PosY,OwnerUid),
    {?noreply, State};
do_cast({broadcast, Uid, BinMsg}, State) ->
	scene_mod:do_broadcast_handle(Uid, BinMsg),
    {?noreply, State};
do_cast({player_list, Uid}, State) ->
	scene_mod:player_list_handle(Uid,State#map.type),
    {?noreply, State};
do_cast({player_list_new, Uid}, State) ->
	scene_mod:player_list_new_handle(Uid,State#map.type),
    {?noreply, State};
do_cast({monster_list, Uid}, State) ->
	scene_mod:monster_list_handle(State, Uid),
    {?noreply, State};
do_cast({monster_list_all,BinMsg}, State) ->
	scene_mod:monster_list_all_handle(State,BinMsg), 
    {?noreply, State};
do_cast({monster_knock, Gmid, Gid}, State) ->
	State2 = scene_mod:monster_knock_handle(State, Gmid, Gid),
    {?noreply, State2};
do_cast({add_monster,MonsInfo}, State) ->
	State2 = scene_mod:add_monster_handle(State,MonsInfo),
    {?noreply, State2};
do_cast({set_posxy, Uid,X,Y,Mtype},State) ->
	State2 = scene_mod:set_posxy(State,Uid,X,Y,Mtype),
    {?noreply,State2};
do_cast({notice_over,_Uid,_HitTimes,_CaromTimes,_MonsHp}, State) ->
    {?noreply,State};
do_cast({?exit, Uid}, State) ->
	scene_mod:exit_handle(Uid, State);
do_cast({move_monster,MGid}, State) ->
	State2 = scene_mod:move_monster(State,MGid),
    {?noreply, State2};
do_cast({change_clan, Uid, ClanId,ClanName}, State) ->
	State2 = scene_mod:change_clan_handle(State, Uid, ClanId,ClanName),
    {?noreply, State2};
do_cast({change_level, Uid, Value}, State) ->
	State2 = scene_mod:change_level_handle(State, Uid, Value),
    {?noreply, State2};
do_cast({change_vip, Uid, Value}, State) ->
	State2 = scene_mod:change_vip_handle(State, Uid, Value),
    {?noreply, State2};
do_cast({change_team_leader, NewLeaderUid, OldLeaderUid}, State) ->
	scene_mod:change_team_leader_handle(NewLeaderUid, OldLeaderUid),
    {?noreply, State};
do_cast({change_mount, Uid, Mount, Speed}, State) ->
	State2 = scene_mod:change_mount_handle(State, Uid, Mount, Speed),
    {?noreply, State2};
do_cast({change_war_state,UidSidStates}, State) ->
	State2 = scene_mod:change_war_state_handle(State,UidSidStates), 
    {?noreply, State2};
do_cast({war_harm,HarmData}, State) -> 
	{State2,_Flag} = scene_mod:war_harm_handle(State,HarmData,0),
    {?noreply, State2};
do_cast(enter_city, State) -> 
	scene_mod:enter_city_handle(),
    {?noreply, State};
do_cast({replace_gmonster, GmonsInfo}, State) -> 
	State2 = scene_mod:replace_gmonster(State, GmonsInfo),
    {?noreply, State2};


do_cast({putew,Uid}, State) -> 
	Suid=scene_mod:get_map_uidlist(),
	NSuid= lists:ukeysort(2, [Uid|Suid]),
	put(user_id_list,NSuid),
    {?noreply, State};


do_cast(stop, State) -> 
    {?stop, ?normal,State};
do_cast(Msg,State)->      %% 默认处理(勿删)
	?MSG_ERROR("Cast Msg:~w State:~w", [Msg,State]),
	{?noreply,State}.


%% --------------------------------------------------------------------
%% Function: do_info/2
%% Description: 异步Info处理
%% Returns: {?noreply, State}          |
%%          {?noreply, State, Timeout} |
%%          {?stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% do_info(Info,State)->     %% 示列
%% 	{?noreply,State};
do_info({?inet_reply,_Socket,_Msg}, State) -> %% 向Socket发包 返回
	{?noreply, State}; 
%% do_info(?doloop,State)->  %% 处理注册定时 doloop
%% 	{?noreply,State};
%% 兼容代码(地图广播)
do_info({?exec, scenes_api, broadcast_cb, BinMsg}, State) ->
	?MSG_ECHO("scenes_api, broadcast_cb, BinMsg:~p",[BinMsg]),
	scene_mod:do_broadcast(get(user_id_list), BinMsg),
	{?noreply, State};
%% 定时清理
do_info({offline,_Key}, State) ->
%% 	?MSG_ECHO("send_lose,{Sid,Uid}:~p",[Key]),
	{?noreply, State};
%% 这也是清理(不能发包)
do_info({send_lose,Key}, State) ->
%% 	?MSG_ECHO("send_lose,{Key}:~p",[Key]),
	scene_mod:broadcast_lose_handle(Key),
	{?noreply, State};
do_info({?exec, Mod, Fun, Arg},State)->
	State2 = Mod:Fun(State, Arg),
	{?noreply, State2 };
do_info(Info,State)-> %% 默认处理(勿删)
	?MSG_ERROR("Info Info:~w State:~w", [Info,State]),
	{?noreply,State}.


%% --------------------------------------------------------------------
%% Function: do_terminate/2
%% Description: 退出处理内容
%% --------------------------------------------------------------------
do_terminate(#map{pid=Mpid})->
	scene_mod:delete_map_data(Mpid),
	?ok.


%% --------------------------------------------------------------------
%%% 外部调用Serv
%% --------------------------------------------------------------------
%% 进入场景 
enter_cast(Pid, PlayerSList, X, Y) ->
	gen_server:cast(Pid, {enter, PlayerSList, X, Y}).

% 场景玩家Uid列表
uid_list_call(Pid) ->
	gen_server:call(Pid,{uid_list},?CONST_OUTTIME_CALL).

% 关闭场景进程
stop_map_call(Pid) ->
	gen_server:call(Pid,stop_call).

% 怪物攻城怪物请求
defend_monster_list_call(Pid) ->
	gen_server:call(Pid,monster_list_defend).

% 把怪物攻城怪物放进场景
replace_defend_monster_call(Pid,GmonsInfo) ->
	gen_server:call(Pid,{replace_defend_monster,GmonsInfo}).

% 根据地图进程查找地图信息
get_map_info_call(Pid,Country) ->
	gen_server:call(Pid,{map_info,Country},?CONST_OUTTIME_CALL).

%%=================API_CAST=================
% 地图刷新
interval_cast(Pid) ->
	gen_server:cast(Pid, interval).

% 各种伤害
war_harm_cast(Spid,HarmData) ->
	gen_server:cast(Spid, {war_harm, HarmData}).

% 拉人回城
enter_city_cast(Spid) ->
	gen_server:cast(Spid, enter_city).

die_cast(Pid,Uid) ->
	gen_server:cast(Pid, {die,Uid}).

die_partner_cast(Pid,Uid,PartnerId) ->
	gen_server:cast(Pid, {die_partner,Uid,PartnerId}).

% 场景移动
move_cast(Pid,Uid,Type,MoveType,PosX,PosY,OwnerUid) ->
	gen_server:cast(Pid, {move,Uid,Type,MoveType,PosX,PosY,OwnerUid}).

move_new_cast(Pid,Uid,Type,MoveType,PosX,PosY,OwnerUid) ->
	gen_server:cast(Pid, {move_new,Uid,Type,MoveType,PosX,PosY,OwnerUid}).

% 退出场景
exit_cast(Pid, Uid) ->
	gen_server:cast(Pid, {?exit, Uid}).

% 替换场景里面所有怪物的#attr{}
replace_gmonster(Pid,GmonsInfo) ->
	gen_server:cast(Pid, {replace_gmonster,GmonsInfo}).

% 关闭场景进程
stop_map_cast(Pid) ->
	gen_server:cast(Pid,stop).

% 场景广播
broadcast_cast(Pid, Uid, BinMsg) ->
	gen_server:cast(Pid, {broadcast, Uid, BinMsg}).

% 请求场景玩家列表
player_list_cast(Pid, Uid) -> 
	gen_server:cast(Pid, {player_list, Uid}).

% 请求场景玩家列表(NEW)
player_list_new_cast(Pid, Uid) -> 
	gen_server:cast(Pid, {player_list_new, Uid}).
 
monster_list_cast(Pid,Uid) when is_integer(Uid) ->
	gen_server:cast(Pid, {monster_list, Uid});
monster_list_cast(Pid,BinMsg) ->
	gen_server:cast(Pid,{monster_list_all,BinMsg}).

monster_knock_cast(Spid,Gmid,Gid) ->
	gen_server:cast(Spid,{monster_knock,Gmid,Gid}).

world_boss_hp_cast(Pid,Uid)->
	gen_server:cast(Pid,{world_boss_hp,Uid}).

add_monster_cast(Pid,MonsterInfo) ->
	gen_server:cast(Pid,{add_monster,MonsterInfo}).

% 玩家失败设置复活点
set_player_posxy(SPid,Uid,X,Y,Mtype) ->
	gen_server:cast(SPid, {set_posxy,Uid,X,Y,Mtype}).

% 把怪物从怪物列表放到临时列表
move_monster_cast(Pid,MGid) ->
	gen_server:cast(Pid,{move_monster,MGid}).

% 场景广播--帮派
change_clan_cast(Pid,Uid,ClanId,ClanName) ->
	gen_server:cast(Pid,  {change_clan, Uid, ClanId,ClanName}).
% 场景广播--升级
change_level_cast(Pid, Uid, Value) ->
	gen_server:cast(Pid,  {change_level, Uid, Value}).
% 场景广播--升级
change_vip_cast(Pid, Uid, Value) ->
	gen_server:cast(Pid,  {change_vip, Uid, Value}).
% 场景广播--改变组队 
change_team_leader_cast(Spid, NewLeaderUid, OldLeaderUid) ->
	gen_server:cast(Spid, {change_team_leader, NewLeaderUid, OldLeaderUid}).
% 场景广播--改变坐骑
change_mount_cast(Pid, Uid, Mount, Speed) ->
	gen_server:cast(Pid, {change_mount, Uid, Mount, Speed}).
% 场景广播--改变战斗状态
change_war_state_cast(ScenePid, UidSidStates) ->
	gen_server:cast(ScenePid, {change_war_state,UidSidStates}).