-module(data_clan_skill).
-include("../include/comm.hrl").

-export([get/1,get_list/0]).

% get(成长类型,等级);
% 帮派技能数据;
% 
get(1)->
	#d_clan_skill{
		skill_lv     = 1,               %% 等级
		cast         = 50,              %% 体能消费
		strong_att   = 100,             %% 物理攻击
		strong_def   = 100,             %% 物理防御
		skill_att    = 100,             %% 技能攻击
		skill_def    = 100             %% 技能防御
	};
get(2)->
	#d_clan_skill{
		skill_lv     = 2,               %% 等级
		cast         = 100,             %% 体能消费
		strong_att   = 200,             %% 物理攻击
		strong_def   = 200,             %% 物理防御
		skill_att    = 200,             %% 技能攻击
		skill_def    = 200             %% 技能防御
	};
get(3)->
	#d_clan_skill{
		skill_lv     = 3,               %% 等级
		cast         = 150,             %% 体能消费
		strong_att   = 300,             %% 物理攻击
		strong_def   = 300,             %% 物理防御
		skill_att    = 300,             %% 技能攻击
		skill_def    = 300             %% 技能防御
	};
get(4)->
	#d_clan_skill{
		skill_lv     = 4,               %% 等级
		cast         = 200,             %% 体能消费
		strong_att   = 400,             %% 物理攻击
		strong_def   = 400,             %% 物理防御
		skill_att    = 400,             %% 技能攻击
		skill_def    = 400             %% 技能防御
	};
get(5)->
	#d_clan_skill{
		skill_lv     = 5,               %% 等级
		cast         = 250,             %% 体能消费
		strong_att   = 500,             %% 物理攻击
		strong_def   = 500,             %% 物理防御
		skill_att    = 500,             %% 技能攻击
		skill_def    = 500             %% 技能防御
	};
get(6)->
	#d_clan_skill{
		skill_lv     = 6,               %% 等级
		cast         = 300,             %% 体能消费
		strong_att   = 600,             %% 物理攻击
		strong_def   = 600,             %% 物理防御
		skill_att    = 600,             %% 技能攻击
		skill_def    = 600             %% 技能防御
	};
get(7)->
	#d_clan_skill{
		skill_lv     = 7,               %% 等级
		cast         = 350,             %% 体能消费
		strong_att   = 700,             %% 物理攻击
		strong_def   = 700,             %% 物理防御
		skill_att    = 700,             %% 技能攻击
		skill_def    = 700             %% 技能防御
	};
get(8)->
	#d_clan_skill{
		skill_lv     = 8,               %% 等级
		cast         = 400,             %% 体能消费
		strong_att   = 800,             %% 物理攻击
		strong_def   = 800,             %% 物理防御
		skill_att    = 800,             %% 技能攻击
		skill_def    = 800             %% 技能防御
	};
get(9)->
	#d_clan_skill{
		skill_lv     = 9,               %% 等级
		cast         = 450,             %% 体能消费
		strong_att   = 900,             %% 物理攻击
		strong_def   = 900,             %% 物理防御
		skill_att    = 900,             %% 技能攻击
		skill_def    = 900             %% 技能防御
	};
get(10)->
	#d_clan_skill{
		skill_lv     = 10,              %% 等级
		cast         = 500,             %% 体能消费
		strong_att   = 1000,            %% 物理攻击
		strong_def   = 1000,            %% 物理防御
		skill_att    = 1000,            %% 技能攻击
		skill_def    = 1000            %% 技能防御
	};
get(11)->
	#d_clan_skill{
		skill_lv     = 11,              %% 等级
		cast         = 550,             %% 体能消费
		strong_att   = 1100,            %% 物理攻击
		strong_def   = 1100,            %% 物理防御
		skill_att    = 1100,            %% 技能攻击
		skill_def    = 1100            %% 技能防御
	};
get(12)->
	#d_clan_skill{
		skill_lv     = 12,              %% 等级
		cast         = 600,             %% 体能消费
		strong_att   = 1200,            %% 物理攻击
		strong_def   = 1200,            %% 物理防御
		skill_att    = 1200,            %% 技能攻击
		skill_def    = 1200            %% 技能防御
	};
