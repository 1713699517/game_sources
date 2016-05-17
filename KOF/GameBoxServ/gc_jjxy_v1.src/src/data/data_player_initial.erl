-module(data_player_initial).
-include("../include/comm.hrl").

-export([get/1]).

% get(pro,sex);
% 主角初始化数据;
% 性别：1 => '女生', 2 => '男生';
% 初始方向：默认为 x;
% 初始速度：默认为 xxx
get(1)->
	#d_player_initial{
		pro          = 1,               %% 
		skill_id     = [{10014,1},{10015,1},{10016,1}],%% 
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=6283000,hp_gro=120,strong=30,strong_gro=130,magic=30,magic_gro=130,strong_att=59339,strong_def=500,skill_att=64805,skill_def=0,crit=3000,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(2)->
	#d_player_initial{
		pro          = 2,               %% 
		skill_id     = [{10024,1},{10025,1},{10026,1}],%% 
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=6283000,hp_gro=130,strong=30,strong_gro=130,magic=30,magic_gro=130,strong_att=59339,strong_def=500,skill_att=64805,skill_def=0,crit=3000,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(3)->
	#d_player_initial{
		pro          = 3,               %% 
		skill_id     = [{10034,1},{10035,1},{10036,1}],%% 
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=6283000,hp_gro=110,strong=40,strong_gro=150,magic=40,magic_gro=150,strong_att=59339,strong_def=500,skill_att=64805,skill_def=0,crit=3000,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(4)->
	#d_player_initial{
		pro          = 4,               %% 
		skill_id     = [{10044,1},{10045,1},{10046,1}],%% 
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=6283000,hp_gro=150,strong=30,strong_gro=130,magic=30,magic_gro=130,strong_att=59339,strong_def=500,skill_att=64805,skill_def=0,crit=3000,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(5)->
	#d_player_initial{
		pro          = 5,               %% 
		skill_id     = [{10014,1},{10015,1},{10016,1}],%% 
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=6283000,hp_gro=100,strong=30,strong_gro=100,magic=30,magic_gro=100,strong_att=59339,strong_def=500,skill_att=64805,skill_def=0,crit=3000,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(6)->
	#d_player_initial{
		pro          = 6,               %% 
		skill_id     = [{10014,1},{10015,1},{10016,1}],%% 
		%% 属性#attr{} 
		attr = #attr{sp=200,sp_up=3,anima=0,hp=6283000,hp_gro=100,strong=30,strong_gro=100,magic=30,magic_gro=100,strong_att=59339,strong_def=500,skill_att=64805,skill_def=0,crit=3000,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0} 
	};
get(_)->?null.
