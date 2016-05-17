%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-8-7
%%% -------------------------------------------------------------------
-module(scene_sup).

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
-export([start_child_map_srv/2, which_children/0]). 

%% --------------------------------------------------------------------
%% Records
%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================
%% scene_sup:start_link(scene_sup,1,1).
start_link(SupName, Cores) ->
	app_link:supervisor_start_link({local, SupName}, ?MODULE, [Cores], Cores).

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
%% 	{?ok,_TRef}		= timer:apply_interval(round(timer:seconds(?CONST_MAP_INTERVAL_SECONDS)),scene_api,interval,[]),
	SupList 		= [{worker, scene_srv, scene_srv, transient, 1000, []}],
	SupervisorList 	= app_link:sup_one_for_one(SupList, Cores, []),
	?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
    {?ok,{{simple_one_for_one, 100, 5}, SupervisorList}}.

%% ====================================================================
%% Internal functions
%% ====================================================================

%% 新建并挂载地图scene_srv
start_child_map_srv(MapId,Suffix) -> 
	case supervisor:start_child(?MODULE, [{MapId, Suffix}]) of 
		{?ok, Pid} ->
			Pid;
		{?error, {already_started, Pid}} ->
			Pid
	end.

%% scenes_map_sup:which_children().
which_children() ->
	supervisor:which_children(?MODULE).