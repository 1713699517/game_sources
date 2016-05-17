
%% ==========================================================
%% 1 - 500 ( 预留 ) 
%% ==========================================================
-define(P_KEEP_END,                      500). % 预留

%% ==========================================================
%% 501 - 1000 ( 系统 ) 
%% ==========================================================
-define(P_SYSTEM_END,                    1000). % 系统
-define(P_SYSTEM_RESET_IDX,              500). % 重置连接hex
-define(P_SYSTEM_HEART,                  501). % 角色心跳
-define(P_SYSTEM_DISCONNECT,             502). % 服务器将断开连接
-define(P_SYSTEM_TIME,                   510). % 时间校正
-define(P_SYSTEM_ERROR,                  700). % 错误代码
-define(P_SYSTEM_NOTICE,                 800). % 系统通知
-define(P_SYSTEM_BROADCAST,              810). % 游戏广播
-define(P_SYSTEM_DATA_XXX,               811). % 广播信息块
-define(P_SYSTEM_TIPS,                   820). % 游戏提示
-define(P_SYSTEM_PAY_CHECK,              830). % 查询是否可充值
-define(P_SYSTEM_PAY_STATE,              840). % 充值查询结果返回

%% ==========================================================
%% 1001 - 2000 ( 角色 ) 
%% ==========================================================
-define(P_ROLE_END,                      2000). % 角色
-define(P_ROLE_LOGIN,                    1010). % 角色登录
-define(P_ROLE_LOGIN_AG_ERR,             1012). % 断线重连返回
-define(P_ROLE_CREATE,                   1020). % 创建角色
-define(P_ROLE_LOGIN_OK_HAVE,            1021). % 创建/登录(有角色)成功
-define(P_ROLE_CURRENCY,                 1022). % 货币
-define(P_ROLE_LOGIN_OK_NO_ROLE,         1023). % 登录成功(没有角色)
-define(P_ROLE_RAND_NAME,                1024). % 请求随机名字
-define(P_ROLE_NAME,                     1025). % 返回名字
-define(P_ROLE_LOGIN_FAIL,               1030). % 登录失败
-define(P_ROLE_CREATE_FAIL,              1050). % 创建失败
-define(P_ROLE_DEL,                      1060). % 销毁角色
-define(P_ROLE_DEL_OK,                   1061). % 销毁角色(成功)
-define(P_ROLE_DEL_FAIL,                 1063). % 销毁角色(失败)
-define(P_ROLE_PROPERTY,                 1101). % 请求玩家属性
-define(P_ROLE_PROPERTY_REVE,            1108). % 玩家属性
-define(P_ROLE_PARTNER_DATA,             1109). % 伙伴属性
-define(P_ROLE_RANK_UPDATE,              1115). % 请求玩家排名更新
-define(P_ROLE_PROPERTY_EXT,             1121). % 请求玩家扩展属性(暂无效)
-define(P_ROLE_PROPERTY_EXT_R,           1128). % 玩家扩展属性(暂无效)
-define(P_ROLE_PROPERTY_UPDATE,          1130). % 玩家单个属性更新
-define(P_ROLE_PROPERTY_UPDATE2,         1131). % 玩家单个属性更新[字符串]
-define(P_ROLE_REQUEST_NPC,              1140). % 请求NPC
-define(P_ROLE_SYS,                      1150). % 返回角色任务已开放系统
-define(P_ROLE_OPEN_SYS,                 1160). % 角色任务开放系统
-define(P_ROLE_LOGIN_N,                  1240). % 腾讯玩家登陆
-define(P_ROLE_CREATE_N,                 1241). % 腾讯创建角色
-define(P_ROLE_ENERGY,                   1260). % 请求体力值
-define(P_ROLE_ENERGY_OK,                1261). % 请求体力值成功
-define(P_ROLE_BUFF_ENERGY,              1262). % 额外赠送精力
-define(P_ROLE_ASK_BUY_ENERGY,           1263). % 请求购买体力面板
-define(P_ROLE_OK_ASK_BUYE,              1264). % 请求购买面板成功
-define(P_ROLE_BUY_ENERGY,               1265). % 购买体力
-define(P_ROLE_OK_BUY_ENERGY,            1267). % 购买精力成功
-define(P_ROLE_USE_SYS,                  1269). % 使用功能
-define(P_ROLE_SYS_ID,                   1270). % 开启的系统ID
-define(P_ROLE_SYS_ID_2,                 1271). % 开启的系统ID(新)
-define(P_ROLE_VIP_MY,                   1310). % 请求VIP(自己)
-define(P_ROLE_LV_MY,                    1311). % 请求vip回复
-define(P_ROLE_VIP,                      1312). % 请求玩家VIP
-define(P_ROLE_VIP_LV,                   1313). % 玩家VIP等级
-define(P_ROLE_NOTICE,                   1330). % 提醒签到
-define(P_ROLE_REQUEST,                  1331). % 请求签到面板
-define(P_ROLE_OK_REQUEST,               1332). % 请求签到面板成功
-define(P_ROLE_CLICK,                    1333). % 玩家点击签到
-define(P_ROLE_OK_CLICK,                 1334). % 玩家签到成功
-define(P_ROLE_ONLINE_REWARD,            1340). % 在线奖励
-define(P_ROLE_LEVEL_GIFT,               1341). % 等级礼包
-define(P_ROLE_ONLINE_OK,                1350). % 领取
-define(P_ROLE_LEVEL_GIFT_OK,            1351). % 领取等级礼包
-define(P_ROLE_BUFF_DATA,                1355). % buff数据(欲废除)
-define(P_ROLE_BUFF1_DATA,               1360). % buff数据
-define(P_ROLE_XXFFS_DATA,               1365). % buffs数据
-define(P_ROLE_BUFF,                     1370). % 通知加buff
-define(P_ROLE_BUFF_REQUEST,             1375). % 请求领取buff

%% ==========================================================
%% 2001 - 2500 ( 物品/背包 ) 
%% ==========================================================
-define(P_GOODS_END,                     2500). % 物品/背包
-define(P_GOODS_XXX1,                    2001). % 物品信息块
-define(P_GOODS_XXX2,                    2002). % 属性信息块
-define(P_GOODS_XXX3,                    2003). % 插槽信息块
-define(P_GOODS_XXX4,                    2004). % 装备打造附加块
-define(P_GOODS_XXX5,                    2005). % 插槽属性块
-define(P_GOODS_ATTR_BASE,               2006). % 基础信息块
-define(P_GOODS_REQUEST,                 2010). % 请求装备,背包物品信息
-define(P_GOODS_REVERSE,                 2020). % 请求返回数据
-define(P_GOODS_REMOVE,                  2040). % 消失物品/装备
-define(P_GOODS_CHANGE,                  2050). % 物品/装备属性变化
-define(P_GOODS_CHANGE_NOTICE,           2060). % 获得|失去物品通知
-define(P_GOODS_CURRENCY_CHANGE,         2070). % 获得|失去货币通知
-define(P_GOODS_USE,                     2080). % 物品/装备使用
-define(P_GOODS_P_EXP_OK,                2081). % 伙伴经验丹使用成功
-define(P_GOODS_TARGET_USE,              2090). % 使用物品(指定对象)
-define(P_GOODS_LOSE,                    2100). % 丢弃物品
-define(P_GOODS_ENLARGE_REQUEST,         2225). % 请求容器扩充
-define(P_GOODS_ENLARGE_COST,            2227). % 扩充需要的道具数量
-define(P_GOODS_ENLARGE,                 2230). % 容器扩充成功
-define(P_GOODS_EQUIP_ASK,               2240). % 请求角色装备信息
-define(P_GOODS_EQUIP_BACK,              2242). % 角色装备信息返回
-define(P_GOODS_PICK_TEMP,               2250). % 提取临时背包物品
-define(P_GOODS_SELL,                    2260). % 出售物品
-define(P_GOODS_P_SELL,                  2261). % 出售物品（新）
-define(P_GOODS_SELL_OK,                 2262). % 出售成功
-define(P_GOODS_EQUIP_SWAP,              2270). % 装备一键互换
-define(P_GOODS_SWAP_OK,                 2272). % 一键互换成功
-define(P_GOODS_SHOP_ASK,                2300). % 请求商店信息
-define(P_GOODS_SHOP_XXX1,               2301). % 商店物品信息块
-define(P_GOODS_SHOP_BACK,               2310). % 商店数据返回
-define(P_GOODS_SHOP_BUY,                2320). % 购买商店物品
-define(P_GOODS_SHOP_BUY_OK,             2321). % 商店购买成功
-define(P_GOODS_LANTERN_INDEX,           2327). % 元宵节活动将会获得的物品索引(0~11)
-define(P_GOODS_LANTERN_GET,             2328). % 领取将要获得的物品
-define(P_GOODS_LANTERN_ASK,             2329). % 请求元宵活动数据
-define(P_GOODS_TIMES_GOODS_ASK,         2330). % 请求次数物品数据
-define(P_GOODS_LANTERN_BACK,            2331). % 元宵活动数据返回
-define(P_GOODS_TIMES_GOODS_BACK,        2332). % 次数物品数据返回
-define(P_GOODS_TIMES_XXX1,              2333). % 次数物品数据块
-define(P_GOODS_TIMES_XXX2,              2334). % 次数物品日志数据块
-define(P_GOODS_TIMES_XXX3,              2335). % 元宵活动物品信息块
-define(P_GOODS_ACTY_USE_CHECK,          2336). % 检查特定活动物品是否可使用
-define(P_GOODS_ACTY_USE_STATE,          2338). % 特定活动物品是否可使用
-define(P_GOODS_SHOP_DATA,               2340). % 随身商店信息

