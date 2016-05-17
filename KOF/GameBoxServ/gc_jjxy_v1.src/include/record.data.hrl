
%%===========data=============
-record(d_player_init,{
					 pro		=		0,			%% 职业
					 sex		=		0,			%% 性别
					 get_equip  =      [],			%% 初始装备
					 lv			=		0,			%% 等级
					 sence_id	=		0,			%% 场景ID
					 pos_x		=		0,			%% 坐标X
					 pos_y		=		0,			%% 坐标Y
					 dir		=		0,			%% 初始移动方向
					 skin		=		0,			%% 皮肤
					 speed		=		0,			%% 移动速度
					 bag_max	=		0,			%% 背包最大容量
					 bag_usable	=		0,			%% 背包开格数量	 
					 talent		=		0,			%% 天赋
					 position	=		0,			%% 阵位
					 skill_id   = 		0,			%% 出事技能ID
					 attack_type=		0,			%% 攻击类型
					 attr		=	    ?null		%% 属性#attr{}
					}).

-record(d_player_initial,{
					 	pro			= 0,			%% 职业
						skill_id	= [],			%% 技能列表
					 	attr		= ?null			%% 属性#attr{}
						}).

-record(d_player_source,{
						 source       = 0,               %% 版本ID
						 gold         = 0,               %% 银元
						 rmb          = 0,               %% 金元
						 bindrmb      = 0,               %% 绑定金元
						 rmb_total    = 0,               %% VIP经验
						 bag          = []              %% 背包
						}).

%% 伙伴
-record(d_partner,{
						 partner_id		=	0,			%% 伙伴ID
						 partner_name	=	<<>>,		%% 伙伴名称
						 name_colour		=	0,			%% 名称颜色
						 pro				=	0,			%% 职业
						 sex				=	0,			%% 性别
 						 call_lv			=   0,			%% 招募等级
						 use_limi		=   0,          %% 是否可招募
						 use_renown		=	0,			%% 招募所达声望值
						 shinwakan		=   0,			%% 招募所需好友度
						 pay				=   [],			%% 消费
						 country			=	0,			%% 阵营
						 talent			=	0,			%% 天赋
						 ai_id        	=   0,      		%% AIID
						 skill_ids		=	0,			%% 技能ID
						 attack_type		=	0,			%% 攻击类型
						 attr			=	?null		%% 属性#attr{}
					   }).

%% 声望
-record	(d_renown,{ 
				   lv           = 0,                %% 声望等级
				   renown_up    = 0,          		%% 等级所需声望
				   sub_renown   = 0,            	%% 每日消耗声望
				   role_sum     = 0,              	%% 可携带角色（个数）
				   role_war     = 0,              	%% 可出战角色（个数）
				   type_bonus   = [],             	%% 属性加成
				   money		= 0,				%% 铜钱（每日俸禄）
				   star			= 0					%% 星魂（每日俸禄）
				  }).

%% 怪物
-record(d_monster,{
				   monster_mid		= 0,	%% 生成ID
				   monster_id		= 0,	%% 编号(大于100)			  
				   monster_type		= 0,	%% 怪物种族
				   attack_type  	= 0,	%% 攻击类型	
				   attack_distance 	= 0,	%% 攻击距离		
				   lv			   	= 0,	%% 等级
				   steps			= 0,	%% 等阶	
				   scene_id			= 0,	%% 场景
				   ai_id			= 0,	%% Ai ID
				   skill			= [],	%% 怪物技能[{技能ID,等级},{技能ID,等级}]	
				   immunity			= 0, 	%% 免疫技能效果
				   drop_goods		= [],	%% 掉落物品
				   delay			= 0,	%% 副本AI延迟时间
				   attr				= ?null %% 25个属性#attr{}
				 }).

-record(d_task, {
				 id        	= 0,      		% 任务ID 
				 lv	  	  	= 0,			% 接受等级
				 accept	  	= 0,			% 可接状态 0:激活列表(隐藏)  1:可接列表  2:已接受列表
				 submit	  	= 0,			% 提交方式 0:NPC对话完成   1:直接完成
				 is_give_up	= 0,			% 是否可放弃 0:不可以  1：可以
				 is_skip	= 0,			% 跳级是否可呼略 0:不可以呼略   1:可以呼略
				 is_quick  	= 0,			% 是否可快速完成呼略 0:不可以快速完成   1:可以快速完成
				 type	 	= 0,			% 任务类型 1:主线任务 2:支线任务 3:日常任务 4:家族任务 5:其他任务 6:活动
				 drama_id  	= 0,			% 压屏剧情
				 drama_touch= 0,			% 剧情触发
				 loop	  	= 0,			% 每天重复次数(1表示:不可重复;其他表示:次数)
				 timed		= 0,			% 限时(不限时:0 限时:{[<周天数,[]每天,[1,3,7]周一周三周日>],{开始小时24,开始分},{结束小时,结束分}})
				 shape		= 0,			% 变身(不变身:0 变身:{女生皮肤,男生皮肤,属性1,属性1值 [正加,负减],属性2,属性2值})
				 country	= 0,			% 国家要求 0:无限制(默认) 	1 => '人' , 2 => '仙'，3 => '魔'
				 accept_id 	= 0,			% 接任务要求属性ID(见常量:玩家属性(更新/任务)地图广播)
				 accept_v  	= 0,			% 接任务要求属性具体值
				 npc_s 	  	= 0, 			% 开始NPC id
				 npc_e	  	= 0, 			% 结束NPC id
				 target_t  	= 0,			% 任务目标     1:对话类 2:收集类 3:击杀怪物 4:击杀玩家 5:问答题 6:其它(首次充值,加入家族,商城购买,装备打造) 
				 target_v  	= 0,			% 目标值
											% 	1:对话      0 
											% 	2:收集      {场景ID,[{怪物ID,掉落机率,物品Give,收集数量},..]} 
											% 	3:杀怪      {场景ID,[{怪物ID,击杀数量},..]} 
											% 	4:击杀玩家  {场景ID,击杀模试,击杀数量} 										
											% 	5:问答题    答案 											
											% 	6:其它      {功能ID,值1,值2,值3,值4,值5} 										
											% 	7:副本      {副本ID} 
				 pre		= 0,			% 引入任务ID
				 next	  	= 0,			% 任务ID
				 next_ext	= [],			% 扩展后置任务
				 exp	  	= 0,			% 经验
				 exp_c	  	= 0,			% 家簇经验类
				 gold	  	= 0,			% 金币
%% 				 goldbind  	= 0,			% 邦定金币
				 goods	  	= [],			% 物品
				 ext_id	  	= 0,			% 其他奖励属性ID(见常量： 玩家属性(更新/任务)地图广播)
				 ext_v	  	= 0				%  奖励属性具体值
				}).

