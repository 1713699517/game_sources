require "common/MessageProtocol"
require "model/VO_NetworkAsyncObject"
require "controller/NetworkAsyncCommand"


--/** AUTO_CODE_BEGIN_Const **************** don't touch this line ********************/
--/** =============================== 自动生成的代码 =============================== **/
require "common/protocol/auto/ACK_SYSTEM_RESET_IDX"
require "common/protocol/auto/ACK_SYSTEM_DISCONNECT"
require "common/protocol/auto/ACK_SYSTEM_TIME"
require "common/protocol/ACK_SYSTEM_ERROR"
require "common/protocol/auto/ACK_SYSTEM_NOTICE"
require "common/protocol/ACK_SYSTEM_BROADCAST"
require "common/protocol/ACK_SYSTEM_DATA_XXX"
require "common/protocol/auto/ACK_SYSTEM_TIPS"
require "common/protocol/auto/ACK_SYSTEM_PAY_STATE"
require "common/protocol/auto/ACK_ROLE_LOGIN_AG_ERR"
require "common/protocol/auto/ACK_ROLE_LOGIN_OK_HAVE"
require "common/protocol/auto/ACK_ROLE_CURRENCY"
require "common/protocol/auto/ACK_ROLE_LOGIN_OK_NO_ROLE"
require "common/protocol/auto/ACK_ROLE_NAME"
require "common/protocol/auto/ACK_ROLE_LOGIN_FAIL"
require "common/protocol/auto/ACK_ROLE_CREATE_FAIL"
require "common/protocol/auto/ACK_ROLE_DEL_OK"
require "common/protocol/auto/ACK_ROLE_DEL_FAIL"
require "common/protocol/ACK_ROLE_PROPERTY_REVE"
require "common/protocol/ACK_ROLE_PARTNER_DATA"
require "common/protocol/auto/ACK_ROLE_PROPERTY_EXT_R"
require "common/protocol/auto/ACK_ROLE_PROPERTY_UPDATE"
require "common/protocol/auto/ACK_ROLE_PROPERTY_UPDATE2"
require "common/protocol/ACK_ROLE_SYS"
require "common/protocol/auto/ACK_ROLE_OPEN_SYS"
require "common/protocol/auto/ACK_ROLE_ENERGY_OK"
require "common/protocol/auto/ACK_ROLE_BUFF_ENERGY"
require "common/protocol/auto/ACK_ROLE_OK_ASK_BUYE"
require "common/protocol/auto/ACK_ROLE_OK_BUY_ENERGY"
require "common/protocol/ACK_ROLE_SYS_ID"
require "common/protocol/ACK_ROLE_SYS_ID_2"
require "common/protocol/auto/ACK_ROLE_LV_MY"
require "common/protocol/auto/ACK_ROLE_VIP_LV"
require "common/protocol/auto/ACK_ROLE_NOTICE"
require "common/protocol/auto/ACK_ROLE_OK_REQUEST"
require "common/protocol/auto/ACK_ROLE_OK_CLICK"
require "common/protocol/auto/ACK_ROLE_ONLINE_REWARD"
require "common/protocol/auto/ACK_ROLE_LEVEL_GIFT"
require "common/protocol/ACK_ROLE_BUFF_DATA"
require "common/protocol/ACK_ROLE_BUFF1_DATA"
require "common/protocol/auto/ACK_ROLE_XXFFS_DATA"
require "common/protocol/ACK_ROLE_BUFF"
require "common/protocol/ACK_GOODS_XXX1"
require "common/protocol/ACK_GOODS_XXX2"
require "common/protocol/ACK_GOODS_XXX3"
require "common/protocol/ACK_GOODS_XXX4"
require "common/protocol/auto/ACK_GOODS_XXX5"
require "common/protocol/auto/ACK_GOODS_ATTR_BASE"
require "common/protocol/ACK_GOODS_REVERSE"
require "common/protocol/ACK_GOODS_REMOVE"
require "common/protocol/ACK_GOODS_CHANGE"
require "common/protocol/ACK_GOODS_CHANGE_NOTICE"
require "common/protocol/auto/ACK_GOODS_CURRENCY_CHANGE"
require "common/protocol/auto/ACK_GOODS_P_EXP_OK"
require "common/protocol/auto/ACK_GOODS_ENLARGE_COST"
require "common/protocol/auto/ACK_GOODS_ENLARGE"
require "common/protocol/ACK_GOODS_EQUIP_BACK"
require "common/protocol/auto/ACK_GOODS_SELL_OK"
require "common/protocol/auto/ACK_GOODS_SWAP_OK"
require "common/protocol/auto/ACK_GOODS_SHOP_XXX1"
require "common/protocol/ACK_GOODS_SHOP_BACK"
require "common/protocol/auto/ACK_GOODS_SHOP_BUY_OK"
require "common/protocol/auto/ACK_GOODS_LANTERN_INDEX"
require "common/protocol/ACK_GOODS_LANTERN_BACK"
require "common/protocol/ACK_GOODS_TIMES_GOODS_BACK"
require "common/protocol/auto/ACK_GOODS_TIMES_XXX1"
require "common/protocol/auto/ACK_GOODS_TIMES_XXX2"
require "common/protocol/auto/ACK_GOODS_TIMES_XXX3"
require "common/protocol/auto/ACK_GOODS_ACTY_USE_STATE"
require "common/protocol/ACK_GOODS_SHOP_DATA"
require "common/protocol/auto/ACK_MAKE_MAKE_OK"
require "common/protocol/ACK_MAKE_STREN_DATA_BACK"
require "common/protocol/auto/ACK_MAKE_STREN_COST_XXX"
require "common/protocol/auto/ACK_MAKE_STREN_MAX"
require "common/protocol/auto/ACK_MAKE_STRENGTHEN_OK"
require "common/protocol/auto/ACK_MAKE_UPGRADE_OK"
require "common/protocol/ACK_MAKE_WASH_BACK"
require "common/protocol/ACK_MAKE_PLUS_MSG_XXX"
require "common/protocol/ACK_MAKE_PLUS_MSG_XXX2"
require "common/protocol/auto/ACK_MAKE_WASH_OK"
require "common/protocol/auto/ACK_MAKE_COMPOSE_OK"
require "common/protocol/auto/ACK_MAKE_PEARL_INSET_OK"
require "common/protocol/auto/ACK_MAKE_MAGIC_PART_OK"
require "common/protocol/auto/ACK_MAKE_ENCHANT_OK"
require "common/protocol/auto/ACK_MAKE_ENCHANT_PAY"
require "common/protocol/ACK_TASK_DATA"
require "common/protocol/auto/ACK_TASK_MONSTER_DETAIL"
require "common/protocol/auto/ACK_TASK_TASK_DRAMA"
require "common/protocol/auto/ACK_TASK_REMOVE"
require "common/protocol/ACK_TEAM_REPLY"
require "common/protocol/auto/ACK_TEAM_REPLY_MSG"
require "common/protocol/ACK_TEAM_PASS_REPLY"
require "common/protocol/auto/ACK_TEAM_PASS_MSG"
require "common/protocol/ACK_TEAM_TEAM_INFO_NEW"
require "common/protocol/auto/ACK_TEAM_MEM_MSG_NEW"
require "common/protocol/ACK_TEAM_TEAM_INFO"
require "common/protocol/auto/ACK_TEAM_MEM_MSG"
require "common/protocol/auto/ACK_TEAM_LEAVE_NOTICE"
require "common/protocol/auto/ACK_TEAM_APPLY_NOTICE"
require "common/protocol/auto/ACK_TEAM_NEW_LEADER"
require "common/protocol/auto/ACK_TEAM_INVITE_NOTICE"
require "common/protocol/auto/ACK_TEAM_LIVE_REP"
require "common/protocol/ACK_FRIEND_INFO"
require "common/protocol/auto/ACK_FRIEND_INFO_GROUP"
require "common/protocol/auto/ACK_FRIEND_DEL_OK"
require "common/protocol/ACK_FRIEND_SEARCH_REPLY"
require "common/protocol/auto/ACK_FRIEND_ADD_NOTICE"
require "common/protocol/ACK_FRIEND_SYS_FRIEND"
require "common/protocol/auto/ACK_SCENE_ENTER_OK"
require "common/protocol/ACK_SCENE_PLAYER_LIST"
require "common/protocol/auto/ACK_SCENE_ROLE_DATA"
require "common/protocol/ACK_SCENE_PARTNER_LIST"
require "common/protocol/auto/ACK_SCENE_PARTNER_DATA"
require "common/protocol/ACK_SCENE_IDX_MONSTER"
require "common/protocol/auto/ACK_SCENE_MONSTER_DATA"
require "common/protocol/auto/ACK_SCENE_MOVE_RECE"
require "common/protocol/auto/ACK_SCENE_SET_PLAYER_XY"
require "common/protocol/auto/ACK_SCENE_OUT"
require "common/protocol/auto/ACK_SCENE_RELIVE"
require "common/protocol/auto/ACK_SCENE_RELIVE_OK"
require "common/protocol/auto/ACK_SCENE_HP_UPDATE"
require "common/protocol/ACK_SCENE_CHANGE_TITLE"
require "common/protocol/auto/ACK_SCENE_CHANGE_ARTIFACT"
require "common/protocol/auto/ACK_SCENE_CHANGE_CLAN"
require "common/protocol/auto/ACK_SCENE_LEVEL_UP"
require "common/protocol/auto/ACK_SCENE_CHANGE_TEAM"
require "common/protocol/auto/ACK_SCENE_CHANGE_MOUNT"
require "common/protocol/auto/ACK_SCENE_CHANGE_STATE"
require "common/protocol/auto/ACK_SCENE_CHANGE_VIP"
require "common/protocol/ACK_WAR_PLAYER_WAR"
require "common/protocol/auto/ACK_WAR_SKILL"
require "common/protocol/auto/ACK_WAR_PK_RECEIVE"
require "common/protocol/auto/ACK_WAR_PK_TIME"
require "common/protocol/auto/ACK_WAR_PK_LOSE"
require "common/protocol/auto/ACK_SKILL_LIST"
require "common/protocol/auto/ACK_SKILL_INFO"
require "common/protocol/auto/ACK_SKILL_EQUIP_INFO"
require "common/protocol/auto/ACK_SKILL_PARENTINFO"
require "common/protocol/ACK_COPY_REVERSE_OLD"
require "common/protocol/auto/ACK_COPY_MSG_REVERSE_OLD"
require "common/protocol/ACK_COPY_CHAP_DATA"
require "common/protocol/auto/ACK_COPY_MSG_BATTLE"
require "common/protocol/ACK_COPY_CHAP_DATA_NEW"
require "common/protocol/ACK_COPY_MSG_BATTLE_NEW"
require "common/protocol/auto/ACK_COPY_TIME_UPDATE"
require "common/protocol/auto/ACK_COPY_SCENE_TIME"
require "common/protocol/auto/ACK_COPY_ENTER_SCENE_INFO"
require "common/protocol/auto/ACK_COPY_SCENE_OVER"
require "common/protocol/ACK_COPY_OVER"
require "common/protocol/auto/ACK_COPY_MSG_GOOD"
require "common/protocol/auto/ACK_COPY_FAIL"
require "common/protocol/auto/ACK_COPY_EXIT_OK"
require "common/protocol/ACK_COPY_UP_RESULT"
require "common/protocol/auto/ACK_COPY_UP_OVER"
require "common/protocol/ACK_COPY_LOGIN_NOTICE"
require "common/protocol/auto/ACK_COPY_CHAP_RE_REP"
require "common/protocol/ACK_MAIL_LIST"
require "common/protocol/auto/ACK_MAIL_MODEL"
require "common/protocol/auto/ACK_MAIL_OK_SEND"
require "common/protocol/ACK_MAIL_INFO"
require "common/protocol/auto/ACK_MAIL_VGOODS_MODEL"
require "common/protocol/ACK_MAIL_OK_PICK"
require "common/protocol/ACK_MAIL_OK_DEL"
require "common/protocol/auto/ACK_MAIL_IDLIST"
require "common/protocol/auto/ACK_FCM_PROMPT"
require "common/protocol/auto/ACK_CHAT_OFFICE_PLAYER"
require "common/protocol/ACK_CHAT_RECE"
require "common/protocol/auto/ACK_WISH_SUCCESS"
require "common/protocol/auto/ACK_WISH_RECV"
require "common/protocol/auto/ACK_WISH_EXP_SUCCESS"
require "common/protocol/auto/ACK_WISH_EXP_DATA_BACK"
require "common/protocol/auto/ACK_WISH_LV_UP"
require "common/protocol/auto/ACK_WISH_DOUBLE_DATA"
require "common/protocol/auto/ACK_TITLE_CAST"
require "common/protocol/ACK_TITLE_LIST_BACK"
require "common/protocol/ACK_TITLE_XXX1"
require "common/protocol/auto/ACK_MOUNT_DEFAULT_SUCCESS"
require "common/protocol/auto/ACK_MOUNT_RIDE_OK"
require "common/protocol/ACK_MOUNT_LLUSION_REPLY"
require "common/protocol/auto/ACK_MOUNT_MOUNT_REPLY"
require "common/protocol/auto/ACK_MOUNT_CUL_RESULT"
require "common/protocol/ACK_MOUNT_LLUSION_REPLY_E"
require "common/protocol/auto/ACK_MOUNT_MOUNT_FRUIT"
require "common/protocol/ACK_COUNTRY_INFO_RESULT"
require "common/protocol/auto/ACK_COUNTRY_SELECT_RESULT"
require "common/protocol/auto/ACK_COUNTRY_CHANGE_RESULT"
require "common/protocol/ACK_COUNTRY_RANK_RESULT"
require "common/protocol/auto/ACK_COUNTRY_PUBLISH_NOTICE_R"
require "common/protocol/auto/ACK_COUNTRY_POST_NOTICE"
require "common/protocol/ACK_COUNTRY_EVENT_BROADCAST"
require "common/protocol/ACK_FISHING_OK_FISHING"
require "common/protocol/auto/ACK_FISHING_FISH_DATE"
require "common/protocol/auto/ACK_FISHING_OK_GO_FISHING"
require "common/protocol/auto/ACK_FISHING_CATCH_FISH"
require "common/protocol/ACK_FISHING_OK_GET_FISH"
require "common/protocol/auto/ACK_HONOR_REWARD_OK"
require "common/protocol/ACK_HONOR_LIST_RETURN"
require "common/protocol/ACK_HONOR_REACH_TIP"
require "common/protocol/auto/ACK_DEFEND_BOOK_INTER_SCENE"
require "common/protocol/auto/ACK_DEFEND_BOOK_TIME"
require "common/protocol/ACK_DEFEND_BOOK_OK_MONST_DATA"
require "common/protocol/auto/ACK_DEFEND_BOOK_MONSTER"
require "common/protocol/auto/ACK_DEFEND_BOOK_MONSTER_DATA"
require "common/protocol/auto/ACK_DEFEND_BOOK_SELF_HARM"
require "common/protocol/ACK_DEFEND_BOOK_RANKING"
require "common/protocol/auto/ACK_DEFEND_BOOK_RANK_DATA"
require "common/protocol/auto/ACK_DEFEND_BOOK_CAMP_INTEGRAL"
require "common/protocol/auto/ACK_DEFEND_BOOK_CAMP_INTEGRAL_N"
require "common/protocol/ACK_DEFEND_BOOK_TRENCH_DATE"
require "common/protocol/ACK_DEFEND_BOOK_PLAYER_DATE"
require "common/protocol/auto/ACK_DEFEND_BOOK_DATE_TRENCH"
require "common/protocol/auto/ACK_DEFEND_BOOK_OK_TRENCH"
require "common/protocol/auto/ACK_DEFEND_BOOK_WAR_RETRUN"
require "common/protocol/auto/ACK_DEFEND_BOOK_WAR_MONSTERS"
require "common/protocol/auto/ACK_DEFEND_BOOK_KILL_PLAYERS"
require "common/protocol/ACK_DEFEND_BOOK_KILL_REWARDS"
require "common/protocol/auto/ACK_DEFEND_BOOK_OK_GET_REWARDS"
require "common/protocol/auto/ACK_DEFEND_BOOK_OK_REVIVE"
require "common/protocol/ACK_DEFEND_BOOK_START_BUFF"
require "common/protocol/ACK_DEFEND_BOOK_OK_GAIN"
require "common/protocol/auto/ACK_RENOWN_REQUEST_OK"
require "common/protocol/auto/ACK_RENOWN_NOTICE"
require "common/protocol/auto/ACK_RENOWN_REWARD_OK"
require "common/protocol/ACK_WELFARE_CONTINUE_BACK"
require "common/protocol/ACK_WELFARE_CUMUL_BACK"
require "common/protocol/ACK_WELFARE_PAY_BACK"
require "common/protocol/auto/ACK_WELFARE_RECOVER_EXP"
require "common/protocol/auto/ACK_WELFARE_REWARD_RESULT"
require "common/protocol/auto/ACK_WELFARE_YELLOW_DAY_BACK"
require "common/protocol/auto/ACK_WELFARE_YELLOW_GROW_BACK"
require "common/protocol/ACK_GAME_LOGS_NOTICES"
require "common/protocol/auto/ACK_GAME_LOGS_MESS"
require "common/protocol/ACK_GAME_LOGS_EVENT"
require "common/protocol/auto/ACK_GAME_LOGS_STR_XXX"
require "common/protocol/auto/ACK_GAME_LOGS_INT_XXX"
require "common/protocol/ACK_PET_PET"
require "common/protocol/ACK_PET_REVERSE"
require "common/protocol/ACK_PET_SKILLS"
require "common/protocol/auto/ACK_PET_SKINS"
require "common/protocol/auto/ACK_PET_OPEN_OK"
require "common/protocol/auto/ACK_PET_CALL_OK"
require "common/protocol/auto/ACK_PET_NEED_RMB_REPLY"
require "common/protocol/auto/ACK_PET_XIULIAN_OK"
require "common/protocol/auto/ACK_PET_HUANHUA_REPLY"
require "common/protocol/auto/ACK_PET_CTN_ENLARGE_OK"
require "common/protocol/ACK_PET_HH_REPLY_MSG"
require "common/protocol/ACK_ARENA_DEKARON"
require "common/protocol/auto/ACK_ARENA_CANBECHALLAGE"
require "common/protocol/ACK_ARENA_WAR_DATA"
require "common/protocol/auto/ACK_ARENA_STRAT"
require "common/protocol/auto/ACK_ARENA_WAR_REWARD"
require "common/protocol/auto/ACK_ARENA_RADIO"
require "common/protocol/auto/ACK_ARENA_RESULT2"
require "common/protocol/auto/ACK_ARENA_BUY_OK"
require "common/protocol/auto/ACK_ARENA_OK"
require "common/protocol/ACK_ARENA_KILLER_DATA"
require "common/protocol/ACK_ARENA_ACE"
require "common/protocol/ACK_ARENA_MAX_DATA"
require "common/protocol/ACK_ARENA_GET_REWARD"
require "common/protocol/auto/ACK_ARENA_GOODS_LIST"
require "common/protocol/auto/ACK_ARENA_REWARD_TIMES"
require "common/protocol/auto/ACK_ARENA_CLEAN_OK"
require "common/protocol/ACK_TOP_DATE"
require "common/protocol/auto/ACK_TOP_XXXX"
require "common/protocol/ACK_CARD_SUCCEED"
require "common/protocol/ACK_CARD_SALES_DATA"
require "common/protocol/ACK_CARD_ID_DATE"
require "common/protocol/auto/ACK_CARD_ID_SUB"
require "common/protocol/auto/ACK_CARD_GET_OK"
require "common/protocol/auto/ACK_CARD_NOTICE"
require "common/protocol/ACK_CARD_RECE"
require "common/protocol/auto/ACK_CARD_XXXXX"
require "common/protocol/ACK_NPC_LIST"
require "common/protocol/auto/ACK_NPC_COPY_ID"
require "common/protocol/auto/ACK_NPC_CLOSE"
require "common/protocol/auto/ACK_NPC_NOTICE_DELETE"
require "common/protocol/auto/ACK_NPC_NOTICE_HIDE"
require "common/protocol/ACK_ARRAY_LIST_DATA"
require "common/protocol/auto/ACK_ARRAY_ROLE_INFO"
require "common/protocol/auto/ACK_ACTIVITY_DATA"
require "common/protocol/ACK_ACTIVITY_OK_ACTIVE_DATA"
require "common/protocol/auto/ACK_ACTIVITY_ACTIVE_DATA"
require "common/protocol/ACK_ACTIVITY_OK_LINK_DATA"
require "common/protocol/auto/ACK_ACTIVITY_ACTIVE_LINK_MSG"
require "common/protocol/auto/ACK_ACTIVITY_REWARDS_DATA"
require "common/protocol/auto/ACK_ACTIVITY_OK_GET_REWARDS"
require "common/protocol/ACK_INN_LIST"
require "common/protocol/auto/ACK_INN_H_DATA"
require "common/protocol/auto/ACK_INN_RES_PARTNER"
require "common/protocol/auto/ACK_WEAGOD_REPLY"
require "common/protocol/auto/ACK_WEAGOD_SUCCESS"
require "common/protocol/auto/ACK_CLAN_MESSAGE"
require "common/protocol/auto/ACK_CLAN_OK_CLAN_DATA"
require "common/protocol/auto/ACK_CLAN_OK_OTHER_DATA"
require "common/protocol/ACK_CLAN_CLAN_LOGS"
require "common/protocol/ACK_CLAN_LOGS_MSG"
require "common/protocol/auto/ACK_CLAN_STRING_MSG"
require "common/protocol/auto/ACK_CLAN_INT_MSG"
require "common/protocol/ACK_CLAN_OK_CLANLIST"
require "common/protocol/ACK_CLAN_APPLIED_CLANLIST"
require "common/protocol/auto/ACK_CLAN_OK_JOIN_CLAN"
require "common/protocol/auto/ACK_CLAN_OK_REBUILD_CLAN"
require "common/protocol/ACK_CLAN_OK_JOIN_LIST"
require "common/protocol/auto/ACK_CLAN_USER_DATA"
require "common/protocol/auto/ACK_CLAN_OK_AUDIT"
require "common/protocol/auto/ACK_CLAN_OK_RESET_CAST"
require "common/protocol/ACK_CLAN_OK_MEMBER_LIST"
require "common/protocol/auto/ACK_CLAN_MEMBER_MSG"
require "common/protocol/auto/ACK_CLAN_OK_OUT_CLAN"
require "common/protocol/ACK_CLAN_OK_CLAN_SKILL"
require "common/protocol/auto/ACK_CLAN_CLAN_ATTR_DATA"
require "common/protocol/auto/ACK_CLAN_NOW_STAMINA"
require "common/protocol/ACK_CLAN_OK_ACTIVE_DATA"
require "common/protocol/auto/ACK_CLAN_ACTIVE_MSG"
require "common/protocol/ACK_CLAN_OK_WATER_DATA"
require "common/protocol/auto/ACK_CLAN_WATER_LOGS_DATA"
require "common/protocol/auto/ACK_CLAN_OK_STRENGTH"
require "common/protocol/auto/ACK_DRAGON_OK_JOIN_DRAGON"
require "common/protocol/ACK_DRAGON_OK_START_DRAGON"
require "common/protocol/ACK_DRAGON_OK_START_NEW"
require "common/protocol/auto/ACK_DRAGON_REWARDS_MSG"
require "common/protocol/auto/ACK_SHOP_INFO"
require "common/protocol/ACK_SHOP_INFO_NEW"
require "common/protocol/ACK_SHOP_REQUEST_OK"
require "common/protocol/ACK_SHOP_REQUEST_OK_NEW"
require "common/protocol/auto/ACK_SHOP_BUY_SUCC"
require "common/protocol/auto/ACK_SHOP_INTEGRAL_BACK"
require "common/protocol/ACK_MOIL_MOIL_DATA"
require "common/protocol/ACK_MOIL_MOIL_RS"
require "common/protocol/auto/ACK_MOIL_PROTECT_TIME"
require "common/protocol/ACK_MOIL_PROTECT_COUNT"
require "common/protocol/ACK_MOIL_PLAYER_DATA"
require "common/protocol/auto/ACK_MOIL_MOIL_XXXX1"
require "common/protocol/ACK_MOIL_PRESS_DATA"
require "common/protocol/auto/ACK_MOIL_MOIL_XXXX2"
require "common/protocol/auto/ACK_MOIL_MOIL_XXXX3"
require "common/protocol/ACK_MOIL_PRESS_RS"
require "common/protocol/auto/ACK_MOIL_PRESS_XX"
require "common/protocol/auto/ACK_MOIL_RELEASE_RS"
require "common/protocol/auto/ACK_MOIL_BUY_OK"
require "common/protocol/ACK_CIRCLE_2_DATA"
require "common/protocol/ACK_CIRCLE_DATA"
require "common/protocol/auto/ACK_CIRCLE_DATA_GROUP"
require "common/protocol/auto/ACK_CIRCLE_2_DATA_GROUP"
require "common/protocol/auto/ACK_WORLD_BOSS_MAP_DATA"
require "common/protocol/auto/ACK_WORLD_BOSS_VIP_RMB"
require "common/protocol/auto/ACK_WORLD_BOSS_SELF_HP"
require "common/protocol/ACK_WORLD_BOSS_DPS"
require "common/protocol/auto/ACK_WORLD_BOSS_DPS_XX"
require "common/protocol/auto/ACK_WORLD_BOSS_WAR_RS"
require "common/protocol/auto/ACK_WORLD_BOSS_REVIVE_OK"
require "common/protocol/ACK_WORLD_BOSS_ADDITION"
require "common/protocol/auto/ACK_WORLD_BOSS_ADDITION_DATA"
require "common/protocol/auto/ACK_WORLD_BOSS_RMB_USE"
require "common/protocol/ACK_TARGET_LIST_BACK"
require "common/protocol/auto/ACK_TARGET_MSG_GROUP"
require "common/protocol/ACK_HERO_CHAP_DATA"
require "common/protocol/auto/ACK_HERO_MSG_BATTLE"
require "common/protocol/auto/ACK_HERO_BACK_TIMES"
require "common/protocol/ACK_HERO_CHAP_DATA_NEW"
require "common/protocol/ACK_HERO_MSG_BATTLE_NEW"
require "common/protocol/ACK_SIGN_DAYS"
require "common/protocol/auto/ACK_SIGN_REWARD_INFO"
require "common/protocol/auto/ACK_SIGN_GET_REWARDS_OK"
require "common/protocol/ACK_SKYWAR_TIME_DOWN"
require "common/protocol/auto/ACK_SKYWAR_TIME_BUFF"
require "common/protocol/auto/ACK_SKYWAR_LIMIT_BACK"
require "common/protocol/ACK_SKYWAR_LIST_DATA"
require "common/protocol/auto/ACK_SKYWAR_LIST_BACK"
require "common/protocol/auto/ACK_SKYWAR_ROLE_STATE"
require "common/protocol/auto/ACK_SKYWAR_STATE_PUNISH"
require "common/protocol/auto/ACK_SKYWAR_BOSS_HP"
require "common/protocol/ACK_SKYWAR_SCORE_BACK"
require "common/protocol/auto/ACK_SKYWAR_SCORE_CLAN"
require "common/protocol/auto/ACK_SKYWAR_SCORE_ROLE"
require "common/protocol/auto/ACK_SKYWAR_KILL_BOSS_BROAD"
require "common/protocol/auto/ACK_NIANSHOU_CREAT_OK"
require "common/protocol/auto/ACK_COLLECT_CARD_STATE_REFRESH"
require "common/protocol/auto/ACK_COLLECT_CARD_LIMIT_RESULT"
require "common/protocol/ACK_COLLECT_CARD_DATA_BACK"
require "common/protocol/ACK_COLLECT_CARD_XXX1"
require "common/protocol/auto/ACK_COLLECT_CARD_XXX2"
require "common/protocol/auto/ACK_COLLECT_CARD_XXX3"
require "common/protocol/auto/ACK_COLLECT_CARD_EXCHANGE_OK"
require "common/protocol/auto/ACK_COLLECT_CARD_COST_BACK"
require "common/protocol/auto/ACK_STRIDE_STATA"
require "common/protocol/auto/ACK_STRIDE_REPROT_OK"
require "common/protocol/ACK_STRIDE_RANK_DATA"
require "common/protocol/ACK_STRIDE_RANK_2_DATA"
require "common/protocol/auto/ACK_STRIDE_XXX_PATNER"
require "common/protocol/ACK_STRIDE_WAR_LOGS"
require "common/protocol/auto/ACK_STRIDE_WAR_2_LOGS"
require "common/protocol/ACK_STRIDE_WISH_DATE"
require "common/protocol/auto/ACK_STRIDE_WISH_2_DATE"
require "common/protocol/ACK_STRIDE_SOUL_COUNT"
require "common/protocol/ACK_STRIDE_PARTNER_OK"
require "common/protocol/auto/ACK_STRIDE_STRIDE_WAR_RS"
require "common/protocol/auto/ACK_STRIDE_BUY_OK"
require "common/protocol/auto/ACK_KEJU_OK_KEJU"
require "common/protocol/auto/ACK_KEJU_JIEGUO_KEJU"
require "common/protocol/ACK_KEJU_JIEGUO_YUQIAN"
require "common/protocol/ACK_KEJU_RANK_MSG_GROUP"
require "common/protocol/ACK_KINGHELL_BACK_KINGS"
require "common/protocol/ACK_KINGHELL_MSG_BACK_KING"
require "common/protocol/auto/ACK_KINGHELL_MSG_MONS"
require "common/protocol/ACK_KINGHELL_BACK_PARTNER"
require "common/protocol/auto/ACK_KINGHELL_MSG_PARTNER"
require "common/protocol/ACK_KINGHELL_BACK_XJ"
require "common/protocol/ACK_KINGHELL_MSG_XJ"
require "common/protocol/auto/ACK_KINGHELL_MSG_P_XJ"
require "common/protocol/auto/ACK_KINGHELL_XJ_UPDATE"
require "common/protocol/auto/ACK_KINGHELL_XJ_SWITCH_OK"
require "common/protocol/ACK_KINGHELL_BACK_YUANS"
require "common/protocol/auto/ACK_KINGHELL_MSG_YUANS"
require "common/protocol/auto/ACK_KINGHELL_BACK_FIRBEST"
require "common/protocol/auto/ACK_CAMPWAR_OK_ASK_WAR"
require "common/protocol/auto/ACK_CAMPWAR_D_TIME"
require "common/protocol/auto/ACK_CAMPWAR_CAMP_POINTS"
require "common/protocol/ACK_CAMPWAR_WINNING_STREAK"
require "common/protocol/auto/ACK_CAMPWAR_PLY_DATA"
require "common/protocol/auto/ACK_CAMPWAR_SELF_WAR"
require "common/protocol/ACK_CAMPWAR_OK_BESTIR"
require "common/protocol/auto/ACK_CAMPWAR_ATTR_MSG"
require "common/protocol/ACK_CAMPWAR_WAR_DATA"
require "common/protocol/auto/ACK_CAMPWAR_REWARDS_DATA"
require "common/protocol/ACK_CAMPWAR_OK_WARDATA"
require "common/protocol/auto/ACK_CAMPWAR_CAMP_END"
require "common/protocol/auto/ACK_WHEEL_XXX1"
require "common/protocol/ACK_WHEEL_DATA_BACK"
require "common/protocol/auto/ACK_WHEEL_IDX"
require "common/protocol/ACK_WHEEL_LOG"
require "common/protocol/ACK_FIEND_CHAP_DATA"
require "common/protocol/auto/ACK_FIEND_MSG_BATTLE"
require "common/protocol/auto/ACK_FIEND_FRESH_BACK"
require "common/protocol/ACK_FIEND_CHAP_DATA_NEW"
require "common/protocol/ACK_FIEND_MSG_BATTLE_NEW"
require "common/protocol/ACK_TREASURE_REQUEST_INFO"
require "common/protocol/auto/ACK_TREASURE_GOODSMSG"
require "common/protocol/auto/ACK_TREASURE_ATTRIBUTE"
require "common/protocol/ACK_TREASURE_SHOP_INFO"
require "common/protocol/ACK_TREASURE_SHOP_INFO_NEW"
require "common/protocol/auto/ACK_TREASURE_PURCHASE_STATE"
require "common/protocol/auto/ACK_TREASURE_COPY_STATE"
require "common/protocol/ACK_SYS_DOUQI_STORAGE_DATA"
require "common/protocol/auto/ACK_SYS_DOUQI_DOUQI_DATA"
require "common/protocol/auto/ACK_SYS_DOUQI_OK_GRASP_DATA"
require "common/protocol/ACK_SYS_DOUQI_MORE_GRASP"
require "common/protocol/ACK_SYS_DOUQI_MSG_MORE"
require "common/protocol/ACK_SYS_DOUQI_OK_DOUQI_ROLE"
require "common/protocol/ACK_SYS_DOUQI_ROLE_DATA"
require "common/protocol/ACK_SYS_DOUQI_EAT_STATE"
require "common/protocol/ACK_SYS_DOUQI_EAT_DATA"
require "common/protocol/auto/ACK_SYS_DOUQI_LAN_MSG"
require "common/protocol/ACK_SYS_DOUQI_OK_GET_DQ"
require "common/protocol/auto/ACK_SYS_DOUQI_OK_DQ_SPLIT"
require "common/protocol/ACK_SYS_DOUQI_OK_USE_DOUQI"
require "common/protocol/ACK_DAILY_TASK_DATA"
require "common/protocol/auto/ACK_DAILY_TASK_TURN"
require "common/protocol/auto/ACK_FLSH_TIMES_REPLY"
require "common/protocol/ACK_FLSH_PAI_REPLY"
require "common/protocol/auto/ACK_FLSH_PAI_DATA"
require "common/protocol/auto/ACK_FLSH_REWARD_OK"
require "common/protocol/ACK_SHOOT_REPLY"
require "common/protocol/auto/ACK_SHOOT_HEAD_INFO"
require "common/protocol/auto/ACK_SHOOT_AWARD_INFO"
require "common/protocol/auto/ACK_MAGIC_EQUIP_ENHANCED_REPLY"
require "common/protocol/auto/ACK_MAGIC_EQUIP_NEED_MONEY_REPLY"
require "common/protocol/ACK_MAGIC_EQUIP_ATTR_REPLY"
require "common/protocol/auto/ACK_MAGIC_EQUIP_MSG_ITEM_XXX"
require "common/protocol/auto/ACK_MAGIC_EQUIP_ATTR"
require "common/protocol/auto/ACK_PRIVILEGE_REPLY"
require "common/protocol/auto/ACK_PRIVILEGE_OPEN_REPLY"
require "common/protocol/auto/ACK_CLAN_BOSS_TIME_DOWN"
require "common/protocol/auto/ACK_CLAN_BOSS_HARM_DATA"
require "common/protocol/auto/ACK_CLAN_BOSS_ACTIVE_STATE"
require "common/protocol/auto/ACK_CLAN_BOSS_JOIN_DATA"
require "common/protocol/ACK_CLAN_BOSS_RANK_DATA"
require "common/protocol/auto/ACK_CLAN_BOSS_ROLE_DATA"
require "common/protocol/ACK_CLAN_BOSS_BUFF_DATA"
require "common/protocol/auto/ACK_CLAN_BOSS_BUFF_MSG"
require "common/protocol/auto/ACK_CLAN_BOSS_DIED_STATE"
require "common/protocol/auto/ACK_CLAN_BOSS_OK_RELIVE"
require "common/protocol/auto/ACK_WRESTLE_AREANK_RANK"
require "common/protocol/auto/ACK_WRESTLE_APPLY_STATE"
require "common/protocol/auto/ACK_WRESTLE_TIME"
require "common/protocol/auto/ACK_WRESTLE_PLAYER"
require "common/protocol/ACK_WRESTLE_SCORE_MSG"
require "common/protocol/auto/ACK_WRESTLE_XXXXX"
require "common/protocol/ACK_WRESTLE_FINAL_INFO"
require "common/protocol/auto/ACK_WRESTLE_AGAINST"
require "common/protocol/auto/ACK_WRESTLE_GUESS_STATE"
require "common/protocol/auto/ACK_WRESTLE_ZHENGBA_REQUEST"
require "common/protocol/auto/ACK_WRESTLE_PEBBLE"
require "common/protocol/ACK_WRESTLE_FINAL_REP"
require "common/protocol/ACK_WRESTLE_FINAL_REP_MSG"
require "common/protocol/ACK_FIGHTERS_CHAP_DATA"
require "common/protocol/auto/ACK_FIGHTERS_MSG_BATTLE"
require "common/protocol/auto/ACK_FIGHTERS_BUY_OK"
require "common/protocol/ACK_FIGHTERS_UP_REPLY"
require "common/protocol/ACK_FIGHTERS_MSG_GOOD"
require "common/protocol/auto/ACK_FIGHTERS_UP_OVER"
require "common/protocol/auto/ACK_FIGHTERS_UP_STOP_REP"
require "common/protocol/auto/ACK_FIGHTERS_UP_RESET_OK"
require "common/protocol/ACK_SYS_SET_TYPE_STATE"
require "common/protocol/auto/ACK_SYS_SET_XXXXX"
require "common/protocol/auto/ACK_DISCOVE_STORE_DATA"
require "common/protocol/auto/ACK_DISCOVE_STORE_GOODS"
--/** =============================== 自动生成的代码 =============================== **/
--/*************************** don't touch this line *********** AUTO_CODE_END_Const **/


