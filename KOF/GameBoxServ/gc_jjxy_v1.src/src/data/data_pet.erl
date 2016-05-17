-module(data_pet).
-include("../include/comm.hrl").

-export([get/1]).

% 突进：获得5倍经验;
% 
get(1)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 1,               %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 70,              %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 40,              %% 物理攻击
		strong_def   = 26,              %% 物理防御
		skill_att    = 40,              %% 技能攻击
		skill_def    = 26,              %% 技能防御
		hp           = 80              %% 气血
	};

get(2)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 2,               %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 225,             %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 84,              %% 物理攻击
		strong_def   = 56,              %% 物理防御
		skill_att    = 84,              %% 技能攻击
		skill_def    = 56,              %% 技能防御
		hp           = 168             %% 气血
	};

get(3)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 3,               %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 380,             %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 132,             %% 物理攻击
		strong_def   = 88,              %% 物理防御
		skill_att    = 132,             %% 技能攻击
		skill_def    = 88,              %% 技能防御
		hp           = 264             %% 气血
	};

get(4)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 4,               %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 535,             %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 184,             %% 物理攻击
		strong_def   = 122,             %% 物理防御
		skill_att    = 184,             %% 技能攻击
		skill_def    = 122,             %% 技能防御
		hp           = 368             %% 气血
	};

get(5)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 5,               %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 690,             %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 240,             %% 物理攻击
		strong_def   = 160,             %% 物理防御
		skill_att    = 240,             %% 技能攻击
		skill_def    = 160,             %% 技能防御
		hp           = 480             %% 气血
	};

get(6)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 6,               %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 845,             %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 300,             %% 物理攻击
		strong_def   = 200,             %% 物理防御
		skill_att    = 300,             %% 技能攻击
		skill_def    = 200,             %% 技能防御
		hp           = 600             %% 气血
	};

get(7)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 7,               %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 1000,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 364,             %% 物理攻击
		strong_def   = 242,             %% 物理防御
		skill_att    = 364,             %% 技能攻击
		skill_def    = 242,             %% 技能防御
		hp           = 728             %% 气血
	};

get(8)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 8,               %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 1155,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 432,             %% 物理攻击
		strong_def   = 288,             %% 物理防御
		skill_att    = 432,             %% 技能攻击
		skill_def    = 288,             %% 技能防御
		hp           = 864             %% 气血
	};

get(9)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 9,               %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 1310,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 504,             %% 物理攻击
		strong_def   = 336,             %% 物理防御
		skill_att    = 504,             %% 技能攻击
		skill_def    = 336,             %% 技能防御
		hp           = 1008            %% 气血
	};

get(10)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 10,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 1465,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 580,             %% 物理攻击
		strong_def   = 386,             %% 物理防御
		skill_att    = 580,             %% 技能攻击
		skill_def    = 386,             %% 技能防御
		hp           = 1160            %% 气血
	};

get(11)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 11,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 1620,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 660,             %% 物理攻击
		strong_def   = 440,             %% 物理防御
		skill_att    = 660,             %% 技能攻击
		skill_def    = 440,             %% 技能防御
		hp           = 1320            %% 气血
	};

get(12)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 12,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 1775,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 776,             %% 物理攻击
		strong_def   = 518,             %% 物理防御
		skill_att    = 776,             %% 技能攻击
		skill_def    = 518,             %% 技能防御
		hp           = 1552            %% 气血
	};

get(13)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 13,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 1930,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 824,             %% 物理攻击
		strong_def   = 550,             %% 物理防御
		skill_att    = 824,             %% 技能攻击
		skill_def    = 550,             %% 技能防御
		hp           = 1648            %% 气血
	};

get(14)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 14,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 2085,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 876,             %% 物理攻击
		strong_def   = 584,             %% 物理防御
		skill_att    = 876,             %% 技能攻击
		skill_def    = 584,             %% 技能防御
		hp           = 1752            %% 气血
	};