get(13)->
	#d_clan_skill{
		skill_lv     = 13,              %% 等级
		cast         = 650,             %% 体能消费
		strong_att   = 1300,            %% 物理攻击
		strong_def   = 1300,            %% 物理防御
		skill_att    = 1300,            %% 技能攻击
		skill_def    = 1300            %% 技能防御
	};
get(14)->
	#d_clan_skill{
		skill_lv     = 14,              %% 等级
		cast         = 700,             %% 体能消费
		strong_att   = 1400,            %% 物理攻击
		strong_def   = 1400,            %% 物理防御
		skill_att    = 1400,            %% 技能攻击
		skill_def    = 1400            %% 技能防御
	};
get(15)->
	#d_clan_skill{
		skill_lv     = 15,              %% 等级
		cast         = 750,             %% 体能消费
		strong_att   = 1500,            %% 物理攻击
		strong_def   = 1500,            %% 物理防御
		skill_att    = 1500,            %% 技能攻击
		skill_def    = 1500            %% 技能防御
	};
get(16)->
	#d_clan_skill{
		skill_lv     = 16,              %% 等级
		cast         = 800,             %% 体能消费
		strong_att   = 1600,            %% 物理攻击
		strong_def   = 1600,            %% 物理防御
		skill_att    = 1600,            %% 技能攻击
		skill_def    = 1600            %% 技能防御
	};
get(17)->
	#d_clan_skill{
		skill_lv     = 17,              %% 等级
		cast         = 850,             %% 体能消费
		strong_att   = 1700,            %% 物理攻击
		strong_def   = 1700,            %% 物理防御
		skill_att    = 1700,            %% 技能攻击
		skill_def    = 1700            %% 技能防御
	};
get(18)->
	#d_clan_skill{
		skill_lv     = 18,              %% 等级
		cast         = 900,             %% 体能消费
		strong_att   = 1800,            %% 物理攻击
		strong_def   = 1800,            %% 物理防御
		skill_att    = 1800,            %% 技能攻击
		skill_def    = 1800            %% 技能防御
	};
get(19)->
	#d_clan_skill{
		skill_lv     = 19,              %% 等级
		cast         = 950,             %% 体能消费
		strong_att   = 1900,            %% 物理攻击
		strong_def   = 1900,            %% 物理防御
		skill_att    = 1900,            %% 技能攻击
		skill_def    = 1900            %% 技能防御
	};
get(20)->
	#d_clan_skill{
		skill_lv     = 20,              %% 等级
		cast         = 1000,            %% 体能消费
		strong_att   = 2000,            %% 物理攻击
		strong_def   = 2000,            %% 物理防御
		skill_att    = 2000,            %% 技能攻击
		skill_def    = 2000            %% 技能防御
	};
get(21)->
	#d_clan_skill{
		skill_lv     = 21,              %% 等级
		cast         = 1050,            %% 体能消费
		strong_att   = 2100,            %% 物理攻击
		strong_def   = 2100,            %% 物理防御
		skill_att    = 2100,            %% 技能攻击
		skill_def    = 2100            %% 技能防御
	};
get(22)->
	#d_clan_skill{
		skill_lv     = 22,              %% 等级
		cast         = 1100,            %% 体能消费
		strong_att   = 2200,            %% 物理攻击
		strong_def   = 2200,            %% 物理防御
		skill_att    = 2200,            %% 技能攻击
		skill_def    = 2200            %% 技能防御
	};
get(23)->
	#d_clan_skill{
		skill_lv     = 23,              %% 等级
		cast         = 1150,            %% 体能消费
		strong_att   = 2300,            %% 物理攻击
		strong_def   = 2300,            %% 物理防御
		skill_att    = 2300,            %% 技能攻击
		skill_def    = 2300            %% 技能防御
	};
get(24)->
	#d_clan_skill{
		skill_lv     = 24,              %% 等级
		cast         = 1200,            %% 体能消费
		strong_att   = 2400,            %% 物理攻击
		strong_def   = 2400,            %% 物理防御
		skill_att    = 2400,            %% 技能攻击
		skill_def    = 2400            %% 技能防御
	};
get(25)->
	#d_clan_skill{
		skill_lv     = 25,              %% 等级
		cast         = 1250,            %% 体能消费
		strong_att   = 2500,            %% 物理攻击
		strong_def   = 2500,            %% 物理防御
		skill_att    = 2500,            %% 技能攻击
		skill_def    = 2500            %% 技能防御
	};
