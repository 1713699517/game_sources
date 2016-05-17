-module(data_mall).
-include("../include/comm.hrl").

-export([name/1,classs/1,data/1,data_ids/1]).

%% name(MallId) -> Mall数据 
name(10)->
	#d_mall_name{
		 mall_id		= 10,	% 商城ID
		 vip			= 6,	%% 打折VIP等级
		 vip_discount = 9000,	%% 打折
		 open_lv		= 10,	%% 开放等级	
		 open_type	= 0,	%% 开放类型	
		 open_arg		= [],	%% 开放参数
		 open_start	= {  0,00  },	%%  开始时间{24小时,分钟}
		 open_end		= {  23,59  }	%%  结束时间{24小时,分钟}
	};
name(20)->
	#d_mall_name{
		 mall_id		= 20,	% 商城ID
		 vip			= 0,	%% 打折VIP等级
		 vip_discount = 10000,	%% 打折
		 open_lv		= 1,	%% 开放等级	
		 open_type	= 0,	%% 开放类型	
		 open_arg		= [],	%% 开放参数
		 open_start	= {  0,00  },	%%  开始时间{24小时,分钟}
		 open_end		= {  23,59  }	%%  结束时间{24小时,分钟}
	};
name(30)->
	#d_mall_name{
		 mall_id		= 30,	% 商城ID
		 vip			= 0,	%% 打折VIP等级
		 vip_discount = 10000,	%% 打折
		 open_lv		= 20,	%% 开放等级	
		 open_type	= 2,	%% 开放类型	
		 open_arg		= [1,2,3,7],	%% 开放参数
		 open_start	= {  0,00  },	%%  开始时间{24小时,分钟}
		 open_end		= {  23,59  }	%%  结束时间{24小时,分钟}
	};
name(40)->
	#d_mall_name{
		 mall_id		= 40,	% 商城ID
		 vip			= 0,	%% 打折VIP等级
		 vip_discount = 10000,	%% 打折
		 open_lv		= 30,	%% 开放等级	
		 open_type	= 0,	%% 开放类型	
		 open_arg		= [],	%% 开放参数
		 open_start	= {  0,00  },	%%  开始时间{24小时,分钟}
		 open_end		= {  23,59  }	%%  结束时间{24小时,分钟}
	};
name(50)->
	#d_mall_name{
		 mall_id		= 50,	% 商城ID
		 vip			= 0,	%% 打折VIP等级
		 vip_discount = 10000,	%% 打折
		 open_lv		= 30,	%% 开放等级	
		 open_type	= 0,	%% 开放类型	
		 open_arg		= [],	%% 开放参数
		 open_start	= {  0,00  },	%%  开始时间{24小时,分钟}
		 open_end		= {  23,59  }	%%  结束时间{24小时,分钟}
	};
name(60)->
	#d_mall_name{
		 mall_id		= 60,	% 商城ID
		 vip			= 0,	%% 打折VIP等级
		 vip_discount = 10000,	%% 打折
		 open_lv		= 30,	%% 开放等级	
		 open_type	= 0,	%% 开放类型	
		 open_arg		= [],	%% 开放参数
		 open_start	= {  0,00  },	%%  开始时间{24小时,分钟}
		 open_end		= {  23,59  }	%%  结束时间{24小时,分钟}
	};
name(70)->
	#d_mall_name{
		 mall_id		= 70,	% 商城ID
		 vip			= 0,	%% 打折VIP等级
		 vip_discount = 10000,	%% 打折
		 open_lv		= 30,	%% 开放等级	
		 open_type	= 0,	%% 开放类型	
		 open_arg		= [],	%% 开放参数
		 open_start	= {  0,00  },	%%  开始时间{24小时,分钟}
		 open_end		= {  23,59  }	%%  结束时间{24小时,分钟}
	};
name(80)->
	#d_mall_name{
		 mall_id		= 80,	% 商城ID
		 vip			= 0,	%% 打折VIP等级
		 vip_discount = 10000,	%% 打折
		 open_lv		= 30,	%% 开放等级	
		 open_type	= 0,	%% 开放类型	
		 open_arg		= [],	%% 开放参数
		 open_start	= {  0,00  },	%%  开始时间{24小时,分钟}
		 open_end		= {  23,59  }	%%  结束时间{24小时,分钟}
	};
name(_)->?null.


%% classs(ClassID) -> Class数据 
classs(1000)->
	#d_mall_class{
		 mall_id		= 10,		%% 商城ID
		 class_id		= 1000,		%% 分类ID
		 is_discount 	= 1	%% 是否打折
	};
classs(1010)->
	#d_mall_class{
		 mall_id		= 10,		%% 商城ID
		 class_id		= 1010,		%% 分类ID
		 is_discount 	= 1	%% 是否打折
	};
classs(1020)->
	#d_mall_class{
		 mall_id		= 10,		%% 商城ID
		 class_id		= 1020,		%% 分类ID
		 is_discount 	= 1	%% 是否打折
	};
classs(1030)->
	#d_mall_class{
		 mall_id		= 10,		%% 商城ID
		 class_id		= 1030,		%% 分类ID
		 is_discount 	= 1	%% 是否打折
	};
