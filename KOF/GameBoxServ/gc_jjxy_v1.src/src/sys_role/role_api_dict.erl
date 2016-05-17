%% @author dreamxyp
%% @doc @todo Add description to role_dict.


-module(role_api_dict).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([
		 player_get/1,
		 fcm_get/0,			fcm_get/1,			fcm_set/1,			fcm_set/2,
		 attr_group_get/0,	attr_group_get/1,	attr_group_set/1,	attr_group_set/2,
		 %% 		 info_get/0,		info_set/1,
		 friend_get/0,		friend_get/1,		friend_set/1,		friend_set/2,
		 equip_get/0,		equip_get/1,        equip_set/1,		equip_set/2,
		 war_p_get/0,		war_p_get/1,        war_p_set/1,        war_p_set/2,
		 %% 		 matrix_get/0,		matrix_set/1,
		 mount_get/0,		mount_get/1,        mount_set/1,        mount_set/2,
		 weagod_get/0,		weagod_get/1,       weagod_set/1,       weagod_set/2,
		 inn_get/0,			inn_get/1,			inn_set/1,			inn_set/2,
		
		 arena_get/0,		arena_get/1,		arena_set/1,		arena_set/2,
		 nianshou_get/0,	nianshou_get/1,		nianshou_set/1,	    nianshou_set/2,
		 defend_book_get/0,	defend_book_get/1,	defend_book_set/1,	defend_book_set/2,
		 clan_boss_get/0,	clan_boss_get/1,    clan_boss_set/1,    clan_boss_set/2,
		 world_boss_get/0,	world_boss_get/1,   world_boss_set/1,   world_boss_set/2,
		 bag_get/0,			bag_get/1,          bag_set/1,          bag_set/2,
		 depot_get/0,		depot_get/1,        depot_set/1,        depot_set/2,
		 skill_user_get/0,  skill_user_get/1,   skill_user_set/1,   skill_user_set/2,
		 tasks_get/0,		tasks_get/1,        tasks_set/1,        tasks_set/2,
%% 		 taskc_get/0,		taskc_get/1,        taskc_set/1,        taskc_set/2,
		 treasure_get/0,    treasure_get/1,     treasure_set/1,     treasure_set/2,
		 task_daily_get/0,  task_daily_get/1,   task_daily_set/1,   task_daily_set/2,
		 renown_get/0,		renown_get/1,       renown_set/1,       renown_set/2,
		 energy_get/0,		energy_get/1,       energy_set/1,       energy_set/2,
		 
		 clan_get/0,		clan_get/1,         clan_set/1,         clan_set/2,
		 clan_cat_get/0,	clan_cat_get/1,		clan_cat_set/1,		clan_cat_set/2,
		 
		 buff_get/0,		buff_get/1,         buff_set/1,         buff_set/2,
		 upcopy_get/0,		upcopy_get/1,       upcopy_set/1,       upcopy_set/2,
		 copy_get/0,		copy_get/1,         copy_set/1,         copy_set/2,
		 hero_get/0,		hero_get/1,         hero_set/1,         hero_set/2,
		 fiend_get/0,		fiend_get/1,        fiend_set/1,        fiend_set/2,
		 fighters_get/0,	fighters_get/1,     fighters_set/1,     fighters_set/2,
		 flsh_get/0,		flsh_get/1,        	flsh_set/1,        	flsh_set/2,
		 sys_get/0,			sys_get/1,          sys_set/1,          sys_set/2,
		 use_count_get/0,	use_count_get/1,    use_count_set/1,    use_count_set/2,
		 target_get/0,		target_get/1,       target_set/1,       target_set/2,
		 welfare_get/0,		welfare_get/1,      welfare_set/1,      welfare_set/2,
		 pet_get/0,			pet_get/1,          pet_set/1,          pet_set/2,
		 circle_get/0,		circle_get/1,       circle_set/1,       circle_set/2,
		 %% 		 money_get/0,       money_set/1,
		 vip_get/0,			vip_get/1,          vip_set/1,          vip_set/2,
		 sign_get/0,		sign_get/1,		    sign_set/1,         sign_set/2,
 		 privilege_get/0,   privilege_get/1,    privilege_set/1,    privilege_set/2,
		 sales_get/0,		sales_get/1,        sales_set/1,        sales_set/2,
		 %% 		 user_buff_get/0,	user_buff_set/1,
		 %% 		 fishing_get/0,		fishing_set/1,
		 stride_get/0,		stride_get/1,       stride_set/1,       stride_set/2,
		 dragon_get/0,		dragon_get/1,       dragon_set/1,       dragon_set/2,
%% 		 camp_war_get/0,	camp_war_get/1,     camp_war_set/1,     camp_war_set/2,
		 make_get/0,		make_get/1,			make_set/1,			make_set/2,
		 store_get/0,       store_get/1,        store_set/1,        store_set/2,

		 douqi_get/0,		douqi_get/1,		douqi_set/1,		douqi_set/2,
		 link_get/0,		link_get/1,			link_set/1,			link_set/2,
		 shoot_get/0,		shoot_get/1,		shoot_set/1,		shoot_set/2,
		 sys_set_get/0,		sys_set_get/1,		sys_set_set/1,		sys_set_set/2,
		 title_get/0,		title_get/1,		title_set/1,		title_set/2,
		 mall_shop_get/0,   mall_shop_get/1,    mall_shop_set/1,    mall_shop_set/2
       ]).  