get(15)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 15,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 2240,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 932,             %% 物理攻击
		strong_def   = 622,             %% 物理防御
		skill_att    = 932,             %% 技能攻击
		skill_def    = 622,             %% 技能防御
		hp           = 1864            %% 气血
	};

get(16)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 16,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 2395,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 992,             %% 物理攻击
		strong_def   = 662,             %% 物理防御
		skill_att    = 992,             %% 技能攻击
		skill_def    = 662,             %% 技能防御
		hp           = 1984            %% 气血
	};

get(17)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 17,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 2550,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1056,            %% 物理攻击
		strong_def   = 704,             %% 物理防御
		skill_att    = 1056,            %% 技能攻击
		skill_def    = 704,             %% 技能防御
		hp           = 2112            %% 气血
	};

get(18)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 18,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 2705,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1124,            %% 物理攻击
		strong_def   = 750,             %% 物理防御
		skill_att    = 1124,            %% 技能攻击
		skill_def    = 750,             %% 技能防御
		hp           = 2248            %% 气血
	};

get(19)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 19,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 2860,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1196,            %% 物理攻击
		strong_def   = 798,             %% 物理防御
		skill_att    = 1196,            %% 技能攻击
		skill_def    = 798,             %% 技能防御
		hp           = 2392            %% 气血
	};

get(20)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 20,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 3015,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1272,            %% 物理攻击
		strong_def   = 848,             %% 物理防御
		skill_att    = 1272,            %% 技能攻击
		skill_def    = 848,             %% 技能防御
		hp           = 2544            %% 气血
	};

get(21)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 21,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 3170,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1352,            %% 物理攻击
		strong_def   = 902,             %% 物理防御
		skill_att    = 1352,            %% 技能攻击
		skill_def    = 902,             %% 技能防御
		hp           = 2704            %% 气血
	};

get(22)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 22,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 3325,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1436,            %% 物理攻击
		strong_def   = 958,             %% 物理防御
		skill_att    = 1436,            %% 技能攻击
		skill_def    = 958,             %% 技能防御
		hp           = 2872            %% 气血
	};

get(23)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 23,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 3480,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1578,            %% 物理攻击
		strong_def   = 1054,            %% 物理防御
		skill_att    = 1578,            %% 技能攻击
		skill_def    = 1054,            %% 技能防御
		hp           = 3156            %% 气血
	};

get(24)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 24,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 3635,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1630,            %% 物理攻击
		strong_def   = 1088,            %% 物理防御
		skill_att    = 1630,            %% 技能攻击
		skill_def    = 1088,            %% 技能防御
		hp           = 3260            %% 气血
	};

get(25)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 25,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 3790,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1686,            %% 物理攻击
		strong_def   = 1126,            %% 物理防御
		skill_att    = 1686,            %% 技能攻击
		skill_def    = 1126,            %% 技能防御
		hp           = 3372            %% 气血
	};

get(26)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 26,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 3945,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1746,            %% 物理攻击
		strong_def   = 1166,            %% 物理防御
		skill_att    = 1746,            %% 技能攻击
		skill_def    = 1166,            %% 技能防御
		hp           = 3492            %% 气血
	};

get(27)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 27,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 4100,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1810,            %% 物理攻击
		strong_def   = 1208,            %% 物理防御
		skill_att    = 1810,            %% 技能攻击
		skill_def    = 1208,            %% 技能防御
		hp           = 3620            %% 气血
	};

get(28)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 28,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 4255,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1878,            %% 物理攻击
		strong_def   = 1254,            %% 物理防御
		skill_att    = 1878,            %% 技能攻击
		skill_def    = 1254,            %% 技能防御
		hp           = 3756            %% 气血
	};

get(29)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 29,              %% 魔宠等级
		unreal_skin  = [10001],         %% 开通皮肤
		next_exp     = 4410,            %% 下一级所需经验
		gold_exp     = 10,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 10,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 1950,            %% 物理攻击
		strong_def   = 1302,            %% 物理防御
		skill_att    = 1950,            %% 技能攻击
		skill_def    = 1302,            %% 技能防御
		hp           = 3900            %% 气血
	};