classs(1040)->
	#d_mall_class{
		 mall_id		= 10,		%% 商城ID
		 class_id		= 1040,		%% 分类ID
		 is_discount 	= 1	%% 是否打折
	};
classs(2000)->
	#d_mall_class{
		 mall_id		= 20,		%% 商城ID
		 class_id		= 2000,		%% 分类ID
		 is_discount 	= 1	%% 是否打折
	};
classs(2010)->
	#d_mall_class{
		 mall_id		= 20,		%% 商城ID
		 class_id		= 2010,		%% 分类ID
		 is_discount 	= 1	%% 是否打折
	};
classs(2020)->
	#d_mall_class{
		 mall_id		= 20,		%% 商城ID
		 class_id		= 2020,		%% 分类ID
		 is_discount 	= 1	%% 是否打折
	};
classs(3010)->
	#d_mall_class{
		 mall_id		= 30,		%% 商城ID
		 class_id		= 3010,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(3020)->
	#d_mall_class{
		 mall_id		= 30,		%% 商城ID
		 class_id		= 3020,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(3030)->
	#d_mall_class{
		 mall_id		= 30,		%% 商城ID
		 class_id		= 3030,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(3040)->
	#d_mall_class{
		 mall_id		= 30,		%% 商城ID
		 class_id		= 3040,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(3050)->
	#d_mall_class{
		 mall_id		= 30,		%% 商城ID
		 class_id		= 3050,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(4010)->
	#d_mall_class{
		 mall_id		= 40,		%% 商城ID
		 class_id		= 4010,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(4020)->
	#d_mall_class{
		 mall_id		= 40,		%% 商城ID
		 class_id		= 4020,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(5010)->
	#d_mall_class{
		 mall_id		= 50,		%% 商城ID
		 class_id		= 5010,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(6010)->
	#d_mall_class{
		 mall_id		= 60,		%% 商城ID
		 class_id		= 6010,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(7010)->
	#d_mall_class{
		 mall_id		= 70,		%% 商城ID
		 class_id		= 7010,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(8010)->
	#d_mall_class{
		 mall_id		= 80,		%% 商城ID
		 class_id		= 8010,		%% 分类ID
		 is_discount 	= 0	%% 是否打折
	};
classs(_)->?null.


%% data(ID) -> 商品数据 
data(248)->
	#d_mall_goods{
		 id			= 248,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 1388,		%% 价格	
		 o_price		= 5000,		%% 原价	
		 count		= 10,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 13,		%% 扩展属性值
		 give		= {give,43266,10,0,1,1,0,0}				%% GoodsGive
	};
data(232)->
	#d_mall_goods{
		 id			= 232,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 748,		%% 价格	
		 o_price		= 2500,		%% 原价	
		 count		= 10,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 75,		%% 扩展属性值
		 give		= {give,40351,10,0,1,1,0,0}				%% GoodsGive
	};
data(7)->
	#d_mall_goods{
		 id			= 7,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1000,		%% 商城分类ID
		 currency	= 1,		%% 货币类型
		 s_price		= 10000,		%% 价格	
		 o_price		= 10000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,1001,1,0,1,1,0,0}				%% GoodsGive
	};
data(8)->
	#d_mall_goods{
		 id			= 8,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1000,		%% 商城分类ID
		 currency	= 1,		%% 货币类型
		 s_price		= 10000,		%% 价格	
		 o_price		= 10000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,3001,1,0,1,1,0,0}				%% GoodsGive
	};
data(10)->
	#d_mall_goods{
		 id			= 10,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1000,		%% 商城分类ID
		 currency	= 1,		%% 货币类型
		 s_price		= 10000,		%% 价格	
		 o_price		= 10000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,4011,1,0,1,1,0,0}				%% GoodsGive
	};
data(11)->
	#d_mall_goods{
		 id			= 11,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1000,		%% 商城分类ID
		 currency	= 1,		%% 货币类型
		 s_price		= 10000,		%% 价格	
		 o_price		= 10000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,2001,1,0,1,1,0,0}				%% GoodsGive
	};
data(12)->
	#d_mall_goods{
		 id			= 12,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1000,		%% 商城分类ID
		 currency	= 1,		%% 货币类型
		 s_price		= 10000,		%% 价格	
		 o_price		= 10000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,5011,1,0,1,1,0,0}				%% GoodsGive
	};
data(13)->
	#d_mall_goods{
		 id			= 13,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1000,		%% 商城分类ID
		 currency	= 1,		%% 货币类型
		 s_price		= 20000,		%% 价格	
		 o_price		= 20000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,6001,1,0,1,1,0,0}				%% GoodsGive
	};
data(14)->
	#d_mall_goods{
		 id			= 14,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1000,		%% 商城分类ID
		 currency	= 1,		%% 货币类型
		 s_price		= 20000,		%% 价格	
		 o_price		= 20000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,7001,1,0,1,1,0,0}				%% GoodsGive
	};
data(15)->
	#d_mall_goods{
		 id			= 15,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1000,		%% 商城分类ID
		 currency	= 1,		%% 货币类型
		 s_price		= 20000,		%% 价格	
		 o_price		= 20000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,8001,1,0,1,1,0,0}				%% GoodsGive
	};
data(51)->
	#d_mall_goods{
		 id			= 51,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33711,1,0,1,1,0,0}				%% GoodsGive
	};