%% 其它玩家的player
player_get(Uid)->
	db_read(Uid,player).  

%% 防沉迷
fcm_get()->
	case get(?PROC_USER_FCM) of
		DictFcm when is_record(DictFcm,fcm) ->
			DictFcm;
		_undefined ->
			DictFcm = #fcm{},
			fcm_set(DictFcm),
			DictFcm
	end.
fcm_get(Uid)->
	db_read(Uid,?PROC_USER_FCM).
fcm_set(DictFcm)->
	put(?PROC_USER_FCM,DictFcm).
fcm_set(Uid,DictFcm)->
	db_save(Uid,?PROC_USER_FCM,DictFcm).



%% 综合属性
attr_group_get()->
	case get(?PROC_USER_ATTR_GROUP) of
		DictAttrGroup when is_record(DictAttrGroup,attr_group) ->
			DictAttrGroup;
		_undefined ->
			DictAttrGroup = #attr_group{},
			attr_group_set(DictAttrGroup),
			DictAttrGroup
	end.
attr_group_get(Uid)->
	db_read(Uid,?PROC_USER_ATTR_GROUP).
attr_group_set(DictAttrGroup)->
	put(?PROC_USER_ATTR_GROUP,DictAttrGroup).
attr_group_set(Uid,DictAttrGroup)->
	db_save(Uid,?PROC_USER_ATTR_GROUP,DictAttrGroup).


%% 社交系统
friend_get()->
	case get(?PROC_USER_FRIEND) of
		Friend when is_list(Friend) ->
			Friend;
		_undefined ->
			Friend = [],
			friend_set(Friend),
			Friend
	end.
friend_get(Uid)->
	db_read(Uid,?PROC_USER_FRIEND).
friend_set(DictRelation)->
	put(?PROC_USER_FRIEND,DictRelation).
friend_set(Uid,DictRelation)->
	db_save(Uid,?PROC_USER_FRIEND,DictRelation).

%%装备
equip_get()->
	case get(?PROC_USER_EQUIP) of
		DictEquip when is_list(DictEquip) ->
			DictEquip;
		_undefined ->
			DictEquip = [],
			equip_set(DictEquip),
			DictEquip
	end.
equip_get(Uid)->
	db_read(Uid,?PROC_USER_EQUIP).
equip_set(DictEquip)->
	put(?PROC_USER_EQUIP,DictEquip).
equip_set(Uid,DictRelation)->
	db_save(Uid,?PROC_USER_EQUIP,DictRelation).

%%战斗/技能 #war_p{}
war_p_get()->
	case get(?PROC_USER_WARP) of
		DictWarP when is_record(DictWarP,war_p) ->
			DictWarP;
		_undefined ->
			DictWarP = #war_p{},
			war_p_set(DictWarP),
			DictWarP
	end.
war_p_get(Uid)->
	db_read(Uid,?PROC_USER_WARP).
war_p_set(DictWarP)->
	put(?PROC_USER_WARP,DictWarP).
war_p_set(Uid,DictWarP)->
	db_save(Uid,?PROC_USER_WARP,DictWarP).

%%初始化技能模块
skill_user_get() ->
	case get(?PROC_USER_SKILL_MSG) of
		DictSkillMsg when is_record(DictSkillMsg,skill_user) ->
			?MSG_ECHO("======~w~n",[skill_user]),
			DictSkillMsg;
		_undefined ->
			DictSkillMsg = #skill_user{},
			skill_user_set(DictSkillMsg),
			DictSkillMsg
	end.
skill_user_get(Uid)->
	db_read(Uid,?PROC_USER_SKILL_MSG).
skill_user_set(DictSkillMsg) ->
	?MSG_ECHO("======~w~n",[DictSkillMsg]),
    put(?PROC_USER_SKILL_MSG,DictSkillMsg).
skill_user_set(Uid,DictSkillMsg)->
	db_save(Uid,?PROC_USER_SKILL_MSG,DictSkillMsg).



%% 坐骑#mount{}
mount_get()->
	case get(?PROC_USER_MOUNT) of
		DictMount when is_record(DictMount,mount) ->
			DictMount;
		_undefined ->
			DictMount = #mount{},
			mount_set(DictMount),
			DictMount
	end.
mount_get(Uid)->
	db_read(Uid,?PROC_USER_MOUNT).
mount_set(DictMount)->
	put(?PROC_USER_MOUNT,DictMount).
mount_set(Uid,DictMount)->
	db_save(Uid,?PROC_USER_MOUNT,DictMount).

%% 财神#weagod{}
weagod_get()->
	case get(?PROC_USER_WEAGOD) of
		DictWeagod when is_record(DictWeagod,weagod) ->
			DictWeagod;
		_undefined ->
			DictWeagod = #weagod{},
			weagod_set(DictWeagod),
			DictWeagod
	end.
weagod_get(Uid)->
	db_read(Uid,?PROC_USER_WEAGOD).
weagod_set(DictWeagod)->
	put(?PROC_USER_WEAGOD,DictWeagod).
