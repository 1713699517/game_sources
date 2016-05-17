%% @author dreamxyp
%% @doc @todo Add description to global_queue.


-module(global_queue).

%% ====================================================================
%% API functions
%% ====================================================================
-export([fcm_callback/2,fcm_callback_cb/2,
		 queue_wrestle_cast/3]).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").


%% 防沉迷 调中心服务器
fcm_callback(Uid,FcmTime)->
	queue_call(?MODULE, fcm_callback_cb,{Uid,FcmTime}).
fcm_callback_cb(State,{Uid,FcmTime})->
	app_link:spawn(util, request_get, [db:config_fcm_callback(),[{"uid",Uid},{"online",FcmTime}]]),
	State.
	

% 调用Serv
queue_call(Mod, Fun, Arg)->
	util:pid_send(global_srv, Mod, Fun, Arg).

queue_wrestle_cast(Mod,Fun,Arg)->
	util:pid_send(global_srv, Mod, Fun, Arg).