%% ==========================================================
%% 2501 - 3000 ( 物品/打造/强化 ) 
%% ==========================================================
-define(P_MAKE_END,                      3000). % 物品/打造/强化
-define(P_MAKE_EQUIP,                    2510). % 装备首饰打造
-define(P_MAKE_MAKE_OK,                  2512). % 打造成功
-define(P_MAKE_KEY_STREN,                2513). % 强化（new）
-define(P_MAKE_STRENGTHEN,               2515). % 装备强化（废除）
-define(P_MAKE_STREN_DATA_ASK,           2516). % 请求装备强化数据
-define(P_MAKE_STREN_DATA_BACK,          2517). % 下一级装备强化数据返回
-define(P_MAKE_STREN_COST_XXX,           2518). % 强化消耗材料信息块
-define(P_MAKE_STREN_MAX,                2519). % 不可强化或已达最高级
-define(P_MAKE_STRENGTHEN_OK,            2520). % 装备强化成功
-define(P_MAKE_MAGIC_UPGRADE,            2522). % 法宝升阶
-define(P_MAKE_UPGRADE_OK,               2525). % 法宝升阶成功
-define(P_MAKE_WASH,                     2530). % 装备洗练
-define(P_MAKE_WASH_BACK,                2532). % 洗练数据返回
-define(P_MAKE_PLUS_MSG_XXX,             2535). % 附加属性数据块
-define(P_MAKE_PLUS_MSG_XXX2,            2536). % 附加属性数据块2
-define(P_MAKE_WASH_SAVE,                2540). % 是否保留洗练数据
-define(P_MAKE_WASH_OK,                  2542). % 保留洗练属性成功
-define(P_MAKE_MAKE_COMPOSE,             2550). %  宝石合成
-define(P_MAKE_COMPOSE_OK,               2552). % 宝石合成成功
-define(P_MAKE_PEARL_INSET,              2560). % 镶嵌宝石
-define(P_MAKE_PEARL_INSET_OK,           2561). % 镶嵌宝石成功
-define(P_MAKE_PEARL_REMOVE,             2570). % 拆除灵珠
-define(P_MAKE_MAGIC_PART,               2580). % 法宝拆分
-define(P_MAKE_MAGIC_PART_OK,            2582). % 法宝拆分成功
-define(P_MAKE_ENCHANT,                  2590). % 装备附魔
-define(P_MAKE_ENCHANT_OK,               2600). % 附魔成功
-define(P_MAKE_ENCHANT_S,                2610). % 请求附魔
-define(P_MAKE_ENCHANT_PAY,              2620). % 附魔消耗
-define(P_MAKE_KEY_ENCHANT,              2640). % 一键附魔

%% ==========================================================
%% 3001 - 3500 ( 任务 ) 
%% ==========================================================
-define(P_TASK_END,                      3500). % 任务
-define(P_TASK_REQUEST_LIST,             3210). % 请求任务列表
-define(P_TASK_DATA,                     3220). % 返回任务数据
-define(P_TASK_MONSTER_DETAIL,           3223). % 怪物信息块
-define(P_TASK_TASK_DRAMA,               3225). % 任务剧情通知
-define(P_TASK_ACCEPT,                   3230). % 接受任务
-define(P_TASK_CANCEL,                   3240). % 放弃任务
-define(P_TASK_SUBMIT,                   3250). % 提交任务
-define(P_TASK_REMOVE,                   3265). % 从列表中移除任务

%% ==========================================================
%% 3501 - 4000 ( 组队系统 ) 
%% ==========================================================
-define(P_TEAM_END,                      4000). % 组队系统
-define(P_TEAM_REQUEST,                  3510). % 请求队伍面板
-define(P_TEAM_REPLY,                    3520). % 队伍面板回复
-define(P_TEAM_REPLY_MSG,                3530). % 队伍信息块
-define(P_TEAM_PASS_REQUEST,             3540). % 请求通关的副本
-define(P_TEAM_PASS_REPLY,               3550). % 通关副本返回
-define(P_TEAM_PASS_MSG,                 3560). % 通关副本信息块
-define(P_TEAM_CREAT,                    3570). % 创建队伍
-define(P_TEAM_TEAM_INFO_NEW,            3572). % 队伍信息返回(new)
-define(P_TEAM_MEM_MSG_NEW,              3574). % 队伍成员信息块(new)
-define(P_TEAM_TEAM_INFO,                3580). % 队伍信息返回
-define(P_TEAM_MEM_MSG,                  3590). % 队伍成员信息块
-define(P_TEAM_JOIN,                     3600). % 加入队伍
-define(P_TEAM_LEAVE,                    3610). % 离开队伍
-define(P_TEAM_LEAVE_NOTICE,             3620). % 离队通知
-define(P_TEAM_KICK,                     3630). % 踢出队员
-define(P_TEAM_SET_LEADER,               3640). % 设置新队长
-define(P_TEAM_APPLY_LEADER,             3650). % 申请做队长
-define(P_TEAM_APPLY_NOTICE,             3660). % 申请队长通知
-define(P_TEAM_NEW_LEADER,               3670). % 新队长通知
-define(P_TEAM_INVITE,                   3680). % 邀请好友
-define(P_TEAM_INVITE_NOTICE,            3700). % 邀请好友返回
-define(P_TEAM_LIVE_REQ,                 3720). % 查询队伍是否存在
-define(P_TEAM_LIVE_REP,                 3730). % 查询队伍返回

%% ==========================================================
%% 4001 - 4500 ( 好友 ) 
%% ==========================================================
-define(P_FRIEND_END,                    4500). % 好友
-define(P_FRIEND_REQUES,                 4010). % 请求好友面板
-define(P_FRIEND_INFO,                   4020). % 返回好友信息
-define(P_FRIEND_INFO_GROUP,             4025). % 返回好友列表信息块
-define(P_FRIEND_DEL,                    4030). % 请求删除好友
-define(P_FRIEND_DEL_OK,                 4040). % 好友删除成功
-define(P_FRIEND_SEARCH_ADD,             4050). % 查找好友
-define(P_FRIEND_SEARCH_REPLY,           4060). % 查找好友返回
-define(P_FRIEND_ADD,                    4070). % 添加好友，最近联系人，黑名单
-define(P_FRIEND_ADD_DETAIL,             4075). % 添加好友详情
-define(P_FRIEND_ADD_NOTICE,             4090). % 发送添加好友通知
-define(P_FRIEND_SYS_FRIEND,             4200). % 系统推荐好友

%% ==========================================================
%% 5001 - 6000 ( 场景 ) 
%% ==========================================================
-define(P_SCENE_END,                     6000). % 场景
-define(P_SCENE_ENTER_FLY,               5010). % 请求进入场景(飞)
-define(P_SCENE_ENTER,                   5020). % 请求进入场景
-define(P_SCENE_ENTER_OK,                5030). % 进入场景
-define(P_SCENE_REQUEST_PLAYERS,         5040). % 请求场景内玩家信息列表
-define(P_SCENE_REQ_PLAYERS_NEW,         5042). % 请求场景玩家列表(new)
-define(P_SCENE_PLAYER_LIST,             5045). % 玩家信息列表
-define(P_SCENE_ROLE_DATA,               5050). % 地图玩家数据
-define(P_SCENE_PARTNER_LIST,            5052). % 地图伙伴列表
-define(P_SCENE_PARTNER_DATA,            5055). % 地图伙伴数据
-define(P_SCENE_REQUEST_MONSTER,         5060). % 请求怪物数据
-define(P_SCENE_IDX_MONSTER,             5065). % 场景刷出第几波怪
-define(P_SCENE_MONSTER_DATA,            5070). % 怪物数据(刷新)
-define(P_SCENE_MOVE,                    5080). % 行走数据
-define(P_SCENE_MOVE_NEW,                5085). % 行走数据(广播)
-define(P_SCENE_MOVE_RECE,               5090). % 行走数据(地图广播)
-define(P_SCENE_SET_PLAYER_XY,           5100). % 强设玩家坐标
-define(P_SCENE_OUT,                     5110). % 离开场景
-define(P_SCENE_CAROM_TIMES,             5120). % 杀怪连击
-define(P_SCENE_KILL_MONSTER,            5130). % 击杀怪物
-define(P_SCENE_HIT_TIMES,               5140). % 被怪物击中
-define(P_SCENE_DIE,                     5150). % 玩家死亡
-define(P_SCENE_DIE_PARTNER,             5155). % 伙伴死亡
-define(P_SCENE_RELIVE,                  5160). % 玩家可以复活
-define(P_SCENE_RELIVE_REQUEST,          5170). % 玩家请求复活
-define(P_SCENE_RELIVE_OK,               5180). % 玩家复活成功
-define(P_SCENE_HP_UPDATE,               5190). % 玩家|伙伴血量更新
-define(P_SCENE_ENTER_CITY,              5200). % 回城
-define(P_SCENE_CHANGE_CLAN,             5930). % 场景广播-帮派
-define(P_SCENE_LEVEL_UP,                5940). % 场景广播-升级
-define(P_SCENE_CHANGE_TEAM,             5950). % 场景广播-改变组队
-define(P_SCENE_CHANGE_MOUNT,            5960). % 场景广播--改变坐骑
-define(P_SCENE_CHANGE_STATE,            5970). % 场景广播-改变战斗状态(is_war)
-define(P_SCENE_CHANGE_VIP,              5980). % 场景广播-VIP

%% ==========================================================
%% 6001 - 6500 ( 战斗 ) 
%% ==========================================================
-define(P_WAR_END,                       6500). % 战斗
-define(P_WAR_PLAYER_WAR,                6010). % 战斗数据块
-define(P_WAR_HARM,                      6020). % 战斗伤害广播
-define(P_WAR_HARM_NEW,                  6021). % 战斗伤害广播
-define(P_WAR_SKILL,                     6030). % 释放技能广播
-define(P_WAR_USE_SKILL,                 6040). % 释放技能
-define(P_WAR_PK,                        6050). % 邀请PK
-define(P_WAR_PK_CANCEL,                 6055). % 取消邀请
-define(P_WAR_PK_RECEIVE,                6060). % 接收PK邀请
-define(P_WAR_PK_TIME,                   6061). % PK时间
-define(P_WAR_PK_REPLY,                  6070). % 邀请回复
-define(P_WAR_PK_LOSE,                   6080). % PK结束死亡广播
-define(P_WAR_DOWN,                      6090). % 怪物击倒

%% ==========================================================
%% 6501 - 7000 ( 技能系统 ) 
%% ==========================================================
-define(P_SKILL_END,                     7000). % 技能系统
-define(P_SKILL_REQUEST,                 6510). % 请求技能列表
-define(P_SKILL_LIST,                    6520). % 技能列表数据
-define(P_SKILL_LEARN,                   6525). % 升级技能
-define(P_SKILL_INFO,                    6530). % 技能信息
-define(P_SKILL_EQUIP,                   6540). % 装备技能
-define(P_SKILL_EQUIP_INFO,              6545). % 装备技能信息
-define(P_SKILL_PARTNER,                 6550). % 请求伙伴技能列表
-define(P_SKILL_UPPARENTLV,              6555). % 请求学习技能
-define(P_SKILL_PARENTINFO,              6560). % 伙伴技能信息

