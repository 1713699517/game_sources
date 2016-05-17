%% ===============ETS表名=======================
-define(ETS_S_INDEX,			ets_s_index). 		%% 索引
-define(ETS_S_CONFIG,			ets_s_config).		%% 配制
-define(ETS_S_GLOBAL,			ets_s_global).		%% 全局状态

%%================管理ets表====================
%% 管理节点(Master节点)
-define(ETS_MASTER_NODE_SERV,		ets_master_node_serv).		%% 现在开启的游戏节点数据
-define(ETS_MASTER_NODE_SERV_ALL,	ets_master_node_serv_all).	%% 现在开启的游戏节点数据(全部 不删)
-define(ETS_MASTER_NODE_SUPER,		ets_master_node_super).		%% 现在开启的跨服节点数据

%%================压力测试ets表====================
%% 压力测试(压力节点)
-define(ETS_TEST_ONLINE,		ets_test_online).		%% 压力机器机在线数据

%%================跨服战ets表====================
%% 跨服(超级节点)
-define(ETS_U_NODE,				ets_u_node). 	            %% 服务器 节点名
-define(ETS_U_DATA_SIGN,		ets_u_data_sign). 	        %% 各服务器的报名数据
-define(ETS_U_RANK_SUPER,		ets_u_rank_super). 	        %% 所有玩家排名数据
-define(ETS_U_STRIDE_GROUP,		ets_u_stride_group).	    %% 当前服务器跨服挑战数据
-define(ETS_U_WAR_SUPERIOR,		ets_u_war_superior).	    %% 巅峰之战挑战数据
%% 本地节点
-define(ETS_WAR_SUPER_GLOBAL,	ets_war_super_global).		%% 全局状态
-define(ETS_WAR_SUPER,			ets_war_super).	 			%% 玩家常规挑战数据
-define(ETS_WAR_SUPER_LOGS,		ets_war_logs).				%% 三界争霸战报日志
-define(ETS_WAR_SUPER2,			ets_war_super2).			%% 玩家越级挑战数据
-define(ETS_WAR_SUPERIOR_DATA,	ets_war_superior_data).		%% 参加巅峰之战
-define(ETS_WAR_SUPERIOR_LOGS,	ets_war_superior_logs).		%% 巅峰之战报日志

%% ===============ETS表名=======================
-define(ETS_M_MAIL,				ets_m_mail).		%% 邮件数据
-define(ETS_M_NOTICE,			ets_m_notice).		%% 全服公告
-define(ETS_M_LOGS,				ets_m_logs).		%% 离线日志记录

-define(ETS_ONLINE,				ets_online).		%% 在线玩家 
-define(ETS_OFFLINE,			ets_offline).		%% 玩家离线数据（每分钟清一次15分钟没有读的数据）
-define(ETS_OFFLINE_SUB,		ets_offline_sub).	%% 玩家离线数据（每分钟清一次15分钟没有读的数据）

-define(ETS_TASK,				ets_task).		%% 玩家任务数据
-define(ETS_GOODS,				ets_goods).		%% 玩家物品数据
-define(ETS_SCENE,				ets_scene).		%% 场景状态数据
-define(ETS_MAP_PLAYER,			ets_map_player).%% 场景玩家数据
-define(ETS_COPY,				ets_copy).		%% 副本状态数据

-define(ETS_TEAM,				ets_team).		%% 组队
-define(ETS_PET,				ets_pet).		%% 庞物
-define(ETS_FRIEND,				ets_friend).	%% 好友
-define(ETS_GOODS_BUFF,			ets_goods_buff).%% 使用物品得到Buff(取经之路有效)
-define(ETS_COPYSAVE,			ets_copysave).	%% 玩家副本数据
-define(ETS_COPYREWARD,			ets_copyreward).%% 副本奖励数据
-define(ETS_HEROSAVE,			ets_herosave).	%% 英雄副本数据
-define(ETS_FIENDSAVE,			ets_fiendsave).	%% 魔王副本数据
-define(ETS_PILBEST,			ets_pilbest).	%% 取经之路最佳记录保存
-define(ETS_BLACK_SHOP_BUY,		ets_black_shop_buy).%% 取经之路最佳记录保存

-define(ETS_ARENA,				ets_arena).			%% 竞技场
-define(ETS_ARENA_DATA,			ets_arena_data).	%% 竞技场数据
-define(ETS_ARENA_REWARD,		ets_arena_reward).	%% 竞技场奖励
-define(ETS_WAR_DATAS,			ets_war_datas).		%% 战斗数据


-define(ETS_CLAN_PUBLIC,		ets_clan_public).	%% 帮会功能公共数据
-define(ETS_CLAN_MEMBER,		ets_clan_member).	%% 帮会成员
-define(ETS_CLAN_CAT,			ets_clan_cat).		%% 帮会活动-招财猫
-define(ETS_CLAN_BOSS_PUB,		ets_clan_boss_pub). %% 帮派BOSS公共数据
-define(ETS_CLAN_BOSS_RANK,		ets_clan_boss_rank).%% 帮派BOSS排行榜

%% -define(ETS_CLAN_WAR_ROLE,		ets_clan_war_role).	%% 帮派战玩家数据		
%% -define(ETS_CLAN_WAR_RECS,		ets_clan_war_recs). %% 帮派战战报记录数据
%% -define(ETS_CLAN_BOSS_TIME,     ets_clan_boss_time).	%% 各帮派开始结束时间
%% -define(ETS_SKY_WAR_CLAN,		ets_sky_war_clan).	%% 天宫之战帮派积分相关
%% -define(ETS_SKY_WAR_ROLE,		ets_sky_war_role).	%% 天宫之战玩家数据

