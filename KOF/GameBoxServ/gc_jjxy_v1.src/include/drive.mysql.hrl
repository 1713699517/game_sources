%% MySQL result record:
-record(mysql_result,{
					  	fieldinfo		= [],
					  	rows			= [],
					  	affectedrows	= 0,
						lastinsertid	= 0,
					  	error			= ""
					 }). 
-record(mysql_state, {
					  	pool_ready		= [], 
						pool_working	= [],
						pool_logs		= ?null,
						queue			= []
						%sid			= 0 
						%cores			= 1 ,
						%times 			= 0
					 }).
-record(mysql_side, {
					  	%sid	  	= 0 ,
						ver	  	= ?null,
						socket 	= ?null,
						bin_acc = <<>>,					
					  	host, port, username, password, database, charset
					 }).
%% MSG
%%--------------------------------------------------------------------
%% Macros
%%--------------------------------------------------------------------
-define(MYSQL_LONG_PASSWORD, 			1).
-define(MYSQL_LONG_FLAG, 				4).
-define(MYSQL_PROTOCOL_41, 				512).
-define(MYSQL_CLIENT_MULTI_STATEMENTS, 	65536).
-define(MYSQL_CLIENT_MULTI_RESULTS, 	131072). 
-define(MYSQL_TRANSACTIONS, 			8192).
-define(MYSQL_CONNECTION_SECURE, 		32768).

-define(MYSQL_MAX_PACKET_SIZE, 		1000000).

-define(MYSQL_CONNECT_WITH_DB, 		8).

-define(MYSQL_TIMEOUT_CONNECT, 		30000).
-define(MYSQL_TIMEOUT_FETCH, 		2000).
-define(MYSQL_TIMEOUT_RUN,          5).% MySQL 执行时间上限（秒） SideSrv 
-define(MYSQL_TIMEOUT_DEFAULT, 		15000).


-define(MYSQL_QUERY_OP, 			3).
-define(MYSQL_REBOOT, 			    10).
-define(MYSQL_4_0, 					40). %% Support for MySQL 4.0.x
-define(MYSQL_4_1, 					41). %% Support for MySQL 4.1.x et 5.0.x

%% Used by transactions to get the state variable for this connection
%% when bypassing the dispatcher.
-define(MYSQL_STATE_VAR, 			mysql_connection_state).
%% Macros
-define(MYSQL_LOCAL_FILES, 			128).
-define(MYSQL_PORT, 		 		3306).


