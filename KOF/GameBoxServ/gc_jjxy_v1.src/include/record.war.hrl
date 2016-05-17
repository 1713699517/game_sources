
%% 战斗
%% ---------------------
-record(war, { type		   			= ?CONST_WAR_TYPE_NORMAL, 	%% 战斗类型
			   is_boss              = 0,                        %% 是否有boos
			   scene_id				= 0,						%% 场景ID			                                                                                       
			   scene_pid			= ?null,					%% 场景Pid
			   scene_type			= ?CONST_MAP_TYPE_CITY,		%% 场景类型(?CONST_MAP_TYPE_*) 
			   gourp_id				= 0,						%% 怪物组ID
			           
			   revise_exp			= 1,		                %% 经验校正    
			   force_goods			= [] ,		                %% 强行掉落			
			   paras				= ?null,  					%% 参数   开始战斗时传出来，退出战斗传了出来	   			                                                                                        
			   unit_left			= {?null, ?null,?null,?null, ?null,?null,?null},	%% 左边单元 #war_unit{}                    
			   unit_right			= {?null, ?null,?null,?null, ?null,?null,?null},	%% 右边单元 #war_unit{}          
				
			   winner				= 0,						%% 1:left  2:right : 胜利方
			   win_rank				= ?CONST_WAR_WIN_NONE,		%% 胜利层次（败是对应）（保留）
			   data_unit			= [],						%% 战斗单元数据
			   data	    			= [],						%% 战斗数据
			   coll					= []						%% 指命集			 
			 }).

%% 战斗回合   数据
%% --------------------------------------------------
-record(tg, {
			 	pos					= ?CONST_WAR_POSITION_LEFT, %% 站位 1:左边 2:右边(见常量)
				idx					= 1,						%% 站位索引(1-9)
				is_crit				= 0,						%% 是否暴击
				status_display		= 0,						%% 击方表现状态       (见常量,表现状态CONST_WAR_DISPLAY_*)
				status_result		= 0,						%% 被击方结果状态  (见常量,战斗状态CONST_WAR_STATE_*)
				harm				= 0,						%% 被击方所受到的伤害
				hp					= 0, 						%% 现有HP
				sp					= 0 						%% 现有Sp
			 }).

%% 战斗单元    定义
%% --------------------------------------------------