-define(ETS_MAKE_WASH,			ets_make_wash).		%% 装备洗练			
-define(ETS_MOIL_DATA,			ets_moil_data).		%% 苦工日志
-define(ETS_MOIL_WORKER,		ets_moil_worker).	%% 苦工工作
-define(ETS_CIRCLE,				ets_circle).		%% 苦工工作

-define(ETS_GOODS_OUTPUT_MAX,	ets_goods_output_max). 	%% 控制随机物品产出数量
-define(ETS_WORLD_BOSS,			ets_world_boss).		%% 打boss排行
-define(ETS_MALL_BUY_MAX,       ets_mall_buy_max).		%% 商城

-define(ETS_WELFARE,			ets_welfare).		    %% 在线奖励(福利)
-define(ETS_ONLINE_REWARD,      ets_online_reward). 	%% 在线时间奖励
-define(ETS_ONLINE_REWAD_LV,    ets_online_reward_lv). 	%% 在线等级奖励 

-define(ETS_PUBLIC_RECORDS,		ets_public_records).	%% 活动公共数据-私

-define(ETS_ACTIVE_STATE,		ets_active_state).		%% 所有活动状态
-define(ETS_ACTIVE_TODAY_DATA,	ets_active_today_data).	%% 当日活动数据

-define(ETS_CAMPWAR_RANK,		ets_camp_rank).			%% 阵营战排行榜数据
-define(ETS_DEFEND_RANK,		ets_defend_rank).		%% 保卫经书排行榜数据
-define(ETS_DEFEND_MONSTERS,	ets_defend_monster).	%% 保卫经书行走怪物

-define(ETS_KEJU_RANK,			ets_keju_rank).		    %% 科举排行榜数据
-define(ETS_TREASURE_STORE,     ets_treasure_store).    %% 藏宝阁
-define(ETS_NIAN_SHOU,			ets_nian_shou).         %% 年兽

-define(ETS_TIMES_GOODS_LOGS,	ets_times_goods_logs). %% 次数物品日志(鞭炮)
-define(ETS_TIMES_GOODS_LOGS2,	ets_times_goods_logs2). %% 次数物品日志(元宵)
-define(ETS_TIMES_GOODS_LOGS3,	ets_times_goods_logs3). %% 清明祭祖活动

-define(ETS_SALES_TIME,			ets_sales_time).     	%% 精彩活动表
-define(ETS_STRIDE_WISH_LOSG,	ets_stride_wish_logs).  %% 许愿日志
-define(ETS_KINGHELL,			ets_kinghell).			%% 阎王殿
-define(ETS_WHEEL_LOG,			ets_wheel_log).			%% 幸运转盘日志	
-define(ETS_WHEEL_TIMES,		ets_wheel_times).		%% 幸运转盘次数
-define(ETS_ENERGY,             ets_energy).            %% 精力系统
-define(ETS_SHOOT,              ets_shoot).             %% 每日一箭公共数据

-define(ETS_WRESTLE,            ets_wrestle).           %% 格斗之王
-define(ETS_WRESTLE_FINAL,      ets_wrestle_final).     %% 格斗之王匹配分组情况
-define(ETS_WRESTLE_GUESS,      ets_wrestle_guess).     %% 格斗之王竞猜情况
-define(ETS_WRESTLE_CONTROL,    ets_wrestle_control).   %% 格斗之王活动控制

-define(ETS_TOP_NGC,      	    ets_top_ngc).           %% TOP总表
-define(ETS_TOP_TYPE,           ets_top_type).          %% TOP分类表

-define(ETS_DISCOUNT_SHOP,      ets_discount_shop).     %% 打折商城记录表

%% ================ 进程字典关键字 ================== 
-define(PROC_CLAN_OFFLINE, 		proc_clan_offline). 	%% 帮派战离线胜出组玩家地图数据
-define(PROC_CLAN_WAR_RECS,		proc_clan_war_recs).	%% 帮派战战报记录数据
-define(PROC_CLAN_LV,			proc_clan_lv).			%% 帮派等级(帮派等级)

-define(PROC_SKYWAR_BOSS,		proc_skywar_boss).		%% 天宫之战boss数据
-define(PROC_SKYWAR_BUFF_TIME,  proc_skywar_buff_time). %% 天宫之战缓存倒计时消息包

-define(PROC_WHEEL_MSG,			proc_wheel_msg).		%% 幸运转盘消息

