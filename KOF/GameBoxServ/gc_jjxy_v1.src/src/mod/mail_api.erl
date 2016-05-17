%% Author: acer
%% Created: 2012-11-14
%% Description: TODO: Add description to mail_api.
-module(mail_api).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([mail/1,
		 
		 login/1,
		 logout/1,
		 
		 send_mail_all/4,
		 send_mail_uids/5,
		 send_clan/3,
		 
		 send_uids/2,
		 get_mails/2,
		 send/2,	 		 
		 del/2,
		 pick_list/2,
 		 read/2,
		 save/2,
		 
		 get_content/2,
		 
		 msg_ok_send/0,
		 msg_ok_del/1,
		 msg_ok_pick/1,
		 msg_ok_request/2
		]).

-define(CONST_MAIL_SYSTEM_NAME,		<<"系统">>).


%% % 每天定时清理数据
%% clear_mail_data() ->
%% 	ets:delete_all_objects(?ETS_M_MAIL).
login(Player) -> ?ok.
%% 	get_mails(Player,?CONST_MAIL_TYPE_GET).

logout(Player) ->
	MailList = mail_mod:lookup(Player#player.uid),
	[ets:delete(?ETS_M_MAIL, MailId) || #mail{mail_id=MailId,send_uid=SendUid} <- MailList,SendUid=/=0].
	
%% 发送系统邮件
%% @spec send_sys(_) -> ?ok | {?error,Reason}
%% UGList :: [UserGoods]; VGList :: [VGoods];
%% 实物: UGList  可放包裹，
%% 虚物: VGList [{Type1,Value1},{Type2,Value2}]  ::  具体见货币常量
%%----------------------------------------------------------------------------------------------------------邮件模版
mail(RecvUids)->
	Title= <<"测试邮件">>, % 所有文本内容转 binary 类型
	Content=util:to_binary(util:to_list(<<"本次你造成 ">>)	++util:to_list(888888)++util:to_list(<<" 点伤害,所得奖励如附件所示。 ">>)),
	VGList=[{?CONST_CURRENCY_GOLD,10000}, 					% 货币-银元
			{?CONST_CURRENCY_RMB,10000},					% 货币-金元(人民币)
			{?CONST_CURRENCY_RMB_BIND,10000},				% 货币-金元(绑定元宝)
			{?CONST_CURRENCY_EXP,10000},					% 货币-经验
			{?CONST_CURRENCY_DEVOTE,10000},					% 货币-帮派贡献
			{?CONST_CURRENCY_ENERGY,10000}],				% 货币-精力

			Goods1001 = data_goods:get(1001),
			Goods1021 = (data_goods:get(1021))#goods{count=3},
			Goods40041= {give,1001,1,0,1,1,0,0},
			Goods43001= {1001,3},
	UGList=[Goods1001,Goods1021,Goods40041,Goods43001,{1001,3},{1001,3}], 
	send_mail_uids(RecvUids,Title,Content,UGList,VGList).

%% 请求邮件列表  
%% reg:     BoxType 邮箱类型（0收|1发|2存)
%% retrun: ok
get_mails(#player{uid=Uid,socket=Socket},Type) -> 
	case mail_mod:lookup(Uid, Type) of
		[] ->
			{Y,M,D}  = util:date(),
			Time     = util:datetime2timestamp(Y, M, D, 0, 0, 0) - ?CONST_MAIL_NET_TIME*86400, %% ?CONST_MAIL_NET_TIME*86400==7*24*60*60 :: 7天邮件过期
			Recv_Sql = "SELECT `mail_id`,`recv_uid`,`recv_name`,`send_uid`,`send_name`,`title`,`content`,`vgoods`,`goods`,`state`,`mtype`,`boxtype`,`pick`,`date` 
						FROM `sys_mail` WHERE `recv_uid` = " ++ util:to_list(Uid) ++ " and `recv_del`= 0 and `date` > " ++ util:to_list(Time) ++" ORDER BY `mail_id` DESC limit 300;" ,
			case mysql_api:select(Recv_Sql) of
				{?ok,[[_,_,_,_,_,_,_,_,_,_,_,_,_,_]|_]=Recv_Datas} ->
					Recv_NewDatas = [get_mails_rec(Recv_Data) || Recv_Data <- Recv_Datas],
					ets:insert(?ETS_M_MAIL,Recv_NewDatas);
				{?ok, []} ->
					?ok;
				Err ->
					?MSG_ERROR("Err : ~p~n", [Err])
			end,
			Send_Sql = "SELECT `mail_id`,`recv_uid`,`recv_name`,`send_uid`,`send_name`,`title`,`content`,`vgoods`,`goods`,`state`,`mtype`,`boxtype`,`pick`,`date` 
						FROM `sys_mail` WHERE `send_uid` =" ++ util:to_list(Uid)++ " and `send_del` = 0 and  `date` > " ++ util:to_list(Time) ++ " ORDER BY `mail_id` DESC limit 300;" ,
			case mysql_api:select(Send_Sql) of
				{?ok,[[_,_,_,_,_,_,_,_,_,_,_,_,_,_]|_]=Send_Datas} ->
					Send_NewDatas = [get_mails_rec(Send_Data) || Send_Data <- Send_Datas],
					ets:insert(?ETS_M_MAIL,Send_NewDatas);
				{?ok,[]} ->
					?ok;
				Err2 ->
					?MSG_ERROR("Err : ~p~n", [Err2])
			end,
			MailList= mail_mod:lookup(Uid, Type);
		MailList ->
			MailList
	end,
	BinMsg = msg_ok_request(Type,MailList),
	app_msg:send(Socket,BinMsg).

get_mails_rec([MailId,RecvUid,RecvName,SendUid,SendName,Title,Content,VGList0,UGList0,State,MType0,BoxType0,Pick,Date|_])->
	VGList = try ( mysql_api:decode(VGList0) ) catch _:_ ->[] end,
	UGList = try ( mysql_api:decode(UGList0) ) catch _:_ ->[] end,
	MType  = util:to_integer(MType0),
	BoxType  = util:to_integer(BoxType0),
	mail_mod:mail_rec(MailId, RecvUid, RecvName, SendUid, SendName, Title, Content, VGList, UGList, State, MType, BoxType, Pick, Date).
	

%% 请求发送邮件--玩家
send(#player{uid=Uid,uname=Name}, {RUid,RecvName,Title,Content}) ->
	case mail_mod:check_send(Name, RUid, RecvName) of
		{?ok, RecvUid, RecvName} ->
			Mail = mail_mod:mail_rec(idx_api:mail_id(), RecvUid, RecvName, Uid, Name, Title, Content, [], [], ?CONST_MAIL_STATE_UNREAD, ?CONST_MAIL_TYPE_PRIVATE, 0, ?CONST_MAIL_ACCESSORY_NULL, util:seconds() ),
			mail_mod:insert(Mail, RecvUid),
			logs_api:action_notice(RUid,?CONST_LOGS_8004, [], []), 
			Binreply = msg_ok_send(),
			{?ok,Binreply};
		{?error, ErrorCode} ->
			{?error,ErrorCode}
	end.


%% 请求发送邮件--帮派
%% Content = get_content(Id,IntList)
%%　reg:{[{RecvUid,RecvName}|Uids],Title,Content}
%% retrun : ?ok
send_clan(Uids,Title,Content) ->
	Time=util:seconds(),
	MailList=send_clan_acc(Uids,Title,Content,Time,[]),
	send_uids(Uids, MailList).

send_clan_acc([],_Title,_Content,_Time,Acc) -> Acc;
send_clan_acc([{RecvUid,RecvName}|Uids],Title,Content,Time,Acc) ->
	Mail = mail_mod:mail_rec(idx_api:mail_id(), RecvUid, RecvName, 0, <<"帮派">>, Title, Content, [], [], 0, 1, 0, 0, Time),
	send_clan_acc(Uids,Title,Content,Time,[Mail|Acc]).

%% 群发邮件
%% Content = get_content(Id,IntList)
%%　reg: {UidList,MailList} :: {收件人列表，邮件列表}
send_uids(UidList,MailList) ->
	MailsSQL = mail_mod:mail_sql(MailList),
	mysql_api:fetch_cast(MailsSQL),
	ets:insert(?ETS_M_MAIL, MailList),
	[logs_api:action_notice(Uid,?CONST_LOGS_8004, [], [])|| {Uid,_Name} <- UidList].


%% 发送系统邮件
%% @spec send_mail_uids(_) -> ?ok | {?error,Reason}
%% Content = get_content(Id,IntList)
%% UGList :: [UserGoods]; VGList :: [VGoods];
%% 实物: Goods = [{give,43001,5,0,0,0,0,0},{give,42001,10,0,0,0,0,0}] 可放包裹，
%% 虚物: VGoods = [{?CONST_CURRENCY_XXX,100}]
send_mail_uids(RecvUids,Title,Content,Goods,VGoods) when is_list(RecvUids) -> 
	RecvUids2 = util:map(fun(U)-> mysql_api:escape(U) end, RecvUids),
	RecvUids3 = util:list_to_string(RecvUids2,"'","','","'"),
	case mysql_api:select_execute("SELECT `uid`,`uname` FROM `user` WHERE `uid` in ("++RecvUids3++");") of
		{?ok, Data}->
			mail_mod:send_mail_list(Data,Title,Content,Goods,VGoods);
		{?error,Error} ->
			{?error,Error}
	end;
send_mail_uids(RecvUids,Title,Content,Goods,VGoods) -> 
	send_mail_uids([RecvUids],Title,Content,Goods,VGoods).

% 全服发邮件
send_mail_all(Title,Content,Goods,VGoods)->
	case mysql_api:select_execute("SELECT `uid`,`uname` FROM `user` ORDER BY `uid` DESC ") of
		{?ok, Data}->
			mail_mod:send_mail_list(Data,Title,Content,Goods,VGoods);
		{?error,Error} ->
			{?error,Error}
	end.



%% 读取邮件
read(#player{uid=Uid,socket=Socket,uname=Name}, MailId) ->
	MailList = mail_mod:lookup(Uid),
	case [Mail||Mail<- MailList, Mail#mail.mail_id == MailId] of
		[] ->
			ErrMsg = system_api:msg_error(?ERROR_MAIL_NULL),
			app_msg:send(Socket, ErrMsg);
		[Mail|_] ->
			#mail{mail_id=MailId,send_uid=SendUid,state=State,send_name=SendName,
				  content=Content,pick=Pick,vgoods=VGList,goods=UGList} = Mail,	
			case SendName == Name orelse SendUid == Uid of
				?true ->
					?ok;
				?false ->
					PosValueList = [{#mail.state,?CONST_MAIL_STATE_READ}],
					FileValueList = [{state,?CONST_MAIL_STATE_READ}],
					mail_mod:update(Uid,Mail#mail.mail_id,PosValueList,FileValueList)
			end,
			Bin = msg_ok_read(MailId,SendUid,State,Pick,Content,VGList,UGList),
			app_msg:send(Socket, Bin)
	end.

%% 收取附件
%% 实物: UGList  可放包裹，
%% 虚物: VGList [{Type1,Value1},{Type2,Value2}]  ::{Exp:0,Gold:1,Rmb:2,Rmb_bind:3,Energy:5,Renown:4,Start:6}
pick_list(Player,[]) ->
	{?ok, Player, <<>>};
pick_list(Player,MailIdList) ->
	pick_list(Player,MailIdList,[]).

pick_list(Player,[],Acc) ->
	BinMsg = msg_ok_pick(Acc),
	{?ok, Player, BinMsg};
pick_list(Player,[MailId | MailIdList],Acc) ->
	case pick(Player, MailId) of
		{?ok,#player{uid=Uid}=Player2} ->
			PosValueList   = [{#mail.vgoods,[]},{#mail.goods,[]},{#mail.pick,?CONST_MAIL_ACCESSORY_YES}],
			FieldValueList = [{vgoods,[]},{goods,[]},{pick,?CONST_MAIL_ACCESSORY_YES}],
			mail_mod:update(Uid, MailId, PosValueList, FieldValueList),
			pick_list(Player2,MailIdList,[MailId |Acc]);
		{?error,ErrorCode} ->
			BinMsg = msg_ok_pick(Acc),
			ErrMsg = system_api:msg_error(ErrorCode),
			{?ok, Player, <<BinMsg/binary,ErrMsg/binary>>}
	end.
	

pick(#player{uid=Uid}=Player, MailId) when MailId > 0 ->
	MailList = mail_mod:lookup(Uid,?CONST_MAIL_TYPE_GET),
	case lists:keytake(MailId, #mail.mail_id, MailList) of
		{value, Mail, _MailList2} ->	
			case Mail#mail.pick of   
				?CONST_MAIL_ACCESSORY_NO -> 		
					#mail{vgoods = VGList, goods = UGList,title=Title} = Mail,
					Title_Logs=iolist_to_binary(["提取邮件附件,", util:to_list(Title)]),
					if length(UGList) =:= 0 ->
						   NPlayer = get_vglist(Player, VGList,Title_Logs),
						   {?ok, NPlayer};
					   ?true ->
						   case bag_api:goods_set([pick,[],Title_Logs],Player, UGList) of
							   {?ok,Player2,GoodsBin,Bin} -> 
								   NPlayer = get_vglist(Player2, VGList,Title_Logs),
								   app_msg:send(NPlayer#player.socket, <<GoodsBin/binary,Bin/binary>>),
								   {?ok, NPlayer};
							   {?error,ErrorCode} ->
								   {?error, ErrorCode}
						   end
					end;
				_ ->
					{?error, ?ERROR_MAIL_GOODS_NULL}
			end;
		?false ->
			{?error, ?ERROR_MAIL_NULL}
	end.

get_vglist(Player, VGList,Title_Logs) ->
	case VGList of
		0 ->
			Player; 
		[] ->  
			Player; 
		VG when is_list(VG) ->
			{Player2,BinMsg} = role_api:currency_add([get_vglist,[],Title_Logs],Player, VGList),
			app_msg:send(Player#player.socket, BinMsg),
			Player2;
		_ ->
			Player
	end.

%% 删除邮件(批量删除) 
%% reg		：玩家，MailIdList
%% retrun	: DMailIdList
del(#player{uid=Uid,socket=Socket}, MailIdList) ->
	Fun=fun(MailId) ->
				MailList = mail_mod:lookup(Uid),
				case lists:keytake(MailId, #mail.mail_id, MailList) of
					{value, Mail, _MailList2} when Mail#mail.pick =/= ?CONST_MAIL_ACCESSORY_NO ->
						if Mail#mail.recv_uid == Uid ->
							   PosValueList  = [{#mail.recv_uid,0}],
							   FileValueList = [{recv_del,1}];
						   ?true ->
							   PosValueList  = [{#mail.send_uid,0}],
							   FileValueList = [{send_del,1}]
						end,
						if Mail#mail.recv_uid == 0 orelse Mail#mail.send_uid == 0 ->
							   ets:delete(?ETS_M_MAIL, MailId),
							   mysql_api:update(sys_mail, FileValueList, "mail_id=" ++ util:to_list(MailId));
						   ?true ->
							   mail_mod:update(Uid,Mail#mail.mail_id,PosValueList,FileValueList)
						end,
						MailId;
					{value, _Mail, _MailList2} ->
						ErrMsg = system_api:msg_error(?ERROR_MAIL_DELETE_BAN),
						app_msg:send(Socket, ErrMsg);
					_ ->
						ErrMsg = system_api:msg_error(?ERROR_MAIL_NULL),
						app_msg:send(Socket, ErrMsg)
				end
		end,
	DList = lists:map(Fun,MailIdList),	
	[MailId1 || MailId1 <- DList,lists:member(MailId1, MailIdList)].
	

%% 将收件箱邮件保存
save(#player{uid=Uid}=Player,MailIdList) ->
	case mail_mod:check_max(Uid) of 
		?ok ->
			case mail_mod:check_pick(Player, MailIdList) of 
				{?true, MailIdList} ->
					[save_acc(Player, MailId) || MailId <- MailIdList],
					?ok;
				{?error, ErrorCode} ->
					{?error, ErrorCode}
			end;
		{?error,ErrorCode} ->
			{?error,ErrorCode}
	end.			
save_acc(#player{uid=Uid},MailId) ->
	case mail_mod:lookup(Uid, MailId,?CONST_MAIL_TYPE_GET) of
		[] ->
			{?error,?ERROR_MAIL_NULL};
		[Mail|_] ->
			PosValueList  = [{#mail.boxtype,?CONST_MAIL_TYPE_SAVE}],
			FileValueList = [{boxtype,?CONST_MAIL_TYPE_SAVE}],
			mail_mod:update(Uid,Mail#mail.mail_id,PosValueList,FileValueList)
	end.

%% %%%%%%%%%%%%%%%%%%%% Msgxxxxxxxxxxxxxxx%%%%%%%%%%%%%
% 请求列表成功 [8512]
msg_ok_request(Type,MailList) -> %% BoxType为邮箱类型
	List1 = app_msg:encode([{?int8u,Type},{?int16u,length(MailList)}]),
	Fun = fun(MailR,Acc) ->
				  #mail{mail_id=MailId,mtype=MType,recv_name=RecvName,send_name=SendName,
						title=Title,date=Date,state=State,pick=Pick} = MailR,
				  Name =
					  case Type of
						  ?CONST_MAIL_TYPE_SEND ->
							  RecvName;
						  _ ->
							  SendName
					  end,
				  BinMsg = msg_model(MailId,MType,Name,Title,Date,State,Pick),
				  <<Acc/binary,BinMsg/binary>>
		  end,
	RsList = lists:foldl(Fun, List1, MailList),
	app_msg:msg(?P_MAIL_LIST, RsList).

% 邮件模块 [8513]
msg_model(MailId,MType0,Name,Title,Date,State,Pick)->
  MType = util:to_integer(MType0),
  ?MSG_ECHO("~p",[{MailId,MType,Name,Title,Date,State,Pick}]),
  app_msg:encode([{?int32u,MailId},
        {?int8u,MType},{?string,Name},
        {?string,Title},{?int32u,Date},
        {?int8u,State},{?int8u,Pick}]).

% 发送邮件成功 [8532]
msg_ok_send()->
    app_msg:msg(?P_MAIL_OK_SEND,<<>>).

% 读取邮件成功 [8542]
msg_ok_read(MailId,SendUid,State,Pick,Content,VGList,UGList)-> 
	CountV = app_msg:encode([{?int16u,length(VGList)}]),
	VGBin = lists:foldl(fun({Type1,Count},Accc) ->
								BinMsg = msg_vgoods_model(Type1,Count),
								<<Accc/binary,BinMsg/binary>>
						end,CountV, VGList),
	CountU = app_msg:encode([{?int16u,length(UGList)}]),
	UGBin = lists:foldl(fun(#goods{}=GoodsMsg,Accg) -> 
								GoodsBin = bag_api:msg_goods(GoodsMsg),
								<<Accg/binary,GoodsBin/binary>>;
						   (#give{}=Give,Accg) ->
								Goods = bag_api:goods(Give),
								GoodsBin = bag_api:msg_goods(Goods),
								<<Accg/binary,GoodsBin/binary>>;
						   ({Gid, Count0}, Accg) ->
								Goods = bag_api:goods(Gid),
								GoodsBin = bag_api:msg_goods(Goods#goods{count = Count0}),
								<<Accg/binary,GoodsBin/binary>>;
						   (_, Accg) ->
								Accg
						end, CountU, UGList),
	RsList = app_msg:encode([{?int32u,MailId},
							 {?int32u,SendUid},{?int8u,State},
							 {?int8u,Pick},{?stringl,Content}]),
	BinData = <<RsList/binary,VGBin/binary,UGBin/binary>>,
	app_msg:msg(?P_MAIL_INFO, BinData).

% 虚拟物品协议块 [8543]
msg_vgoods_model(Type1,Count)->
     app_msg:encode([{?int8u,Type1},{?int32u,Count}]).

% 提取物品成功 [8552]
msg_ok_pick(MailIdList)->
    Count = app_msg:encode([{?int16u,length(MailIdList)}]),
	RsList =lists:foldl(fun(MailId,Acc) ->
								BinMsg = msg_idlist(MailId),
								<<Acc/binary,BinMsg/binary>>
						end, Count, MailIdList),
    app_msg:msg(?P_MAIL_OK_PICK, RsList).

% 邮件移出 [8562]
msg_ok_del(MailIdList)->
    Count = app_msg:encode([{?int16u,length(MailIdList)}]),
	RsList =lists:foldl(fun(MailId,Acc) ->
								BinMsg = msg_idlist(MailId),
								<<Acc/binary,BinMsg/binary>>
						end, Count, MailIdList),
    app_msg:msg(?P_MAIL_OK_DEL, RsList).

% 删除邮件信息块 [8563]
msg_idlist(Idlist)->
    app_msg:encode([{?int32u,Idlist}]).



%%　ActiveId＝1001  IntList=[100,200,300,400,500]::length(IntList)=5
%% return:　Content＝mail_api:get_content(1001,[100,200,300]).
get_content(StringId,IntList) ->
	case data_active_mail:get(StringId) of
		[String, 0] -> 
			iolist_to_binary(String);
		[String, Count] ->
			case length(IntList) of
				Count ->
					F= fun(L,V)-> lists:concat([L,V]) end,
					String2 = string:tokens(String, "~p"),
					{String3,String4} = lists:split(Count, String2),
					StringList=lists:zipwith(F, String3, IntList),
					iolist_to_binary(StringList++String4);
				Count2 ->
					?MSG_ERROR("error::IntList=~w length(IntList)=/=~w~n",[IntList,Count2]),
					<<"">>
			end;
		_ ->
			?MSG_ERROR("error::ActiveId=~w~n",[StringId]), 
			<<"">>
	end.