data(71)->
	#d_mall_goods{
		 id			= 71,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33131,1,0,1,1,0,0}				%% GoodsGive
	};
data(69)->
	#d_mall_goods{
		 id			= 69,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33121,1,0,1,1,0,0}				%% GoodsGive
	};
data(68)->
	#d_mall_goods{
		 id			= 68,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33111,1,0,1,1,0,0}				%% GoodsGive
	};
data(67)->
	#d_mall_goods{
		 id			= 67,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33081,1,0,1,1,0,0}				%% GoodsGive
	};
data(247)->
	#d_mall_goods{
		 id			= 247,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 6998,		%% 价格	
		 o_price		= 80000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 12,		%% 扩展属性值
		 give		= {give,40010,1,0,1,1,0,0}				%% GoodsGive
	};
data(65)->
	#d_mall_goods{
		 id			= 65,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33071,1,0,1,1,0,0}				%% GoodsGive
	};
data(64)->
	#d_mall_goods{
		 id			= 64,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33061,1,0,1,1,0,0}				%% GoodsGive
	};
data(59)->
	#d_mall_goods{
		 id			= 59,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33011,1,0,1,1,0,0}				%% GoodsGive
	};
data(60)->
	#d_mall_goods{
		 id			= 60,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33021,1,0,1,1,0,0}				%% GoodsGive
	};
data(61)->
	#d_mall_goods{
		 id			= 61,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33031,1,0,1,1,0,0}				%% GoodsGive
	};
data(62)->
	#d_mall_goods{
		 id			= 62,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33041,1,0,1,1,0,0}				%% GoodsGive
	};
data(63)->
	#d_mall_goods{
		 id			= 63,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33051,1,0,1,1,0,0}				%% GoodsGive
	};
data(53)->
	#d_mall_goods{
		 id			= 53,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33001,1,0,1,1,0,0}				%% GoodsGive
	};
data(30)->
	#d_mall_goods{
		 id			= 30,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33001,1,0,1,1,0,0}				%% GoodsGive
	};
data(31)->
	#d_mall_goods{
		 id			= 31,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33111,1,0,1,1,0,0}				%% GoodsGive
	};
data(32)->
	#d_mall_goods{
		 id			= 32,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33221,1,0,1,1,0,0}				%% GoodsGive
	};
data(33)->
	#d_mall_goods{
		 id			= 33,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33331,1,0,1,1,0,0}				%% GoodsGive
	};
data(34)->
	#d_mall_goods{
		 id			= 34,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33436,1,0,1,1,0,0}				%% GoodsGive
	};
data(35)->
	#d_mall_goods{
		 id			= 35,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33491,1,0,1,1,0,0}				%% GoodsGive
	};
data(36)->
	#d_mall_goods{
		 id			= 36,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33601,1,0,1,1,0,0}				%% GoodsGive
	};
data(263)->
	#d_mall_goods{
		 id			= 263,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 15,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 80,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37501,1,0,1,1,0,0}				%% GoodsGive
	};
data(260)->
	#d_mall_goods{
		 id			= 260,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 68,		%% 价格	
		 o_price		= 500,		%% 原价	
		 count		= 5,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 3,		%% 扩展属性
		 ext_v		= 300,		%% 扩展属性值
		 give		= {give,43083,5,0,1,1,0,0}				%% GoodsGive
	};
data(259)->
	#d_mall_goods{
		 id			= 259,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 18,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 3,		%% 扩展属性
		 ext_v		= 1000,		%% 扩展属性值
		 give		= {give,40351,1,0,1,1,0,0}				%% GoodsGive
	};
data(258)->
	#d_mall_goods{
		 id			= 258,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 68,		%% 价格	
		 o_price		= 250,		%% 原价	
		 count		= 5,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 3,		%% 扩展属性
		 ext_v		= 300,		%% 扩展属性值
		 give		= {give,45001,5,0,1,1,0,0}				%% GoodsGive
	};
data(257)->
	#d_mall_goods{
		 id			= 257,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 178,		%% 价格	
		 o_price		= 1250,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 3,		%% 扩展属性
		 ext_v		= 300,		%% 扩展属性值
		 give		= {give,40007,1,0,1,1,0,0}				%% GoodsGive
	};
data(256)->
	#d_mall_goods{
		 id			= 256,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 38,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 3,		%% 扩展属性
		 ext_v		= 1000,		%% 扩展属性值
		 give		= {give,43221,1,0,1,1,0,0}				%% GoodsGive
	};
data(252)->
	#d_mall_goods{
		 id			= 252,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 198,		%% 价格	
		 o_price		= 1250,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 40,		%% 扩展属性值
		 give		= {give,40007,1,0,1,1,0,0}				%% GoodsGive
	};
data(251)->
	#d_mall_goods{
		 id			= 251,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 38,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 40,		%% 扩展属性值
		 give		= {give,40006,1,0,1,1,0,0}				%% GoodsGive
	};
data(250)->
	#d_mall_goods{
		 id			= 250,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 8,		%% 价格	
		 o_price		= 80,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 40,		%% 扩展属性值
		 give		= {give,40021,1,0,1,1,0,0}				%% GoodsGive
	};
