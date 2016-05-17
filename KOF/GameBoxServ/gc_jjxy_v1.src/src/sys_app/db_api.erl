%% @author dreamxyp
%% @doc @todo Add description to db_api.

-module(db_api).

-include("../include/comm.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([
		 init_ets/0,
		 load_ets/0,
		 get_data2ets/2,
		 insert_data2ets/2
		]).


init_ets()->
	ets:new(?ETS_ONLINE,			[set,public,named_table,{keypos,#player.uid}]),	%% 在线玩家
	ets:new(?ETS_OFFLINE,			[set,public,named_table,{keypos,1}]),		%% 玩家离线数据（每分钟清一次15分钟没有读的数据）
	ets:new(?ETS_OFFLINE_SUB,		[set,public,named_table,{keypos,1}]),
	
	ets:new(?ETS_TASK,				[set,public,named_table,{keypos,1}]),	%% 玩家任务索引数据
	ets:new(?ETS_SCENE,				[set,public,named_table,{keypos,#map.pid}]),		%% 场景状态数据
	ets:new(?ETS_MAP_PLAYER,		[set,public,named_table,{keypos,#player_s.uid}]),	%% 场景玩家数据
	ets:new(?ETS_COPY,				[set,public,named_table,{keypos,#copy.pid}]),		%% 副本状态数据
%% 	ets:new(?ETS_COPY_PLAYER,		[set,public,named_table,{keypos,#player_s.uid}]),	%% 副本玩家数据
	ets:new(?ETS_TEAM,				[set,public,named_table,{keypos,#team.team_id}]),	%% 组队
%% 	ets:new(?ETS_PET,				[set,public,named_table,{keypos,1}]),	            %% 庞物
%% 	ets:new(?ETS_FRIEND,			[set,public,named_table,{keypos,#relation.uid}]),	%% 好友
	ets:new(?ETS_GOODS_BUFF,		[set,public,named_table,{keypos,1}]),	%% 使用物品得到的Buff加成
	ets:new(?ETS_COPYSAVE,			[set,public,named_table,{keypos,1}]),	%% 玩家副本数据
	ets:new(?ETS_COPYREWARD,		[set,public,named_table,{keypos,1}]),	%% 副本奖励记录
	ets:new(?ETS_HEROSAVE,			[set,public,named_table,{keypos,1}]),	%% 英雄副本数据
	ets:new(?ETS_FIENDSAVE,			[set,public,named_table,{keypos,1}]),	%% 魔王副本数据
	ets:new(?ETS_PILBEST,			[set,public,named_table,{keypos,1}]),	%% 取经之路最佳记录
	ets:new(?ETS_BLACK_SHOP_BUY,	[set,public,named_table,{keypos,1}]),	%% 取经之路神秘黑店物品购买记录
	ets:new(?ETS_WELFARE,			[set,public,named_table,{keypos,1}]),	%% 在线奖励(福利)
 
	ets:new(?ETS_ARENA,				[set,public,named_table,{keypos,#rank_data.rank}]),	%% 竞技场
	ets:new(?ETS_ARENA_DATA,		[set,public,named_table,{keypos,1}]),				%% 竞技场数据
	ets:new(?ETS_ARENA_REWARD,		[set,public,named_table,{keypos,1}]),				%% 竞技场奖励
    ets:new(?ETS_TREASURE_STORE,    [set,public,named_table,{keypos,#tr_shop.uid}]),    %% 藏宝阁系统
    ets:new(?ETS_ENERGY,            [set,public,named_table,{keypos,1}]),               %% 精力系统
%% 	ets:new(?ETS_WAR_DATAS, 		[set,public,named_table,{keypos,1}]),

	
	ets:new(?ETS_PUBLIC_RECORDS,	[set,public,named_table,{keypos,1}]),						%% tanwer公共数据 Key=?CONST_PUBLIC_KEY_XXX
	ets:new(?ETS_CLAN_PUBLIC,		[set,public,named_table,{keypos,#clan_public.clan_id}]),	%% 帮会公共数据
	ets:new(?ETS_CLAN_MEMBER,		[set,public,named_table,{keypos,#clan_mem.uid}]),			%% 帮会成员
 	ets:new(?ETS_CLAN_CAT,			[set,public,named_table,{keypos,#clan_cat_data.clan_id}]),	%% 帮会活动-招财猫
  	ets:new(?ETS_CLAN_BOSS_RANK,	[set,public,named_table,{keypos,#clan_boss_rank.uid}]),		%% 帮会活动-帮派BOSS排名数据
  	ets:new(?ETS_CLAN_BOSS_PUB,		[set,public,named_table,{keypos,#clan_boss_pub.clan_id}]),	%% 帮会活动-帮派BOSS公共数据

 	ets:new(?ETS_ACTIVE_STATE,		[set,public,named_table,{keypos,1}]),						%% 所有活动状态
 	ets:new(?ETS_ACTIVE_TODAY_DATA,	[set,public,named_table,{keypos,1}]),						%% 当天活动数据



%% 	ets:new(?ETS_CLAN_WAR_ROLE, 	[set,public,named_table,{keypos,#clan_war_role.uid}]),	%% 帮派战玩家数据
%% 	ets:new(?ETS_CLAN_WAR_RECS,     [set,public,named_table,{keypos,#clan_war_recs.id}]),	%% 帮派战战报记录数据
%% 	ets:new(?ETS_CLAN_BOSS,		    [set,public,named_table,{keypos,1}]),   %% 帮派心魔
%% 	ets:new(?ETS_CLAN_BOSS_TIME,	[set,public,named_table,{keypos,1}]),   %% 帮派心魔
%% 	ets:new(?ETS_SKY_WAR_CLAN,    	[set,public,named_table,{keypos,#skywar_clan.clan_id}]),	%% 天宫之战帮派积分相关
%% 	ets:new(?ETS_SKY_WAR_ROLE,		[set,public,named_table,{keypos,#skywar_role.uid}]),   		%% 天宫之战玩家数据

	ets:new(?ETS_M_MAIL,				[set,public,named_table,{keypos,#mail.mail_id}]),    %% 邮件列表
	ets:new(?ETS_M_NOTICE,				[set,public,named_table,{keypos,#notice.id}]),       %% 全服公告
	ets:new(?ETS_M_LOGS,				[set,public,named_table,{keypos,#logs.uid}]),        %% 离线玩家日志
	
	ets:new(?ETS_MAKE_WASH, 			[set,public,named_table,{keypos,1}]),	%% 装备洗练
	ets:new(?ETS_MOIL_DATA, 			[set,public,named_table,{keypos,1}]),	%% 苦工日志
	ets:new(?ETS_MOIL_WORKER, 			[set,public,named_table,{keypos,2}]),	%% 苦工工作
	ets:new(?ETS_MALL_BUY_MAX,      	[set,public,named_table,{keypos,1}]),	%% 商城购买数量数据
	ets:new(?ETS_CIRCLE, 				[set,public,named_table,{keypos,1}]),	%% 三界杀

	ets:new(?ETS_GOODS_OUTPUT_MAX,		[set,public,named_table,{keypos,1}]),	%% 控制随机物品产出数量
	ets:new(?ETS_WORLD_BOSS,			[set,public,named_table,{keypos,1}]),	%% 打BOSS排行 
	ets:new(?ETS_DEFEND_RANK,			[set,public,named_table,{keypos,#defend_rank.uid}]),	%% 保卫经书排行榜
	ets:new(?ETS_DEFEND_MONSTERS,		[set,public,named_table,{keypos,#defend_monsters.gmid}]),	%% 保卫经书怪物行走

	ets:new(?ETS_CAMPWAR_RANK,			[set,public,named_table,{keypos,#camp_rank.uid}]),	%% 阵营战排行榜
	
	ets:new(?ETS_ONLINE_REWARD,	    	[set,public,named_table,{keypos,1}]),   %% 在线奖励  
	ets:new(?ETS_ONLINE_REWAD_LV,		[set,public,named_table,{keypos,1}]),   %% 在线等级奖励  

	ets:new(?ETS_KEJU_RANK,				[set,public,named_table,{keypos,#keju_rank.uid}]),   %% 科举排行表
 
	ets:new(?ETS_NIAN_SHOU,				[set,public,named_table,{keypos,1}]),   %% 年兽
	
	ets:new(?ETS_TIMES_GOODS_LOGS,  	[set,public,named_table,{keypos,#times_goods_logs.ref}]),   %% 次数物品日志(鞭炮)
	ets:new(?ETS_TIMES_GOODS_LOGS2, 	[set,public,named_table,{keypos,#times_goods_logs.ref}]),   %% 次数物品日志(元宵)
	ets:new(?ETS_TIMES_GOODS_LOGS3,  	[set,public,named_table,{keypos,#times_goods_logs.ref}]),   %% 清明祭祖活动
	ets:new(?ETS_SALES_TIME,			[set,public,named_table,{keypos,#d_sales_total.id}]),   %% 精彩活动
	ets:new(?ETS_STRIDE_WISH_LOSG,		[bag,public,named_table,{keypos,#wish_logs.uid}]), %% 许愿日志
	ets:new(?ETS_WAR_SUPER,				[set,public,named_table,{keypos,1}]), %% 玩家常规挑战数据
	ets:new(?ETS_WAR_SUPER2,			[set,public,named_table,{keypos,1}]), %% 玩家越级挑战数据
	ets:new(?ETS_WAR_SUPERIOR_DATA,		[set,public,named_table,{keypos,2}]), %% 参加巅峰之战玩家
	ets:new(?ETS_WAR_SUPER_LOGS,		[set,public,named_table,{keypos,1}]), 	%% 三界争霸战报日志
	ets:new(?ETS_WAR_SUPERIOR_LOGS,		[set,public,named_table,{keypos,1}]), 	%% 巅峰之战报日志
	ets:new(?ETS_KINGHELL, 				[set,public,named_table,{keypos,#king_kill.mons_id}]),	%% 阎王殿单挑和正式记录(首次和最佳)
	ets:new(?ETS_WHEEL_LOG,				[set,public,named_table,{keypos,#times_goods_logs.ref}]), 	%% 转盘日志
	ets:new(?ETS_WHEEL_TIMES,			[set,public,named_table,{keypos,1}]), 	%% 转盘次数
 	ets:new(?ETS_SHOOT,			        [set,public,named_table,{keypos,1}]), 	%% 所有玩家中奖情况

	ets:new(?ETS_WRESTLE_CONTROL,       [set,public,named_table,{keypos,#wrestle_con.idx}]),       %% 格斗之王活动控制
    ets:new(?ETS_WRESTLE,               [set,public,named_table,{keypos,#wrestle.uid}]),           %% 格斗之王
    ets:new(?ETS_WRESTLE_FINAL,         [set,public,named_table,{keypos,#wrestle_final.uid}]),     %% 格斗之王决赛
    ets:new(?ETS_WRESTLE_GUESS,         [set,public,named_table,{keypos,#wrestle_guess.uid}]),     %% 格斗之王竞猜情况
    
	
	ets:new(?ETS_TOP_NGC,         		[set,public,named_table,{keypos,2}]),   %% TOP总表
	ets:new(?ETS_TOP_TYPE,         		[set,public,named_table,{keypos,1}]),   %% TOP分类表
	ets:new(?ETS_DISCOUNT_SHOP,         [set,public,named_table,{keypos,#discount_shop.uid}]), 
	?ok.

load_ets()->
	load_ets(?ETS_TASK),
	load_ets(?ETS_ARENA),
	load_ets(?ETS_ARENA_DATA),
	load_ets(?ETS_ARENA_REWARD),
	load_ets(?ETS_MOIL_DATA),
	
	load_ets(?ETS_CLAN_PUBLIC), 
	load_ets(?ETS_CLAN_CAT), 
	load_ets(?ETS_CLAN_MEMBER),
	load_ets(?ETS_TOP_NGC),
%% 	load_ets(?ETS_CLAN_APPLY),
%% 	load_ets(?ETS_CLAN_WAR_ROLE),
%% 	load_ets(?ETS_SKY_WAR_CLAN),
%% 	load_ets(?ETS_SKY_WAR_ROLE),
%%  load_ets(?ETS_FRIEND),
%% 	load_ets(?ETS_COPYREWARD),
%% 	load_ets(?ETS_PILBEST),
%% 	load_ets(?ETS_BLACK_SHOP_BUY),
%% 	load_ets(?ETS_CIRCLE),
%% 	load_ets(?ETS_ONLINE_REWARD),
%% 	load_ets(?ETS_ONLINE_REWAD_LV),
%% 	load_ets(?ETS_NIAN_SHOU),
%% 	load_ets(?ETS_TIMES_GOODS_LOGS),
%% 	load_ets(?ETS_TIMES_GOODS_LOGS2),
%% 	load_ets(?ETS_TIMES_GOODS_LOGS3),
%% 	load_ets(?ETS_MALL_BUY_MAX),
	load_ets(?ETS_SALES_TIME),
%% 	load_ets(?ETS_KINGHELL),
%% 	load_ets(?ETS_WHEEL_LOG),
%% 	load_ets(?ETS_WHEEL_TIMES),
%% 	load_ets(?ETS_WAR_SUPER),
%% 	load_ets(?ETS_WAR_SUPER2),
	?ok.



%% 读取scene(ETS)
scene(Mapid) ->
	ets:lookup_element(?ETS_SCENE, Mapid, 1).

%% 根据游戏场景地图MAPID，得到地图进程MPID
scene_mpid(Mapid) ->
	ets:lookup_element(?ETS_SCENE, Mapid, 1).

%% goods_insert()
goods_insert(ID, Gid, Seconds) ->
	Sid   = app_tool:sid(),
	Datas = [{id, ID}, {gid, Gid}, {seconds, Seconds}],
	case mysql_api:insert(Sid,goods,Datas) of
		{?ok, 1, _} ->
			?ok;
		R ->
			?MSG_ERROR("Goods New error : ~w~n", [R])
	end.
	


%% Msq -> ets %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
load_ets(?ETS_CLAN_PUBLIC) -> 
	Sql = "SELECT `clan_id`,`clan_rank`,`clan_name`,`clan_lv`,`devote`,`up_devote`,`max_member`,
			`master_id`,`master_name`,`master_color`,`master_Lv`,`notice`,`member`,`master_list`,`seconds` FROM `clan_public`;",
	case mysql_api:select(Sql) of
		{?ok, []} ->
			?ok;
		{?ok, Datas} ->
			Fun = fun([ClanId,ClanRank,ClanName,ClanLv,Devote,UpDevote,Max,Mid,Mname,Mcolor,MLv,Notice,Member0,MasterList0,Seconds], Acc) ->
						  Member	 = mysql_api:decode(Member0),
						  MasterList = mysql_api:decode(MasterList0),
						  Clan = #clan_public{clan_id=ClanId,clan_rank=ClanRank,clan_name=ClanName,clan_lv=ClanLv,
											  devote=Devote,up_devote=UpDevote,max_member=Max,notice = Notice,
											  master_id = Mid, master_name = Mname,master_name_color=Mcolor,master_lv=MLv,
											  member = Member, master_list =MasterList,seconds = Seconds},
						  [Clan|Acc]
				  end,
			Objects = lists:foldl(Fun, [], Datas),
			ets:insert(?ETS_CLAN_PUBLIC, Objects),
			?ok;
		{?error, Reason} ->
			?MSG_ERROR("Error : ~w~n", [Reason])
	end;

load_ets(?ETS_CLAN_MEMBER) ->
	Sql = "SELECT `uid`,`clan_id`,`name`,`name_color`,`lv`,`post`,`devote_day`,`devote_sum`,`logout_time`,`join_time` FROM `clan_mem`;",
	case mysql_api:select(Sql) of
		{?ok, []} ->
			?ok;
		{?ok, Datas} ->
			Fun = fun([Uid,ClanId,Name,NameColor,Lv,Post,DevoteDay,DevoteSum,LogoutTime,JoinTime], Acc) ->
					  ClanMem = #clan_mem{uid = Uid, clan_id = ClanId, name = Name, name_color = NameColor,
										  lv = Lv, post = Post, devote_day = DevoteDay, devote_sum = DevoteSum,
										  logout_time = LogoutTime, join_time = JoinTime},
					 [ClanMem|Acc]
				  end,
			Objects = lists:foldl(Fun, [], Datas),
			ets:insert(?ETS_CLAN_MEMBER, Objects),
			?ok;
		{?error, Reason} ->
			?MSG_ERROR("Error : ~w~n", [Reason])
	end;



load_ets(?ETS_CLAN_CAT) ->
	Sql = "SELECT  `clan_id`, `cat_exp` FROM `clan_cat_data`;",
	case mysql_api:select(Sql) of
		{?ok, []} ->
			?ok;
		{?ok, Datas} ->
			Fun = fun([ClanId,Exp],Acc) ->
						  {Lv,_NowExp,UpExp}=clan_active_api:cat_uplv(Exp),
						  CatData = #clan_cat_data{clan_id=ClanId,cat_lv=Lv,cat_exp=Exp,cat_upexp=UpExp},
						  [CatData|Acc]
				  end,
			Objects = lists:foldl(Fun, [], Datas),
			ets:insert(?ETS_CLAN_CAT, Objects),
			?ok;
		{?error, Reason} ->
			?MSG_ERROR("Error : ~w~n", [Reason])
	end;

load_ets(?ETS_TOP_NGC) ->
	Sql = "SELECT  `uid`, `name`,`name_color`,`clan_id`,`clan_name`,`lv`,`powerful`,`rank` FROM `top_ngc`;",
	case mysql_api:select(Sql) of
		{?ok, Datas} ->
			Fun = fun([Uid,Name,NameColor,ClanId,ClanName,Lv,Power,Rank],Acc) ->
						  TopNgc=#top_ngc{uid = Uid, name = Name, name_color = NameColor, rank=Rank,
								   clan_id = ClanId, clan_name = ClanName, lv = Lv, powerful = Power},
						  [TopNgc|Acc];
					 (_,Acc)->Acc
				  end,
			Objects = lists:foldl(Fun, [], Datas),
			ets:insert(?ETS_TOP_NGC,Objects),
%% 			LvObjects=lists:sublist(lists:reverse(lists:keysort(#top_ngc.lv,Objects)),?CONST_TOP_RANK_20),
%% 			ets:insert(?ETS_TOP_TYPE,{?CONST_TOP_TYPE_LV,LvObjects}),
%% 			PoObjects=lists:sublist(lists:reverse(lists:keysort(#top_ngc.powerful,Objects)),?CONST_TOP_RANK_20),
%% 			ets:insert(?ETS_TOP_TYPE,{?CONST_TOP_TYPE_POWER,PoObjects}),
%% 			RaObjects=lists:sublist(lists:keysort(#top_ngc.rank,Objects),?CONST_TOP_RANK_20),
%% 			ets:insert(?ETS_TOP_TYPE,{?CONST_TOP_TYPE_ARENA,RaObjects}),
			?ok;
		{?error, Reason} ->
			?MSG_ERROR("Error : ~w~n", [Reason])
	end;

%% 	
%% load_ets(?ETS_CLAN_WAR_ROLE) ->
%% 	clan_api:init_clan_role();
%% 		  
%% load_ets(?ETS_CLAN_LOG) ->
%% 	Sql = "SELECT `clan_id`,`logs` FROM `clan_log` ",
%% 	case mysql_api:select(Sql) of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			Objects = [list_to_tuple(Data)||Data <- Datas],
%% 			ets:insert(?ETS_CLAN_LOG, Objects),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
%% load_ets(?ETS_CLAN_WAR_RECS) ->
%% 	case global_data:get(?GLOBAL_CLAN_WAR_RECS) of
%% 		[] ->
%% 			?skip;
%% 		WarRecs ->
%% 			Objects = case erlang:is_binary(WarRecs) of
%% 						  ?true ->
%% 							  try 
%% 								  erlang:binary_to_term(WarRecs)
%% 							  catch
%% 								  _Err:_Reason ->
%% 									  erlang:binary_to_term(zlib:uncompress(WarRecs))
%% 							  end;
%% 						  ?false ->
%% 							  WarRecs
%% 					  end,
%% 			ets:insert(?ETS_CLAN_WAR_RECS, Objects)
%% 	end;
%% 
%% load_ets(?ETS_FRIEND) ->
%% 	Sql = " SELECT `uid`,`friend` FROM friend ",
%% 	case mysql_api:select(Sql) of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			Objects	= [util:bin_to_term(Data) || [_,Data] <- Datas],
%% 			ets:insert(?ETS_FRIEND, Objects),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
%% %% load_ets(?ETS_COPYSAVE) ->
%% %% 	Sid = app_tool:sid(),
%% %% 	Sql = "SELECT * FROM copysave",
%% %% 	case mysql_api:select(Sid, Sql) of
%% %% 		{?ok, []} ->
%% %% 			?ok;
%% %% 		{?ok, Datas} ->
%% %% 			Objects	= [{{Sid,Uid},util:bin_to_term(Data)} || [Uid,Data] <- Datas],
%% %% 			ets:insert(?ETS_COPYSAVE, Objects),
%% %% 			?ok;
%% %% 		{?error, Reason} ->
%% %% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% %% 	end;
%% 
%% %% load_ets(?ETS_PILSAVE) ->
%% %% 	Sid = app_tool:sid(),
%% %% 	Sql = "SELECT * FROM pilsave",
%% %% 	case mysql_api:select(Sid, Sql) of
%% %% 		{?ok, []} ->
%% %% 			?ok;
%% %% 		{?ok, Datas} -> 
%% %% 			Objects	= [{{Sid,Uid},util:bin_to_term(Data)} || [Uid,Data] <- Datas],
%% %% 			ets:insert(?ETS_PILSAVE, Objects),
%% %% 			?ok;
%% %% 		{?error, Reason} ->
%% %% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% %% 	end;
%% 
%% load_ets(?ETS_COPYREWARD) ->
%% 	Sql = "SELECT `copyid`,`copyreward` FROM copyreward",
%% 	case mysql_api:select(Sql) of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			Objects	= [{CopyId,util:bin_to_term(Data)} || [CopyId,Data] <- Datas],
%% 			ets:insert(?ETS_COPYREWARD, Objects),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
%% load_ets(?ETS_PILBEST) ->
%% 	Sql = "SELECT `copyid`,`pilbest` FROM pilbest",
%% 	case mysql_api:select(Sql) of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			Objects	= [{CopyId,util:bin_to_term(Data)} || [CopyId,Data] <- Datas],
%% 			ets:insert(?ETS_PILBEST, Objects),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
%% load_ets(?ETS_BLACK_SHOP_BUY) ->
%% 	Sql = "SELECT `key_str`,`black_shop` FROM black_shop",
%% 	case mysql_api:select(Sql) of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			Objects	= [{KeyStr,util:bin_to_term(Data)} || [KeyStr,Data] <- Datas],
%% 			ets:insert(?ETS_BLACK_SHOP_BUY, Objects),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
load_ets(?ETS_ARENA)->
	Sql = "SELECT `rank`,`uid`,`name`,`country`,`sex`,`pro`,`lv`,
		  `renown`,`win_count`,`surplus`,`power` FROM arena",
	case mysql_api:select(Sql) of
		{?ok, []} ->
			?ok;
		{?ok, Datas} ->
			Fun = fun([Rank,Uid,Name,Country,Sex,Pro,Lv,Renown,WinCount,Surplus,Power]) ->
						  RankData = #rank_data{rank = Rank, uid = Uid, name = Name, city = Country,sex = Sex, pro = Pro, lv = Lv, 
												renown = Renown, win_count = WinCount, surplus = Surplus, power =Power},
						  ets:insert(?ETS_ARENA, RankData)
				  end,
			lists:foreach(Fun, Datas);
		{?error, Reason} ->
			?MSG_ERROR("Error : ~w~n", [Reason])
	end;

load_ets(?ETS_ARENA_DATA)->
	case mysql_api:select("SELECT `uid`,`datas` FROM arena_data") of
		{?ok, []} -> 
			?ok;
		{?ok, Datas} ->
			NewDatas = [{Uid,Sid2,util:bin_to_term(Data)}||{Uid,Sid2,Data} <- Datas],
			ets:insert(?ETS_ARENA_DATA, NewDatas),
			?ok;
		{?error, Reason} ->
			?MSG_ERROR("Error : ~w~n", [Reason])
	end;

%% REPLACE INTO `clan_boss` (`clan_id`,`times`,`date`) VALUES 
load_ets(?ETS_CLAN_BOSS_PUB)->
	case mysql_api:select("SELECT `clan_id`,`times`,`date` FROM clan_boss") of
		{?ok, []} ->
			?ok;
		{?ok, Datas} ->
			NewDatas = [{ClanId,Times,Date}||[ClanId,Times,Date] <- Datas],
			ets:insert(?ETS_CLAN_BOSS_PUB, NewDatas),
			?ok;
		{?error, Reason} ->
			?MSG_ERROR("Error : ~w~n", [Reason])
	end;
	
%% %% load_ets(?ETS_WAR_DATAS)->
%% %% 	Sid = app_tool:sid(),
%% %% 	case mysql_api:select(Sid,"select * from war_datas") of
%% %% 		{?ok, []} ->
%% %% 			?ok;
%% %% 		{?ok, Datas} ->
%% %% 			NewDatas = [{Id,util:bin_to_term(Data)}||{Id,Data} <- Datas],
%% %% 			ets:insert(?ETS_ARENA_DATA, NewDatas),
%% %% 			?ok;
%% %% 		{?error, Reason} ->
%% %% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% %% 	end;
%% 
%% %% load_ets(?ETS_M_MAIL) ->
%% %% 	Sid = app_tool:sid(),
%% %% 	{Y,M,D}=util:date(),
%% %% 	Time=util:datetime2timestamp(Y, M, D, 0, 0, 0) - ?CONST_MAIL_NET_TIME*86400,     %% ?CONST_MAIL_NET_TIME*86400==7*24*60*60 :: 7天邮件过期
%% %% 	Sql = "SELECT * FROM `mail` WHERE `date` > " ++ util:to_list(Time),
%% %% 	case mysql_api:select(Sid, Sql) of
%% %% 		{?ok, []} ->
%% %% 			?ok;
%% %% 		{?ok, Datas} ->
%% %% 			Fun	= fun({MailId,RecvUid,RecvName,SendUid,SendName,Title,Content,VGList,UGList,State,MType,BoxType,Pick,Date}) ->
%% %% 						  mail_api:mail_data2ets(MailId,RecvUid,RecvName,SendUid,SendName,Title,Content,
%% %% 												 VGList,UGList,State,MType,BoxType,Pick,Date)
%% %% 				  end,
%% %% 			Objects = [Fun(list_to_tuple(Data)) || Data <- Datas],
%% %% 			ets:insert(?ETS_M_MAIL, Objects),
%% %% 			?ok;
%% %% 		{?error, Reason} ->
%% %% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% %% 	end;
%% 	
%% load_ets(?ETS_MOIL_DATA)->
%% 	case mysql_api:select("SELECT `uid`,`sid`,`datas` FROM moil_data") of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			NewDatas = [{{NSid,NUid},util:bin_to_term(Data)}||[NSid,NUid,Data] <- Datas],
%% 			ets:insert(?ETS_MOIL_DATA, NewDatas),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%%  
%% load_ets(?ETS_CIRCLE)->
%% 	case mysql_api:select("SELECT `id`,`datas` FROM circle") of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			NewDatas = [{Nid,util:bin_to_term(Data)}||[Nid,Data] <- Datas],
%% 			ets:insert(?ETS_CIRCLE, NewDatas),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
%% load_ets(?ETS_ONLINE_REWARD)->
%% 	case mysql_api:select("SELECT `uid`,`time`,`stime`,`logtime` FROM online_reward") of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			NDatas=[{Uid,Time,Stime,LogTime}||[Uid,Time,Stime,LogTime]<-Datas],
%% 			ets:insert(?ETS_ONLINE_REWARD, NDatas),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
%% load_ets(?ETS_ONLINE_REWAD_LV)->
%% 	case mysql_api:select("SELECT `uid`,`lv` FROM online_reward_lv") of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			NDatas=[{Uid,Lv}||[Uid,Lv]<-Datas],
%% 			ets:insert(?ETS_ONLINE_REWAD_LV, NDatas),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
%% load_ets(?ETS_TIMES_GOODS_LOGS) ->
%% 	L = global_data:get(?GLOBAL_TIMES_GOODS_LOGS),
%% 	ets:insert(?ETS_TIMES_GOODS_LOGS, L);
%% 
%% load_ets(?ETS_TIMES_GOODS_LOGS2) ->
%% 	L = global_data:get(?GLOBAL_TIMES_GOODS_LOGS2),
%% 	ets:insert(?ETS_TIMES_GOODS_LOGS2, L);
%% 
%% load_ets(?ETS_TIMES_GOODS_LOGS3) ->
%% 	L = global_data:get(?GLOBAL_TIMES_GOODS_LOGS3),
%% 	ets:insert(?ETS_TIMES_GOODS_LOGS3, L);
%% 
%% 
%% load_ets(?ETS_NIAN_SHOU)->
%% 	case mysql_api:select("SELECT `uid`,`data` FROM nianshou") of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			NDatas=[{Uid,util:bin_to_term(Data)}||[Uid,Data]<-Datas],
%% 			ets:insert(?ETS_NIAN_SHOU, NDatas),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
%% load_ets(?ETS_SKY_WAR_CLAN) ->
%% 	Sql = "SELECT `clan_id`,`clan_name`,`camp`,`rank`,`score` FROM skywar_clan",
%% 	case mysql_api:select(Sql) of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			SkywarClans = [#skywar_clan{clan_id = ClanID, clan_name = ClanName, camp = Camp, 
%% 										rank = Rank, score = Score}
%% 									   ||[ClanID,ClanName,Camp,Rank,Score]<-Datas],
%% 			ets:insert(?ETS_SKY_WAR_CLAN, SkywarClans),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
%% %% load_ets(?ETS_SKY_WAR_ROLE) ->
%% %% 	Sql = "SELECT `uid`,`uname`,`lv`,`clan_id`,`clan_name`,`camp`,
%% %% 		   `kill`,`dead`,`one_max`,`score`,`revive` FROM skywar_role",
%% %% 	case mysql_api:select(Sql) of
%% %% 		{?ok, []} ->
%% %% 			?ok;
%% %% 		{?ok, Datas} ->
%% %% 			Fun = fun([Uid,Name,Lv,ClanID,ClanName,Camp,Kill,Dead,OneMax,Score,Revive], Acc) ->
%% %% 						  SkywarRole = 
%% %% 							  #skywar_role{sid = Sid, uid = Uid, name = Name, lv = Lv, clan_id = ClanID, 
%% %% 										   clan_name = ClanName, camp = Camp,kill = Kill, dead = Dead, 
%% %% 										   one_max2 = OneMax, score = Score, revive = Revive},
%% %% 						  [SkywarRole|Acc]
%% %% 				  end,
%% %% 			SkywarRoles = lists:foldl(Fun, [], Datas),
%% %% 			ets:insert(?ETS_SKY_WAR_ROLE, SkywarRoles),
%% %% 			?ok;
%% %% 		{?error, Reason} ->
%% %% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% %% 	end;
%% 
%% load_ets(?ETS_MALL_BUY_MAX) ->
%% 	case global_data:get(?GLOBAL_MALL_BUY_MAX) of
%% 		[] ->
%% 			?ok;
%% 		Objects ->
%% 			ets:insert(?ETS_MALL_BUY_MAX, Objects)
%% 	end;
%% 
load_ets(?ETS_SALES_TIME) ->
	SalesIds=data_sales_total:get_ids(),
	SalesList=[data_sales_total:get(SalesId)||SalesId<-SalesIds],
	SalesList2=[DSalesTotal||DSalesTotal<-SalesList,is_record(DSalesTotal,d_sales_total)],
	ets:insert(?ETS_SALES_TIME,SalesList2);
%% 
%% load_ets(?ETS_KINGHELL)->
%% 	case mysql_api:select("SELECT `id`,`datas` FROM kinghell") of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok, Datas} ->
%% 			NewDatas = [{Nid,util:bin_to_term(Data)}||[Nid,Data] <- Datas],
%% 			ets:insert(?ETS_KINGHELL, NewDatas),
%% 			?ok;
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% 
%% load_ets(?ETS_WHEEL_LOG) ->
%% 	case global_data:get(?GLOBAL_WHEEL_LOG) of
%% 		[] ->
%% 			?skip;
%% 		Logs ->
%% 			ets:insert(?ETS_WHEEL_LOG, Logs)
%% 	end;
%% 
%% load_ets(?ETS_WHEEL_TIMES) ->
%% 	case global_data:get(?GLOBAL_WHEEL_TIMES) of
%% 		[] ->
%% 			?skip;
%% 		Times ->
%% 			ets:insert(?ETS_WHEEL_TIMES, Times)
%% 	end;
%% load_ets(?ETS_WAR_SUPER)->
%% 	Sql = "SELECT `uid`,`sid`,`datas` FROM stride_super",
%% 	case mysql_api:select(Sql) of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok,Datas} ->
%% 			Fun=fun([Sevid,Uid,Pdatas],Acc)->
%% 						Key={Sevid,Uid},
%% 						Pdatas2=util:decode(Pdatas),
%% 						[{Key,Pdatas2}|Acc]
%% 				end,
%% 			Datas2=lists:foldl(Fun,[],Datas),
%% 			ets:insert(?ETS_WAR_SUPER,Datas2);
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;
%% load_ets(?ETS_WAR_SUPER2)->
%% 	Sql = "SELECT `uid`,`sid`,`datas` FROM stride_super2",
%% 	case mysql_api:select(Sql) of
%% 		{?ok, []} ->
%% 			?ok;
%% 		{?ok,Datas} ->
%% 			Fun=fun([Sevid,Uid,Pdatas],Acc)->
%% 						Key={Sevid,Uid},
%% 						Pdatas2=util:decode(Pdatas),
%% 						[{Key,Pdatas2}|Acc]
%% 				end,
%% 			Datas2=lists:foldl(Fun,[],Datas),
%% 			ets:insert(?ETS_WAR_SUPER2,Datas2);
%% 		{?error, Reason} ->
%% 			?MSG_ERROR("Error : ~w~n", [Reason])
%% 	end;

load_ets(_Unkown)->ok.
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%公共ETS表数据存取%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------- 使用公共ETS表时注意填常量?CONST_PUBLIC_KEY_** 避免数据Key值冲突导致数据错误---------------------
%------------- ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_DEFENDBOOK,[{num,1},{human_get,100}...]})------
%% 从ets表取公共数据 
%% db_api:get_data2ets(?CONST_PUBLIC_KEY_DEFENDBOOK,[num,human_get,fairy_get,magic_get]).
%% retrun:[Num,HumanGet,FairyGet,MagicGet] | []

get_data2ets(Key,{KeyDate,Data}) ->
	get_data2ets(Key,[{KeyDate,Data}]);
get_data2ets(Key,FindList) ->
	case ets:lookup(?ETS_PUBLIC_RECORDS,Key) of
		[{Key,EtsList}|_] -> 
			F=fun(Atorm,Acc) ->
					  case lists:keyfind(Atorm, 1, EtsList) of
						  {Atorm,GetData} -> [GetData | Acc];
						  _ -> [0 | Acc]
					  end
			  end,
			NewList=lists:foldl(F, [], FindList),
			lists:reverse(NewList);
		_ ->
			[]
	end.

%% 更新ets表公共数据
%% db_api:insert_data2ets(?CONST_PUBLIC_KEY_DEFENDBOOK,[{num,Num},{integral,Integral}]).
insert_data2ets(Key,{KeyDate,Data}) ->
	insert_data2ets(Key,[{KeyDate,Data}]);
insert_data2ets(Key,InsertList) ->
	case ets:lookup(?ETS_PUBLIC_RECORDS, Key) of
		[{Key,EtsList}|_] -> 
			Fun=fun({Atorm,Data},Acc) ->
						[{Atorm,Data}|[{A,D}||{A,D} <- Acc,A=/=Atorm]]
				end,
			NewList = lists:foldl(Fun, EtsList, InsertList),
			ets:insert(?ETS_PUBLIC_RECORDS, {Key,NewList});
		_ ->
			ets:insert(?ETS_PUBLIC_RECORDS, {Key,InsertList})
	end.