-record(d_skill_start,{
					   pro          = 0,           %% 职业ID
					   skill_default = [],         %% 初始技能
                       skill_learn   = []          %% 要学习的技能                                  
					  }).

-record(d_task_addto,		{
							 task_id      = 15,              %% 任务ID
							 valid        = 0,               %% 是否有效
							 type         = 1,               %% 可接条件类型
							 value        = 0,               %% 可接条件值
							 ext1         = 0,               %% 扩展参数1
							 ext2         = 0,               %% 扩展参数2
							 ext3         = 5                %% 扩展参数3
							}).


%	材料2数量	打造物品ID	材料3数量	打造物品ID	材料4数量	打造物品ID	材料5数量	消耗货币类型1	消耗货币值1	消耗货币类型2	消耗货币值2	消耗货币类型3	消耗货币值3

%% 装备首饰打造
-record(d_equip_make,		{
							 goods_id     = 0,           %% 打造物品ID
							 str_need	  = 0,			 %% 所需强化等级
							 lv_last      = 0,           %% 强化后等级
							 lv_last2     = 0,           %% 打造后强化等级
							 make1		  =?null         %% 打造材料 
							 }).	

-record(d_make, 			{
							 goods=0,   %% 打造生成的物品ID
							 lv=0,		%% 打造所需等级
							 item1=0,	%% 打造材料ID1
							 count1=0,	%% 打造材料1数量
							 item2=0,	%% 打造材料ID2
							 count2=0,	%% 打造材料数量2
							 item3=0,	%% 打造材料ID2
							 count3=0,	%% 打造材料数量2
							 ct=0,		%% 打造消耗类型
							 cv=0		%% 打造消耗值
							 }).

%% 法宝打造
-record(d_magic_make,		{
							 id           = 0,            	 %% 法宝ID
							 item1        = 0,           	 %% 打造材料1
							 count1       = 0,               %% 材料1数量
							 item2        = 0,            	 %% 打造材料2
							 count2       = 1,               %% 材料2数量
							 type         = 1,               %% 消耗货币类型
							 value        = 1,               %% 消耗货币值
							 part1        = 1,               %% 拆分获得材料1
							 partc1       = 1,               %% 拆分获得材料1数量
							 part2        = 1,               %% 拆分获得材料2
							 partc2       = 1                %% 拆分获得材料2数量
							}).

%% 物品强化
-record(d_equip_stren,      {
							 lv           = 0,               %% 强化等级
							 color        = 0,               %% 颜色
							 typesub      = 0,               %% 子类型
							 class        = 0,               %% 等阶
							 odds         = 0,     		     %% 强化机率
							 lose_lv      = 0,               %% 失败后强化等级
							 value        = 0,               %% 强化数值
							 money        = 0,               %% 消耗铜钱
							 item1        = 0,               %% 材料ID1
							 count1       = 0,               %% 材料1数量
							 rep_t1       = 0,               %% 金币替代材料1单价
							 item2        = 0,               %% 材料ID2
							 count2       = 0,               %% 材料2数量
							 rep_t2       = 0,               %% 金币替代材料2单价
							 item3        = 0,               %% 材料ID3
							 count3       = 0,               %% 材料3数量
							 rep_t3       = 0,               %% 金币替代材料3单价
							 sell_price   = 0,				 %% 出售价格
							 attr		  = ?null
							}).

%% 藏宝阁
-record(d_hidden_treasure,   {
							  hidden_layer_id = 0,         %% 藏宝阁层数_ID
							  open_lv      =0,             %% 开通等级
							  all_items    =[],            %% 物品ID（顺时针)
							  linking_items =[],           %% 物品连成线
							  attr		    =?null		   %% 属性#attr{}
							 }).

%%藏宝阁商店
-record(d_hidden_store,     {
							 goods_id     = 0,            %% 道具ID
							 goods_count  = 0,            %% 道具数量
							 appear_odds  = 0,            %% 出现权重
							 price_type   = 0,            %% 价格类型
							 price        = 0             %% 价格
							}).