%% ==========================================================
%% 7001 - 8000 ( 副本 ) 
%% ==========================================================
-define(P_COPY_END,                      8000). % 副本
-define(P_COPY_REQUEST_OLD,              7001). % 请求副本列表
-define(P_COPY_REVERSE_OLD,              7002). % 副本信息返回
-define(P_COPY_MSG_REVERSE_OLD,          7003). % 副本信息返回块
-define(P_COPY_REQUEST,                  7010). % 请求普通副本
-define(P_COPY_CHAP_DATA,                7015). % 当前章节信息
-define(P_COPY_MSG_BATTLE,               7020). % 战役数据信息块
-define(P_COPY_CHAP_DATA_NEW,            7022). % 当前章节信息(new)
-define(P_COPY_MSG_BATTLE_NEW,           7024). % 战役数据信息块(new)
-define(P_COPY_CREAT,                    7030). % 创建进入副本
-define(P_COPY_TIMING,                   7040). % 副本计时(待删除)
-define(P_COPY_TIME_UPDATE,              7050). % 副本时间同步(待删除)
-define(P_COPY_SCENE_TIME,               7060). % 场景时间同步(生存,限时类型)
-define(P_COPY_ENTER_SCENE_INFO,         7710). % 进入副本场景返回信息(待删除)
-define(P_COPY_SCENE_OVER,               7790). % 场景目标完成
-define(P_COPY_NOTICE_OVER,              7795). % 通知副本完成
-define(P_COPY_OVER,                     7800). % 副本完成
-define(P_COPY_MSG_GOOD,                 7805). % 副本物品信息块
-define(P_COPY_FAIL,                     7810). % 副本失败
-define(P_COPY_COPY_EXIT,                7820). % 退出副本
-define(P_COPY_EXIT_OK,                  7830). % 退出副本成功
-define(P_COPY_UP_START,                 7840). % 开始挂机
-define(P_COPY_UP_SPEED,                 7845). % 加速挂机
-define(P_COPY_UP_RESULT,                7850). % 挂机返回
-define(P_COPY_UP_OVER,                  7860). % 挂机完成
-define(P_COPY_IS_UP,                    7864). % 请求登陆挂机
-define(P_COPY_LOGIN_NOTICE,             7865). % 登陆提醒挂机
-define(P_COPY_UP_STOP,                  7870). % 停止挂机
-define(P_COPY_CHAP_REWARD,              7880). % 领取章节评价奖励
-define(P_COPY_CHAP_RE_REP,              7890). % 查询章节奖励返回

%% ==========================================================
%% 8501 - 9000 ( 邮件 ) 
%% ==========================================================
-define(P_MAIL_END,                      9000). % 邮件
-define(P_MAIL_ID_SEND,                  8501). % 发送的邮件ID
-define(P_MAIL_REQUEST,                  8510). % 请求邮件列表
-define(P_MAIL_LIST,                     8512). % 请求列表成功
-define(P_MAIL_MODEL,                    8513). % 邮件模块
-define(P_MAIL_SEND,                     8530). % 请求发送邮件
-define(P_MAIL_OK_SEND,                  8532). % 发送邮件成功
-define(P_MAIL_READ,                     8540). % 请求读取邮件
-define(P_MAIL_INFO,                     8542). % 读取邮件成功
-define(P_MAIL_VGOODS_MODEL,             8543). % 虚拟物品协议块
-define(P_MAIL_PICK,                     8550). % 提取邮件物品
-define(P_MAIL_OK_PICK,                  8552). % 提取物品成功
-define(P_MAIL_DEL,                      8560). % 删除邮件
-define(P_MAIL_OK_DEL,                   8562). % 邮件移出
-define(P_MAIL_IDLIST,                   8563). % 删除邮件信息块
-define(P_MAIL_SAVE,                     8580). % 请求保存邮件

%% ==========================================================
%% 9001 - 9500 ( 防沉迷 ) 
%% ==========================================================
-define(P_FCM_END,                       9500). % 防沉迷
-define(P_FCM_PROMPT,                    9020). % 防沉迷提示

%% ==========================================================
%% 9501 - 10000 ( 聊天 ) 
%% ==========================================================
-define(P_CHAT_END,                      10000). % 聊天
-define(P_CHAT_GOODS_LIST,               9524). % 收到频道聊天
-define(P_CHAT_SEND,                     9525). % 发送频道聊天
-define(P_CHAT_NAME,                     9526). % 发送名字私聊
-define(P_CHAT_OFFICE_PLAYER,            9527). % 玩家不在线
-define(P_CHAT_RECE,                     9530). % 收到频道聊天
-define(P_CHAT_GM,                       9600). % GM命令

%% ==========================================================
%% 10001 - 10100 ( 祝福 ) 
%% ==========================================================
-define(P_WISH_END,                      10100). % 祝福
-define(P_WISH_SENT,                     10001). % 好友祝福
-define(P_WISH_SUCCESS,                  10010). % 祝福成功
-define(P_WISH_RECV,                     10012). % 收到好友祝福
-define(P_WISH_EXPERIENCE,               10020). % 领取祝福经验
-define(P_WISH_EXP_SUCCESS,              10022). % 领取祝福经验成功
-define(P_WISH_EXP_DATA,                 10030). % 请求祝福经验信息
-define(P_WISH_EXP_DATA_BACK,            10032). % 祝福经验信息返回
-define(P_WISH_LV_UP,                    10040). % 好友升级提示
-define(P_WISH_DOUBLE,                   10050). % 双倍信息
-define(P_WISH_DOUBLE_DATA,              10052). % 双倍信息返回

%% ==========================================================
%% 10701 - 11000 ( 称号 ) 
%% ==========================================================
-define(P_TITLE_END,                     11000). % 称号
-define(P_TITLE_CAST,                    10701). % 玩家称号广播
-define(P_TITLE_REQUEST,                 10710). % 请求称号列表
-define(P_TITLE_SET_STATE,               10720). % 设置称号状态
-define(P_TITLE_LIST_BACK,               10730). % 称号列表数据返回
-define(P_TITLE_XXX1,                    10740). % 称号数据块

%% ==========================================================
%% 12101 - 12200 ( 坐骑 ) 
%% ==========================================================
-define(P_MOUNT_END,                     12200). % 坐骑
-define(P_MOUNT_DEFAULT_MOUNT,           12102). % 得到默认坐骑
-define(P_MOUNT_DEFAULT_SUCCESS,         12103). % 成功得到默认坐骑
-define(P_MOUNT_RIDE,                    12110). % 骑乘|下骑
-define(P_MOUNT_RIDE_OK,                 12115). % 骑乘|下骑成功
-define(P_MOUNT_LLUSION,                 12120). % 幻化请求
-define(P_MOUNT_LLUSION_REPLY,           12125). % 幻化请求返回
-define(P_MOUNT_REQUEST,                 12130). % 坐骑系统请求
-define(P_MOUNT_MOUNT_REPLY,             12135). % 坐骑系统请求返回
-define(P_MOUNT_LIUSION_MOUNT,           12140). % 幻化坐骑
-define(P_MOUNT_UP_MOUNT,                12145). % 坐骑升阶
-define(P_MOUNT_CUL,                     12150). % 培养
-define(P_MOUNT_CUL_RESULT,              12155). % 坐骑培养结果
-define(P_MOUNT_LLUSION_REPLY_E,         12156). % 幻化坐骑返回单元
-define(P_MOUNT_MOUNT_FRUIT,             12160). % 坐骑吃仙果返回结果

%% ==========================================================
%% 14001 - 18000 ( 阵营 ) 
%% ==========================================================
-define(P_COUNTRY_END,                   18000). % 阵营
-define(P_COUNTRY_INFO,                  14001). % 请求阵营信息
-define(P_COUNTRY_INFO_RESULT,           14002). % 阵营信息
-define(P_COUNTRY_SELECT,                14010). % 选择阵营
-define(P_COUNTRY_SELECT_RESULT,         14015). % 选择阵营结果
-define(P_COUNTRY_CHANGE_PRE,            14020). % 改变阵营--前奏
-define(P_COUNTRY_CHANGE,                14025). % 改变阵营
-define(P_COUNTRY_CHANGE_RESULT,         14027). % 改变阵营返回
-define(P_COUNTRY_RANK,                  14030). % 阵营排名
-define(P_COUNTRY_RANK_RESULT,           14035). % 阵营排名结果
-define(P_COUNTRY_PUBLISH_NOTICE,        14040). % 发布阵营公告
-define(P_COUNTRY_PUBLISH_NOTICE_R,      14045). % 发布阵营公告返回(阵营广播)
-define(P_COUNTRY_POST_APPOINT,          14050). % 任命官员
-define(P_COUNTRY_POST_RECALL,           14060). % 罢免官员
-define(P_COUNTRY_POST_RESIGN,           14070). % 官员辞职
-define(P_COUNTRY_POST_NOTICE,           14080). % 阵营职位改变消息通知(阵营广播)
-define(P_COUNTRY_EVENT_BROADCAST,       14090). % 阵营事件广播

%% ==========================================================
%% 18001 - 18100 ( 活动-钓鱼达人 ) 
%% ==========================================================
-define(P_FISHING_END,                   18100). % 活动-钓鱼达人
-define(P_FISHING_ASK_FISHING,           18010). % 请求钓鱼界面
-define(P_FISHING_OK_FISHING,            18015). % 请求界面成功
-define(P_FISHING_FISH_DATE,             18017). % 可收取鱼数据块
-define(P_FISHING_ASK_GO_FISH,           18020). % 请求开始钓鱼
-define(P_FISHING_OK_GO_FISHING,         18025). % 开始钓鱼
-define(P_FISHING_CATCH_FISH,            18030). % 钓到鱼了
-define(P_FISHING_GET_FISH,              18040). % 请求收获鱼
-define(P_FISHING_OK_GET_FISH,           18045). % 收取成功
-define(P_FISHING_RMB,                   18050). % rmb收鱼

