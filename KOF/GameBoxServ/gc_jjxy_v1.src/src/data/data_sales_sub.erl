-module(data_sales_sub).
-include("../include/comm.hrl").

-export([get/1,get_ids/0]).

% 促销活动阶段配置;
% ;
% ;
% ;
% ;
% ;
% ;
% ;
% ;
% ;
% ;
% ;
% ;
% ;
% ;
% ;
% ;
% 
get(1011)->
	#d_sales_sub{
		id           = 101,             %% 活动ID
		id_sub       = 1011,            %% id_sub
		cid          = [],              %% 平台id
		value        = 1,               %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{49001,1},{43021,5},{43211,5},{53001,1}]%% 奖励1
	};
get(2011)->
	#d_sales_sub{
		id           = 201,             %% 活动ID
		id_sub       = 2011,            %% id_sub
		cid          = [],              %% 平台id
		value        = 1,               %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{43021,5},{43211,5}]%% 奖励1
	};
get(3011)->
	#d_sales_sub{
		id           = 301,             %% 活动ID
		id_sub       = 3011,            %% id_sub
		cid          = [],              %% 平台id
		value        = {500,999},       %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{1001,1},{2001,1},{3001,1}]%% 奖励1
	};
get(3012)->
	#d_sales_sub{
		id           = 301,             %% 活动ID
		id_sub       = 3012,            %% id_sub
		cid          = [],              %% 平台id
		value        = {1000,2999},     %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{4011,1},{2001,1},{3001,1}]%% 奖励1
	};
get(3013)->
	#d_sales_sub{
		id           = 301,             %% 活动ID
		id_sub       = 3013,            %% id_sub
		cid          = [],              %% 平台id
		value        = {3000,4999},     %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{5011,1},{2001,1},{3001,1}]%% 奖励1
	};
get(3014)->
	#d_sales_sub{
		id           = 301,             %% 活动ID
		id_sub       = 3014,            %% id_sub
		cid          = [],              %% 平台id
		value        = {5000,9999},     %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{6001,1},{2001,1},{3001,1}]%% 奖励1
	};
get(3015)->
	#d_sales_sub{
		id           = 301,             %% 活动ID
		id_sub       = 3015,            %% id_sub
		cid          = [],              %% 平台id
		value        = {10000,29999},   %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{7001,1},{2001,1},{3001,1}]%% 奖励1
	};
get(3016)->
	#d_sales_sub{
		id           = 301,             %% 活动ID
		id_sub       = 3016,            %% id_sub
		cid          = [],              %% 平台id
		value        = {30000,49999},   %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{8001,1},{2001,1},{3001,1}]%% 奖励1
	};
get(3017)->
	#d_sales_sub{
		id           = 301,             %% 活动ID
		id_sub       = 3017,            %% id_sub
		cid          = [],              %% 平台id
		value        = {50000,99999},   %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{20001,1},{2001,1},{3001,1}]%% 奖励1
	};
get(3018)->
	#d_sales_sub{
		id           = 301,             %% 活动ID
		id_sub       = 3018,            %% id_sub
		cid          = [],              %% 平台id
		value        = {100000,0},      %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{21001,1},{2001,1},{3001,1}]%% 奖励1
	};
get(4011)->
	#d_sales_sub{
		id           = 401,             %% 活动ID
		id_sub       = 4011,            %% id_sub
		cid          = [],              %% 平台id
		value        = 500,             %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{20001,1},{2001,1},{3001,2}]%% 奖励1
	};
get(4012)->
	#d_sales_sub{
		id           = 401,             %% 活动ID
		id_sub       = 4012,            %% id_sub
		cid          = [],              %% 平台id
		value        = 1000,            %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{21001,1},{2001,1},{3001,2}]%% 奖励1
	};
get(4013)->
	#d_sales_sub{
		id           = 401,             %% 活动ID
		id_sub       = 4013,            %% id_sub
		cid          = [],              %% 平台id
		value        = 3000,            %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{20001,1},{2001,1},{3001,3}]%% 奖励1
	};
get(4014)->
	#d_sales_sub{
		id           = 401,             %% 活动ID
		id_sub       = 4014,            %% id_sub
		cid          = [],              %% 平台id
		value        = 5000,            %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{21001,1},{2001,1},{3001,3}]%% 奖励1
	};
get(4015)->
	#d_sales_sub{
		id           = 401,             %% 活动ID
		id_sub       = 4015,            %% id_sub
		cid          = [],              %% 平台id
		value        = 10000,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{20001,1},{2001,1},{3001,4}]%% 奖励1
	};