_CNetwork = class(function(self)
    self:init()
end)

function _CNetwork.init(self)
    print("network init")
    self.m_bReconnect = true
    self.m_WaitLists = {}
end

--_G.netWorkUrl = "http://jjapi.gamecore.cn:89"         --外网
--  _G.netWorkUrl = "http://192.168.1.9:89"             --内网

if CLoginHttpApi:getInternalVerify() == true then
  
    local nState = LUA_NETWORK() or 1
    print("网络类型： 1:内网, 2:外网 -->", nState)
    if nState == 1 then
        _G.netWorkUrl = "http://192.168.1.9:89"
    elseif nState == 2 then
        _G.netWorkUrl = "http://jjapi.appqj.com"
    end
    
else
    _G.netWorkUrl = "http://jjapi.appqj.com"
end

function _CNetwork.connect(self, ip, port )
    local ret = 1	--CTcpClient:sharedTcpClient():connect(ip, port)
    if ret == 1 then
    	self:clearWaitingMessages()
    end
end

function _CNetwork.disconnect(self)
    -- CTcpClient:sharedTcpClient():close()
end

function _CNetwork.pause(self)
    -- CTcpClient:sharedTcpClient():setPauseProcess(true)
end

function _CNetwork.resume(self)
    -- CTcpClient:sharedTcpClient():setPauseProcess(false)
