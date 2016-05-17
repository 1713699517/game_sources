%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description : The Supervisor behaviour(gamecore.cn) dreamxyp@gmail.com
%%%
%%% Created : 2012-8-29
%%% -------------------------------------------------------------------
-module(global_sup).

-behaviour(supervisor).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([]). 

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([start_link/2,
		 init/1]). 

%% ====================================================================
%% External functions
%% ====================================================================



%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Func: start_link/3
%% Returns: {?ok,    Pid}                       |
%%          {?error, {already_started, Pid}}    |
%%          {?error, Reason}
%% Test:global_sup:start_link(global_sup, 1, 1).
%% --------------------------------------------------------------------
start_link(SrvName, Cores) ->
	app_link:supervisor_start_link({local, SrvName}, ?MODULE, [Cores], Cores).
	%supervisor:start_link({local, SrvName}, ?MODULE, [Cores]).
	
%% --------------------------------------------------------------------
%% Func: init/1
%% Returns: {?ok,  {SupFlags,  [ChildSpec]}} |
%%          ?ignore                          |
%%          {?error, Reason}
%% --------------------------------------------------------------------
init([Cores]) ->
    process_flag(?trap_exit, ?true),
    
    SupList 	  = [{worker, app_logs_srv},	%% 错误日志
					 {worker, global_srv},      %% global srv
					 {worker, crond_srv},		%% 定时服务进程
					 
					 {worker, clan_srv},         %% 帮派
					 {worker, arena_srv},        %%  逐鹿台
					 {worker, active_srv},       %% 活动
					 {worker, shoot_srv},
%% 					 {worker, camp_war_srv},	  %% 阵营战
					 {worker, world_boss_srv},    %%  世界BOSS
					 {worker, top_srv},  		  %%  世界排行版
                     {worker, wrestle_srv}        %% 格斗之王 
					% {worker, defend_book_srv}, %% 保卫经书
					% {worker, skywar_srv},		%% 天宫之战			
					% {worker, stride_srv},		%% 跨服战	

					% {supervisor, clan_sup}		%% 帮派进程监控	 
					],
	SupervisorList = app_link:sup_one_for_one(SupList, Cores, []),
    
	?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
    {?ok, {{one_for_one, 100, 5}, SupervisorList}}.

%% ====================================================================
%% Internal functions
%% ====================================================================