data(249)->
	#d_mall_goods{
		 id			= 249,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 1088,		%% 价格	
		 o_price		= 10000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 14,		%% 扩展属性值
		 give		= {give,43084,1,0,1,1,0,0}				%% GoodsGive
	};
data(50)->
	#d_mall_goods{
		 id			= 50,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33656,1,0,1,1,0,0}				%% GoodsGive
	};
data(52)->
	#d_mall_goods{
		 id			= 52,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33766,1,0,1,1,0,0}				%% GoodsGive
	};
data(72)->
	#d_mall_goods{
		 id			= 72,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33141,1,0,1,1,0,0}				%% GoodsGive
	};
data(73)->
	#d_mall_goods{
		 id			= 73,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33151,1,0,1,1,0,0}				%% GoodsGive
	};
data(74)->
	#d_mall_goods{
		 id			= 74,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33161,1,0,1,1,0,0}				%% GoodsGive
	};
data(75)->
	#d_mall_goods{
		 id			= 75,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33171,1,0,1,1,0,0}				%% GoodsGive
	};
data(76)->
	#d_mall_goods{
		 id			= 76,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33181,1,0,1,1,0,0}				%% GoodsGive
	};
data(77)->
	#d_mall_goods{
		 id			= 77,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33191,1,0,1,1,0,0}				%% GoodsGive
	};
data(78)->
	#d_mall_goods{
		 id			= 78,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33221,1,0,1,1,0,0}				%% GoodsGive
	};
data(79)->
	#d_mall_goods{
		 id			= 79,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33231,1,0,1,1,0,0}				%% GoodsGive
	};
data(80)->
	#d_mall_goods{
		 id			= 80,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33241,1,0,1,1,0,0}				%% GoodsGive
	};
data(81)->
	#d_mall_goods{
		 id			= 81,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33251,1,0,1,1,0,0}				%% GoodsGive
	};
data(82)->
	#d_mall_goods{
		 id			= 82,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33261,1,0,1,1,0,0}				%% GoodsGive
	};
data(83)->
	#d_mall_goods{
		 id			= 83,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33271,1,0,1,1,0,0}				%% GoodsGive
	};
data(84)->
	#d_mall_goods{
		 id			= 84,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33281,1,0,1,1,0,0}				%% GoodsGive
	};
data(85)->
	#d_mall_goods{
		 id			= 85,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33291,1,0,1,1,0,0}				%% GoodsGive
	};
data(86)->
	#d_mall_goods{
		 id			= 86,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33301,1,0,1,1,0,0}				%% GoodsGive
	};
data(87)->
	#d_mall_goods{
		 id			= 87,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33331,1,0,1,1,0,0}				%% GoodsGive
	};
data(88)->
	#d_mall_goods{
		 id			= 88,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33341,1,0,1,1,0,0}				%% GoodsGive
	};
data(89)->
	#d_mall_goods{
		 id			= 89,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33351,1,0,1,1,0,0}				%% GoodsGive
	};
data(90)->
	#d_mall_goods{
		 id			= 90,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33361,1,0,1,1,0,0}				%% GoodsGive
	};
data(91)->
	#d_mall_goods{
		 id			= 91,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33371,1,0,1,1,0,0}				%% GoodsGive
	};
data(92)->
	#d_mall_goods{
		 id			= 92,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33381,1,0,1,1,0,0}				%% GoodsGive
	};
data(93)->
	#d_mall_goods{
		 id			= 93,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33391,1,0,1,1,0,0}				%% GoodsGive
	};
data(94)->
	#d_mall_goods{
		 id			= 94,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33401,1,0,1,1,0,0}				%% GoodsGive
	};
data(95)->
	#d_mall_goods{
		 id			= 95,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33411,1,0,1,1,0,0}				%% GoodsGive
	};
data(96)->
	#d_mall_goods{
		 id			= 96,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33436,1,0,1,1,0,0}				%% GoodsGive
	};
data(97)->
	#d_mall_goods{
		 id			= 97,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33441,1,0,1,1,0,0}				%% GoodsGive
	};
data(98)->
	#d_mall_goods{
		 id			= 98,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33446,1,0,1,1,0,0}				%% GoodsGive
	};
data(99)->
	#d_mall_goods{
		 id			= 99,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33451,1,0,1,1,0,0}				%% GoodsGive
	};
data(100)->
	#d_mall_goods{
		 id			= 100,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33456,1,0,1,1,0,0}				%% GoodsGive
	};
data(101)->
	#d_mall_goods{
		 id			= 101,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33461,1,0,1,1,0,0}				%% GoodsGive
	};
data(102)->
	#d_mall_goods{
		 id			= 102,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33466,1,0,1,1,0,0}				%% GoodsGive
	};
data(103)->
	#d_mall_goods{
		 id			= 103,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33471,1,0,1,1,0,0}				%% GoodsGive
	};
data(104)->
	#d_mall_goods{
		 id			= 104,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33476,1,0,1,1,0,0}				%% GoodsGive
	};
data(105)->
	#d_mall_goods{
		 id			= 105,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33491,1,0,1,1,0,0}				%% GoodsGive
	};
data(106)->
	#d_mall_goods{
		 id			= 106,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33496,1,0,1,1,0,0}				%% GoodsGive
	};
data(107)->
	#d_mall_goods{
		 id			= 107,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33501,1,0,1,1,0,0}				%% GoodsGive
	};
