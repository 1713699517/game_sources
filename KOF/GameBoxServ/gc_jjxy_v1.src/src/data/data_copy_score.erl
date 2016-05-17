-module(data_copy_score).
-include("../include/comm.hrl").

-export([get/3,gets_unscatch/0,gets_time/0,gets_combo/0,gets_kill/0,gets_score/0]).

% get();
% 副本评分;
% type:1-无损 2-时间 3-连击 4-杀敌 5-评分档次
get(1001,1,1)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 20,              %% 结束值
		value        = 10000           %% 评分
	};

get(1001,1,2)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 21,              %% 开始值
		end_score    = 50,              %% 结束值
		value        = 9000            %% 评分
	};

get(1001,1,3)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 51,              %% 开始值
		end_score    = 80,              %% 结束值
		value        = 6000            %% 评分
	};

get(1001,1,4)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 81,              %% 开始值
		end_score    = 1000,            %% 结束值
		value        = 3000            %% 评分
	};

get(1001,2,1)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 45,              %% 结束值
		value        = 10000           %% 评分
	};

get(1001,2,2)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 46,              %% 开始值
		end_score    = 90,              %% 结束值
		value        = 9000            %% 评分
	};

get(1001,2,3)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 91,              %% 开始值
		end_score    = 200,             %% 结束值
		value        = 6000            %% 评分
	};

get(1001,2,4)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 201,             %% 开始值
		end_score    = 5000,            %% 结束值
		value        = 3000            %% 评分
	};

get(1001,3,1)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 101,             %% 开始值
		end_score    = 300,             %% 结束值
		value        = 10000           %% 评分
	};

get(1001,3,2)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 51,              %% 开始值
		end_score    = 100,             %% 结束值
		value        = 9000            %% 评分
	};

get(1001,3,3)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 21,              %% 开始值
		end_score    = 50,              %% 结束值
		value        = 6000            %% 评分
	};

get(1001,3,4)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 20,              %% 结束值
		value        = 3000            %% 评分
	};

get(1001,4,1)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 3001,            %% 开始值
		end_score    = 10000,           %% 结束值
		value        = 10000           %% 评分
	};

get(1001,4,2)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 2001,            %% 开始值
		end_score    = 3000,            %% 结束值
		value        = 9000            %% 评分
	};

get(1001,4,3)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 1001,            %% 开始值
		end_score    = 2000,            %% 结束值
		value        = 6000            %% 评分
	};

get(1001,4,4)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 1000,            %% 结束值
		value        = 3000            %% 评分
	};

get(1001,5,1)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 5,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 30000,           %% 开始值
		end_score    = 40000,           %% 结束值
		value        = 3               %% 评分
	};

get(1001,5,2)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 5,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 19001,           %% 开始值
		end_score    = 29999,           %% 结束值
		value        = 2               %% 评分
	};

get(1001,5,3)->
	#d_copy_score{
		id           = 1001,            %% 评分ID
		type         = 5,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 19000,           %% 结束值
		value        = 1               %% 评分
	};

get(1002,1,1)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 20,              %% 结束值
		value        = 10000           %% 评分
	};

get(1002,1,2)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 21,              %% 开始值
		end_score    = 40,              %% 结束值
		value        = 9000            %% 评分
	};

get(1002,1,3)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 41,              %% 开始值
		end_score    = 60,              %% 结束值
		value        = 8000            %% 评分
	};

get(1002,1,4)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 61,              %% 开始值
		end_score    = 80,              %% 结束值
		value        = 7000            %% 评分
	};

get(1002,1,5)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 5,               %% 分数等级
		start_score  = 81,              %% 开始值
		end_score    = 100,             %% 结束值
		value        = 6000            %% 评分
	};

get(1002,1,6)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 6,               %% 分数等级
		start_score  = 101,             %% 开始值
		end_score    = 120,             %% 结束值
		value        = 5000            %% 评分
	};

get(1002,1,7)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 7,               %% 分数等级
		start_score  = 121,             %% 开始值
		end_score    = 140,             %% 结束值
		value        = 4000            %% 评分
	};

get(1002,1,8)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 8,               %% 分数等级
		start_score  = 141,             %% 开始值
		end_score    = 160,             %% 结束值
		value        = 3000            %% 评分
	};

get(1002,1,9)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 9,               %% 分数等级
		start_score  = 161,             %% 开始值
		end_score    = 180,             %% 结束值
		value        = 2000            %% 评分
	};

