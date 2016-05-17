%% Author: Administrator
%% Created: 2012-8-31
%% Description: TODO: Add description to app_link
-module(app_link).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([spawn/3, 	   spawn/4,			spawn/5, 
		 spawn_link/3, spawn_link/4,	spawn_link/5,
		 
		 gen_server_start_link_noname/2, gen_server_start_link_noname/3,
		 gen_server_start_link/3,		 gen_server_start_link/4,
		 supervisor_start_link_noname/2, supervisor_start_link_noname/3,
		 supervisor_start_link/3,		 supervisor_start_link/4, 
		 
		 call/2, call/3, call_timeout/3, call_timeout/4, cast/2, cast/3,
		 
		 srv_name/2,srv_namecall/2,
		 srv_list/7,srv_list/6,
		 sup_one_for_one/3]).


%% 指定CPU
spawn(Module,Function,Args)->
	Cores 	= util:core_count(),
	Times	= idx:srv_idx(),
	spawn(Module,Function,Args,Cores,Times).
spawn(Module,Function,Args,Cores)->
	Times	= idx:srv_idx(),
	spawn(Module,Function,Args,Cores,Times).
spawn(Module,Function,Args,Cores,Times)->
	case Cores of
		1 -> erlang:spawn(Module, Function, Args);
		_ -> spawn_opt(Module,Function,Args,[{scheduler, (Times rem Cores) + 1  }])
	end.

spawn_link(Module,Function,Args)->
	Cores 	= util:core_count(),
	Times	= idx:srv_idx(),
	spawn_link(Module,Function,Args,Cores,Times).
spawn_link(Module,Function,Args,Cores)->
	Times	= idx:srv_idx(),
	spawn_link(Module,Function,Args,Cores,Times).
spawn_link(Module,Function,Args,Cores,Times)->
	case Cores of
		1 -> erlang:spawn_link(Module, Function, Args);
		_ -> spawn_opt(Module,Function,Args,[link,{scheduler, (Times rem Cores) + 1 }])
	end.


gen_server_start_link_noname(Mod,Args)->
	Cores 	= util:core_count(),
	gen_server_start_link_noname(Mod,Args,Cores).
gen_server_start_link_noname(Mod,Args,Cores)->
	Times	= idx:srv_idx(),
	case Cores of
		1 -> gen_server:start_link(Mod, Args, []);
		_ -> gen_server:start_link(Mod, Args, [{spawn_opt,[{scheduler, (Times rem Cores) + 1}]}])
	end.

gen_server_start_link(SrvName,Mod,Args)->
	Cores 	= util:core_count(),
	gen_server_start_link(SrvName,Mod,Args,Cores).
gen_server_start_link(SrvName,Mod,Args,Cores)->
	Times	= idx:srv_idx(),
	case Cores of
		1 -> gen_server:start_link({local, SrvName}, Mod, Args, []);
		_ -> gen_server:start_link({local, SrvName}, Mod, Args, [{spawn_opt,[{scheduler,(Times rem Cores) + 1}]}])
	end.

supervisor_start_link_noname(Mod, Args) ->
	Cores 	= util:core_count(),
	supervisor_start_link_noname(Mod, Args, Cores).
supervisor_start_link_noname(Mod, Args, Cores) ->
	Times	= idx:srv_idx(),
	case Cores of
		1 -> gen_server:start_link(supervisor, {self, Mod, Args}, []);
		_ -> gen_server:start_link(supervisor, {self, Mod, Args}, [{spawn_opt,[{scheduler,(Times rem Cores) + 1}]}])
	end.

supervisor_start_link(SupName, Mod, Args) ->
	Cores 	= util:core_count(),
	supervisor_start_link(SupName, Mod, Args, Cores).
supervisor_start_link(SupName, Mod, Args, Cores) ->
	Times	= idx:srv_idx(),
	case Cores of
		1 -> gen_server:start_link(SupName, supervisor, {SupName, Mod, Args}, []);
		_ -> gen_server:start_link(SupName, supervisor, {SupName, Mod, Args}, [{spawn_opt,[{scheduler,(Times rem Cores) + 1}]}])
	end.

