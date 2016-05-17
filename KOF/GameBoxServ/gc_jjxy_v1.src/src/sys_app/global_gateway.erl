 %% Author: Administrator
 %% Created: 2011-7-1
 %% Description: TODO: Add description to gateway_api
 -module(global_gateway).
 
 %% --------------------------------------------------------------------
 %% Include files
 %% --------------------------------------------------------------------
 -include("../include/comm.hrl").
 %%
 %% Exported Functions 
 %%
 -export([gateway/3]).  
 
 %% 1 - 500 ( 预留 ) 
 gateway(ProtocolCode, Player, Binary) 
   when ProtocolCode =< ?P_KEEP_END -> 
	 ?MSG_ERROR("?error In ProtocolCode:~p Player:~p Binary:~p~n",[ProtocolCode, Player, Binary]),
	 {?ok, Player};

% 充值控制开关
 gateway(?P_SYSTEM_PAY_CHECK, Player, _Binary) ->
	 BinMsg =
		 case is_funs_api:check_fun(?CONST_FUNC_OPEN_RECHARGE) of
			 ?CONST_TRUE ->
				 SQL = "SELECT `oid` FROM `logs_pay` WHERE `uid`= " ++ util:to_list(Player#player.uid),
				 State = ?IF(mysql_api:select(SQL) == {?ok,[]}, 2, 1),
				 app_msg:msg(?P_SYSTEM_PAY_STATE, app_msg:encode([{?int8u, State}]));
			 _ ->
				 BinMsg1 = app_msg:msg(?P_SYSTEM_PAY_STATE, app_msg:encode([{?int8u, ?CONST_FALSE}])),
				 BinMsg2 = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
				 <<BinMsg1/binary,BinMsg2/binary>>
		 end,
	 app_msg:send(Player#player.socket, BinMsg),
	 {?ok,Player};

 %% 501 - 1000 ( 系统 )
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_SYSTEM_END ->
	 system_gateway:gateway(ProtocolCode, Player, Binary);
 %% 1001 - 2000 ( 角色 )
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_ROLE_END ->
	 role_gateway:gateway(ProtocolCode, Player, Binary); 
 %% 2001 - 2500 ( 物品/背包 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_GOODS_END ->
	 bag_gateway:gateway(ProtocolCode, Player, Binary); 
 %% 2501 - 3000 ( 物品/打造/强化 )
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_MAKE_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_STRENGTHEN) of
		 ?CONST_TRUE ->
			 make_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 %% 3001 - 3500 ( 任务 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_TASK_END ->
	case is_funs_api:check_fun(?CONST_FUNC_OPEN_MAIN_TASK) of
		 ?CONST_TRUE ->
			 task_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
	
	 
 %% 3501 - 4000 ( 组队系统 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_TEAM_END -> 
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_TEAM) of
		 ?CONST_TRUE ->
			 team_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %% 4001 - 4500 ( 好友 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_FRIEND_END ->
	case is_funs_api:check_fun(?CONST_FUNC_OPEN_FRIEND) of
		 ?CONST_TRUE ->
			 friend_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
	
	 
 %% 5001 - 6000 ( 场景 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_SCENE_END ->
	 scene_gateway:gateway(ProtocolCode, Player, Binary);
 %% 6001 - 6500 ( 战斗 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_WAR_END ->
	 war_gateway:gateway(ProtocolCode, Player, Binary);
 %% 6501 - 7000 ( 技能 )
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_SKILL_END ->
	 skill_gateway:gateway(ProtocolCode, Player, Binary);
 %% 7001 - 8000 ( 副本 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_COPY_END ->
	 copy_gateway:gateway(ProtocolCode, Player, Binary);
 %% 8501 - 9000 ( 邮件 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_MAIL_END ->
	 mail_gateway:gateway(ProtocolCode, Player, Binary);
 %% 9001 - 9500 ( 防沉迷 )
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_FCM_END ->
	 fcm_gateway:gateway(ProtocolCode, Player, Binary);
 %% 9501 - 10000 ( 聊天 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_CHAT_END ->
	case is_funs_api:check_fun(?CONST_FUNC_OPEN_CHATTING) of
		 ?CONST_TRUE ->
			 chat_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
	
	 
 %% 10001 - 10100 ( 祝福 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_WISH_END ->
	 wish_gateway:gateway(ProtocolCode, Player, Binary);
 %% 10701 - 11000 ( 称号 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_TITLE_END ->
	 title_gateway:gateway(ProtocolCode, Player, Binary);
 %% 12101 - 12200 ( 坐骑 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_MOUNT_END ->
	 %% 	{?ok,Player};
	 mount_gateway:gateway(ProtocolCode, Player, Binary);
 %% 14001 - 18000 ( 阵营 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_COUNTRY_END ->
	 country_gateway:gateway(ProtocolCode, Player, Binary);
 %% 18001 - 18100 ( 钓鱼 )
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_FISHING_END ->  
	 fishing_gateway:gateway(ProtocolCode, Player, Binary);
 %% 18101 - 19100 ( 荣誉 )
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_HONOR_END ->
	 honor_gateway:gateway(ProtocolCode, Player, Binary);
 %% 21101 - 22100 ( 家族 ) (费除,移到下面相应模块)
 %%gateway(ProtocolCode, Player, Binary)
 %%  when ProtocolCode =< ?P_CLAN_END ->
 %%	clan_gateway:gateway(ProtocolCode, Player, Binary);
 %% 21101 - 21500 ( 保卫经书 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_DEFEND_BOOK_END ->
	 defend_book_gateway:gateway(ProtocolCode, Player, Binary);
 %% 22101 - 22200 ( 声望 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_RENOWN_END ->
	 renown_gateway:gateway(ProtocolCode, Player, Binary);
 %% 22201 - 22700 ( 福利 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_WELFARE_END -> 
	 welfare_gateway:gateway(ProtocolCode, Player, Binary);
 %% 22701 - 22800 ( 日志 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_GAME_LOGS_END -> 
	 game_logs_gateway:gateway(ProtocolCode, Player, Binary);
 %% 22801 - 23800 ( 宠物 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_PET_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_DEVIL) of
		 ?CONST_TRUE ->
			 pet_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 
 %% 23801 - 24800 ( 封神台 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_ARENA_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_LISTS) of
		 ?CONST_TRUE ->
			 arena_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %% 24801 - 24900 ( 排行榜 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_TOP_END -> 
	 top_gateway:gateway(ProtocolCode, Player, Binary); 
 %% 24901 - 24999 ( 新手卡 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_CARD_END -> 
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_ELIMINATE) of
		 ?CONST_TRUE ->
			 card_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %% 26000 - 26999 ( NPC )
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_NPC_END -> 
	 npc_gateway:gateway(ProtocolCode, Player, Binary);
 %% 28000 - 29000 ( 布阵 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_ARRAY_END -> 
	 array_gateway:gateway(ProtocolCode, Player, Binary);
 %% 30501 - 31000 ( 活动面板 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_ACTIVITY_END ->
	 active_gateway:gateway(ProtocolCode, Player, Binary);
 %% 31001 - 32000 ( 客栈 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_INN_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_PARTNER) of
		 ?CONST_TRUE ->
			 inn_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %% 32001 - 33000 ( 财神 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_WEAGOD_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_MONEYTREE) of
		 ?CONST_TRUE ->
			 weagod_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %% 33001 - 34000 ( 帮派 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_CLAN_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_GUILD) of
		 ?CONST_TRUE ->
			 clan_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 %% 34001 - 34500 ( 龙宫寻宝 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_DRAGON_END ->
	 dragon_gateway:gateway(ProtocolCode, Player, Binary);
 %% 34501 - 35000 ( 店铺 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_SHOP_END ->
	 mall_gateway:gateway(ProtocolCode, Player, Binary);
 %% 35001 - 36000 ( 苦工 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_MOIL_END ->
	 moil_gateway:gateway(ProtocolCode, Player, Binary);
 %% 35001 - 36000 ( 三界杀 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_CIRCLE_END ->
	 circle_gateway:gateway(ProtocolCode, Player, Binary);
 %% 37001 - 38000 ( 世界BOSS )  
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_WORLD_BOSS_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_BOSS) of
		 ?CONST_TRUE ->
			 world_boss_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %% 38001-39000 ( 目标任务) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_TARGET_END ->
	 target_gateway:gateway(ProtocolCode, Player, Binary);
 %% 39001-40000 (取经之路 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_HERO_END ->
	 hero_gateway:gateway(ProtocolCode, Player, Binary);
 %% 40001 - 40500 (签到)
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_SIGN_END -> 
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_INLAY) of
		 ?CONST_TRUE ->
			 sign_gateway:gateway(ProtocolCode, Player, Binary); 
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %% 40501-41500 (天宫之战 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_SKYWAR_END ->
	 skywar_gateway:gateway(ProtocolCode, Player, Binary);
 %% 41501-42500 (年兽 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_NIANSHOU_END -> 
	 nianshou_gateway:gateway(ProtocolCode, Player, Binary); 
 %% 42501-43500 (收集卡片 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_COLLECT_CARD_END ->
	 collect_gateway:gateway(ProtocolCode, Player, Binary);
 %% 43501 - 44500 ( 跨服战 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_STRIDE_END ->
	 stride_gateway:gateway(ProtocolCode, Player, Binary);
 %% (44501-44600) (御前科举)
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_KEJU_END ->
	 keju_gateway:gateway(ProtocolCode, Player, Binary);
 %% (44601-45600) (阎王殿)
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_KINGHELL_END ->
	 kinghell_gateway:gateway(ProtocolCode, Player, Binary);
 %% 45601 - 46000 ( 活动-阵营战 )
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_CAMPWAR_END ->
	 camp_war_gateway:gateway(ProtocolCode, Player, Binary);
 %% 46001 - 46200 (幸运转盘)
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_WHEEL_END ->
	 wheel_gateway:gateway(ProtocolCode, Player, Binary);
 %% 46201 - 47200 (魔王副本)
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_FIEND_END ->
	 fiend_gateway:gateway(ProtocolCode, Player, Binary);
 
 %% 47201 - 48200 (藏宝阁系统) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_TREASURE_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_JEWELLERY) of
		 ?CONST_TRUE ->
			 treasure_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %% 48201 - 49200 ( 斗气系统 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_SYS_DOUQI_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_STAR) of
		 ?CONST_TRUE ->
			 douqi_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %% 49201-50200 ( 日常任务系统 ) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_DAILY_TASK_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_STRENGTH) of
		 ?CONST_TRUE ->
			 task_daily_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 
 %% 50201-51200 (风林山火) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_FLSH_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_GAMBLE) of
		 ?CONST_TRUE ->
			 flsh_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %% 51201-52200 (每日一箭)
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_SHOOT_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_WEAPON) of
		 ?CONST_TRUE ->
			 shoot_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 
 %% 52201-53200 (神器)
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_MAGIC_EQUIP_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_ARTIFACT) of
		 ?CONST_TRUE ->
			 magic_equip_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;
 
 %%　投资理财(53201-54200) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_PRIVILEGE_END ->
	 privilege_gateway:gateway(ProtocolCode, Player, Binary);
 
 %%　社团BOSS(54201-54800) 
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_CLAN_BOSS_END ->
	 clan_boss_gateway:gateway(ProtocolCode, Player, Binary);
 
 %% 54801-55800(格斗之王)
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_WRESTLE_END ->
	 wrestle_gateway:gateway(ProtocolCode, Player, Binary);
 
 %% 55801-56800 (拳皇生涯)
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_FIGHTERS_END ->
	 case is_funs_api:check_fun(?CONST_FUNC_OPEN_OVERCOME) of
		 ?CONST_TRUE ->
			 fighters_gateway:gateway(ProtocolCode, Player, Binary);
		 _ ->
			 BinMsg = system_api:msg_error(?ERROR_KOF_TIPS_CLOSE_FUN),
			 app_msg:send(Player#player.socket, BinMsg),
			 {?ok,Player}
	 end;	
 
 %% 系统设置(56801-57800)
 gateway(ProtocolCode, Player, Binary)
   when ProtocolCode =< ?P_SYS_SET_END ->
	 sys_set_gateway:gateway(ProtocolCode, Player, Binary);
 
 %% 默认处理
 gateway(ProtocolCode, Player, Binary)->
	 ?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	 {?ok, Player}.