-define(PROC_USER_FCM,			proc_user_fcm).				%% 防沉迷/定时写数据库
-define(PROC_USER_ATTR_GROUP,	proc_user_attr_group).		%% 角色属性集合
-define(PROC_USER_INFO,			proc_user_info).			%% 基本信息
-define(PROC_USER_FRIEND,		proc_user_friend).			%% 社交系统
-define(PROC_USER_EQUIP,		proc_user_equip).			%% 装备
-define(PROC_USER_WARP,			proc_user_war_p).			%% 战斗/技能 #war_p{}
-define(PROC_USER_SKILL_Lv,     proc_user_skill_lv).        %% 技能#skill_lv{}
-define(PROC_USER_SKILL_MSG,    proc_user_skill_msg).       %% 技能#skill_msg{}
-define(PROC_USER_MOUNT,		proc_user_mount).			%% 坐骑#mount{}
-define(PROC_USER_WEAGOD,		proc_user_weagod).			%% 财神#weagod{}
-define(PROC_USER_INN,			proc_user_inn).				%% 客栈
-define(PROC_USER_ARENA,		proc_user_arena).			%% 竞技场
-define(PROC_USER_NIANSHOU,		proc_user_nianshou).		%% 年兽
-define(PROC_USER_DEFEND_BOOK,	proc_user_defend_book).		%% 保卫经书
-define(PROC_USER_CLAN_BOSS,	proc_user_clan_boss).		%% 帮派心魔
-define(PROC_USER_WORLD_BOSS,	proc_user_world_boss).		%% 世界Boss
-define(PROC_USER_BAG,			proc_user_bag).				%% 背包
-define(PROC_USER_DEPOT,		proc_user_depot).			%% 仓库
-define(PROC_USER_TASKS,		proc_user_tasks).			%% 任务#tasks{}
-define(PROC_USER_TREASURE,     proc_user_treasure).        %% 藏宝阁系统
-define(PROC_USER_STORE,        proc_user_store).           %% 商店系统
-define(PROC_USER_RENOWN,		proc_user_renown).			%% 声望 #renown{} 
-define(PROC_USER_ENERGY,		proc_user_energy).			%% 精力 #energy{}
-define(PROC_USER_DATA_CLAN,	proc_user_data_clan).		%% 家族 
-define(PROC_USER_CLAN_CAT,		proc_user_clan_cat).		%% 帮派招财猫
-define(PROC_USER_DATA_BUFF,	proc_user_data_buff).		%% 状态数据元组列表{Type,Start,Remain,Value,Icon}	如:双倍等经验
-define(PROC_USER_UPCOPY,		proc_user_upcopy).			%% 副本挂机信息
-define(PROC_USER_COPY,			proc_user_copy).			%% 普通副本章节信息
-define(PROC_USER_HERO,			proc_user_hero).			%% 英雄副本章节信息
-define(PROC_USER_FIEND,		proc_user_fiend).			%% 魔王副本章节信息
-define(PROC_USER_FIGHTERS,		proc_user_fighters).		%% 拳皇生涯
-define(PROC_USER_FLSH,			proc_user_flsh).			%% 风林山火
-define(PROC_USER_SYS,			proc_user_sys).				%% 任务开放系统
-define(PROC_USER_USE_COUNT,	proc_user_use_count).		%% 各种限定时间内限定使用次数事件,[{Type,Date,[{TypeSub,Count},...]},....]
-define(PROC_USER_TARGRT,		proc_user_target).			%% 目标任务数据
-define(PROC_USER_WELFARE,		proc_user_welfare).			%% 福利
-define(PROC_USER_PET,			proc_user_pet).				%% 宠物
-define(PROC_USER_HONOR,		proc_user_honor).			%% 荣誉
-define(PROC_USER_CIRCLE,		proc_user_circle).			%% 三界杀
-define(PROC_USER_MONEY,        proc_user_money).           %% 玩家货币
-define(PROC_USER_VIP,			proc_user_vip).				%% VIP #vip{}
-define(PROC_USER_SIGN,			proc_user_sign).			%% 签到 #sign{}
-define(PROC_USER_PRIVILEGE,	proc_user_privilege).		%% 新手特权 #privilege{}
-define(PROC_USER_SALES,		proc_user_sales).			%% 精彩活动(促销)
-define(PROC_USER_BUFF,			proc_user_buff).			%% 各种buff
-define(PROC_USER_TIMES_GOODS,	proc_user_times_goods).		%% 使用物品次数(隔天重置)
-define(PROC_USER_ONCE_GOODS,	proc_user_once_goods).		%% 购买一次物品(只能购买一次)
-define(PROC_USER_FISHING,		proc_user_fishing).			%% 钓鱼数据
-define(PROC_USER_STRIDE,		proc_user_stride).			%% 跨服战
-define(PROC_USER_DRAGON,		proc_user_dragon).			%% 龙宫寻宝
-define(PROC_USER_CAMP_WAR,		proc_user_camp_war).		%% 阵营战 
-define(PROC_USER_ENCHANT,		proc_user_enchant).			%% 附魔次数
-define(PROC_USER_DOUQI,		proc_user_douqi).			%% 斗气
-define(PROC_USER_DAILY_TASK,	proc_user_daily_task).	    %% 日常任务
-define(PROC_USER_SHOOT,	    proc_user_shoot).	        %% 每日一箭
-define(PROC_USER_LINK,	    	proc_user_link).	        %% 活动入口，玩家活跃度
-define(PROC_USER_SYS_SET,	    proc_user_sys_set).	        %% 活动入口，玩家活跃度
-define(PROC_USER_TITLE,	    proc_user_title).	        %% 玩家称号
-define(PROC_USER_MALL_SHOP,    proc_user_mall_shop).       %% 玩家优惠商店


