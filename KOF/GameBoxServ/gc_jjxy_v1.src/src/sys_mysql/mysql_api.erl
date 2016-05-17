
-module(mysql_api).


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
-include("../include/drive.mysql.hrl"). 

-export([%%data2amf3/1,
		 escape/1, interval/0,
		 decode/1, encode/1,
		 
		 row_repeat/3,
		 add/2, add/3, cut/2, cut/3,
		 select/1, select/2, select/3, select/4, select/5, 
		 select_execute/1,
		 select_execute_logs/1,
		 select_max/1,
		 insert_execute/1, 
		 update_execute/1,
		 insert/2, insert/3,
		 insert_cast/2, insert_cast/3,
		 replace/2,
		 update/2, update/3, update/4,
		 update_insert/3, update_insert/4,
		 delete/1, delete/2,
		 fetch_cast/1, 
		 fetch_logs/1, fetch_logs/2,
		 fetch_cast_logs/1,
		 fetch/1,  fetch/2]).
%% ---------------------------------------------------------------------------------
%% -- MYSQL CALL
%% ---------------------------------------------------------------------------------
%% 定时调用
interval() ->
	idx:mysql_idx_clear_logs(),
	idx:mysql_idx_clear(),
	List = supervisor:which_children(mysql_sup),
	interval(List).
interval([]) -> ?ok;
interval([{_SrvName,_SrvPid,supervisor,_Mods}|List])-> interval(List);
interval([{_SrvName, SrvPid,_Type,     _Mods}|List])->
	mysql_srv:heart_cast(SrvPid),
	interval(List).


%% 返回 Bin
encode(Data)->
	Bin1	= term_to_binary(Data),
	Bin0	= zlib:compress(Bin1),
	iolist_to_binary("0x"++util:bin_to_hex(Bin0)). 

%% 返回 Data
decode(Bin)->
	Bin0 	= zlib:uncompress(Bin),
	binary_to_term(Bin0).

%% 转义一个字符串用于 mysql_query
escape(List)->
	List2 = util:to_list(List),
	% ?MSG_ECHO("List2:~p",[List2]),
	escape(List2,[]).

escape([],ListRs)->
	lists:reverse(ListRs);
%% \v \t \r \n \f \\ \0 \' \"
%escape([$\\,$v,List],ListRs) -- ----------------
escape([92,118|List],ListRs)->
	escape(List,[118,92|ListRs]);
%escape([$\\,$t,List],ListRs)
escape([92,116|List],ListRs)->
	escape(List,[116,92|ListRs]);
%escape([$\\,$r,List],ListRs)
escape([92,114|List],ListRs)->
	escape(List,[114,92|ListRs]);
%escape([$\\,$n,List],ListRs)
escape([92,110|List],ListRs)->
	escape(List,[110,92|ListRs]);
%escape([$\\,$f,List],ListRs)
escape([92,102|List],ListRs)->
	escape(List,[102,92|ListRs]);
%escape([$\\,$\\,List],ListRs)
escape([92,92|List],ListRs)->
	escape(List,[92,92|ListRs]);
%escape([$\\,$0,List],ListRs)
escape([92,48|List],ListRs)->
	escape(List,[48,92|ListRs]);