%% ==========================================================
%% 18101 - 19100 ( 荣誉 ) 
%% ==========================================================
-define(P_HONOR_END,                     19100). % 荣誉
-define(P_HONOR_LIST_REQUEST,            18110). % 请求荣誉列表
-define(P_HONOR_REWARD,                  18120). % 领取奖励
-define(P_HONOR_REWARD_OK,               18125). % 领取成功
-define(P_HONOR_LIST_RETURN,             18130). % 荣誉状态列表
-define(P_HONOR_REACH_TIP,               18150). % 荣誉达成提示

%% ==========================================================
%% 21101 - 21500 ( 活动-保卫经书 ) 
%% ==========================================================
-define(P_DEFEND_BOOK_END,               21500). % 活动-保卫经书
-define(P_DEFEND_BOOK_REQUEST,           21110). % 请求参加怪物攻城
-define(P_DEFEND_BOOK_INTER_SCENE,       21120). % 进入场景
-define(P_DEFEND_BOOK_TIME,              21122). % 倒计时
-define(P_DEFEND_BOOK_ASK_PLAYER_DATE,   21130). % 请求场景玩家数据
-define(P_DEFEND_BOOK_OK_MONST_DATA,     21135). % 所有怪物数据返回
-define(P_DEFEND_BOOK_MONSTER,           21136). % 怪物数据组
-define(P_DEFEND_BOOK_MONSTER_DATA,      21137). % 怪物数据刷新
-define(P_DEFEND_BOOK_SELF_HARM,         21140). % 玩家对怪伤害值
-define(P_DEFEND_BOOK_RANKING,           21145). % 对怪物累计伤害前10排名
-define(P_DEFEND_BOOK_RANK_DATA,         21150). % 排行榜数据
-define(P_DEFEND_BOOK_CAMP_INTEGRAL,     21160). % 阵营积分数据
-define(P_DEFEND_BOOK_CAMP_INTEGRAL_N,   21165). % 阵营积分数据_新
-define(P_DEFEND_BOOK_TRENCH_DATE,       21170). % 战壕数据
-define(P_DEFEND_BOOK_PLAYER_DATE,       21175). % 单个防守圈玩家数据
-define(P_DEFEND_BOOK_DATE_TRENCH,       21180). % 战壕玩家信息块
-define(P_DEFEND_BOOK_ASK_TRENCH,        21190). % 请求选择战壕
-define(P_DEFEND_BOOK_OK_TRENCH,         21200). % 请求战壕结果
-define(P_DEFEND_BOOK_START_WAR,         21210). % 开始战斗
-define(P_DEFEND_BOOK_WAR_RETRUN,        21220). % 战斗结果返回
-define(P_DEFEND_BOOK_WAR_MONSTERS,      21223). % 战斗怪物更新
-define(P_DEFEND_BOOK_KILL_PLAYERS,      21225). % 玩家死亡
-define(P_DEFEND_BOOK_KILL_REWARDS,      21227). % 击杀掉落
-define(P_DEFEND_BOOK_ASK_GET_REWARDS,   21230). % 请求拾取击杀奖励
-define(P_DEFEND_BOOK_OK_GET_REWARDS,    21232). % 拾取击杀奖励
-define(P_DEFEND_BOOK_REVIVE,            21240). % 复活
-define(P_DEFEND_BOOK_OK_REVIVE,         21250). % 复活成功
-define(P_DEFEND_BOOK_REQUEST_BACK,      21260). % 请求退出战斗
-define(P_DEFEND_BOOK_START_BUFF,        21270). % 开启增益
-define(P_DEFEND_BOOK_GAIN,              21280). % 请求领取增益
-define(P_DEFEND_BOOK_OK_GAIN,           21290). % 领取增益成功
-define(P_DEFEND_BOOK_CHANGE_TRENCH,     21300). % 请求更换战壕

%% ==========================================================
%% 22101 - 22200 ( 声望 ) 
%% ==========================================================
-define(P_RENOWN_END,                    22200). % 声望
-define(P_RENOWN_REQUEST,                22102). %  请求声望面板
-define(P_RENOWN_REQUEST_OK,             22103). % 请求声望面板成功
-define(P_RENOWN_NOTICE,                 22106). % 提醒领取俸禄
-define(P_RENOWN_REWARD,                 22107). % 领取每日俸禄
-define(P_RENOWN_REWARD_OK,              22108). % 领取每日俸禄成功

%% ==========================================================
%% 22201 - 22700 ( 福利 ) 
%% ==========================================================
-define(P_WELFARE_END,                   22700). % 福利
-define(P_WELFARE_REQUEST,               22210). % 请求福利数据
-define(P_WELFARE_CONTINUE_BACK,         22220). % 连续登陆数据返回
-define(P_WELFARE_CUMUL_BACK,            22230). % 在线奖励数据
-define(P_WELFARE_PAY_BACK,              22240). % 充值奖励数据
-define(P_WELFARE_RECOVER_EXP,           22250). % 找回经验数据
-define(P_WELFARE_REWARD_GET,            22260). % 领取奖励
-define(P_WELFARE_REWARD_RESULT,         22270). % 领取奖励结果
-define(P_WELFARE_YELLOW_DAY_BACK,       22280). % 黄钻每日面板数据
-define(P_WELFARE_YELLOW_GROW_BACK,      22290). % 黄钻成长数据

%% ==========================================================
%% 22701 - 22800 ( 日志 ) 
%% ==========================================================
-define(P_GAME_LOGS_END,                 22800). % 日志
-define(P_GAME_LOGS_NOTICES,             22760). % 获得|失去通知
-define(P_GAME_LOGS_MESS,                22770). % 信息组协议块
-define(P_GAME_LOGS_EVENT,               22780). % 事件通知
-define(P_GAME_LOGS_STR_XXX,             22781). % 字符串信息块
-define(P_GAME_LOGS_INT_XXX,             22782). % 数字信息块

%% ==========================================================
%% 22801 - 23800 ( 宠物 ) 
%% ==========================================================
-define(P_PET_END,                       23800). % 宠物
-define(P_PET_PET,                       22801). % 宠物消息块
-define(P_PET_REQUEST,                   22810). % 请求宠物列表
-define(P_PET_REVERSE,                   22820). % 返回魔宠信息列表
-define(P_PET_SKILLS,                    22825). % 式神信息块
-define(P_PET_SKINS,                     22827). % 皮肤信息块
-define(P_PET_OPEN,                      22830). % 开启式神
-define(P_PET_OPEN_OK,                   22840). % 开启式神ok
-define(P_PET_CALL,                      22850). % 召唤式神
-define(P_PET_CALL_OK,                   22860). % 召唤式神成功返回
-define(P_PET_NEED_RMB,                  22870). % 修炼还需要的钻石数
-define(P_PET_NEED_RMB_REPLY,            22875). % 修炼需要钻石返回
-define(P_PET_XIULIAN,                   22880). % 魔宠修炼
-define(P_PET_XIULIAN_OK,                22885). % 魔宠修炼成功返回
-define(P_PET_HUANHUA,                   22900). % 式神幻化
-define(P_PET_HUANHUA_REPLY,             22950). % 幻化成功返回
-define(P_PET_CTN_ENLARGE_OK,            22980). % 宠物栏开格成功
-define(P_PET_HUANHUA_REQUEST,           23000). % 请求幻化界面
-define(P_PET_HH_REPLY_MSG,              23010). % 幻化界面返回

%% ==========================================================
%% 23801 - 24800 ( 逐鹿台 ) 
%% ==========================================================
-define(P_ARENA_END,                     24800). % 逐鹿台
-define(P_ARENA_JOIN,                    23810). % 进入封神台
-define(P_ARENA_DEKARON,                 23820). % 可以挑战的玩家列表
-define(P_ARENA_CANBECHALLAGE,           23821). % 可以挑战的玩家
-define(P_ARENA_BATTLE,                  23830). % 挑战
-define(P_ARENA_WAR_DATA,                23831). % 战斗信息块
-define(P_ARENA_STRAT,                   23832). % 封神台开始广播
-define(P_ARENA_WAR_REWARD,              23835). % 挑战奖励
-define(P_ARENA_FINISH,                  23840). % 挑战结束
-define(P_ARENA_RADIO,                   23850). % 战果广播
-define(P_ARENA_BUY,                     23860). % 购买挑战次数
-define(P_ARENA_RESULT2,                 23870). % 结果
-define(P_ARENA_BUY_YES,                 23880). % 确定购买
-define(P_ARENA_BUY_OK,                  23890). % 返回结果
-define(P_ARENA_EXIT,                    23900). % 退出封神台
-define(P_ARENA_OK,                      23910). % 退出成功
-define(P_ARENA_KILLER,                  23920). % 请求封神台排行榜
-define(P_ARENA_KILLER_DATA,             23930). % 返回高手信息
-define(P_ARENA_ACE,                     23931). % 高手信息
-define(P_ARENA_MAX_DATA,                23940). % 返回最竞技场信息
-define(P_ARENA_DAY_REWARD,              23960). % 领取每日奖励
-define(P_ARENA_GET_REWARD,              23970). % 领取结果
-define(P_ARENA_GOODS_LIST,              23971). % 获得物品id列表
-define(P_ARENA_REWARD_TIMES,            24000). % 领取倒计时
-define(P_ARENA_CLEAN,                   24010). % 清除CD时间
-define(P_ARENA_CLEAN_OK,                24020). % 清除成功

%% ==========================================================
%% 24801 - 24900 ( 排行榜 ) 
%% ==========================================================
-define(P_TOP_END,                       24900). % 排行榜
-define(P_TOP_RANK,                      24810). % 请求排行版
-define(P_TOP_DATE,                      24820). % 排行榜信息
-define(P_TOP_XXXX,                      24830). % 排行信息块