%%藏宝阁打造表
-record(d_hidden_make,     {
							items_id     = 0,            %% 打造后物品ID
							make         = [],
                            level        = 0
							}).

-record(d_task_daily,     { node = 0,
                            type = 0, 
                            copys_id = 0, 
                            value = 0, 
                            exp = 0, 
                            goods_count = 0, 
                            money = 0,
                            energy = 0, 
                            rmb = 0,
                            renown = 0
						   }).                          

-record(d_task_daily_lv,{
						 lv           = 100,             %% 人物等级
						 list         = [1211,1216,1221,1226,1231,1236,1241]%% 任务列表
						}).

-record(d_hidden_line,     {
                            goods_id     = 0,             %% 物品id
                            keyid        = []             %% 影响的key
                            }).							  

%% 法宝升阶
-record(d_magic_upgrade,      {
							   class        = 0,               %% 法宝等阶
							   vip          = 0,               %% vip等级需求
							   cost_t       = 0,               %% 消耗类型
							   cost_v       = 0      	       %% 消耗值
							  }).

%% 洗练消耗
-record(d_wash_cost,		  {
							   type         = 0,              %% 洗练类型
							   lv           = 0,              %% 等级
							   color        = 0,              %% 颜色
							   ctype        = 0,              %% 消耗货币类型
							   cvalue		= 0				  %% 消耗货币值
							   }).

%% npc位置
-record(d_npc,				{
							 npc_id,			%% npc id
							 type,				%% npc类型 
							 scene_id,			%% 所在场景ID
							 func,				%% 功能
 							 x,					%% 位置x
							 y					%% 位置y
							 }).

%% 星阵图
-record(d_star,				{
							 pro,
							 star_id,			% 星阵图ID
							 star_lv,			% 星阵图等级 
						 	 star_must,		    % 星阵图消耗星魂值
						 	 star_next,		    % 星阵图下一等级
							 name_colour,		% 主角名字颜色
						 	 array_pos,		    % 星阵图效果阵位
							 array_attr,		% 阵行加成
						 	 star_skill,		% 星阵图技能学习
							 matrix_attr	    % 星阵图基本属性加成#attr{}
							 }).
%% 场景数据--scene
-record(d_scene,	{
					 scene_id		= 0,			% 场景ID
					 material_id	= 0,			% 素材ID					 

					 copy_id		= 0,
					 lv				= 0,			% 地图需求等级
					 scene_type		= 0,			% 地图类型

					 pass_type		= 0,			% 通关类型
					 pass_value		= 0,			% 通关值

					 war_cd			= 0,			% 战斗间隔CD(0:无CD|具体数字:单位秒)
					 reborn_cd		= 0,			% 复活CD
					 reborn			= [],			% 复活数据{阵营(活动对伍),场景ID,安全区(格),X(格),Y(格)} 如:[{CountryID,SceneID,Area,X,Y}]
					 born			= [],			% 场景的出生点{阵营(活动对伍),安全区(格),X(格),Y(格)}    如:[{CountryID,Area,X,Y}]
					
					 buff_state		= 0,			% BUFF持续状态(0:没有|1:退出场景后消失|2:退出后再进入时存在)
					 attr_bonus		= [],			% 地图属性加成
					 attr_add		= 0,			% 属性加成是否叠加
					 exp_revise		= 0,		    % 经验校正
					 flop_revise	= 0,			% 掉落校正
					 
					 is_team		= 0, %% 组队
					 is_flyin		= 0, %% 飞入	
					 is_flyout		= 0, %% 飞出
					 is_train		= 0, %% 修炼
					 is_button		= 0, %% 显示按钮
					 is_par			= 0, %% 显示伙伴
					 is_save		= 0, %% 保存进度	
					 is_matte		= 0, %% 迷雾遮罩		
					 is_map			= 0, %% 小地图是否显示	
					 is_ride		= 0, %% 是否可以坐骑		
					 is_mount		= 0, %% 坐骑效果加成
					 war_reward		= [],%% 场景战斗奖励
					 
					 door			= [],% 传送点     [{传送点类型,传送点ID,坐标X,坐标Y,目标地图ID,目标地图X,目标地图Y},...] 
					 npc			= [],% NPC列表  [{NPC_id,坐标X,坐标Y},...]
					 collect		= [],% 采集列表[{MonsterId,坐标X,坐标Y,采集时间,刷新间隔,总数},...]
					 monsters		= [] % 怪物列表 [{MonsterID,坐标X,坐标Y,刷新间隔,总数},...]
					 }).

%% 场景(地图)
-record(d_material,	{
					 id				= 0,			% 素材ID 
					 scale       	= 1,	        % 格子大小"
					 image_height	= 0,			% 素材像素高
					 image_width	= 0,			% 素材像素宽
					 tile_height	= 0,			% 素材格子tile高
					 tile_width		= 0,			% 素材格子tile宽
					 move_height	= 0,			% 可行高度
					 excess_bottom	= 0,			% 底部多余部份
					 path			= <<>>			% 行走点
					 }).


