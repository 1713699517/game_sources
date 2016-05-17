%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-6-21
%%% -------------------------------------------------------------------
-module(gateway_worker_sup).

-behaviour(supervisor).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([start_link/2,
		 worker_list/0]). 

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([init/1]).
-export([start_child_gateway_worker_srv/3]).

%% ====================================================================
%% External functions
%% ====================================================================
%% gateway_worker_sup:start_link(gateway_worker_sup, 4).
start_link(SrvName, Cores) ->
	app_link:supervisor_start_link({local, SrvName}, ?MODULE, [Cores], Cores).
	% supervisor:start_link({local, SrvName}, ?MODULE, [Cores, Times]).

%% ====================================================================
%% Server functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Func: init/1
%% Returns: {?ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {?error, Reason}
%% --------------------------------------------------------------------
init([Cores]) ->
	process_flag(?trap_exit, ?true),
%% 	SupList 		= [{worker, gateway_worker_srv, gateway_worker_srv, transient, 1000, []}],
	SupList 		= [{worker, gateway_worker_srv, gateway_worker_srv, temporary, 3000, []}],
	SupervisorList 	= app_link:sup_one_for_one(SupList, Cores, []), 
	?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
    {?ok, {{simple_one_for_one, 100, 5}, SupervisorList}}.


%% 新建并挂载gateway_worker_srv
start_child_gateway_worker_srv(Cores,Socket,ListenSocket)->
	Idx		= (idx:work_idx() rem  Cores)+1, % util:uniform(Cores),
	SupName = app_link:srv_name(?MODULE, Idx),
	case supervisor:start_child(SupName, [Socket,ListenSocket]) of
		{?ok, MPid} -> 
			unlink(MPid),
			{?ok, MPid};
		{?error, {already_started, MPid}} -> 
			unlink(MPid),
			{?ok, MPid} 
	end.
	% gen_tcp:controlling_process(Socket, Pid),
	% util:pid_send(Pid, {set_socket, ListenSocket, Socket}).



%% 获取在线玩家列表
worker_list()->
	Cores  		= util:core_count(),
	CoreList	= lists:seq(1, Cores),
	worker_list(CoreList,[]).	
worker_list([],List) -> List;
worker_list([N|CoreList],List)->
	SrvName 	= app_link:srv_name(?MODULE, N),
	List2		= supervisor:which_children(SrvName),
	worker_list(CoreList,List++List2).
