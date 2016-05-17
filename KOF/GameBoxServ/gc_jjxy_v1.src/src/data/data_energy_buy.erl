-module(data_energy_buy).
-include("../include/comm.hrl").

-export([get/1,get_ids/0]).

% get();
% 购买精力消耗元宝;
% 
get(1)->
	#d_energy_buy{
		times        = 1,               %% 购买次数
		use_rmb      = 20,              %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(2)->
	#d_energy_buy{
		times        = 2,               %% 购买次数
		use_rmb      = 20,              %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(3)->
	#d_energy_buy{
		times        = 3,               %% 购买次数
		use_rmb      = 40,              %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(4)->
	#d_energy_buy{
		times        = 4,               %% 购买次数
		use_rmb      = 40,              %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(5)->
	#d_energy_buy{
		times        = 5,               %% 购买次数
		use_rmb      = 60,              %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(6)->
	#d_energy_buy{
		times        = 6,               %% 购买次数
		use_rmb      = 60,              %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(7)->
	#d_energy_buy{
		times        = 7,               %% 购买次数
		use_rmb      = 80,              %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(8)->
	#d_energy_buy{
		times        = 8,               %% 购买次数
		use_rmb      = 80,              %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(9)->
	#d_energy_buy{
		times        = 9,               %% 购买次数
		use_rmb      = 100,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(10)->
	#d_energy_buy{
		times        = 10,              %% 购买次数
		use_rmb      = 100,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(11)->
	#d_energy_buy{
		times        = 11,              %% 购买次数
		use_rmb      = 120,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(12)->
	#d_energy_buy{
		times        = 12,              %% 购买次数
		use_rmb      = 120,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(13)->
	#d_energy_buy{
		times        = 13,              %% 购买次数
		use_rmb      = 140,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(14)->
	#d_energy_buy{
		times        = 14,              %% 购买次数
		use_rmb      = 140,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(15)->
	#d_energy_buy{
		times        = 15,              %% 购买次数
		use_rmb      = 160,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(16)->
	#d_energy_buy{
		times        = 16,              %% 购买次数
		use_rmb      = 160,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(17)->
	#d_energy_buy{
		times        = 17,              %% 购买次数
		use_rmb      = 180,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(18)->
	#d_energy_buy{
		times        = 18,              %% 购买次数
		use_rmb      = 180,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(19)->
	#d_energy_buy{
		times        = 19,              %% 购买次数
		use_rmb      = 200,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(20)->
	#d_energy_buy{
		times        = 20,              %% 购买次数
		use_rmb      = 200,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(21)->
	#d_energy_buy{
		times        = 21,              %% 购买次数
		use_rmb      = 220,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(22)->
	#d_energy_buy{
		times        = 22,              %% 购买次数
		use_rmb      = 220,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(23)->
	#d_energy_buy{
		times        = 23,              %% 购买次数
		use_rmb      = 240,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(24)->
	#d_energy_buy{
		times        = 24,              %% 购买次数
		use_rmb      = 240,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(25)->
	#d_energy_buy{
		times        = 25,              %% 购买次数
		use_rmb      = 260,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(26)->
	#d_energy_buy{
		times        = 26,              %% 购买次数
		use_rmb      = 260,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(27)->
	#d_energy_buy{
		times        = 27,              %% 购买次数
		use_rmb      = 280,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(28)->
	#d_energy_buy{
		times        = 28,              %% 购买次数
		use_rmb      = 280,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(29)->
	#d_energy_buy{
		times        = 29,              %% 购买次数
		use_rmb      = 300,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(30)->
	#d_energy_buy{
		times        = 30,              %% 购买次数
		use_rmb      = 300,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(31)->
	#d_energy_buy{
		times        = 31,              %% 购买次数
		use_rmb      = 320,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(32)->
	#d_energy_buy{
		times        = 32,              %% 购买次数
		use_rmb      = 320,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(33)->
	#d_energy_buy{
		times        = 33,              %% 购买次数
		use_rmb      = 340,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(34)->
	#d_energy_buy{
		times        = 34,              %% 购买次数
		use_rmb      = 340,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(35)->
	#d_energy_buy{
		times        = 35,              %% 购买次数
		use_rmb      = 360,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(36)->
	#d_energy_buy{
		times        = 36,              %% 购买次数
		use_rmb      = 360,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(37)->
	#d_energy_buy{
		times        = 37,              %% 购买次数
		use_rmb      = 380,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(38)->
	#d_energy_buy{
		times        = 38,              %% 购买次数
		use_rmb      = 380,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(39)->
	#d_energy_buy{
		times        = 39,              %% 购买次数
		use_rmb      = 400,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(40)->
	#d_energy_buy{
		times        = 40,              %% 购买次数
		use_rmb      = 400,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(41)->
	#d_energy_buy{
		times        = 41,              %% 购买次数
		use_rmb      = 420,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(42)->
	#d_energy_buy{
		times        = 42,              %% 购买次数
		use_rmb      = 420,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(43)->
	#d_energy_buy{
		times        = 43,              %% 购买次数
		use_rmb      = 440,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(44)->
	#d_energy_buy{
		times        = 44,              %% 购买次数
		use_rmb      = 440,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(45)->
	#d_energy_buy{
		times        = 45,              %% 购买次数
		use_rmb      = 460,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(46)->
	#d_energy_buy{
		times        = 46,              %% 购买次数
		use_rmb      = 460,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(47)->
	#d_energy_buy{
		times        = 47,              %% 购买次数
		use_rmb      = 480,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(48)->
	#d_energy_buy{
		times        = 48,              %% 购买次数
		use_rmb      = 480,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(49)->
	#d_energy_buy{
		times        = 49,              %% 购买次数
		use_rmb      = 500,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(50)->
	#d_energy_buy{
		times        = 50,              %% 购买次数
		use_rmb      = 500,             %% 消耗元宝
		add_energy   = 50              %% 增加体力
	};
get(_)-> ?null.


%% 集合;
get_ids()->[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50].