%% 副本
-record(d_copy,			{
						copy_id		= 0,	% 副本Id
						copy_type	= 0,	% 类型
						type_sub	= 0,	% 子类型

						pass_type	= 0,	% 副本通关类型
						pass_value	= 0,	% 副本通关值

						relive_lim	= 0,	% 可以复活次数

						is_save		= 0,	% 是否保存
						difficulty	= 1,	% 副本难度
						ext_id		= 0,	% 奖励 - 属性常量
						ext_v		= 0,	% 奖励 - 属性值

						belong_id   = 0,	% 上级Id(退出副本回去的场景ID)
						key_id		= 0,    % 条件主健
						task_id		= 0,	% 前置任务，没有则为0
						pre_copy_id = 0,	% 前置副本Id
						next_copy_id= 0,	% 下一个副本Id
						key_goods_id= 0,	% 开启钥匙物品Id

						lv			= 0,	% 等级
						lv_max		= 0,	% 等级上限
						time		= 0,	% 限时(秒)
						use_energy	= 0,	% 消耗体力\n"
						fast_vip	= 0,	% 挂机加速VIP等级
						score_id	= 0,	% 评分Id

						times_max_day	= 0,	% 每天上限次数
						
						flop			= [],	% 掉落
						scene			= []	% 场景列表
					}).
%% 副本评价奖励
-record(d_copy_reward,{
						copy_id      = 0,        % 副本ID
						a_exp        = 0,        % A评价经验
						a_money      = 0,        % A评价银币
						a_goods      = [],		 % A评价物品
						a_power		 = 0,		 % A评价战功
						b_exp        = 0,        % B评价经验
						b_money      = 0,        % B评价银币
						b_goods      = [],		 % B评价物品
						b_power		 = 0,		 % B评价战功
						c_exp        = 0,        % C评价经验
						c_money      = 0,        % C评价银币
						c_goods      = [],		 % C评价物品
						c_power		 = 0		 % C评价战功
					}).

%% 副本评分奖励
-record(d_copy_score,	{
						 id			= 0,		%% 评分Id
						 type		= 0,		%% 分数等级
						 level		= 0,		%% 评分类型
						 start_score= 0,		%% 开始值
						 end_score	= 0,		%% 结束值
						 value		= 0			%% 评分
						}).
%% 根本等级找副本ID
-record(d_keycopy,	{
						serial			 = 0,	% 等级范围序号
						start_lv		 = 0,	% 开始等级
						end_lv			 = 0,	% 结束等级
						copy_id			 = 0	% 副本ID
						}).

%% 风林山火奖励数据
-record(d_flsh_reward,	{
							sz_num       = 0,   %% 顺子数
							same_num     = 0,   %% 相同牌数
							dz_num       = 0,   %% 对子数
							money        = 0,	%% 美刀
							renown		 = 0	%% 声望
						}).
%% 坐骑
-record(d_mount,		{
						mount_id    	 = 0,           %% 坐骑ID
						lv          	 = 0,           %% 坐骑等级
						lv_role			 = 0,			%% 人物等级限制
						next_id     	 = 0,           %% 下一阶段ID
						next_exp    	 = 0,           %% 下一级所需经验
						common_exp		 = 0,          	%% 普通培养经验
						common_ten_opp 	 = 0,         	%% 普通培养突进概率
						common_time  	 = 0,           %% 普通倍率
						common_up_opp 	 = 0,         	%% 普通培养突破概率
						gold_exp     	 = 0,          	%% 元宝培养经验
						gold_ten_opp 	 = 0,          	%% 元宝培养突进概率
						gold_time    	 = 0,           %% 元宝倍率
						gold_up_opp  	 = 0,           %% 元宝培养突破概率
						good_exp     	 = 0,           %% 道具培养经验
						good_ten_opp 	 = 0,           %% 道具培养突进概率
						good_time    	 = 0,           %% 道具倍率
						good_up_opp  	 = 0,           %% 道具培养突破概率
						strong_att   	 = 0,          %% 物理攻击
						strong_def   	 = 0,           %% 物理防御
						magic_att    	 = 0,           %% 法术攻击
						magic_def    	 = 0,           %% 法术防御
						att_speed    	 = 0,           %% 速度
						hp           	 = 0            %% 气血
						}).
%% 招财
-record(d_weagod,		{
						lv           	= 0,            %% 玩家等级
						money			= 0,			%% 获得美金
						auto_money		= 0				%% 自动招财铜钱
						}).
%% 招财次数
-record(d_weatimes,		{
						lv				= 0,			%% VIP等级
						times			= 0				%% 招财次数
						}).
%% 招财次数和所需元宝
-record(d_god_times,	{
						times			= 0,			%% 招财次数
						gold			= 0				%% 所需元宝
						}).
%% 任务目标
-record(d_target,		{
						serial			= 0,			%% 目标序号
						type			= 0,			%% 目标类型
						value			= 0,			%% 目标值
						next			= 0,			%% 下个目标序号
						goods_count		= []			%% 奖励物品和数量
						}).

%% 各种副本章节
-record(d_copy_chap,	{
						type			= 0,			%% 章节类型
					 	chap_id			= 0,			%% 章节ID
						chap_lv			= 0,			%% 章节等级
					 	copy_id			= 0,			%% 战役(副本)列表
					 	pre_chap_id		= 0,			%% 上一个章节ID
					 	next_chap_id	= 0,			%% 下一个章节ID
						reset_rmb		= 0,			%% 挂机重置消耗钻石
						chap_reward		= []			%% 章节奖励
					}).
%% 取经之路采集怪
-record(d_pilroad_collect,	{
							monster_id		= 0,			%% 采集怪ID
							type			= 0,			%% 采集怪类型
							attr_value		= []			%% 采集怪属性值
							}).