data(108)->
	#d_mall_goods{
		 id			= 108,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33506,1,0,1,1,0,0}				%% GoodsGive
	};
data(109)->
	#d_mall_goods{
		 id			= 109,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33511,1,0,1,1,0,0}				%% GoodsGive
	};
data(110)->
	#d_mall_goods{
		 id			= 110,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33516,1,0,1,1,0,0}				%% GoodsGive
	};
data(111)->
	#d_mall_goods{
		 id			= 111,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33521,1,0,1,1,0,0}				%% GoodsGive
	};
data(112)->
	#d_mall_goods{
		 id			= 112,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33526,1,0,1,1,0,0}				%% GoodsGive
	};
data(113)->
	#d_mall_goods{
		 id			= 113,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33531,1,0,1,1,0,0}				%% GoodsGive
	};
data(114)->
	#d_mall_goods{
		 id			= 114,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33546,1,0,1,1,0,0}				%% GoodsGive
	};
data(115)->
	#d_mall_goods{
		 id			= 115,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33551,1,0,1,1,0,0}				%% GoodsGive
	};
data(246)->
	#d_mall_goods{
		 id			= 246,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 598,		%% 价格	
		 o_price		= 5000,		%% 原价	
		 count		= 50,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 11,		%% 扩展属性值
		 give		= {give,43083,50,0,1,1,0,0}				%% GoodsGive
	};
data(117)->
	#d_mall_goods{
		 id			= 117,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33556,1,0,1,1,0,0}				%% GoodsGive
	};
data(118)->
	#d_mall_goods{
		 id			= 118,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33561,1,0,1,1,0,0}				%% GoodsGive
	};
data(119)->
	#d_mall_goods{
		 id			= 119,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33566,1,0,1,1,0,0}				%% GoodsGive
	};
data(120)->
	#d_mall_goods{
		 id			= 120,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33571,1,0,1,1,0,0}				%% GoodsGive
	};
data(231)->
	#d_mall_goods{
		 id			= 231,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 798,		%% 价格	
		 o_price		= 2500,		%% 原价	
		 count		= 50,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 70,		%% 扩展属性值
		 give		= {give,45001,50,0,1,1,0,0}				%% GoodsGive
	};
data(122)->
	#d_mall_goods{
		 id			= 122,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33576,1,0,1,1,0,0}				%% GoodsGive
	};
data(123)->
	#d_mall_goods{
		 id			= 123,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33581,1,0,1,1,0,0}				%% GoodsGive
	};
data(124)->
	#d_mall_goods{
		 id			= 124,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33586,1,0,1,1,0,0}				%% GoodsGive
	};
data(125)->
	#d_mall_goods{
		 id			= 125,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33656,1,0,1,1,0,0}				%% GoodsGive
	};
data(126)->
	#d_mall_goods{
		 id			= 126,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33661,1,0,1,1,0,0}				%% GoodsGive
	};
data(127)->
	#d_mall_goods{
		 id			= 127,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33666,1,0,1,1,0,0}				%% GoodsGive
	};
data(128)->
	#d_mall_goods{
		 id			= 128,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33671,1,0,1,1,0,0}				%% GoodsGive
	};
data(230)->
	#d_mall_goods{
		 id			= 230,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 228,		%% 价格	
		 o_price		= 1000,		%% 原价	
		 count		= 10,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 65,		%% 扩展属性值
		 give		= {give,43083,10,0,1,1,0,0}				%% GoodsGive
	};
data(130)->
	#d_mall_goods{
		 id			= 130,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33676,1,0,1,1,0,0}				%% GoodsGive
	};
data(131)->
	#d_mall_goods{
		 id			= 131,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33681,1,0,1,1,0,0}				%% GoodsGive
	};
data(132)->
	#d_mall_goods{
		 id			= 132,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33686,1,0,1,1,0,0}				%% GoodsGive
	};
data(133)->
	#d_mall_goods{
		 id			= 133,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33691,1,0,1,1,0,0}				%% GoodsGive
	};
data(134)->
	#d_mall_goods{
		 id			= 134,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33696,1,0,1,1,0,0}				%% GoodsGive
	};
data(135)->
	#d_mall_goods{
		 id			= 135,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33766,1,0,1,1,0,0}				%% GoodsGive
	};
data(136)->
	#d_mall_goods{
		 id			= 136,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33771,1,0,1,1,0,0}				%% GoodsGive
	};
data(137)->
	#d_mall_goods{
		 id			= 137,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33776,1,0,1,1,0,0}				%% GoodsGive
	};
data(229)->
	#d_mall_goods{
		 id			= 229,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 428,		%% 价格	
		 o_price		= 5000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 60,		%% 扩展属性值
		 give		= {give,52041,1,0,1,1,0,0}				%% GoodsGive
	};
data(139)->
	#d_mall_goods{
		 id			= 139,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33781,1,0,1,1,0,0}				%% GoodsGive
	};
data(140)->
	#d_mall_goods{
		 id			= 140,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33786,1,0,1,1,0,0}				%% GoodsGive
	};
data(245)->
	#d_mall_goods{
		 id			= 245,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 398,		%% 价格	
		 o_price		= 5000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 10,		%% 扩展属性值
		 give		= {give,52041,1,0,1,1,0,0}				%% GoodsGive
	};
