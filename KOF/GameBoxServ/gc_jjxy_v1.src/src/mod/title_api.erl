%% Author: xushaofeng
%% Create: 2013-5-24
%% Description: TODO: Add description to role_mod

-module(title_api).

%%------------------------------------------------
%% Include Files
%%------------------------------------------------

-include("../include/comm.hrl").

%%
%% Exported Functions
%%

-export([
		 decode_title/1,
		 encode_title/1,
		 init_title/1,
		 
		 login/1,
		 ref_title/0,
		 ref_title_cb/2,
		 
		 title/1,
%% 		 title_cb/2,
		 
		 role_title/1,
		 new_title/4,
		 new_title_cb/2,
		 
		 set_title/3,
		 check_title/1,
		 change_gm/2,
		 
		 msg_list_back/1,
		 msg_cast/2
		 ]).


encode_title(TitleList) ->
	TitleList.

decode_title(0) -> [];
decode_title(?null) -> [];
decode_title([]) -> [];
decode_title([Title|_List]=TitleList) ->
	?IF(is_record(Title,title), TitleList, []).

init_title(Player) ->
	TitleList0=
		case role_api_dict:title_get() of
			[Title|_List]=TitleList when is_record(Title, title) ->
				TitleList;
			_ ->
				[]
		end,
	{Player,TitleList0}. 

