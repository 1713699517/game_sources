%% Author: mirahs
%% Created: 2011-12-17
%% Description: TODO: Add description to fiend_api
-module(fiend_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([
		 decode_fiend/1,
		 encode_fiend/1,

		 init/1,
		 init/0,
		 login/0,
		 refresh/0,
		 logout/1,
		 
		 check_pass/1,
		 
		 check_in_fiend/1,
		 fresh_copy/2,
		 %chap_info/4,
		 chap_info_new/2,
		 chap_info_new/3,
		 
		 copy_state_change_cb/2,
		 chap_reward/2,
		 
		 require_info/1,
		 times_max_day/1,
		 
		 msg_chap_data/4,
		 msg_chap_data_new/4,
		 msg_fresh_back/2
		]).

%%
%% API Functions
%%
encode_fiend(FiendData) ->
	FiendData.

decode_fiend(FiendData) when is_record(FiendData,fiend) ->
	FiendData;
decode_fiend({fiend,BuyTimes,Date,ChapId,UseIds,Copys}) ->
	#fiend{date=Date,buy_times=BuyTimes,chap_id=ChapId,use_id=UseIds,copys=Copys};
decode_fiend({fiend,BuyTimes,Date,ChapId,UseIds,Copys,ChapReward}) ->
	#fiend{date=Date,buy_times=BuyTimes,chap_id=ChapId,use_id=UseIds,copys=Copys,chap_reward=ChapReward};
decode_fiend(_FiendData) ->
	init().

%% 角色初始魔王章节
%% arg:		
%% return:	#fiend{}
init(Player) ->
	Fiend = init(),
	{Player,Fiend}.

init() ->
	[ChapId|_] = data_copy_chap:gets_fiend(),
	#fiend{chap_id=ChapId,use_id=[]}.

login() ->
	Date = util:date(),
	ChapFiend = role_api_dict:fiend_get(),
	case ChapFiend#fiend.date of
		Date ->
			?skip;
		_ ->
			NewSave = login(ChapFiend#fiend.copys),
			NewChapFiend = ChapFiend#fiend{buy_times=0,date=Date,copys=NewSave,team_ids=[]},
			role_api_dict:fiend_set(NewChapFiend)
	end.

login(Saves) ->
	Fun = fun(Save,Acc) ->
				  [Save#fiendsave{times=0}|Acc]
		  end,
	lists:foldl(Fun, [], Saves).

refresh() ->
	login().

logout(Player) ->
	Player.

check_pass(IdList) ->
	?MSG_ECHO("======================~w~n",[IdList]),
	#fiend{copys=Saves} = role_api_dict:fiend_get(),
	PassIds = [Save#fiendsave.id || Save <- Saves,Save#fiendsave.is_pass =:= ?CONST_TRUE],
	?MSG_ECHO("======================~w~n",[Saves]),
	?MSG_ECHO("======================~w~n",[PassIds]),
	check_pass(IdList, PassIds, []).

check_pass([], _Saves, Acc) ->
	Acc;
check_pass([Id | Ids], Saves, Acc) ->
	case data_scene_copy:get(Id) of
		#d_copy{copy_type=?CONST_COPY_TYPE_FIEND} ->
			case lists:member(Id, Saves) of
				?true ->
					check_pass(Ids, Saves, [Id | Acc]);
				_ ->
					check_pass(Ids, Saves, Acc)
			end;
		_ ->
			check_pass(Ids, Saves, Acc)
	end.

%% 进入魔王副本检查
check_in_fiend(CopyId) ->
	#fiend{copys=Save} = role_api_dict:fiend_get(),
	case lists:keyfind(CopyId, #fiendsave.id, Save) of
		#fiendsave{times=Times,times_day=TimesDay} ->
			case TimesDay =:= 0 orelse Times < TimesDay of
				?true ->
					?ok;
				_ ->
					{?error, ?ERROR_COPY_COUNT_FULL}
			end;
		_ ->
			{?error, ?ERROR_COPY_NOT_COPY}
	end.

fresh_copy(#player{vip=Vip}=Player,CopyId) ->
	CanFreshTimes = vip_api:check_fun(Vip#vip.lv, #d_vip.fiend_times),
	case CanFreshTimes > 0 of
		?true ->
			ChapFiend = role_api_dict:fiend_get(),
			FreshTimes = ChapFiend#fiend.buy_times,
			NewTimes = FreshTimes + 1,
			case CanFreshTimes >= NewTimes of
				?true ->
					Rmb = get_fresh_rmb(NewTimes),
					case lists:keytake(CopyId, #fiendsave.id, ChapFiend#fiend.copys) of
						{value,#fiendsave{times=Ftimes,times_day=TimesDay}=CopyS,Tmp} ->
							case role_api:currency_cut([fresh_copy,[],<<"刷新魔王副本">>],Player,[{?CONST_CURRENCY_RMB,Rmb}]) of
								{?ok,Player1,CurMsg} ->
									NewFtimes = ?IF(Ftimes =< 0,0,Ftimes-1),
									NewSave = [CopyS#fiendsave{times=NewFtimes}|Tmp],
									role_api_dict:fiend_set(ChapFiend#fiend{buy_times=NewTimes,copys=NewSave}),
									BinMsg = msg_fresh_back(CopyId,TimesDay-NewFtimes),
									{?ok,Player1,<<CurMsg/binary,BinMsg/binary>>};
								{?error,ErrorCode} ->
									{?error,ErrorCode}
							end;
						_ ->
							{?error,?ERROR_COPY_NOT_COPY}
					end;
				_ ->
					{?error,?ERROR_FIEND_NO_FRESH_TIMES}
			end;
		_ ->
			{?error,?ERROR_FIEND_NOT_FRESH}
	end.

get_fresh_rmb(Times) ->
	NewTimes = ?IF(Times > ?CONST_COPY_MAX_FRESH_BUY_TIMES,?CONST_COPY_MAX_FRESH_BUY_TIMES,Times),
	case data_copy_times_pay:get(NewTimes) of
		Rmb when is_integer(Rmb) ->
			Rmb;
		_ ->
			2
	end.

%% 请求章节信息
%% chap_info(Lv,ChapId,Chaps,ChapFiend) ->
%% 	NewChapFiend=check_new_fiend(ChapFiend,Chaps),
%% 	NowChap	= ?IF(ChapId =:= 0,ChapFiend#fiend.chap_id,ChapId),
%% 	?MSG_ECHO("---------------~w~n",[{NowChap,Chaps}]),
%% 	% #d_fiend{next_chap_id=Next,copy_id=Copys} = data_fiend:get_chap(NowChap),
%% 	#d_copy_chap{next_chap_id=Next,copy_id=Copys} = data_copy_chap:get(?CONST_COPY_TYPE_FIEND, NowChap),
%% 	NextChap= next_chap_status(NewChapFiend#fiend.use_id,NowChap,Next,Chaps),
%% 	{ResultS,NewSave} = get_battle_status(NowChap,Lv,Copys,NewChapFiend#fiend.copys),
%% 	{NowChap,NextChap,ResultS,NewChapFiend#fiend{chap_id=NowChap,copys=NewSave}}.

%% 找出全部通过的章节
check_new_fiend(#fiend{copys=FiendSave}=ChapFiend,Chaps) ->
	case FiendSave of
		[] ->
			ChapFiend;
		_ ->
			Fun =  fun(ChapId,Acc) ->
						   case data_copy_chap:get(?CONST_COPY_TYPE_FIEND, ChapId) of
							   #d_copy_chap{copy_id=Ids} ->
								   Fun1	= fun(Id,Acc1) ->
												  case lists:keyfind(Id, #fiendsave.id, FiendSave) of
													  #fiendsave{is_pass=?CONST_TRUE} ->
														  [Id | Acc1];
													  _ ->
														  Acc1
												  end
										  end,
								   NewIds = lists:foldl(Fun1, [], Ids),
								   case length(NewIds) >= length(Ids) of
									   ?true ->
										   [ChapId | Acc];
									   _ ->
										   Acc
								   end;
							   _ ->
								   Acc
						   end
				   end,
			Use	= lists:foldl(Fun, [], Chaps),
			ChapFiend#fiend{use_id=Use}
	end.

%% 检查下一个章节是否能够进入
next_chap_status(UseChap,NowChap,Next,Chaps,Lv) ->
	case lists:member(NowChap, UseChap) andalso lists:member(Next, Chaps) of
		?true ->
			case data_copy_chap:get(?CONST_COPY_TYPE_FIEND, Next) of
				#d_copy_chap{chap_lv=NextChapLv} when Lv >= NextChapLv ->
					?CONST_TRUE;
				_ ->
					?CONST_FALSE
			end;
		_ ->
			?CONST_FALSE
	end.

%% 得到当前章节能够进入的副本
get_battle_status(ChapId,Lv,Ids,Save) ->
	?MSG_ECHO("----------------------~w~n",[{ChapId,Lv,Ids}]),
	ChapCopys= [FiendS || FiendS <- Save,FiendS#fiendsave.belongid =:= ChapId],
	MyChap = chap_copys(ChapCopys,ChapId,Ids,Lv),
	FunS = fun(HeroTmpS=#fiendsave{id=HeroId},AccS) ->
				   case lists:keytake(HeroId,#fiendsave.id,AccS) of
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
								  case lists:keytake(Id,#fiendsave.id,Acc) of
									  {value,SaveT,Tmp} ->
										  TimesDay = times_max_day(KeyId),
										  [SaveT#fiendsave{keyid=KeyId,times_day=TimesDay} | Tmp];
									  _ ->
										  case copy_api:check_add_copy(Dlv,PreId,TaskId,Lv,?CONST_COPY_TYPE_FIEND,Acc) of
											  ?true ->
												  TimesDay = times_max_day(KeyId),
												  Fsave = #fiendsave{id=Id,keyid=KeyId,belongid=BelongId,times_day=TimesDay},
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

chap_reward(#player{socket=Socket}=Player,ChapId) ->
	case chap_reward_acc(Player,ChapId) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			Player2;
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			Player
	end.

chap_reward_acc(Player,ChapId) ->
	Fiend = role_api_dict:fiend_get(),
	case lists:member(ChapId, Fiend#fiend.chap_reward) of
		?true ->
			{?error,?ERROR_COPY_ALREWARD_CHAP};
		?false ->
			case data_copy_chap:get(?CONST_COPY_TYPE_FIEND, ChapId) of
				#d_copy_chap{copy_id=Ids,chap_reward=Goods} ->
					case chap_reward_check(Fiend#fiend.copys, Ids) of
						?true ->
							Bag = role_api_dict:bag_get(),
							case bag_api:goods_set([chap_reward_acc,[],<<"副本章节奖励">>],Player,Bag,Goods) of
								{?ok,Player1,Bag1,GoodsBin,BinTmp} ->
									role_api_dict:bag_set(Bag1),
									NewFiend = Fiend#fiend{chap_reward=[ChapId|Fiend#fiend.chap_reward]},
									role_api_dict:fiend_set(NewFiend),
									BinReward = copy_api:msg_chap_reward_rep(?CONST_TRUE),
									{?ok, Player1,<<GoodsBin/binary,BinTmp/binary,BinReward/binary>>};
								{?error,ErrorCode} ->
									{?error,ErrorCode}
							end;
						?false ->
							{?error,?ERROR_COPY_CHAP_INALLS}
					end;
				_ ->
					{?error,?ERROR_COPY_NOT_COPY_DATA}
			end
	end.

chap_reward_check(_Copys, []) ->
	?true;
chap_reward_check(Copys,[Id|Ids]) ->
	case lists:keyfind(Id, #fiendsave.id, Copys) of
		#fiendsave{evaluation=Eva} when Eva >= ?CONST_COPY_EVA_A ->
			chap_reward_check(Copys,Ids);
		_ ->
			?false
	end.

%% 请求章节信息(无指定章节)
chap_info_new(Lv,Vip) ->
	ChapFiend1 = role_api_dict:fiend_get(),
	Dchaps	= data_copy_chap:gets_fiend(),
	ChapFiend=check_new_fiend(ChapFiend1,Dchaps),
	ChapId	= chap_info_chap(ChapFiend),
	case chap_info_nowchap(ChapFiend,ChapId,Lv) of
		{?ok,NowChap} ->
			chap_info_new(ChapFiend,Lv,Vip,NowChap,Dchaps);
		{?error,ErrorCode} ->
			{?error,ErrorCode}
	end.

%% 请求章节信息(指定章节)
chap_info_new(NowChap,Lv,Vip) ->
	ChapFiend1 = role_api_dict:fiend_get(),
	Dchaps	= data_copy_chap:gets_fiend(),
	ChapFiend=check_new_fiend(ChapFiend1,Dchaps),
	case lists:member(NowChap, Dchaps) of
		?true ->
			chap_info_new(ChapFiend,Lv,Vip,NowChap,Dchaps);
		_ ->
			{?error,?ERROR_HERO_NO_CHAP}
	end.

chap_info_new(ChapFiend,Lv,Vip,NowChap,Dchaps) ->
	case data_copy_chap:get(?CONST_COPY_TYPE_FIEND, NowChap) of
		#d_copy_chap{next_chap_id=Next,copy_id=Copys} ->
			NextStatus= next_chap_status(ChapFiend#fiend.use_id,NowChap,Next,Dchaps,Lv),
			{ResultS,NewSave} = get_battle_status(NowChap,Lv,Copys,ChapFiend#fiend.copys),
			NewChapFiend = ChapFiend#fiend{chap_id=NowChap,copys=NewSave},
			VipFreshTimes = vip_api:check_fun(Vip#vip.lv, #d_vip.fiend_times),
			FreeTimes = VipFreshTimes-NewChapFiend#fiend.buy_times,
			FreshTimes = ?IF(FreeTimes>0,FreeTimes,0),
			role_api_dict:fiend_set(NewChapFiend),
			BinMsg = msg_chap_data_new(NowChap,NextStatus,FreshTimes,ResultS),
			BinReward = copy_api:chap_reward_req(NowChap,ChapFiend#fiend.chap_reward),
			{?ok,<<BinMsg/binary,BinReward/binary>>};
		_ ->
			?MSG_ERROR("=====Normal Copy Chap ~w No Data~n",[NowChap]),
			{?error,?ERROR_UNKNOWN}
	end.

chap_info_chap(#fiend{use_id=[],chap_id=ChapId}) ->
	ChapId;
chap_info_chap(#fiend{use_id=UseIds1}) ->
	UseIds = lists:sort(UseIds1),
	lists:last(UseIds).

chap_info_nowchap(#fiend{copys=Copys},ChapId,Lv) ->
	case data_copy_chap:get(?CONST_COPY_TYPE_FIEND,ChapId) of
		#d_copy_chap{next_chap_id=0} ->
			{?ok,ChapId};
		#d_copy_chap{copy_id=Ids,next_chap_id=NextChapId} ->
			case chap_info_check_chap_pass(Copys,Ids) of
				?true ->
					case data_copy_chap:get(?CONST_COPY_TYPE_FIEND,NextChapId) of
						#d_copy_chap{chap_lv=ChapLv} when Lv >= ChapLv ->
							{?ok,NextChapId};
						_ ->
							{?ok,ChapId}
					end;
				_ ->
					{?ok,ChapId}
			end;
		_ ->
			?MSG_ERROR("=====Normal Copy Chap ~w No Data~n",[ChapId]),
			{?error,?ERROR_UNKNOWN}
	end.

chap_info_check_chap_pass(_Copys, []) ->
	?true;
chap_info_check_chap_pass(Copys,[Id|Ids]) ->
	case lists:keyfind(Id, #fiendsave.id, Copys) of
		#fiendsave{is_pass=?CONST_TRUE} ->
			chap_info_check_chap_pass(Copys,Ids);
		_ ->
			?false
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
copy_state_change_cb(#player{uid=Uid,uname=Name,uname_color=NameColor,lv=Lv,pro=Pro}=Player,{CopyId,Eva}) ->
	ChapFiend = role_api_dict:fiend_get(),
	#fiend{copys=Save,team_ids=TeamIds} = ChapFiend,
	case lists:keytake(CopyId, #fiendsave.id, Save) of
		{value,FiendS=#fiendsave{times=Times,evaluation=OldEva},Tmp} ->
			NewEva = ?IF(Eva > OldEva, Eva, OldEva),
			NewSave = [FiendS#fiendsave{is_pass=?CONST_TRUE,times=Times+1,evaluation=NewEva}|Tmp],
			role_api_dict:fiend_set(ChapFiend#fiend{copys=NewSave});
		_ ->
			case lists:member(CopyId, TeamIds) of
				?true ->
					?skip;
				_ ->
					NewTeamIds = [CopyId|TeamIds],
					role_api_dict:fiend_set(ChapFiend#fiend{team_ids=NewTeamIds})
			end
	end,
	BinMsg = broadcast_api:msg_broadcast_frend({Uid,Name,Lv,NameColor,Pro},CopyId),
	chat_api:send_to_all(BinMsg),
	active_api:check_link(Player#player.uid,102),
	card_api:sales_notice(Player),
	Player.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 副本需求查询
require_info(CopyId) ->
	case data_scene_copy:get(CopyId) of
		#d_copy{lv=Lv,lv_max=LvMax,times_max_day=TimesMaxDay} ->
			{Lv,LvMax,TimesMaxDay};
		_ ->
			{0,0,0}
	end.

%% 每天免费进入次数
times_max_day(KeyId) ->
	case data_scene_copy:get(KeyId) of
		#d_copy{times_max_day=TimesMaxDay} ->
			TimesMaxDay;
		_ ->
			0
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 章节信息 [46210]
msg_chap_data(Chap,NextChap,FreshTimes,MyChap) ->
	Fun = fun(#fiendsave{id=CopyId,times=Times,times_day=TimesDay,is_pass=IsPass},AccBin) ->
				  MsgList	= app_msg:encode([{?int16u,CopyId},{?int16u,TimesDay-Times},{?int8u,IsPass}]),
				  <<AccBin/binary,MsgList/binary>>
		  end,
	MsgList	= lists:foldl(Fun, app_msg:encode([{?int16u,Chap},{?int8u,NextChap},{?int16u,FreshTimes},{?int16u,length(MyChap)}]), MyChap),
	app_msg:msg(?P_FIEND_CHAP_DATA, MsgList).

msg_chap_data_new(Chap,NextChap,FreshTimes,MyChap) ->
	Fun = fun(#fiendsave{id=CopyId,times=Times,times_day=TimesDay,is_pass=IsPass,evaluation=Eva},AccBin) ->
				  MsgList	= app_msg:encode([{?int16u,CopyId},{?int16u,TimesDay-Times},{?int8u,IsPass},{?int8u,Eva}]),
				  <<AccBin/binary,MsgList/binary>>
		  end,
	MsgList	= lists:foldl(Fun, app_msg:encode([{?int16u,Chap},{?int8u,NextChap},{?int16u,FreshTimes},{?int16u,length(MyChap)}]), MyChap),
	app_msg:msg(?P_FIEND_CHAP_DATA_NEW, MsgList).

msg_fresh_back(CopyId,Times) ->
	BinData = app_msg:encode([{?int16u,CopyId},{?int16u,Times}]),
	app_msg:msg(?P_FIEND_FRESH_BACK, BinData).