call(Mod, Request) ->
	N		= util:core_idx(),
	call(Mod, N, Request).
call(Mod, Suffix, Request) ->
	Handler = srv_namecall(Mod, Suffix),
	case gen_server:call(Handler, Request,?CONST_OUTTIME_CALL) of
		{?error, Error} ->
			?MSG_ERROR("call(Mod:~p Suffix:~p Request:~p):~p",[Mod, Suffix, Request, {?error, Error}]),
			{?error, Error};
		Reply -> 
			Reply
	end.
call_timeout(Mod, Request, Timeout)->
	N		= util:core_idx(),
	call_timeout(Mod, Request, N, Timeout).
call_timeout(Mod, Request, Suffix, Timeout) ->
	Handler = srv_namecall(Mod, Suffix),
	case gen_server:call(Handler, Request, Timeout) of
		{?error, Error} ->
			?MSG_ERROR("call_timeout(Mod:~p Request:~p Suffix:~p Timeout:~p):~p",[Mod, Request, Suffix, Timeout, {?error, Error}]),
			{?error, Error};
		Reply ->
			Reply
	end.
cast(Mod, Request) ->
	N		= util:core_idx(),
	cast(Mod, N, Request).
cast(Mod, Suffix, Request) ->
	Handler = srv_namecall(Mod, Suffix),
	gen_server:cast(Handler, Request).



%% Srv列表
srv_list([], Rs, _Type, _Mod, _Restart, _Shutdown, _Arg) ->
	Rs;
srv_list([N|TList], Rs, Type, Mod, Restart, Shutdown, Arg) ->
	SrvName = srv_name(Mod, N),
	R  		= {Type, Mod, SrvName, Restart, Shutdown, Arg},
	srv_list(TList, [R|Rs], Type, Mod, Restart, Shutdown, Arg).
srv_list([], Rs, _Type, _Mod, _Restart, _Shutdown) ->
	Rs;
srv_list([{N,Arg}|TList], Rs, Type, Mod, Restart, Shutdown) ->
	SrvName = srv_name(Mod, N),
	R  		= {Type, Mod, SrvName, Restart, Shutdown, Arg},
	srv_list(TList, [R|Rs], Type, Mod, Restart, Shutdown).


%% 监控树启动项
sup_one_for_one([Mod|ModList], Cores, Rs) ->
	ChildSpec = sup_one_for_one2(Mod, Cores),
	sup_one_for_one(ModList, Cores, [ChildSpec | Rs]);
sup_one_for_one([], _Cores, Rs) ->
	lists:reverse(Rs).
sup_one_for_one2({Type, Mod, SrvName, Restart, Shutdown, Args}, Cores) ->
	{SrvName,											%% Id 		 = term()
	 {Mod, start_link, [SrvName, Cores|Args]},	%% StartFunc = {M, F, A}
	 Restart,											%% Restart 	 = permanent | transient | temporary
	 Shutdown,											%% Shutdown  = brutal_kill | integer() >=0 | infinity
	 Type,												%% Type 	 = worker | supervisor
	 [Mod]												%% Modules 	 = [Module] | dynamic
	};
sup_one_for_one2({Type, Mod, SrvName, Shutdown}, Cores) ->
	sup_one_for_one2({Type, Mod, SrvName, permanent, Shutdown, []}, Cores);
sup_one_for_one2({Type, Mod, SrvName}, Cores) ->
	sup_one_for_one2({Type, Mod, SrvName, permanent, 1000, []},Cores);
sup_one_for_one2({Type, Mod}, Cores) ->
	sup_one_for_one2({Type, Mod, Mod, 	  permanent, 1000, []}, Cores);
sup_one_for_one2(Mod, Cores) ->
	sup_one_for_one2({worker, Mod, Mod,   permanent, 1000, []}, Cores).


srv_name(Mod, N) ->
	util:list_to_atom(util:to_list(Mod) ++ "_" ++ util:to_list(N)).

srv_namecall(Mod, N) ->
	list_to_existing_atom(util:to_list(Mod) ++ "_" ++ util:to_list(N)).
