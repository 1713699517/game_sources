%% Author: Administrator
%% Created: 2012-12-12
%% Description: TODO: Add description to role_mod_db
-module(role_db).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").

-export([
		 money/2,
		 
		 role_create/16,
		 role_login/1,
		 role_save/2,
		 role_delete/1,
		 
		 ets_offline_read/1,
		 ets_offline_read/2,
		 ets_offline_update/2,
		 ets_offline_save/3,
		 ets_offline_delete/1,
		 ets_offline_clean/0,
		 
		 ets_online_read/1,
		 ets_online_update/1,
		 ets_online_update/3,
		 ets_online_delete/1
		]).

role_create(Uid,Socket,Mpid,
			Uname,UnameColor,Sex,Pro,Country,Lv,
			Attr,Info,Money,Sex,Vip,Is,Io)->
%% 	Attr	= #attr{},
%% 	Info	= #info{},
%% 	Money	= #money{},
%% 	Vip		= #vip{},
%% 	Is		= #is{},
%% 	Io		= #io{},
	Player2	= #player{
						uid         = Uid,           % 用户ID
						socket      = Socket,        % Socket
						mpid        = Mpid,          % 进程ID
						spid		= ?null,		 % 场景进程
		
						uname 		= Uname,		 % 玩家名字
						uname_color = UnameColor,	 % 角色名颜色			
						sex			= Sex,			 % 玩家性别
						pro 		= Pro,			 % 玩家职业
						country 	= Country,		 % 玩家阵营
						lv			= Lv,			 % 玩家等级
						lv_wea		= 0,			 % 玩家财神等级
						team_id     = 0,	 		 % 队伍ID
						team_leader	= 0,			 % 扩展1 (这个扩展 不能乱加 先申请 让一平来加)
						ext2		= 0,			 % 扩展2
						ext3		= 0,			 % 扩展3
						ext4		= 0,			 % 扩展4
						ext5		= 0,			 % 扩展5
						
						attr		= Attr,		 	 % 角色属性(最终的)
						info		= Info,		 	 % 玩家基本信息
						money		= Money,		 % 货币
						vip  		= Vip,		 	 % VIP
						is			= Is,  		 	 % 状态flag
						io			= Io			 % 网络I/O
					},
	{Player3,DictData}	= role_mod:role_init(Player2), 
	ets_offline_update(Player3,DictData),
	dict_write(DictData),
	mysql_insert(Player3, DictData),
	{?ok,Player3}.

