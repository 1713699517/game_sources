-module(data_vipsign).
-include("../include/comm.hrl").

-export([get/1]).

% get(VIP等级);
% sign_vip数据;
% rewards：[{give,Id,count,streng,name_color,bind,expiry_type,expiry},...]
get(1)->
	#d_vipsign{
		vip_lv       = 1,               %% VIP等级
		rewards      = [],              %% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(2)->
	#d_vipsign{
		vip_lv       = 2,               %% VIP等级
		rewards      = [],              %% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(3)->
	#d_vipsign{
		vip_lv       = 3,               %% VIP等级
		rewards      = [{give,41126,1,0,0,0,0,0}],%% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(4)->
	#d_vipsign{
		vip_lv       = 4,               %% VIP等级
		rewards      = [{give,41126,1,0,0,0,0,0}],%% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(5)->
	#d_vipsign{
		vip_lv       = 5,               %% VIP等级
		rewards      = [{give,41131,1,0,0,0,0,0}],%% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(6)->
	#d_vipsign{
		vip_lv       = 6,               %% VIP等级
		rewards      = [{give,41131,1,0,0,0,0,0}],%% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(7)->
	#d_vipsign{
		vip_lv       = 7,               %% VIP等级
		rewards      = [{give,41131,1,0,0,0,0,0}],%% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(8)->
	#d_vipsign{
		vip_lv       = 8,               %% VIP等级
		rewards      = [{give,41131,1,0,0,0,0,0}],%% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(9)->
	#d_vipsign{
		vip_lv       = 9,               %% VIP等级
		rewards      = [{give,41131,1,0,0,0,0,0}],%% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(10)->
	#d_vipsign{
		vip_lv       = 10,              %% VIP等级
		rewards      = [{give,41131,1,0,0,0,0,0}],%% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(11)->
	#d_vipsign{
		vip_lv       = 11,              %% VIP等级
		rewards      = [{give,41131,1,0,0,0,0,0}],%% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(12)->
	#d_vipsign{
		vip_lv       = 12,              %% VIP等级
		rewards      = [{give,41131,1,0,0,0,0,0}],%% 奖励{一号钱袋}
		vgoods       = []              %% 虚拟物品{铜钱1|元宝2|绑定元宝3|声望4|精力5|星魂6}
	};
get(_)->?null.