get(1002,1,10)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 10,              %% 分数等级
		start_score  = 181,             %% 开始值
		end_score    = 200,             %% 结束值
		value        = 1000            %% 评分
	};

get(1002,2,1)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 30,              %% 结束值
		value        = 10000           %% 评分
	};

get(1002,2,2)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 31,              %% 开始值
		end_score    = 60,              %% 结束值
		value        = 9000            %% 评分
	};

get(1002,2,3)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 61,              %% 开始值
		end_score    = 90,              %% 结束值
		value        = 8000            %% 评分
	};

get(1002,2,4)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 91,              %% 开始值
		end_score    = 120,             %% 结束值
		value        = 7000            %% 评分
	};

get(1002,2,5)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 5,               %% 分数等级
		start_score  = 121,             %% 开始值
		end_score    = 150,             %% 结束值
		value        = 6000            %% 评分
	};

get(1002,2,6)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 6,               %% 分数等级
		start_score  = 151,             %% 开始值
		end_score    = 180,             %% 结束值
		value        = 5000            %% 评分
	};

get(1002,2,7)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 7,               %% 分数等级
		start_score  = 181,             %% 开始值
		end_score    = 210,             %% 结束值
		value        = 4000            %% 评分
	};

get(1002,2,8)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 8,               %% 分数等级
		start_score  = 211,             %% 开始值
		end_score    = 240,             %% 结束值
		value        = 3000            %% 评分
	};

get(1002,2,9)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 9,               %% 分数等级
		start_score  = 241,             %% 开始值
		end_score    = 270,             %% 结束值
		value        = 2000            %% 评分
	};

get(1002,2,10)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 10,              %% 分数等级
		start_score  = 271,             %% 开始值
		end_score    = 300,             %% 结束值
		value        = 1000            %% 评分
	};

get(1002,3,1)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 136,             %% 开始值
		end_score    = 150,             %% 结束值
		value        = 10000           %% 评分
	};

get(1002,3,2)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 121,             %% 开始值
		end_score    = 135,             %% 结束值
		value        = 9000            %% 评分
	};

get(1002,3,3)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 106,             %% 开始值
		end_score    = 120,             %% 结束值
		value        = 8000            %% 评分
	};

get(1002,3,4)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 91,              %% 开始值
		end_score    = 105,             %% 结束值
		value        = 7000            %% 评分
	};

get(1002,3,5)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 5,               %% 分数等级
		start_score  = 76,              %% 开始值
		end_score    = 90,              %% 结束值
		value        = 6000            %% 评分
	};

get(1002,3,6)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 6,               %% 分数等级
		start_score  = 61,              %% 开始值
		end_score    = 75,              %% 结束值
		value        = 5000            %% 评分
	};

get(1002,3,7)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 7,               %% 分数等级
		start_score  = 46,              %% 开始值
		end_score    = 60,              %% 结束值
		value        = 4000            %% 评分
	};

get(1002,3,8)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 8,               %% 分数等级
		start_score  = 31,              %% 开始值
		end_score    = 45,              %% 结束值
		value        = 3000            %% 评分
	};

get(1002,3,9)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 9,               %% 分数等级
		start_score  = 16,              %% 开始值
		end_score    = 30,              %% 结束值
		value        = 2000            %% 评分
	};

get(1002,3,10)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 10,              %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 15,              %% 结束值
		value        = 1000            %% 评分
	};

get(1002,4,1)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 2701,            %% 开始值
		end_score    = 3000,            %% 结束值
		value        = 10000           %% 评分
	};

get(1002,4,2)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 2401,            %% 开始值
		end_score    = 2700,            %% 结束值
		value        = 9000            %% 评分
	};

get(1002,4,3)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 2101,            %% 开始值
		end_score    = 2400,            %% 结束值
		value        = 8000            %% 评分
	};

get(1002,4,4)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 1801,            %% 开始值
		end_score    = 2100,            %% 结束值
		value        = 7000            %% 评分
	};

get(1002,4,5)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 5,               %% 分数等级
		start_score  = 1501,            %% 开始值
		end_score    = 1800,            %% 结束值
		value        = 6000            %% 评分
	};

get(1002,4,6)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 6,               %% 分数等级
		start_score  = 1201,            %% 开始值
		end_score    = 1500,            %% 结束值
		value        = 5000            %% 评分
	};

get(1002,4,7)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 7,               %% 分数等级
		start_score  = 901,             %% 开始值
		end_score    = 1200,            %% 结束值
		value        = 4000            %% 评分
	};