-record(unit,{      type			= ?CONST_PLAYER,%% 战斗单元    玩家                            : 1  CONST_WAR_UNIT_PLAYER
													%%          怪物（庞物等）   : 2  CONST_WAR_UNIT_MONSTER
				  
					mpid			= ?null, 		%% 角色:Mpid   			怪物:null      宠物： ?nill      忍者： 属于哪个队伍
					uid				= 0,			%% 玩家:角色UID			怪物:生成ID(MonsterMid)     宠物：宠物ID    忍者： 是否为队长 
					sid				= 0,			%% 角色:服务器sid		怪物:ID	   (MonsterId)      宠物：宠物唯一ID   忍者： 忍者ID
					name        	= <<>>,			%% 角色:昵称char[16]		怪物:<<>>
					name_color  	= 0,			%% 角色:角色名颜色		怪物:0
					lv				= 1 ,			%% 等级
					country			= 0 ,			%% 阵营    默认为 0                       怪物:怪物种族
					clan        	= 0,        	%% 家族：显示玩家的家族     怪物:0
					pro				= 1, 			%% 职业                                             怪物:攻击类型
					sex				= 0,			%% 性别				          怪物:攻击距离	
					idx				= 0,	 		%% 位置索引
					vip				= 0,			%% VIP等级                                    怪物:0
					attack_type		= 0,			%% 攻击类型
					state			= ?CONST_WAR_STATE_NORMAL,	%%   战斗状态
					
					armor			= 0,			%% 装备衣服ID          怪物:是否是共享怪
					mount			= 0,			%% 坐骑                                          怪物:是否回血		
					weapon			= 0,			%% 武器 goods_id		       怪物:被杀了否世界广播 
					
					hp				= 0,			%% 当前生命	
					hp_lim			= 0,			%% 最大气血
					sp				= 0,			%% 当前士气
					attr			= #attr{},		%% 基础属性(初始值)         
					skill		    = [],			%% 技能ID
					weapon_skill	= [],			%% 武器技能
					buff			= [],			%% Buff
					map_buff		= [],			%% 场景随机属性加成
					is_leader		= ?CONST_FALSE,	%% 是否是队长 ?CONST_FALSE：不知   ?CONST_TRUE：是
					murderer		= 0,			%% 凶手:被谁杀死的
					array_data		= ?null,		%% 阵型加成					
					immunity		= [],			%%
					%% 炼体
				 	tried_m	  		= [],	 		%% 玩家:星魂所收集的怪物状态	怪物:星魂（0:是不炼体怪物  n>0：可以炼体次数）
				 	tried		  	= 0 	 		%% 玩家:星魂		怪物:星魂能量值 
				 } ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--skill%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 技能
-record(skill, {
				id		= 0,		%% 技能ID
				% name	= <<>>,		%% 名称
				pos     = 0,		%% 技能面板的位置
				type	= 1,		%% 类型   1:被动        2:主动      3:BUFF   4:DEBUFF
				distance= 1,		%% 攻击类型: 0:近程  1:远程 2:无限
				% range = 0,		%% 攻击范围：0：单体  1：列-前后    2：行-左右   3：周边-前后左右
				round	= 1,		%% 是否占回合数:  1:占用   0:不占用
				pro		= [],		%% 职业要求 []:不限职业（默认） 1:修罗 2:幻影 3:逆天 4:死神 5:噬魂
				sex     = 2,		%% 性别要求 1：女生  2：男生  0：无限制（默认）
				
				times 	= 0, 		%% 状态:一少次场战斗触发成功了多
				interval= 0,  		%% 状态:触发后下次触发最少回合间隔 到0了就又可以触发（每个回合减一）
				
			    lv		= 0,		%% 当前技能等级
				% lv_must = 1,      %% 人物等级要求
				lv_max	= 1,		%% 技能等级上限
				slv     = ?null,    %% 当前等级 #s_lv{}
                battle_remark = 0   %% 学习等级限制
				%slv_ns	= ?null     %% 下一等级 #s_lv{}
			   }).

%% 技能 - 等级
-record(s_lv,{
			  	  id			= 0, %% 技能ID	
				  lv	  		= 1, %% 技能等级
				  type			= 1, %% 技能类型
				  skill_attr	= 1, %% 技能属性

				  timing		= 0, %% 触发时机  - 1：自己行动前  2：自己动手时  3：自己动手后  4：战斗开始时
				  limit			= 0, %% 触发限制 - 一场战斗最多触发多少次 0:无限制（默认）
				  interval		= 0, %% 触发限制 - 触发后下次触发最少回合间隔 0:无限制（默认）
				  odds			= 0, %% 触发概率  - 万分比
				  target		= 0, %% 目标
				 
				  must    		= ?null,	%% 升级条件 #s_must{}
				  use_up		= ?null,	%% 升级消耗  #s_use{}
				  use			= ?null,	%% 修练消耗  #s_use{}
				  mc			= ?null  	%% 效果属性1  #s_mc{} | 被动 技能       #attr{}
			}).


%% 条件
-record(s_must,{
				lv 	 	 = 0, %% 人物等级要求
			  	skill	 = 0, %% 前置技能
				skill_lv = 0, %% 前置技能等级要求
				book     = 0, %% 技能书 物品ID 0：不用技能书
				good	 = 0, %% 物品ID	
			    streng_lv= 0  %% 物品强化等级
			   }).
%% 消耗
-record(s_use,	{
				 rmb	 = 0,		% 元宝
				 gold	 = 0,		% 消耗金币
				 renown  = 0,		% 声望
				 power	 = 0,		% 战功
				 star	 = 0,       % 星魂值
				 exp	 = 0,		% 经验值：玩家升级的一种方式
				 sp		 = 0,		% 怒气值
				 soul	 = 0,		% 灵气值
				 cd		 = 0		% 技能冷却时间（秒）
				}).




%% 技能-效果
-record(s_mc,{
				  mc_id			= 0,							% 技能效果
				  state_self	= ?CONST_WAR_STATE_NORMAL,		% 结果状态 自身
				  state_target 	= ?CONST_WAR_STATE_NORMAL,		% 结果状态 目标
				  arg1			= 0,	% 参数1
				  arg2			= 0,	% 参数2
				  arg3			= 0,	% 参数3
				  arg4			= 0,	% 参数4
				  arg5			= 0,	% 参数5
				  arg6			= 0,	% 参数6
				  arg7			= 0,	% 参数7
				  arg8			= 0,	% 参数8
				  arg9			= 0 	% 参数9				
			  }).

%% 技能-Buff
-record(buff,{
				  mc_id		    = 0,	% 来源效果mc_id (CONST_SKILL_MC_*)
				  state_self	= ?CONST_WAR_STATE_NORMAL,		% 结果状态 自身
				  state_target 	= ?CONST_WAR_STATE_NORMAL,		% 结果状态 目标
				  touch			= 0,	% 触发,时机 (CONST_SKILL_TOUCH_*)	
				  have			= ?CONST_SKILL_ROUND_HAVE_NOT,  %%  不占用 回合数  
				                % ?CONST_SKILL_ROUND_HAVE		%%  占用 回合数 
				  %% 回合round为-1，重叠数stack为0，回合数为0,重叠数为0，次数没上限
				  stack			= 0,	% Buff重叠上限(0:无上限,-1:不重叠不替换, Other:替换)
				  round			= 0,	% Buff持续回合(0:只有次数,	-1:永久持续, Other:持续回合)
				  odds			= 0,	% Buff触发机率
				  data1			= 0,	% 数据1
				  data2			= 0,	% 数据2
				  data3			= 0,	% 数据3
				  data4			= 0,	% 数据4
				  data5			= 0		% 数据5
			  }).

%% 战斗数据
%% -record(war_d,{
%% 			   id			= 0,    % 数据自动增长ID
%% 			   luid			= 0,    % 左边玩家UID   发起人
%% 			   lsid			= 0,	% 左边玩家Sid   
%% 			   luname		= <<>>,	% 左边玩家名称
%% 			   ruid			= 0,    % 右边玩家UID   打怪  怪物ID  
%% 			   rsid			= 0,	% 右边玩家Sid   打怪      0
%% 			   runame		= <<>>,	% 右边玩家名称      打怪为 <<>>
%% 			   wd           = <<>>  % 
%% 	   		 }).
			   
