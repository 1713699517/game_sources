%% 场景角色数据
-record(player_s,	{
					 uid			= 0,			% 玩家ID
					 mpid        	= ?null,        % 进程ID(玩家)
					 
					 send_lose		= 0,			% [temp]发送失败数。
					 socket			= ?null,		% Socket
				   	 name       	= <<>>,         % 昵称char[16]
					 name_color 	= 0,			% 角色名颜色
                     sex         	= 0,         	% 性别
                     pro         	= 3,         	% 职业
                     lv          	= 0,            % 等级

					 is_war			= 0,		    % 状态flag 战斗/打造/整理仓库/
					 is_mount		= 0,			% 状态flag 骑乘状态(0:正常状态|1:骑乘中)
					 is_guide    	= 0,            % [Base]新手指导员 (0:正常状态|1:指导员)
					 
					 state			= 0,
					 
					 leader_uid		= 0,			% 状态flag 队伍队长Uid
					 team_id		= 0,			% 队伍ID
					 partners		= [],	% #partner_s{} 出战伙伴列表

					 die			= ?false,
					 relive_times	= 0,

				     begin_x		= 0,			% X开始坐标
					 begin_y		= 0,			% Y开始坐标
					 pos_x			= 0,			% X坐标
					 pos_y			= 0,			% Y坐标
					 pos_pixel_x	= 0,			% X像素坐标
					 pos_pixel_y	= 0,			% Y像素坐标

					 hp_now			= 0,			% 当前血量
					 hp_max			= 0,			% 最大血量
					 
					 speed			= 0,			% 移动速度
				  	 dir			= 5,			% 方向
					 distance		= 0,			% 距离
					 distance2		= 0,			% 距离*距离（距离平方）
					 walk			= ?CONST_FALSE,	% 是否行走状态（?CONST_FALSE:站  ?CONST_TRUE:走）
					 
					 skin_mount		= 0,			% 坐骑皮肤
					 skin_weapon	= 0,			% 武器皮肤
					 skin_armor		= 0,			% 衣服皮肤
					 skin_pet		= 0,			% 魔宠皮肤
					 
					 country     	= 0,            % 国家：显示玩家的国家
					 country_post	= 0,            % 国家：职位
                     clan        	= 0,            % 家族：显示玩家的家族
					 clan_name		= <<>>,			% 家族：显示玩家的家族名称
					 clan_post		= 0,			% 家族：职位
                     vip      		= 0				% VIP等级(0:0级  N:N级  非#vip{} )
				 }).

%% 场景伙伴数据
-record(partner_s,	{
					 partner_id 	= 0,			% 复活点 ID
				 	 lv				= 0,			% 复活点 目标地图ID
					 hp				= 0,			% 复活点移动区域
					 hp_max			= 0,			% 复活点 X坐标
					 die				= ?false,	% 是否死亡
					 pos_x			= 0,			% 坐标x
					 pos_y			= 0			% 坐标y
			    	}).

%% 地图数据
-record(map,	{
				 pid				= ?null,		% 地图进程Pid
				 map_id 			= 0,			% 地图ID
				 suffix				= 0,			% 地图后缀
				 type				= 0,			% 地图类型
				 pass_type			= 0,			% 通关类型
				 pass_value			= 0,			% 通关值
				 war_s				= [],			% 玩家战斗状态
				 counter			= 0,			% 当前地图人数
				 time				= 0,			% 在这个地图呆的时间
				 timer_switch		= 0,			% 计时
				 monsters			= [],			% 怪物组战斗数据
				 monsters_pos_temp	= [],			% 怪物临时列表分布点
				 monsters_all		= [],			% 所有怪物(第一波，第二波...)
				 
				 lx					= 0,			% 屏幕左边X
				 rx					= 0,			% 屏幕右边X
				 reborn_x			= 0,			% 屏幕复活点X
				 screen_gives		= [],			% 屏幕杀完怪奖励give列表
				 screen_now			= 0,			% 怪物打到第几屏
				 screen_sum			= 0,			% 总共多少屏怪
				 collect			= [],			% 地图采集怪
				 buff				= [],			% 玩家在场景里面的BUFF加成(主要用于取经之路)[{Uid,[{Type,Value} | ...]} | ...]
 				 ext				= ?null			% 扩展
			    }).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 怪物数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(monster, {
					 monster_mid	= 0,     		% 生成ID
					 monster_id		= 0,     		% 怪物组编号(大于100)
					 monster_type	= 0,	 		% 怪物类型
					 scene_id		= 0,	 		% 场景ID	
					 ai_id			= 0,			% ai_Id

					 patrol			= 0, 			% 巡逻	 
					 patrol_radius	= 0, 			% 巡逻半径	
					 share			= 0, 			% 共享(1:共,0:否)	
					 regen			= 0, 			% 回血(只对非共享有效)	
					 %hp			= 0,	 		% 当前生命
					 
					 % 场景相关
					 interval		= 0,	 		% 怪物 刷新间隔
					 interval_temp	= 0,	 		% 怪物 刷新间隔临时数据
					 sum			= 0,	 		% 怪物 刷新总数
					 own			= 0,	 		% 属于谁（主要是宠物/护送/采集时，一般怪没有）
					 state			= 1,	 		% 怪物状态(1:没杀过 0:已杀过)
					 
					 origin_x		= 0,	 		% X原点
					 origin_y		= 0,	 		% Y原点
					 
					 begin_x		= 0,	 		% X开始坐标 
					 begin_y		= 0,	 		% Y开始坐标
					 pos_x			= 0,	 		% X坐标
					 pos_y			= 0,	 		% Y坐标
					 pos_pixel_x	= 0,	 		% X像素坐标
					 pos_pixel_y	= 0,	 		% Y像素坐标
					 target_x		= 0,	 		% X坐标目的
					 target_y		= 0,	 		% Y坐标目的
					 
					 flag_move		= 0,	 		% 移动
					 flag_foe		= 0,	 		% 可攻击

					 hp				= 0,			% 当前血量
					 hp_max			= 0,			% 最大血量
					 
					 steps			= 0,			% 怪物等阶
					 speed			= 100,	 		% 移动速度
				  	 dir			= 0,	 		% 方向
					 distance		= 0,  	 		% 距离
					 distance2		= 0,  	 		% 距离平方
					 walk			= ?CONST_FALSE, % 是否行走状态（?CONST_FALSE:站  ?CONST_TRUE:走）
					 reaction_time	= 0,			% 思考时间
                     delay			= 0,			% 副本AI延迟时间
					 attack_interval= 0,			% 攻击间隔时间
					 knock_down		= ?false		% 是否被击倒
				}).

%% 地图数据--热区(传送点)
-record(m_door,		{
					 door_id 		= 0,			% 热区(传送点) ID					 
					 type			= 0,			% 热区(传送点) 类型
					 door_x			= 0,			% 热区(传送点) X坐标
					 door_y			= 0,			% 热区(传送点) Y坐标
					 map_id			= 0,			% 热区(传送点) 目标地图ID
					 x 				= 0,			% 目标地图X坐标
					 y 				= 0				%   目标地图Y坐标
			    	}).

%% 地图数据--复活点
-record(m_reborn,	{
					 reborn_id 		= 0,			% 复活点 ID
				 	 map_id			= 0,			% 复活点 目标地图ID
					 area			= 0,			% 复活点移动区域
					 x 				= 0,			% 复活点 X坐标
					 y 				= 0				%   复活点 Y坐标
			    	}).

%% 压力测试 - record
-record(t_test,	    {
					 socket 		= 0,			% Socket
					 uid			= 0,			% Uid
                     sid			= 0,			% Sid
					 step_mod		= trole,		% 测试-步骤模块
					 step_id		= 0,			% 测试-步骤id
					 data			= <<>>,			% 接收的数据
					 heart			= 5,			% 心跳
					 time			= 10,			% 时间
					 monster		= [],           % 怪物数据
				 	 player_s		= ?null			% 
			    	}).