% 所有PROC_USER进程字典												
-define(PROC_USER,[
%     								{Player2,Data} = role_api:init_player_attr(Player),			EnData = role_api:encode_attr(Data)				role_api:decode_attr(EnData),					DeData = role_api_dict:fcm_get(),					role_api_dict:fcm_set(Data),
%1*20		proc					init_mod					init_fun						encode_mod					encode_fun,			decode_mod					decode_fun			dictget_mod				dictget_fun					dictset_mod					dictset_fun	
	{proc_ud,?PROC_USER_FCM,		?null,					    ?null,				            ?null,						?null,				?null,						?null,				role_api_dict,			fcm_get,					role_api_dict,				fcm_set},
	{proc_ud,?PROC_USER_ATTR_GROUP, role_api,					init_attr_group,				?null,						?null,				?null,						?null,				role_api_dict,			attr_group_get,				role_api_dict,			    attr_group_set},
	{proc_ud,?PROC_USER_EQUIP,      bag_api,					init_equip,					bag_api,						encode_equip,		bag_api,						decode_equip,		role_api_dict,			equip_get,					role_api_dict,				equip_set},
	{proc_ud,?PROC_USER_MOUNT, 		?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			mount_get,					role_api_dict,				mount_set},
	{proc_ud,?PROC_USER_WEAGOD,		weagod_api,					init,							weagod_api,				encode_weagod,		weagod_api,					decode_weagod,		role_api_dict,			weagod_get,					role_api_dict,				weagod_set},
	{proc_ud,?PROC_USER_INN, 		inn_api,					init,							inn_api,					encode_inn,			inn_api,					decode_inn,			role_api_dict,			inn_get,					role_api_dict,				inn_set},
	{proc_ud,?PROC_USER_ARENA, 		arena_api,					init,							arena_api,					encode_arena,		arena_api,					decode_arena,		role_api_dict,			arena_get,					role_api_dict,				arena_set},
	{proc_ud,?PROC_USER_BAG, 		bag_api,					init_bag,						bag_api,					encode_bag,			bag_api,					decode_bag,			role_api_dict,			bag_get,					role_api_dict,				bag_set},
	{proc_ud,?PROC_USER_DEPOT,		?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			depot_get,					role_api_dict,				depot_set},
	{proc_ud,?PROC_USER_TASKS,		task_api,				    init,							task_api,					encode_task,		task_api,				    decode_task,		role_api_dict,			tasks_get,					role_api_dict,				tasks_set},
 	{proc_ud,?PROC_USER_UPCOPY, 	copy_api,					init_upcopy,						copy_api,					encode_upcopy,		copy_api,					decode_upcopy,		role_api_dict,			upcopy_get,					role_api_dict,				upcopy_set},
	{proc_ud,?PROC_USER_COPY, 		copy_api,					init_chapcopy,					copy_api,					encode_chapcopy,	copy_api,					decode_chapcopy,	role_api_dict,			copy_get,					role_api_dict,				copy_set},
 	{proc_ud,?PROC_USER_HERO, 		hero_api,					init,							hero_api,					encode_hero,		hero_api,					decode_hero,		role_api_dict,			hero_get,					role_api_dict,				hero_set},
	{proc_ud,?PROC_USER_FIEND, 		fiend_api,					init,							fiend_api,					encode_fiend,		fiend_api,					decode_fiend,		role_api_dict,			fiend_get,					role_api_dict,				fiend_set},
	{proc_ud,?PROC_USER_FLSH, 		flsh_api,					init,							flsh_api,					encode_flsh,		flsh_api,					decode_flsh,		role_api_dict,			flsh_get,					role_api_dict,				flsh_set},
 	{proc_ud,?PROC_USER_DATA_CLAN, 	clan_api,					init_clan,						clan_api,					encode_clan,		clan_api,					decode_clan,		role_api_dict,			clan_get,					role_api_dict,				clan_set},
    {proc_ud,?PROC_USER_DAILY_TASK, task_daily_api,             init,                           task_daily_api,             encode_daily,       task_daily_api,             decode_daily,       role_api_dict,          task_daily_get,             role_api_dict,              task_daily_set},
	{proc_ud,?PROC_USER_SKILL_MSG, 	skill_api,					init,							skill_api,					encode_skill_user,	skill_api,					decode_skill_user,	role_api_dict,			skill_user_get,				role_api_dict,				skill_user_set},
	{proc_ud,?PROC_USER_TREASURE, 	treasure_api,				init,							treasure_api,				encode_treasure,    treasure_api,               decode_treasure,    role_api_dict,			treasure_get,				role_api_dict,              treasure_set},
	{proc_ud,?PROC_USER_ENERGY,		energy_api,					init,							energy_api,					encode_energy,		energy_api,					decode_energy,		role_api_dict,			energy_get,					role_api_dict,				energy_set},

%2*20		proc					init_mod						init_fun							encode_mod					encode_fun,			decode_mod					decode_fun			dictget_mod				dictget_fun					dictset_mod					dictset_fun
	{proc_ud,?PROC_USER_ENCHANT,	make_api,				    init,							make_api,					encode_make,		make_api,					decode_make,		role_api_dict,			make_get,					role_api_dict,				make_set},
	{proc_ud,?PROC_USER_WORLD_BOSS, world_boss_api,				init,							world_boss_api,				encode_world_boss,	world_boss_api,				decode_world_boss,	role_api_dict,			world_boss_get,				role_api_dict,				world_boss_set},
	{proc_ud,?PROC_USER_SYS,		role_api,				    init_sys,						role_api,					encode_sys,			role_api,					decode_sys,			role_api_dict,			sys_get,					role_api_dict,				sys_set},
	{proc_ud,?PROC_USER_DOUQI,		douqi_api,					init_douqi,						douqi_api,					encode_douqi,		douqi_api,					decode_douqi,		role_api_dict,			douqi_get,   				role_api_dict,				douqi_set},	
	{proc_ud,?PROC_USER_SALES,		card_api,					init_sales,						card_api,					encode_sales,		card_api,					decode_sales,		role_api_dict,			sales_get,					role_api_dict,				sales_set},
	{proc_ud,?PROC_USER_SHOOT, 		shoot_api,					init,							shoot_api,					encode_shoot,		shoot_api,					decode_shoot,		role_api_dict,			shoot_get,					role_api_dict,				shoot_set},
	{proc_ud,?PROC_USER_SIGN,		sign_api,					init,							sign_api,				    encode_sign,		sign_api,					decode_sign,		role_api_dict,			sign_get,					role_api_dict,				sign_set},
	{proc_ud,?PROC_USER_FRIEND,		friend_api,					init,					        friend_api,				    encode_friend,		friend_api,					decode_friend,		role_api_dict,			friend_get,					role_api_dict,				friend_set},
	{proc_ud,?PROC_USER_PET, 		pet_api,					init,						    pet_api,					encode_pet,			pet_api,					decode_pet,			role_api_dict,			pet_get,				    role_api_dict,			    pet_set},
	{proc_ud,?PROC_USER_SYS_SET,	sys_set_api,				init,							sys_set_api,				encode_sys_set,		sys_set_api,   			    decode_sys_set,		role_api_dict,		    sys_set_get,				role_api_dict,			    sys_set_set},
	{proc_ud,?PROC_USER_PRIVILEGE,	privilege_api,				init,							privilege_api,				encode_privilege,	privilege_api,				decode_privilege,	role_api_dict,			privilege_get,				role_api_dict,				privilege_set},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			dragon_get,					role_api_dict,				dragon_set},
	{proc_ud,?null,					?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			renown_get,					role_api_dict,				renown_set},
	{proc_ud,?null,					?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			renown_get,					role_api_dict,				renown_set},
	{proc_ud,?null,					?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			clan_get,					role_api_dict,				clan_set},
	{proc_ud,?null, 				?null,					    ?null,							?null,						?null,				?null,						?null,				role_api_dict,			buff_get,					role_api_dict,				buff_set},
	{proc_ud,?null, 				?null,					   ?null,							?null,						?null,				?null,						?null,				role_api_dict,			nianshou_get,				role_api_dict,				nianshou_set},
	{proc_ud,?null,					?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			defend_book_get,			role_api_dict,				defend_book_set},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			clan_boss_get,				role_api_dict,				clan_boss_set},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			world_boss_get,				role_api_dict,				world_boss_set},
	