%% 传送门
-record(d_scene_door,	{
						 door_id      = 0,         
						 type         = 0,           
						 transfer_id  = 0           
						}).
%% 苦工权限
-record(d_moil,		{
						type_id			= 0,			%% 身份类型
						captrue			= 0,			%% 抓捕
						active			= 0,			%% 互动
						press			= 0,			%% 压榨
						calls			= 0,			%% 求救
						protest			= 0				%% 反抗
						}).

%% 苦工权限
-record(d_moil_exp,		{
						 lv           = 0,            	%% 等级
						 active_exp   = 0,          	%% 互动经验
						 exp_max      = 0,           	%% 经验上限
						 moil_exp     = 0           	%% 苦工打工经验
						}).

%% d_clan
-record(d_clan,		{
					 lv				= 0,			%% 帮派等级
					 devote			= 0,			%% 帮派本级升级贡献
					 devote_up		= 0,			%% 帮派下一级升级贡献
					 max			= 0,			%% 帮派成员上限
					 exp_plus		= 0,			%% 关卡经验加成
					 gold_plus		= 0,			%% 关卡铜钱加成
					 tineng_limit	= 0,			%% 体能培养等级上限
					 boss_times		= 0,			%% 帮派BOSS次数
					 copy_times		= 0,			%% 副本次数
					 copy_id		= 0				%% 副本ID
					 }).

-record(d_clan_skill,  {
						skill_lv     = 0,             %% 等级
						cast         = 0,             %% 体能消费
						strong_att   = 0,             %% 物理攻击
						strong_def   = 0,             %% 物理防御
						skill_att    = 0,             %% 技能攻击
						skill_def    = 0              %% 技能防御
					   }).


-record(d_clan_yqs_lv,	{
						 yqs_lv       = 0,               %% 等级
						 yqs_exp      = 0,         		 %% 当前等级下限值
						 yqs_exp_up   = 0,         		 %% 下一级升级值
						 rewards      = [],				 %% 摇钱奖励
						 times		  = 0				 %% 摇钱次数
						}).


%% -record(d_clan_role, {
%% 					  rank         = 1,            %% 排名
%% 					  exp_persend  = 0,            %% 帮派贡献
%% 					  money        = 0,            %% 铜钱
%% 					  exp          = 0,            %% 经验
%% 					  rmb_band     = 0,            %% 绑定元宝
%% 					  renown       = 0,            %% 声望
%% 					  star         = 0,            %% 星魂
%% 					  goods        = []			   %% 物品
%% 					 }).

-record(d_word,		{
					 id,
					 str,
					 msg
					 }).

%% 商城
-record(d_mall_name,	{
					 	mall_id		= 0, 	%% 商城ID	
						%mall_name	= <<>>,	%% 名称	
						vip			= 0,	%% 打折VIP等级	
						vip_discount= 0,	%% 打折	
						open_lv		= 0,	%% 开放等级	
						open_type	= 0,	%% 开放类型	
						open_arg	= [],	%% 开放参数	
						open_start	= {0,0},	%%  开始时间{24小时,分钟}
						open_end	= {23,59}	%%  结束时间{24小时,分钟}
						%explain	= <<>>	%% 说明
						}).

%% 商城 分类
-record(d_mall_class,	{
						  mall_id	= 0,		%% 商城ID	
						  class_id	= 0,		%% 分类ID	
						  %%class_name= <<>>,	%% 分类名称	
						  is_discount = 1		%%  是否打折
						 }).

%% 商城  物品
-record(d_mall_goods,	{
						  id		= 0,		%% ID
						  mall_id	= 0,		%% 商城ID
						  class_id	= 0,		%% 商城分类ID
						  currency	= 0,		%% 货币类型
						  s_price	= 0,		%% 价格
                          o_price	= 0,		%% 原来价格
					      count     = 0, 		%% 数量
						  swap_goods_id	= 0,	%% 兑换所需物品
						  swap_count	= 0,	%% 兑换所需物品数
						  sort		= 0,		%% 排序
						  quick		    = 0,	%% 是否快速购买
						  limit_all		= 0,	%% 每天的总限量
						  limit			= 0,	%% 每人每天限量
						  lv			= 0,	%% 大于这个等级才显示和购卖
						  ext_k			= 0,	%% 扩展属性
				          ext_v			= 0,	%% 扩展属性值
						  give			= ?null	%% GoodsGive
						}).


%% 活动面板
-record(d_activity_panel,{
					 	id		=  0,% 唯一ID
						type	=  0,% 分类(任务)	
						lv		=  0,% 等级	
						times	=  0,% 次数	
						number	=  0,% 人数	
						week	=  0,% 日期(星期)	
						time	=  0,% 时间	
						enter	=  0,% 函数入口
						show	=  0,% 是否一直显示
						open_event	=  0,% 	打开#事件
						open_scene	=  0,%  打开#场景
						open_scene_x	=  0,% 	打开#场景坐标X
						open_scene_y	=  0,% 	打开#场景坐标Y
						open_arg		=  0 % 	打开#参数
						}).


%% 三界杀
-record(d_circle,	{
					 chap         = 3,               		%% 章节
					 lv			  = 0,						%% 等级
					 id           = 10071,           		%% 武将ID
					 idx          = 5,               		%% 武将位置
					 next         = 0,              	 	%% 下一个开启武将
					 flop_odds    = [],						%% 章节物品掉落几率
					 vip          = {0,0,0,0,0,0,0,0,0}		%% vip次数
					}).