%% ==========================================================
%% 24901 - 24999 ( 新手卡 ) 
%% ==========================================================
-define(P_CARD_END,                      24999). % 新手卡
-define(P_CARD_GETS,                     24910). % 领取卡
-define(P_CARD_SUCCEED,                  24920). % 领取成功
-define(P_CARD_SALES_ASK,                24930). % 请求促销活动可领取状态
-define(P_CARD_SALES_DATA,               24932). % 促销活动状态返回
-define(P_CARD_ID_DATE,                  24933). % 促销活动信息
-define(P_CARD_ID_SUB,                   24934). % 促销活动开启阶段
-define(P_CARD_SALES_GET,                24940). % 请求领取奖励
-define(P_CARD_GET_OK,                   24950). % 领取成功
-define(P_CARD_NOTICE,                   24960). % 领取通知
-define(P_CARD_RECE,                     24970). % 以领取的活动Id
-define(P_CARD_XXXXX,                    24980). % 以领取的活动

%% ==========================================================
%% 26000 - 26999 ( NPC ) 
%% ==========================================================
-define(P_NPC_END,                       26999). % NPC
-define(P_NPC_REQUEST,                   26000). % 请求NPC
-define(P_NPC_LIST,                      26005). % 队伍列表
-define(P_NPC_COPY_ID,                   26007). % 返回NPC副本ID
-define(P_NPC_SCRAM,                     26010). % 从NPC处滚蛋
-define(P_NPC_CLOSE,                     26015). % 关闭组队面板
-define(P_NPC_NOTICE_DELETE,             26020). % 通知--删除队伍
-define(P_NPC_SET_LEADER,                26040). % 设置队长
-define(P_NPC_JOIN,                      26050). % 加入队伍
-define(P_NPC_LEAVE,                     26060). % 退出队伍
-define(P_NPC_KICK,                      26070). % 踢出队员
-define(P_NPC_DISMISS,                   26080). % 解散队伍
-define(P_NPC_TEAM_ENTER,                26100). % NPC进入(战场|副本|各种组队玩法)
-define(P_NPC_NOTICE_HIDE,               26110). % 隐藏队伍

%% ==========================================================
%% 28000 - 29000 ( 布阵 ) 
%% ==========================================================
-define(P_ARRAY_END,                     29000). % 布阵
-define(P_ARRAY_LIST_DATA,               28000). % 返回伙伴信息数据
-define(P_ARRAY_LIST,                    28010). % 请求阵型系统
-define(P_ARRAY_UP_ARRAY,                28020). % 上阵
-define(P_ARRAY_DOWN_ARRAY,              28030). % 下阵
-define(P_ARRAY_EXCHANGE,                28040). % 交换阵位
-define(P_ARRAY_ROLE_INFO,               28050). % 布阵伙伴信息块

%% ==========================================================
%% 30501 - 31000 ( 活动面板 ) 
%% ==========================================================
-define(P_ACTIVITY_END,                  31000). % 活动面板
-define(P_ACTIVITY_DATA,                 30501). % 活动状态改变滚屏通知
-define(P_ACTIVITY_REQUEST,              30510). % 请求活动数据
-define(P_ACTIVITY_OK_ACTIVE_DATA,       30520). % 活动数据返回
-define(P_ACTIVITY_ACTIVE_DATA,          30540). % 活动数据
-define(P_ACTIVITY_ASK_LINK_DATA,        30610). % 请求活跃度数据
-define(P_ACTIVITY_OK_LINK_DATA,         30620). % 活跃度数据返回
-define(P_ACTIVITY_ACTIVE_LINK_MSG,      30630). % 活动数据信息块
-define(P_ACTIVITY_REWARDS_DATA,         30640). % 奖励数据块
-define(P_ACTIVITY_ASK_REWARDS,          30650). % 请求领取奖励
-define(P_ACTIVITY_OK_GET_REWARDS,       30660). % 领奖状态返回

%% ==========================================================
%% 31001 - 32000 ( 客栈 ) 
%% ==========================================================
-define(P_INN_END,                       32000). % 客栈
-define(P_INN_ENJOY_INN,                 31110). % 请求客栈
-define(P_INN_LIST,                      31120). % 伙伴列表
-define(P_INN_H_DATA,                    31121). % 伙伴信息块
-define(P_INN_CALL_PARTNER,              31150). % 招募伙伴
-define(P_INN_WAR,                       31170). % 伙伴出战
-define(P_INN_NTE_WAR,                   31180). % 伙伴出战休息
-define(P_INN_DROP_OUT,                  31250). % 离队
-define(P_INN_ENJOY,                     31260). % 归队
-define(P_INN_RES_PARTNER,               31270). % 离队/归队结果

%% ==========================================================
%% 32001 - 33000 ( 财神 ) 
%% ==========================================================
-define(P_WEAGOD_END,                    33000). % 财神
-define(P_WEAGOD_REQUEST,                32010). % 请求招财面板
-define(P_WEAGOD_REPLY,                  32020). % 招财面板返回
-define(P_WEAGOD_GET_MONEY,              32030). % 招财
-define(P_WEAGOD_PL_MONEY,               32040). % 批量招财
-define(P_WEAGOD_AUTO_GET,               32050). % 自动招财
-define(P_WEAGOD_SUCCESS,                32060). % 招财成功返回

%% ==========================================================
%% 33001 - 34000 ( 社团 ) 
%% ==========================================================
-define(P_CLAN_END,                      34000). % 社团
-define(P_CLAN_MESSAGE,                  33001). % 通知  【废除不用】
-define(P_CLAN_ASK_CLAN,                 33010). % 请求帮派面板
-define(P_CLAN_OK_CLAN_DATA,             33020). % 返加帮派基础数据1
-define(P_CLAN_OK_OTHER_DATA,            33023). % 返加帮派基础数据2
-define(P_CLAN_CLAN_LOGS,                33025). % 返加帮派日志数据3
-define(P_CLAN_LOGS_MSG,                 33026). % 帮派日志数据块
-define(P_CLAN_STRING_MSG,               33027). % string数据块
-define(P_CLAN_INT_MSG,                  33028). % int数据块
-define(P_CLAN_ASL_CLANLIST,             33030). % 请求帮派列表
-define(P_CLAN_OK_CLANLIST,              33034). % 帮派列表返回
-define(P_CLAN_APPLIED_CLANLIST,         33036). % 已申请帮派列表
-define(P_CLAN_ASK_CANCEL,               33037). % 请求|取消入帮申请
-define(P_CLAN_OK_JOIN_CLAN,             33040). % 申请成功
-define(P_CLAN_ASK_REBUILD_CLAN,         33050). % 请求创建帮派
-define(P_CLAN_OK_REBUILD_CLAN,          33060). % 创建成功
-define(P_CLAN_ASK_JOIN_LIST,            33070). % 请求入帮申请列表
-define(P_CLAN_OK_JOIN_LIST,             33080). % 返回入帮申请列表
-define(P_CLAN_USER_DATA,                33085). % 入帮申请玩家信息块
-define(P_CLAN_ASK_AUDIT,                33090). % 请求审核操作
-define(P_CLAN_OK_AUDIT,                 33095). % 返回审核结果
-define(P_CLAN_ASK_RESET_CAST,           33110). % 请求修改帮派公告
-define(P_CLAN_OK_RESET_CAST,            33120). % 返回修改公告结果
-define(P_CLAN_ASK_MEMBER_MSG,           33130). % 请求帮派成员列表
-define(P_CLAN_ASK_SET_POST,             33135). % 请求设置成员职位
-define(P_CLAN_OK_MEMBER_LIST,           33140). % 返回帮派成员列表
-define(P_CLAN_MEMBER_MSG,               33145). % 成员数据信息块
-define(P_CLAN_ASK_OUT_CLAN,             33150). % 请求退出|解散帮派
-define(P_CLAN_OK_OUT_CLAN,              33160). % 退出帮派成功
-define(P_CLAN_ASK_CLAN_SKILL,           33200). % 请求帮派技能面板
-define(P_CLAN_OK_CLAN_SKILL,            33210). % 返回帮派技能面板数据
-define(P_CLAN_CLAN_ATTR_DATA,           33215). % 帮派技能属性数据块【33215】
-define(P_CLAN_STUDY_SKILL,              33220). % 请求学习帮派技能
-define(P_CLAN_ASK_CLAN_ACTIVE,          33300). % 请求帮派活动面板
-define(P_CLAN_NOW_STAMINA,              33305). % 玩家现有体能值
-define(P_CLAN_OK_ACTIVE_DATA,           33310). % 返回活动面板数据
-define(P_CLAN_ACTIVE_MSG,               33315). % 帮派活动面板数据块
-define(P_CLAN_ASK_WATER,                33320). % 请求浇水
-define(P_CLAN_START_WATER,              33325). % 请求开始浇水|摇钱
-define(P_CLAN_OK_WATER_DATA,            33330). % 返回浇水面板数据
-define(P_CLAN_WATER_LOGS_DATA,          33335). % 浇水日志数据块
-define(P_CLAN_ASK_START_STR,            33360). % 请求开始体能训练
-define(P_CLAN_OK_STRENGTH,              33370). % 训练成功[33305]

%% ==========================================================
%% 34001 - 34500 ( 活动-龙宫寻宝 ) 
%% ==========================================================
-define(P_DRAGON_END,                    34500). % 活动-龙宫寻宝
-define(P_DRAGON_ASK_JOIN_DRAGON,        34010). % 请求寻宝界面
-define(P_DRAGON_OK_JOIN_DRAGON,         34020). % 请求界面成功
-define(P_DRAGON_START_DRAGON,           34030). % 开始寻宝
-define(P_DRAGON_OK_START_DRAGON,        34040). % 寻宝结果_旧
-define(P_DRAGON_OK_START_NEW,           34042). % 寻宝结果
-define(P_DRAGON_REWARDS_MSG,            34050). % 寻宝奖励信息块

%% ==========================================================
%% 34501 - 35000 ( 商城 ) 
%% ==========================================================
-define(P_SHOP_END,                      35000). % 商城
-define(P_SHOP_INFO,                     34501). % 店铺物品信息块
-define(P_SHOP_INFO_NEW,                 34502). % 店铺物品信息块
-define(P_SHOP_REQUEST,                  34510). %  请求店铺面板
-define(P_SHOP_REQUEST_OK,               34511). %  请求店铺面板成功
-define(P_SHOP_REQUEST_OK_NEW,           34512). % 请求店铺面板成功
-define(P_SHOP_BUY,                      34515). % 请求购买
-define(P_SHOP_BUY_SUCC,                 34516). % 购买成功
-define(P_SHOP_ASK_INTEGRAL,             34520). % 请求积分数据
-define(P_SHOP_INTEGRAL_BACK,            34522). % 玩家积分数据