get(26)->
	#d_clan_skill{
		skill_lv     = 26,              %% 等级
		cast         = 1300,            %% 体能消费
		strong_att   = 2600,            %% 物理攻击
		strong_def   = 2600,            %% 物理防御
		skill_att    = 2600,            %% 技能攻击
		skill_def    = 2600            %% 技能防御
	};
get(27)->
	#d_clan_skill{
		skill_lv     = 27,              %% 等级
		cast         = 1350,            %% 体能消费
		strong_att   = 2700,            %% 物理攻击
		strong_def   = 2700,            %% 物理防御
		skill_att    = 2700,            %% 技能攻击
		skill_def    = 2700            %% 技能防御
	};
get(28)->
	#d_clan_skill{
		skill_lv     = 28,              %% 等级
		cast         = 1400,            %% 体能消费
		strong_att   = 2800,            %% 物理攻击
		strong_def   = 2800,            %% 物理防御
		skill_att    = 2800,            %% 技能攻击
		skill_def    = 2800            %% 技能防御
	};
get(29)->
	#d_clan_skill{
		skill_lv     = 29,              %% 等级
		cast         = 1450,            %% 体能消费
		strong_att   = 2900,            %% 物理攻击
		strong_def   = 2900,            %% 物理防御
		skill_att    = 2900,            %% 技能攻击
		skill_def    = 2900            %% 技能防御
	};
get(30)->
	#d_clan_skill{
		skill_lv     = 30,              %% 等级
		cast         = 1500,            %% 体能消费
		strong_att   = 3000,            %% 物理攻击
		strong_def   = 3000,            %% 物理防御
		skill_att    = 3000,            %% 技能攻击
		skill_def    = 3000            %% 技能防御
	};
get(31)->
	#d_clan_skill{
		skill_lv     = 31,              %% 等级
		cast         = 1550,            %% 体能消费
		strong_att   = 3100,            %% 物理攻击
		strong_def   = 3100,            %% 物理防御
		skill_att    = 3100,            %% 技能攻击
		skill_def    = 3100            %% 技能防御
	};
get(32)->
	#d_clan_skill{
		skill_lv     = 32,              %% 等级
		cast         = 1600,            %% 体能消费
		strong_att   = 3200,            %% 物理攻击
		strong_def   = 3200,            %% 物理防御
		skill_att    = 3200,            %% 技能攻击
		skill_def    = 3200            %% 技能防御
	};
get(33)->
	#d_clan_skill{
		skill_lv     = 33,              %% 等级
		cast         = 1650,            %% 体能消费
		strong_att   = 3300,            %% 物理攻击
		strong_def   = 3300,            %% 物理防御
		skill_att    = 3300,            %% 技能攻击
		skill_def    = 3300            %% 技能防御
	};
get(34)->
	#d_clan_skill{
		skill_lv     = 34,              %% 等级
		cast         = 1700,            %% 体能消费
		strong_att   = 3400,            %% 物理攻击
		strong_def   = 3400,            %% 物理防御
		skill_att    = 3400,            %% 技能攻击
		skill_def    = 3400            %% 技能防御
	};
get(35)->
	#d_clan_skill{
		skill_lv     = 35,              %% 等级
		cast         = 1750,            %% 体能消费
		strong_att   = 3500,            %% 物理攻击
		strong_def   = 3500,            %% 物理防御
		skill_att    = 3500,            %% 技能攻击
		skill_def    = 3500            %% 技能防御
	};
get(36)->
	#d_clan_skill{
		skill_lv     = 36,              %% 等级
		cast         = 1800,            %% 体能消费
		strong_att   = 3600,            %% 物理攻击
		strong_def   = 3600,            %% 物理防御
		skill_att    = 3600,            %% 技能攻击
		skill_def    = 3600            %% 技能防御
	};
get(37)->
	#d_clan_skill{
		skill_lv     = 37,              %% 等级
		cast         = 1850,            %% 体能消费
		strong_att   = 3700,            %% 物理攻击
		strong_def   = 3700,            %% 物理防御
		skill_att    = 3700,            %% 技能攻击
		skill_def    = 3700            %% 技能防御
	};