%% Vip
-record(d_vip,    	{
					 lv           = 0,               %% VIP等级
					 vip_up       = 0,               %% 充值元宝数
					 sub_rmb      = 0,               %% RMB
					 energy_max   = 0,               %% 体力上限增加
					 bag_max      = 0,               %% 背包增加
					 bowl_max     = 0,               %% 增加聚宝盆次数
					 energy_buys  = 0,               %% 购买体力次数
					 mining_tim   = 0,               %% 挖金矿次数
					 tran_buy     = 0,               %% 购买精英副本次数
					 charity_tim  = 0,               %% 日行一善次数
					 daily_tim    = 0,               %% 日常任务刷新次数
					 energy_add   = 0,               %% 0点额外赠送体力
					 dia_got      = 0,               %% 一键合成宝石
					 jewel_got    = 0,               %% 一键合成珍宝
					 douqi_times  = 0,               %% 金元领悟次数
					 fiend_times  = 0,               %% 每日刷新魔王副本次数
					 cat_times    = 0,               %% 帮派招财猫次数
					 career_refresh = 0,             %% 拳皇生涯重置次数
					 tim_exit3    = 0,               %% tim_exit3
					 tim_exit4    = 0,               %% tim_exit4
					 tim_exit5    = 0,               %% tim_exit5
					 tim_exit6    = 0,               %% tim_exit6
					 tim_exit7    = 0,               %% tim_exit7
					 tim_exit8    = 0,               %% tim_exit8
					 tim_exit9    = 0,               %% tim_exit9
					 tim_exit10   = 0,               %% tim_exit10
					 tim_exit11   = 0,               %% tim_exit11
					 tim_exit12   = 0,               %% tim_exit12
					 tim_exit13   = 0,               %% tim_exit13
					 tim_exit14   = 0,               %% tim_exit14
					 tim_exit15   = 0                %% tim_exit15
					}).


%% 签到
%% -record(d_sign,    	{
%% 					 num          = 0,              	%% 天数
%% 					 rewards      = [],					%% 奖励{一号钱袋，驭兽铃铛}
%% 					 vgoods       = []					%% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6|精魄7}
%% 					}).
-record(d_sign,		{
						 day          = 0,              %% 天数
						 reward_1     = 0,              %% 奖励1
						 count_1      = 0,              %% 奖励1数量
						 reward_2     = 0,              %% 奖励2
						 count_2      = 0,              %% 奖励2数量
						 reward_3     = 0,              %% 奖励3
						 count_3      = 0,              %% 奖励3数量
						 reward_4     = 0,              %% 奖励4
						 count_4      = 0               %% 奖励4数量
						}).

-record(d_privilege,		{
						day          = 0,               %% 天数
						gold         = 0,             %% 美刀数量
						rmb          = 0               %% 钻石数量
						}).

-record(d_energy_buy, {
					   times          = 0,              %% 购买次数
					   use_rmb          = 0,              %% 花费元宝数
					   add_energy   = 0               %% 增加体力
					  }).

%% -record(d_energy_vip,{
%%                       vip_lv        =0,               %% VIP等级	 	
%% 					  tim_energy    =0,               %% 购买精力次数
%% 					  max_energy    =0                %% 精力上限
%% 					 }).

-record(d_vipsign,    	{
						 vip_lv       = 0,               %% VIP等级
						 rewards      = [],				%% 奖励{一号钱袋}
						 vgoods       = []				%% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6|精魄7}
						}).

-record(d_lv_goods,			{
						 goods_id     = 41006,           %% 物品ID
						 range_lv     = 1,               %% 等级段
						 get_goods	  = []				 %% 物品库
							}).

-record(d_times_goods,		{
							goods_id     = 0,           %% 物品ID
							times        = 0,            %% 次数
							type         = 0,               %% 货币类型
							value        = 0,             %% 货币数量
							goods        = []%% 物品
							}).

-record(d_task_rand,		{
							 node         = 1,               %% 任务节点
							 type         = 1,               %% 事件类型
							 value        = 5,               %% 事件目标值
							 goods_count  = [],%% 奖励物品
							 step         = 0,               %% 移动节点数
							 gold         = 0,               %% 银元
							 energy       = 0,               %% 精力
							 point        = 0,               %% 金元
							 renown		  = 0				 %% 声望
							}).

-record(d_task_rand_box,	{
							 node         = 15,              %% 任务节点
							 type         = 1,               %% 事件类型
							 value        = 0,               %% 事件目标值
							 goods_count  = [],%% 奖励物品
							 gold         = 0,               %% 银元
							 point        = 0,               %% 金元
							 energy       = 0               %% 精力
							}).

-record(d_sales_total,		{
							 id           = 1,               %% 活动ID
							 type         = 1,               %% 活动类型
							 is_have	  = 0,				 %% 活动是否存在   0:不存在   1:存在
							 valid        = 1,               %% 是否有效      0:不生效   1：生效
							 type_getshow = 0,				 %% 全部领取完是否消失 0：不消失  1：消失
							 s_id         = 0,               %% 有效服务器ID  0:都生效 []:都不生效 [Sid1,Sid2]:指定生效服务器
							 time         = []               %% 生效时段           
															 %%     []:一直生效
															 %%     [{StartM,StartD,StartH,StartI,StartS,EndM,EndD,EndH,EndI,EndS},..]:  自然时间{月,日,时,分,月,日,时,分}
															 %%     [{open,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS},..]:  开服时间(开服当天算第一天){开服天数,时,分,开服天数,时,分}  
															 %%     [{week,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS},..]:  每周活动(1-7){星期几,时,分,星期几,时,分}  
															 %%     [{month,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS},..]: 每月活动(1-31){几号,时,分,几号,时,分} 
							}). 

