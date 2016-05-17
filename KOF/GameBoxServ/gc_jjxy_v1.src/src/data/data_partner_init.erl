-module(data_partner_init).
-include("../include/comm.hrl").

-export([get/1]).

% get(伙伴ID);
% 伙伴初始化数据;
% 性别：1 => '女生', 2 => '男生';
% 职业：1 => '战灵' , 2 => '翎羽' , 3=> '天机',4=> '云狂',5=> '逍遥';
% 攻击类型：1 => '力量攻击' , 2 => '灵力攻击';
% 名称颜色：2=> '绿' , 3 => '蓝'，4 => '紫'，5 =>'金'，6 =>'橙'，7 =>'红';
% 天赋：1 => '力量天赋' , 2 => '灵力天赋'，3 => '敏捷天赋'，4 =>'暴击天赋'，5 =>'闪避天赋'，6 =>'格挡天赋'，7 =>'气血天赋',8 =>'防御天赋';
% 类型：1 => '等级为1类型'
get(10051)->
	#d_partner{
		partner_id   = 10051,           %% 伙伴ID
		name_colour  = 4,               %% 名称颜色
		pro          = 4,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 1,               %% 招募等级
		use_limi     = 0,               %% 是否可招募
		use_renown   = 1500000,         %% 招募所达声望值
		shinwakan    = 180,             %% 敏捷
		pay          = 3000000,         %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10416,           %% AIID
		skill_ids    = [{14160,1},{14161,1}],%% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=20000,hp_gro=360,strong=150,strong_gro=130,magic=100,magic_gro=130,strong_att=120,strong_def=120,skill_att=72,skill_def=72,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(10021)->
	#d_partner{
		partner_id   = 10021,           %% 伙伴ID
		name_colour  = 2,               %% 名称颜色
		pro          = 1,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 1,               %% 招募等级
		use_limi     = 1,               %% 是否可招募
		use_renown   = 0,               %% 招募所达声望值
		shinwakan    = 100,             %% 敏捷
		pay          = 100,             %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10402,           %% AIID
		skill_ids    = [{14020,1},{14021,1}],%% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=10000,hp_gro=330,strong=50,strong_gro=100,magic=35,magic_gro=100,strong_att=50,strong_def=30,skill_att=25,skill_def=25,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(10024)->
	#d_partner{
		partner_id   = 10024,           %% 伙伴ID
		name_colour  = 3,               %% 名称颜色
		pro          = 1,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 20,              %% 招募等级
		use_limi     = 1,               %% 是否可招募
		use_renown   = 2000,            %% 招募所达声望值
		shinwakan    = 100,             %% 敏捷
		pay          = 50000,           %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10403,           %% AIID
		skill_ids    = [{14030,1},{14031,1}],%% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=12000,hp_gro=350,strong=80,strong_gro=120,magic=50,magic_gro=120,strong_att=80,strong_def=50,skill_att=40,skill_def=40,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(10027)->
	#d_partner{
		partner_id   = 10027,           %% 伙伴ID
		name_colour  = 3,               %% 名称颜色
		pro          = 1,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 30,              %% 招募等级
		use_limi     = 1,               %% 是否可招募
		use_renown   = 10000,           %% 招募所达声望值
		shinwakan    = 150,             %% 敏捷
		pay          = 100000,          %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10407,           %% AIID
		skill_ids    = [{14070,1},{14071,1}],%% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=15000,hp_gro=370,strong=120,strong_gro=140,magic=80,magic_gro=140,strong_att=120,strong_def=80,skill_att=60,skill_def=60,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(10030)->
	#d_partner{
		partner_id   = 10030,           %% 伙伴ID
		name_colour  = 4,               %% 名称颜色
		pro          = 3,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 40,              %% 招募等级
		use_limi     = 1,               %% 是否可招募
		use_renown   = 40000,           %% 招募所达声望值
		shinwakan    = 150,             %% 敏捷
		pay          = 200000,          %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10409,           %% AIID
		skill_ids    = [{14090,1},{14091,1}],%% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=20000,hp_gro=380,strong=150,strong_gro=150,magic=100,magic_gro=150,strong_att=150,strong_def=100,skill_att=75,skill_def=75,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(10033)->
	#d_partner{
		partner_id   = 10033,           %% 伙伴ID
		name_colour  = 4,               %% 名称颜色
		pro          = 1,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 50,              %% 招募等级
		use_limi     = 1,               %% 是否可招募
		use_renown   = 80000,           %% 招募所达声望值
		shinwakan    = 150,             %% 敏捷
		pay          = 300000,          %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10414,           %% AIID
		skill_ids    = [{14140,1},{14141,1}],%% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=25000,hp_gro=410,strong=200,strong_gro=180,magic=135,magic_gro=180,strong_att=200,strong_def=130,skill_att=100,skill_def=100,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(10036)->
	#d_partner{
		partner_id   = 10036,           %% 伙伴ID
		name_colour  = 4,               %% 名称颜色
		pro          = 4,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 60,              %% 招募等级
		use_limi     = 1,               %% 是否可招募
		use_renown   = 150000,          %% 招募所达声望值
		shinwakan    = 200,             %% 敏捷
		pay          = 500000,          %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10412,           %% AIID
		skill_ids    = [{14120,1},{14121,1}],%% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=30000,hp_gro=440,strong=250,strong_gro=210,magic=165,magic_gro=210,strong_att=250,strong_def=170,skill_att=125,skill_def=125,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(10039)->
	#d_partner{
		partner_id   = 10039,           %% 伙伴ID
		name_colour  = 5,               %% 名称颜色
		pro          = 3,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 70,              %% 招募等级
		use_limi     = 1,               %% 是否可招募
		use_renown   = 250000,          %% 招募所达声望值
		shinwakan    = 150,             %% 敏捷
		pay          = 700000,          %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10425,           %% AIID
		skill_ids    = [{14250,1},{14251,1}],%% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=50000,hp_gro=460,strong=300,strong_gro=230,magic=200,magic_gro=230,strong_att=300,strong_def=200,skill_att=150,skill_def=150,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(10042)->
	#d_partner{
		partner_id   = 10042,           %% 伙伴ID
		name_colour  = 5,               %% 名称颜色
		pro          = 1,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 80,              %% 招募等级
		use_limi     = 1,               %% 是否可招募
		use_renown   = 400000,          %% 招募所达声望值
		shinwakan    = 150,             %% 敏捷
		pay          = 1000000,         %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10428,           %% AIID
		skill_ids    = [{14280,1},{14281,1}],%% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=70000,hp_gro=480,strong=400,strong_gro=250,magic=265,magic_gro=250,strong_att=400,strong_def=270,skill_att=200,skill_def=200,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(10045)->
	#d_partner{
		partner_id   = 10045,           %% 伙伴ID
		name_colour  = 5,               %% 名称颜色
		pro          = 1,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 90,              %% 招募等级
		use_limi     = 1,               %% 是否可招募
		use_renown   = 600000,          %% 招募所达声望值
		shinwakan    = 150,             %% 敏捷
		pay          = 1500000,         %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10432,           %% AIID
		skill_ids    = [{14320,1},{14321,1}],%% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=90000,hp_gro=530,strong=500,strong_gro=300,magic=350,magic_gro=300,strong_att=500,strong_def=330,skill_att=250,skill_def=250,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(10048)->
	#d_partner{
		partner_id   = 10048,           %% 伙伴ID
		name_colour  = 6,               %% 名称颜色
		pro          = 3,               %% 职业
		sex          = 1,               %% 性别
		call_lv      = 1,               %% 招募等级
		use_limi     = 0,               %% 是否可招募
		use_renown   = 1000000,         %% 招募所达声望值
		shinwakan    = 200,             %% 敏捷
		pay          = 2000000,         %% 招募美刀花费
		country      = 0,               %% 门派
		talent       = 0,               %% 天赋
		ai_id        = 10435,           %% AIID
		skill_ids    = [{14350,1}],     %% 技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=20,anima=0,hp=100000,hp_gro=580,strong=600,strong_gro=350,magic=400,magic_gro=350,strong_att=600,strong_def=400,skill_att=300,skill_def=300,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(_)->?null.