data(142)->
	#d_mall_goods{
		 id			= 142,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33791,1,0,1,1,0,0}				%% GoodsGive
	};
data(143)->
	#d_mall_goods{
		 id			= 143,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33796,1,0,1,1,0,0}				%% GoodsGive
	};
data(144)->
	#d_mall_goods{
		 id			= 144,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33801,1,0,1,1,0,0}				%% GoodsGive
	};
data(253)->
	#d_mall_goods{
		 id			= 253,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 38,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 2,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 3,		%% 扩展属性
		 ext_v		= 1000,		%% 扩展属性值
		 give		= {give,43083,2,0,1,1,0,0}				%% GoodsGive
	};
data(146)->
	#d_mall_goods{
		 id			= 146,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33806,1,0,1,1,0,0}				%% GoodsGive
	};
data(147)->
	#d_mall_goods{
		 id			= 147,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33821,1,0,1,1,0,0}				%% GoodsGive
	};
data(148)->
	#d_mall_goods{
		 id			= 148,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33826,1,0,1,1,0,0}				%% GoodsGive
	};
data(149)->
	#d_mall_goods{
		 id			= 149,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33831,1,0,1,1,0,0}				%% GoodsGive
	};
data(244)->
	#d_mall_goods{
		 id			= 244,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 1888,		%% 价格	
		 o_price		= 20000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 9,		%% 扩展属性值
		 give		= {give,40009,1,0,1,1,0,0}				%% GoodsGive
	};
data(151)->
	#d_mall_goods{
		 id			= 151,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33836,1,0,1,1,0,0}				%% GoodsGive
	};
data(152)->
	#d_mall_goods{
		 id			= 152,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33841,1,0,1,1,0,0}				%% GoodsGive
	};
data(153)->
	#d_mall_goods{
		 id			= 153,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33846,1,0,1,1,0,0}				%% GoodsGive
	};
data(154)->
	#d_mall_goods{
		 id			= 154,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33851,1,0,1,1,0,0}				%% GoodsGive
	};
data(155)->
	#d_mall_goods{
		 id			= 155,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33856,1,0,1,1,0,0}				%% GoodsGive
	};
data(156)->
	#d_mall_goods{
		 id			= 156,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33861,1,0,1,1,0,0}				%% GoodsGive
	};
data(157)->
	#d_mall_goods{
		 id			= 157,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2,		%% 价格	
		 o_price		= 2,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33876,1,0,1,1,0,0}				%% GoodsGive
	};
data(158)->
	#d_mall_goods{
		 id			= 158,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 5,		%% 价格	
		 o_price		= 5,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33881,1,0,1,1,0,0}				%% GoodsGive
	};
data(159)->
	#d_mall_goods{
		 id			= 159,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 10,		%% 价格	
		 o_price		= 10,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33886,1,0,1,1,0,0}				%% GoodsGive
	};
data(160)->
	#d_mall_goods{
		 id			= 160,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 50,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33891,1,0,1,1,0,0}				%% GoodsGive
	};
data(254)->
	#d_mall_goods{
		 id			= 254,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 18,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 10,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 3,		%% 扩展属性
		 ext_v		= 1000,		%% 扩展属性值
		 give		= {give,43261,10,0,1,1,0,0}				%% GoodsGive
	};
data(162)->
	#d_mall_goods{
		 id			= 162,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33896,1,0,1,1,0,0}				%% GoodsGive
	};
data(255)->
	#d_mall_goods{
		 id			= 255,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 198,		%% 价格	
		 o_price		= 2500,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 3,		%% 扩展属性
		 ext_v		= 1000,		%% 扩展属性值
		 give		= {give,52036,1,0,1,1,0,0}				%% GoodsGive
	};
data(164)->
	#d_mall_goods{
		 id			= 164,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33901,1,0,1,1,0,0}				%% GoodsGive
	};
data(165)->
	#d_mall_goods{
		 id			= 165,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 300,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33906,1,0,1,1,0,0}				%% GoodsGive
	};
data(166)->
	#d_mall_goods{
		 id			= 166,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 400,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33911,1,0,1,1,0,0}				%% GoodsGive
	};
data(167)->
	#d_mall_goods{
		 id			= 167,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 800,		%% 价格	
		 o_price		= 800,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,33916,1,0,1,1,0,0}				%% GoodsGive
	};
data(228)->
	#d_mall_goods{
		 id			= 228,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 168,		%% 价格	
		 o_price		= 500,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 55,		%% 扩展属性值
		 give		= {give,43266,1,0,1,1,0,0}				%% GoodsGive
	};
data(227)->
	#d_mall_goods{
		 id			= 227,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 168,		%% 价格	
		 o_price		= 500,		%% 原价	
		 count		= 10,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 50,		%% 扩展属性值
		 give		= {give,45001,10,0,1,1,0,0}				%% GoodsGive
	};
data(226)->
	#d_mall_goods{
		 id			= 226,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 248,		%% 价格	
		 o_price		= 2500,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 45,		%% 扩展属性值
		 give		= {give,52036,1,0,1,1,0,0}				%% GoodsGive
	};