weagod_set(Uid,DictWeagod)->
	db_save(Uid,?PROC_USER_WEAGOD,DictWeagod).

%% 客栈
inn_get()->
	case get(?PROC_USER_INN) of
		DictInn when is_record(DictInn,inn) ->
			DictInn;
		_undefined ->
			DictInn = #inn{},
			inn_set(DictInn),
			DictInn
	end.
inn_get(Uid)->
	db_read(Uid,?PROC_USER_INN).
inn_set(DictInn)->
	put(?PROC_USER_INN,DictInn).
inn_set(Uid,DictInn)->
	db_save(Uid,?PROC_USER_INN,DictInn).

%% 商店系统
store_get() ->
	case get(?PROC_USER_STORE) of
        DictStore when is_record(DictStore,store) ->
             DictStore;
        _undefine ->
             DictStore = #store{},
             store_set(DictStore),
             DictStore
    end.
store_get(Uid) ->
	db_read(Uid, ?PROC_USER_STORE).

store_set(DictStore)->
	put(?PROC_USER_STORE,DictStore).
store_set(Uid,DictStore) ->
	db_save(Uid,?PROC_USER_STORE,DictStore).

%% 竞技场
arena_get()->
	case get(?PROC_USER_ARENA) of
		DictArena when is_record(DictArena,arena) ->
			DictArena;
		_undefined ->
			DictArena = #arena{},
			arena_set(DictArena),
			DictArena
	end.
arena_get(Uid)->
	db_read(Uid,?PROC_USER_ARENA).
arena_set(DictArena)->
	put(?PROC_USER_ARENA,DictArena).
arena_set(Uid,DictArena)->
	db_save(Uid,?PROC_USER_ARENA,DictArena).

%% 年兽
nianshou_get()->
	case get(?PROC_USER_NIANSHOU) of
		DictNianShou when is_record(DictNianShou,nianshou) ->
			DictNianShou;
		_undefined ->
			DictNianShou = #nianshou{},
			nianshou_set(DictNianShou),
			DictNianShou
	end.
nianshou_get(Uid)->
	db_read(Uid,?PROC_USER_NIANSHOU).
nianshou_set(DictNianShou)->
	put(?PROC_USER_NIANSHOU,DictNianShou).
nianshou_set(Uid,DictNianShou)->
	db_save(Uid,?PROC_USER_NIANSHOU,DictNianShou).

%% 保卫经书
defend_book_get()->
	case get(?PROC_USER_DEFEND_BOOK) of
		DictDefendBook when is_record(DictDefendBook,defend_book) ->
			DictDefendBook;
		_undefined ->
			DictDefendBook = #defend_book{},
			defend_book_set(DictDefendBook),
			DictDefendBook
	end.
defend_book_get(Uid)->
	db_read(Uid,?PROC_USER_DEFEND_BOOK).
defend_book_set(DictDefendBook)->
	put(?PROC_USER_DEFEND_BOOK,DictDefendBook).
defend_book_set(Uid,DictDefendBook)->
	db_save(Uid,?PROC_USER_DEFEND_BOOK,DictDefendBook).


%%　招财猫
clan_cat_get()->
	case get(?PROC_USER_CLAN_CAT) of
		DictCat when is_record(DictCat,clan_cat) ->
			DictCat;
		_undefined ->
			DictCat = #clan_cat{},
			clan_cat_set(DictCat),
			DictCat
	end.
clan_cat_get(Uid) ->
	db_read(Uid,?PROC_USER_CLAN_CAT).
clan_cat_set(DictCat)->
	put(?PROC_USER_CLAN_CAT,DictCat).
clan_cat_set(Uid,DictCat)->
	db_save(Uid,?PROC_USER_CLAN_CAT,DictCat).


%% 帮派心魔
clan_boss_get()->
	case get(?PROC_USER_CLAN_BOSS) of
		DictClanBoss when is_record(DictClanBoss,clan_boss) ->
			DictClanBoss;
		_undefined ->
			DictClanBoss = #clan_boss{},
			clan_boss_set(DictClanBoss),
			DictClanBoss
	end.
clan_boss_get(Uid)->
	db_read(Uid,?PROC_USER_CLAN_BOSS).
clan_boss_set(DictClanBoss)->
	put(?PROC_USER_CLAN_BOSS,DictClanBoss).
clan_boss_set(Uid,DictDefendBook)->
	db_save(Uid,?PROC_USER_CLAN_BOSS,DictDefendBook).


%% 世界Boss
world_boss_get()->
	case get(?PROC_USER_WORLD_BOSS) of
		DictWorldBoss when is_record(DictWorldBoss,world_boss) ->
			DictWorldBoss;
		_undefined ->
			DictWorldBoss = #world_boss{},
			world_boss_set(DictWorldBoss),
			DictWorldBoss
	end.
world_boss_get(Uid)->
	db_read(Uid,?PROC_USER_WORLD_BOSS).
world_boss_set(DictWorldBoss)->
	put(?PROC_USER_WORLD_BOSS,DictWorldBoss).
world_boss_set(Uid,DictDefendBook)->
	db_save(Uid,?PROC_USER_WORLD_BOSS,DictDefendBook).


