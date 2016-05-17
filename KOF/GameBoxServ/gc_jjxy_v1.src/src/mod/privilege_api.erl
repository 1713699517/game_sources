%% Author  : mirahs
%% Created: 2012-6-20
%% Description: TODO: Add description to team_api
-module(privilege_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 decode_privilege/1,
		 encode_privilege/1,
		 request_privilege/0,
		 init/1,
		 init/0,
 		 login/0,
		 refresh/0,
		 open/1,
		 
		 get_rewards/1,

		 msg_reply/2,
		 msg_reply/5,
		 msg_open_reply/0
		]).

encode_privilege(Privilege) ->
	Privilege.

decode_privilege(Privilege) when is_record(Privilege,privilege) -> 
	Privilege;
decode_privilege(_Privilege) ->
	init().

%% 初始化投资理财信息
init(Player) -> 
	Privilege= init(),
	{Player,Privilege}.

init() ->
	Date= util:date(),
	DictPrivilege = #privilege{is_open= 0, day = 1, date = Date, is_get = 0 },
	role_api_dict:privilege_set(DictPrivilege),
	DictPrivilege.

refresh()->
	login().

login() ->
	Now= util:date(),
	Privilege= role_api_dict:privilege_get(),
	#privilege{is_open= IsOpen, date= Date}= Privilege,
	case IsOpen == 1 of 
		?true ->
			case util:days_diff(Now, Date) =:= 0 of
				?true ->
					?skip;
				_ ->
					role_api_dict:privilege_set(Privilege#privilege{date=Now,is_get=0})
			end;
		_ ->
			?skip
	end.
	

open(Player) ->
	Date= util:date(),
	#privilege{is_open=IsOpen}= role_api_dict:privilege_get(),
	case IsOpen =:= 0 of 
		?true ->
			case role_api:currency_cut([privilege,[],<<"开启投资理财">>], Player, [{?CONST_CURRENCY_RMB,?CONST_PRIVILEGE_RMB}]) of
				{?ok,Player2,Bin1} ->
					DictPrivilege = #privilege{is_open=1 , day = 1, date = Date, is_get = ?CONST_SIGN_NO },
					role_api_dict:privilege_set(DictPrivilege),
					Bin2= msg_open_reply(),
					?MSG_ECHO("======================~n",[]),
					{?ok,Player2,<<Bin1/binary,Bin2/binary>>};
				{?error,ErrorCode}-> 
					?MSG_ECHO("======================~n",[]),
					{?error,ErrorCode}
			end;
		_->
			?MSG_ECHO("======================~n",[]),
			{?error,?ERROR_PRIVILEGE_REOPEN}
	end.

request_privilege() ->
	Now= util:date(),
	Privilege= role_api_dict:privilege_get(),
	#privilege{is_open= IsOpen, date= Date,is_get=IsGet, day=Day}= Privilege,
	case IsOpen =:= 1 of 
		?true ->
			case util:days_diff(Now, Date) =:= 0 of
				?true ->
					{Money,Rmb} =get_reward(Day),
					msg_reply(IsOpen, Day, IsGet, Money, Rmb);
				_ ->
					role_api_dict:privilege_set(Privilege#privilege{date=Now,is_get=0}),
					?MSG_ECHO("======================~w~n",[Privilege#privilege{date=Now,is_get=0}]),
					{Money,Gold} =get_reward(Day),
					msg_reply(IsOpen, Day, IsGet, Money, Gold)
			end;
		_ ->
			NeedGold= ?CONST_PRIVILEGE_RMB,
			msg_reply(IsOpen, NeedGold)
	end.

get_rewards(Player) ->
	Now= util:date(),
	Privilege= role_api_dict:privilege_get(),
	#privilege{is_open= IsOpen, date= Date,is_get=IsGet, day=Day}= Privilege,
	case IsOpen == 1 of
		?true ->
			case util:days_diff(Now, Date) == 0 of
				?true ->
					case IsGet == 0 of
						?true ->
							{Gold,Rmb} =get_reward(Day),
							Day1 =Day +1,
							role_api_dict:privilege_set(Privilege#privilege{is_get=1,day=Day1}),
							{Player2,Bin} = role_api:currency_add([privilege,[],<<"投资理财">>], Player, [{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_RMB,Rmb}]),
							{?ok,Player2,Bin};
						_ ->
							?MSG_ECHO("======================~n",[]),
							{?error,?ERROR_PRIVILEGE_GOT_REWARD}
					end;
				_ ->
					?MSG_ECHO("======================~n",[]),
					refresh()
			end;
		_ ->
			?MSG_ECHO("======================~n",[]),
			{?error,?ERROR_PRIVILEGE_NO_OPEN}
	end.
					



get_reward(Day) ->
	case data_privilege:get(Day) of
		#d_privilege{gold=Gold, rmb= Rmb} ->
			{Gold, Rmb};
		_ ->
			{0,0}
	end.

% 面板返回 [53220]
msg_reply(IsOpen,Day,IsGet,Money,Gold)->
    RsList = app_msg:encode([{?int8u,IsOpen},{?int8u,Day},{?int8u,IsGet},{?int32u,Money},{?int32u,Gold}]),
    app_msg:msg(?P_PRIVILEGE_REPLY, RsList).

% 面板返回 [53220]
msg_reply(IsOpen,NeedGold)->
    RsList = app_msg:encode([{?int8u,IsOpen},{?int32u,NeedGold}]),
    app_msg:msg(?P_PRIVILEGE_REPLY, RsList).


% 开通新手特权成功 [53240]
msg_open_reply()->
    app_msg:msg(?P_PRIVILEGE_OPEN_REPLY,<<>>).
