%% Author: tanwer
%% Created: 2013-06-26
%% Description: TODO: Add description to clan_api
-module(clan_active_api).

%%
%% Include files
%%
-include("../include/comm.hrl"). 


%%
%% Exported Functions
%% 

-export([
		 
		 encode_clan_cat/1,
		 decode_clan_cat/1,
		 init_clan_cat/1,
		 % Api
		 % local_fun
		 ask_clan_active/2,
		 ask_cat_data/1,
		 start_clan_cat/3,
		 start_strength/2,
		 enter_copy/1,
		 cat_uplv/1,
		 state/1,
		 
		 
		 get_cat4clanid/1,
		 cat_all_time/1,
		 get_cat_data/0,
		 
		 
		 % local_mod
		 cat_hudong_handl/4,
		 cat_hudong_acc/2,
		 
		 %%　帮派活动消息
		 msg_active_msg/5,
		 msg_ok_active_data/1,
		 msg_ok_water_data/7,
		 msg_ok_strength/0,
		 msg_now_stamina/1
		
		]).

encode_clan_cat(ClanCat) -> ClanCat.
	
decode_clan_cat(ClanCat) when is_record(ClanCat, clan_cat) -> ClanCat;
decode_clan_cat(_ClanCat) -> #clan_cat{}.

init_clan_cat(Player) ->
	ClanCatData=
		case role_api_dict:clan_cat_get() of
			ClanCat when is_record(ClanCat, clan_cat) ->
				?IF(ClanCat#clan_cat.date =:= util:date(), 
					ClanCat, 
					ClanCat#clan_cat{date=util:date(),get_lv=1,rmb_times=0,gold_times=0});
			_ ->
				#clan_cat{}
		end,
	{Player,ClanCatData}. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Api

%% 请求活动面板
ask_clan_active(Uid,VipLv) ->
	Clan=role_api_dict:clan_get(),
	#clan{stamina=Stamina,clan_id=ClanId}=Clan,
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId,devote_sum=Devote_Sum} ->
			case clan_mod:get_clan4id(ClanId) of
				#clan_public{clan_lv=ClanLv} ->
					ActiveList=clan_active_data(Uid, VipLv,ClanLv, []),
					BinMsg1	= msg_now_stamina(Devote_Sum-Stamina),
					BinMsg2	= msg_ok_active_data(ActiveList),
					{?ok, <<BinMsg1/binary,BinMsg2/binary>>};
				_ ->
					{?error,?ERROR_CLAN_NULL1}
			end;		
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end.

%% 帮派活动数据返回
%% reg		: {ClanLv,VipLv}::{帮派等级，VIP等级}
%%			  [{活动ID,	 帮派限制等级,	已完成次数,总次数,	 开启状态}|_]
%% retrun	: [{ActiveId,LimiteClanlv,Times,AllTimes,State}|_] ::　
clan_active_data(Uid,VipLv,ClanLv,Acc) -> 
	Clan = role_api_dict:clan_get(),
	#clan{clan_id=ClanId} = Clan,
	CatData	= get_cat(ClanId,ClanLv),
	Acc2	= ?IF(CatData =:= [], Acc,[CatData|Acc]),
%% 	ClanBoss= clan_boss_api:clan_boss_state(ClanId, ClanLv),
%% 	Acc3	= [ClanBoss|Acc2],
	[CopyData,_CopyId]=get_copy(Clan),
	Acc4	= [CopyData|Acc2],
	Acc4.

%% 活动控制开关
state(_ActyId) -> 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 活动 1--招财猫

%% 请求招财猫面板
%% reg: {error,ErrorCode} | {ok,BinMsg}
ask_cat_data(Uid) ->
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId,devote_sum=DevoteSum} ->
			#clan{stamina=Stamina}=role_api_dict:clan_get(),
			#clan_cat{gold_times=GoldTimes,rmb_times=RmbTimes,get_lv=GetLv,get_day=GetDay}=get_cat_data(),
			case get_cat4clanid(ClanId) of
				#clan_cat_data{cat_exp=Exp,cat_upexp=UpExp,cat_logs=Logs,cat_lv=CatLv} ->
					AllTimes= cat_all_time(ClanId),
					BinMsg= msg_ok_water_data(DevoteSum-Stamina,GoldTimes+RmbTimes,AllTimes, Exp, UpExp, 
											  ?IF(GetLv>=CatLv,0,1)+GetDay, [Log||{Log,_Time} <- Logs]),
					{?ok,BinMsg};
				_ ->
					{?error,?ERROR_CLAN_NULL1}
			end;
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end.

