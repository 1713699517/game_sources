%% Author  : mirahs
%% Created: 2012-6-20
%% Description: TODO: Add description to team_api
-module(shoot_mod).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 reward_history_handle/2,
		 reward_history2/3,
		 reward_all_handle/3,
		 reward_money_handle/1,
		 shoot_data_get/0,
		 shoot_data_set/1

		]).

reward_money_handle(Money) ->
	case shoot_data_get() of
		?null ->
			ShootData = #shoot_data{ money= ?CONST_ARROW_DAILY_BUY_LIMIT_TIMES },
			shoot_data_set(ShootData);
		ShootData ->
			shoot_data_set(ShootData#shoot_data{money=Money})
	end.



reward_history_handle(Uid,GoodsId) ->
	Seconds = util:seconds(),
	History1 = #s_history{uid=Uid,goods_id=GoodsId,seconds=Seconds},
	%% ?MSG_ECHO("-------------------~w~n",[History1]),
	case shoot_data_get() of
		?null ->
			ShootData = #shoot_data{history=[History1]},
			%% ?MSG_ECHO("-------------------~w~n",[ShootData]),
			shoot_data_set(ShootData);
		#shoot_data{history=RewardHistory}=ShootData ->
			%% ?MSG_ECHO("-------------------~w~n",[ShootData]),
			Max = ?CONST_ARROW_DAILY_HISTORY,
			RewardHistory1 = [History1|RewardHistory],
			case length(RewardHistory1) > Max of
				?true ->
					RewardHistory2 = lists:keysort(#s_history.seconds,RewardHistory1),
					RewardHistory3 = lists:reverse(RewardHistory2),
					RewardHistory4 = lists:sublist(RewardHistory3, Max),
					shoot_data_set(ShootData#shoot_data{history=RewardHistory4});
				_ ->
					%% ?MSG_ECHO("-------------------~w~n",[ShootData]),
					shoot_data_set(ShootData#shoot_data{history=RewardHistory1})
			end
	end.

reward_history2(Uid,GoodsId,Count) ->
	Seconds = util:seconds(),
	History1 = #s_history{uid=Uid,goods_id=GoodsId,count= Count,seconds=Seconds},
	%% ?MSG_ECHO("-------------------~w~n",[History1]),
	case shoot_data_get() of
		?null ->
			ShootData = #shoot_data{history=[History1]},
			%% ?MSG_ECHO("-------------------~w~n",[ShootData]),
			shoot_data_set(ShootData);
		#shoot_data{history=RewardHistory}=ShootData ->
			%% ?MSG_ECHO("-------------------~w~n",[ShootData]),
			Max = ?CONST_ARROW_DAILY_HISTORY,
			RewardHistory1 = [History1|RewardHistory],
			case length(RewardHistory1) > Max of
				?true ->
					RewardHistory2 = lists:keysort(#s_history.seconds,RewardHistory1),
					RewardHistory3 = lists:reverse(RewardHistory2),
					RewardHistory4 = lists:sublist(RewardHistory3, Max),
					shoot_data_set(ShootData#shoot_data{history=RewardHistory4});
				_ ->
					%% ?MSG_ECHO("-------------------~w~n",[ShootData]),
					shoot_data_set(ShootData#shoot_data{history=RewardHistory1})
			end
	end.

reward_all_handle(Uid,Uname,Money) ->
	case shoot_data_get() of
		?null ->
			ShootData = #shoot_data{last_award={Uid,Uname,Money}},
			shoot_data_set(ShootData);
		ShootData ->
			shoot_data_set(ShootData#shoot_data{last_award={Uid,Uname,Money}})
	end.

shoot_data_get() ->
	case ets:lookup(?ETS_PUBLIC_RECORDS, ?CONST_PUBLIC_KEY_KEY_SHOOT) of
		[{?CONST_PUBLIC_KEY_KEY_SHOOT,ShootData}|_] ->
			%% ?MSG_ECHO("~w~n",[ShootData]),
			ShootData;
		_ ->
			?null
	end.

shoot_data_set(ShootData) ->
	ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_KEY_SHOOT,ShootData}),
	?ok.