%% 背包
bag_get()->
	case get(?PROC_USER_BAG) of
		DictBag when is_record(DictBag,bag) ->
			DictBag;
		_undefined ->
			DictBag = #bag{max = ?CONST_GOODS_BAG_MAX, list = []},
			bag_set(DictBag),
			DictBag
	end.
bag_get(Uid)->
	db_read(Uid,?PROC_USER_BAG).
bag_set(DictBag)->
	put(?PROC_USER_BAG,DictBag).
bag_set(Uid,DictBag)->
	db_save(Uid,?PROC_USER_BAG,DictBag).

%%仓库
depot_get()->
	case get(?PROC_USER_DEPOT) of
		DictDepot when is_list(DictDepot) ->
			DictDepot;
		_undefined ->
			DictDepot = [],
			depot_set(DictDepot),
			DictDepot
	end.
depot_get(Uid)->
	db_read(Uid,?PROC_USER_DEPOT).
depot_set(DictDepot)->
	put(?PROC_USER_DEPOT,DictDepot).
depot_set(Uid,DictDepot)->
	db_save(Uid,?PROC_USER_DEPOT,DictDepot).

%% 任务tasks[]
tasks_get()->
	case get(?PROC_USER_TASKS) of
		DictTasks when is_record(DictTasks,tasks) ->
			DictTasks;
		_undefined ->
			DictTasks = #tasks{},
			tasks_set(DictTasks),
			DictTasks
	end.
tasks_get(Uid)->
	db_read(Uid,?PROC_USER_TASKS).
tasks_set(DictTasks)->
	put(?PROC_USER_TASKS,DictTasks).
tasks_set(Uid,DictTasks)->
	db_save(Uid,?PROC_USER_TASKS,DictTasks).

%% 日常任务系统
task_daily_get()->
	case get(?PROC_USER_DAILY_TASK) of
		DictTaskDaily when is_record(DictTaskDaily,task_daily) ->
%% 			?MSG_ECHO("DictTaskc get= ~w~n",[DictTaskDaily]),
			DictTaskDaily;
		_undefined ->
			DictTaskDaily = #task_daily{},
			task_daily_set(DictTaskDaily),
			DictTaskDaily
	end.
task_daily_get(Uid)->
	db_read(Uid,?PROC_USER_DAILY_TASK).

task_daily_set(DictTaskc)->
%% 	?MSG_ECHO("DictTaskc set= ~w~n",[DictTaskc]),
	put(?PROC_USER_DAILY_TASK,DictTaskc).
task_daily_set(Uid,DictTaskc)->
	db_save(Uid,?PROC_USER_DAILY_TASK,DictTaskc).

%% 藏宝阁系统
treasure_get()->
	case get(?PROC_USER_TREASURE) of 
		DictTreasure when is_record(DictTreasure,treasure) ->
			DictTreasure;
		_undefined ->
			DictTreasure = #treasure{},
			treasure_set(DictTreasure),
			DictTreasure
	end.
treasure_get(Uid)->
	db_read(Uid,?PROC_USER_TREASURE).

treasure_set(Uid,DictTreasure)->
	db_save(Uid,?PROC_USER_TREASURE,DictTreasure).

treasure_set(DictTreasure)->
	put(?PROC_USER_TREASURE,DictTreasure).

	

%% 仙旅奇缘(骰子任务)
%% task_rand_get()->
%% 	case get(?PROC_USER_TASK_RAND) of
%% 		DictTaskRand when is_record(DictTaskRand,task_rand) ->
%% 			DictTaskRand;
%% 		_undefined ->
%% 			DictTaskRand = #task_rand{},
%% 			task_rand_set(DictTaskRand),
%% 			DictTaskRand
%% 	end.
%% 
%% task_rand_set(DictTaskRand)->
%% 	put(?PROC_USER_TASK_RAND,DictTaskRand).


%% 声望 #renown{}
renown_get()->
	case get(?PROC_USER_RENOWN) of
		DictRenown when is_record(DictRenown,renown) ->
			DictRenown;
		_undefined ->
			DictRenown = #renown{},
			renown_set(DictRenown),
			DictRenown
	end.
renown_get(Uid)->
	db_read(Uid,?PROC_USER_RENOWN).
renown_set(DictRenown)->
	put(?PROC_USER_RENOWN,DictRenown).
renown_set(Uid,DictRenown)->
	db_save(Uid,?PROC_USER_RENOWN,DictRenown).

%% 体力 #energy{}
energy_get()->
	case get(?PROC_USER_ENERGY) of
		DictEnergy when is_record(DictEnergy,energy) ->
			DictEnergy;
		_undefined ->
			DictEnergy = energy_api:init_energy(),
			energy_set(DictEnergy),
			DictEnergy
	end.
energy_get(Uid)->
	db_read(Uid,?PROC_USER_ENERGY).
energy_set(DictEnergy)->
	put(?PROC_USER_ENERGY,DictEnergy).
energy_set(Uid,DictEnergy)->
	db_save(Uid,?PROC_USER_ENERGY,DictEnergy).

%% 家族
clan_get()->
	case get(?PROC_USER_DATA_CLAN) of
		DictDataClan when is_record(DictDataClan,clan) ->
			DictDataClan;
		_undefined ->
			DictDataClan = #clan{},
			clan_set(DictDataClan),
			DictDataClan
	end.
