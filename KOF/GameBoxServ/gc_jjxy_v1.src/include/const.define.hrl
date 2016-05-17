%% 定义的常量名称不能相同，每个模块的常量值不能相同

%% ==========================================================
%% 系统
%% ==========================================================
-define(CONST_CARRY_STORE_ID,                       16).% 随身商店ID 
-define(CONST_BAD_HEART,                            30).% 心跳容错次数上限 
-define(CONST_USER_OFFLINE_ALIVE,                   60).% 玩家掉线进程存活时间(秒) 
-define(CONST_TSP_INTERVAL,                         60).% 时间同步协议频率（秒） 
-define(CONST_MESSAGE_QUEUE_LEN_MAX,                100).% 消息队列最大长度 
-define(CONST_DB_SAVE,                              300).% Player数据存蓄间隔时间（秒） 
-define(CONST_INTERVAL_HEART,                       3000).% 心跳间隔时间（毫秒）PS：300毫秒容错 
-define(CONST_OFF_DATA_TIME,                        3600).% 离线玩家数据ets保存多少时间(秒) 
-define(CONST_BAG_TEMP_EXPIRY,                      172800).% 临时背包物品有效时间(秒) 

-define(CONST_FAULT_PROTOCOL,                       10).% 协议，容错次数(次) 
-define(CONST_FAULT_TOLERANT,                       600).% 登录，容错时间(秒) 

-define(CONST_NOTICE_SHOW_TIME,                     20).% 游戏公告显示默认时长(秒) 
-define(CONST_NOTICE_SHOW_TIME_MAX,                 80).% 游戏公告显示最长时长(秒) 

-define(CONST_SP_ONLINE_VALUE,                      20).% 在线获得体力值点数 
-define(CONST_SP_ONLINE_TIMES,                      1800).% 在线获得体力值时间间隔 

-define(CONST_DEFAULT_MATE,                         0).% 默认无配偶 
-define(CONST_DEFAULT_MAP,                          0).% 默认地图id 
-define(CONST_DEFAULT_RMB_BIND,                     0).% 默认绑元 
-define(CONST_DEFAULT_DIR,                          6).% 玩家/怪物初始化(方向) 
-define(CONST_DEFAULT_GOLD,                         5000).% 默认银元 

-define(CONST_PLAYER,                               1).% 玩家 
-define(CONST_PARTNER,                              2).% 伙伴 
-define(CONST_MONSTER,                              3).% 怪物 
-define(CONST_NPC,                                  4).% NPC 
-define(CONST_PET,                                  5).% 宠物 
-define(CONST_TRANSPORT,                            6).% 传送点 
-define(CONST_VITRO,                                7).% 离体攻击 

-define(CONST_EXPIRY_PERPETUITY,                    0).% 有效期-不失效 
-define(CONST_EXPIRY_ECOND,                         1).% 有效期-秒 
-define(CONST_EXPIRY_DAY,                           2).% 有效期-天 

-define(CONST_CURRENCY_GOLD,                        1).% 货币-美刀 
-define(CONST_CURRENCY_RMB,                         2).% 货币-钻石(人民币) 
-define(CONST_CURRENCY_RMB_BIND,                    3).% 货币-钻石(绑定钻石) 
-define(CONST_CURRENCY_RENOWN,                      4).% 货币-声望 
-define(CONST_CURRENCY_ENERGY,                      5).% 货币-体力 
-define(CONST_CURRENCY_SOUL_STAR,                   6).% 货币-真气 
-define(CONST_CURRENCY_ADV_SKILL,                   7).% 货币-战功 
-define(CONST_CURRENCY_SOUL_VIGOUR_PURPLE,          8).% 货币-紫色精魄 
-define(CONST_CURRENCY_SOUL_VIGOUR_GOLD,            9).% 货币-金色精魄 
-define(CONST_CURRENCY_SOUL_VIGOUR_ORANGE,          10).% 货币-橙色精魄 
-define(CONST_CURRENCY_SOUL_VIGOUR_RED,             11).% 货币-红色精魄 
-define(CONST_CURRENCY_FIGHT_ALLOW,                 12).% 货币-战斗次数 
-define(CONST_CURRENCY_EXP,                         13).% 货币-经验 
-define(CONST_CURRENCY_DEVOTE,                      14).% 货币-个人贡献 
-define(CONST_CONST_CURRENCY_SYMBOL,                15).% 货币-神器碎片 
-define(CONST_CURRENCY_PAY_POINT,                   16).% 货币-消费积分 
-define(CONST_CURRENCY_TINENG,                      17).% 货币-体能 
-define(CONST_COMPETITIVE_PEBBLE,                   19).% 货币-竞技水晶 
-define(CONST_CURRENCY_DOUHUN,                      20).% 货币-斗魂 

-define(CONST_PRO_NULL,                             0).% 职业-所有 
-define(CONST_PRO_SUNMAN,                           1).% 职业-烈焰之拳 
-define(CONST_PRO_ZHENGTAI,                         2).% 职业-焰之旋风 
-define(CONST_PRO_ICEGIRL,                          3).% 职业-苍蓝之冰 
-define(CONST_PRO_BIGSISTER,                        4).% 职业-飞天之舞 
-define(CONST_PRO_LOLI,                             5).% 职业-梦幻之星 
-define(CONST_PRO_MONSTER,                          6).% 职业-钢铁之躯 

-define(CONST_SEX_NULL,                             0).% 性别-不限 
-define(CONST_SEX_MM,                               1).% 性别-女生 
-define(CONST_SEX_GG,                               2).% 性别-男生 

-define(CONST_COUNTRY_DEFAULT,                      0).% 阵营-无 
-define(CONST_COUNTRY_ONE,                          1).% 阵营-人 
-define(CONST_COUNTRY_FAIRY,                        2).% 阵营-仙 
-define(CONST_COUNTRY_MAGIC,                        3).% 阵营-魔 

-define(CONST_COLOR_GRAY,                           0).% 颜色-灰 
-define(CONST_COLOR_WHITE,                          1).% 颜色-白 
-define(CONST_COLOR_GREEN,                          2).% 颜色-绿 
-define(CONST_COLOR_BLUE,                           3).% 颜色-蓝 
-define(CONST_COLOR_VIOLET,                         4).% 颜色-紫 
-define(CONST_COLOR_GOLD,                           5).% 颜色-金 
-define(CONST_COLOR_ORANGE,                         6).% 颜色-橙 
-define(CONST_COLOR_RED,                            7).% 颜色-红 
-define(CONST_COLOR_CYANBLUE,                       8).% 颜色-青 
-define(CONST_COLOR_MOONLIGHT,                      9).% 颜色-月光 
-define(CONST_COLOR_AMBER,                          10).% 颜色-琥珀 

-define(CONST_SPEED_PLAYER,                         200).% 速度-角色 
-define(CONST_SPEED_MOUNT,                          260).% 速度-坐骑 
-define(CONST_SPEED_MONSTER,                        340).% 速度-怪物 

-define(CONST_PLAYER_FLAG_NORMAL,                   0).% 状态-正常(无状态) 
-define(CONST_PLAYER_FLAG_WAR,                      1).% 状态-战斗中 
-define(CONST_PLAYER_FLAG_DIE,                      2).% 状态-死亡 
-define(CONST_PLAYER_FLAG_ARENA,                    3).% 状态-封神台 
-define(CONST_PLAYER_FLAG_CLANWAR,                  4).% 状态-帮派战 
-define(CONST_PLAYER_FLAG_HOOK,                     6).% 状态-挂机 
-define(CONST_PLAYER_FLAG_TEAM_LEADER,              9).% 状态-组队(是否是队长) 
-define(CONST_PLAYER_FLAG_RED,                      10).% 状态-红名 

-define(CONST_ATTACK_DISTANCE_SHORT,                1).% 攻击类型-力量 
-define(CONST_ATTACK_DISTANCE_LONG,                 2).% 攻击类型-灵力 

-define(CONST_NAME_COLOR_BLUE,                      1).% 名字蓝色 
-define(CONST_NAME_COLOR_VIOLET,                    2).% 名字紫色 
-define(CONST_NAME_COLOR_GOLDEN,                    3).% 名字金色 

-define(CONST_RED_NAME,                             3).% 角色红色-杀戮值分界点，大于等于就红名 

-define(CONST_GRADE_1_10,                           10).% 等级1~10 
-define(CONST_GRADE_11_20,                          20).% 等级11~20 
-define(CONST_GRADE_21_30,                          30).% 等级21~30 
-define(CONST_GRADE_31_40,                          40).% 等级31~40 
-define(CONST_GRADE_41_50,                          50).% 等级41~50 
-define(CONST_GRADE_51_60,                          60).% 等级51~60 
-define(CONST_GRADE_61_70,                          70).% 等级61~70 
-define(CONST_GRADE_71_80,                          80).% 等级71~80 
-define(CONST_GRADE_81_90,                          90).% 等级81~90 
-define(CONST_GRADE_91_100,                         100).% 等级91~100 

-define(CONST_MONSTER_RANK_NORMAL,                  1).% 怪物等阶-普通 
-define(CONST_MONSTER_RANK_GOOD,                    2).% 怪物等阶-优秀 
-define(CONST_MONSTER_RANK_ELITE,                   3).% 怪物等阶-精英（显示血量） 
-define(CONST_MONSTER_RANK_ELITE_LEADER,            4).% 怪物等阶-精英BOSS（显示血量） 
-define(CONST_MONSTER_RANK_BOSS,                    5).% 怪物等阶-魔王BOSS（显示血量） 
-define(CONST_MONSTER_RANK_BOSS_SUPER,              6).% 怪物等阶-通关boss（显示血量） 
-define(CONST_OVER_BOSS,                            7).% 怪物等阶-世界boss（显示血量） 

-define(CONST_MONSTER_RACE_NORMAL,                  1).% 怪物种族-普通怪:可移动可攻击的怪物 
-define(CONST_MONSTER_RACE_COLLECT,                 5).% 怪物种族-采集怪:攻击此怪物不会进入战斗，只有采集进度条显示 

-define(CONST_MONSTER_STATE_STAND,                  1).% 怪物行为状态--站立 
-define(CONST_MONSTER_STATE_MOVE,                   2).% 怪物行为状态--移动 
-define(CONST_MONSTER_ATTACK_RADIUS,                10).% 场景普通怪攻击半径 

-define(CONST_DIRECTION_SOUTHWEST,                  1).% 方向--西南 
-define(CONST_DIRECTION_SOUTH,                      2).% 方向--南 
-define(CONST_DIRECTION_SOUTHEAST,                  3).% 方向--东南 
-define(CONST_DIRECTION_WEST,                       4).% 方向--西(右) 
-define(CONST_DIRECTION_CENTER,                     5).% 方向--中心 
-define(CONST_DIRECTION_EAST,                       6).% 方向--东(左) 
-define(CONST_DIRECTION_NORTHWEST,                  7).% 方向--西北 
-define(CONST_DIRECTION_NORTH,                      8).% 方向--北 
-define(CONST_DIRECTION_NORTHEAST,                  9).% 方向--东北 

-define(CONST_SYS_LV,                               1).% 系统开放类型-等级 
-define(CONST_SYS_TASK,                             2).% 系统开放类型-任务 

-define(CONST_FALSE,                                0).% 各种FALSE 
-define(CONST_TRUE,                                 1).% 各种TRUE 

-define(CONST_PERCENT_FAST,                         100).% 百分比,转换速算数(如:5978 除以本速算数5978/100=59.78%) Ps:主要是前端用 
-define(CONST_PERCENT,                              10000).% 百分比分母(100为1% 10000为100%)) 

-define(CONST_CLIENT_WEB,                           10).% 客户端类型-网页 
-define(CONST_CLIENT_AIR,                           20).% 客户端类型-富媒体 
-define(CONST_CLIENT_WIN,                           30).% 客户端类型-微端 
-define(CONST_CLIENT_WP,                            40).% 客户端类型-WinPhone 
-define(CONST_CLIENT_IOS,                           80).% 客户端类型-iOS 
-define(CONST_CLIENT_ANDROID,                       120).% 客户端类型-Android 

-define(CONST_TYPE_TIME_ALWAYS,                     0).% 开放时间类型-永久开放 
-define(CONST_TYPE_TIME_GREGORY,                    1).% 开放时间类型-按西元日期时间(开始结束) 
-define(CONST_TYPE_TIME_WEEK,                       2).% 开放时间类型-按周开放 
-define(CONST_TYPE_TIME_MONTH,                      3).% 开放时间类型-按月开放 

%% ==========================================================
%% 物品
%% ==========================================================
-define(CONST_GOODS_TIMES_GOODS_LOGS,               6).% 次数物品日志数量(鞭炮) 
-define(CONST_GOODS_ACTION_EQUIP,                   13).% 装备栏容量 

-define(CONST_GOODS_ID_TRUM,                        2033).% 物品ID-小喇叭 
-define(CONST_GOODS_ID_PROTECT,                     9504).% 物品ID-镇兽石 
-define(CONST_GOODS_ID_TANGYUAN,                    57001).% 物品ID-汤圆 
-define(CONST_GOODS_ID_RUZHU,                       57006).% 物品ID-乳猪 

-define(CONST_GOODS_CONTAINER_BAG,                  1).% 背包 
-define(CONST_GOODS_CONTAINER_EQUIP,                2).% 装备 
-define(CONST_GOODS_CONTAINER_DEPOT,                3).% 临时背包 
-define(CONST_GOODS_CONTAINER_CHEST_BAG,            4).% 开宝箱仓库 
-define(CONST_GOODS_CONTAINER_TEMP_BAG,             5).% 战斗临时背包 

-define(CONST_GOODS_EQUIP,                          1).% 类型-装备 
-define(CONST_GOODS_WEAPON,                         2).% 装备-武器 
-define(CONST_GOODS_STERS,                          3).% 类型-灵珠 
-define(CONST_GOODS_MATERIAL,                       4).% 类型-材料 
-define(CONST_GOODS_MAGIC,                          5).% 类型-神器 
-define(CONST_GOODS_ORD,                            6).% 类型-道具 
-define(CONST_GOODS_MOUNT,                          7).% 类型-坐骑 

-define(CONST_GOODS_EQUIP_HAT,                      11).% 装备-帽子 
-define(CONST_GOODS_EQUIP_CLOTHES,                  12).% 装备-衣服 
-define(CONST_GOODS_EQUIP_CLOAK,                    13).% 装备-披风 
-define(CONST_GOODS_EQUIP_BELT,                     14).% 装备-腰带 
-define(CONST_GOODS_EQUIP_SHOE,                     15).% 装备-鞋子 
-define(CONST_GOODS_EQUIP_WEAPON_GUN,               31).% 装备-武器-枪 
-define(CONST_GOODS_EQUIP_WEAPON_BOW,               32).% 装备-武器-弓 
-define(CONST_GOODS_EQUIP_WEAPON_STICK,             33).% 装备-武器-杖 
-define(CONST_GOODS_GOD_WINDS,                      51).% 装备-神器-翅膀 
-define(CONST_GOODS_GOD_TWO,                        52).% 装备-神器-炎书 
-define(CONST_GOODS_GOD_THREE,                      53).% 装备-神器-风书 
-define(CONST_GOODS_GOD_FOUR,                       54).% 装备-神器-光书 
-define(CONST_GOODS_GOD_FIVE,                       55).% 装备-神器-暗书 
-define(CONST_GOODS_GOD_SIX,                        56).% 装备-神器-雷书 
-define(CONST_GOODS_MATERIAL_MATERIAL,              70).% 材料-宝石卷轴 
-define(CONST_GOODS_BLESS,                          71).% 材料-普通材料 
-define(CONST_GOODS_PROTECTION,                     72).% 材料-珍宝卷轴 
-define(CONST_GOODS_LUCK_STAR,                      73).% 材料-待定 
-define(CONST_GOODS_SIGNER,                         74).% 材料-待定 
-define(CONST_GOODS_DEBRIS,                         75).% 材料-神器祝福油 
-define(CONST_GOODS_PROTECT_OPERATOR,               76).% 神器材料-保护符 
-define(CONST_GOODS_DECORATION,                     77).% 神器材料-勋章 
-define(CONST_GOODS_FRAGMENT,                       78).% 神器材料-碎片 
-define(CONST_GOODS_HOLY_WATER,                     79).% 神器材料-圣水 
-define(CONST_GOODS_STERS_HP,                       111).% 宝石-气血 
-define(CONST_GOODS_STERS_STRONG,                   112).% 宝石-物攻 
-define(CONST_GOODS_STERS_STR_DEF,                  113).% 宝石-物防 
-define(CONST_GOODS_STERS_MAGIC,                    114).% 宝石-技攻 
-define(CONST_GOODS_STERS_MAGIC_DEF,                115).% 宝石-技防 
-define(CONST_GOODS_STERS_CRIT,                     116).% 宝石-暴击 
-define(CONST_GOODS_STERS_RES_CRIT,                 117).% 宝石-抗暴 
-define(CONST_GOODS_STERS_CRIT_HARM,                118).% 宝石-暴伤 
-define(CONST_GOODS_STERS_DEF_DOWN,                 119).% 宝石-破甲 
-define(CONST_GOODS_STERS_HARM,                     120).% 宝石-伤害率 
-define(CONST_GOODS_STERS_REDUCTION,                121).% 宝石-免伤率 
-define(CONST_GOODS_STERS_STRONG_UP,                122).% 宝石-力量 
-define(CONST_GOODS_STERS_MAGIC_UP,                 123).% 宝石-智力 
-define(CONST_GOODS_COMMON_GIFT,                    131).% 普通-礼包 
-define(CONST_GOODS_COMMON_BOX,                     132).% 普通-宝盒 
-define(CONST_GOODS_COMMON_MONEY_BAG,               133).% 普通-钱袋 
-define(CONST_GOODS_COMMON_EXP,                     134).% 普通-经验丹(主角专用) 
-define(CONST_GOODS_COMMON_PAR_EXP,                 135).% 普通-伙伴经验丹 
-define(CONST_GOODS_COMMON_MOUNT_EXP,               136).% 普通-坐骑经验丹 
-define(CONST_GOODS_IDEAL_GET,                      137).% 普通-虚拟货币 
-define(CONST_GOODS_COMMON_PARTNER_CARD,            138).% 普通-伙伴卡 
-define(CONST_GOODS_COMMON_RESET_SKILL,             139).% 普通-重置技能卡 
-define(CONST_GOODS_VIP,                            140).% 普通-VIP体验 
-define(CONST_GOODS_WHEEL_GOODS,                    141).% 普通-转盘物品类 
-define(CONST_GOODS_LV_GOODS,                       142).% 普通-等级物品类 
-define(CONST_GOODS_PET_CARD,                       143).% 普通-宠物卡片类 

-define(CONST_GOODS_ACTION_ALL,                     0).% 容器-全部取出 
-define(CONST_GOODS_ACTION_PART,                    1).% 容器-部分取出 
-define(CONST_GOODS_ACTION_LACK,                    3).% 容器-数量不足 
-define(CONST_GOODS_ACTION_FULL,                    4).% 容器-已满 

-define(CONST_GOODS_BAG_MAX,                        60).% 背包开格数 
-define(CONST_GOODS_TEMP_BAG,                       500).% 临时背包开格数 

-define(CONST_GOODS_RANGE_LV_ONE,                   1).% 等级段常量-1-9级 
-define(CONST_GOODS_RANGE_LV_TWO,                   2).% 等级段常量,10-19级 
-define(CONST_GOODS_RANGE_LV_THREE,                 3).% 等级段常量 20-29级 
-define(CONST_GOODS_RANGE_LV_FOUR,                  4).% 等级段常量-30-39级 
-define(CONST_GOODS_RANGE_LV_FIVE,                  5).% 等级段常量-40-49级 
-define(CONST_GOODS_RANGE_LV_SIX,                   6).% 等级段常量-50-59级 
-define(CONST_GOODS_RANGE_LV_SEVEN,                 7).% 等级段常量-60-69级 
-define(CONST_GOODS_RANGE_LV_EIGHT,                 8).% 等级段常量-70-79级 
-define(CONST_GOODS_RANGE_LV_NIGHT,                 9).% 等级段常量-80-89级 
-define(CONST_GOODS_RANGE_LV_TEN,                   10).% 等级段常量-90-99级 
-define(CONST_GOODS_RANGE_LV_ELE,                   11).% 等级段常量-100-109级 
-define(CONST_GOODS_RANGE_LV_TWL,                   12).% 等级段常量-110-119级 

-define(CONST_GOODS_SITE_OTHERROLE,                 0).% Tips位置-在其他位置，只能查看信息，无按钮 
-define(CONST_GOODS_SITE_BACKPACK,                  1).% Tips位置-在背包中 
-define(CONST_GOODS_SITE_ROLEBODY,                  2).% Tips位置-在角色身上 
-define(CONST_GOODS_SITE_ROLEBACKPACK,              3).% Tips位置-在角色身上背包中 
-define(CONST_GOODS_SITE_ARTIFACT,                  4).% Tips位置-在神器界面中 
-define(CONST_GOODS_SITE_TREASUREUNLOAD,            5).% Tips位置-在珍宝界面中 取出 
-define(CONST_GOODS_SITE_TREASURELOAD,              6).% Tips位置-在珍宝界面中 放入 

%% ==========================================================
%% 装备
%% ==========================================================
-define(CONST_EQUIP_WEAPON,                         1).% 武器 
-define(CONST_EQUIP_HAT,                            2).% 帽子 
-define(CONST_EQUIP_ARMOR,                          3).% 衣服 
-define(CONST_EQUIP_ENCHANT_VIP,                    3).% VIP开发等级 
-define(CONST_EQUIP_CLOAK,                          4).% 披风 
-define(CONST_EQUIP_BELT,                           5).% 腰带 
-define(CONST_EQUIP_SHOE,                           6).% 鞋子 
-define(CONST_EQUIP_MOUNT,                          7).% 坐骑 

-define(CONST_EQUIP_PET,                            8).% 特殊 

-define(CONST_EQUIP_ENCHANT_RMB,                    2).% 附魔初次消耗元宝 

-define(CONST_EQUIP_ENCHANT_OPEN,                   25).% 附魔按钮打开等级 

%% ==========================================================
%% 场景
%% ==========================================================
-define(CONST_MAP_DEFAULT_POSX,                     60).% 默认地图X 
-define(CONST_MAP_DEFAULT_POSY,                     160).% 默认地图Y 
-define(CONST_MAP_DEFAULT_MAP,                      10100).% 默认地图ID 

-define(CONST_MAP_INTERVAL_SECONDS,                 0.5).% 地图检查时间间隔(单位秒) 
-define(CONST_MAP_MAP_SEND_LOSE_MAX,                3).% 发送失败次数上限，列表删除 
-define(CONST_MAP_MAP_TILE_PIXEL,                   10).% 地图一个格子的像素 
-define(CONST_MAP_MAP_DISTANCE_MOVE,                50).% 地图坐标间隔距离(大于这个数，就会提示相距太远) 
-define(CONST_MAP_MAP_MAX_COUNT,                    60).% 地图最大人数 
-define(CONST_MAP_MAP_TIME_SLOT,                    100).% 地图时间间隔,清理一次,没人关闭进程(秒) 

