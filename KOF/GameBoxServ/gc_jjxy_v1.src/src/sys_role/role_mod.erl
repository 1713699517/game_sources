%% Author  : Kevin
%% Created: 2012-9-5
%% Description: TODO: Add description to role_mod
-module(role_mod).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


%%
%% Exported Functions
%%
-export([
		 create/13,
		 login/5,
%% 		 logout/1,
		 
		 create_name/1,
		 login_again/4,
		 login_check/5,
		 
		 
		 level_up/1,
		 
		 role_init/1
		]). 

%% 登录验正



%% 创建角色 
create(_Player,0,_Uuid,_Sid,_Cid,_Os,_Versions,_Uname,_Sex,_Pro,_Source,_SourceSub,_LoginTime)->
	{?error,?ERROR_NOT_UID};
create(_Player,_Uid,0,_Sid,_Cid,_Os,_Versions,_Uname,_Sex,_Pro,_Source,_SourceSub,_LoginTime)->
	{?error,?ERROR_NOT_UUID}; 
create(_Player,_Uid,_Uuid,0,_Cid,_Os,_Versions,_Uname,_Sex,_Pro,_Source,_SourceSub,_LoginTime)->
	{?error,?ERROR_NOT_SID};
create(_Player,_Uid,_Uuid,_Sid,0,_Os,_Versions,_Uname,_Sex,_Pro,_Source,_SourceSub,_LoginTime)->
	{?error,?ERROR_NOT_CID};
create(Player=#player{socket=Socket,mpid=Mpid,io=Io,is=Is,
					  uname_color=UnameColor,country=Country},
	   Uid,Uuid,Sid,Cid,Os,Versions,Uname,Sex,Pro,Source,SourceSub,LoginTime)->
	case create_check_name(Uname) of 
		?ok -> 
			case check_uid(Uid) of
				?ok ->
					case data_player_init:get(Pro,Sex) of
						#d_player_init{lv=Lv,sence_id=SenceId,
									   pos_x=PosX,pos_y=PosY,dir=Dir,
									   skin=Skin,speed=Speed,talent=Talent,
									   skill_id=SkillId,
									   attack_type=AttackType,attr=LvAttr} ->
							Sid		 = app_tool:sid(),
							AttrGroup= #attr_group{lv=LvAttr},
							Attr	 = role_api:attr_all(AttrGroup, Lv, Talent),
							Powerful = role_api:powerful_calc(Attr),
							Info	 = #info{hp=Attr#attr.hp,talent=Talent,skill_id=SkillId,attack_type=AttackType,powerful=Powerful,
											 pos_x=PosX,pos_y=PosY,dir=Dir,speed=Speed,map_id=SenceId,skin_armor=Skin},
							Money	 = #money{},
							Vip		 = #vip{},
							Io2 	 = Io#io{uuid=Uuid,sid=Sid,cid=Cid,os=Os,versions=Versions,
									  		 source=Source,source_sub=SourceSub,login_time=LoginTime},
							case role_db:role_create(Uid,Socket,Mpid,Uname,UnameColor,Sex,Pro,Country,Lv,
													 Attr,Info,Money,Sex,Vip,Is,Io2) of
								{?ok,Player2}->
									{?ok,Player2};
								{?error,Error}->
									{?error,Error}
							end;
						_ ->
							{?error,?ERROR_BADARG}
					end;
				{?error,Error} ->
					{?error,Error}
			end;
		{?error,Error}->
			{?error,Error}
	end.





%% 登录接口
login(Socket,MPid,FcmRecord,Uid,Sid)->
	%% 登录时判断是否有已存在进程
	Rs = 
		case role_api:mpid(Uid) of 
			OldPid when is_pid(OldPid), MPid =/= OldPid ->
				BinMsg		 = system_api:msg_error(?ERROR_BUSY_MYSQL),
				%BinMsg		 = role_api:msg_out(?ERROR_OTHER_LOGIN),
				app_msg:send(OldPid, BinMsg),
				Ref			 = erlang:make_ref(),
				util:pid_send(OldPid, {login_other,Ref,self()}),
				receive
					{?ok,Ref} ->
						?ok					
				after 5000 ->
						?MSG_ERROR("Other Logout Timeout {Sid,Uid,OldPid,MPid} : ~p~n", [{Sid,Uid,OldPid,MPid}]),
						{?error, ?ERROR_UNKNOWN}
				end;
			_ ->
				?ok
		end,
	case Rs of
		?ok ->
			util:sleep(200),
			case login_control(Sid,Socket,Uid) of
				?ok ->
					role_db:role_login(Uid);