get(30)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 30,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 4565,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2026,            %% 物理攻击
		strong_def   = 1352,            %% 物理防御
		skill_att    = 2026,            %% 技能攻击
		skill_def    = 1352,            %% 技能防御
		hp           = 4052            %% 气血
	};

get(31)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 31,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 4720,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2106,            %% 物理攻击
		strong_def   = 1406,            %% 物理防御
		skill_att    = 2106,            %% 技能攻击
		skill_def    = 1406,            %% 技能防御
		hp           = 4212            %% 气血
	};

get(32)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 32,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 4875,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2190,            %% 物理攻击
		strong_def   = 1462,            %% 物理防御
		skill_att    = 2190,            %% 技能攻击
		skill_def    = 1462,            %% 技能防御
		hp           = 4380            %% 气血
	};

get(33)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 33,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 5030,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2278,            %% 物理攻击
		strong_def   = 1520,            %% 物理防御
		skill_att    = 2278,            %% 技能攻击
		skill_def    = 1520,            %% 技能防御
		hp           = 4556            %% 气血
	};

get(34)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 34,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 5185,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2446,            %% 物理攻击
		strong_def   = 1632,            %% 物理防御
		skill_att    = 2446,            %% 技能攻击
		skill_def    = 1632,            %% 技能防御
		hp           = 4892            %% 气血
	};

get(35)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 35,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 5340,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2502,            %% 物理攻击
		strong_def   = 1670,            %% 物理防御
		skill_att    = 2502,            %% 技能攻击
		skill_def    = 1670,            %% 技能防御
		hp           = 5236            %% 气血
	};

get(36)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 36,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 5495,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2562,            %% 物理攻击
		strong_def   = 1710,            %% 物理防御
		skill_att    = 2562,            %% 技能攻击
		skill_def    = 1710,            %% 技能防御
		hp           = 5588            %% 气血
	};

get(37)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 37,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 5650,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2626,            %% 物理攻击
		strong_def   = 1754,            %% 物理防御
		skill_att    = 2626,            %% 技能攻击
		skill_def    = 1754,            %% 技能防御
		hp           = 5948            %% 气血
	};

get(38)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 38,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 5805,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2694,            %% 物理攻击
		strong_def   = 1798,            %% 物理防御
		skill_att    = 2694,            %% 技能攻击
		skill_def    = 1798,            %% 技能防御
		hp           = 6316            %% 气血
	};

get(39)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 39,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 5960,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2766,            %% 物理攻击
		strong_def   = 1846,            %% 物理防御
		skill_att    = 2766,            %% 技能攻击
		skill_def    = 1846,            %% 技能防御
		hp           = 6692            %% 气血
	};

get(40)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 40,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 6115,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2842,            %% 物理攻击
		strong_def   = 1898,            %% 物理防御
		skill_att    = 2842,            %% 技能攻击
		skill_def    = 1898,            %% 技能防御
		hp           = 7076            %% 气血
	};

get(41)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 41,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 6270,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 2922,            %% 物理攻击
		strong_def   = 1950,            %% 物理防御
		skill_att    = 2922,            %% 技能攻击
		skill_def    = 1950,            %% 技能防御
		hp           = 7468            %% 气血
	};

get(42)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 42,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 6425,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3006,            %% 物理攻击
		strong_def   = 2008,            %% 物理防御
		skill_att    = 3006,            %% 技能攻击
		skill_def    = 2008,            %% 技能防御
		hp           = 7868            %% 气血
	};

get(43)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 43,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 6580,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3094,            %% 物理攻击
		strong_def   = 2066,            %% 物理防御
		skill_att    = 3094,            %% 技能攻击
		skill_def    = 2066,            %% 技能防御
		hp           = 8276            %% 气血
	};

get(44)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 44,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 6735,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3186,            %% 物理攻击
		strong_def   = 2128,            %% 物理防御
		skill_att    = 3186,            %% 技能攻击
		skill_def    = 2128,            %% 技能防御
		hp           = 8692            %% 气血
	};

