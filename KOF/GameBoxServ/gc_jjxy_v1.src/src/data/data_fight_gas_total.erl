-module(data_fight_gas_total).
-include("../include/comm.hrl").

-export([get/1]).

% get();
% 斗气总况;
% 
get({1001,1})->
	#d_fight_gas_total{
		gas_id       = 1001,            %% 斗气ID
		type         = 0,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 1,               %% 颜色
		self_exp     = 5,               %% 本身经验
		next_lv_exp  = 99999,           %% 下一级总经验
		attr_type_one = 0,              %% 属性类型1
		attr_one     = 0,               %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1001,2})->
	#d_fight_gas_total{
		gas_id       = 1001,            %% 斗气ID
		type         = 0,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 1,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 999999,          %% 下一级总经验
		attr_type_one = 0,              %% 属性类型1
		attr_one     = 0,               %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1001,3})->
	#d_fight_gas_total{
		gas_id       = 1001,            %% 斗气ID
		type         = 0,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 1,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 9999999,         %% 下一级总经验
		attr_type_one = 0,              %% 属性类型1
		attr_one     = 0,               %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1006,1})->
	#d_fight_gas_total{
		gas_id       = 1006,            %% 斗气ID
		type         = 0,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 1,               %% 颜色
		self_exp     = 5,               %% 本身经验
		next_lv_exp  = 99999,           %% 下一级总经验
		attr_type_one = 0,              %% 属性类型1
		attr_one     = 0,               %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1006,2})->
	#d_fight_gas_total{
		gas_id       = 1006,            %% 斗气ID
		type         = 0,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 1,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 999999,          %% 下一级总经验
		attr_type_one = 0,              %% 属性类型1
		attr_one     = 0,               %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1006,3})->
	#d_fight_gas_total{
		gas_id       = 1006,            %% 斗气ID
		type         = 0,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 1,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 9999999,         %% 下一级总经验
		attr_type_one = 0,              %% 属性类型1
		attr_one     = 0,               %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1011,1})->
	#d_fight_gas_total{
		gas_id       = 1011,            %% 斗气ID
		type         = 0,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 1,               %% 颜色
		self_exp     = 5,               %% 本身经验
		next_lv_exp  = 30001,           %% 下一级总经验
		attr_type_one = 0,              %% 属性类型1
		attr_one     = 0,               %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1011,2})->
	#d_fight_gas_total{
		gas_id       = 1011,            %% 斗气ID
		type         = 0,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 1,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 60001,           %% 下一级总经验
		attr_type_one = 0,              %% 属性类型1
		attr_one     = 0,               %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1011,3})->
	#d_fight_gas_total{
		gas_id       = 1011,            %% 斗气ID
		type         = 0,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 1,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 100001,          %% 下一级总经验
		attr_type_one = 0,              %% 属性类型1
		attr_one     = 0,               %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1016,1})->
	#d_fight_gas_total{
		gas_id       = 1016,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 120,             %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1016,2})->
	#d_fight_gas_total{
		gas_id       = 1016,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1016,3})->
	#d_fight_gas_total{
		gas_id       = 1016,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1016,4})->
	#d_fight_gas_total{
		gas_id       = 1016,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 320,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1016,5})->
	#d_fight_gas_total{
		gas_id       = 1016,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1016,6})->
	#d_fight_gas_total{
		gas_id       = 1016,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1016,7})->
	#d_fight_gas_total{
		gas_id       = 1016,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 560,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1016,8})->
	#d_fight_gas_total{
		gas_id       = 1016,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 640,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1016,9})->
	#d_fight_gas_total{
		gas_id       = 1016,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 720,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1016,10})->
	#d_fight_gas_total{
		gas_id       = 1016,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1021,1})->
	#d_fight_gas_total{
		gas_id       = 1021,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 120,             %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1021,2})->
	#d_fight_gas_total{
		gas_id       = 1021,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1021,3})->
	#d_fight_gas_total{
		gas_id       = 1021,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1021,4})->
	#d_fight_gas_total{
		gas_id       = 1021,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 320,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1021,5})->
	#d_fight_gas_total{
		gas_id       = 1021,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1021,6})->
	#d_fight_gas_total{
		gas_id       = 1021,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1021,7})->
	#d_fight_gas_total{
		gas_id       = 1021,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 560,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1021,8})->
	#d_fight_gas_total{
		gas_id       = 1021,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 640,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1021,9})->
	#d_fight_gas_total{
		gas_id       = 1021,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 720,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1021,10})->
	#d_fight_gas_total{
		gas_id       = 1021,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1026,1})->
	#d_fight_gas_total{
		gas_id       = 1026,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 120,             %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1026,2})->
	#d_fight_gas_total{
		gas_id       = 1026,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1026,3})->
	#d_fight_gas_total{
		gas_id       = 1026,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1026,4})->
	#d_fight_gas_total{
		gas_id       = 1026,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1026,5})->
	#d_fight_gas_total{
		gas_id       = 1026,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1026,6})->
	#d_fight_gas_total{
		gas_id       = 1026,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1026,7})->
	#d_fight_gas_total{
		gas_id       = 1026,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 420,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1026,8})->
	#d_fight_gas_total{
		gas_id       = 1026,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1026,9})->
	#d_fight_gas_total{
		gas_id       = 1026,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 540,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1026,10})->
	#d_fight_gas_total{
		gas_id       = 1026,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1031,1})->
	#d_fight_gas_total{
		gas_id       = 1031,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 120,             %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1031,2})->
	#d_fight_gas_total{
		gas_id       = 1031,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1031,3})->
	#d_fight_gas_total{
		gas_id       = 1031,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1031,4})->
	#d_fight_gas_total{
		gas_id       = 1031,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1031,5})->
	#d_fight_gas_total{
		gas_id       = 1031,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1031,6})->
	#d_fight_gas_total{
		gas_id       = 1031,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1031,7})->
	#d_fight_gas_total{
		gas_id       = 1031,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 420,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1031,8})->
	#d_fight_gas_total{
		gas_id       = 1031,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1031,9})->
	#d_fight_gas_total{
		gas_id       = 1031,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 540,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1031,10})->
	#d_fight_gas_total{
		gas_id       = 1031,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1036,1})->
	#d_fight_gas_total{
		gas_id       = 1036,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 120,             %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1036,2})->
	#d_fight_gas_total{
		gas_id       = 1036,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1036,3})->
	#d_fight_gas_total{
		gas_id       = 1036,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 3600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1036,4})->
	#d_fight_gas_total{
		gas_id       = 1036,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 4800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1036,5})->
	#d_fight_gas_total{
		gas_id       = 1036,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 6000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1036,6})->
	#d_fight_gas_total{
		gas_id       = 1036,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 7200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1036,7})->
	#d_fight_gas_total{
		gas_id       = 1036,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 8400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1036,8})->
	#d_fight_gas_total{
		gas_id       = 1036,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 9600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1036,9})->
	#d_fight_gas_total{
		gas_id       = 1036,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 10800,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1036,10})->
	#d_fight_gas_total{
		gas_id       = 1036,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 12000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1041,1})->
	#d_fight_gas_total{
		gas_id       = 1041,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 120,             %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 20,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1041,2})->
	#d_fight_gas_total{
		gas_id       = 1041,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 40,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1041,3})->
	#d_fight_gas_total{
		gas_id       = 1041,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1041,4})->
	#d_fight_gas_total{
		gas_id       = 1041,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1041,5})->
	#d_fight_gas_total{
		gas_id       = 1041,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1041,6})->
	#d_fight_gas_total{
		gas_id       = 1041,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1041,7})->
	#d_fight_gas_total{
		gas_id       = 1041,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 140,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1041,8})->
	#d_fight_gas_total{
		gas_id       = 1041,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1041,9})->
	#d_fight_gas_total{
		gas_id       = 1041,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1041,10})->
	#d_fight_gas_total{
		gas_id       = 1041,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1046,1})->
	#d_fight_gas_total{
		gas_id       = 1046,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 120,             %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 20,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1046,2})->
	#d_fight_gas_total{
		gas_id       = 1046,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 40,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1046,3})->
	#d_fight_gas_total{
		gas_id       = 1046,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1046,4})->
	#d_fight_gas_total{
		gas_id       = 1046,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1046,5})->
	#d_fight_gas_total{
		gas_id       = 1046,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1046,6})->
	#d_fight_gas_total{
		gas_id       = 1046,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1046,7})->
	#d_fight_gas_total{
		gas_id       = 1046,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 140,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1046,8})->
	#d_fight_gas_total{
		gas_id       = 1046,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1046,9})->
	#d_fight_gas_total{
		gas_id       = 1046,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1046,10})->
	#d_fight_gas_total{
		gas_id       = 1046,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1051,1})->
	#d_fight_gas_total{
		gas_id       = 1051,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 120,             %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 20,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1051,2})->
	#d_fight_gas_total{
		gas_id       = 1051,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 40,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1051,3})->
	#d_fight_gas_total{
		gas_id       = 1051,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1051,4})->
	#d_fight_gas_total{
		gas_id       = 1051,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1051,5})->
	#d_fight_gas_total{
		gas_id       = 1051,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1051,6})->
	#d_fight_gas_total{
		gas_id       = 1051,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1051,7})->
	#d_fight_gas_total{
		gas_id       = 1051,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 140,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1051,8})->
	#d_fight_gas_total{
		gas_id       = 1051,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1051,9})->
	#d_fight_gas_total{
		gas_id       = 1051,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1051,10})->
	#d_fight_gas_total{
		gas_id       = 1051,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1056,1})->
	#d_fight_gas_total{
		gas_id       = 1056,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 120,             %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 20,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1056,2})->
	#d_fight_gas_total{
		gas_id       = 1056,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 40,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1056,3})->
	#d_fight_gas_total{
		gas_id       = 1056,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1056,4})->
	#d_fight_gas_total{
		gas_id       = 1056,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1056,5})->
	#d_fight_gas_total{
		gas_id       = 1056,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1056,6})->
	#d_fight_gas_total{
		gas_id       = 1056,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1056,7})->
	#d_fight_gas_total{
		gas_id       = 1056,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 140,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1056,8})->
	#d_fight_gas_total{
		gas_id       = 1056,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1056,9})->
	#d_fight_gas_total{
		gas_id       = 1056,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1056,10})->
	#d_fight_gas_total{
		gas_id       = 1056,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1061,1})->
	#d_fight_gas_total{
		gas_id       = 1061,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 1,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 120,             %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 10,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1061,2})->
	#d_fight_gas_total{
		gas_id       = 1061,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 2,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 15,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1061,3})->
	#d_fight_gas_total{
		gas_id       = 1061,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 3,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 20,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1061,4})->
	#d_fight_gas_total{
		gas_id       = 1061,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 4,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 25,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1061,5})->
	#d_fight_gas_total{
		gas_id       = 1061,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 5,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 30,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1061,6})->
	#d_fight_gas_total{
		gas_id       = 1061,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 6,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 35,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1061,7})->
	#d_fight_gas_total{
		gas_id       = 1061,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 7,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 40,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1061,8})->
	#d_fight_gas_total{
		gas_id       = 1061,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 8,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 45,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1061,9})->
	#d_fight_gas_total{
		gas_id       = 1061,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 9,               %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 50,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1061,10})->
	#d_fight_gas_total{
		gas_id       = 1061,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 10,              %% 等级
		color        = 2,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 55,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1066,1})->
	#d_fight_gas_total{
		gas_id       = 1066,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1066,2})->
	#d_fight_gas_total{
		gas_id       = 1066,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 320,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1066,3})->
	#d_fight_gas_total{
		gas_id       = 1066,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1066,4})->
	#d_fight_gas_total{
		gas_id       = 1066,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 640,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1066,5})->
	#d_fight_gas_total{
		gas_id       = 1066,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1066,6})->
	#d_fight_gas_total{
		gas_id       = 1066,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 960,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1066,7})->
	#d_fight_gas_total{
		gas_id       = 1066,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1120,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1066,8})->
	#d_fight_gas_total{
		gas_id       = 1066,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1280,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1066,9})->
	#d_fight_gas_total{
		gas_id       = 1066,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1440,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1066,10})->
	#d_fight_gas_total{
		gas_id       = 1066,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1071,1})->
	#d_fight_gas_total{
		gas_id       = 1071,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1071,2})->
	#d_fight_gas_total{
		gas_id       = 1071,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 320,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1071,3})->
	#d_fight_gas_total{
		gas_id       = 1071,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1071,4})->
	#d_fight_gas_total{
		gas_id       = 1071,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 640,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1071,5})->
	#d_fight_gas_total{
		gas_id       = 1071,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1071,6})->
	#d_fight_gas_total{
		gas_id       = 1071,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 960,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1071,7})->
	#d_fight_gas_total{
		gas_id       = 1071,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1120,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1071,8})->
	#d_fight_gas_total{
		gas_id       = 1071,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1280,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1071,9})->
	#d_fight_gas_total{
		gas_id       = 1071,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1440,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1071,10})->
	#d_fight_gas_total{
		gas_id       = 1071,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1076,1})->
	#d_fight_gas_total{
		gas_id       = 1076,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1076,2})->
	#d_fight_gas_total{
		gas_id       = 1076,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1076,3})->
	#d_fight_gas_total{
		gas_id       = 1076,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1076,4})->
	#d_fight_gas_total{
		gas_id       = 1076,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1076,5})->
	#d_fight_gas_total{
		gas_id       = 1076,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1076,6})->
	#d_fight_gas_total{
		gas_id       = 1076,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 720,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1076,7})->
	#d_fight_gas_total{
		gas_id       = 1076,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 840,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1076,8})->
	#d_fight_gas_total{
		gas_id       = 1076,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 960,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1076,9})->
	#d_fight_gas_total{
		gas_id       = 1076,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1080,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1076,10})->
	#d_fight_gas_total{
		gas_id       = 1076,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1081,1})->
	#d_fight_gas_total{
		gas_id       = 1081,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1081,2})->
	#d_fight_gas_total{
		gas_id       = 1081,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1081,3})->
	#d_fight_gas_total{
		gas_id       = 1081,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1081,4})->
	#d_fight_gas_total{
		gas_id       = 1081,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1081,5})->
	#d_fight_gas_total{
		gas_id       = 1081,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1081,6})->
	#d_fight_gas_total{
		gas_id       = 1081,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 720,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1081,7})->
	#d_fight_gas_total{
		gas_id       = 1081,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 840,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1081,8})->
	#d_fight_gas_total{
		gas_id       = 1081,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 960,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1081,9})->
	#d_fight_gas_total{
		gas_id       = 1081,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1080,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1081,10})->
	#d_fight_gas_total{
		gas_id       = 1081,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1086,1})->
	#d_fight_gas_total{
		gas_id       = 1086,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1086,2})->
	#d_fight_gas_total{
		gas_id       = 1086,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 4800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1086,3})->
	#d_fight_gas_total{
		gas_id       = 1086,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 7200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1086,4})->
	#d_fight_gas_total{
		gas_id       = 1086,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 9600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1086,5})->
	#d_fight_gas_total{
		gas_id       = 1086,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 12000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1086,6})->
	#d_fight_gas_total{
		gas_id       = 1086,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 14400,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1086,7})->
	#d_fight_gas_total{
		gas_id       = 1086,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 16800,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1086,8})->
	#d_fight_gas_total{
		gas_id       = 1086,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 19200,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1086,9})->
	#d_fight_gas_total{
		gas_id       = 1086,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 21600,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1086,10})->
	#d_fight_gas_total{
		gas_id       = 1086,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 24000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1091,1})->
	#d_fight_gas_total{
		gas_id       = 1091,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 40,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1091,2})->
	#d_fight_gas_total{
		gas_id       = 1091,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1091,3})->
	#d_fight_gas_total{
		gas_id       = 1091,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1091,4})->
	#d_fight_gas_total{
		gas_id       = 1091,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1091,5})->
	#d_fight_gas_total{
		gas_id       = 1091,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1091,6})->
	#d_fight_gas_total{
		gas_id       = 1091,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1091,7})->
	#d_fight_gas_total{
		gas_id       = 1091,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 280,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1091,8})->
	#d_fight_gas_total{
		gas_id       = 1091,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 320,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1091,9})->
	#d_fight_gas_total{
		gas_id       = 1091,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1091,10})->
	#d_fight_gas_total{
		gas_id       = 1091,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1096,1})->
	#d_fight_gas_total{
		gas_id       = 1096,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 40,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1096,2})->
	#d_fight_gas_total{
		gas_id       = 1096,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1096,3})->
	#d_fight_gas_total{
		gas_id       = 1096,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1096,4})->
	#d_fight_gas_total{
		gas_id       = 1096,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1096,5})->
	#d_fight_gas_total{
		gas_id       = 1096,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1096,6})->
	#d_fight_gas_total{
		gas_id       = 1096,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1096,7})->
	#d_fight_gas_total{
		gas_id       = 1096,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 280,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1096,8})->
	#d_fight_gas_total{
		gas_id       = 1096,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 320,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1096,9})->
	#d_fight_gas_total{
		gas_id       = 1096,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1096,10})->
	#d_fight_gas_total{
		gas_id       = 1096,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1101,1})->
	#d_fight_gas_total{
		gas_id       = 1101,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 40,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1101,2})->
	#d_fight_gas_total{
		gas_id       = 1101,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1101,3})->
	#d_fight_gas_total{
		gas_id       = 1101,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1101,4})->
	#d_fight_gas_total{
		gas_id       = 1101,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1101,5})->
	#d_fight_gas_total{
		gas_id       = 1101,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1101,6})->
	#d_fight_gas_total{
		gas_id       = 1101,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1101,7})->
	#d_fight_gas_total{
		gas_id       = 1101,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 280,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1101,8})->
	#d_fight_gas_total{
		gas_id       = 1101,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 320,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1101,9})->
	#d_fight_gas_total{
		gas_id       = 1101,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1101,10})->
	#d_fight_gas_total{
		gas_id       = 1101,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1106,1})->
	#d_fight_gas_total{
		gas_id       = 1106,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 40,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1106,2})->
	#d_fight_gas_total{
		gas_id       = 1106,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1106,3})->
	#d_fight_gas_total{
		gas_id       = 1106,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1106,4})->
	#d_fight_gas_total{
		gas_id       = 1106,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1106,5})->
	#d_fight_gas_total{
		gas_id       = 1106,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1106,6})->
	#d_fight_gas_total{
		gas_id       = 1106,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1106,7})->
	#d_fight_gas_total{
		gas_id       = 1106,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 280,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1106,8})->
	#d_fight_gas_total{
		gas_id       = 1106,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 320,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1106,9})->
	#d_fight_gas_total{
		gas_id       = 1106,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1106,10})->
	#d_fight_gas_total{
		gas_id       = 1106,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1111,1})->
	#d_fight_gas_total{
		gas_id       = 1111,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 1,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 240,             %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 20,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1111,2})->
	#d_fight_gas_total{
		gas_id       = 1111,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 2,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 30,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1111,3})->
	#d_fight_gas_total{
		gas_id       = 1111,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 3,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 40,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1111,4})->
	#d_fight_gas_total{
		gas_id       = 1111,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 4,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 50,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1111,5})->
	#d_fight_gas_total{
		gas_id       = 1111,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 5,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1111,6})->
	#d_fight_gas_total{
		gas_id       = 1111,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 6,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 70,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1111,7})->
	#d_fight_gas_total{
		gas_id       = 1111,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 7,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1111,8})->
	#d_fight_gas_total{
		gas_id       = 1111,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 8,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 90,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1111,9})->
	#d_fight_gas_total{
		gas_id       = 1111,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 9,               %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1111,10})->
	#d_fight_gas_total{
		gas_id       = 1111,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 10,              %% 等级
		color        = 3,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 110,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1116,1})->
	#d_fight_gas_total{
		gas_id       = 1116,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1116,2})->
	#d_fight_gas_total{
		gas_id       = 1116,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1116,3})->
	#d_fight_gas_total{
		gas_id       = 1116,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 720,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1116,4})->
	#d_fight_gas_total{
		gas_id       = 1116,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 960,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1116,5})->
	#d_fight_gas_total{
		gas_id       = 1116,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1116,6})->
	#d_fight_gas_total{
		gas_id       = 1116,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1440,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1116,7})->
	#d_fight_gas_total{
		gas_id       = 1116,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1680,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1116,8})->
	#d_fight_gas_total{
		gas_id       = 1116,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1920,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1116,9})->
	#d_fight_gas_total{
		gas_id       = 1116,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 2160,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1116,10})->
	#d_fight_gas_total{
		gas_id       = 1116,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1121,1})->
	#d_fight_gas_total{
		gas_id       = 1121,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1121,2})->
	#d_fight_gas_total{
		gas_id       = 1121,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1121,3})->
	#d_fight_gas_total{
		gas_id       = 1121,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 720,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1121,4})->
	#d_fight_gas_total{
		gas_id       = 1121,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 960,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1121,5})->
	#d_fight_gas_total{
		gas_id       = 1121,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1121,6})->
	#d_fight_gas_total{
		gas_id       = 1121,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1440,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1121,7})->
	#d_fight_gas_total{
		gas_id       = 1121,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1680,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1121,8})->
	#d_fight_gas_total{
		gas_id       = 1121,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1920,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1121,9})->
	#d_fight_gas_total{
		gas_id       = 1121,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 2160,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1121,10})->
	#d_fight_gas_total{
		gas_id       = 1121,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1126,1})->
	#d_fight_gas_total{
		gas_id       = 1126,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1126,2})->
	#d_fight_gas_total{
		gas_id       = 1126,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1126,3})->
	#d_fight_gas_total{
		gas_id       = 1126,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 540,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1126,4})->
	#d_fight_gas_total{
		gas_id       = 1126,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 720,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1126,5})->
	#d_fight_gas_total{
		gas_id       = 1126,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1126,6})->
	#d_fight_gas_total{
		gas_id       = 1126,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1080,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1126,7})->
	#d_fight_gas_total{
		gas_id       = 1126,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1260,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1126,8})->
	#d_fight_gas_total{
		gas_id       = 1126,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1440,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1126,9})->
	#d_fight_gas_total{
		gas_id       = 1126,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1620,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1126,10})->
	#d_fight_gas_total{
		gas_id       = 1126,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1131,1})->
	#d_fight_gas_total{
		gas_id       = 1131,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1131,2})->
	#d_fight_gas_total{
		gas_id       = 1131,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1131,3})->
	#d_fight_gas_total{
		gas_id       = 1131,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 540,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1131,4})->
	#d_fight_gas_total{
		gas_id       = 1131,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 720,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1131,5})->
	#d_fight_gas_total{
		gas_id       = 1131,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1131,6})->
	#d_fight_gas_total{
		gas_id       = 1131,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1080,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1131,7})->
	#d_fight_gas_total{
		gas_id       = 1131,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1260,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1131,8})->
	#d_fight_gas_total{
		gas_id       = 1131,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1440,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1131,9})->
	#d_fight_gas_total{
		gas_id       = 1131,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1620,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1131,10})->
	#d_fight_gas_total{
		gas_id       = 1131,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1136,1})->
	#d_fight_gas_total{
		gas_id       = 1136,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 3600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1136,2})->
	#d_fight_gas_total{
		gas_id       = 1136,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 7200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1136,3})->
	#d_fight_gas_total{
		gas_id       = 1136,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 10800,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1136,4})->
	#d_fight_gas_total{
		gas_id       = 1136,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 14400,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1136,5})->
	#d_fight_gas_total{
		gas_id       = 1136,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 18000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1136,6})->
	#d_fight_gas_total{
		gas_id       = 1136,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 21600,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1136,7})->
	#d_fight_gas_total{
		gas_id       = 1136,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 25200,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1136,8})->
	#d_fight_gas_total{
		gas_id       = 1136,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 28800,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1136,9})->
	#d_fight_gas_total{
		gas_id       = 1136,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 32400,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1136,10})->
	#d_fight_gas_total{
		gas_id       = 1136,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 36000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1141,1})->
	#d_fight_gas_total{
		gas_id       = 1141,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1141,2})->
	#d_fight_gas_total{
		gas_id       = 1141,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1141,3})->
	#d_fight_gas_total{
		gas_id       = 1141,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1141,4})->
	#d_fight_gas_total{
		gas_id       = 1141,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1141,5})->
	#d_fight_gas_total{
		gas_id       = 1141,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1141,6})->
	#d_fight_gas_total{
		gas_id       = 1141,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1141,7})->
	#d_fight_gas_total{
		gas_id       = 1141,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 420,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1141,8})->
	#d_fight_gas_total{
		gas_id       = 1141,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1141,9})->
	#d_fight_gas_total{
		gas_id       = 1141,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 540,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1141,10})->
	#d_fight_gas_total{
		gas_id       = 1141,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1146,1})->
	#d_fight_gas_total{
		gas_id       = 1146,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1146,2})->
	#d_fight_gas_total{
		gas_id       = 1146,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1146,3})->
	#d_fight_gas_total{
		gas_id       = 1146,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1146,4})->
	#d_fight_gas_total{
		gas_id       = 1146,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1146,5})->
	#d_fight_gas_total{
		gas_id       = 1146,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1146,6})->
	#d_fight_gas_total{
		gas_id       = 1146,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1146,7})->
	#d_fight_gas_total{
		gas_id       = 1146,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 420,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1146,8})->
	#d_fight_gas_total{
		gas_id       = 1146,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1146,9})->
	#d_fight_gas_total{
		gas_id       = 1146,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 540,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1146,10})->
	#d_fight_gas_total{
		gas_id       = 1146,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1151,1})->
	#d_fight_gas_total{
		gas_id       = 1151,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1151,2})->
	#d_fight_gas_total{
		gas_id       = 1151,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1151,3})->
	#d_fight_gas_total{
		gas_id       = 1151,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1151,4})->
	#d_fight_gas_total{
		gas_id       = 1151,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1151,5})->
	#d_fight_gas_total{
		gas_id       = 1151,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1151,6})->
	#d_fight_gas_total{
		gas_id       = 1151,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1151,7})->
	#d_fight_gas_total{
		gas_id       = 1151,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 420,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1151,8})->
	#d_fight_gas_total{
		gas_id       = 1151,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1151,9})->
	#d_fight_gas_total{
		gas_id       = 1151,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 540,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1151,10})->
	#d_fight_gas_total{
		gas_id       = 1151,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1156,1})->
	#d_fight_gas_total{
		gas_id       = 1156,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1156,2})->
	#d_fight_gas_total{
		gas_id       = 1156,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1156,3})->
	#d_fight_gas_total{
		gas_id       = 1156,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1156,4})->
	#d_fight_gas_total{
		gas_id       = 1156,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1156,5})->
	#d_fight_gas_total{
		gas_id       = 1156,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1156,6})->
	#d_fight_gas_total{
		gas_id       = 1156,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1156,7})->
	#d_fight_gas_total{
		gas_id       = 1156,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 420,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1156,8})->
	#d_fight_gas_total{
		gas_id       = 1156,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1156,9})->
	#d_fight_gas_total{
		gas_id       = 1156,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 540,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1156,10})->
	#d_fight_gas_total{
		gas_id       = 1156,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1161,1})->
	#d_fight_gas_total{
		gas_id       = 1161,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 1,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 480,             %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 60,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1161,2})->
	#d_fight_gas_total{
		gas_id       = 1161,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 2,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 70,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1161,3})->
	#d_fight_gas_total{
		gas_id       = 1161,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 3,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 80,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1161,4})->
	#d_fight_gas_total{
		gas_id       = 1161,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 4,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 90,              %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1161,5})->
	#d_fight_gas_total{
		gas_id       = 1161,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 5,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1161,6})->
	#d_fight_gas_total{
		gas_id       = 1161,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 6,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 110,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1161,7})->
	#d_fight_gas_total{
		gas_id       = 1161,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 7,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1161,8})->
	#d_fight_gas_total{
		gas_id       = 1161,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 8,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 130,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1161,9})->
	#d_fight_gas_total{
		gas_id       = 1161,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 9,               %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 140,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1161,10})->
	#d_fight_gas_total{
		gas_id       = 1161,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 10,              %% 等级
		color        = 4,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 150,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1166,1})->
	#d_fight_gas_total{
		gas_id       = 1166,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1166,2})->
	#d_fight_gas_total{
		gas_id       = 1166,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1166,3})->
	#d_fight_gas_total{
		gas_id       = 1166,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1166,4})->
	#d_fight_gas_total{
		gas_id       = 1166,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1166,5})->
	#d_fight_gas_total{
		gas_id       = 1166,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 2000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1166,6})->
	#d_fight_gas_total{
		gas_id       = 1166,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1166,7})->
	#d_fight_gas_total{
		gas_id       = 1166,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 2800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1166,8})->
	#d_fight_gas_total{
		gas_id       = 1166,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 3200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1166,9})->
	#d_fight_gas_total{
		gas_id       = 1166,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 3600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1166,10})->
	#d_fight_gas_total{
		gas_id       = 1166,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 4000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1171,1})->
	#d_fight_gas_total{
		gas_id       = 1171,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1171,2})->
	#d_fight_gas_total{
		gas_id       = 1171,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1171,3})->
	#d_fight_gas_total{
		gas_id       = 1171,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1171,4})->
	#d_fight_gas_total{
		gas_id       = 1171,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1171,5})->
	#d_fight_gas_total{
		gas_id       = 1171,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 2000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1171,6})->
	#d_fight_gas_total{
		gas_id       = 1171,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1171,7})->
	#d_fight_gas_total{
		gas_id       = 1171,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 2800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1171,8})->
	#d_fight_gas_total{
		gas_id       = 1171,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 3200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1171,9})->
	#d_fight_gas_total{
		gas_id       = 1171,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 3600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1171,10})->
	#d_fight_gas_total{
		gas_id       = 1171,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 4000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1176,1})->
	#d_fight_gas_total{
		gas_id       = 1176,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1176,2})->
	#d_fight_gas_total{
		gas_id       = 1176,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1176,3})->
	#d_fight_gas_total{
		gas_id       = 1176,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1176,4})->
	#d_fight_gas_total{
		gas_id       = 1176,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1176,5})->
	#d_fight_gas_total{
		gas_id       = 1176,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1500,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1176,6})->
	#d_fight_gas_total{
		gas_id       = 1176,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1176,7})->
	#d_fight_gas_total{
		gas_id       = 1176,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 2100,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1176,8})->
	#d_fight_gas_total{
		gas_id       = 1176,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1176,9})->
	#d_fight_gas_total{
		gas_id       = 1176,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 2700,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1176,10})->
	#d_fight_gas_total{
		gas_id       = 1176,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 3000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1181,1})->
	#d_fight_gas_total{
		gas_id       = 1181,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1181,2})->
	#d_fight_gas_total{
		gas_id       = 1181,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1181,3})->
	#d_fight_gas_total{
		gas_id       = 1181,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1181,4})->
	#d_fight_gas_total{
		gas_id       = 1181,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1181,5})->
	#d_fight_gas_total{
		gas_id       = 1181,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1500,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1181,6})->
	#d_fight_gas_total{
		gas_id       = 1181,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1181,7})->
	#d_fight_gas_total{
		gas_id       = 1181,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 2100,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1181,8})->
	#d_fight_gas_total{
		gas_id       = 1181,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1181,9})->
	#d_fight_gas_total{
		gas_id       = 1181,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 2700,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1181,10})->
	#d_fight_gas_total{
		gas_id       = 1181,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 3000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1186,1})->
	#d_fight_gas_total{
		gas_id       = 1186,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 6000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1186,2})->
	#d_fight_gas_total{
		gas_id       = 1186,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 12000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1186,3})->
	#d_fight_gas_total{
		gas_id       = 1186,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 18000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1186,4})->
	#d_fight_gas_total{
		gas_id       = 1186,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 24000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1186,5})->
	#d_fight_gas_total{
		gas_id       = 1186,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 30000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1186,6})->
	#d_fight_gas_total{
		gas_id       = 1186,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 36000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1186,7})->
	#d_fight_gas_total{
		gas_id       = 1186,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 42000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1186,8})->
	#d_fight_gas_total{
		gas_id       = 1186,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 48000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1186,9})->
	#d_fight_gas_total{
		gas_id       = 1186,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 54000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1186,10})->
	#d_fight_gas_total{
		gas_id       = 1186,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 60000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1191,1})->
	#d_fight_gas_total{
		gas_id       = 1191,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1191,2})->
	#d_fight_gas_total{
		gas_id       = 1191,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1191,3})->
	#d_fight_gas_total{
		gas_id       = 1191,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1191,4})->
	#d_fight_gas_total{
		gas_id       = 1191,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1191,5})->
	#d_fight_gas_total{
		gas_id       = 1191,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 500,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1191,6})->
	#d_fight_gas_total{
		gas_id       = 1191,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1191,7})->
	#d_fight_gas_total{
		gas_id       = 1191,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 700,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1191,8})->
	#d_fight_gas_total{
		gas_id       = 1191,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1191,9})->
	#d_fight_gas_total{
		gas_id       = 1191,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1191,10})->
	#d_fight_gas_total{
		gas_id       = 1191,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 1000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1196,1})->
	#d_fight_gas_total{
		gas_id       = 1196,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1196,2})->
	#d_fight_gas_total{
		gas_id       = 1196,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1196,3})->
	#d_fight_gas_total{
		gas_id       = 1196,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1196,4})->
	#d_fight_gas_total{
		gas_id       = 1196,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1196,5})->
	#d_fight_gas_total{
		gas_id       = 1196,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 500,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1196,6})->
	#d_fight_gas_total{
		gas_id       = 1196,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1196,7})->
	#d_fight_gas_total{
		gas_id       = 1196,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 700,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1196,8})->
	#d_fight_gas_total{
		gas_id       = 1196,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1196,9})->
	#d_fight_gas_total{
		gas_id       = 1196,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1196,10})->
	#d_fight_gas_total{
		gas_id       = 1196,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 1000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1201,1})->
	#d_fight_gas_total{
		gas_id       = 1201,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1201,2})->
	#d_fight_gas_total{
		gas_id       = 1201,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1201,3})->
	#d_fight_gas_total{
		gas_id       = 1201,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1201,4})->
	#d_fight_gas_total{
		gas_id       = 1201,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1201,5})->
	#d_fight_gas_total{
		gas_id       = 1201,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 500,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1201,6})->
	#d_fight_gas_total{
		gas_id       = 1201,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1201,7})->
	#d_fight_gas_total{
		gas_id       = 1201,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 700,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1201,8})->
	#d_fight_gas_total{
		gas_id       = 1201,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1201,9})->
	#d_fight_gas_total{
		gas_id       = 1201,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1201,10})->
	#d_fight_gas_total{
		gas_id       = 1201,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 1000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1206,1})->
	#d_fight_gas_total{
		gas_id       = 1206,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1206,2})->
	#d_fight_gas_total{
		gas_id       = 1206,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1206,3})->
	#d_fight_gas_total{
		gas_id       = 1206,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1206,4})->
	#d_fight_gas_total{
		gas_id       = 1206,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1206,5})->
	#d_fight_gas_total{
		gas_id       = 1206,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 500,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1206,6})->
	#d_fight_gas_total{
		gas_id       = 1206,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1206,7})->
	#d_fight_gas_total{
		gas_id       = 1206,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 700,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1206,8})->
	#d_fight_gas_total{
		gas_id       = 1206,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1206,9})->
	#d_fight_gas_total{
		gas_id       = 1206,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1206,10})->
	#d_fight_gas_total{
		gas_id       = 1206,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 1000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1211,1})->
	#d_fight_gas_total{
		gas_id       = 1211,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 1,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 960,             %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 100,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1211,2})->
	#d_fight_gas_total{
		gas_id       = 1211,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 2,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 120,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1211,3})->
	#d_fight_gas_total{
		gas_id       = 1211,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 3,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 140,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1211,4})->
	#d_fight_gas_total{
		gas_id       = 1211,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 4,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 160,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1211,5})->
	#d_fight_gas_total{
		gas_id       = 1211,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 5,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1211,6})->
	#d_fight_gas_total{
		gas_id       = 1211,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 6,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1211,7})->
	#d_fight_gas_total{
		gas_id       = 1211,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 7,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 220,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1211,8})->
	#d_fight_gas_total{
		gas_id       = 1211,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 8,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1211,9})->
	#d_fight_gas_total{
		gas_id       = 1211,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 9,               %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 260,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1211,10})->
	#d_fight_gas_total{
		gas_id       = 1211,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 10,              %% 等级
		color        = 5,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 280,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1216,1})->
	#d_fight_gas_total{
		gas_id       = 1216,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1216,2})->
	#d_fight_gas_total{
		gas_id       = 1216,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1216,3})->
	#d_fight_gas_total{
		gas_id       = 1216,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1216,4})->
	#d_fight_gas_total{
		gas_id       = 1216,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 3200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1216,5})->
	#d_fight_gas_total{
		gas_id       = 1216,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 4000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1216,6})->
	#d_fight_gas_total{
		gas_id       = 1216,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 4800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1216,7})->
	#d_fight_gas_total{
		gas_id       = 1216,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 5600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1216,8})->
	#d_fight_gas_total{
		gas_id       = 1216,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 6400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1216,9})->
	#d_fight_gas_total{
		gas_id       = 1216,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 7200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1216,10})->
	#d_fight_gas_total{
		gas_id       = 1216,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 8000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1221,1})->
	#d_fight_gas_total{
		gas_id       = 1221,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1221,2})->
	#d_fight_gas_total{
		gas_id       = 1221,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1221,3})->
	#d_fight_gas_total{
		gas_id       = 1221,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1221,4})->
	#d_fight_gas_total{
		gas_id       = 1221,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 3200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1221,5})->
	#d_fight_gas_total{
		gas_id       = 1221,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 4000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1221,6})->
	#d_fight_gas_total{
		gas_id       = 1221,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 4800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1221,7})->
	#d_fight_gas_total{
		gas_id       = 1221,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 5600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1221,8})->
	#d_fight_gas_total{
		gas_id       = 1221,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 6400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1221,9})->
	#d_fight_gas_total{
		gas_id       = 1221,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 7200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1221,10})->
	#d_fight_gas_total{
		gas_id       = 1221,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 8000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1226,1})->
	#d_fight_gas_total{
		gas_id       = 1226,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1226,2})->
	#d_fight_gas_total{
		gas_id       = 1226,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1226,3})->
	#d_fight_gas_total{
		gas_id       = 1226,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1226,4})->
	#d_fight_gas_total{
		gas_id       = 1226,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1226,5})->
	#d_fight_gas_total{
		gas_id       = 1226,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 3000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1226,6})->
	#d_fight_gas_total{
		gas_id       = 1226,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 3600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1226,7})->
	#d_fight_gas_total{
		gas_id       = 1226,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 4200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1226,8})->
	#d_fight_gas_total{
		gas_id       = 1226,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 4800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1226,9})->
	#d_fight_gas_total{
		gas_id       = 1226,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 5400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1226,10})->
	#d_fight_gas_total{
		gas_id       = 1226,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 6000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1231,1})->
	#d_fight_gas_total{
		gas_id       = 1231,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1231,2})->
	#d_fight_gas_total{
		gas_id       = 1231,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1231,3})->
	#d_fight_gas_total{
		gas_id       = 1231,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1231,4})->
	#d_fight_gas_total{
		gas_id       = 1231,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1231,5})->
	#d_fight_gas_total{
		gas_id       = 1231,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 3000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1231,6})->
	#d_fight_gas_total{
		gas_id       = 1231,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 3600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1231,7})->
	#d_fight_gas_total{
		gas_id       = 1231,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 4200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1231,8})->
	#d_fight_gas_total{
		gas_id       = 1231,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 4800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1231,9})->
	#d_fight_gas_total{
		gas_id       = 1231,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 5400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1231,10})->
	#d_fight_gas_total{
		gas_id       = 1231,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 6000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1236,1})->
	#d_fight_gas_total{
		gas_id       = 1236,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 12000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1236,2})->
	#d_fight_gas_total{
		gas_id       = 1236,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 24000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1236,3})->
	#d_fight_gas_total{
		gas_id       = 1236,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 36000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1236,4})->
	#d_fight_gas_total{
		gas_id       = 1236,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 48000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1236,5})->
	#d_fight_gas_total{
		gas_id       = 1236,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 60000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1236,6})->
	#d_fight_gas_total{
		gas_id       = 1236,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 72000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1236,7})->
	#d_fight_gas_total{
		gas_id       = 1236,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 84000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1236,8})->
	#d_fight_gas_total{
		gas_id       = 1236,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 96000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1236,9})->
	#d_fight_gas_total{
		gas_id       = 1236,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 108000,          %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1236,10})->
	#d_fight_gas_total{
		gas_id       = 1236,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 120000,          %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1241,1})->
	#d_fight_gas_total{
		gas_id       = 1241,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1241,2})->
	#d_fight_gas_total{
		gas_id       = 1241,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1241,3})->
	#d_fight_gas_total{
		gas_id       = 1241,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1241,4})->
	#d_fight_gas_total{
		gas_id       = 1241,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1241,5})->
	#d_fight_gas_total{
		gas_id       = 1241,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 1000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1241,6})->
	#d_fight_gas_total{
		gas_id       = 1241,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1241,7})->
	#d_fight_gas_total{
		gas_id       = 1241,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 1400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1241,8})->
	#d_fight_gas_total{
		gas_id       = 1241,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 1600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1241,9})->
	#d_fight_gas_total{
		gas_id       = 1241,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1241,10})->
	#d_fight_gas_total{
		gas_id       = 1241,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 2000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1246,1})->
	#d_fight_gas_total{
		gas_id       = 1246,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1246,2})->
	#d_fight_gas_total{
		gas_id       = 1246,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1246,3})->
	#d_fight_gas_total{
		gas_id       = 1246,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1246,4})->
	#d_fight_gas_total{
		gas_id       = 1246,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1246,5})->
	#d_fight_gas_total{
		gas_id       = 1246,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 1000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1246,6})->
	#d_fight_gas_total{
		gas_id       = 1246,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1246,7})->
	#d_fight_gas_total{
		gas_id       = 1246,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 1400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1246,8})->
	#d_fight_gas_total{
		gas_id       = 1246,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 1600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1246,9})->
	#d_fight_gas_total{
		gas_id       = 1246,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1246,10})->
	#d_fight_gas_total{
		gas_id       = 1246,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 2000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1251,1})->
	#d_fight_gas_total{
		gas_id       = 1251,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1251,2})->
	#d_fight_gas_total{
		gas_id       = 1251,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1251,3})->
	#d_fight_gas_total{
		gas_id       = 1251,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1251,4})->
	#d_fight_gas_total{
		gas_id       = 1251,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1251,5})->
	#d_fight_gas_total{
		gas_id       = 1251,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 1000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1251,6})->
	#d_fight_gas_total{
		gas_id       = 1251,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1251,7})->
	#d_fight_gas_total{
		gas_id       = 1251,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 1400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1251,8})->
	#d_fight_gas_total{
		gas_id       = 1251,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 1600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1251,9})->
	#d_fight_gas_total{
		gas_id       = 1251,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1251,10})->
	#d_fight_gas_total{
		gas_id       = 1251,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 2000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1256,1})->
	#d_fight_gas_total{
		gas_id       = 1256,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1256,2})->
	#d_fight_gas_total{
		gas_id       = 1256,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1256,3})->
	#d_fight_gas_total{
		gas_id       = 1256,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1256,4})->
	#d_fight_gas_total{
		gas_id       = 1256,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 800,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1256,5})->
	#d_fight_gas_total{
		gas_id       = 1256,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 1000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1256,6})->
	#d_fight_gas_total{
		gas_id       = 1256,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1256,7})->
	#d_fight_gas_total{
		gas_id       = 1256,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 1400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1256,8})->
	#d_fight_gas_total{
		gas_id       = 1256,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 1600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1256,9})->
	#d_fight_gas_total{
		gas_id       = 1256,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1256,10})->
	#d_fight_gas_total{
		gas_id       = 1256,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 2000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1261,1})->
	#d_fight_gas_total{
		gas_id       = 1261,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 1,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 1920,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 150,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1261,2})->
	#d_fight_gas_total{
		gas_id       = 1261,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 2,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 180,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1261,3})->
	#d_fight_gas_total{
		gas_id       = 1261,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 3,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 210,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1261,4})->
	#d_fight_gas_total{
		gas_id       = 1261,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 4,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1261,5})->
	#d_fight_gas_total{
		gas_id       = 1261,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 5,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 270,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1261,6})->
	#d_fight_gas_total{
		gas_id       = 1261,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 6,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1261,7})->
	#d_fight_gas_total{
		gas_id       = 1261,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 7,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 330,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1261,8})->
	#d_fight_gas_total{
		gas_id       = 1261,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 8,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1261,9})->
	#d_fight_gas_total{
		gas_id       = 1261,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 9,               %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 390,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1261,10})->
	#d_fight_gas_total{
		gas_id       = 1261,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 10,              %% 等级
		color        = 6,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 420,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1266,1})->
	#d_fight_gas_total{
		gas_id       = 1266,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1266,2})->
	#d_fight_gas_total{
		gas_id       = 1266,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1266,3})->
	#d_fight_gas_total{
		gas_id       = 1266,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 3600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1266,4})->
	#d_fight_gas_total{
		gas_id       = 1266,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 4800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1266,5})->
	#d_fight_gas_total{
		gas_id       = 1266,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 6000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1266,6})->
	#d_fight_gas_total{
		gas_id       = 1266,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 7200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1266,7})->
	#d_fight_gas_total{
		gas_id       = 1266,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 8400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1266,8})->
	#d_fight_gas_total{
		gas_id       = 1266,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 9600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1266,9})->
	#d_fight_gas_total{
		gas_id       = 1266,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 10800,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1266,10})->
	#d_fight_gas_total{
		gas_id       = 1266,            %% 斗气ID
		type         = 1,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 50,             %% 属性类型1
		attr_one     = 12000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1271,1})->
	#d_fight_gas_total{
		gas_id       = 1271,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1271,2})->
	#d_fight_gas_total{
		gas_id       = 1271,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1271,3})->
	#d_fight_gas_total{
		gas_id       = 1271,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 3600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1271,4})->
	#d_fight_gas_total{
		gas_id       = 1271,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 4800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1271,5})->
	#d_fight_gas_total{
		gas_id       = 1271,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 6000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1271,6})->
	#d_fight_gas_total{
		gas_id       = 1271,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 7200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1271,7})->
	#d_fight_gas_total{
		gas_id       = 1271,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 8400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1271,8})->
	#d_fight_gas_total{
		gas_id       = 1271,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 9600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1271,9})->
	#d_fight_gas_total{
		gas_id       = 1271,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 10800,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1271,10})->
	#d_fight_gas_total{
		gas_id       = 1271,            %% 斗气ID
		type         = 2,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 51,             %% 属性类型1
		attr_one     = 12000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1276,1})->
	#d_fight_gas_total{
		gas_id       = 1276,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1276,2})->
	#d_fight_gas_total{
		gas_id       = 1276,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1276,3})->
	#d_fight_gas_total{
		gas_id       = 1276,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 2700,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1276,4})->
	#d_fight_gas_total{
		gas_id       = 1276,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 3600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1276,5})->
	#d_fight_gas_total{
		gas_id       = 1276,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 4500,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1276,6})->
	#d_fight_gas_total{
		gas_id       = 1276,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 5400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1276,7})->
	#d_fight_gas_total{
		gas_id       = 1276,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 6300,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1276,8})->
	#d_fight_gas_total{
		gas_id       = 1276,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 7200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1276,9})->
	#d_fight_gas_total{
		gas_id       = 1276,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 8100,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1276,10})->
	#d_fight_gas_total{
		gas_id       = 1276,            %% 斗气ID
		type         = 3,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 52,             %% 属性类型1
		attr_one     = 9000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1281,1})->
	#d_fight_gas_total{
		gas_id       = 1281,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1281,2})->
	#d_fight_gas_total{
		gas_id       = 1281,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1281,3})->
	#d_fight_gas_total{
		gas_id       = 1281,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 2700,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1281,4})->
	#d_fight_gas_total{
		gas_id       = 1281,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 3600,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1281,5})->
	#d_fight_gas_total{
		gas_id       = 1281,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 4500,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1281,6})->
	#d_fight_gas_total{
		gas_id       = 1281,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 5400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1281,7})->
	#d_fight_gas_total{
		gas_id       = 1281,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 6300,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1281,8})->
	#d_fight_gas_total{
		gas_id       = 1281,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 7200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1281,9})->
	#d_fight_gas_total{
		gas_id       = 1281,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 8100,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1281,10})->
	#d_fight_gas_total{
		gas_id       = 1281,            %% 斗气ID
		type         = 4,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 53,             %% 属性类型1
		attr_one     = 9000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1286,1})->
	#d_fight_gas_total{
		gas_id       = 1286,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 18000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1286,2})->
	#d_fight_gas_total{
		gas_id       = 1286,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 36000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1286,3})->
	#d_fight_gas_total{
		gas_id       = 1286,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 54000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1286,4})->
	#d_fight_gas_total{
		gas_id       = 1286,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 72000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1286,5})->
	#d_fight_gas_total{
		gas_id       = 1286,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 90000,           %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1286,6})->
	#d_fight_gas_total{
		gas_id       = 1286,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 108000,          %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1286,7})->
	#d_fight_gas_total{
		gas_id       = 1286,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 126000,          %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1286,8})->
	#d_fight_gas_total{
		gas_id       = 1286,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 144000,          %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1286,9})->
	#d_fight_gas_total{
		gas_id       = 1286,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 162000,          %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1286,10})->
	#d_fight_gas_total{
		gas_id       = 1286,            %% 斗气ID
		type         = 5,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 44,             %% 属性类型1
		attr_one     = 180000,          %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1291,1})->
	#d_fight_gas_total{
		gas_id       = 1291,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1291,2})->
	#d_fight_gas_total{
		gas_id       = 1291,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1291,3})->
	#d_fight_gas_total{
		gas_id       = 1291,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1291,4})->
	#d_fight_gas_total{
		gas_id       = 1291,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1291,5})->
	#d_fight_gas_total{
		gas_id       = 1291,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 1500,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1291,6})->
	#d_fight_gas_total{
		gas_id       = 1291,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1291,7})->
	#d_fight_gas_total{
		gas_id       = 1291,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 2100,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1291,8})->
	#d_fight_gas_total{
		gas_id       = 1291,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1291,9})->
	#d_fight_gas_total{
		gas_id       = 1291,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 2700,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1291,10})->
	#d_fight_gas_total{
		gas_id       = 1291,            %% 斗气ID
		type         = 6,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 56,             %% 属性类型1
		attr_one     = 3000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1296,1})->
	#d_fight_gas_total{
		gas_id       = 1296,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1296,2})->
	#d_fight_gas_total{
		gas_id       = 1296,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1296,3})->
	#d_fight_gas_total{
		gas_id       = 1296,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1296,4})->
	#d_fight_gas_total{
		gas_id       = 1296,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1296,5})->
	#d_fight_gas_total{
		gas_id       = 1296,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 1500,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1296,6})->
	#d_fight_gas_total{
		gas_id       = 1296,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1296,7})->
	#d_fight_gas_total{
		gas_id       = 1296,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 2100,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1296,8})->
	#d_fight_gas_total{
		gas_id       = 1296,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1296,9})->
	#d_fight_gas_total{
		gas_id       = 1296,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 2700,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1296,10})->
	#d_fight_gas_total{
		gas_id       = 1296,            %% 斗气ID
		type         = 7,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 57,             %% 属性类型1
		attr_one     = 3000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1301,1})->
	#d_fight_gas_total{
		gas_id       = 1301,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1301,2})->
	#d_fight_gas_total{
		gas_id       = 1301,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1301,3})->
	#d_fight_gas_total{
		gas_id       = 1301,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1301,4})->
	#d_fight_gas_total{
		gas_id       = 1301,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1301,5})->
	#d_fight_gas_total{
		gas_id       = 1301,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 1500,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1301,6})->
	#d_fight_gas_total{
		gas_id       = 1301,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1301,7})->
	#d_fight_gas_total{
		gas_id       = 1301,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 2100,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1301,8})->
	#d_fight_gas_total{
		gas_id       = 1301,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1301,9})->
	#d_fight_gas_total{
		gas_id       = 1301,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 2700,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1301,10})->
	#d_fight_gas_total{
		gas_id       = 1301,            %% 斗气ID
		type         = 8,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 58,             %% 属性类型1
		attr_one     = 3000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1306,1})->
	#d_fight_gas_total{
		gas_id       = 1306,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 1,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 300,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1306,2})->
	#d_fight_gas_total{
		gas_id       = 1306,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 2,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 600,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1306,3})->
	#d_fight_gas_total{
		gas_id       = 1306,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 3,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 900,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1306,4})->
	#d_fight_gas_total{
		gas_id       = 1306,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 4,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 1200,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1306,5})->
	#d_fight_gas_total{
		gas_id       = 1306,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 5,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 1500,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1306,6})->
	#d_fight_gas_total{
		gas_id       = 1306,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 6,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 1800,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1306,7})->
	#d_fight_gas_total{
		gas_id       = 1306,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 7,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 2100,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1306,8})->
	#d_fight_gas_total{
		gas_id       = 1306,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 8,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 2400,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1306,9})->
	#d_fight_gas_total{
		gas_id       = 1306,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 9,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 2700,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1306,10})->
	#d_fight_gas_total{
		gas_id       = 1306,            %% 斗气ID
		type         = 9,               %% 斗气类型
		lv           = 10,              %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 59,             %% 属性类型1
		attr_one     = 3000,            %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1311,1})->
	#d_fight_gas_total{
		gas_id       = 1311,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 1,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 30,              %% 本身经验
		next_lv_exp  = 3840,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 200,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1311,2})->
	#d_fight_gas_total{
		gas_id       = 1311,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 2,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 7680,            %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 240,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1311,3})->
	#d_fight_gas_total{
		gas_id       = 1311,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 3,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 15360,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 280,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1311,4})->
	#d_fight_gas_total{
		gas_id       = 1311,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 4,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 30720,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 320,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1311,5})->
	#d_fight_gas_total{
		gas_id       = 1311,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 5,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 61440,           %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 360,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1311,6})->
	#d_fight_gas_total{
		gas_id       = 1311,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 6,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 122880,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 400,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1311,7})->
	#d_fight_gas_total{
		gas_id       = 1311,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 7,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 245760,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 440,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1311,8})->
	#d_fight_gas_total{
		gas_id       = 1311,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 8,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 491520,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 480,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1311,9})->
	#d_fight_gas_total{
		gas_id       = 1311,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 9,               %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 520,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get({1311,10})->
	#d_fight_gas_total{
		gas_id       = 1311,            %% 斗气ID
		type         = 10,              %% 斗气类型
		lv           = 10,              %% 等级
		color        = 7,               %% 颜色
		self_exp     = 0,               %% 本身经验
		next_lv_exp  = 983040,          %% 下一级总经验
		attr_type_one = 67,             %% 属性类型1
		attr_one     = 560,             %% 属性值1
		attr_type_two = 0,              %% 属性类型2
		attr_two     = 0,               %% 属性值2
		attr_type_three = 0,            %% 属性类型3
		attr_three   = 0               %% 属性值3
	};
get(_)->?null.
