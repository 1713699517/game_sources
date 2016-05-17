%% Author  : mirahs
%% Created: 2012-9-5
%% Description: TODO: Add description to team_mod
-module(flsh_mod).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
%%
%% Exported Functions
%%
-export([
		 game_start/0,
		 switch/2,
		 get_sld_times/1,
		 get_reward/1,
		 rand_flsh/0,
		 find_sz/1
		 ]).

%%
%% API Functions
%%
game_start() ->
	Flsh = role_api_dict:flsh_get(),
	if Flsh#flsh.times =< 0 ->
		   {?error,?ERROR_FLSH_NO_TIMES};
	   ?true ->
		   case Flsh#flsh.pai_data of
			   ?null ->
				   PaiData	= rand_flsh(),
				   MyPai	= list_to_tuple(PaiData),
				   role_api_dict:flsh_set(Flsh#flsh{pai_data=MyPai,is_get=?CONST_FALSE}),
				   BinMsg = flsh_api:msg_pai_reply(Flsh#flsh.swi_times,MyPai),
				   {?ok,BinMsg};
			   OldPaiData ->
				   BinMsg = flsh_api:msg_pai_reply(Flsh#flsh.swi_times,OldPaiData),
				   {?ok,BinMsg}
		   end
	end.

rand_flsh() ->
	AllNum = ?FLSH_NUM,
	NumList= rand_pai(AllNum,?CONST_FLSH_PLAYER_COUNT,?CONST_FLSH_PAI_COUNT,[]),
	NumList.

rand_pai(_PaiList,0,_Num2,AccList) ->
	AccList;
rand_pai(PaiList,Num1,Num2,AccList) ->
	RandNum = util:uniform(Num2),
	MyNum	= lists:nth(RandNum,PaiList),
	rand_pai(PaiList,Num1-1,Num2,AccList++[MyNum]).

switch(Player,PosList) ->
	Flsh = role_api_dict:flsh_get(),
	case Flsh#flsh.pai_data of
		?null ->
			{?error,?ERROR_FLSH_NO_PAI_DATA};
		OldPaiData ->
			PosList1 = [Pos || Pos <- PosList,Pos > 0,Pos =< ?CONST_FLSH_PLAYER_COUNT],
			case length(PosList) =:= length(PosList1) of
				?true ->
					case Flsh#flsh.swi_times < ?CONST_FLSH_FREE_SWITCH_TIMES of
						?true ->
							NewPaiData = switch(PosList,OldPaiData,?FLSH_NUM,?CONST_FLSH_PAI_COUNT),
							NewSwiTimes=Flsh#flsh.swi_times+1,
							role_api_dict:flsh_set(Flsh#flsh{pai_data=NewPaiData,swi_times=NewSwiTimes}),
							BinMsg = flsh_api:msg_pai_reply(NewSwiTimes,NewPaiData),
							{?ok,Player,BinMsg};
						_ ->
							NewSwiTimes=Flsh#flsh.swi_times + 1,
							Rmb = ?CONST_FLSH_CHANGE_RMB_USE * (NewSwiTimes - ?CONST_FLSH_FREE_SWITCH_TIMES),
							case role_api:currency_cut([switch,[],<<"牌语交换">>],Player,[{?CONST_CURRENCY_RMB, Rmb}]) of
								{?ok,Player2,Bin1} ->
									NewPaiData = switch(PosList,OldPaiData,?FLSH_NUM,?CONST_FLSH_PAI_COUNT),
									role_api_dict:flsh_set(Flsh#flsh{pai_data=NewPaiData,swi_times=NewSwiTimes}),
									Bin2 = flsh_api:msg_pai_reply(NewSwiTimes,NewPaiData),
									{?ok,Player2,<<Bin1/binary,Bin2/binary>>};
								{?error,ErrorCode} ->
									{?error,ErrorCode}
							end
					end;
				_ ->
					{?error,?ERROR_FLSH_POS_ERROR}
			end
	end.

switch([],PaiData,_AllNum,_PaiSum) ->
	PaiData;
switch([Pos|PosList],PaiData,AllNum,PaiSum) ->
	RandNum = util:uniform(PaiSum),
	MyNum	= lists:nth(RandNum,AllNum),
	NewPaiData = setelement(Pos,PaiData,MyNum),
	switch(PosList,NewPaiData,AllNum,PaiSum).

get_reward(Player) ->
	Flsh = role_api_dict:flsh_get(),
	case Flsh#flsh.pai_data of
		?null ->
			{?error,?ERROR_FLSH_NO_PAI_DATA};
		PaiData ->
			{SzNum,SameNum,DzNum} = get_sld_times(PaiData),
			{Player2,BinMsg} = get_reward(Player,Flsh,SzNum,SameNum,DzNum),
			{?ok,Player2,BinMsg}
	end.

%% get_sld_times(PilData) ->
%% 	?MSG_ECHO("------------------~w~n",[PilData]),
%% 	PilDataList = tuple_to_list(PilData),
%% 	MaxSz = find_sz(PilDataList),
%% 	case MaxSz >= ?CONST_FLSH_MIN_SZ of
%% 		?true -> %四连顺,五连顺
%% 			?MSG_ECHO("------------------~n",[]),
%% 			{MaxSz,0,0};
%% 		_ ->
%% 			?MSG_ECHO("------------------~n",[]),
%% 			IdCountList = util:lists_group(PilDataList),
%% 			?MSG_ECHO("------------------~w~n",[IdCountList]),
%% 			case lists:keyfind(5, 2, IdCountList) of
%% 				{_,5} -> %五张相同
%% 					?MSG_ECHO("------------------~n",[]),
%% 					{0,5,0};
%% 				_ ->
%% 					case lists:keyfind(4, 2, IdCountList) of
%% 						{_,4} -> %四张相同
%% 							?MSG_ECHO("------------------~n",[]),
%% 							{0,4,0};
%% 						_ ->
%% 							case lists:keytake(3, 2, IdCountList) of
%% 								{value,_,TmpCoutList} ->
%% 									case lists:keyfind(2, 2, TmpCoutList) of
%% 										{_,2} -> %三张相同带一对
%% 											?MSG_ECHO("------------------~n",[]),
%% 											{0,3,1};
%% 										_ -> %三张相同
%% 											?MSG_ECHO("------------------~n",[]),
%% 											{0,3,0}
%% 									end;
%% 								_ ->
%% 									DzNums = [Id || {Id,Count} <- IdCountList,Count =:= 2],
%% 									case length(DzNums) of
%% 										0 ->
%% 											case find_flsh(PilDataList) of
%% 												?true -> %风林山火
%% 													?MSG_ECHO("------------------~n",[]),
%% 													{1,1,1};
%% 												_ -> %什么也没有
%% 													?MSG_ECHO("------------------~n",[]),
%% 													{0,0,0}
%% 											end;
%% 										1 -> %一对
%% 											?MSG_ECHO("------------------~n",[]),
%% 											{0,0,1};
%% 										2 -> %两对
%% 											?MSG_ECHO("------------------~n",[]),
%% 											{0,0,2}
%% 									end
%% 							end
%% 					end
%% 			end
%% 	end.

get_sld_times(PilData) ->
	PilDataList = tuple_to_list(PilData),
	IdCountList = util:lists_group(PilDataList),
	case lists:keyfind(5, 2, IdCountList) of
		{_,5} -> %五张相同
			{0,5,0};
		_ ->
			case lists:keyfind(4, 2, IdCountList) of
				{_,4} -> %四张相同
					{0,4,0};
				_ ->
					MaxSz = find_sz(PilDataList),
					case MaxSz >= ?CONST_FLSH_MIN_SZ of
						?true -> %四连顺,五连顺
							{MaxSz,0,0};
						_ ->
							case lists:keytake(3, 2, IdCountList) of
								{value,_,TmpCoutList} ->
									case lists:keyfind(2, 2, TmpCoutList) of
										{_,2} -> %三张相同带一对
											{0,3,1};
										_ -> %三张相同
											{0,3,0}
									end;
								_ ->
									DzNums = [Id || {Id,Count} <- IdCountList,Count =:= 2],
									case length(DzNums) of
										1 -> %一对
											{0,0,1};
										2 -> %两对
											{0,0,2};
										_ ->
											{0,0,0}
									end
							end
					end
			end
	end.

get_reward(Player,Flsh,SzNum,SameNum,DzNum) ->
	case data_flsh_reward:get(SzNum, SameNum, DzNum) of
		#d_flsh_reward{money=Money,renown=Renown} ->
			{Player1,Bin1} = role_api:currency_add([get_reward,[],<<"风林山火">>],Player,[{?CONST_CURRENCY_GOLD,Money},{?CONST_CURRENCY_RENOWN,Renown}]),
			Bin2 = flsh_api:msg_reward_ok(SzNum, SameNum, DzNum),
			NewFlsh = Flsh#flsh{times=Flsh#flsh.times-1,pai_data=?null,is_get=?CONST_TRUE,swi_times=0},
			role_api_dict:flsh_set(NewFlsh),
			active_api:check_link(Player#player.uid,?CONST_ACTIVITY_LINK_108),
			{Player1,<<Bin1/binary,Bin2/binary>>};
		_ ->
			?MSG_ERROR("--------------NO_FLSH_DATA------------~w~n",[{SzNum,SameNum,DzNum}]),
			{Player,system_api:msg_error(?ERROR_UNKNOWN)}
	end.

%% find_flsh(PaiList) ->
%% 	find_flsh(?FLSH_LIST,PaiList).
%% 
%% find_flsh([],_PaiList) ->
%% 	?true;
%% find_flsh([Num|Nums],PaiList) ->
%% 	case lists:member(Num,PaiList) of
%% 		?true ->
%% 			find_flsh(Nums,PaiList);
%% 		_ ->
%% 			?false
%% 	end.

%% 找最长的顺子
%% arg:		NumList
%% return:	{SzNum,SzNumList}
find_sz(NumList) ->
	SzNumList	= find_sz(lists:sort(NumList),NumList,[]),
	SortNumList	= lists:sort(SzNumList),
	[Max|_]		= lists:reverse(SortNumList),
	Max.

find_sz([],_NumList,SzNumList) ->
	SzNumList;
find_sz([Num|Nums],NumList,SzNumList) ->
	SzNum = find_sz_acc(Num,NumList,0),
	find_sz(Nums,NumList,[SzNum|SzNumList]).

find_sz_acc(_Num,[],AccNum) ->
	AccNum;
find_sz_acc(Num,NumList,AccNum) ->
	case lists:member(Num,NumList) of
		?true ->
			NextNum = Num + 1,
			find_sz_acc(NextNum,lists:delete(Num,NumList),AccNum + 1);
		_ ->
			AccNum
	end.