%3*20		proc					init_mod						init_fun							encode_mod					encode_fun,			decode_mod					decode_fun			dictget_mod				dictget_fun					dictset_mod					dictset_fun
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			war_p_get,					role_api_dict,				war_p_set},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			matrix_get,					role_api_dict,				matrix_set},
	{proc_ud,?null, 					?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			matrix_get,					role_api_dict,				matrix_set},
	{proc_ud,?PROC_USER_SHOOT, 		?null,						?null,							?null,						?null,				?null,						?null,				role_api_dict,			shoot_get,					role_api_dict,						?null},
	{proc_ud,?PROC_USER_CLAN_CAT,	clan_active_api,			init_clan_cat,					clan_active_api,			encode_clan_cat,	clan_active_api,			decode_clan_cat,	role_api_dict,			clan_cat_get,				role_api_dict,				clan_cat_set},
	{proc_ud,?PROC_USER_FIGHTERS, 	fighters_api,				init,							fighters_api,				encode_fighters,	fighters_api,				decode_fighters,	role_api_dict,			fighters_get,				role_api_dict,				fighters_set},
	{proc_ud,?PROC_USER_LINK, 		active_api,					init_link,						active_api,					encode_link,		active_api,					decode_link,		role_api_dict,			link_get,					role_api_dict,				link_set},
	{proc_ud,?PROC_USER_TITLE, 		title_api,					init_title,						title_api,					encode_title,		title_api,					decode_title,		role_api_dict,			title_get,					role_api_dict,				title_set},
	{proc_ud,?PROC_USER_MALL_SHOP,  mall_api,                   init,                           mall_api,                   encode_mall,        mall_api,                   decode_mall,        role_api_dict,          mall_shop_get,              role_api_dict,              mall_shop_set},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},

%4*10		proc					init_mod						init_fun							encode_mod					encode_fun,			decode_mod					decode_fun			dictget_mod				dictget_fun					dictset_mod					dictset_fun
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null},
	{proc_ud,?null, 				?null,						?null,							?null,						?null,				?null,						?null,				?null,					?null,						?null,						?null}
] ).




-define(EQUIP_TYPE_LIST, 		[?CONST_GOODS_EQUIP,?CONST_GOODS_WEAPON,?CONST_GOODS_MAGIC]).
%% -define(EQUIP_TYPE_LIST, 		[?CONST_GOODS_EQUIP, ?CONST_GOODS_JEWELRY, ?CONST_GOODS_MAGIC]).
-define(EQUIP_WEAPON_TYPES, 	[?CONST_GOODS_EQUIP_WEAPON_GUN, ?CONST_GOODS_EQUIP_WEAPON_BOW, ?CONST_GOODS_EQUIP_WEAPON_STICK]).

-define(EQUIP_TYPE_RAND_TRUNC, 	[
%% 								 ?CONST_ATTR_HIT,?CONST_ATTR_DOD,?CONST_ATTR_CRIT,?CONST_ATTR_RES_CRIT,
%% 								 ?CONST_ATTR_PARRY,?CONST_ATTR_WRECK,?CONST_ATTR_MERGE,?CONST_ATTR_RES_ASK,
%% 								 ?CONST_ATTR_BONUS,?CONST_ATTR_REDUCTION
								 ]).