%% 					role_db:login(Socket,MPid,FcmRecord,Uid,Sid);
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.


login_control(Sid,Socket,Uid)->
	{{Ip1,Ip2,Ip3,Ip4},_Port2} = case inet:peername(Socket) of
									 {?ok, 	{Address, Port}} -> {Address, Port};
									 {?error,_}				 -> {{0,0,0,0}, 0}
								 end,
	Ip   = util:to_list(Ip1)++"."++util:to_list(Ip2)++"."++util:to_list(Ip3)++"."++util:to_list(Ip4),
	Time = util:seconds(),
	case mysql_api:select("SELECT `end_time` FROM `control` where `data`='"++Ip++"' and `type`= 2 order by `end_time` desc LIMIT 1; ") of
		{?ok,[[EndTime|_]|_]} when 0 == EndTime orelse EndTime >= Time ->
			{?error,?ERROR_OUT_IP};
		_ ->
			case mysql_api:select("SELECT `end_time` FROM `control` where `data`='"++util:to_list(Uid)++"' and `type`= 1 order by `end_time` desc LIMIT 1; ") of
				{?ok,[[0|_]|_]} ->
					{?error,?ERROR_OUT_COLD_LONG};
				{?ok,[[EndTime|_]|_]} when EndTime >= Time ->
					{?error,?ERROR_OUT_COLD};
				_ ->
					?ok
			end
	end.


%% 断线重连 return : {?ok, ?change_socket} | ?false
login_again(NewSocket,MPid,Uid,Os) ->
	%% 重连时判断是否有已存在进程
	case role_api:mpid(Uid) of
		MPid ->
			?false;
		OldMPid when is_pid(OldMPid),is_port(NewSocket) ->
			%% 			erlang:port_connect(Socket, OldMPid),
			case erlang:is_process_alive(OldMPid) of
				?true ->
					Ref = make_ref(),
					util:pid_send(OldMPid, {?change_socket,Ref,MPid,Os,NewSocket}),
					receive
						{?change_socket, Ref} ->
							unlink(NewSocket),
							%% 			util:pid_send(OldMPid, {?change_socket,Client,NewSocket}),
							util:sleep(1000),
							?MSG_ECHO("========UidUidUid : ~w~n",[Uid]),
							util:pid_send(MPid, ?exit),
							{?ok, ?change_socket}
					after 3000 ->
							?false
					end;
%% 					case gen_server:call(OldMPid, {?change_socket, Client, NewSocket}) of
%% 						?true ->
%% 							unlink(NewSocket),
%% 							%% 			util:pid_send(OldMPid, {?change_socket,Client,NewSocket}),
%% 							util:sleep(1000),
%% 							util:pid_send(MPid, ?exit),
%% 							{?ok, ?change_socket};
%% 						?false ->
%% 							?false
%% 					end;
				?false ->
					?false
			end;
		_ ->
			?false
	end.
			
%% onlin_reward_lv_ok(Uid,MPid,Lv)->
%% 	case ets:lookup(?ETS_ONLINE_REWAD_LV,Uid) of
%% 		[{_,Lv0}|_]->
%% 			case Lv0>Lv of
%% 				?true->?skip;
%% 				_->
%% 					onlin_reward_lv(MPid,Lv)
%% 			end;
%% 		_->
%% 			onlin_reward_lv(MPid,Lv)
%% 	end.



%% 检查uid
check_uid(Uid) ->
	?MSG_ECHO("======= ~w~n",[Uid]),
	SQL = "SELECT `uid` from user where uid=" ++ util:to_list(Uid),
	case mysql_api:select(SQL) of
		{?ok, []} ->
			?ok;
		Err ->
			?MSG_ERROR("Err : ~p~n", [Err]),
			{?error, ?ERROR_UNKNOWN}
	end.

	