get(38)->
	#d_clan_skill{
		skill_lv     = 38,              %% 等级
		cast         = 1900,            %% 体能消费
		strong_att   = 3800,            %% 物理攻击
		strong_def   = 3800,            %% 物理防御
		skill_att    = 3800,            %% 技能攻击
		skill_def    = 3800            %% 技能防御
	};
get(39)->
	#d_clan_skill{
		skill_lv     = 39,              %% 等级
		cast         = 1950,            %% 体能消费
		strong_att   = 3900,            %% 物理攻击
		strong_def   = 3900,            %% 物理防御
		skill_att    = 3900,            %% 技能攻击
		skill_def    = 3900            %% 技能防御
	};
get(40)->
	#d_clan_skill{
		skill_lv     = 40,              %% 等级
		cast         = 2000,            %% 体能消费
		strong_att   = 4000,            %% 物理攻击
		strong_def   = 4000,            %% 物理防御
		skill_att    = 4000,            %% 技能攻击
		skill_def    = 4000            %% 技能防御
	};
get(41)->
	#d_clan_skill{
		skill_lv     = 41,              %% 等级
		cast         = 2200,            %% 体能消费
		strong_att   = 4100,            %% 物理攻击
		strong_def   = 4100,            %% 物理防御
		skill_att    = 4100,            %% 技能攻击
		skill_def    = 4100            %% 技能防御
	};
get(42)->
	#d_clan_skill{
		skill_lv     = 42,              %% 等级
		cast         = 2400,            %% 体能消费
		strong_att   = 4200,            %% 物理攻击
		strong_def   = 4200,            %% 物理防御
		skill_att    = 4200,            %% 技能攻击
		skill_def    = 4200            %% 技能防御
	};
get(43)->
	#d_clan_skill{
		skill_lv     = 43,              %% 等级
		cast         = 2600,            %% 体能消费
		strong_att   = 4300,            %% 物理攻击
		strong_def   = 4300,            %% 物理防御
		skill_att    = 4300,            %% 技能攻击
		skill_def    = 4300            %% 技能防御
	};
get(44)->
	#d_clan_skill{
		skill_lv     = 44,              %% 等级
		cast         = 2800,            %% 体能消费
		strong_att   = 4400,            %% 物理攻击
		strong_def   = 4400,            %% 物理防御
		skill_att    = 4400,            %% 技能攻击
		skill_def    = 4400            %% 技能防御
	};
get(45)->
	#d_clan_skill{
		skill_lv     = 45,              %% 等级
		cast         = 3000,            %% 体能消费
		strong_att   = 4500,            %% 物理攻击
		strong_def   = 4500,            %% 物理防御
		skill_att    = 4500,            %% 技能攻击
		skill_def    = 4500            %% 技能防御
	};
get(46)->
	#d_clan_skill{
		skill_lv     = 46,              %% 等级
		cast         = 3200,            %% 体能消费
		strong_att   = 4600,            %% 物理攻击
		strong_def   = 4600,            %% 物理防御
		skill_att    = 4600,            %% 技能攻击
		skill_def    = 4600            %% 技能防御
	};
get(47)->
	#d_clan_skill{
		skill_lv     = 47,              %% 等级
		cast         = 3400,            %% 体能消费
		strong_att   = 4700,            %% 物理攻击
		strong_def   = 4700,            %% 物理防御
		skill_att    = 4700,            %% 技能攻击
		skill_def    = 4700            %% 技能防御
	};
get(48)->
	#d_clan_skill{
		skill_lv     = 48,              %% 等级
		cast         = 3600,            %% 体能消费
		strong_att   = 4800,            %% 物理攻击
		strong_def   = 4800,            %% 物理防御
		skill_att    = 4800,            %% 技能攻击
		skill_def    = 4800            %% 技能防御
	};
get(49)->
	#d_clan_skill{
		skill_lv     = 49,              %% 等级
		cast         = 3800,            %% 体能消费
		strong_att   = 4900,            %% 物理攻击
		strong_def   = 4900,            %% 物理防御
		skill_att    = 4900,            %% 技能攻击
		skill_def    = 4900            %% 技能防御
	};
get(50)->
	#d_clan_skill{
		skill_lv     = 50,              %% 等级
		cast         = 4000,            %% 体能消费
		strong_att   = 5000,            %% 物理攻击
		strong_def   = 5000,            %% 物理防御
		skill_att    = 5000,            %% 技能攻击
		skill_def    = 5000            %% 技能防御
	};
