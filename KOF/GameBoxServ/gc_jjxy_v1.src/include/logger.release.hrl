% 错误   -1：关闭
%     >=0：只记录
-define(DEBUG_LEVEL_ERROR, 					9).
% MYSQL -1：关闭
%        0：只记录 等级为0的LOGS  ... 9:什么都记录
-define(DEBUG_LEVEL_MYSQL, 					9).
% 调试登录 
%        0：关闭调试登录 
%        1: 开起调试登录
-define(DEBUG_LOGIN, 						0).
% 调试GM 
%        0：关闭调试GM 
%        1: 开起调试GM
-define(DEBUG_GM, 							0).
%% ---------------------------------
%% Logging mechanism
%% Print in standard output
-define(MSG_PRINT(Format, Args),			io:format("PRINT ~p:~p "++Format++"~n",				[?MODULE,?LINE|Args])			 ).
-define(MSG_ECHO(S,D),						0  ).
-define(MSG_ERROR(S,D),						app_logs_srv:error_cast(S,D,?MODULE,?LINE)   		).
%-define(MSG_MYSQL(S,D,Lv),					app_tool:mysql(S,D,Lv,?MODULE,?LINE) 				).

%-define(MSG_INFO(Format, Args),			logger:info_msg(?MODULE,?LINE,Format,Args)			).
%-define(MSG_WARNING(Format, Args),			logger:warning_msg(?MODULE,?LINE,Format,Args)		).


% now
% date_api:now().
%-define(TIME_NOW(),						begin Diff = db:config_diff_time(),{MegaSecs, Secs, MicroSecs} = erlang:now(),{MegaSecs, Secs+Diff, MicroSecs} end	).
-define(TIME_NOW(),							erlang:now()		).

% date
% date_api:date().
%-define(TIME_DATE(),						begin {Date,_Time} = calendar:now_to_local_time(?TIME_NOW()),Date end		).
-define(TIME_DATE(),						erlang:date()		).

% date
% date_api:time().
%-define(TIME_TIME(),						begin {_Date,Time} = calendar:now_to_local_time(?TIME_NOW()),Time end		).
-define(TIME_TIME(),						erlang:time()		).
	
% localtime
% date_api:localtime().
%-define(TIME_LOCALTIME(),					calendar:now_to_local_time(?TIME_NOW())								).
-define(TIME_LOCALTIME(),					erlang:localtime()	).
