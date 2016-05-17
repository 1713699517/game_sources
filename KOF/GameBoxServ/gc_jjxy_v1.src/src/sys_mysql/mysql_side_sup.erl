%%% -------------------------------------------------------------------
%%% Author  : dreamxyp
%%% Description :
%%%
%%% Created : 2011-6-25
%%% -------------------------------------------------------------------
-module(mysql_side_sup).

-behaviour(supervisor).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
-include("../include/drive.mysql.hrl").
%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([start_link/2,
		 restart_child/1,
		 start_child_mysql_side_srv_logs/2,
		 start_child_mysql_side_srv/2]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([init/1]).
%% --------------------------------------------------------------------
%% Records
%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================

%% ====================================================================
%% External functions
%% ====================================================================
%% mysql_side_sup:start_link(mysql_side_sup,1).
start_link(SrvName, Cores) ->
	app_link:supervisor_start_link({local, SrvName}, ?MODULE, [Cores], Cores).
	% supervisor:start_link({local, SrvName}, ?MODULE, [Cores,Times,Sid]).

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
%% 	CoreList0	   	= lists:seq(1, Cores),
%% 	CoreList		= lists:map(fun(I)-> util:to_list(Sid) ++"_"++ util:to_list(I) end, CoreList0),
%% 	SupList     	= app_link:srv_list(CoreList, [], worker, mysql_side_srv, permanent, brutal_kill,[Sid]),
%% 	SupervisorList  = app_link:sup_one_for_one(SupList, Cores, Times, []),	
	?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
	{?ok, {{one_for_one, 100, 5}, []}}.



start_child_mysql_side_srv(Cores,MysqlSideState)->
	% Sid			= MysqlSideState#mysql_side.sid,
	CoreList	   	= lists:seq(1, Cores),
	%CoreList		= lists:map(fun(I)-> util:to_list(Sid) ++"_"++ util:to_list(I) end, CoreList0),
	SupList     	= app_link:srv_list(CoreList, [], worker, mysql_side_srv, permanent, brutal_kill,[MysqlSideState]),
	SupervisorList  = app_link:sup_one_for_one(SupList, Cores, []),	
	start_child_mysql_side_srv2(SupervisorList,[]).


start_child_mysql_side_srv_logs(Cores,MysqlSideState)->
	CoreList	   	= ["logs"],
	SupList     	= app_link:srv_list(CoreList, [], worker, mysql_side_srv, permanent, brutal_kill,[MysqlSideState]),
	SupervisorList  = app_link:sup_one_for_one(SupList, Cores, []),
	[Pid|_] 		= start_child_mysql_side_srv2(SupervisorList,[]),
	Pid.

start_child_mysql_side_srv2([],Rs) -> Rs;
start_child_mysql_side_srv2([ChildSpec|SupervisorList],Rs) ->
	SupName = ?MODULE, % app_link:srv_name(?MODULE, Sid),
	SrvName	= element(1, ChildSpec),
	% ?MSG_ECHO("SupName:~p SrvName:~p , ChildSpec:~p",[SupName,SrvName,ChildSpec]),
	case supervisor:start_child(SupName, ChildSpec) of
		{?ok,	 _Pid} -> ?ok;
		{?error, {already_started, _Pid}} -> ?ok
	end,
	Rs2	= [SrvName|Rs],
	start_child_mysql_side_srv2(SupervisorList,Rs2).

restart_child(SrvName)->
	SupName = ?MODULE,% app_link:srv_name(?MODULE, Sid),
	supervisor:terminate_child(SupName, SrvName),
	supervisor:restart_child(SupName, 	SrvName),
	?ok.
	