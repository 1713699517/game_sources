%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-6-21
%%% -------------------------------------------------------------------
-module(gateway_sup).

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
-export([start_link/2, init/1, down/0, wake_up/0, show/0]).


%% --------------------------------------------------------------------
%% Records
%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================
%% gateway_sup:start_link(gateway_sup, 4).
start_link(SrvName, Cores) ->
	app_link:supervisor_start_link({local, SrvName}, ?MODULE, [Cores], Cores).
	% supervisor:start_link({local, SrvName}, ?MODULE, [Cores,Times]).


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
%% 	{
%% 	 sid,			Sid,
%% 	 sid_merge,		_SidMerge,
%% 	 business,		_LineNums
%% 	} 		= db:config_line(),   % app_tool:ly_config(line),
	{
	 port, 			Port,
	 port_gm, 		_Port_gm
	} 		= db:config_gateway(),% app_tool:ly_config(gateway,Sid),	 
	case gen_tcp:listen(Port, ?TCP_OPTIONS) of
        {?ok, ListenSocket} ->
			CoreList	   = lists:seq(1, Cores),
			SupList1  	   = app_link:srv_list(CoreList, [], supervisor, gateway_worker_sup,   permanent, infinity,   []),
			SupList2       = app_link:srv_list(CoreList, [], worker,     gateway_acceptor_srv, permanent, brutal_kill,[ListenSocket]),
			SupervisorList = app_link:sup_one_for_one(SupList1++SupList2, Cores, []),
			%?MSG_ECHO(" SupervisorList:~p ",[SupervisorList]),
			
			util:sleep(1000),
			?MSG_PRINT(" Server Start Cores:~p OnCore:~p",[Cores, util:core_idx() ]),
			{?ok, {{one_for_one, 100, 5}, SupervisorList}};
		Reason ->
			?MSG_ERROR(" Reason:~p",[Reason]),
			{?error, Reason}
	end.

%% 停服
%% down()->
%% 	 Children = supervisor:which_children(?MODULE),
%% 	 case down_check(Children) of
%% 		 ?false -> % 正在停服中
%% 			 ?false;
%% 		 ?true  ->
%% 			 %% 停服维护广播(5分钟)
%% 			 core_api:broadcast_stop_server(5),
%% 			 %% 不让登录
%% 			 Cores  	= utilcore(),
%% 			 CoreList	= lists:seq(1, Cores),			 
%% 			 lists:foreach(fun(N)->
%% 								   SrvName = app_link:srv_name(gateway_acceptor_srv, N),
%% 								   %supervisor:terminate_child(?MODULE,SrvName),
%% 								   %supervisor:delete_child(?MODULE,SrvName)
%% 								   ?ok
%% 						   end,CoreList),
%% 			 ?true
%% 	 end.
%% down_check([])-> 
%% 	?false;
%% down_check([{_SrvName,_Pid,_Type,[gateway_acceptor_srv]}|_Children])-> 
%% 	?true;
%% down_check([_H|Children])-> 
%% 	down_check(Children).
%% gateway_sup:down().
down() -> 
	 Children = supervisor:which_children(?MODULE),
	 down(Children).
down([{_SrvName,Pid,_Type,[gateway_acceptor_srv]}|Children]) ->
	gateway_acceptor_srv:switch(Pid, ?false),
	down(Children);
down([_|Children]) ->
	down(Children);
down([]) -> ?ok.
%% gateway_sup:wake_up().
wake_up() ->
	 Children = supervisor:which_children(?MODULE),
	 wake_up(Children).
wake_up([{_SrvName,Pid,_Type,[gateway_acceptor_srv]}|Children]) ->
	gateway_acceptor_srv:switch(Pid, ?true),
	wake_up(Children);
wake_up([_|Children]) ->
	wake_up(Children);
wake_up([]) -> ?ok.
			 
show() ->
	Children = supervisor:which_children(?MODULE),
	show(Children).
show([{_SrvName,Pid,_Type,[gateway_acceptor_srv]}|Children]) ->
	gateway_acceptor_srv:show(Pid),
	show(Children);
show([_|Children]) ->
	show(Children);
show([]) -> ?ok.
			 

%% ====================================================================
%% Internal functions
%% ====================================================================



