%% Author: Administrator
%% Created: 2009-7-11 
%% Description: TODO: Add description to app_msg
-module(app_msg).
%% 数据类型
%% AMF3 wire types 
-define(AMF3_UNDEF,     16#00). 
-define(AMF3_NULL,      16#01). 
-define(AMF3_FALSE,     16#00).
-define(AMF3_TRUE,      16#01).

%% AMF3 variable-length integers are 29-bit
-define(AMF3_INT_MIN, 	-16#10000000). 
-define(AMF3_INT_MAX,  	 16#0fffffff).
%% --------------------------------------------------------------------
%% Include files 
%% --------------------------------------------------------------------
-include("../include/comm.hrl").  

%%
%% Exported Functions
%%
-export([
		 send/2,         send_fast/2, 
		 msg/2,
		 encode/1,
		 decode/2,       decode2/2,
		 
	
		 broad_scene/2,  broad_scene/3
%% 		 broad_world/1,  broad_world/2
		]).
%% to_send
send(_Socket,<<>>) -> ?true;
send( Socket,BinMsg) when is_port(Socket)->
	% case gen_tcp:send(Socket,BinMsg) of
	case app_msg:send_fast(Socket,BinMsg) of
		?ok 			  -> ?true;
		{?error, _Reason} -> ?false % exit(Reason)
	end;
send(Mpid,BinMsg) when is_pid(Mpid) ->
	case util:pid_send(Mpid, {send, BinMsg}) of
		?true  ->
			?MSG_ECHO("~nSEND MsgId:~p  ~nBinData:~p~n", [Mpid, BinMsg]),
			?true;
		?false -> ?false 
	end;
%% 尽量少用Uid 来发
send(Uid,BinMsg) when is_number(Uid)->
	case role_api:mpid(Uid) of
		Pid when is_pid(Pid) ->
%% 			?MSG_ECHO("~nSEND MsgId:~p  ~nBinData:~p~n", [Uid, BinMsg]),
			Pid!{send, BinMsg};
		_ -> ?false
	end;
send(_Uid,_Binary)->
	?false.

% 高速Send
send_fast(Socket,BinMsg) ->
	<<_Len:16/big-integer-unsigned,_:7/big-integer-unsigned,MsgId:16/big-integer-unsigned, _:1/big-integer-unsigned,BinData/binary>> = BinMsg,
	if
		MsgId =:= 5041 orelse MsgId =:= 510 orelse MsgId =:= 5090 orelse MsgId =:= 5080 orelse MsgId =:= 6020->
			% ?MSG_ECHO("~nSEND MsgId:~p  ~nBinData:~p~n", [MsgId, BinData]),
			?ok;
		?true ->
			%% 			?ok
			?MSG_ECHO("~nSEND MsgId:~p  ~nBinData:~p~n", [MsgId, BinData])
	end,
	
	try erlang:port_command(Socket,BinMsg,[force,nosuspend]) of
		?true  -> ?ok;
		?false -> 
			% ?MSG_ERROR("~nReason:~p~n", [busy]),
			{?error,busy} 
	catch
		_:_Error ->
			% ?MSG_ERROR("~nPid:~p Socket:~p BinMsg:~p Reason:~p~n", [self(),Socket,BinMsg,Error]),
			{?error,einval}
	end.


%% do_msg
msg(MsgId,BinData) ->
%% 	?IF(MsgId == 5090 orelse MsgId == 510 orelse MsgId == 5041 orelse MsgId == 33024 orelse MsgId == 1130 orelse MsgId == 33020, ?skip, ?MSG_ECHO("aaMsgID : ~p~n ", [MsgId])),
	Len 	= byte_size(BinData) + 3,
	if
		?false andalso Len > 128 ->
			<<120,156,Bin/binary>> = zlib:compress(BinData),
			Len2				   = byte_size(Bin)+5,
			?MSG_ECHO("OLen:~p Len:~p ",[Len,Len2]),
			<<Len2:16/big-integer-unsigned,(MsgId+Len2):7/big-integer-unsigned,MsgId:16/big-integer-unsigned,1:1/big-integer-unsigned,(Len-3):16/big-integer-unsigned,Bin/binary>>;
		?true ->
			<<Len :16/big-integer-unsigned,(MsgId+Len ):7/big-integer-unsigned,MsgId:16/big-integer-unsigned,0:1/big-integer-unsigned,BinData/binary>>
	end. 
%%	<<Len:16/big-integer-unsigned,(MsgId+Len ):7/big-integer-unsigned,MsgId:16/big-integer-unsigned,0:1/big-integer-unsigned,BinData/binary>>.


%% broad_world(MsgBin) ->
%% 	MS			 = ets:fun2ms(fun(R)->R#ets_online.uid  end),
%% 	PlayerIDList = ets:select(?ETS_ONLINE,MS),
%% 	broad(PlayerIDList,MsgBin).
%% 	
%% broad_world(MsgBin,MyUid) ->
%% 	MS 			 = ets:fun2ms(fun(#ets_online{uid=ID}) when ID =/= MyUid -> ID end),
%% 	PlayerIDList = ets:select(?ETS_ONLINE,MS),
%% 	broad(PlayerIDList,MsgBin).

broad_scene(_SceneID,MsgBin,MyUid) ->
	PlayerIDList = [ID||ID<-lib_map:get_player_ids(),ID=/=MyUid],
	broad(PlayerIDList,MsgBin).
broad_scene(_SceneID,MsgBin) ->
	PlayerIDList = mod_map:get_player_ids(), 
	broad(PlayerIDList,MsgBin).

	
broad(PlayerIDList,Bin)->
	[send(PlayerID,Bin)||PlayerID<-PlayerIDList].

%% 写数据
%% 例子：app_msg:encode([{?int8,Int1},{?int8,Int2}],Bin),
%% 返回：{Int1,Int2}
encode(Datas) ->
	Datas2 = lists:reverse(Datas),
	encode(Datas2,	<<>>).
encode([],Bin)-> Bin;
encode([{Type,Val}|Datas],Bin)->
	encode(Datas, 	encode_val(Type,Val,Bin) ).
encode_val(?bool,   ?true,	Bin)->
	<<?AMF3_TRUE,	Bin/binary>>;
encode_val(?bool,  	?false,	Bin)->
	<<?AMF3_FALSE,	Bin/binary>>;
encode_val(?bool,   ?CONST_TRUE,  Bin)->
	<<?AMF3_TRUE,	Bin/binary>>;
encode_val(?bool,  	?CONST_FALSE, Bin)->
	<<?AMF3_FALSE,	Bin/binary>>;
encode_val(?null, 	?null,	Bin)->
	<<?AMF3_NULL,	Bin/binary>>;
encode_val(?undefined,	?undefined,Bin)->
	<<?AMF3_UNDEF,	Bin/binary>>;
encode_val(?int8,	Val,	Bin)->
	<<Val:8/big-integer-signed,Bin/binary>>;
encode_val(?int8u,	Val,	Bin)->
	<<Val:8/big-integer-unsigned,Bin/binary>>;
encode_val(?int16,	Val,	Bin)->
	<<Val:16/big-integer-signed,Bin/binary>>;
encode_val(?int16u,	Val,	Bin)->
	<<Val:16/big-integer-unsigned,Bin/binary>>;
encode_val(?int32,	Val,	Bin)->
	<<Val:32/big-integer-signed,Bin/binary>>;
encode_val(?int32u,	Val,	Bin)->
	<<Val:32/big-integer-unsigned,Bin/binary>>;
encode_val(?int64,	Val,	Bin)-> 
	<<Val:64/big-integer-signed,Bin/binary>>;
encode_val(?int64u,	Val,	Bin)->
	<<Val:64/big-integer-unsigned,Bin/binary>>;
%% encode_val(?float32,Val,	Bin)->
%%     <<Val:32/big-float, Bin/binary>>;
encode_val(?float64,?nan,	Bin)-> 
    <<0:1,4095:11/big, 1:52/big,Bin/binary>>;
encode_val(?float64,Val,	Bin)->
    <<Val:64/big-float, Bin/binary>>;
encode_val(?string,	Val,	Bin)->
	Len = byte_size(Val),
	<<Len:8/big-integer-unsigned, Val:Len/binary,Bin/binary>>;
encode_val(?stringl,Val,	Bin)->
	Len = byte_size(Val),
	<<Len:16/big-integer-unsigned, Val:Len/binary,Bin/binary>>.


%% 读取数据
%% 例子：app_msg:decode({?int8,?int8},Bin),
%% 返回：{Int1,Int2}
decode(Types,Bin)->
	Size  = tuple_size(Types),
	Data  = erlang:make_tuple(Size, 0),
	decode(1,Size,Data,Types,Bin).
decode(Idx,Size,Data,Types,Bin)->
	{Val,Rest} = decode_val2(Bin, element(Idx,Types)),
	if 
		Idx =:= Size -> setelement(Idx, Data, Val);
		?true -> Data2 = setelement(Idx, Data, Val),decode(Idx+1,Size,Data2,Types,Rest)
	end.
%% 读取数据
%% 例子：app_msg:decode2({?int8,?int8},Bin),
%% 返回：{Int1,Int2,Rest}
decode2(Types,Bin)->
	Size  = tuple_size(Types),
	Data  = erlang:make_tuple(Size+1, 0),
	decode2(1,Size,Data,Types,Bin).
decode2(Idx,Size,Data,Types,Bin)->
	{Val,Rest} = decode_val2(Bin, element(Idx,Types)),
	if 
		Idx =:= Size -> Data2 = setelement(Idx, Data, Val),setelement(Idx+1, Data2, Rest);
		?true -> Data2 = setelement(Idx, Data, Val),decode2(Idx+1,Size,Data2,Types,Rest)
	end.


decode_val2(<<?AMF3_TRUE,	Rest/binary>>, ?bool)->
	{?true ,Rest};
decode_val2(<<?AMF3_FALSE,	Rest/binary>>, ?bool)->
	{?false,Rest};
decode_val2(<<?AMF3_NULL,	Rest/binary>>, ?null)->
	{?null,Rest};
decode_val2(<<?AMF3_UNDEF,	Rest/binary>>, ?undefined)->
	{?undefined,Rest};
decode_val2(<<Val:8/big-integer-signed,Rest/binary>>, ?int8)->
	{Val,Rest};
decode_val2(<<Val:8/big-integer-unsigned,Rest/binary>>, ?int8u)->
	{Val,Rest};
decode_val2(<<Val:16/big-integer-signed,Rest/binary>>, ?int16)->
	{Val,Rest};
decode_val2(<<Val:16/big-integer-unsigned,Rest/binary>>, ?int16u)->
	{Val,Rest};
decode_val2(<<Val:32/big-integer-signed,Rest/binary>>, ?int32)->
	{Val,Rest};
decode_val2(<<Val:32/big-integer-unsigned,Rest/binary>>, ?int32u)->
	{Val,Rest};
decode_val2(<<Val:64/big-integer-signed,  Rest/binary>>, ?int64)->
	{Val,Rest};
decode_val2(<<Val:64/big-integer-unsigned,Rest/binary>>, ?int64u)-> 
	{Val,Rest};
%% decode_val2(Binary, ?float32) ->
%%     try <<Val:32/big-float, Rest/binary>>  = Binary, {Val, Rest}
%%     catch  _:_ -> <<_:32, Rest2/binary>> = Binary, {?nan, Rest2} end;
decode_val2(Binary, ?float64) ->
    try <<Val:64/big-float, Rest/binary>>  = Binary, {Val, Rest}
    catch  _:_ -> <<_:64, Rest2/binary>> = Binary, {?nan, Rest2} end;
decode_val2(<<Len:8/big-integer-unsigned, Val:Len/binary,Rest/binary>>, ?string)->
	{Val,Rest};
decode_val2(<<Len:16/big-integer-unsigned,Val:Len/binary,Rest/binary>>, ?stringl)->
	?MSG_ECHO("1111111111",[]),
	{Val,Rest}.



