-module(data_privilege).
-include("../include/comm.hrl").

-export([get/1]).

% get();
% 新手特权(投资理财);
% 
get(1)->
	#d_privilege{
		day          = 1,               %% 天数
		gold         = 1280000,         %% 美刀数量
		rmb          = 128             %% 钻石数量
	};

get(2)->
	#d_privilege{
		day          = 2,               %% 天数
		gold         = 1280000,         %% 美刀数量
		rmb          = 128             %% 钻石数量
	};

get(3)->
	#d_privilege{
		day          = 3,               %% 天数
		gold         = 1880000,         %% 美刀数量
		rmb          = 188             %% 钻石数量
	};

get(4)->
	#d_privilege{
		day          = 4,               %% 天数
		gold         = 2880000,         %% 美刀数量
		rmb          = 288             %% 钻石数量
	};

get(5)->
	#d_privilege{
		day          = 5,               %% 天数
		gold         = 3880000,         %% 美刀数量
		rmb          = 388             %% 钻石数量
	};

get(6)->
	#d_privilege{
		day          = 6,               %% 天数
		gold         = 660000,          %% 美刀数量
		rmb          = 66              %% 钻石数量
	};

get(7)->
	#d_privilege{
		day          = 7,               %% 天数
		gold         = 660000,          %% 美刀数量
		rmb          = 66              %% 钻石数量
	};

get(8)->
	#d_privilege{
		day          = 8,               %% 天数
		gold         = 660000,          %% 美刀数量
		rmb          = 0               %% 钻石数量
	};

get(9)->
	#d_privilege{
		day          = 9,               %% 天数
		gold         = 660000,          %% 美刀数量
		rmb          = 0               %% 钻石数量
	};

get(10)->
	#d_privilege{
		day          = 10,              %% 天数
		gold         = 660000,          %% 美刀数量
		rmb          = 0               %% 钻石数量
	};

get(11)->
	#d_privilege{
		day          = 11,              %% 天数
		gold         = 880000,          %% 美刀数量
		rmb          = 0               %% 钻石数量
	};

get(12)->
	#d_privilege{
		day          = 12,              %% 天数
		gold         = 880000,          %% 美刀数量
		rmb          = 0               %% 钻石数量
	};

get(13)->
	#d_privilege{
		day          = 13,              %% 天数
		gold         = 880000,          %% 美刀数量
		rmb          = 0               %% 钻石数量
	};

get(14)->
	#d_privilege{
		day          = 14,              %% 天数
		gold         = 880000,          %% 美刀数量
		rmb          = 0               %% 钻石数量
	};

get(15)->
	#d_privilege{
		day          = 15,              %% 天数
		gold         = 880000,          %% 美刀数量
		rmb          = 0               %% 钻石数量
	};

get(16)->
	#d_privilege{
		day          = 16,              %% 天数
		gold         = 880000,          %% 美刀数量
		rmb          = 0               %% 钻石数量
	};

get(_)->
	?null.
