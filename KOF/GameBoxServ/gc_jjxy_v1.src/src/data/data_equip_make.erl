-module(data_equip_make).
-include("../include/comm.hrl").

-export([get/1]).

% 
get(1001)->
	#d_equip_make{
		goods_id     = 1001,            %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=1011,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(1011)->
	#d_equip_make{
		goods_id     = 1011,            %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=1021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(1021)->
	#d_equip_make{
		goods_id     = 1021,            %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=1031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(1031)->
	#d_equip_make{
		goods_id     = 1031,            %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=1041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(2001)->
	#d_equip_make{
		goods_id     = 2001,            %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=2011,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(2011)->
	#d_equip_make{
		goods_id     = 2011,            %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=2021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(2021)->
	#d_equip_make{
		goods_id     = 2021,            %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=2031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(2031)->
	#d_equip_make{
		goods_id     = 2031,            %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=2041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(3001)->
	#d_equip_make{
		goods_id     = 3001,            %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=3011,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(3011)->
	#d_equip_make{
		goods_id     = 3011,            %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=3021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(3021)->
	#d_equip_make{
		goods_id     = 3021,            %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=3031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(3031)->
	#d_equip_make{
		goods_id     = 3031,            %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=3041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(4011)->
	#d_equip_make{
		goods_id     = 4011,            %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=4021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(4021)->
	#d_equip_make{
		goods_id     = 4021,            %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=4031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(4031)->
	#d_equip_make{
		goods_id     = 4031,            %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=4041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(4041)->
	#d_equip_make{
		goods_id     = 4041,            %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=4051,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(5011)->
	#d_equip_make{
		goods_id     = 5011,            %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=5021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(5021)->
	#d_equip_make{
		goods_id     = 5021,            %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=5031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(5031)->
	#d_equip_make{
		goods_id     = 5031,            %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=5041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(5041)->
	#d_equip_make{
		goods_id     = 5041,            %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=5051,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(6001)->
	#d_equip_make{
		goods_id     = 6001,            %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=6011,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(6011)->
	#d_equip_make{
		goods_id     = 6011,            %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=6021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(6021)->
	#d_equip_make{
		goods_id     = 6021,            %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=6031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(6031)->
	#d_equip_make{
		goods_id     = 6031,            %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=6041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(7001)->
	#d_equip_make{
		goods_id     = 7001,            %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=7011,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(7011)->
	#d_equip_make{
		goods_id     = 7011,            %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=7021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(7021)->
	#d_equip_make{
		goods_id     = 7021,            %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=7031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(7031)->
	#d_equip_make{
		goods_id     = 7031,            %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=7041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(8001)->
	#d_equip_make{
		goods_id     = 8001,            %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=8011,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(8011)->
	#d_equip_make{
		goods_id     = 8011,            %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=8021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(8021)->
	#d_equip_make{
		goods_id     = 8021,            %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=8031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(8031)->
	#d_equip_make{
		goods_id     = 8031,            %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=8041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(9001)->
	#d_equip_make{
		goods_id     = 9001,            %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=9011,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(9011)->
	#d_equip_make{
		goods_id     = 9011,            %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=9021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(9021)->
	#d_equip_make{
		goods_id     = 9021,            %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=9031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(9031)->
	#d_equip_make{
		goods_id     = 9031,            %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=9041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(10001)->
	#d_equip_make{
		goods_id     = 10001,           %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=10011,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(10011)->
	#d_equip_make{
		goods_id     = 10011,           %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=10021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(10021)->
	#d_equip_make{
		goods_id     = 10021,           %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=10031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(10031)->
	#d_equip_make{
		goods_id     = 10031,           %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=10041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(11001)->
	#d_equip_make{
		goods_id     = 11001,           %% 打造物品ID
		str_need     = 20,              %% 所需强化等级
		lv_last      = 10,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=11011,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(11011)->
	#d_equip_make{
		goods_id     = 11011,           %% 打造物品ID
		str_need     = 40,              %% 所需强化等级
		lv_last      = 30,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=11021,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(11021)->
	#d_equip_make{
		goods_id     = 11021,           %% 打造物品ID
		str_need     = 60,              %% 所需强化等级
		lv_last      = 50,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=11031,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(11031)->
	#d_equip_make{
		goods_id     = 11031,           %% 打造物品ID
		str_need     = 80,              %% 所需强化等级
		lv_last      = 70,              %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=11041,lv=0,item1=0,count1=0,item2=0,count2=0,item3=0,count3=0,ct=1,cv=0}
	};
get(13001)->
	#d_equip_make{
		goods_id     = 13001,           %% 打造物品ID
		str_need     = 0,               %% 所需强化等级
		lv_last      = 0,               %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=13021,lv=0,item1=39001,count1=2,item2=0,count2=0,item3=0,count3=0,ct=1,cv=30000}
	};
get(13021)->
	#d_equip_make{
		goods_id     = 13021,           %% 打造物品ID
		str_need     = 0,               %% 所需强化等级
		lv_last      = 0,               %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=13041,lv=0,item1=39006,count1=3,item2=0,count2=0,item3=0,count3=0,ct=1,cv=60000}
	};
get(13041)->
	#d_equip_make{
		goods_id     = 13041,           %% 打造物品ID
		str_need     = 0,               %% 所需强化等级
		lv_last      = 0,               %% 强化后等级
		lv_last2     = 0,               %% 打造后强化等级
		%% 属性#make1{} 
		make1 = #d_make{goods=13061,lv=0,item1=39011,count1=4,item2=0,count2=0,item3=0,count3=0,ct=1,cv=100000}
	};
get(_)->?null.
