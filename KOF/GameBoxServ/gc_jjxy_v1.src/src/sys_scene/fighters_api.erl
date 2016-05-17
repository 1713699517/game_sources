%% Author: mirahs
%% Created: 2011-12-17
%% Description: TODO: Add description to fiend_api
-module(fighters_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([
		 decode_fighters/1,
		 encode_fighters/1,

		 init/1,
		 init/0,
		 login/0,
		 refresh/0,
		 logout/1,
		 
		 copy_state_change_cb/2,
		 
		 check_in_fighters/1,
		 wartimes_add/1,
		 buy_times/2,
		 up_start/1,
		 up_stop/1,
		 up_reset/1,
		 
		 chap_info/4,
		 
		 msg_chap_data/7,
		 msg_buy_times_ok/1,
		 msg_up_reply/6,
		 msg_up_over/0,
		 msg_up_reset_ok/5
		]).

%%
%% API Functions
%%
encode_fighters(FightersData) ->
	FightersData.

decode_fighters(FightersData) when is_record(FightersData,fighters) ->
	FightersData;
decode_fighters({fighters,Date,WarTimes,BuyTimes,ResetTimes,UpDate,UpIs,UpChapId,UpCopyId,UpAfter,ChapId,UseId,PassInfo,Copys}) ->
	#fighters{date=Date,war_times=WarTimes,buy_times=BuyTimes,reset_times=ResetTimes,up_date=UpDate,up_is=UpIs,
			   up_chap_id=UpChapId,up_copy_id=UpCopyId,up_after=UpAfter,chap_id=ChapId,use_id=UseId,pass_info=PassInfo,copys=Copys};
decode_fighters(_FightersData) ->
	init().

%% 角色初始魔王章节
%% arg:		
%% return:	#fighters{}
init(Player) ->
	Fighters= init(),
	{Player,Fighters}.

init() ->
	[ChapId|_] = data_copy_chap:gets_fighters(),
	Date = util:date(),
	#fighters{chap_id=ChapId,date=Date,up_date=Date,up_is=?CONST_FIGHTERS_UPNO}.

login() ->
	Date = util:date(),
	ChapFighters = role_api_dict:fighters_get(),
	case ChapFighters#fighters.date of
		Date ->
			?skip;
		_ ->
			NewChapFighters = ChapFighters#fighters{buy_times=0,war_times=0,reset_times=0,date=Date,is_free_re=?CONST_TRUE},
			role_api_dict:fighters_set(NewChapFighters)
	end.

refresh() ->
	login().

logout(Player) ->
	Player.

%% 进入拳皇生涯检查
check_in_fighters(TeamId) ->
	case TeamId of
		0 ->
			#fighters{war_times=WarTimes} = role_api_dict:fighters_get(),
			case WarTimes < ?CONST_FIGHTERS_CHALLENGE_TIMES of
				?true ->
					?ok;
				_ ->
					{?error, ?ERROR_FIGHTERS_NO_WARTIMES}
			end;
		_ ->
			{?error,?ERROR_UNKNOWN}
	end.