clan_get(Uid)->
	db_read(Uid,?PROC_USER_DATA_CLAN).
clan_set(DictDataClan)->
	put(?PROC_USER_DATA_CLAN,DictDataClan).
clan_set(Uid,DictDataClan)->
	db_save(Uid,?PROC_USER_DATA_CLAN,DictDataClan).

%% 状态数据元组列表{Type,Start,Remain,Value,Icon}	如:双倍等经验
buff_get()->
	case get(?PROC_USER_DATA_BUFF) of
		DictDataBuff when is_list(DictDataBuff) ->
			DictDataBuff;
		_undefined ->
			DictDataBuff = [],
			buff_set(DictDataBuff),
			DictDataBuff
	end.
buff_get(Uid)->
	db_read(Uid,?PROC_USER_DATA_BUFF).
buff_set(DictDataBuff)->
	put(?PROC_USER_DATA_BUFF,DictDataBuff).
buff_set(Uid,DictDataBuff)->
	db_save(Uid,?PROC_USER_DATA_BUFF,DictDataBuff).

%% 副本挂机
upcopy_get()->
	case get(?PROC_USER_UPCOPY) of
		DictUpCopy when is_record(DictUpCopy,upcopy) ->
			DictUpCopy;
		_undefined ->
			DictUpCopy = #upcopy{},
			upcopy_set(DictUpCopy),
			DictUpCopy
	end.
upcopy_get(Uid)->
	db_read(Uid,?PROC_USER_UPCOPY).
upcopy_set(DictUpCopy)->
	put(?PROC_USER_UPCOPY,DictUpCopy).
upcopy_set(Uid,DictUpCopy)->
	db_save(Uid,?PROC_USER_UPCOPY,DictUpCopy).

%% 普通副本
copy_get()->
	case get(?PROC_USER_COPY) of
		DictCopy when is_record(DictCopy,chapcopy) ->
			DictCopy;
		_undefined ->
			DictCopy = copy_api:init_chapcopy(),
			copy_set(DictCopy),
			DictCopy
	end.
copy_get(Uid)->
	db_read(Uid,?PROC_USER_COPY).
copy_set(DictCopy)->
	put(?PROC_USER_COPY,DictCopy).
copy_set(Uid,DictCopy)->
	db_save(Uid,?PROC_USER_COPY,DictCopy).

%% 英雄副本
hero_get()->
	case get(?PROC_USER_HERO) of
		DictHero when is_record(DictHero,hero) ->
			DictHero;
		_undefined ->
			DictHero = hero_api:init(),
			hero_set(DictHero),
			DictHero
	end.
hero_get(Uid)->
	db_read(Uid,?PROC_USER_HERO).
hero_set(DictHero)->
	put(?PROC_USER_HERO,DictHero).
hero_set(Uid,DictHero)->
	db_save(Uid,?PROC_USER_HERO,DictHero).

%% 魔王副本
fiend_get()->
	case get(?PROC_USER_FIEND) of
		DictHero when is_record(DictHero,fiend) ->
			DictHero;
		_undefined ->
			DictHero = fiend_api:init(),
			fiend_set(DictHero),
			DictHero
	end.
fiend_get(Uid)->
	db_read(Uid,?PROC_USER_FIEND).
fiend_set(DictFiend)->
	put(?PROC_USER_FIEND,DictFiend).
fiend_set(Uid,DictFiend)->
	db_save(Uid,?PROC_USER_FIEND,DictFiend).


%% 拳皇生涯
fighters_get()->
	case get(?PROC_USER_FIGHTERS) of
		DictFighters when is_record(DictFighters,fighters) ->
			DictFighters;
		_undefined ->
			DictFighters = fighters_api:init(),
			fiend_set(DictFighters),
			DictFighters
	end.
fighters_get(Uid)->
	db_read(Uid,?PROC_USER_FIGHTERS).
fighters_set(DictFighters)->
	put(?PROC_USER_FIGHTERS,DictFighters).
fighters_set(Uid,DictFighters)->
	db_save(Uid,?PROC_USER_FIGHTERS,DictFighters).

%% 风林山火
flsh_get()->
	case get(?PROC_USER_FLSH) of
		DictFlsh when is_record(DictFlsh,flsh) ->
			DictFlsh;
		_undefined ->
			DictFlsh = flsh_api:init(),
			flsh_set(DictFlsh),
			DictFlsh
	end.
flsh_get(Uid)->
	db_read(Uid,?PROC_USER_FLSH).
flsh_set(DictFlsh)->
	put(?PROC_USER_FLSH,DictFlsh).
flsh_set(Uid,DictFlsh)->
	db_save(Uid,?PROC_USER_FLSH,DictFlsh).

%% 任务开放系统
sys_get()->
	case get(?PROC_USER_SYS) of
		DictSys when is_record(DictSys,sys) ->
			DictSys;
		_undefined ->
			DictSys = #sys{},
			sys_set(DictSys),
			DictSys
	end.
sys_get(Uid)->
	db_read(Uid,?PROC_USER_SYS).
sys_set(DictSys)->
	put(?PROC_USER_SYS,DictSys).
sys_set(Uid,DictSys)->
	db_save(Uid,?PROC_USER_SYS,DictSys).