-record(d_sales_sub,		{
							 id           = 0,               %% 活动ID
							 id_sub       = 0,             %% 阶段ID
							 cid		  = 0,				%% 平台Id
							 value        = {500,999},       %% 阶段值
							 times		  = 0,				%% 可领取次数
							 virtue       = []	%% 奖励物品
							}).
%-----------------------------------------------------------------------------------------
%% 保卫经书--Buff
-record(d_defend_book_buff,{
							id		= 0,			%% buff编号
							harm    = 0,			%% 伤害值
							tone_up = 0				%% 增益值
						   }).
%% 保卫经书--怪物
-record(d_defend_book_monster, {
								war_num			= 0,			%% 第几波怪物
								monters_id 	 	= 0,			%% 怪物Id
								integral		= 0,			%% 击杀怪物积分
							    kill_rewards	= []			%% 击杀怪物奖励
							   }).

%% 保卫经书--排行奖励
-record(d_defend_book_rank, {
								rank			= 0,			%% 排名
								money_persend 	= 0,			%% 铜钱*10000
								exp_persend		= 0,			%% 经验*10000
								star			= 0,			%% 排行奖励星魂
								goods			= 0				%% 排行奖励物品
							   }).

%% 保卫经书--攻击奖励
-record(d_defend_book_reward, {
								lv			= 0,			%% 人物等级
								exp 		= 0,			%% 攻击奖励经验
								gold_max	= 0				%%  攻击奖励铜钱
							   }).

%% 钓鱼达人--奖励
-record(d_fishing_reward, {
							num			= 0,			%% 鱼的品阶
							rewards		= [],			%% 奖励
							reward_show	= []			%% 奖励显示
						   }).
%% 龙宫寻宝--奖励
-record(d_dragon_reward, {
							num		= 0,			%% 寻宝类型
							rewards		= []			%% 奖励
						   }).


%% 天宫之战
-record(d_sky_war_rank,		{
							 win_type     = 0,               %% 胜利方类型
							 rank         = 0,               %% 排名
							 goods        = []%% 物品
							}).

%% 收集卡片
-record(d_collect_card,		{
							 id           = 0,               %% 卡片套装ID
							 cost         = [],     %% 套装物品ID列表
							 currency     = [],              %% 奖励虚拟货币
							 virtue       = []%% 奖励物品
							}).

%% 日期活动
-record(d_acty_date,		{
							 id           = 1,               %% 活动ID
							 is_have	  = 1,				 %% 是否有效
							 type         = 1,               %% 开放时间类型
							 time         = [],%% 开放日期时间
							 lv           = 1,               %% 等级
							 sid          = []              %% 开放服务器ID
							}).

%% 跨服许愿
-record(data_wish_reward , {
						    type         = 0,              	 %% 许愿类型
						    money_type   = 0,         		 %% 消费银元
						    gold         = 0,              	 %% 消费金元
						    renown       = 0,            	 %% 声望奖励
						    orange_soul  = 0              	 %% 橙色精魄奖励
						  }).

-record(d_scores, 			{
				  			 people       = 0,               %% 人数
				   			 win_score    = 0,               %% 胜利积分
				   			 fail_score   = 0,               %% 失败积分
				   			 goods        = [],          	 %% 物品
				  			 title        = 0                %% 称号
				  			}).

%% 科举题目
-record(d_keju_timu,      {
                           id           =0,                  %% 题目id
					       answer       =0                   %% 题目答案
                          }).

%% 每日答题奖励 
-record(d_answer_day, {
						  title             = 0,               %%题目数量
						  money             = 0,               %%奖励银元
						  exp               = 0,               %%奖励经验
						  goods             = []               %%物品 
						 }).

%% 御前科举奖励
-record(d_answer_weeken,{
						 title             = 0,               %%题目数量
						 money             = 0,               %%奖励银元
						 exp               = 0,               %%奖励经验
						 goods             = []               %%物品 
						}).

%% 积分榜前十名奖励
-record(d_answer_rank,{
					   rank              = 1,               %%题目数量
					   money             = 0,               %%奖励银元
					   exp               = 0,               %%奖励经验
					   goods             = []               %%物品 
					  }).

%% 阎王殿
-record(d_yan_challeng,   {
						   yan_id         = [],               %%第一组阎王怪物组ID
						   last_id		  = 0,				  %%上一组阎王ID
						   next_yan	      = [],               %%第二组阎王怪物组ID
						   left_dharma    = 0,                %%所属文官ID
						   right_dharma   = 0,                %%所属武官ID
						   left_fight_id  = 0,                %%单挑文官ID
						   right_fight_id = 0,                %%单挑武官ID
						   yan_fight_id   = 0,                %%单挑阎王ID
						   bat_lv         = 0,                %%挑战等级
						   sp_up          = 0,                %%胜利提升士气
                           sp_down        = 0,                %%失败减少士气
					   	   reward         = [],               %%章节物品掉落
						   open           = 0                 %%打开阎王图的ID
						  }).

