-module(data_sales_total).
-include("../include/comm.hrl").

-export([get/1,get_ids/0]).

% 促销活动总体配置;
% 时间类型：1、自然时间（月日时分）；2、开服天数；3、每周星期几；4、每月几号；5、一直生效;
% %% 生效时段;
% %%     []:一直生效
                %%     [{StartM,StartD,StartH,StartI,StartS,EndM,EndD,EndH,EndI,EndS},..]:  自然时间{月,日,时,分,秒,月,日,时,分,秒}
                %%     [{open,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS},..]:  开服时间(开服当天算第一天){开服天数,时,分,秒,开服天数,时,分,秒}  
                %%     [{week,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS},..]:  每周活动(1-7){星期几,时,分,秒,星期几,时,分,秒}  
                %%     [{month,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS},..]: 每月活动(1-31){几号,时,分,秒,几号,时,分,秒};
% 领取后是否消失：0->领取后不消失，1->全部领取后消失;
% ;
% ;
% 1101;
% 301;
% 401
get(101)->
	#d_sales_total{
		id           = 101,             %% 活动ID
		is_have      = 1,               %% 是否存在
		valid        = 1,               %% 是否有效
		type_getshow = 1,               %% 领取后是否消失
		time         = [],              %% 生效时间段
		s_id         = 0,               %% 服务器ID
		type         = 1               %% 活动类型
	};
get(201)->
	#d_sales_total{
		id           = 201,             %% 活动ID
		is_have      = 1,               %% 是否存在
		valid        = 1,               %% 是否有效
		type_getshow = 1,               %% 领取后是否消失
		time         = [],              %% 生效时间段
		s_id         = 0,               %% 服务器ID
		type         = 2               %% 活动类型
	};
get(501)->
	#d_sales_total{
		id           = 501,             %% 活动ID
		is_have      = 1,               %% 是否存在
		valid        = 1,               %% 是否有效
		type_getshow = 1,               %% 领取后是否消失
		time         = [{open,1,0,0,0,10,23,59,59}],%% 生效时间段
		s_id         = 0,               %% 服务器ID
		type         = 4               %% 活动类型
	};
get(601)->
	#d_sales_total{
		id           = 601,             %% 活动ID
		is_have      = 1,               %% 是否存在
		valid        = 1,               %% 是否有效
		type_getshow = 1,               %% 领取后是否消失
		time         = [{open,1,0,0,0,14,23,59,59}],%% 生效时间段
		s_id         = 0,               %% 服务器ID
		type         = 5               %% 活动类型
	};
get(701)->
	#d_sales_total{
		id           = 701,             %% 活动ID
		is_have      = 1,               %% 是否存在
		valid        = 1,               %% 是否有效
		type_getshow = 1,               %% 领取后是否消失
		time         = [{open,1,0,0,0,14,23,59,59}],%% 生效时间段
		s_id         = 0,               %% 服务器ID
		type         = 6               %% 活动类型
	};
get(801)->
	#d_sales_total{
		id           = 801,             %% 活动ID
		is_have      = 1,               %% 是否存在
		valid        = 1,               %% 是否有效
		type_getshow = 1,               %% 领取后是否消失
		time         = [{open,1,0,0,0,14,23,59,59}],%% 生效时间段
		s_id         = 0,               %% 服务器ID
		type         = 7               %% 活动类型
	};
get(901)->
	#d_sales_total{
		id           = 901,             %% 活动ID
		is_have      = 1,               %% 是否存在
		valid        = 1,               %% 是否有效
		type_getshow = 1,               %% 领取后是否消失
		time         = [{open,1,0,0,0,14,23,59,59}],%% 生效时间段
		s_id         = 0,               %% 服务器ID
		type         = 8               %% 活动类型
	};
get(1001)->
	#d_sales_total{
		id           = 1001,            %% 活动ID
		is_have      = 1,               %% 是否存在
		valid        = 1,               %% 是否有效
		type_getshow = 1,               %% 领取后是否消失
		time         = [{open,1,0,0,0,14,23,59,59}],%% 生效时间段
		s_id         = 0,               %% 服务器ID
		type         = 9               %% 活动类型
	};
get(_)-> ?null.


%% 集合;
get_ids()->[101,201,501,601,701,801,901,1001].