%% 请求开始互动
start_clan_cat(Player,1,TypeAct) -> 
	#player{uid=Uid,uname=Name,uname_color=NameColor}=Player,
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId} ->
			RoleCat=get_cat_data(),
			#clan_cat{gold_times=GoldTimes,rmb_times=RmbTimes}=RoleCat,
			AllTimes=cat_all_time(ClanId),
			case RmbTimes + GoldTimes >= AllTimes of
				?true ->
					{?error,?ERROR_CLAN_NO_TIMES};
				_ ->
					case get_water_cast(?CONST_CLAN_ACTIVE_CAT,TypeAct) of
						{?error,ErrorCode} ->
							{?error,ErrorCode};
						{?ok,CastValue,[{_,Add}=GetValue,{_YQSExp,AddExp}]} ->
							LogSrc=[start_clan_cat, Add, <<"帮派招财猫互动">>],
							case role_api:currency_cut(LogSrc, Player, CastValue) of
								{?ok, Player2, Bin1} ->
									clan_srv:cat_hudong_cast({Name,NameColor,TypeAct},Uid,ClanId,AddExp),
									{Player3, Bin2}=role_api:currency_add(LogSrc, Player2, [GetValue]),
									RoleCat2 =
										case CastValue of
											[{1,_}] -> 
												RoleCat#clan_cat{gold_times=GoldTimes+1};
											[{2,_}] ->
												RoleCat#clan_cat{rmb_times=RmbTimes+1}
										end,
									role_api_dict:clan_cat_set(RoleCat2),
									{?ok,Player3,<<Bin1/binary,Bin2/binary>>};
								{?error, ErrorCode} ->
									{?error, ErrorCode}
							end
					end
			end;
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end;
%% 请求开始摇钱
start_clan_cat(#player{uid=Uid}=Player,2,_TypeAct) -> 
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{clan_id=ClanId} ->
			RoleCat=get_cat_data(),
			#clan_cat{get_lv=GetLv,get_day=GetDay}=RoleCat,
			case get_cat4clanid(ClanId) of
				#clan_cat_data{cat_lv=CatLv} ->
					case GetDay of
						T when T > 0 ->
							#d_clan_yqs_lv{rewards=Rewards}=data_clan_yqs_lv:get(CatLv),
							Reward=util:odds_list_count(Rewards,1),
							LogSrc=[start_clan_cat, [], <<"帮派招财">>],
							case bag_api:goods_set(LogSrc, Player, Reward) of
								{?ok, Player2,GoodsBin,Bin} ->
									role_api_dict:clan_cat_set(RoleCat#clan_cat{get_day=GetDay-1}),
									{?ok, Player2,<<GoodsBin/binary,Bin/binary>>};
								{?error, ErrorCode} ->
									{?error, ErrorCode}
							end;
						_ ->
							if CatLv > GetLv ->
								   #d_clan_yqs_lv{rewards=Rewards}=data_clan_yqs_lv:get(CatLv),
								   Reward=util:odds_list_count(Rewards,1),
								   LogSrc=[start_clan_cat, [], <<"帮派招财">>],
								   case bag_api:goods_set(LogSrc, Player, Reward) of
									   {?ok, Player2,GoodsBin,Bin} ->
										   role_api_dict:clan_cat_set(RoleCat#clan_cat{get_lv=CatLv}),
										   {?ok, Player2, <<GoodsBin/binary,Bin/binary>>};
									   {?error, ErrorCode} ->
										   {?error, ErrorCode}
								   end;
							   ?true ->
								   {?error, ?ERROR_CLAN_YQSNO_UPLV}
							end
					end;
				_ ->
					{?error,?ERROR_CLAN_NULL1}
			end;
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end;
start_clan_cat(_Player,_Type,_TypeAct) -> {?error,?ERROR_BADARG}.

%% 互动结果返回
cat_hudong_handl(Log,Uid,ClanId,AddExp) ->
	case clan_mod:get_clan4id(ClanId) of
		#clan_public{clan_lv=ClanLv} ->
			case get_cat4clanid(ClanId) of
				#clan_cat_data{cat_logs=CatLogs,cat_exp=CatExp}=ClanCat ->
					CatLogs2 = lists:keysort(2, [{Log,util:seconds()}|CatLogs]),
					CatLogs3 = lists:sublist(lists:reverse(CatLogs2), ?CONST_CLAN_EVENT_COUNT_MAX),
					{CatLv,_NowExp,UpExp} = cat_uplv(CatExp+AddExp),
					ClanCat2=
						case CatLv > ClanLv of
							?true ->
								#d_clan_yqs_lv{yqs_exp_up=ExpUp1}=data_clan_yqs_lv:get(ClanLv),
								ClanCat#clan_cat_data{cat_exp=ExpUp1-1,cat_logs=CatLogs3,cat_lv=ClanLv,cat_upexp=ExpUp1};
							_ ->
								ClanCat#clan_cat_data{cat_exp=CatExp+AddExp,cat_logs=CatLogs3,cat_lv=CatLv,cat_upexp=UpExp}
						end,
					new_clan_active(ClanCat2),
					util:pid_send(Uid, ?MODULE, cat_hudong_acc, ?null);
				_ ->
					ok
			end;
		_ ->
			ok
	end.

cat_hudong_acc(Player,_) ->
	case ask_cat_data(Player#player.uid) of
		{?ok,BinMsg} ->
			?ok;
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode)
	end,
	app_msg:send(Player#player.socket, BinMsg),
	Player.
			
	
%% ----------------------------------------------------------------------------------活动 2-- 帮派副本
%%　clan_active_api:enter_copy(Uid) -> CopyId| {?error,?ERROR}.
enter_copy(Uid) ->
	Clan = role_api_dict:clan_get(),
	[{_ActiveId,_LimiteClanlv,Times,AllTimes,State},CopyId]=get_copy(Clan),
	case State of
		1 ->
			case AllTimes - Times of
				N when N >=0 ->
					role_api_dict:clan_set(Clan#clan{clan_copy=[Times+1,util:date()]}),
					{?ok,CopyId};
				_ ->
					{?error,?ERROR_CLAN_NO_TIMES} %% 副本次数不足
			end;
		_ ->
			{?error,?ERROR_CLAN_CLANCOPY_LV_LOW} %% 未开放
	end.
	
%%　{AllTimes,CopyId}　＝　	
get_copy_all_times(ClanId) ->
	case clan_mod:get_clan4id(ClanId) of
		#clan_public{clan_lv=ClanLv} ->
			case data_clan_level:get(ClanLv) of
				#d_clan{copy_times=AllTimes,copy_id=CopyId} ->
					{AllTimes,CopyId};
				_ ->
					{?error,?ERROR_CLAN_NULL1}
			end;
		_ ->
			{?error,?ERROR_CLAN_NULL1}
	end.


%　{ActiveId,LimiteClanlv,Times,AllTimes,State}
get_copy(Clan) ->
	#clan{clan_copy=ClanCopy,clan_id=ClanId} = Clan,
	case get_copy_all_times(ClanId) of
		{?error,_ErrorCode} ->
			[{?CONST_CLAN_ACTIVE_COPY,?CONST_CLAN_COPY_LV,0,0,0},0];
		{AllTimes,CopyId} ->
			Now = util:date(),
			Times = case ClanCopy of
						[T,D] when D=:=Now -> T;
						_ ->
							role_api_dict:clan_set(Clan#clan{clan_copy=[0,Now]}),
							0
					end,
			State = 
				case state(?CONST_CLAN_ACTIVE_COPY) of
					0 -> 0;
					_ ->
						case AllTimes =:= Times of
							?true ->
								2;
							_ ->
								?IF(AllTimes < 1,0,1)
						end
				end,
			[{?CONST_CLAN_ACTIVE_COPY,?CONST_CLAN_COPY_LV,Times,AllTimes,State},CopyId]
	end.

%% -----------------------------------------------------------------------------------活动 3-- 体能训练						
%% 请求开始体能训练
start_strength(#player{vip=Vip}=Player,Type) ->
	case data_clan_active_cast:get(?CONST_CLAN_ACTIVE_TRAIN) of
		?null ->
			{?error,?ERROR_CLAN_NOT_START};
		Typedate ->
			case lists:keyfind(Type, 1, Typedate) of
				{Type,VipLv,CastVG,GetVG} ->
					if Vip#vip.lv >= VipLv ->
						   LogSrc = [start_strength,[],<<"体能训练">>],
						   case role_api:currency_cut(LogSrc, Player, CastVG) of
							   {ok, Player2, BinCast} ->
								   {Player3, BinGet}=role_api:currency_add(LogSrc, Player2, GetVG),
								   BinMsg=msg_ok_strength(),
								   {?ok,Player3,<<BinCast/binary,BinGet/binary,BinMsg/binary>>};
							   {error, ErrorCode} ->
								   {error, ErrorCode}
						   end;
					   ?true ->
						   {?error,?ERROR_VIP_LV_LACK}
					end;
				_ ->
					{?error,?ERROR_BADARG}
			end
	end.

						   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% local_mod

%% 取招财猫可互动总次数
%%　clan_active_api:cat_all_time(70002)
cat_all_time(ClanId) -> 
	case get_cat4clanid(ClanId) of
		#clan_cat_data{cat_lv=CatLv} -> ?MSG_ECHO("-------~w~n",[CatLv]),
			case data_clan_yqs_lv:get(CatLv) of
				#d_clan_yqs_lv{times=AllTimes} ->
					AllTimes;
				_ ->
					0
			end;
		_ ->
			0
	end.

	
%% 取出招财猫数据
get_cat_data() ->
	Cat=role_api_dict:clan_cat_get(),
	#clan_cat{date=Date}=Cat,
	Now=util:date(),
	case Now=:=Date of
		?true -> Cat;
		_ ->
			Cat2=Cat#clan_cat{date=Now, rmb_times=0,gold_times=0,get_day = ?CONST_CLAN_CAT_TIMES},
			role_api_dict:clan_cat_set(Cat2),
			Cat2
	end.

%%　通过帮派Id查找帮招财猫活动信息
%% return: ClanCat || ?null
get_cat4clanid(ClanId) ->
	case ets:lookup(?ETS_CLAN_CAT, ClanId) of
		[#clan_cat_data{}=ClanCat|_] ->
			ClanCat;
		_ ->
			Sql = "SELECT `clan_id`,`cat_exp` FROM `clan_cat_data` where `clan_id` = " ++ util:to_list(ClanId),
			case mysql_api:select(Sql) of
				{?ok, [[ClanId,CatExp]|_]} ->
					{CatLv,_NowExp,UpExp}=cat_uplv(CatExp),
					ClanCat = #clan_cat_data{cat_exp=CatExp,cat_logs=[],cat_lv=CatLv,cat_upexp=UpExp,clan_id=ClanId},
					ets:insert(?ETS_CLAN_CAT, ClanCat),
					ClanCat;
				{?ok,[]} -> 
					#d_clan_yqs_lv{yqs_exp=UpExp} = data_clan_yqs_lv:get(1),
					ClanCat = #clan_cat_data{clan_id=ClanId,cat_upexp=UpExp},
					new_clan_active(ClanCat),
					ClanCat;
				_ ->
					?null
			end
	end.

%% 新建|更新活动信息
new_clan_active(ClanCat) ->
	#clan_cat_data{clan_id=ClanId,cat_exp=CatExp,cat_lv=CatLv} = ClanCat,
	SQL	= <<"REPLACE INTO `clan_cat_data` (`clan_id`,`cat_lv`,`cat_exp`) VALUES ",
			 "('", ?B(ClanId),  "','", ?B(CatLv),  "','", ?B(CatExp), "');">>,
	mysql_api:fetch_cast(SQL),
	ets:insert(?ETS_CLAN_CAT, ClanCat).

	
%%　摇钱树升级	
%% {Lv2,NowExp,UpExp}
cat_uplv(YqsExp) -> 
	#d_clan_yqs_lv{yqs_exp_up=Up} = data_clan_yqs_lv:get(1),
	cat_uplv(YqsExp,0,0,Up).
cat_uplv(YqsExp,Lv,Up,Up2) ->
	case data_clan_yqs_lv:get(Lv+1) of
		#d_clan_yqs_lv{yqs_exp=NowExp,yqs_exp_up=UpExp} when UpExp=/=0 ->
			if YqsExp>=UpExp ->
				   cat_uplv(YqsExp,Lv+1,NowExp,UpExp);
			   YqsExp>=NowExp ->
				   {Lv+1,NowExp,UpExp};
			   ?true ->
				   {1,0,Up}
			end;
		_ ->
			{lists:max(data_clan_yqs_lv:get_list()),Up2,0} 
	end.

%% 消费
%%　{TypeAct,Vip,CastValue,GetValue}
%%　{?ok,CastValue,GetValue}|| {?error,?ERROR_VIP_LV_LACK}
get_water_cast(ActiveId,TypeAct) ->
	CastList = data_clan_active_cast:get(ActiveId),
	case lists:keyfind(TypeAct, 1, CastList) of
		{TypeAct,CastValue,GetValue} ->
			{?ok,CastValue,GetValue};
		R ->?MSG_ECHO("_____________________________________R:~w~n",[R]),
			{?error,?ERROR_BADARG}
	end.

%% 招财猫活动状态数据
get_cat(ClanId,ClanLv) ->
	#clan_cat{gold_times=GoldTimes,rmb_times=RmbTimes}=get_cat_data(),
	AllTimes= cat_all_time(ClanId),
	State= 
		case state(?CONST_CLAN_ACTIVE_CAT) of
			0 -> 0;
			_ -> ?IF(ClanLv >= ?CONST_CLAN_CLAN_LV_LIMIT,1,0)
		end,
	{?CONST_CLAN_ACTIVE_CAT,?CONST_CLAN_CLAN_LV_LIMIT,GoldTimes+RmbTimes,AllTimes,State}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---Msg----%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 玩家现有体能值 [33305]
msg_now_stamina(Stamina)->
    RsList = app_msg:encode([{?int32u,Stamina}]),
    app_msg:msg(?P_CLAN_NOW_STAMINA, RsList).

% 返回活动面板数据 [33310]
msg_ok_active_data(ActiveData)->
	Rs	  = app_msg:encode([{?int16u,length(ActiveData)}]),
	F=fun({ActiveId,LimiteClanlv,Times,AllTimes,State},Acc) ->
			  Bin = app_msg:encode([{?int16u,ActiveId},
									{?int8u,LimiteClanlv},{?int8u,Times},
									{?int8u,AllTimes},{?int8u,State}]),
			  <<Acc/binary,Bin/binary>>
	  end,
	RsList= lists:foldl(F,Rs, ActiveData),
	app_msg:msg(?P_CLAN_OK_ACTIVE_DATA, RsList).

% 帮派活动数据块 [33315]
msg_active_msg(ActiveId,LimiteClanlv,Times,AllTimes,State)->
    RsList = app_msg:encode([{?int16u,ActiveId},
        {?int8u,LimiteClanlv},{?int8u,Times},
        {?int8u,AllTimes},{?int8u,State}]),
    app_msg:msg(?P_CLAN_ACTIVE_MSG, RsList).


% 返回浇水面板数据 [33330]
msg_ok_water_data(Stamina,WaterTimes,AllTimes,YqsExp,UpExp,YqTimes,WaterLogs)->
	Rs	= app_msg:encode([{?int32u,Stamina},
							 {?int8u,WaterTimes},{?int8u,AllTimes},
							 {?int32u,YqsExp},{?int32u,UpExp},
							 {?int8u,YqTimes},
							 {?int16u,length(WaterLogs)}]),
	RsList = lists:foldl(fun({Name,NameColor,Type},Acc) -> 
								 Bin = app_msg:encode([{?string,Name},{?int8u,NameColor},{?int8u,Type}]),
								 <<Acc/binary,Bin/binary>>
						 end, Rs, WaterLogs),
	app_msg:msg(?P_CLAN_OK_WATER_DATA, RsList).


% 训练成功 [33370]
msg_ok_strength()->
    app_msg:msg(?P_CLAN_OK_STRENGTH,<<>>).