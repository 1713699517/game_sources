%% Author: Kevin
%% Created: 2012-9-13
%% Description: TODO: Add description to lib_mask
-module(system_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
%%
%% Exported Functions
%%
-export([msg_time/1,
		 msg_error/1,
		 msg_notice/3,
		 msg_tips/3,
		 msg_disconnect/2,
		 
		 heart_time_cb/2,
		 heart/0,
		 word_re/3]).

%%
%% API Functions
%%
heart()->
	PlayerList=ets:tab2list(?ETS_ONLINE),
	[util:pid_send(Mpid,system_api,heart_time_cb,?null)||#player{mpid=Mpid}<-PlayerList].

heart_time_cb(Player=#player{socket=Socket},_)->
	Time=util:seconds(),
	BinMsg=msg_time(Time),
	app_msg:send(Socket, BinMsg),
	Player.

% 时间校正 [510]
msg_time(SrvTime)->
    RsList = app_msg:encode([{?int32u,SrvTime}]),
    app_msg:msg(?P_SYSTEM_TIME, RsList).


% 错误代码 [700]
msg_error(ErrorCode)->
	msg_error(ErrorCode,[]).
msg_error(ErrorCode,Datas) ->
	Rs2   = msg_error2(Datas,[]),
	Count = length(Datas),
	Rs    = [{?int16u,ErrorCode},{?int16u,Count}|Rs2],
	BinData = app_msg:encode(Rs), 
	app_msg:msg(?P_SYSTEM_ERROR, BinData).


msg_error2([],Rs) -> Rs;
msg_error2([Data|Datas],Rs) when is_integer(Data) ->
	msg_error2(Datas, Rs++[{?bool,?false},{?int32u,Data}]);
msg_error2([Data|Datas],Rs) ->
	msg_error2(Datas, Rs++[{?bool,?true}, {?string,Data}]).



% 系统通知 [800]
msg_notice(ShowTime,MsgType,MsgData)->
    RsList = app_msg:encode([{?int32u,ShowTime},{?int16u,MsgType},{?stringl,MsgData}]),
    app_msg:msg(?P_SYSTEM_NOTICE, RsList).


% 游戏提示 [820]
msg_tips(TypeId,Count,TipsData) ->
    RsList = app_msg:encode([{?int16u,TypeId},{?int16u,Count},{?int32,TipsData}]),
    app_msg:msg(?P_SYSTEM_TIPS, RsList).

% 服务器将断开连接 [502]
msg_disconnect(ErrorCode,Msg) ->
    RsList = app_msg:encode([{?int16u,ErrorCode},
        {?stringl,Msg}]),
    app_msg:msg(?P_SYSTEM_DISCONNECT, RsList).


%% 游戏后端文字模板替换
word_re(Bin, Key, Re) ->
	Blen = size(Bin),
	Klen = size(Key),
	word_re(Bin,Key,Re,0,Klen,Blen, <<>>).

word_re(Bin,Key,Re,N,Klen,Blen,BinAcc) when N + Klen =< Blen ->
	case binary:part(Bin, N, Klen) of
		Key ->
			Nx = N + Klen,
			Tail = ?IF(Nx =:= Blen, <<>>, binary:part(Bin, Nx, Blen - Nx)),
			<<BinAcc/binary,Re/binary,Tail/binary>>;
		_ ->
			NB = binary:part(Bin, N, 1),
			word_re(Bin,Key,Re,N+1,Klen,Blen,<<BinAcc/binary,NB/binary>>)
	end;
word_re(Bin,_Key,_Re,N,_Klen,Blen,BinAcc) ->
	Tail = ?IF(N =:= Blen, <<>>, binary:part(Bin, N, Blen - N)),
	<<BinAcc/binary, Tail/binary>>.  

	
	
	
	
	