%% 各种限定时间内限定使用次数事件,[{Type,Date,[{TypeSub,Count},...]},....]
use_count_get()->
	case get(?PROC_USER_USE_COUNT) of
		DictUseCount when is_list(DictUseCount) ->
			DictUseCount;
		_undefined ->
			DictUseCount = [],
			use_count_set(DictUseCount),
			DictUseCount
	end.
use_count_get(Uid)->
	db_read(Uid,?PROC_USER_USE_COUNT).
use_count_set(DictUseCount)->
	put(?PROC_USER_USE_COUNT,DictUseCount).
use_count_set(Uid,DictUseCount)->
	db_save(Uid,?PROC_USER_USE_COUNT,DictUseCount).

%% 目标任务数据
target_get()->
	case get(?PROC_USER_TARGRT) of
		DictTarget when is_record(DictTarget,target) ->
			DictTarget;
		_undefined ->
			DictTarget = #target{},
			target_set(DictTarget),
			DictTarget
	end.
target_get(Uid)->
	db_read(Uid,?PROC_USER_TARGRT).
target_set(DictTarget)->
	put(?PROC_USER_TARGRT,DictTarget).
target_set(Uid,DictTarget)->
	db_save(Uid,?PROC_USER_TARGRT,DictTarget).


%% 福利
welfare_get()->
	case get(?PROC_USER_WELFARE) of
		DictWelfare when is_record(DictWelfare,welfare) ->
			DictWelfare;
		_undefined ->
			DictWelfare = #welfare{},
			welfare_set(DictWelfare),
			DictWelfare
	end.
welfare_get(Uid)->
	db_read(Uid,?PROC_USER_WELFARE).
welfare_set(DictSys)->
	put(?PROC_USER_WELFARE,DictSys).
welfare_set(Uid,DictSys)->
	db_save(Uid,?PROC_USER_WELFARE,DictSys).


%% 宠物
pet_get()->
	case get(?PROC_USER_PET) of
		DictPet when is_record(DictPet,pet) ->
%%  			?MSG_ECHO("-----------------~w~n",[DictPet]),
			DictPet;
		_undefined ->
			DictPet= pet_api:init(),
			pet_set(DictPet),
%% 			?MSG_ECHO("-----------------~w~n",[DictPet]),
			DictPet
	end.
pet_get(Uid)->
	db_read(Uid,?PROC_USER_PET).
pet_set(DictSys)->
%% 	?MSG_ECHO("-----------------~w~n",[DictSys]),
	put(?PROC_USER_PET,DictSys).
pet_set(Uid,DictSys)->
	db_save(Uid,?PROC_USER_PET,DictSys).

%% 荣誉
%% honor_get()->
%% 	case get(?PROC_USER_HONOR) of
%% 		DictHonor when is_record(DictHonor,honor) ->
%% 			DictHonor;
%% 		_undefined ->
%% 			DictHonor = [],
%% 			honor_set(DictHonor),
%% 			DictHonor
%% 	end.
%% honor_set(DictHonor)->
%% 	put(?PROC_USER_HONOR,DictHonor).

%% 三界杀
circle_get()->
	case get(?PROC_USER_CIRCLE) of
		DictCircle when is_record(DictCircle,circle) ->
			DictCircle;
		_undefined ->
			DictCircle = #circle{},
			circle_set(DictCircle),
			DictCircle
	end.
circle_get(Uid)->
	db_read(Uid,?PROC_USER_CIRCLE).
circle_set(DictHonor)->
	put(?PROC_USER_CIRCLE,DictHonor).
circle_set(Uid,DictHonor)->
	db_save(Uid,?PROC_USER_CIRCLE,DictHonor).
		

%% VIP #vip{}
vip_get()->
	case get(?PROC_USER_VIP) of
		DictVip when is_record(DictVip,vip) ->
			DictVip;
		_undefined ->
			DictVip = #vip{},
			vip_set(DictVip),
			DictVip
	end.
vip_get(Uid)->
	db_read(Uid,?PROC_USER_VIP).
vip_set(DictVip)->
	put(?PROC_USER_VIP,DictVip).
vip_set(Uid,DictVip)->
	db_save(Uid,?PROC_USER_VIP,DictVip).

%% 签到 #sign{}
sign_get()->
	case get(?PROC_USER_SIGN) of
		DictSign when is_record(DictSign,sign) ->
			DictSign;
		_undefined ->
			SignReward= #signreward{
									day=1,
									is_get = ?CONST_SIGN_NO},
			DictSign =#sign{num = 1, 
						date = util:seconds(),
						signreward = [SignReward]
					   },
			sign_set(DictSign),
			DictSign
	end.
sign_get(Uid)->
	db_read(Uid,?PROC_USER_SIGN).
sign_set(DictSign)->
	put(?PROC_USER_SIGN,DictSign).
sign_set(Uid,DictSign)->
	db_save(Uid,?PROC_USER_SIGN,DictSign).

%% 新手特权 #privilege{}
privilege_get()->
	case get(?PROC_USER_PRIVILEGE) of
		DictPrivilege when is_record(DictPrivilege,privilege) ->
			DictPrivilege;
		_undefined ->
			DictPrivilege= #privilege{
									  is_open= ?CONST_SIGN_NO,
									  day=1,
									  is_get = ?CONST_SIGN_NO},
			privilege_set(DictPrivilege),
			DictPrivilege
	end.