end

function _CNetwork.setReconnect(self, bValue)
    self.m_bReconnect = bValue
end

function _CNetwork.getReconnect(self)
    return self.m_bReconnect
end

function _CNetwork.isConnected(self)
	return true --CTcpClient:sharedTcpClient():isConnected()
end

function _CNetwork.send(self, requestMessage)
    if requestMessage:is(CRequestMessage) then
        local req = CReqMessage(requestMessage.MsgID)
        local writer = CDataWriter(req:getStreamData())
        req:serialize(writer)
        requestMessage:serialize(writer)
        req:setLength(writer:getPosition())
        CTcpClient:sharedTcpClient():send(req)
        --
        if requestMessage.ReactProtocol ~= nil 
        	and requestMessage.ReactTime ~= nil 
        	and type(requestMessage.ReactProtocol) == "table"
            and #requestMessage.ReactProtocol > 0 
            and type(requestMessage.ReactTime) == "number" 
            and requestMessage.ReactTime > 0 then
            
            local protocolTab = requestMessage.ReactProtocol
            local voReact = VO_NetworkAsyncObject( requestMessage.ReactTime , protocolTab )
            table.insert(self.m_WaitLists, voReact)
            local voCommand = CNetworkAsyncCommand(CNetworkAsyncCommand.ACT_WAIT, voReact)
            controller:sendCommand(voCommand)
            protocolTab = nil
            voReact = nil
            voCommand = nil
        end
        --writer:release()
        --req:release()
        req = nil
        writer = nil
        CCLOG("请求服务器 信息ID %s",requestMessage.MsgID)
    end