get(1002,4,8)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 8,               %% 分数等级
		start_score  = 601,             %% 开始值
		end_score    = 900,             %% 结束值
		value        = 3000            %% 评分
	};

get(1002,4,9)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 9,               %% 分数等级
		start_score  = 301,             %% 开始值
		end_score    = 600,             %% 结束值
		value        = 2000            %% 评分
	};

get(1002,4,10)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 10,              %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 300,             %% 结束值
		value        = 1000            %% 评分
	};

get(1002,5,1)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 5,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 33000,           %% 开始值
		end_score    = 40000,           %% 结束值
		value        = 3               %% 评分
	};

get(1002,5,2)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 5,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 24000,           %% 开始值
		end_score    = 32999,           %% 结束值
		value        = 2               %% 评分
	};

get(1002,5,3)->
	#d_copy_score{
		id           = 1002,            %% 评分ID
		type         = 5,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 23999,           %% 结束值
		value        = 1               %% 评分
	};

get(1003,1,1)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 20,              %% 结束值
		value        = 10000           %% 评分
	};

get(1003,1,2)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 21,              %% 开始值
		end_score    = 40,              %% 结束值
		value        = 9000            %% 评分
	};

get(1003,1,3)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 41,              %% 开始值
		end_score    = 60,              %% 结束值
		value        = 8000            %% 评分
	};

get(1003,1,4)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 61,              %% 开始值
		end_score    = 80,              %% 结束值
		value        = 7000            %% 评分
	};

get(1003,1,5)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 5,               %% 分数等级
		start_score  = 81,              %% 开始值
		end_score    = 100,             %% 结束值
		value        = 6000            %% 评分
	};

get(1003,1,6)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 6,               %% 分数等级
		start_score  = 101,             %% 开始值
		end_score    = 120,             %% 结束值
		value        = 5000            %% 评分
	};

get(1003,1,7)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 7,               %% 分数等级
		start_score  = 121,             %% 开始值
		end_score    = 140,             %% 结束值
		value        = 4000            %% 评分
	};

get(1003,1,8)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 8,               %% 分数等级
		start_score  = 141,             %% 开始值
		end_score    = 160,             %% 结束值
		value        = 3000            %% 评分
	};

get(1003,1,9)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 9,               %% 分数等级
		start_score  = 161,             %% 开始值
		end_score    = 180,             %% 结束值
		value        = 2000            %% 评分
	};

get(1003,1,10)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 1,               %% 评分类型
		level        = 10,              %% 分数等级
		start_score  = 181,             %% 开始值
		end_score    = 200,             %% 结束值
		value        = 1000            %% 评分
	};

get(1003,2,1)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 30,              %% 结束值
		value        = 10000           %% 评分
	};

get(1003,2,2)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 31,              %% 开始值
		end_score    = 60,              %% 结束值
		value        = 9000            %% 评分
	};

get(1003,2,3)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 61,              %% 开始值
		end_score    = 90,              %% 结束值
		value        = 8000            %% 评分
	};

get(1003,2,4)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 91,              %% 开始值
		end_score    = 120,             %% 结束值
		value        = 7000            %% 评分
	};

get(1003,2,5)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 5,               %% 分数等级
		start_score  = 121,             %% 开始值
		end_score    = 150,             %% 结束值
		value        = 6000            %% 评分
	};

get(1003,2,6)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 6,               %% 分数等级
		start_score  = 151,             %% 开始值
		end_score    = 180,             %% 结束值
		value        = 5000            %% 评分
	};

get(1003,2,7)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 7,               %% 分数等级
		start_score  = 181,             %% 开始值
		end_score    = 210,             %% 结束值
		value        = 4000            %% 评分
	};

get(1003,2,8)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 8,               %% 分数等级
		start_score  = 211,             %% 开始值
		end_score    = 240,             %% 结束值
		value        = 3000            %% 评分
	};

get(1003,2,9)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 9,               %% 分数等级
		start_score  = 241,             %% 开始值
		end_score    = 270,             %% 结束值
		value        = 2000            %% 评分
	};

get(1003,2,10)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 2,               %% 评分类型
		level        = 10,              %% 分数等级
		start_score  = 271,             %% 开始值
		end_score    = 300,             %% 结束值
		value        = 1000            %% 评分
	};

get(1003,3,1)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 136,             %% 开始值
		end_score    = 150,             %% 结束值
		value        = 10000           %% 评分
	};

