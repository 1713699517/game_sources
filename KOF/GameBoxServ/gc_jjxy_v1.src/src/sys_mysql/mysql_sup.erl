%%% -------------------------------------------------------------------
%%% Author  : dreamxyp
%%% Description :
%%%
%%% Created : 2011-6-25
%%% -------------------------------------------------------------------
-module(mysql_sup).

-behaviour(supervisor).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
-include("../include/drive.mysql.hrl").
%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([start_link/2,restart_child/0,restart_child_logs/0]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([init/1]).
%% ====================================================================
%% External functions
%% ====================================================================

%% ====================================================================
%% External functions
%% ====================================================================
%% mysql_sup:start_link(mysql_sup, 4).
start_link(SrvName, Cores) ->
	app_link:supervisor_start_link({local, SrvName}, ?MODULE, [Cores], Cores).
	% supervisor:start_link({local, SrvName}, ?MODULE, [Cores,Times]).

%% ====================================================================
%% Server functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Func: init/1
%% Returns: {?ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                           |
%%          {?error, Reason}
%% --------------------------------------------------------------------
init([Cores]) ->
	process_flag(?trap_exit, ?true),
	SupList 	  = [
					 {supervisor, mysql_side_sup},	%% 进程监控	
					 {worker, 	  mysql_srv}		%% 工作主Serv
					],
	SupervisorList = app_link:sup_one_for_one(SupList, Cores, []),
	?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores,util:core_idx() ]),
	{?ok, {{one_for_one, 100, 5}, SupervisorList}}.


restart_child()->
	supervisor:terminate_child(?MODULE, mysql_side_sup),
	supervisor:restart_child(?MODULE, 	mysql_side_sup),
	supervisor:terminate_child(?MODULE, mysql_srv),
	supervisor:restart_child(?MODULE, 	mysql_srv),
	?ok.

restart_child_logs()->
	mysql_side_sup:restart_child(mysql_side_srv_logs),
	?ok.