data(225)->
	#d_mall_goods{
		 id			= 225,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 48,		%% 价格	
		 o_price		= 300,		%% 原价	
		 count		= 3,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 35,		%% 扩展属性值
		 give		= {give,43083,3,0,1,1,0,0}				%% GoodsGive
	};
data(224)->
	#d_mall_goods{
		 id			= 224,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 168,		%% 价格	
		 o_price		= 600,		%% 原价	
		 count		= 3,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 30,		%% 扩展属性值
		 give		= {give,43221,3,0,1,1,0,0}				%% GoodsGive
	};
data(223)->
	#d_mall_goods{
		 id			= 223,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 15,		%% 价格	
		 o_price		= 50,		%% 原价	
		 count		= 10,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 25,		%% 扩展属性值
		 give		= {give,43261,10,0,1,1,0,0}				%% GoodsGive
	};
data(222)->
	#d_mall_goods{
		 id			= 222,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2000,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 28,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 1,		%% 扩展属性
		 ext_v		= 20,		%% 扩展属性值
		 give		= {give,43083,1,0,1,1,0,0}				%% GoodsGive
	};
data(243)->
	#d_mall_goods{
		 id			= 243,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 498,		%% 价格	
		 o_price		= 5000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 8,		%% 扩展属性值
		 give		= {give,40008,1,0,1,1,0,0}				%% GoodsGive
	};
data(242)->
	#d_mall_goods{
		 id			= 242,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 398,		%% 价格	
		 o_price		= 1500,		%% 原价	
		 count		= 3,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 7,		%% 扩展属性值
		 give		= {give,43266,3,0,1,1,0,0}				%% GoodsGive
	};
data(241)->
	#d_mall_goods{
		 id			= 241,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 268,		%% 价格	
		 o_price		= 1000,		%% 原价	
		 count		= 20,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 6,		%% 扩展属性值
		 give		= {give,45001,20,0,1,1,0,0}				%% GoodsGive
	};
data(240)->
	#d_mall_goods{
		 id			= 240,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 148,		%% 价格	
		 o_price		= 1000,		%% 原价	
		 count		= 10,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 5,		%% 扩展属性值
		 give		= {give,43083,10,0,1,1,0,0}				%% GoodsGive
	};
data(239)->
	#d_mall_goods{
		 id			= 239,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 98,		%% 价格	
		 o_price		= 600,		%% 原价	
		 count		= 3,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 4,		%% 扩展属性值
		 give		= {give,43221,3,0,1,1,0,0}				%% GoodsGive
	};
data(238)->
	#d_mall_goods{
		 id			= 238,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 228,		%% 价格	
		 o_price		= 2500,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 4,		%% 扩展属性值
		 give		= {give,52036,1,0,1,1,0,0}				%% GoodsGive
	};
data(264)->
	#d_mall_goods{
		 id			= 264,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 160,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37506,1,0,1,1,0,0}				%% GoodsGive
	};
data(236)->
	#d_mall_goods{
		 id			= 236,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 68,		%% 价格	
		 o_price		= 500,		%% 原价	
		 count		= 5,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 3,		%% 扩展属性值
		 give		= {give,43083,5,0,1,1,0,0}				%% GoodsGive
	};
data(235)->
	#d_mall_goods{
		 id			= 235,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 78,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 2,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 2,		%% 扩展属性值
		 give		= {give,43221,2,0,1,1,0,0}				%% GoodsGive
	};
data(234)->
	#d_mall_goods{
		 id			= 234,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 20,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 20,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 2,		%% 扩展属性值
		 give		= {give,43261,20,0,1,1,0,0}				%% GoodsGive
	};
data(233)->
	#d_mall_goods{
		 id			= 233,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2010,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 38,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 2,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 2,		%% 扩展属性
		 ext_v		= 1,		%% 扩展属性值
		 give		= {give,43083,2,0,1,1,0,0}				%% GoodsGive
	};
data(198)->
	#d_mall_goods{
		 id			= 198,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 15,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 2,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,38001,1,0,1,1,0,0}				%% GoodsGive
	};
data(199)->
	#d_mall_goods{
		 id			= 199,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 15,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 6,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,38006,1,0,1,1,0,0}				%% GoodsGive
	};
data(200)->
	#d_mall_goods{
		 id			= 200,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 15,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 18,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,38011,1,0,1,1,0,0}				%% GoodsGive
	};
data(201)->
	#d_mall_goods{
		 id			= 201,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 15,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 54,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,38016,1,0,1,1,0,0}				%% GoodsGive
	};
data(202)->
	#d_mall_goods{
		 id			= 202,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 15,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 162,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,38021,1,0,1,1,0,0}				%% GoodsGive
	};
data(203)->
	#d_mall_goods{
		 id			= 203,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 15,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 20,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,39001,1,0,1,1,0,0}				%% GoodsGive
	};
data(204)->
	#d_mall_goods{
		 id			= 204,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 15,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 60,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,39006,1,0,1,1,0,0}				%% GoodsGive
	};
data(205)->
	#d_mall_goods{
		 id			= 205,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 15,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 180,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,39011,1,0,1,1,0,0}				%% GoodsGive
	};
data(206)->
	#d_mall_goods{
		 id			= 206,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1030,		%% 商城分类ID
		 currency	= 15,		%% 货币类型
		 s_price		= 0,		%% 价格	
		 o_price		= 0,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 38501,	%% 兑换所需物品
		 swap_count	= 540,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,39016,1,0,1,1,0,0}				%% GoodsGive
	};