end

function _CNetwork.clearWaitingMessages(self)
	self.m_WaitLists = nil
	self.m_WaitLists = {}
end

local function func_desc(a,b)
	return a>b
end

function _CNetwork.parse(self, eventType, ackMessage)
    if eventType == "NETWORK_MESSAGE" and ackMessage ~= nil then
        local msgID = ackMessage:getMsgID()
        local ackMsgClsName = Protocol[msgID]
        if ackMsgClsName == nil then
            CCLOG("msgID not define = "..tostring(msgID))
            return nil
        end
        local clsName = "common/protocol/"..ackMsgClsName
        local cls=_G[ackMsgClsName]
        if cls ~= nil then
            if self.m_WaitLists ~= nil and #self.m_WaitLists > 0 then
                local r = {}
                for i,v in ipairs(self.m_WaitLists) do
                	CCLOG("-----------=====>>")
	                    for i2,v2 in pairs(v:getProtocolList()) do
	                    	CCLOG(tostring(i2)..","..tostring(v2))
	                        if v2 == msgID then
	                            table.insert(r, i)
	                            break
	                        end
	                    end
                	CCLOG("<<-----------=====")
                end

                table.sort(r, func_desc)
                
                if #r ~= 0 then
                    for i,v in ipairs(r) do
                        table.remove(self.m_WaitLists, v)
                    end
                    if #self.m_WaitLists == 0 then
                        local voCommand = CNetworkAsyncCommand(CNetworkAsyncCommand.ACT_CONTINUE)
                        controller:sendCommand(voCommand)
                    end
                end
            end
            local ackMsg = cls()
            ackMessage:resetStream()
            local reader = CDataReader(ackMessage:getStreamData())
            ackMsg:deserialize(reader)
            --

            --
            --reader:release()
            return ackMsg
        end
    end
end

_G.CNetwork = _CNetwork()