%% ==========================================================
%% 35001 - 36000 ( 苦工 ) 
%% ==========================================================
-define(P_MOIL_END,                      36000). % 苦工
-define(P_MOIL_ENJOY_MOIL,               35010). % 进入苦工系统
-define(P_MOIL_MOIL_DATA,                35020). % 返回自己身份信息
-define(P_MOIL_MOIL_RS,                  35021). % 苦工操作信息
-define(P_MOIL_PROTECT_TIME,             35022). % 互动保护剩余时间
-define(P_MOIL_PROTECT_COUNT,            35023). % 苦工保护时间列表
-define(P_MOIL_PLAYER_DATA,              35025). % 玩家信息列表(抓捕,求救)
-define(P_MOIL_MOIL_XXXX1,               35026). % 玩家信息块(抓捕,求救)
-define(P_MOIL_OPER,                     35030). % 苦工系统操作
-define(P_MOIL_CAPTRUE,                  35040). % 抓捕
-define(P_MOIL_CALL_RES,                 35041). % 战斗结果
-define(P_MOIL_ACTIVE,                   35050). % 互动
-define(P_MOIL_PRESS_START,              35060). % 请求压榨/互动
-define(P_MOIL_PRESS_DATA,               35061). % 可压榨苦工
-define(P_MOIL_MOIL_XXXX2,               35062). % 苦工信息
-define(P_MOIL_PRESS_ENJOY,              35063). % 进入压榨界面
-define(P_MOIL_MOIL_XXXX3,               35064). % 苦工具体信息
-define(P_MOIL_PRESS,                    35070). % 压榨/抽取/提取
-define(P_MOIL_PRESS_RS,                 35080). %  压榨结果
-define(P_MOIL_PRESS_XX,                 35081). % 压榨分红
-define(P_MOIL_MOIL_TIME,                35090). % 打工时间到
-define(P_MOIL_RELEASE,                  35100). % 释放苦工
-define(P_MOIL_RELEASE_RS,               35110). % 结果
-define(P_MOIL_BUY_CAPTRUE,              35120). % 购买抓捕次数
-define(P_MOIL_BUY_OK,                   35130). % 返回消耗信息

%% ==========================================================
%% 36001 - 37000 ( 三界杀 ) 
%% ==========================================================
-define(P_CIRCLE_END,                    37000). % 三界杀
-define(P_CIRCLE_ENJOY,                  36010). % 请求三界杀
-define(P_CIRCLE_2_DATA,                 36011). % 当前章节信息(新)
-define(P_CIRCLE_DATA,                   36020). % 当前章节信息(废除)
-define(P_CIRCLE_DATA_GROUP,             36021). % 当前信息块(废除)
-define(P_CIRCLE_2_DATA_GROUP,           36022). % 当前信息块(新)
-define(P_CIRCLE_RESET,                  36030). % 请求重置
-define(P_CIRCLE_WAR_START,              36040). % 开始挑战

%% ==========================================================
%% 37001 - 38000 ( 世界BOSS ) 
%% ==========================================================
-define(P_WORLD_BOSS_END,                38000). % 世界BOSS
-define(P_WORLD_BOSS_DATA,               37010). % 请求世界boss数据
-define(P_WORLD_BOSS_MAP_DATA,           37020). % 返回地图数据
-define(P_WORLD_BOSS_VIP_RMB,            37051). % 是否开启鼓舞
-define(P_WORLD_BOSS_SELF_HP,            37053). % 玩家当前血量
-define(P_WORLD_BOSS_DPS,                37060). % DPS排行
-define(P_WORLD_BOSS_DPS_XX,             37070). % DPS排行块
-define(P_WORLD_BOSS_WAR_DIE,            37080). % 玩家死亡
-define(P_WORLD_BOSS_WAR_RS,             37090). % 返回结果
-define(P_WORLD_BOSS_EXIT_S,             37100). % 退出世界BOSS
-define(P_WORLD_BOSS_REVIVE,             37110). % 复活
-define(P_WORLD_BOSS_REVIVE_OK,          37120). % 复活成功
-define(P_WORLD_BOSS_ADDITION,           37130). % 随机加成
-define(P_WORLD_BOSS_ADDITION_DATA,      37140). % 加成信息
-define(P_WORLD_BOSS_RMB_ATTR,           37150). % 金元购买
-define(P_WORLD_BOSS_RMB_USE,            37160). % 返回消耗信息

%% ==========================================================
%% 38001 - 39000 ( 目标任务 ) 
%% ==========================================================
-define(P_TARGET_END,                    39000). % 目标任务
-define(P_TARGET_LIST_ASK,               38005). % 请求目标数据
-define(P_TARGET_LIST_BACK,              38010). % 目标数据返回
-define(P_TARGET_MSG_GROUP,              38015). % 目标数据信息块
-define(P_TARGET_REWARD_REQUEST,         38030). % 领取目标奖励

%% ==========================================================
%% 39001 - 40000 ( 英雄副本 ) 
%% ==========================================================
-define(P_HERO_END,                      40000). % 英雄副本
-define(P_HERO_REQUEST,                  39010). % 请求英雄副本
-define(P_HERO_CHAP_DATA,                39020). % 当前章节信息
-define(P_HERO_MSG_BATTLE,               39030). % 战役数据信息块
-define(P_HERO_BUY_TIMES,                39050). % 购买英雄副本次数
-define(P_HERO_BACK_TIMES,               39060). % 购买次数返回
-define(P_HERO_CHAP_DATA_NEW,            39070). % 当前章节信息(new)
-define(P_HERO_MSG_BATTLE_NEW,           39080). % 战役数据信息块(new)

%% ==========================================================
%% 40001 - 40500 ( 签到 ) 
%% ==========================================================
-define(P_SIGN_END,                      40500). % 签到
-define(P_SIGN_REQUES,                   40010). % 请求登陆奖励页面
-define(P_SIGN_DAYS,                     40020). % 连续登陆的天数
-define(P_SIGN_REWARD_INFO,              40030). % 是否领取信息块
-define(P_SIGN_GET_REWARDS,              40040). % 领取奖励
-define(P_SIGN_GET_REWARDS_OK,           40050). % 返回领取奖励信息

%% ==========================================================
%% 40501 - 41500 ( 天宫之战 ) 
%% ==========================================================
-define(P_SKYWAR_END,                    41500). % 天宫之战
-define(P_SKYWAR_TIME_DOWN,              40502). % 天宫之战倒计时
-define(P_SKYWAR_TIME_BUFF,              40505). % 天宫之战暂缓时间戳
-define(P_SKYWAR_ASK_LIMIT,              40510). % 查询是否可参与天宫之战
-define(P_SKYWAR_LIMIT_BACK,             40512). % 是否可参与天宫之战
-define(P_SKYWAR_ENTER,                  40520). % 请求进入(或退出)天空之战场景
-define(P_SKYWAR_ASK_LIST,               40530). % 请求查看攻守列表(上阵)
-define(P_SKYWAR_LIST_DATA,              40531). % 攻守列表
-define(P_SKYWAR_LIST_BACK,              40532). % 攻守列表玩家数据
-define(P_SKYWAR_FIGHT,                  40536). % 请求战斗
-define(P_SKYWAR_ROLE_STATE,             40538). % 玩家死亡状态
-define(P_SKYWAR_STATE_PUNISH,           40539). % 玩家惩罚时间状态
-define(P_SKYWAR_REVIVE,                 40540). % 复活
-define(P_SKYWAR_BOSS_HP,                40541). % 守城大将气血数据(广播)
-define(P_SKYWAR_ASK_SCORE,              40550). % 请求天宫之战积分数据
-define(P_SKYWAR_SCORE_BACK,             40552). % 天宫之战积分数据返回
-define(P_SKYWAR_SCORE_CLAN,             40560). % 帮派积分数据
-define(P_SKYWAR_SCORE_ROLE,             40562). % 个人积分数据
-define(P_SKYWAR_KILL_BOSS_BROAD,        40570). % 击杀boss广播

%% ==========================================================
%% 41501 - 42500 ( 年兽 ) 
%% ==========================================================
-define(P_NIANSHOU_END,                  42500). % 年兽
-define(P_NIANSHOU_CREAT_NIANSHOU,       41510). % 创建年兽
-define(P_NIANSHOU_CREAT_OK,             41520). % 创建成功
-define(P_NIANSHOU_WAR,                  41530). % 挑战开始

%% ==========================================================
%% 42501 - 43500 ( 收集卡片 ) 
%% ==========================================================
-define(P_COLLECT_CARD_END,              43500). % 收集卡片
-define(P_COLLECT_CARD_ASK_LIMIT,        42510). % 查询是否有卡片活动
-define(P_COLLECT_CARD_STATE_REFRESH,    42511). % 卡片活动状态有变化
-define(P_COLLECT_CARD_LIMIT_RESULT,     42512). % 卡片活动开放结果
-define(P_COLLECT_CARD_ASK_DATA,         42520). % 请求卡片套装和奖励数据
-define(P_COLLECT_CARD_DATA_BACK,        42522). % 卡片套装和奖励数据返回
-define(P_COLLECT_CARD_XXX1,             42524). % 套装数据信息块
-define(P_COLLECT_CARD_XXX2,             42526). % 物品信息块
-define(P_COLLECT_CARD_XXX3,             42528). % 虚拟货币信息块
-define(P_COLLECT_CARD_EXCHANGE,         42530). % 请求兑换卡片套装奖励
-define(P_COLLECT_CARD_EXCHANGE_OK,      42532). % 兑换成功
-define(P_COLLECT_CARD_EXCHANGE_COST,    42540). % 请求兑换所需金元
-define(P_COLLECT_CARD_COST_BACK,        42542). % 兑换所需金元