%escape([$\\,$',List],ListRs)
escape([92,39|List],ListRs)->
	%?MSG_ECHO("92,39",[]),
	escape(List,[39,92|ListRs]);
%escape([$\\,$\",List],ListRs)
escape([92,34|List],ListRs)->
	escape(List,[34,92|ListRs]);
%% \v \t \r \n \f \\ \0 \' \"
%escape([$\v,List],ListRs) -- ----------------
escape([11|List],ListRs)->
	escape(List,[118,92|ListRs]);
%escape([$\t,List],ListRs)
escape([9|List],ListRs)->
	escape(List,[116,92|ListRs]);
%escape([$\r,List],ListRs)
escape([13|List],ListRs)->
	escape(List,[114,92|ListRs]);
%escape([$\n,List],ListRs)
escape([10|List],ListRs)->
	escape(List,[110,92|ListRs]);
%escape([$\f,List],ListRs)
escape([12|List],ListRs)->
	escape(List,[102,92|ListRs]);
%escape([$\\,$\\,List],ListRs)
escape([92|List],ListRs)->
	escape(List,[92,92|ListRs]);
%escape([$\0,List],ListRs)
escape([0|List],ListRs)->
	escape(List,[48,92|ListRs]);
%escape([$\',List],ListRs)
escape([39|List],ListRs)->
	%?MSG_ECHO("92,39",[]),
	escape(List,[39,92|ListRs]);
%escape([$\",List],ListRs)
escape([34|List],ListRs)->
	escape(List,[34,92|ListRs]);
%% --- 0 --------------------------------
escape([H|List],ListRs)->
	escape(List,[H|ListRs]).


%% 异步
fetch_cast(Query)->
	PidFrom	= ?null, %% 不用返回 所以 设为 null
	Ref		= make_ref(),
	%%?MSG_ECHO("~p",[Query]),
	mysql_srv:fetch_cast(PidFrom, Ref, Query).



	

%% 实时(等待)
fetch(Query) ->
    fetch(Query, ?MYSQL_TIMEOUT_FETCH).
fetch(Query, Timeout) ->
	PidFrom	= self(),
	Ref		= make_ref(),
	fetch(Query, PidFrom, Ref, Timeout, 2).

fetch(Query, PidFrom, Ref, Timeout, Loop) when Loop > 0 ->
	mysql_srv:fetch_cast(PidFrom, Ref, Query),
	receive
		{?ok,Ref,Result} ->
			% ?MSG_ECHO("Result:~p",[Result]),
			{?ok, Result}
	after Timeout -> 
		fetch(Query,PidFrom,Ref, Timeout, Loop-1)
	end;
fetch(Query, _PidFrom, _Ref, Timeout, _Loop) ->
	Count  = idx:mysql_idx(), 
	if
		Count > ?MYSQL_REBOOT ->   % 重起一次mysql_srv
			mysql_sup:restart_child(),
			idx:mysql_idx_clear();
		?true ->
			?ok
	end,
	?MSG_ERROR("Reconn Error:~w Timeout:~p", [Query, Timeout]),
	{?error, mysql_timeout}.

%% 异步 日志
fetch_cast_logs(Query)->
	PidFrom	= ?null, %% 不用返回 所以 设为 null
	Ref		= make_ref(),
	%%?MSG_ECHO("~p",[Query]),
	mysql_side_srv:fetch_cast(mysql_side_srv_logs, PidFrom, Ref, Query).

%% 实时(等待)
fetch_logs(Query) ->
    fetch_logs(Query, ?MYSQL_TIMEOUT_FETCH).
fetch_logs(Query, Timeout) ->
	PidFrom	= self(),
	Ref		= make_ref(),
	fetch_logs(Query, PidFrom, Ref, Timeout, 2).

fetch_logs(Query, PidFrom, Ref, Timeout, Loop) when Loop > 0 ->
	mysql_side_srv:fetch_cast(mysql_side_srv_logs, PidFrom, Ref, Query),
	receive
		{?ok,Ref,Result} ->
			% ?MSG_ECHO("Result:~p",[Result]),
			{?ok, Result}
	after Timeout -> 
		fetch_logs(Query,PidFrom,Ref, Timeout, Loop-1)
	end;
fetch_logs(Query, _PidFrom, _Ref, Timeout, _Loop) ->
	Count  = idx:mysql_idx_logs(), 
	if
		Count > ?MYSQL_REBOOT ->   % 重起一次mysql_srv
			mysql_sup:restart_child_logs(),
			idx:mysql_idx_clear_logs();
		?true ->
			?ok
	end,
	?MSG_ERROR("Reconn Error:~w Timeout:~p", [Query, Timeout]),
	{?error, mysql_timeout}.

%% -------------------------------------------------------------------
%% data2amf3(Data)->
%% 	Fieldinfo = lib_tool:map2(fun({_Table, Field, _Length, _Type})-> Field end, Data#mysql_result.fieldinfo),
%% 	lib_tool:map2(fun(Data2)->
%% 						  {obj,lists:zip(Fieldinfo,Data2)} 
%% 				  end,Data#mysql_result.rows).
%% -------------------------------------------------------------------
%% rowRepeat
%% 回某個欄位元的內容是否重複
row_repeat(Table,Field, Value)->
	Query = " select count("++util:to_list(Field)++") as cc from "++util:to_list(Table)++" where `"++util:to_list(Field)++"` = '"++escape(Value)++"'",
	case fetch(Query) of
		{?ok,Data}->
			[[Rs]] = Data#mysql_result.rows,
			Rs;
		{?error,Data}->
			?MSG_ERROR("MYSQL SQL:~w DATA:~w~n",[Query,Data]),
			?error
	end.
%% -------------------------------------------------------------------
%% mysql_api:insert(1, gchy_mail, [{type,1},{send_uid,1},{send_name,1},{recv_uid,1},{recv_name,1},{title,1},{date,1},{content,1},{gold,1},{goods,1},{state,1},{pick,1}]).
insert(Table,Data)->
	insert(Table,Data,[]).
insert(Table,Datas,Ext)->
	SQL = insert_encode(Table,Datas,Ext),
	insert_execute(SQL).

insert_cast(Table,Data)->
	insert_cast(Table,Data,[]).
insert_cast(Table,Datas,Ext)->
	Sql = insert_encode(Table,Datas,Ext),
	fetch_cast(Sql).

insert_encode(Table,Datas,Ext)->
	Fun = fun({Field, {binary,Data} }, {Acc1, Acc2}) ->
				  {["`"++util:to_list(Field)++"`"|Acc1], [ escape(Data) |Acc2]};
			 ({Field, Data}, {Acc1, Acc2}) ->
				  {["`"++util:to_list(Field)++"`"|Acc1], ["'"++escape(Data)++"'"|Acc2]};
			 (_, {Acc1, Acc2}) ->
				  {Acc1, Acc2}
		  end,
	{FieldList, DatasList} = lists:foldl(Fun, {[],[]}, Datas),
	FieldString = util:list_to_string(FieldList, " (", ",", ") "),
	DatasString = util:list_to_string(DatasList, " (", ",", ") "),
	"INSERT INTO " ++ util:to_list(Table) ++ FieldString ++ " VALUES " ++ DatasString ++ util:to_list(Ext).
  

%% mysql_api:replace(1, gchy_mail, [{type,1},{send_uid,1},{send_name,1},{recv_uid,1},{recv_name,1},{title,1},{date,1},{content,1},{gold,1},{goods,1},{state,1},{pick,1}]).
replace(Table,Datas)->
	Fun = fun({Field, {binary,Data} }, {Acc1, Acc2}) ->
				  {["`"++util:to_list(Field)++"`"|Acc1], [ escape(Data) |Acc2]};
			 ({Field, Data}, {Acc1, Acc2}) ->
				  {["`"++util:to_list(Field)++"`"|Acc1], ["'"++escape(Data)++"'"|Acc2]};
			 (_, {Acc1, Acc2}) ->
				  {Acc1, Acc2}
		  end,
	{FieldList, DatasList} = lists:foldl(Fun, {[],[]}, Datas),
	FieldString = util:list_to_string(FieldList, " (", ",", ") "),
	DatasString = util:list_to_string(DatasList, " (", ",", ") "),
	SQL = "REPLACE INTO " ++ util:to_list(Table) ++ FieldString ++ " VALUES " ++ DatasString,
	insert_execute(SQL).

update(Table,DataList)->
	update(Table,DataList,[],0).
update(Table,DataList,Where)->
	update(Table,DataList,Where,0).
update(Table,DataList,Where,Limit)->
	case Limit of
		0 ->
			Limit2 = "";
		_ ->
			Limit2 = " LIMIT " ++ util:to_list(Limit)
	end,
	case Where of
		[] ->
			Where2 = Limit2;
		_  -> 
			Where2 = " WHERE " ++ util:to_list(Where) ++ Limit2
	end,
	DataStr = lists:map(fun({Field, {binary,Data} }) ->
								"`"++util:to_list(Field)++"`  =  "++escape(Data)++"";
						   ({Field,Data})->
								 "`"++util:to_list(Field)++"` = '"++escape(Data)++"'"
						end,DataList),
	DataStr2= util:list_to_string(DataStr, "UPDATE "++util:to_list(Table)++" SET ", ",", Where2),
	update_execute(DataStr2).

add(Table,DataList)->
	add(Table,DataList,[]).
add(Table,DataList,Where)->
	case Where of
		[] ->
			Where2 = [];
		_  -> 
			Where2 = " WHERE " ++ util:to_list(Where)
	end,
	DataStr = lists:map(fun ({Field,Data})->
								 "`"++util:to_list(Field)++"` = `"++util:to_list(Field)++"` + "++util:to_list(Data)
						end,DataList),
	DataStr2= util:list_to_string(DataStr, "UPDATE "++util:to_list(Table)++" SET ", ",", Where2),
	update_execute(DataStr2).

cut(Table,DataList)->
	cut(Table,DataList,[]).
cut(Table,DataList,Where)->
	case Where of
		[] ->
			Where2 = [];
		_  -> 
			Where2 = " WHERE " ++ util:to_list(Where)
	end,
	DataStr = lists:map(fun ({Field,Data})->
								 "`"++util:to_list(Field)++"` = `"++util:to_list(Field)++"` - "++util:to_list(Data)
						end,DataList),
	DataStr2= util:list_to_string(DataStr, "UPDATE "++util:to_list(Table)++" SET ", ",", Where2),
	update_execute(DataStr2).

update_insert(Table,PrimaryDataList,DataList)->
	update_insert(Table,PrimaryDataList,DataList,update). 
update_insert(Table,PrimaryDataList,DataList,Type)->
	case Type of
		add ->
			ExtStr = lists:map(fun ({Field,Data})->
										 "`"++util:to_list(Field)++"` = `"++util:to_list(Field)++"` + "++util:to_list(Data)
								end,DataList);
		cut ->
			ExtStr = lists:map(fun ({Field,Data})->
										"`"++util:to_list(Field)++"` = `"++util:to_list(Field)++"` - "++util:to_list(Data)
							   end,DataList);
		update ->
			ExtStr = lists:map(fun ({Field, {binary,Data} }) ->
										"`"++util:to_list(Field)++"` =  "++escape(Data)++" ";
								   ({Field,Data})->
										"`"++util:to_list(Field)++"` = '"++escape(Data)++"'"
							   end,DataList)
	end,
	AllDataList = lists:append([PrimaryDataList,DataList]),
	%%{HeaderStr,DataStr} = lists:unzip(AllDataList),
	HeaderStr 	= lists:map(fun ({Field2,_Data2}) -> "`"++util:to_list(Field2)++"`" end, AllDataList),
	DataStr		= lists:map(fun ({_Field3, {binary,Data3} }) -> " "++escape(Data3)++" ";
								({_Field3,Data3}) 			 -> "'"++escape(Data3)++"'" end, AllDataList),
	ExtStr2     = util:list_to_string(ExtStr, " ", ",", " "),
	HeaderStr2 	= util:list_to_string(HeaderStr, " (", ",", ") "),
	DataStr2 	= util:list_to_string(DataStr, " (", ",", ")"),
	DataStr3	= "INSERT INTO "++util:to_list(Table)++HeaderStr2++" VALUES "++DataStr2 ++" ON DUPLICATE KEY UPDATE " ++ ExtStr2,
	insert_execute(DataStr3).

delete(Table)->
	update_execute("DELETE  FROM "++util:to_list(Table)).
delete(Table,Where)->
	update_execute("DELETE  FROM "++util:to_list(Table)++" WHERE "++util:to_list(Where)).
update_execute(SQL)->
	case fetch(SQL) of
		{?ok,Data}	->
			{?ok,		Data#mysql_result.affectedrows}; 
		{?error,Data}->
			{?error,	Data#mysql_result.error}
	end.

insert_execute(SQL)->
	case fetch(SQL) of
		{?ok,Data2}	->
			if 
				Data2#mysql_result.affectedrows > 0 ->
					{?ok,Data2#mysql_result.affectedrows,Data2#mysql_result.lastinsertid};
				?true ->
					{?ok,0,0}
			end;
		{?error,Data2}->
			{?error,Data2#mysql_result.error}
	end.

%% mysql_api:select(1, [mail_id, title], gchy_mail).
%% mysql_api:select(1, [mail_id, title], gchy_mail, [{mail_id,222},{date,111}]).
%% mysql_api:select(1, [mail_id, title], gchy_mail, [{mail_id,222},{date,111}], {gold,asc}, 30).
select(SQL) ->
	select_execute(SQL).  
select(Fields, Table) ->
	select(Fields, Table, [], [], 0).
select(Fields, Table, Where) -> 
	select(Fields, Table, Where, [], 0).
select(Fields, Table, Where, Order) ->
	select(Fields, Table, Where, Order, 0).
select(Fields, Table, Where, Order, Limit) ->
	case Limit of
		0 -> LimitString = [];
		_ -> LimitString = " LIMIT " ++ util:to_list(Limit)
	end,
	case Order of
		[] -> OrderString = LimitString;
		{OrderField,  AscDesc}  ->
			OrderString = " ORDER BY `" ++ util:to_list(OrderField) ++ "` "++ util:to_list(AscDesc) ++ LimitString
	end,
	case Where of
		[] -> WhereString = OrderString;
		_  ->
			WhereList 	= ["`" ++ util:to_list(Field) ++ "` = '" ++ escape(Data) ++ "'" || {Field, Data} <- Where],
			WhereString = util:list_to_string(WhereList, " WHERE ", " AND ", OrderString)
	end,
	FieldsString = ["`" ++ util:to_list(Field) ++ "`"|| Field <- Fields],
	SQL 		 = util:list_to_string(FieldsString, "SELECT ", ",", " FROM " ++ util:to_list(Table) ++ WhereString),
	select_execute(SQL). 

%% mysql_api:select_execute(1, "SELECT `uid` FROM gchy_user WHERE `uname` = '华华'").
select_execute(SQL) -> 
	case fetch(SQL) of
		{?ok, _Result = #mysql_result{rows = Data, error = []}} ->
			{?ok, Data};
		{?ok, _Result = #mysql_result{error = Error}} ->
			{?error, Error};
		{?error, _Result = #mysql_result{error = Error}}->
			{?error,	Error};
		{?error, Error} ->
			{?error, Error}
	end.

select_execute_logs(SQL) -> 
	case fetch_logs(SQL) of
		{?ok, _Result = #mysql_result{rows = Data, error = []}} ->
			{?ok, Data};
		{?ok, _Result = #mysql_result{error = Error}} ->
			{?error, Error};
		{?error, _Result = #mysql_result{error = Error}}->
			{?error,	Error};
		{?error, Error} ->
			{?error, Error}
	end.

select_max(SQL)->
	case fetch(SQL) of
		{?ok, _Result = #mysql_result{rows = Data, error = []}} ->
			case Data of
				[[?null]]->
					{?ok,[[0]]};
				_->
					{?ok, Data}
			end;
		{?ok, _Result = #mysql_result{error = Error}} ->
			{?error, Error};
		{?error, _Result = #mysql_result{error = Error}}->
			{?error,	Error};
		{?error, Error} ->
			{?error, Error}
	end.