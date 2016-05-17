%%% -------------------------------------------------------------------
%%% Author  : mirahs
%%% Description :
%%%
%%% Created : 2011-12-17
%%% -------------------------------------------------------------------
-module(copy_srv).


-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% 调用导出
-export([start_call/2,
		 switch_in_call/1,
		 reward_call/2,
		 
		 interval_cast/1,
		 timing_cast/2,
		 times_carom_cast/3,
		 times_hit_cast/3,
		 mons_kill_cast/3,
		 relive_ok_cast/2,
		 notice_over_cast/5,
		 set_player_posxy_cast/5,
		 move_monster_cast/2,
		 exit_cast/2,
		 change_clan_cast/4
		]).
%% --------------------------------------------------------------------
%% 以下系统默认导出(勿删)
-export([start_link/3,init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
%% 以下系统默认函数(勿删)
start_link(_SrvName, Cores, InitData) ->
	app_link:gen_server_start_link_noname(?MODULE, [Cores,InitData], Cores).
init([Cores,{CopyId,IsTeam}])     ->
	process_flag(?trap_exit, ?true),
	Reply = do_init(CopyId,IsTeam), 
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
do_init(CopyId,IsTeam) ->
	%% 初始化State
	process_flag(?trap_exit, ?true),
	Copy = copy_mod:init_copy_srv(CopyId,IsTeam),
 	copy_mod:update_pid(Copy),
	{?ok, Copy}.








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
do_call({start, PlayerS}, _From, State) ->
    copy_mod:start_handle(State, PlayerS);
do_call(switch_in, _From, State) ->
	copy_mod:switch_in_handle(State);
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
	copy_mod:interval_handle(State);
do_cast({timing, _Type}, State) ->
%%  State2 = copy_mod:timing_handle(State, Type),
    {?noreply, State};
do_cast({times_carom, Uid,Times}, State) ->
    State2 = copy_mod:times_carom_handle(State,Uid,Times),
    {?noreply, State2};
do_cast({times_hit, Uid,Times}, State) ->
    State2 = copy_mod:times_hit_handle(State,Uid,Times),
    {?noreply, State2};
do_cast({mons_kill, Uid,MonsMid}, State) ->
    State2 = copy_mod:mons_kill_handle(State,Uid,MonsMid),
    {?noreply, State2};
do_cast({die, Uid}, State) ->
    copy_mod:die_handle(State,Uid),
    {?noreply, State};
do_cast({die_partner, Uid,PartnerId}, State) ->
    copy_mod:die_partner_handle(Uid,PartnerId),
    {?noreply, State};
do_cast({relive_ok, PlayerS}, State) ->
    copy_mod:relive_ok_handle(State,PlayerS),
    {?noreply, State};
do_cast({notice_over,Uid,HitTimes,CaromTimes,MonsHp}, State) ->
    State2 = copy_mod:notice_over_handle(State,Uid,HitTimes,CaromTimes,MonsHp),
    {?noreply, State2};
do_cast({move,Uid,Type,MoveType,PosX,PosY,OwnerUid}, State) ->
	copy_mod:move_handle(Uid,Type,MoveType,PosX,PosY,OwnerUid),
    {?noreply, State};
do_cast({move_new,Uid,Type,MoveType,PosX,PosY,OwnerUid}, State) ->
	copy_mod:move_new_handle(Uid,Type,MoveType,PosX,PosY,OwnerUid),
    {?noreply, State};
do_cast({war_harm,HarmData}, State) -> 
	State2 = copy_mod:war_harm_handle(State,HarmData),
    {?noreply, State2};
do_cast({player_list, Uid}, State) ->
	copy_mod:player_list_handle(State,Uid),
    {?noreply, State};
do_cast({player_list_new, Uid}, State) ->
	copy_mod:player_list_new_handle(State,Uid),
    {?noreply, State};
do_cast({set_posxy,Uid,X,Y,Mtype},State) -> 
	State2 = copy_mod:set_posxy_handle(State,Uid,X,Y,Mtype), 
    {?noreply,State2};
do_cast({broadcast, Uid, BinMsg}, State) ->
	scene_mod:do_broadcast_handle(Uid, BinMsg),
    {?noreply, State};
do_cast({exit, Uid}, State) ->
	copy_mod:exit_handle(Uid, State);
do_cast({monster_list,Uid}, State) ->
	copy_mod:monster_list_handle(State,Uid),
    {?noreply, State};
do_cast({monster_knock, Gmid, Gid}, State) ->
	State2 = copy_mod:monster_knock_handle(State, Gmid, Gid),
    {?noreply, State2};
do_cast({change_level, Uid, Value}, State) ->
	State2 = copy_mod:change_level_handle(State, Uid, Value),
    {?noreply, State2};
do_cast({change_clan, Uid, ClanId,ClanName}, State) ->
	State2 = copy_mod:change_clan_handle(State, Uid, ClanId,ClanName),
    {?noreply, State2};
do_cast({change_team, Uid, LeaderUid}, State) ->% NO
	State2 = copy_mod:change_team_handle(State, Uid, LeaderUid),
    {?noreply, State2};
do_cast({change_team_leader, NewLeaderUid, OldLeaderUid}, State) ->% NO
	copy_mod:change_team_leader_handle(NewLeaderUid, OldLeaderUid),
    {?noreply, State};
do_cast({change_mount, Uid, Mount, Speed}, State) ->
	State2 = copy_mod:change_mount_handle(State, Uid, Mount, Speed),
    {?noreply, State2};
do_cast({move_monster,MGid}, State) ->
	State2 = copy_mod:move_monster_handle(State,MGid),
    {?noreply, State2};
do_cast({change_war_state,UidAndState}, State) ->% NO
	State2 = copy_mod:change_war_state_handle(State,UidAndState), 
    {?noreply, State2};
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
do_info({?exec, Mod, Fun, Arg},State)->
	State2 = Mod:Fun(State, Arg),
	{?noreply, State2 };
%% do_info(?doloop,State)->  %% 处理注册定时 doloop
%% 	{?noreply,State};
%% 定时清理
do_info({offline,_Key}, State) ->
	{?noreply, State};
%% 这也是清理(不能发包)
do_info({send_lose,_Key}, State) ->
	{?noreply, State};
do_info(Info,State)-> %% 默认处理(勿删)
	?MSG_ERROR("Info Info:~w State:~w", [Info,State]),
	{?noreply,State}.


%% --------------------------------------------------------------------
%% Function: do_terminate/2
%% Description: 退出处理内容
%% --------------------------------------------------------------------
do_terminate(#copy{pid=Pid})->
	?MSG_ECHO("------------~w~n",[Pid]),
	%copy_mod:delete_copy(Pid),
	?ok.


%% --------------------------------------------------------------------
%%% 外部调用Serv
%% --------------------------------------------------------------------
% 开始进入副本
start_call(Pid, PlayerS) ->
	gen_server:call(Pid, {start, PlayerS}, ?CONST_OUTTIME_CALL).

% 副本场景切换
switch_in_call(Pid) ->
	gen_server:call(Pid, switch_in, ?CONST_OUTTIME_CALL).

%% 查找副本奖励
reward_call(Pid, Uid) ->
	gen_server:call(Pid, {reward, Uid}, ?CONST_OUTTIME_CALL).


%%=================API_CAST=================
% 定时刷新副本
interval_cast(Pid) ->
	gen_server:cast(Pid, interval).

% 开始计时
timing_cast(Pid, Type) ->
	gen_server:cast(Pid, {timing, Type}).

times_carom_cast(Pid,Uid,Times) ->
	gen_server:cast(Pid, {times_carom,Uid,Times}).

times_hit_cast(Pid,Uid,Times) ->
	gen_server:cast(Pid, {times_hit,Uid,Times}).

mons_kill_cast(Pid,Uid,MonsMid) ->
	gen_server:cast(Pid, {mons_kill,Uid,MonsMid}).

relive_ok_cast(Pid,PlayerS) ->
	gen_server:cast(Pid, {relive_ok,PlayerS}).

notice_over_cast(Pid,Uid,HitTimes,CaromTimes,MonsHp) ->
	gen_server:cast(Pid,{notice_over,Uid,HitTimes,CaromTimes,MonsHp}).

% 退出副本
exit_cast(Pid, Uid) ->
	gen_server:cast(Pid, {exit, Uid}).

% 玩家失败设置复活点
set_player_posxy_cast(SPid,Uid,X,Y,Mtype) ->
	gen_server:cast(SPid, {set_posxy, Uid,X,Y,Mtype}).

change_clan_cast(Pid,Uid,ClanId,ClanName) ->
	gen_server:cast(Pid,  {change_clan, Uid, ClanId,ClanName}).

%% 把怪物从场景移除
move_monster_cast(Pid,MGid) ->
	gen_server:cast(Pid,{move_monster,MGid}). 