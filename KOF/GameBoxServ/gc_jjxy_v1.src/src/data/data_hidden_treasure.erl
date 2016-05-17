-module(data_hidden_treasure).
-include("../include/comm.hrl").

-export([get/1,get_ids/0]).

% get();
% 藏宝阁属性表;
% 
get(101)->
	#d_hidden_treasure{
		hidden_layer_id = 101,          %% 藏宝阁层数_ID
		open_lv      = 1,               %% 开通等级
		all_items    = [1001,1002,1003,1004,1005,1006,1007,1008],%% 物品ID（顺时针)
		linking_items = [1001,1002,1003],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=2000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=360,strong_def=0,skill_att=0,skill_def=0,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(102)->
	#d_hidden_treasure{
		hidden_layer_id = 102,          %% 藏宝阁层数_ID
		open_lv      = 1,               %% 开通等级
		all_items    = [1001,1002,1003,1004,1005,1006,1007,1008],%% 物品ID（顺时针)
		linking_items = [1003,1004,1005],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=2000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=360,skill_att=0,skill_def=0,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(103)->
	#d_hidden_treasure{
		hidden_layer_id = 103,          %% 藏宝阁层数_ID
		open_lv      = 1,               %% 开通等级
		all_items    = [1001,1002,1003,1004,1005,1006,1007,1008],%% 物品ID（顺时针)
		linking_items = [1005,1006,1007],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=2000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=0,crit=180,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(104)->
	#d_hidden_treasure{
		hidden_layer_id = 104,          %% 藏宝阁层数_ID
		open_lv      = 1,               %% 开通等级
		all_items    = [1001,1002,1003,1004,1005,1006,1007,1008],%% 物品ID（顺时针)
		linking_items = [1007,1008,1001],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=2000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=0,crit=0,crit_res=180,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(201)->
	#d_hidden_treasure{
		hidden_layer_id = 201,          %% 藏宝阁层数_ID
		open_lv      = 40,              %% 开通等级
		all_items    = [2001,2002,2003,2004,2005,2006,2007,2008],%% 物品ID（顺时针)
		linking_items = [2001,2002,2003],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=5000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=540,skill_def=0,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(202)->
	#d_hidden_treasure{
		hidden_layer_id = 202,          %% 藏宝阁层数_ID
		open_lv      = 40,              %% 开通等级
		all_items    = [2001,2002,2003,2004,2005,2006,2007,2008],%% 物品ID（顺时针)
		linking_items = [2003,2004,2005],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=5000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=540,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(203)->
	#d_hidden_treasure{
		hidden_layer_id = 203,          %% 藏宝阁层数_ID
		open_lv      = 40,              %% 开通等级
		all_items    = [2001,2002,2003,2004,2005,2006,2007,2008],%% 物品ID（顺时针)
		linking_items = [2005,2006,2007],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=5000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=0,crit=0,crit_res=0,crit_harm=160,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(204)->
	#d_hidden_treasure{
		hidden_layer_id = 204,          %% 藏宝阁层数_ID
		open_lv      = 40,              %% 开通等级
		all_items    = [2001,2002,2003,2004,2005,2006,2007,2008],%% 物品ID（顺时针)
		linking_items = [2007,2008,2001],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=5000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=0,crit=0,crit_res=0,crit_harm=0,defend_down=320,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(301)->
	#d_hidden_treasure{
		hidden_layer_id = 301,          %% 藏宝阁层数_ID
		open_lv      = 50,              %% 开通等级
		all_items    = [3001,3002,3003,3004,3005,3006,3007,3008],%% 物品ID（顺时针)
		linking_items = [3001,3002,3003],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=8000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=700,strong_def=0,skill_att=0,skill_def=0,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(302)->
	#d_hidden_treasure{
		hidden_layer_id = 302,          %% 藏宝阁层数_ID
		open_lv      = 50,              %% 开通等级
		all_items    = [3001,3002,3003,3004,3005,3006,3007,3008],%% 物品ID（顺时针)
		linking_items = [3003,3004,3005],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=8000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=700,skill_att=0,skill_def=0,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(303)->
	#d_hidden_treasure{
		hidden_layer_id = 303,          %% 藏宝阁层数_ID
		open_lv      = 50,              %% 开通等级
		all_items    = [3001,3002,3003,3004,3005,3006,3007,3008],%% 物品ID（顺时针)
		linking_items = [3005,3006,3007],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=8000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=0,crit=360,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(304)->
	#d_hidden_treasure{
		hidden_layer_id = 304,          %% 藏宝阁层数_ID
		open_lv      = 50,              %% 开通等级
		all_items    = [3001,3002,3003,3004,3005,3006,3007,3008],%% 物品ID（顺时针)
		linking_items = [3007,3008,3001],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=8000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=0,crit=0,crit_res=360,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(401)->
	#d_hidden_treasure{
		hidden_layer_id = 401,          %% 藏宝阁层数_ID
		open_lv      = 60,              %% 开通等级
		all_items    = [4001,4002,4003,4004,4005,4006,4007,4008],%% 物品ID（顺时针)
		linking_items = [4001,4002,4003],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=12000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=1320,skill_def=0,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(402)->
	#d_hidden_treasure{
		hidden_layer_id = 402,          %% 藏宝阁层数_ID
		open_lv      = 60,              %% 开通等级
		all_items    = [4001,4002,4003,4004,4005,4006,4007,4008],%% 物品ID（顺时针)
		linking_items = [4003,4004,4005],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=12000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=1320,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(403)->
	#d_hidden_treasure{
		hidden_layer_id = 403,          %% 藏宝阁层数_ID
		open_lv      = 60,              %% 开通等级
		all_items    = [4001,4002,4003,4004,4005,4006,4007,4008],%% 物品ID（顺时针)
		linking_items = [4005,4006,4007],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=12000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=0,crit=0,crit_res=0,crit_harm=400,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(404)->
	#d_hidden_treasure{
		hidden_layer_id = 404,          %% 藏宝阁层数_ID
		open_lv      = 60,              %% 开通等级
		all_items    = [4001,4002,4003,4004,4005,4006,4007,4008],%% 物品ID（顺时针)
		linking_items = [4007,4008,4001],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=0,sp_up=0,anima=0,hp=12000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=0,crit=0,crit_res=0,crit_harm=0,defend_down=640,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(501)->
	#d_hidden_treasure{
		hidden_layer_id = 501,          %% 藏宝阁层数_ID
		open_lv      = 70,              %% 开通等级
		all_items    = [5001,5002,5003,5004,5005,5006,5007,5008],%% 物品ID（顺时针)
		linking_items = [5001,5002,5003],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=1,sp_up=0,anima=0,hp=16000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=1060,strong_def=0,skill_att=0,skill_def=0,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(502)->
	#d_hidden_treasure{
		hidden_layer_id = 502,          %% 藏宝阁层数_ID
		open_lv      = 70,              %% 开通等级
		all_items    = [5001,5002,5003,5004,5005,5006,5007,5008],%% 物品ID（顺时针)
		linking_items = [5003,5004,5005],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=1,sp_up=0,anima=0,hp=16000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=1060,skill_att=0,skill_def=0,crit=0,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(503)->
	#d_hidden_treasure{
		hidden_layer_id = 503,          %% 藏宝阁层数_ID
		open_lv      = 70,              %% 开通等级
		all_items    = [5001,5002,5003,5004,5005,5006,5007,5008],%% 物品ID（顺时针)
		linking_items = [5005,5006,5007],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=1,sp_up=0,anima=0,hp=16000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=0,crit=540,crit_res=0,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(504)->
	#d_hidden_treasure{
		hidden_layer_id = 504,          %% 藏宝阁层数_ID
		open_lv      = 70,              %% 开通等级
		all_items    = [5001,5002,5003,5004,5005,5006,5007,5008],%% 物品ID（顺时针)
		linking_items = [5007,5008,5001],%% 物品连成线
		%% 属性#attr{} 
		attr = #attr{sp=1,sp_up=0,anima=0,hp=16000,hp_gro=0,strong=0,strong_gro=0,magic=0,magic_gro=0,strong_att=0,strong_def=0,skill_att=0,skill_def=0,crit=0,crit_res=540,crit_harm=0,defend_down=0,light=0,light_def=0,dark=0,dark_def=0,god=0,god_def=0,bonus=0,reduction=0,imm_dizz=0}
	};
get(_)-> ?null.


%% 集合;
get_ids()->[101,102,103,104,201,202,203,204,301,302,303,304,401,402,403,404,501,502,503,504].