get(45)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 45,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 6890,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3380,            %% 物理攻击
		strong_def   = 2256,            %% 物理防御
		skill_att    = 3380,            %% 技能攻击
		skill_def    = 2256,            %% 技能防御
		hp           = 9116            %% 气血
	};

get(46)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 46,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 7045,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3440,            %% 物理攻击
		strong_def   = 2296,            %% 物理防御
		skill_att    = 3440,            %% 技能攻击
		skill_def    = 2296,            %% 技能防御
		hp           = 9548            %% 气血
	};

get(47)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 47,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 7200,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3504,            %% 物理攻击
		strong_def   = 2340,            %% 物理防御
		skill_att    = 3504,            %% 技能攻击
		skill_def    = 2340,            %% 技能防御
		hp           = 9988            %% 气血
	};

get(48)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 48,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 7355,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3572,            %% 物理攻击
		strong_def   = 2386,            %% 物理防御
		skill_att    = 3572,            %% 技能攻击
		skill_def    = 2386,            %% 技能防御
		hp           = 10436           %% 气血
	};

get(49)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 49,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 7510,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3644,            %% 物理攻击
		strong_def   = 2434,            %% 物理防御
		skill_att    = 3644,            %% 技能攻击
		skill_def    = 2434,            %% 技能防御
		hp           = 10892           %% 气血
	};

get(50)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 50,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 7665,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3720,            %% 物理攻击
		strong_def   = 2484,            %% 物理防御
		skill_att    = 3720,            %% 技能攻击
		skill_def    = 2484,            %% 技能防御
		hp           = 11356           %% 气血
	};

get(51)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 51,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 7820,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3800,            %% 物理攻击
		strong_def   = 2538,            %% 物理防御
		skill_att    = 3800,            %% 技能攻击
		skill_def    = 2538,            %% 技能防御
		hp           = 11828           %% 气血
	};

get(52)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 52,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 7975,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3884,            %% 物理攻击
		strong_def   = 2594,            %% 物理防御
		skill_att    = 3884,            %% 技能攻击
		skill_def    = 2594,            %% 技能防御
		hp           = 12308           %% 气血
	};

get(53)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 53,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 8130,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 3972,            %% 物理攻击
		strong_def   = 2652,            %% 物理防御
		skill_att    = 3972,            %% 技能攻击
		skill_def    = 2652,            %% 技能防御
		hp           = 12796           %% 气血
	};

get(54)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 54,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 8285,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4064,            %% 物理攻击
		strong_def   = 2714,            %% 物理防御
		skill_att    = 4064,            %% 技能攻击
		skill_def    = 2714,            %% 技能防御
		hp           = 13292           %% 气血
	};

get(55)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 55,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 8440,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4160,            %% 物理攻击
		strong_def   = 2778,            %% 物理防御
		skill_att    = 4160,            %% 技能攻击
		skill_def    = 2778,            %% 技能防御
		hp           = 13796           %% 气血
	};

get(56)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 56,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 8595,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4380,            %% 物理攻击
		strong_def   = 2924,            %% 物理防御
		skill_att    = 4380,            %% 技能攻击
		skill_def    = 2924,            %% 技能防御
		hp           = 14308           %% 气血
	};

get(57)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 57,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 8750,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4440,            %% 物理攻击
		strong_def   = 2966,            %% 物理防御
		skill_att    = 4440,            %% 技能攻击
		skill_def    = 2966,            %% 技能防御
		hp           = 14828           %% 气血
	};

get(58)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 58,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 8905,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4504,            %% 物理攻击
		strong_def   = 3010,            %% 物理防御
		skill_att    = 4504,            %% 技能攻击
		skill_def    = 3010,            %% 技能防御
		hp           = 15356           %% 气血
	};

get(59)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 59,              %% 魔宠等级
		unreal_skin  = [10001,10002],   %% 开通皮肤
		next_exp     = 9060,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4572,            %% 物理攻击
		strong_def   = 3056,            %% 物理防御
		skill_att    = 4572,            %% 技能攻击
		skill_def    = 3056,            %% 技能防御
		hp           = 15892           %% 气血
	};

