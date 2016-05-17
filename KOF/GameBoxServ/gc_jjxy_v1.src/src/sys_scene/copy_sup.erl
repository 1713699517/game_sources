%%% -------------------------------------------------------------------
%%% Author  : mirahs
%%% Description :
%%%
%%% Created : 2011-12-18
%%% -------------------------------------------------------------------
-module(copy_sup).

-behaviour(supervisor).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([start_link/2]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([init/1]).
-export([start_child_copy_srv/2, which_children/0]).

%% --------------------------------------------------------------------
%% Records 
%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================
%% copy_inside_sup:start_link(copy_inside_sup,1,1).
start_link(SupName, Cores) ->
	app_link:supervisor_start_link({local, SupName}, ?MODULE, [Cores],Cores).


%% ====================================================================
%% Server functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {error, Reason}
%% --------------------------------------------------------------------
init([Cores]) ->
	process_flag(?trap_exit, ?true),
%% 	{?ok,_TRef}		= timer:apply_interval(round(timer:seconds(?CONST_MAP_INTERVAL_SECONDS)),copy_api,interval,[]),
	SupList 		= [{worker, copy_srv, copy_srv, transient, 1000, []}],
	SupervisorList 	= app_link:sup_one_for_one(SupList, Cores, []),
	?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
    {?ok,{{simple_one_for_one, 100, 5}, SupervisorList}}.

%% ====================================================================
%% Internal functions
%% ====================================================================

%% 新建并挂载副本copy_srv
start_child_copy_srv(CopyId,IsTeam) ->
	case supervisor:start_child(?MODULE, [{CopyId,IsTeam}]) of
		{?ok, Pid} ->
			Pid;
		{?error, {already_started, Pid}} ->
			Pid
	end.

%% copy_sup:which_children().
which_children() ->
	supervisor:which_children(?MODULE).