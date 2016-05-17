%% Author  : Kevin
%% Created: 2012-9-5
%% Description: TODO: Add description to role_mod
-module(arena_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


%%
%% Exported Functions
%%

-export([encode_arena/1,
		 decode_arena/1,
		 
		 init/1,
		 ets_day_player/2,
		 player_list/2,
		 arena_lv/0, 
		 arena_update_lv/2,
		 arena_update_lv_handle/2,
		 arena_update_powerful/2,
		 arena_update_powerful_handle/2,
		 arena_get_rank/1,
		 arena_reward_rank/2,
		 arena_exp/2,
		 rank_update_arena/1,
		 arena_join/1,
%% 		 arena_radio/1,
		 reward_day/0,
		 arena_reward_day/1,
		 arena_buy_count/2, 
		 arena_war_handle/3,
		 arena_war_updata_cb/2,
%% 		 rank_update_barena_cb/2,
		 arena_war_count/1,
		 maysql_arena/0,
		 arena_reward_times/0,
		 arena_sort/2,
		 arena_clean/1,
		 arena_get_rank/0,
		 
		 msg_reward_times/4,
		 msg_max_data/1,
		 msg_get_reward/4,
		 msg_war_reward/3,
		 msg_dekaron/4, 
		 msg_strat/0,
		 msg_get_reward/1,
		 msg_killer_data/3, 
		 msg_result2/1,
		 msg_buy_ok/1,
		 msg_war_data/1,
		 msg_ok/0]).

encode_arena(Arena) ->
	Arena.

decode_arena(Arena) ->
	DateYmd = util:date_Ymd(),
	Moil=moil_api:init(),
	case is_record(Arena,arena) of
		?true ->
			case is_record(Arena#arena.moil,moil) of
				?true->
					Arena;
				_->
%% 					ets:delete_all_objects(?ETS_ARENA),
					#arena{date=DateYmd,surplus=?CONST_ARENA_SURPLUS,moil=Moil}
			end;
		?false->
			#arena{date=DateYmd,surplus=?CONST_ARENA_SURPLUS,moil=Moil}
	end.

%% 封神台剩余挑战次数
arena_war_count(Arena)->
	Arena#arena.surplus.

arena_get_rank()->
	case role_api_dict:arena_get() of
		#arena{ranking=Rank}->
			Rank;
		_->0
	end.
						

%% 初始化
init(Player)->
	DateYmd = util:date_Ymd(),
	Moil=moil_api:init(),
	Arena = #arena{
				   date          = DateYmd,                   % 当前日期
				   surplus       = ?CONST_ARENA_SURPLUS,      % 剩余挑战次数
				   moil			 = Moil						  % 苦工
				  }, 
	{Player,Arena}.


%% 封神榜世界等级
arena_lv()->
	RnakDataList = ets:select(?ETS_ARENA, [{'$1',[{'=<',{element,2,'$1'},20}],['$1']}]),
	RnakDataList2=[RankData||RankData<-RnakDataList,is_record(RankData,rank_data)],
	Fun=fun(PRankData,Acc)->
				Acc+PRankData#rank_data.lv
		end,
	Sum=lists:foldl(Fun,0,RnakDataList2),
	round(Sum/20).

%% 升级更新逐鹿台信息
arena_update_lv(Uid,Lv)->
	arena_srv:arena_lv_cast(Uid,Lv).

arena_update_lv_handle(Uid,Lv)->
	case ets:select(ets_arena,[{'$1',[{'=:=',{element,3,'$1'},{const,Uid}}],['$1']}]) of
		[] ->?skip;
		[RnakData|_] ->
			RnakData2=RnakData#rank_data{lv=Lv},
			ets:insert(?ETS_ARENA,RnakData2)
	end.

%%更新战斗力
arena_update_powerful(Uid,Powerful)->
	arena_srv:arena_powerful_cast(Uid,Powerful).

arena_update_powerful_handle(Uid,Powerful)->
	case ets:select(ets_arena,[{'$1',[{'=:=',{element,3,'$1'},{const,Uid}}],['$1']}]) of
		[] ->?skip;
		[RnakData|_] ->
			RnakData2=RnakData#rank_data{power=Powerful},
			ets:insert(?ETS_ARENA,RnakData2)
	end.
	
arena_exp(Lv,Exp)->
	ArenaLv=arena_lv(),
	Exp2=round(Exp*?CONST_ARENA_WLV_EXP_ADD/?CONST_PERCENT),
	?IF(Lv=<ArenaLv,Exp+Exp2,Exp).
	
maysql_arena()->
	mysql_api:fetch("TRUNCATE TABLE `arena` "),
	ArenaList0 = ets:tab2list(?ETS_ARENA),
	Fun=fun(RankDate)->
				#rank_data{rank=Ranking,uid=Uid,name=Name,city=City,
						   sex=Sex, pro =Pro, lv =Lv, renown =Renown, 
						   win_count =WinCount, surplus = Surplus,power =Power}=RankDate,
				mysql_api:insert(arena,[{rank,Ranking},{uid,Uid},{sex,Sex},{pro,Pro},{name,Name},{lv,Lv},{renown,Renown},{country,City},
				{win_count,WinCount},{surplus,Surplus},{power,Power}])
		end,
	lists:map(Fun,ArenaList0).