%% 是否重名 
create_check_name(Uname) when byte_size(Uname) < 2 ->
	{?error,?ERROR_ROLE_NAME_MIN};
create_check_name(Uname) when byte_size(Uname) > 15 ->
	{?error,?ERROR_ROLE_NAME_LONG}; 
create_check_name(Uname) ->
%% 	UnameBin=util:to_list(Msg)(Uname),
%% 	?MSG_ECHO("~w",[UnameBin]),
%% 	"set names `utf8mb4`;select * from `user` where `uname`=" ++ util:to_list(Uname)";"
%% 	case mysql_api:select(Sid, "select * from `user` where `uname`=" ++ util:to_list(UnameBin)++";") of													  
	case mysql_api:select([uid], user, [{uname,Uname}]) of
		{?ok,[]} -> 
			?ok;
		_Error -> 
			% ?MSG_ERROR("Error:~p, Sid : ~p  Uname :~p~n",[Error,Sid,Uname]),
			{?error, ?ERROR_ROLE_NAME_REPEAT}
	end.

%% 随机取名
create_name(Sex) ->
	Name = data_player_name:get(Sex),
	case create_check_name(Name) of
		?ok -> Name;
		_   -> create_name2(Name,2)
	end.
create_name2(Name,CC) when CC > 5 ->
	CC2	  = util:to_binary(CC+1),
	<<Name/binary,CC2/binary>>;
create_name2(Name,CC) ->
	CC2	  = util:to_binary(CC),
	Name2 = <<Name/binary,CC2/binary>>,
	case create_check_name(Name2) of
		?ok -> Name2;
		_   -> create_name2(Name,CC+1)
	end.

