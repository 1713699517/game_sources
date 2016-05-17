%% Author: acer
%% Created: 2012-11-14
%% Description: TODO: Add description to mail_api.
-module(mail_mod).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 
		 check_send/3,
		 check_max/1,
		 chack_over/1,
		 check_pick/2,
		 chack_del/1,
		 
		 mysql_chack_over/1,
		 
		 mail_rec/14,
		 mail_sql/1,
		 
		 send_mail_list/5,
		 
		 get_name2uid/1,
		 delete/1,
		 insert/2,
		 lookup/1,
		 lookup/2,
		 lookup/3,
		 update/4
		]).




%% 检查收件人是否存在(不能是发件人)	
%% retrun:{ok, RecvUid, RecvName}| {error, ErrorCode}
check_send(MyName,RecvUid,RecvName) ->
	case get_name2uid(RecvName) of
		{?ok,Uid} -> 
			case RecvUid == 0 orelse RecvUid =:= Uid of
				?true ->
					if RecvName =/= MyName ->
						   {?ok, Uid, RecvName};
					   ?true ->
						   {?error, ?ERROR_MAIL_MINE}
					end;
				?false ->
					{?error, ?ERROR_USER_NOT_EXIST}
			end;
		{?error,ErrorCode} ->
			{?error, ErrorCode}
	end.


%% 检查保存箱容量
%% retrun: {?ok,Uid} | {?error,?Errorcode}
check_max(Uid) ->
	MailList = lookup(Uid,?CONST_MAIL_TYPE_SAVE),
	Count = length(MailList),
	if Count < ?CONST_MAIL_VOLUME_MAX ->
			?ok;
		?true ->
			{?error, ?ERROR_MAIL_SAVE_FULL}
	end.