privilege_get(Uid)->
	db_read(Uid,?PROC_USER_PRIVILEGE).
privilege_set(DictPrivilege)->
	put(?PROC_USER_PRIVILEGE,DictPrivilege).
privilege_set(Uid,DictPrivilege)->
	db_save(Uid,?PROC_USER_PRIVILEGE,DictPrivilege).

%% 精彩活动(促销)
sales_get()->
	case get(?PROC_USER_SALES) of
		DictSales when is_record(DictSales,sales) ->
			DictSales;
		_undefined ->
			DictSales = #sales{},
			sales_set(DictSales),
			DictSales
	end.
sales_get(Uid)->
	db_read(Uid,?PROC_USER_SALES).
sales_set(DictSales)->
	put(?PROC_USER_SALES,DictSales).
sales_set(Uid,DictSales)->
	db_save(Uid,?PROC_USER_SALES,DictSales).


%% 使用物品次数(隔天重置)
%% times_goods_get()->
%% 	case get(?PROC_USER_TIMES_GOODS) of
%% 		DictHonor when is_record(DictHonor,times_goods) ->
%% 			DictHonor;
%% 		_undefined ->
%% 			DictHonor = [],
%% 			times_goods_set(DictHonor),
%% 			DictHonor
%% 	end.
%% times_goods_set(DictHonor)->
%% 	put(?PROC_USER_TIMES_GOODS,DictHonor).

%% 购买一次物品(只能购买一次)
%% once_goods_get()->
%% 	case get(?PROC_USER_ONCE_GOODS) of
%% 		DictOnceGoods when is_record(DictOnceGoods,once_goods) ->
%% 			DictOnceGoods;
%% 		_undefined ->
%% 			DictOnceGoods = [],
%% 			once_goods_set(DictOnceGoods),
%% 			DictOnceGoods
%% 	end.
%% once_goods_set(DictOnceGoods)->
%% 	put(?PROC_USER_ONCE_GOODS,DictOnceGoods).

%% 钓鱼数据
%% fishing_get()->
%% 	case get(?PROC_USER_FISHING) of
%% 		DictFinsh when is_record(DictFinsh,fishing) ->
%% 			DictFinsh;
%% 		_undefined ->
%% 			DictFinsh = #fishing{},
%% 			fishing_set(DictFinsh),
%% 			DictFinsh
%% 	end.
%% 
%% fishing_set(DictHonor)->
%% 	put(?PROC_USER_FISHING,DictHonor).

%% 跨服战
stride_get()->
	case get(?PROC_USER_STRIDE) of
		DictStride when is_record(DictStride,stride) ->
			DictStride;
		_undefined ->
			DictStride = #stride{},
			stride_set(DictStride),
			DictStride
	end.
stride_get(Uid)->
	db_read(Uid,?PROC_USER_STRIDE).
stride_set(DictStride)->
	put(?PROC_USER_STRIDE,DictStride).
stride_set(Uid,DictStride)->
	db_save(Uid,?PROC_USER_STRIDE,DictStride).

%% 龙宫寻宝
dragon_get()->
	case get(?PROC_USER_DRAGON) of
		DictDragon when is_record(DictDragon,dragon) ->
			DictDragon;
		_undefined ->
			DictDragon = #dragon{},
			dragon_set(DictDragon),
			DictDragon
	end.
dragon_get(Uid)->
	db_read(Uid,?PROC_USER_DRAGON).
dragon_set(DictDragon)->
	put(?PROC_USER_DRAGON,DictDragon).
dragon_set(Uid,DictDragon)->
	db_save(Uid,?PROC_USER_DRAGON,DictDragon).



%% %% 阵营战
%% camp_war_get()->
%% 	case get(?PROC_USER_CAMP_WAR) of
%% 		DictCampWar when is_record(DictCampWar,camp_war) ->
%% 			DictCampWar;
%% 		_undefined ->
%% 			DictCampWar = #camp_war{},
%% 			camp_war_set(DictCampWar),
%% 			DictCampWar
%% 	end.
%% camp_war_get(Uid)->
%% 	db_read(Uid,?PROC_USER_CAMP_WAR).
%% camp_war_set(DictCampWar)->
%% 	put(?PROC_USER_CAMP_WAR,DictCampWar).
%% camp_war_set(Uid,DictCampWar)->
%% 	db_save(Uid,?PROC_USER_CAMP_WAR,DictCampWar).

%% 装备附魔次数
make_get()->
	case get(?PROC_USER_ENCHANT) of
		{Data,Count}->
			TData=util:date_Ymd(),
			?IF(TData==Data,{Data,Count},{TData,1});
		_undefined->
			TData=util:date_Ymd(),
			make_set({TData,1}),
			{TData,1}
	end.
make_get(Uid)->
	db_read(Uid,?PROC_USER_ENCHANT).
make_set(DictMake)->
	put(?PROC_USER_ENCHANT,DictMake).
make_set(Uid,DictMake)->
	db_save(Uid,?PROC_USER_ENCHANT,DictMake).