%% 创建角色根据渠道给予奖励
create_reward(Player, Channel) ->
	case data_player_init_source:get(Channel) of
		#d_player_source{gold = Gold, rmb = Rmb, bindrmb = BindRmb, rmb_total = RmbTotal, bag = Bag} ->
			CL = [{?CONST_CURRENCY_GOLD, Gold}, {?CONST_CURRENCY_RMB, Rmb},
				  {?CONST_CURRENCY_RMB_BIND, BindRmb}],
			Remark = iolist_to_binary(["创建人物渠道奖励,渠道ID:",Channel]),
			case goods_api:set([?MODULE,create_reward,[],Remark], Player, Bag) of
				{?ok, Player2, _BinMsg} ->
					{Player3, _BinMsg2} = role_api:currency_add([create_reward,[],<<"创建人物初始奖励">>], Player2, CL),
					case RmbTotal of
						0 ->
							Player3;  
						_ ->
							Money = (Player#player.money)#money{rmb_total = abs(RmbTotal)},
							Player3#player{money = Money}
					end;
				{?error, ErrorCode} ->
					?MSG_ERROR("Error : ~p~n", [ErrorCode]),
					Player
			end;
		_ ->
			Player
	end.



%% 用户登录验证
login_check(_Uid, _Sid, _Time, _Pwd, ?true) when ?DEBUG_LOGIN == ?CONST_TRUE -> 
	ApiKey	= db:config_api_key(),
	SingStr = "uid=" ++ util:to_list(_Uid) ++ "&sid=" ++ util:to_list(_Sid) ++ "&time=" ++ util:to_list(_Time) ++"&key=" ++ util:to_list(ApiKey),
	Sing	= util:to_list(_Pwd),
	_Sing2	= util:md5(SingStr),
	?MSG_ECHO("~nlogin_check0 {Sing:~p Sing2:~p Uid:~p Sid:~p Time:~p~nSingStr:~p,Pwd:~p}",[Sing,_Sing2,_Uid,_Sid,_Time,SingStr,_Pwd]),
	?true;
login_check( Uid,  Sid,  Time,  Pwd, _Debug) ->
	?MSG_ECHO("~nlogin_check1 {Uid:~p,Sid:~p,Time:~p,Pwd:~p,Debug:~p}",[Uid,Sid,Time,Pwd,_Debug]),
	TimeNow = util:seconds(),
	if
		?DEBUG_LOGIN /= ?CONST_TRUE andalso abs(TimeNow - Time) > ?CONST_FAULT_TOLERANT ->
			?MSG_ERROR("login_check {TimeNow:~p Time:~p}",[TimeNow,Time]),
			?false;%% 登录失败
		?true ->
%% 			?true
			ApiKey	= db:config_api_key(),
			SingStr = "uid=" ++ util:to_list(Uid) ++ "&sid=" ++ util:to_list(Sid) ++
				      "&time=" ++ util:to_list(Time) ++"&key=" ++ util:to_list(ApiKey),
			Sing	= util:to_list(Pwd),
			case util:md5(SingStr) of
				Sing -> 
					?true; %% 登录成功
				Sing2->
					?MSG_ERROR("login_check {Sing:~p Sing2:~p Uid:~p Sid:~p Time:~p~nSingStr:~p,Pwd:~p}",[Sing,Sing2,Uid,Sid,Time,SingStr,Pwd]),
					?false %% 登录失败
			end
	end.


%% 升级
level_up(Player=#player{socket=Socket,uid=Uid,lv=InfoLv,info=Info})->
	AttrGroup=role_api_dict:attr_group_get(), 
	Inn		 =role_api_dict:inn_get(),
	InfoLv2=InfoLv+1,
	friend_api:level_up(InfoLv2,Socket,Uid),
	weagod_api:level_up(InfoLv2),
	ets:update_element(?ETS_ONLINE, Uid, [{#player.lv, InfoLv2}]),
	Info2	=Info#info{exp=0},
	?MSG_ECHO("===================== ~w~n",[AttrGroup#attr_group.lv]),
	Player2	=role_api:attr_update_player(Player#player{lv=InfoLv2,info=Info2},lv,AttrGroup#attr_group.lv),
	#inn{partners=Partners}=Inn, 
	role_api:sys_lv(Socket,InfoLv2),
	NxetExp2	=?DATA_PLAYER_UP_EXP:get(?CONST_PLAYER,InfoLv2), 
%% 	Fun=fun(Partner,Acc)->
%% 				#partner{partner_id=Partnerid,lv=PartnerLv}=Partner,
%% 				BinP0=role_api:msg_property_update(Partnerid,?CONST_ATTR_LV,PartnerLv),
%% 				<<Acc/binary,BinP0/binary>>
%% 		end,
%% 	BinP=lists:foldl(Fun,<<>>,Partners2), arena_api:arena_update_lv(1024,50)
	Bin =role_api:msg_property_update(0,?CONST_ATTR_LV,InfoLv2),
	Bin2=role_api:msg_property_update(0,?CONST_ATTR_EXPN,NxetExp2),
	arena_api:arena_update_lv(Uid,InfoLv2),
	skill_api:skill_auto_study(Player2),
	task_api:refresh(Player2),
	scene_api:change_level(Player, InfoLv2),
	app_msg:send(Socket, <<Bin/binary,Bin2/binary>>),
	Player2.


%% 角色初始化
role_init(Player)-> 
	DataSize			= length(?PROC_USER), 
	Data				= erlang:make_tuple(DataSize,0),
	{Player2,Data2,_Idx}= lists:foldl(fun role_init_inside/2,{Player,Data,1},?PROC_USER),
	{Player2,Data2}.
role_init_inside(Ud,{Player,Data,Idx})->
	Mod			= Ud#proc_ud.init_mod,
	Fun			= Ud#proc_ud.init_fun,
	if
		Ud#proc_ud.proc /= ?null andalso Mod /= ?null andalso Fun /= ?null ->
			{Player2,D}	= Mod:Fun(Player),
			?MSG_ECHO("=========== ~w~n",[{Mod,Fun}]),
			Data2		= setelement(Idx, Data, D);
		?true ->
			Player2		= Player,
			?MSG_ECHO("=========== ~w~n",[{Mod,Fun}]),
			Data2		= Data
	end,
	Idx2		= Idx+1,
	{Player2,Data2,Idx2}. 



	




	
	