get(60)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 60,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 9215,            %% 下一级所需经验
		gold_exp     = 15,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 15,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4644,            %% 物理攻击
		strong_def   = 3104,            %% 物理防御
		skill_att    = 4644,            %% 技能攻击
		skill_def    = 3104,            %% 技能防御
		hp           = 16436           %% 气血
	};

get(61)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 61,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 9370,            %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4720,            %% 物理攻击
		strong_def   = 3154,            %% 物理防御
		skill_att    = 4720,            %% 技能攻击
		skill_def    = 3154,            %% 技能防御
		hp           = 16988           %% 气血
	};

get(62)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 62,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 9525,            %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4800,            %% 物理攻击
		strong_def   = 3208,            %% 物理防御
		skill_att    = 4800,            %% 技能攻击
		skill_def    = 3208,            %% 技能防御
		hp           = 17548           %% 气血
	};

get(63)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 63,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 9680,            %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4884,            %% 物理攻击
		strong_def   = 3264,            %% 物理防御
		skill_att    = 4884,            %% 技能攻击
		skill_def    = 3264,            %% 技能防御
		hp           = 18116           %% 气血
	};

get(64)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 64,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 9835,            %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 4972,            %% 物理攻击
		strong_def   = 3322,            %% 物理防御
		skill_att    = 4972,            %% 技能攻击
		skill_def    = 3322,            %% 技能防御
		hp           = 18692           %% 气血
	};

get(65)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 65,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 9990,            %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 5064,            %% 物理攻击
		strong_def   = 3384,            %% 物理防御
		skill_att    = 5064,            %% 技能攻击
		skill_def    = 3384,            %% 技能防御
		hp           = 19276           %% 气血
	};

get(66)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 66,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 10145,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 5160,            %% 物理攻击
		strong_def   = 3448,            %% 物理防御
		skill_att    = 5160,            %% 技能攻击
		skill_def    = 3448,            %% 技能防御
		hp           = 19868           %% 气血
	};

get(67)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 67,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 10300,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 5260,            %% 物理攻击
		strong_def   = 3514,            %% 物理防御
		skill_att    = 5260,            %% 技能攻击
		skill_def    = 3514,            %% 技能防御
		hp           = 20468           %% 气血
	};

get(68)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 68,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 10455,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 5506,            %% 物理攻击
		strong_def   = 3678,            %% 物理防御
		skill_att    = 5506,            %% 技能攻击
		skill_def    = 3678,            %% 技能防御
		hp           = 21076           %% 气血
	};

get(69)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 69,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 10610,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 5574,            %% 物理攻击
		strong_def   = 3724,            %% 物理防御
		skill_att    = 5574,            %% 技能攻击
		skill_def    = 3724,            %% 技能防御
		hp           = 21692           %% 气血
	};

get(70)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 70,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 10765,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 5646,            %% 物理攻击
		strong_def   = 3772,            %% 物理防御
		skill_att    = 5646,            %% 技能攻击
		skill_def    = 3772,            %% 技能防御
		hp           = 22316           %% 气血
	};

get(71)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 71,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 10920,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 5722,            %% 物理攻击
		strong_def   = 3824,            %% 物理防御
		skill_att    = 5722,            %% 技能攻击
		skill_def    = 3824,            %% 技能防御
		hp           = 22948           %% 气血
	};

get(72)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 72,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 11075,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 5802,            %% 物理攻击
		strong_def   = 3876,            %% 物理防御
		skill_att    = 5802,            %% 技能攻击
		skill_def    = 3876,            %% 技能防御
		hp           = 23588           %% 气血
	};

get(73)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 73,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 11230,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 5886,            %% 物理攻击
		strong_def   = 3932,            %% 物理防御
		skill_att    = 5886,            %% 技能攻击
		skill_def    = 3932,            %% 技能防御
		hp           = 24236           %% 气血
	};

