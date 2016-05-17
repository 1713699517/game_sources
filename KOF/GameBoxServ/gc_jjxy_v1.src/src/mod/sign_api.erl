%% Author  : mirahs
%% Created: 2012-6-20
%% Description: TODO: Add description to team_api
-module(sign_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 decode_sign/1,
		 encode_sign/1,
		 request_sign/0,
		 init/1,
		 init/0,
 		 login/0,
		 refresh/0,
		 get_day_rewards/2,
		 get_rewards/2,
%% 		 gives2goods/1,
		 
		 msg_reward_info/2,
		 msg_get_rewards_ok/1
		]).

encode_sign(Sign) ->
	Sign.

decode_sign(Sign) when is_record(Sign,sign) -> 
	Sign;
decode_sign(_Sign) ->
	init().

%% 初始化签到信息
init(Player) -> 
	Sign= init(),
	{Player,Sign}.

init() ->
	SignReward= #signreward{day=1, is_get = ?CONST_SIGN_NO},
	Date= util:seconds(),
	?MSG_ECHO("------------~w~n",[SignReward]),
	DictSign = #sign{num = 1, date = Date, signreward = [SignReward] },
	role_api_dict:sign_set(DictSign),
	DictSign.

refresh()->
	login().

login() ->
	#sign{num=Num,date=Date,signreward=SignRewards}= role_api_dict:sign_get(),
	NewDate = util:seconds(),
	Day= util:days_diff(NewDate, Date),
	if Day =:= 1 -> 
		   case Num < ?CONST_SIGN_TIM_MAX of
			   ?true ->
				   NewNum = Num +1 ,
				   SignReward1 = #signreward{day= NewNum,is_get = ?CONST_SIGN_NO},
				   NewSignReward = [SignReward1|SignRewards],
				   NewSign= #sign{num= NewNum, date= NewDate, signreward= NewSignReward},
				   role_api_dict:sign_set(NewSign);
			   _ ->
				   case lists:keytake(?CONST_SIGN_TIM_MAX, #signreward.day, SignRewards) of
					   {value,Reward,RewardTmp} ->
						   ?MSG_ECHO("-----------~w~n",[{Reward,RewardTmp}]),
						   RewardTmp1= RewardTmp;
					   _ ->
						   RewardTmp1 =[]
				   end,
				   NewNum = Num +1 ,
				   NewSignReward = #signreward{day= ?CONST_SIGN_TIM_MAX,is_get= ?CONST_SIGN_NO},
				   NewSignRewards= [NewSignReward|RewardTmp1],
				   NewSign= #sign{num= NewNum, date= NewDate, signreward= NewSignRewards},
				   ?MSG_ECHO("~w~n",[{NewSignRewards}]),
				   ?MSG_ECHO("~w~n",[NewSign]),
				   role_api_dict:sign_set(NewSign)
		   end;
	   Day > 1 ->
		   ?MSG_ECHO("~w~n",[Day]),
		   SignReward= #signreward{day=1, is_get = ?CONST_SIGN_NO},
		   Sign2= #sign{num = 1, date = NewDate, signreward = [SignReward] },
		   role_api_dict:sign_set(Sign2);
	   ?true ->
		   ?MSG_ECHO("~w~n",[Day]),
		   ?skip
	end.

request_sign() ->
	#sign{date = Date,signreward = Reward} = role_api_dict:sign_get(),
	Now = util:seconds(),
	Day = util:days_diff(Now, Date),
	case Day =:= 0 of
		?true ->
			case Reward =/= [] of
				?true ->
					Fun = fun({signreward,AccDay,AccIsGet},{Count,Bin}) ->
								  BinAcc = msg_reward_info(AccDay, AccIsGet),
								  {Count+1,<<BinAcc/binary,Bin/binary>>}
						  end,
					{Count1,Bin1} = lists:foldl(Fun,{0,<<>>}, Reward),
					?MSG_ECHO("--------------~w~n",[{Count1,Bin1}]),
					Bin2 = app_msg:encode([{?int16u,Count1}]),
					app_msg:msg(?P_SIGN_DAYS,<<Bin2/binary,Bin1/binary>>);
				_->
					refresh(),
					request_sign()
			end;
		_ ->
			refresh(),
			request_sign()
	end.
	

get_rewards(#player{socket= Socket,uid = Uid, lv = Lv}= Player,Day) ->
	#sign{num= Num,date= Date,signreward= SignRewards}= role_api_dict:sign_get(),
	NowDate= util:seconds(),
	Bag = role_api_dict:bag_get(),
	Day1 = util:days_diff(Date, NowDate),
	case Day1 =:= 0 of
		?true ->
			case lists:keytake(Day, #signreward.day, SignRewards) of
				{value,Reward,RewardTmp} ->
					#signreward{is_get=IsGet}= Reward,
					LeaveReward= RewardTmp,
					case IsGet =:= ?CONST_SIGN_NO of
						?true ->
							List= get_day_rewards(Day,Lv),
							case bag_api:goods_set([get_rewards,[],<<"签到奖励">>], Player, Bag, List) of
								{?ok,Player2,NewBag,GoodsBin,LogBin} ->
									NewReward = #signreward{day=Day,is_get=?CONST_SIGN_OK},
									NewSignReward2 = [NewReward|LeaveReward],
									NewSign= #sign{num= Num, date= NowDate, signreward= NewSignReward2},
									stat_api:logs_sign(Uid, Num),
									role_api_dict:sign_set(NewSign),
									role_api_dict:bag_set(NewBag),
									BinMsg= msg_get_rewards_ok(Num),
									{?ok,Player2,<<BinMsg/binary,GoodsBin/binary,LogBin/binary>>};
								{?error,ErrorCode} ->
									{?error,ErrorCode}
							end;
						_->
							{?error,?ERROR_SIGN_RESIGN}
					end;
				_ ->
					{?error,?ERROR_SIGN_DAY}
			end
	end.

%% gives2goods(Gives) ->
%% 	Fun = fun(Give,AccGoods) ->
%% 				  ?MSG_ECHO("------------------~w~n",[Give]),
%% 				  case bag_api:goods(Give) of
%% 					  Goods when is_record(Goods,goods) ->
%% 						  ?MSG_ECHO("------------------~w~n",[Give]),
%% 						  [Goods|AccGoods];
%% 					  _ ->
%% 						  ?MSG_ECHO("------------------~w~n",[Give]),
%% 						  AccGoods
%% 				  end
%% 		  end,
%% 	lists:foldl(Fun, [], Gives).

get_day_rewards(Day, Lv) ->
	case data_sign:get(Day) of
		#d_sign{reward_1     = Reward1,
				count_1      = Coun1,
				reward_2     = Reward2,
				count_2      = Count2,
				reward_3     = Reward3,
				count_3      = Count3,
				reward_4     = Reward4,
				count_4      = Count4 }->
			List=[{Reward1,Coun1},{Reward2,Count2 * Lv * 2},{Reward3,Count3* Lv},{Reward4,Count4}],
			[R||R<-List,R=/={0,0}];
		_ ->
			[]
	end.

%% 每天登陆礼包领取情况信息
msg_reward_info(Day,IsGet)->
    app_msg:encode([{?int16u,Day},{?int8u,IsGet}]).

msg_get_rewards_ok(Day)->
    RsList = app_msg:encode([{?int16u,Day}]),
    app_msg:msg(?P_SIGN_GET_REWARDS_OK, RsList).
