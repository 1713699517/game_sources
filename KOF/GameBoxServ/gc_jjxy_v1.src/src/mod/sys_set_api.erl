%% Author  : mirahs
%% Created: 2012-6-20
%% Description: TODO: Add description to team_api
-module(sys_set_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 encode_sys_set/1,
		 decode_sys_set/1,
		 
		 init/1,
		 sys_set/1,
		 sys_set_login/1,
		 
		 msg_type_state/1
		]).

encode_sys_set(SysSet) ->
	SysSet.

decode_sys_set(SysSet) -> 
	SysSet.

init(Player)->
	List=data_sys_set:get(),
	{Player,List}.

sys_set(Type)->
	Lists=role_api_dict:sys_set_get(),
	case lists:keytake(Type,1,Lists) of
		{_,{Type,State},Lists2}->
			State2=?IF(State==?CONST_TRUE,?CONST_FALSE,?CONST_TRUE),
			[{Type,State2}|Lists2];
		_->
			Lists
	end.
	
%% sys_get()->
%% 	[{StepId,?CONST_TRUE}||StepId<-?SYS_SET_STEP].

sys_set_login(Socket)->
	Lists=role_api_dict:sys_set_get(),
	Lists2=lists:sort([StepId||{StepId,_}<-Lists]),
	Lists3=case ?SYS_SET_STEP--Lists2 of
		[]->
			Lists;
		R->
			[{RStepId,?CONST_FALSE}||RStepId<-R]++Lists
	end,
	role_api_dict:sys_set_set(Lists3),
	BinMsg=msg_type_state(Lists3),
	app_msg:send(Socket,BinMsg).

%%%%%%%%%%%%%%%%%%%%%%%%%%  msg xxxxxxxxxxx  %%%%%%%%%%%%%%%%%%%%%%%%%%%

% 各功能状态 [56820]
msg_type_state(List)->
	Count=length(List),
	Rs=app_msg:encode([{?int16u,Count}]),
	Fun=fun({Type,State},Acc)->
				Acc2=app_msg:encode([{?int16u,Type},{?int8u,State}]),
				<<Acc/binary,Acc2/binary>>
		end,
	RsList=lists:foldl(Fun,Rs,List),
    app_msg:msg(?P_SYS_SET_TYPE_STATE, RsList).