%% 版本兼容排序
arena_sort(Uid,RankList)->
	RankList2=lists:keysort(#rank_data.rank,RankList),
	RankList3=arena_sort2(Uid,RankList2,[]),
	lists:sublist(RankList3,6).

arena_sort2(_Uid,[],Acc)->Acc;
arena_sort2(Uid,[RankData|RankList],Acc)->
	case length([RankData|Acc]) < 6 of
		?true->arena_sort2(Uid,RankList,[RankData|Acc]);
		_->
			case lists:keyfind(Uid,#rank_data.uid,Acc) of
				?false-> arena_sort2(Uid,RankList,[RankData|Acc]);
				_     -> [RankData|Acc]
			end
	end.

	

%% 取当前排名
arena_get_rank(Uid)->
	case ets:select(?ETS_ARENA, [{'$1',[{'=:=',{element,3,'$1'},{const,Uid}}],[{element,2,'$1'}]}]) of
		[]->0;
		[Rank|_]->Rank
	end.

%% 进入封神榜
arena_join(Player=#player{socket=Socket,lv=InfoLv,uid=Uid,info=Info})->
	if
		InfoLv < ?CONST_ARENA_YES_ARENA ->
			{?error, ?ERROR_ARENA_NO_ARENA};
		?true ->
			Arena=role_api_dict:arena_get(),
			Arena2=ets_day_player(Player,Arena),
			{Arena3,RankList}=player_list(Player,Arena2),  
			MapMsg		= msg_strat(),
			app_msg:send(Socket,MapMsg),
			Time			=util:seconds(),
			ArenaLv		=arena_lv(),
			Times		=?IF(?CONST_ARENA_LOSE_TIME*60-(Time-Arena#arena.time)=<0,0,?CONST_ARENA_LOSE_TIME*60-(Time-Arena#arena.time)),
			BinMsg3 		= msg_dekaron(ArenaLv,Times,Info#info.renown,RankList),
			Hearsays2=case ets:lookup(?ETS_ARENA_DATA,Uid) of
						  [{_Uid,Hearsays}|_] ->
							  Hearsays;
						  _->[]
					  end,
			BinMsg2			= msg_max_data(Hearsays2),
			
			app_msg:send(Socket,BinMsg2),
			app_msg:send(Socket,BinMsg3),
%% 			app_msg:send(Socket,<<BinMsg2/binary,BinMsg3/binary>>),
			role_api_dict:arena_set(Arena3)
	end.
	
player_list(#player{uid=Uid,uname=Name,lv=Lv,sex=Sex,pro=Pro,country=City,info=Info},Arena)->
	#info{renown=Renown,powerful=Power0}=Info,
	InnPowerful=inn_api:inn_powerful(),
	Power=Power0+InnPowerful,
	#arena{win_count=WinCount,surplus=Surplus}=Arena,
	case ets:select(?ETS_ARENA, [{'$1',[{'=:=',{element,3,'$1'},{const,Uid}}],['$1']}])  of
		[] ->
			ArenaData	= [Uid,Name,City,Sex,Pro,Lv,Renown,WinCount,Surplus,Power],
			Ranking		= 0;
		[ERankData|_] ->
			#rank_data{rank=NRanking,uid=NUid,name=Nname,win_count=NWinCount} = ERankData,
			Ranking			 = NRanking,
			ArenaData		 = [NUid,Nname,City,Sex,Pro,Lv,Renown,NWinCount,Surplus,Power]
	end,
	PlayerCount = ets:info(?ETS_ARENA,size),
	{Rank,RankDate}=player_list2(Uid,ArenaData,Ranking,PlayerCount),
	R=[LPower||#rank_data{power=LPower,uid=LUid}<-RankDate,LUid==Uid],
%% 	?MSG_ERROR("============== ~w~n",[{Uid,R}]),
	Arena2		   = Arena#arena{ranking=Rank},
	top_api:top_arena_updata([{Uid,Rank}]),
	{Arena2,RankDate}.

player_list2(Uid,ArenaData,_Rank,0)->
	[_NUid,Name,City,Sex,Pro,Lv,Renown,WinCount,Surplus,Power]=ArenaData,
	RankData = {rank_data,1,Uid,Name,City,Sex,Pro,Lv,Renown,WinCount,Surplus,Power},
	ets:insert(?ETS_ARENA, RankData),
	mysql_api:insert(arena,[{rank,1},{uid,Uid},{name,Name},{country,City},{sex,Sex},{pro,Pro},{lv,Lv},
								{renown,Renown},{win_count,WinCount},{surplus,Surplus},{power,Power}]),
	{1,[RankData]};

player_list2(Uid,ArenaData,0,PlayerCount) when PlayerCount>0 ->
	[Uid,Name,City,Sex,Pro,Lv,Renown,WinCount,Surplus,Power] = ArenaData,
	ets:insert(?ETS_ARENA,{rank_data,PlayerCount+1,Uid,Name,City,Sex,Pro,Lv,Renown,WinCount,Surplus,Power}),
	mysql_api:insert(arena,[{rank,PlayerCount+1},{uid,Uid},{name,Name},{country,City},{sex,Sex},{pro,Pro},{lv,Lv},
								{renown,Renown},{win_count,WinCount},{surplus,Surplus},{power,Power}]),
	player_list2(Uid,ArenaData,PlayerCount+1,PlayerCount+1);
 
player_list2(_Uid,ArenaData,Rank,_PlayerCount) ->
%% 	?CONST_ARENA_NUM
	{_WinRenown,_WinGold,_LoseRenown,_LoseGold,Space} = arena_reward_Integral(Rank),
	if
		Rank =< ?CONST_ARENA_SHOW_ROLE -> 
			RankList0 = lists:seq(1,?CONST_ARENA_SHOW_ROLE),
			RankList  = lists:delete(Rank, RankList0);
		?true ->
			RankList  = rank_list_space(Rank,Space,[])
	end,
	ArenaData2=list_to_tuple([rank_data,Rank|ArenaData]),
	Fun=fun(ARank,Acc)->
				case ets:lookup(?ETS_ARENA,ARank) of
					[]->Acc;
					[ARankData|_] ->
						[ARankData|Acc];
					_->Acc
				end
		end,
	ArenaDatas=lists:foldl(Fun, [], RankList),
	{Rank,[ArenaData2|ArenaDatas]}.


%% 排名列表 [1,2,3,...]
rank_list_space(Rank,Space,Acc)->
	case length(Acc) < ?CONST_ARENA_SHOW_ROLE-1 of 
		?true ->
			Rank2 = Rank - Space,
			if
				Rank2 > 0 -> 
					Acc2     = [Rank2|Acc],
					rank_list_space(Rank2,Space,Acc2);
				?true -> Acc
			end;			
		?false-> Acc
	end.
		
	
%% 
arena_broadcast(RoleData,WinCount2,{RdUid,RdName,Rlv,RdPro,RdWinCount},Flag)->
%% 	RNameColor=role_api:get_name_color(RdUid),
	RRoleData={RdUid,RdName,Rlv,RdPro,0},
	case Flag of
		?true->
			FBinMsg=broadcast_api:msg_broadcast_arena_one(RoleData,RRoleData),
			chat_api:send_to_all(FBinMsg);
		_->
			?skip
	end,
	if
		RdWinCount>=?CONST_ARENA_WIN_LINK_10 -> 
			BinMsg=broadcast_api:msg_broadcast_arena_s(RoleData,RRoleData,RdWinCount),
			chat_api:send_to_all(BinMsg);
		WinCount2=:=?CONST_ARENA_WIN_LINK_10 ->
			BinMsg=broadcast_api:msg_broadcast_arena_win_count(RoleData,WinCount2),
			chat_api:send_to_all(BinMsg);
		WinCount2=:=?CONST_ARENA_WIN_LINK_50 ->
			BinMsg=broadcast_api:msg_broadcast_arena_win_count(RoleData,WinCount2),
			chat_api:send_to_all(BinMsg);
		WinCount2=:=?CONST_ARENA_WIN_LINK_100 ->
			BinMsg=broadcast_api:msg_broadcast_arena_win_count(RoleData,WinCount2),
			chat_api:send_to_all(BinMsg);
		WinCount2=:=?CONST_ARENA_WIN_LINK_500 ->
			BinMsg=broadcast_api:msg_broadcast_arena_win_count(RoleData,WinCount2),
			chat_api:send_to_all(BinMsg);
		WinCount2=:=?CONST_ARENA_WIN_LINK_1000 ->
			BinMsg=broadcast_api:msg_broadcast_arena_win_count(RoleData,WinCount2),
			chat_api:send_to_all(BinMsg);
		?true->
			?skip
	end.


%% 开始挑战/登录刷新竞技场排名
rank_update_arena(Player = #player{uid = Uid})->
	Arena=role_api_dict:arena_get(),
%% 	[{'$1',[{'=:=',{element,3,'$1'},{const,9018}}],['$1']}]
	case ets:select(ets_arena,[{'$1',[{'=:=',{element,3,'$1'},{const,Uid}}],['$1']}]) of
		[] ->
			Player;
		[RnakData|_] ->
			case {RnakData#rank_data.rank,RnakData#rank_data.win_count} of
				{1,WinCount0} ->
					Ranking = 1,
					WinCount= WinCount0,
					IsFirst = ?CONST_TRUE;
				{Ranking0,WinCount0} ->
					Ranking = Ranking0,
					WinCount= WinCount0, 
					IsFirst = ?CONST_FALSE
			end,
			Arena2	= Arena#arena{ranking = Ranking,win_count = WinCount,is_first = IsFirst},
			role_api_dict:arena_set(Arena2),
			Player
	end.

%% %% 每天更新可挑战次数和时间
ets_day_player(#player{socket=Socket,uid=Uid,lv=InfoLv},Arena) ->
	RewardTime	 = arena_reward_times(),
	case ets:lookup(?ETS_ARENA_REWARD,Uid) of
		[{Uid,Rank,Lv}|_]->
			{Renown,Gold}=arena_reward_rank(Rank,Lv),
			BinMsg=msg_reward_times(?CONST_TRUE,RewardTime,Renown,Gold);
		_->
			{Renown,Gold}=arena_reward_rank(Arena#arena.ranking,InfoLv),
			BinMsg=msg_reward_times(?CONST_FALSE,RewardTime,Renown,Gold)
	end,
	app_msg:send(Socket, BinMsg),
	Date = util:date_Ymd(),
	#arena{date=ADate,moil=Moil}=Arena,
	if
		Date =/= ADate -> 
			Moil2=Moil#moil{ 		
							captrue_count		= ?CONST_MOIL_CAPTRUE_COUNT,% 抓捕次数
							active_count		= ?CONST_MOIL_ACTIVE_COUNT,	% 互动次数
							calls_count		    = ?CONST_MOIL_CALLS_COUNT,	% 求救次数	
							protest_count		= ?CONST_MOIL_PROTEST_COUNT,% 反抗次数
							expn				= 0,						% 今日获得经验
							buy_count			= ?CONST_MOIL_CATCH_MAX 	% 购买次数
						   },
			Arena#arena{date 	   = Date,
						time 	   = 0,
						surplus    = ?CONST_ARENA_SURPLUS,
						buy_count  = 0,
						moil       = Moil2 };
		?true -> Arena
	end.

%% 把挑战信息存入数据库
set_hearsay(Uid,BUid,Hearsay) ->
	mysql_update_hearsay_uid(Uid,Hearsay,[]),
	mysql_update_hearsay_uid(BUid,Hearsay,[]).

mysql_update_hearsay_uid(Uid,Hearsay,Acc) ->
	case ets:lookup(?ETS_ARENA_DATA, Uid) of
		[] ->
			ets:insert(?ETS_ARENA_DATA, {Uid,[Hearsay|Acc]}),
			{_,Datas} = util:db_encode([Hearsay|Acc]),
			mysql_api:fetch("REPLACE INTO arena_data (uid,datas) VALUES ("
						   ++util:to_list(Uid)++","++util:to_list(Datas)++");");
		[{_uid,DataS}] -> 
			DataS2 = [Hearsay|DataS],
			DataS3 = lists:sublist(DataS2, ?CONST_ARENA_NUM),
			ets:update_element(?ETS_ARENA_DATA, Uid, [{2,DataS3}]),
			{_,DataS4} =  util:db_encode(DataS3),
			mysql_api:fetch("REPLACE INTO arena_data (uid,sid,datas) VALUES ("
						   ++util:to_list(Uid)++","++util:to_list(DataS4)++");")
	end.


%% 每日奖励
reward_day()->
	mysql_api:select("TRUNCATE TABLE `sales_arena`"),
	RankDatas = ets:tab2list(?ETS_ARENA),
	IsStart=card_api:sales_arena(),
	Fun=fun(RankData)->
				case is_record(RankData,rank_data) of
					?true->
						#rank_data{uid=Uid,rank=Rank,lv=Lv}=RankData,
						case role_api:mpid(Uid) of
							Pid when is_pid(Pid) ->
								RewardTime	 = arena_reward_times(),
								{Renown,Gold}=arena_reward_rank(Rank,Lv),
								Bin = msg_reward_times(?CONST_TRUE,RewardTime,Renown,Gold),
								app_msg:send(Pid, Bin);
							_ ->
								?skip
						end,
						ets:insert(?ETS_ARENA_REWARD,{RankData#rank_data.uid,RankData#rank_data.rank,RankData#rank_data.lv}),
						mysql_api:update_insert(arena_reward,[{uid,Uid}],[{rank,Rank},{lv,Lv}]),
						if
							IsStart==?true andalso Rank =< 50 ->
								Sid=app_tool:sid(),
								mysql_api:update_insert(sales_arena,[{sid,Sid},{uid,Uid}],[{rank,Rank}]);
							?true->?skip
						end;
					_->?skip
				end
		end,
	lists:map(Fun,RankDatas).


%%开始挑战
arena_war_handle(#player{mpid=Mpid,uid=Uid,uname=Name,lv=Lv,uname_color=NameColor,
								country=City,sex=Sex,pro=Pro},Ranking,Result)->
	StartTime = util:seconds(),
	[RankData|_]=ets:lookup(?ETS_ARENA,Ranking),
	#rank_data{uid=RUid,name=RName,lv=Rlv,pro=RPro,win_count=RWinCount}=RankData,
	{WinRenown,WinGold,LoseRenown,LoseGold,_Pace}  = arena_reward_Integral(Ranking),
	PRankdata=case ets:select(?ETS_ARENA,[{'$1',[{'=:=',{element,3,'$1'},{const,Uid}}],['$1']}]) of
				  [PRankdata0|_]->PRankdata0;
				  _->
					  PlayerCount = ets:info(?ETS_ARENA,size)+1,
					  {rank_data,PlayerCount,Uid,Name,City,Sex,Pro,Lv,0,0,0,0}
			  end,
	#rank_data{rank=PRanking,win_count=PWinCount,surplus=PSurplus}=PRankdata,
	case Result of
		?CONST_TRUE -> 
			Hearsay  = {StartTime,?CONST_CHAT_JJC,0,Uid,Name,PRanking,RUid,RName,Ranking,?CONST_ARENA_STATA_1},
			case PRanking<Ranking of
				?true->
					PRankdata2=PRankdata#rank_data{lv=Lv,win_count=PWinCount+1},
					RankData2=RankData#rank_data{win_count=0},
					stat_api:logs_arena_rank(Uid,PRanking,PRanking,PSurplus),
					ets:insert(?ETS_ARENA,[PRankdata2,RankData2]);
				?false->
					PRankdata2=PRankdata#rank_data{rank=Ranking,lv=Lv,win_count=PWinCount+1},
					RankData2=RankData#rank_data{rank=PRanking,win_count=0},
					top_api:top_arena_updata([{Uid,Ranking},{RUid,PRanking}]),
					logs_api:action_notice(RUid,?CONST_LOGS_8002,[{Name,NameColor}],[PRanking]),
					stat_api:logs_arena_rank(Uid, PRanking, Ranking, PSurplus),
					ets:insert(?ETS_ARENA,[PRankdata2,RankData2])
			end,
%% 			BinMsg=war_api:msg_flop(?CONST_FALSE,0,0,0,1,WinGold,WinRenown,[]),
%% 			app_msg:send(Mpid,BinMsg),
			Falg=?IF(Ranking=:=1,?true,?false),
			RankRole={RUid,RName,Rlv,RPro,RWinCount},
			SelfRole={Uid,Name,Lv,NameColor,Pro},
			arena_broadcast(SelfRole,PWinCount+1,RankRole,Falg),
			LogSrc=[rank_update_win,[],<<"封神台挑战胜利">>],
			util:pid_send(Mpid,?MODULE, arena_war_updata_cb,{Result,LogSrc,WinRenown,WinGold,RUid,Ranking}),
			set_hearsay(Uid,RUid,Hearsay);
		?CONST_FALSE ->
			LogSrc=[rank_update_los,[],<<"封神台挑战失败">>],
			util:pid_send(Mpid,?MODULE, arena_war_updata_cb,{Result,LogSrc,LoseRenown,LoseGold,RUid,PRanking}),
			PRankdata2=PRankdata#rank_data{win_count=0},
			logs_api:action_notice(RUid,?CONST_LOGS_8001,[{Name,NameColor}],[]),
			stat_api:logs_arena_rank(Uid,PRanking,PRanking,PSurplus),
			ets:insert(?ETS_ARENA,PRankdata2),
			Hearsay  = {StartTime,?CONST_CHAT_JJC,0,Uid,Name,PRanking,RUid,RName,Ranking,?CONST_ARENA_STATA_2},
			set_hearsay(Uid,RUid,Hearsay)
	end.

	
arena_war_updata_cb(Player=#player{uid=Uid,socket=Socket,info=Info},{Result,LogSrc,Renown,Gold,RUid,Ranking})->
	{Player2,Bin}=role_api:currency_add(LogSrc,Player,[{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_RENOWN,Renown}]),
	app_msg:send(Socket,Bin),
	Binrew=msg_war_reward(Result,Gold, Renown),
	Arena=role_api_dict:arena_get(),
	Time   = util:seconds(),
	Arena2 = ets_day_player(Player,Arena#arena{ranking=Ranking,time=Time}), 
	{Arena3,RankList} = player_list(Player,Arena2),
	Time			=util:seconds(),
	ArenaLv			=arena_lv(),
	Times			=?IF(?CONST_ARENA_LOSE_TIME*60-(Time-Arena#arena.time)=<0,0,?CONST_ARENA_LOSE_TIME*60-(Time-Arena#arena.time)),
	BinMsg3   		= msg_dekaron(ArenaLv,Times,Info#info.renown,RankList),
	app_msg:send(Socket,<<BinMsg3/binary,Binrew/binary>>),
	role_api_dict:arena_set(Arena3),
	moil_api:moil(Uid,RUid,Arena3#arena.moil),
	Player2.


arena_reward_day(Player=#player{socket=Socket,uid=Uid}) ->
	case ets:lookup(?ETS_ARENA_REWARD, Uid) of
		[] -> {?error,?ERROR_GOODS_NOT_EXIST};
		[{_Uid,Rank,Lv}|_] ->
			{Renown,Gold} = arena_reward_rank(Rank,Lv),
			{Player2,CBin}=role_api:currency_add([arena_reward_day,[],<<"封神台每日奖励">>],
												Player,[{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_RENOWN,Renown}]),
			BinMsg=msg_get_reward(Gold,Renown,0,[]),
			app_msg:send(Socket, BinMsg),
			ets:delete(?ETS_ARENA_REWARD,Uid),
			mysql_api:delete(arena_reward, " uid = "++ util:to_list(Uid)),
			{Player2,CBin}
	end.

arena_reward_Integral(Ranking)->
	List = data_arena:get(),
	arena_reward_Integral2(Ranking,List).
arena_reward_Integral2(_Ranking,[])->{0,0,0,0,0};
arena_reward_Integral2(Ranking,[{LevelMin,LevelMsx,WinRenown,WinGold,LoseRenown,LoseGold,Pace}|List])->
	if
		Ranking >= LevelMin andalso Ranking =< LevelMsx -> {WinRenown,WinGold,LoseRenown,LoseGold,Pace};
		Ranking >= LevelMin andalso LevelMsx =:= 0 ->{WinRenown,WinGold,LoseRenown,LoseGold,Pace};
		?true ->
			arena_reward_Integral2(Ranking,List)
	end.

arena_reward_rank(Ranking,_Lv)->
	List=data_arena_reward:get(),
	{Renown,Gold}=arena_reward_rank2(Ranking,List),
	{Renown,Gold}.
arena_reward_rank2(_Rank,[])->{0,0};
arena_reward_rank2(Rank,[{RankMax,RankMin,Renown,Gold}|List])->
	if
		Rank >= RankMax andalso Rank =< RankMin -> {Renown,Gold};
		Rank >= RankMax andalso RankMin =:= 0 ->{Renown,Gold};
		?true ->
			arena_reward_rank2(Rank,List)
	end.


arena_buy_count(Player,Arena)->
	case role_api:currency_cut([arena_buy_count,[],<<"逐鹿台购买次数">>],Player,[{?CONST_CURRENCY_RMB,(Arena#arena.buy_count+1)*?CONST_ARENA_BUY_RMB}]) of
		{?error,ErrorCode}->
			{?error, ErrorCode};
		{?ok,Player2,Bin}->
			?MSG_ECHO("====================== ~w~n",[Arena#arena.surplus]),
			Arena2=Arena#arena{surplus=Arena#arena.surplus+1,buy_count=Arena#arena.buy_count+1},
			{?ok,Player2,Arena2,Arena2#arena.surplus,Bin}
	end.
			
%% 剩余时间
arena_reward_times()->
	{{Y,M,D},{H,I,_S}}=util:localtime(),
	if
		H>19 orelse (H>=19 andalso I>=20) ->  
			{{TY,TM,TD},_}=util:localtime_tomorrow(),
			util:datetime2timestamp(TY,TM,TD,19,20,0);
		?true->
			util:datetime2timestamp(Y,M,D,19,20,0)
	end.

%% 清除CD时间
arena_clean(Player)->
	Arean=role_api_dict:arena_get(),
	#arena{time=ArenaTime}=Arean,
	Time=util:seconds(),
	Rmb=?IF(?CONST_ARENA_LOSE_TIME*60-(Time-ArenaTime)=<0,0,util:ceil((?CONST_ARENA_LOSE_TIME*60-(Time-ArenaTime))/60)*?CONST_ARENA_FAST_RMB),
	LogSrc=[arena_clean,[],<<"清除CD时间">>],
	case role_api:currency_cut(LogSrc,Player,[{?CONST_CURRENCY_RMB,Rmb}]) of
		{?ok,Player2,Bin}->
			Arean2=Arean#arena{time=0},
			role_api_dict:arena_set(Arean2),
			BinMsg=msg_clean_ok(),
			{?ok,Player2,<<Bin/binary,BinMsg/binary>>};
		{?error,Error}->
			{?error,Error}
	end.
			
		
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% msg_xxx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 可以挑战的玩家列表[23820]
msg_dekaron(ArenaLv,Time,Renown,RankList)->
	Sid=app_tool:sid(),
    Rs=app_msg:encode([{?int16u,ArenaLv},{?int32u,Time},{?int32u,Renown},{?int16u,length(RankList)}]),
	Fun=fun(RankData,Acc) when is_record(RankData,rank_data) ->
				#rank_data{pro=Pro,sex=Sex,lv=Lv,uid=Uid,name=Name,power=Power,
						   rank=Ranking,win_count=WinCount,surplus=Surplus}=RankData,
				Rs2=app_msg:encode([{?int16u,Sid},{?int8u,Pro},{?int8u,Sex},{?int16u,Lv},
									{?int32u,Uid},{?stringl,Name},{?int16u,Ranking},
									{?int8u,WinCount},{?int8u,Surplus},{?int32u,Power}]),
				<<Acc/binary,Rs2/binary>>
		end,
	RsList=lists:foldl(Fun,Rs,RankList),
    app_msg:msg(?P_ARENA_DEKARON, RsList). 


% 封神台开始广播 [23832]
msg_strat()->
    app_msg:msg(?P_ARENA_STRAT, <<>>).

% 挑战奖励 [23835]
msg_war_reward(Res,Gold,Renown)->
    RsList = app_msg:encode([{?int8u,Res},{?int32u,Gold},{?int32u,Renown}]),
    app_msg:msg(?P_ARENA_WAR_REWARD, RsList). 

% 返回最新4条竞技场信息 [23940]
msg_max_data(HearsayData)->
	Rs=app_msg:encode([{?int16u,length(HearsayData)}]),
	Hearsays2 = lists:reverse(HearsayData),
	Fun = fun({StartTime,Type,Event,TUid,TName,TRanking,BUid,BName,BRanking,Result},Acc) -> 
				  Rs2 = app_msg:encode([{?int32u,StartTime},{?int8u,Type},{?int8u,Event},
										{?int32u,TUid},{?stringl,TName},{?int16u,TRanking},
										{?int32u,BUid},{?stringl,BName},{?int16u,BRanking},
										{?int8u,Result}]),
				<<Acc/binary,Rs2/binary>>
		end,
	BinData = lists:foldl(Fun,Rs,Hearsays2),
	app_msg:msg(?P_ARENA_MAX_DATA, BinData).

% 退出成功 [23910]
msg_ok()->
    app_msg:msg(?P_ARENA_OK,<<>>).

% 返回高手信息 [23930]
msg_killer_data(RankDatas,PUid,PLv)->
	Rs=app_msg:encode([{?int16u,length(RankDatas)}]),
	Fun=fun(RankData,Acc) when is_record(RankData,rank_data)->
				#rank_data{rank=Rank,uid=Uid,name=Name,lv=Lv,power=ClanName}=RankData,
				PLv0=case PUid==Uid of
						 ?true->PLv;
						 _->Lv
					 end,
				Rs2=app_msg:encode([{?int16u,Rank},{?int32u,Uid},{?stringl,Name},{?int16u,PLv0},{?string,ClanName}]),
				<<Acc/binary,Rs2/binary>>
		end,
    RsList=lists:foldl(Fun,Rs,RankDatas),
    app_msg:msg(?P_ARENA_KILLER_DATA, RsList).

% 领取结果 [23970]
msg_get_reward(Res)->
    RsList = app_msg:encode([{?bool,Res}]),
    app_msg:msg(?P_ARENA_GET_REWARD, RsList).

% 结果 [23870]
msg_result2(BuyCount)->
    RsList = app_msg:encode([{?int16u,BuyCount}]),
    app_msg:msg(?P_ARENA_RESULT2, RsList).


% 返回结果 [23890]
msg_buy_ok(Scount)->
    RsList = app_msg:encode([{?int16u,Scount}]),
    app_msg:msg(?P_ARENA_BUY_OK, RsList).

% 领取结果 [23970]
msg_get_reward(Gold,Renown,Star,GoodsList)->
    Rs = app_msg:encode([{?int32u,Gold},
        {?int32u,Renown},{?int32u,Star},
        {?int16u,length(GoodsList)}]),
	Fun=fun(GoodsId,Acc)->
				Rs2=app_msg:encode([{?int16u,GoodsId}]),
				<<Acc/binary,Rs2/binary>>
		end,
	RsList=lists:foldl(Fun,Rs,GoodsList),
    app_msg:msg(?P_ARENA_GET_REWARD, RsList).

% 领取倒计时 [24000]
msg_reward_times(Type,Times,Renoe,Gold)->
    RsList = app_msg:encode([{?int8u,Type},
        {?int32u,Times},{?int32u,Gold},
        {?int32u,Renoe}]),
    app_msg:msg(?P_ARENA_REWARD_TIMES, RsList).

% 战斗信息块 [23831]
msg_war_data(BinMsg)->
    app_msg:msg(?P_ARENA_WAR_DATA, BinMsg).

% 清除成功 [24020]
msg_clean_ok()->
    app_msg:msg(?P_ARENA_CLEAN_OK,<<>>).