%% ==========================================================
%% 43501 - 44500 ( 跨服战 ) 
%% ==========================================================
-define(P_STRIDE_END,                    44500). % 跨服战
-define(P_STRIDE_ENJOY,                  43510). % 请求跨服战
-define(P_STRIDE_SUPERIOR,               43511). % 请求巅峰之战
-define(P_STRIDE_STATA,                  43520). % 返回报名状态
-define(P_STRIDE_REPORT,                 43530). % 报名
-define(P_STRIDE_REPROT_OK,              43535). % 报名成功
-define(P_STRIDE_RANK,                   43540). % 请求排行榜
-define(P_STRIDE_RANK_DATA,              43550). % 三界争霸/巅峰之战排行榜
-define(P_STRIDE_RANK_2_DATA,            43551). % 三界争霸/巅峰之战排行榜数据块
-define(P_STRIDE_XXX_PATNER,             43552). % 伙伴块
-define(P_STRIDE_WAR_LOGS,               43555). % 战报日志
-define(P_STRIDE_WAR_2_LOGS,             43556). % 战报日志信息块
-define(P_STRIDE_WISH,                   43560). % 许愿
-define(P_STRIDE_WISH_DATE,              43570). % 返回许愿日志
-define(P_STRIDE_WISH_2_DATE,            43571). % 返回许愿日志块
-define(P_STRIDE_WISH_TYPE,              43580). % 玩家许愿类型
-define(P_STRIDE_PARTNER,                43590). % 请求招募伙伴界面
-define(P_STRIDE_SOUL_COUNT,             43600). % 返回橙色精魄数量
-define(P_STRIDE_PARTNER_OK,             43610). % 已招募的橙色伙伴
-define(P_STRIDE_STRIDE_WAR,             43630). % 挑战
-define(P_STRIDE_SUPERIOR_WAR,           43631). % 巅峰之战
-define(P_STRIDE_STRIDE_WAR_RS,          43640). % 挑战结果
-define(P_STRIDE_STRIDE_UP,              43650). % 购买越级挑战
-define(P_STRIDE_BUY_COUNT,              43660). % 购买挑战次数
-define(P_STRIDE_BUY_OK,                 43670). % 购买成功

%% ==========================================================
%% 44501 - 44600 ( 御前科举 ) 
%% ==========================================================
-define(P_KEJU_END,                      44600). % 御前科举
-define(P_KEJU_ASK_KEJU,                 44510). % 请求答题面板
-define(P_KEJU_OK_KEJU,                  44520). % 请求面板成功
-define(P_KEJU_DATI_KEJU,                44530). % 开始答题
-define(P_KEJU_JIEGUO_KEJU,              44540). % 每日答题结果
-define(P_KEJU_JIEGUO_YUQIAN,            44550). % 御前科举答题结果
-define(P_KEJU_RANK_MSG_GROUP,           44555). % 前十名排行榜

%% ==========================================================
%% 44601 - 45600 ( 阎王殿 ) 
%% ==========================================================
-define(P_KINGHELL_END,                  45600). % 阎王殿
-define(P_KINGHELL_ASK_KINGS,            44610). % 请求阎王列表
-define(P_KINGHELL_BACK_KINGS,           44620). % 阎王列表返回
-define(P_KINGHELL_MSG_BACK_KING,        44630). % 阎王列表信息块
-define(P_KINGHELL_MSG_MONS,             44640). % 怪物信息块
-define(P_KINGHELL_ASK_PARTNER,          44650). % 请求挑战伙伴
-define(P_KINGHELL_BACK_PARTNER,         44655). % 挑战伙伴返回
-define(P_KINGHELL_MSG_PARTNER,          44660). % 挑战伙伴信息块
-define(P_KINGHELL_ASK_XJ,               44670). % 请求伙伴心经列表
-define(P_KINGHELL_BACK_XJ,              44675). % 心经返回
-define(P_KINGHELL_MSG_XJ,               44680). % 伙伴心经信息块
-define(P_KINGHELL_MSG_P_XJ,             44685). % 心经信息块
-define(P_KINGHELL_XJ_START,             44690). % 点亮心经境界
-define(P_KINGHELL_XJ_UPDATE,            44695). % 点亮心经成功
-define(P_KINGHELL_XJ_SWITCH,            44700). % 请求心经交换
-define(P_KINGHELL_XJ_SWITCH_OK,         44705). % 心经互换成功
-define(P_KINGHELL_ASK_YUANS,            44720). % 请求阎王元神
-define(P_KINGHELL_BACK_YUANS,           44730). % 阎王元神返回
-define(P_KINGHELL_MSG_YUANS,            44735). % 元神信息块
-define(P_KINGHELL_ASK_FIRBEST,          44740). % 请求首次和最佳记录
-define(P_KINGHELL_BACK_FIRBEST,         44745). % 首次和最佳记录返回
-define(P_KINGHELL_WAR,                  44800). % 请求挑战

%% ==========================================================
%% 45601 - 46000 ( 活动-阵营战 ) 
%% ==========================================================
-define(P_CAMPWAR_END,                   46000). % 活动-阵营战
-define(P_CAMPWAR_ASK_WAR,               45610). % 请求阵营战界面
-define(P_CAMPWAR_OK_ASK_WAR,            45620). % 界面请求返回
-define(P_CAMPWAR_D_TIME,                45630). % 各种倒计时
-define(P_CAMPWAR_CAMP_POINTS,           45640). % 阵营积分数据
-define(P_CAMPWAR_WINNING_STREAK,        45650). % 连胜榜数据
-define(P_CAMPWAR_PLY_DATA,              45655). % 连胜玩家信息块
-define(P_CAMPWAR_SELF_WAR,              45670). % 个人战绩
-define(P_CAMPWAR_ASK_BESTIR,            45680). % 请求振奋
-define(P_CAMPWAR_OK_BESTIR,             45690). % 请求振奋成功
-define(P_CAMPWAR_ATTR_MSG,              45695). % 属性加成信息块
-define(P_CAMPWAR_START_MACHING,         45720). % 开始匹配战斗
-define(P_CAMPWAR_END_WAR,               45750). % 战斗结束
-define(P_CAMPWAR_WAR_DATA,              45755). % 战报数据
-define(P_CAMPWAR_REWARDS_DATA,          45757). % 奖励数据块
-define(P_CAMPWAR_ASK_BACK,              45790). % 请求退出活动
-define(P_CAMPWAR_ASK_WAR_DATA,          45800). % 请求设置战报数据类型
-define(P_CAMPWAR_OK_WARDATA,            45810). % 战报数据返回
-define(P_CAMPWAR_CAMP_END,              45850). % 活动结束

%% ==========================================================
%% 46001 - 46200 ( 幸运大转盘 ) 
%% ==========================================================
-define(P_WHEEL_END,                     46200). % 幸运大转盘
-define(P_WHEEL_XXX1,                    46010). % 奖励物品数据块
-define(P_WHEEL_REQUEST,                 46020). % 请求转盘数据
-define(P_WHEEL_DATA_BACK,               46022). % 转盘数据返回
-define(P_WHEEL_DO,                      46030). % 请求玩转盘
-define(P_WHEEL_IDX,                     46032). % 转盘索引
-define(P_WHEEL_PLAY_END,                46040). % 转盘动画结束
-define(P_WHEEL_LOG,                     46050). % 转盘日志返回

%% ==========================================================
%% 46201 - 47200 ( 魔王副本 ) 
%% ==========================================================
-define(P_FIEND_END,                     47200). % 魔王副本
-define(P_FIEND_REQUEST,                 46210). % 请求魔王副本
-define(P_FIEND_CHAP_DATA,               46220). % 当前章节信息
-define(P_FIEND_MSG_BATTLE,              46230). % 战役数据信息块
-define(P_FIEND_FRESH_COPY,              46250). % 刷新魔王副本
-define(P_FIEND_FRESH_BACK,              46260). % 刷新魔王副本返回
-define(P_FIEND_CHAP_DATA_NEW,           46270). % 当前章节信息(new)
-define(P_FIEND_MSG_BATTLE_NEW,          46280). % 战役数据信息块(new)

%% ==========================================================
%% 47201 - 48200 ( 珍宝阁系统 ) 
%% ==========================================================
-define(P_TREASURE_END,                  48200). % 珍宝阁系统
-define(P_TREASURE_LEVEL_ID,             47201). % 请求层次id
-define(P_TREASURE_REQUEST_INFO,         47210). % 处理藏宝阁面板请求
-define(P_TREASURE_GOODSMSG,             47215). % 物品信息块
-define(P_TREASURE_GOODS_ID,             47220). % 物品打造数据请求
-define(P_TREASURE_ATTRIBUTE,            47230). % 触发属性加成
-define(P_TREASURE_SHOP_REQUEST,         47260). % 请求商店面板
-define(P_TREASURE_MONEY_REFRESH,        47270). % 金元刷新面板
-define(P_TREASURE_INTERVAL_REFRESH,     47275). % 定时刷新
-define(P_TREASURE_SHOP_INFO,            47280). % 返回商店面板数据
-define(P_TREASURE_SHOP_INFO_NEW,        47285). % 返回商店面板数据（new）
-define(P_TREASURE_PURCHASE,             47290). % 请求购买
-define(P_TREASURE_PURCHASE_STATE,       47300). % 购买成功与否
-define(P_TREASURE_IS_COPY,              47310). % 请求副本时候开启
-define(P_TREASURE_COPY_STATE,           47320). % 副本开启状态

%% ==========================================================
%% 48201 - 49200 ( 斗气系统 ) 
%% ==========================================================
-define(P_SYS_DOUQI_END,                 49200). % 斗气系统
-define(P_SYS_DOUQI_STORAGE_DATA,        48201). % 仓库数据
-define(P_SYS_DOUQI_DOUQI_DATA,          48203). % 斗气信息块
-define(P_SYS_DOUQI_ASK_GRASP_DOUQI,     48210). % 请求领悟界面
-define(P_SYS_DOUQI_ASK_START_GRASP,     48211). % 请求开始领悟
-define(P_SYS_DOUQI_OK_GRASP_DATA,       48220). % 领悟界面信息返回
-define(P_SYS_DOUQI_MORE_GRASP,          48223). % 一键领悟数据返回
-define(P_SYS_DOUQI_MSG_MORE,            48225). % 一键领悟数据
-define(P_SYS_DOUQI_ASK_USR_GRASP,       48230). % 请求装备斗气界面
-define(P_SYS_DOUQI_OK_DOUQI_ROLE,       48240). % 装备界面信息返回
-define(P_SYS_DOUQI_ROLE_DATA,           48245). % 伙伴数据信息块
-define(P_SYS_DOUQI_ASK_EAT,             48280). % 请求一键吞噬
-define(P_SYS_DOUQI_EAT_STATE,           48285). % 吞噬结果
-define(P_SYS_DOUQI_EAT_DATA,            48290). % 吞噬结果信息块
-define(P_SYS_DOUQI_LAN_MSG,             48295). % 被吞者位置ID列表
-define(P_SYS_DOUQI_ASK_GET_DQ,          48300). % 请求拾取斗气
-define(P_SYS_DOUQI_OK_GET_DQ,           48310). % 拾取成功
-define(P_SYS_DOUQI_DQ_SPLIT,            48320). % 请求分解斗气
-define(P_SYS_DOUQI_OK_DQ_SPLIT,         48330). % 分解斗气成功
-define(P_SYS_DOUQI_ASK_USE_DOUQI,       48380). % 请求移动斗气位置
-define(P_SYS_DOUQI_OK_USE_DOUQI,        48390). % 移动斗气成功
-define(P_SYS_DOUQI_ASK_CLEAR_STORAG,    48400). % 请求整理仓库 [48201] Type=1

