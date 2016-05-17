%% Author: dreamxyp
%% Created: 2012-2-13
%% Description: TODO: Add description to mysql_mod
-module(mysql_mod).

%%
%% Include files
%%
-include("../include/comm.hrl").
-include("../include/drive.mysql.hrl").
%%
%% Exported Functions
%%
-export([do_query/4,
		 do_recv/4,
		 do_send/3]).

do_query(Sock,BinAcc,Version,Query) ->
	Packet  = iolist_to_binary([?MYSQL_QUERY_OP,Query]),
	%%?MSG_ECHO("fetch ~p ", [Query]),		
    case do_send(Sock, Packet , 0) of
		?ok ->
			case get_query_response(Sock,BinAcc,Version) of
				{?ok,    Result, BinAcc2} ->
					if
						%% 这里 INSERT 得到 SELECT LAST_INSERT_ID();
						Result#mysql_result.affectedrows > 0 ->
							case Packet of
								%<<?MYSQL_QUERY_OP,"INSERT",_/binary>> ->
								<<3,73,78,83,69,82,84,_/binary>> ->
									Packet2  = iolist_to_binary([?MYSQL_QUERY_OP,<<"SELECT LAST_INSERT_ID();">>]),
									case do_send(Sock, Packet2 , 0) of
										?ok ->
											case get_query_response(Sock,BinAcc2,Version) of
												{?ok, Resul3, BinAcc3} ->
													case Resul3#mysql_result.rows of
														[[LAST_ID]] -> ?ok;
														_ -> LAST_ID = 0
													end,
													{?ok, Result#mysql_result{lastinsertid=LAST_ID}, BinAcc3};
												{?error, Result} ->
													{?ok, Result, <<>>}
											end;
										{?error, Reason} ->
											?MSG_ERROR("Reason:~p",[Reason]),
											{?ok, Result, <<>>}
									end;
								_ ->
									{?ok,    Result, BinAcc2}
							end; %% end case Packet of
						?true ->
							{?ok,    Result, BinAcc2}
					end; %% end Result#mysql_result.affectedrows > 0
				{?error, Result} -> 
					{?ok, Result, <<>>}
            end;
		{?error, Reason} ->
	    	Msg = io_lib:format("Failed sending data on socket : ~p",[Reason]),
	    	{?error, Msg}
    end.
do_recv(Sock,<<Length:24/little, Num:8, D/binary>>,Version,SeqNum) when Length =< size(D) ->
	{Packet, Rest} = split_binary(D, Length),
	if
		is_integer(SeqNum) andalso (SeqNum+1) == Num ->
			{?ok,Packet,Rest,Num};
		is_integer(SeqNum) ->
			do_recv(Sock,Rest,Version,SeqNum); 
		?true ->
			{?ok,Packet,Rest,Num}
	end;	
do_recv(Sock,Data,Version,SeqNum) ->
	receive
		{tcp, Sock, InData} ->
			% NewData = <<Data/binary,InData/binary>>,
			do_recv(Sock,<<Data/binary,InData/binary>>,Version,SeqNum);
		{tcp_error, Sock, Reason} ->
			?MSG_ERROR("mysql_recv: Socket ~p closed : ~p",[Sock, Reason]),
	    	gen_tcp:close(Sock),
			{?error, tcp_error}; 
		{tcp_closed, Sock} ->
	    	?MSG_ERROR("mysql_recv: Socket ~p closed", [Sock]),
	    	gen_tcp:close(Sock),
			{?error, tcp_closed};
		close ->
			?MSG_ERROR("socket closed",[]),
			gen_tcp:close(Sock),
			{?error, closed}
%%  		Unknown ->
%%  	    	?MSG_ERROR("received unknown signal, Unknown: ~p", [Unknown]),
%%  			do_recv(Sock,Data,Version,SeqNum)
	end.

do_send(Sock, Packet, SeqNum) -> 
	Data = <<(size(Packet)):24/little, SeqNum:8, Packet/binary>>,
    gen_tcp:send(Sock, Data). 


get_query_response(Sock,Data,Version) ->
    case do_recv(Sock,Data,Version,?undefined) of
		{?ok,Packet,Data2,_Num} ->
			%?MSG_MYSQL("get_query_response Packet:~p",[Packet],9),
			{FieldCount, Rest}	= get_lcb(Packet),
			case FieldCount of
				0 ->
		    		%% No Tabular data
		    		{AffectedRows, _Rest2}				= get_lcb(Rest),
					% ?MSG_ECHO("get_query_response AffectedRows:~p",[AffectedRows]),
		    		%% {updated, #mysql_result{affectedrows=AffectedRows}};
					{?ok,    #mysql_result{affectedrows=AffectedRows}, Data2};
				255 ->
		    		<<_Code:16/little, Message/binary>>	= Rest,
		    		{?ok,    #mysql_result{error=Message},			   Data2};
				_ ->
		    		%% Tabular data received
		    		case get_fields(Version,Sock,Data2, []) of
						{?ok,   Fields,Data3} ->
							%?MSG_MYSQL("Fields:~p",[Fields],9),
							case get_rows(Fields, Sock,Data3, Version, []) of
								{?ok, 	Rows,	Data4} ->
									% {data, #mysql_result{fieldinfo=Fields,
				    				{?ok, 	 #mysql_result{fieldinfo=Fields,rows=Rows},Data4};
								{?error, Reason} ->
									{?error, #mysql_result{error=Reason}}
							end;
						{?error,Reason} ->
							{?error, #mysql_result{error=Reason}}
					end
			end;
		{?error, Reason} ->
			{?error, #mysql_result{error=Reason}}
	end.



get_fields(?MYSQL_4_0, Sock,Data, Res) ->
    case do_recv(Sock,Data,?MYSQL_4_0,?undefined) of
	{?ok, Packet, Data2,_Num} ->
		%?MSG_MYSQL("get_fields 4.0 Packet:~p",[Packet],9),
	    case Packet of
		<<254:8>> ->
		    {?ok, lists:reverse(Res),Data2};
		<<254:8, Rest/binary>> when size(Rest) < 8 ->
		    {?ok, lists:reverse(Res),Data2};
		_ ->
		    {Table, Rest} 		= get_with_length(Packet),
		    {Field, Rest2} 		= get_with_length(Rest),
		    {LengthB, Rest3} 	= get_with_length(Rest2),
		    LengthL 			= size(LengthB) * 8,
		    <<Length:LengthL/little>> = LengthB,
		    {Type, Rest4} 		= get_with_length(Rest3),
		    {_Flags, _Rest5} 	= get_with_length(Rest4),
		    This = {Table,
			    Field,
			    Length,
			    %% TODO: Check on MySQL 4.0 if types are specified
			    %%       using the same 4.1 formalism and could 
			    %%       be expanded to atoms:
			    Type},
		    get_fields(?MYSQL_4_0, Sock,Data2, [This | Res])
	    end;
	{?error, Reason} ->
	    {?error, Reason}
    end;
%% Support for MySQL 4.1.x and 5.x:
get_fields(?MYSQL_4_1, Sock,Data, Res) ->
    case do_recv(Sock,Data,?MYSQL_4_1,?undefined) of
	{?ok, Packet, Data2, _Num} ->
		%?MSG_MYSQL("get_fields 4.1 Packet:~p",[Packet],9),
	    case Packet of
			<<254:8>> ->
		    	{?ok, lists:reverse(Res),Data2};
			<<254:8, Rest/binary>> when size(Rest) < 8 ->
		    	{?ok, lists:reverse(Res),Data2};
			_ ->
		    	{_Catalog, Rest} 	= get_with_length(Packet),
		    	{_Database, Rest2} 	= get_with_length(Rest),
		    	{Table, Rest3} 		= get_with_length(Rest2),
		    	%% OrgTable is the real table name if Table is an alias
		    	{_OrgTable, Rest4} 	= get_with_length(Rest3),
		    	{Field, Rest5} 		= get_with_length(Rest4),
		    	%% OrgField is the real field name if Field is an alias
		    	{_OrgField, Rest6} 	= get_with_length(Rest5),
		    	<<_Metadata:8/little, _Charset:16/little,
		     		Length:32/little, Type:8/little,
		     		_Flags:16/little, _Decimals:8/little,
		     		_Rest7/binary>>		= Rest6,		    
		    	This 	= {Table,Field,Length,get_field_datatype(Type)},
		    	get_fields(?MYSQL_4_1,Sock,Data2,[This | Res])
	    end;
		{?error, Reason} ->
			%?MSG_MYSQL("get_fields 4.1 Reason:~p",[Reason],9),
			{?error, Reason}
	end.

%%--------------------------------------------------------------------
%% Function: get_rows(N, LogFun, RecvPid, [])
%%           N       = integer(), number of rows to get
%%           LogFun  = ?undefined | function() with arity 3
%%           RecvPid = pid(), yp_mysql_recv process
%% Descrip.: Receive and decode a number of rows.
%% Returns : {?ok, Rows} |
%%           {?error, Reason}
%%           Rows = list() of [string()]
%%--------------------------------------------------------------------
get_rows(Fields, Sock,Data, Version, Res) ->
    case do_recv(Sock,Data,Version,?undefined) of
	{?ok,Packet,Data2,_Num} -> 
		%?MSG_MYSQL("get_rows 4.0 Packet:~p",[Packet],9),
	    case Packet of
		<<254:8, Rest/binary>> when size(Rest) < 8 ->
		    {?ok, lists:reverse(Res),Data2};
		_ ->
		    {?ok, This} = get_row(Fields, Packet, []),
		    get_rows(Fields, Sock,Data2, Version, [This | Res])
	    end;
	{?error, Reason} ->
	    {?error, Reason} 
    end. 

%% part of get_rows/4
get_row([], _Data, Res) ->
    {?ok, lists:reverse(Res)};
get_row([Field | OtherFields], Data, Res) ->
    {Col, Rest} = get_with_length(Data),
    This = case Col of
			   ?null ->
				   ?null;
			   _ ->
				   convert_type(Col, element(4, Field))
		   end,
    get_row(OtherFields, Rest, [This | Res]).

get_with_length(Bin) when is_binary(Bin) ->
	case get_lcb(Bin) of
		{?null, Rest} ->
			{?null, Rest};
		{Length, Rest} ->
			% {Length, Rest} = get_lcb(Bin),
			% ?MSG_ECHO("----Length:~p Rest:~p",[Length, Rest]),
			split_binary(Rest, Length)
	end.

get_lcb(<<251:8, Rest/binary>>) ->
	{?null, Rest};
    %% {0, Rest};
get_lcb(<<252:8, Value:16/little, Rest/binary>>) ->
    {Value, Rest};
get_lcb(<<253:8, Value:24/little, Rest/binary>>) ->
    {Value, Rest};
get_lcb(<<254:8, Value:32/little, Rest/binary>>) ->
    {Value, Rest};
get_lcb(<<Value:8, Rest/binary>>) when Value < 251 ->
    {Value, Rest};
get_lcb(<<255:8, Rest/binary>>) ->
    {255, Rest}.




%%--------------------------------------------------------------------
%% Function: get_field_datatype(DataType)
%%           DataType = integer(), MySQL datatype
%% Descrip.: Return MySQL field datatype as description string
%% Returns : String, MySQL datatype
%%--------------------------------------------------------------------
get_field_datatype(0) ->   'DECIMAL';
get_field_datatype(1) ->   'TINY';
get_field_datatype(2) ->   'SHORT';
get_field_datatype(3) ->   'LONG';
get_field_datatype(4) ->   'FLOAT';
get_field_datatype(5) ->   'DOUBLE';
get_field_datatype(6) ->   'NULL';
get_field_datatype(7) ->   'TIMESTAMP';
get_field_datatype(8) ->   'LONGLONG';
get_field_datatype(9) ->   'INT24';
get_field_datatype(10) ->  'DATE';
get_field_datatype(11) ->  'TIME';
get_field_datatype(12) ->  'DATETIME';
get_field_datatype(13) ->  'YEAR';
get_field_datatype(14) ->  'NEWDATE';
get_field_datatype(16) ->  'TINYINT';
get_field_datatype(246) -> 'NEWDECIMAL';
get_field_datatype(247) -> 'ENUM';
get_field_datatype(248) -> 'SET';
get_field_datatype(249) -> 'TINYBLOB';
get_field_datatype(250) -> 'MEDIUM_BLOG';
get_field_datatype(251) -> 'LONG_BLOG';
get_field_datatype(252) -> 'BLOB';
get_field_datatype(253) -> 'VAR_STRING';
get_field_datatype(254) -> 'STRING';
get_field_datatype(255) -> 'GEOMETRY'.

convert_type(Val, ColType) ->
    case ColType of
	T when T == 'TINY';
	       T == 'SHORT';
	       T == 'LONG';
	       T == 'LONGLONG';
	       T == 'INT24';
	       T == 'YEAR' ->
	    list_to_integer(binary_to_list(Val));
	T when T == 'TIMESTAMP';
	       T == 'DATETIME' ->
	    {?ok, [Year, Month, Day, Hour, Minute, Second], _Leftovers} = io_lib:fread("~d-~d-~d ~d:~d:~d", binary_to_list(Val)),
	    {datetime, {{Year, Month, Day}, {Hour, Minute, Second}}};
	'TIME' ->
	    {?ok, [Hour, Minute, Second], _Leftovers} = io_lib:fread("~d:~d:~d", binary_to_list(Val)),
	    {time, {Hour, Minute, Second}};
	'DATE' ->
	    {?ok, [Year, Month, Day], _Leftovers} = io_lib:fread("~d-~d-~d", binary_to_list(Val)),
	    {date, {Year, Month, Day}};
	T when T == 'DECIMAL';
	       T == 'NEWDECIMAL';
	       T == 'FLOAT';
	       T == 'DOUBLE' ->
	    {?ok, [Num], _Leftovers} = case io_lib:fread("~f", binary_to_list(Val)) of
									   {?error, _} ->
										   io_lib:fread("~d", binary_to_list(Val));
									   Res ->
										   Res
								   end,
		Num;
	T when T == 'TINYINT' ->
		<<Res:8>> = Val,
	    Res;
	_Other ->
	    Val
    end.