get(1003,3,2)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 121,             %% 开始值
		end_score    = 135,             %% 结束值
		value        = 9000            %% 评分
	};

get(1003,3,3)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 106,             %% 开始值
		end_score    = 120,             %% 结束值
		value        = 8000            %% 评分
	};

get(1003,3,4)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 91,              %% 开始值
		end_score    = 105,             %% 结束值
		value        = 7000            %% 评分
	};

get(1003,3,5)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 5,               %% 分数等级
		start_score  = 76,              %% 开始值
		end_score    = 90,              %% 结束值
		value        = 6000            %% 评分
	};

get(1003,3,6)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 6,               %% 分数等级
		start_score  = 61,              %% 开始值
		end_score    = 75,              %% 结束值
		value        = 5000            %% 评分
	};

get(1003,3,7)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 7,               %% 分数等级
		start_score  = 46,              %% 开始值
		end_score    = 60,              %% 结束值
		value        = 4000            %% 评分
	};

get(1003,3,8)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 8,               %% 分数等级
		start_score  = 31,              %% 开始值
		end_score    = 45,              %% 结束值
		value        = 3000            %% 评分
	};

get(1003,3,9)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 9,               %% 分数等级
		start_score  = 16,              %% 开始值
		end_score    = 30,              %% 结束值
		value        = 2000            %% 评分
	};

get(1003,3,10)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 3,               %% 评分类型
		level        = 10,              %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 15,              %% 结束值
		value        = 1000            %% 评分
	};

get(1003,4,1)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 2701,            %% 开始值
		end_score    = 3000,            %% 结束值
		value        = 10000           %% 评分
	};

get(1003,4,2)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 2401,            %% 开始值
		end_score    = 2700,            %% 结束值
		value        = 9000            %% 评分
	};

get(1003,4,3)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 2101,            %% 开始值
		end_score    = 2400,            %% 结束值
		value        = 8000            %% 评分
	};

get(1003,4,4)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 4,               %% 分数等级
		start_score  = 1801,            %% 开始值
		end_score    = 2100,            %% 结束值
		value        = 7000            %% 评分
	};

get(1003,4,5)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 5,               %% 分数等级
		start_score  = 1501,            %% 开始值
		end_score    = 1800,            %% 结束值
		value        = 6000            %% 评分
	};

get(1003,4,6)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 6,               %% 分数等级
		start_score  = 1201,            %% 开始值
		end_score    = 1500,            %% 结束值
		value        = 5000            %% 评分
	};

get(1003,4,7)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 7,               %% 分数等级
		start_score  = 901,             %% 开始值
		end_score    = 1200,            %% 结束值
		value        = 4000            %% 评分
	};

get(1003,4,8)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 8,               %% 分数等级
		start_score  = 601,             %% 开始值
		end_score    = 900,             %% 结束值
		value        = 3000            %% 评分
	};

get(1003,4,9)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 9,               %% 分数等级
		start_score  = 301,             %% 开始值
		end_score    = 600,             %% 结束值
		value        = 2000            %% 评分
	};

get(1003,4,10)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 4,               %% 评分类型
		level        = 10,              %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 300,             %% 结束值
		value        = 1000            %% 评分
	};

get(1003,5,1)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 5,               %% 评分类型
		level        = 1,               %% 分数等级
		start_score  = 35000,           %% 开始值
		end_score    = 40000,           %% 结束值
		value        = 3               %% 评分
	};

get(1003,5,2)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 5,               %% 评分类型
		level        = 2,               %% 分数等级
		start_score  = 28000,           %% 开始值
		end_score    = 34999,           %% 结束值
		value        = 2               %% 评分
	};

get(1003,5,3)->
	#d_copy_score{
		id           = 1003,            %% 评分ID
		type         = 5,               %% 评分类型
		level        = 3,               %% 分数等级
		start_score  = 1,               %% 开始值
		end_score    = 27999,           %% 结束值
		value        = 1               %% 评分
	};

get(_,_,_)->
	?null.

% gets_unscatch()->[Level,..]

gets_unscatch()->[1,2,3,4,5,6,7,8,9,10].

% gets_time()->[Level,..]

gets_time()->[1,2,3,4,5,6,7,8,9,10].

% gets_combo()->[Level,..]

gets_combo()->[1,2,3,4,5,6,7,8,9,10].

% gets_kill()->[Level,..]

gets_kill()->[1,2,3,4,5,6,7,8,9,10].

% gets_score()->[Level,..]

gets_score()->[1,2,3].