get(51)->
	#d_clan_skill{
		skill_lv     = 51,              %% 等级
		cast         = 4200,            %% 体能消费
		strong_att   = 5100,            %% 物理攻击
		strong_def   = 5100,            %% 物理防御
		skill_att    = 5100,            %% 技能攻击
		skill_def    = 5100            %% 技能防御
	};
get(52)->
	#d_clan_skill{
		skill_lv     = 52,              %% 等级
		cast         = 4400,            %% 体能消费
		strong_att   = 5200,            %% 物理攻击
		strong_def   = 5200,            %% 物理防御
		skill_att    = 5200,            %% 技能攻击
		skill_def    = 5200            %% 技能防御
	};
get(53)->
	#d_clan_skill{
		skill_lv     = 53,              %% 等级
		cast         = 4600,            %% 体能消费
		strong_att   = 5300,            %% 物理攻击
		strong_def   = 5300,            %% 物理防御
		skill_att    = 5300,            %% 技能攻击
		skill_def    = 5300            %% 技能防御
	};
get(54)->
	#d_clan_skill{
		skill_lv     = 54,              %% 等级
		cast         = 4800,            %% 体能消费
		strong_att   = 5400,            %% 物理攻击
		strong_def   = 5400,            %% 物理防御
		skill_att    = 5400,            %% 技能攻击
		skill_def    = 5400            %% 技能防御
	};
get(55)->
	#d_clan_skill{
		skill_lv     = 55,              %% 等级
		cast         = 5000,            %% 体能消费
		strong_att   = 5500,            %% 物理攻击
		strong_def   = 5500,            %% 物理防御
		skill_att    = 5500,            %% 技能攻击
		skill_def    = 5500            %% 技能防御
	};
get(56)->
	#d_clan_skill{
		skill_lv     = 56,              %% 等级
		cast         = 5200,            %% 体能消费
		strong_att   = 5600,            %% 物理攻击
		strong_def   = 5600,            %% 物理防御
		skill_att    = 5600,            %% 技能攻击
		skill_def    = 5600            %% 技能防御
	};
get(57)->
	#d_clan_skill{
		skill_lv     = 57,              %% 等级
		cast         = 5400,            %% 体能消费
		strong_att   = 5700,            %% 物理攻击
		strong_def   = 5700,            %% 物理防御
		skill_att    = 5700,            %% 技能攻击
		skill_def    = 5700            %% 技能防御
	};
get(58)->
	#d_clan_skill{
		skill_lv     = 58,              %% 等级
		cast         = 5600,            %% 体能消费
		strong_att   = 5800,            %% 物理攻击
		strong_def   = 5800,            %% 物理防御
		skill_att    = 5800,            %% 技能攻击
		skill_def    = 5800            %% 技能防御
	};
get(59)->
	#d_clan_skill{
		skill_lv     = 59,              %% 等级
		cast         = 5800,            %% 体能消费
		strong_att   = 5900,            %% 物理攻击
		strong_def   = 5900,            %% 物理防御
		skill_att    = 5900,            %% 技能攻击
		skill_def    = 5900            %% 技能防御
	};
get(60)->
	#d_clan_skill{
		skill_lv     = 60,              %% 等级
		cast         = 6000,            %% 体能消费
		strong_att   = 6000,            %% 物理攻击
		strong_def   = 6000,            %% 物理防御
		skill_att    = 6000,            %% 技能攻击
		skill_def    = 6000            %% 技能防御
	};
get(61)->
	#d_clan_skill{
		skill_lv     = 61,              %% 等级
		cast         = 6200,            %% 体能消费
		strong_att   = 6100,            %% 物理攻击
		strong_def   = 6100,            %% 物理防御
		skill_att    = 6100,            %% 技能攻击
		skill_def    = 6100            %% 技能防御
	};
get(62)->
	#d_clan_skill{
		skill_lv     = 62,              %% 等级
		cast         = 6400,            %% 体能消费
		strong_att   = 6200,            %% 物理攻击
		strong_def   = 6200,            %% 物理防御
		skill_att    = 6200,            %% 技能攻击
		skill_def    = 6200            %% 技能防御
	};
get(63)->
	#d_clan_skill{
		skill_lv     = 63,              %% 等级
		cast         = 6600,            %% 体能消费
		strong_att   = 6300,            %% 物理攻击
		strong_def   = 6300,            %% 物理防御
		skill_att    = 6300,            %% 技能攻击
		skill_def    = 6300            %% 技能防御
	};