-define(CONST_MAP_ENTER_NULL,                       1).% 进入-正常（新上线/换地图） 
-define(CONST_MAP_ENTER_COPY,                       2).% 进入-副本 
-define(CONST_MAP_ENTER_TELEPORT,                   3).% 进入-瞬移 
-define(CONST_MAP_ENTER_CHECK,                      4).% 进入-校正(服务器拉) 
-define(CONST_MAP_ENTER_DRAMA,                      5).% 进入-剧情 

-define(CONST_MAP_OUT_NULL,                         1).% 离开-正常（下线/换地图） 
-define(CONST_MAP_OUT_DIE,                          2).% 离开-死亡 
-define(CONST_MAP_OUT_TELEPORT,                     3).% 离开-瞬移 
-define(CONST_MAP_OUT_CHECK,                        4).% 离开-校正(服务器拉) 

-define(CONST_MAP_DOOR_MAP,                         1).% 传送门类型 - 进地图 
-define(CONST_MAP_DOOR_OPEN,                        2).% 传送门类型 - 打开面板 
-define(CONST_MAP_DOOR_NEXT_COPY,                   3).% 传送门类型 - 进入下层副本 

-define(CONST_MAP_OPEN_COM_COPY,                    101).% 打开-普通副本 
-define(CONST_MAP_HERO_COPY,                        102).% 打开精英副本 
-define(CONST_MAP_FIEND_COPY,                       103).% 打开魔王副本 
-define(CONST_MAP_DAILY,                            104).% 打开日常任务 
-define(CONST_MAP_BOSS,                             105).% 打开世界BOSS 
-define(CONST_MAP_ARENA,                            106).% 打开竞技场 
-define(CONST_MAP_MONEY,                            107).% 打开招财 
-define(CONST_MAP_DOUQI,                            108).% 打开斗气 
-define(CONST_MAP_FANFANLE,                         109).% 打开翻翻乐 
-define(CONST_MAP_YIJIAN,                           110).% 打开每日一箭 
-define(CONST_MAP_FIGHTERS,                         111).% 打开拳皇生涯 
-define(CONST_MAP_TREASURE,                         112).% 打开珍宝 
-define(CONST_MAP_OPEN_BAG,                         113).% 打开背包 
-define(CONST_MAP_TASK,                             114).% 打开任务界面 
-define(CONST_MAP_COMMUNITY,                        115).% 打开社团界面 
-define(CONST_MAP_STRENGTHEN,                       116).% 打开强化 
-define(CONST_MAP_GOD,                              117).% 开启神器 
-define(CONST_MAP_GIFT,                             118).% 开启首充礼包 
-define(CONST_MAP_PLAYER,                           119).% 打开人物界面 
-define(CONST_MAP_BAR,                              120).% 打开酒吧界面 
-define(CONST_MAP_WONDERFUL_ACTIVITIES,             121).% 精彩活动界面 
-define(CONST_MAP_STRATEGY,                         122).% 打开游戏攻略--我要变强 
-define(CONST_MAP_SKILL,                            123).% 人物-技能界面 
-define(CONST_MAP_INSET,                            124).% 强化-镶嵌界面 
-define(CONST_MAP_DAILY_SIGN,                       125).% 每日签到界面 
-define(CONST_MAP_TREASURE_SHOP,                    126).% 珍宝商店 
-define(CONST_MAP_CHAPPER_SHOP,                     127).% 特惠商店 
-define(CONST_MAP_WONDERFUL_ADD_PAY,                128).% 打开精彩活动-累计充值活动 

-define(CONST_MAP_TYPE_CITY,                        1).% 地图类型-城镇 
-define(CONST_MAP_TYPE_COPY_NORMAL,                 2).% 地图类型-普通副本 
-define(CONST_MAP_TYPE_COPY_HERO,                   3).% 地图类型-英雄副本 
-define(CONST_MAP_TYPE_COPY_FIEND,                  4).% 地图类型-魔王副本 
-define(CONST_MAP_TYPE_BOSS,                        5).% 地图类型-世界BOSS 
-define(CONST_MAP_TYPE_CHALLENGEPANEL,              6).% 地图类型-逐鹿台 
-define(CONST_MAP_TYPE_INVITE_PK,                   7).% 地图类型-多人PK 
-define(CONST_MAP_TYPE_COPY_FIGHTERS,               8).% 地图类型-拳皇生涯 
-define(CONST_MAP_TYPE_KOF,                         9).% 地图类型-格斗之王 
-define(CONST_MAP_TYPE_CLAN_BOSS,                   10).% 地图类型-帮派Boss 
-define(CONST_MAP_TYPE_COPY_CLAN,                   11).% 地图类型-帮派副本 

-define(CONST_MAP_WAR_DISTANCE,                     20).% 主动怪攻击触发距离 

-define(CONST_MAP_TOUCH_WAR,                        1).% 触发-打怪 
-define(CONST_MAP_TOUCH_COLLECT,                    2).% 触发-采集 

-define(CONST_MAP_WALK_NO,                          0).% 场景坐标标识--不可行走 
-define(CONST_MAP_WALK_YES,                         1).% 场景坐标标识--可行走 
-define(CONST_MAP_WALK_HALF,                        2).% 场景坐标标识--可行走(半透明) 

-define(CONST_MAP_MOVE_MOVE,                        1).% 地图行走方式--移动 
-define(CONST_MAP_MOVE_JUMP,                        2).% 地图行走方式--跳跃 
-define(CONST_MAP_MOVE_STOP,                        3).% 地图行走方式-停止行走 

%% ==========================================================
%% 任务
%% ==========================================================
-define(CONST_TASK_PRE_LV,                          1).% 预先取得任务的等级 
-define(CONST_TASK_SPLIT_LV,                        15).% 任务分界等级 
-define(CONST_TASK_COUNTRY_ID,                      100180).% 阵营任务ID 

-define(CONST_TASK_TO_PAY_FIRST,                    1).% 任务目标其它 - 首次充值 
-define(CONST_TASK_TO_COUNTRY,                      2).% 任务目标其它 - 加入阵营 
-define(CONST_TASK_TO_BUY,                          3).% 任务目标其它 - 加入帮派 
-define(CONST_TASK_TO_MAKE,                         4).% 任务目标其它 - 装备打造 
-define(CONST_TASK_TO_STRENG,                       5).% 任务目标其它 - 装备强化 
-define(CONST_TASK_TO_WASH,                         6).% 任务目标其它 - 装备洗练 
-define(CONST_TASK_TO_PASS_LV,                      7).% 任务目标其它 - 通过关卡 
-define(CONST_TASK_TO_PET_FEED,                     8).% 任务目标其它 - 培养宠物 
-define(CONST_TASK_TO_MONEY,                        9).% 任务目标其它 - 招财 
-define(CONST_TASK_TO_PRAY,                         10).% 任务目标其它 - 上香 
-define(CONST_TASK_TO_RENOWN_LV,                    11).% 任务目标其它 - 提升声望等级 
-define(CONST_TASK_TO_SANJIESHA,                    12).% 任务目标其它 - 三界杀(挑战某BOSS) 
-define(CONST_TASK_TO_COPY,                         13).% 任务目标其它 - 打副本 
-define(CONST_TASK_TO_USE_GOODS,                    14).% 任务目标其它 - 特殊道具 
-define(CONST_TASK_TO_GOODS,                        15).% 任务目标其它 - 道具使用 
-define(CONST_TASK_TO_ARENA,                        17).% 任务目标其它 - 封神台 
-define(CONST_TASK_TO_COST_RMB,                     18).% 任务目标其它 - 消费金元 
-define(CONST_TASK_TO_PAY_RMB,                      19).% 任务目标其它 - 充值金元 
-define(CONST_TASK_TO_PARTNER,                      20).% 任务目标其它 - 送伙伴 
-define(CONST_TASK_DOWN_NEWS,                       21).% 任务目标其它 - 下载新资源 

-define(CONST_TASK_POP_FB,                          1).% 任务追踪弹出面板-忍之书(剧情副本) 
-define(CONST_TASK_POP_MS,                          2).% 任务追踪弹出面板-月读空间(阶段副本) 
-define(CONST_TASK_POP_VS,                          3).% 任务追踪弹出面板-虚空城（竞技场） 
-define(CONST_TASK_POP_TASK,                        4).% 任务追踪弹出面板-任务面板 
-define(CONST_TASK_POP_WELFARE,                     7).% 任务追踪弹出面板-福利面板 
-define(CONST_TASK_POP_MARKET,                      8).% 任务追踪弹出面板-市场系统面板 
-define(CONST_TASK_POP_RENOWN,                      9).% 任务追踪弹出面板-声望兑换面板 
-define(CONST_TASK_POP_EQUIP,                       12).% 任务追踪弹出面板-装备炼制系统 
-define(CONST_TASK_POP_PET,                         13).% 任务追踪弹出面板-宠物面板 
-define(CONST_TASK_POP_FAM,                         14).% 任务追踪弹出面板-家族面板 
-define(CONST_TASK_POP_MALL,                        15).% 任务追踪弹出面板-商城 

-define(CONST_TASK_DAILY_FREE_FRESH_TIMES,          5).% 日常任务免费刷星次数 
-define(CONST_TASK_DAILY_ONE_FRESH,                 10).% 一键满星所用的RMB 
-define(CONST_TASK_DAILY_LV,                        40).% 日常任务开放等级 
-define(CONST_TASK_DAILY_NPC_ID,                    308).% 日常任务NPC_ID 
-define(CONST_TASK_DAILY_FRESH_GOODS_ID,            2078).% 日常任务刷星必需品ID 

-define(CONST_TASK_TYPE_MAIN,                       1).% 主线任务 
-define(CONST_TASK_TYPE_BRANCH,                     2).% 支线任务 
-define(CONST_TASK_TYPE_EVERYDAY,                   10).% 日常任务 
-define(CONST_TASK_TYPE_CLAN,                       20).% 家族任务 
-define(CONST_TASK_TYPE_WIFE,                       22).% 夫妻任务 
-define(CONST_TASK_TYPE_ACTIVITY,                   60).% 活动任务 
-define(CONST_TASK_TYPE_OTHER,                      99).% 其他任务 

-define(CONST_TASK_TARGET_TALK,                     1).% 对话类 
-define(CONST_TASK_TARGET_COLLECT,                  2).% 收集类 
-define(CONST_TASK_TARGET_KILL,                     3).% 击杀怪物 
-define(CONST_TASK_TARGET_PK,                       4).% 击杀玩家 
-define(CONST_TASK_TARGET_ASK,                      5).% 问答题 
-define(CONST_TASK_TARGET_OTHER,                    6).% 其它(充值,加入家族,商城购买,装备打造) 
-define(CONST_TASK_TARGET_COPY,                     7).% 通关副本 
-define(CONST_TASK_TARGET_GATHER,                   8).% 采集类 

-define(CONST_TASK_SUBMIT_PASSIVE,                  0).% 任务提交方式:被动提交,即:npc对话完成 
-define(CONST_TASK_SUBMIT_ACTIVE,                   1).% 任务提交方式-主动提交,直接完成 

-define(CONST_TASK_STATE_INACTIVE,                  0).% 任务状态-未激活 
-define(CONST_TASK_STATE_ACTIVATE,                  1).% 任务状态-已激活 
-define(CONST_TASK_STATE_ACCEPTABLE,                2).% 任务状态-可接受 
-define(CONST_TASK_STATE_UNFINISHED,                3).% 任务状态-接受未完成 
-define(CONST_TASK_STATE_FINISHED,                  4).% 任务状态-完成未提交 
-define(CONST_TASK_STATE_SUBMIT,                    5).% 任务状态-已提交 

-define(CONST_TASK_REMOVE_REASON_DOWN,              1).% 任务移除原因--完成任务 
-define(CONST_TASK_REMOVE_REASON_CANCEL,            2).% 任务移除原因--放弃任务 

-define(CONST_TASK_ACCEPT_TYPE_ADD,                 2).% 接受条件类型--追加任务 

-define(CONST_TASK_TRACE_MAIN_TASK,                 1).% 任务追踪--主线任务类 
-define(CONST_TASK_TRACE_DAILY_TASK,                2).% 任务追踪--日常任务类 
-define(CONST_TASK_TRACE_MATERIAL,                  3).% 任务追踪--材料掉落类 

%% ==========================================================
%% 聊天频道
%% ==========================================================
-define(CONST_CHAT_ALL,                             0).% 综合频道 
-define(CONST_CHAT_HEARSAY,                         1).% 传闻 
-define(CONST_CHAT_MAP,                             2).% 当前 
-define(CONST_CHAT_TEAM,                            3).% 队伍 
-define(CONST_CHAT_CLAN,                            4).% 社团频道 
-define(CONST_CHAT_COUNTRY,                         5).% 阵营 
-define(CONST_CHAT_WORLD,                           6).% 世界频道 
-define(CONST_CHAT_SUONA,                           7).% 小喇叭 
-define(CONST_CHAT_SYSTEM,                          8).% 系统 
-define(CONST_CHAT_PM,                              9).% 私聊频道 
-define(CONST_CHAT_JJC,                             10).% 竞技场 
-define(CONST_CHAT_ADD_FRIENDS,                     11).% 自定义好友通知 
-define(CONST_CHAT_MARQUEE,                         12).% 跑马灯 
-define(CONST_CHAT_MARQUEE_ALL,                     13).% 跑马灯 +综合频道 

-define(CONST_CHAT_GOODS,                           1).% 物品类型 
-define(CONST_CHAT_TEAM_ID,                         2).% 组队类型 

-define(CONST_CHAT_MSGTYPE_CHAT,                    0).% 聊天消息 
-define(CONST_CHAT_MSGTYPE_BROADCAST,               1).% 游戏广播 

%% ==========================================================
%% 好友系统
%% ==========================================================
-define(CONST_FRIEND_SYS_RECOMMEND,                 10).% 系统推荐好友数量 
-define(CONST_FRIEND_TWENTY_FIVE,                   12).% 系统推荐好友-12级 
-define(CONST_FRIEND_THIRTY,                        26).% 系统推荐好友-26级 
-define(CONST_FRIEND_THIRTY_FIVE,                   29).% 系统推荐好友-29级 
-define(CONST_FRIEND_MAX,                           100).% 好友上限 

-define(CONST_FRIEND_RECENT_TIME,                   1).% 最近联系人保存时间( 天) 
-define(CONST_FRIEND_FRIEND_LV,                     1).% 好友开放等级 
-define(CONST_FRIEND_RECENT_COUNT,                  5).% 最近联系人显示数量 

-define(CONST_FRIEND_FRIEND,                        1).% 类型-好友 
-define(CONST_FRIEND_RECENT,                        2).% 类型-最近联系人 
-define(CONST_FRIEND_BLACKLIST,                     3).% 类型-黑名单 

-define(CONST_FRIEND_RECOM_TIMES,                   3).% 玩家推荐好友次数 

