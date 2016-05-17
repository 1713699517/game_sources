-module(data_player_init).
-include("../include/comm.hrl").

-export([get/2]).

% get(pro,sex);
% 主角初始化数据;
% 性别：1 => '女生', 2 => '男生';
% 初始方向：默认为 x;
% 初始速度：默认为 xxx
get(1,1)->
	#d_player_init{
		get_equip    = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,4011,1,0,0,0,0,0},{give,5011,1,0,0,0,0,0},{give,6001,1,0,0,0,0,0}],%% 初始装备
		lv           = 1,               %% 初始等级
		sence_id     = 10100,           %% 出生场景ID
		pos_x        = 27,              %% 初始X坐标
		pos_y        = 59,              %% 初始Y坐标
		dir          = 6,               %% 初始方向
		skin         = 10001,           %% 皮肤
		speed        = 200,             %% 初始移动速度
		talent       = 0,               %% 天赋
		skill_id     = {101,1},         %% 初始化技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=300,hp_gro=350,strong=30,strong_gro=130,magic=30,magic_gro=130,strong_att=35,strong_def=35,skill_att=30,skill_def=30,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(2,1)->
	#d_player_init{
		get_equip    = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,4011,1,0,0,0,0,0},{give,5011,1,0,0,0,0,0},{give,8001,1,0,0,0,0,0}],%% 初始装备
		lv           = 1,               %% 初始等级
		sence_id     = 10100,           %% 出生场景ID
		pos_x        = 27,              %% 初始X坐标
		pos_y        = 59,              %% 初始Y坐标
		dir          = 6,               %% 初始方向
		skin         = 10002,           %% 皮肤
		speed        = 200,             %% 初始移动速度
		talent       = 0,               %% 天赋
		skill_id     = {151,1},         %% 初始化技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=300,hp_gro=360,strong=30,strong_gro=130,magic=30,magic_gro=130,strong_att=35,strong_def=35,skill_att=30,skill_def=30,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(3,1)->
	#d_player_init{
		get_equip    = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,4011,1,0,0,0,0,0},{give,5011,1,0,0,0,0,0},{give,6001,1,0,0,0,0,0}],%% 初始装备
		lv           = 1,               %% 初始等级
		sence_id     = 10100,           %% 出生场景ID
		pos_x        = 27,              %% 初始X坐标
		pos_y        = 59,              %% 初始Y坐标
		dir          = 6,               %% 初始方向
		skin         = 10003,           %% 皮肤
		speed        = 200,             %% 初始移动速度
		talent       = 0,               %% 天赋
		skill_id     = {201,1},         %% 初始化技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=300,hp_gro=340,strong=40,strong_gro=150,magic=40,magic_gro=150,strong_att=35,strong_def=35,skill_att=30,skill_def=30,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(4,1)->
	#d_player_init{
		get_equip    = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,4011,1,0,0,0,0,0},{give,5011,1,0,0,0,0,0},{give,7001,1,0,0,0,0,0}],%% 初始装备
		lv           = 1,               %% 初始等级
		sence_id     = 10100,           %% 出生场景ID
		pos_x        = 27,              %% 初始X坐标
		pos_y        = 59,              %% 初始Y坐标
		dir          = 6,               %% 初始方向
		skin         = 10004,           %% 皮肤
		speed        = 200,             %% 初始移动速度
		talent       = 0,               %% 天赋
		skill_id     = {251,1},         %% 初始化技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=300,hp_gro=370,strong=30,strong_gro=130,magic=30,magic_gro=130,strong_att=35,strong_def=35,skill_att=30,skill_def=30,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(5,1)->
	#d_player_init{
		get_equip    = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,4011,1,0,0,0,0,0},{give,5011,1,0,0,0,0,0},{give,10001,1,0,0,0,0,0}],%% 初始装备
		lv           = 1,               %% 初始等级
		sence_id     = 10100,           %% 出生场景ID
		pos_x        = 27,              %% 初始X坐标
		pos_y        = 59,              %% 初始Y坐标
		dir          = 6,               %% 初始方向
		skin         = 10001,           %% 皮肤
		speed        = 200,             %% 初始移动速度
		talent       = 0,               %% 天赋
		skill_id     = {301,1},         %% 初始化技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=300,hp_gro=330,strong=30,strong_gro=100,magic=30,magic_gro=100,strong_att=35,strong_def=35,skill_att=30,skill_def=30,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(6,1)->
	#d_player_init{
		get_equip    = [{give,1001,1,0,0,0,0,0},{give,2001,1,0,0,0,0,0},{give,3001,1,0,0,0,0,0},{give,4011,1,0,0,0,0,0},{give,5011,1,0,0,0,0,0},{give,11001,1,0,0,0,0,0}],%% 初始装备
		lv           = 1,               %% 初始等级
		sence_id     = 10100,           %% 出生场景ID
		pos_x        = 27,              %% 初始X坐标
		pos_y        = 59,              %% 初始Y坐标
		dir          = 6,               %% 初始方向
		skin         = 10001,           %% 皮肤
		speed        = 200,             %% 初始移动速度
		talent       = 0,               %% 天赋
		skill_id     = {351,1},         %% 初始化技能ID
		attack_type  = 1,               %% 攻击类型
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=300,hp_gro=330,strong=30,strong_gro=100,magic=30,magic_gro=100,strong_att=35,strong_def=35,skill_att=30,skill_def=30,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(_,_)->?null.
