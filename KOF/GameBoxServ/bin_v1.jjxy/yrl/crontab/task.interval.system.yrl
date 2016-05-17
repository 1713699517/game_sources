%% % -------------------------------------------------------------------
%% % Description : erlang版crontab
%%
%% Created : 2010-12-8
%% -------------------------------------------------------------------
%% 定时要执行的函数
%% 唯一ID																		间隔秒数        	执行上限次数  0:没上限  
%% {unique_id,					{M,F,A} 										second			limit }
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 这里是系统内部接口，不要随意删改
%% 定时向Mongo写数据
%{sys_mongo_flush,	    		{mongo_api, 	 interval_flush, 	[]},		5,			        	0	 }.
%% Mongo心跳
%{sys_mongo_interval,	    	{mongo_api, 	 interval_heart, 	[]},		3000,			        0	 }.
% 定时查看Master节点是否开起
{sys_master_ping,	    		{gc_server, 	 interval, 			[]},		17,			        	0	 }.
% Mysql心跳
{sys_mysql_interval,	    	{mysql_api, 	 interval, 			[]},		350,			        0	 }.
% 地图
{sys_scene_interval,	   		{scene_api, 	 interval, 			[]},		0.5,			        0	 }.
% 副本
{sys_copy_interval,	    		{copy_api, 	 	 interval, 			[]},		1,			        	0	 }.

{sys_moil_interval,	    		{moil_api, 	 	 interval, 			[]},		60,			        	0	 }.

% 钓鱼
%{sys_fishing_interval,	   		{fishing_api, 	 interval, 			[]},		1,			        	0	 }.

% 清理EtsOffLine 长时间没用到的数据
{sys_role_interval,	    		{role_interval,  interval_clean, 	[]},		290,			        0	 }.

% 定时竞技场
{sys_arena_mysql,	    		{arena_api, 	 maysql_arena, 		[]},		600,			        0	 }.

%% 定时增加精力系统
{sys_energy_interval,     	     {energy_api,     interval,          []},		5,                		0	 }.

%% 定时增加精力系统
{sys_energy_interval,     	     {energy_api,     interval,          []},		5,                		0	 }.  
 
% 称号系统
{sys_title_interval,	    	{title_api, 	 ref_title, 		 []},		60,			        	0	 }.

% 帮派排行列表刷新(2013-7-1)
{sys_clan_rank,	    			{clan_api, 	 	 ref_clan_rank, 	[]},		300,			        0	 }.

% 心跳时间校正
{sys_heart_time,	    		{system_api, 	 heart, 			[]},		3,			        	0	 }.
   

