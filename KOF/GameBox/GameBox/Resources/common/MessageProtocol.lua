_G.Protocol = 
{
    --/** AUTO_CODE_BEGIN_Protocol **************** don't touch this line ********************/
	--/** =============================== 自动生成的代码 =============================== **/

	--------------------------------------------------------
	-- 1 - 500 ( 预留 ) 
	--------------------------------------------------------

	--------------------------------------------------------
	-- 501 - 1000 ( 系统 ) 
	--------------------------------------------------------
	-- [500]重置连接hex -- 系统 
	ACK_SYSTEM_RESET_IDX             = 500,       [500] = "ACK_SYSTEM_RESET_IDX", 
	-- [501]角色心跳 -- 系统 
	REQ_SYSTEM_HEART                 = 501,       [501] = "REQ_SYSTEM_HEART", 
	-- [502]服务器将断开连接 -- 系统 
	ACK_SYSTEM_DISCONNECT            = 502,       [502] = "ACK_SYSTEM_DISCONNECT", 
	-- [510]时间校正 -- 系统 
	ACK_SYSTEM_TIME                  = 510,       [510] = "ACK_SYSTEM_TIME", 
	-- [700]错误代码 -- 系统 
	ACK_SYSTEM_ERROR                 = 700,       [700] = "ACK_SYSTEM_ERROR", 
	-- [800]系统通知 -- 系统 
	ACK_SYSTEM_NOTICE                = 800,       [800] = "ACK_SYSTEM_NOTICE", 
	-- [810]游戏广播 -- 系统 
	ACK_SYSTEM_BROADCAST             = 810,       [810] = "ACK_SYSTEM_BROADCAST", 
	-- [811]广播信息块 -- 系统 
	ACK_SYSTEM_DATA_XXX              = 811,       [811] = "ACK_SYSTEM_DATA_XXX", 
	-- [820]游戏提示 -- 系统 
	ACK_SYSTEM_TIPS                  = 820,       [820] = "ACK_SYSTEM_TIPS", 
	-- [830]查询是否可充值 -- 系统 
	REQ_SYSTEM_PAY_CHECK             = 830,       [830] = "REQ_SYSTEM_PAY_CHECK", 
	-- [840]充值查询结果返回 -- 系统 
	ACK_SYSTEM_PAY_STATE             = 840,       [840] = "ACK_SYSTEM_PAY_STATE", 

	--------------------------------------------------------
	-- 1001 - 2000 ( 角色 ) 
	--------------------------------------------------------
	-- [1010]角色登录 -- 角色 
	REQ_ROLE_LOGIN                   = 1010,       [1010] = "REQ_ROLE_LOGIN", 
	-- [1012]断线重连返回 -- 角色 
	ACK_ROLE_LOGIN_AG_ERR            = 1012,       [1012] = "ACK_ROLE_LOGIN_AG_ERR", 
	-- [1020]创建角色 -- 角色 
	REQ_ROLE_CREATE                  = 1020,       [1020] = "REQ_ROLE_CREATE", 
	-- [1021]创建/登录(有角色)成功 -- 角色 
	ACK_ROLE_LOGIN_OK_HAVE           = 1021,       [1021] = "ACK_ROLE_LOGIN_OK_HAVE", 
	-- [1022]货币 -- 角色 
	ACK_ROLE_CURRENCY                = 1022,       [1022] = "ACK_ROLE_CURRENCY", 
	-- [1023]登录成功(没有角色) -- 角色 
	ACK_ROLE_LOGIN_OK_NO_ROLE        = 1023,       [1023] = "ACK_ROLE_LOGIN_OK_NO_ROLE", 
	-- [1024]请求随机名字 -- 角色 
	REQ_ROLE_RAND_NAME               = 1024,       [1024] = "REQ_ROLE_RAND_NAME", 
	-- [1025]返回名字 -- 角色 
	ACK_ROLE_NAME                    = 1025,       [1025] = "ACK_ROLE_NAME", 
	-- [1030]登录失败 -- 角色 
	ACK_ROLE_LOGIN_FAIL              = 1030,       [1030] = "ACK_ROLE_LOGIN_FAIL", 
	-- [1050]创建失败 -- 角色 
	ACK_ROLE_CREATE_FAIL             = 1050,       [1050] = "ACK_ROLE_CREATE_FAIL", 
	-- [1060]销毁角色 -- 角色 
	REQ_ROLE_DEL                     = 1060,       [1060] = "REQ_ROLE_DEL", 
	-- [1061]销毁角色(成功) -- 角色 
	ACK_ROLE_DEL_OK                  = 1061,       [1061] = "ACK_ROLE_DEL_OK", 
	-- [1063]销毁角色(失败) -- 角色 
	ACK_ROLE_DEL_FAIL                = 1063,       [1063] = "ACK_ROLE_DEL_FAIL", 
	-- [1101]请求玩家属性 -- 角色 
	REQ_ROLE_PROPERTY                = 1101,       [1101] = "REQ_ROLE_PROPERTY", 
	-- [1108]玩家属性 -- 角色 
	ACK_ROLE_PROPERTY_REVE           = 1108,       [1108] = "ACK_ROLE_PROPERTY_REVE", 
	-- [1109]伙伴属性 -- 角色 
	ACK_ROLE_PARTNER_DATA            = 1109,       [1109] = "ACK_ROLE_PARTNER_DATA", 
	-- [1115]请求玩家排名更新 -- 角色 
	REQ_ROLE_RANK_UPDATE             = 1115,       [1115] = "REQ_ROLE_RANK_UPDATE", 
	-- [1121]请求玩家扩展属性(暂无效) -- 角色 
	REQ_ROLE_PROPERTY_EXT            = 1121,       [1121] = "REQ_ROLE_PROPERTY_EXT", 
	-- [1128]玩家扩展属性(暂无效) -- 角色 
	ACK_ROLE_PROPERTY_EXT_R          = 1128,       [1128] = "ACK_ROLE_PROPERTY_EXT_R", 
	-- [1130]玩家单个属性更新 -- 角色 
	ACK_ROLE_PROPERTY_UPDATE         = 1130,       [1130] = "ACK_ROLE_PROPERTY_UPDATE", 
	-- [1131]玩家单个属性更新[字符串] -- 角色 
	ACK_ROLE_PROPERTY_UPDATE2        = 1131,       [1131] = "ACK_ROLE_PROPERTY_UPDATE2", 
	-- [1140]请求NPC -- 角色 
	REQ_ROLE_REQUEST_NPC             = 1140,       [1140] = "REQ_ROLE_REQUEST_NPC", 
	-- [1150]返回角色任务已开放系统 -- 角色 
	ACK_ROLE_SYS                     = 1150,       [1150] = "ACK_ROLE_SYS", 
	-- [1160]角色任务开放系统 -- 角色 
	ACK_ROLE_OPEN_SYS                = 1160,       [1160] = "ACK_ROLE_OPEN_SYS", 
	-- [1240]腾讯玩家登陆 -- 角色 
	REQ_ROLE_LOGIN_N                 = 1240,       [1240] = "REQ_ROLE_LOGIN_N", 
	-- [1241]腾讯创建角色 -- 角色 
	REQ_ROLE_CREATE_N                = 1241,       [1241] = "REQ_ROLE_CREATE_N", 
	-- [1260]请求体力值 -- 角色 
	REQ_ROLE_ENERGY                  = 1260,       [1260] = "REQ_ROLE_ENERGY", 
	-- [1261]请求体力值成功 -- 角色 
	ACK_ROLE_ENERGY_OK               = 1261,       [1261] = "ACK_ROLE_ENERGY_OK", 
	-- [1262]额外赠送精力 -- 角色 
	ACK_ROLE_BUFF_ENERGY             = 1262,       [1262] = "ACK_ROLE_BUFF_ENERGY", 
	-- [1263]请求购买体力面板 -- 角色 
	REQ_ROLE_ASK_BUY_ENERGY          = 1263,       [1263] = "REQ_ROLE_ASK_BUY_ENERGY", 
	-- [1264]请求购买面板成功 -- 角色 
	ACK_ROLE_OK_ASK_BUYE             = 1264,       [1264] = "ACK_ROLE_OK_ASK_BUYE", 
	-- [1265]购买体力 -- 角色 
	REQ_ROLE_BUY_ENERGY              = 1265,       [1265] = "REQ_ROLE_BUY_ENERGY", 
	-- [1267]购买精力成功 -- 角色 
	ACK_ROLE_OK_BUY_ENERGY           = 1267,       [1267] = "ACK_ROLE_OK_BUY_ENERGY", 
	-- [1269]使用功能 -- 角色 
	REQ_ROLE_USE_SYS                 = 1269,       [1269] = "REQ_ROLE_USE_SYS", 
	-- [1270]开启的系统ID -- 角色 
	ACK_ROLE_SYS_ID                  = 1270,       [1270] = "ACK_ROLE_SYS_ID", 
	-- [1271]开启的系统ID(新) -- 角色 
	ACK_ROLE_SYS_ID_2                = 1271,       [1271] = "ACK_ROLE_SYS_ID_2", 
	-- [1310]请求VIP(自己) -- 角色 
	REQ_ROLE_VIP_MY                  = 1310,       [1310] = "REQ_ROLE_VIP_MY", 
	-- [1311]请求vip回复 -- 角色 
	ACK_ROLE_LV_MY                   = 1311,       [1311] = "ACK_ROLE_LV_MY", 
	-- [1312]请求玩家VIP -- 角色 
	REQ_ROLE_VIP                     = 1312,       [1312] = "REQ_ROLE_VIP", 
	-- [1313]玩家VIP等级 -- 角色 
	ACK_ROLE_VIP_LV                  = 1313,       [1313] = "ACK_ROLE_VIP_LV", 
	-- [1330]提醒签到 -- 角色 
	ACK_ROLE_NOTICE                  = 1330,       [1330] = "ACK_ROLE_NOTICE", 
	-- [1331]请求签到面板 -- 角色 
	REQ_ROLE_REQUEST                 = 1331,       [1331] = "REQ_ROLE_REQUEST", 
	-- [1332]请求签到面板成功 -- 角色 
	ACK_ROLE_OK_REQUEST              = 1332,       [1332] = "ACK_ROLE_OK_REQUEST", 
	-- [1333]玩家点击签到 -- 角色 
	REQ_ROLE_CLICK                   = 1333,       [1333] = "REQ_ROLE_CLICK", 
	-- [1334]玩家签到成功 -- 角色 
	ACK_ROLE_OK_CLICK                = 1334,       [1334] = "ACK_ROLE_OK_CLICK", 
	-- [1340]在线奖励 -- 角色 
	ACK_ROLE_ONLINE_REWARD           = 1340,       [1340] = "ACK_ROLE_ONLINE_REWARD", 
	-- [1341]等级礼包 -- 角色 
	ACK_ROLE_LEVEL_GIFT              = 1341,       [1341] = "ACK_ROLE_LEVEL_GIFT", 
	-- [1350]领取 -- 角色 
	REQ_ROLE_ONLINE_OK               = 1350,       [1350] = "REQ_ROLE_ONLINE_OK", 
	-- [1351]领取等级礼包 -- 角色 
	REQ_ROLE_LEVEL_GIFT_OK           = 1351,       [1351] = "REQ_ROLE_LEVEL_GIFT_OK", 
	-- [1355]buff数据(欲废除) -- 角色 
	ACK_ROLE_BUFF_DATA               = 1355,       [1355] = "ACK_ROLE_BUFF_DATA", 
	-- [1360]buff数据 -- 角色 
	ACK_ROLE_BUFF1_DATA              = 1360,       [1360] = "ACK_ROLE_BUFF1_DATA", 
	-- [1365]buffs数据 -- 角色 
	ACK_ROLE_XXFFS_DATA              = 1365,       [1365] = "ACK_ROLE_XXFFS_DATA", 
	-- [1370]通知加buff -- 角色 
	ACK_ROLE_BUFF                    = 1370,       [1370] = "ACK_ROLE_BUFF", 
	-- [1375]请求领取buff -- 角色 
	REQ_ROLE_BUFF_REQUEST            = 1375,       [1375] = "REQ_ROLE_BUFF_REQUEST", 

	--------------------------------------------------------
	-- 2001 - 2500 ( 物品/背包 ) 
	--------------------------------------------------------
	-- [2001]物品信息块 -- 物品/背包 
	ACK_GOODS_XXX1                   = 2001,       [2001] = "ACK_GOODS_XXX1", 
	-- [2002]属性信息块 -- 物品/背包 
	ACK_GOODS_XXX2                   = 2002,       [2002] = "ACK_GOODS_XXX2", 
	-- [2003]插槽信息块 -- 物品/背包 
	ACK_GOODS_XXX3                   = 2003,       [2003] = "ACK_GOODS_XXX3", 
	-- [2004]装备打造附加块 -- 物品/背包 
	ACK_GOODS_XXX4                   = 2004,       [2004] = "ACK_GOODS_XXX4", 
	-- [2005]插槽属性块 -- 物品/背包 
	ACK_GOODS_XXX5                   = 2005,       [2005] = "ACK_GOODS_XXX5", 
	-- [2006]基础信息块 -- 物品/背包 
	ACK_GOODS_ATTR_BASE              = 2006,       [2006] = "ACK_GOODS_ATTR_BASE", 
	-- [2010]请求装备,背包物品信息 -- 物品/背包 
	REQ_GOODS_REQUEST                = 2010,       [2010] = "REQ_GOODS_REQUEST", 
	-- [2020]请求返回数据 -- 物品/背包 
	ACK_GOODS_REVERSE                = 2020,       [2020] = "ACK_GOODS_REVERSE", 
	-- [2040]消失物品/装备 -- 物品/背包 
	ACK_GOODS_REMOVE                 = 2040,       [2040] = "ACK_GOODS_REMOVE", 
	-- [2050]物品/装备属性变化 -- 物品/背包 
	ACK_GOODS_CHANGE                 = 2050,       [2050] = "ACK_GOODS_CHANGE", 
	-- [2060]获得|失去物品通知 -- 物品/背包 
	ACK_GOODS_CHANGE_NOTICE          = 2060,       [2060] = "ACK_GOODS_CHANGE_NOTICE", 
	-- [2070]获得|失去货币通知 -- 物品/背包 
	ACK_GOODS_CURRENCY_CHANGE        = 2070,       [2070] = "ACK_GOODS_CURRENCY_CHANGE", 
	-- [2080]物品/装备使用 -- 物品/背包 
	REQ_GOODS_USE                    = 2080,       [2080] = "REQ_GOODS_USE", 
	-- [2081]伙伴经验丹使用成功 -- 物品/背包 
	ACK_GOODS_P_EXP_OK               = 2081,       [2081] = "ACK_GOODS_P_EXP_OK", 
	-- [2090]使用物品(指定对象) -- 物品/背包 
	REQ_GOODS_TARGET_USE             = 2090,       [2090] = "REQ_GOODS_TARGET_USE", 
	-- [2100]丢弃物品 -- 物品/背包 
	REQ_GOODS_LOSE                   = 2100,       [2100] = "REQ_GOODS_LOSE", 
	-- [2225]请求容器扩充 -- 物品/背包 
	REQ_GOODS_ENLARGE_REQUEST        = 2225,       [2225] = "REQ_GOODS_ENLARGE_REQUEST", 
	-- [2227]扩充需要的道具数量 -- 物品/背包 
	ACK_GOODS_ENLARGE_COST           = 2227,       [2227] = "ACK_GOODS_ENLARGE_COST", 
	-- [2230]容器扩充成功 -- 物品/背包 
	ACK_GOODS_ENLARGE                = 2230,       [2230] = "ACK_GOODS_ENLARGE", 
	-- [2240]请求角色装备信息 -- 物品/背包 
	REQ_GOODS_EQUIP_ASK              = 2240,       [2240] = "REQ_GOODS_EQUIP_ASK", 
	-- [2242]角色装备信息返回 -- 物品/背包 
	ACK_GOODS_EQUIP_BACK             = 2242,       [2242] = "ACK_GOODS_EQUIP_BACK", 
	-- [2250]提取临时背包物品 -- 物品/背包 
	REQ_GOODS_PICK_TEMP              = 2250,       [2250] = "REQ_GOODS_PICK_TEMP", 
	-- [2260]出售物品 -- 物品/背包 
	REQ_GOODS_SELL                   = 2260,       [2260] = "REQ_GOODS_SELL", 
	-- [2261]出售物品（新） -- 物品/背包 
	REQ_GOODS_P_SELL                 = 2261,       [2261] = "REQ_GOODS_P_SELL", 
	-- [2262]出售成功 -- 物品/背包 
	ACK_GOODS_SELL_OK                = 2262,       [2262] = "ACK_GOODS_SELL_OK", 
	-- [2270]装备一键互换 -- 物品/背包 
	REQ_GOODS_EQUIP_SWAP             = 2270,       [2270] = "REQ_GOODS_EQUIP_SWAP", 
	-- [2272]一键互换成功 -- 物品/背包 
	ACK_GOODS_SWAP_OK                = 2272,       [2272] = "ACK_GOODS_SWAP_OK", 
	-- [2300]请求商店信息 -- 物品/背包 
	REQ_GOODS_SHOP_ASK               = 2300,       [2300] = "REQ_GOODS_SHOP_ASK", 
	-- [2301]商店物品信息块 -- 物品/背包 
	ACK_GOODS_SHOP_XXX1              = 2301,       [2301] = "ACK_GOODS_SHOP_XXX1", 
	-- [2310]商店数据返回 -- 物品/背包 
	ACK_GOODS_SHOP_BACK              = 2310,       [2310] = "ACK_GOODS_SHOP_BACK", 
	-- [2320]购买商店物品 -- 物品/背包 
	REQ_GOODS_SHOP_BUY               = 2320,       [2320] = "REQ_GOODS_SHOP_BUY", 
	-- [2321]商店购买成功 -- 物品/背包 
	ACK_GOODS_SHOP_BUY_OK            = 2321,       [2321] = "ACK_GOODS_SHOP_BUY_OK", 
	-- [2327]元宵节活动将会获得的物品索引(0~11) -- 物品/背包 
	ACK_GOODS_LANTERN_INDEX          = 2327,       [2327] = "ACK_GOODS_LANTERN_INDEX", 
	-- [2328]领取将要获得的物品 -- 物品/背包 
	REQ_GOODS_LANTERN_GET            = 2328,       [2328] = "REQ_GOODS_LANTERN_GET", 
	-- [2329]请求元宵活动数据 -- 物品/背包 
	REQ_GOODS_LANTERN_ASK            = 2329,       [2329] = "REQ_GOODS_LANTERN_ASK", 
	-- [2330]请求次数物品数据 -- 物品/背包 
	REQ_GOODS_TIMES_GOODS_ASK        = 2330,       [2330] = "REQ_GOODS_TIMES_GOODS_ASK", 
	-- [2331]元宵活动数据返回 -- 物品/背包 
	ACK_GOODS_LANTERN_BACK           = 2331,       [2331] = "ACK_GOODS_LANTERN_BACK", 
	-- [2332]次数物品数据返回 -- 物品/背包 
	ACK_GOODS_TIMES_GOODS_BACK       = 2332,       [2332] = "ACK_GOODS_TIMES_GOODS_BACK", 
	-- [2333]次数物品数据块 -- 物品/背包 
	ACK_GOODS_TIMES_XXX1             = 2333,       [2333] = "ACK_GOODS_TIMES_XXX1", 
	-- [2334]次数物品日志数据块 -- 物品/背包 
	ACK_GOODS_TIMES_XXX2             = 2334,       [2334] = "ACK_GOODS_TIMES_XXX2", 
	-- [2335]元宵活动物品信息块 -- 物品/背包 
	ACK_GOODS_TIMES_XXX3             = 2335,       [2335] = "ACK_GOODS_TIMES_XXX3", 
	-- [2336]检查特定活动物品是否可使用 -- 物品/背包 
	REQ_GOODS_ACTY_USE_CHECK         = 2336,       [2336] = "REQ_GOODS_ACTY_USE_CHECK", 
	-- [2338]特定活动物品是否可使用 -- 物品/背包 
	ACK_GOODS_ACTY_USE_STATE         = 2338,       [2338] = "ACK_GOODS_ACTY_USE_STATE", 
	-- [2340]随身商店信息 -- 物品/背包 
	ACK_GOODS_SHOP_DATA              = 2340,       [2340] = "ACK_GOODS_SHOP_DATA", 

	--------------------------------------------------------
	-- 2501 - 3000 ( 物品/打造/强化 ) 
	--------------------------------------------------------
	-- [2510]装备首饰打造 -- 物品/打造/强化 
	REQ_MAKE_EQUIP                   = 2510,       [2510] = "REQ_MAKE_EQUIP", 
	-- [2512]打造成功 -- 物品/打造/强化 
	ACK_MAKE_MAKE_OK                 = 2512,       [2512] = "ACK_MAKE_MAKE_OK", 
	-- [2513]强化（new） -- 物品/打造/强化 
	REQ_MAKE_KEY_STREN               = 2513,       [2513] = "REQ_MAKE_KEY_STREN", 
	-- [2515]装备强化（废除） -- 物品/打造/强化 
	REQ_MAKE_STRENGTHEN              = 2515,       [2515] = "REQ_MAKE_STRENGTHEN", 
	-- [2516]请求装备强化数据 -- 物品/打造/强化 
	REQ_MAKE_STREN_DATA_ASK          = 2516,       [2516] = "REQ_MAKE_STREN_DATA_ASK", 
	-- [2517]下一级装备强化数据返回 -- 物品/打造/强化 
	ACK_MAKE_STREN_DATA_BACK         = 2517,       [2517] = "ACK_MAKE_STREN_DATA_BACK", 
	-- [2518]强化消耗材料信息块 -- 物品/打造/强化 
	ACK_MAKE_STREN_COST_XXX          = 2518,       [2518] = "ACK_MAKE_STREN_COST_XXX", 
	-- [2519]不可强化或已达最高级 -- 物品/打造/强化 
	ACK_MAKE_STREN_MAX               = 2519,       [2519] = "ACK_MAKE_STREN_MAX", 
	-- [2520]装备强化成功 -- 物品/打造/强化 
	ACK_MAKE_STRENGTHEN_OK           = 2520,       [2520] = "ACK_MAKE_STRENGTHEN_OK", 
	-- [2522]法宝升阶 -- 物品/打造/强化 
	REQ_MAKE_MAGIC_UPGRADE           = 2522,       [2522] = "REQ_MAKE_MAGIC_UPGRADE", 
	-- [2525]法宝升阶成功 -- 物品/打造/强化 
	ACK_MAKE_UPGRADE_OK              = 2525,       [2525] = "ACK_MAKE_UPGRADE_OK", 
	-- [2530]装备洗练 -- 物品/打造/强化 
	REQ_MAKE_WASH                    = 2530,       [2530] = "REQ_MAKE_WASH", 
	-- [2532]洗练数据返回 -- 物品/打造/强化 
	ACK_MAKE_WASH_BACK               = 2532,       [2532] = "ACK_MAKE_WASH_BACK", 
	-- [2535]附加属性数据块 -- 物品/打造/强化 
	ACK_MAKE_PLUS_MSG_XXX            = 2535,       [2535] = "ACK_MAKE_PLUS_MSG_XXX", 
	-- [2536]附加属性数据块2 -- 物品/打造/强化 
	ACK_MAKE_PLUS_MSG_XXX2           = 2536,       [2536] = "ACK_MAKE_PLUS_MSG_XXX2", 
	-- [2540]是否保留洗练数据 -- 物品/打造/强化 
	REQ_MAKE_WASH_SAVE               = 2540,       [2540] = "REQ_MAKE_WASH_SAVE", 
	-- [2542]保留洗练属性成功 -- 物品/打造/强化 
	ACK_MAKE_WASH_OK                 = 2542,       [2542] = "ACK_MAKE_WASH_OK", 
	-- [2550] 宝石合成 -- 物品/打造/强化 
	REQ_MAKE_MAKE_COMPOSE            = 2550,       [2550] = "REQ_MAKE_MAKE_COMPOSE", 
	-- [2552]宝石合成成功 -- 物品/打造/强化 
	ACK_MAKE_COMPOSE_OK              = 2552,       [2552] = "ACK_MAKE_COMPOSE_OK", 
	-- [2560]镶嵌宝石 -- 物品/打造/强化 
	REQ_MAKE_PEARL_INSET             = 2560,       [2560] = "REQ_MAKE_PEARL_INSET", 
	-- [2561]镶嵌宝石成功 -- 物品/打造/强化 
	ACK_MAKE_PEARL_INSET_OK          = 2561,       [2561] = "ACK_MAKE_PEARL_INSET_OK", 
	-- [2570]拆除灵珠 -- 物品/打造/强化 
	REQ_MAKE_PEARL_REMOVE            = 2570,       [2570] = "REQ_MAKE_PEARL_REMOVE", 
	-- [2580]法宝拆分 -- 物品/打造/强化 
	REQ_MAKE_MAGIC_PART              = 2580,       [2580] = "REQ_MAKE_MAGIC_PART", 
	-- [2582]法宝拆分成功 -- 物品/打造/强化 
	ACK_MAKE_MAGIC_PART_OK           = 2582,       [2582] = "ACK_MAKE_MAGIC_PART_OK", 
	-- [2590]装备附魔 -- 物品/打造/强化 
	REQ_MAKE_ENCHANT                 = 2590,       [2590] = "REQ_MAKE_ENCHANT", 
	-- [2600]附魔成功 -- 物品/打造/强化 
	ACK_MAKE_ENCHANT_OK              = 2600,       [2600] = "ACK_MAKE_ENCHANT_OK", 
	-- [2610]请求附魔 -- 物品/打造/强化 
	REQ_MAKE_ENCHANT_S               = 2610,       [2610] = "REQ_MAKE_ENCHANT_S", 
	-- [2620]附魔消耗 -- 物品/打造/强化 
	ACK_MAKE_ENCHANT_PAY             = 2620,       [2620] = "ACK_MAKE_ENCHANT_PAY", 
	-- [2640]一键附魔 -- 物品/打造/强化 
	REQ_MAKE_KEY_ENCHANT             = 2640,       [2640] = "REQ_MAKE_KEY_ENCHANT", 

	--------------------------------------------------------
	-- 3001 - 3500 ( 任务 ) 
	--------------------------------------------------------
	-- [3210]请求任务列表 -- 任务 
	REQ_TASK_REQUEST_LIST            = 3210,       [3210] = "REQ_TASK_REQUEST_LIST", 
	-- [3220]返回任务数据 -- 任务 
	ACK_TASK_DATA                    = 3220,       [3220] = "ACK_TASK_DATA", 
	-- [3223]怪物信息块 -- 任务 
	ACK_TASK_MONSTER_DETAIL          = 3223,       [3223] = "ACK_TASK_MONSTER_DETAIL", 
	-- [3225]任务剧情通知 -- 任务 
	ACK_TASK_TASK_DRAMA              = 3225,       [3225] = "ACK_TASK_TASK_DRAMA", 
	-- [3230]接受任务 -- 任务 
	REQ_TASK_ACCEPT                  = 3230,       [3230] = "REQ_TASK_ACCEPT", 
	-- [3240]放弃任务 -- 任务 
	REQ_TASK_CANCEL                  = 3240,       [3240] = "REQ_TASK_CANCEL", 
	-- [3250]提交任务 -- 任务 
	REQ_TASK_SUBMIT                  = 3250,       [3250] = "REQ_TASK_SUBMIT", 
	-- [3265]从列表中移除任务 -- 任务 
	ACK_TASK_REMOVE                  = 3265,       [3265] = "ACK_TASK_REMOVE", 

	--------------------------------------------------------
	-- 3501 - 4000 ( 组队系统 ) 
	--------------------------------------------------------
	-- [3510]请求队伍面板 -- 组队系统 
	REQ_TEAM_REQUEST                 = 3510,       [3510] = "REQ_TEAM_REQUEST", 
	-- [3520]队伍面板回复 -- 组队系统 
	ACK_TEAM_REPLY                   = 3520,       [3520] = "ACK_TEAM_REPLY", 
	-- [3530]队伍信息块 -- 组队系统 
	ACK_TEAM_REPLY_MSG               = 3530,       [3530] = "ACK_TEAM_REPLY_MSG", 
	-- [3540]请求通关的副本 -- 组队系统 
	REQ_TEAM_PASS_REQUEST            = 3540,       [3540] = "REQ_TEAM_PASS_REQUEST", 
	-- [3550]通关副本返回 -- 组队系统 
	ACK_TEAM_PASS_REPLY              = 3550,       [3550] = "ACK_TEAM_PASS_REPLY", 
	-- [3560]通关副本信息块 -- 组队系统 
	ACK_TEAM_PASS_MSG                = 3560,       [3560] = "ACK_TEAM_PASS_MSG", 
	-- [3570]创建队伍 -- 组队系统 
	REQ_TEAM_CREAT                   = 3570,       [3570] = "REQ_TEAM_CREAT", 
	-- [3572]队伍信息返回(new) -- 组队系统 
	ACK_TEAM_TEAM_INFO_NEW           = 3572,       [3572] = "ACK_TEAM_TEAM_INFO_NEW", 
	-- [3574]队伍成员信息块(new) -- 组队系统 
	ACK_TEAM_MEM_MSG_NEW             = 3574,       [3574] = "ACK_TEAM_MEM_MSG_NEW", 
	-- [3580]队伍信息返回 -- 组队系统 
	ACK_TEAM_TEAM_INFO               = 3580,       [3580] = "ACK_TEAM_TEAM_INFO", 
	-- [3590]队伍成员信息块 -- 组队系统 
	ACK_TEAM_MEM_MSG                 = 3590,       [3590] = "ACK_TEAM_MEM_MSG", 
	-- [3600]加入队伍 -- 组队系统 
	REQ_TEAM_JOIN                    = 3600,       [3600] = "REQ_TEAM_JOIN", 
	-- [3610]离开队伍 -- 组队系统 
	REQ_TEAM_LEAVE                   = 3610,       [3610] = "REQ_TEAM_LEAVE", 
	-- [3620]离队通知 -- 组队系统 
	ACK_TEAM_LEAVE_NOTICE            = 3620,       [3620] = "ACK_TEAM_LEAVE_NOTICE", 
	-- [3630]踢出队员 -- 组队系统 
	REQ_TEAM_KICK                    = 3630,       [3630] = "REQ_TEAM_KICK", 
	-- [3640]设置新队长 -- 组队系统 
	REQ_TEAM_SET_LEADER              = 3640,       [3640] = "REQ_TEAM_SET_LEADER", 
	-- [3650]申请做队长 -- 组队系统 
	REQ_TEAM_APPLY_LEADER            = 3650,       [3650] = "REQ_TEAM_APPLY_LEADER", 
	-- [3660]申请队长通知 -- 组队系统 
	ACK_TEAM_APPLY_NOTICE            = 3660,       [3660] = "ACK_TEAM_APPLY_NOTICE", 
	-- [3670]新队长通知 -- 组队系统 
	ACK_TEAM_NEW_LEADER              = 3670,       [3670] = "ACK_TEAM_NEW_LEADER", 
	-- [3680]邀请好友 -- 组队系统 
	REQ_TEAM_INVITE                  = 3680,       [3680] = "REQ_TEAM_INVITE", 
	-- [3700]邀请好友返回 -- 组队系统 
	ACK_TEAM_INVITE_NOTICE           = 3700,       [3700] = "ACK_TEAM_INVITE_NOTICE", 
	-- [3720]查询队伍是否存在 -- 组队系统 
	REQ_TEAM_LIVE_REQ                = 3720,       [3720] = "REQ_TEAM_LIVE_REQ", 
	-- [3730]查询队伍返回 -- 组队系统 
	ACK_TEAM_LIVE_REP                = 3730,       [3730] = "ACK_TEAM_LIVE_REP", 

	--------------------------------------------------------
	-- 4001 - 4500 ( 好友 ) 
	--------------------------------------------------------
	-- [4010]请求好友面板 -- 好友 
	REQ_FRIEND_REQUES                = 4010,       [4010] = "REQ_FRIEND_REQUES", 
	-- [4020]返回好友信息 -- 好友 
	ACK_FRIEND_INFO                  = 4020,       [4020] = "ACK_FRIEND_INFO", 
	-- [4025]返回好友列表信息块 -- 好友 
	ACK_FRIEND_INFO_GROUP            = 4025,       [4025] = "ACK_FRIEND_INFO_GROUP", 
	-- [4030]请求删除好友 -- 好友 
	REQ_FRIEND_DEL                   = 4030,       [4030] = "REQ_FRIEND_DEL", 
	-- [4040]好友删除成功 -- 好友 
	ACK_FRIEND_DEL_OK                = 4040,       [4040] = "ACK_FRIEND_DEL_OK", 
	-- [4050]查找好友 -- 好友 
	REQ_FRIEND_SEARCH_ADD            = 4050,       [4050] = "REQ_FRIEND_SEARCH_ADD", 
	-- [4060]查找好友返回 -- 好友 
	ACK_FRIEND_SEARCH_REPLY          = 4060,       [4060] = "ACK_FRIEND_SEARCH_REPLY", 
	-- [4070]添加好友，最近联系人，黑名单 -- 好友 
	REQ_FRIEND_ADD                   = 4070,       [4070] = "REQ_FRIEND_ADD", 
	-- [4075]添加好友详情 -- 好友 
	REQ_FRIEND_ADD_DETAIL            = 4075,       [4075] = "REQ_FRIEND_ADD_DETAIL", 
	-- [4090]发送添加好友通知 -- 好友 
	ACK_FRIEND_ADD_NOTICE            = 4090,       [4090] = "ACK_FRIEND_ADD_NOTICE", 
	-- [4200]系统推荐好友 -- 好友 
	ACK_FRIEND_SYS_FRIEND            = 4200,       [4200] = "ACK_FRIEND_SYS_FRIEND", 

	--------------------------------------------------------
	-- 5001 - 6000 ( 场景 ) 
	--------------------------------------------------------
	-- [5010]请求进入场景(飞) -- 场景 
	REQ_SCENE_ENTER_FLY              = 5010,       [5010] = "REQ_SCENE_ENTER_FLY", 
	-- [5020]请求进入场景 -- 场景 
	REQ_SCENE_ENTER                  = 5020,       [5020] = "REQ_SCENE_ENTER", 
	-- [5030]进入场景 -- 场景 
	ACK_SCENE_ENTER_OK               = 5030,       [5030] = "ACK_SCENE_ENTER_OK", 
	-- [5040]请求场景内玩家信息列表 -- 场景 
	REQ_SCENE_REQUEST_PLAYERS        = 5040,       [5040] = "REQ_SCENE_REQUEST_PLAYERS", 
	-- [5042]请求场景玩家列表(new) -- 场景 
	REQ_SCENE_REQ_PLAYERS_NEW        = 5042,       [5042] = "REQ_SCENE_REQ_PLAYERS_NEW", 
	-- [5045]玩家信息列表 -- 场景 
	ACK_SCENE_PLAYER_LIST            = 5045,       [5045] = "ACK_SCENE_PLAYER_LIST", 
	-- [5050]地图玩家数据 -- 场景 
	ACK_SCENE_ROLE_DATA              = 5050,       [5050] = "ACK_SCENE_ROLE_DATA", 
	-- [5052]地图伙伴列表 -- 场景 
	ACK_SCENE_PARTNER_LIST           = 5052,       [5052] = "ACK_SCENE_PARTNER_LIST", 
	-- [5055]地图伙伴数据 -- 场景 
	ACK_SCENE_PARTNER_DATA           = 5055,       [5055] = "ACK_SCENE_PARTNER_DATA", 
	-- [5060]请求怪物数据 -- 场景 
	REQ_SCENE_REQUEST_MONSTER        = 5060,       [5060] = "REQ_SCENE_REQUEST_MONSTER", 
	-- [5065]场景刷出第几波怪 -- 场景 
	ACK_SCENE_IDX_MONSTER            = 5065,       [5065] = "ACK_SCENE_IDX_MONSTER", 
	-- [5070]怪物数据(刷新) -- 场景 
	ACK_SCENE_MONSTER_DATA           = 5070,       [5070] = "ACK_SCENE_MONSTER_DATA", 
	-- [5080]行走数据 -- 场景 
	REQ_SCENE_MOVE                   = 5080,       [5080] = "REQ_SCENE_MOVE", 
	-- [5085]行走数据(广播) -- 场景 
	REQ_SCENE_MOVE_NEW               = 5085,       [5085] = "REQ_SCENE_MOVE_NEW", 
	-- [5090]行走数据(地图广播) -- 场景 
	ACK_SCENE_MOVE_RECE              = 5090,       [5090] = "ACK_SCENE_MOVE_RECE", 
	-- [5100]强设玩家坐标 -- 场景 
	ACK_SCENE_SET_PLAYER_XY          = 5100,       [5100] = "ACK_SCENE_SET_PLAYER_XY", 
	-- [5110]离开场景 -- 场景 
	ACK_SCENE_OUT                    = 5110,       [5110] = "ACK_SCENE_OUT", 
	-- [5120]杀怪连击 -- 场景 
	REQ_SCENE_CAROM_TIMES            = 5120,       [5120] = "REQ_SCENE_CAROM_TIMES", 
	-- [5130]击杀怪物 -- 场景 
	REQ_SCENE_KILL_MONSTER           = 5130,       [5130] = "REQ_SCENE_KILL_MONSTER", 
	-- [5140]被怪物击中 -- 场景 
	REQ_SCENE_HIT_TIMES              = 5140,       [5140] = "REQ_SCENE_HIT_TIMES", 
	-- [5150]玩家死亡 -- 场景 
	REQ_SCENE_DIE                    = 5150,       [5150] = "REQ_SCENE_DIE", 
	-- [5155]伙伴死亡 -- 场景 
	REQ_SCENE_DIE_PARTNER            = 5155,       [5155] = "REQ_SCENE_DIE_PARTNER", 
	-- [5160]玩家可以复活 -- 场景 
	ACK_SCENE_RELIVE                 = 5160,       [5160] = "ACK_SCENE_RELIVE", 
	-- [5170]玩家请求复活 -- 场景 
	REQ_SCENE_RELIVE_REQUEST         = 5170,       [5170] = "REQ_SCENE_RELIVE_REQUEST", 
	-- [5180]玩家复活成功 -- 场景 
	ACK_SCENE_RELIVE_OK              = 5180,       [5180] = "ACK_SCENE_RELIVE_OK", 
	-- [5190]玩家|伙伴血量更新 -- 场景 
	ACK_SCENE_HP_UPDATE              = 5190,       [5190] = "ACK_SCENE_HP_UPDATE", 
	-- [5200]回城 -- 场景 
	REQ_SCENE_ENTER_CITY             = 5200,       [5200] = "REQ_SCENE_ENTER_CITY", 
	-- [5300]场景广播-称号 -- 场景 
	ACK_SCENE_CHANGE_TITLE           = 5300,       [5300] = "ACK_SCENE_CHANGE_TITLE", 
	-- [5310]场景广播-神器 -- 场景 
	ACK_SCENE_CHANGE_ARTIFACT        = 5310,       [5310] = "ACK_SCENE_CHANGE_ARTIFACT", 
	-- [5930]场景广播-帮派 -- 场景 
	ACK_SCENE_CHANGE_CLAN            = 5930,       [5930] = "ACK_SCENE_CHANGE_CLAN", 
	-- [5940]场景广播-升级 -- 场景 
	ACK_SCENE_LEVEL_UP               = 5940,       [5940] = "ACK_SCENE_LEVEL_UP", 
	-- [5950]场景广播-改变组队 -- 场景 
	ACK_SCENE_CHANGE_TEAM            = 5950,       [5950] = "ACK_SCENE_CHANGE_TEAM", 
	-- [5960]场景广播--改变坐骑 -- 场景 
	ACK_SCENE_CHANGE_MOUNT           = 5960,       [5960] = "ACK_SCENE_CHANGE_MOUNT", 
	-- [5970]场景广播-改变战斗状态(is_war) -- 场景 
	ACK_SCENE_CHANGE_STATE           = 5970,       [5970] = "ACK_SCENE_CHANGE_STATE", 
	-- [5980]场景广播-VIP -- 场景 
	ACK_SCENE_CHANGE_VIP             = 5980,       [5980] = "ACK_SCENE_CHANGE_VIP", 

	--------------------------------------------------------
	-- 6001 - 6500 ( 战斗 ) 
	--------------------------------------------------------
	-- [6010]战斗数据块 -- 战斗 
	ACK_WAR_PLAYER_WAR               = 6010,       [6010] = "ACK_WAR_PLAYER_WAR", 
	-- [6020]战斗伤害广播 -- 战斗 
	REQ_WAR_HARM                     = 6020,       [6020] = "REQ_WAR_HARM", 
	-- [6021]战斗伤害广播 -- 战斗 
	REQ_WAR_HARM_NEW                 = 6021,       [6021] = "REQ_WAR_HARM_NEW", 
	-- [6030]释放技能广播 -- 战斗 
	ACK_WAR_SKILL                    = 6030,       [6030] = "ACK_WAR_SKILL", 
	-- [6040]释放技能 -- 战斗 
	REQ_WAR_USE_SKILL                = 6040,       [6040] = "REQ_WAR_USE_SKILL", 
	-- [6050]邀请PK -- 战斗 
	REQ_WAR_PK                       = 6050,       [6050] = "REQ_WAR_PK", 
	-- [6055]取消邀请 -- 战斗 
	REQ_WAR_PK_CANCEL                = 6055,       [6055] = "REQ_WAR_PK_CANCEL", 
	-- [6060]接收PK邀请 -- 战斗 
	ACK_WAR_PK_RECEIVE               = 6060,       [6060] = "ACK_WAR_PK_RECEIVE", 
	-- [6061]PK时间 -- 战斗 
	ACK_WAR_PK_TIME                  = 6061,       [6061] = "ACK_WAR_PK_TIME", 
	-- [6070]邀请回复 -- 战斗 
	REQ_WAR_PK_REPLY                 = 6070,       [6070] = "REQ_WAR_PK_REPLY", 
	-- [6080]PK结束死亡广播 -- 战斗 
	ACK_WAR_PK_LOSE                  = 6080,       [6080] = "ACK_WAR_PK_LOSE", 
	-- [6090]怪物击倒 -- 战斗 
	REQ_WAR_DOWN                     = 6090,       [6090] = "REQ_WAR_DOWN", 

	--------------------------------------------------------
	-- 6501 - 7000 ( 技能系统 ) 
	--------------------------------------------------------
	-- [6510]请求技能列表 -- 技能系统 
	REQ_SKILL_REQUEST                = 6510,       [6510] = "REQ_SKILL_REQUEST", 
	-- [6520]技能列表数据 -- 技能系统 
	ACK_SKILL_LIST                   = 6520,       [6520] = "ACK_SKILL_LIST", 
	-- [6525]升级技能 -- 技能系统 
	REQ_SKILL_LEARN                  = 6525,       [6525] = "REQ_SKILL_LEARN", 
	-- [6530]技能信息 -- 技能系统 
	ACK_SKILL_INFO                   = 6530,       [6530] = "ACK_SKILL_INFO", 
	-- [6540]装备技能 -- 技能系统 
	REQ_SKILL_EQUIP                  = 6540,       [6540] = "REQ_SKILL_EQUIP", 
	-- [6545]装备技能信息 -- 技能系统 
	ACK_SKILL_EQUIP_INFO             = 6545,       [6545] = "ACK_SKILL_EQUIP_INFO", 
	-- [6550]请求伙伴技能列表 -- 技能系统 
	REQ_SKILL_PARTNER                = 6550,       [6550] = "REQ_SKILL_PARTNER", 
	-- [6555]请求学习技能 -- 技能系统 
	REQ_SKILL_UPPARENTLV             = 6555,       [6555] = "REQ_SKILL_UPPARENTLV", 
	-- [6560]伙伴技能信息 -- 技能系统 
	ACK_SKILL_PARENTINFO             = 6560,       [6560] = "ACK_SKILL_PARENTINFO", 

	--------------------------------------------------------
	-- 7001 - 8000 ( 副本 ) 
	--------------------------------------------------------
	-- [7001]请求副本列表 -- 副本 
	REQ_COPY_REQUEST_OLD             = 7001,       [7001] = "REQ_COPY_REQUEST_OLD", 
	-- [7002]副本信息返回 -- 副本 
	ACK_COPY_REVERSE_OLD             = 7002,       [7002] = "ACK_COPY_REVERSE_OLD", 
	-- [7003]副本信息返回块 -- 副本 
	ACK_COPY_MSG_REVERSE_OLD         = 7003,       [7003] = "ACK_COPY_MSG_REVERSE_OLD", 
	-- [7010]请求普通副本 -- 副本 
	REQ_COPY_REQUEST                 = 7010,       [7010] = "REQ_COPY_REQUEST", 
	-- [7015]当前章节信息 -- 副本 
	ACK_COPY_CHAP_DATA               = 7015,       [7015] = "ACK_COPY_CHAP_DATA", 
	-- [7020]战役数据信息块 -- 副本 
	ACK_COPY_MSG_BATTLE              = 7020,       [7020] = "ACK_COPY_MSG_BATTLE", 
	-- [7022]当前章节信息(new) -- 副本 
	ACK_COPY_CHAP_DATA_NEW           = 7022,       [7022] = "ACK_COPY_CHAP_DATA_NEW", 
	-- [7024]战役数据信息块(new) -- 副本 
	ACK_COPY_MSG_BATTLE_NEW          = 7024,       [7024] = "ACK_COPY_MSG_BATTLE_NEW", 
	-- [7030]创建进入副本 -- 副本 
	REQ_COPY_CREAT                   = 7030,       [7030] = "REQ_COPY_CREAT", 
	-- [7040]副本计时(待删除) -- 副本 
	REQ_COPY_TIMING                  = 7040,       [7040] = "REQ_COPY_TIMING", 
	-- [7050]副本时间同步(待删除) -- 副本 
	ACK_COPY_TIME_UPDATE             = 7050,       [7050] = "ACK_COPY_TIME_UPDATE", 
	-- [7060]场景时间同步(生存,限时类型) -- 副本 
	ACK_COPY_SCENE_TIME              = 7060,       [7060] = "ACK_COPY_SCENE_TIME", 
	-- [7710]进入副本场景返回信息(待删除) -- 副本 
	ACK_COPY_ENTER_SCENE_INFO        = 7710,       [7710] = "ACK_COPY_ENTER_SCENE_INFO", 
	-- [7790]场景目标完成 -- 副本 
	ACK_COPY_SCENE_OVER              = 7790,       [7790] = "ACK_COPY_SCENE_OVER", 
	-- [7795]通知副本完成 -- 副本 
	REQ_COPY_NOTICE_OVER             = 7795,       [7795] = "REQ_COPY_NOTICE_OVER", 
	-- [7800]副本完成 -- 副本 
	ACK_COPY_OVER                    = 7800,       [7800] = "ACK_COPY_OVER", 
	-- [7805]副本物品信息块 -- 副本 
	ACK_COPY_MSG_GOOD                = 7805,       [7805] = "ACK_COPY_MSG_GOOD", 
	-- [7810]副本失败 -- 副本 
	ACK_COPY_FAIL                    = 7810,       [7810] = "ACK_COPY_FAIL", 
	-- [7820]退出副本 -- 副本 
	REQ_COPY_COPY_EXIT               = 7820,       [7820] = "REQ_COPY_COPY_EXIT", 
	-- [7830]退出副本成功 -- 副本 
	ACK_COPY_EXIT_OK                 = 7830,       [7830] = "ACK_COPY_EXIT_OK", 
	-- [7840]开始挂机 -- 副本 
	REQ_COPY_UP_START                = 7840,       [7840] = "REQ_COPY_UP_START", 
	-- [7845]加速挂机 -- 副本 
	REQ_COPY_UP_SPEED                = 7845,       [7845] = "REQ_COPY_UP_SPEED", 
	-- [7850]挂机返回 -- 副本 
	ACK_COPY_UP_RESULT               = 7850,       [7850] = "ACK_COPY_UP_RESULT", 
	-- [7860]挂机完成 -- 副本 
	ACK_COPY_UP_OVER                 = 7860,       [7860] = "ACK_COPY_UP_OVER", 
	-- [7864]请求登陆挂机 -- 副本 
	REQ_COPY_IS_UP                   = 7864,       [7864] = "REQ_COPY_IS_UP", 
	-- [7865]登陆提醒挂机 -- 副本 
	ACK_COPY_LOGIN_NOTICE            = 7865,       [7865] = "ACK_COPY_LOGIN_NOTICE", 
	-- [7870]停止挂机 -- 副本 
	REQ_COPY_UP_STOP                 = 7870,       [7870] = "REQ_COPY_UP_STOP", 
	-- [7880]领取章节评价奖励 -- 副本 
	REQ_COPY_CHAP_REWARD             = 7880,       [7880] = "REQ_COPY_CHAP_REWARD", 
	-- [7890]查询章节奖励返回 -- 副本 
	ACK_COPY_CHAP_RE_REP             = 7890,       [7890] = "ACK_COPY_CHAP_RE_REP", 

	--------------------------------------------------------
	-- 8501 - 9000 ( 邮件 ) 
	--------------------------------------------------------
	-- [8501]发送的邮件ID -- 邮件 
	REQ_MAIL_ID_SEND                 = 8501,       [8501] = "REQ_MAIL_ID_SEND", 
	-- [8510]请求邮件列表 -- 邮件 
	REQ_MAIL_REQUEST                 = 8510,       [8510] = "REQ_MAIL_REQUEST", 
	-- [8512]请求列表成功 -- 邮件 
	ACK_MAIL_LIST                    = 8512,       [8512] = "ACK_MAIL_LIST", 
	-- [8513]邮件模块 -- 邮件 
	ACK_MAIL_MODEL                   = 8513,       [8513] = "ACK_MAIL_MODEL", 
	-- [8530]请求发送邮件 -- 邮件 
	REQ_MAIL_SEND                    = 8530,       [8530] = "REQ_MAIL_SEND", 
	-- [8532]发送邮件成功 -- 邮件 
	ACK_MAIL_OK_SEND                 = 8532,       [8532] = "ACK_MAIL_OK_SEND", 
	-- [8540]请求读取邮件 -- 邮件 
	REQ_MAIL_READ                    = 8540,       [8540] = "REQ_MAIL_READ", 
	-- [8542]读取邮件成功 -- 邮件 
	ACK_MAIL_INFO                    = 8542,       [8542] = "ACK_MAIL_INFO", 
	-- [8543]虚拟物品协议块 -- 邮件 
	ACK_MAIL_VGOODS_MODEL            = 8543,       [8543] = "ACK_MAIL_VGOODS_MODEL", 
	-- [8550]提取邮件物品 -- 邮件 
	REQ_MAIL_PICK                    = 8550,       [8550] = "REQ_MAIL_PICK", 
	-- [8552]提取物品成功 -- 邮件 
	ACK_MAIL_OK_PICK                 = 8552,       [8552] = "ACK_MAIL_OK_PICK", 
	-- [8560]删除邮件 -- 邮件 
	REQ_MAIL_DEL                     = 8560,       [8560] = "REQ_MAIL_DEL", 
	-- [8562]邮件移出 -- 邮件 
	ACK_MAIL_OK_DEL                  = 8562,       [8562] = "ACK_MAIL_OK_DEL", 
	-- [8563]删除邮件信息块 -- 邮件 
	ACK_MAIL_IDLIST                  = 8563,       [8563] = "ACK_MAIL_IDLIST", 
	-- [8580]请求保存邮件 -- 邮件 
	REQ_MAIL_SAVE                    = 8580,       [8580] = "REQ_MAIL_SAVE", 

	--------------------------------------------------------
	-- 9001 - 9500 ( 防沉迷 ) 
	--------------------------------------------------------
	-- [9020]防沉迷提示 -- 防沉迷 
	ACK_FCM_PROMPT                   = 9020,       [9020] = "ACK_FCM_PROMPT", 

	--------------------------------------------------------
	-- 9501 - 10000 ( 聊天 ) 
	--------------------------------------------------------
	-- [9524]收到频道聊天 -- 聊天 
	REQ_CHAT_GOODS_LIST              = 9524,       [9524] = "REQ_CHAT_GOODS_LIST", 
	-- [9525]发送频道聊天 -- 聊天 
	REQ_CHAT_SEND                    = 9525,       [9525] = "REQ_CHAT_SEND", 
	-- [9526]发送名字私聊 -- 聊天 
	REQ_CHAT_NAME                    = 9526,       [9526] = "REQ_CHAT_NAME", 
	-- [9527]玩家不在线 -- 聊天 
	ACK_CHAT_OFFICE_PLAYER           = 9527,       [9527] = "ACK_CHAT_OFFICE_PLAYER", 
	-- [9530]收到频道聊天 -- 聊天 
	ACK_CHAT_RECE                    = 9530,       [9530] = "ACK_CHAT_RECE", 
	-- [9600]GM命令 -- 聊天 
	REQ_CHAT_GM                      = 9600,       [9600] = "REQ_CHAT_GM", 

	--------------------------------------------------------
	-- 10001 - 10100 ( 祝福 ) 
	--------------------------------------------------------
	-- [10001]好友祝福 -- 祝福 
	REQ_WISH_SENT                    = 10001,       [10001] = "REQ_WISH_SENT", 
	-- [10010]祝福成功 -- 祝福 
	ACK_WISH_SUCCESS                 = 10010,       [10010] = "ACK_WISH_SUCCESS", 
	-- [10012]收到好友祝福 -- 祝福 
	ACK_WISH_RECV                    = 10012,       [10012] = "ACK_WISH_RECV", 
	-- [10020]领取祝福经验 -- 祝福 
	REQ_WISH_EXPERIENCE              = 10020,       [10020] = "REQ_WISH_EXPERIENCE", 
	-- [10022]领取祝福经验成功 -- 祝福 
	ACK_WISH_EXP_SUCCESS             = 10022,       [10022] = "ACK_WISH_EXP_SUCCESS", 
	-- [10030]请求祝福经验信息 -- 祝福 
	REQ_WISH_EXP_DATA                = 10030,       [10030] = "REQ_WISH_EXP_DATA", 
	-- [10032]祝福经验信息返回 -- 祝福 
	ACK_WISH_EXP_DATA_BACK           = 10032,       [10032] = "ACK_WISH_EXP_DATA_BACK", 
	-- [10040]好友升级提示 -- 祝福 
	ACK_WISH_LV_UP                   = 10040,       [10040] = "ACK_WISH_LV_UP", 
	-- [10050]双倍信息 -- 祝福 
	REQ_WISH_DOUBLE                  = 10050,       [10050] = "REQ_WISH_DOUBLE", 
	-- [10052]双倍信息返回 -- 祝福 
	ACK_WISH_DOUBLE_DATA             = 10052,       [10052] = "ACK_WISH_DOUBLE_DATA", 

	--------------------------------------------------------
	-- 10701 - 11000 ( 称号 ) 
	--------------------------------------------------------
	-- [10701]玩家称号广播 -- 称号 
	ACK_TITLE_CAST                   = 10701,       [10701] = "ACK_TITLE_CAST", 
	-- [10710]请求称号列表 -- 称号 
	REQ_TITLE_REQUEST                = 10710,       [10710] = "REQ_TITLE_REQUEST", 
	-- [10720]设置称号状态 -- 称号 
	REQ_TITLE_SET_STATE              = 10720,       [10720] = "REQ_TITLE_SET_STATE", 
	-- [10730]称号列表数据返回 -- 称号 
	ACK_TITLE_LIST_BACK              = 10730,       [10730] = "ACK_TITLE_LIST_BACK", 
	-- [10740]称号数据块 -- 称号 
	ACK_TITLE_XXX1                   = 10740,       [10740] = "ACK_TITLE_XXX1", 

	--------------------------------------------------------
	-- 12101 - 12200 ( 坐骑 ) 
	--------------------------------------------------------
	-- [12102]得到默认坐骑 -- 坐骑 
	REQ_MOUNT_DEFAULT_MOUNT          = 12102,       [12102] = "REQ_MOUNT_DEFAULT_MOUNT", 
	-- [12103]成功得到默认坐骑 -- 坐骑 
	ACK_MOUNT_DEFAULT_SUCCESS        = 12103,       [12103] = "ACK_MOUNT_DEFAULT_SUCCESS", 
	-- [12110]骑乘|下骑 -- 坐骑 
	REQ_MOUNT_RIDE                   = 12110,       [12110] = "REQ_MOUNT_RIDE", 
	-- [12115]骑乘|下骑成功 -- 坐骑 
	ACK_MOUNT_RIDE_OK                = 12115,       [12115] = "ACK_MOUNT_RIDE_OK", 
	-- [12120]幻化请求 -- 坐骑 
	REQ_MOUNT_LLUSION                = 12120,       [12120] = "REQ_MOUNT_LLUSION", 
	-- [12125]幻化请求返回 -- 坐骑 
	ACK_MOUNT_LLUSION_REPLY          = 12125,       [12125] = "ACK_MOUNT_LLUSION_REPLY", 
	-- [12130]坐骑系统请求 -- 坐骑 
	REQ_MOUNT_REQUEST                = 12130,       [12130] = "REQ_MOUNT_REQUEST", 
	-- [12135]坐骑系统请求返回 -- 坐骑 
	ACK_MOUNT_MOUNT_REPLY            = 12135,       [12135] = "ACK_MOUNT_MOUNT_REPLY", 
	-- [12140]幻化坐骑 -- 坐骑 
	REQ_MOUNT_LIUSION_MOUNT          = 12140,       [12140] = "REQ_MOUNT_LIUSION_MOUNT", 
	-- [12145]坐骑升阶 -- 坐骑 
	REQ_MOUNT_UP_MOUNT               = 12145,       [12145] = "REQ_MOUNT_UP_MOUNT", 
	-- [12150]培养 -- 坐骑 
	REQ_MOUNT_CUL                    = 12150,       [12150] = "REQ_MOUNT_CUL", 
	-- [12155]坐骑培养结果 -- 坐骑 
	ACK_MOUNT_CUL_RESULT             = 12155,       [12155] = "ACK_MOUNT_CUL_RESULT", 
	-- [12156]幻化坐骑返回单元 -- 坐骑 
	ACK_MOUNT_LLUSION_REPLY_E        = 12156,       [12156] = "ACK_MOUNT_LLUSION_REPLY_E", 
	-- [12160]坐骑吃仙果返回结果 -- 坐骑 
	ACK_MOUNT_MOUNT_FRUIT            = 12160,       [12160] = "ACK_MOUNT_MOUNT_FRUIT", 

	--------------------------------------------------------
	-- 14001 - 18000 ( 阵营 ) 
	--------------------------------------------------------
	-- [14001]请求阵营信息 -- 阵营 
	REQ_COUNTRY_INFO                 = 14001,       [14001] = "REQ_COUNTRY_INFO", 
	-- [14002]阵营信息 -- 阵营 
	ACK_COUNTRY_INFO_RESULT          = 14002,       [14002] = "ACK_COUNTRY_INFO_RESULT", 
	-- [14010]选择阵营 -- 阵营 
	REQ_COUNTRY_SELECT               = 14010,       [14010] = "REQ_COUNTRY_SELECT", 
	-- [14015]选择阵营结果 -- 阵营 
	ACK_COUNTRY_SELECT_RESULT        = 14015,       [14015] = "ACK_COUNTRY_SELECT_RESULT", 
	-- [14020]改变阵营--前奏 -- 阵营 
	REQ_COUNTRY_CHANGE_PRE           = 14020,       [14020] = "REQ_COUNTRY_CHANGE_PRE", 
	-- [14025]改变阵营 -- 阵营 
	REQ_COUNTRY_CHANGE               = 14025,       [14025] = "REQ_COUNTRY_CHANGE", 
	-- [14027]改变阵营返回 -- 阵营 
	ACK_COUNTRY_CHANGE_RESULT        = 14027,       [14027] = "ACK_COUNTRY_CHANGE_RESULT", 
	-- [14030]阵营排名 -- 阵营 
	REQ_COUNTRY_RANK                 = 14030,       [14030] = "REQ_COUNTRY_RANK", 
	-- [14035]阵营排名结果 -- 阵营 
	ACK_COUNTRY_RANK_RESULT          = 14035,       [14035] = "ACK_COUNTRY_RANK_RESULT", 
	-- [14040]发布阵营公告 -- 阵营 
	REQ_COUNTRY_PUBLISH_NOTICE       = 14040,       [14040] = "REQ_COUNTRY_PUBLISH_NOTICE", 
	-- [14045]发布阵营公告返回(阵营广播) -- 阵营 
	ACK_COUNTRY_PUBLISH_NOTICE_R     = 14045,       [14045] = "ACK_COUNTRY_PUBLISH_NOTICE_R", 
	-- [14050]任命官员 -- 阵营 
	REQ_COUNTRY_POST_APPOINT         = 14050,       [14050] = "REQ_COUNTRY_POST_APPOINT", 
	-- [14060]罢免官员 -- 阵营 
	REQ_COUNTRY_POST_RECALL          = 14060,       [14060] = "REQ_COUNTRY_POST_RECALL", 
	-- [14070]官员辞职 -- 阵营 
	REQ_COUNTRY_POST_RESIGN          = 14070,       [14070] = "REQ_COUNTRY_POST_RESIGN", 
	-- [14080]阵营职位改变消息通知(阵营广播) -- 阵营 
	ACK_COUNTRY_POST_NOTICE          = 14080,       [14080] = "ACK_COUNTRY_POST_NOTICE", 
	-- [14090]阵营事件广播 -- 阵营 
	ACK_COUNTRY_EVENT_BROADCAST      = 14090,       [14090] = "ACK_COUNTRY_EVENT_BROADCAST", 

	--------------------------------------------------------
	-- 18001 - 18100 ( 活动-钓鱼达人 ) 
	--------------------------------------------------------
	-- [18010]请求钓鱼界面 -- 活动-钓鱼达人 
	REQ_FISHING_ASK_FISHING          = 18010,       [18010] = "REQ_FISHING_ASK_FISHING", 
	-- [18015]请求界面成功 -- 活动-钓鱼达人 
	ACK_FISHING_OK_FISHING           = 18015,       [18015] = "ACK_FISHING_OK_FISHING", 
	-- [18017]可收取鱼数据块 -- 活动-钓鱼达人 
	ACK_FISHING_FISH_DATE            = 18017,       [18017] = "ACK_FISHING_FISH_DATE", 
	-- [18020]请求开始钓鱼 -- 活动-钓鱼达人 
	REQ_FISHING_ASK_GO_FISH          = 18020,       [18020] = "REQ_FISHING_ASK_GO_FISH", 
	-- [18025]开始钓鱼 -- 活动-钓鱼达人 
	ACK_FISHING_OK_GO_FISHING        = 18025,       [18025] = "ACK_FISHING_OK_GO_FISHING", 
	-- [18030]钓到鱼了 -- 活动-钓鱼达人 
	ACK_FISHING_CATCH_FISH           = 18030,       [18030] = "ACK_FISHING_CATCH_FISH", 
	-- [18040]请求收获鱼 -- 活动-钓鱼达人 
	REQ_FISHING_GET_FISH             = 18040,       [18040] = "REQ_FISHING_GET_FISH", 
	-- [18045]收取成功 -- 活动-钓鱼达人 
	ACK_FISHING_OK_GET_FISH          = 18045,       [18045] = "ACK_FISHING_OK_GET_FISH", 
	-- [18050]rmb收鱼 -- 活动-钓鱼达人 
	REQ_FISHING_RMB                  = 18050,       [18050] = "REQ_FISHING_RMB", 

	--------------------------------------------------------
	-- 18101 - 19100 ( 荣誉 ) 
	--------------------------------------------------------
	-- [18110]请求荣誉列表 -- 荣誉 
	REQ_HONOR_LIST_REQUEST           = 18110,       [18110] = "REQ_HONOR_LIST_REQUEST", 
	-- [18120]领取奖励 -- 荣誉 
	REQ_HONOR_REWARD                 = 18120,       [18120] = "REQ_HONOR_REWARD", 
	-- [18125]领取成功 -- 荣誉 
	ACK_HONOR_REWARD_OK              = 18125,       [18125] = "ACK_HONOR_REWARD_OK", 
	-- [18130]荣誉状态列表 -- 荣誉 
	ACK_HONOR_LIST_RETURN            = 18130,       [18130] = "ACK_HONOR_LIST_RETURN", 
	-- [18150]荣誉达成提示 -- 荣誉 
	ACK_HONOR_REACH_TIP              = 18150,       [18150] = "ACK_HONOR_REACH_TIP", 

	--------------------------------------------------------
	-- 21101 - 21500 ( 活动-保卫经书 ) 
	--------------------------------------------------------
	-- [21110]请求参加怪物攻城 -- 活动-保卫经书 
	REQ_DEFEND_BOOK_REQUEST          = 21110,       [21110] = "REQ_DEFEND_BOOK_REQUEST", 
	-- [21120]进入场景 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_INTER_SCENE      = 21120,       [21120] = "ACK_DEFEND_BOOK_INTER_SCENE", 
	-- [21122]倒计时 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_TIME             = 21122,       [21122] = "ACK_DEFEND_BOOK_TIME", 
	-- [21130]请求场景玩家数据 -- 活动-保卫经书 
	REQ_DEFEND_BOOK_ASK_PLAYER_DATE  = 21130,       [21130] = "REQ_DEFEND_BOOK_ASK_PLAYER_DATE", 
	-- [21135]所有怪物数据返回 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_OK_MONST_DATA    = 21135,       [21135] = "ACK_DEFEND_BOOK_OK_MONST_DATA", 
	-- [21136]怪物数据组 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_MONSTER          = 21136,       [21136] = "ACK_DEFEND_BOOK_MONSTER", 
	-- [21137]怪物数据刷新 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_MONSTER_DATA     = 21137,       [21137] = "ACK_DEFEND_BOOK_MONSTER_DATA", 
	-- [21140]玩家对怪伤害值 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_SELF_HARM        = 21140,       [21140] = "ACK_DEFEND_BOOK_SELF_HARM", 
	-- [21145]对怪物累计伤害前10排名 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_RANKING          = 21145,       [21145] = "ACK_DEFEND_BOOK_RANKING", 
	-- [21150]排行榜数据 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_RANK_DATA        = 21150,       [21150] = "ACK_DEFEND_BOOK_RANK_DATA", 
	-- [21160]阵营积分数据 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_CAMP_INTEGRAL    = 21160,       [21160] = "ACK_DEFEND_BOOK_CAMP_INTEGRAL", 
	-- [21165]阵营积分数据_新 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_CAMP_INTEGRAL_N  = 21165,       [21165] = "ACK_DEFEND_BOOK_CAMP_INTEGRAL_N", 
	-- [21170]战壕数据 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_TRENCH_DATE      = 21170,       [21170] = "ACK_DEFEND_BOOK_TRENCH_DATE", 
	-- [21175]单个防守圈玩家数据 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_PLAYER_DATE      = 21175,       [21175] = "ACK_DEFEND_BOOK_PLAYER_DATE", 
	-- [21180]战壕玩家信息块 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_DATE_TRENCH      = 21180,       [21180] = "ACK_DEFEND_BOOK_DATE_TRENCH", 
	-- [21190]请求选择战壕 -- 活动-保卫经书 
	REQ_DEFEND_BOOK_ASK_TRENCH       = 21190,       [21190] = "REQ_DEFEND_BOOK_ASK_TRENCH", 
	-- [21200]请求战壕结果 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_OK_TRENCH        = 21200,       [21200] = "ACK_DEFEND_BOOK_OK_TRENCH", 
	-- [21210]开始战斗 -- 活动-保卫经书 
	REQ_DEFEND_BOOK_START_WAR        = 21210,       [21210] = "REQ_DEFEND_BOOK_START_WAR", 
	-- [21220]战斗结果返回 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_WAR_RETRUN       = 21220,       [21220] = "ACK_DEFEND_BOOK_WAR_RETRUN", 
	-- [21223]战斗怪物更新 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_WAR_MONSTERS     = 21223,       [21223] = "ACK_DEFEND_BOOK_WAR_MONSTERS", 
	-- [21225]玩家死亡 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_KILL_PLAYERS     = 21225,       [21225] = "ACK_DEFEND_BOOK_KILL_PLAYERS", 
	-- [21227]击杀掉落 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_KILL_REWARDS     = 21227,       [21227] = "ACK_DEFEND_BOOK_KILL_REWARDS", 
	-- [21230]请求拾取击杀奖励 -- 活动-保卫经书 
	REQ_DEFEND_BOOK_ASK_GET_REWARDS  = 21230,       [21230] = "REQ_DEFEND_BOOK_ASK_GET_REWARDS", 
	-- [21232]拾取击杀奖励 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_OK_GET_REWARDS   = 21232,       [21232] = "ACK_DEFEND_BOOK_OK_GET_REWARDS", 
	-- [21240]复活 -- 活动-保卫经书 
	REQ_DEFEND_BOOK_REVIVE           = 21240,       [21240] = "REQ_DEFEND_BOOK_REVIVE", 
	-- [21250]复活成功 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_OK_REVIVE        = 21250,       [21250] = "ACK_DEFEND_BOOK_OK_REVIVE", 
	-- [21260]请求退出战斗 -- 活动-保卫经书 
	REQ_DEFEND_BOOK_REQUEST_BACK     = 21260,       [21260] = "REQ_DEFEND_BOOK_REQUEST_BACK", 
	-- [21270]开启增益 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_START_BUFF       = 21270,       [21270] = "ACK_DEFEND_BOOK_START_BUFF", 
	-- [21280]请求领取增益 -- 活动-保卫经书 
	REQ_DEFEND_BOOK_GAIN             = 21280,       [21280] = "REQ_DEFEND_BOOK_GAIN", 
	-- [21290]领取增益成功 -- 活动-保卫经书 
	ACK_DEFEND_BOOK_OK_GAIN          = 21290,       [21290] = "ACK_DEFEND_BOOK_OK_GAIN", 
	-- [21300]请求更换战壕 -- 活动-保卫经书 
	REQ_DEFEND_BOOK_CHANGE_TRENCH    = 21300,       [21300] = "REQ_DEFEND_BOOK_CHANGE_TRENCH", 

	--------------------------------------------------------
	-- 22101 - 22200 ( 声望 ) 
	--------------------------------------------------------
	-- [22102] 请求声望面板 -- 声望 
	REQ_RENOWN_REQUEST               = 22102,       [22102] = "REQ_RENOWN_REQUEST", 
	-- [22103]请求声望面板成功 -- 声望 
	ACK_RENOWN_REQUEST_OK            = 22103,       [22103] = "ACK_RENOWN_REQUEST_OK", 
	-- [22106]提醒领取俸禄 -- 声望 
	ACK_RENOWN_NOTICE                = 22106,       [22106] = "ACK_RENOWN_NOTICE", 
	-- [22107]领取每日俸禄 -- 声望 
	REQ_RENOWN_REWARD                = 22107,       [22107] = "REQ_RENOWN_REWARD", 
	-- [22108]领取每日俸禄成功 -- 声望 
	ACK_RENOWN_REWARD_OK             = 22108,       [22108] = "ACK_RENOWN_REWARD_OK", 

	--------------------------------------------------------
	-- 22201 - 22700 ( 福利 ) 
	--------------------------------------------------------
	-- [22210]请求福利数据 -- 福利 
	REQ_WELFARE_REQUEST              = 22210,       [22210] = "REQ_WELFARE_REQUEST", 
	-- [22220]连续登陆数据返回 -- 福利 
	ACK_WELFARE_CONTINUE_BACK        = 22220,       [22220] = "ACK_WELFARE_CONTINUE_BACK", 
	-- [22230]在线奖励数据 -- 福利 
	ACK_WELFARE_CUMUL_BACK           = 22230,       [22230] = "ACK_WELFARE_CUMUL_BACK", 
	-- [22240]充值奖励数据 -- 福利 
	ACK_WELFARE_PAY_BACK             = 22240,       [22240] = "ACK_WELFARE_PAY_BACK", 
	-- [22250]找回经验数据 -- 福利 
	ACK_WELFARE_RECOVER_EXP          = 22250,       [22250] = "ACK_WELFARE_RECOVER_EXP", 
	-- [22260]领取奖励 -- 福利 
	REQ_WELFARE_REWARD_GET           = 22260,       [22260] = "REQ_WELFARE_REWARD_GET", 
	-- [22270]领取奖励结果 -- 福利 
	ACK_WELFARE_REWARD_RESULT        = 22270,       [22270] = "ACK_WELFARE_REWARD_RESULT", 
	-- [22280]黄钻每日面板数据 -- 福利 
	ACK_WELFARE_YELLOW_DAY_BACK      = 22280,       [22280] = "ACK_WELFARE_YELLOW_DAY_BACK", 
	-- [22290]黄钻成长数据 -- 福利 
	ACK_WELFARE_YELLOW_GROW_BACK     = 22290,       [22290] = "ACK_WELFARE_YELLOW_GROW_BACK", 

	--------------------------------------------------------
	-- 22701 - 22800 ( 日志 ) 
	--------------------------------------------------------
	-- [22760]获得|失去通知 -- 日志 
	ACK_GAME_LOGS_NOTICES            = 22760,       [22760] = "ACK_GAME_LOGS_NOTICES", 
	-- [22770]信息组协议块 -- 日志 
	ACK_GAME_LOGS_MESS               = 22770,       [22770] = "ACK_GAME_LOGS_MESS", 
	-- [22780]事件通知 -- 日志 
	ACK_GAME_LOGS_EVENT              = 22780,       [22780] = "ACK_GAME_LOGS_EVENT", 
	-- [22781]字符串信息块 -- 日志 
	ACK_GAME_LOGS_STR_XXX            = 22781,       [22781] = "ACK_GAME_LOGS_STR_XXX", 
	-- [22782]数字信息块 -- 日志 
	ACK_GAME_LOGS_INT_XXX            = 22782,       [22782] = "ACK_GAME_LOGS_INT_XXX", 

	--------------------------------------------------------
	-- 22801 - 23800 ( 宠物 ) 
	--------------------------------------------------------
	-- [22801]宠物消息块 -- 宠物 
	ACK_PET_PET                      = 22801,       [22801] = "ACK_PET_PET", 
	-- [22810]请求宠物列表 -- 宠物 
	REQ_PET_REQUEST                  = 22810,       [22810] = "REQ_PET_REQUEST", 
	-- [22820]返回魔宠信息列表 -- 宠物 
	ACK_PET_REVERSE                  = 22820,       [22820] = "ACK_PET_REVERSE", 
	-- [22825]式神信息块 -- 宠物 
	ACK_PET_SKILLS                   = 22825,       [22825] = "ACK_PET_SKILLS", 
	-- [22827]皮肤信息块 -- 宠物 
	ACK_PET_SKINS                    = 22827,       [22827] = "ACK_PET_SKINS", 
	-- [22830]开启式神 -- 宠物 
	REQ_PET_OPEN                     = 22830,       [22830] = "REQ_PET_OPEN", 
	-- [22840]开启式神ok -- 宠物 
	ACK_PET_OPEN_OK                  = 22840,       [22840] = "ACK_PET_OPEN_OK", 
	-- [22850]召唤式神 -- 宠物 
	REQ_PET_CALL                     = 22850,       [22850] = "REQ_PET_CALL", 
	-- [22860]召唤式神成功返回 -- 宠物 
	ACK_PET_CALL_OK                  = 22860,       [22860] = "ACK_PET_CALL_OK", 
	-- [22870]修炼还需要的钻石数 -- 宠物 
	REQ_PET_NEED_RMB                 = 22870,       [22870] = "REQ_PET_NEED_RMB", 
	-- [22875]修炼需要钻石返回 -- 宠物 
	ACK_PET_NEED_RMB_REPLY           = 22875,       [22875] = "ACK_PET_NEED_RMB_REPLY", 
	-- [22880]魔宠修炼 -- 宠物 
	REQ_PET_XIULIAN                  = 22880,       [22880] = "REQ_PET_XIULIAN", 
	-- [22885]魔宠修炼成功返回 -- 宠物 
	ACK_PET_XIULIAN_OK               = 22885,       [22885] = "ACK_PET_XIULIAN_OK", 
	-- [22900]式神幻化 -- 宠物 
	REQ_PET_HUANHUA                  = 22900,       [22900] = "REQ_PET_HUANHUA", 
	-- [22950]幻化成功返回 -- 宠物 
	ACK_PET_HUANHUA_REPLY            = 22950,       [22950] = "ACK_PET_HUANHUA_REPLY", 
	-- [22980]宠物栏开格成功 -- 宠物 
	ACK_PET_CTN_ENLARGE_OK           = 22980,       [22980] = "ACK_PET_CTN_ENLARGE_OK", 
	-- [23000]请求幻化界面 -- 宠物 
	REQ_PET_HUANHUA_REQUEST          = 23000,       [23000] = "REQ_PET_HUANHUA_REQUEST", 
	-- [23010]幻化界面返回 -- 宠物 
	ACK_PET_HH_REPLY_MSG             = 23010,       [23010] = "ACK_PET_HH_REPLY_MSG", 

	--------------------------------------------------------
	-- 23801 - 24800 ( 逐鹿台 ) 
	--------------------------------------------------------
	-- [23810]进入封神台 -- 逐鹿台 
	REQ_ARENA_JOIN                   = 23810,       [23810] = "REQ_ARENA_JOIN", 
	-- [23820]可以挑战的玩家列表 -- 逐鹿台 
	ACK_ARENA_DEKARON                = 23820,       [23820] = "ACK_ARENA_DEKARON", 
	-- [23821]可以挑战的玩家 -- 逐鹿台 
	ACK_ARENA_CANBECHALLAGE          = 23821,       [23821] = "ACK_ARENA_CANBECHALLAGE", 
	-- [23830]挑战 -- 逐鹿台 
	REQ_ARENA_BATTLE                 = 23830,       [23830] = "REQ_ARENA_BATTLE", 
	-- [23831]战斗信息块 -- 逐鹿台 
	ACK_ARENA_WAR_DATA               = 23831,       [23831] = "ACK_ARENA_WAR_DATA", 
	-- [23832]封神台开始广播 -- 逐鹿台 
	ACK_ARENA_STRAT                  = 23832,       [23832] = "ACK_ARENA_STRAT", 
	-- [23835]挑战奖励 -- 逐鹿台 
	ACK_ARENA_WAR_REWARD             = 23835,       [23835] = "ACK_ARENA_WAR_REWARD", 
	-- [23840]挑战结束 -- 逐鹿台 
	REQ_ARENA_FINISH                 = 23840,       [23840] = "REQ_ARENA_FINISH", 
	-- [23850]战果广播 -- 逐鹿台 
	ACK_ARENA_RADIO                  = 23850,       [23850] = "ACK_ARENA_RADIO", 
	-- [23860]购买挑战次数 -- 逐鹿台 
	REQ_ARENA_BUY                    = 23860,       [23860] = "REQ_ARENA_BUY", 
	-- [23870]结果 -- 逐鹿台 
	ACK_ARENA_RESULT2                = 23870,       [23870] = "ACK_ARENA_RESULT2", 
	-- [23880]确定购买 -- 逐鹿台 
	REQ_ARENA_BUY_YES                = 23880,       [23880] = "REQ_ARENA_BUY_YES", 
	-- [23890]返回结果 -- 逐鹿台 
	ACK_ARENA_BUY_OK                 = 23890,       [23890] = "ACK_ARENA_BUY_OK", 
	-- [23900]退出封神台 -- 逐鹿台 
	REQ_ARENA_EXIT                   = 23900,       [23900] = "REQ_ARENA_EXIT", 
	-- [23910]退出成功 -- 逐鹿台 
	ACK_ARENA_OK                     = 23910,       [23910] = "ACK_ARENA_OK", 
	-- [23920]请求封神台排行榜 -- 逐鹿台 
	REQ_ARENA_KILLER                 = 23920,       [23920] = "REQ_ARENA_KILLER", 
	-- [23930]返回高手信息 -- 逐鹿台 
	ACK_ARENA_KILLER_DATA            = 23930,       [23930] = "ACK_ARENA_KILLER_DATA", 
	-- [23931]高手信息 -- 逐鹿台 
	ACK_ARENA_ACE                    = 23931,       [23931] = "ACK_ARENA_ACE", 
	-- [23940]返回最竞技场信息 -- 逐鹿台 
	ACK_ARENA_MAX_DATA               = 23940,       [23940] = "ACK_ARENA_MAX_DATA", 
	-- [23960]领取每日奖励 -- 逐鹿台 
	REQ_ARENA_DAY_REWARD             = 23960,       [23960] = "REQ_ARENA_DAY_REWARD", 
	-- [23970]领取结果 -- 逐鹿台 
	ACK_ARENA_GET_REWARD             = 23970,       [23970] = "ACK_ARENA_GET_REWARD", 
	-- [23971]获得物品id列表 -- 逐鹿台 
	ACK_ARENA_GOODS_LIST             = 23971,       [23971] = "ACK_ARENA_GOODS_LIST", 
	-- [24000]领取倒计时 -- 逐鹿台 
	ACK_ARENA_REWARD_TIMES           = 24000,       [24000] = "ACK_ARENA_REWARD_TIMES", 
	-- [24010]清除CD时间 -- 逐鹿台 
	REQ_ARENA_CLEAN                  = 24010,       [24010] = "REQ_ARENA_CLEAN", 
	-- [24020]清除成功 -- 逐鹿台 
	ACK_ARENA_CLEAN_OK               = 24020,       [24020] = "ACK_ARENA_CLEAN_OK", 

	--------------------------------------------------------
	-- 24801 - 24900 ( 排行榜 ) 
	--------------------------------------------------------
	-- [24810]请求排行版 -- 排行榜 
	REQ_TOP_RANK                     = 24810,       [24810] = "REQ_TOP_RANK", 
	-- [24820]排行榜信息 -- 排行榜 
	ACK_TOP_DATE                     = 24820,       [24820] = "ACK_TOP_DATE", 
	-- [24830]排行信息块 -- 排行榜 
	ACK_TOP_XXXX                     = 24830,       [24830] = "ACK_TOP_XXXX", 

	--------------------------------------------------------
	-- 24901 - 24999 ( 新手卡 ) 
	--------------------------------------------------------
	-- [24910]领取卡 -- 新手卡 
	REQ_CARD_GETS                    = 24910,       [24910] = "REQ_CARD_GETS", 
	-- [24920]领取成功 -- 新手卡 
	ACK_CARD_SUCCEED                 = 24920,       [24920] = "ACK_CARD_SUCCEED", 
	-- [24930]请求促销活动可领取状态 -- 新手卡 
	REQ_CARD_SALES_ASK               = 24930,       [24930] = "REQ_CARD_SALES_ASK", 
	-- [24932]促销活动状态返回 -- 新手卡 
	ACK_CARD_SALES_DATA              = 24932,       [24932] = "ACK_CARD_SALES_DATA", 
	-- [24933]促销活动信息 -- 新手卡 
	ACK_CARD_ID_DATE                 = 24933,       [24933] = "ACK_CARD_ID_DATE", 
	-- [24934]促销活动开启阶段 -- 新手卡 
	ACK_CARD_ID_SUB                  = 24934,       [24934] = "ACK_CARD_ID_SUB", 
	-- [24940]请求领取奖励 -- 新手卡 
	REQ_CARD_SALES_GET               = 24940,       [24940] = "REQ_CARD_SALES_GET", 
	-- [24950]领取成功 -- 新手卡 
	ACK_CARD_GET_OK                  = 24950,       [24950] = "ACK_CARD_GET_OK", 
	-- [24960]领取通知 -- 新手卡 
	ACK_CARD_NOTICE                  = 24960,       [24960] = "ACK_CARD_NOTICE", 
	-- [24970]以领取的活动Id -- 新手卡 
	ACK_CARD_RECE                    = 24970,       [24970] = "ACK_CARD_RECE", 
	-- [24980]以领取的活动 -- 新手卡 
	ACK_CARD_XXXXX                   = 24980,       [24980] = "ACK_CARD_XXXXX", 

	--------------------------------------------------------
	-- 26000 - 26999 ( NPC ) 
	--------------------------------------------------------
	-- [26000]请求NPC -- NPC 
	REQ_NPC_REQUEST                  = 26000,       [26000] = "REQ_NPC_REQUEST", 
	-- [26005]队伍列表 -- NPC 
	ACK_NPC_LIST                     = 26005,       [26005] = "ACK_NPC_LIST", 
	-- [26007]返回NPC副本ID -- NPC 
	ACK_NPC_COPY_ID                  = 26007,       [26007] = "ACK_NPC_COPY_ID", 
	-- [26010]从NPC处滚蛋 -- NPC 
	REQ_NPC_SCRAM                    = 26010,       [26010] = "REQ_NPC_SCRAM", 
	-- [26015]关闭组队面板 -- NPC 
	ACK_NPC_CLOSE                    = 26015,       [26015] = "ACK_NPC_CLOSE", 
	-- [26020]通知--删除队伍 -- NPC 
	ACK_NPC_NOTICE_DELETE            = 26020,       [26020] = "ACK_NPC_NOTICE_DELETE", 
	-- [26040]设置队长 -- NPC 
	REQ_NPC_SET_LEADER               = 26040,       [26040] = "REQ_NPC_SET_LEADER", 
	-- [26050]加入队伍 -- NPC 
	REQ_NPC_JOIN                     = 26050,       [26050] = "REQ_NPC_JOIN", 
	-- [26060]退出队伍 -- NPC 
	REQ_NPC_LEAVE                    = 26060,       [26060] = "REQ_NPC_LEAVE", 
	-- [26070]踢出队员 -- NPC 
	REQ_NPC_KICK                     = 26070,       [26070] = "REQ_NPC_KICK", 
	-- [26080]解散队伍 -- NPC 
	REQ_NPC_DISMISS                  = 26080,       [26080] = "REQ_NPC_DISMISS", 
	-- [26100]NPC进入(战场|副本|各种组队玩法) -- NPC 
	REQ_NPC_TEAM_ENTER               = 26100,       [26100] = "REQ_NPC_TEAM_ENTER", 
	-- [26110]隐藏队伍 -- NPC 
	ACK_NPC_NOTICE_HIDE              = 26110,       [26110] = "ACK_NPC_NOTICE_HIDE", 

	--------------------------------------------------------
	-- 28000 - 29000 ( 布阵 ) 
	--------------------------------------------------------
	-- [28000]返回伙伴信息数据 -- 布阵 
	ACK_ARRAY_LIST_DATA              = 28000,       [28000] = "ACK_ARRAY_LIST_DATA", 
	-- [28010]请求阵型系统 -- 布阵 
	REQ_ARRAY_LIST                   = 28010,       [28010] = "REQ_ARRAY_LIST", 
	-- [28020]上阵 -- 布阵 
	REQ_ARRAY_UP_ARRAY               = 28020,       [28020] = "REQ_ARRAY_UP_ARRAY", 
	-- [28030]下阵 -- 布阵 
	REQ_ARRAY_DOWN_ARRAY             = 28030,       [28030] = "REQ_ARRAY_DOWN_ARRAY", 
	-- [28040]交换阵位 -- 布阵 
	REQ_ARRAY_EXCHANGE               = 28040,       [28040] = "REQ_ARRAY_EXCHANGE", 
	-- [28050]布阵伙伴信息块 -- 布阵 
	ACK_ARRAY_ROLE_INFO              = 28050,       [28050] = "ACK_ARRAY_ROLE_INFO", 

	--------------------------------------------------------
	-- 30501 - 31000 ( 活动面板 ) 
	--------------------------------------------------------
	-- [30501]活动状态改变滚屏通知 -- 活动面板 
	ACK_ACTIVITY_DATA                = 30501,       [30501] = "ACK_ACTIVITY_DATA", 
	-- [30510]请求活动数据 -- 活动面板 
	REQ_ACTIVITY_REQUEST             = 30510,       [30510] = "REQ_ACTIVITY_REQUEST", 
	-- [30520]活动数据返回 -- 活动面板 
	ACK_ACTIVITY_OK_ACTIVE_DATA      = 30520,       [30520] = "ACK_ACTIVITY_OK_ACTIVE_DATA", 
	-- [30540]活动数据 -- 活动面板 
	ACK_ACTIVITY_ACTIVE_DATA         = 30540,       [30540] = "ACK_ACTIVITY_ACTIVE_DATA", 
	-- [30610]请求活跃度数据 -- 活动面板 
	REQ_ACTIVITY_ASK_LINK_DATA       = 30610,       [30610] = "REQ_ACTIVITY_ASK_LINK_DATA", 
	-- [30620]活跃度数据返回 -- 活动面板 
	ACK_ACTIVITY_OK_LINK_DATA        = 30620,       [30620] = "ACK_ACTIVITY_OK_LINK_DATA", 
	-- [30630]活动数据信息块 -- 活动面板 
	ACK_ACTIVITY_ACTIVE_LINK_MSG     = 30630,       [30630] = "ACK_ACTIVITY_ACTIVE_LINK_MSG", 
	-- [30640]奖励数据块 -- 活动面板 
	ACK_ACTIVITY_REWARDS_DATA        = 30640,       [30640] = "ACK_ACTIVITY_REWARDS_DATA", 
	-- [30650]请求领取奖励 -- 活动面板 
	REQ_ACTIVITY_ASK_REWARDS         = 30650,       [30650] = "REQ_ACTIVITY_ASK_REWARDS", 
	-- [30660]领奖状态返回 -- 活动面板 
	ACK_ACTIVITY_OK_GET_REWARDS      = 30660,       [30660] = "ACK_ACTIVITY_OK_GET_REWARDS", 

	--------------------------------------------------------
	-- 31001 - 32000 ( 客栈 ) 
	--------------------------------------------------------
	-- [31110]请求客栈 -- 客栈 
	REQ_INN_ENJOY_INN                = 31110,       [31110] = "REQ_INN_ENJOY_INN", 
	-- [31120]伙伴列表 -- 客栈 
	ACK_INN_LIST                     = 31120,       [31120] = "ACK_INN_LIST", 
	-- [31121]伙伴信息块 -- 客栈 
	ACK_INN_H_DATA                   = 31121,       [31121] = "ACK_INN_H_DATA", 
	-- [31150]招募伙伴 -- 客栈 
	REQ_INN_CALL_PARTNER             = 31150,       [31150] = "REQ_INN_CALL_PARTNER", 
	-- [31170]伙伴出战 -- 客栈 
	REQ_INN_WAR                      = 31170,       [31170] = "REQ_INN_WAR", 
	-- [31180]伙伴出战休息 -- 客栈 
	REQ_INN_NTE_WAR                  = 31180,       [31180] = "REQ_INN_NTE_WAR", 
	-- [31250]离队 -- 客栈 
	REQ_INN_DROP_OUT                 = 31250,       [31250] = "REQ_INN_DROP_OUT", 
	-- [31260]归队 -- 客栈 
	REQ_INN_ENJOY                    = 31260,       [31260] = "REQ_INN_ENJOY", 
	-- [31270]离队/归队结果 -- 客栈 
	ACK_INN_RES_PARTNER              = 31270,       [31270] = "ACK_INN_RES_PARTNER", 

	--------------------------------------------------------
	-- 32001 - 33000 ( 财神 ) 
	--------------------------------------------------------
	-- [32010]请求招财面板 -- 财神 
	REQ_WEAGOD_REQUEST               = 32010,       [32010] = "REQ_WEAGOD_REQUEST", 
	-- [32020]招财面板返回 -- 财神 
	ACK_WEAGOD_REPLY                 = 32020,       [32020] = "ACK_WEAGOD_REPLY", 
	-- [32030]招财 -- 财神 
	REQ_WEAGOD_GET_MONEY             = 32030,       [32030] = "REQ_WEAGOD_GET_MONEY", 
	-- [32040]批量招财 -- 财神 
	REQ_WEAGOD_PL_MONEY              = 32040,       [32040] = "REQ_WEAGOD_PL_MONEY", 
	-- [32050]自动招财 -- 财神 
	REQ_WEAGOD_AUTO_GET              = 32050,       [32050] = "REQ_WEAGOD_AUTO_GET", 
	-- [32060]招财成功返回 -- 财神 
	ACK_WEAGOD_SUCCESS               = 32060,       [32060] = "ACK_WEAGOD_SUCCESS", 

	--------------------------------------------------------
	-- 33001 - 34000 ( 社团 ) 
	--------------------------------------------------------
	-- [33001]通知  【废除不用】 -- 社团 
	ACK_CLAN_MESSAGE                 = 33001,       [33001] = "ACK_CLAN_MESSAGE", 
	-- [33010]请求帮派面板 -- 社团 
	REQ_CLAN_ASK_CLAN                = 33010,       [33010] = "REQ_CLAN_ASK_CLAN", 
	-- [33020]返加帮派基础数据1 -- 社团 
	ACK_CLAN_OK_CLAN_DATA            = 33020,       [33020] = "ACK_CLAN_OK_CLAN_DATA", 
	-- [33023]返加帮派基础数据2 -- 社团 
	ACK_CLAN_OK_OTHER_DATA           = 33023,       [33023] = "ACK_CLAN_OK_OTHER_DATA", 
	-- [33025]返加帮派日志数据3 -- 社团 
	ACK_CLAN_CLAN_LOGS               = 33025,       [33025] = "ACK_CLAN_CLAN_LOGS", 
	-- [33026]帮派日志数据块 -- 社团 
	ACK_CLAN_LOGS_MSG                = 33026,       [33026] = "ACK_CLAN_LOGS_MSG", 
	-- [33027]string数据块 -- 社团 
	ACK_CLAN_STRING_MSG              = 33027,       [33027] = "ACK_CLAN_STRING_MSG", 
	-- [33028]int数据块 -- 社团 
	ACK_CLAN_INT_MSG                 = 33028,       [33028] = "ACK_CLAN_INT_MSG", 
	-- [33030]请求帮派列表 -- 社团 
	REQ_CLAN_ASL_CLANLIST            = 33030,       [33030] = "REQ_CLAN_ASL_CLANLIST", 
	-- [33034]帮派列表返回 -- 社团 
	ACK_CLAN_OK_CLANLIST             = 33034,       [33034] = "ACK_CLAN_OK_CLANLIST", 
	-- [33036]已申请帮派列表 -- 社团 
	ACK_CLAN_APPLIED_CLANLIST        = 33036,       [33036] = "ACK_CLAN_APPLIED_CLANLIST", 
	-- [33037]请求|取消入帮申请 -- 社团 
	REQ_CLAN_ASK_CANCEL              = 33037,       [33037] = "REQ_CLAN_ASK_CANCEL", 
	-- [33040]申请成功 -- 社团 
	ACK_CLAN_OK_JOIN_CLAN            = 33040,       [33040] = "ACK_CLAN_OK_JOIN_CLAN", 
	-- [33050]请求创建帮派 -- 社团 
	REQ_CLAN_ASK_REBUILD_CLAN        = 33050,       [33050] = "REQ_CLAN_ASK_REBUILD_CLAN", 
	-- [33060]创建成功 -- 社团 
	ACK_CLAN_OK_REBUILD_CLAN         = 33060,       [33060] = "ACK_CLAN_OK_REBUILD_CLAN", 
	-- [33070]请求入帮申请列表 -- 社团 
	REQ_CLAN_ASK_JOIN_LIST           = 33070,       [33070] = "REQ_CLAN_ASK_JOIN_LIST", 
	-- [33080]返回入帮申请列表 -- 社团 
	ACK_CLAN_OK_JOIN_LIST            = 33080,       [33080] = "ACK_CLAN_OK_JOIN_LIST", 
	-- [33085]入帮申请玩家信息块 -- 社团 
	ACK_CLAN_USER_DATA               = 33085,       [33085] = "ACK_CLAN_USER_DATA", 
	-- [33090]请求审核操作 -- 社团 
	REQ_CLAN_ASK_AUDIT               = 33090,       [33090] = "REQ_CLAN_ASK_AUDIT", 
	-- [33095]返回审核结果 -- 社团 
	ACK_CLAN_OK_AUDIT                = 33095,       [33095] = "ACK_CLAN_OK_AUDIT", 
	-- [33110]请求修改帮派公告 -- 社团 
	REQ_CLAN_ASK_RESET_CAST          = 33110,       [33110] = "REQ_CLAN_ASK_RESET_CAST", 
	-- [33120]返回修改公告结果 -- 社团 
	ACK_CLAN_OK_RESET_CAST           = 33120,       [33120] = "ACK_CLAN_OK_RESET_CAST", 
	-- [33130]请求帮派成员列表 -- 社团 
	REQ_CLAN_ASK_MEMBER_MSG          = 33130,       [33130] = "REQ_CLAN_ASK_MEMBER_MSG", 
	-- [33135]请求设置成员职位 -- 社团 
	REQ_CLAN_ASK_SET_POST            = 33135,       [33135] = "REQ_CLAN_ASK_SET_POST", 
	-- [33140]返回帮派成员列表 -- 社团 
	ACK_CLAN_OK_MEMBER_LIST          = 33140,       [33140] = "ACK_CLAN_OK_MEMBER_LIST", 
	-- [33145]成员数据信息块 -- 社团 
	ACK_CLAN_MEMBER_MSG              = 33145,       [33145] = "ACK_CLAN_MEMBER_MSG", 
	-- [33150]请求退出|解散帮派 -- 社团 
	REQ_CLAN_ASK_OUT_CLAN            = 33150,       [33150] = "REQ_CLAN_ASK_OUT_CLAN", 
	-- [33160]退出帮派成功 -- 社团 
	ACK_CLAN_OK_OUT_CLAN             = 33160,       [33160] = "ACK_CLAN_OK_OUT_CLAN", 
	-- [33200]请求帮派技能面板 -- 社团 
	REQ_CLAN_ASK_CLAN_SKILL          = 33200,       [33200] = "REQ_CLAN_ASK_CLAN_SKILL", 
	-- [33210]返回帮派技能面板数据 -- 社团 
	ACK_CLAN_OK_CLAN_SKILL           = 33210,       [33210] = "ACK_CLAN_OK_CLAN_SKILL", 
	-- [33215]帮派技能属性数据块【33215】 -- 社团 
	ACK_CLAN_CLAN_ATTR_DATA          = 33215,       [33215] = "ACK_CLAN_CLAN_ATTR_DATA", 
	-- [33220]请求学习帮派技能 -- 社团 
	REQ_CLAN_STUDY_SKILL             = 33220,       [33220] = "REQ_CLAN_STUDY_SKILL", 
	-- [33300]请求帮派活动面板 -- 社团 
	REQ_CLAN_ASK_CLAN_ACTIVE         = 33300,       [33300] = "REQ_CLAN_ASK_CLAN_ACTIVE", 
	-- [33305]玩家现有体能值 -- 社团 
	ACK_CLAN_NOW_STAMINA             = 33305,       [33305] = "ACK_CLAN_NOW_STAMINA", 
	-- [33310]返回活动面板数据 -- 社团 
	ACK_CLAN_OK_ACTIVE_DATA          = 33310,       [33310] = "ACK_CLAN_OK_ACTIVE_DATA", 
	-- [33315]帮派活动面板数据块 -- 社团 
	ACK_CLAN_ACTIVE_MSG              = 33315,       [33315] = "ACK_CLAN_ACTIVE_MSG", 
	-- [33320]请求浇水 -- 社团 
	REQ_CLAN_ASK_WATER               = 33320,       [33320] = "REQ_CLAN_ASK_WATER", 
	-- [33325]请求开始浇水|摇钱 -- 社团 
	REQ_CLAN_START_WATER             = 33325,       [33325] = "REQ_CLAN_START_WATER", 
	-- [33330]返回浇水面板数据 -- 社团 
	ACK_CLAN_OK_WATER_DATA           = 33330,       [33330] = "ACK_CLAN_OK_WATER_DATA", 
	-- [33335]浇水日志数据块 -- 社团 
	ACK_CLAN_WATER_LOGS_DATA         = 33335,       [33335] = "ACK_CLAN_WATER_LOGS_DATA", 
	-- [33360]请求开始体能训练 -- 社团 
	REQ_CLAN_ASK_START_STR           = 33360,       [33360] = "REQ_CLAN_ASK_START_STR", 
	-- [33370]训练成功[33305] -- 社团 
	ACK_CLAN_OK_STRENGTH             = 33370,       [33370] = "ACK_CLAN_OK_STRENGTH", 

	--------------------------------------------------------
	-- 34001 - 34500 ( 活动-龙宫寻宝 ) 
	--------------------------------------------------------
	-- [34010]请求寻宝界面 -- 活动-龙宫寻宝 
	REQ_DRAGON_ASK_JOIN_DRAGON       = 34010,       [34010] = "REQ_DRAGON_ASK_JOIN_DRAGON", 
	-- [34020]请求界面成功 -- 活动-龙宫寻宝 
	ACK_DRAGON_OK_JOIN_DRAGON        = 34020,       [34020] = "ACK_DRAGON_OK_JOIN_DRAGON", 
	-- [34030]开始寻宝 -- 活动-龙宫寻宝 
	REQ_DRAGON_START_DRAGON          = 34030,       [34030] = "REQ_DRAGON_START_DRAGON", 
	-- [34040]寻宝结果_旧 -- 活动-龙宫寻宝 
	ACK_DRAGON_OK_START_DRAGON       = 34040,       [34040] = "ACK_DRAGON_OK_START_DRAGON", 
	-- [34042]寻宝结果 -- 活动-龙宫寻宝 
	ACK_DRAGON_OK_START_NEW          = 34042,       [34042] = "ACK_DRAGON_OK_START_NEW", 
	-- [34050]寻宝奖励信息块 -- 活动-龙宫寻宝 
	ACK_DRAGON_REWARDS_MSG           = 34050,       [34050] = "ACK_DRAGON_REWARDS_MSG", 

	--------------------------------------------------------
	-- 34501 - 35000 ( 商城 ) 
	--------------------------------------------------------
	-- [34501]店铺物品信息块 -- 商城 
	ACK_SHOP_INFO                    = 34501,       [34501] = "ACK_SHOP_INFO", 
	-- [34502]店铺物品信息块 -- 商城 
	ACK_SHOP_INFO_NEW                = 34502,       [34502] = "ACK_SHOP_INFO_NEW", 
	-- [34510] 请求店铺面板 -- 商城 
	REQ_SHOP_REQUEST                 = 34510,       [34510] = "REQ_SHOP_REQUEST", 
	-- [34511] 请求店铺面板成功 -- 商城 
	ACK_SHOP_REQUEST_OK              = 34511,       [34511] = "ACK_SHOP_REQUEST_OK", 
	-- [34512]请求店铺面板成功 -- 商城 
	ACK_SHOP_REQUEST_OK_NEW          = 34512,       [34512] = "ACK_SHOP_REQUEST_OK_NEW", 
	-- [34515]请求购买 -- 商城 
	REQ_SHOP_BUY                     = 34515,       [34515] = "REQ_SHOP_BUY", 
	-- [34516]购买成功 -- 商城 
	ACK_SHOP_BUY_SUCC                = 34516,       [34516] = "ACK_SHOP_BUY_SUCC", 
	-- [34520]请求积分数据 -- 商城 
	REQ_SHOP_ASK_INTEGRAL            = 34520,       [34520] = "REQ_SHOP_ASK_INTEGRAL", 
	-- [34522]玩家积分数据 -- 商城 
	ACK_SHOP_INTEGRAL_BACK           = 34522,       [34522] = "ACK_SHOP_INTEGRAL_BACK", 

	--------------------------------------------------------
	-- 35001 - 36000 ( 苦工 ) 
	--------------------------------------------------------
	-- [35010]进入苦工系统 -- 苦工 
	REQ_MOIL_ENJOY_MOIL              = 35010,       [35010] = "REQ_MOIL_ENJOY_MOIL", 
	-- [35020]返回自己身份信息 -- 苦工 
	ACK_MOIL_MOIL_DATA               = 35020,       [35020] = "ACK_MOIL_MOIL_DATA", 
	-- [35021]苦工操作信息 -- 苦工 
	ACK_MOIL_MOIL_RS                 = 35021,       [35021] = "ACK_MOIL_MOIL_RS", 
	-- [35022]互动保护剩余时间 -- 苦工 
	ACK_MOIL_PROTECT_TIME            = 35022,       [35022] = "ACK_MOIL_PROTECT_TIME", 
	-- [35023]苦工保护时间列表 -- 苦工 
	ACK_MOIL_PROTECT_COUNT           = 35023,       [35023] = "ACK_MOIL_PROTECT_COUNT", 
	-- [35025]玩家信息列表(抓捕,求救) -- 苦工 
	ACK_MOIL_PLAYER_DATA             = 35025,       [35025] = "ACK_MOIL_PLAYER_DATA", 
	-- [35026]玩家信息块(抓捕,求救) -- 苦工 
	ACK_MOIL_MOIL_XXXX1              = 35026,       [35026] = "ACK_MOIL_MOIL_XXXX1", 
	-- [35030]苦工系统操作 -- 苦工 
	REQ_MOIL_OPER                    = 35030,       [35030] = "REQ_MOIL_OPER", 
	-- [35040]抓捕 -- 苦工 
	REQ_MOIL_CAPTRUE                 = 35040,       [35040] = "REQ_MOIL_CAPTRUE", 
	-- [35041]战斗结果 -- 苦工 
	REQ_MOIL_CALL_RES                = 35041,       [35041] = "REQ_MOIL_CALL_RES", 
	-- [35050]互动 -- 苦工 
	REQ_MOIL_ACTIVE                  = 35050,       [35050] = "REQ_MOIL_ACTIVE", 
	-- [35060]请求压榨/互动 -- 苦工 
	REQ_MOIL_PRESS_START             = 35060,       [35060] = "REQ_MOIL_PRESS_START", 
	-- [35061]可压榨苦工 -- 苦工 
	ACK_MOIL_PRESS_DATA              = 35061,       [35061] = "ACK_MOIL_PRESS_DATA", 
	-- [35062]苦工信息 -- 苦工 
	ACK_MOIL_MOIL_XXXX2              = 35062,       [35062] = "ACK_MOIL_MOIL_XXXX2", 
	-- [35063]进入压榨界面 -- 苦工 
	REQ_MOIL_PRESS_ENJOY             = 35063,       [35063] = "REQ_MOIL_PRESS_ENJOY", 
	-- [35064]苦工具体信息 -- 苦工 
	ACK_MOIL_MOIL_XXXX3              = 35064,       [35064] = "ACK_MOIL_MOIL_XXXX3", 
	-- [35070]压榨/抽取/提取 -- 苦工 
	REQ_MOIL_PRESS                   = 35070,       [35070] = "REQ_MOIL_PRESS", 
	-- [35080] 压榨结果 -- 苦工 
	ACK_MOIL_PRESS_RS                = 35080,       [35080] = "ACK_MOIL_PRESS_RS", 
	-- [35081]压榨分红 -- 苦工 
	ACK_MOIL_PRESS_XX                = 35081,       [35081] = "ACK_MOIL_PRESS_XX", 
	-- [35090]打工时间到 -- 苦工 
	REQ_MOIL_MOIL_TIME               = 35090,       [35090] = "REQ_MOIL_MOIL_TIME", 
	-- [35100]释放苦工 -- 苦工 
	REQ_MOIL_RELEASE                 = 35100,       [35100] = "REQ_MOIL_RELEASE", 
	-- [35110]结果 -- 苦工 
	ACK_MOIL_RELEASE_RS              = 35110,       [35110] = "ACK_MOIL_RELEASE_RS", 
	-- [35120]购买抓捕次数 -- 苦工 
	REQ_MOIL_BUY_CAPTRUE             = 35120,       [35120] = "REQ_MOIL_BUY_CAPTRUE", 
	-- [35130]返回消耗信息 -- 苦工 
	ACK_MOIL_BUY_OK                  = 35130,       [35130] = "ACK_MOIL_BUY_OK", 

	--------------------------------------------------------
	-- 36001 - 37000 ( 三界杀 ) 
	--------------------------------------------------------
	-- [36010]请求三界杀 -- 三界杀 
	REQ_CIRCLE_ENJOY                 = 36010,       [36010] = "REQ_CIRCLE_ENJOY", 
	-- [36011]当前章节信息(新) -- 三界杀 
	ACK_CIRCLE_2_DATA                = 36011,       [36011] = "ACK_CIRCLE_2_DATA", 
	-- [36020]当前章节信息(废除) -- 三界杀 
	ACK_CIRCLE_DATA                  = 36020,       [36020] = "ACK_CIRCLE_DATA", 
	-- [36021]当前信息块(废除) -- 三界杀 
	ACK_CIRCLE_DATA_GROUP            = 36021,       [36021] = "ACK_CIRCLE_DATA_GROUP", 
	-- [36022]当前信息块(新) -- 三界杀 
	ACK_CIRCLE_2_DATA_GROUP          = 36022,       [36022] = "ACK_CIRCLE_2_DATA_GROUP", 
	-- [36030]请求重置 -- 三界杀 
	REQ_CIRCLE_RESET                 = 36030,       [36030] = "REQ_CIRCLE_RESET", 
	-- [36040]开始挑战 -- 三界杀 
	REQ_CIRCLE_WAR_START             = 36040,       [36040] = "REQ_CIRCLE_WAR_START", 

	--------------------------------------------------------
	-- 37001 - 38000 ( 世界BOSS ) 
	--------------------------------------------------------
	-- [37010]请求世界boss数据 -- 世界BOSS 
	REQ_WORLD_BOSS_DATA              = 37010,       [37010] = "REQ_WORLD_BOSS_DATA", 
	-- [37020]返回地图数据 -- 世界BOSS 
	ACK_WORLD_BOSS_MAP_DATA          = 37020,       [37020] = "ACK_WORLD_BOSS_MAP_DATA", 
	-- [37051]是否开启鼓舞 -- 世界BOSS 
	ACK_WORLD_BOSS_VIP_RMB           = 37051,       [37051] = "ACK_WORLD_BOSS_VIP_RMB", 
	-- [37053]玩家当前血量 -- 世界BOSS 
	ACK_WORLD_BOSS_SELF_HP           = 37053,       [37053] = "ACK_WORLD_BOSS_SELF_HP", 
	-- [37060]DPS排行 -- 世界BOSS 
	ACK_WORLD_BOSS_DPS               = 37060,       [37060] = "ACK_WORLD_BOSS_DPS", 
	-- [37070]DPS排行块 -- 世界BOSS 
	ACK_WORLD_BOSS_DPS_XX            = 37070,       [37070] = "ACK_WORLD_BOSS_DPS_XX", 
	-- [37080]玩家死亡 -- 世界BOSS 
	REQ_WORLD_BOSS_WAR_DIE           = 37080,       [37080] = "REQ_WORLD_BOSS_WAR_DIE", 
	-- [37090]返回结果 -- 世界BOSS 
	ACK_WORLD_BOSS_WAR_RS            = 37090,       [37090] = "ACK_WORLD_BOSS_WAR_RS", 
	-- [37100]退出世界BOSS -- 世界BOSS 
	REQ_WORLD_BOSS_EXIT_S            = 37100,       [37100] = "REQ_WORLD_BOSS_EXIT_S", 
	-- [37110]复活 -- 世界BOSS 
	REQ_WORLD_BOSS_REVIVE            = 37110,       [37110] = "REQ_WORLD_BOSS_REVIVE", 
	-- [37120]复活成功 -- 世界BOSS 
	ACK_WORLD_BOSS_REVIVE_OK         = 37120,       [37120] = "ACK_WORLD_BOSS_REVIVE_OK", 
	-- [37130]随机加成 -- 世界BOSS 
	ACK_WORLD_BOSS_ADDITION          = 37130,       [37130] = "ACK_WORLD_BOSS_ADDITION", 
	-- [37140]加成信息 -- 世界BOSS 
	ACK_WORLD_BOSS_ADDITION_DATA     = 37140,       [37140] = "ACK_WORLD_BOSS_ADDITION_DATA", 
	-- [37150]金元购买 -- 世界BOSS 
	REQ_WORLD_BOSS_RMB_ATTR          = 37150,       [37150] = "REQ_WORLD_BOSS_RMB_ATTR", 
	-- [37160]返回消耗信息 -- 世界BOSS 
	ACK_WORLD_BOSS_RMB_USE           = 37160,       [37160] = "ACK_WORLD_BOSS_RMB_USE", 

	--------------------------------------------------------
	-- 38001 - 39000 ( 目标任务 ) 
	--------------------------------------------------------
	-- [38005]请求目标数据 -- 目标任务 
	REQ_TARGET_LIST_ASK              = 38005,       [38005] = "REQ_TARGET_LIST_ASK", 
	-- [38010]目标数据返回 -- 目标任务 
	ACK_TARGET_LIST_BACK             = 38010,       [38010] = "ACK_TARGET_LIST_BACK", 
	-- [38015]目标数据信息块 -- 目标任务 
	ACK_TARGET_MSG_GROUP             = 38015,       [38015] = "ACK_TARGET_MSG_GROUP", 
	-- [38030]领取目标奖励 -- 目标任务 
	REQ_TARGET_REWARD_REQUEST        = 38030,       [38030] = "REQ_TARGET_REWARD_REQUEST", 

	--------------------------------------------------------
	-- 39001 - 40000 ( 英雄副本 ) 
	--------------------------------------------------------
	-- [39010]请求英雄副本 -- 英雄副本 
	REQ_HERO_REQUEST                 = 39010,       [39010] = "REQ_HERO_REQUEST", 
	-- [39020]当前章节信息 -- 英雄副本 
	ACK_HERO_CHAP_DATA               = 39020,       [39020] = "ACK_HERO_CHAP_DATA", 
	-- [39030]战役数据信息块 -- 英雄副本 
	ACK_HERO_MSG_BATTLE              = 39030,       [39030] = "ACK_HERO_MSG_BATTLE", 
	-- [39050]购买英雄副本次数 -- 英雄副本 
	REQ_HERO_BUY_TIMES               = 39050,       [39050] = "REQ_HERO_BUY_TIMES", 
	-- [39060]购买次数返回 -- 英雄副本 
	ACK_HERO_BACK_TIMES              = 39060,       [39060] = "ACK_HERO_BACK_TIMES", 
	-- [39070]当前章节信息(new) -- 英雄副本 
	ACK_HERO_CHAP_DATA_NEW           = 39070,       [39070] = "ACK_HERO_CHAP_DATA_NEW", 
	-- [39080]战役数据信息块(new) -- 英雄副本 
	ACK_HERO_MSG_BATTLE_NEW          = 39080,       [39080] = "ACK_HERO_MSG_BATTLE_NEW", 

	--------------------------------------------------------
	-- 40001 - 40500 ( 签到 ) 
	--------------------------------------------------------
	-- [40010]请求登陆奖励页面 -- 签到 
	REQ_SIGN_REQUES                  = 40010,       [40010] = "REQ_SIGN_REQUES", 
	-- [40020]连续登陆的天数 -- 签到 
	ACK_SIGN_DAYS                    = 40020,       [40020] = "ACK_SIGN_DAYS", 
	-- [40030]是否领取信息块 -- 签到 
	ACK_SIGN_REWARD_INFO             = 40030,       [40030] = "ACK_SIGN_REWARD_INFO", 
	-- [40040]领取奖励 -- 签到 
	REQ_SIGN_GET_REWARDS             = 40040,       [40040] = "REQ_SIGN_GET_REWARDS", 
	-- [40050]返回领取奖励信息 -- 签到 
	ACK_SIGN_GET_REWARDS_OK          = 40050,       [40050] = "ACK_SIGN_GET_REWARDS_OK", 

	--------------------------------------------------------
	-- 40501 - 41500 ( 天宫之战 ) 
	--------------------------------------------------------
	-- [40502]天宫之战倒计时 -- 天宫之战 
	ACK_SKYWAR_TIME_DOWN             = 40502,       [40502] = "ACK_SKYWAR_TIME_DOWN", 
	-- [40505]天宫之战暂缓时间戳 -- 天宫之战 
	ACK_SKYWAR_TIME_BUFF             = 40505,       [40505] = "ACK_SKYWAR_TIME_BUFF", 
	-- [40510]查询是否可参与天宫之战 -- 天宫之战 
	REQ_SKYWAR_ASK_LIMIT             = 40510,       [40510] = "REQ_SKYWAR_ASK_LIMIT", 
	-- [40512]是否可参与天宫之战 -- 天宫之战 
	ACK_SKYWAR_LIMIT_BACK            = 40512,       [40512] = "ACK_SKYWAR_LIMIT_BACK", 
	-- [40520]请求进入(或退出)天空之战场景 -- 天宫之战 
	REQ_SKYWAR_ENTER                 = 40520,       [40520] = "REQ_SKYWAR_ENTER", 
	-- [40530]请求查看攻守列表(上阵) -- 天宫之战 
	REQ_SKYWAR_ASK_LIST              = 40530,       [40530] = "REQ_SKYWAR_ASK_LIST", 
	-- [40531]攻守列表 -- 天宫之战 
	ACK_SKYWAR_LIST_DATA             = 40531,       [40531] = "ACK_SKYWAR_LIST_DATA", 
	-- [40532]攻守列表玩家数据 -- 天宫之战 
	ACK_SKYWAR_LIST_BACK             = 40532,       [40532] = "ACK_SKYWAR_LIST_BACK", 
	-- [40536]请求战斗 -- 天宫之战 
	REQ_SKYWAR_FIGHT                 = 40536,       [40536] = "REQ_SKYWAR_FIGHT", 
	-- [40538]玩家死亡状态 -- 天宫之战 
	ACK_SKYWAR_ROLE_STATE            = 40538,       [40538] = "ACK_SKYWAR_ROLE_STATE", 
	-- [40539]玩家惩罚时间状态 -- 天宫之战 
	ACK_SKYWAR_STATE_PUNISH          = 40539,       [40539] = "ACK_SKYWAR_STATE_PUNISH", 
	-- [40540]复活 -- 天宫之战 
	REQ_SKYWAR_REVIVE                = 40540,       [40540] = "REQ_SKYWAR_REVIVE", 
	-- [40541]守城大将气血数据(广播) -- 天宫之战 
	ACK_SKYWAR_BOSS_HP               = 40541,       [40541] = "ACK_SKYWAR_BOSS_HP", 
	-- [40550]请求天宫之战积分数据 -- 天宫之战 
	REQ_SKYWAR_ASK_SCORE             = 40550,       [40550] = "REQ_SKYWAR_ASK_SCORE", 
	-- [40552]天宫之战积分数据返回 -- 天宫之战 
	ACK_SKYWAR_SCORE_BACK            = 40552,       [40552] = "ACK_SKYWAR_SCORE_BACK", 
	-- [40560]帮派积分数据 -- 天宫之战 
	ACK_SKYWAR_SCORE_CLAN            = 40560,       [40560] = "ACK_SKYWAR_SCORE_CLAN", 
	-- [40562]个人积分数据 -- 天宫之战 
	ACK_SKYWAR_SCORE_ROLE            = 40562,       [40562] = "ACK_SKYWAR_SCORE_ROLE", 
	-- [40570]击杀boss广播 -- 天宫之战 
	ACK_SKYWAR_KILL_BOSS_BROAD       = 40570,       [40570] = "ACK_SKYWAR_KILL_BOSS_BROAD", 

	--------------------------------------------------------
	-- 41501 - 42500 ( 年兽 ) 
	--------------------------------------------------------
	-- [41510]创建年兽 -- 年兽 
	REQ_NIANSHOU_CREAT_NIANSHOU      = 41510,       [41510] = "REQ_NIANSHOU_CREAT_NIANSHOU", 
	-- [41520]创建成功 -- 年兽 
	ACK_NIANSHOU_CREAT_OK            = 41520,       [41520] = "ACK_NIANSHOU_CREAT_OK", 
	-- [41530]挑战开始 -- 年兽 
	REQ_NIANSHOU_WAR                 = 41530,       [41530] = "REQ_NIANSHOU_WAR", 

	--------------------------------------------------------
	-- 42501 - 43500 ( 收集卡片 ) 
	--------------------------------------------------------
	-- [42510]查询是否有卡片活动 -- 收集卡片 
	REQ_COLLECT_CARD_ASK_LIMIT       = 42510,       [42510] = "REQ_COLLECT_CARD_ASK_LIMIT", 
	-- [42511]卡片活动状态有变化 -- 收集卡片 
	ACK_COLLECT_CARD_STATE_REFRESH   = 42511,       [42511] = "ACK_COLLECT_CARD_STATE_REFRESH", 
	-- [42512]卡片活动开放结果 -- 收集卡片 
	ACK_COLLECT_CARD_LIMIT_RESULT    = 42512,       [42512] = "ACK_COLLECT_CARD_LIMIT_RESULT", 
	-- [42520]请求卡片套装和奖励数据 -- 收集卡片 
	REQ_COLLECT_CARD_ASK_DATA        = 42520,       [42520] = "REQ_COLLECT_CARD_ASK_DATA", 
	-- [42522]卡片套装和奖励数据返回 -- 收集卡片 
	ACK_COLLECT_CARD_DATA_BACK       = 42522,       [42522] = "ACK_COLLECT_CARD_DATA_BACK", 
	-- [42524]套装数据信息块 -- 收集卡片 
	ACK_COLLECT_CARD_XXX1            = 42524,       [42524] = "ACK_COLLECT_CARD_XXX1", 
	-- [42526]物品信息块 -- 收集卡片 
	ACK_COLLECT_CARD_XXX2            = 42526,       [42526] = "ACK_COLLECT_CARD_XXX2", 
	-- [42528]虚拟货币信息块 -- 收集卡片 
	ACK_COLLECT_CARD_XXX3            = 42528,       [42528] = "ACK_COLLECT_CARD_XXX3", 
	-- [42530]请求兑换卡片套装奖励 -- 收集卡片 
	REQ_COLLECT_CARD_EXCHANGE        = 42530,       [42530] = "REQ_COLLECT_CARD_EXCHANGE", 
	-- [42532]兑换成功 -- 收集卡片 
	ACK_COLLECT_CARD_EXCHANGE_OK     = 42532,       [42532] = "ACK_COLLECT_CARD_EXCHANGE_OK", 
	-- [42540]请求兑换所需金元 -- 收集卡片 
	REQ_COLLECT_CARD_EXCHANGE_COST   = 42540,       [42540] = "REQ_COLLECT_CARD_EXCHANGE_COST", 
	-- [42542]兑换所需金元 -- 收集卡片 
	ACK_COLLECT_CARD_COST_BACK       = 42542,       [42542] = "ACK_COLLECT_CARD_COST_BACK", 

	--------------------------------------------------------
	-- 43501 - 44500 ( 跨服战 ) 
	--------------------------------------------------------
	-- [43510]请求跨服战 -- 跨服战 
	REQ_STRIDE_ENJOY                 = 43510,       [43510] = "REQ_STRIDE_ENJOY", 
	-- [43511]请求巅峰之战 -- 跨服战 
	REQ_STRIDE_SUPERIOR              = 43511,       [43511] = "REQ_STRIDE_SUPERIOR", 
	-- [43520]返回报名状态 -- 跨服战 
	ACK_STRIDE_STATA                 = 43520,       [43520] = "ACK_STRIDE_STATA", 
	-- [43530]报名 -- 跨服战 
	REQ_STRIDE_REPORT                = 43530,       [43530] = "REQ_STRIDE_REPORT", 
	-- [43535]报名成功 -- 跨服战 
	ACK_STRIDE_REPROT_OK             = 43535,       [43535] = "ACK_STRIDE_REPROT_OK", 
	-- [43540]请求排行榜 -- 跨服战 
	REQ_STRIDE_RANK                  = 43540,       [43540] = "REQ_STRIDE_RANK", 
	-- [43550]三界争霸/巅峰之战排行榜 -- 跨服战 
	ACK_STRIDE_RANK_DATA             = 43550,       [43550] = "ACK_STRIDE_RANK_DATA", 
	-- [43551]三界争霸/巅峰之战排行榜数据块 -- 跨服战 
	ACK_STRIDE_RANK_2_DATA           = 43551,       [43551] = "ACK_STRIDE_RANK_2_DATA", 
	-- [43552]伙伴块 -- 跨服战 
	ACK_STRIDE_XXX_PATNER            = 43552,       [43552] = "ACK_STRIDE_XXX_PATNER", 
	-- [43555]战报日志 -- 跨服战 
	ACK_STRIDE_WAR_LOGS              = 43555,       [43555] = "ACK_STRIDE_WAR_LOGS", 
	-- [43556]战报日志信息块 -- 跨服战 
	ACK_STRIDE_WAR_2_LOGS            = 43556,       [43556] = "ACK_STRIDE_WAR_2_LOGS", 
	-- [43560]许愿 -- 跨服战 
	REQ_STRIDE_WISH                  = 43560,       [43560] = "REQ_STRIDE_WISH", 
	-- [43570]返回许愿日志 -- 跨服战 
	ACK_STRIDE_WISH_DATE             = 43570,       [43570] = "ACK_STRIDE_WISH_DATE", 
	-- [43571]返回许愿日志块 -- 跨服战 
	ACK_STRIDE_WISH_2_DATE           = 43571,       [43571] = "ACK_STRIDE_WISH_2_DATE", 
	-- [43580]玩家许愿类型 -- 跨服战 
	REQ_STRIDE_WISH_TYPE             = 43580,       [43580] = "REQ_STRIDE_WISH_TYPE", 
	-- [43590]请求招募伙伴界面 -- 跨服战 
	REQ_STRIDE_PARTNER               = 43590,       [43590] = "REQ_STRIDE_PARTNER", 
	-- [43600]返回橙色精魄数量 -- 跨服战 
	ACK_STRIDE_SOUL_COUNT            = 43600,       [43600] = "ACK_STRIDE_SOUL_COUNT", 
	-- [43610]已招募的橙色伙伴 -- 跨服战 
	ACK_STRIDE_PARTNER_OK            = 43610,       [43610] = "ACK_STRIDE_PARTNER_OK", 
	-- [43630]挑战 -- 跨服战 
	REQ_STRIDE_STRIDE_WAR            = 43630,       [43630] = "REQ_STRIDE_STRIDE_WAR", 
	-- [43631]巅峰之战 -- 跨服战 
	REQ_STRIDE_SUPERIOR_WAR          = 43631,       [43631] = "REQ_STRIDE_SUPERIOR_WAR", 
	-- [43640]挑战结果 -- 跨服战 
	ACK_STRIDE_STRIDE_WAR_RS         = 43640,       [43640] = "ACK_STRIDE_STRIDE_WAR_RS", 
	-- [43650]购买越级挑战 -- 跨服战 
	REQ_STRIDE_STRIDE_UP             = 43650,       [43650] = "REQ_STRIDE_STRIDE_UP", 
	-- [43660]购买挑战次数 -- 跨服战 
	REQ_STRIDE_BUY_COUNT             = 43660,       [43660] = "REQ_STRIDE_BUY_COUNT", 
	-- [43670]购买成功 -- 跨服战 
	ACK_STRIDE_BUY_OK                = 43670,       [43670] = "ACK_STRIDE_BUY_OK", 

	--------------------------------------------------------
	-- 44501 - 44600 ( 御前科举 ) 
	--------------------------------------------------------
	-- [44510]请求答题面板 -- 御前科举 
	REQ_KEJU_ASK_KEJU                = 44510,       [44510] = "REQ_KEJU_ASK_KEJU", 
	-- [44520]请求面板成功 -- 御前科举 
	ACK_KEJU_OK_KEJU                 = 44520,       [44520] = "ACK_KEJU_OK_KEJU", 
	-- [44530]开始答题 -- 御前科举 
	REQ_KEJU_DATI_KEJU               = 44530,       [44530] = "REQ_KEJU_DATI_KEJU", 
	-- [44540]每日答题结果 -- 御前科举 
	ACK_KEJU_JIEGUO_KEJU             = 44540,       [44540] = "ACK_KEJU_JIEGUO_KEJU", 
	-- [44550]御前科举答题结果 -- 御前科举 
	ACK_KEJU_JIEGUO_YUQIAN           = 44550,       [44550] = "ACK_KEJU_JIEGUO_YUQIAN", 
	-- [44555]前十名排行榜 -- 御前科举 
	ACK_KEJU_RANK_MSG_GROUP          = 44555,       [44555] = "ACK_KEJU_RANK_MSG_GROUP", 

	--------------------------------------------------------
	-- 44601 - 45600 ( 阎王殿 ) 
	--------------------------------------------------------
	-- [44610]请求阎王列表 -- 阎王殿 
	REQ_KINGHELL_ASK_KINGS           = 44610,       [44610] = "REQ_KINGHELL_ASK_KINGS", 
	-- [44620]阎王列表返回 -- 阎王殿 
	ACK_KINGHELL_BACK_KINGS          = 44620,       [44620] = "ACK_KINGHELL_BACK_KINGS", 
	-- [44630]阎王列表信息块 -- 阎王殿 
	ACK_KINGHELL_MSG_BACK_KING       = 44630,       [44630] = "ACK_KINGHELL_MSG_BACK_KING", 
	-- [44640]怪物信息块 -- 阎王殿 
	ACK_KINGHELL_MSG_MONS            = 44640,       [44640] = "ACK_KINGHELL_MSG_MONS", 
	-- [44650]请求挑战伙伴 -- 阎王殿 
	REQ_KINGHELL_ASK_PARTNER         = 44650,       [44650] = "REQ_KINGHELL_ASK_PARTNER", 
	-- [44655]挑战伙伴返回 -- 阎王殿 
	ACK_KINGHELL_BACK_PARTNER        = 44655,       [44655] = "ACK_KINGHELL_BACK_PARTNER", 
	-- [44660]挑战伙伴信息块 -- 阎王殿 
	ACK_KINGHELL_MSG_PARTNER         = 44660,       [44660] = "ACK_KINGHELL_MSG_PARTNER", 
	-- [44670]请求伙伴心经列表 -- 阎王殿 
	REQ_KINGHELL_ASK_XJ              = 44670,       [44670] = "REQ_KINGHELL_ASK_XJ", 
	-- [44675]心经返回 -- 阎王殿 
	ACK_KINGHELL_BACK_XJ             = 44675,       [44675] = "ACK_KINGHELL_BACK_XJ", 
	-- [44680]伙伴心经信息块 -- 阎王殿 
	ACK_KINGHELL_MSG_XJ              = 44680,       [44680] = "ACK_KINGHELL_MSG_XJ", 
	-- [44685]心经信息块 -- 阎王殿 
	ACK_KINGHELL_MSG_P_XJ            = 44685,       [44685] = "ACK_KINGHELL_MSG_P_XJ", 
	-- [44690]点亮心经境界 -- 阎王殿 
	REQ_KINGHELL_XJ_START            = 44690,       [44690] = "REQ_KINGHELL_XJ_START", 
	-- [44695]点亮心经成功 -- 阎王殿 
	ACK_KINGHELL_XJ_UPDATE           = 44695,       [44695] = "ACK_KINGHELL_XJ_UPDATE", 
	-- [44700]请求心经交换 -- 阎王殿 
	REQ_KINGHELL_XJ_SWITCH           = 44700,       [44700] = "REQ_KINGHELL_XJ_SWITCH", 
	-- [44705]心经互换成功 -- 阎王殿 
	ACK_KINGHELL_XJ_SWITCH_OK        = 44705,       [44705] = "ACK_KINGHELL_XJ_SWITCH_OK", 
	-- [44720]请求阎王元神 -- 阎王殿 
	REQ_KINGHELL_ASK_YUANS           = 44720,       [44720] = "REQ_KINGHELL_ASK_YUANS", 
	-- [44730]阎王元神返回 -- 阎王殿 
	ACK_KINGHELL_BACK_YUANS          = 44730,       [44730] = "ACK_KINGHELL_BACK_YUANS", 
	-- [44735]元神信息块 -- 阎王殿 
	ACK_KINGHELL_MSG_YUANS           = 44735,       [44735] = "ACK_KINGHELL_MSG_YUANS", 
	-- [44740]请求首次和最佳记录 -- 阎王殿 
	REQ_KINGHELL_ASK_FIRBEST         = 44740,       [44740] = "REQ_KINGHELL_ASK_FIRBEST", 
	-- [44745]首次和最佳记录返回 -- 阎王殿 
	ACK_KINGHELL_BACK_FIRBEST        = 44745,       [44745] = "ACK_KINGHELL_BACK_FIRBEST", 
	-- [44800]请求挑战 -- 阎王殿 
	REQ_KINGHELL_WAR                 = 44800,       [44800] = "REQ_KINGHELL_WAR", 

	--------------------------------------------------------
	-- 45601 - 46000 ( 活动-阵营战 ) 
	--------------------------------------------------------
	-- [45610]请求阵营战界面 -- 活动-阵营战 
	REQ_CAMPWAR_ASK_WAR              = 45610,       [45610] = "REQ_CAMPWAR_ASK_WAR", 
	-- [45620]界面请求返回 -- 活动-阵营战 
	ACK_CAMPWAR_OK_ASK_WAR           = 45620,       [45620] = "ACK_CAMPWAR_OK_ASK_WAR", 
	-- [45630]各种倒计时 -- 活动-阵营战 
	ACK_CAMPWAR_D_TIME               = 45630,       [45630] = "ACK_CAMPWAR_D_TIME", 
	-- [45640]阵营积分数据 -- 活动-阵营战 
	ACK_CAMPWAR_CAMP_POINTS          = 45640,       [45640] = "ACK_CAMPWAR_CAMP_POINTS", 
	-- [45650]连胜榜数据 -- 活动-阵营战 
	ACK_CAMPWAR_WINNING_STREAK       = 45650,       [45650] = "ACK_CAMPWAR_WINNING_STREAK", 
	-- [45655]连胜玩家信息块 -- 活动-阵营战 
	ACK_CAMPWAR_PLY_DATA             = 45655,       [45655] = "ACK_CAMPWAR_PLY_DATA", 
	-- [45670]个人战绩 -- 活动-阵营战 
	ACK_CAMPWAR_SELF_WAR             = 45670,       [45670] = "ACK_CAMPWAR_SELF_WAR", 
	-- [45680]请求振奋 -- 活动-阵营战 
	REQ_CAMPWAR_ASK_BESTIR           = 45680,       [45680] = "REQ_CAMPWAR_ASK_BESTIR", 
	-- [45690]请求振奋成功 -- 活动-阵营战 
	ACK_CAMPWAR_OK_BESTIR            = 45690,       [45690] = "ACK_CAMPWAR_OK_BESTIR", 
	-- [45695]属性加成信息块 -- 活动-阵营战 
	ACK_CAMPWAR_ATTR_MSG             = 45695,       [45695] = "ACK_CAMPWAR_ATTR_MSG", 
	-- [45720]开始匹配战斗 -- 活动-阵营战 
	REQ_CAMPWAR_START_MACHING        = 45720,       [45720] = "REQ_CAMPWAR_START_MACHING", 
	-- [45750]战斗结束 -- 活动-阵营战 
	REQ_CAMPWAR_END_WAR              = 45750,       [45750] = "REQ_CAMPWAR_END_WAR", 
	-- [45755]战报数据 -- 活动-阵营战 
	ACK_CAMPWAR_WAR_DATA             = 45755,       [45755] = "ACK_CAMPWAR_WAR_DATA", 
	-- [45757]奖励数据块 -- 活动-阵营战 
	ACK_CAMPWAR_REWARDS_DATA         = 45757,       [45757] = "ACK_CAMPWAR_REWARDS_DATA", 
	-- [45790]请求退出活动 -- 活动-阵营战 
	REQ_CAMPWAR_ASK_BACK             = 45790,       [45790] = "REQ_CAMPWAR_ASK_BACK", 
	-- [45800]请求设置战报数据类型 -- 活动-阵营战 
	REQ_CAMPWAR_ASK_WAR_DATA         = 45800,       [45800] = "REQ_CAMPWAR_ASK_WAR_DATA", 
	-- [45810]战报数据返回 -- 活动-阵营战 
	ACK_CAMPWAR_OK_WARDATA           = 45810,       [45810] = "ACK_CAMPWAR_OK_WARDATA", 
	-- [45850]活动结束 -- 活动-阵营战 
	ACK_CAMPWAR_CAMP_END             = 45850,       [45850] = "ACK_CAMPWAR_CAMP_END", 

	--------------------------------------------------------
	-- 46001 - 46200 ( 幸运大转盘 ) 
	--------------------------------------------------------
	-- [46010]奖励物品数据块 -- 幸运大转盘 
	ACK_WHEEL_XXX1                   = 46010,       [46010] = "ACK_WHEEL_XXX1", 
	-- [46020]请求转盘数据 -- 幸运大转盘 
	REQ_WHEEL_REQUEST                = 46020,       [46020] = "REQ_WHEEL_REQUEST", 
	-- [46022]转盘数据返回 -- 幸运大转盘 
	ACK_WHEEL_DATA_BACK              = 46022,       [46022] = "ACK_WHEEL_DATA_BACK", 
	-- [46030]请求玩转盘 -- 幸运大转盘 
	REQ_WHEEL_DO                     = 46030,       [46030] = "REQ_WHEEL_DO", 
	-- [46032]转盘索引 -- 幸运大转盘 
	ACK_WHEEL_IDX                    = 46032,       [46032] = "ACK_WHEEL_IDX", 
	-- [46040]转盘动画结束 -- 幸运大转盘 
	REQ_WHEEL_PLAY_END               = 46040,       [46040] = "REQ_WHEEL_PLAY_END", 
	-- [46050]转盘日志返回 -- 幸运大转盘 
	ACK_WHEEL_LOG                    = 46050,       [46050] = "ACK_WHEEL_LOG", 

	--------------------------------------------------------
	-- 46201 - 47200 ( 魔王副本 ) 
	--------------------------------------------------------
	-- [46210]请求魔王副本 -- 魔王副本 
	REQ_FIEND_REQUEST                = 46210,       [46210] = "REQ_FIEND_REQUEST", 
	-- [46220]当前章节信息 -- 魔王副本 
	ACK_FIEND_CHAP_DATA              = 46220,       [46220] = "ACK_FIEND_CHAP_DATA", 
	-- [46230]战役数据信息块 -- 魔王副本 
	ACK_FIEND_MSG_BATTLE             = 46230,       [46230] = "ACK_FIEND_MSG_BATTLE", 
	-- [46250]刷新魔王副本 -- 魔王副本 
	REQ_FIEND_FRESH_COPY             = 46250,       [46250] = "REQ_FIEND_FRESH_COPY", 
	-- [46260]刷新魔王副本返回 -- 魔王副本 
	ACK_FIEND_FRESH_BACK             = 46260,       [46260] = "ACK_FIEND_FRESH_BACK", 
	-- [46270]当前章节信息(new) -- 魔王副本 
	ACK_FIEND_CHAP_DATA_NEW          = 46270,       [46270] = "ACK_FIEND_CHAP_DATA_NEW", 
	-- [46280]战役数据信息块(new) -- 魔王副本 
	ACK_FIEND_MSG_BATTLE_NEW         = 46280,       [46280] = "ACK_FIEND_MSG_BATTLE_NEW", 

	--------------------------------------------------------
	-- 47201 - 48200 ( 珍宝阁系统 ) 
	--------------------------------------------------------
	-- [47201]请求层次id -- 珍宝阁系统 
	REQ_TREASURE_LEVEL_ID            = 47201,       [47201] = "REQ_TREASURE_LEVEL_ID", 
	-- [47210]处理藏宝阁面板请求 -- 珍宝阁系统 
	ACK_TREASURE_REQUEST_INFO        = 47210,       [47210] = "ACK_TREASURE_REQUEST_INFO", 
	-- [47215]物品信息块 -- 珍宝阁系统 
	ACK_TREASURE_GOODSMSG            = 47215,       [47215] = "ACK_TREASURE_GOODSMSG", 
	-- [47220]物品打造数据请求 -- 珍宝阁系统 
	REQ_TREASURE_GOODS_ID            = 47220,       [47220] = "REQ_TREASURE_GOODS_ID", 
	-- [47230]触发属性加成 -- 珍宝阁系统 
	ACK_TREASURE_ATTRIBUTE           = 47230,       [47230] = "ACK_TREASURE_ATTRIBUTE", 
	-- [47260]请求商店面板 -- 珍宝阁系统 
	REQ_TREASURE_SHOP_REQUEST        = 47260,       [47260] = "REQ_TREASURE_SHOP_REQUEST", 
	-- [47270]金元刷新面板 -- 珍宝阁系统 
	REQ_TREASURE_MONEY_REFRESH       = 47270,       [47270] = "REQ_TREASURE_MONEY_REFRESH", 
	-- [47275]定时刷新 -- 珍宝阁系统 
	REQ_TREASURE_INTERVAL_REFRESH    = 47275,       [47275] = "REQ_TREASURE_INTERVAL_REFRESH", 
	-- [47280]返回商店面板数据 -- 珍宝阁系统 
	ACK_TREASURE_SHOP_INFO           = 47280,       [47280] = "ACK_TREASURE_SHOP_INFO", 
	-- [47285]返回商店面板数据（new） -- 珍宝阁系统 
	ACK_TREASURE_SHOP_INFO_NEW       = 47285,       [47285] = "ACK_TREASURE_SHOP_INFO_NEW", 
	-- [47290]请求购买 -- 珍宝阁系统 
	REQ_TREASURE_PURCHASE            = 47290,       [47290] = "REQ_TREASURE_PURCHASE", 
	-- [47300]购买成功与否 -- 珍宝阁系统 
	ACK_TREASURE_PURCHASE_STATE      = 47300,       [47300] = "ACK_TREASURE_PURCHASE_STATE", 
	-- [47310]请求副本时候开启 -- 珍宝阁系统 
	REQ_TREASURE_IS_COPY             = 47310,       [47310] = "REQ_TREASURE_IS_COPY", 
	-- [47320]副本开启状态 -- 珍宝阁系统 
	ACK_TREASURE_COPY_STATE          = 47320,       [47320] = "ACK_TREASURE_COPY_STATE", 

	--------------------------------------------------------
	-- 48201 - 49200 ( 斗气系统 ) 
	--------------------------------------------------------
	-- [48201]仓库数据 -- 斗气系统 
	ACK_SYS_DOUQI_STORAGE_DATA       = 48201,       [48201] = "ACK_SYS_DOUQI_STORAGE_DATA", 
	-- [48203]斗气信息块 -- 斗气系统 
	ACK_SYS_DOUQI_DOUQI_DATA         = 48203,       [48203] = "ACK_SYS_DOUQI_DOUQI_DATA", 
	-- [48210]请求领悟界面 -- 斗气系统 
	REQ_SYS_DOUQI_ASK_GRASP_DOUQI    = 48210,       [48210] = "REQ_SYS_DOUQI_ASK_GRASP_DOUQI", 
	-- [48211]请求开始领悟 -- 斗气系统 
	REQ_SYS_DOUQI_ASK_START_GRASP    = 48211,       [48211] = "REQ_SYS_DOUQI_ASK_START_GRASP", 
	-- [48220]领悟界面信息返回 -- 斗气系统 
	ACK_SYS_DOUQI_OK_GRASP_DATA      = 48220,       [48220] = "ACK_SYS_DOUQI_OK_GRASP_DATA", 
	-- [48223]一键领悟数据返回 -- 斗气系统 
	ACK_SYS_DOUQI_MORE_GRASP         = 48223,       [48223] = "ACK_SYS_DOUQI_MORE_GRASP", 
	-- [48225]一键领悟数据 -- 斗气系统 
	ACK_SYS_DOUQI_MSG_MORE           = 48225,       [48225] = "ACK_SYS_DOUQI_MSG_MORE", 
	-- [48230]请求装备斗气界面 -- 斗气系统 
	REQ_SYS_DOUQI_ASK_USR_GRASP      = 48230,       [48230] = "REQ_SYS_DOUQI_ASK_USR_GRASP", 
	-- [48240]装备界面信息返回 -- 斗气系统 
	ACK_SYS_DOUQI_OK_DOUQI_ROLE      = 48240,       [48240] = "ACK_SYS_DOUQI_OK_DOUQI_ROLE", 
	-- [48245]伙伴数据信息块 -- 斗气系统 
	ACK_SYS_DOUQI_ROLE_DATA          = 48245,       [48245] = "ACK_SYS_DOUQI_ROLE_DATA", 
	-- [48280]请求一键吞噬 -- 斗气系统 
	REQ_SYS_DOUQI_ASK_EAT            = 48280,       [48280] = "REQ_SYS_DOUQI_ASK_EAT", 
	-- [48285]吞噬结果 -- 斗气系统 
	ACK_SYS_DOUQI_EAT_STATE          = 48285,       [48285] = "ACK_SYS_DOUQI_EAT_STATE", 
	-- [48290]吞噬结果信息块 -- 斗气系统 
	ACK_SYS_DOUQI_EAT_DATA           = 48290,       [48290] = "ACK_SYS_DOUQI_EAT_DATA", 
	-- [48295]被吞者位置ID列表 -- 斗气系统 
	ACK_SYS_DOUQI_LAN_MSG            = 48295,       [48295] = "ACK_SYS_DOUQI_LAN_MSG", 
	-- [48300]请求拾取斗气 -- 斗气系统 
	REQ_SYS_DOUQI_ASK_GET_DQ         = 48300,       [48300] = "REQ_SYS_DOUQI_ASK_GET_DQ", 
	-- [48310]拾取成功 -- 斗气系统 
	ACK_SYS_DOUQI_OK_GET_DQ          = 48310,       [48310] = "ACK_SYS_DOUQI_OK_GET_DQ", 
	-- [48320]请求分解斗气 -- 斗气系统 
	REQ_SYS_DOUQI_DQ_SPLIT           = 48320,       [48320] = "REQ_SYS_DOUQI_DQ_SPLIT", 
	-- [48330]分解斗气成功 -- 斗气系统 
	ACK_SYS_DOUQI_OK_DQ_SPLIT        = 48330,       [48330] = "ACK_SYS_DOUQI_OK_DQ_SPLIT", 
	-- [48380]请求移动斗气位置 -- 斗气系统 
	REQ_SYS_DOUQI_ASK_USE_DOUQI      = 48380,       [48380] = "REQ_SYS_DOUQI_ASK_USE_DOUQI", 
	-- [48390]移动斗气成功 -- 斗气系统 
	ACK_SYS_DOUQI_OK_USE_DOUQI       = 48390,       [48390] = "ACK_SYS_DOUQI_OK_USE_DOUQI", 
	-- [48400]请求整理仓库 [48201] Type=1 -- 斗气系统 
	REQ_SYS_DOUQI_ASK_CLEAR_STORAG   = 48400,       [48400] = "REQ_SYS_DOUQI_ASK_CLEAR_STORAG", 

	--------------------------------------------------------
	-- 49201 - 50200 ( 日常任务系统 ) 
	--------------------------------------------------------
	-- [49201]日常任务数据返回 -- 日常任务系统 
	ACK_DAILY_TASK_DATA              = 49201,       [49201] = "ACK_DAILY_TASK_DATA", 
	-- [49202]请求任务数据 -- 日常任务系统 
	REQ_DAILY_TASK_REQUEST           = 49202,       [49202] = "REQ_DAILY_TASK_REQUEST", 
	-- [49203]请求放弃任务 -- 日常任务系统 
	REQ_DAILY_TASK_DROP              = 49203,       [49203] = "REQ_DAILY_TASK_DROP", 
	-- [49204]领取奖励协议 -- 日常任务系统 
	REQ_DAILY_TASK_REWARD            = 49204,       [49204] = "REQ_DAILY_TASK_REWARD", 
	-- [49205]vip刷新次数 -- 日常任务系统 
	REQ_DAILY_TASK_VIP_REFRESH       = 49205,       [49205] = "REQ_DAILY_TASK_VIP_REFRESH", 
	-- [49206]日常任务当前轮次 -- 日常任务系统 
	ACK_DAILY_TASK_TURN              = 49206,       [49206] = "ACK_DAILY_TASK_TURN", 
	-- [49207]一键完成日常任务 -- 日常任务系统 
	REQ_DAILY_TASK_KEY               = 49207,       [49207] = "REQ_DAILY_TASK_KEY", 

	--------------------------------------------------------
	-- 50201 - 51200 ( 风林山火 ) 
	--------------------------------------------------------
	-- [50210]请求剩余次数 -- 风林山火 
	REQ_FLSH_TIMES_REQUEST           = 50210,       [50210] = "REQ_FLSH_TIMES_REQUEST", 
	-- [50220]剩余次数返回 -- 风林山火 
	ACK_FLSH_TIMES_REPLY             = 50220,       [50220] = "ACK_FLSH_TIMES_REPLY", 
	-- [50230]开始游戏 -- 风林山火 
	REQ_FLSH_GAME_START              = 50230,       [50230] = "REQ_FLSH_GAME_START", 
	-- [50240]牌语返回 -- 风林山火 
	ACK_FLSH_PAI_REPLY               = 50240,       [50240] = "ACK_FLSH_PAI_REPLY", 
	-- [50250]牌语信息块 -- 风林山火 
	ACK_FLSH_PAI_DATA                = 50250,       [50250] = "ACK_FLSH_PAI_DATA", 
	-- [50260]换牌 -- 风林山火 
	REQ_FLSH_PAI_SWITCH              = 50260,       [50260] = "REQ_FLSH_PAI_SWITCH", 
	-- [50270]换牌信息块 -- 风林山火 
	REQ_FLSH_SWITCH_DATA             = 50270,       [50270] = "REQ_FLSH_SWITCH_DATA", 
	-- [50280]领取奖励 -- 风林山火 
	REQ_FLSH_GET_REWARD              = 50280,       [50280] = "REQ_FLSH_GET_REWARD", 
	-- [50290]领取奖励成功 -- 风林山火 
	ACK_FLSH_REWARD_OK               = 50290,       [50290] = "ACK_FLSH_REWARD_OK", 

	--------------------------------------------------------
	-- 51201 - 52200 ( 每日一箭 ) 
	--------------------------------------------------------
	-- [51210]请求每日一箭面板 -- 每日一箭 
	REQ_SHOOT_REQUEST                = 51210,       [51210] = "REQ_SHOOT_REQUEST", 
	-- [51220]每日一箭返回 -- 每日一箭 
	ACK_SHOOT_REPLY                  = 51220,       [51220] = "ACK_SHOOT_REPLY", 
	-- [51230]头像信息块 -- 每日一箭 
	ACK_SHOOT_HEAD_INFO              = 51230,       [51230] = "ACK_SHOOT_HEAD_INFO", 
	-- [51240]获取其他玩家获奖信息块 -- 每日一箭 
	ACK_SHOOT_AWARD_INFO             = 51240,       [51240] = "ACK_SHOOT_AWARD_INFO", 
	-- [51250]请求射箭 -- 每日一箭 
	REQ_SHOOT_SHOOTED                = 51250,       [51250] = "REQ_SHOOT_SHOOTED", 

	--------------------------------------------------------
	-- 52201 - 53200 ( 神器 ) 
	--------------------------------------------------------
	-- [52210]请求神器面板 -- 神器 
	REQ_MAGIC_EQUIP_REQUEST          = 52210,       [52210] = "REQ_MAGIC_EQUIP_REQUEST", 
	-- [52220]神器强化 -- 神器 
	REQ_MAGIC_EQUIP_ENHANCED         = 52220,       [52220] = "REQ_MAGIC_EQUIP_ENHANCED", 
	-- [52230]神器进阶 -- 神器 
	REQ_MAGIC_EQUIP_ADVANCE          = 52230,       [52230] = "REQ_MAGIC_EQUIP_ADVANCE", 
	-- [52240]强化返回 -- 神器 
	ACK_MAGIC_EQUIP_ENHANCED_REPLY   = 52240,       [52240] = "ACK_MAGIC_EQUIP_ENHANCED_REPLY", 
	-- [52250]神器强化所需要钱数 -- 神器 
	REQ_MAGIC_EQUIP_NEED_MONEY       = 52250,       [52250] = "REQ_MAGIC_EQUIP_NEED_MONEY", 
	-- [52260]神器强化所需要钱数返回 -- 神器 
	ACK_MAGIC_EQUIP_NEED_MONEY_REPLY = 52260,       [52260] = "ACK_MAGIC_EQUIP_NEED_MONEY_REPLY", 
	-- [52300]请求下一级属性 -- 神器 
	REQ_MAGIC_EQUIP_ASK_NEXT_ATTR    = 52300,       [52300] = "REQ_MAGIC_EQUIP_ASK_NEXT_ATTR", 
	-- [52310]属性返回 -- 神器 
	ACK_MAGIC_EQUIP_ATTR_REPLY       = 52310,       [52310] = "ACK_MAGIC_EQUIP_ATTR_REPLY", 
	-- [52315]材料信息块 -- 神器 
	ACK_MAGIC_EQUIP_MSG_ITEM_XXX     = 52315,       [52315] = "ACK_MAGIC_EQUIP_MSG_ITEM_XXX", 
	-- [52320]属性值 -- 神器 
	ACK_MAGIC_EQUIP_ATTR             = 52320,       [52320] = "ACK_MAGIC_EQUIP_ATTR", 

	--------------------------------------------------------
	-- 53201 - 54200 ( 新手特权 ) 
	--------------------------------------------------------
	-- [53210]新手特权面板请求 -- 新手特权 
	REQ_PRIVILEGE_REQUEST            = 53210,       [53210] = "REQ_PRIVILEGE_REQUEST", 
	-- [53220]面板返回 -- 新手特权 
	ACK_PRIVILEGE_REPLY              = 53220,       [53220] = "ACK_PRIVILEGE_REPLY", 
	-- [53230]开通新手特权 -- 新手特权 
	REQ_PRIVILEGE_OPEN               = 53230,       [53230] = "REQ_PRIVILEGE_OPEN", 
	-- [53240]开通新手特权成功 -- 新手特权 
	ACK_PRIVILEGE_OPEN_REPLY         = 53240,       [53240] = "ACK_PRIVILEGE_OPEN_REPLY", 
	-- [53250]领取奖励 -- 新手特权 
	REQ_PRIVILEGE_GET_REWARDS        = 53250,       [53250] = "REQ_PRIVILEGE_GET_REWARDS", 

	--------------------------------------------------------
	-- 54201 - 54800 ( 社团BOSS ) 
	--------------------------------------------------------
	-- [54205]活动倒计时 -- 社团BOSS 
	ACK_CLAN_BOSS_TIME_DOWN          = 54205,       [54205] = "ACK_CLAN_BOSS_TIME_DOWN", 
	-- [54210]伤害数据 -- 社团BOSS 
	ACK_CLAN_BOSS_HARM_DATA          = 54210,       [54210] = "ACK_CLAN_BOSS_HARM_DATA", 
	-- [54220]请求开启社团BOSS -- 社团BOSS 
	REQ_CLAN_BOSS_START_BOSS         = 54220,       [54220] = "REQ_CLAN_BOSS_START_BOSS", 
	-- [54230]请求参加社团BOSS -- 社团BOSS 
	REQ_CLAN_BOSS_ASK_JOIN           = 54230,       [54230] = "REQ_CLAN_BOSS_ASK_JOIN", 
	-- [54235]界面信息返回--活动状态 -- 社团BOSS 
	ACK_CLAN_BOSS_ACTIVE_STATE       = 54235,       [54235] = "ACK_CLAN_BOSS_ACTIVE_STATE", 
	-- [54240]界面信息返回--BOSS信息 -- 社团BOSS 
	ACK_CLAN_BOSS_JOIN_DATA          = 54240,       [54240] = "ACK_CLAN_BOSS_JOIN_DATA", 
	-- [54250]界面信息返回--排行榜信息 -- 社团BOSS 
	ACK_CLAN_BOSS_RANK_DATA          = 54250,       [54250] = "ACK_CLAN_BOSS_RANK_DATA", 
	-- [54255]玩家信息块 -- 社团BOSS 
	ACK_CLAN_BOSS_ROLE_DATA          = 54255,       [54255] = "ACK_CLAN_BOSS_ROLE_DATA", 
	-- [54260]鼓舞属性加成 -- 社团BOSS 
	ACK_CLAN_BOSS_BUFF_DATA          = 54260,       [54260] = "ACK_CLAN_BOSS_BUFF_DATA", 
	-- [54265]属性加成信息块 -- 社团BOSS 
	ACK_CLAN_BOSS_BUFF_MSG           = 54265,       [54265] = "ACK_CLAN_BOSS_BUFF_MSG", 
	-- [54270]请求豉舞【54260】 -- 社团BOSS 
	REQ_CLAN_BOSS_ASK_INCITE         = 54270,       [54270] = "REQ_CLAN_BOSS_ASK_INCITE", 
	-- [54280]玩家死亡 -- 社团BOSS 
	REQ_CLAN_BOSS_DIED               = 54280,       [54280] = "REQ_CLAN_BOSS_DIED", 
	-- [54290]状态返回 -- 社团BOSS 
	ACK_CLAN_BOSS_DIED_STATE         = 54290,       [54290] = "ACK_CLAN_BOSS_DIED_STATE", 
	-- [54300]请求复活 -- 社团BOSS 
	REQ_CLAN_BOSS_ASK_RELIVE         = 54300,       [54300] = "REQ_CLAN_BOSS_ASK_RELIVE", 
	-- [54305]复活成功 -- 社团BOSS 
	ACK_CLAN_BOSS_OK_RELIVE          = 54305,       [54305] = "ACK_CLAN_BOSS_OK_RELIVE", 
	-- [54310]退出活动 -- 社团BOSS 
	REQ_CLAN_BOSS_ASK_OUT            = 54310,       [54310] = "REQ_CLAN_BOSS_ASK_OUT", 

	--------------------------------------------------------
	-- 54801 - 55800 ( 格斗之王 ) 
	--------------------------------------------------------
	-- [54801]请求活动报名 -- 格斗之王 
	REQ_WRESTLE_BOOK                 = 54801,       [54801] = "REQ_WRESTLE_BOOK", 
	-- [54802]返回竞技场数据 -- 格斗之王 
	ACK_WRESTLE_AREANK_RANK          = 54802,       [54802] = "ACK_WRESTLE_AREANK_RANK", 
	-- [54803]格斗之王报名 -- 格斗之王 
	REQ_WRESTLE_APPLY                = 54803,       [54803] = "REQ_WRESTLE_APPLY", 
	-- [54804]报名状态 -- 格斗之王 
	ACK_WRESTLE_APPLY_STATE          = 54804,       [54804] = "ACK_WRESTLE_APPLY_STATE", 
	-- [54808]各种倒计时 -- 格斗之王 
	ACK_WRESTLE_TIME                 = 54808,       [54808] = "ACK_WRESTLE_TIME", 
	-- [54810]玩家信息块 -- 格斗之王 
	ACK_WRESTLE_PLAYER               = 54810,       [54810] = "ACK_WRESTLE_PLAYER", 
	-- [54815]请求积分榜数据 -- 格斗之王 
	REQ_WRESTLE_SCORE                = 54815,       [54815] = "REQ_WRESTLE_SCORE", 
	-- [54818]积分榜返回 -- 格斗之王 
	ACK_WRESTLE_SCORE_MSG            = 54818,       [54818] = "ACK_WRESTLE_SCORE_MSG", 
	-- [54820]玩家积分返回 -- 格斗之王 
	ACK_WRESTLE_XXXXX                = 54820,       [54820] = "ACK_WRESTLE_XXXXX", 
	-- [54830]离开格斗之王面板 -- 格斗之王 
	REQ_WRESTLE_DROP                 = 54830,       [54830] = "REQ_WRESTLE_DROP", 
	-- [54850]决赛入口 -- 格斗之王 
	REQ_WRESTLE_FINAL_REQUEST        = 54850,       [54850] = "REQ_WRESTLE_FINAL_REQUEST", 
	-- [54860]决赛信息 -- 格斗之王 
	ACK_WRESTLE_FINAL_INFO           = 54860,       [54860] = "ACK_WRESTLE_FINAL_INFO", 
	-- [54870]决赛对阵信息返回 -- 格斗之王 
	ACK_WRESTLE_AGAINST              = 54870,       [54870] = "ACK_WRESTLE_AGAINST", 
	-- [54890]欢乐竞猜 -- 格斗之王 
	REQ_WRESTLE_GUESS                = 54890,       [54890] = "REQ_WRESTLE_GUESS", 
	-- [54892]断线重连 -- 格斗之王 
	REQ_WRESTLE_CONNET               = 54892,       [54892] = "REQ_WRESTLE_CONNET", 
	-- [54900]竞猜状态 -- 格斗之王 
	ACK_WRESTLE_GUESS_STATE          = 54900,       [54900] = "ACK_WRESTLE_GUESS_STATE", 
	-- [54910]王者争霸入口 -- 格斗之王 
	REQ_WRESTLE_ZHENGBA              = 54910,       [54910] = "REQ_WRESTLE_ZHENGBA", 
	-- [54920]争霸信息返回 -- 格斗之王 
	ACK_WRESTLE_ZHENGBA_REQUEST      = 54920,       [54920] = "ACK_WRESTLE_ZHENGBA_REQUEST", 
	-- [54930]竞技水晶更新 -- 格斗之王 
	ACK_WRESTLE_PEBBLE               = 54930,       [54930] = "ACK_WRESTLE_PEBBLE", 
	-- [54940]决赛信息2 -- 格斗之王 
	ACK_WRESTLE_FINAL_REP            = 54940,       [54940] = "ACK_WRESTLE_FINAL_REP", 
	-- [54945]决赛信息块 -- 格斗之王 
	ACK_WRESTLE_FINAL_REP_MSG        = 54945,       [54945] = "ACK_WRESTLE_FINAL_REP_MSG", 

	--------------------------------------------------------
	-- 55801 - 56800 ( 拳皇生涯 ) 
	--------------------------------------------------------
	-- [55810]请求拳皇信息 -- 拳皇生涯 
	REQ_FIGHTERS_REQUEST             = 55810,       [55810] = "REQ_FIGHTERS_REQUEST", 
	-- [55820]当前章节信息 -- 拳皇生涯 
	ACK_FIGHTERS_CHAP_DATA           = 55820,       [55820] = "ACK_FIGHTERS_CHAP_DATA", 
	-- [55830]战役数据信息块 -- 拳皇生涯 
	ACK_FIGHTERS_MSG_BATTLE          = 55830,       [55830] = "ACK_FIGHTERS_MSG_BATTLE", 
	-- [55840]购买挑战次数 -- 拳皇生涯 
	REQ_FIGHTERS_BUY_TIMES           = 55840,       [55840] = "REQ_FIGHTERS_BUY_TIMES", 
	-- [55850]购买挑战次数成功 -- 拳皇生涯 
	ACK_FIGHTERS_BUY_OK              = 55850,       [55850] = "ACK_FIGHTERS_BUY_OK", 
	-- [55860]开始挂机 -- 拳皇生涯 
	REQ_FIGHTERS_UP_START            = 55860,       [55860] = "REQ_FIGHTERS_UP_START", 
	-- [55870]挂机返回 -- 拳皇生涯 
	ACK_FIGHTERS_UP_REPLY            = 55870,       [55870] = "ACK_FIGHTERS_UP_REPLY", 
	-- [55875]物品信息块 -- 拳皇生涯 
	ACK_FIGHTERS_MSG_GOOD            = 55875,       [55875] = "ACK_FIGHTERS_MSG_GOOD", 
	-- [55880]挂机完成 -- 拳皇生涯 
	ACK_FIGHTERS_UP_OVER             = 55880,       [55880] = "ACK_FIGHTERS_UP_OVER", 
	-- [55890]停止挂机 -- 拳皇生涯 
	REQ_FIGHTERS_UP_STOP             = 55890,       [55890] = "REQ_FIGHTERS_UP_STOP", 
	-- [55895]停止挂机返回 -- 拳皇生涯 
	ACK_FIGHTERS_UP_STOP_REP         = 55895,       [55895] = "ACK_FIGHTERS_UP_STOP_REP", 
	-- [55960]重置挂机 -- 拳皇生涯 
	REQ_FIGHTERS_UP_RESET            = 55960,       [55960] = "REQ_FIGHTERS_UP_RESET", 
	-- [55970]重置挂机成功 -- 拳皇生涯 
	ACK_FIGHTERS_UP_RESET_OK         = 55970,       [55970] = "ACK_FIGHTERS_UP_RESET_OK", 

	--------------------------------------------------------
	-- 56801 - 57800 ( 系统设置 ) 
	--------------------------------------------------------
	-- [56810]勾选功能 -- 系统设置 
	REQ_SYS_SET_CHECK                = 56810,       [56810] = "REQ_SYS_SET_CHECK", 
	-- [56820]各功能状态 -- 系统设置 
	ACK_SYS_SET_TYPE_STATE           = 56820,       [56820] = "ACK_SYS_SET_TYPE_STATE", 
	-- [56830]状态信息块 -- 系统设置 
	ACK_SYS_SET_XXXXX                = 56830,       [56830] = "ACK_SYS_SET_XXXXX", 

	--------------------------------------------------------
	-- 57801 - 58800 ( 宝箱探秘 ) 
	--------------------------------------------------------
	-- [57801]请求面板 -- 宝箱探秘 
	REQ_DISCOVE_STORE_ASK            = 57801,       [57801] = "REQ_DISCOVE_STORE_ASK", 
	-- [57810]数据返回 -- 宝箱探秘 
	ACK_DISCOVE_STORE_DATA           = 57810,       [57810] = "ACK_DISCOVE_STORE_DATA", 
	-- [57820]请求类型 -- 宝箱探秘 
	REQ_DISCOVE_STORE_TYPE           = 57820,       [57820] = "REQ_DISCOVE_STORE_TYPE", 
	-- [57830]返回物品 -- 宝箱探秘 
	ACK_DISCOVE_STORE_GOODS          = 57830,       [57830] = "ACK_DISCOVE_STORE_GOODS", 
	--/** =============================== 自动生成的代码 =============================== **/
	--/*************************** don't touch this line *********** AUTO_CODE_END_Protocol **/
}