get(64)->
	#d_clan_skill{
		skill_lv     = 64,              %% 等级
		cast         = 6800,            %% 体能消费
		strong_att   = 6400,            %% 物理攻击
		strong_def   = 6400,            %% 物理防御
		skill_att    = 6400,            %% 技能攻击
		skill_def    = 6400            %% 技能防御
	};
get(65)->
	#d_clan_skill{
		skill_lv     = 65,              %% 等级
		cast         = 7000,            %% 体能消费
		strong_att   = 6500,            %% 物理攻击
		strong_def   = 6500,            %% 物理防御
		skill_att    = 6500,            %% 技能攻击
		skill_def    = 6500            %% 技能防御
	};
get(66)->
	#d_clan_skill{
		skill_lv     = 66,              %% 等级
		cast         = 7200,            %% 体能消费
		strong_att   = 6600,            %% 物理攻击
		strong_def   = 6600,            %% 物理防御
		skill_att    = 6600,            %% 技能攻击
		skill_def    = 6600            %% 技能防御
	};
get(67)->
	#d_clan_skill{
		skill_lv     = 67,              %% 等级
		cast         = 7400,            %% 体能消费
		strong_att   = 6700,            %% 物理攻击
		strong_def   = 6700,            %% 物理防御
		skill_att    = 6700,            %% 技能攻击
		skill_def    = 6700            %% 技能防御
	};
get(68)->
	#d_clan_skill{
		skill_lv     = 68,              %% 等级
		cast         = 7600,            %% 体能消费
		strong_att   = 6800,            %% 物理攻击
		strong_def   = 6800,            %% 物理防御
		skill_att    = 6800,            %% 技能攻击
		skill_def    = 6800            %% 技能防御
	};
get(69)->
	#d_clan_skill{
		skill_lv     = 69,              %% 等级
		cast         = 7800,            %% 体能消费
		strong_att   = 6900,            %% 物理攻击
		strong_def   = 6900,            %% 物理防御
		skill_att    = 6900,            %% 技能攻击
		skill_def    = 6900            %% 技能防御
	};
get(70)->
	#d_clan_skill{
		skill_lv     = 70,              %% 等级
		cast         = 8000,            %% 体能消费
		strong_att   = 7000,            %% 物理攻击
		strong_def   = 7000,            %% 物理防御
		skill_att    = 7000,            %% 技能攻击
		skill_def    = 7000            %% 技能防御
	};
get(71)->
	#d_clan_skill{
		skill_lv     = 71,              %% 等级
		cast         = 8200,            %% 体能消费
		strong_att   = 7100,            %% 物理攻击
		strong_def   = 7100,            %% 物理防御
		skill_att    = 7100,            %% 技能攻击
		skill_def    = 7100            %% 技能防御
	};
get(72)->
	#d_clan_skill{
		skill_lv     = 72,              %% 等级
		cast         = 8400,            %% 体能消费
		strong_att   = 7200,            %% 物理攻击
		strong_def   = 7200,            %% 物理防御
		skill_att    = 7200,            %% 技能攻击
		skill_def    = 7200            %% 技能防御
	};
get(73)->
	#d_clan_skill{
		skill_lv     = 73,              %% 等级
		cast         = 8600,            %% 体能消费
		strong_att   = 7300,            %% 物理攻击
		strong_def   = 7300,            %% 物理防御
		skill_att    = 7300,            %% 技能攻击
		skill_def    = 7300            %% 技能防御
	};
get(74)->
	#d_clan_skill{
		skill_lv     = 74,              %% 等级
		cast         = 8800,            %% 体能消费
		strong_att   = 7400,            %% 物理攻击
		strong_def   = 7400,            %% 物理防御
		skill_att    = 7400,            %% 技能攻击
		skill_def    = 7400            %% 技能防御
	};
get(75)->
	#d_clan_skill{
		skill_lv     = 75,              %% 等级
		cast         = 9000,            %% 体能消费
		strong_att   = 7500,            %% 物理攻击
		strong_def   = 7500,            %% 物理防御
		skill_att    = 7500,            %% 技能攻击
		skill_def    = 7500            %% 技能防御
	};