-record(d_yan_calm,       {
						   calm_times     = 0,                %%安抚次数
						   gold           = 0,                %%消费金元
						   get            = 0,                %%获得元神
						   crit           = 0,             	  %%暴击机率
						   crit_get       = 0                 %%暴击后获得
						  }).

-record(d_yan_attr,       {
						   yan_id		  = 0,                %% 阎王图ID
						   yan_lv         = 0,                %% 当前阎王图等级
						   god_must       = 0,                %% 元神消耗
						   yan_next       = 0,                %% 下一阎王图等级
						   skin           = 0,                %% 点完此点后主角皮肤
						   attr			  = ?null        	  %% #attr{}
						  }).

-record(d_wheel_goods,	  {
						   level        = 0,              %% 等级
						   type         = 0,               %% 货币类型
						   value        = 0,              %% 货币数量
						   times        = 0,              %% 次数
						   ratio        = 0,               %% 倍率
						   goods        = []			   %% 物品
						  }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 阵营战对战奖励
-record(d_camp_war_reward,{
						   lv				= 0,		%% 等级
						   win_rewards		= [],       %% 战胜奖励
						   fail_rewards		= [],		%% 战败奖励
						   bye_rewards		= []        %% 轮空奖励
						  }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 宝石合成数据
-record(d_pearl,		 {
						  goods_id			=0,         %% 合成物品ID
						  goods_make			=[]			%% 合成材料
						 }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 战斗AI
-record(d_battle_ai,	{
						  ai_id        		= 0,             %% AI_ID
						  reaction_time 		= 0,                 %% 反应时间（秒）
						  view        		= 0,             %% 视野范围半径（象素）
						  attack_interval 	= 0,             %% 攻击间隔时间（秒）
						  attack_skill 		= [],			 %% 攻击策略所用技能
						  get_up_skill 		= [],			 %% 起身策略所用技能
						  is_area      		= 1,             %% 是否产生特殊区域
						  special_area 		= ?null,  		 %% 特殊区域范围
						  rand_type    		= [1,2,3,4],       %% 随机类型
						  rand_x       		= 0,             %% 随机x
						  rand_y       		= 0,              %% 随机y
						  get_up_rand  		= 0               %% 起身策略随机
						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 装备附魔
-record(d_enchant,     {
						  type_sub     = 11,            %% 装备子类型
						  step         = 0,             %% 阶段
						  step_value   = 0,             %% 升阶值
						  goods        = [],			%% 材料升阶
						  money		   = 0,				%% 消耗银币
						  odds         = []				%% 升阶倍数
	                   }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 斗气
-record(d_fight_gas_total,	{
							 gas_id       = 0,            %% 斗气ID
							 type         = 0,               %% 斗气类型
							 lv           = 0,               %% 等级
							 color        = 0,               %% 颜色
							 self_exp     = 0,               %% 本身经验
							 next_lv_exp  = 0,            %% 下一级总经验
							 attr_type_one = 0,             %% 属性类型1
							 attr_one     = 0,             %% 属性值1
							 attr_type_two = 0,              %% 属性类型2
							 attr_two     = 0,               %% 属性值2
							 attr_type_three = 0,            %% 属性类型3
							 attr_three   = 0               %% 属性值3
							}).

-record(d_fight_gas_open,	{
							 seal_id      = 0,              %% 封印编号
							 open_lv      = 0,              %% 开通等级
							 set_type     = 0               %% 镶嵌类型
							}).

-record(d_fight_gas_grasp,  {
							 grasp_id     = 0,			%% 领悟ID
							 click_type   = 0,			%% 点击类型
							 price        = 0,			%% 点击费用
							 click_next_odds = 0,		%% 点亮下一个封印概率
							 appear_odds  = []			%% 出现权重
							}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 每日一箭
-record(d_arrow_daily_items,	{
							 items_id      = 0,              %% 物品ID
							 value         = 0               %% 物品值
							}).

-record(d_arrow_daily_odds,	{
							 num      = 0,                 %% 奖励类型
							 rewards         = 0           %% 奖励
							}).


%% 式神
-record(d_pet_skill,	{
							 unreal_skin    		= 0,                 %% 开通皮肤
							 lv      				= 0,                 %% 开通等级
							 skill      			= 0                 %% 学习技能
							}).

-record(d_pet,	{
				 pet_id       = 0,           	%% 魔宠ID
				 lv           = 0,               %% 魔宠等级
				 unreal_skin  = [],         	%% 开通皮肤
				 next_exp     = 0,              %% 下一级所需经验
				 gold_exp     = 0,               %% 钻石培养经验
				 gold_ten_opp = 0,            	%% 钻石培养突进概率
				 gold_time    = 0,               %% 钻石倍率
				 good_exp     = 0,              %% 道具培养经验
				 good_ten_opp = 0,               %% 道具培养突进概率
				 good_time    = 0,               %% 道具倍率
				 strong_att   = 0,              %% 物理攻击
				 strong_def   = 0,              %% 物理防御
				 skill_att    = 0,              %% 技能攻击
				 skill_def    = 0,              %% 技能防御
				 hp           = 0              %% 气血
				}).


% 活跃度奖励配置表;
-record(link_rewards,	{
						 id           = 0,               %% 活动进展
						 vitality     = 0,             	 %% 所需活跃度
						 rewards_id   = 0,          	 %% 活动奖励
						 rewards_count = 0             	 %% 活动奖励数量
						}).