get(74)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 74,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 11385,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 5974,            %% 物理攻击
		strong_def   = 3992,            %% 物理防御
		skill_att    = 5974,            %% 技能攻击
		skill_def    = 3992,            %% 技能防御
		hp           = 24892           %% 气血
	};

get(75)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 75,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 11540,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 6066,            %% 物理攻击
		strong_def   = 4054,            %% 物理防御
		skill_att    = 6066,            %% 技能攻击
		skill_def    = 4054,            %% 技能防御
		hp           = 25556           %% 气血
	};

get(76)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 76,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 11695,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 6162,            %% 物理攻击
		strong_def   = 4118,            %% 物理防御
		skill_att    = 6162,            %% 技能攻击
		skill_def    = 4118,            %% 技能防御
		hp           = 26228           %% 气血
	};

get(77)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 77,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 11850,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 6262,            %% 物理攻击
		strong_def   = 4184,            %% 物理防御
		skill_att    = 6262,            %% 技能攻击
		skill_def    = 4184,            %% 技能防御
		hp           = 26908           %% 气血
	};

get(78)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 78,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 12005,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 6838,            %% 物理攻击
		strong_def   = 4569,            %% 物理防御
		skill_att    = 6838,            %% 技能攻击
		skill_def    = 4569,            %% 技能防御
		hp           = 29665           %% 气血
	};

get(79)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 79,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 12160,           %% 下一级所需经验
		gold_exp     = 20,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 20,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 6916,            %% 物理攻击
		strong_def   = 4621,            %% 物理防御
		skill_att    = 6916,            %% 技能攻击
		skill_def    = 4621,            %% 技能防御
		hp           = 30413           %% 气血
	};

get(80)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 80,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 12315,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 6998,            %% 物理攻击
		strong_def   = 4675,            %% 物理防御
		skill_att    = 6998,            %% 技能攻击
		skill_def    = 4675,            %% 技能防御
		hp           = 31170           %% 气血
	};

get(81)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 81,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 12470,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 7084,            %% 物理攻击
		strong_def   = 4733,            %% 物理防御
		skill_att    = 7084,            %% 技能攻击
		skill_def    = 4733,            %% 技能防御
		hp           = 31936           %% 气血
	};

get(82)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 82,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 12625,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 7174,            %% 物理攻击
		strong_def   = 4793,            %% 物理防御
		skill_att    = 7174,            %% 技能攻击
		skill_def    = 4793,            %% 技能防御
		hp           = 32710           %% 气血
	};

get(83)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 83,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 12780,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 7268,            %% 物理攻击
		strong_def   = 4855,            %% 物理防御
		skill_att    = 7268,            %% 技能攻击
		skill_def    = 4855,            %% 技能防御
		hp           = 33492           %% 气血
	};

get(84)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 84,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 12935,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 7367,            %% 物理攻击
		strong_def   = 4922,            %% 物理防御
		skill_att    = 7367,            %% 技能攻击
		skill_def    = 4922,            %% 技能防御
		hp           = 34283           %% 气血
	};

get(85)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 85,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 13090,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 7471,            %% 物理攻击
		strong_def   = 4991,            %% 物理防御
		skill_att    = 7471,            %% 技能攻击
		skill_def    = 4991,            %% 技能防御
		hp           = 35083           %% 气血
	};

get(86)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 86,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 13245,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 7578,            %% 物理攻击
		strong_def   = 5062,            %% 物理防御
		skill_att    = 7578,            %% 技能攻击
		skill_def    = 5062,            %% 技能防御
		hp           = 35892           %% 气血
	};

get(87)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 87,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 13400,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 7690,            %% 物理攻击
		strong_def   = 5137,            %% 物理防御
		skill_att    = 7690,            %% 技能攻击
		skill_def    = 5137,            %% 技能防御
		hp           = 36709           %% 气血
	};