get(4016)->
	#d_sales_sub{
		id           = 401,             %% 活动ID
		id_sub       = 4016,            %% id_sub
		cid          = [],              %% 平台id
		value        = 30000,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{21001,1},{2001,1},{3001,4}]%% 奖励1
	};
get(4017)->
	#d_sales_sub{
		id           = 401,             %% 活动ID
		id_sub       = 4017,            %% id_sub
		cid          = [],              %% 平台id
		value        = 50000,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{20001,1},{2001,1},{3001,5}]%% 奖励1
	};
get(4018)->
	#d_sales_sub{
		id           = 401,             %% 活动ID
		id_sub       = 4018,            %% id_sub
		cid          = [],              %% 平台id
		value        = 100000,          %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{21001,1},{2001,1},{3001,5}]%% 奖励1
	};
get(5011)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5011,            %% id_sub
		cid          = [],              %% 平台id
		value        = 150,             %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40021,1}]     %% 奖励1
	};
get(5012)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5012,            %% id_sub
		cid          = [],              %% 平台id
		value        = 350,             %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40006,1}]     %% 奖励1
	};
get(5013)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5013,            %% id_sub
		cid          = [],              %% 平台id
		value        = 650,             %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40007,1}]     %% 奖励1
	};
get(5014)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5014,            %% id_sub
		cid          = [],              %% 平台id
		value        = 1000,            %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{4041,1},{43211,5},{43083,1}]%% 奖励1
	};
get(5015)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5015,            %% id_sub
		cid          = [],              %% 平台id
		value        = 1550,            %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{2031,1},{40351,3}]%% 奖励1
	};
get(5016)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5016,            %% id_sub
		cid          = [],              %% 平台id
		value        = 2150,            %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{1031,1},{40361,1}]%% 奖励1
	};
get(5017)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5017,            %% id_sub
		cid          = [],              %% 平台id
		value        = 5000,            %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{3031,1},{5041,1},{43083,1}]%% 奖励1
	};
get(5018)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5018,            %% id_sub
		cid          = [],              %% 平台id
		value        = 8000,            %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{43241,5},{45001,10}]%% 奖励1
	};
get(5019)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5019,            %% id_sub
		cid          = [],              %% 平台id
		value        = 16000,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{43261,80},{43083,2}]%% 奖励1
	};
get(5020)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5020,            %% id_sub
		cid          = [],              %% 平台id
		value        = 25000,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{43083,50}]    %% 奖励1
	};
get(5021)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5021,            %% id_sub
		cid          = [],              %% 平台id
		value        = 35000,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{52031,1}]     %% 奖励1
	};
get(5022)->
	#d_sales_sub{
		id           = 501,             %% 活动ID
		id_sub       = 5022,            %% id_sub
		cid          = [],              %% 平台id
		value        = 50000,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{49006,1}]     %% 奖励1
	};
get(6011)->
	#d_sales_sub{
		id           = 601,             %% 活动ID
		id_sub       = 6011,            %% id_sub
		cid          = [],              %% 平台id
		value        = 30,              %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{43081,5},{43261,5},{52046,1}]%% 奖励1
	};
get(6012)->
	#d_sales_sub{
		id           = 601,             %% 活动ID
		id_sub       = 6012,            %% id_sub
		cid          = [],              %% 平台id
		value        = 40,              %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{43081,10},{43261,10},{52051,1}]%% 奖励1
	};
get(6013)->
	#d_sales_sub{
		id           = 601,             %% 活动ID
		id_sub       = 6013,            %% id_sub
		cid          = [],              %% 平台id
		value        = 50,              %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{43081,20},{43261,30},{52056,1}]%% 奖励1
	};
get(7011)->
	#d_sales_sub{
		id           = 701,             %% 活动ID
		id_sub       = 7011,            %% id_sub
		cid          = [],              %% 平台id
		value        = 30040,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{21021,2}]     %% 奖励1
	};
get(7012)->
	#d_sales_sub{
		id           = 701,             %% 活动ID
		id_sub       = 7012,            %% id_sub
		cid          = [],              %% 平台id
		value        = 30050,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{23021,2}]     %% 奖励1
	};
get(7013)->
	#d_sales_sub{
		id           = 701,             %% 活动ID
		id_sub       = 7013,            %% id_sub
		cid          = [],              %% 平台id
		value        = 30060,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{20021,2}]     %% 奖励1
	};
