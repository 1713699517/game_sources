%% Author: goku
%% Created: 2013-4-12
%% Description: TODO: Add description to global_data
-module(global_data).

-include("comm.hrl").

-export([
		 init/0,
		 save/0,
		 get/1,
		 set/2,
		 set_force/2
		 ]).

%% 把数据从MYSQL中读出
init()->
	case mysql_api:select([val],sys_global,[{k,"global"}]) of 
		{?ok,[[Val|_]|_]} ->
			?MSG_ECHO("Val:~w",[Val]),
			Val2 = util:to_list(Val),
			Val3 = ?TRY_DO(util:string_to_term(Val2),[]),
			if
				is_list(Val3) andalso length(Val3) > 1 ->
					ets:insert(?ETS_S_GLOBAL,Val3);
				?true ->
					?skip
			end;
		_ -> 
			?skip
	end.

%% 数据刷新到MYSQL
save()->
	Val	   = ets:tab2list(?ETS_S_GLOBAL),
	Val2   = util:term_to_string(Val),
	Val3   = mysql_api:escape(Val2),
	Query  = <<"REPLACE INTO `sys_global` (`k`, `val`) VALUES ('global','",(util:to_binary(Val3))/binary,"');">>,
	mysql_api:fetch_cast(Query),
	?ok.


get(Key)->
	case ets:lookup(?ETS_S_GLOBAL, Key) of
		[{Key, Value}|_] -> Value;
		_ -> ?null
	end.

%% 定时刷新MYSQL
set(Key,Value)->
	ets:insert(?ETS_S_GLOBAL, {Key,Value}),
	?ok.

%% 值有变化时并马上刷新MYSQL
set_force(Key,Value)->
	case ?MODULE:get(Key) of
		Value -> 
			?ok;
		_ -> 
			?MODULE:set(Key,Value),
			?MODULE:save()
	end.