%% ==========================================================
%% 49201 - 50200 ( 日常任务系统 ) 
%% ==========================================================
-define(P_DAILY_TASK_END,                50200). % 日常任务系统
-define(P_DAILY_TASK_DATA,               49201). % 日常任务数据返回
-define(P_DAILY_TASK_REQUEST,            49202). % 请求任务数据
-define(P_DAILY_TASK_DROP,               49203). % 请求放弃任务
-define(P_DAILY_TASK_REWARD,             49204). % 领取奖励协议
-define(P_DAILY_TASK_VIP_REFRESH,        49205). % vip刷新次数
-define(P_DAILY_TASK_TURN,               49206). % 日常任务当前轮次
-define(P_DAILY_TASK_KEY,                49207). % 一键完成日常任务

%% ==========================================================
%% 50201 - 51200 ( 风林山火 ) 
%% ==========================================================
-define(P_FLSH_END,                      51200). % 风林山火
-define(P_FLSH_TIMES_REQUEST,            50210). % 请求剩余次数
-define(P_FLSH_TIMES_REPLY,              50220). % 剩余次数返回
-define(P_FLSH_GAME_START,               50230). % 开始游戏
-define(P_FLSH_PAI_REPLY,                50240). % 牌语返回
-define(P_FLSH_PAI_DATA,                 50250). % 牌语信息块
-define(P_FLSH_PAI_SWITCH,               50260). % 换牌
-define(P_FLSH_SWITCH_DATA,              50270). % 换牌信息块
-define(P_FLSH_GET_REWARD,               50280). % 领取奖励
-define(P_FLSH_REWARD_OK,                50290). % 领取奖励成功

%% ==========================================================
%% 51201 - 52200 ( 每日一箭 ) 
%% ==========================================================
-define(P_SHOOT_END,                     52200). % 每日一箭
-define(P_SHOOT_REQUEST,                 51210). % 请求每日一箭面板
-define(P_SHOOT_REPLY,                   51220). % 每日一箭返回
-define(P_SHOOT_HEAD_INFO,               51230). % 头像信息块
-define(P_SHOOT_AWARD_INFO,              51240). % 获取其他玩家获奖信息块
-define(P_SHOOT_SHOOTED,                 51250). % 请求射箭

%% ==========================================================
%% 52201 - 53200 ( 神器 ) 
%% ==========================================================
-define(P_MAGIC_EQUIP_END,               53200). % 神器
-define(P_MAGIC_EQUIP_REQUEST,           52210). % 请求神器面板
-define(P_MAGIC_EQUIP_ENHANCED,          52220). % 神器强化
-define(P_MAGIC_EQUIP_ADVANCE,           52230). % 神器进阶
-define(P_MAGIC_EQUIP_ENHANCED_REPLY,    52240). % 强化返回
-define(P_MAGIC_EQUIP_NEED_MONEY,        52250). % 神器强化所需要钱数
-define(P_MAGIC_EQUIP_NEED_MONEY_REPLY,  52260). % 神器强化所需要钱数返回
-define(P_MAGIC_EQUIP_ASK_NEXT_ATTR,     52300). % 请求下一级属性
-define(P_MAGIC_EQUIP_ATTR_REPLY,        52310). % 属性返回
-define(P_MAGIC_EQUIP_MSG_ITEM_XXX,      52315). % 材料信息块
-define(P_MAGIC_EQUIP_ATTR,              52320). % 属性值

%% ==========================================================
%% 53201 - 54200 ( 新手特权 ) 
%% ==========================================================
-define(P_PRIVILEGE_END,                 54200). % 新手特权
-define(P_PRIVILEGE_REQUEST,             53210). % 新手特权面板请求
-define(P_PRIVILEGE_REPLY,               53220). % 面板返回
-define(P_PRIVILEGE_OPEN,                53230). % 开通新手特权
-define(P_PRIVILEGE_OPEN_REPLY,          53240). % 开通新手特权成功
-define(P_PRIVILEGE_GET_REWARDS,         53250). % 领取奖励

%% ==========================================================
%% 54201 - 54800 ( 社团BOSS ) 
%% ==========================================================
-define(P_CLAN_BOSS_END,                 54800). % 社团BOSS
-define(P_CLAN_BOSS_TIME_DOWN,           54205). % 活动倒计时
-define(P_CLAN_BOSS_HARM_DATA,           54210). % 伤害数据
-define(P_CLAN_BOSS_START_BOSS,          54220). % 请求开启社团BOSS
-define(P_CLAN_BOSS_ASK_JOIN,            54230). % 请求参加社团BOSS
-define(P_CLAN_BOSS_ACTIVE_STATE,        54235). % 界面信息返回--活动状态
-define(P_CLAN_BOSS_JOIN_DATA,           54240). % 界面信息返回--BOSS信息
-define(P_CLAN_BOSS_RANK_DATA,           54250). % 界面信息返回--排行榜信息
-define(P_CLAN_BOSS_ROLE_DATA,           54255). % 玩家信息块
-define(P_CLAN_BOSS_BUFF_DATA,           54260). % 鼓舞属性加成
-define(P_CLAN_BOSS_BUFF_MSG,            54265). % 属性加成信息块
-define(P_CLAN_BOSS_ASK_INCITE,          54270). % 请求豉舞【54260】
-define(P_CLAN_BOSS_DIED,                54280). % 玩家死亡
-define(P_CLAN_BOSS_DIED_STATE,          54290). % 状态返回
-define(P_CLAN_BOSS_ASK_RELIVE,          54300). % 请求复活
-define(P_CLAN_BOSS_OK_RELIVE,           54305). % 复活成功
-define(P_CLAN_BOSS_ASK_OUT,             54310). % 退出活动

%% ==========================================================
%% 54801 - 55800 ( 格斗之王 ) 
%% ==========================================================
-define(P_WRESTLE_END,                   55800). % 格斗之王
-define(P_WRESTLE_BOOK,                  54801). % 请求活动报名
-define(P_WRESTLE_AREANK_RANK,           54802). % 返回竞技场数据
-define(P_WRESTLE_APPLY,                 54803). % 格斗之王报名
-define(P_WRESTLE_APPLY_STATE,           54804). % 报名状态
-define(P_WRESTLE_TIME,                  54808). % 各种倒计时
-define(P_WRESTLE_PLAYER,                54810). % 玩家信息块
-define(P_WRESTLE_SCORE,                 54815). % 请求积分榜数据
-define(P_WRESTLE_SCORE_MSG,             54818). % 积分榜返回
-define(P_WRESTLE_XXXXX,                 54820). % 玩家积分返回
-define(P_WRESTLE_DROP,                  54830). % 离开格斗之王面板
-define(P_WRESTLE_FINAL_REQUEST,         54850). % 决赛入口
-define(P_WRESTLE_FINAL_INFO,            54860). % 决赛信息
-define(P_WRESTLE_AGAINST,               54870). % 决赛对阵信息返回
-define(P_WRESTLE_GUESS,                 54890). % 欢乐竞猜
-define(P_WRESTLE_CONNET,                54892). % 断线重连
-define(P_WRESTLE_GUESS_STATE,           54900). % 竞猜状态
-define(P_WRESTLE_ZHENGBA,               54910). % 王者争霸入口
-define(P_WRESTLE_ZHENGBA_REQUEST,       54920). % 争霸信息返回
-define(P_WRESTLE_PEBBLE,                54930). % 竞技水晶更新
-define(P_WRESTLE_FINAL_REP,             54940). % 决赛信息2
-define(P_WRESTLE_FINAL_REP_MSG,         54945). % 决赛信息块

%% ==========================================================
%% 55801 - 56800 ( 拳皇生涯 ) 
%% ==========================================================
-define(P_FIGHTERS_END,                  56800). % 拳皇生涯
-define(P_FIGHTERS_REQUEST,              55810). % 请求拳皇信息
-define(P_FIGHTERS_CHAP_DATA,            55820). % 当前章节信息
-define(P_FIGHTERS_MSG_BATTLE,           55830). % 战役数据信息块
-define(P_FIGHTERS_BUY_TIMES,            55840). % 购买挑战次数
-define(P_FIGHTERS_BUY_OK,               55850). % 购买挑战次数成功
-define(P_FIGHTERS_UP_START,             55860). % 开始挂机
-define(P_FIGHTERS_UP_REPLY,             55870). % 挂机返回
-define(P_FIGHTERS_MSG_GOOD,             55875). % 物品信息块
-define(P_FIGHTERS_UP_OVER,              55880). % 挂机完成
-define(P_FIGHTERS_UP_STOP,              55890). % 停止挂机
-define(P_FIGHTERS_UP_STOP_REP,          55895). % 停止挂机返回
-define(P_FIGHTERS_UP_RESET,             55960). % 重置挂机
-define(P_FIGHTERS_UP_RESET_OK,          55970). % 重置挂机成功

%% ==========================================================
%% 56801 - 57800 ( 系统设置 ) 
%% ==========================================================
-define(P_SYS_SET_END,                   57800). % 系统设置
-define(P_SYS_SET_CHECK,                 56810). % 勾选功能
-define(P_SYS_SET_TYPE_STATE,            56820). % 各功能状态
-define(P_SYS_SET_XXXXX,                 56830). % 状态信息块
