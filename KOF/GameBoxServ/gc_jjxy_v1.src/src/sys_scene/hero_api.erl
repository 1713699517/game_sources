%% Author: mirahs
%% Created: 2011-12-17
%% Description: TODO: Add description to hero_api
-module(hero_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([
		 decode_hero/1,
		 encode_hero/1,
		 init/1,
		 init/0,
		 
		 login/0,
		 refresh/0,
		 logout/1,
		 
		 check_pass/1,
		 
		 check_in_hero/1,
		 buy_times/2,
		 fcm_goods/2,
		 %chap_info/4,
		 chap_info_new/2,
		 chap_info_new/3,
		 
		 copy_state_change_cb/2,
		 chap_reward/2,
		 
		 require_info/1,
		 times_max_day/1,
		 
		 msg_chap_data/6,
		 msg_chap_data_new/6,
		 msg_back_times/1
		]).

%%
%% API Functions
%%
encode_hero(HeroData) ->
	HeroData.

decode_hero(HeroData) when is_record(HeroData,hero) ->
	HeroData;
decode_hero({hero,Date,Times,BuyTimes,Default,ChapId,UseIds,Copys}) ->
	#hero{date=Date,times=Times,buy_times=BuyTimes,default=Default,chap_id=ChapId,use_id=UseIds,copys=Copys};
decode_hero(_HeroData) ->
	init().

%% 角色初始英雄章节
%% arg:		
%% return:	#hero{}
init(Player) ->
	Hero = init(),
	{Player,Hero}.

init() ->
	Date = util:date(),
	[ChapId|_] = data_copy_chap:gets_hero(),
	#hero{date=Date,times=1,chap_id=ChapId,use_id=[]}.

login() ->
	Hero = role_api_dict:hero_get(),
	#hero{copys=Save} = Hero,
	NewHero = login_check(Hero,Save),
	role_api_dict:hero_set(NewHero).

login_check(Hero,Save) ->
	Date = util:date(),
	if Hero#hero.default =:= ?true ->
		   Hero;
	   Hero#hero.date =:= Date ->
		   Hero;
	   ?true ->
		   Times = login_check_times(Save),
		   ?MSG_ECHO("-================~w~n",[Times]),
		   Hero#hero{date=Date,times=Times,buy_times=0}
	end.

login_check_times(Saves) ->
	PassCopy = [Save || Save <- Saves, Save#herosave.is_pass =:= ?CONST_TRUE],
	length(PassCopy).

refresh() ->
	login().

logout(Player) ->
	Player.

check_pass(IdList) ->
	#hero{copys=Saves} = role_api_dict:hero_get(),
	PassIds = [Save#herosave.id || Save <- Saves,Save#herosave.is_pass =:= ?CONST_TRUE],
	check_pass(IdList, PassIds, []).

check_pass([], _Saves, Acc) ->
	Acc;
check_pass([Id | Ids], Saves, Acc) ->
	case data_scene_copy:get(Id) of
		#d_copy{copy_type=?CONST_COPY_TYPE_HERO} ->
			case lists:member(Id, Saves) of
				?true ->
					check_pass(Ids, Saves, [Id | Acc]);
				_ ->
					check_pass(Ids, Saves, Acc)
			end;
		_ ->
			check_pass(Ids, Saves, Acc)
	end.

%% 进入英雄副本检查
check_in_hero(CopyId) ->
	#hero{times=Times,copys=Save} = role_api_dict:hero_get(),
	case Times > 0 of
		?true ->
			case lists:keyfind(CopyId, #herosave.id, Save) of
				#herosave{} ->
					?ok;
				_ ->
					{?error,?ERROR_COPY_NOT_COPY}
			end;
		_ ->
			{?error, ?ERROR_COPY_COUNT_FULL}
	end.

buy_times(#player{vip=Vip}=Player,Times) ->
	CanBuyTimes = vip_api:check_fun(Vip#vip.lv, #d_vip.tran_buy),
	case CanBuyTimes > 0 of
		?true ->
			Hero = role_api_dict:hero_get(),
			BuyTimes = Hero#hero.buy_times,
			NewTimes = BuyTimes + Times,
			case CanBuyTimes >= NewTimes of
				?true ->
					Rmb = get_buy_rmb(BuyTimes+1,Times,0),
					case role_api:currency_cut([buy_times,[],<<"购买英雄副本次数">>],Player,[{?CONST_CURRENCY_RMB,Rmb}]) of
						{?ok,Player1,CurMsg} ->
							NewWarTimes = Hero#hero.times + Times,
							role_api_dict:hero_set(Hero#hero{buy_times=NewTimes,times=NewWarTimes}),
							BinMsg = msg_back_times(NewWarTimes),
							{?ok,Player1,<<CurMsg/binary,BinMsg/binary>>};
						{?error,ErrorCode} ->
							{?error,ErrorCode}
					end;
				_ ->
					{?error,?ERROR_HERO_NO_BUY_TIMES}
			end;
		_ ->
			{?error,?ERROR_HERO_NOT_BUY}
	end.

get_buy_rmb(_BuyTimes,0,TotalRmb) ->
	TotalRmb;
get_buy_rmb(BuyTimes,Times,TotalRmb) ->
	NewBuyTimes = ?IF(BuyTimes > ?CONST_COPY_MAX_FRESH_BUY_TIMES,?CONST_COPY_MAX_FRESH_BUY_TIMES,BuyTimes),
	GetRmb =
		case data_copy_times_pay:get(NewBuyTimes) of
			Rmb when is_integer(Rmb) ->
				Rmb;
			_ ->
				2
		end,
	get_buy_rmb(BuyTimes+1,Times-1,TotalRmb+GetRmb).

%% 请求取经之路章节信息
%% chap_info(Lv,ChapId,Chaps,ChapHero) ->
%% 	NewChapHero=check_new_hero(ChapHero,Chaps),
%% 	NowChap	= ?IF(ChapId =:= 0,ChapHero#hero.chap_id,ChapId),
%% 	?MSG_ECHO("---------------~w~n",[{NowChap,Chaps}]),
%% 	#d_copy_chap{next_chap_id=Next,copy_id=Copys} = data_copy_chap:get(?CONST_COPY_TYPE_HERO, NowChap),
%% 	NextChap= next_chap_status(NewChapHero#hero.use_id,NowChap,Next,Chaps),
%% 	{ResultS,NewSave} = get_battle_status(NowChap,Lv,Copys,NewChapHero#hero.copys),
%% 	{NowChap,NextChap,ResultS,NewChapHero#hero{chap_id=NowChap,copys=NewSave}}.

%% 找出全部通过的章节
check_new_hero(#hero{copys=HeroSave}=ChapHero,Chaps) ->
	case HeroSave of
		[] ->
			ChapHero;
		_ ->
			Fun =  fun(ChapId,Acc) ->
						   case data_copy_chap:get(?CONST_COPY_TYPE_HERO, ChapId) of
							   #d_copy_chap{copy_id=Ids} ->
								   Fun1	= fun(Id,Acc1) ->
												  case lists:keyfind(Id, #herosave.id, HeroSave) of
													  #herosave{is_pass=?CONST_TRUE} ->
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
			ChapHero#hero{use_id=Use}
	end.

%% 检查下一个章节是否能够进入
next_chap_status(UseChap,NowChap,Next,Chaps,Lv) ->
	case lists:member(NowChap, UseChap) andalso lists:member(Next, Chaps) of
		?true ->
			case data_copy_chap:get(?CONST_COPY_TYPE_HERO, Next) of
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
	ChapCopys= [HeroS || HeroS <- Save,HeroS#herosave.belongid =:= ChapId],
	MyChap = chap_copys(ChapCopys,ChapId,Ids,Lv),
	FunS = fun(HeroTmpS=#herosave{id=HeroId},AccS) ->
				   case lists:keytake(HeroId,#herosave.id,AccS) of
					   {value,_,Tmpxx} ->
						   [HeroTmpS | Tmpxx];
					   _ ->
						   [HeroTmpS | AccS]
				   end;
			  (_,AccS) ->
				   AccS
		   end,  
	NewSave	= lists:foldl(FunS, Save, MyChap),
	{MyChap,NewSave}.

chap_copys(Copys,ChapId,Ids,Lv) ->
	Fun = fun(Id,Acc) ->
				  case data_scene_copy:get(Id) of
					  #d_copy{copy_id=Id,key_id=KeyId,task_id=TaskId,pre_copy_id=PreId,lv=Dlv,belong_id=BelongId} ->
						  case BelongId of
							  ChapId ->
								  case lists:keytake(Id,#herosave.id,Acc) of
									  {value,SaveT,Tmp} ->
										  [SaveT#herosave{keyid=KeyId} | Tmp];
									  _ ->
										  case copy_api:check_add_copy(Dlv,PreId,TaskId,Lv,?CONST_COPY_TYPE_HERO,Acc) of
											  ?true ->
												  Fsave = #herosave{id=Id,keyid=KeyId,belongid=BelongId},
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
	Hero = role_api_dict:hero_get(),
	case lists:member(ChapId, Hero#hero.chap_reward) of
		?true ->
			{?error,?ERROR_COPY_ALREWARD_CHAP};
		?false ->
			case data_copy_chap:get(?CONST_COPY_TYPE_HERO, ChapId) of
				#d_copy_chap{copy_id=Ids,chap_reward=Goods} ->
					case chap_reward_check(Hero#hero.copys, Ids) of
						?true ->
							Bag = role_api_dict:bag_get(),
							case bag_api:goods_set([chap_reward_acc,[],<<"副本章节奖励">>],Player,Bag,Goods) of
								{?ok,Player1,Bag1,GoodsBin,BinTmp} ->
									role_api_dict:bag_set(Bag1),
									NewHero = Hero#hero{chap_reward=[ChapId|Hero#hero.chap_reward]},
									role_api_dict:hero_set(NewHero),
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
	case lists:keyfind(Id, #herosave.id, Copys) of
		#herosave{evaluation=Eva} when Eva >= ?CONST_COPY_EVA_A ->
			chap_reward_check(Copys,Ids);
		_ ->
			?false
	end.


%% 请求章节信息(无指定章节)
chap_info_new(Lv,Vip) ->
	ChapHero1 = role_api_dict:hero_get(),
	Dchaps	= data_copy_chap:gets_hero(),
	ChapHero=check_new_hero(ChapHero1,Dchaps),
	ChapId	= chap_info_chap(ChapHero),
	case chap_info_nowchap(ChapHero,ChapId,Lv) of
		{?ok,NowChap} ->
			chap_info_new(ChapHero,Lv,Vip,NowChap,Dchaps);
		{?error,ErrorCode} ->
			{?error,ErrorCode}
	end.

%% 请求章节信息(指定章节)
chap_info_new(NowChap,Lv,Vip) ->
	ChapHero1 = role_api_dict:hero_get(),
	Dchaps	= data_copy_chap:gets_hero(),
	ChapHero=check_new_hero(ChapHero1,Dchaps),
	case lists:member(NowChap, Dchaps) of
		?true ->
			chap_info_new(ChapHero,Lv,Vip,NowChap,Dchaps);
		_ ->
			{?error,?ERROR_HERO_NO_CHAP}
	end.

chap_info_new(ChapHero,Lv,Vip,NowChap,Dchaps) ->
	case data_copy_chap:get(?CONST_COPY_TYPE_HERO, NowChap) of
		#d_copy_chap{next_chap_id=Next,copy_id=Copys} ->
			NextStatus= next_chap_status(ChapHero#hero.use_id,NowChap,Next,Dchaps,Lv),
			{ResultS,NewSave} = get_battle_status(NowChap,Lv,Copys,ChapHero#hero.copys),
			NewChapHero = ChapHero#hero{chap_id=NowChap,copys=NewSave},
			CanBuyTimes = vip_api:check_fun(Vip#vip.lv, #d_vip.tran_buy),
			AlBuyTimes = ChapHero#hero.buy_times,
			FreeBuyTimes1 = CanBuyTimes - AlBuyTimes,
			FreeBuyTimes = ?IF(FreeBuyTimes1 > 0, FreeBuyTimes1, 0),
			?MSG_ECHO("---------------=============~w~n",[{Vip#vip.lv,CanBuyTimes,AlBuyTimes,FreeBuyTimes}]),
			role_api_dict:hero_set(NewChapHero),
			BinMsg	= msg_chap_data_new(NowChap,NextStatus,NewChapHero#hero.times,AlBuyTimes,FreeBuyTimes,ResultS),
			BinReward = copy_api:chap_reward_req(NowChap,ChapHero#hero.chap_reward),
			{?ok,<<BinMsg/binary,BinReward/binary>>};
		_ ->
			?MSG_ERROR("=====Normal Copy Chap ~w No Data~n",[NowChap]),
			{?error,?ERROR_UNKNOWN}
	end.

chap_info_chap(#hero{use_id=[],chap_id=ChapId}) ->
	ChapId;
chap_info_chap(#hero{use_id=UseIds1}) ->
	UseIds = lists:sort(UseIds1),
	lists:last(UseIds).

chap_info_nowchap(#hero{copys=Copys},ChapId,Lv) ->
	case data_copy_chap:get(?CONST_COPY_TYPE_HERO,ChapId) of
		#d_copy_chap{next_chap_id=0} ->
			{?ok,ChapId};
		#d_copy_chap{copy_id=Ids,next_chap_id=NextChapId} ->
			case chap_info_check_chap_pass(Copys,Ids) of
				?true ->
					case data_copy_chap:get(?CONST_COPY_TYPE_HERO,NextChapId) of
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
	case lists:keyfind(Id, #herosave.id, Copys) of
		#herosave{is_pass=?CONST_TRUE} ->
			chap_info_check_chap_pass(Copys,Ids);
		_ ->
			?false
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
copy_state_change_cb(#player{uid=Uid,uname=Name,uname_color=NameColor,lv=Lv,pro=Pro}=Player,{CopyId,Eva}) ->
	Hero = role_api_dict:hero_get(),
	Save = Hero#hero.copys,
	case lists:keytake(CopyId, #herosave.id, Save) of
		{value,#herosave{is_pass=?CONST_TRUE,evaluation=OldEva} = HeroS,Tmp} ->
			Times	= Hero#hero.times, 
			NewTimes= ?IF(Times > 0,Times - 1, 0),
			NewEva = ?IF(Eva > OldEva, Eva, OldEva),
			NewSave = [HeroS#herosave{is_pass=?CONST_TRUE,evaluation=NewEva}|Tmp],
			role_api_dict:hero_set(Hero#hero{times=NewTimes,copys=NewSave});
		{value,#herosave{is_pass=?CONST_FALSE} = HeroS,Tmp} ->
			NewSave = [HeroS#herosave{is_pass=?CONST_TRUE,evaluation=Eva}|Tmp],
			case Hero#hero.default of
				?true ->
					role_api_dict:hero_set(Hero#hero{default=?false,copys=NewSave});
				_ ->
					role_api_dict:hero_set(Hero#hero{copys=NewSave})
			end;
		_ ->
			Times	= Hero#hero.times, 
			NewTimes= ?IF(Times > 0,Times - 1, 0),
			role_api_dict:hero_set(Hero#hero{times=NewTimes})
	end,
	BinMsg = broadcast_api:msg_broadcast_hero({Uid,Name,Lv,NameColor,Pro},CopyId),
	chat_api:send_to_all(BinMsg),
	active_api:check_link(Player#player.uid,103),
	card_api:sales_notice(Player),
	Player.

fcm_goods(_,Goods) ->
	Goods.
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
%% 章节信息 [39010]
msg_chap_data(Chap,NextChap,Times,AlBuyTimes,FreeBuyTimes,MyChap) ->
	Fun = fun(#herosave{id=CopyId,is_pass=IsPass},AccBin) ->
				  MsgList	= app_msg:encode([{?int16u,CopyId},{?int8u,IsPass}]),
				  <<AccBin/binary,MsgList/binary>>
		  end,
	Bin1 = app_msg:encode([{?int16u,Chap},{?int8u,NextChap},{?int16u,Times},{?int16u,AlBuyTimes},
						   {?int16u,FreeBuyTimes},{?int16u,length(MyChap)}]),
	MsgList	= lists:foldl(Fun, Bin1, MyChap),
	app_msg:msg(?P_HERO_CHAP_DATA, MsgList).

msg_chap_data_new(Chap,NextChap,Times,AlBuyTimes,FreeBuyTimes,MyChap) ->
	?MSG_ECHO("==================~w~n",[{Times,AlBuyTimes,FreeBuyTimes}]),
	Fun = fun(#herosave{id=CopyId,is_pass=IsPass,evaluation=Eva},AccBin) ->
				  MsgList	= app_msg:encode([{?int16u,CopyId},{?int8u,IsPass},{?int8u,Eva}]),
				  <<AccBin/binary,MsgList/binary>>
		  end,
	Bin1 = app_msg:encode([{?int16u,Chap},{?int8u,NextChap},{?int16u,Times},{?int16u,AlBuyTimes},
						   {?int16u,FreeBuyTimes},{?int16u,length(MyChap)}]),
	MsgList	= lists:foldl(Fun, Bin1, MyChap),
	app_msg:msg(?P_HERO_CHAP_DATA_NEW, MsgList).

msg_back_times(Times) ->
	BinData = app_msg:encode([{?int16u,Times}]),
	app_msg:msg(?P_HERO_BACK_TIMES, BinData).