-define(EQUIP_POWER_CALC, 		[
%% 								 {#attr.strong_att, ?CONST_ATTR_STRONG_ATT, ?CONST_ATTR_SCORE_STRONG_ATT},
%% 								 {#attr.strong_def, ?CONST_ATTR_STRONG_DEF, ?CONST_ATTR_SCORE_STRONG_DEF},
%% 								 {#attr.magic_att,	?CONST_ATTR_MAGIC_ATT, ?CONST_ATTR_SCORE_MAGIC_ATT},
%% 								 {#attr.magic_def, 	?CONST_ATTR_MAGIC_DEF, ?CONST_ATTR_SCORE_MAGIC_DEF},
%% 								 {#attr.hp, 		?CONST_ATTR_HP_MAX, ?CONST_ATTR_SCORE_HP},
%% 								 {#attr.att_speed, 	?CONST_ATTR_SPEED_ATT, ?CONST_ATTR_SCORE_SPEED},
%% 								 {#attr.hit, 		?CONST_ATTR_HIT, ?CONST_ATTR_SCORE_HIT},
%% 								 {#attr.dod, 		?CONST_ATTR_DOD, ?CONST_ATTR_SCORE_DOD},
%% 								 {#attr.crit, 		?CONST_ATTR_CRIT, ?CONST_ATTR_SCORE_CRIT},
%% 								 {#attr.res_crit, 	?CONST_ATTR_RES_CRIT, ?CONST_ATTR_SCORE_RES_CRIT},
%% 								 {#attr.parry, 		?CONST_ATTR_PARRY, ?CONST_ATTR_SCORE_PARRY},
%% 								 {#attr.wreck, 		?CONST_ATTR_WRECK, ?CONST_ATTR_SCORE_WRECK},
%% 								 {#attr.merge, 		?CONST_ATTR_MERGE, ?CONST_ATTR_SCORE_MERGE},
%% 								 {#attr.res_ask, 	?CONST_ATTR_RES_ASK, ?CONST_ATTR_SCORE_RES_ASK},
%% 								 {#attr.sp, 		?CONST_ATTR_SP, ?CONST_ATTR_SCORE_SP}
								]).

%% 组队的位置
-define(TEAM_POS,				[1,2,3]).
%% 组队的类型
-define(TEAM_TYPES,				[?CONST_COPY_TYPE_NORMAL,?CONST_COPY_TYPE_HERO,?CONST_COPY_TYPE_FIEND]).
%% 牌的数字
-define(FLSH_NUM,				[1,2,3,4,5,6]).
%% 风林山火
-define(FLSH_LIST,				[1,2,4,5]).
%% 副本的类型
-define(COPY_TYPES,				[?CONST_COPY_TYPE_NORMAL,?CONST_COPY_TYPE_HERO,?CONST_COPY_TYPE_FIEND,?CONST_COPY_TYPE_FIGHTERS]).
%% 副本地图类型
-define(COPY_MAP_TYPES,			[?CONST_MAP_TYPE_COPY_NORMAL,?CONST_MAP_TYPE_COPY_HERO,?CONST_MAP_TYPE_COPY_FIEND,?CONST_MAP_TYPE_COPY_FIGHTERS,?CONST_MAP_TYPE_COPY_CLAN]).
%% 格斗之王
-define(GROUP_LIST,             [1,2,3,4,5,6,7,8]).

%% 控制随机物品产出数量 类型定义
%-define(ODDS_GOODS_MAX_GIFT,				1).		% 礼包、宝箱类物品类型
%-define(ODDS_GOODS_MAX_MONSTER,				1).		% 打怪、副本挂机怪物掉落类型	

%% =============== global key 全局变量主键名 =======================
-define(GLOBAL_LEVEL_MAX,					level_max).	% 当前人物最高等级	
-define(GLOBAL_TIMES_GOODS_LOGS,			times_goods_logs). % 次数物品使用日志(鞭炮)
-define(GLOBAL_TIMES_GOODS_LOGS2,			times_goods_logs2). % 次数物品使用日志(元宵)
-define(GLOBAL_TIMES_GOODS_LOGS3,			times_goods_logs3). % 清明祭祖活动
-define(GLOBAL_GOODS_MAX_INDEX,				goods_max_index).% 天宫之战守城方连续守城天数
-define(GLOBAL_MALL_BUY_MAX, 				mall_buy_max).	%% 商城购买数据
-define(GLOBAL_WHEEL_LOG,					wheel_log).		%% 幸运转盘日志	
-define(GLOBAL_WHEEL_TIMES,					wheel_times). 	%% 幸运转盘次数	

%/** **********************************************************************************
% *  Data数据
% ** ********************************************************************************** */
%/** AUTO_CODE_BEGIN_EDATA **************** don't touch this line ********************/
% /** =============================== 自动生成的代码 =============================== **/
-define(DATA_ACTIVE,                    	data_active).
-define(DATA_ACTIVE_LINK,               	data_active_link).
-define(DATA_ACTIVE_LINK_REWARDS,       	data_active_link_rewards).
-define(DATA_ACTIVE_MAIL,               	data_active_mail).
-define(DATA_ARENA,                     	data_arena).
-define(DATA_ARENA_REWARD,              	data_arena_reward).
-define(DATA_ARROW_DAILY_ITEMS,         	data_arrow_daily_items).
-define(DATA_ARROW_DAILY_ODDS,          	data_arrow_daily_odds).
-define(DATA_BAG,                       	data_bag).
-define(DATA_BATTLE_AI,                 	data_battle_ai).
-define(DATA_BATTLE_SPEED,              	data_battle_speed).
-define(DATA_BROADCAST,                 	data_broadcast).
-define(DATA_CLAN_ACTIVE_CAST,          	data_clan_active_cast).
-define(DATA_CLAN_BOSS_ATTR,            	data_clan_boss_attr).
-define(DATA_CLAN_BOSS_LV,              	data_clan_boss_lv).
-define(DATA_CLAN_BOSS_RELIVE,          	data_clan_boss_relive).
-define(DATA_CLAN_BOSS_REWARD,          	data_clan_boss_reward).
-define(DATA_CLAN_LEVEL,                	data_clan_level).
-define(DATA_CLAN_SKILL,                	data_clan_skill).
-define(DATA_CLAN_YQS_LV,               	data_clan_yqs_lv).
-define(DATA_COPY_CHAP,                 	data_copy_chap).
-define(DATA_COPY_REWARD,               	data_copy_reward).
-define(DATA_COPY_SCORE,                	data_copy_score).
-define(DATA_COPY_TIMES_PAY,            	data_copy_times_pay).
-define(DATA_ENERGY_BUY,                	data_energy_buy).
-define(DATA_EQUIP_ENCHANT,             	data_equip_enchant).
-define(DATA_EQUIP_MAKE,                	data_equip_make).
-define(DATA_EQUIP_STREN,               	data_equip_stren).
-define(DATA_FIGHT_GAS_GRASP,           	data_fight_gas_grasp).
-define(DATA_FIGHT_GAS_OPEN,            	data_fight_gas_open).
-define(DATA_FIGHT_GAS_TOTAL,           	data_fight_gas_total).
-define(DATA_FLSH_REWARD,               	data_flsh_reward).
-define(DATA_GOODS,                     	data_goods).
-define(DATA_GOODS_CATEGORY,            	data_goods_category).
-define(DATA_GOODS_SUIT_EQUIP,          	data_goods_suit_equip).
-define(DATA_HIDDEN_LINE,               	data_hidden_line).
-define(DATA_HIDDEN_MAKE,               	data_hidden_make).
-define(DATA_HIDDEN_STORE,              	data_hidden_store).
-define(DATA_HIDDEN_TREASURE,           	data_hidden_treasure).
-define(DATA_IS_FUN,                    	data_is_fun).
-define(DATA_MALL,                      	data_mall).
-define(DATA_PARTNER_INIT,              	data_partner_init).
-define(DATA_PARTNER_LV,                	data_partner_lv).
-define(DATA_PEARL_COM,                 	data_pearl_com).
-define(DATA_PET,                       	data_pet).
-define(DATA_PET_SKILL,                 	data_pet_skill).
-define(DATA_PLAYER_GROW,               	data_player_grow).
-define(DATA_PLAYER_GROW_TABLE,         	data_player_grow_table).
-define(DATA_PLAYER_INIT,               	data_player_init).
-define(DATA_PLAYER_INITIAL,            	data_player_initial).
-define(DATA_PLAYER_INIT_SOURCE,        	data_player_init_source).
-define(DATA_PLAYER_NAME,               	data_player_name).
-define(DATA_PLAYER_TALENT,             	data_player_talent).
-define(DATA_PLAYER_UP_EXP,             	data_player_up_exp).
-define(DATA_PRIVILEGE,                 	data_privilege).
-define(DATA_SALES_SUB,                 	data_sales_sub).
-define(DATA_SALES_TOTAL,               	data_sales_total).
-define(DATA_SCENE,                     	data_scene).
-define(DATA_SCENE_COPY,                	data_scene_copy).
-define(DATA_SCENE_DOOR,                	data_scene_door).
-define(DATA_SCENE_MONSTER,             	data_scene_monster).
-define(DATA_SCENE_NPC,                 	data_scene_npc).
-define(DATA_SCENE_SHOP,                	data_scene_shop).
-define(DATA_SIGN,                      	data_sign).
-define(DATA_SKILL,                     	data_skill).
-define(DATA_SKILL_START,               	data_skill_start).
-define(DATA_SYS_OPEN,                  	data_sys_open).
-define(DATA_SYS_SET,                   	data_sys_set).
-define(DATA_TASK,                      	data_task).
-define(DATA_TASK_DAILY,                	data_task_daily).
-define(DATA_TASK_DAILY_LV,             	data_task_daily_lv).
-define(DATA_VIP,                       	data_vip).
-define(DATA_VIPSIGN,                   	data_vipsign).
-define(DATA_WEAGOD,                    	data_weagod).
-define(DATA_WORLD_BOSS_ATTR,           	data_world_boss_attr).
-define(DATA_WORLD_BOSS_LV,             	data_world_boss_lv).
-define(DATA_WORLD_BOSS_RANK,           	data_world_boss_rank).
-define(DATA_WORLD_BOSS_RELIVE,         	data_world_boss_relive).
-define(DATA_WORLD_BOSS_REWARD,         	data_world_boss_reward).
-define(DATA_WRESTLE_FINAL,             	data_wrestle_final).
-define(DATA_WRESTLE_PRELIMINARY,       	data_wrestle_preliminary).
-define(DATA_WRESTLE_RANK,              	data_wrestle_rank).
% /** =============================== 自动生成的代码 =============================== **/
% /*************************** don't touch this line *********** AUTO_CODE_END_EDATA **/

%% =============== 自定义 ======================= 
-define(ATTR_TYPE_POS, [ 
						{?CONST_ATTR_SP,			#attr.sp			}, % 怒气
						{?CONST_ATTR_SP_UP,			#attr.sp_up			}, % 怒气恢复速度
						{?CONST_ATTR_ANIMA,			#attr.anima 		}, % 初始灵气值
						{?CONST_ATTR_HP,			#attr.hp			}, % 气血值
						{?CONST_ATTR_HP_GRO,		#attr.hp_gro        }, % 气血成长值
						{?CONST_ATTR_STRONG,		#attr.strong		}, % 力量
						{?CONST_ATTR_STRONG_GRO,	#attr.strong_gro	}, % 力量成长
						{?CONST_ATTR_MAGIC,			#attr.magic			}, % 智力
						{?CONST_ATTR_MAGIC_GRO,		#attr.magic_gro		}, % 智力成长
						{?CONST_ATTR_STRONG_ATT,	#attr.strong_att	}, % 物攻
						{?CONST_ATTR_STRONG_DEF,	#attr.strong_def	}, % 物防
						{?CONST_ATTR_SKILL_ATT,		#attr.skill_att		}, % 技能攻击
						{?CONST_ATTR_SKILL_DEF,		#attr.skill_def	 	}, % 技能防御
%% 						{?CONST_ATTR_HIT,			#attr.hit			}, % 命中值
%% 						{?CONST_ATTR_DOD,			#attr.dod			}, % 闪避值
						{?CONST_ATTR_CRIT,			#attr.crit			}, % 暴击值
						{?CONST_ATTR_RES_CRIT,		#attr.crit_res		}, % 抗暴
						{?CONST_ATTR_CRIT_HARM,		#attr.crit_harm		}, % 暴伤
						{?CONST_ATTR_DEFEND_DOWN,	#attr.defend_down	}, % 破甲
						{?CONST_ATTR_LIGHT,			#attr.light			}, % 光属性
						{?CONST_ATTR_LIGHT_DEF,		#attr.light_def		}, % 光抗性
						{?CONST_ATTR_DARK,			#attr.dark			}, % 暗属性
						{?CONST_ATTR_DARK_DEF,		#attr.dark_def		}, % 暗抗性
						{?CONST_ATTR_GOD,			#attr.god			}, % 灵属性
						{?CONST_ATTR_GOD_DEF,		#attr.god_def		}, % 灵抗性
						{?CONST_ATTR_BONUS,			#attr.bonus			}, % 伤害率
						{?CONST_ATTR_REDUCTION,		#attr.reduction		}, % 免伤率
						{?CONST_ATTR_IMM_DIZZ,		#attr.imm_dizz		}  % 免疫眩晕
					   ]).

%%　属性参数 跟记录保持一致
-define(ATTR_ARG,				{attr,
								 ?CONST_ATTR_SP,            % 怒气值
								 ?CONST_ATTR_SP_UP,			% 怒气回复速度
								 ?CONST_ATTR_ANIMA,			% 初始灵气值
								 ?CONST_ATTR_HP,		  	% 气血值
								 ?CONST_ATTR_HP_GRO,		% 气血成长值
								 ?CONST_ATTR_STRONG,		% 力量值
								 ?CONST_ATTR_STRONG_GRO,	% 力量成长值
								 ?CONST_ATTR_MAGIC,			% 灵力值
								 ?CONST_ATTR_MAGIC_GRO,		% 灵力攻击成长值
								 ?CONST_ATTR_STRONG_ATT,	% 力量物理攻击
								 ?CONST_ATTR_STRONG_DEF,	% 力量物理防御值
								 ?CONST_ATTR_SKILL_ATT,		% 技能攻击
								 ?CONST_ATTR_SKILL_DEF,		% 技能防御
								 ?CONST_ATTR_CRIT,			% 暴击值(万分比)
								 ?CONST_ATTR_RES_CRIT,		% 抗暴值(万分比)
								 ?CONST_ATTR_CRIT_HARM,     % 暴击伤害值(万分比)
								 ?CONST_ATTR_DEFEND_DOWN,	% 破甲值(万分比)
								 ?CONST_ATTR_LIGHT,			% 光属性(万分比)
								 ?CONST_ATTR_LIGHT_DEF,		% 光抗性(万分比)
								 ?CONST_ATTR_DARK,			% 暗属性(万分比)
								 ?CONST_ATTR_DARK_DEF,		% 暗抗性(万分比)
								 ?CONST_ATTR_GOD,			% 灵属性(万分比)
								 ?CONST_ATTR_GOD_DEF,		% 灵抗性(万分比)
								 ?CONST_ATTR_BONUS,			% 伤害系数(万分比)
								 ?CONST_ATTR_REDUCTION,		% 免伤系数(万分比)
								 ?CONST_ATTR_IMM_DIZZ		% 抗晕值(万分比)
								}).


-define(ATTR_EQUIPS,				[?CONST_EQUIP_WEAPON,?CONST_EQUIP_TORQUE,?CONST_EQUIP_RING,?CONST_EQUIP_BELT]).
-define(DEFT_EQUIPS,				[?CONST_EQUIP_ARMOR,?CONST_EQUIP_HAT,?CONST_EQUIP_LEG,?CONST_EQUIP_SHOE]).
-define(ROLE_PRO, [?CONST_PRO_SUNMAN,?CONST_PRO_ZHENGTAI,?CONST_PRO_ICEGIRL,
				   ?CONST_PRO_BIGSISTER,?CONST_PRO_LOLI,?CONST_PRO_MONSTER]).
-define(WORLD_BOSS_ACTIVE,       [?CONST_ACTIVITY_WORLD_BOSS,?CONST_ACTIVITY_WORLD_BOSS_TWO]).

%% 系统设置内容
-define(SYS_SET_STEP,				[101,102,103,104,105,106,107,108,109]). 

%% 天赋计算公式
-define(TALENT(Value,Arg),			trunc(Value*(1+Arg/?CONST_PERCENT))). 
%% 战斗相关公式
%% --------------------------------------------------
	
%% 实际命中率
%%    当攻击方命中率大于防御方闪避值时，必中
%%    当攻击方命中率小于防御方闪避率时，差值就是被攻击方闪避的几率
%%    闪避几率如果大于45%则等于45%计算
-define(EXPRESSION_WAR_REAL_HIT(OwnHitP,FoeDodgeP),				util:betweet(OwnHitP-FoeDodgeP,200,9800)).

	
%% 实际暴击率
%%    实际暴击率=自身暴击率-对方坚韧率
%%    当攻击方暴击率大于防御方坚韧率时，差值为实际暴击率
%%    实际暴击率，最小为5% 极限为50%，超过请返回95%值计算
-define(EXPRESSION_WAR_REAL_CRIT(OwnCritP,FoeToughP),			util:betweet(OwnCritP-FoeToughP,500,9500) ).

%% 攻防公式：伤害=攻击^2/（攻击*a+防御*b）    ab为系数，暂时为1 
-define(EXPRESSION_WAR_HARM(A,OwnAttr,B,FoeDef,C,PJ,Arg,Bonus,FoeReduction,Arg2),	
		erlang:max(trunc((A*OwnAttr-B*FoeDef+C*PJ)*Arg/10000*(1+Bonus-FoeReduction)),
				   trunc((A*OwnAttr*Arg2)*Arg/10000*(1+Bonus-FoeReduction)))).
%% %% 抗性计算
%% %%    如果实际抗性大于0%，那么最终伤害=攻防伤害*（1-抗性率）
%% %%    如果实际抗性小于或等于0%则不计算抗性
%% -define(EXPRESSION_WAR_REAL_HARM(Harm,Repel),					erlang:max(?CONST_WAR_EXPRESSION_HARM_MIN,  ?IF(Repel > 0,round(Harm - Harm*Repel/?CONST_PERCENT),Harm)   ).

%%世界boss金币计算公式
-define(GOLD_WORLD_BOSS(Lv,SGold,Harm,Hurt,Arg,Arg2),			erlang:max(trunc(SGold*(Harm/Hurt)/Arg), trunc(Lv*Arg2))).