%% 地图进程取玩家当前使用的称号
%% reg		: Uid
%% retrun	: BinMsg
title(Uid) ->
	TitleId = 
		case db_api:get_data2ets(?CONST_PUBLIC_KEY_TITLE, [Uid]) of
			[#title{}|_] = [TitleList] ->
				case lists:keyfind(1, #title.state, TitleList) of
					#title{id=Id,et=Et,st=St} ->
						Now = util:seconds(),
						case util:betweet(Now, St, Et) of
							Now ->
								Id;
							_ ->
								0
						end;
					_ ->
						0
				end;
			_ ->
				0
		end,
	msg_cast(Uid, TitleId).
	
%% title(Uid) ->
%% 	case role_api:is_online(Uid) of
%% 		?true ->
%% 			Ref	= make_ref(),
%% 			case util:pid_send(Uid, ?MODULE, title_cb, {self(), Ref, ?null}) of
%% 				?true 	->
%% 					receive  {Ref, Id} -> msg_cast(Uid, Id) 
%% 					after ?CONST_OUTTIME_PID -> msg_cast(Uid, 0)
%% 					end;
%% 				?false 	-> msg_cast(Uid, 0)
%% 			end;
%% 		_ ->
%% 			{ok,TitleList} = role_api_dict:title_get(Uid),
%% 			msg_cast(Uid, role_title(Uid, TitleList))
%% 	end.
%% 						
%% title_cb(#player{uid=Uid}=Player, {From, Ref, _null}) ->
%% 	{ok,TitleList} = role_api_dict:title_get(Player#player.uid),
%% 	TId = role_title(Uid, TitleList),
%% 	util:pid_send(From, {Ref, TId}),
%% 	Player.

%% 玩家自己查找玩家当前称号
role_title(Uid) ->
	NewTitle = check_title(Uid),
	role_title(Uid, NewTitle).
role_title(_Uid, ?null) -> 0;
role_title(_Uid, []) -> 0;
role_title(_Uid, NewTitle) ->
	case lists:keytake(1, #title.state, NewTitle) of
		{value, #title{id=Id}, _TupleList2} ->
			Id;
		_ ->
			0
	end.

%% 
login(Uid) ->
	case check_title(Uid) of
		[] -> 
			ok;
		TitleList ->
			role_api_dict:title_set(TitleList),
			db_api:insert_data2ets(?CONST_PUBLIC_KEY_TITLE, {Uid,TitleList})
	end.

%% 刷新称号系统
ref_title() ->
	case ets:lookup(?ETS_PUBLIC_RECORDS, ?CONST_PUBLIC_KEY_TITLE) of
		[{?CONST_PUBLIC_KEY_TITLE, []}|_] -> ?ok;
		[{?CONST_PUBLIC_KEY_TITLE, EtsList}|_] ->
			Now		= util:seconds(),
			FunTit	= fun(#title{st=ST,et=ET,flag=0}=Title,{UidAcc,TAcc,FlagAcc}) ->
							  case util:betweet(Now, ST, ET) of
								  Now -> {UidAcc, [Title#title{flag=1}|TAcc], ?false};
								  ST  -> {UidAcc, [Title|TAcc], FlagAcc};
								  _	  -> 
									  change_gm(UidAcc, 0),
									  {UidAcc, TAcc, ?false}
							  end;
						 (#title{st=ST,et=ET,flag=1}=Title,{UidAcc, TAcc,FlagAcc}) ->
							  case util:betweet(Now, ST, ET) of
								  Now -> {UidAcc, [Title|TAcc], FlagAcc};
								  ST  -> {UidAcc, [Title#title{flag=0}|TAcc], FlagAcc};
								  _	  ->
									  change_gm(UidAcc, 0),
									  {UidAcc, TAcc, ?false}
							  end;
						 (_, {UidAcc, TAcc, FlagAcc}) ->
							  {UidAcc, TAcc, FlagAcc}
					  end, 
			FunUid = fun({Uid,TitleList},UAcc) ->
							 case lists:foldl(FunTit, {Uid, [], ?true}, TitleList) of
								 {Uid, Utitle,?true } -> 
									 [{Uid,Utitle}|UAcc];
								 {Uid, Utitle,?false} ->
									 case role_api:is_online(Uid) of
										 ?true ->
											 util:pid_send(Uid, ?MODULE, ref_title_cb, ?null),
											 [{Uid,Utitle}|UAcc];
										 _ ->
											 UAcc
									 end
							 end
					 end,
			NewEtsList = lists:foldl(FunUid, [], EtsList),
			ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_TITLE,NewEtsList});
		_ ->
			ets:insert(?ETS_PUBLIC_RECORDS, {?CONST_PUBLIC_KEY_TITLE,[]})
	end.
%% 刷新回调
ref_title_cb(#player{uid=Uid,socket=Socket}=Player, _) ->
	NewTitle = check_title(Uid),
	role_api_dict:title_set(NewTitle),
	BinCast = msg_cast(Uid, role_title(Uid)),
	scene_api:broadcast_scene(Uid, BinCast),
	BinMsg = msg_list_back(NewTitle),
	app_msg:send(Socket, BinMsg),
	Player.


%%　新增称号
new_title(Uid, Id, STime, ETime) ->
	case role_api:is_online(Uid) of
		?true ->
			util:pid_send(Uid, ?MODULE, new_title_cb, [Id, STime, ETime]);
		_ ->
			{?ok,TitleList0} = role_api_dict:title_get(Uid),
			TitleList = ?IF(TitleList0==?null,[],TitleList0),
			TitleList2= [TiT#title{state=0}||TiT <- TitleList],
			TitleList3= [#title{id=Id,state=1,st=STime,et=ETime}|TitleList2],
			role_api_dict:title_set(Uid, TitleList3),
			db_api:insert_data2ets(?CONST_PUBLIC_KEY_TITLE, {Uid,TitleList3}),
			change_gm(Uid, ?IF(util:seconds() >= ETime, 0, 1))
	end.

new_title_cb(#player{uid=Uid,socket=Socket,mpid=MPid}=Player, [Id, STime, ETime]) ->
	Now 		= util:seconds(),
	TitleList 	= check_title(Uid),
	case util:betweet(Now, STime, ETime) of
		Now ->
			change_gm(Uid, Id),
			TupleList3 	= [TiT#title{state=0}||TiT <-TitleList],
			NewTitle	= #title{id=Id,state=1,st=STime,et=ETime},
			NewTitleList= [NewTitle|TupleList3],
			BinCast = msg_cast(Uid, Id),
			scene_api:broadcast_scene(MPid, BinCast),
			BinMsg = msg_list_back(NewTitleList),
			app_msg:send(Socket, BinMsg);
		STime ->
			change_gm(Uid, Id),
			NewTitle	= #title{id=Id,state=0,st=STime,et=ETime},
			NewTitleList= [NewTitle|TitleList];
		ETime ->
			change_gm(Uid, ?IF(Id == 1, 0, Id)),
			case lists:keytake(Id, #title.id, TitleList) of
				{value, #title{id=Id,state=0}, TupleList2} ->
					NewTitleList= TupleList2;
				{value, #title{id=Id,state=1}, []} ->
					NewTitleList= [],
					BinCast = msg_cast(Uid, 0),
					scene_api:broadcast_scene(MPid, BinCast), 
					BinMsg = msg_list_back(NewTitleList),
					app_msg:send(Socket, BinMsg);
				{value, #title{id=Id,state=1}, [#title{id=TTId}=TTtitle|TupleList2]} ->
					NewTitleList= [TTtitle#title{id=TTId,state=1}|TupleList2],
					BinCast = msg_cast(Uid, TTId),
					scene_api:broadcast_scene(MPid, BinCast), 
					BinMsg = msg_list_back(NewTitleList),
					app_msg:send(Socket, BinMsg);
				_ ->
					NewTitleList= TitleList
			end
	end,
	role_api_dict:title_set(NewTitleList),
	db_api:insert_data2ets(?CONST_PUBLIC_KEY_TITLE, {Uid,NewTitleList}),
	Player.

%% 设置称号状态
set_title(Uid,State,Tid) ->
	TitleList = check_title(Uid),
	case lists:keytake(Tid, #title.id, TitleList) of
		{value, #title{state=State}, _TupleList2} ->
			{?error,?ERROR_TITLE_USE_SAMETYPE};
		{value, Title, TupleList2} ->
			TupleList3 = [TiT#title{state=0}||TiT <-TupleList2],
			NewTitle = [Title|TupleList3],
			role_api_dict:title_set(NewTitle),
			BinCast = msg_cast(Uid, role_title(Uid)),
			scene_api:broadcast_scene(Uid, BinCast),
			BinMsg = msg_list_back(NewTitle),
			{?ok,BinMsg};
		_ ->
			{?error,?ERROR_TITLE_NOT_HAVE}
	end.
			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% local_fun%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%% 将玩家称号分类 在用，新加还不可用
%% TitleList = check_title(Uid)
check_title(Uid) ->
	Now = util:seconds(),
	TitleList = role_api_dict:title_get(),
	Fun = fun(#title{et=ET,st=ST}=Title, Acc) ->
				  case util:betweet(Now, ST, ET) of
					  Now -> [Title#title{flag=1}|Acc];
					  ST  -> [Title#title{flag=0}|Acc];
					  _   -> change_gm(Uid, 0), Acc
				  end
		  end,
	lists:foldl(Fun, [], TitleList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Gm %%%%%%%%%%%%%%%%%%%%%%%%%%
change_gm(Uid, 1) ->
	SQL = "UPDATE `user` SET  `state` = 1 WHERE `Uid` =  " ++ util:to_list(Uid) ++ " limit 1;",
	mysql_api:fetch_cast(SQL);
change_gm(Uid, 0) ->
	SQL = "UPDATE `user` SET  `state` = 0 WHERE `Uid` =  " ++ util:to_list(Uid) ++ " limit 1;",
	mysql_api:fetch_cast(SQL);
change_gm(_Uid, _) -> ?ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% msg %%%%%%%%%%%%%%%%%%%%%%%%
% 称号列表数据返回 [10712]
msg_list_back(MsgTitle)->
	Rs		= app_msg:encode([{?int16u,length(MsgTitle)}]),
	Fun 	= fun(#title{id=Tid,state=State}, BinAcc) ->
					  BinM = app_msg:encode([{?int8u,State},{?int16u,Tid}]),	  
					  <<BinAcc/binary,BinM/binary>>
			  end, 
	RsList	= lists:foldl(Fun, Rs, MsgTitle),
	app_msg:msg(?P_TITLE_LIST_BACK, RsList).

% 玩家称号广播 [10750]
msg_cast(Uid,Tid)->
    RsList = app_msg:encode([{?int32u,Uid},{?int16u,Tid}]),
    app_msg:msg(?P_TITLE_CAST, RsList).

