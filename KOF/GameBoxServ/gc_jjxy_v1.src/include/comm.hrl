%%%------------------------------------------------
%%% File    : common.hrl
%%% Rewrite by  : Bill
%%% Created : 2012.06.20
%%% Description: 公共定义
%%%------------------------------------------------
-include("const.error.hrl").
-include("const.define.hrl").
-include("const.protocol.hrl").

-include("logger.compile.hrl").
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  配制文件所在根目录
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 根目录
-define(DIR_ROOT, 					"./../").
%% 数据
-define(DIR_YRL_ROOT, 				?DIR_ROOT++"yrl/").
%% 日志
-define(DIR_LOGS_ROOT, 				?DIR_ROOT++"../dir.jjxy.logs/").
%% 基本配制文件名(服)
-define(FILENAME_CONFIG_BASE, 		?DIR_ROOT++"../dir.jjxy.config/ini.all.config."). %% ++NodeTag++".yrl",
%% 安全串
-define(SECURITY_PREFIX, 			<<60,112,111,108,105,99,121,45,102,105,108,101,45,114,101,113,117,101,115,116,47,62,0>>).
%% 回应安全串  
-define(SECURITY, 			    	<<60,63,120,109,108,32,118,101,114,115,105,111,110,61,34,49,46,48,34,63,62,
								  	  60,99,114,111,115,115,45,100,111,109,97,105,110,45,112,111,108,105,99,121,62,
								  	  60,97,108,108,111,119,45,97,99,99,101,115,115,45,102,114,111,109,32,100,111,109,97,
								  	  105,110,61,34,42,34,32,116,111,45,112,111,114,116,115,61,34,52,48,48,45,57,57,57,57,34,47,62,
								  	  60,47,99,114,111,115,115,45,100,111,109,97,105,110,45,112,111,108,105,99,121,62,0>>).
%%tcp_server监听参数
-define(TCP_OPTIONS, 				[binary,{packet, 		0}, 
					  		  				{active, 		false}, 
					  		  				{reuseaddr, 	true}, 
					  		  				{nodelay, 		true}, 
					  	      				{delay_send,	false},
					  		  				{backlog, 		5120},
					  		  				{send_timeout,	12000}, 
					  		  				{keepalive,   	false}, 
					  		  				{exit_on_close, true}]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 常量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 最大心跳包检测失败次数
-define(HEARTBEAT_MAX_FAIL_TIME, 	3).
%% 心跳包时间间隔（秒）
-define(HEARTBEAT_TICKET_TIME, 		24000).
%% 地图 心跳(半秒)
-define(LOOP_TIME_MAP,				500).
%% 玩家 心跳(6秒)
-define(LOOP_TIME_PLAYER,			6000).
%% 服务(Serv)之间调用超时 时间长
-define(CONST_OUTTIME_CALL,			1000).
%% 进程之间超时（2秒）
-define(CONST_OUTTIME_PID,			2000).	
%% Socket连接超时
-define(CONST_OUTTIME_GATEWAY,		90000).
%% 常量 一分钟
-define(CONST_MINUTE_MULTIPLE,		60000).
%% sleep(半秒)
-define(CONST_TIME_SLEEP,			500).
%% 一天的时间（秒）
-define(CONST_DAY_SECONDS,        	86400).	
%% 一天时间（毫秒）
-define(CONST_DAY_MILLISECONDS, 	86400000).
%% 0000到1970年的秒数
-define(DIFF_SECONDS_0000_1900, 	62167219200).
%% 测试 空白步骤(不用执行)
-define(STEP_NULL, 					999999999).
			   		


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 数据类型与常量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-define(true, 					true).		 %% true  真/开
-define(false, 					false).		 %% false 假/关
-define(ok, 					ok).	 	 %% ok
-define(error, 					error).	 	 %% error
-define(start, 					start).	 	 %% start
-define(stop, 					stop).	 	 %% stop
-define(reply, 					reply).	 	 %% reply
-define(loop, 					loop).		 %% loop 
-define(doloop, 				doloop).	 %% doloop 
-define(noreply, 				noreply).	 %% noreply
-define(timeout, 				timeout).	 %% timeout
-define(ignore, 				ignore).	 %% ignore
-define(skip,					skip).	     %% skip
-define(nan,					nan).		 %% nan
-define(undefined, 				undefined).	 %% undefined
-define(null, 					null).		 %% null 
-define(normal, 				normal).	 %% normal 
-define(exit, 					exit).	 	 %% exit
-define(trap_exit, 				trap_exit).	 %% trap_exit 
-define(change_socket,			change_socket). 
-define(inet_reply,				inet_reply). %% inet_reply
-define(alive,					alive).
-define(pong,					pong).
-define(exec,					exec).

-define(bool, 					boolean).	 %% 布尔值
-define(int8, 					int8).		 %% 8位带符号整型
-define(int8u, 					int8u).		 %% 8位无符号整型
-define(int16, 					int16).		 %% 16位带符号整型
-define(int16u, 				int16u).	 %% 16位无符号整型
-define(int32, 					int32).		 %% 32位带符号整型
-define(int32u, 				int32u). 	 %% 32位无符号整型
-define(int64, 					int64).		 %% 64位带符号整型 
-define(int64u, 				int64u).	 %% 64位无符号整型
%-define(float32,				float32).	 %% 单精度(32 位)浮点数
-define(float64,				float64).	 %% 双精度(64 位)浮点数
-define(string, 				string).     %% 短字符串(小于256)
-define(stringl, 				string_long).%% 长字符串(小于65536)

%% 转二进制 简写
-define(B(D),					(util:to_binary(D))/binary                       ).
%% 打包字符串
-define(P_STRING(String),		<<(byte_size(String)):8, String/binary>>/binary  ).	
%% 打包字符串Long
-define(P_STRINGL(String),		<<(byte_size(String)):16,String/binary>>/binary  ).			
%% 语言包参数转换
-define(LANG(Tran, Args),		io_lib:format(Tran, Args)).
%% 函数封装
-define(TRY_FAST(B,T), 			try (B) catch _:_->(T) end				).
-define(TRY_DO(B), 				try (B) catch Error:Reason -> ?MSG_ERROR("Error:~p, ~nReason:~p, ~nStackTrace:~p",[Error,Reason,erlang:get_stacktrace()]) end 		).
-define(TRY_DO(B,R),			try (B) catch Error:Reason -> ?MSG_ERROR("Error:~p, ~nReason:~p, ~nStackTrace:~p",[Error,Reason,erlang:get_stacktrace()]), R end		).
-define(ERROR_GATEWAY(ProtocolCode, Player, Binary), ?MSG_ERROR("Error In ProtocolCode:~p PlayerUid:~p Binary:~p",[ProtocolCode,Player#player.uid,Binary])  	).
-define(IF(B,T,F), 				case (B) of ?true->(T);?false->(F) end	).

%% Record 
-include("const.core.hrl").
-include("record.data.hrl").
-include("record.player.hrl").
-include("record.scene.hrl").
-include("record.war.hrl").