get(76)->
	#d_clan_skill{
		skill_lv     = 76,              %% 等级
		cast         = 9200,            %% 体能消费
		strong_att   = 7600,            %% 物理攻击
		strong_def   = 7600,            %% 物理防御
		skill_att    = 7600,            %% 技能攻击
		skill_def    = 7600            %% 技能防御
	};
get(77)->
	#d_clan_skill{
		skill_lv     = 77,              %% 等级
		cast         = 9400,            %% 体能消费
		strong_att   = 7700,            %% 物理攻击
		strong_def   = 7700,            %% 物理防御
		skill_att    = 7700,            %% 技能攻击
		skill_def    = 7700            %% 技能防御
	};
get(78)->
	#d_clan_skill{
		skill_lv     = 78,              %% 等级
		cast         = 9600,            %% 体能消费
		strong_att   = 7800,            %% 物理攻击
		strong_def   = 7800,            %% 物理防御
		skill_att    = 7800,            %% 技能攻击
		skill_def    = 7800            %% 技能防御
	};
get(79)->
	#d_clan_skill{
		skill_lv     = 79,              %% 等级
		cast         = 9800,            %% 体能消费
		strong_att   = 7900,            %% 物理攻击
		strong_def   = 7900,            %% 物理防御
		skill_att    = 7900,            %% 技能攻击
		skill_def    = 7900            %% 技能防御
	};
get(80)->
	#d_clan_skill{
		skill_lv     = 80,              %% 等级
		cast         = 10000,           %% 体能消费
		strong_att   = 8000,            %% 物理攻击
		strong_def   = 8000,            %% 物理防御
		skill_att    = 8000,            %% 技能攻击
		skill_def    = 8000            %% 技能防御
	};
get(81)->
	#d_clan_skill{
		skill_lv     = 81,              %% 等级
		cast         = 10200,           %% 体能消费
		strong_att   = 8100,            %% 物理攻击
		strong_def   = 8100,            %% 物理防御
		skill_att    = 8100,            %% 技能攻击
		skill_def    = 8100            %% 技能防御
	};
get(82)->
	#d_clan_skill{
		skill_lv     = 82,              %% 等级
		cast         = 10400,           %% 体能消费
		strong_att   = 8200,            %% 物理攻击
		strong_def   = 8200,            %% 物理防御
		skill_att    = 8200,            %% 技能攻击
		skill_def    = 8200            %% 技能防御
	};
get(83)->
	#d_clan_skill{
		skill_lv     = 83,              %% 等级
		cast         = 10600,           %% 体能消费
		strong_att   = 8300,            %% 物理攻击
		strong_def   = 8300,            %% 物理防御
		skill_att    = 8300,            %% 技能攻击
		skill_def    = 8300            %% 技能防御
	};
get(84)->
	#d_clan_skill{
		skill_lv     = 84,              %% 等级
		cast         = 10800,           %% 体能消费
		strong_att   = 8400,            %% 物理攻击
		strong_def   = 8400,            %% 物理防御
		skill_att    = 8400,            %% 技能攻击
		skill_def    = 8400            %% 技能防御
	};
get(85)->
	#d_clan_skill{
		skill_lv     = 85,              %% 等级
		cast         = 11000,           %% 体能消费
		strong_att   = 8500,            %% 物理攻击
		strong_def   = 8500,            %% 物理防御
		skill_att    = 8500,            %% 技能攻击
		skill_def    = 8500            %% 技能防御
	};
get(86)->
	#d_clan_skill{
		skill_lv     = 86,              %% 等级
		cast         = 11200,           %% 体能消费
		strong_att   = 8600,            %% 物理攻击
		strong_def   = 8600,            %% 物理防御
		skill_att    = 8600,            %% 技能攻击
		skill_def    = 8600            %% 技能防御
	};
get(87)->
	#d_clan_skill{
		skill_lv     = 87,              %% 等级
		cast         = 11400,           %% 体能消费
		strong_att   = 8700,            %% 物理攻击
		strong_def   = 8700,            %% 物理防御
		skill_att    = 8700,            %% 技能攻击
		skill_def    = 8700            %% 技能防御
	};
get(88)->
	#d_clan_skill{
		skill_lv     = 88,              %% 等级
		cast         = 11600,           %% 体能消费
		strong_att   = 8800,            %% 物理攻击
		strong_def   = 8800,            %% 物理防御
		skill_att    = 8800,            %% 技能攻击
		skill_def    = 8800            %% 技能防御
	};