%% 斗气
douqi_get() ->
	case get(?PROC_USER_DOUQI) of
		DictDouQi when is_record(DictDouQi,douqi) ->
			DictDouQi;
		_undefined ->
			DictDouQi = douqi_api:init(),
			douqi_set(DictDouQi),
			DictDouQi
	end.
douqi_get(Uid) ->
	db_read(Uid,?PROC_USER_DOUQI).
douqi_set(DictDouQi) ->
	put(?PROC_USER_DOUQI,DictDouQi).
douqi_set(Uid,DictDouQi) ->
	db_save(Uid,?PROC_USER_DOUQI,DictDouQi).



db_read(Uid,ProcKey) when is_integer(Uid) ->
%% 	case role_api:mpid(Uid) of
%% 		Pid when is_pid(Pid) -> %% 在线
%% 			?MSG_ERROR("?ERROR_ONLINE_READOFFLINE Pid:~p,Uid:~p,ProcKey:~p",[Pid,Uid,ProcKey]),
%% 			{?error,?ERROR_ONLINE_READOFFLINE};
%% 		_ -> %% 不在线
%% 			role_db:ets_offline_read(Uid,ProcKey)
%% 	end;
	role_db:ets_offline_read(Uid,ProcKey);
db_read(_Uid,_ProcKey) -> %% 参数错误
	?MSG_ERROR("?ERROR_BADARG Uid:~p,ProcKey:~p",[_Uid,_ProcKey]),
	{?error,?ERROR_BADARG}.

db_save(Uid,ProcKey,DictValue) when is_integer(Uid) ->
	case role_api:mpid(Uid) of
		Pid when is_pid(Pid) -> %% 在线
			?MSG_ERROR("?ERROR_ONLINE_READOFFLINE Pid:~p,Uid:~p,ProcKey:~p DictValue:~w",[Pid,Uid,ProcKey,DictValue]),
			{?error,?ERROR_ONLINE_READOFFLINE};
		_ -> %% 不在线
			role_db:ets_offline_save(Uid,ProcKey,DictValue)
	end;
db_save(_Uid,_ProcKey,_DictValue)->
	?MSG_ERROR("?ERROR_BADARG Uid:~p,ProcKey:~p _DictValue:~w",[_Uid,_ProcKey,_DictValue]),
	{?error,?ERROR_BADARG}.

%% 每日一箭
shoot_get() ->
	case get(?PROC_USER_SHOOT) of
		DictShoot when is_record(DictShoot,shoot) ->
			DictShoot;
		_undefined ->
			DictShoot = #shoot{},
			shoot_set(DictShoot),
			DictShoot
	end.
shoot_get(Uid) ->
	db_read(Uid,?PROC_USER_SHOOT).
shoot_set(DictShoot) ->
	put(?PROC_USER_SHOOT,DictShoot).
shoot_set(Uid,DictShoot) ->
	db_save(Uid,?PROC_USER_SHOOT,DictShoot).
	
%% 活动入口 玩家活跃度
link_get() ->
	case get(?PROC_USER_LINK) of
		DictLink when is_record(DictLink,active_link)->
			DictLink;
		_undefined ->
			DictLink = #active_link{},
			link_set(DictLink),
			DictLink
	end.
link_get(Uid) ->
	db_read(Uid,?PROC_USER_LINK).
link_set(DictLink) ->
	put(?PROC_USER_LINK,DictLink).
link_set(Uid,DictLink) ->
	db_save(Uid,?PROC_USER_LINK,DictLink).
				
sys_set_get()->
	case get(?PROC_USER_SYS_SET) of
		DictSysSet when is_list(DictSysSet)->
			DictSysSet;
		_undefined ->
			DictSysSet = sys_set_api:sys_get(),
			sys_set_set(DictSysSet),
			DictSysSet
	end.

sys_set_get(Uid)->
	db_read(Uid,?PROC_USER_SYS_SET).
sys_set_set(DictSysSet)->
	put(?PROC_USER_SYS_SET,DictSysSet).
sys_set_set(Uid,DictSysSet)->
	db_save(Uid,?PROC_USER_SYS_SET,DictSysSet).

%%  玩家活称号
title_get() ->
	case get(?PROC_USER_TITLE) of
		[] -> [];
		[Title|_] = DictTitle when is_record(Title,title)->
			DictTitle;
		_undefined ->
			title_set([]),
			[]
	end.
title_get(Uid) ->
	db_read(Uid,?PROC_USER_TITLE).
title_set(DictTitle) ->
	put(?PROC_USER_TITLE,DictTitle).
title_set(Uid,DictTitle) ->
	db_save(Uid,?PROC_USER_TITLE,DictTitle).

mall_shop_get() ->
	case get(?PROC_USER_MALL_SHOP) of
		  DictMallShop when is_record(DictMallShop,mall_shop) ->
				DictMallShop;
          _undefined->
				DictMallShop = #mall_shop{},
			    shoot_set(DictMallShop),
			    DictMallShop
	end.
mall_shop_get(Uid) ->
	db_read(Uid,?PROC_USER_MALL_SHOP).

mall_shop_set(DictMallShop)->
	put(?PROC_USER_MALL_SHOP,DictMallShop).
mall_shop_set(Uid,DictMallShop)->
	db_save(Uid,?PROC_USER_MALL_SHOP,DictMallShop).
	









				