%% ==========================================================
%% 邮件
%% ==========================================================
-define(CONST_MAIL_NET_TIME,                        7).% 邮件有效期(天数） 
-define(CONST_MAIL_ITLE_MAX,                        40).% 邮件标题字数上限 
-define(CONST_MAIL_VOLUME_MAX,                      50).% 保存箱容量上限 
-define(CONST_MAIL_CONTENT_LENGTH,                  900).% 邮件内容字数上限 

-define(CONST_MAIL_STATE_UNREAD,                    0).% 读取状态 - 未读 
-define(CONST_MAIL_STATE_READ,                      1).% 读取状态 - 已读 

-define(CONST_MAIL_ACCESSORY_NULL,                  0).% 附件状态--无物品 
-define(CONST_MAIL_ACCESSORY_NO,                    1).% 附件状态--未提取 
-define(CONST_MAIL_ACCESSORY_YES,                   2).% 附件状态--已提取 
-define(CONST_MAIL_ATTACH,                          6).% 附件数量 

-define(CONST_MAIL_TYPE_SYSTEM,                     0).% 邮件类型--系统 
-define(CONST_MAIL_TYPE_WAR,                        1).% 邮件类型--帮派 
-define(CONST_MAIL_TYPE_PRIVATE,                    2).% 邮件类型--玩家 

-define(CONST_MAIL_TYPE_GET,                        0).% 邮箱类型--收件箱 
-define(CONST_MAIL_TYPE_SEND,                       1).% 邮箱类型--发件箱 
-define(CONST_MAIL_TYPE_SAVE,                       2).% 邮箱类型--保存箱 

-define(CONST_MAIL_PICK_BOX,                        6).% 邮件附件可发送箱子数 

%% ==========================================================
%% 玩家属性
%% ==========================================================
-define(CONST_ATTR_COUNTRY,                         1).% 国家 
-define(CONST_ATTR_COUNTRY_POST,                    2).% 国家-职位 
-define(CONST_ATTR_NAME_COLOR,                      5).% 角色名颜色 
-define(CONST_ATTR_LV,                              6).% 等级 
-define(CONST_ATTR_VIP,                             7).% vip等级 

-define(CONST_ATTR_ENERGY,                          10).% 精力 
-define(CONST_ATTR_EXP,                             11).% 经验值 
-define(CONST_ATTR_EXPN,                            12).% 下级要多少经验 
-define(CONST_ATTR_EXPT,                            13).% 总共集了多少 经验 
-define(CONST_ATTR_RENOWN,                          14).% 声望 
-define(CONST_ATTR_SLAUGHTER,                       15).% 杀戮值 
-define(CONST_ATTR_HONOR,                           16).% 荣誉值 
-define(CONST_ATTR_POWERFUL,                        17).% 战斗力 
-define(CONST_ATTR_NAME,                            18).% 名字 
-define(CONST_ATTR_RANK,                            19).% 排名 

-define(CONST_ATTR_WEAPON,                          21).% 装备武器id（换装） 
-define(CONST_ATTR_ARMOR,                           22).% 装备衣服id（换装） 
-define(CONST_ATTR_FASHION,                         23).% 装备时装id(换装) 
-define(CONST_ATTR_MOUNT,                           24).% 坐骑 

-define(CONST_ATTR_S_HP,                            40).% 气血(现有战斗中) 

-define(CONST_ATTR_SP,                              41).% 怒气 
-define(CONST_ATTR_SP_UP,                           42).% 怒气恢复速度 
-define(CONST_ATTR_ANIMA,                           43).% 初始灵气值 
-define(CONST_ATTR_HP,                              44).% 气血值 
-define(CONST_ATTR_HP_GRO,                          45).% 气血成长值 
-define(CONST_ATTR_STRONG,                          46).% 武力 
-define(CONST_ATTR_STRONG_GRO,                      47).% 武力成长 
-define(CONST_ATTR_MAGIC,                           48).% 内力 
-define(CONST_ATTR_MAGIC_GRO,                       49).% 内力成长 
-define(CONST_ATTR_STRONG_ATT,                      50).% 物攻 
-define(CONST_ATTR_STRONG_DEF,                      51).% 物防 
-define(CONST_ATTR_SKILL_ATT,                       52).% 技能攻击 
-define(CONST_ATTR_SKILL_DEF,                       53).% 技能防御 
-define(CONST_ATTR_HIT,                             54).% 命中 
-define(CONST_ATTR_CRIT,                            56).% 暴击 
-define(CONST_ATTR_RES_CRIT,                        57).% 抗暴 
-define(CONST_ATTR_CRIT_HARM,                       58).% 暴伤 
-define(CONST_ATTR_DEFEND_DOWN,                     59).% 破甲 
-define(CONST_ATTR_LIGHT,                           60).% 光属性 
-define(CONST_ATTR_LIGHT_DEF,                       61).% 光抗性 
-define(CONST_ATTR_DARK,                            62).% 暗属性 
-define(CONST_ATTR_DARK_DEF,                        63).% 暗抗性 
-define(CONST_ATTR_GOD,                             64).% 灵属性 
-define(CONST_ATTR_GOD_DEF,                         65).% 灵抗性 
-define(CONST_ATTR_BONUS,                           66).% 伤害率 
-define(CONST_ATTR_REDUCTION,                       67).% 免伤率 
-define(CONST_ATTR_IMM_DIZZ,                        68).% 免疫眩晕 
-define(CONST_ATTR_ATTACK,                          69).% 攻击（物攻-技攻） 
-define(CONST_ATTR_SCORE_EQ,                        80).% 装备评分 
-define(CONST_ATTR_SCORE_JEW,                       81).% 首饰评分 
-define(CONST_ATTR_SCORE_MAG,                       82).% 法宝评分 
-define(CONST_ATTR_SCORE_PEA,                       84).% 灵珠评分 

-define(CONST_ATTR_MATE,                            71).% 配偶：id 
-define(CONST_ATTR_MATE_NAME,                       72).% 配偶：姓名[字符串] 

-define(CONST_ATTR_TITLES_ADD,                      81).% 称号-新加 
-define(CONST_ATTR_TITLES_DEL,                      82).% 称号-移除(得到更高级的称号，低的要移除) 

-define(CONST_ATTR_CLAN,                            91).% 帮派ID 
-define(CONST_ATTR_CLAN_POST,                       92).% 帮派：职位 
-define(CONST_ATTR_CLAN_NAME,                       93).% 帮派：名称[字符串] 

-define(CONST_ATTR_SKIN_TYPE_EQUIP,                 31).% 角色皮肤类型--装备 
-define(CONST_ATTR_SKIN_TYPE_SHAPE,                 32).% 角色皮肤类型--时装 
-define(CONST_ATTR_SKIN_TYPE_MOUNT,                 33).% 角色皮肤类型--坐骑 
-define(CONST_ATTR_SKIN_TYPE_TASK_ESCORT,           34).% 角色皮肤类型--任务(护送) 
-define(CONST_ATTR_SKIN_TYPE_TASK_SHAPE,            35).% 角色皮肤类型--任务(变身) 

-define(CONST_ATTR_SCORE_BONUS,                     0.01).% 战斗力-伤害率 
-define(CONST_ATTR_SCORE_HP,                        0.1).% 战斗力-气血 
-define(CONST_ATTR_SCORE_SKILL_DEF,                 1).% 战斗力-技防 
-define(CONST_ATTR_SCORE_STRONG_DEF,                1).% 战斗力-物防 
-define(CONST_ATTR_SCORE_STRONG_ATT,                1).% 战斗力-物攻 
-define(CONST_ATTR_SCORE_SKILL_ATT,                 1.5).% 战斗力-技攻 
-define(CONST_ATTR_SCORE_DEFEND_DOWN,               2).% 战斗力-破甲 
-define(CONST_ATTR_SCORE_CRIT,                      5).% 战斗力-暴击 
-define(CONST_ATTR_SCORE_RES_CRIT,                  5).% 战斗力-抗暴 
-define(CONST_ATTR_SCORE_CRIT_HARM,                 10).% 战斗力-暴伤 
-define(CONST_ATTR_SCORE_REDUCTION,                 20).% 战斗力-免伤率 

-define(CONST_ATTR_TALENT_1,                        1).% 力量天赋 
-define(CONST_ATTR_TALENT_2,                        2).% 灵力天赋 
-define(CONST_ATTR_TALENT_3,                        3).% 敏捷天赋 
-define(CONST_ATTR_TALENT_4,                        4).% 暴击天赋 
-define(CONST_ATTR_TALENT_5,                        5).% 躲避天赋 
-define(CONST_ATTR_TALENT_6,                        6).% 格挡天赋 
-define(CONST_ATTR_TALENT_7,                        7).% 气血天赋 
-define(CONST_ATTR_TALENT_8,                        8).% 坚守天赋 

-define(CONST_ATTR_SHOW_TYPE,                       0).% 查看玩家属性类型 

-define(CONST_ATTR_INIT_NAME,                       2).% 角色初始化颜色 
-define(CONST_ATTR_CHANGE_LV,                       50).% 主角换位置等级要求 

-define(CONST_ATTR_PARTNER_LV_TWO,                  30).% 第二个出战伙伴等级限制 
-define(CONST_ATTR_PARTNER_LV_THREE,                50).% 第三个出战伙伴等级限制 

-define(CONST_ATTR_ALLS_POWER,                      100).% 人物总战斗力 

%% ==========================================================
%% 组队
%% ==========================================================
-define(CONST_TEAM_MAX,                             3).% 组队成员人数上限 
-define(CONST_TEAM_RECRUIT_TIME,                    20).% 发布招募间隔时间（秒） 

-define(CONST_TEAM_OUT_KICK,                        1).% 离队-被踢出队伍 
-define(CONST_TEAM_OUT_EXIT,                        2).% 离队-自己主动退出 

-define(CONST_TEAM_MEMBER_UPDATE_IN,                1).% 队伍成员加入 
-define(CONST_TEAM_MEMBER_UPDATE_OUT,               2).% 队伍成员退出 

-define(CONST_TEAM_STATE_TEAMING,                   1).% 队伍状态-组队中 
-define(CONST_TEAM_STATE_WARING,                    2).% 队伍状态-战斗中 

-define(CONST_TEAM_INVITE_FRIEND,                   1).% 邀请类型--好友 
-define(CONST_TEAM_INVITE_CLAN,                     2).% 邀请类型--社团人员 

%% ==========================================================
%% 战斗
%% ==========================================================
-define(CONST_WAR_EMBATTLE_DEFAULT,                 1).% 阵型 - 默认 
-define(CONST_WAR_MAX_PLAYER,                       5).% 战斗 最多5个玩家同时参战 
-define(CONST_WAR_POSITION_MAX,                     9).% 站位-左右每边总人数 
-define(CONST_WAR_BOSS_SP,                          20).% boss命中增加士气值 
-define(CONST_WAR_MIN_PK2_LV,                       29).% 切磋最小等级 
-define(CONST_WAR_ROUNT_MAX,                        30).% 战斗最大回合数 
-define(CONST_WAR_UP_SP,                            50).% 每次命中后增加士气 
-define(CONST_WAR_USE_SP,                           100).% 技能触发所需士气 
-define(CONST_WAR_RES_ASK,                          2000).% 支援承受伤害 
-define(CONST_WAR_PARRY,                            3000).% 格挡承受30%伤害 
-define(CONST_WAR_TIME_MIN,                         3000).% 战斗开始到结束最少时长（毫秒） 
-define(CONST_WAR_BATTLE_INTERVAL,                  5000).% 两次战斗间隔-毫秒 

-define(CONST_WAR_MERGE_FAULT_TOLERANT,             1).% 援助 - 容错值 
-define(CONST_WAR_MERGE_STRENGTHEN,                 13000).% 援助 - 普通攻击*130% 

-define(CONST_WAR_BACK_STRENGTHEN,                  13000).% 反击 - 普通攻击*130% 
-define(CONST_WAR_CRIT_STRENGTHEN,                  15000).% 暴击 - 普通攻击*150% 

-define(CONST_WAR_PARAS_1_NORMAL,                   1).% 战斗参数 - 场景杀怪（包括副本） 
-define(CONST_WAR_PARAS_1_PK,                       2).% 战斗参数 - PK(默认) 
-define(CONST_WAR_PARAS_1_MOIL,                     3).% 战斗参数 - 苦工 
-define(CONST_WAR_PARAS_1_TEAM,                     4).% 战斗参数 - 组队副本 
-define(CONST_WAR_PARAS_1_JJC,                      6).% 战斗参数 - 封神台 
-define(CONST_WAR_PARAS_1_CLAN,                     9).% 战斗参数 - 帮派 
-define(CONST_WAR_PARAS_1_CLAN2,                    10).% 战斗参数 - 家族怪物 
-define(CONST_WAR_PARAS_1_WORLD_BOSS,               11).% 战斗参数 - 世界Boss 
-define(CONST_WAR_PARAS_1_DEFEND_BOOK,              13).% 战斗参数 - 保卫经书 
-define(CONST_WAR_PARAS_1_SKY_WAR,                  14).% 战斗参数 - 天空之战 
-define(CONST_WAR_PARAS_1_PILROAD,                  15).% 战斗参数 - 取经之路 
-define(CONST_WAR_BLASTING_ODDS,                    500).% 战斗参数 - 身上/背包的装备有5%的爆出机率 

-define(CONST_WAR_PK_SLAUGHTER,                     1).% PK - 同国杀死，增加杀戮值 
-define(CONST_WAR_PK_HONOR,                         1).% PK - 击杀敌国，增加荣誉值 

-define(CONST_WAR_BROADCAST_FLAG_START,             1).% 战斗广播标识--战斗开始 
-define(CONST_WAR_BROADCAST_FLAG_OVER,              2).% 战斗广播标识--战斗结束 

-define(CONST_WAR_PLUS_ATTACK,                      10).% buff类型-加攻击 
-define(CONST_WAR_MINUS_ATTACK,                     15).% buff类型-减攻击 
-define(CONST_WAR_PLUS_DEFENSE,                     20).% buff类型-加防御 
-define(CONST_WAR_MINUS_DEFENSE,                    25).% buff类型-减防御 
-define(CONST_WAR_PLUS_SPEED,                       26).% buff类型-加速度 
-define(CONST_WAR_MINUS_SPEED,                      27).% buff类型-降速度 
-define(CONST_WAR_PLUS_CRIT,                        30).% buff类型-加暴击 
-define(CONST_WAR_MINUS_CRIT,                       35).% buff类型-减暴击 
-define(CONST_WAR_PLUS_HIT,                         40).% buff类型-加命中 
-define(CONST_WAR_MINUS_HIT,                        45).% buff类型-减命中 
-define(CONST_WAR_PLUS_DODGE,                       50).% buff类型-加闪避 
-define(CONST_WAR_MINUS_DODGE,                      55).% buff类型-减闪避 
-define(CONST_WAR_PLUS_PARRY,                       60).% buff类型-加格挡 
-define(CONST_WAR_MINUS_PARRY,                      65).% buff类型-降格挡 
-define(CONST_WAR_PLUS_WRECK,                       70).% buff类型-加破击 
-define(CONST_WAR_MINUS_WRECK,                      75).% buff类型-减破击 
-define(CONST_WAR_PLUS_REGAIN_HP,                   80).% buff类型-每回合加血 
-define(CONST_WAR_MINUS_POISON,                     85).% buff类型-中毒 
-define(CONST_WAR_MINUS_BURN,                       90).% buff类型-烧伤 
-define(CONST_WAR_VERTIGO,                          100).% buff类型-眩晕 
-define(CONST_WAR_PLUS_ANTI_IMM_VERTIGO,            110).% buff类型-免疫眩晕 
-define(CONST_WAR_PLUS_CURE,                        115).% buff类型-降低治疗效果 
-define(CONST_WAR_MINUS_ROUND_SP,                   120).% buff类型-每回合降士气 
-define(CONST_WAR_PLUS_MERGE,                       125).% buff类型-加合击 
-define(CONST_WAR_PLUS_RES_ASK,                     130).% buff类型-加求援 
-define(CONST_WAR_CHANGE,                           135).% buff类型-换位置 
-define(CONST_WAR_PLUS_ATTACK_WEAPON,               140).% buff类型-武器加攻击 
-define(CONST_WAR_PLUS_DEFENSE_WEAPN,               145).% buff类型-武器加防御 
-define(CONST_WAR_SP_ADD,                           150).% buff类型-加士气 
-define(CONST_WAR_SP_DOWN,                          155).% buff类型-降低士气 

-define(CONST_WAR_WIN_NONE,                         0).% 胜(败)层次-微胜(败) 
-define(CONST_WAR_WIN_NOSE,                         1).% 胜(败)层次-小胜(败) 

-define(CONST_WAR_TYPE_NORMAL,                      1).% 战斗类型 - 普通(打怪) 
-define(CONST_WAR_TYPE_PK,                          2).% 战斗类型 - pk 
-define(CONST_WAR_TYPE_PK2,                         3).% 战斗类型- 切磋 

-define(CONST_WAR_STATE_DIE,                        0).% 战斗状态(被) - 死亡 
-define(CONST_WAR_STATE_NORMAL,                     1).% 战斗状态(被) - 正常 

-define(CONST_WAR_COM_NORMAL,                       1).% 指命类型-普通攻击 
-define(CONST_WAR_COM_SKILL,                        2).% 指命类型-技能 
-define(CONST_WAR_COM_TRIED,                        4).% 指命类型-星魂 
-define(CONST_WAR_COM_BUFF_TYPE,                    5).% 指命类型-buff获得类型 
-define(CONST_WAR_COM_RE_BUFF,                      6).% 指命类型-buff释放 
-define(CONST_WAR_COM_BOMB,                         7).% 指命类型-炸弹 

-define(CONST_WAR_POSITION_LEFT,                    1).% 站位-左边 
-define(CONST_WAR_POSITION_RIGHT,                   2).% 站位-右边 

-define(CONST_WAR_TARGET_OWN,                       1).% 目标-队友（已方） 
-define(CONST_WAR_TARGET_FOE,                       2).% 目标-敌人（敌方） 
-define(CONST_WAR_TARGET_DIE,                       3).% 目标-死亡个体(已方) 
-define(CONST_WAR_TARGET_ALL,                       4).% 目标-全部(敌我) 

-define(CONST_WAR_COLL_NULL,                        100).% 指命集 - 正常 
-define(CONST_WAR_COLL_DOUBLE_HIT,                  101).% 指命集 - 连击 
-define(CONST_WAR_COLL_STRIKE_BACK,                 102).% 指命集 - 反击 
-define(CONST_WAR_COLL_MERGE,                       103).% 指命集 - 援助(合击) 
-define(CONST_WAR_COLL_BUFF,                        104).% 指命集 - buff释放 
-define(CONST_WAR_COLL_BRUISE,                      105).% 指命集 - 中毒 

-define(CONST_WAR_MONSTER_MAKE_NULL,                0).% 怪物生成-空 
-define(CONST_WAR_MONSTER_MAKE_SELF,                1).% 怪物生成-本身 
-define(CONST_WAR_MONSTER_MAKE_RANDOM,              2).% 怪物生成-随机(必生) 
-define(CONST_WAR_MONSTER_MAKE_ODDS,                100).% 怪物生成-随机(机率) 

-define(CONST_WAR_EXPRESSION_HARM_MIN,              1).% 公式常量 - 伤害(最小) 
-define(CONST_WAR_EXPRESSION_CRIT_MIN,              500).% 公式常量 - 暴击几率%(最小) 
-define(CONST_WAR_EXPRESSION_DODGE_MAX,             4500).% 公式常量 - 闪避几率%(最大) 
-define(CONST_WAR_EXPRESSION_CRIT_MAX,              5000).% 公式常量 - 暴击几率%(最大) 

-define(CONST_WAR_PARAMETER_DEFENSE,                1).% 公式计算系数 - 防御 
-define(CONST_WAR_PARAMETER_ATTACK,                 1).% 公式计算系数 - 攻击 
-define(CONST_WAR_PARAMETER_TOUGH,                  200).% 公式计算系数 - 坚韧 
-define(CONST_WAR_PARAMETER_CRIT,                   200).% 公式计算系数 - 暴击 
-define(CONST_WAR_PARAMETER_HIT,                    200).% 公式计算系数 - 命中 
-define(CONST_WAR_PARAMETER_DODGE,                  200).% 公式计算系数 - 闪避 

-define(CONST_WAR_STATE_POISONING,                  2).% 战斗状态(被)  - 中毒 
-define(CONST_WAR_STATE_HIDING,                     3).% 战斗状态(被)  - 隐身 

-define(CONST_WAR_DISPLAY_NORMAL,                   50).% 表现状态 - 正常 
-define(CONST_WAR_DISPLAY_DODGE,                    51).% 表现状态 - 未命中 
-define(CONST_WAR_DISPLAY_CRIT,                     52).% 表现状态 - 击暴 
-define(CONST_WAR_DISPLAY_REFLEX,                   53).% 表现状态 - 反射 
-define(CONST_WAR_DISPLAY_PARRY,                    54).% 表现状态 - 格挡 
-define(CONST_WAR_DISPLAY_DOD,                      55).% 表现状态 - 闪避 
-define(CONST_WAR_DISPLAY_ASK,                      56).% 表现状态 - 求援 

-define(CONST_WAR_REVIVE_LOCAL,                     0.3).% 复活 - 原地,回复30%血 
-define(CONST_WAR_REVIVE_STWP,                      1).% 复活 - 回城,回复1点血 

-define(CONST_WAR_OVER_CONFIRM,                     1).% 战斗结束选项-确定 
-define(CONST_WAR_OVER_REVIVE_LOCAL,                2).% 战斗结束选项-复活-原地 
-define(CONST_WAR_OVER_REVIVE_STWP,                 3).% 战斗结束选项-复活-回城 

-define(CONST_WAR_SHAKE_NONE,                       0).% 震屏效果-不震屏 
-define(CONST_WAR_SHAKE_SLIGHT,                     1).% 震屏效果-微震 
-define(CONST_WAR_SHAKE_SMALL,                      2).% 震屏效果-小震 
-define(CONST_WAR_SHAKE_MIDDLE,                     3).% 震屏效果-中震 
-define(CONST_WAR_SHAKE_BIG,                        4).% 震屏效果-大震 
-define(CONST_WAR_SHAKE_WORLD,                      5).% 震屏效果-惊天动地的震 

-define(CONST_WAR_STRONG,                           1).% 攻击类型--力量 
-define(CONST_WAR_MAGIC,                            2).% 攻击类型--灵力 

-define(CONST_WAR_BUFF_TYPE_POISON,                 1).% buff释放显示类型-中毒 
-define(CONST_WAR_BUFF_TYPE_RECOVERY,               2).% buff释放显示类型-回血 

-define(CONST_WAR_MAP_TYPE_ARENA,                   1).% 背景类型-封神台 
-define(CONST_WAR_MAP_TYPE_CIRCLE,                  2).% 背景类型-三界杀 
-define(CONST_WAR_MAP_TYPE_MOIL,                    3).% 背景类型-苦工 

-define(CONST_WAR_CAL_MULTIPLE,                     1.25).% 战斗计算倍数（1.25） 

-define(CONST_WAR_TOUNGHNESS1,                      15).% 角色击飞韧性 
-define(CONST_WAR_TOUNGHNESS2,                      80).% 角色霸体韧性 

-define(CONST_WAR_HP_TIME,                          0.5).% 血量飘动时间 

%% ==========================================================
%% 技能
%% ==========================================================
-define(CONST_SKILL_ROLE_SKILL,                     0).% 主角技能 
-define(CONST_SKILL_PARTNER_SKILL,                  0).% 伙伴技能 
-define(CONST_SKILL_CD_SHINE,                       0.3).% 技能冷却后高亮时间 
-define(CONST_SKILL_CLICK_SHINE,                    0.6).% 技能点击效果持续时间 
-define(CONST_SKILL_ONE,                            1).% 技能装备方案1 
-define(CONST_SKILL_TWO,                            2).% 技能装备方案2 
-define(CONST_SKILL_THREE,                          3).% 技能装备方案3 
-define(CONST_SKILL_LV_MAX,                         100).% 技能等级上限 
-define(CONST_SKILL_STAR_LV,                        101).% 星阵图初始化等级 

-define(CONST_SKILL_ARG_OPEN,                       0).% 正常施放 
-define(CONST_SKILL_ARG_CLOSE,                      1).% 不能施放技能 

-define(CONST_SKILL_EQUIP_INIT_NUM,                 5).% 技能初始装备数量 
-define(CONST_SKILL_EQUIP_MAX,                      6).% 技能最大装备数量 

-define(CONST_SKILL_ROUND_HAVE_NOT,                 0).% 是否占回合数-不占用 
-define(CONST_SKILL_ROUND_HAVE,                     1).% 是否占回合数-占用 

-define(CONST_SKILL_TYPE_PASSIVITY,                 1).% 类型-被动 
-define(CONST_SKILL_TYPE_INITIATIVE,                2).% 类型-主动 
-define(CONST_SKILL_TYPE_WEAPON,                    3).% 类型- 兵器技能 

-define(CONST_SKILL_TOUCH_ACTION_PRE,               1).% 效果触发-自己行动前 
-define(CONST_SKILL_TOUCH_ACTION,                   2).% 效果触发-自己动手时 
-define(CONST_SKILL_TOUCH_ACTION_AFTER,             3).% 效果触发-自己动手后 
-define(CONST_SKILL_TOUCH_BEGIN,                    4).% 效果触发-战斗开始时 

-define(CONST_SKILL_SINGLE,                         0).% 范围参数-目标(默认) 
-define(CONST_SKILL_OWN_FRONT,                      1).% 范围参数-己方前军 
-define(CONST_SKILL_OWN_MIDDLE,                     2).% 范围-己方中军 
-define(CONST_SKILL_OWN_BACK,                       3).% 范围参数-己方后军 
-define(CONST_SKILL_OWN_ALL,                        4).% 范围参数-己方全军 
-define(CONST_SKILL_OWN_FM_ONLY,                    5).% 范围参数-只对己方前中军 
-define(CONST_SKILL_OWN_FB,                         6).% 范围参数-己方前后军 
-define(CONST_SKILL_OWN_MB,                         7).% 范围-己方中后军 
-define(CONST_SKILL_SELF,                           8).% 范围-自身 
-define(CONST_SKILL_OWN_OTHER,                      9).% 范围-己方其它 
-define(CONST_SKILL_FOE_FRONT,                      10).% 范围-对方前军 
-define(CONST_SKILL_FOE_MIDD,                       11).% 范围-对方中军 
-define(CONST_SKILL_FOE_BACK,                       12).% 范围-对方后军 
-define(CONST_SKILL_FOE_ALL,                        13).% 范围-对方全军 
-define(CONST_SKILL_FOE_FM,                         14).% 范围-对方前中军 
-define(CONST_SKILL_FOE_FB,                         15).% 范围-对方前后军 
-define(CONST_SKILL_FOE_MB,                         16).% 范围-对方中后军 
-define(CONST_SKILL_OWN_MID_ONLY,                   17).% 范围-只对己方中军 
-define(CONST_SKILL_OWN_BAC_ONLY,                   18).% 范围-只对己方后军 

-define(CONST_SKILL_MC_110,                         110).% 效果-对目标造成伤害，技能威力系数arg1% 
-define(CONST_SKILL_MC_115,                         115).% 攻击对方目标单位，技能威力系数{mc_arg1}%，提升己方目标{mc_arg2}%速度，持续arg9回合，当前回合生效 
-define(CONST_SKILL_MC_120,                         120).% 攻击对方目标单位，技能威力系数{mc_arg1}%，降低对方目标{mc_arg2}%速度，持续arg9回合，当前回合生效 
-define(CONST_SKILL_MC_125,                         125).% 攻击对方目标单位，技能威力系数{mc_arg1}%，降低对方目标{mc_arg2}%攻击，持续arg3次，当前回合生效 
-define(CONST_SKILL_MC_130,                         130).% 攻击目标单位，技能系数arg1%，提升目标arg2%攻击，arg3%暴击和arg4%破击,持续arg5次 
-define(CONST_SKILL_MC_135,                         135).% 攻击目标单位，技能系数arg1%，提升目标arg2%攻击持续arg3次和arg4点士气，恢复自身arg5点士气 
-define(CONST_SKILL_MC_210,                         210).% 效果-对目标造成伤害，技能威力系数arg1%，动手时提升自身格挡arg2%，持续arg3次数，当前回合生效 
-define(CONST_SKILL_MC_220,                         220).% 效果-对目标造成伤害，技能威力系数arg1%，动手时提升自身力量攻击力arg2%和灵力攻击力arg3%，持续arg4次数 
-define(CONST_SKILL_MC_230,                         230).% 效果-对目标造成伤害，技能威力系数arg1%，动手时降低对方格挡arg2%，持续arg3次数，当前回合生效 
-define(CONST_SKILL_MC_240,                         240).% 效果-对目标造成伤害，技能威力系数arg1%，动手时提升自身暴击arg2%，持续arg3次数，当前回合生效 
-define(CONST_SKILL_MC_250,                         250).% 效果-对目标造成伤害，技能威力系数arg1%，动手时提升己方中军破击arg2%，持续arg9回合，当前回合生效 
-define(CONST_SKILL_MC_255,                         255).% 效果-对目标造成伤害，技能威力系数arg1%，动手时提升自身闪避arg2%，持续arg3次数，当前回合生效 
-define(CONST_SKILL_MC_260,                         260).% 效果-对目标造成伤害，技能威力系数arg1%，动手时提升己方中军力量攻击arg2%和灵力攻击arg3%,持续arg9回合，当前回合生效 
-define(CONST_SKILL_MC_320,                         320).% 效果-对目标造成伤害，技能威力系数arg1%，动手后提升己方中军arg2点士气，恢复自身arg3点士气 
-define(CONST_SKILL_MC_410,                         410).% 效果-对目标造成伤害，技能威力系数arg1%，动手后提升己方其它单位arg2点士气，恢复自身arg3点士气 
-define(CONST_SKILL_MC_420,                         420).% 效果-对目标造成伤害，技能威力系数arg1%，动手时降低对方闪避arg2%,持续arg3次数，当前回合生效 
-define(CONST_SKILL_MC_510,                         510).% 效果-对目标造成伤害，技能威力系数arg1%，动手后恢复自身arg2点士气 
-define(CONST_SKILL_MC_550,                         550).% 效果-对目标造成伤害，技能威力系数arg1%，动手时损失自身arg2%的当前血量并提升自身力量攻击arg3%和格挡arg4%，持续arg5次数，当前回合生效 
-define(CONST_SKILL_MC_610,                         610).% 效果-对目标造成伤害，技能威力系数arg1%，动手时提升自身力量防御arg2%和灵力防御arg3%，持续arg4次数，当前回合生效 
-define(CONST_SKILL_MC_620,                         620).% 效果-对目标造成伤害，技能威力系数arg1%，动手后有（arg2%+（自身等级-对方等级）的绝对值*arg3%）的机率令对方眩晕并降低对方arg4点士气，持续arg5次，当前回合生效 
-define(CONST_SKILL_MC_630,                         630).% 对目标造成伤害，技能威力系数arg1%，动手后有（arg2%+（自身等级-对方等级）的绝对值*arg3%）的机率令对方眩晕，持续arg9回合 
-define(CONST_SKILL_MC_735,                         735).% 效果-对目标造成伤害，技能威力系数arg1%，动手时驱散己方目标arg2的异常状态，动手时使己方目标免疫眩晕效果，持续arg9回合，当前回合生效 
-define(CONST_SKILL_MC_750,                         750).% 效果-对目标造成伤害，技能威力系数arg1%，动手时令对方中毒，中毒比例arg2%，持续arg9回合，下回合生效 
-define(CONST_SKILL_MC_810,                         810).% 效果-治疗己方目标，治疗技能系数arg1% 
-define(CONST_SKILL_MC_840,                         840).% 效果-治疗己方目标，技能威力系数arg1%，持续治疗arg9回合，持续治疗比例arg3%，下回合生效 
-define(CONST_SKILL_MC_850,                         850).% 效果-治疗己方目标，治疗技能系数arg1%，动手后恢复自身arg2点士气 
-define(CONST_SKILL_MC_901,                         901).% 效果-对目标造成伤害，技能威力系数arg1%，动手时降低对方力量防御arg2%和灵力防御arg3%，持续arg4次数，当前回合生效 
-define(CONST_SKILL_MC_902,                         902).% 效果-对目标造成伤害，技能威力系数arg1%，动手后有arg3机率眩晕对方，持续arg2次数，当前回合生效 
-define(CONST_SKILL_MC_903,                         903).% 效果-对目标造成伤害，技能威力系数arg1%，动手时使己方中军免疫眩晕效果，持续arg9回合，当前回合生效 
-define(CONST_SKILL_MC_904,                         904).% 效果-对目标造成伤害，技能威力系数arg1%，动手时降低对方治疗效果arg2%，持续arg3次数，当前回合生效 
-define(CONST_SKILL_MC_905,                         905).% 效果-对目标造成伤害，技能威力系数arg1%，动手时提升自身求援率arg2%，持续arg3次数，当前回合生效 
-define(CONST_SKILL_MC_906,                         906).% 效果-对目标造成伤害，技能威力系数arg1%，动手时提升自身合击率arg2%，持续arg3次数，下回合生效 
-define(CONST_SKILL_MC_907,                         907).% 效果-对目标造成伤害，技能威力系数arg1%，动手时将己方中军移动至后军位置，持续arg9回合，当前回合生效 
-define(CONST_SKILL_MC_911,                         911).% 攻击对方目标单位，技能威力系数{mc_arg1}%，动手时提升自身{mc_arg2}%格挡和{mc_arg3}%攻击，持续{mc_arg5}次数 
-define(CONST_SKILL_MC_912,                         912).% 攻击对方目标单位，技能威力系数{mc_arg1}%，动手时提升自身{mc_arg2}%闪避和{mc_arg3}%攻击，持续{mc_arg5}次数 
-define(CONST_SKILL_MC_913,                         913).% 攻击对方目标单位，技能威力系数{mc_arg1}%，动手时提升自身{mc_arg2}%防御和{mc_arg3}%攻击，持续{mc_arg5}次数 ( 
-define(CONST_SKILL_MC_915,                         915).% 攻击对方目标单位，技能威力系数{mc_arg1}%，动手后造成伤害的{mc_arg2}%转化为自身气血 
-define(CONST_SKILL_MC_916,                         916).% 攻击对方目标单位，技能威力系数{mc_arg1}%，提升自身{mc_arg2}%攻击，持续{mc_arg4}次数，造成伤害的{mc_arg5}%转化为自身气血 
-define(CONST_SKILL_MC_921,                         921).% 攻击对方地坤单位，技能威力系数{mc_arg1}%，动手后恢复自身最大气血的{mc_arg2}% 
-define(CONST_SKILL_MC_922,                         922).% 攻击对方目标单位，技能威力系数{mc_arg1}%，提升自身{mc_arg2}%攻击，持续arg4次数，恢复自身最大气血的{mc_arg5}% 
-define(CONST_SKILL_MC_925,                         925).% 攻击对方目标单位，技能威力系数{mc_arg1}%，动手后降低对方{mc_arg2}点士气，并使我方人伐单位免疫眩晕{mc_arg9}回合 
-define(CONST_SKILL_MC_926,                         926).% 攻击对方目标单位，技能威力系数{mc_arg1}%，动手后提升所有单位{mc_arg2}点士气，使我方天泽单位免疫眩晕{mc_arg9}回合 
-define(CONST_SKILL_MC_981,                         981).% 效果-战斗开始时，额外增加自身arg1点士气 
-define(CONST_SKILL_MC_982,                         982).% 效果-动手后提升自身力量攻击力arg1%和灵力攻击力arg2%，持续arg3次数，下回合生效 
-define(CONST_SKILL_MC_983,                         983).% 效果-动手后回复自身最大气血的arg1% 
-define(CONST_SKILL_MC_984,                         984).% 效果-动手后降低对方arg1点士气 
-define(CONST_SKILL_MC_985,                         985).% 效果-动手后将造成伤害的arg1%转化为自身气血 
-define(CONST_SKILL_MC_986,                         986).% 效果-动手后提升自身力量防御力arg1%和灵力防御力arg2%，持续arg3次数，下回合生效 
-define(CONST_SKILL_MC_987,                         987).% 兵器技-动手时有arg1%概率打出双倍伤害 

-define(CONST_SKILL_USE_SKILL,                      2).% 类型--使用中 

-define(CONST_SKILL_STAR_LAST_ONE,                  616).% 星阵图结束点-1 
-define(CONST_SKILL_STAR_LAST_TWO,                  716).% 星阵图结束点-2 
-define(CONST_SKILL_STAR_LAST_THREE,                816).% 星阵图结束点-3 

%% ==========================================================
%% 新手卡
%% ==========================================================
-define(CONST_CARD_PAY_MULTIPLE,                    3).% 首充礼包倍数 

%% ==========================================================
%% 称号
%% ==========================================================
-define(CONST_TITLE_TEAM,                           5).% 称号类型-团队 
-define(CONST_TITLE_NAME_WORDS_LIMIT,               7).% 称号字符限制 

-define(CONST_TITLE_FLAG_DELETE,                    0).% 删除称号 
-define(CONST_TITLE_FLAG_ADD,                       1).% 增加称号 

-define(CONST_TITLE_STATE_UNUSE,                    0).% 称号不使用 
-define(CONST_TITLE_STATE_USE,                      1).% 使用称号 

-define(CONST_TITLE_SYSTEM,                         1).% 称号类型-系统 
-define(CONST_TITLE_ACHIEVE,                        2).% 称号类型-成就 
-define(CONST_TITLE_RANK,                           3).% 称号类型-排行 
-define(CONST_TITLE_CLAN,                           4).% 称号类型-家族 

%% ==========================================================
%% 防沉迷
%% ==========================================================
-define(CONST_FCM_NORMAL,                           0).% 防沉迷状态-正常(非沉迷状态) 
-define(CONST_FCM_HALF,                             1).% 防沉迷状态-收益减半 
-define(CONST_FCM_NOTHING,                          2).% 防沉迷状态-收益为0 

-define(CONST_FCM_ERROR_VALUE,                      3).% 防沉迷-时间沉余(秒) 
-define(CONST_FCM_TIP_INTERVAL,                     900).% 防沉迷-超出5小时，每15分钟提示一次 

%% ==========================================================
%% 反馈
%% ==========================================================
-define(CONST_FB_BAD,                               0).% 反馈-失败 
-define(CONST_FB_OK,                                1).% 反馈-成功 

-define(CONST_FB_TYPE_BUG,                          1).% 类型-bug 
-define(CONST_FB_TYPE_SUGGEST,                      2).% 类型-建议 
-define(CONST_FB_TYPE_COMPLAINT,                    3).% 类型-投诉 

%% ==========================================================
%% 素材
%% ==========================================================
-define(CONST_MATERIAL_SKIN_ROBOT,                  2).% 皮肤-机器人 
-define(CONST_MATERIAL_SKIN_PET,                    3).% 皮肤-庞物 
-define(CONST_MATERIAL_SKIN_MOUNT,                  4).% 皮肤-浮云(坐骑) 
-define(CONST_MATERIAL_SKIN_WEAPON,                 5).% 皮肤-武器 
-define(CONST_MATERIAL_SKIN_ARMOR,                  6).% 皮肤-衣服 
-define(CONST_MATERIAL_FASHION,                     7).% 时装 

-define(CONST_MATERIAL_ICON_SYSTEM,                 -2).% 图标-系统 
-define(CONST_MATERIAL_ICON_SKILL,                  -1).% 图标-技能 
-define(CONST_MATERIAL_ICON_EQUI,                   1).% 图标-装备 
-define(CONST_MATERIAL_ICON_WEAPON,                 2).% 图标-武器 
-define(CONST_MATERIAL_ICON_FUN,                    3).% 图标-功能 
-define(CONST_MATERIAL_ICON_NORMAL,                 4).% 图标-普通 
-define(CONST_MATERIAL_ICON_TASK,                   5).% 图标-任务 

%% ==========================================================
%% 签到
%% ==========================================================
-define(CONST_SIGN_TYPE_PLAIN,                      0).% 玩家类型--普通 
-define(CONST_SIGN_TYPE_VIP,                        1).% 玩家类型--vip 
-define(CONST_SIGN_START,                           102210).% 开启签到需完成的任务ID 

-define(CONST_SIGN_VIPLV,                           3).% Vip玩家签到所需的VIP等级 
-define(CONST_SIGN_TIM_MAX,                         3).% 连续签到的最大天数 

-define(CONST_SIGN_VIP_OK,                          0).% VIP玩家已签到 
-define(CONST_SIGN_VIP_NO,                          1).% VIP玩家未签到 

-define(CONST_SIGN_NO,                              0).% 普通玩家未领取奖励 
-define(CONST_SIGN_OK,                              1).% 普通玩家已领取奖励 

%% ==========================================================
%% NPC
%% ==========================================================
-define(CONST_NPC_FUN_DEPOT,                        1).% 酒吧 
-define(CONST_NPC_FUN_SHOP,                         3).% 商店 
-define(CONST_NPC_FUN_PREFEREN_SHOP,                4).% 优惠商店 
-define(CONST_NPC_FUN_COPY_TEAM,                    8).% 进入副本（组队） 
-define(CONST_NPC_FUN_GEM,                          15).% 灵珠镶嵌 
-define(CONST_NPC_FUN_MALL,                         16).% 打开商场 
-define(CONST_NPC_FUN_TAVERN,                       17).% 进入旅馆 
-define(CONST_NPC_FUN_NIANSHOU,                     18).% 打开年兽 

-define(CONST_NPC_WAREHOUSE_ID,                     148).% 仓库NPC的ID 
-define(CONST_NPC_WAREHOUSE_SCENCE,                 40201).% 仓库NPC的场景ID 

%% ==========================================================
%% 打造
%% ==========================================================
-define(CONST_MAKE_STREN_LOW_JEW,                   0).% 强化下降固定等级(首饰) 
-define(CONST_MAKE_STREN_LOW_MAGIC,                 2).% 强化下降固定等级(法宝) 
-define(CONST_MAKE_STREN_LOW_WEA,                   4).% 强化下降固定等级(装备) 
-define(CONST_MAKE_BIPTIZE_COUNT_MAX,               6).% 附加最大条数 
-define(CONST_MAKE_STREN_DIS_COST,                  10).% 打折强化消耗金元 
-define(CONST_MAKE_STREN_DOU_COST,                  10).% 双倍强化消耗金元 
-define(CONST_MAKE_LV_INLAX,                        30).% 装备镶嵌等级 

-define(CONST_MAKE_MAGIC_UPGRADE_VIP,               1).% 法宝升阶需要vip等级 
-define(CONST_MAKE_MAGIC_UPGRADE_LOW,               1).% 法宝升阶强化等级降级 
-define(CONST_MAKE_MAGIC_UPGRADE_CLASS,             3).% 法宝升阶需要最低等阶 

-define(CONST_MAKE_WASH_TYPE_COMM,                  1).% 洗练类型--普通 
-define(CONST_MAKE_WASH_TYPE_FIXED,                 2).% 洗练类型--定向 
-define(CONST_MAKE_WASH_TYPE_SKILL,                 3).% 洗练类型--技能 
-define(CONST_MAKE_WASH_TYPE_MUL_COM,               4).% 洗练类型--批量普通 
-define(CONST_MAKE_WASH_TYPE_MUL_FIX,               5).% 洗练类型--批量定向 

-define(CONST_MAKE_WASH_COUNT,                      5).% 批量洗练次数 

-define(CONST_MAKE_COMPOSE_COMM,                    1).% 灵珠合成类型--普通 
-define(CONST_MAKE_COMPOSE_ONEKEY,                  2).% 灵珠合成类型--一键 

-define(CONST_MAKE_MAKE_UNKNOW,                     1).% 打造预览-未知 

-define(CONST_MAKE_STREN_DOUBLE_ODDS,               2000).% 双倍强化-概率 

-define(CONST_MAKE_INTENSIFY_LV_OPEN,               3).% 装备强化功能开启等级 
-define(CONST_MAKE_INLAY_LV_OPEN,                   15).% 装备镶嵌功能开启等级 
-define(CONST_MAKE_ENCHANTING_LV_OPEN,              30).% 装备附魔功能开启等级 

%% ==========================================================
%% 恶魔果实
%% ==========================================================

%% ==========================================================
%% 阵营
%% ==========================================================
-define(CONST_COUNTRY_WIND_MAP,                     10101).% 人地图ID 
-define(CONST_COUNTRY_FIRE_MAP,                     20101).% 仙地图ID 
-define(CONST_COUNTRY_CLOUD_MAP,                    30101).% 魔地图ID 
-define(CONST_COUNTRY_TASK_ID,                      100180).% 阵营任务ID 

-define(CONST_COUNTRY_RAND_GIFT,                    40071).% 听天由命礼包ID 

%% ==========================================================
%% 商城
%% ==========================================================
-define(CONST_MALL_ONE_DAY,                         8).% 开服第一天 
-define(CONST_MALL_TWO_DAY,                         9).% 开服第二天 
-define(CONST_MALL_THREE_DAY,                       10).% 开服第三天 
-define(CONST_MALL_LIMIT,                           999).% 无限购买次数 

-define(CONST_MALL_TYPE_NORMAL,                     0).% 商品属性--普通 
-define(CONST_MALL_TYPE_ONCE,                       1).% 商品属性--只能购买一次(永久) 

-define(CONST_MALL_TYPE_ID_ORDINARY,                10).% 商城类型--普通商店 
-define(CONST_MALL_TYPE_ID_DISCOUNT,                20).% 商城类型--优惠商店 
-define(CONST_MALL_TYPE_ID_YUQING,                  50).% 商城类型--玉清阁 
-define(CONST_MALL_TYPE_ID_CANGBAO,                 60).% 商城类型--藏宝阁 
-define(CONST_MALL_TYPE_ID_COLLECT,                 70).% 商城类型--集卡物品商店 
-define(CONST_MALL_TYPE_ID_PAY_POINT,               80).% 商城类型--消费积分商城 
-define(CONST_MALL_TYPE_SUB_DISCOUNT,               2020).% 每日特惠商店 
-define(CONST_MALL_TYPE_SUB_YUQING,                 5010).% 商城子类型--玉清阁 
-define(CONST_MALL_TYPE_SUB_CANGBAO,                6010).% 商城子类型--藏宝阁 
-define(CONST_MALL_TYPE_SUB_COLLECT,                7010).% 商城子类型--集卡物品商店 
-define(CONST_MALL_TYPE_SUB_PAY_POINT,              8010).% 商城子类型--消费积分商城 

-define(CONST_MALL_EXCHANGE_RATE,                   10000).% 消费积分兑换比率（万分比） 

-define(CONST_MALL_VIP_EFFECT,                      6).% VIP6商店优惠购买特权 

-define(CONST_MALL_SHOP_LV,                         10).% 商店按钮出现等级 

-define(CONST_MALL_TYPE_LV,                         1).% 附加属性类型-等级限制 
-define(CONST_MALL_TYPE_VIP,                        2).% 附加属性类型-VIP限制 
-define(CONST_MALL_TYPE_ODDS,                       3).% 附加属性类型--出现机率 

%% ==========================================================
%% 福利
%% ==========================================================
-define(CONST_WELFARE_NEWCARD,                      9).% (奖励领取类型)新手卡 
-define(CONST_WELFARE_NEWCARD_MEDIA,                10).% (奖励领取类型)媒体卡 

-define(CONST_WELFARE_REWARD_LOGIN,                 1).% (奖励领取类型)连续登陆 
-define(CONST_WELFARE_REWARD_CUMUL_DAY,             2).% (奖励领取类型)日累计在线 
-define(CONST_WELFARE_REWARD_CUMUL_WEEK,            3).% (奖励领取类型)周累计在线 
-define(CONST_WELFARE_REWARD_PAY_CUMUL,             4).% (奖励领取类型)充值累计 
-define(CONST_WELFARE_REWARD_PAY_LIMIT,             5).% (奖励领取类型)充值额度 
-define(CONST_WELFARE_REWARD_FIRST_CREATE,          6).% (奖励领取类型)首次创建人物倒计时 
-define(CONST_WELFARE_REWARD_CUMUL_ONLINE,          7).% (奖励领取类型)登陆在线倒计时 

-define(CONST_WELFARE_LIST_CONTINUE,                1).% (请求数据)登陆 
-define(CONST_WELFARE_LIST_CUMUL,                   2).% (请求数据)在线 
-define(CONST_WELFARE_LIST_PAY,                     3).% (请求数据)充值 
-define(CONST_WELFARE_LIST_EXP,                     4).% (请求数据)经验 
-define(CONST_WELFARE_LIST_YELLOW_DAY,              5).% (请求黄钻特权)每日面板 

-define(CONST_WELFARE_EXP_RECOVER,                  8).% (奖励领取类型)经验找回 

%% ==========================================================
%% 竞技场
%% ==========================================================
-define(CONST_ARENA_HEARSAY,                        0).% 广播类型-JJC信息 
-define(CONST_ARENA_EVENT,                          1).% 事件--竞技场 
-define(CONST_ARENA_HEARSAY_ONE,                    1).% 广播类型-排名第一传闻 
-define(CONST_ARENA_LOSE_TIME,                      3).% 挑战失败后的冷却时间（分钟） 
-define(CONST_ARENA_SHOW_ROLE,                      5).% jjc 显示人数 
-define(CONST_ARENA_NUM,                            10).% 取前10个挑战信息 
-define(CONST_ARENA_SURPLUS,                        10).% 每天竞技场战斗次数 
-define(CONST_ARENA_YES_ARENA,                      13).% 进入竞技场需要等级 
-define(CONST_ARENA_BATTLE_TIME,                    180).% 竞技场战斗时间 

-define(CONST_ARENA_FAST_RMB,                       1).% 消除冷却时间所需的钻石（每分钟） 
-define(CONST_ARENA_BUY_RMB,                        2).% 购买挑战次数所需的元宝（首次） 
-define(CONST_ARENA_BUY_MAX_TIMES,                  5).% 竞技场每天可购买次数 

-define(CONST_ARENA_STATA_1,                        1).% 状态--挑战成功 
-define(CONST_ARENA_STATA_2,                        2).% 状态--挑战失败 
-define(CONST_ARENA_STATA_3,                        3).% 状态--挑站排名不变 

-define(CONST_ARENA_SET_TYPE_2,                     2).% 类型-领取 
-define(CONST_ARENA_BUY,                            3).% 类型- 购买挑战 

-define(CONST_ARENA_WIN_LINK_10,                    10).% 连胜-终结连胜-10场 
-define(CONST_ARENA_WIN_LINK_50,                    50).% 连胜-终结连胜-50场 
-define(CONST_ARENA_WIN_LINK_100,                   100).% 连胜-终结连胜-100场 
-define(CONST_ARENA_WIN_LINK_500,                   500).% 连胜-终结连胜-500场 
-define(CONST_ARENA_WIN_LINK_1000,                  1000).% 连胜-终结连胜-1000场 

-define(CONST_ARENA_WLV_EXP_ADD,                    5000).% 世界平均等级经验加成 

-define(CONST_ARENA_THE_ARENA_ID,                   50020).% 竞技场场景ID 

-define(CONST_ARENA_SENCE_LEFT_Y,                   150).% 竞技场左"y" 
-define(CONST_ARENA_SENCE_RIGHT_Y,                  150).% 竞技场右"y" 
-define(CONST_ARENA_SENCE_LEFT_X,                   200).% 竞技场左"x" 
-define(CONST_ARENA_RIGHT_X,                        900).% 竞技场右"x" 

-define(CONST_ARENA_ATTR_HP_TIMES,                  5).% 战斗时增加气血倍数 

%% ==========================================================
%% 广播
%% ==========================================================
-define(CONST_BROAD_MAX_PLAYER,                     30).% 广播每次最大人数 

-define(CONST_BROAD_PLAYER_NAME,                    1).% 广播字段类型--角色名字 
-define(CONST_BROAD_CLAN_NAME,                      2).% 广播字段类型--家族名字 
-define(CONST_BROAD_GROUP_NAME,                     3).% 广播字段类型--团队名字 
-define(CONST_BROAD_COPY_ID,                        4).% 广播字段类型--副本Id 
-define(CONST_BROAD_PLAYER_NAME_NEW,                5).% 广播字段类型--角色名字（有职业） 
-define(CONST_BROAD_STRING,                         50).% 广播字段类型--普通字符串 
-define(CONST_BROAD_NUMBER,                         51).% 广播字段类型--普通数字 
-define(CONST_BROAD_MAPID,                          52).% 广播字段类型--地图ID 
-define(CONST_BROAD_COUNTRYID,                      53).% 广播字段类型--阵营ID 
-define(CONST_BROAD_GOODSID,                        54).% 广播字段类型--物品ID 
-define(CONST_BROAD_MONSTERID,                      55).% 广播字段类型--怪物ID 
-define(CONST_BROAD_CIRCLE_CHAP,                    56).% 广播字段类型--三界杀卷名ID 
-define(CONST_BROAD_REWARD,                         57).% 广播字段类型--奖励内容 
-define(CONST_BROAD_PILROAD_ID,                     58).% 广播字段类型--取经之路名字 
-define(CONST_BROAD_NAME_COLOR,                     59).% 广播字段类型--颜色 
-define(CONST_BROAD_STARID,                         60).% 广播字段类型--星阵图名字 
-define(CONST_BROAD_PARTNER_ID,                     61).% 广播字段类型--伙伴名字 
-define(CONST_BROAD_DOUQI_ID,                       62).% 广播字段类型--斗气ID 
-define(CONST_BROAD_VIP_LV,                         63).% 广播字段类型--VIP等级 

-define(CONST_BROAD_ID_SERVER_CLOSE,                1010).% 系统-停服 
-define(CONST_BROAD_ID_SERVER_OPEN,                 1020).% 系统-开服 
-define(CONST_BROAD_ID_TALISMAN,                    2010).% 打造神器—紫色和金色神器 
-define(CONST_BROAD_ID_ARENA_10,                    3010).% 竞技场—连胜10次以上 
-define(CONST_BROAD_ID_ARENA_20,                    3020).% 竞技场—连胜20次以上 
-define(CONST_BROAD_ID_ARENA_30,                    3030).% 竞技场—连胜30次以上 
-define(CONST_BROAD_ID_ARENA_50,                    3040).% 竞技场—连胜50次以上 
-define(CONST_BROAD_ID_ARENA_100,                   3050).% 竞技场—连胜100次以上 
-define(CONST_BROAD_ID_ARENA_S_10,                  3060).% 竞技场—终结10次以上的连胜 
-define(CONST_BROAD_ID_ARENA_ONE,                   3070).% 竞技场—第一名更换 
-define(CONST_BROAD_INN_RECRUIT,                    4010).% 客栈—邀请伙伴 
-define(CONST_BROAD_ID_WORLD_START,                 5010).% 三界BOSS—活动提前通告 
-define(CONST_BROAD_ID_WORLD_REY,                   5020).% 三界BOSS—活动开启准备 
-define(CONST_BROAD_ID_WORLD_SHOW,                  5030).% 三界BOSS—BOSS出现 
-define(CONST_BROAD_ID_WORLD_DIE,                   5040).% 三界BOSS—BOSS被击杀 
-define(CONST_BROAD_ID_WORLD_END,                   5050).% 三界BOSS—活动结束通告 
-define(CONST_BROAD_COMPREHEND_GOLDEN_ORANGE,       6010).% 领悟金色和橙色斗气 
-define(CONST_BROAD_VIP_5,                          6020).% 获得VIP5或以上 
-define(CONST_BROAD_TOP_PRIZE,                      6030).% 每日一箭获得至尊大奖 
-define(CONST_BROAD_ID_INN_CARD,                    6040).% 成功使用伙伴卡—不知火舞 
-define(CONST_BROAD_COPY_HERO,                      7010).% 首次通过各个精英副本 
-define(CONST_BROAD_COPY_FREND,                     7020).% 首次通关各个魔王副本 
-define(CONST_BROAD_COPY_CAREER,                    7030).% 首次通过拳皇生涯各个副本 

-define(CONST_BROAD_AREA_MULTIPLE,                  1).% 区 -  综合频道 
-define(CONST_BROAD_AREA_WORLD,                     2).% 区 - 世界频道 
-define(CONST_BROAD_AREA_CLAN,                      3).% 区 -  帮派频道 
-define(CONST_BROAD_AREA_PRIVATE,                   4).% 区 - 私聊频道 
-define(CONST_BROAD_AREA_SUPER,                     5).% 区 - 超级公告(跑马灯) 
-define(CONST_BROAD_AREA_SUPER_MULTIPLE,            6).% 区 - 综合频道+超级公告 

-define(CONST_BROAD_ID_INN_JING,                    10021).% 成功使用伙伴卡—不知火舞 

%% ==========================================================
%% 酒馆
%% ==========================================================
-define(CONST_INN_MONEY_ADD,                        10).% 银币增加友好度 
-define(CONST_INN_BAND_RMB_ADD,                     12).% 绑定元宝增加友好度 

-define(CONST_INN_BLUE_KNIFE,                       1).% 蓝色 
-define(CONST_INN_VIOLET_KNIFE,                     2).% 紫色 
-define(CONST_INN_GOLDEN_KNIFE,                     3).% 金色 

-define(CONST_INN_BLUE_BOX,                         11).% 蓝色宝箱 
-define(CONST_INN_VIOLET_BOX,                       12).% 紫色宝箱 
-define(CONST_INN_GOLDEN_BOX,                       13).% 金色宝箱 

-define(CONST_INN_LV_RANGE_FIRST,                   1).% 等级段-25-69 
-define(CONST_INN_LV_RANGE_MID,                     2).% 等级段-70-79 
-define(CONST_INN_LV_RANGE_AFTER,                   3).% 等级段-80-89 

-define(CONST_INN_WINE_COST,                        30).% 单次奉酒消耗金元 
-define(CONST_INN_WINE_CASH,                        1500000).% 二狗头酒少于70级消耗-150万 
-define(CONST_INN_WINE_HIGHER_CASH,                 3000000).% 大于等于70级银元消耗-300万 

-define(CONST_INN_DRINK_TYPE,                       0).% 奉酒 
-define(CONST_INN_DRINK_TYPE2,                      1).% 一键奉酒 

-define(CONST_INN_STATA0,                           0).% 伙伴状态-已招募 
-define(CONST_INN_STATA1,                           1).% 伙伴状态-可招募 
-define(CONST_INN_STATA2,                           2).% 伙伴状态-休息中 
-define(CONST_INN_STATA3,                           3).% 伙伴状态-出战中 

-define(CONST_INN_DRINK_LV_LINE,                    70).% 酒留仙等级分界点-70级 

-define(CONST_INN_OPERATION0,                       0).% 伙伴操作-离队 
-define(CONST_INN_OPERATION1,                       1).% 伙伴操作-归队 
-define(CONST_INN_OPERATION2,                       2).% 伙伴操作-出战 
-define(CONST_INN_OPERATION3,                       3).% 伙伴操作-休息 
-define(CONST_INN_OPERATION4,                       4).% 伙伴操作-招募 

-define(CONST_INN_RECRUIT_LV,                       7).% 招募按钮可点击等级 

-define(CONST_INN_PARTNER_WU,                       10051).% 不知火舞伙伴 

%% ==========================================================
%% 日志
%% ==========================================================
-define(CONST_LOGS_TYPE_CURRENCY,                   1).% type常量--虚拟物品（金钱类::CONST_CURRENCY_XX） 
-define(CONST_LOGS_TYPE_GOODS,                      2).% type常量--实体物品（装备类） 
-define(CONST_LOGS_TYPE_ATTR,                       3).% type常量--属性改变::CONST_ATTR_XX 
-define(CONST_LOGS_TYPE_BUFF,                       4).% type常量--BUFF改变::CONST_WAR_PLUS_XXX 
-define(CONST_LOGS_TYPE_DOUQI,                      5).% type常量--斗气物品 

-define(CONST_LOGS_DEL,                             0).% state状态--失去、减少、下降 
-define(CONST_LOGS_ADD,                             1).% state状态--获得、增加、上升 

-define(CONST_LOGS_1001,                            1001).% 恭喜你达到15级&#13;赶紧去使用15级礼包吧 
-define(CONST_LOGS_1002,                            1002).% 恭喜你达到20级&#13;赶紧去使用20级礼包吧 
-define(CONST_LOGS_1003,                            1003).% 恭喜你达到25级&#13;赶紧去使用25级礼包吧 
-define(CONST_LOGS_1004,                            1004).% 恭喜你达到30级&#13;赶紧去使用30级礼包吧 
-define(CONST_LOGS_1005,                            1005).% 恭喜你达到40级&#13;赶紧去使用40级礼包吧 
-define(CONST_LOGS_1006,                            1006).% 恭喜你达到50级&#13;赶紧去使用50级礼包吧 
-define(CONST_LOGS_1101,                            1101).% 每天12点、18点获得50额外体力&#13;赶紧去挑战吧 
-define(CONST_LOGS_1106,                            1106).% 接受精英副本任务&#13;迎接更强挑战吧！ 
-define(CONST_LOGS_1111,                            1111).% 有伙伴加入社团，赶快去审核吧！ 
-define(CONST_LOGS_1116,                            1116).% 升级成功 
-define(CONST_LOGS_1117,                            1117).% 你的活跃度达到了$等奖励，赶快领取吧！ 
-define(CONST_LOGS_2009,                            2009).% 新伙伴需要上阵才能帮助你战斗哦！ 
-define(CONST_LOGS_2010,                            2010).% 主人$心情好大赦天下，你终于自由了，赶紧谢恩吧！ 
-define(CONST_LOGS_2012,                            2012).% 你被$抓走了，你成为了TA的苦工，命苦哇！ 
-define(CONST_LOGS_2013,                            2013).% $不堪忍受你的折磨，想要反抗你，可惜他还是太嫩了！ 
-define(CONST_LOGS_2014,                            2014).% $不堪忍受你的折磨，鼓起勇气反抗了你，现在TA自由了！ 
-define(CONST_LOGS_2015,                            2015).% $不堪忍受你的折磨向大侠$求救，他那花拳绣腿怎是你的对手？ 
-define(CONST_LOGS_2016,                            2016).% $不堪忍受你的折磨向大侠$求救，矮油那货太厉害了你还是跑吧！ 
-define(CONST_LOGS_2017,                            2017).% $在给财神上香时顺手帮你的财神也上了一柱，感谢他吧！ 
-define(CONST_LOGS_2019,                            2019).% 恭喜，声望提升到#级！快去看看新增的属性吧！ 
-define(CONST_LOGS_2020,                            2020).% 你的精力不足，请先购买精力！ 
-define(CONST_LOGS_2021,                            2021).% 你的VIP体验已过期，成为VIP可享受更多特权！ 
-define(CONST_LOGS_2024,                            2024).% 你获得了新装备，立即使用可增强战斗力！ 
-define(CONST_LOGS_2025,                            2025).% 应付对方人伐阵位猛烈攻击，可以招募使用眩晕对方技能的伙伴！ 
-define(CONST_LOGS_2026,                            2026).% 应付对方天泽阵位的眩晕控制，可以招募使用眩晕对方技能的伙伴！ 
-define(CONST_LOGS_2027,                            2027).% 应付控制较强的敌人，可以使用提高抗性技能 
-define(CONST_LOGS_2028,                            2028).% 你现在可以打造等级更高的装备了！ 
-define(CONST_LOGS_2029,                            2029).% 你现在可以打造品质更好的法宝了！ 
-define(CONST_LOGS_2030,                            2030).% $邀请你并肩挑战取经之路[$]，是否接受邀请？ 
-define(CONST_LOGS_2031,                            2031).% 一大批英雄慕名而来，想与你结交好友！ 
-define(CONST_LOGS_2032,                            2032).% 提升增加战斗力，招募更强伙伴! 
-define(CONST_LOGS_2033,                            2033).% $开启了帮派Boss$，社团的兄弟们一起来消灭它吧 
-define(CONST_LOGS_CLAN_BOSS_KILLER,                2034).%  $在帮派Boss战役中奋力一击 #，成功击杀了BOSS $ ，成为咱帮的帮派英雄。 
-define(CONST_LOGS_NO_MAILS,                        2035).% 你的邮箱没有收到任何邮件哦！ 
-define(CONST_LOGS_NEW_CLAN_MEMBER,                 2036).% 有小弟加入社团，赶快去处理吧！ 
-define(CONST_LOGS_7000,                            7000).% 战斗失败，赶紧去增强实力吧 

-define(CONST_LOGS_END_ID,                          8000).% ---------------------------------玩家离线需保存的日志--填写大于8000的常量值 

-define(CONST_LOGS_8001,                            8001).% $在竞技场挑战你失败&#13;你的排名不变 
-define(CONST_LOGS_8002,                            8002).% $在竞技场挑战你成功&#13;你的排名下降到第#名 
-define(CONST_LOGS_8004,                            8004).% 你有新邮件，请注意查收！ 
-define(CONST_LOGS_8005,                            8005).% 恭喜，[$]社团已通过你的申请！ 

%% ==========================================================
%% 副本
%% ==========================================================
-define(CONST_COPY_TYPE_NORMAL,                     1).% 副本类型-普通副本 
-define(CONST_COPY_TYPE_HERO,                       2).% 副本类型-英雄副本 
-define(CONST_COPY_TYPE_FIEND,                      3).% 副本类型-魔王副本 
-define(CONST_COPY_TYPE_FIGHTERS,                   4).% 副本类型-拳皇生涯 
-define(CONST_COPY_TYPE_CLAN,                       5).% 副本类型-帮派副本 

-define(CONST_COPY_STATE_READY,                     1).% 副本状态--准备 
-define(CONST_COPY_STATE_PLAY,                      2).% 副本状态--进行中 
-define(CONST_COPY_STATE_PAUSE,                     3).% 副本状态--暂停 
-define(CONST_COPY_STATE_OVER,                      4).% 副本状态--完成 
-define(CONST_COPY_STATE_STOP,                      5).% 副本状态--停止 
-define(CONST_COPY_STATE_TIMEOUT,                   6).% 副本状态--时间到 

-define(CONST_COPY_PASS_NORMAL,                     1).% 副本通关类型--普通 
-define(CONST_COPY_PASS_TIME,                       2).% 副本通关类型--限时 
-define(CONST_COPY_PASS_COMBO,                      3).% 副本通关类型--连击 
-define(CONST_COPY_PASS_ALIVE,                      4).% 副本通关类型--生存 
-define(CONST_COPY_PASS_BOSS,                       5).% 副本通关类型--击杀BOSS 

-define(CONST_COPY_WAY_WHOLE,                       1).% 玩法-全部刷怪 
-define(CONST_COPY_WAY_PART,                        2).% 玩法-部分刷怪 

-define(CONST_COPY_HERO_BASE,                       1).% 英雄副本基数(可打次数等于已通关乘基数) 
-define(CONST_COPY_FIEND_OPEN_EVA,                  3).% 魔王副本开启评价(相应的英雄副本的评价) 
-define(CONST_COPY_EVA_WHOLE,                       3).% 副本满星评价 
-define(CONST_COPY_CHEST_NUM,                       3).% 副本宝箱数量 

-define(CONST_COPY_TIMING_START,                    1).% 副本计时--开始 
-define(CONST_COPY_TIMING_STOP,                     2).% 副本计时--停止 

-define(CONST_COPY_WAR_ROUND_MIN,                   1).% 战斗最少回合数 
-define(CONST_COPY_WAR_ROUND_MAX,                   6).% 战斗最多回合数 

-define(CONST_COPY_OVER_ENERGY,                     1).% 通关副本消耗精力 
-define(CONST_COPY_UP_ENERGY,                       1).% 挂机一轮消耗精力 

-define(CONST_COPY_INTERVAL_SECONDS,                1).% 副本检查时间间隔(单位秒) 
-define(CONST_COPY_TIME_SLOT,                       100).% 副本时间间隔,清理一次,没人关闭进程(秒) 

-define(CONST_COPY_EVA_C,                           1).% 副本评价--C级 
-define(CONST_COPY_EVA_B,                           2).% 副本评价--B级 
-define(CONST_COPY_EVA_A,                           3).% 副本评价--A级 

-define(CONST_COPY_UP_TIME,                         1).% 挂机一次的时间(秒) 
-define(CONST_COPY_SPEED_RMB,                       1).% 挂机加速每分钟消耗钻石 
-define(CONST_COPY_NORMAL_CD,                       1).% 普通副本挂机冷却时间-60秒 
-define(CONST_COPY_UP_EVA,                          2).% 挂机奖励评价 
-define(CONST_COPY_HERO_CD,                         120).% 英雄副本挂机冷却时间-120秒 
-define(CONST_COPY_FIEND_CD,                        180).% 魔王副本挂机冷却时间-180秒 

-define(CONST_COPY_MAX_FRESH_BUY_TIMES,             20).% 英雄魔王最大刷新购买次数 

-define(CONST_COPY_SCORE_HITS,                      1).% 副本评分类型--无损 
-define(CONST_COPY_SCORE_TIME,                      2).% 副本评分类型--时间 
-define(CONST_COPY_SCORE_CAROM,                     3).% 副本评分类型--连击 
-define(CONST_COPY_SCORE_KILL,                      4).% 副本评分类型--杀敌 
-define(CONST_COPY_SCORE_REWARD,                    5).% 副本评分类型--奖励 

-define(CONST_COPY_UPTYPE_NORMAL,                   1).% 挂机完成类型--正常 
-define(CONST_COPY_UPTYPE_VIP,                      2).% 挂机完成类型--VIP 
-define(CONST_COPY_UPTYPE_SPEED,                    3).% 挂机完成类型--加速 
-define(CONST_COPY_UPTYPE_BAG_FULL,                 4).% 挂机完成类型--背包已满 

-define(CONST_COPY_SWEEP_LV_OPEN,                   10).% 挂机功能开启 
-define(CONST_COPY_HERO_LV_OPEN,                    20).% 精英副本开放等级 
-define(CONST_COPY_FIEND_LV_OPEN,                   25).% 魔王副本开放等级 

-define(CONST_COPY_FIRST_COPY,                      50001).% 初次进入游戏副本 

-define(CONST_COPY_FIRST_SCENE,                     50001).% 初次战斗场景 

-define(CONST_COPY_AUTO_EXIT,                       3).% 副本通过后自行退出界面时间（秒） 

-define(CONST_COPY_HP_UP_ONE,                       1).% 1人怪物血量提升倍数 
-define(CONST_COPY_HP_UP_TWO,                       1.2).% 2人怪物血量提升倍数 
-define(CONST_COPY_HP_UP_THREE,                     1.4).% 3人怪物血量提升倍数 

%% ==========================================================
%% 布阵
%% ==========================================================
-define(CONST_ARRAY_POSITION_FRONT,                 1).% 阵位-地坤（前军） 
-define(CONST_ARRAY_POSITION_MIDDLE,                2).% 阵位-人伐（中军） 
-define(CONST_ARRAY_POSITION_BACK,                  3).% 阵位-天泽（后军） 

-define(CONST_ARRAY_ADDITION_ATTR_BONUS,            1).% 伤害率加成 
-define(CONST_ARRAY_ADDITION_HP_MAX,                2).% 气血加成 
-define(CONST_ARRAY_ADDITION_RESUMEHP,              3).% 恢复气血加成 
-define(CONST_ARRAY_ADDITION_SPEED,                 4).% 速度加成 
-define(CONST_ARRAY_ADDITION_REDUCTION,             5).% 免伤率加成 

-define(CONST_ARRAY_DOWN_HAEM,                      6000).% 地坤伤害值(万分比) 

%% ==========================================================
%% 坐骑
%% ==========================================================
-define(CONST_MOUNT_MIN_STAR,                       0).% 坐骑最低星级 
-define(CONST_MOUNT_GET_LV,                         1).% 坐骑系统要求等级 
-define(CONST_MOUNT_MAX_STAR,                       10).% 坐骑最高星级 
-define(CONST_MOUNT_END_MOUNTID,                    50008).% 最高等阶坐骑ID 

-define(CONST_MOUNT_PROP_STRONG,                    1).% 仙果增加属性-物攻，物防 
-define(CONST_MOUNT_PROP_MAGIC,                     2).% 仙果增加属性-法攻，法防 
-define(CONST_MOUNT_PROP_ATT_SPEED,                 3).% 仙果增加属性-速度 
-define(CONST_MOUNT_PROP_HP,                        4).% 仙果增加属性-气血 

-define(CONST_MOUNT_MODE_GOLD,                      1).% 培养方式-普通培养 
-define(CONST_MOUNT_MODE_RMB,                       2).% 培养方式-金元培养 
-define(CONST_MOUNT_MODE_PROP,                      3).% 培养方式-道具培养 

-define(CONST_MOUNT_BEGIN_LV,                       0).% 初始化-坐骑等级 
-define(CONST_MOUNT_BEGIN_MOUNTID,                  50001).% 初始化-坐骑ID 
-define(CONST_MOUNT_START_TASKID,                   102610).% 开放坐骑任务ID 

-define(CONST_MOUNT_PROP_NUMBER,                    1).% 坐骑培养-消耗道具 
-define(CONST_MOUNT_CULTURE_RMB,                    10).% 培养坐骑-消耗金元 
-define(CONST_MOUNT_CULTRUE_GOLD,                   15000).% 培养坐骑-消耗银元 
-define(CONST_MOUNT_PROP_ID,                        42001).% 培养坐骑-道具物品ID 

-define(CONST_MOUNT_STATUS_USING,                   0).% 幻化状态-使用中 
-define(CONST_MOUNT_STATUS_LIUSION,                 1).% 幻化状态-已开启幻化过但使用 
-define(CONST_MOUNT_STATUS_NOLIUSION,               2).% 幻化状态-开启但从未幻化过 

-define(CONST_MOUNT_RESULT_EXP,                     1).% 坐骑培养结果-得到经验 
-define(CONST_MOUNT_RESULT_DART,                    2).% 坐骑培养结果-突进 
-define(CONST_MOUNT_RESULT_BREACH,                  3).% 坐骑培养结果-突破 

%% ==========================================================
%% 帮派
%% ==========================================================
-define(CONST_CLAN_TIME_OUTCLAN,                    1).% 离帮再进帮会时间限制(H) 
-define(CONST_CLAN_COUNT_SECOND,                    3).% 副帮主数量 
-define(CONST_CLAN_JOIN_MAX_CALL,                   5).% 同时申请加入帮派的上限数 
-define(CONST_CLAN_TITLE_MAX,                       6).% 帮派名称最大字数 
-define(CONST_CLAN_RANK_COUNT,                      7).% 帮派列表单页显示数量 
-define(CONST_CLAN_EVENT_COUNT_MAX,                 10).% 最大日志数 
-define(CONST_CLAN_CREATE_COST,                     10).% 创建帮派花费银元(万) 
-define(CONST_CLAN_NEW_CLAN_MAX,                    10).% 初始化帮派最大成员上限 
-define(CONST_CLAN_LV_LIMIT,                        20).% 创建帮派等级限制 
-define(CONST_CLAN_NOTICE_MAX,                      40).% 帮派公告最大字数 

-define(CONST_CLAN_POST_OUT,                        0).% 职位-踢出帮派 
-define(CONST_CLAN_POST_COMMON,                     1).% 职位-平民 
-define(CONST_CLAN_POST_SECOND,                     2).% 职位-副帮主 
-define(CONST_CLAN_POST_MASTER,                     3).% 职位-帮主 

-define(CONST_CLAN_MSG_TYPE_INVITE,                 0).% 通知类型--邀请入帮 
-define(CONST_CLAN_MSG_TYPE_AUDIT,                  1).% 通知类型--入帮审核 
-define(CONST_CLAN_MSG_TYPE_OUT,                    2).% 通知类型--踢出帮派 
-define(CONST_CLAN_MAG_TYPE_JOIN,                   3).% 通知类型--请求入帮 

-define(CONST_CLAN_EVENT_JOIN,                      1).% 日志类型- $加入帮派 
-define(CONST_CLAN_EVENT_OUT,                       2).% 日志类型- $退出本帮派 
-define(CONST_CLAN_EVENT_POST_DOWN,                 3).% 日志类型- $被$贬为庶民 
-define(CONST_CLAN_EVENT_POST_UP,                   4).% 日志类型- $被帮主升为副帮主 
-define(CONST_CLAN_EVENT_TRANS,                     5).% 日志类型- $将帮主之位让贤给了$ 
-define(CONST_CLAN_EVENT_KICK,                      6).% 日志类型- $被$踢出帮派 
-define(CONST_CLAN_EVENT_NOTICE,                    7).% 日志类型- $修改了公告 
-define(CONST_CLAN_APPLY_JOIN,                      8).% 日志类型- $请求加入社团 
-define(CONST_CLAN_EVENT_YQSJS,                     10).% 日志类型- $与帮派招财猫互动，获得体能#，帮派贡献增长了# 

-define(CONST_CLAN_ACTIVE_CAT,                      1001).% 帮派活动--招财猫 
-define(CONST_CLAN_ACTIVE_CLANBOSS,                 1002).% 帮派活动--帮派BOSS 
-define(CONST_CLAN_ACTIVE_COPY,                     1003).% 帮派活动--帮派副本 
-define(CONST_CLAN_ACTIVE_TRAIN,                    1004).% 帮派活动--帮派训练 

-define(CONST_CLAN_CLAN_LV_LIMIT,                   1).% 开启等级--招财猫 
-define(CONST_CLAN_CLAN_BOSS_LIMIT_LV,              2).% 开启等级--帮派BOSS 
-define(CONST_CLAN_COPY_LV,                         2).% 开启等级--帮派副本 

-define(CONST_CLAN_BOSS_RANK_COUNT,                 10).% 伤害排行榜玩家个数 
-define(CONST_CLAN_RELIVE_TIME,                     60).% 玩家死亡后复活等待时间（S） 
-define(CONST_CLAN_CLAN_BOSS_SPEND,                 100).% 开启帮派BOSS的花费（钻） 
-define(CONST_CLAN_BOSS_TIME,                       1800).% 帮派Boss时长（s） 
-define(CONST_CLAN_BOSS_MAPID,                      50010).% 帮派BOSS场景 

-define(CONST_CLAN_CAT_TIMES,                       1).% 每日免费招财次数 

-define(CONST_CLAN_BOSS_SCENE,                      50050).% 社团BOSS场景 

%% ==========================================================
%% 财神
%% ==========================================================
-define(CONST_WEAGOD_FREE_TIMES,                    2).% 招财免费次数 
-define(CONST_WEAGOD_VIP0,                          3).% VIP0招财次数 
-define(CONST_WEAGOD_AUTO_VIP,                      6).% 开启自动招财VIP等级 
-define(CONST_WEAGOD_OPEN_LV,                       12).% 开通等级 
-define(CONST_WEAGOD_PL_TIMES,                      20).% 批量招财次数 

-define(CONST_WEAGOD_SINGLE_TYPE,                   1).% 单次招财成功返回类型 
-define(CONST_WEAGOD_PL_TYPE,                       2).% 批量招财成功返回类型 
-define(CONST_WEAGOD_AUTO_TYPE,                     3).% 自动招财成功返回类型 

%% ==========================================================
%% 声望
%% ==========================================================
-define(CONST_RENOWN_BEGIN_LV,                      1).% 初始化等级 
-define(CONST_RENOWN_STEP_LV,                       22).% 不消耗每日声望等级 
-define(CONST_RENOWN_MAX_LV,                        37).% 最大声望等级 

%% ==========================================================
%% 精力
%% ==========================================================
-define(CONST_ENERGY_EXTRA,                         0).% 初始化精力类型 
-define(CONST_ENERGY_ZERO,                          0).% 精力清0 
-define(CONST_ENERGY_ADD,                           5).% 每半小时增加精力值 
-define(CONST_ENERGY_BEGIN,                         200).% 初始化精力 
-define(CONST_ENERGY_MAX,                           200).% 精力上限 
-define(CONST_ENERGY_DELAY,                         1800).% 自动恢复精力时间 

-define(CONST_ENERGY_BUY_BASE,                      1).% 非VIP玩家可购买精力的次数 
-define(CONST_ENERGY_BUY_NUM,                       10).% 购买成功增加精力数 
-define(CONST_ENERGY_BUY_RMB,                       20).% 购买一次精力需花费金元数 

-define(CONST_ENERGY_REQUEST_TYPE,                  0).% 购买精力类型--前端请求 
-define(CONST_ENERGY_RETRUN_TYPE,                   1).% 购买精力类型--后端触发 

-define(CONST_ENERGY_GET_GOODS,                     48086).% 点击获得体力道具 

%% ==========================================================
%% 店铺
%% ==========================================================
-define(CONST_SHOP_LV1,                             30).% 装配店铺等级 
-define(CONST_SHOP_LV2,                             31).% 宝石店铺等级 

%% ==========================================================
%% 抓苦工
%% ==========================================================
-define(CONST_MOIL_ACTIVE_COUNT,                    5).% 每日互动次数 
-define(CONST_MOIL_PROTEST_COUNT,                   5).% 每日反抗次数 
-define(CONST_MOIL_CALLS_COUNT,                     5).% 每日求救次数 
-define(CONST_MOIL_CAPTRUE_COUNT,                   10).% 每日抓捕次数 

-define(CONST_MOIL_FUNCTION_CATCH,                  1).% 抓苦工 
-define(CONST_MOIL_FUNCTION_HELP,                   2).% 解救苦工 
-define(CONST_MOIL_FUNCTION_INTER,                  3).% 互动 
-define(CONST_MOIL_FUNCTION_DRAW,                   4).% 压榨苦工 
-define(CONST_MOIL_FUNCTION_REVOLT,                 5).% 反抗 
-define(CONST_MOIL_FUNCTION_ASKHELP,                6).% 求救 
-define(CONST_MOIL_FUNCTION_SNATCH,                 7).% 夺扑之敌 

-define(CONST_MOIL_ID_HOST,                         1).% 身份-主人 
-define(CONST_MOIL_ID_MOIL,                         2).% 身份-苦工 
-define(CONST_MOIL_ID_FREEMAN,                      3).% 身份-酱油党 
-define(CONST_MOIL_ID_H_M,                          4).% 身份-主人兼苦工 

-define(CONST_MOIL_PRESS,                           1).% 压榨类型-压榨 
-define(CONST_MOIL_PRESS_2,                         2).% 压榨类型-提取 
-define(CONST_MOIL_PRESS_3,                         3).% 压榨类型-抽干 

-define(CONST_MOIL_MOIL_COUNT,                      3).% 苦工最大拥有数量 

-define(CONST_MOIL_PRESS_RMB_USE,                   10).% 压榨1小时消耗金元 
-define(CONST_MOIL_CATCH_MAX,                       10).% 购买抓捕次数上限 
-define(CONST_MOIL_CATCH_RMB_USE,                   10).% 购买一次抓捕消耗金元 

%% ==========================================================
%% 功能开放
%% ==========================================================
-define(CONST_FUNC_OPEN_FUNTION,                    10000).% 功能键 
-define(CONST_FUNC_OPEN_RECHARGE,                   10001).% 充值 
-define(CONST_FUNC_OPEN_CHAPER_SHOP,                10009).% 优惠商店 
-define(CONST_FUNC_OPEN_SHOP,                       10010).% 开放功能-商店 
-define(CONST_FUNC_OPEN_TASK_GUIDE,                 10011).% 开放功能-任务指引 
-define(CONST_FUNC_OPEN_ROLE,                       10012).% 人物 
-define(CONST_FUNC_OPEN_MAIN_TASK,                  10013).% 任务 
-define(CONST_FUNC_OPEN_SYSTEM,                     10014).% 1级-功能开放-系统设置 
-define(CONST_FUNC_OPEN_MALL,                       10020).% 开放功能-商城 
-define(CONST_FUNC_OPEN_CHATTING,                   10030).% 开放功能-聊天 
-define(CONST_FUNC_OPEN_BAG,                        10040).% 开放功能-背包 
-define(CONST_FUNC_OPEN_MAIL,                       10050).% 开放功能-邮件 
-define(CONST_FUNC_OPEN_SENCE,                      10060).% 开放功能-普通副本 
-define(CONST_FUNC_OPEN_SKILL,                      10070).% 3级-10022-技能学习与强化 
-define(CONST_FUNC_OPEN_STRENGTHEN,                 10080).% 5级-10041-强化 
-define(CONST_FUNC_OPEN_STRENGTHEN_SECOND,          10081).% 功能开放-二次强化 
-define(CONST_FUNC_OPEN_PARTNER,                    10090).% 10级-10081-酒吧-伙伴招募 
-define(CONST_FUNC_OPEN_AI,                         10100).% 15级-10123-AI/托管 
-define(CONST_FUNC_OPEN_COMPOSE,                    10101).% 18级-10151-合成（宝石） 
-define(CONST_FUNC_OPEN_FRIEND,                     10110).% 19级-10161-好友 
-define(CONST_FUNC_OPEN_ELITE,                      10120).% 20级-10171-精英副本 
-define(CONST_FUNC_OPEN_TEAM,                       10130).% 20级-10173-组队 
-define(CONST_FUNC_OPEN_INLAY,                      10140).% 22级-10182-每日登录 
-define(CONST_FUNC_OPEN_LISTS,                      10150).% 25级-10211-竞技场 
-define(CONST_FUNC_OPEN_MONEYTREE,                  10160).% 23级-10191-招财 
-define(CONST_FUNC_OPEN_MOIL,                       10170).% 27级-10232-苦工 
-define(CONST_FUNC_OPEN_COMPETITION,                10180).% 28级-10242-切磋 
-define(CONST_FUNC_OPEN_GUILD,                      10190).% 28级-10241-社团 
-define(CONST_FUNC_OPEN_DEVIL,                      10200).% 55级-10263-魔宠 
-define(CONST_FUNC_OPEN_BOSS,                       10210).% 21级-10181-世界BOSS 
-define(CONST_FUNC_OPEN_STRENGTH,                   10220).% 32级-10281-日常任务 
-define(CONST_FUNC_OPEN_ACTIVE,                     10230).% 35级-10311-活跃度玩法 
-define(CONST_FUNC_OPEN_GUILDWAR,                   10240).% 35级-10313-帮派战 
-define(CONST_FUNC_OPEN_GAMBLE,                     10250).% 33级-10291-翻翻乐 
-define(CONST_FUNC_OPEN_WEAPON,                     10260).% 35级-10311-每日一箭 
-define(CONST_FUNC_OPEN_ELIMINATE,                  10270).% 1级-精彩活动 
-define(CONST_FUNC_OPEN_GUILDMOVE,                  10280).% 40级-10363-社团活动 
-define(CONST_FUNC_OPEN_ANSWER,                     10290).% 40级-10364-多人在线答题 
-define(CONST_FUNC_OPEN_STAR,                       10300).% 40级-10361-斗气 
-define(CONST_FUNC_OPEN_OVERCOME,                   10310).% 50级-10461-拳皇生涯 
-define(CONST_FUNC_OPEN_PEOPLESMONEYTREE,           10320).% 50级-10463-多人摇钱树 
-define(CONST_FUNC_OPEN_PET,                        10330).% 50级-10464-宠物 
-define(CONST_FUNC_OPEN_ACHIEVEMENT,                10340).% 60级-10562-目标 
-define(CONST_FUNC_OPEN_COMMONWAR,                  10350).% 60级-10563-阵营战 
-define(CONST_FUNC_OPEN_JEWELLERY,                  10360).% 45级-10411-珍宝 
-define(CONST_FUNC_OPEN_MOUNT,                      10370).% 70级-坐骑 
-define(CONST_FUNC_OPEN_PASSAGE,                    10380).% 80级-经脉 
-define(CONST_FUNC_OPEN_ARTIFACT,                   10390).% 50级-10461-神器 

-define(CONST_FUNC_OPEN_ENERGY_TIME,                20001).% 12点18点赠送体力 

%% ==========================================================
%% 三界杀
%% ==========================================================
-define(CONST_CIRCLE_ENERGY,                        3).% 消耗精力 
-define(CONST_CIRCLE_RMB,                           50).% 重置消耗金元 
-define(CONST_CIRCLE_INIT,                          30001).% 三界杀初始化武将 

%% ==========================================================
%% vip
%% ==========================================================
-define(CONST_VIP_BAG_ADD_TWO,                      2).% VIP2增加背包 
-define(CONST_VIP_BAG_ADD_FIVE,                     5).% VIP5增加背包 
-define(CONST_VIP_BAG_ADD_SEVNE,                    7).% VIP7增加背包 

%% ==========================================================
%% 剧情
%% ==========================================================
-define(CONST_DRAMA_ACT_APPEAR,                     1).% 剧情类型-人物出现 
-define(CONST_DRAMA_ACT_DIALOGUE,                   2).% 剧情类型-人物对话 
-define(CONST_DRAMA_ACT_MOVE,                       3).% 剧情类型-人物移动 
-define(CONST_DRAMA_ACT_DISAPPEAR,                  4).% 剧情类型-人物消失 
-define(CONST_DRAMA_ACT_LEAVE,                      5).% 剧情类型-人物离开 
-define(CONST_DRAMA_ACT_REPLACE,                    6).% 剧情类型-剧情更换 
-define(CONST_DRAMA_ACT_EFFECT,                     7).% 剧情类型-播放特效 
-define(CONST_DRAMA_ACT_NORMAL_ATTACK,              8).% 剧情类型-普通攻击特效 
-define(CONST_DRAMA_ACT_UNIQUE_SKILL,               9).% 剧情类型-绝招攻击特效 
-define(CONST_DRAMA_ACT_DEATH,                      10).% 剧情类型-人物死亡 
-define(CONST_DRAMA_ACT_MEDITATION,                 11).% 剧情类型-人物打坐 
-define(CONST_DRAMA_ACT_NORMAL_STATE,               12).% 剧情类型-人物正常状态 
-define(CONST_DRAMA_ACT_SHOCK,                      13).% 剧情类型-震屏 

-define(CONST_DRAMA_GETINTO,                        1).% 触发条件-进入场景 
-define(CONST_DRAMA_FINISHE,                        2).% 触发条件-场景通关后 
-define(CONST_DRAMA_ENCOUNTER,                      3).% 触发条件-遇到指定BOSS 
-define(CONST_DRAMA_TRIGGER,                        4).% 触发条件-任务触发 
-define(CONST_DRAMA_DEFEAT,                         5).% 触发条件-打死指定BOSS 

%% ==========================================================
%% 活动
%% ==========================================================
-define(CONST_ACTIVITY_STATE_OVER,                  0).% 通用活动状态--活动结束 
-define(CONST_ACTIVITY_STATE_START,                 1).% 通用活动状态--活动开始 
-define(CONST_ACTIVITY_STATE_ENTRANCE,              2).% 通用活动状态--提前入场 
-define(CONST_ACTIVITY_STATE_ADVANCE,               3).% 通用活动状态--提前通知 
-define(CONST_ACTIVITY_STATE_SIGN,                  4).% 通用活动状态--提前报名 
-define(CONST_ACTIVITY_STATE_NOT_OPEN,              5).% 通用活动状态--未开始 
-define(CONST_ACTIVITY_DOLOOP_TIME,                 10).% doloop检查时间 

-define(CONST_ACTIVITY_TYPE_OPEN,                   0).% 活动类型--开服活动 
-define(CONST_ACTIVITY_TYPE_TIMES,                  1).% 活动类型--充值活动 
-define(CONST_ACTIVITY_TYPE_DAILY,                  2).% 活动类型--日常活动 
-define(CONST_ACTIVITY_TYPE_RANK,                   4).% 活动类型--集体活动 

-define(CONST_ACTIVITY_WORLD_BOSS,                  3001).% 活动ID--世界Boss 
-define(CONST_ACTIVITY_WRESTLE_YUSAI,               3002).% 活动ID--格斗之王预赛 
-define(CONST_ACTIVITY_WRESTLE,                     3003).% 活动ID--格斗之王决赛 
-define(CONST_ACTIVITY_WORLD_BOSS_TWO,              3004).% 活动ID--世界BOSS2 
-define(CONST_ACTIVITY_ID_CLAN_WAR,                 4001).% 活动ID--帮派战 

-define(CONST_ACTIVITY_LINK_101,                    101).% 活跃度任务：一轮日常任务 
-define(CONST_ACTIVITY_LINK_102,                    102).% 活跃度任务：通关魔王副本 
-define(CONST_ACTIVITY_LINK_103,                    103).% 活跃度任务：通关精英副本 
-define(CONST_ACTIVITY_LINK_104,                    104).% 活跃度任务：世界BOSS 
-define(CONST_ACTIVITY_LINK_105,                    105).% 活跃度任务：竞技场 
-define(CONST_ACTIVITY_LINK_106,                    106).% 活跃度任务：招财 
-define(CONST_ACTIVITY_LINK_107,                    107).% 活跃度任务：领悟斗气 
-define(CONST_ACTIVITY_LINK_108,                    108).% 活跃度任务：翻翻乐 
-define(CONST_ACTIVITY_LINK_109,                    109).% 活跃度任务：钻石刷新珍宝 
-define(CONST_ACTIVITY_LINK_110,                    110).% 活跃度任务：拳皇生涯 
-define(CONST_ACTIVITY_LINK_111,                    111).% 活跃度任务：每日一箭 

-define(CONST_ACTIVITY_MAIL_CLAN_BOSS,              1001).% 活动邮件--帮派BOSS 
-define(CONST_ACTIVITY_MAIL_WOLD_BOSS,              1002).% 活动邮件--世界BOSS 
-define(CONST_ACTIVITY_MAIL_KILL_BOSS,              1003).% 活动邮件-击杀BOSS 

%% ==========================================================
%% 目标任务
%% ==========================================================
-define(CONST_TARGET_TASK,                          1).% 类型-完成主线任务(任务ID) 
-define(CONST_TARGET_STRENG_EQUIP,                  2).% 类型-强化装备(到多少级) 
-define(CONST_TARGET_WEAGOD,                        3).% 类型-招财(次数) 
-define(CONST_TARGET_WEACEN,                        4).% 类型-上香(次数) 
-define(CONST_TARGET_RENOWN_LEVEL,                  5).% 类型-提升声望等级(到多少级) 
-define(CONST_TARGET_OVER_COPY,                     6).% 类型-副本通关(副本ID) 
-define(CONST_TARGET_CUL_MOUNT,                     7).% 类型-培养坐骑(次数) 
-define(CONST_TARGET_MAKE_EQUIP,                    8).% 类型-打造装备(次数) 
-define(CONST_TARGET_MOIL_EXP,                      9).% 类型-抓苦工、获取经验 
-define(CONST_TARGET_KILL_WUJIANG,                  10).% 类型-去三界杀杀武将(武将ID) 
-define(CONST_TARGET_WAR_ARENA,                     11).% 类型-去封神台挑战(次数) 

-define(CONST_TARGET_UNDONE,                        1).% 目标状态--未完成 
-define(CONST_TARGET_FINISH,                        2).% 目标状态--已完成 
-define(CONST_TARGET_REWARD,                        3).% 目标状态--已领取 

-define(CONST_TARGET_INIT_TASK,                     1).% 初始目标任务序号 
-define(CONST_TARGET_OPEN,                          100010).% 目标任务开启-任务ID 

%% ==========================================================
%% 世界BOSS
%% ==========================================================
-define(CONST_BOSS_ENJOY_LV,                        20).% 进入所需等级 

-define(CONST_BOSS_HUMAN_SENCE,                     50010).% 三界BOSS场景 

-define(CONST_BOSS_FORMULA_B,                       12).% 公式常量-b 
-define(CONST_BOSS_FORMULA_A,                       20).% 公式常量-a 

-define(CONST_BOSS_TIMES_RELIVE,                    30).% 世界BOSS复活次数 

-define(CONST_BOSS_CRIT_ADD_LIMIT,                  5000).% 暴击属性加成上限-50% 
-define(CONST_BOSS_ATTACK_ADD_LIMIT,                10000).% 攻击属性加成上限-100% 

-define(CONST_BOSS_SKIN,                            2020).% 三界BOSS皮肤 

-define(CONST_BOSS_SECURITY_X,                      50).% 安全区域X轴 

-define(CONST_BOSS_CLAN_BOSS_MAIL,                  1001).% 帮派BOSS奖励邮件 
-define(CONST_BOSS_WORLD_BOSS_MAIL,                 1002).% 世界BOSS奖励邮件 
-define(CONST_BOSS_WORLD_BOSS_KILLED,               1003).% 世界BOSS击杀邮件 

-define(CONST_BOSS_RELIVE_TIME,                     20).% 世界BOSS复活时间 

%% ==========================================================
%% 英雄副本
%% ==========================================================

%% ==========================================================
%% 界面事件
%% ==========================================================
-define(CONST_SURFACE_ANENERGIA,                    1001).% 精力不足 
-define(CONST_SURFACE_SKILL_DISRUPTING,             1006).% 破军技能 
-define(CONST_SURFACE_SKILL_SWIM,                   1011).% 眩晕技能 
-define(CONST_SURFACE_INSET_PANEL,                  1016).% 镶嵌面板 
-define(CONST_SURFACE_LV_UP,                        1021).% 等级提升 
-define(CONST_SURFACE_STAR,                         1026).% 星阵图 
-define(CONST_SURFACE_PARTNER,                      1031).% 伙伴信息 
-define(CONST_SURFACE_RENOWN,                       1036).% 声望提升 
-define(CONST_SURFACE_EQUIP_STRENGTHEN,             1041).% 强化装备 
-define(CONST_SURFACE_RECRUIT_PARTNER,              1046).% 招募伙伴 
-define(CONST_SURFACE_WAVE_MONEY,                   1051).% 招财 

%% ==========================================================
%% 仙旅奇缘
%% ==========================================================
-define(CONST_TASK_RAND_MAX_MOVE,                   6).% 前进或后退最大步数 
-define(CONST_TASK_RAND_FAST_COST,                  10).% 快速完成花费金元 
-define(CONST_TASK_RAND_MAX_ACCEPT,                 15).% 一天最大掷骰子次数 

-define(CONST_TASK_RAND_MOUNT,                      1).% 培养坐骑（次数） 
-define(CONST_TASK_RAND_STRENG,                     2).% 强化装备（次数） 
-define(CONST_TASK_RAND_WASH,                       3).% 洗练装备（次数） 
-define(CONST_TASK_RAND_ARENA,                      4).% 封神台（次数） 
-define(CONST_TASK_RAND_COPY,                       5).% 完成副本（次数） 
-define(CONST_TASK_RAND_INN_CONTEST,                6).% 客栈斗法（次数） 
-define(CONST_TASK_RAND_MONEY,                      7).% 招财（次数） 
-define(CONST_TASK_RAND_PRAY,                       8).% 帮好友上香（次数） 
-define(CONST_TASK_RAND_MOVE,                       9).% 移动 
-define(CONST_TASK_RAND_WAR,                        10).% 战斗 
-define(CONST_TASK_RAND_GIFT,                       11).% 礼物（直接获得奖励） 
-define(CONST_TASK_RAND_RANDOM,                     12).% 随机事件 

%% ==========================================================
%% 活动-保卫经书
%% ==========================================================
-define(CONST_DEFEND_BOOK_TIME_SI,                  0).% 开始时间-分 
-define(CONST_DEFEND_BOOK_TIME_SS,                  0).% 开始时间-秒 
-define(CONST_DEFEND_BOOK_TIME_SH,                  21).% 开始时间-时 

-define(CONST_DEFEND_BOOK_TIME_ES,                  0).% 结束时间-秒 
-define(CONST_DEFEND_BOOK_TIME_EH,                  21).% 结束时间-时 
-define(CONST_DEFEND_BOOK_TIME_EI,                  30).% 结束时间-分 

-define(CONST_DEFEND_BOOK_RANK_NUM,                 10).% 排行榜上可显示的玩家数 
-define(CONST_DEFEND_BOOK_MAX_PLAYERS,              100).% 单个防守圈内玩家个数上限 
-define(CONST_DEFEND_BOOK_MAPID,                    8050).% 目标活动地图ID 

-define(CONST_DEFEND_BOOK_KILL_TYPE_NO,             0).% 击杀类型Type--未击杀 
-define(CONST_DEFEND_BOOK_KILL_TYPE,                1).% 击杀类型Type--击杀 
-define(CONST_DEFEND_BOOK_KILL_TYPE_END,            2).% 击杀类型Type--击杀最后一只 

-define(CONST_DEFEND_BOOK_BRUSH_MONSTER,            10).% 杀死最后一只怪物后等待下波怪刷新的时间 
-define(CONST_DEFEND_BOOK_ADDRMB_RELIVE,            30).% 30次金元复活后每次复活消耗金元100个 
-define(CONST_DEFEND_BOOK_RELIVE_TIME,              60).% 玩家死亡后等待复活的时间（S） 

-define(CONST_DEFEND_BOOK_X_Y,                      1).% X_Y起始值 
-define(CONST_DEFEND_BOOK_MONSTERS_NUM,             5).% 每波怪物数量| Y轴最大值 
-define(CONST_DEFEND_BOOK_X,                        45).% 最大格数--X轴 

-define(CONST_DEFEND_BOOK_TIME_V,                   1).% 怪物走一步所用时间（s） 
-define(CONST_DEFEND_BOOK_WAR_BREAK,                3).% 子弹冷却时间 
-define(CONST_DEFEND_BOOK_BULLET_SPEED,             200).% 子弹移动的速度 

-define(CONST_DEFEND_BOOK_SAVE_REWARDS,             60).% 物品掉落保留时间(S) 

-define(CONST_DEFEND_BOOK_FORMULE_A,                50000).% 公式常量-a 

-define(CONST_DEFEND_BOOK_EXP_REWORD,               80).% 经验奖励常量 
-define(CONST_DEFEND_BOOK_MONEY_REWORD,             400).% 铜钱奖励常量 

-define(CONST_DEFEND_BOOK_LIMITS_LV,                30).% 可参于活动的玩家等级 

%% ==========================================================
%% 促销活动
%% ==========================================================
-define(CONST_SALES_TYPE_PAY_ONCE,                  1).% 活动类型--首充礼包 

-define(CONST_SALES_ID_PAY_ONCE,                    101).% 活动ID--首充礼包 
-define(CONST_SALES_ID_CDKEY,                       201).% 新手卡 
-define(CONST_SALES_ID_PAY_SINGLE,                  301).% 单笔充值 
-define(CONST_SALES_PAY_TOTAL,                      401).% 累计充值活动 
-define(CONST_SALES_PAY_TOTAL_TIME,                 501).% 累计充值活动(指定时间） 
-define(CONST_SALES_REACH_LV,                       601).% 冲级活动 
-define(CONST_SALES_KILL_ALMA,                      701).% 击杀精英 
-define(CONST_SALES_KILL_DEVILS,                    801).% 击杀魔王 
-define(CONST_SALES_FIGHT_GAS,                      901).% 领悟斗气 
-define(CONST_SALES_COLLECT_TREASURES,              1001).% 收集珍宝 
-define(CONST_SALES_ARENA_RANKING,                  1011).% 竞技排名 

%% ==========================================================
%% 人物Buff
%% ==========================================================
-define(CONST_BUFF_CLAN,                            1).% 帮派Buff ID 
-define(CONST_BUFF_WORLD_LV,                        2).% 世界等级Buff ID 
-define(CONST_BUFF_SKY_WAR,                         3).% 天宫之战Buff ID 

%% ==========================================================
%% 天宫之战
%% ==========================================================
-define(CONST_SKYWAR_ATTACK_COUNT,                  9).% 攻城帮派数 
-define(CONST_SKYWAR_REVIVE_TIME,                   60).% 复活时间(秒) 
-define(CONST_SKYWAR_PUNISH_SECOND,                 60).% 退出重进场景惩罚时间(秒) 
-define(CONST_SKYWAR_SCORE_BROAD_TIME,              5000).% 定时广播积分数据(毫秒) 
-define(CONST_SKYWAR_MAPID,                         8060).% 天宫之战地图 
-define(CONST_SKYWAR_KILL_BOSS_TIME,                30000).% 杀死守城大将缓冲时间(毫秒) 

-define(CONST_SKYWAR_BOSS_ID_OUT_START,             53001).% 外墙守城BOSS-起始ID 
-define(CONST_SKYWAR_BOSS_ID_OUT_END,               53100).% 外墙守城BOSS-结束ID 

-define(CONST_SKYWAR_BOSS_ID_IN_START,              53501).% 内墙守城boss-开始ID 
-define(CONST_SKYWAR_BOSS_ID_IN_END,                53600).% 内墙守城boss-结束ID 

-define(CONST_SKYWAR_REWORD_CONTRIBUTION,           1).% 个人奖励-帮贡常量 
-define(CONST_SKYWAR_FAIL_INTEGRAL,                 4).% 失败积分常量 
-define(CONST_SKYWAR_INTEGRAL_BOSS,                 7).% BOSS积分常量 
-define(CONST_SKYWAR_INTEGRAL,                      10).% 胜利积分常量 
-define(CONST_SKYWAR_REWORD_MONEY,                  1000).% 个人奖励-银元常量 
-define(CONST_SKYWAR_REWORD_EXP,                    2000).% 个人奖励-经验常量 
-define(CONST_SKYWAR_BOMB_HARM,                     3000).% 炸弹伤害常量 
-define(CONST_SKYWAR_INTEGRAL_BURN,                 10000).% 伤害常量 

-define(CONST_SKYWAR_CAMP_ATTACK,                   1).% 阵营--攻城方 
-define(CONST_SKYWAR_CAMP_DEFEND,                   2).% 阵营--守城方 

-define(CONST_SKYWAR_WALL_OUT,                      1).% 城墙--外墙 
-define(CONST_SKYWAR_WALL_IN,                       2).% 城墙--内墙 

-define(CONST_SKYWAR_HOLD_MONEY,                    5000).% 天宫之战守城银元奖励 
-define(CONST_SKYWAR_HOLD_EXPREWARD,                5000).% 天宫之战守城经验奖励 

%% ==========================================================
%% 挑战镜像(年兽)
%% ==========================================================
-define(CONST_MIRROR_ATTR_UP_TWO,                   12000).% 怪物提升百分比-120% 

-define(CONST_MIRROR_ATTR_UP_ONE,                   11000).% 怪物提升百分比-110% 

-define(CONST_MIRROR_BASE_EXP,                      1).% 基础经验奖励 
-define(CONST_MIRROR_BASE_POWER,                    100).% 基础战斗力 
-define(CONST_MIRROR_BASE_MONEY,                    200).% 基础银元奖励 

%% ==========================================================
%% 活动-钓鱼达人
%% ==========================================================
-define(CONST_FISHING_FISH_TIME_ONE,                300).% 钓一条鱼需花费的时间 
-define(CONST_FISHING_FISH_TIME_MAX,                1800).% 每场钓鱼共需花费的时间（s） 

-define(CONST_FISHING_LIMITS_LV,                    50).% 可参于活动的玩家等级 
-define(CONST_FISHING_CAST_GOLD,                    300).% 钓鱼需花费的银元数（万） 

-define(CONST_FISHING_ALL_FISH,                     0).% 一键收取 
-define(CONST_FISHING_GREEN_FISH,                   1).% 鱼品阶--绿 
-define(CONST_FISHING_BLUE_FISH,                    2).% 鱼品阶--蓝 
-define(CONST_FISHING_PURPLE_FISH,                  3).% 鱼品阶--紫 
-define(CONST_FISHING_GOLD_FISH,                    4).% 鱼品阶--金 

%% ==========================================================
%% 活动-龙宫寻宝
%% ==========================================================
-define(CONST_DRAGON_LIMITS_VIP_ONE,                2).% 寻宝VIP等级限制-一 
-define(CONST_DRAGON_LIMITS_VIP_TWO,                5).% 寻宝VIP等级限制-二 
-define(CONST_DRAGON_LIMITS_VIP_THREE,              8).% 寻宝VIP等级限制-三 

-define(CONST_DRAGON_TIMES_ONE,                     1).% 一键寻宝次数限制-一 
-define(CONST_DRAGON_TIMES_TWO,                     10).% 一键寻宝次数限制-二 
-define(CONST_DRAGON_TIMES_THREE,                   50).% 一键寻宝次数限制-三 
-define(CONST_DRAGON_TIMES_MAX,                     99).% 一键寻宝次数限制-最大次数 

-define(CONST_DRAGON_TREASURE_ID,                   47006).% 寻宝令物品ID 

-define(CONST_DRAGON_RMB,                           10).% 一次寻宝需花费的Rmb 

-define(CONST_DRAGON_LIMITS_LV,                     30).% 可参加活动的等级限制 

%% ==========================================================
%% 跨服战
%% ==========================================================
-define(CONST_OVER_SERVER_AUTO_APPLY,               9).% 自动报名VIP等级-9 
-define(CONST_OVER_SERVER_JOIN_LV,                  72).% 跨服战参加等级-72 

-define(CONST_OVER_SERVER_ADD_TIMES,                10).% 跨服战增加战斗次数-10 
-define(CONST_OVER_SERVER_BATTLE_TIMES,             18).% 跨服战战斗次数-18 

-define(CONST_OVER_SERVER_FINAL_ADD_TIMES,          10).% 巅峰之战增加战斗次数 
-define(CONST_OVER_SERVER_FINAL_TIMES,              15).% 巅峰之战战斗次数 

-define(CONST_OVER_SERVER_TITLE_LAST,               24).% 称号持续时间-24小时 

-define(CONST_OVER_SERVER_STRIDE_TYPR_1,            1).% 跨服数据类型--挑战信息 
-define(CONST_OVER_SERVER_STRIDE_TYPE_2,            2).% 跨服数据类型--三界排行榜 
-define(CONST_OVER_SERVER_STRIDE_TYPE_3,            3).% 跨服数据类型--巅峰排行榜 
-define(CONST_OVER_SERVER_STRIDE_TYPE_4,            4).% 跨服数据类型--巅峰挑战信息 
-define(CONST_OVER_SERVER_STRIDE_TYPE_5,            5).% 跨服数据类型--18为挑战信息 
-define(CONST_OVER_SERVER_STRIDE_TYPE_6,            6).% 跨服数据类型--越级挑战信息 

-define(CONST_OVER_SERVER_WAR_1,                    1).% 跨服挑战类型--常规挑战 
-define(CONST_OVER_SERVER_WAR_2,                    2).% 跨服挑战类型--越级挑战 
-define(CONST_OVER_SERVER_WAR_3,                    3).% 跨服挑战类型--巅峰挑战 

-define(CONST_OVER_SERVER_GROUP_1,                  1).% 跨服分组--新手组 
-define(CONST_OVER_SERVER_GROUP_2,                  2).% 跨服分组--青铜组 
-define(CONST_OVER_SERVER_GROUP_3,                  3).% 跨服分组--白银组 
-define(CONST_OVER_SERVER_GROUP_4,                  4).% 跨服分组--黄金组 
-define(CONST_OVER_SERVER_GROUP_5,                  5).% 跨服分组--钻石组 
-define(CONST_OVER_SERVER_GROUP_6,                  6).% 跨服分组--大师组 
-define(CONST_OVER_SERVER_GROUP_7,                  7).% 跨服分组--宗师组 

-define(CONST_OVER_SERVER_CENCI_1,                  1).% 跨服常规挑战层--1层 
-define(CONST_OVER_SERVER_CENCI_2,                  2).% 跨服常规挑战层--2层 
-define(CONST_OVER_SERVER_CENCI_3,                  3).% 跨服常规挑战层--3层 
-define(CONST_OVER_SERVER_CENCI_4,                  4).% 跨服常规挑战层--4层 
-define(CONST_OVER_SERVER_CENCI_5,                  5).% 跨服常规挑战层--5层 
-define(CONST_OVER_SERVER_CENCI_6,                  6).% 跨服常规挑战层--6层 

-define(CONST_OVER_SERVER_TITLE_1,                  1).% 跨服称号--黄金虎卫 
-define(CONST_OVER_SERVER_TITLE_2,                  2).% 跨服称号--玄武圣骑 
-define(CONST_OVER_SERVER_TITLE_3,                  3).% 跨服称号--朱雀圣骑 
-define(CONST_OVER_SERVER_TITLE_4,                  4).% 跨服称号--青龙圣卫 

-define(CONST_OVER_SERVER_ROLE_SUM_12,              12).% 跨服战匹配人数-12 
-define(CONST_OVER_SERVER_ROLE_SUM_18,              18).% 跨服战匹配人数--18 

%% ==========================================================
%% 御前科举
%% ==========================================================
-define(CONST_KEJU_TYPE_MEIRI,                      0).% type类型--每日答题 
-define(CONST_KEJU_TRUE,                            0).% 是否已经领取奖励 
-define(CONST_KEJU_TYPE_KEJU,                       1).% type类型--御前科举 
-define(CONST_KEJU_SECONDS,                         1).% 每日答题间隔10分钟 
-define(CONST_KEJU_RIGHT,                           1).% 答案正确与否 
-define(CONST_KEJU_YKEJU_SCORE,                     1).% 御前科举得分 
-define(CONST_KEJU_TIS,                             3).% 御前科举答题时间 
-define(CONST_KEJU_NUM,                             10).% 计算器 
-define(CONST_KEJU_RANK_NUM,                        10).% 御前科举排行前10名的玩家 
-define(CONST_KEJU_TIMES,                           15).% 御前科举答题间隔 
-define(CONST_KEJU_KNUM,                            15).% 御前科举题目数量 
-define(CONST_KEJU_YUQIANTIMES,                     43200).% 御前科举开放时间 

%% ==========================================================
%% 活动-阵营战
%% ==========================================================
-define(CONST_CAMPWAR_NOT_MATCH,                    0).% 不可匹配 
-define(CONST_CAMPWAR_TYPE_HUMAN,                   1).% 阵营类型--游龙图 
-define(CONST_CAMPWAR_MATCH,                        1).% 可以匹配 
-define(CONST_CAMPWAR_TYPE_FAIRY,                   2).% 阵营类型--御仙图 
-define(CONST_CAMPWAR_TYPE_MAGIC,                   3).% 阵营类型--惊刹图 

-define(CONST_CAMPWAR_TIMETYPE_BEFORE,              1).% 倒计时类型--提前入场倒计时 
-define(CONST_CAMPWAR_TIMETYPE_WAR_AFTER,           2).% 倒计时类型--战后整顿 
-define(CONST_CAMPWAR_TIMETYPE_MATCHING,            3).% 倒计时类型--匹配中 

-define(CONST_CAMPWAR_LIMITS_LV,                    40).% 阵营战开放等级 

-define(CONST_CAMPWAR_TIME_BATTLE,                  10).% 计时器--战后整顿时间（s） 
-define(CONST_CAMPWAR_TIME_MATCHING,                30).% 计时器--匹配战斗时长（s) 
-define(CONST_CAMPWAR_TIME_ALL,                     1800).% 计时器--活动总时长(s) 

-define(CONST_CAMPWAR_WINS_COUNT,                   3).% 连胜排行榜玩家数量 

-define(CONST_CAMPWAR_TYPE_NOWAR,                   0).% 战报类型--匹配失败 
-define(CONST_CAMPWAR_TYPE_WAR,                     1).% 战报类型--匹配成功 

-define(CONST_CAMPWAR_WARDATA_TYPE_SELF,            0).% 个人战报数据 
-define(CONST_CAMPWAR_WARDATA_TYPE_ALL,             1).% 所有战报数据 

-define(CONST_CAMPWAR_MSG_SELF,                     20).% 战报数量--个人战报 
-define(CONST_CAMPWAR_MSG_ALL,                      30).% 战报数量--全体战报 

%% ==========================================================
%% 阎王殿
%% ==========================================================
-define(CONST_KINGHELL_YYAF_NUM,                    1).% 语言安抚阎王次数 
-define(CONST_KINGHELL_OPEN_LEVEL,                  70).% 阎王殿开放等级 
-define(CONST_KINGHELL_DZ_KING,                     56059).% 地藏王ID 

-define(CONST_KINGHELL_CHALLENGE_OK,                1).% 阎王状态---挑战成功 
-define(CONST_KINGHELL_CHALLENGE_ING,               2).% 阎王状态---挑战中 

-define(CONST_KINGHELL_MONS_CHALLENGE_OK,           0).% 怪物状态---已经挑战 
-define(CONST_KINGHELL_MONS_CHALLENGE_ING,          1).% 怪物状态---可挑战 
-define(CONST_KINGHELL_NO_CHALLENGE,                2).% 怪物状态—不可挑战 

-define(CONST_KINGHELL_MONS_TYPE_KING,              1).% 怪物类型---阎王 
-define(CONST_KINGHELL_MONS_TYPE_WEN_KING,          2).% 怪物类型---文判官 
-define(CONST_KINGHELL_MONS_TYPE_WU_KING,           3).% 怪物类型---武判官 

%% ==========================================================
%% 公共数据表Key值
%% ==========================================================
-define(CONST_PUBLIC_KEY_CAMPWAR,                   1001).% 活动-阵营战 
-define(CONST_PUBLIC_KEY_DEFENDBOOK,                1002).% 活动-保卫经书 
-define(CONST_PUBLIC_KEY_YKEJU,                     1003).% 活动-御前科举 

-define(CONST_PUBLIC_KEY_CLANLIST_PAGE,             2001).% 功能-帮派 
-define(CONST_PUBLIC_KEY_TREASURE,                  2002).% 功能-藏宝阁 
-define(CONST_PUBLIC_KEY_ENERGY,                    2003).% 功能-精力 
-define(CONST_PUBLIC_KEY_ALL_ACTIVE,                2004).% 功能-活动界面状态数据 
-define(CONST_PUBLIC_KEY_ACTIVE_CONFIG,             2005).% 功能-活动配置数据暂存 
-define(CONST_PUBLIC_KEY_KEY_SHOOT,                 2006).% 功能-每日一箭 
-define(CONST_PUBLIC_KEY_FUNS_STATE,                2007).% 功能-功能开放控制 
-define(CONST_PUBLIC_KEY_TITLE,                     2008).% 功能-称号数据 

-define(CONST_PUBLIC_KEY_MALL,                      3001).% 商店-打折商店 

%% ==========================================================
%% 魔王副本
%% ==========================================================

%% ==========================================================
%% 战斗相关
%% ==========================================================
-define(CONST_BATTLE_STATUS_IDLE,                   1).% 站立 
-define(CONST_BATTLE_STATUS_MOVE,                   2).% 移动 
-define(CONST_BATTLE_STATUS_HURT,                   3).% 受击 
-define(CONST_BATTLE_STATUS_FALL,                   4).% 倒地 
-define(CONST_BATTLE_STATUS_CRASH,                  5).% 击飞 
-define(CONST_BATTLE_STATUS_JUMP,                   6).% 跳跃 
-define(CONST_BATTLE_STATUS_JUMPATTACK,             7).% 跳跃普通攻击 
-define(CONST_BATTLE_STATUS_DEAD,                   8).% 死亡 
-define(CONST_BATTLE_STATUS_USESKILL,               9).% 使用技能力 

-define(CONST_BATTLE_BUFF_THRUST,                   1).% 自身推力 
-define(CONST_BATTLE_BUFF_SILENCE,                  2).% 沉默 
-define(CONST_BATTLE_BUFF_ENDUCE,                   3).% 霸体 
-define(CONST_BATTLE_BUFF_INVINCIBLE,               4).% 无敌 
-define(CONST_BATTLE_BUFF_LOCKX,                    5).% 锁定X 
-define(CONST_BATTLE_BUFF_LOCKY,                    6).% 锁定Y 
-define(CONST_BATTLE_BUFF_LOCKZ,                    7).% 锁定Z 
-define(CONST_BATTLE_BUFF_RIGIDITY,                 8).% 使目标僵值,受击 
-define(CONST_BATTLE_BUFF_CRASH,                    9).% 使目标击飞 
-define(CONST_BATTLE_BUFF_SPEEDADD,                 10).% 自身速度加成 
-define(CONST_BATTLE_BUFF_BLEED,                    11).% 流血状态 
-define(CONST_BATTLE_BUFF_SPRINT,                   12).% 冲刺  只作标识用 
-define(CONST_BATTLE_BUFF_VIBRATE,                  13).% 震动屏幕 
-define(CONST_BATTLE_BUFF_ENDUCE_FOREVER,           14).% 永久霸体 
-define(CONST_BATTLE_BUFF_HANGIN,                   15).% 悬空 

-define(CONST_BATTLE_JUMP_THRUST,                   1000).% 跳跃推力 
-define(CONST_BATTLE_JUMP_ACCELERATION,             2500).% 跳跃加速度 

-define(CONST_BATTLE_FORMULA_F,                     0.1).% 战斗公式常量-F 
-define(CONST_BATTLE_FORMULA_E,                     0.1).% 战斗公式常量-E 
-define(CONST_BATTLE_FORMULA_B,                     1).% 战斗公式常量-b 
-define(CONST_BATTLE_FORMULA_A,                     1).% 战斗公式常量-a 
-define(CONST_BATTLE_FORMULA_C,                     1.5).% 战斗公式常量-C 
-define(CONST_BATTLE_FORMULA_D,                     1.5).% 战斗公式常量-D 

-define(CONST_BATTLE_COMBO_TIME,                    2).% 有效连击时间(秒) 

-define(CONST_BATTLE_HOST_HIT_SP,                   1).% 攻击命中回蓝点数 
-define(CONST_BATTLE_PASSIVE_HIT_SP,                1).% 被攻击命中回蓝点数 

-define(CONST_BATTLE_DEAD_ANGLE,                    -80).% 站立死亡时弹起角度 
-define(CONST_BATTLE_DEAD_SPEED,                    600).% 站立死亡时弹起速度 
-define(CONST_BATTLE_DEAD_ACCELERATION,             2500).% 站立死亡时弹起的加速度 

-define(CONST_BATTLE_FLYCOLLIDER_1,                 1).% 飞行物穿透碰撞 
-define(CONST_BATTLE_FLYCOLLIDER_2,                 2).% 飞行物单次碰撞 

-define(CONST_BATTLE_RAND_TYPE_1,                   1).% 怪物随机-原地不动 
-define(CONST_BATTLE_RAND_TYPE_2,                   2).% 怪物随机-左右移动 
-define(CONST_BATTLE_RAND_TYPE_3,                   3).% 怪物随机-上下移动 
-define(CONST_BATTLE_RAND_TYPE_4,                   4).% 怪物移动-范围移动 

-define(CONST_BATTLE_END_SHOWDOWN,                  0.33).% 击杀boss慢镜头放慢倍数 
-define(CONST_BATTLE_END_SHOWTIME,                  1.2).% 击杀boss慢镜头放慢时间 

-define(CONST_BATTLE_DIE,                           1.8).% 人物死亡动画时间 

%% ==========================================================
%% 前端人物初始化相关
%% ==========================================================
-define(CONST_INIT_MOVE_CALL_BACK_TIME,             0.5).% 移动回调时间-发送服务端 
-define(CONST_INIT_COLLIDER_ID,                     1).% 初始人物碰撞ID 

-define(CONST_INIT_Y_ANGLE_MIN,                     60).% Y速度小夹角 
-define(CONST_INIT_Y_ANGLE_MAX,                     120).% Y速度大夹角 
-define(CONST_INIT_MOVE_Y_SPEED,                    200).% Y基础速度 
-define(CONST_INIT_MOVE_X_SPEED,                    500).% X基础速度 

%% ==========================================================
%% 提示界面
%% ==========================================================
-define(CONST_CUE_CHANGE,                           1).% 批量招财 
-define(CONST_CUE_FIGHTGAS,                         2).% 钻石领悟 

%% ==========================================================
%% 珍宝系统
%% ==========================================================
-define(CONST_TREASURE_DIFFERENCE,                  100).% 珍宝阁 
-define(CONST_TREASURE_ZERO,                        3600).% 倒计时为0 
-define(CONST_TREASURE_STORE_TREASURE_TIME,         3600).% 商店定时刷新时间 
-define(CONST_TREASURE_STORE_REFRESH_RMB,           80000).% 商店刷新消耗美刀 

-define(CONST_TREASURE_ONCE_MAKE_VIP,               6).% VIP6增加一键制作功能 

-define(CONST_TREASURE_OPEN_SECOND,                 40).% 珍宝第二层开放等级 
-define(CONST_TREASURE_OPEN_THIRD,                  50).% 珍宝第三层开放等级 
-define(CONST_TREASURE_OPEN_FOUR,                   60).% 珍宝第四层开放等级 
-define(CONST_TREASURE_OPEN_FIVE,                   70).% 珍宝第五层开放等级 
-define(CONST_TREASURE_OPEN_SIX,                    75).% 珍宝第六层开放等级 
-define(CONST_TREASURE_OPEN_SEVEN,                  80).% 珍宝第七层开放等级 
-define(CONST_TREASURE_OPEN_EIGHT,                  85).% 珍宝第八层开放等级 
-define(CONST_TREASURE_OPEN_NIGHT,                  90).% 珍宝第九层开放等级 
-define(CONST_TREASURE_OPEN_TEN,                    95).% 珍宝第十层开放等级 

-define(CONST_TREASURE_OPEN_MAX_LEVEL,              4).% 珍宝开放最高层数 

%% ==========================================================
%% 斗气系统
%% ==========================================================
-define(CONST_DOUQI_FREE_TIMES,                     0).% 每日免费领悟次数 
-define(CONST_DOUQI_VIP_LIMIT,                      3).% 开启金元领悟需要的VIP等级 
-define(CONST_DOUQI_ONEKEY_VIP,                     3).% 一键领悟所需的vip等级 
-define(CONST_DOUQI_SPLIT_COLOR,                    4).% 可分解的斗气颜色等级限制 
-define(CONST_DOUQI_MIN_GRASP_LV,                   101).% 美金最小领悟等级 
-define(CONST_DOUQI_MAX_GRASP_LV,                   105).% 美金最大领悟等级 
-define(CONST_DOUQI_RMB_GRASP_LV,                   106).% 钻石领悟等级 

-define(CONST_DOUQI_TYPE_STORAGE,                   0).% 领悟仓库类型 0 
-define(CONST_DOUQI_TYPE_BAG,                       1).% 装备仓库类型 1 
-define(CONST_DOUQI_DQLAN_NUM,                      8).% 装备栏个数 
-define(CONST_DOUQI_BAG,                            20).% 装备仓格子数 
-define(CONST_DOUQI_STORAGE_NUM,                    24).% 领悟仓格子数 

-define(CONST_DOUQI_LAN_START,                      1).% 斗气装备栏编号--开始 
-define(CONST_DOUQI_LAN_END,                        8).% 斗气装备栏编号--结束 
-define(CONST_DOUQI_BAG_START,                      9).% 装备仓格子编号--开始 
-define(CONST_DOUQI_BAG_END,                        28).% 装备仓格子编号--结束 
-define(CONST_DOUQI_STORAGE_START,                  29).% 领悟仓格子编号--开始 
-define(CONST_DOUQI_STORAGE_END,                    52).% 领悟仓格子编号--结束 

-define(CONST_DOUQI_STORAGE_TYPE_TEMP,              0).% 仓库类型--领悟仓 
-define(CONST_DOUQI_STORAGE_TYPE_EQUIP,             1).% 仓库类型--装备仓 
-define(CONST_DOUQI_STORAGE_TYPE_ROLE,              2).% 仓库类型--人物仓 

-define(CONST_DOUQI_GRASP_TYPE_RMB,                 0).% 领悟方式--钻石领悟 
-define(CONST_DOUQI_GRASP_TYPE_GOLD,                1).% 领悟方式--美金领悟 
-define(CONST_DOUQI_GRASP_TYPE_MORE,                2).% 领悟方式--美金一键领悟 

%% ==========================================================
%% 充值类活动
%% ==========================================================
-define(CONST_RECHARGE_SALES_FIRST_PREPAID,         101).% 首充活动ID 

%% ==========================================================
%% 日常任务
%% ==========================================================
-define(CONST_TASK_DAILY_INITVALUE,                 0).% 任务初始值 
-define(CONST_TASK_DAILY_ZERO,                      0).% 日常任务清零 
-define(CONST_TASK_DAILY_VIPZERO,                   0).% 任务刷新次数清零 
-define(CONST_TASK_DAILY_SETZERO,                   0).% 这一轮任务为0 
-define(CONST_TASK_DAILY_STRENGTH_EQUIP,            1).% 强化装备 
-define(CONST_TASK_DAILY_REFRESH_COPY,              2).% 刷副本 
-define(CONST_TASK_DAILY_DOUQI,                     3).% 领悟斗气 
-define(CONST_TASK_DAILY_LINK_COPYS,                4).% 连击副本 
-define(CONST_TASK_DAILY_ALL,                       10).% 日常任务次数 

-define(CONST_TASK_DAILY_REWARD_GOOD,               43221).% 日常任务一轮奖励-物品ID 

-define(CONST_TASK_DAILY_REFALSH_RMB_USE,           100).% 刷新一轮消耗钻石数目 

-define(CONST_TASK_DAILY_UNFINISH,                  0).% 未完成 
-define(CONST_TASK_DAILY_FINISH,                    1).% 当前任务完成 
-define(CONST_TASK_DAILY_ALLFINISH,                 2).% 这一轮任务已经完成 

-define(CONST_TASK_DAILY_ENTER_LV,                  23).% 日常任务进入等级 

-define(CONST_TASK_DAILY_FIRST_COUNT,               1).% 第一轮奖励 
-define(CONST_TASK_DAILY_SECOND_COUNT,              1.5).% 第二轮奖励 
-define(CONST_TASK_DAILY_THIRD_COUNT,               2).% 第三轮奖励 

-define(CONST_TASK_DAILY_FINISH_OPEN,               4).% 一键完成日常任务按钮开启 
-define(CONST_TASK_DAILY_ONE_FINISH,                5).% 日常任务一键完成消耗钻石 

%% ==========================================================
%% 风林山火
%% ==========================================================
-define(CONST_FLSH_PLAYER_COUNT,                    5).% 牌语数量--玩家拥有 
-define(CONST_FLSH_PAI_COUNT,                       6).% 牌语数量--所有 

-define(CONST_FLSH_FREE_SWITCH_TIMES,               1).% 每局免费换牌次数 
-define(CONST_FLSH_MIN_SZ,                          4).% 最低顺子 
-define(CONST_FLSH_GAME_TIMES,                      10).% 玩的次数--每天 

-define(CONST_FLSH_CHANGE_RMB_USE,                  2).% 换牌消耗钻石基数 

%% ==========================================================
%% 每日一箭
%% ==========================================================
-define(CONST_ARROW_DAILY_HISTORY,                  5).% 该区玩家获得的大奖信息保存总数 
-define(CONST_ARROW_DAILY_MIN_REWARD,               1000000).% 奖池最低奖励 

-define(CONST_ARROW_DAILY_FREE_TIMES,               2).% 免费射箭次数 
-define(CONST_ARROW_DAILY_BUY_LIMIT_TIMES,          10).% 每日可购买钻石次数上限 
-define(CONST_ARROW_DAILY_ADD_RMB_USE,              20).% 增加每日一箭消耗钻石基数 
-define(CONST_ARROW_DAILY_MONEY_UES,                10000).% 点击头像消耗美刀数 

-define(CONST_ARROW_DAILY_TYPE_GOLD,                4).% 免费抽取or美刀抽取 
-define(CONST_ARROW_DAILY_TYPE_RMB,                 5).% 钻石抽取 

-define(CONST_ARROW_DAILY_SUPREME_REWARD,           100).% 至尊大奖ID 

%% ==========================================================
%% 神器
%% ==========================================================
-define(CONST_MAGIC_EQUIP_LV_DOWN,                  3).% 神器升阶降低等级 
-define(CONST_MAGIC_EQUIP_STRENGTHEN_LV,            9).% 神器升阶需要强化等级 
-define(CONST_MAGIC_EQUIP_STRENGTHEN_MAX,           15).% 最高可以强化到的级别 
-define(CONST_MAGIC_EQUIP_STORY_STONE_ID,           37021).% 传说祝福石id 

-define(CONST_MAGIC_EQUIP_CLASS_STEP1,              1).% 神器阶层1 
-define(CONST_MAGIC_EQUIP_CLASS_STEP2,              2).% 神器阶层2 
-define(CONST_MAGIC_EQUIP_CLASS_STEP3,              3).% 神器阶层3 
-define(CONST_MAGIC_EQUIP_CLASS_STEP4,              4).% 神器阶层4 
-define(CONST_MAGIC_EQUIP_CLASS_STEP5,              5).% 神器阶层5 

-define(CONST_MAGIC_EQUIP_PRIMARY_STONE,            500).% 初级祝福石机率 
-define(CONST_MAGIC_EQUIP_MIDDLE_STONE,             1000).% 中级祝福石机率 
-define(CONST_MAGIC_EQUIP_SENIOR_STONE,             1500).% 高级祝福石机率 
-define(CONST_MAGIC_EQUIP_EPIC_STONE,               2000).% 史诗祝福石机率 
-define(CONST_MAGIC_EQUIP_STORY_STONE,              2500).% 传说祝福石机率 

-define(CONST_MAGIC_EQUIP_PRIMARY_PROTECT,          37501).% 初级保护石id 
-define(CONST_MAGIC_EQUIP_MIDDLE_PROTECT,           37506).% 中级保护石id 
-define(CONST_MAGIC_EQUIP_SENTOR_PROTECT,           37511).% 高级保护石id 
-define(CONST_MAGIC_EQUIP_EPIC_PROTECT,             37516).% 史诗保护石id 
-define(CONST_MAGIC_EQUIP_STORY_PROTECT,            37521).% 传说保护石id 

-define(CONST_MAGIC_EQUIP_STEP1_MALL_ID,            43).% 神器阶层1商品id 
-define(CONST_MAGIC_EQUIP_STEP2_MALL_ID,            44).% 神器阶层2商品id 
-define(CONST_MAGIC_EQUIP_STEP3_MALL_ID,            45).% 神器阶层3商品id 
-define(CONST_MAGIC_EQUIP_STEP4_MALL_ID,            46).% 神器阶层4商品id 
-define(CONST_MAGIC_EQUIP_STEP5_MALL_ID,            47).% 神器阶层5商品id 

-define(CONST_MAGIC_EQUIP_GOD_OPENLV,               35).% 神器按钮可按等级 

-define(CONST_MAGIC_EQUIP_EXCHANGE_MAT,             1030).% 神器商店-碎片兑换 
-define(CONST_MAGIC_EQUIP_EXCHANGE_DIAMOND,         1040).% 神器商店-钻石兑换 

%% ==========================================================
%% 活动-格斗之王
%% ==========================================================
-define(CONST_WRESTLE_FAIL,                         0).% 报名失败 
-define(CONST_WRESTLE_SHANGBANQU,                   0).% 上半区 
-define(CONST_WRESTLE_XIABANQU,                     1).% 下半区 
-define(CONST_WRESTLE_SUCCESS,                      1).% 报名成功 
-define(CONST_WRESTLE_GROUNP_COUNT,                 2).% 默认分组数量 
-define(CONST_WRESTLE_ZHENGBA,                      2).% 拳皇争霸 
-define(CONST_WRESTLE_FINAL_COUNT,                  32).% 进入决赛的人数 
-define(CONST_WRESTLE_LV,                           40).% 格斗之王限制等级 
-define(CONST_WRESTLE_COUNT,                        64).% 参加比赛玩家人数 

-define(CONST_WRESTLE_FAIL_SCORE,                   1).% 失败一方获得分数 
-define(CONST_WRESTLE_SUCCESS_SCORE,                2).% 胜利一方获得分数 

-define(CONST_WRESTLE_NO_MATCH_UID,                 0).% 轮空uid的值 

-define(CONST_WRESTLE_DAJISHI_START,                1).% 活动离下场战斗开始倒计时type 
-define(CONST_WRESTLE_DAOJISHI_GUESS,               2).% 活动竞猜开始倒计时type 
-define(CONST_WRESTLE_DAOSHI_START_ING,             3).% 活动战斗进行时type 
-define(CONST_WRESTLE_BEFORE_TIME,                  60).% 活动首轮战斗开始倒计时 
-define(CONST_WRESTLE_ACTIVE_TIME,                  180).% 回合战斗时间 
-define(CONST_WRESTLE_ROUND_TIME,                   240).% 活动离下场战斗开始倒计时（轮空） 

-define(CONST_WRESTLE_GUESS_FAIL,                   0).% 竞猜失败 
-define(CONST_WRESTLE_GUESS_SUCCESS,                1).% 竞猜成功 
-define(CONST_WRESTLE_GUESS_NOT,                    2).% 没有参加竞猜 

-define(CONST_WRESTLE_YUSAIZHONG,                   0).% 预赛中 
-define(CONST_WRESTLE_YUSAIJIESU,                   1).% 预赛结束 
-define(CONST_WRESTLE_JUESAIJINGXINGZHONG,          2).% 决赛进行中 
-define(CONST_WRESTLE_JUESAIJIESHU,                 3).% 决赛结束 
-define(CONST_WRESTLE_ZHENGBASAIJINXINGZHONG,       4).% 争霸赛进行中 
-define(CONST_WRESTLE_NOT_START,                    5).% 比赛还没有开始 

-define(CONST_WRESTLE_PEBBLE,                       5000).% 竞技水晶数量 
-define(CONST_WRESTLE_KOF_SENCE,                    50040).% 格斗之王-场景常量 

%% ==========================================================
%% 邀请PK
%% ==========================================================
-define(CONST_INVITE_PK_SENCE,                      50030).% 邀请PK场景 

-define(CONST_INVITE_PK_LEFT,                       1).% 进入坐标-左 

-define(CONST_INVITE_PK_RIGHT,                      2).% 进入坐标-右 

%% ==========================================================
%% 拳皇生涯
%% ==========================================================
-define(CONST_FIGHTERS_UP_COPY_TIME,                1).% 挂机一个副本的时间(s) 
-define(CONST_FIGHTERS_CHALLENGE_TIMES,             3).% 每天总共挑战次数 

-define(CONST_FIGHTERS_UPNO,                        1).% 挂机状态-没有挂机 
-define(CONST_FIGHTERS_UPING,                       2).% 挂机状态-挂机中 
-define(CONST_FIGHTERS_UPOVER,                      3).% 挂机状态-挂机完成 

-define(CONST_FIGHTERS_TIMES_BUY_BASE,              10).% 购买挑战次数所需的钻石基数 
-define(CONST_FIGHTERS_TIMES_BUY_LIMIT,             10).% 挑战次数购买上限 

-define(CONST_FIGHTERS_DOOR_DELAY_TIME,             0.5).% 副本传送门出现延迟秒数 

-define(CONST_FIGHTERS_FREE_FRESH,                  1).% 免费重置次数 

%% ==========================================================
%% 排行版
%% ==========================================================
-define(CONST_TOP_TYPE_LV,                          1).% 排行版类型-等级 
-define(CONST_TOP_TYPE_ARENA,                       2).% 排行版类型-竞技场 
-define(CONST_TOP_TYPE_POWER,                       3).% 排行版类型-战斗力 

-define(CONST_TOP_RANK_20,                          24).% 各排行前20数据 

%% ==========================================================
%% 式神（宠物）
%% ==========================================================
-define(CONST_PET_RMB,                              10).% 高级修炼钻石基数 
-define(CONST_PET_OPEN_LV,                          35).% 魔宠模块开通等级 
-define(CONST_PET_SENIOR_TIMES,                     50).% 高级修炼次数 
-define(CONST_PET_MAX_LV,                           100).% 宠物最高等级 
-define(CONST_PET_GOODS_ID,                         54001).% 魔宠修炼道具id 

-define(CONST_PET_STATE_0,                          0).% 式神状态-可获得 
-define(CONST_PET_STATE_1,                          1).% 式神状态-已获得 
-define(CONST_PET_STATE_2,                          2).% 式神状态-可召唤 
-define(CONST_PET_STATE_3,                          3).% 式神状态-已召唤 

%% ==========================================================
%% 系统设置
%% ==========================================================
-define(CONST_SYS_SET_MUSIC_BG,                     101).% 设置背景音乐 
-define(CONST_SYS_SET_MUSIC,                        102).% 游戏音效 
-define(CONST_SYS_SET_SHOW_ROLE,                    103).% 屏蔽其他玩家 
-define(CONST_SYS_SET_ROLE_DATA,                    104).% 查看他人信息 
-define(CONST_SYS_SET_PK,                           105).% 允许切磋 
-define(CONST_SYS_SET_TEAM,                         106).% 允许接收组队 
-define(CONST_SYS_SET_MOBILE,                       107).% 设置手机系统消息是否弹出 
-define(CONST_SYS_SET_ENERGY,                       108).% 满体力提示 
-define(CONST_SYS_SET_GUIDE,                        109).% 是否跳过新手指引 

%% ==========================================================
%% 新手指引
%% ==========================================================
-define(CONST_NEW_GUIDE_NEW,                        1).% 初次进入游戏 
-define(CONST_NEW_GUIDE_DRAMA_PLOT,                 2).% 剧情对话后 
-define(CONST_NEW_GUIDE_ACCEPT_TASK,                3).% 接受任务 
-define(CONST_NEW_GUIDE_COMPLETE_TASK,              4).% 完成任务 
-define(CONST_NEW_GUIDE_COMPLETE_GUIDE,             5).% 完成指引 
-define(CONST_NEW_GUIDE_FUN_NOTIC,                  6).% 关闭功能开放提示界面时 

-define(CONST_NEW_GUIDE_PUSH_BUTTON,                1).% 指引方式-按钮 
-define(CONST_NEW_GUIDE_NPC,                        2).% 指引方式-NPC 
-define(CONST_NEW_GUIDE_COPY_TIPS_ENTER,            3).% 指引方式-副本TIPS进入按钮 
-define(CONST_NEW_GUIDE_GOOD_TIPS_USE,              4).% 指引方式-物品TIPS使用按钮 
-define(CONST_NEW_GUIDE_BAG_GOOD_BUTTON,            5).% 大背包里面的某个物品 
-define(CONST_NEW_GUIDE_COPY_TIPS_HANGUP,           6).% 指引方式-副本TIPS挂机按钮 
-define(CONST_NEW_GUIDE_HANGUP_BUTTON,              7).% 挂机界面-挂机按钮 
-define(CONST_NEW_GUIDE_FUNTION_BUTTON,             8).% 功能开放界面按钮 
-define(CONST_NEW_GUIDE_SPEED_BUTTON,               9).% 挂机界面-加速按钮 

-define(CONST_NEW_GUIDE_UP,                         1).% 方向-上 
-define(CONST_NEW_GUIDE_DOWN,                       2).% 方向-下 
-define(CONST_NEW_GUIDE_LEFT,                       3).% 方向-左 
-define(CONST_NEW_GUIDE_RIGHT,                      4).% 方向-右 

-define(CONST_NEW_GUIDE_SPECIAL_GOON,               1).% 无需等待-继续指引 
-define(CONST_NEW_GUIDE_SPECIAL_INITVIEW,           2).% 打开界面后继续指引 
-define(CONST_NEW_GUIDE_SPECIAL_MAINSCENE_COPY,     3).% 完成副本跳转到主场景继续指引 
-define(CONST_NEW_GUIDE_SPECIAL_FINISH,             4).% 整个指引结束 
-define(CONST_NEW_GUIDE_SPECIAL_GOBACK,             5).% 返回上个界面继续指引 

%% ==========================================================
%% 投资理财
%% ==========================================================
-define(CONST_PRIVILEGE_DAY,                        7).% 投资理财最大天数 
-define(CONST_PRIVILEGE_RMB,                        10000).% 开通投资理财所需要的钻石数 