get(89)->
	#d_clan_skill{
		skill_lv     = 89,              %% 等级
		cast         = 11800,           %% 体能消费
		strong_att   = 8900,            %% 物理攻击
		strong_def   = 8900,            %% 物理防御
		skill_att    = 8900,            %% 技能攻击
		skill_def    = 8900            %% 技能防御
	};
get(90)->
	#d_clan_skill{
		skill_lv     = 90,              %% 等级
		cast         = 12000,           %% 体能消费
		strong_att   = 9000,            %% 物理攻击
		strong_def   = 9000,            %% 物理防御
		skill_att    = 9000,            %% 技能攻击
		skill_def    = 9000            %% 技能防御
	};
get(91)->
	#d_clan_skill{
		skill_lv     = 91,              %% 等级
		cast         = 12200,           %% 体能消费
		strong_att   = 9100,            %% 物理攻击
		strong_def   = 9100,            %% 物理防御
		skill_att    = 9100,            %% 技能攻击
		skill_def    = 9100            %% 技能防御
	};
get(92)->
	#d_clan_skill{
		skill_lv     = 92,              %% 等级
		cast         = 12400,           %% 体能消费
		strong_att   = 9200,            %% 物理攻击
		strong_def   = 9200,            %% 物理防御
		skill_att    = 9200,            %% 技能攻击
		skill_def    = 9200            %% 技能防御
	};
get(93)->
	#d_clan_skill{
		skill_lv     = 93,              %% 等级
		cast         = 12600,           %% 体能消费
		strong_att   = 9300,            %% 物理攻击
		strong_def   = 9300,            %% 物理防御
		skill_att    = 9300,            %% 技能攻击
		skill_def    = 9300            %% 技能防御
	};
get(94)->
	#d_clan_skill{
		skill_lv     = 94,              %% 等级
		cast         = 12800,           %% 体能消费
		strong_att   = 9400,            %% 物理攻击
		strong_def   = 9400,            %% 物理防御
		skill_att    = 9400,            %% 技能攻击
		skill_def    = 9400            %% 技能防御
	};
get(95)->
	#d_clan_skill{
		skill_lv     = 95,              %% 等级
		cast         = 13000,           %% 体能消费
		strong_att   = 9500,            %% 物理攻击
		strong_def   = 9500,            %% 物理防御
		skill_att    = 9500,            %% 技能攻击
		skill_def    = 9500            %% 技能防御
	};
get(96)->
	#d_clan_skill{
		skill_lv     = 96,              %% 等级
		cast         = 13200,           %% 体能消费
		strong_att   = 9600,            %% 物理攻击
		strong_def   = 9600,            %% 物理防御
		skill_att    = 9600,            %% 技能攻击
		skill_def    = 9600            %% 技能防御
	};
get(97)->
	#d_clan_skill{
		skill_lv     = 97,              %% 等级
		cast         = 13400,           %% 体能消费
		strong_att   = 9700,            %% 物理攻击
		strong_def   = 9700,            %% 物理防御
		skill_att    = 9700,            %% 技能攻击
		skill_def    = 9700            %% 技能防御
	};
get(98)->
	#d_clan_skill{
		skill_lv     = 98,              %% 等级
		cast         = 13600,           %% 体能消费
		strong_att   = 9800,            %% 物理攻击
		strong_def   = 9800,            %% 物理防御
		skill_att    = 9800,            %% 技能攻击
		skill_def    = 9800            %% 技能防御
	};
get(99)->
	#d_clan_skill{
		skill_lv     = 99,              %% 等级
		cast         = 13800,           %% 体能消费
		strong_att   = 9900,            %% 物理攻击
		strong_def   = 9900,            %% 物理防御
		skill_att    = 9900,            %% 技能攻击
		skill_def    = 9900            %% 技能防御
	};
get(100)->
	#d_clan_skill{
		skill_lv     = 100,             %% 等级
		cast         = 14000,           %% 体能消费
		strong_att   = 10000,           %% 物理攻击
		strong_def   = 10000,           %% 物理防御
		skill_att    = 10000,           %% 技能攻击
		skill_def    = 10000           %% 技能防御
	};
get(_)->?null.

get_list()->[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100].
