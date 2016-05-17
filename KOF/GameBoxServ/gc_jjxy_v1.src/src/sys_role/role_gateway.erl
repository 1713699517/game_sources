%% Author: Administrator
%% Created: 2012-6-21
%% Description: TODO: Add description to pp_player
-module(role_gateway).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([gateway/3]). 

%%
%% API Functions
%%
%% gateway(?P_ROLE_CONNECT_AGAIN, Player = #player{socket=Socket,mpid=Mpid,is=Is}, Binary) ->
%% 	{Uid,Sid,_LoginTime,_Pwd,_Fcm,Client,_Debug} = app_msg:decode({?int32u,?int16u,?int32u,?string,?int32u,?int8u,?bool},Binary),
%% 	%% ?MSG_ECHO("~n~n~nIs :~p~n", [is_record(Player, player)]),
%% 	case Is#is.is_db of
%% 		?CONST_FALSE ->
%% 			case role_mod:login_again(Socket,Mpid,Client,Uid,Sid) of
%% 				{?ok, ?change_socket} ->
%% 					Is2=Is#is{is_db=?CONST_FALSE},
%% 					{?ok,?change_socket,Player#player{uid=0,socket=?null,is=Is2}};
%% 				?false ->
%% 					gateway(?P_ROLE_LOGIN, Player, Binary)
%% 			end;
%% 		?CONST_TRUE ->
%% 			role_api:change_socket_update(Player),
%% 			{?ok, Player}
%% 	end;

gateway(?P_ROLE_LOGIN, Player = #player{socket=Socket,mpid=Mpid,is=Is}, Binary) ->
	{Uid,_Uuid,Sid,_Cid,Os,Pwd,Versions,
	 FcmInit,Relink,Debug,LoginTime} = app_msg:decode({?int32u,?int32u,?int16u,?int16u,?string,?string,?int32u,
												   ?int32u,?bool,?bool,?int32u},Binary),
	case role_mod:login_check(Uid, Sid, LoginTime, Pwd, Debug) of 
		?true ->
%% 			role_api:login_routine(Player,FcmInit,Sid,Uid,Os,Versions);
			case Relink of
				?true  ->
					case ets:lookup(?ETS_S_GLOBAL,{relink,Uid}) of
						[]->
							role_api:relink_check(Player, FcmInit, Sid, Uid, Os, Versions);
						[{_,STime}|_]->
							case util:seconds()-STime < 10 of
								?true->
									util:pid_send(Mpid, ?exit), %% 退出
									Is2=Is#is{is_db=?CONST_FALSE},
									{?ok,Player#player{uid=0,is=Is2}};
								_->
									role_api:relink_check(Player, FcmInit, Sid, Uid, Os, Versions)
							end
					end;
				?false ->
					role_api:login_routine(Player,FcmInit,Sid,Uid,Os,Versions)
			end;
		?false ->
			BinMsg	 = system_api:msg_disconnect(?ERROR_LOGIN_CHECK,<<>>),
			app_msg:send(Socket,BinMsg),
			util:pid_send(Mpid, ?exit), %% 退出
			Is2=Is#is{is_db=?CONST_FALSE},
			{?ok,Player#player{uid=0,is=Is2}}
	end;

gateway(?P_ROLE_CREATE,Player=#player{socket=Socket},Binary) -> 
	{Uid,Uuid,Sid,Cid,Os,Versions,Uname,Sex,Pro,Source,SourceSub,
	 LoginTime,_Ext1,Ext2} = app_msg:decode({?int32u,?int32u,?int16u,?int16u,?string,?int32u,?string,
											?int8u,?int8u,?string,?string,?int32u,?int16u,?int16u},Binary),
	?MSG_ECHO("~p",[{Uid,Cid,Uuid,Sid,LoginTime,Uname,Sex,Pro,Source,Ext2}]),
	case role_mod:create(Player,Uid,Uuid,Sid,Cid,Os,Versions,Uname,Sex,Pro,Source,SourceSub,LoginTime) of  
		{?ok,Player2=#player{money=Money,is=Is}} ->
			role_api:mpid_atom_reg(Uid),
			#money{gold=Gold,rmb=Rmb,rmb_bind=BindRmb} = Money,
%% 			role_api:online_reward(Socket,Sid,Uid),
			Sys=role_api_dict:sys_get(),
			role_api:role_sys(Socket,Sys),
			role_db:ets_online_update(Player2),
			top_api:top_create_updata(Player2),
			sys_set_api:sys_set_login(Socket),
			BinMsg 		= role_api:msg_login_ok_have(Player2),   
			BinMoney		= role_api:msg_currency(Gold,Rmb,BindRmb),
			BinEnergy 	= energy_api:request(Player2),
			app_msg:send(Socket,<<BinMsg/binary,BinMoney/binary,BinEnergy/binary>>),
			?MSG_ECHO("~n**********************Player:~p Login**********************~n",[Player#player.uid]),
			Equip= role_api_dict:equip_get(),
			Player3=bag_api:player_create_attr(Player2,Equip),
%% 			Pet = role_api_dict:pet_get(),
%% 			Player3=pet_api:player_attr_calc(Player2,Pet),
			Is2         = Is#is{is_db=?CONST_TRUE},
			{?ok,Player3#player{is=Is2,uname_color=?CONST_COLOR_GOLD}};
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Socket,BinMsg),
			{?ok,Player}
	end;

gateway(?P_ROLE_DEL,Player,_Binary) -> 
	{?ok,Player};

%% 请求玩家数据
gateway(?P_ROLE_PROPERTY,Player=#player{socket=Socket,uid=Uid},Binary) ->
	{_Sid,PUid,Type} = app_msg:decode({?int16u,?int32u,?int16u},Binary),
	case Uid=:=PUid of
		?true->
			role_api:role_data_cb(Player,{Socket,Type,?true});
		?false->
			case role_api:mpid(PUid) of
				Pid when is_pid(Pid)->
					util:pid_send(Pid,role_api,role_data_cb,{Socket,Type,?true});
				_->
					case role_api_dict:player_get(PUid) of
						{?ok,PPlayer} when is_record(PPlayer,player)->
							role_api:role_data_cb(PPlayer,{Socket,Type,?false});
						_R->
							BinMsg=system_api:msg_error(?ERROR_NOT_PLAYER),
							app_msg:send(Player#player.socket, BinMsg)
					end
			end
	end,
	{?ok, Player};


gateway(?P_ROLE_RAND_NAME,Player=#player{socket=Socket},Binary) ->
	{Sex} = app_msg:decode({?int8u},Binary),
	Name  = role_mod:create_name(Sex),
	BinMsg=role_api:msg_name(Name),
	app_msg:send(Socket,BinMsg), 
	{?ok,Player};

%% 请求自己的VIP
gateway(?P_ROLE_VIP_MY, #player{socket=Socket,vip=Vip}=Player, _Bin) ->
	if erlang:is_record(Vip, vip) ->
		   BinMsg = vip_api:msg_lv_my(Vip#vip.lv,Vip#vip.sum_rmb),
		   app_msg:send(Socket, BinMsg),
		   {?ok, Player};
	   ?true ->
		   Vip2= #vip{indate=0,lv=0,lv_real=0,sum_rmb=0},
		   BinMsg = vip_api:msg_lv_my(0,0),
		   app_msg:send(Socket, BinMsg),
		   {?ok, Player#player{vip=Vip2}}
	end;

%% 请求玩家的VIP
gateway(?P_ROLE_VIP, #player{socket=Socket,uid=Uid}=Player, Bin) ->
	{ToUid} = app_msg:decode({?int32u},Bin),
	{?ok,ToPlayer} = ?IF(ToUid=:=Uid,{?ok,Player},role_api_dict:player_get(ToUid)),
	if is_record(ToPlayer, player) ->
		   {Lv,_VipUp}	= vip_api:request_viplv(ToPlayer#player.vip),
		   BinMsg = vip_api:msg_vip_lv(Uid, Lv),
		   app_msg:send(Socket, BinMsg);
	   ?true -> ?ok
	end,
	{?ok, Player};



%% 使用功能图标
gateway(?P_ROLE_USE_SYS, Player, Bin) ->
	{SysId} = app_msg:decode({?int16u},Bin),
	role_api:sys_use(SysId),
	{?ok,Player};

%% 领取在线奖励
gateway(?P_ROLE_ONLINE_OK,Player=#player{socket=Socket},_Bin) ->
%% 	case role_api:online_reward(Player) of
%% 		{?error,_Erroe}->
%% 			{?ok,Player};
%% 		{?ok,Player2,BinMsg}->
%% 			app_msg:send(Socket,BinMsg),
%% 			{?ok,Player2};
%% 		_->
%% 			{?ok,Player}
%% 	end;
	{?ok,Player};
  
%% 请求玩家排名更新 
gateway(?P_ROLE_RANK_UPDATE,Player=#player{socket=Socket,uid=Uid},_Bin) ->
%% 	Rank=arena_api:arena_get_rank(Uid),
%% 	BinMsg=role_api:msg_property_update(0,?CONST_ATTR_RANK,Rank),
%% 	app_msg:send(Socket,BinMsg),
	{?ok,Player};


%% 请求精力值
gateway(?P_ROLE_ENERGY,#player{socket = Socket} = Player,_Bin) ->
	BinMsg = energy_api:request(Player),
	app_msg:send(Socket, BinMsg),
	{?ok,Player};

%% 请求购买精力值
gateway(?P_ROLE_ASK_BUY_ENERGY,Player,_Bin) ->
	BinMsg = energy_api:ask_buy(Player),
	app_msg:send(Player#player.socket, BinMsg),
	{?ok,Player};

%% 购买精力值
gateway(?P_ROLE_BUY_ENERGY,Player,_Bin) ->
	case energy_api:buy(Player) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Player2#player.socket, BinMsg),
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, BinMsg),
			{?ok,Player}
	end;

%% 购买精力值
gateway(?P_ROLE_BUFF_REQUEST,Player,_Bin) ->
	case energy_api:buffer(Player) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Player2#player.socket, BinMsg),
			{?ok,Player2};
		{?error,ErrorCode} ->
			BinMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, BinMsg),
			{?ok,Player}
	end;


%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.