get(88)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 88,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 13555,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 7806,            %% 物理攻击
		strong_def   = 5214,            %% 物理防御
		skill_att    = 7806,            %% 技能攻击
		skill_def    = 5214,            %% 技能防御
		hp           = 37534           %% 气血
	};

get(89)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 89,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 13710,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 7922,            %% 物理攻击
		strong_def   = 5291,            %% 物理防御
		skill_att    = 7922,            %% 技能攻击
		skill_def    = 5291,            %% 技能防御
		hp           = 38359           %% 气血
	};

get(90)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 90,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 13865,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 8038,            %% 物理攻击
		strong_def   = 5368,            %% 物理防御
		skill_att    = 8038,            %% 技能攻击
		skill_def    = 5368,            %% 技能防御
		hp           = 39184           %% 气血
	};

get(91)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 91,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 14020,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 8154,            %% 物理攻击
		strong_def   = 5445,            %% 物理防御
		skill_att    = 8154,            %% 技能攻击
		skill_def    = 5445,            %% 技能防御
		hp           = 40009           %% 气血
	};

get(92)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 92,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 14175,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 8270,            %% 物理攻击
		strong_def   = 5522,            %% 物理防御
		skill_att    = 8270,            %% 技能攻击
		skill_def    = 5522,            %% 技能防御
		hp           = 40834           %% 气血
	};

get(93)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 93,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 14330,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 8386,            %% 物理攻击
		strong_def   = 5599,            %% 物理防御
		skill_att    = 8386,            %% 技能攻击
		skill_def    = 5599,            %% 技能防御
		hp           = 41659           %% 气血
	};

get(94)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 94,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 14485,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 8502,            %% 物理攻击
		strong_def   = 5676,            %% 物理防御
		skill_att    = 8502,            %% 技能攻击
		skill_def    = 5676,            %% 技能防御
		hp           = 42484           %% 气血
	};

get(95)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 95,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 14640,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 8618,            %% 物理攻击
		strong_def   = 5753,            %% 物理防御
		skill_att    = 8618,            %% 技能攻击
		skill_def    = 5753,            %% 技能防御
		hp           = 43309           %% 气血
	};

get(96)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 96,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 14795,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 8734,            %% 物理攻击
		strong_def   = 5830,            %% 物理防御
		skill_att    = 8734,            %% 技能攻击
		skill_def    = 5830,            %% 技能防御
		hp           = 44134           %% 气血
	};

get(97)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 97,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 14950,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 8850,            %% 物理攻击
		strong_def   = 5907,            %% 物理防御
		skill_att    = 8850,            %% 技能攻击
		skill_def    = 5907,            %% 技能防御
		hp           = 44959           %% 气血
	};

get(98)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 98,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 15105,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 8966,            %% 物理攻击
		strong_def   = 5984,            %% 物理防御
		skill_att    = 8966,            %% 技能攻击
		skill_def    = 5984,            %% 技能防御
		hp           = 45784           %% 气血
	};

get(99)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 99,              %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 15260,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 9082,            %% 物理攻击
		strong_def   = 6061,            %% 物理防御
		skill_att    = 9082,            %% 技能攻击
		skill_def    = 6061,            %% 技能防御
		hp           = 46609           %% 气血
	};

get(100)->
	#d_pet{
		pet_id       = 50001,           %% 魔宠ID
		lv           = 100,             %% 魔宠等级
		unreal_skin  = [10001,10002,10003],%% 开通皮肤
		next_exp     = 15415,           %% 下一级所需经验
		gold_exp     = 25,              %% 钻石培养经验
		gold_ten_opp = 5000,            %% 钻石培养突进概率
		gold_time    = 5,               %% 钻石倍率
		good_exp     = 25,              %% 道具培养经验
		good_ten_opp = 0,               %% 道具培养突进概率
		good_time    = 5,               %% 道具倍率
		strong_att   = 9198,            %% 物理攻击
		strong_def   = 6138,            %% 物理防御
		skill_att    = 9198,            %% 技能攻击
		skill_def    = 6138,            %% 技能防御
		hp           = 47434           %% 气血
	};

get(_)->
	?null.