data(207)->
	#d_mall_goods{
		 id			= 207,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 3,		%% 价格	
		 o_price		= 3,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,38001,1,0,1,1,0,0}				%% GoodsGive
	};
data(208)->
	#d_mall_goods{
		 id			= 208,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 9,		%% 价格	
		 o_price		= 9,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,38006,1,0,1,1,0,0}				%% GoodsGive
	};
data(209)->
	#d_mall_goods{
		 id			= 209,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 27,		%% 价格	
		 o_price		= 27,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,38011,1,0,1,1,0,0}				%% GoodsGive
	};
data(210)->
	#d_mall_goods{
		 id			= 210,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 81,		%% 价格	
		 o_price		= 81,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,38016,1,0,1,1,0,0}				%% GoodsGive
	};
data(211)->
	#d_mall_goods{
		 id			= 211,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 243,		%% 价格	
		 o_price		= 243,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,38021,1,0,1,1,0,0}				%% GoodsGive
	};
data(212)->
	#d_mall_goods{
		 id			= 212,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 125,		%% 价格	
		 o_price		= 125,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37501,1,0,1,1,0,0}				%% GoodsGive
	};
data(213)->
	#d_mall_goods{
		 id			= 213,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 250,		%% 价格	
		 o_price		= 250,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37506,1,0,1,1,0,0}				%% GoodsGive
	};
data(214)->
	#d_mall_goods{
		 id			= 214,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 500,		%% 价格	
		 o_price		= 500,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37511,1,0,1,1,0,0}				%% GoodsGive
	};
data(215)->
	#d_mall_goods{
		 id			= 215,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 1000,		%% 价格	
		 o_price		= 1000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37516,1,0,1,1,0,0}				%% GoodsGive
	};
data(216)->
	#d_mall_goods{
		 id			= 216,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 2000,		%% 价格	
		 o_price		= 2000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37521,1,0,1,1,0,0}				%% GoodsGive
	};
data(217)->
	#d_mall_goods{
		 id			= 217,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 100,		%% 价格	
		 o_price		= 100,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37001,1,0,1,1,0,0}				%% GoodsGive
	};
data(218)->
	#d_mall_goods{
		 id			= 218,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 200,		%% 价格	
		 o_price		= 200,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37006,1,0,1,1,0,0}				%% GoodsGive
	};
data(219)->
	#d_mall_goods{
		 id			= 219,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 500,		%% 价格	
		 o_price		= 500,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37011,1,0,1,1,0,0}				%% GoodsGive
	};
data(220)->
	#d_mall_goods{
		 id			= 220,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 1000,		%% 价格	
		 o_price		= 1000,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37016,1,0,1,1,0,0}				%% GoodsGive
	};
data(221)->
	#d_mall_goods{
		 id			= 221,		%% ID
		 mall_id		= 10,		%% 商城ID
		 class_id	= 1040,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 1500,		%% 价格	
		 o_price		= 1500,		%% 原价	
		 count		= 1,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 0,		%% 扩展属性
		 ext_v		= 0,		%% 扩展属性值
		 give		= {give,37021,1,0,1,1,0,0}				%% GoodsGive
	};
data(262)->
	#d_mall_goods{
		 id			= 262,		%% ID
		 mall_id		= 20,		%% 商城ID
		 class_id	= 2020,		%% 商城分类ID
		 currency	= 2,		%% 货币类型
		 s_price		= 58,		%% 价格	
		 o_price		= 400,		%% 原价	
		 count		= 2,		%% 数量	
		 swap_goods_id	= 0,	%% 兑换所需物品
		 swap_count	= 1,	%% 兑换所需物品数
		 sort		= 0,			%% 列表排序 
		 quick		= 0,		%% 是否快速购买
		 limit_all	= 0,	%% 每天的总限量
		 limit		= 0,		%% 每个每天的限量
		 lv			= 0,			%% 大于这个等级才显示和购卖
		 ext_k		= 3,		%% 扩展属性
		 ext_v		= 800,		%% 扩展属性值
		 give		= {give,43221,2,0,1,1,0,0}				%% GoodsGive
	};
data(_)->?null.


%% data_ids(ClassID) -> Class数据 
data_ids(2010)->[248,247,249,246,245,244,243,242,241,240,239,238,236,235,234,233];
data_ids(2000)->[232,252,251,250,231,230,229,228,227,226,225,224,223,222];
data_ids(1000)->[7,8,10,11,12,13,14,15];
data_ids(1020)->[51,30,31,32,33,34,35,36,50,52];
data_ids(1010)->[71,69,68,67,65,64,59,60,61,62,63,53,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,118,119,120,122,123,124,125,126,127,128,130,131,132,133,134,135,136,137,139,140,142,143,144,146,147,148,149,151,152,153,154,155,156,157,158,159,160,162,164,165,166,167];
data_ids(1030)->[263,264,198,199,200,201,202,203,204,205,206];
data_ids(2020)->[260,259,258,257,256,253,254,255,262];
data_ids(1040)->[207,208,209,210,211,212,213,214,215,216,217,218,219,220,221];
data_ids(_)->[].