role_login(Uid)->
	case ets_offline_read(Uid) of
		{?ok,?null} ->
			{?ok,?null}; 
		{?ok,PlayerBase, DictData}  ->
			%% 读出MYSQL里的金币
			Player    = case PlayerBase#player.mpid of
							?null -> 
								PlayerBase; %% 刚从MYSQL读出来的就不刷新了
							_ 	  ->
								Money	= role_api:currency_refresh(Uid, PlayerBase#player.money),
								Vip     = vip_api:buy_rmb(PlayerBase#player.vip,Money#money.rmb_total),
								PlayerBase#player{money=Money,vip = Vip}
						end,
%% 			?MSG_ECHO("===~w~n",[DictData]),
			dict_write(DictData),
			mysql_login_logs(Player),
			{?ok,Player};
		{?error,ErrorCode} ->
			{?error,ErrorCode}
	end.

% 保存数据
% 参数Way: ?CONST_TRUE  :退出时保存
%         ?CONST_FALSE :中间(如:定时)保存
role_save(Player,Way)->
	case Player#player.is of
		Is when is_record(Is,is) andalso Is#is.is_db == ?CONST_TRUE andalso Player#player.uid > 0 ->
			DictData	= dict_read(),
			ets_offline_update(Player,DictData),
			mysql_update(Player,DictData, Way); 
		_ ->
			?MSG_ERROR("save PlayerBase Uid:~p",[Player#player.uid])
	end,
	?ok.
%DELETE FROM `user` WHERE (`uid`='111')
%% 销毁角色 
role_delete(Uid)->
	case mysql_api:select("DELETE FROM `user` WHERE (`uid`='" ++ util:to_list(Uid) ++"')") of
		{?ok,_Data}->
			ets_offline_delete(Uid),
			ets_online_delete(Uid),
			?ok;
		{?error,Error}->
			{?error,Error}
	end.



dict_read()->
	DataSize	 = length(?PROC_USER),
	Data		 = erlang:make_tuple(DataSize,0),
	{Data2,_Idx} = lists:foldl(fun dict_read_inside/2,{Data,1},?PROC_USER),
	Data2.
dict_read_inside(Ud,{Data,Idx})->
	Mod			= Ud#proc_ud.dictget_mod,
	Fun			= Ud#proc_ud.dictget_fun,
	if
		Ud#proc_ud.proc /= ?null andalso Mod /= ?null andalso Fun /= ?null ->
			D		= Mod:Fun(),
			Data2	= setelement(Idx, Data, D);
		?true ->
			Data2	= Data
	end,
	{Data2,Idx+1}.

dict_write(Data)->
	lists:foldl(fun dict_write_inside/2,{Data,1},?PROC_USER),
	?ok.
dict_write_inside(Ud,{Data,Idx})->
	Mod			= Ud#proc_ud.dictset_mod,
	Fun			= Ud#proc_ud.dictset_fun,
	if
		Ud#proc_ud.proc /= ?null andalso Mod /= ?null andalso Fun /= ?null ->
			D		= element(Idx,Data),
%% 		    ?MSG_ECHO("~w~n",[D]),
			Data2	= setelement(Idx, Data, 0),
			Mod:Fun(D); 
		?true ->
			Data2	= Data
	end,
	{Data2,Idx+1}.

encode(Data)->
	{Data2,_Idx} = lists:foldl(fun encode_inside/2,{Data,1},?PROC_USER),
	Data2.
encode_inside(Ud,{Data,Idx})->
	Mod			= Ud#proc_ud.encode_mod,
	Fun			= Ud#proc_ud.encode_fun,
	if
		Ud#proc_ud.proc /= ?null andalso Mod /= ?null andalso Fun /= ?null ->
			D		= element(Idx,Data),
			D2		= Mod:Fun(D),
			Data2	= setelement(Idx, Data, D2);
		?true ->
			Data2	= Data
	end,
	{Data2,Idx+1}.

encode(Player,DictData)->
	Player2 = Player#player{socket = ?null,mpid = ?null,spid= ?null,io = ?null},
	Data2	= encode(DictData),
	{Player2,Data2}.

	
decode(Data)-> 
	{Data2,_Idx} = lists:foldl(fun decode_inside/2,{Data,1},?PROC_USER),
	Data2.
decode_inside(Ud,{Data,Idx})->
	Mod			= Ud#proc_ud.decode_mod,
	Fun			= Ud#proc_ud.decode_fun,
	if
		Ud#proc_ud.proc /= ?null andalso Mod /= ?null andalso Fun /= ?null ->
			D		= element(Idx,Data),
			D2		= Mod:Fun(D),
			Data2	= setelement(Idx, Data, D2);
		?true ->
			Data2	= Data
	end,
	{Data2,Idx+1}.


%% 在线列表数据
ets_online_read(Uid)->
	case ets:lookup(?ETS_ONLINE, Uid) of
		[Player|_] when is_record(Player, player) ->
			Player;
		_ ->
			?null
	end.
ets_online_update(Player)->
	case is_pid(Player#player.mpid) of
		?true->
			ets:insert(?ETS_ONLINE, Player);
		_->
			?skip
	end.
ets_online_update(Uid,PlayerIdx,Val)->
	ets:update_element(?ETS_ONLINE, Uid, [{PlayerIdx, Val}]).
ets_online_delete(Uid)->
	ets:delete(?ETS_ONLINE, Uid).


%% IsLogin:  true:登录时
ets_offline_read(Uid)-> 
	case ets:lookup(?ETS_OFFLINE,Uid) of
		[{Key,_Time,Player,Dict}|_] ->
			Times = util:seconds(),
			ets:insert(?ETS_OFFLINE,{Key,Times,Player,Dict}),
			{?ok,Player,Dict};
		_ ->
			case mysql_read(Uid) of
				{?ok,Player,Dict} when is_record(Player,player) ->
					ets_offline_update(Player#player{mpid=0},Dict), 
					{?ok,Player,Dict};
				{?ok,?null}  ->
					{?ok,?null};
				{?error,Error}->
					{?error,Error}
			end
	end.
ets_offline_read(Uid,Key)->
	ets_offline_read(Uid,Key,1).
ets_offline_read(Uid,Key,Loop)->
	case ets:lookup(?ETS_OFFLINE_SUB,{Uid,Key}) of
		[{Key2,_Time,Data}|_] ->
			Times = util:seconds(),
			ets:insert(?ETS_OFFLINE_SUB,{Key2,Times,Data}),
			{?ok,Data};
		_ when Loop > 0 ->
			ets_offline_read(Uid),
			ets_offline_read(Uid,Key,Loop-1);
		_ ->
			{?ok,?null}
	end.

ets_offline_update(Player=#player{uid=Uid},Dict) ->
	Times = util:seconds(),
	ets:insert(?ETS_OFFLINE,	{Uid,Times,Player,Dict}),
	ets:insert(?ETS_OFFLINE_SUB,{{Uid,player},Times,Player}),
	lists:foldl(fun ets_offline_update_inside/2,{Dict,Times,Uid,1},?PROC_USER),
	?ok.
ets_offline_update_inside(Ud,{Dict,Times,Uid,Idx})->
	if
		Ud#proc_ud.proc /= ?null ->
			D		= element(Idx,Dict),
			Dict2	= setelement(Idx, Dict, 0),
			ets:insert(?ETS_OFFLINE_SUB,{{Uid,Ud#proc_ud.proc},Times,D});
		?true ->
			Dict2	= Dict
	end,
	{Dict2,Times,Uid,Idx+1}.

ets_offline_save(Uid,ProcKey,DictValue)->
	case ets_offline_save_inside(?PROC_USER,1,ProcKey) of
		Idx when is_integer(Idx) ->
			case ets_offline_read(Uid) of
				{?ok,Player,Dict} ->
					Dict2	= setelement(Idx, Dict, DictValue),
					ets_offline_update(Player#player{uid=Uid},Dict2);
				{?error,Error} ->
					?MSG_ERROR("{?error,Error:~p} Idx:~p ProcKey:~p",[Error,Idx,ProcKey]),
					?ok;
				_Error ->
					?MSG_ERROR("{?error,Error:~p} Idx:~p ProcKey:~p",[_Error,Idx,ProcKey]),
					?ok
			end;
		_null ->
			?MSG_ECHO("Idx:~p ProcKey:~p",[_null,ProcKey]),
			?ok
	end.

ets_offline_save_inside([],_Idx,_ProcKey)->
	?null;
ets_offline_save_inside([Ud|T],Idx,ProcKey)->
	if
		Ud#proc_ud.proc == ProcKey ->
			Idx;
		?true ->
			ets_offline_save_inside(T,Idx+1,ProcKey)
	end.
 
ets_offline_delete(Uid)->
	ets:delete(?ETS_OFFLINE, 	 Uid),
	ets:delete(?ETS_OFFLINE_SUB, {Uid,player}),
	lists:foldl(fun ets_offline_delete_inside/2,Uid,?PROC_USER), 
	?ok.
ets_offline_delete_inside(Ud,Uid)->
	if
		Ud#proc_ud.proc /= ?null ->
			ets:delete(?ETS_OFFLINE_SUB, {Uid,Ud#proc_ud.proc});
		?true ->
			?skip
	end,
	Uid.


ets_offline_clean()->
	ets_offline_clean(?ETS_OFFLINE),
	ets_offline_clean(?ETS_OFFLINE_SUB).
	
ets_offline_clean(Tab)->
	Now	= util:seconds(),
	ets:safe_fixtable(Tab,?true), 
	First = ets:first(Tab),
	ets_offline_clean2(Tab,First,Now,[]),
	ets:safe_fixtable(Tab,?false),
	?ok.
%%  清理
ets_offline_clean2(Tab,'$end_of_table',_Now,Rs) ->
%% 	?MSG_ECHO("Rs:~p",[Rs]),
	ets_offline_clean3(Tab,Rs);
ets_offline_clean2(Tab,Key,Now,Rs) ->
	Rs2 = case ets:lookup(Tab,Key) of
			  [{Key,Times,_,_}|_] when Now - Times > ?CONST_OFF_DATA_TIME ->  [Key|Rs];
			  _ ->  Rs
		  end,
	NextKey	= ets:next(Tab,Key), 
    ets_offline_clean2(Tab,NextKey,Now,Rs2).
ets_offline_clean3(_Tab,[])-> ?ok;
ets_offline_clean3( Tab,[Key|Rs])->
	ets:delete(Tab, Key),
	ets_offline_clean3(Tab,Rs).



%% 元宝校正 
money(Uid, Money = #money{rmb=Rmb,rmb_total=RmbTotal}) ->
	if
		Rmb > RmbTotal ->
			Money2 = Money#money{rmb=0};
		?true ->
			Money2 = Money
	end,
	case mysql_api:select("SELECT `pay`,`balance` FROM `logs_pay` WHERE `uid` =" ++ util:to_list(Uid) ++ " and `pay` > 0 ORDER BY `time` DESC LIMIT 1; ") of
		{?ok,[[Pay,Balance]|_]} when Pay > 0 -> 
			case Balance of
				0 -> 
					Money2;
				_ when Money2#money.rmb =< Balance ->
					Money2;
				R ->
					?MSG_ERROR("-----------------uid:~w ~w Money:~p~n",[Uid,R,Money]),
					Money2#money{rmb=0,rmb_total=0}
			end;
		{?ok,_R}->
			Money2#money{rmb=0,rmb_total=0};
		_->
			Money2
	end.

mysql_login_logs(Player)->
	Time   	    = util:seconds(),
	Io			= Player#player.io,
	Uid			= Player#player.uid,
	Uuid		= Io#io.uuid,
	LoginIp		= Io#io.login_ip,
    Sid			= Io#io.sid,
	Cid			= Io#io.cid,
	LoginLast	= Time,
	Uname		= mysql_api:escape(Player#player.uname),
	Os			= mysql_api:escape(Io#io.os),
	Versions	= mysql_api:escape(Io#io.versions),
	Source		= mysql_api:escape(Io#io.source),
	SourceSub	= mysql_api:escape(Io#io.source_sub),
	SQL	 		= <<"UPDATE `user` SET  `login_times` = `login_times` + 1,`login_last` =  '",?B(LoginLast),"',`login_ip` =  '",?B(LoginIp),"'  WHERE `uid` =",?B(Uid)," LIMIT 1 ;">>,
	LogsSql  	= <<"INSERT INTO `logs_login` (`uid`,		 		`uuid`,	   			`cid`,		  	`sid`,				`os`,			`versions`,
											   `source`,	 		`source_sub`, 		`uname`,	  	`ip`,				`time`)VALUES 
											  (",?B(Uid),",  		",?B(Uuid),", 		",?B(Cid),",  	",?B(Sid),",		'",?B(Os),"',	'",?B(Versions),"',
											   '",?B(Source),"',	'",?B(SourceSub),"','",?B(Uname),"','",?B(LoginIp),"',	'",?B(Time),"');">>,
	mysql_api:fetch_cast(SQL),
	mysql_api:fetch_cast_logs(LogsSql),
	?ok.



% 保存数据
% 参数Way: ?CONST_TRUE  :退出时保存
%         ?CONST_FALSE :中间定时保存
mysql_update(Player,DictData,Way)->
	Time   	    = util:seconds(),
	Data		    = encode(Player, DictData),
	BinData		= mysql_api:encode(Data),
	Io			= Player#player.io,
	Info			= Player#player.info,
	Vip			= Player#player.vip,
	Money		= Player#player.money,
	Uid			= Player#player.uid,
	Lv			= Player#player.lv,
	Country		= Player#player.country,
	UnameColor	= Player#player.uname_color,
	MapId		= Info#info.map_id,
	X			= Info#info.pos_x,
	Y			= Info#info.pos_y,
	Exp			= Info#info.exp,
	ExpTotal	= Info#info.exp_total,
	State		= Info#info.state,
	VipLv		= Vip#vip.lv,
	VipIndate	= Vip#vip.indate,
	RmbConsume	= Money#money.rmb_consume,
	LoginLast	= Time,
	LoginIp		= Io#io.login_ip,
	OnlineLast0 = Time-Io#io.login_time,
	OnlineLast	= ?IF(OnlineLast0 > 0,OnlineLast0 ,0),
	OnlineTime	= Io#io.online + OnlineLast,
	Os			= mysql_api:escape(Io#io.os),
	Versions	= mysql_api:escape(Io#io.versions),
	SQL			= <<"UPDATE `user` SET	`versions` = '",?B(Versions),"' ,	   `uname_color` = '",?B(UnameColor),"' ,	`country` = '",?B(Country),"'  ,	 	`lv` = '",?B(Lv),"' ,",
									   "`vip`  = '",?B(VipLv),"' ,			   `vip_indate`  = '",?B(VipIndate),"' ,	`map_id`  = '",?B(MapId),"' ,	  		`x`  = '",?B(X),"'  ,",
									   "`y`  = '",?B(Y),"'   ,				   `exp`  = '",?B(Exp),"'  ,				`exp_total`  = '",?B(ExpTotal),"' ,		`rmb_consume`  = '",?B(RmbConsume),"' ,",
									   "`login_last`  = '",?B(LoginLast),"'  , `login_ip`   = '",?B(LoginIp),"' ,  		`online_time`  = '",?B(OnlineTime),"' , `online_last`  = '",?B(OnlineLast),"' ,",
									   "`state`  = '",?B(State),"' ,           `os` = '",?B(Os),"' ,					`data` = ",BinData/binary,
					" WHERE `uid` =",?B(Uid)," LIMIT 1 ;">>,
	case Way of
		?CONST_TRUE ->
			Fcm			= role_api_dict:fcm_get(),
			Os			= mysql_api:escape(Io#io.os),
			Sid			= Io#io.sid,
			Uuid			= Io#io.uuid,
			Cid			= Io#io.cid,
			Uname		= mysql_api:escape(Player#player.uname),
			Source		= mysql_api:escape(Io#io.source),
			SourceSub	= mysql_api:escape(Io#io.source_sub),
			SQL2		= <<" INSERT INTO `logs_online` (`time`,	   		`uid` ,		      `uuid` , 		   `cid` , 		 `sid` ,",
														"`os`,		   		`versions`,	      `source` ,       `source_sub`, `uname` ,",
														"`ip` , 	   		`online`) ",
											  " VALUES (",?B(Time),", 		",?B(Uid),",       ",?B(Uuid),",    ",?B(Cid),", 	   ",?B(Sid),",",
														"'",?B(Os),"', 		'",?B(Versions),"','",?B(Source),"','",?B(SourceSub),"','",?B(Uname),"',",
														"'",?B(LoginIp),"', ",?B(OnlineLast),");">>,
			case Fcm#fcm.fcm of
				?CONST_TRUE ->
					FcmTime		= Fcm#fcm.fcm_init + OnlineLast,
					global_queue:fcm_callback(Uid, FcmTime);
				_CONST_FALSE ->
					?ok
			end,
			mysql_api:fetch_cast(SQL),
			mysql_api:fetch_cast_logs(SQL2);
		_ -> 
			mysql_api:fetch_cast(SQL)
	end,
	?ok.


mysql_read(0)->
	?MSG_ERROR("uid 0",[]),
	{?error,?ERROR_NOT_PLAYER};
mysql_read(Uid)->
	Fields	= [uuid,cid,sid,os,versions,source,source_sub,uname,uname_color,pro,sex,country,
			   lv,vip,vip_indate,map_id,x,y,exp,exp_total,gold,rmb,rmb_bind,rmb_total,rmb_consume,
			   login_last,login_ip,online_time,state,data],
	case mysql_api:select(Fields,user,[{uid,Uid}]) of
		{?ok,[[Uuid,Cid,Sid,Os,Versions,Source,SourceSub,Uname,UnameColor,Pro,Sex,Country,
			   Lv,VipLv,VipIndate,MapId,X,Y,Exp,ExpTotal,Gold,Rmb,RmbBind,RmbTotal,RmbConsume,
			   LoginLast,LoginIp,OnlineTime,State,BinData|_]|_]}->
			{Player,Data}	= mysql_api:decode(BinData),
			Is		= (?IF(is_record(Player#player.is,is),Player#player.is,#is{}))#is{is_db=?CONST_FALSE},
			Attr	= ?IF(is_record(Player#player.attr,attr),Player#player.attr,#attr{}),
			Info	= (?IF(is_record(Player#player.info,info),Player#player.info,#info{}))#info{state=State,
																								map_id=MapId,
																								pos_x=X,
																								pos_y=Y,
																								exp=Exp,
																								exp_total=ExpTotal},
			Vip  	= (?IF(is_record(Player#player.vip,vip),Player#player.vip,#vip{}))#vip{lv=VipLv,indate=VipIndate},
			Money	= #money{
							 	 gold 		= Gold,			% 铜钱
								 rmb		= Rmb,			% 元宝
								 rmb_bind	= RmbBind,		% 绑定元宝
								 rmb_total  = RmbTotal,		% 充值总额
								 rmb_consume= RmbConsume 	% 已消耗元宝
							}, 
			Money2	= money(Uid, Money),
			Vip2    = vip_api:buy_rmb(Vip,Money2#money.rmb_total),
			Io		= #io{
							 db_save 		= ?CONST_FALSE,  % 数据库,下次存蓄时间
							 login_time	    = LoginLast,	 % 登录时间
							 login_ip	    = LoginIp,	     % 登录IP
							 online			= OnlineTime,	 % 在线总时长(不记本次)
							 uuid			= Uuid,			 % 帐号UUID
							 cid            = Cid,           % 平台cid
							 sid            = Sid,           % 服务器sid
							 os			    = Os,			 % 系统类型
							 versions       = Versions,		 % 游戏版本
							 source      	= Source,	     % 来源渠道
							 source_sub     = SourceSub,	 % 子渠道
						     offline  		= 0,             % 断线时长
							 heart			= 0,			 % 上次心跳包时间（毫秒）
							 heart_errs		= 0,			 % 连续错误心跳次数
							 io_hex			= 0,			 % 校验
							 io_hex_errs 	= 0,			 % 校验连续
							 io_hex_last	= 0,			 % 最近触发时间
							 io_list		= [],			 % Socket缓冲区
							 io_logs		= []	 		 % 最近5次 协议 与 数据{协议,数据}
						 },
			Player2	= Player#player{
							    uid         = Uid,           % 用户ID
								socket      = ?null,         % Socket
								mpid        = ?null,         % 进程ID
								spid		= ?null,		 % 场景进程
				
								
								uname 		= Uname,	     % 玩家名字
								uname_color = UnameColor,	 % 角色名颜色			
								sex			= Sex,			 % 玩家性别
								pro 		= Pro,			 % 玩家职业
								country 	= Country,		 % 玩家阵营
								lv			= Lv,			 % 玩家等级
								%lv_wea		= 0,			 % 玩家财神等级
								%team_id    = 0,	 		 % 队伍ID
								%team_leader= 0,		 	 % 队伍队长Uid
								
								attr		= Attr,		     % 角色属性(最终的)
								info		= Info,		 	 % 玩家基本信息
								vip  		= Vip2,		 	 % VIP
								money		= Money2,		 % 货币
								is			= Is,  		 	 % 状态flag
								io			= Io			 % 网络I/O
							  },
			Data2	= decode(Data),
			{?ok,Player2,Data2};
		{?ok,_Any} ->
			% ?MSG_ERROR("~p",[_Any]),
			{?ok,?null};
		{?error,Error}->
			?MSG_ERROR("~p",[Error]),
			{?error,Error}
	end.

mysql_insert(Player,DictData)->
	Time   	    = util:seconds(),
	Data		= encode(Player, DictData),
	BinData		= mysql_api:encode(Data),
	LoginTimes	= 1,
	Io			= Player#player.io,
	Info		= Player#player.info,
	Vip			= Player#player.vip,
	Money		= Player#player.money,
	Uid			= Player#player.uid,
	Pro			= Player#player.pro,
	Sex			= Player#player.sex,
	Lv			= Player#player.lv,
	Country		= Player#player.country,
	Uname		= mysql_api:escape(Player#player.uname),
	UnameColor	= Player#player.uname_color,
	MapId		= Info#info.map_id,
	X			= Info#info.pos_x,
	Y			= Info#info.pos_y,
	Exp			= Info#info.exp,
	ExpTotal	= Info#info.exp_total,
	State		= Info#info.state,
	Gold		= Money#money.gold,
	Rmb			= Money#money.rmb,
	RmbBind		= Money#money.rmb_bind,
	RmbTotal	= Money#money.rmb_total,
	RmbConsume	= Money#money.rmb_consume,
	VipLv		= Vip#vip.lv,
	VipIndate	= Vip#vip.indate,
	Uuid		= Io#io.uuid,
	Sid			= Io#io.sid,
	Cid			= Io#io.cid,
	RegTime		= Io#io.login_time,
	RegIp		= Io#io.login_ip,
	LoginLast	= Time,
	LoginIp		= Io#io.login_ip,
	OnlineLast0 = Time-Io#io.login_time,
	OnlineLast	= ?IF(OnlineLast0 > 0,OnlineLast0 ,0),
	OnlineTime	= Io#io.online + OnlineLast,
	Os			= mysql_api:escape(Io#io.os),
	Versions	= mysql_api:escape(Io#io.versions),
	Source		= mysql_api:escape(Io#io.source),
	SourceSub	= mysql_api:escape(Io#io.source_sub),
	if
		Uid < 1 orelse Uuid < 1 orelse Cid < 1 orelse Sid < 1 ->
			?MSG_ERROR("Uid:~p Uuid:~p Cid:~p Sid:~p",[Uid,Uuid,Cid,Sid]);
		?true ->
			?skip
	end,
    SQL			= <<"INSERT INTO `user` ( `uid`,      	 		`uuid`,		 		 	`cid`,					`sid`,					`os`  ,	  			    `versions` ,",
										" `source`  ,	 		`source_sub` ,		 	`uname`  ,				`uname_color`,			`pro` ,		  			`sex`  ,",
										" `country`  ,	 		`lv`,				 	`vip`  ,				`vip_indate` ,			`map_id` ,	  			`x`  ,",
										" `y`  ,		 		`exp` ,		 		 	`exp_total` ,			`gold` ,				`rmb`  ,	  			`rmb_bind`  ,",
										" `rmb_total` ,	 		`rmb_consume`,  	 	`reg_time`,    			`reg_ip`  ,     		`login_times`,			`login_last`  ,",
										" `login_ip`  ,  		`online_time`,  	 	`online_last`, 			`state`,        		`data` ) VALUES ",
					                    "('",?B(Uid),"',    	'",?B(Uuid),"', 	 	'",?B(Cid),"', 			'",?B(Sid),"',  		'",?B(Os),"', 			'",?B(Versions),"', ",
										" '",?B(Source),"', 	'",?B(SourceSub),"', 	'",?B(Uname),"', 		'",?B(UnameColor),"', 	'",?B(Pro),"', 			'",?B(Sex),"', ",
										" '",?B(Country),"', 	'",?B(Lv),"',			'",?B(VipLv),"',    	'",?B(VipIndate),"', 	'",?B(MapId),"', 		'",?B(X),"', ",
										" '",?B(Y),"', 			'",?B(Exp),"', 		 	'",?B(ExpTotal),"', 	'",?B(Gold),"', 		'",?B(Rmb),"', 			'",?B(RmbBind),"', ",
										" '",?B(RmbTotal),"', 	'",?B(RmbConsume),"',	'",?B(RegTime),"',    	'",?B(RegIp),"', 		'",?B(LoginTimes),"', 	'",?B(LoginLast),"', ",
										" '",?B(LoginIp),"', 	'",?B(OnlineTime),"', 	'",?B(OnlineLast),"',	'",?B(State),"', 		",BinData/binary,");">>,
	mysql_api:fetch_cast(SQL),
	stat_api:logs_user(Uid,Uuid,Cid,Sid,Io#io.os,Io#io.versions,Io#io.source,Io#io.source_sub,
					   Player#player.uname,Pro,Sex,Country,RegTime,RegIp),
	?ok.