get(7014)->
	#d_sales_sub{
		id           = 701,             %% 活动ID
		id_sub       = 7014,            %% id_sub
		cid          = [],              %% 平台id
		value        = 30070,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{25041,2}]     %% 奖励1
	};
get(7015)->
	#d_sales_sub{
		id           = 701,             %% 活动ID
		id_sub       = 7015,            %% id_sub
		cid          = [],              %% 平台id
		value        = 30080,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{31041,2}]     %% 奖励1
	};
get(7016)->
	#d_sales_sub{
		id           = 701,             %% 活动ID
		id_sub       = 7016,            %% id_sub
		cid          = [],              %% 平台id
		value        = 30090,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{32041,2}]     %% 奖励1
	};
get(7017)->
	#d_sales_sub{
		id           = 701,             %% 活动ID
		id_sub       = 7017,            %% id_sub
		cid          = [],              %% 平台id
		value        = 30100,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{21061,1},{23061,1}]%% 奖励1
	};
get(8011)->
	#d_sales_sub{
		id           = 801,             %% 活动ID
		id_sub       = 8011,            %% id_sub
		cid          = [],              %% 平台id
		value        = 32010,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40351,1},{43261,3}]%% 奖励1
	};
get(8012)->
	#d_sales_sub{
		id           = 801,             %% 活动ID
		id_sub       = 8012,            %% id_sub
		cid          = [],              %% 平台id
		value        = 32020,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40351,1},{43261,3}]%% 奖励1
	};
get(8013)->
	#d_sales_sub{
		id           = 801,             %% 活动ID
		id_sub       = 8013,            %% id_sub
		cid          = [],              %% 平台id
		value        = 32030,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40351,1},{43261,3}]%% 奖励1
	};
get(8014)->
	#d_sales_sub{
		id           = 801,             %% 活动ID
		id_sub       = 8014,            %% id_sub
		cid          = [],              %% 平台id
		value        = 32040,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40351,1},{43261,3}]%% 奖励1
	};
get(8015)->
	#d_sales_sub{
		id           = 801,             %% 活动ID
		id_sub       = 8015,            %% id_sub
		cid          = [],              %% 平台id
		value        = 32050,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40351,2},{43261,6}]%% 奖励1
	};
get(8016)->
	#d_sales_sub{
		id           = 801,             %% 活动ID
		id_sub       = 8016,            %% id_sub
		cid          = [],              %% 平台id
		value        = 32060,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40351,2},{43261,6}]%% 奖励1
	};
get(8017)->
	#d_sales_sub{
		id           = 801,             %% 活动ID
		id_sub       = 8017,            %% id_sub
		cid          = [],              %% 平台id
		value        = 32070,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40351,2},{43261,6}]%% 奖励1
	};
get(8018)->
	#d_sales_sub{
		id           = 801,             %% 活动ID
		id_sub       = 8018,            %% id_sub
		cid          = [],              %% 平台id
		value        = 32080,           %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{40351,2},{43261,6}]%% 奖励1
	};
get(9011)->
	#d_sales_sub{
		id           = 901,             %% 活动ID
		id_sub       = 9011,            %% id_sub
		cid          = [],              %% 平台id
		value        = 1186,            %% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{43083,3}]     %% 奖励1
	};
get(10011)->
	#d_sales_sub{
		id           = 1001,            %% 活动ID
		id_sub       = 10011,           %% id_sub
		cid          = [],              %% 平台id
		value        = [1001,1002,1003,1004,1005,1006,1007,1008],%% 阶段值
		times        = 1,               %% 领取次数上限
		virtue       = [{43221,3}]     %% 奖励1
	};
get(_)-> ?null.


%% 集合;
get_ids()->[{101,1011},{201,2011},{301,3011},{301,3012},{301,3013},{301,3014},{301,3015},{301,3016},{301,3017},{301,3018},{401,4011},{401,4012},{401,4013},{401,4014},{401,4015},{401,4016},{401,4017},{401,4018},{501,5011},{501,5012},{501,5013},{501,5014},{501,5015},{501,5016},{501,5017},{501,5018},{501,5019},{501,5020},{501,5021},{501,5022},{601,6011},{601,6012},{601,6013},{701,7011},{701,7012},{701,7013},{701,7014},{701,7015},{701,7016},{701,7017},{801,8011},{801,8012},{801,8013},{801,8014},{801,8015},{801,8016},{801,8017},{801,8018},{901,9011},{1001,10011}].

