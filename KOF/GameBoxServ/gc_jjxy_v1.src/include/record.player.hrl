


%% 基本属性info----------------------------------------------------------------
%% 战斗属性battle---------------------------------------------------------------
%% 特殊属性---------------------------------------------------------------------
%% 装备equip-------------------------------------------------------------------
%% 背包bag---------------------------------------------------------------------
%% 仓库depot-------------------------------------------------------------------
%% 技能skill-------------------------------------------------------------------
%% 任务task--------------------------------------------------------------------
%% 声望renown -----------------------------------------------------------------
 
-record(player,{
				uid         = 0,             % 用户ID
				socket      = ?null,         % Socket
				mpid        = ?null,         % 进程ID
				spid		= ?null,		 % 场景进程

				uname 		= 0,			 % 玩家名字
				uname_color = 0,			 % 角色名颜色			
				sex			= 0,			 % 玩家性别
				pro 		= 0,			 % 玩家职业
				country 	= 0,			 % 玩家阵营
				lv			= 0,			 % 玩家等级
				lv_wea		= 0,			 % 玩家财神等级
				team_id     = 0,	 		 % 队伍ID
				team_leader	= 0,		 	 % 队伍队长Uid
				team_type	= 0,			 % 扩展1 (这个扩展 不能乱加 先申请 让一平来加)
				ext2		= 0,			 % 扩展2
				ext3		= 0,			 % 扩展3
				ext4		= 0,			 % 扩展4
				ext5		= 0,			 % 扩展5
				
				attr		= ?null,		 % 角色属性(最终的)
				info		= ?null,		 % 玩家基本信息
				money		= ?null,		 % 货币
				vip  		= ?null,		 % VIP
				is			= ?null,  		 % 状态flag
				io			= ?null			 % 网络I/O
			   }).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 状态flag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(is,   {
				is_db		= ?CONST_FALSE,  % 状态flag 退出是否保存(0:不保存|1：保存)
				is_war		= 0,		 	 % 状态flag 战斗
				is_train	= 0,		 	 % 状态flag 打坐
				is_collect	= 0,		 	 % 状态flag 采集
				is_mount	= 0,			 % 状态flag 骑乘状态(0:正常状态|1:骑乘中)
				is_red      = 0,             % 是否红名 (0:正常状态|1:红名)
				is_guide    = 0              % 新手指导员 (0:正常状态|1:指导员)
			  }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 网络I/O
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(io,   {
			     login_time	    = 0,			 % 登录时间
				 login_ip	    = 0,			 % 登录IP
				 db_save 		= 0, 	 		 % 数据库，下次存蓄时间
				 online			= 0,	 		 % 在线总时长(不记本次)
				 uuid			= 0,			 % 帐号UUID
				 sid            = 0,             % 服务器sid
				 cid            = 0,             % 平台cid
				 os			    = 0,			 % 系统类型
				 versions       = 0,			 % 游戏版本
				 source      	= 0,			 % 来源渠道
				 source_sub     = 0,			 % 子渠道
			     offline  		= 0,             % 断线时长
				 heart			= 0,			 % 上次心跳包时间（毫秒）
				 heart_errs		= 0,			 % 连续错误心跳次数
				 io_hex			= 0,			 % 校验
				 io_hex_errs 	= 0,			 % 校验连续
				 io_hex_last	= 0,			 % 最近触发时间
				 io_list		= [],			 % Socket缓冲区
				 io_logs		= []	 		 % 最近5次 协议 与 数据{协议,数据}
			  }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 防沉迷
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(fcm,		{
					 ip					= 0,	 %% 玩家IP
					 fcm				= 0,	 %% 防沉迷-是否加入防沉迷(?CONST_FALSE:不加入，?CONST_TRUE:加入防沉迷)
					 fcm_state			= 0,	 %% 防沉迷-状态
					 fcm_init			= 0,	 %% 防沉迷-初始时长
					 fcm_nt				= 0,	 %% 防沉迷-下次触发时间
					 tsp				= 0		 %% 时间同步协议(Time Synchronization Protocol)
					}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 玩家基本信息
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(info,   {
				 hp		 	 		= 0,			% 生命值（现有）
				 exp		 		    = 0,			% 经验值：玩家升级的一种方式
				 exp_total		 	= 0,			% 总共集了多少 经验
				 soul_blue   		= 0,        % 蓝色精魄
				 soul_violet 		= 0,        % 紫色精魄
				 soul_golden 		= 0,		    % 金色精魄
				 soul_orange 		= 0,		    % 橙色精魄
				 soul_red 	 		= 0,		    % 红色精魄
				 renown		 		= 0,			% 声望值
				 slaughter	 		= 0,			% 杀戮值
				 honor 		 		= 0,			% 荣誉值
				 integral	 		= 0,			% 积分
				 integral_time 		= 0,			% 积分获得时间戳
				 talent 	 		= 0,            % 天赋
				 position 			= 0,        % 阵位
				 skill_id			= 0,			% 初始技能ID
				 attack_type		= 0,				% 攻击类型
				 powerful			= 0,			% 角色战斗力
				 state				= 0,			% 状态  0:正常  1:新手指导员
				 power		        = 0,			% 战功
				 pebble		        = 0,			% 竞技水晶
				 ext3		        = 0,			% 
				 ext4		 = 0,			% 
				 ext5		 = 0,			% 
				 ext6		 = 0, 			%
				 ext7		 = 0,			%
				 ext8		 = 0,			%
				 
				 dir				= 5,			% 方向
				 speed				= 200,			% 移动速度
				 copy_id			= 0,			% 当前副本ID(城镇为0)
				 map_id				= 0,			% 当前地图（非地图）
				 map_type			= 0,			% 当前地图类型
				 map_last    		= 0,			% 上次所在地图（非地图）
				 pos_x				= 0,			% X坐标 
				 pos_y				= 0,			% Y坐标 
				 pos_x_last  		= 0,			% 上次所在X坐标
				 pos_y_last  		= 0,			% 上次所在Y坐标

				 sys_fri1			= 0,			% 玩家推荐好友次数(?CONST_FRIEND_RECOM_TIMES)
				 sys_fri2			= 0,			% 玩家达到30级推荐好友(0:没推荐过 | 1:推荐过)
				 sys_fri3			= 0,			% 玩家达到35级推荐好友(0:没推荐过 | 1:推荐过)
				 
				 skin_weapon		= 0,			% 装备武器皮肤ID
				 skin_armor			= 0,			% 装备衣服皮肤ID
				 skin_mount			= 0,			% 坐骑皮肤ID
				 skin_shape			= 0,			% 时装皮肤ID
				 skin_task_escort	= 0,			% 任务皮肤(护送)
				 skin_task_shape	= 0,			% 任务皮肤(变身)
				 skin_effect		= 0 			% 角色光效
% 下面属性转到相应系统 
%				 country     		= 0,            % 国家：显示玩家的国家
%				 country_post		= 0,            % 国家：职位
%				 clan        		= 0,            % 家族：显示玩家的家族
%				 clan_post			= 0,			% 家族：职位
%				 clan_name			= <<>>,			% 家族：名称
%				 teacher			= 0,			% 师徒状态
%				 mate				= 0,			% 配偶：ID  （非地图）
%				 mate_name			= <<>>,			% 配偶：姓名 （非地图）
%				 vip      			= 0,        	% VIP等级(0:0级 )
%				 titles				= []			% 称号,地图，名称后带的
				}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%初始化技能
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(skill_user,{
					 	study  = [],        % 学习的技能 [{SkillId,SkillLv}]
					 	equip  = []	        % 装备上的技能 [ #skill{} ]
				   }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 角色属性集合
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(attr_group,	{
					 lv		= ?null,		% #attr{}角色基础属性(等级)
					 matrix	= ?null,		% #attr{}星阵图
					 pet    = ?null,		% #attr{}宠物
					 mount	= ?null,		% #attr{}坐骑
					 renown	= ?null,		% #attr{}声望
					 honor  = ?null,		% #attr{}荣誉
					 society= ?null,		% #attr{}好友
					 equip	= ?null,		% #attr{}角色装备属性(装备)
					 clan	= ?null,		% #attr{}帮派技能属性加成
					 treasure = ?null,		% #attr{}珍宝阁属性加成
					 douqi	= ?null,		% #attr{}斗气属性加成
					 ext3	= ?null,		%
					 ext4	= ?null,		%
					 ext5	= ?null			%
					}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 角色/装备 基础属性
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(attr, 		{
					 sp				=0,             	% 怒气值
					 sp_up			=0,					% 怒气回复速度
					
					 anima			=0,					% 初始灵气值
					 hp				=0,		  			% 气血值
					 hp_gro			=0,					% 气血成长值
					 strong			=0,					% 力量值
					 strong_gro		=0,					% 力量成长值
					 magic			=0,					% 灵力值
					 magic_gro		=0,					% 灵力攻击成长值
					 strong_att		=0,					% 力量物理攻击
					 strong_def		=0,					% 力量物理防御值
					 skill_att		=0,					% 技能攻击
					 skill_def		=0,					% 技能防御
                     
					 crit			=0,					% 暴击值(万分比)
					 crit_res		=0,					% 抗暴值(万分比)
					 crit_harm		=0,                 % 暴击伤害值(万分比)
					 defend_down    =0,					% 破甲值(万分比)
					 light			=0,					% 光属性(万分比)
					 light_def		=0,					% 光抗性(万分比)
					 dark			=0,					% 暗属性(万分比)
					 dark_def		=0,					% 暗抗性(万分比)
					 god			=0,					% 灵属性(万分比)
					 god_def		=0,					% 灵抗性(万分比)
					 bonus			=0,					% 伤害系数(万分比)
					 reduction		=0,					% 免伤系数(万分比)
					 imm_dizz		=0					% 抗晕值(万分比)
					}).

-record(array_attr, {
					 bonus=0,				% 阵位伤害加成
					 hp_max=0,				% 阵位气血加成
					 speed=0,				% 阵位速度加成
					 resumehp=0,			% 阵位恢复气血加成
					 reduction=0			% 阵位免伤率加成
					}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 客栈
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(inn,		{
					 partnering	= [], 		% 正在招募中的伙伴
					 partners   = []		% 已经招募的伙伴#partner{}
					}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 玩家货币
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(money,		{
					 gold 		= 0,		% 铜钱
					 rmb		= 0,		% 元宝
					 rmb_bind	= 0,		% 绑定元宝
					 rmb_total  = 0,		% 充值总额
					 rmb_consume= 0 		% 已消耗元宝
					}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 玩家VIP功能
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-record(vip, {
			  lv           = 0,               %% VIP等级
			  lv_real      = 0,               %% VIP等级(真实)
			  indate 	   = 0,				  %% Vip特权功能到期时间(秒)，到期后变成(真实)	VIP等级	
			  sum_rmb	   = 0				  %% 已冲值元宝总额  
			 }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 玩家一次性购买物品列表
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(store,{
              once_goods = []                 %% 只能购买一次的物品
               }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 玩家背包数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 背包record
-record(bag, {
			  max  = 0,			%% 当前背包最大容量
			  count= 0,		%% 背包已扩容次数 
			  list = [],		%% 背包列表 
			  temp = [],		%% 临时背包列表
			  time = 0,			%% 刷新时间
			  shop_goods = 0 	%% 随机商店列表
			  }). 

%% 玩家物品数据外存记录(装备类)
-record(goods_equip, {
					  id=0,			%% 唯一ID
					  idx=0,			%% 索引
					  gid=0,			%% 物品ID
					  count=0,		%% 现有数量
					  expiry = 0,	%% 有效期
					  time = 0,		%% 物品获得时间戳
					  powerful = 0,	%% 物品战斗力
					  streng = 0,	%% 强化等级，现有
					  streng_v = 0,	%% 强化属性
					  plus = [],		%% 附加属性
					  slots = [],	%% 插槽
					  ext1 = 0,
					  ext2 = 0
					 }).

-record(goods_equip2, {
					   id=0,			%% 唯一ID
					   idx=0,			%% 索引
					   gid=0,			%% 物品ID
					   count=0,			%% 现有数量
					   expiry = 0,		%% 有效期
					   time = 0,		%% 物品获得时间戳
					   
					   powerful		 = 0,		% [NB]装备评分
					   pearl_score	 = 0,		% [NB]灵珠评分
					   wskill_id	 = 0,		% [NB]武器技能
					   streng 		 = 0,		% [NB]强化等级，现有
					   streng_v		 = 0,		% [DNB]强化属性
					   baptize		 = 0,		% [NB]洗炼次数
					   plus 		 = [],		% [NB]附加属性[{Type,Color,Value,MaxValue},...]
					   slots		 = [],	
					   
					   ext1 = 0,
					   ext2 = 0,
					   ext3 = 0,
					   ext4 = 0,
					   ext5 = 0
					  }).

 
%% 玩家物品数据外存记录(普通类)
-record(goods_com, {
					id=0,			%% 唯一ID
					idx=0,			%% 索引
					gid=0,			%% 物品ID
					count=0,		%% 现有数量
					expiry = 0,	%% 有效期
					time = 0,		%% 物品获得时间戳
					ad1 = 0,		%% 动态属性1
					ad2 = 0,		%% 动态属性2
					ad3 = 0,		%% 动态属性3
					ad4 = 0,		%% 动态属性4
					ext1 = 0,
					ext2 = 0
				   }).


%D -> data (服务器端) 
%X -> xml  (客户客端)
%N -> net  (网络发送)
%B -> bag  (背包)
%T -> temp (临时)
-record(goods,		{
					 id			= 0,		% [NB]物品唯一ID
					 idx		= 1,		% [NB]所在容器位置索引
					 goods_id	= 0,    	% [DXNB]物品的ID，ID数字中间不能够有间隔，比如1,3
					 name_color	= 0,		% [DX]物品名称的颜色
					 type		= 0,		% [DX]物品的类型，每种类型一个编号  1//装备 2//武器3//功能物品 4//普通物品 5//任务物品
					 type_sub	= 0,		% [DX]物品的子类型，每种类型一个编号
					 class		= 0,		% [DX]法宝等阶,无则为0
					 
					 count		= 1,		% [NB]物品数量   
					 stack		= 1,		% [DX]堆叠数量
					 lv			= 0,		% [DX]等级(等级要求) 为0时没有要求
					 pro		= 0,		% [DX]职业要求    为0时没有要求
					 sex		= 0,		% [DX]性别要求    为0时没有要求
					 price_type	= 0,	    % [DX]价格的类型，1：金币，2：绑定金币，请多预留几个以后会增加
					 price		= 0,		% [DX]上面选择类型后，这里输入的价格单位为选择类型的（指的是跟npc出售）
					 expiry_type= 0,		% [DX]有效期类型，0:不失效，1：秒，  2：天，请多预留几个以后会增加
					 expiry		= 0,		% [NB]有效期，到期后自动消失，并发系统邮件通知
					 time		= 0,		% [DX]获得时间
					 flag		= ?null,	% [XY]在内存中是#goods_flag{}
					 exts		= ?null     % 扩展数据 #g_eq{}  #g_none{}
								  
								  % bind		= 0,		% 是否绑定(0:不绑定 1:绑定)
								  % icon		= 0,		% 所有物品图标大小都一样，装备除了武器和衣服，其他部位都只有图标
								  % name		= <<>>,		% 物品的名称，最多8个字，可以改变颜色
								  % remark	= <<>>		% 物品的说明，可以加颜色代码
					}).
%% 装备
-record(g_eq,		{
					 powerful		 = 0,		% [NB]装备评分
					 pearl_score	 = 0,		% [NB]灵珠评分
					 suit_id 		 = 0,		% [NB]所属的套装ID
					 wskill_id		 = 0,		% [NB]武器技能
					 %upgrade_id  	 = 0,		% [DX]升级ID
					 speed_move		 = 0,		% [DX]移动速度
					 attr_base_type  = 0,		% [DX]基础属性类型
%% 					 attr_base_value = 0,		% [DX]基础属性数值
					 %skin			 = 0,		% [DX]皮肤（时装、衣服、武器）
					 streng 		 = 0,		% [NB]强化等级，现有
				     streng_v		 = 0,		% [DNB]强化属性
					 baptize		 = 0,		% [NB]洗炼次数
					 plus 			 = [],		% [NB]附加属性[{Type,Color,Value,MaxValue},...]
					 slots	      	 = ?null, 	% [NB]插槽[{AttrType,PearlId, AttrValue},{AttrType, PearlId, AttrValue}]
					 enchant		 = 0,		% [NB]附魔阶段	
					 enchant_value	 = 0		% [NB]附魔阶段值
					}).
%% 普通物品
-record(g_none,	   {
					as1 = 0,  % [DX]静态属性
					as2 = 0,  % [DX]静态属性
					as3 = 0,  % [DX]静态属性
					as4 = 0,  % [DX]静态属性
					as5 = 0,  % [DX]静态属性
					
					ad1 = 0,  % [NB]动态属性
					ad2 = 0,  % [NB]动态属性
					ad3 = 0,  % [NB]动态属性
					ad4 = 0   % [NB]动态属性
				   }).
%% 物品标识
-record(g_flag,	 {
				  logs		= ?CONST_FALSE, % 记录日志		?CONST_TRUE 记录日志           | ?CONST_FALSE 不记录日志
				  sell    	= ?CONST_FALSE, % 出售			?CONST_TRUE 可出售给NPC | ?CONST_FALSE 不可出售给NPC
				  %depot    	= ?CONST_FALSE, % 存仓库			?CONST_TRUE 可存仓库          | ?CONST_FALSE 不可存仓库	
				  %biz     	= ?CONST_FALSE, % 交易			?CONST_TRUE 可交易               | ?CONST_FALSE 不可交易
				  destroy 	= ?CONST_FALSE, % 可销毁			?CONST_TRUE 可销毁	   | ?CONST_FALSE  不可以销毁
				  %die_flop 	= ?CONST_FALSE, % 死亡掉落		?CONST_TRUE 死亡正常掉落        |  ?CONST_FALSE 不会掉落
				  die_vanish 	= ?CONST_FALSE, % 死亡后消失		?CONST_TRUE 死亡后消失             | ?CONST_FALSE  死亡后走正常
				  %repair 	= ?CONST_FALSE, % 修理			?CONST_TRUE 可修理         | ?CONST_FALSE       不可修理
				  %abrade 	= ?CONST_FALSE, % 永不磨损		?CONST_TRUE 永不磨损  | ?CONST_FALSE      正常磨损规则
				  make 		= ?CONST_FALSE, % 打造			?CONST_TRUE 可打造 | ?CONST_FALSE      不可打造，升级拆分
				  %show_durable= ?CONST_FALSE,% 显示耐久		?CONST_TRUE 显示耐久 | ?CONST_FALSE 不显示耐久
				  %bind 		= ?CONST_FALSE, % 自动绑定		?CONST_TRUE 自动绑定  | ?CONST_FALSE 自动不绑定
				  equip 		= ?CONST_FALSE, % 装备			?CONST_TRUE 可装备 | ?CONST_FALSE 不是装备物品，都不能够装备
				  split 		= ?CONST_FALSE  % 拆分			?CONST_TRUE 可拆分 | ?CONST_FALSE 物品不可以拆分
				 }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 通用 给物品 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(give,			{
						 goods_id 		= 0,		% 物品ID
						 count			= 1,		% 数量
						 streng 		= 0,		% [BN]强化等级
						 name_color		= 1,		% 物品名称的颜色
						 bind	  		= 1,		% 是否绑定(0:不绑定 1:绑定)
						 expiry_type	= 0,		% 有效期类型，0:不失效，1：秒，  2：天，请多预留几个以后会增加
						 expiry			= 0			%   有效期，到期后自动消失，并发系统邮件通知
						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 装备打造数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 装备强化
-record(strengthen,		{
						 lv					= 0,			% 强化等级
						 lower				= 0,			% 成功下限
						 upper				= 0,			% 成功上限
						 odds				= 0,			% 成功几率
						 odds_max			= 0,			% 最大几率
						 currency_type		= 0,			% 货币类型
						 currency_value		= 0,			% 货币值
						 strengthen_id		= 0,			% 强化卷轴
						 strengthen_count	= 0,			% 强化卷轴数量
						 luck_id				= 0,			% 几率道具ID
						 luck_max			= 0,			% 几率道具使用最大数量
						 attr				= ?null			% 强化增加基础属性
						}).
%% 强化重置
-record(reset,			{
						 id					= 0,			% ID
						 lower				= 0,			% 成功下限
						 upper				= 0,			% 成功上限
						 odds				= 0,			% 成功几率
						 odds_max			= 0,			% 最大几率
						 currency_type		= 0,			% 货币类型
						 currency_value		= 0,			% 货币值
						 reset_id			= 0,			% 重置卷轴
						 reset_count			= 0,			% 重置卷轴数量
						 luck_id				= 0,			% 几率道具ID
						 luck_max			= 0				%   几率道具使用最大数量
						}).
%% 血祭重置
-record(reset_fete,		{
						 star				= 0,			% 实体星星
						 odds				= 0,			% 成功几率
						 odds_max			= 0,			% 最大几率
						 currency_type		= 0,			% 货币类型
						 currency_value		= 0,			% 货币值 	
						 reset_id			= 0,			% 重置卷轴
						 reset_count			= 0,			% 重置卷轴数量
						 luck_id				= 0,			% 几率道具ID
						 luck_max			= 0,			% 几率道具使用最大数量
						 lower_percent		= 0,			% 最低百分比
						 upper_percent		= 0				%  最高百分比
						}).
%% 紫装洗练
-record(baptize,		{
						 key		 			= {},			% 区间
						 percent				= 0,			% 属性比例
						 odds				= 0,			% 成功几率
						 odds_max			= 0,			% 最大几率
						 currency_type		= 0,			% 货币类型
						 currency_value		= 0,			% 货币值
						 baptize_id			= 0,			% 洗练石
						 baptize_count		= 0,			% 洗练石数量
						 luck_id				= 0,			% 几率道具ID
						 luck_max			= 0,			% 几率道具使用最大数量
						 attr_num			= [],			% 属性条目
						 lock_num			= [],			% 锁定条目
						 attr_list			= []			% 属性类型
						}).
%% 装备升阶
-record(upsteps,		{
						 odds				= 0,			% 成功几率
						 odds_max			= 0,			% 最大几率
						 currency_type		= 0,			% 货币类型
						 currency_value		= 0,			% 货币值
						 upsteps_id			= 0,			% 升阶石
						 upsteps_count		= 0,			% 升阶石数量
						 luck_id				= 0,			% 几率道具ID
						 luck_max			= 0,			% 几率道具使用最大数量	
						 star_id				= 0,			% 镇星石ID
						 star_count			= 0,			% 镇星石数量
						 spirit_id			= 0,			% 镇灵石ID
						 spirit_count		= 0				%   镇灵石数量
						}).
%% 装备精炼
-record(refine,			{
						 odds				= 0,			% 成功几率
						 odds_max			= 0,			% 最大几率
						 currency_type		= 0,			% 货币类型
						 currency_value		= 0,			% 货币值
						 refine_id			= 0,			% 精炼石
						 refine_count		= 0,			% 精炼石数量
						 luck_id				= 0,			% 几率道具ID
						 luck_max			= 0				%   几率道具使用最大数量	
						}).
%% 龙珠合成
-record(pearl_upgrade,	 {
						  lv					= 0,			% 合成龙珠等级
						  request_lv			= 0,			% 需要的角色等级
						  request_num			= 0,			% 需要龙珠数量
						  odds				= 0,			% 成功几率
						  odds_max			= 0,			% 最大几率
						  currency_type		= 0,			% 货币类型
						  currency_value		= 0,			% 货币值
						  request_id			= 0,			% 龙珠卷轴
						  request_count		= 0,			% 龙珠卷轴数量
						  luck_id				= 0,			% 几率道具ID
						  luck_max			= 0				%   几率道具使用最大数量
						 }).
%% 物品合成
-record(compose,		{
						 type_sub			= 0,			% 物品子类型
						 currency_type		= 0,			% 货币类型
						 currency_value		= 0 			% 货币值
						}).
%% 物品分解
-record(part,			{
						 key					= 0,			% 类型
						 goods				= 0 			% 获得物品
						}).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 日志
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(logs,			{
						 uid			= 0,		% 玩家Uid
						 bin			= <<>>		% 日志信息
						}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 伙伴
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(partner,		{
						 partner_id		=	0,			%% 伙伴ID
						 hp				=   0,          %% 现有血量
						 % partner_name	=	<<>>,		%% 伙伴名称
						 %% 						 	name_colour	=	0,			%% 名称颜色
						 idx			=	0,			%% 位置	
						 state		    =   0,			%% 状态 0:为在队，1:出站，2：为休息	
						 shinwakan		=   0,			%% 友好度
						 lv				=	0,			%% 等级
						 pro			=	0,			%% 职业
						 sex			=	0,			%% 性别
						 country		=	0,			%% 阵营
						 talent			=	0,			%% 天赋
						 position		=	0,			%% 阵位
						 skill 			=	0,			%% 技能#skill{}
						 attack_type	=	0,			%% 攻击类型
						 attr_group		=	0,			%% 附和属性
						 attr			=	?null,		%% #attr{}基本属性
						 equip			=	[],			%% 装备信息
						 powerful		=	0,			%%   战斗力
						 exp			=   0			%% 经验值
						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 玩家邮件数据 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(mail,		{
					 mail_id	= 0,			% 邮件ID
					 mtype		= 0,			% 邮件类型(系统:0|私人:1)
					 send_sid	= 0,			% 发件人Sid
					 send_uid	= 0,			% 发件人Uid
					 send_name	= <<>>,			% 发件人名字
					 recv_uid	= 0,			% 收件人Uid
					 recv_name	= <<>>,			% 收件人名字
					 boxtype		= 0,		% 邮箱类型(收件箱：0|发件箱：1|保存箱：2)				

					 title		= <<>>,			% 标题
					 date		= 0,			% 日期
					 content	= <<>>,			% 内容
					 vgoods		= [],			% 虚拟类物品(货币、经验、星魂、精魄、声望等，不占包裹空间)
					 goods		= [],			% 实物类物品 (道具，装备，材料，宝箱等..)
					 state		= 0,			% 邮件状态(未读:0|已读:1)
					 pick		= 0				%  附件是否提取(无附件:0|未提取:1|已提取:2)
					}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 任务
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(tasks,{
               tlist =  [],             %% 正在做的任务
               taskclist = []           %% 已经完成列表
			  }).

-record(user_task, {
					id = 0,				%% 玩家任务ID
					state = 0, 			%% 任务状态 0、未激活  1、已经激活 2:可接受 3、接受未完成 4:完成未提交 5:已提交
					seconds = 0,		%% 接受任务时间戳
					value = {}			%% {Type,Value}
				   }).

%% -record(taskc,     {
%%                    taskc_list = []}).    %% 已经完成的任务列表

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 日常任务数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(task_daily, {
					dTaskId = 0,		%% 任务节点
					left = 0,			%% 次数 
                    value = 0,			%% 事件当前值 
					state = 0,			%% 当前任务是否完成(0:未完成 | 1 : 已完成 |2: 这一轮任务已经完成)
                    refresh = 0,        %% 当前vip刷新剩余次数
                    refreshc = 0,       %% 当前已经刷新次数
                    timec  = {}          %% 完成时间 {Ymd} 
					}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 藏宝阁
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(treasure, {
%% 					goods_id = 0,		    %% 打造物品ID
					level_id = 0, 			%% 层次ID
					complete_list = [],		%% 已经完成的列表
                    shop_time = 0,          %% 请求商店的时间
                    is_refresh = 0,         %% 是否已经刷新过
                    activated = [],         %% 已经激活的列表
                    shoplist = []           %% 商店列表
				   }).

-record(tr_shop, {
                 uid = 0,                   %% 玩家uid
                 shoplistc = []             %% 已经买过的商品列表
				 }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 阵营战
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(camp_war,		{
						 is_war					= 0,	% 是否可战
						 check_time				= 0,	% 活动时间核查
						 buy_count				= 0,	% 激励次数
						 msg					= <<>>	% 个人广播
						}).

%% ets表专用记录
-record(camp_rank,		{
						 uid        			= 0,     %  玩家UID
						 integral  				= 0,     %  阵营积分
						 lv        				= 0,     %  等级
                         sex					= 0,	 %	性别
						 pro					= 0,	 %	职业
						 name      				= <<>>,  %  玩家名字
						 name_color 			= 0,	 %  角色名颜色
						 camp	    			= 0,	 %  战队阵营
                         match					= 0,	 %  匹配状态：1可匹配
						 mach_time				= 0,	 %	开始匹配战斗时间
						 wardata				= 0,	 %	玩家参战时数据
						 wins_now				= 0,	 %	当前连胜次数
						 wins_max				= 0, 	 %	最大连胜次数
						 get_buff				= 0,	 %	获得Buff次数
						 wins					= 0,	 %	战胜总次数
						 fails					= 0,	 %	战败总次数
						 mymsg					= []	 %	个人战报IdList：[{Id,Bin},{...}]
						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 玩家鲜花数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(flower, 	{
					 sum			= 0,			% 使用鲜花数量
					 count			= 0,			% 赠送次数
					 charm			= 0				%  玩家魅力值
					}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 阵营
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(country,	{
					 key				= 0,	 %% 阵营KEY
					 num				= 0,	 %% 阵营人数
					 powerful			= 0,	 %% 阵营综合实力
					 resource			= 0,	 %% 阵营资源
					 post				= [],	 %% 阵营职位
					 notice				= 0		 %% 公告
					}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 帮派
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 帮派公共数据-ets-sql
-record(clan_public,		{
							 clan_id 		= 0,				%% 帮派唯一id
							 clan_rank		= 0,				%% 帮派排名
							 clan_name 		= <<>>,				%% 帮派名称
							 clan_lv 		= 0,				%% 帮派等级
							 devote 		= 0,				%% 帮派贡献
							 up_devote 		= 0,				%% 帮派升级所需贡献
							 master_id 		= 0,				%% 帮主uid
							 master_name 	= <<>>,				%% 帮主名字
							 master_name_color = 0,				%% 帮主名字颜色
							 master_lv 		= 0,				%% 帮主等级
							 notice 		= <<>>,				%% 帮派公告
							 max_member		= 0,				%% 帮派成员上限	
							 logs			= [],				%%　帮派日志
							 master_list	= [],				%% 帮派管理员uid列表		 
							 member 		= [],				%% 帮派成员uid列表
							 apply_list		= [],				%% 申请入帮玩家列表[{uid,name,namecolor,lv,pro,util:seconds()}]
							 seconds 		= 0					%% 创建时间
							}).

%% 帮派成员数据-ets-sql
-record(clan_mem,			{
							 uid 				= 0,			%% 玩家uid
							 clan_id 			= 0,			%% 帮派id
							 name 				= <<>>,			%% 玩家名字
							 name_color 		= 1,			%% 玩家名字颜色
							 lv					= 0,			%% 玩家等级
							 por				= 0,			%% 玩家职业
							 post 				= 0,			%% 玩家职位
							 devote_day 		= 0,			%% 日贡献
							 devote_sum 		= 0,			%% 总贡献
							 time				= 0,			%%　日期
							 logout_time		= 0,			%% 离线时间戳
							 join_time			= 0 			%% 入帮时间戳
							}).	

%% 个人帮派数据
-record(clan,				{
							 clan_id 			= 0,			%% 帮派唯一id
							 clan_name 			= <<>>,			%% 帮派名称
							 ask_clanlist		= [],			%% 已申请帮派列表 	:: [{util:seconds(),ClanId}|_]
							 stamina			= 0,			%% 已消耗帮派贡献值
							 clan_skill			= [],			%% 帮派技能数据 	:: [{Type,TypeLv,Value,addValue,cast}|_]
							 clan_copy			= 0,			%% 帮派副本		:: [times,date]  次数，日期
							 outtime			= 0 			%% 退帮时间
							}).

% 帮派活动公共数据---------------------------------------------------------------------------------------------------------
%% 招财猫活动
-record(clan_cat_data, 		{
							 clan_id 			= 0,			%% 帮派id
							 cat_lv				= 1,			%% 摇钱树等级
							 cat_exp			= 0,			%% 摇钱树经验
							 cat_upexp			= 0,			%% 摇钱树升级经验
							 cat_logs			= [] 			%% 摇钱树日志
							}).	

%% 招财猫活动
-record(clan_cat, 			{
							 gold_times			= 0, 			%% 普通喂养次数
							 rmb_times			= 0,			%%　RMB喂养次数
							 get_lv				= 0,			%%　已招财的招财猫等级
							 get_day			= 1,			%% 每日免费招财次数
							 date				= 0				%% 喂养日期
							}).	


%%　帮派BOSS
-record(clan_boss_pub,		{
							 clan_id				= 0,				%% 帮派ID
							 start_time			= 0,				%% 开始时间
							 end_time			= 0,				%% 结束时间
							 open_data			= [],			%% 开启活动的玩家数据		[Uid,Name,NameColor,Pos]
							 boss_data			= [],			%% Boss数据			[BossId,BossLv,BossHp]
							 clan_player			= [], 			%% 参加人员数据 #boss_dps{}
							 clan_all_hp			= [],				%% 参加人物剩余血量
							 open_times			= 0,				%% 帮派BOSS开启次数
							 date				= 0				%% 日期	util:date()
							}).	

-record(clan_boss_rank,		{
							 uid 				= 0,			%% 玩家Uid
							 clan_id			= 0,			%% 帮派ID
							 integer			= 0,			%% 活动积分
							 name				= 0,			%% 玩家名字
							 name_color			= 0,			%% 玩家名字颜色
							 lv					= 0,			%% 玩家等级
							 relive_tims		= 0,			%% 已复活次数
							 buff_times			= 0,			%% 已豉舞次数
							 buff				= []			%% 属性加成
							}).	
%----------------------------------------------------------------------------------------------------------------------


%% %% 帮派战玩家数据
%% -record(clan_war_role, {
%% 						sid = 0,				%% 玩家sid
%% 						uid = 0 :: integer(),	%% 玩家uid
%% 						clan_id = 0,			%% 玩家所在帮派
%% 						clan_name = <<>>,		%% 帮派名字
%% 						is_online = 0,			%% 当前战场分组(0:离线组|1:在线组)
%% 						name = <<>>,			%% 玩家名字
%% 						lv = 1,					%% 玩家等级
%% 						hp = [],				%% 玩家当前剩余血量(离线玩家才有)
%% 						kill = 0,				%% 击杀数	
%% 						die = 0,				%% 被击败时间戳
%% 						rank = 0,				%% 玩家帮派战排名(击杀人数排序)
%% 						player = null,			%% 角色数据record
%% 						state = 0				%% 玩家帮派战状态 :: 0(死亡被淘汰) | 1(未被淘汰)
%% 						}).
%% 
%% %% 帮派战帮派数据
%% -record(clan_war_com, {
%% 						clan_id = 0,			%% 帮派id
%% 						clan_name = 0,			%% 帮派名字	
%% 						seconds = 0,			%% 帮派最后成员被淘汰时间戳
%% 						kill = 0,				%% 击杀数
%% 						rank = 0				%% 排名	
%% 						}).
%% 
%% %% 帮派战战报记录
%% -record(clan_war_recs,	{
%% 						 id = 0,				%% 战报id
%% 						 sidw = 0,				%% 胜利方服务器id
%% 						 uidw = 0,				%% 胜利方uid
%% 						 namew = <<>>,			%% 胜利方名字
%% 						 clan_idw = 0,			%% 胜利方帮派ID
%% 						 clan_namew = <<>>,		%% 胜利方帮派名字
%% 						 sidl = 0,				%% 失败方服务器id
%% 						 uidl = 0,				%% 失败方uid
%% 						 namel = <<>>,			%% 失败方名字
%% 						 clan_idl = 0,			%% 失败方帮派ID
%% 						 clan_namel = <<>>,		%% 失败方帮派名字
%% 						 seconds = 0			%% 时间戳 
%% 						}).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 荣誉
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(honor_pandect, {
						key					= 0,	% KEY{Sid,Uid}
						honor_dot			= 0,	% 荣誉点
						honor_all			= 0,	% 已获得总荣誉
						honor_rank			= 0,	% 荣誉排名
						title				= 0,	% 已获得称号
						target				= 0,	% 火影目标
						grow				= 0,	% 角色成长
						stronger			= 0,	% 强者之路
						practice			= 0,	% 角色历练
						pet					= 0,	% 神骑神宠
						war					= 0,	% 欲血沙场
						gold				= 0,	% 金币
						rmb					= 0,	% 克拉
						rmb_bind			= 0, 	% 工资
						exploit				= 0,	% 功勋
						renown				= 0,	% 声望
						exp					= 0	 	% 经验
					   }).
%%
-record(honor_data,	{
					 type				= 0,	% 荣誉类型
					 type_sub			= 0,	% 荣誉子类型
					 honor_id			= 0,	% 荣誉Id
					 value				= 0,	% 荣誉值
					 honor_dot			= 0,	% 荣誉点
					 gold				= 0,	% 金币
					 rmb					= 0,	% 克拉
					 rmb_bind			= 0,	% 工资
					 exploit				= 0,	% 功勋
					 renown				= 0,	% 声望
					 exp					= 0,	% 经验
					 gift				= 0,	% 礼包
					 attr				= ?null,% 
					 titles				= 0 	% 称号
					}). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 福利
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(welfare,		{
						 login_time			= 0,	% 最后登陆时间
						 login_date			= 0,	% 最后登陆日期
						 continue_day		= 0,	% 连续登陆天数
						 continue_day_get	= [],	% 已领取的登陆奖励
						 cumul_day			= 0,	% 日累计在线时间
						 cumul_day_get		= [],	% 已领取的日累计奖励
						 cumul_last_week		= 0,	% 上周累计在线时间
						 cumul_week			= 0,	% 周累计在线时间
						 cumul_week_get		= ?true,% 是否领取了周累计奖励
						 cumul_create		= ?true,% 创建人物初次登陆奖励 
						 cumul_online		= 0,	% 当前登陆在线时间
						 cumul_online_get	= [],	% 当前登陆在线奖励领取
						 cumul_rmb			= 0,	% 活动期累计充值克拉
						 cumul_limit_rmb		= [],	% 充值条件额度剩余值
						 cumul_rmb_get		= [],	% 已领取的累计充值奖励
						 recover_exp			= [],	% 找回经验活动列表
						 recover_exp_get		= []	% 找回经验奖励领取状态
						}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 副本
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% {副本Id,类型,子类型,等级,等级下限,等级上限,时间(秒),人数上限,次数上限每天,VIP每天上限次数,总次数上限,奖励,场景列表}
%% {CopyId,Type,TypeSub,Lv,LvMin,LvMax,Time,CountMax,TimesMaxDay,TimesMaxVip,TimesMaxTotal,Reward,DetailsDatas}
-record(copy,			{
						 pid				= ?null, % 副本进程
						 id					= 0,	 % 副本Id
						 type				= 0,	 % 副本类型
						 details			= [],	 % 副本细节[Scene1010 | ...]

						 is_team			= 0,	 % 当前是否在组队
						 relive_lim			= 0,	 % 可以复活次数
						 die_state			= [], 	 % 玩家状态[{Uid,State,Times}|...]  现在的状态(?true:活着|?false:死亡)死亡次数)
						 
						 use_energy			= 0,	 % 通关消耗体力
						 state				= ?false,% 副本状态
						 gate				= 0,	 % 场景数量
						 gate_now			= 0,	 % 当前第几个场景
						 gate_over			= 0,	 % 当前完成的场景
						 score_id			= 0,	 % 评分Id
						 
						 ctime				= 0,	 % 副本创建时间(util:seconds)
						 time_copy			= 0,	 % 副本规定时间(单机时,如果副本生存时间小于这个值,则有作弊)
						 time_life			= 0,	 % 时间(副本生存时间)
						 timer_switch		= 0		 % 计时(在一定时间检查副本没人,关闭进程)
						}).

%% 副本战斗结果
-record(war_s,			{
						 uid 			= 0,			% 玩家Uid
				 		 carom_times	= 0,			% 最高连击次数
				 		 kill_times 	= 0,			% 击杀个数
				 		 hit_times		= 0,			% 被击次数
						 monster_hp		= 0				% 怪物伤害(血量)
			    		}).

-record(copysave,		{
						 id					= 0,	% 副本ID
						 belongid			= 0,	% 上级ID
						 keyid				= 0,	% 普通副本为自己，精英副本共用一个
						 is_comein			= 0,	% 是否第一次
						 is_pass			= 0,	% 是否通关过
						 times				= 0,	% 进入次数
						 sumtimes			= 0,	% 每天可进入次数
						 evaluation			= 0		% 评价
						 }).
-record(copyreward,		 {
						  uid				= 0,	% 玩家Uid
						  uname				= <<>>,	% 玩家名字
						  name_color		= 0,	% 名字颜色
						  goods_id			= 0,	% 物品Id
						  goods_num			= 0,	% 物品数量
						  time				= 0		% 领取时间
						  }).
-record(upcopy,			  {id				= 0,	% 副本ID
						   type				= 0,	% 副本类型
						   btime			= ?null,% 开始挂机时间
						   etime			= ?null,% 结束挂机时间
						   use_all			= 0,	% 是否使用所有体力
						   nowtimes			= 0,	% 已挂机次数
						   cdtime			= 0,	% CD时间(一次挂机时间)
						   sumtimes			= 0,	% 总挂机次数
						   gold				= 0,	% 挂机一轮铜钱
						   exp				= 0,	% 挂机一轮经验
						   power			= 0,	% 挂机一轮战功
						   energy			= 0,	% 挂机一轮消耗体力
						   fast_vip			= 0,	% 挂机免时间vip等级
						   stop				= ?true,% 是否已停止

						   tref				= ?null,%挂机定时器
						   up_over_type		= 0,	% 挂机完成类型
						   up_speed			= ?false,%是否快速挂机或加速挂机
						   uphistory		= [],	% 挂机历史记录[{Now,Sum,Exp,Gold,Power,Goods}|_]
						   reward			= []	% 通关奖励
						  }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 英雄副本
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(herosave,		{							% 副本记录
						 id					= 0,	% 副本ID
						 type				= 0,	% 副本类型

						 keyid				= 0,	% Key(次数，重置次数各种在这里)
						 is_pass			= 0,	% 是否通关过
						 is_comein			= 0,	% 是否来过这个副本
						 belongid			= 0,	% 副本上级地图ID

						 evaluation			= 0		% 评价
						 }).
-record(herobest,		{
						 first				= ?null, % {Sid,Uid,Name}
						 best				= ?null	 % {Sid,Uid,Name,Hp}
						}).
-record(black_shop,		{
						 re_time			= ?null, % 刷新黑店的时间戳
						 re_goods			= [],	 % 刷新黑店给玩家显示的物品(六种)[{Give,RmbType,Price,IsBuy} | ...]
						 re_count			= 0	 	 % 刷新黑店的总次数
						 }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 魔王副本
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(fiendsave,		{							% 副本记录
						 id					= 0,	% 副本ID
						 type				= 0,	% 副本类型

						 keyid				= 0,	% Key(次数，重置次数各种在这里)
						 is_pass			= 0,	% 是否通关过
						 is_comein			= 0,	% 是否来过这个副本
						 belongid			= 0,	% 副本上级地图ID
						 times				= 0,	% 已进入次数
						 times_day			= 0,	% 每天可进入次数

						 evaluation			= 0		% 评价
						 }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 拳皇生涯副本
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(figsave,		{
						 id					= 0,	% 副本ID
						 keyid				= 0,	% Key(次数，重置次数各种在这里)
						 is_pass			= 0,	% 是否通关过
						 is_comein			= 0,	% 是否来过这个副本
						 belongid			= 0,	% 副本上级地图ID
						 evaluation			= 0		% 评价
						 }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 普通副本章节
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(chapcopy,{
				 date		= ?null,	% 日期
				 chap_id	= 1,		% 当前正在进行的章节
				 use_id		= [],		% 可以进入的章节
				 copys		= [],		% 保存的副本信息
				 chap_reward= []		% 领取过章节评价奖励的章节ID
				}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 英雄副本章节
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(hero,	{
				 date		= ?null,	% 日期
				 times		= 1,		% 当天可打次数
				 buy_times	= 0,		% 当天已购买次数
				 default	= ?true,	% 是否还是默认(通关第一次英雄副本就把它设为0)
				 chap_id	= 1,		% 当前正在进行的章节
				 use_id		= [],		% 可以进入的章节
				 copys		= [],		% 保存的副本信息
				 chap_reward= []		% 领取过章节评价奖励的章节ID
				}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 魔王副本章节
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(fiend,	{
				 date		= ?null,	% 日期
				 buy_times	= 0,		% 当天已购买次数
				 chap_id	= 1,		% 当前正在进行的章节
				 use_id		= [],		% 可以进入的章节
				 copys		= [],		% 保存的副本信息
				 chap_reward= [],		% 领取过章节评价奖励的章节ID
				 team_ids	= []		% 未开启但已组队的副本(每天要刷新且每天只能组队一次)
				}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 拳皇生涯
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(fighters,{
				 	date		= ?null,	% 日期
					war_times	= 0,		% 挑战次数
				 	buy_times	= 0,		% 当天已购买次数
				 	reset_times	= 0,		% 当天重置副本挂机次数
					
					up_date		= ?null,	% 挂机停留日期
					up_is		= ?CONST_FIGHTERS_UPNO,	% 当前是否挂机
					up_chap_id	= 0,		% 当前挂机的章节
					up_copy_id	= 0,		% 当前挂机的副本
					up_after	= ?false,	% 是否可以执行apply_after
					
					chap_id		= 0,		% 当前正在进行的章节
				 	use_id		= [],		% 可以进入的章节
					pass_info	= [],		% 章节信息[{ChapId,[PassCopyId|...]}|...]
				 	copys		= [],		% 保存的拳皇副本信息
					is_free_re	= ?CONST_TRUE% 是否有免费重置
				  }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 风林山火
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(flsh,	{
				 date		= ?null,	% 日期
				 is_get		= ?CONST_TRUE,% 是否已领取
				 times		= 0,		% 剩余玩的次数
				 swi_times	= 0,		% 已换牌次数
				 pai_data	= ?null		% 玩家的牌
				}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 排行榜
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(top,			{
						 times				= 0,    % 崇拜次数
						 date				= 0		%  日期
						}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 恢复包
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(regain,			{
						 hp_usable			= 0,	% 气血存储剩余值
						 mp_usable			= 0		%   能量存储剩余值	
						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 玩家战斗/技能信息
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(war_p,{
			   % [Temp]战斗后状态  1:正常   0:死亡  (见CONST_WAR_STATE_*)
			   state		  = 1, 
			   % [Temp]请求PK2(切磋)玩家的UID
			   pk2		  = 0,
			   % [Temp]战斗开始时间(毫秒)
			   start		  = 0,
			   % [Temp]战斗回合数
			   round		  = 0,
			   % [Temp]战斗参数中第一个参数
			   war_paras_1  = 0,
			   % [Temp]战报临时字段  
			   %    (发起者存 #war_d{}[已存 有id 并把wd设<<>>,没存 id为0], 
			   %     参于者存 发起者的Mpid, 
			   %     默认为?null[战斗开始也设为?null])
			   war_data	  = [],
			   % 世界Boss属性加成
			   other_buff = [],
			   %% 学习的技能 {SkillId,SkillLv}
			   skill   	  = [],
			   use_skill  = [],
			   idx		  = 3, 	 %% 默认阵型位置
			   %% 炼体
			   tried_m	  = [],	 %% 炼体所收集的怪物状态
			   tried		  = 0,	 %% 炼体
%% 			   kill_m	  = [],	 %% 怪物播剧情状态[{{MapId,Gid},First_kill,First_success} | ...]
			   % 阵型
			   array_data = [], %阵位加成{阵位,加成属性#array_attr{}}
			   array	  = {0, 0,0,0, 0,0,0}  %% 阵型信息出战伙伴
			  }). 
%% 战斗参数
-record(war_paras,{
				   ad1			= 0,	% 数据1(见常量：CONST_WAR_PARAS_1_*)
				   ad2			= 0,	% 数据2
				   ad3			= 0,	% 数据3
				   ad4			= 0,	% 数据4
				   ad5			= 0		% 数据5
				  }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 式神
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -record(pet_info, 	{
%% 					 call_id	= 0,			% 已召唤式神id（0为未召唤）
%% %% 					 usable		= ?null,		% 式神开启情况
%% 					 pets		= ?null		    % 式神元组
%% 					}).
-record(pet,	{
				 id           = 0,           	%% 魔宠ID
				 lv           = 0,              %% 魔宠等级
				 skin_id	  = 0,			%% 使用中的皮肤
				 skill_id     = 0,				%% 使用中的技能id
				 skills		  = [],             %% 已开通技能ids
				 unreal_skin  = [],         	%% 开通皮肤
				 exp		  = 0,		    	%% 等级当前经验值
				 next_exp     = 0,              %% 下一级所需经验
				 
				 gold_exp     = 0,              %% 钻石培养经验
				 gold_ten_opp = 0,            	%% 钻石培养突进概率
				 gold_time    = 0,              %% 钻石倍率
				 good_exp     = 0,              %% 道具培养经验
				 good_ten_opp = 0,              %% 道具培养突进概率
				 good_time    = 0,              %% 道具倍率

				 strong_att   = 0,              %% 物理攻击
				 strong_def   = 0,              %% 物理防御
				 skill_att    = 0,              %% 技能攻击
				 skill_def    = 0,              %% 技能防御
				 hp           = 0,              %% 气血
				 ext		  = ?null						% 扩展
				}).


-record(pet_control, 		{
							 color				= 0,	% 宠物颜色
							 odds				= 0,	% 成功几率
							 odds_max			= 0,	% 最大几率
							 stone_id			= 0,	% 祭炼石
							 stone_num			= 0,	% 祭炼石数量
							 luck_id				= 0,	% 祭炼符
							 luck_max			= 0,	% 最大祭炼符
							 currency_type		= 0,	% 货币类型
							 currency_value		= 0 	% 货币值
							}).
-record(pet_refine,	 		{
							 count				= 0,	% 祭炼数
							 spirit_hp			= 0,	% 生命灵性
							 spirit_attack		= 0,	% 攻击灵性
							 spirit_defense		= 0,	% 防御灵性
							 spirit_healthy		= 0 	% 健体灵性  	
							}).
-record(pet_step_control, {
						   step				= 0,	% 宠物等阶
						   odds				= 0,	% 成功几率
						   odds_max			= 0,	% 最大几率
						   step_id				= 0,	% 进阶丹
						   step_num			= 0,	% 进阶丹数量
						   luck_id				= 0,	% 进阶符
						   luck_max			= 0,	% 最大进阶符
						   currency_type		= 0,	% 货币类型
						   currency_value		= 0, 	% 货币值
						   hide_odds			= 0 	% 隐藏几率
						  }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 坐骑
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(mount,	{
				mount_id    	 = 0,           %% 坐骑ID
				lv          	 = 0,           %% 坐骑等级
				next_id     	 = 0,           %% 下一阶段ID
				exp				 = 0,			%% 现有经验
				next_exp    	 = 0,           %% 下一级所需经验
				mount_attr		 = ?null,		%% #attr{}
				prop_attr		 = ?null,		%% #attr{}

				liusion_mountid	= [],			%% 已经开启并幻化过的坐骑ID
				noliu_mountid	= [],			%% 已经开启没有幻化过的坐骑ID
				date			= ?null,		%% 日期
				cul_times		= 0				%% 培养次数(每日要刷新)
				}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 好友
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -record(relation,   {
%%                      friend     = []    		% 联系人列表 根据里面的type分类
%%                     }).

-record(friend,		{
					 uid		= 0, 			% 好友Uid
					 type		= 0,			% 联系人类型 1：好友  2 最近联系人 3 黑名单
 					 time		= 0				% 添加时间
					 }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 招财
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(weagod,		{
					 date		= 0,			% 日期
					 times		= 0,			% 今天招财次数			

					 auto		= ?CONST_FALSE,	% 是否自动招财
					 automoney	= 0				% 自动招财数量
					}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 组队
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 队伍
-record(team,		{
					 	team_id		= 0,		%% 队伍Id
						copy_id		= 0,		%% 副本ID
						copy_type	= 0,		%% 副本类型
						uid			= 0,		%% 队长Uid
					 	mpid	 	= ?null,	%% 队长Mpid
						socket		= ?null,	%% 队长Socket
						name		= <<>>,		%% 队长姓名
						lv			= 0,		%% 队长等级
						map			= 0,		%% 队伍所在地图Id
						spid		= 0,		%% 队伍所在地图进程Id
						state		= 0,		%% 队伍状态(0:组队中|1:战斗中)
					 	mem		 	= []		%% 成员列表[#team_m{}|...]
			  		}).
%% team_member 队伍成员
-record(team_m,	{
						uid			= 0,		%% 队伍成员Uid
					 	mpid	 	= 0,		%% 队伍成员Mpid
						socket		= ?null,	%% 队伍成员Socket
						name		= <<>>,		%% 队伍成员姓名
						name_color	= ?CONST_COLOR_GREEN,%% 队伍成员姓名颜色
						lv			= 0,		%% 队伍成员等级
						power   	= 0,        %% 队伍成员战斗力
						clan_name	= <<>>,		%% 社团名字
						pos			= 0,		%% 队伍成员显示位置(1,2,3,4)
						pro			= ?CONST_PRO_NULL,		%% 队伍成员职业
						sex			= ?CONST_SEX_NULL,		%% 队伍成员性别
						country		= ?CONST_COUNTRY_DEFAULT%% 队伍成员国家
			  		}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 任务目标
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(target_p,	{
					 serial			= 0,			% 当前目标序号
					 type			= 0,			% 当前目标类型
					 value			= 0,			% 当前目标值
					 nowvalue		= 0,			% 已达目标值
					 target_list	= []			% 目标列表				 
					}).

-record(target,		{
					 serial			= 0,			%% 目标序号
					 type			= 0,			%% 目标类型
					 value			= 0,			%% 目标值
					 next			= 0,			%% 下个目标序号
					 state			= 0				%% 目标状态
					}). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 封神台
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(arena,  {
				 date          = 0,                        % 日期
				 time          = 0,                        % 挑战结束时间
				 buy_time      = 0,                        % 购买结束时间
				 ranking       = 0,                        % 当前排名
				 %%integral      = 0,                        % 挑战积分
				 win_count     = 0,                        % 连赢次数
				 win_sum	   = 0,                        % 累积赢的次数
%% 				 sum           = 0,                        % 累积挑战的次数 
				 surplus       = 0,                        % 剩余挑战次数
				 buy_count     = 0,                        % 购买挑战次数
%% 				 sweep		   = 0,                        % 当前已挑战次数
%% 				 title_id      = 0,                        % 称号ID
%% 				 every_renown  = 0,                        % 每次挑战结束获得的积分
				 is_first      = 0,                        % 是否为第一名
				 id            = 0,                        % 战报ID
				 trend 		   = 0,						   % 趋势0:不变，1:上升，2:下降
				 show_war      = ?null,                    % 最近一次战报展示的时间和ID {Time,Id}
				 moil		   = ?null					   % 苦工
				}).
%% 数据库排行榜信息
-record(rank_data, {
					rank       = 0,                        %  排名 
					uid        = 0,                        %  玩家ID
					name       = <<>>,                     %  玩家名字
					city	   = 0,						   %  阵营
					sex        = 0,                        %  性别
					pro        = 0,                        %  职业
					lv         = 0,                        %  等级
					renown	   = 0,                        %  声望
					win_count  = 0,                        %  连赢次数
					surplus    = 0,                        %  剩余挑战测试
					power	   = 0                     		%  战斗力
				   }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NPC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(npc, 	 {
				   key			= 0,
				   npc_id		= 0,
				   sid			= 0,
				   uid			= 0,
				   socket		= 0,
				   mpid		= 0,
				   team_pid	= 0,
				   leader_sid	= 0,
				   leader_uid	= 0,
				   
				   name		= 0,
				   pro			= 0,
				   sex			= 0,
				   lv			= 0,
				   country		= 0,
				   clan		= 0,
				   powerful	= 0
				  }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 公告
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(notice, {
				 id			= 0, 	% 公告ID
				 type		= 0,	% 显示区域  见常量：CONST_BROAD_AREA_＊
				 touch		= 0, 	% 上次触发时间
				 interval	= 0, 	% 推送公告间隔时间(秒)
				 begin_time	= 0, 	% 开始时间
				 end_time	= 0, 	% 结束时间
				 show_time	= 0,	% 显示时长
				 content	= <<>>  % 内容
				}).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 活动
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(activ_list,		{
						 id				= 0,		% 唯一ID
						 type			= 1,		% 分类(任务,副本，活动)
						 arg     		= 0,		% 活动参数
						 lv      		= 1,		% 最少等级
						 times   		= 1,		% 次数
						 number 		= 1,		% 人数
						 activate 		= 0,		% 激活时间（开服第几天才开起，0：为开服当天  n>=现在日期减开服日期）
						 week       	= [],		% 日期（每天[]    [1,3,7]每周周一，周三，周日）
						 time           = [],		% 时间
						 tip           	= [],		% 提前通知
						 show        	= 1,		% 是否一直显示
						 hide 			= 0,		% 隐藏间隔
						 open_event 	= 0,		% 打开#事件
						 open_scene		= 0,        % 打开#场景      
						 open_arg		= 0,		% 打开#参数 
						 reward_arg_key = 0,		% 奖励属性
						 reward_arg_val = 0,		% 奖励属性 值
						 reward_gold	= 0,		% 金币
						 reward_exp		= 0,		% 经验
						 reward_goods   = []		% 物品  
						}).                                       
 
-record(activ_boss,		{
						 id				= 0,		% 唯一ID
						 type      		= 1,		% 分类(日常BOSS，活动BOSS)
						 lv      		= 1,		% 最少等级
						 monster  		= 0,		% 怪物ID
						 fighting  		= 0,		% 战力估算
						 activate 		= 0,		% 激活时间（开服第几天才开起，0：为开服当天  n>=现在日期减开服日期）
						 week       	= [],		% 日期（每天[]    [1,3,7]每周周一，周三，周日）
						 time           = [],		% 时间
						 tip           	= [],		% 提前通知
						 hide    		= 0,		% 消失时间
						 scene      	= 0,		% 打开#场景
						 pos   			= 0,		% 打开#场景坐标   [{x,y},{x,y},...]  或 {[{x,y},{x,y},...],[{x,y},{x,y},...],[{x,y},{x,y},...]}(区分阵营为{风,火，云}) 
						 reward_arg_key = 0,		% 奖励属性
						 reward_arg_val = 0,		% 奖励属性 值
						 reward_gold	= 0,		% 金币
						 reward_exp		= 0,		% 经验
						 reward_goods   = []		% 物品 
						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% buffer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(buffer,			{
						 type			= 0,		% buff类型
						 type_sub		= 0,		% 在线有效|离线|不限时 
						 start			= 0,		% 开始时间戳
						 remain			= 0,		% 持续时间(秒|到期时间戳)
						 value			= 0,		% buff值
						 icon			= 0			% buff图标
						}).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% renown 声望
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(renown,			{
						 renown_lv		= 0,		% 声望等级
						 exp			= 0,		% 声望值
						 get_lv			= 0,		% 上次领取俸禄的声望等级
						 date1			= 0,		% 上一次领取俸禄的日期
						 date2			= 0,		% 上一次扣除声望的日期
						 state			= 0			% 是否播放升级特效
						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% energy 体力
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(energy,			{
						 energy_value	= 0,		 % 当前体力值
                         buff_value     = 0,         % 额外赠送体力值
						 buy_base		= 0,		 % 可购买体力次数
						 today_buy_num	= 0,		 % 今天购买体力的次数
						 last_date		= 0,		 % 购买体力的时间
                         start_date 	= 0,		 % 初始化时间点
                         buff_time      = {0,0},     % 领取buff时间
						 state          = 0          % 是否已经领取buff
						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% shop 店铺
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(shop,			{
						 type			= 0,		% 店铺类型
						 type_bb		= 0,		% 店铺子类型
						 goods_list		= [] 		% 商品列表						 

						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 苦工
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(moil, {
			   	type_id		   	= 0,				% 当前身份		
				captrue_count	= 0,				% 抓捕次数
				active_count	= 0,				% 互动次数
				calls_count		= 0,				% 求救次数	
				protest_count	= 0,				% 反抗次数
				expn			= 0,				% 今日获得经验
				landlord		= 0,				% 主人Uid
				protect_time	= [], 				% 保护时间
				buy_count       = 0,                % 购买抓捕次数
				moil_data		= [],				% [{苦工Uid,Time}|_]
				captrue_list	= [],				% [{Sid,Uid}|_]可抓捕列表
				revenge_list	= []				% 夺仆之仇列表
			   }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 三界杀
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(circle,{
				chap		= 1,		%% 当前章节
				id			= 0,		%% 当前武将Id 
				use_id		= [],		%% 所有可以挑战的
				war_id		= [], 		%% [{id,count}|_]已打的武将id 和 数量 
				date        = 0		 	%% 日期
			   }).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 签到
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(sign,	{
				num			= 1, 		%% 连续第几天登陆
				date        = 0,		%% 普通上次签到日期
%% 				date2       = 0,		%% VIP上次签到日期
%% 				com_sign	= 0,		%% 普通玩家签到标记
%% 				vip_sign	= 0,		%% VIP签到标记
				signreward	= []		%% 每天是否领取信息
				}).

-record(signreward,	{
				day			= 1, 		%% 第几次签到 
				is_get      = 0 		%% 是否领取(1:已经领取;0:未领取)
				}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 新手特权
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(privilege,	{
			    is_open		= 0,		%% 是否开通新手特权
				day			= 1, 		%% 连续第几天领取
				date        = 0,		%% 上次领取日期
				is_get  	= 0 		%% 是否领取(1:已经领取;0:未领取)
				}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 世界BOSS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(world_boss,{
					die_count	= 0, 		%% 死亡次数
					world_buff	= [],		%% boss_buff
					s_time		= 0, 		%% 死亡时间
					buy_count	= 0,		%% 金元鼓舞次数
					buff		= [],		%% 鼓舞加成
					data		= 0			%% 时间
				   }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 帮派心魔
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(clan_boss,{
				   call_count  = 0,			%% 召唤心魔次数
				   part_count  = 0,			%% 参与心魔挑战次数
				   ach_gold	   = 0,			%% 挑战获得金币
				   s_time	   = 0,         %% 战斗时间
				   date		   = 0			%%  时间
				   }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 活动--怪物攻城
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(defend_book,{
					 star_time	= 0,        %% 活动结束时间
					 end_time	= 0,		%% 战斗结束时间
					 data		= 0,		%% 时间
					 die_time	= 0,		%% 玩家死亡时间
					 die_count	= 0,		%% RMB复活次数
					 get_buff	= 0,		%% 获取攻击增益
					 change_count=0,		%% 玩家RMB更换战壕的次数
					 kill_monster=[]		%% 击杀怪物编号[{Num,GMid}]
					}).

-record(defend_monsters,{
						 gmid 		= 0,		%% 怪物唯一生成Id
						 mid		= 0,		%% 怪物Id
						 pos_x		= 0,		%% Y轴坐标
						 pos_y		= 0,		%% X轴坐标
						 mhp	 	= 0,		%% 怪物当前血量
						 all_mhp	= 0 		%% 怪物最大血量
						}).

-record(defend_rank, {
					  uid        = 0,                        %  玩家ID
					  integral   = 0,                        %  伤害值
					  name       = <<>>,                     %  玩家名字
					  name_color = 0,						 %  角色名颜色
					  city	     = 0,						 %  阵营
					  title_id   = 0,                        %  称号ID
					  sid        = 0,                        %  服务器ID
					  sex        = 0,                        %  性别
					  pro        = 0,                        %  职业
					  lv         = 0,                        %  等级
					  trench     = 0,                        %  当前战壕编号 无=0
					  rewards	 = []						 %  击杀掉落物品
%% 					  arm_rewards =0					 	 %  单次攻击是否有效 ?CONST_TRUE::有效
					 }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 活动--精彩活动(促销)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(sales,		{
					 id,					%% 活动ID
					 rece		=[],		%% 活动类型
					 value,				%% 可领取阶段列表
					 seconds				%% 时间戳
					 }).


-record(sales_sub,	{
					 id_sub,				%% 活动阶段ID
					 state,					%% 可领取状态
					 value					%% 当前阶段值
					 }).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 活动--天宫之战
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(skywar_role,	{
						 sid = 0,				%% 玩家服务器ID
						 uid = 0,				%% 玩家uid
						 name = <<>>,			%% 玩家名字
						 lv = 0,				%% 玩家等级
						 clan_id = 0,			%% 帮派ID
						 clan_name = <<>>,		%% 帮派名字
						 camp = 0,				%% 攻守阵营(?CONST_TRUE 攻方 | ?CONST_FALSE 守方)
						 player = ?null,		%% 玩家数据(攻守)
						 kill = 0,				%% 击杀数(总)
						 dead = 0,				%% 死亡数
						 one_max = 0,			%% 连续击杀数(当前)
						 one_max2 = 0,			%% 连续击杀最大数
						 die = 0,				%% 死亡状态
						 is_online = 0,			%% 是否在天宫之战场景内(?CONST_TRUE:在天宫之战场景内 | ?CONST_FALSE:不在场景内)
						 punish = 0,			%% 惩罚截止时间戳
						 score = 0,				%% 积分
						 revive = 0,			%% 复活次数
						 bomb = 0				%% 炸弹伤害
						}).

-record(skywar_clan,	{
						 clan_id = 0,			%% 帮派ID
						 clan_name = <<>>,		%% 帮派名字
						 camp = 0,				%% 攻守阵营(?CONST_TRUE 攻方 | ?CONST_FALSE 守方)
						 rank = 0,				%% 排名
						 score = 0				%% 积分
						 }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 年兽
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(nianshou,		{
						 call_count  = 0,	%% 一召唤的次数
						 date	     = 0	%% 召唤日期
						 }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 次数物品使用日志 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(times_goods_logs,	{
							 ref,
							 uid,
							 name,
							 name_color,
							 gid_use,
							 count_use,
							 gid_get,
							 count_get,
							 seconds							 
							 }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 钓鱼达人,龙宫寻宝
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(fishing,		{
						 get_time				= 0,	% 上次钓到鱼的时间
						 end_time				= 0, 	% 结束钓鱼时间
						 rewards				= [],	% 钓鱼奖励
						 date					= 0,	% 日期（s）
						 num					= 0		% 当天钓鱼的次数
						}).


-record(dragon,		{
						 logs					= <<>>,	% 寻宝日志
						 date					= 0,	% 日期（s）
						 num					= 0		% 寻宝次数
						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 跨服战
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(stride,			{
						 date					= 0,    % 报名时间
						 rank					= 0,    % 三界争霸排名
						 super_rank				= 0,	% 巅峰之战排名
						 state					= 0,    % 报名状态
						 cenci					= 6,    % 当前的层次
						 cenci2					= 1,	% 越级波次
						 war_count				= 0,	% 每天可挑战次数
						 buy_count				= 0, 	% 每天可购买次数
						 super_count			= 0,	% 巅峰之战挑战次数
						 super_buy				= 0,	% 巅峰之战购买次数
						 wish_count				= 0,	% 许愿剩余次数
						 yesday_rank			= 0,    % 昨日排名
						 today_jf				= 0, 	% 今日挑战积分
						 stride_jf				= 0,	% 总积分
						 title					= 0,	% 称号
						 group					= 1,  	% 玩家组别
						 time					= 0     % 时间
						 }).	

-record(stride_rank,	{
						 rank					= 0,    % 当前排名
						 sid					= 0,    % 服务器ID
						 uid					= 0,    % 玩家Uid
						 name					= <<>>, % 玩家姓名
						 pro					= 0,	% 玩家职业
						 sex					= 0,	% 玩家性别
						 lv						= 0,	% 玩家等级
						 name_colcor			= 0,	% 玩家名字颜色
						 is_war					= 0,	% 是否可挑战
						 cenci					= 0,	% 层次
						 yesday_rank			= 0,    % 昨日排名
						 power					= 0,    % 玩家战斗力
						 today_jf				= 0,	% 今日挑战积分
						 stride_jf				= 0, 	% 总积分
						 date					= 0,    % 时间
						 partners				=[]		% 伙伴列表
						 }).

-record(wish_logs,		{
						 sid =0,				% 服务器ID
						 uid	=0,				% 玩家UID
						 name = <<>>,			% 玩家名字
						 name_color= 0,			% 玩家名字颜色
						 type	  = 0,			% 许愿类型
						 date	  = 0			% 许愿时间
						}).

-record(war_logs,		{
						 sid =0,				% 服务器ID
						 uid	=0,				% 玩家UID
						 name = <<>>,			% 玩家名字
						 name_color= 0,			% 玩家名字颜色
						 t_sid =0,				% 被挑战服务器ID
						 t_uid	=0,				% 被挑战玩家UID
						 t_name = <<>>,			% 被挑战玩家名字
						 t_name_color= 0,		% 被挑战玩家名字颜色
						 rs	  = 0,				% 结果
						 war_id=0,				% 战报ID
						 date	  = 0			% 时间
						}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 科举
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(keju,           {
				         mlistid =[],           %每日答题已答题目列表
                         mdate =0,              %每日答题上一题日期
                         mnum = 0,              %每日答题数量
                         mtrue = 0,             %每日答题正确题目的数量
                         is_mget = 0,           %每日答题是否可以领取奖励 

                         kdate =0,              %御前科举上一题时间
				         knum =0,               %御前科举答题数量
                         ktrue =0,              %御前科举正确的题目数量
                         is_kget =0             %御前科举是否可以领取奖励
                         }).

-record(keju_rank,    {
                       uid = 0,                 %玩家id
                       name = <<>>,             %玩家名字
                       name_color = 0 ,         %玩家名字颜色
                       score = 0                %得分
                      }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%阎王殿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(kinghell,	{
					 date		= ?null,		% 日期
					 kings		= [],			% 各种阎王(挑战成功)
					 partner	= 0,			% 选中单挑的伙伴
					 xj			= []			% [{PartnerId,[{kingId,Lv}|...]|...}]
					 }).
-record(kings,		{
					 kingid		= 0,			% 阎王id
					 preid		= 0,			% 上一个阎王id
					 nextid		= 0,			% 下一个阎王id
					 pet		= [],			% 判官([{Type,[{MonsType,MonsId}|...],State,Dtstate}])(state 0:已经挑战  1:可挑战 2：不可挑战   Dtstate 0:没单挑 ,1:胜利,2:失败)
					 state		= 0,			% 阎王状态(1:挑战成功 2:挑战中)
					 ysnum		= 0,			% 元神数量
					 yyaf		= 0,			% 语言安抚次数
					 giftaf		= 0				% 礼物安抚次数
					 }).
-record(king_kill,	{
					 mons_id	= 0,			% boss id
					 dt_first	= ?null,		% 单挑首次击破记录 {Sid,Uid,Uname,WarId}
					 dt_best	= ?null,		% 单挑最佳击破记录 {Sid,Uid,Uname,WarId,HP}
					 zs_first	= ?null,		% 正式首次击破记录 {Sid,Uid,Uname,WarId}
					 zs_best	= ?null			% 正式最佳击破记录 {Sid,Uid,Uname,WarId,HP}
					 }).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% proc_ud
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(proc_ud,  {
				 	proc		= ?null,
					init_mod	= role_api,
					init_fun	= init_player_attr,	%% {Player2,Data} = role_api:init_player_attr(Player),
					encode_mod	= role_api,
					encode_fun	= encode_attr,		%% EnData = role_api:encode_attr(Data),
					decode_mod	= role_api,
					decode_fun	= decode_attr,		%% DeData = role_api:decode_attr(EnData),
					
					dictget_mod	= role_api_dict,
					dictget_fun	= fcm_get,			%% DeData = role_api_dict:fcm_get(),
					dictset_mod	= role_api_dict,
					dictset_fun	= fcm_set			%% role_api_dict:fcm_set(Data),
				  }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(sys,  	 {
				 	lv_sys		= [], %% lv开放系统列表
					task_sys	= [], %% 任务开放系统列表
					cue			= []  %% 不进行提示的系统Id列表
				  }).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 斗气
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(douqi,	{
				 start_limit	= 0, %% 功能是否开启
				 grasp_lv		= 0, %% 当前领悟等级
				 adam_war		= 0, %% 斗魂值
				 free_times		= 0, %% 每日免费领悟次数
				 gold_times		= 0, %% 普通领悟次数
				 rmb_times		= 0, %% 钻石领悟次数
				 date			= 0, %% 日期
				 is_first		= 0, %% 是否钻石第一次点击 
				 sto_equip		= [],%% 装备仓库 [#dq_data{}|_] 
				 sto_temp		= [] %% 领悟仓库 [#dq_data{}|_]
				 }).

-record(dq_data,	{
					 dq_id			= 0, %% 斗气唯一ID
					 role_id		= 0, %% 斗气所在位置  ID伙伴装备| 0主角 装备仓 领悟仓库
					 lan_id			= 0, %% 斗气栏编号
					 dq_type		= 0, %% 斗气类型
					 dq_lv			= 0, %% 斗气等级
					 dq_exp			= 0, %% 斗气经验 
					 dq_color		= 0, %%　斗气颜色
					 equip_type		= 0, %%　装备类型
					 is_lock		= 0  %% 是否锁定
					}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 每日一箭
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(shoot,	{
				 free_time			= 0, %% 免费射箭次数
				 purchase_time      = 0, %% 付费射箭次数
				 head               = [],%% 头像位置和奖品信息
				 date               = 0  %% 日期
				}).

-record(head,	{
				 position			= 0, %% 头像的位置
 				 is_shoot           = 0, %% 是否被射中(0：没被射中1：已被射中)
				 type				= 0, %% 奖品的类型(1：美刀，2：钻石，3：道具)
				 award              = 0  %% 位置上的奖品
				}).

-record(shoot_data,	{
					 money			= 0, %% 累积的奖金
					 last_award     = ?null, %% 上一期至尊大奖信息
					 history=[]			 %% 近5次该区玩家获得的大奖信息
					}).

-record(s_history,	{
					 uid		= 0,    %% 获得大奖的玩家的uid
					 goods_id	= 0,	%% 道具id
					 count  	= 0,	%% 道具数量
					 seconds	= 0		%%  获奖时间
					}). 

-record(boss_dps,	{
					 uid			= 0,    %% 玩家的uid
					 name		= 0,		%% 玩家姓名
					 lv			= 0,		%% 玩家等级
					 hp			= 0,		%% 当前血量
					 harm		= 0,		%% 玩家伤害
					 kill_boss	= 0 		%% 是否击杀Boss
					}). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 格斗之王
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(wrestle_con,  {
					  idx    = 0,                                   %% 活动id    
                      state  = 0,                                   %% 活动状态  0:预赛中 1:预赛结束 2:决赛进行中 3:决赛结束 4:争霸赛进行中 5:争霸赛已经结束 
					  value  = 0,                                   %% 轮次
                      time   = {0,0},                               %% 时间
                      pebble = ?CONST_WRESTLE_PEBBLE,               %% 竞技水晶
                      drop   = []                                 %% 离开面板uid列表
                   
					  }).

-record(wrestle,     {
                      uid = 0,              %% 玩家的uid
                      group_id = 0,         %% 分组组id
                      group_index = 0,      %% 分组索引
					  pos = 0,              %% 小组积分榜排名
                      name = <<>>,          %% 玩家姓名
					  score = 0,            %% 玩家积分
                      success = 0,          %% 胜场次
                      fail = 0,             %% 输场次
                      name_color = 0,       %% 玩家名字颜色
                      lv = 0,               %% 玩家等级
					  sex = 0,              %% 玩家性别
					  pro = 0,              %% 玩家职业 
					  power = 0,            %% 玩家战斗力
					  areana_rank = 0,      %% 竞技场排名
					  foe_uid	= 0,		%% 对手Uid(每一轮自己对手的Uid)
					  is_handle	= ?false	%% 格斗之王是否已处理               
					  }).

-record(wrestle_final,{
					   type      = 2,           %% 区分上下半区：0 上半区 1 下半区                       
					   index     = 0,           %% 索引
                       uid       = 0,           %% 玩家uid
                       name      = <<>>,        %% 玩家名字
					   fail_turn = 0,           %% 哪一轮失败
                       is_fail   = ?false,      %% 是否失败过
                       is_handle = ?false,      %% 是否已经处理过
					   is_reward = ?false,      %% 是否已经领取奖励
                       is_king   = ?false,      %% 是否是王者争霸
					   to_uid    = 0            %% 对手uid 
 					   }).

-record(wrestle_guess,{
                       uid = 0,            %% uid
                       name = <<>>,        %% 名字
                       pick_list = [],     %% 选中的冠军列表
                       rmb = 0             %% 下注金额
					   }).

%% 排行版
-record(top_ngc,    {
					 uid 		= 0,           	%% 玩家的uid
					 name 		= <<>>,         %% 分组组id
					 name_color = 0,    		%% 分组索引
					 clan_id 	= 0,       		%% 玩家帮派ID
					 clan_name 	= <<>>,         %% 玩家名字
					 lv 			= 0,        %% 玩家性别
					 powerful 	= 0,       		%% 玩家战斗力
					 rank		= 0,				%% 逐鹿台排名
					 ext1 		= 0,            %% 
					 ext2 		= 1,        		%% 
					 ext3 		= 0,        		%% 
					 ext4 		= 0,    			%% 
					 ext5 		= 0       		%% 
					}).


%%　活跃度
-record(active_link,    {
						 date		= 0,		%% 日期
						 rewards	= [],		%% 奖励数据
						 link_data	= []		%% 数据
						}).

%%　称号
-record(title,    {
						 id		= 0,		%% 称号ID
						 flag	= 0,		%% 1可使用|0不可使用
						 state	= 0,		%% 称号状态  [1启用 | 0未启用]
						 st		= 0,		%% 开始时间
						 et		= 0			%% 结束时间 util:seconds()
						}).

%% 打折商城
-record(discount_shop, {
                        uid = 0,                   %% 玩家uid
                        shoplistc = [],            %% 已经买过的商品列表
						buy_time = util:seconds()  %% 购买时间
				        }).
%% 优惠商店
-record(mall_shop,{    shoplistc = [],
					   buy_time = util:seconds()
				  }).



