%% @author dreamxyp
%% @doc @todo Add description to role_interval.


-module(role_interval).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
%% ====================================================================
%% API functions
%% ====================================================================
-export([interval_clean/0,
		 interval/0,
		 interval_cb/2]).


%% 玩家定时doloop
doloop(Player) ->
	Player2 = goods_api:check_temp(Player, []),
	Player2.


%% 清理  EtsOffLine 长时间没用到的数据
interval_clean()->
	role_db:ets_offline_clean(). 

%% 每日0点刷新
interval() ->
	case app_tool:node_super() of
		0->?skip;
		NodeName->
			rpc:call(NodeName,super_api,update_super,[])
	end,
	%% 刷新日期活动(非格列高利历时间类型活动)状态
	% com_srv:apply_after_info(5000, collect_api, refresh_state, []),
	% wheel_api:reset_times(),
	% clan_api:clean_day(),
	% clan_api:reset_clanboss(),
	OnUserList	= ets:tab2list(?ETS_ONLINE),		% 将在线玩家列表转换成记录
	Fun=fun(Uid)->
				util:pid_send(Uid, ?MODULE, interval_cb, ?null)
		end,
	[Fun(Online#player.uid)||Online<-OnUserList].

interval_cb(Player=#player{info=Info,socket=Socket},_) ->
	copy_api:refresh(Info#info.copy_id,Info#info.map_type), 
	hero_api:refresh(),
	fiend_api:refresh(),
	fighters_api:refresh(),
	friend_api:refresh(),
	weagod_api:refresh(),
	sign_api:refresh(),
	flsh_api:fresh(Socket),
	shoot_api:refresh(),
	active_api:refresh(Socket),
	% Player1=renown_api:login(Player),
	% Player2=sign_api:login(Player1),
	% Player4=weagod_api:refresh(Player2),
	% Player4=fishing_api:login(Player3),
	% Player5=mount_api:refresh(Player4),
	% Player6=dragon_api:login(Player5),
	% Player7=stride_api:login_stride_day(Player6),
	Player.



%% 每周二固定给内部号发放绑定金元
inside_rmb() ->
	case mysql_api:select([uid,bind_rmb], inside_rmb) of
		{?ok, []} ->
			?skip;
		{?ok, InsideL} ->
			Fun = fun([Uid,BindRmb]) ->
						  inside_rmb_one(Uid, BindRmb)  
				  end,
			lists:foreach(Fun, InsideL);
		Err ->
			?MSG_ERROR("Err : ~p~n", [Err])
	end.

inside_rmb_one(Uid, BindRmb) ->
	case role_db:ets_online_read(Uid) of
		Player when is_record(Player, player) ->
			role_api:progress_send(Player#player.mpid, ?MODULE, inside_rmb_cb, BindRmb);
		_ ->
			case mysql_api:select("select `rmb_bind`,`rmb_total`,`lv` from user where uid=" ++ util:to_list(Uid)) of
				{?ok, [[BindRmb0,RmbTotal,Lv]]} ->
					Value = BindRmb0 + BindRmb,
					stat_api:logs_cost(Uid,Lv, ?CONST_CURRENCY_RMB_BIND, BindRmb, Value, [?MODULE,inside_rmb_one,[],<<"内部号发放金元">>]),
					mysql_api:update(user, [{bindrmb,Value},{rmb_total,RmbTotal+BindRmb}], "uid=" ++ util:to_list(Uid));
				Any ->
					?MSG_ERROR("inside role is no exits : ~p~n", [{Uid,BindRmb, Any}]),
					?skip
			end
	end.

%% 固定给内部号发放绑定金元
inside_rmb_cb(Player, BindRmb) -> 
	{Player2, BinMsg} = role_api:currency_add([inside_rmb_cb,[],<<"内部号发放金元">>], Player, [{?CONST_CURRENCY_RMB_BIND, BindRmb}]),
	app_msg:send(Player2#player.socket, BinMsg),
	Player2.

