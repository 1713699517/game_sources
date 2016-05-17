%% Author: acer
%% Created: 2012-12-06
%% Description: TODO: Add description to vip_api.
-module(is_funs_api).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
%%
%% API exports
-export([
		 gm/2,
		 
		 get_funs_state/0,
		 set_funs_state/1,
		 check_fun/1,
		 start_funs/0
		]).


%% 检查功能是否开放 
%% reg: FunId
%%　return: ?CONST_TRUE | ?CONST_FALSE
check_fun(FunId) ->
	case ets:lookup(?ETS_PUBLIC_RECORDS,?CONST_PUBLIC_KEY_FUNS_STATE) of
		[{?CONST_PUBLIC_KEY_FUNS_STATE,EtsList}|_] -> 
			case lists:keyfind(FunId, 1, EtsList) of
				{FunId,State} -> ?IF(State =:= ?CONST_FALSE,?CONST_FALSE,?CONST_TRUE);
				_ -> ?CONST_TRUE
			end;
		_ ->
			?CONST_TRUE
	end.

%% 开服调用，初始化数据
start_funs() ->
	AllFuns = data_is_fun:get(),
	ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_FUNS_STATE,AllFuns}).


%% 后台调用    修改    ets表内功能开关状态
set_funs_state(AllFuns) ->
	F =fun({Id,State},Acc) -> 
			   ?IF(lists:member(State, [0,1]), [{Id,State}|Acc], Acc);
		  (Err, Acc) ->
			   ?MSG_ERROR(" set_funs_data_error: ~w~n ",[Err]),
			   Acc
	   end,
	AllFuns2= lists:foldl(F, [], AllFuns),
	ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_FUNS_STATE,AllFuns2}).

%% 后台调用    查询    ets表内功能开关状态
get_funs_state() ->
	case ets:lookup(?ETS_PUBLIC_RECORDS, ?CONST_PUBLIC_KEY_FUNS_STATE) of
		[{_,EtsList}|_] -> 
			EtsList;
		_ ->
			[]
	end.

%% GM命令
gm(Id,State) ->
	case ets:lookup(?ETS_PUBLIC_RECORDS, ?CONST_PUBLIC_KEY_FUNS_STATE) of
		[{_,EtsList}|_] -> 
			case lists:keytake(Id, 1, EtsList) of
				{value, {Id,State}, _TupleList2} ->
					ok;
				{value, {Id,_}, TupleList2} ->
					AllFuns = [{Id,State}|TupleList2],
					ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_FUNS_STATE,AllFuns});
				_ ->
					AllFuns = [{Id,State}|EtsList],
					ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_FUNS_STATE,AllFuns})
			end;
		_ ->
			ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_FUNS_STATE,[{Id,State}]})
	end.












