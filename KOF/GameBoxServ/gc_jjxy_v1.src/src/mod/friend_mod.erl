%% Author  : zhengxinyi
%% Created: 2013-7-29
%% Description: TODO: Add description to team_mod
-module(friend_mod).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
%%
%% Exported Functions
%%
-export([
		 is_friend/3,
		 get_rel_info/1,
		 request_friend/1,
		 get_name_to_uid/1,
		 search_friend_add/1,
		 friend_add/3,
		 delete_friend/2,
		 delete_friend2/2,
		 get_uid_to_name/1,
		 get_friend/2,
%% 		 get_list_length/1,
		 check_is_friend/2,
		 list_to_uid/1
		 ]). 

request_friend(Type) ->
	Friends = role_api_dict:friend_get(),
	Friend = [Fri || Fri <- Friends,Fri#friend.type =:= Type],
	Friend2 = lists:reverse(Friend),
	friend_api:msg_friend_request(Type,Friend2).
	

%% 添加好友
friend_add(_Player,_Type,0) ->
	?ok;
friend_add(#player{uid = Uid,socket = Socket},_Type,Fuid) when Uid =:= Fuid ->
	MsgErr = system_api:msg_error(?ERROR_FRIEND_ADD_MYSELF),
	app_msg:send(Socket, MsgErr);
friend_add(#player{socket = Socket,uid = Uid,uname = Name},Type,Fuid) ->
	Friends = role_api_dict:friend_get(),
	Date= util:seconds(),
	Friends2 = get_friend(Friends, Type),
	case length(Friends2) < ?CONST_FRIEND_MAX of 
		?true ->
			case is_friend(Fuid,Type,Friends) of
				?false ->
					Friend= #friend{uid=Fuid,type= Type, time= Date},
					role_api_dict:friend_set([Friend|Friends]),
					BinMsg = request_friend(Type),
					app_msg:send(Socket, BinMsg),
					%%发送好友添加通知
					case role_api:is_online(Fuid) of
						?true  ->
							case check_is_friend(Uid,Type) of 
								?false ->
									Bin = app_msg:encode([{?int32u,Uid},{?string,Name}]),
									NoticeMsg = app_msg:msg(?P_FRIEND_ADD_NOTICE,<<Bin/binary>>),
%% 									?MSG_ECHO("-----      -----------~w~n",[NoticeMsg]),
									app_msg:send(Fuid, NoticeMsg);
								?true ->
									?skip
							end;
						?false ->
							?skip
					end;
				_ ->
					ErrorMsg = ?ERROR_FRIEND_CONTACT_EXIST,
					BinMsg = system_api:msg_error(ErrorMsg),
					app_msg:send(Socket, BinMsg)
			end;
		?false ->
			ErrorMsg2 = ?ERROR_FRIEND_TOPLIMIT,
			BinMsg2 = system_api:msg_error(ErrorMsg2),
			app_msg:send(Socket, BinMsg2)
	end.
	
	

get_friend([#friend{type = Type}=Friend|T],Type1) ->
	case Type =:= Type1 of 
		true ->
			[Friend|get_friend(T,Type1)];
		false ->
			get_friend(T,Type1)
	end;

get_friend([],_) ->
	[].

%% get_list_length([_|T]) ->
%% 	1+ get_list_length(T);
%% get_list_length([]) ->
%% 	0.

	
is_friend(_Uid,_Type,[]) ->
	?false;
is_friend(Uid,Type,[#friend{type=Type,uid=Uid}=Friend|_]) ->
	 Friend;
is_friend(Uid,Type,[_|T]) ->
	is_friend(Uid,Type,T).


%% 判断是否为好友（Ftype == 1）  联系人（Ftype=2） 黑名单（Ftype=3）
check_is_friend(Fuid,Ftype) ->
 	Friends = role_api_dict:friend_get(),
		case is_friend(Fuid,Ftype,Friends) of
			#friend{} ->
				?true;
			_ ->
				?false
		end.

get_rel_info(Fuid) ->
	case role_api_dict:player_get(Fuid) of 
		{?ok,#player{uid= Uid, lv=Lv, uname= Name,pro = Pro}} ->
			Online = ?IF(role_api:is_online(Fuid),?CONST_TRUE,?CONST_FALSE),
			ClanName = clan_api:clan_name_get(Uid),
%% 			?MSG_ECHO("----------------~w~n",[{Fuid, Name, ClanName, Lv, Online,Pro}]),
%% 			Power= Info#info.power,
%% 			Powerful= Info#info.powerful,
%% 			?MSG_ECHO("----------------~w~n",[{Power, Powerful}]),
			%%%%%在这里取是否在线信息？？？？？？？？
			{Fuid, Name, ClanName, Lv, Online,Pro};
		_ ->
			?null
	end.

%% 删除好友
delete_friend(Uid, Type) ->
	Friends = role_api_dict:friend_get(),
	case is_friend(Uid,Type,Friends) of
		?false ->
			{?error,?ERROR_COUNTRY_POST_CHECK_NULL};
		Friend ->
			NewFriends = lists:delete(Friend,Friends),
			role_api_dict:friend_set(NewFriends),
    		RsList = app_msg:encode([{?int32u,Uid}]),
    		Msg= app_msg:msg(?P_FRIEND_DEL_OK, RsList),
			{?ok,Msg}
	end.

%% 删除好友
delete_friend2(Uid, Type) ->
	Friends = role_api_dict:friend_get(),
	case is_friend(Uid,Type,Friends) of
		?false ->
			Friends;
		Friend ->
			lists:delete(Friend,Friends)
	end.




%% 根据玩家名称添加好友
search_friend_add(Uname) ->
	case get_name_to_uid(Uname) of
		{?ok,UidList} ->
			Fun = fun([Uid],{AccCount,AccBin}) ->
						  case get_uid_to_info(Uid) of
							  {?ok,#player{uname = Uname1, lv =Lv,pro = Pro}  }->
								  Clan = clan_api:clan_name_get(Uid),
								  IsOnline = ?IF(role_api:is_online(Uid),?CONST_TRUE,?CONST_FALSE),
								  Bin = app_msg:encode([{?int32,Uid},{?string,Uname1},{?string,Clan},{?int8u,Lv},{?int16u,IsOnline},{?int8u,Pro}]),
								  {AccCount+1,<<AccBin/binary,Bin/binary>>};
							  _ ->
								  {AccCount,AccBin}
						  end
				  end,
			
			{Count,BinMsg} = lists:foldl(Fun, {0,<<>>}, UidList),
			Bin2 = app_msg:encode([{?int16u,Count}]),
			Msg = app_msg:msg(?P_FRIEND_SEARCH_REPLY,<<Bin2/binary,BinMsg/binary>>),
			{?ok,Msg};
		{?error,ErrorCode}->
			{?error,ErrorCode}
	end.


%% 根据玩家姓名找Uid
get_name_to_uid(Uname) ->
	Name = util:to_list(Uname),
	SQL = "SELECT `uid` FROM user WHERE `uname` like '%" ++ Name ++ "%'",
	case mysql_api:select(SQL) of
		{?ok,UidList} ->
			case length(UidList) == 0 of
				?true ->
					{?error,?ERROR_FRIEND_NOT_PLAYER};
				_->
					{?ok,UidList}
			end;
		_ ->
			{?error,?ERROR_FRIEND_NOT_PLAYER}
	end.

%% 根据玩家Uid找到玩家信息
get_uid_to_info(Uid) ->
	case role_api_dict:player_get(Uid) of 
		{?ok,Player} ->
			{?ok,Player};
		_ ->
			{?error,undefine}
	end.

%% 根据玩家Uid找到玩家信息
get_uid_to_name(Uid) ->
	case role_api_dict:player_get(Uid) of 
		{?ok,Player} ->
			Uname= Player#player.uname,
			{?ok,Uname}; 
		_ ->
			{?error,undefine}
	end.

%% 获取玩家好友信息
%% find_data(Uid) ->
%% 	case ets:lookup(?ETS_FRIEND, Uid) of
%% 		[] ->
%% 			[];
%% 		[R|_] ->
%% 			R
%% 	end.

list_to_uid(List) ->
	case List of
		[] ->
			[];
		[Uid|_] ->
			Uid
	end.

