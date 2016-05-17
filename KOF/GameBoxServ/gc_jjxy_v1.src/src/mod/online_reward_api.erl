%% @author dreamxyp
%% @doc @todo Add description to online_reward.


-module(online_reward_api).


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


%% ====================================================================
%% API functions
%% ====================================================================
-export([]).


%% 退出保存累计时间
online_reward_logout(#player{uid=Uid})->
	Time=util:seconds(),
	case ets:lookup(?ETS_ONLINE_REWARD,Uid) of
		[]->?skip;
		[{_,NextTime,Stime,LogTime}|_]->
			Stime2=?IF(Time-LogTime<0,0,Stime-(Time-LogTime)),
			ets:insert(?ETS_ONLINE_REWARD,{Uid,NextTime,Stime2,Time}),
			mysql_api:update_insert(online_reward,[{uid,Uid}],[{stime,Stime},{logtime,Time}])
	end.

%% 在线奖励
online_reward(Socket,Sid,Uid)->
	case ets:lookup(?ETS_ONLINE_REWARD,Uid) of
		[]->
			?skip;
		[{_,Time,Stime,LogTime}]->
			LogTime2=util:seconds(),
			Stime2=?IF(LogTime2-LogTime<0,0,LogTime2-LogTime),
			Stime3=?IF(Stime-Stime2=<0,0,Stime-Stime2),
			ets:insert(?ETS_ONLINE_REWARD,{Uid,Time,Stime2,LogTime2}),
			mysql_api:update_insert(Sid,online_reward,[{uid,Uid}],[{logtime,LogTime2}]),
			BinMsg=role_api:msg_online_reward(Time,Stime3),
			app_msg:send(Socket,BinMsg)
	end.

%% %% 在线等级奖励领取
online_reward_lv(Player=#player{uid=Uid})->
	case ets:lookup(?ETS_ONLINE_REWAD_LV,Uid) of 
		[]->
			online_reward_lv2(Player,1);
		[{_,Lv}|_]->
			online_reward_lv2(Player,Lv) 
	end.

online_reward_lv2(Player=#player{socket=Socket,lv=InfoLv},Lv)->
	case Lv=<InfoLv of
		?true->
			online_reward_goods(Socket,Lv),
			online_reward_lv2(Player,Lv+1);
		_->Player
	end.

online_reward_goods(Socket,Lv) ->
	case data_level_gift:get(Lv) of
		GiveList when is_list(GiveList)->
			LogSrc=[?MODULE,online_rewardlv,[],<<"在线等级奖励">>],
			case goods_api:set(LogSrc,GiveList) of
				{?ok,Bin}->
					app_msg:send(Socket,Bin);
				{?error,ErrorCode}->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg)
			end; 
		_->?skip
	end.



%% 在线时间奖励
online_reward(Player=#player{uid=Uid})->
	case ets:lookup(?ETS_ONLINE_REWARD,Uid) of
		[]->
			{?ok,Player};
		[{_,KeyTime,Stime,LogTime}|_]->
			Time=util:seconds(),
			case Time-LogTime>=Stime of
				?true->
					online_reward_good(Player,KeyTime,Time);
				_->
					{?error,110}
			end
	end.

online_reward_good(Player=#player{uid=Uid},KeyTime,Time)->
	case data_time_gift:get(KeyTime) of
		{NextTime,GiveList} when is_list(GiveList)->
			Fun=fun(Give0,Acc)-> 
						case goods_api:goods(Give0) of
							Goods when is_record(Goods,goods)->
								[Goods|Acc];
							_->
								Acc
						end
				end,
			GoodsList0=lists:foldl(Fun,[],GiveList),
			case goods_api:set([?MODULE,online_reward_good,[],<<"领取在线奖励">>],Player, GoodsList0) of
				{?ok,Player2,GoodsBin}->
					case NextTime of
						0->ets:delete(?ETS_ONLINE_REWARD,Uid),
						   mysql_api:delete(nline_reward,"uid ="++ util:to_list(Uid));
						_->
							ets:insert(?ETS_ONLINE_REWARD,{Uid,NextTime,NextTime*60,Time}),
							mysql_api:update_insert(online_reward,[{uid,Uid}],[{time,NextTime},{stime,NextTime*60},{logtime,Time}])
					end,
					BinMsg=role_api:msg_online_reward(NextTime,NextTime*60),
					{?ok,Player2,<<BinMsg/binary,GoodsBin/binary>>};
				{?error,Error}->
					{?error,Error}
			end
	end.


online_reward_time(Sid,Uid)->
	LogTime=util:seconds(),
	%% 在线时间奖励
	ets:insert(?ETS_ONLINE_REWARD,{Uid,1,1*60,LogTime}),
	mysql_api:update_insert(Sid,online_reward,[{uid,Uid}],[{time,1},{stime,1*60},{logtime,LogTime}]),
	TimeBinMsg=role_api:msg_online_reward(1,1*60),
	app_msg:send(Uid,TimeBinMsg).

%% %% 在线等级奖励
%% onlin_reward_lv(Uid,Lv)->
%% 	case data_level_gift:get(Lv) of
%% 		?null-> ?skip;
%% 		_ ->
%% 			LvBinMsg=role_api:msg_level_gift(Lv),
%% 			app_msg:send(Uid,LvBinMsg)
%% 	end.
