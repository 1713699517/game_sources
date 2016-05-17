%% Author  : zxy
%% Created: 2012-6-20
%% Description: TODO: Add description to team_api
-module(friend_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([encode_friend/1,
		 decode_friend/1,
		 
		 init/0,
		 init/1,
		 
		 add_recent/1,
		 add_recent2/2,
		 add_recent2_cb/2,
		 level_up/3,
		 list_is_null/1,
		 get_last/3,
		 deleteList/2,
		 check_is_friend/2,
		 
 		 refresh/0,
		 
		 get_sql_uid/3,
		 recomm_friend/2,
		 msg_friend_sys/2,
		 msg_friend_request/2
%% 		 msg_search_info/1
		]).

encode_friend(Friend) ->
	Friend.

decode_friend(Friend) ->
	Friend.

%% 初始化
init(Player) ->
	Friend = init(),
	{Player,Friend}.

init() ->
	[].

%% 凌晨十二点或登录刷新最近联系人
refresh() ->
	Time = util:seconds(),
	Friends = role_api_dict:friend_get(),
	Type = ?CONST_FRIEND_RECENT,
	RecentFriends = get_recent(Friends,Type),
	Fun = fun(Friend , Acc) ->
				  case Time - Friend#friend.time > 86400 of
					  ?true ->
						  [Friend|Acc];
					  ?false ->
						  Acc
				  end
		  end,
	NewRecentFriends = lists:foldl(Fun, [],RecentFriends),
	NewRelation = deleteList(NewRecentFriends, Friends),
	role_api_dict:friend_set(NewRelation).

%% 判断是否为好友（Ftype == 1）  联系人（Ftype=2） 黑名单（Ftype=3）
check_is_friend(Fuid,Ftype) ->
	Friends = role_api_dict:friend_get(),
	case friend_mod:is_friend(Fuid,Ftype,Friends) of
		#friend{} ->
			?true;
		_ ->
			?false
	end.

%% 收到信息将对方添为最近联系人
add_recent2(PUid,Uid)->
%%  ?MSG_ECHO("-----------------------~w~n",[{PUid,Uid}]),
	util:pid_send(PUid,?MODULE,add_recent2_cb, Uid).

add_recent2_cb(Player,Uid)->
%% 	?MSG_ECHO("-----------------------~w~n",[{Player,Uid}]),
%% 	#relation{friend =Friends } = role_api_dict:friend_get(),
%% 	?MSG_ECHO("-----------------------~w~n",[Friends]),
	add_recent(Uid),
	Player.

%% 添加最近联系人接口
add_recent(Fuid) ->
	Time = util:seconds(),
	Type = ?CONST_FRIEND_RECENT,
	Friends = role_api_dict:friend_get(),
	case friend_mod:is_friend(Fuid,Type,Friends) of
		?false ->
			RecentFriends = get_recent(Friends,Type),
			NewFriend= #friend{uid=Fuid,type= Type,time = Time},
			?MSG_ECHO("-----------------  ~w~n",[RecentFriends]),
			case length(RecentFriends) < ?CONST_FRIEND_RECENT_COUNT of 
				?true ->
					?MSG_ECHO("-----------------  ~w~n",[NewFriend]),
					role_api_dict:friend_set([NewFriend|Friends]);
				?false ->
					?MSG_ECHO("-----------------  ~w~n",[NewFriend]),
					LastFriend = get_last(RecentFriends,Time,NewFriend),
					Uid = LastFriend#friend.uid,
					NewFriends= friend_mod:delete_friend2(Uid, Type),
					?MSG_ECHO("-----------------  ~w~n",[NewFriends]),
					role_api_dict:friend_set([NewFriend|NewFriends])
			end;
		Friend ->
			NewFriends= lists:delete(Friend, Friends),
			NewFriend= #friend{uid=Fuid,type= Type,time = Time},
			role_api_dict:friend_set([NewFriend|NewFriends])
			
	end.



get_recent(Friends,Type) ->
	[ Friend || Friend <- Friends,Friend#friend.type=:=Type].

get_last([#friend{time = Time} = Friend|T],Last,Acc) ->
	?MSG_ECHO("----------------------   ~w~n",[{Time,Last}]),
	case Time =:= 0 of 
		?true ->
			get_last(T, Last,Acc);
		?false ->
			case Time < Last of
				true ->
					NewLast = Time,
					NewAcc = Friend,
					get_last(T, NewLast,NewAcc);
				false ->
					get_last(T, Last,Acc)
			end
	end;
		
get_last([], _Last,Acc) ->
	Acc.


%% get_list_length([_H|T]) ->
%% 	1+ get_list_length(T);
%% get_list_length([]) ->
%% 	0.

%% 当等级达到某个等级时  系统自动推荐好友
level_up(Lv,Socket,Uid) ->
	LvList = [?CONST_FRIEND_TWENTY_FIVE,?CONST_FRIEND_THIRTY,?CONST_FRIEND_THIRTY_FIVE],
	case lists:member(Lv, LvList) of
		?true ->
			recomm_friend(Socket,Uid);
		?false ->
			?skip
	end.


	
%% 系统推荐好友
recomm_friend(Socket,Uid) ->
	Type = ?CONST_FRIEND_FRIEND,
	Players = ets:tab2list(?ETS_ONLINE),
	OnLineUid = [Player#player.uid || Player <- Players],
	Fun2 = fun(LUid,Acc) ->
				   case friend_mod:check_is_friend(LUid,Type) of 
					   ?true ->
						   Acc;
					   ?false ->
						   [LUid|Acc]
				   end
		   end,
	FriendUid = lists:foldl(Fun2, [],OnLineUid),
	LeaveList = lists:delete(Uid, FriendUid),
	?MSG_ECHO("-----------------------~w~n",[{OnLineUid,FriendUid,LeaveList}]),
	Fun = fun (Uid,{Count1,Acc}) ->
				   case Count1 <?CONST_FRIEND_SYS_RECOMMEND of
					   ?true ->
						   {Count1+1 , [Uid|Acc]};
					   ?false ->
						   {Count1 , Acc}
				   end
		  end,
	{Count1,Bin} = lists:foldl(Fun, {0,[]}, LeaveList),
	case Count1 <?CONST_FRIEND_SYS_RECOMMEND of
		?true ->
			MyLimit = ?CONST_FRIEND_SYS_RECOMMEND - Count1,
			OffLineList = get_sql_uid(Bin,MyLimit,Uid),
			{_Count2,Bin1} = lists:foldl(Fun, {Count1,Bin}, OffLineList),
			msg_friend_sys(Bin1,Socket);
		_ ->
			msg_friend_sys(Bin,Socket)
	end.


				
%% 拿到不在线玩家的信息
get_sql_uid(OnUid,Limit,Uid) ->
	Friends= role_api_dict:friend_get(),
	AllFriendUid = [Friend#friend.uid || Friend <- Friends],
 	AllUid = AllFriendUid++OnUid,
	AllUid2= [Uid|AllUid],
	?MSG_ECHO("------------------------~w~n",[AllUid2]),
	OnList	= util:list_to_string(AllUid2, "(" , ",", ")"),
	Sql="SELECT `uid` FROM  `user` WHERE `uid` not in " ++ util:to_list(OnList) ++ "limit " ++ util:to_list(Limit),
	case mysql_api:select(Sql) of
		{?ok, []} ->
			[];
		{?ok, Datas} ->
			get_list2atom(Datas,[]);
		{?error, _Reason} ->
			[]
	end.	

deleteList([H|T],Lists) ->
	NewList= lists:delete(H, Lists),
	deleteList(T, NewList);
deleteList([], Lists) ->
	Lists.

list_is_null([_H|_])->
	?false;
list_is_null([])->
	?true.

get_list2atom([H|T],Acc) ->
	[H1|_]	= H,
	NewAcc	= [H1 | Acc],
	get_list2atom(T,NewAcc);
get_list2atom([],Acc) ->
	Acc.

% 请求好友数据返回
msg_friend_request(Type, List) ->
	Fun = fun(#friend{uid=Uid},{Count1,Acc1}) ->
				  case friend_mod:get_rel_info(Uid) of
					  ?null ->
						  {Count1,Acc1}; 
					  Data ->
						  Bin1 = msg_info_group(Data),
						  {Count1 + 1,<<Acc1/binary,Bin1/binary>>}
				  end
		  end,			  
	{Count,Bin} = lists:foldl(Fun, {0,<<>>}, List),
	Bin2 = app_msg:encode([{?int8u,Type},{?int16u,Count}]),
	app_msg:msg(?P_FRIEND_INFO,<<Bin2/binary,Bin/binary>>).
%% 系统推荐玩家数据返回
msg_friend_sys(List,Socket) ->
	?MSG_ECHO("---------~w~n",[List]),
	Fun = fun(Uid,{Count1,Acc1}) ->
				  case friend_mod:get_rel_info(Uid) of
					  ?null ->
						  {Count1,Acc1}; 
					  Data ->
%% 						  ?MSG_ECHO("---------~w~n",[Data]),
						  Bin1 = msg_info_group(Data),
						  {Count1 + 1,<<Acc1/binary,Bin1/binary>>}
				  end
		  end,			  
	{Count,Bin} = lists:foldl(Fun, {0,<<>>}, List),
	?MSG_ECHO("---------~w~n",[Count]),
	Bin2 = app_msg:encode([{?int16u,Count}]),
	BinMsg = app_msg:msg(?P_FRIEND_SYS_FRIEND,<<Bin2/binary,Bin/binary>>),
	app_msg:send(Socket, BinMsg).

	

msg_info_group({Fid,Fname,Fclan,Flv,Isonline,Pro})->
	app_msg:encode([{?int32u,Fid},{?string,Fname},{?string,Fclan},{?int8u,Flv},{?int16u,Isonline},{?int8u, Pro}]).