wartimes_add(Uid) ->
	ChapFighters = role_api_dict:fighters_get(),
	WarTimes = ChapFighters#fighters.war_times + 1,
	active_api:check_link(Uid,?CONST_ACTIVITY_LINK_110),
	role_api_dict:fighters_set(ChapFighters#fighters{war_times=WarTimes}).

buy_times(Player,Times) ->
	ChapFighters = role_api_dict:fighters_get(),
	NewBuyTimes = ChapFighters#fighters.buy_times + Times,
	?MSG_ECHO("----------------~w~n",[{ChapFighters#fighters.buy_times,NewBuyTimes}]),
	case ?CONST_FIGHTERS_TIMES_BUY_LIMIT >= NewBuyTimes of
		?true ->
			BuyRmb = ?CONST_FIGHTERS_TIMES_BUY_BASE + (NewBuyTimes - 1) * 2,
			case role_api:currency_cut([buy_times,[],<<"拳皇生涯购买挑战次数">>],Player,[{?CONST_CURRENCY_RMB,BuyRmb}]) of
				{?ok,Player1,CurMsg} ->
					WarTimes = ChapFighters#fighters.war_times - Times,
					?MSG_ECHO("----------------~w~n",[{ChapFighters#fighters.war_times,WarTimes}]),
					NewWarTimes = ?IF(WarTimes > 0,WarTimes,0),
					role_api_dict:fighters_set(ChapFighters#fighters{war_times=NewWarTimes,buy_times=NewBuyTimes}),
					BinMsg = msg_buy_times_ok(?CONST_FIGHTERS_CHALLENGE_TIMES - NewWarTimes),
					{?ok,Player1,<<CurMsg/binary,BinMsg/binary>>};
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		_ ->
			{?error,?ERROR_FIGHTERS_NO_BUYTIMES}
	end.

up_check_over(Fighters) ->
	case data_scene_copy:get(Fighters#fighters.up_copy_id) of
		#d_copy{next_copy_id=0} ->
			case data_copy_chap:get(?CONST_COPY_TYPE_FIGHTERS, Fighters#fighters.up_chap_id) of
				#d_copy_chap{next_chap_id=0} ->
					{?true,0,0};
				#d_copy_chap{next_chap_id=NextChapId} ->
					%?MSG_ECHO("-------------~w~n",[NextChapId]),
					case data_copy_chap:get(?CONST_COPY_TYPE_FIGHTERS, NextChapId) of
						#d_copy_chap{copy_id=[]} ->
							{?true,0,0};
						#d_copy_chap{copy_id=CopyIds} ->
							%?MSG_ECHO("-------------~w~n",[CopyIds]),
							[HeadCopyId|_] = CopyIds,
							%?MSG_ECHO("-------------~w~n",[Fighters#fighters.pass_info]),
							case lists:keyfind(NextChapId, 1, Fighters#fighters.pass_info) of
								{NextChapId,PassCopys} ->
									%?MSG_ECHO("-------------~w~n",[PassCopys]),
									case lists:member(HeadCopyId, PassCopys) of
										?true ->
											{?false,NextChapId,HeadCopyId};
										_ ->
											{?true,0,0}
									end;
								_ ->
									{?true,0,0}
							end;
						_ ->
							{?true,0,0}
					end;
				_ ->
					{?true,0,0}
			end;
		#d_copy{next_copy_id=NextCopyId} ->
			%?MSG_ECHO("-------------~w~n",[NextCopyId]),
			%?MSG_ECHO("-------------~w~n",[Fighters#fighters.pass_info]),
			case lists:keyfind(Fighters#fighters.up_chap_id,1,Fighters#fighters.pass_info) of
				{UpChapId,PassCopys} ->
					%?MSG_ECHO("-------------~w~n",[PassCopys]),
					case lists:member(NextCopyId, PassCopys) of
						?true ->
							{?false,UpChapId,NextCopyId};
						_ ->
							{?true,0,0}
					end;
				_ ->
					{?true,0,0}
			end;
		_ ->
			{?true,0,0}
	end.

up_start(#player{socket=Socket}=Player) ->
	Fighters = role_api_dict:fighters_get(),
	%?MSG_ECHO("----------------~w~n",[Fighters#fighters.up_is]),
	case Fighters#fighters.up_is of
		?CONST_FIGHTERS_UPNO ->
			[ChapId|_] = data_copy_chap:gets_fighters(),
			%?MSG_ECHO("----------------~w~n",[ChapId]),
			case lists:keyfind(ChapId,1,Fighters#fighters.pass_info) of
				{ChapId,[]} ->
					%?MSG_ECHO("----------------~w~n",[ChapId]),
					{?error,?ERROR_FIGHTERS_NO_UP_COPY};
				{ChapId,PassInfo} ->
					%?MSG_ECHO("----------------~w~n",[PassInfo]),
					case find_chap_first(ChapId,PassInfo) of
						?null ->
							%?MSG_ECHO("----------------~w~n",[ChapId]),
							{?error,?ERROR_FIGHTERS_NO_UP_COPY};
						FirstCopyId ->
							%?MSG_ECHO("----------------~w~n",[{ChapId, FirstCopyId}]),
							Fighters1 = Fighters#fighters{up_is=?CONST_FIGHTERS_UPING,up_chap_id=ChapId,up_copy_id=FirstCopyId,up_after=?true},
							{Player2,Exp,Gold,Power,Goods} = up_start_reward(Player,FirstCopyId),
							BinMsg = msg_up_reply(ChapId,FirstCopyId,Exp,Gold,Power,Goods),
							app_msg:send(Socket, BinMsg),
							case bag_api:check_bag() of
								?true ->
									Bin2 = msg_up_stop(),
									app_msg:send(Socket, Bin2),
									role_api_dict:fighters_set(Fighters1#fighters{up_after=?false});
								?false ->
									role_api_dict:fighters_set(Fighters1)
							end,
							{?ok,Player2}
						end;
				_ ->
					%?MSG_ECHO("----------------~w~n",[ChapId]),
					{?error,?ERROR_FIGHTERS_NO_UP_COPY}
			end;
		?CONST_FIGHTERS_UPING ->
			up_starting(Player,Fighters);
		?CONST_FIGHTERS_UPOVER ->
			{?error,?ERROR_FIGHTERS_PLEASE_RESET}
	end.

find_chap_first(ChapId,PassCopy) ->
	?MSG_ECHO("----------------~w~n",[{ChapId,PassCopy}]),
	case data_copy_chap:get(?CONST_COPY_TYPE_FIGHTERS, ChapId) of
		#d_copy_chap{copy_id=Ids} ->
			[FirstCopyId|_] = Ids,
			?MSG_ECHO("----------------~w~n",[Ids]),
			case lists:member(FirstCopyId, PassCopy) of
				?true ->
					FirstCopyId;
				_ ->
					?null
			end;
		_ ->
			?null
	end.

up_starting(#player{socket=Socket}=Player,Fighters) ->
	case up_check_over(Fighters) of
		{?true,_,_} ->
			Bin = msg_up_over(),
			app_msg:send(Socket, Bin),
			Fighters2 = Fighters#fighters{up_is=?CONST_FIGHTERS_UPOVER,up_chap_id=0,up_copy_id=0,up_after=?false},
			role_api_dict:fighters_set(Fighters2),
			{?ok,Player};
		{?false,NextChapId,NextCopyId} ->
			{Player2,Exp,Gold,Power,Goods} = up_start_reward(Player,NextCopyId),
			Bin1 = msg_up_reply(NextChapId,NextCopyId,Exp,Gold,Power,Goods),
			case bag_api:check_bag() of
				?false ->
					app_msg:send(Socket, Bin1),
					Fighters2 = Fighters#fighters{up_chap_id=NextChapId,up_copy_id=NextCopyId},
					role_api_dict:fighters_set(Fighters2);
				?true ->
					Bin2 = msg_up_stop(),
					app_msg:send(Socket, <<Bin1/binary,Bin2/binary>>),
					Fighters2 = Fighters#fighters{up_after=?false},
					role_api_dict:fighters_set(Fighters2)
			end,
			{?ok,Player2}
	end.

up_start_reward(Player,UpCopyId) ->
	{Exp,Gold,Power,Reward} = copy_api:get_copy_up_reward(UpCopyId, Player#player.vip),
	Goods = copy_mod:get_goods(Reward),
	%Player2	= role_api:exp_add(Player, Exp,up_start_reward,<<"拳皇生涯挂机奖励:",(util:to_binary(UpCopyId))/binary>>),
	{Player3,_Bin1} = role_api:currency_add([up_start_reward,[],<<"拳皇生涯挂机奖励">>],Player,[{?CONST_CURRENCY_EXP,Exp},{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_ADV_SKILL,Power}]),
	Bag = role_api_dict:bag_get(),
	case bag_api:goods_set([copy_over_update_cb,[],<<"拳皇生涯挂机奖励">>],Player3,Bag,Goods) of
		{?ok,Player4,Bag2,GoodsBin,_BinLog} ->
			role_api_dict:bag_set(Bag2),
			app_msg:send(Player#player.socket, GoodsBin),
			{Player4,Exp,Gold,Power,Goods};
		{?error,ErrorCode} ->
			BinMsg	= system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, BinMsg),
			{Player3,Exp,Gold,Power,[]}
	end.

up_stop(Socket) ->
	Fighters = role_api_dict:fighters_get(),
	Fighters2 = Fighters#fighters{up_after=?false},
	BinMsg = msg_up_stop(),
	app_msg:send(Socket, BinMsg),
	role_api_dict:fighters_set(Fighters2).

up_reset(#player{socket=Socket,vip=Vip}=Player) ->
	Fighters = role_api_dict:fighters_get(),
	case Fighters#fighters.up_is of
		?CONST_FIGHTERS_UPNO ->
			{?error,?ERROR_FIGHTERS_NO_UP_COPY};
		_ ->
			Date = util:date(),
			VipResetTimes = vip_api:check_fun(Vip#vip.lv, #d_vip.career_refresh),
			NewResetTimes = Fighters#fighters.reset_times + 1,
			case Fighters#fighters.is_free_re of
				?CONST_FALSE ->
					case NewResetTimes =< VipResetTimes of
						?true ->
							case data_copy_chap:get(?CONST_COPY_TYPE_FIGHTERS, Fighters#fighters.chap_id) of
								#d_copy_chap{reset_rmb=ResetRmb} ->
									case role_api:currency_cut([up_speed,[],<<"重置拳皇挂机">>],Player,[{?CONST_CURRENCY_RMB, ResetRmb}]) of
										{?ok,Player2,Bin1} ->
											NewFighters = Fighters#fighters{reset_times=NewResetTimes,up_date=Date,
																			up_after=?false,up_chap_id=0,up_copy_id=0,
																			up_is=?CONST_FIGHTERS_UPNO,
																			is_free_re=?CONST_FALSE},
											?MSG_ECHO("--------------------~w~n",[{VipResetTimes,NewResetTimes,NewFighters#fighters.is_free_re}]),
											Bin2 = msg_up_reset_ok(VipResetTimes - NewResetTimes,?CONST_FALSE,?CONST_FIGHTERS_UPNO,0,0),
											role_api_dict:fighters_set(NewFighters),
											app_msg:send(Socket, <<Bin1/binary,Bin2/binary>>),
											{?ok,Player2};
										{?error,ErrorCode} ->
											{?error,ErrorCode}
									end;
								_ ->
									{?error,?ERROR_FIGHTERS_NO_UP_COPY}
							end;
						_ ->
							{?error,?ERROR_FIGHTERS_NO_RESET_TIMES}
					end;
				_ ->
					NewFighters = Fighters#fighters{up_after=?false,up_chap_id=0,up_copy_id=0,up_date=Date,
													up_is=?CONST_FIGHTERS_UPNO,reset_times=0,is_free_re=?CONST_FALSE},
					role_api_dict:fighters_set(NewFighters),
					?MSG_ECHO("--------------------~w~n",[{VipResetTimes,NewResetTimes,NewFighters#fighters.is_free_re}]),
					BinMsg = msg_up_reset_ok(VipResetTimes,?CONST_FALSE,?CONST_FIGHTERS_UPNO,0,0),
					app_msg:send(Socket, BinMsg),
					{?ok,Player}
			end
	end.

%% 请求拳皇生涯章节信息
chap_info(Lv,ChapId,Chaps,ChapFighters) ->
	NewChapFighters=check_new_fighters(ChapFighters,Chaps),
	NowChap	= ?IF(ChapId =:= 0,ChapFighters#fighters.chap_id,ChapId),
	?MSG_ECHO("---------------~w~n",[{NowChap,Chaps}]),
	?MSG_ERROR("--------------~w~n",[{ChapId,NowChap}]),
	#d_copy_chap{next_chap_id=Next,copy_id=Copys} = data_copy_chap:get(?CONST_COPY_TYPE_FIGHTERS, NowChap),
	NextChap= next_chap_status(NewChapFighters#fighters.use_id,NowChap,Next,Chaps),
	{ResultS,NewSave} = get_battle_status(NowChap,Lv,Copys,NewChapFighters#fighters.copys),
	{NowChap,NextChap,ResultS,NewChapFighters#fighters{chap_id=NowChap,copys=NewSave},NewSave}.

%% 找出全部通过的章节
check_new_fighters(#fighters{copys=FightersSave}=ChapFighters,Chaps) ->
	case FightersSave of
		[] ->
			ChapFighters;
		_ ->
			Fun =  fun(ChapId,{Acc,AccTmp}) ->
						   case data_copy_chap:get(?CONST_COPY_TYPE_FIGHTERS, ChapId) of
							   #d_copy_chap{copy_id=Ids} ->
								   Fun1	= fun(Id,Acc1) ->
												  case lists:keyfind(Id, #figsave.id, FightersSave) of
													  #figsave{is_pass=?CONST_TRUE} ->
														  [Id | Acc1];
													  _ ->
														  Acc1
												  end
										  end,
								   NewIds = lists:foldl(Fun1, [], Ids),
								   case length(NewIds) >= length(Ids) of
									   ?true ->
										   {[ChapId | Acc],[{ChapId,NewIds}|AccTmp]};
									   _ ->
										   {Acc,[{ChapId,NewIds}|AccTmp]}
								   end;
							   _ ->
								   {Acc,AccTmp}
						   end
				   end,
			{Use,PassInfo}	= lists:foldl(Fun, {[],[]}, Chaps),
			ChapFighters#fighters{use_id=Use,pass_info=PassInfo}
	end.

%% 检查下一个章节是否能够进入
next_chap_status(UseChap,NowChap,Next,Chaps) ->
	case lists:member(NowChap, UseChap) andalso lists:member(Next, Chaps) of
		?true ->
			?CONST_TRUE;
		_ ->
			?CONST_FALSE
	end.

%% 得到当前章节能够进入的副本
get_battle_status(ChapId,Lv,Ids,Save) ->
	?MSG_ECHO("----------------------~w~n",[{ChapId,Lv,Ids}]),
	?MSG_ECHO("----------------------~w~n",[Save]),
	ChapCopys= [FightersS || FightersS <- Save,FightersS#figsave.belongid =:= ChapId],
	?MSG_ECHO("----------------------~w~n",[ChapCopys]),
	MyChap = chap_copys(ChapCopys,ChapId,Ids,Lv),
	?MSG_ECHO("----------------------~w~n",[MyChap]),
	FunS = fun(HeroTmpS=#figsave{id=FightersId},AccS) ->
				   case lists:keytake(FightersId,#figsave.id,AccS) of
					   {value,_,Tmpxx} ->
						   [HeroTmpS | Tmpxx];
					   _ ->
						   [HeroTmpS | AccS]
				   end
		   end,  
	NewSave	= lists:foldl(FunS, Save, MyChap),
	{MyChap,NewSave}.

chap_copys(Copys,ChapId,Ids,Lv) ->
	Fun = fun(Id,Acc) ->
				  case data_scene_copy:get(Id) of
					  #d_copy{copy_id=Id,key_id=KeyId,task_id=TaskId,pre_copy_id=PreId,lv=Dlv,belong_id=BelongId} ->
						  case BelongId of
							  ChapId ->
								  case lists:keytake(Id,#figsave.id,Acc) of
									  {value,SaveT,Tmp} ->
										  [SaveT#figsave{keyid=KeyId} | Tmp];
									  _ ->
										  case copy_api:check_add_copy(Dlv,PreId,TaskId,Lv,?CONST_COPY_TYPE_FIGHTERS,Acc) of
											  ?true ->
												  Fsave = #figsave{id=Id,keyid=KeyId,belongid=BelongId},
												  [Fsave|Acc];
											  _ ->
												  Acc
										  end
								  end;
							  _ ->
								  Acc
						  end;
					  _ ->
						  Acc
				  end
		  end,
	lists:foldl(Fun, Copys, Ids).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
copy_state_change_cb(#player{uid=Uid,uname=Name,uname_color=NameColor,lv=Lv,pro=Pro}=Player,CopyId) ->
	ChapFighters = role_api_dict:fighters_get(),
	#fighters{copys=Save} = ChapFighters,
	Save1 =
		case lists:keytake(CopyId,#figsave.id,Save) of
			{value,FigS,Tmp} ->
				[FigS#figsave{is_pass=?CONST_TRUE}|Tmp];
			_ ->
				Save
		end,
	role_api_dict:fighters_set(ChapFighters#fighters{copys=Save1}),
	BinMsg = broadcast_api:msg_broadcast_career({Uid,Name,Lv,NameColor,Pro},CopyId),
	chat_api:send_to_all(BinMsg),
	Player.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 章节信息 [46210]
msg_chap_data(Chap,NextChap,WarTimes,ResetTimes,#fighters{is_free_re=IsFreeRe,up_is=UpIs,reset_times=AlreTimes,buy_times=BuyTimes,up_chap_id=UpChapId,up_copy_id=UpCopyId},
			  _MyChap,Save) ->
	%?MSG_ECHO("---------------~w~n",[{Chap,NextChap,WarTimes,ResetTimes,UpIs,UpChapId,UpCopyId,IsFreeRe}]),
	%?MSG_ECHO("---------------~w~n",[BuyTimes]),
	%?MSG_ECHO("---------------~w~n",[Save]),
	Fun = fun(#figsave{id=CopyId,is_pass=IsPass},AccBin) ->
				  %?MSG_ECHO("---------------~w~n",[{CopyId,IsPass}]),
				  Fbin = app_msg:encode([{?int16u,CopyId},{?int8u,IsPass}]),
				  <<AccBin/binary,Fbin/binary>>
		  end,
	Bin1	= app_msg:encode([{?int16u,Chap},{?int8u,NextChap},{?int16u,WarTimes},{?int16u,ResetTimes},
							  {?int16u,BuyTimes},{?int16u,AlreTimes},{?int8u,IsFreeRe},{?int8u,UpIs},
							  {?int16u,UpChapId},{?int16u,UpCopyId},{?int16u,length(Save)}]),
	MsgList	= lists:foldl(Fun, Bin1, Save),
	app_msg:msg(?P_FIGHTERS_CHAP_DATA, MsgList).

msg_buy_times_ok(Times) ->
	BinData = app_msg:encode([{?int16u,Times}]),
	app_msg:msg(?P_FIGHTERS_BUY_OK, BinData).

msg_up_reply(ChapId,CopyId,Exp,Gold,Power,Goods) ->
	Bin1 = app_msg:encode([{?int16u,ChapId},{?int16u,CopyId},{?int32u,Exp},{?int32u,Gold},
						   {?int32u,Power},{?int16u,length(Goods)}]),
	Fun = fun({GoodsId,GoodsCount},AccBin) ->
				  Fbin = app_msg:encode([{?int16u,GoodsId},{?int16u,GoodsCount}]),
				  <<AccBin/binary,Fbin/binary>>
		  end,
	BinData = lists:foldl(Fun, Bin1, Goods),
	app_msg:msg(?P_FIGHTERS_UP_REPLY, BinData).

msg_up_over() ->
	app_msg:msg(?P_FIGHTERS_UP_OVER, <<>>).

msg_up_stop() ->
	app_msg:msg(?P_FIGHTERS_UP_STOP_REP, <<>>).

msg_up_reset_ok(ResetTimes,FreeResetTimes,UpState,UpChapId,UpCopyId) ->
	%?MSG_ECHO("------------------~w~n",[{ResetTimes,FreeResetTimes}]),
	BinData = app_msg:encode([{?int16u,ResetTimes},{?int16u,FreeResetTimes},{?int8u,UpState},{?int16u,UpChapId},{?int16u,UpCopyId}]),
	app_msg:msg(?P_FIGHTERS_UP_RESET_OK, BinData).