%% 检查邮件附件是否已提取
%% retrun: {?ok,MailIdList} | {?error,?Errorcode}
check_pick(Player,MailIdList) ->
	MailList = lookup(Player#player.uid,?CONST_MAIL_TYPE_GET),
	F=fun(_MailId,{?false, Error}) ->
			  {?false, Error};
		 (MailId,{_AccB, AccM}) ->
			  case lists:keytake(MailId, #mail.mail_id, AccM) of
				  {value, Mail, MailList2} ->
					  case Mail#mail.pick =/= ?CONST_MAIL_ACCESSORY_NO of
						  ?true ->
							  {?true, MailList2};
						  ?false ->
							  {?false, ?ERROR_MAIL_DELETE_BAN}
					  end;
				  _ ->
					  {?false, ?ERROR_MAIL_NULL}
			  end
	  end,
	case lists:foldl(F,{?true,MailList}, MailIdList) of 
		{?true, _MailList2} ->
			{?true, MailIdList};
		{?false, ErrorCode} ->
			{?error, ErrorCode}
	end.

%% 检查邮件有效期
chack_over(#mail{date=Date,mail_id=MailId}) ->
	Now=util:seconds(),
	Over=util:days_diff(Date,Now),
	if  Over >= ?CONST_MAIL_NET_TIME ->
			ets:delete(?ETS_M_MAIL, MailId),
			?false;
		?true ->
			?true
	end.

%% 检查邮件是否已删除
chack_del(#mail{boxtype=BoxType}) ->
	case BoxType of 
		14 -> ?true; % 自己删除
		44 -> ?true; % 双方删除
		24 -> ?false;  % 对方删除
		_ -> ?false	  % 未删除
	end.
			

mysql_chack_over(#mail{date=Date}) ->
	Now=util:seconds(),
	Over=util:diff_days(Date,Now),
	?IF(Over >= ?CONST_MAIL_NET_TIME,?false,?true).

%% 删除邮件
delete(MailId) ->
	case mysql_api:delete(sys_mail, " mail_id = "++ util:to_list(MailId)) of
		{?ok,_Data}->
			ets:delete(?ETS_M_MAIL, MailId),
			{?ok,MailId};
		{?error,Error}->
			{?error,Error}
	end.


%% 查找玩家所有的邮件
lookup(Uid) ->
	MailList = get_mails_data(Uid),
	MailList2= [Mail || Mail <- MailList ,chack_over(Mail)], % 检查超时邮件 			
	MailList2.
%% 查找指定邮箱的邮件
lookup(Uid,Type) ->
	MailList = lookup(Uid),
	case Type of
		?CONST_MAIL_TYPE_GET ->
			MailList2=[Mail||Mail <- MailList,Mail#mail.recv_uid == Uid, Mail#mail.boxtype =/= ?CONST_MAIL_TYPE_SAVE];
		?CONST_MAIL_TYPE_SEND ->
			MailList2=[Mail||Mail <- MailList,Mail#mail.send_uid == Uid];
		?CONST_MAIL_TYPE_SAVE ->
			MailList2=[Mail||Mail <- MailList,Mail#mail.recv_uid == Uid, Mail#mail.boxtype == ?CONST_MAIL_TYPE_SAVE]
	end,
	MailList2.
%% 查找玩家Id与邮件Id
lookup(Uid, MailId,Type) ->
	MailList = lookup(Uid,Type),
	[Mail||Mail<- MailList, Mail#mail.mail_id == MailId].

%% 新增邮件 
insert(Mail,RecvUid) ->
	case role_api:is_online(RecvUid) of
		?true ->
			ets:insert(?ETS_M_MAIL, Mail);
		?false ->
			?ok
	end,
	Datas = mail_sql([Mail]),
	mysql_api:fetch_cast(Datas).

mail_sql(Mails)->
	Mails2  = [ " ("++util:to_list(MailId)
			  ++", "++util:to_list(RecvUid)
			  ++", '"++mysql_api:escape(RecvName)
			  ++"', "++util:to_list(SendUid)
			  ++", '"++mysql_api:escape(SendName)
			  ++"', '"++mysql_api:escape(Title)
			  ++"', '"++mysql_api:escape(Content)
			  ++"', "++util:to_list(mysql_api:encode(VGList))
			  ++", "++util:to_list(mysql_api:encode(UGList))
			  ++", "++util:to_list(State)
			  ++", '"++util:to_list(MType)
			  ++"', '"++util:to_list(BoxType)
			  ++"', "++util:to_list(Pick)
			  ++", "++util:to_list(Date)++") " || 
			  #mail{mail_id  = MailId,
				    mtype    = MType,
				    recv_uid = RecvUid,
				    recv_name= RecvName,
				    send_uid = SendUid,
				    send_name= SendName,
				    boxtype  = BoxType,
				    title    = Title,
				    date     = Date,
				    content  = Content,
				    vgoods   = VGList,
				    goods    = UGList,
				    state    = State,
				    pick     = Pick} <- Mails],
	H = "INSERT INTO `sys_mail` (`mail_id`,`recv_uid`, `recv_name`, `send_uid`, `send_name`, `title`, `content`, `vgoods`, `goods`, `state`, `mtype`, `boxtype`, `pick`, `date`) VALUES ",
	M = " , ",
	T = " ; ",
	util:list_to_string(Mails2, H, M, T).


mail_rec(MailId,RecvUid,RecvName,SendUid,SendName,Title,Content,VGList,UGList,State,MType,BoxType,Pick,Date)->
	#mail{
		   mail_id  = MailId,
		   mtype    = MType,
		   recv_uid = RecvUid,
		   recv_name= RecvName,
		   send_uid = SendUid,
		   send_name= SendName,
		   boxtype  = BoxType,
		   title    = util:to_binary(Title),
		   date     = Date,
		   content  = util:to_binary(Content),
		   vgoods   = VGList,
		   goods    = UGList,
		   state    = State,
		   pick     = Pick
		  }.
%% 更新邮件
update(_Uid,MailId,PosValueList,FieldValueList) ->
	ets:update_element(?ETS_M_MAIL, MailId, PosValueList),
	F=fun({Field,Value}) when Field == vgoods, Field == goods ->
			  {Field, util:bin_for_db(Value)};
		 ({Field,Value}) ->
			  {Field, Value}
	  end,
	FieldValueList2 = lists:map(F,FieldValueList),
	mysql_api:update(sys_mail, FieldValueList2, "mail_id=" ++ util:to_list(MailId)),
	?ok.

%% 从ets表取出玩家的  收or发or保 邮箱邮件
%% get_mails_data(UID) ->
%%  			MS=ets:fun2ms(fun(R) when R#mail.recv_uid =:= UID orelse R#mail.send_uid=:=UID  -> R end),
%% 			ets:select(?ETS_M_MAIL,MS);	
get_mails_data(UID) ->
	MS=[{'$1',[{'orelse',{'=:=',{element,7,'$1'},{const,UID}},
			   {'=:=',{element,5,'$1'},{const,UID}}}],['$1']}],
	ets:select(?ETS_M_MAIL,MS).

%%　名字查找Uid
get_name2uid(Uname) ->
	case mysql_api:select([uid], user, [{uname,Uname}]) of
		{?ok,[[Uid|_]|_]} ->
			{?ok,Uid};
		_ ->
			{?error,?ERROR_USER_NOT_EXIST}
	end.


%%　群发系统邮件
send_mail_list(Data,Title,Content,UGList0,VGList0) ->
	VGList = ?IF(is_list(VGList0),lists:filter(fun({T,V}) -> T=/=0 andalso V=/=0 end, VGList0),[]),
	UGList = ?IF(is_list(UGList0),UGList0,[]),
	Mails  = send_mail2(Data,Title,Content,UGList,VGList,[]),
	ets:insert(?ETS_M_MAIL, Mails),
	[begin MailsSQL = mail_sql(MailList),
		   mysql_api:fetch_cast(MailsSQL)
		    end ||  MailList <- util:lists_split(Mails, 100)],
	lists:map(fun([RecvUid, _RecvName]) -> logs_api:action_notice(RecvUid,?CONST_LOGS_8004, [], []) end, Data),
	ok.

send_mail2([],_Title,_Content,_UGList,_VGList,Acc)-> Acc;
send_mail2([[RecvUid, RecvName]|RecvList],Title,Content,UGList,VGList,Acc) ->
	MailList=
		case UGList of
			UG when is_list(UG) ->
				if length(UGList) =< ?CONST_MAIL_PICK_BOX ->
					  Mail = send_sys_inside(RecvUid,RecvName, Title, Content, UGList, VGList),
					  [Mail];
				   ?true ->
					   Fun = fun(UG,Acc) ->
									 Mail=send_sys_inside(RecvUid,RecvName,Title,Content,UG,VGList),
									 [Mail|Acc]
							 end,
					   lists:foldl(Fun,util:lists_split(UGList, [], ?CONST_MAIL_PICK_BOX))
				end;
			_ ->
				Mail=send_sys_inside(RecvUid,RecvName, Title, Content, [], VGList),
				[Mail]
		end,
	send_mail2(RecvList,Title,Content,UGList,VGList,util:lists_merge(Acc,MailList)).


send_sys_inside(RecvUid,RecvName, Title, Content, UGList, VGList) ->
	Pick = if UGList =/= [] orelse VGList =/= [] ->
				  ?CONST_MAIL_ACCESSORY_NO;
			  ?true ->  
				  ?CONST_MAIL_ACCESSORY_NULL 
		   end,
	mail_mod:mail_rec(idx_api:mail_id(), RecvUid, RecvName, 0, <<"系统">>, util:to_binary(Title), 
					  util:to_binary(Content), VGList, UGList, 0, 0, 0, Pick, util:seconds()).




