%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :Mod Api (gamecore.cn) dreamxyp@gmail.com
%%%
%%% Created : 2012-12-18
%%% -------------------------------------------------------------------
-module(card_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------

%% ====================================================================
%% API functions
%% ====================================================================
-export([gets/2,
		 msg_succeed/1]). 

-export([encode_sales/1,
		 decode_sales/1,
		 
		 new_pay/2,
		 new_pay_cb/2,
		 check_sales_type/1,
		 
		 login_sales/1,
		 init_sales/1,
		 sales_ask/1,  
		 sales_get/3,
		 sales_notice/1,
%% 		 sales_jf/2,
		 sales_notice_clan/1,
		 sales_notice_clan_cb/2,
		 sales_start/1,
%% 		 sales_broadcast/1,
		 
		 sales_arena/0,
		 sales_updata/2,
		 sales_time_setup/3,
		 sales_time_read/0,
		 
		 msg_rece/1,
		 msg_notice/0,
		 msg_get_ok/0,
		 msg_sales_data/1]).


encode_sales(Sales) -> 
	Sales.

decode_sales(Sales) when is_record(Sales,sales)->
	Sales;
decode_sales(_) ->
	#sales{}. 


%% 新手卡
gets(SN,Uid)->
	StrSn = util:to_list(SN),
	case string:tokens(StrSn, "-") of
		[Tag,Type,"1",Id] ->			
			?MSG_ECHO("SN:~p", [{Tag,Type,"1",Id}]),
			case mysql_api:select([<<"SELECT `uid` FROM  `card_list` where `type` = '">>,
								      Type,<<"' and `tag` = '">>,Tag,<<"' and `model` = '1' and `sn` ='">>,Id,<<"' limit 1;">>]) of
				{?ok,[[0]|_]} ->  %% 卡号可用
					UidStr = util:to_list(Uid),
					case mysql_api:select([<<"SELECT `tag` FROM  `card_list` where `uid` = '">>,UidStr,
										   <<"' and `type` = '">>,Type,<<"' limit 1;">>]) of
						{?ok,[]} ->
							case mysql_api:select([<<"SELECT `give`,`total`,`used`,`start_time`,`end_time` FROM  `card` where `type` = '">>,
										 			  Type,<<"' and `tag` = '">>,Tag,<<"' and `model` = '1' limit 1;">>]) of
								{?ok,[[MyGive,MyTotal,MyUsed,MyStartTime,MyEndTime]|_]} ->
									MyGiveGoodsId = util:to_integer(MyGive),
									NowTime		  = util:seconds(),
									?MSG_ECHO("Card:~p", [{MyGiveGoodsId,MyTotal,MyUsed,MyStartTime,MyEndTime}]),
									if
										NowTime < MyStartTime ->
											{?error,?ERROR_CARD_NOT_START};
										NowTime > MyEndTime ->
											{?error,?ERROR_CARD_OUTTIME};
										MyUsed >= MyTotal ->
											{?error,?ERROR_CARD_AFIH}; 
										?true ->
											mysql_api:fetch_cast([<<"UPDATE `card` SET  `used` =  `used`+1 WHERE `type` =  '">>,Type,<<"' AND `tag` =  '">>,Tag,<<"' AND `model` =  '1' limit 1;">>]),
											mysql_api:fetch_cast([<<"UPDATE `card_list` SET  `uid` = '">>,UidStr,<<"',`time` = '">>,util:to_list(NowTime),<<"'  where `type` = '">>,
										 						     Type,<<"' and `tag` = '">>,Tag,<<"' and `model` = '1' and `sn` ='">>,Id,<<"' limit 1;">>]),
											{?ok,MyGiveGoodsId}
									end;
								_ ->
									{?error,?ERROR_BUSY_MYSQL}
							end;
						{?ok,[[MyTag]|_]} ->
							case util:to_list(MyTag) of
								Tag ->
									{?error,?ERROR_CARD_JION_OK};
								_ ->
									{?error,?ERROR_CARD_JION_TYPE}
							end;
						_ ->
							{?error,?ERROR_BUSY_MYSQL}
					end;
				{?ok,[[Uid]|_]} ->
					{?error,?ERROR_CARD_USED_YOU};
				{?ok,[[_UseUid]|_]} ->
					{?error,?ERROR_CARD_USED};
				_ -> %%{?ok,[]} ->
					{?error,?ERROR_CARD_INVALID}
			end;
		[Tag,Type,"N","007YES"] ->
			% ?MSG_ECHO("SN:~p", [{Tag,Type}]),
			UidStr = util:to_list(Uid),
			case mysql_api:select([<<"SELECT `tag` FROM  `card_list` where `uid` = '">>,UidStr,
								   <<"' and `type` = '">>,Type,<<"' limit 1;">>]) of
				{?ok,[]} ->
					case mysql_api:select([<<"SELECT `give`,`total`,`used`,`start_time`,`end_time` FROM  `card` where `type` = '">>,
											  Type,<<"' and `tag` = '">>,Tag,<<"' and `model` = 'N' limit 1;">>]) of
						{?ok,[[MyGive,MyTotal,MyUsed,MyStartTime,MyEndTime]|_]} ->
							MyGiveGoodsId = util:to_integer(MyGive),
							NowTime		  = util:seconds(),
							?MSG_ECHO("Card:~p", [{MyGiveGoodsId,MyTotal,MyUsed,MyStartTime,MyEndTime}]),
							if
								NowTime < MyStartTime ->
									{?error,?ERROR_CARD_NOT_START};
								NowTime > MyEndTime ->
									{?error,?ERROR_CARD_OUTTIME};
								MyUsed >= MyTotal ->
									{?error,?ERROR_CARD_AFIH};
								?true ->
									mysql_api:fetch_cast([<<"UPDATE `card` SET  `used` =  `used`+1 WHERE `type` =  '">>,Type,<<"' AND `tag` =  '">>,Tag,<<"' AND `model` =  'N' limit 1;">>]),
									mysql_api:fetch_cast([<<"INSERT INTO `card_list` (`tag` ,`type` ,`model` ,`sn` ,`uid` ,`time`) VALUES ('">>,Tag,<<"',  '">>,Type,<<"', 'N',  '007YES_">>,UidStr,<<"',  '">>,UidStr,<<"',  '">>,util:to_list(NowTime),<<"');">>]),
									{?ok,MyGiveGoodsId}
							end;
						_ ->
							{?error,?ERROR_CARD_INVALID}
					end;
				{?ok,[[MyTag]|_]} ->
					case util:to_list(MyTag) of
						Tag ->
							{?error,?ERROR_CARD_JION_OK};
						_ ->
							{?error,?ERROR_CARD_JION_TYPE}
					end;
				_ ->
					{?error,?ERROR_BUSY_MYSQL}
			end;
		_ ->
			{?error,?ERROR_CARD_INVALID}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 促销活动 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% listen event
%% listen_sales(#player{sales = Sales} = Player, Type, Value) ->
%% 	case check_sales_type(Type) of
%% 		?true ->
%% 			ok;
%% 		?false ->
%% 			Player
%% 	end.


check_sales_type(Type) ->
	List = data_sales_total:get_ids(),
	Pred = fun(ID) ->
				   case ets:lookup(?ETS_SALES_TIME,ID) of
					   [#d_sales_total{type = Type0}|_] when Type0 =:= Type ->
						   ?true;
					   _ ->
						   ?false
				   end
		   end,
	lists:any(Pred, List).
	
	
	
  
%% 初始化 return : #sales{}
init_sales(Player) ->
	{Player,#sales{}}.	

%% 充值更新充值记录
new_pay(_Sid, Uid) ->
	role_api:progress_send(Uid, ?MODULE, new_pay_cb, []).

%% 回调更新人物身上充值记录数据
new_pay_cb(Player, []) ->
	login_sales(Player),
	Player.

%% 登陆初始化玩家充值记录数据(更新) 
login_sales(#player{uid = Uid} = Player) ->
	Sales=role_api_dict:sales_get(),
	Sql = [<<"SELECT `id`,`sid`,`pay`,`state`,`seconds` FROM logs_pay WHERE uid=">>,Uid],
%% 	SQL = "select id,pay,state,seconds from logs_pay where uid="++util:to_list(Uid),
	case mysql_api:select(Sql) of
		{?ok, List0} when is_list(List0) ->
			List = lists:map(fun([ID,Sid,Pay,State,Seconds]) ->
									 #sales{id = ID}
							 end, List0),
			erlang:put(sales, List),
			List;
		_ ->
			[]  
	end.
			

%% %%精彩活动提示
%% sales_broadcast(Player=#player{socket=Socket})->
%% 	{_,StartListData}=card_api:sales_ask(Player),
%% 	BinMsg=card_api:msg_sales_data(StartListData),
%% 	app_msg:send(Socket, BinMsg).

%% 精彩活动时间设置
sales_time_setup(SalesId,IsHave,Times)->
	case ets:lookup(?ETS_SALES_TIME,SalesId) of
		[DSalesTotal] when is_record(DSalesTotal,d_sales_total)->
			DSalesTotal2=DSalesTotal#d_sales_total{is_have=IsHave,s_id=0,time=Times},
			ets:insert(?ETS_SALES_TIME,DSalesTotal2),
			Onlines=ets:tab2list(?ETS_ONLINE),
			[util:pid_send(Online#player.uid,?MODULE,sales_updata,?null)||Online<-Onlines];
		[]->?skip
	end.

sales_updata(Player=#player{socket=Socket},_)->
	{Player2,StartListData,_}=card_api:sales_ask(Player),
	BinMsg=msg_sales_data(StartListData),
	?MSG_ECHO("geng xin jing cai huo dong ",[]),
	app_msg:send(Socket, BinMsg), 
	Player2.

%% 精彩活动 读取
%% [SalesTotal,..]
sales_time_read()->
	Sales = ets:tab2list(?ETS_SALES_TIME),
	Sales.

%% 竞技場活动是否开启
sales_arena()->
	Sid = app_tool:sid(),
	StartList=sales_start(Sid),
	StartList2=[DSalesTotal||{_,_,_,DSalesTotal}<-StartList],
	case lists:keyfind(?CONST_SALES_ARENA_RANKING,#d_sales_total.id,StartList2) of
		?false->?false;
		_->?true
	end.

%% 查看是否有活动领取
sales_notice(Player=#player{socket=Socket})->
	sales_ask(Player),
	Sales=role_api_dict:sales_get(),
	case sales_notice2(Sales#sales.value) of
		?true->
			BinMsg=msg_notice(),
			app_msg:send(Socket,BinMsg);
		_->
			?skip
	end.

%% %% 精彩消费活动积分
%% sales_jf(Player=#player{sid=Sid,save=Save},Rmb)->
%% 	StartList=sales_start(Sid),
%% 	StartList2=[DSalesTotal||{_,_,_,DSalesTotal}<-StartList],
%% 	case lists:keyfind(?CONST_SALES_ID_PAY_POINT_F,#d_sales_total.id,StartList2) of
%% 		?false->Save2=Save#save{ext2=0};
%% 		_->Save2=Save#save{ext2=Save#save.ext2+Rmb}
%% 	end,
%% 	Player#player{save=Save2}.
		
	



%% 过滤已完成精彩活动
sales_filtrate(Uid,StartList)->
	case mysql_api:select("SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" 
						 ++ util:to_list(Uid)) of
		{?ok,UseSales}->
			sales_filtrate2(UseSales,StartList);
		_->
			StartList
	end.
	
sales_filtrate2(UseSales,StartList)->
	Fun=fun({StarrTime,EndTime,DSalesTotal},Acc)->
				if
					DSalesTotal#d_sales_total.type_getshow==?CONST_FALSE->
						[{StarrTime,EndTime,DSalesTotal}|Acc];
					?true->
						IdStepAll  =data_sales_sub:get_ids(),
						IdStepCount=length([Step||{Id,Step}<-IdStepAll,Id=:=DSalesTotal#d_sales_total.id]),
						UseCount   =length([TypeStep||[_,UseId,_,_,TypeStep,_,_]<-UseSales,UseId=:=DSalesTotal#d_sales_total.id]),
						case UseCount>=IdStepCount of
							?true-> 
								Acc;
							_    ->
								[{StarrTime,EndTime,DSalesTotal}|Acc]
						end
				end
		end,
	lists:foldl(Fun,[],StartList).			

sales_notice2([])->?false;
sales_notice2([{_Tid,SIdSteps}|StartListData])->
	case length(SIdSteps)>0 of
		?true->?true;
		_-> sales_notice2(StartListData)
	end.


%%精彩活动家族升级
sales_notice_clan(Uids)->
	[role_api:progress_send(Uid,?MODULE,sales_notice_clan_cb,?null)||Uid<-Uids].

sales_notice_clan_cb(Player,_)->
	sales_notice(Player),
	Player.

%% 查看该服务器是否开启此活动
sales_total_sid(_Sid,0)->?true;
sales_total_sid(_Sid,[])->?false;
sales_total_sid(Sid,[SalesSid|SalesSids])->
	case Sid==SalesSid of
		?true-> ?true;
		_->sales_total_sid(Sid,SalesSids)
	end.
	

%% 可以开启的精彩活动
sales_start(Sid)->
	IDs = data_sales_total:get_ids(), 
	Fun=fun(Id,Acc)-> 
				case ets:lookup(?ETS_SALES_TIME,Id) of
					[DSalesTotal|_] when is_record(DSalesTotal,d_sales_total)->
						#d_sales_total{s_id=SalesSids,is_have=IsHave,valid=Valid,time=Times}=DSalesTotal,
						case IsHave == 0 of
							?true-> Acc;
							_->
								case Valid==0 of
									?true->Acc;
									_->
										case sales_total_sid(Sid,SalesSids) of
											?true->
												case sales_ask_ymd(Times) of
													{NStarrTime,NEndTime}->
														Time=util:seconds(),
														if
															(Time>=NStarrTime andalso Time=<NEndTime) orelse
																(Time>=NStarrTime andalso NEndTime==0)->
																[{NStarrTime,NEndTime,DSalesTotal}|Acc];
															?true->
																Acc
														end;
													_->
														Acc
												end;
											_->Acc
										end
								end
						end;
					_->Acc
				end
		end,
	lists:foldl(Fun,[],IDs). 
	
%% 已经激活的活动
sales_ask_ymd(Times)->
	Day=db:config_work_day(),
	{{Y,M,D},_}=util:localtime(), %% 得到当前的日期
	Time=util:datetime2timestamp(Y,M,D,0,0,0), %% 得到当前的秒数
	%% 刷选出已经开始的活动
	case Times of
		[]->
			StarrTime=?IF(Day==1,Time,Time-(Day-1)*24*3600),
			EndTime  =0,
			{StarrTime,EndTime};
		_->
			sales_ask_ymd2(Times)
	end.

%%[{StartM,StartD,StartH,StartI,StartS,EndM,EndD,EndH,EndI,EndS},..]:  自然时间{月,日,时,分,月,日,时,分}
sales_ask_ymd2([{StartM,StartD,StartH,StartI,StartS,EndM,EndD,EndH,EndI,EndS}|Times])->
	DQtime=util:seconds(),
	{{Y,_M,_D},_}=util:localtime(),
	StartTime=util:datetime2timestamp(Y,StartM,StartD,StartH,StartI,StartS),
	EndTime	 =util:datetime2timestamp(Y,EndM,EndD,EndH,EndI,EndS),
	if
		DQtime>=StartTime andalso DQtime=<EndTime->{StartTime,EndTime};
		?true->sales_ask_ymd2(Times)
	end;

%%[{open,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS},..]:  开服时间(开服当天算第一天){开服天数,时,分,开服天数,时,分}
sales_ask_ymd2([{open,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS}|Times])->
	Day=db:config_work_day(),
	{{Y,M,D},_}=util:localtime(),
	if
		Day>=StartD andalso Day=<EndD->
			{SY,SM,SD}=sales_start_sid(start,Y,M,D,StartD,Day),
			{EY,EM,ED}=sales_start_sid(eend,Y,M,D,EndD,Day),
			StartTime=util:datetime2timestamp(SY,SM,SD,StartH,StartI,StartS),
			EndTime	 =util:datetime2timestamp(EY,EM,ED,EndH,EndI,EndS),
			{StartTime,EndTime};
		?true->sales_ask_ymd2(Times)
	end;

%%[{week,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS},..]:  每周活动(1-7){星期几,时,分,星期几,时,分}
sales_ask_ymd2([{week,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS}|Times])->
	Week=util:week(),
	{{Y,M,D},_}=util:localtime(),
	if
		Week>=StartD andalso Week=<EndD->
			{SY,SM,SD}=sales_week(start,Y,M,D,StartD),
			{EY,EM,ED}=sales_week(eend,Y,M,D,EndD),
			StartTime=util:datetime2timestamp(SY,SM,SD,StartH,StartI,StartS),
			EndTime	 =util:datetime2timestamp(EY,EM,ED,EndH,EndI,EndS),
			{StartTime,EndTime};
		?true->sales_ask_ymd2(Times)
	end;

%%[{month,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS},..]: 每月活动(1-31){几号,时,分,几号,时,分}
sales_ask_ymd2([{month,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS}|Times])->
	{{Y,M,D},_}=util:localtime(),
	if
		D>=StartD andalso D=<EndD->
			StartTime=util:datetime2timestamp(Y,M,StartD,StartH,StartI,StartS),
			EndTime	 =util:datetime2timestamp(Y,M,EndD,EndH,EndI,EndS),
			{StartTime,EndTime};
		?true->sales_ask_ymd2(Times)
	end;
			
sales_ask_ymd2(_)->?null.


%% 开始星期几的日期
sales_week(start,Y,M,D,SWeek)->
	Week=util:week(Y,M,D),
	case Week==SWeek of
		?true->{Y,M,D};
		_->
			Time =util:datetime2timestamp(Y,M,D,0,0,0),
			Time2=Time-24*3600,
			{{YY,YM,YD},_}=util:seconds2localtime(Time2),
			sales_week(start,YY,YM,YD,SWeek)
	end;
%% 结束星期几的日期
sales_week(eend,Y,M,D,EWeek)->
	Week=util:week(Y,M,D),
	case Week==EWeek of
		?true->{Y,M,D};
		_->
			Time=util:datetime2timestamp(Y,M,D,0,0,0),
			Time2=Time+24*3600,
			{{YY,YM,YD},_}=util:seconds2localtime(Time2),
			sales_week(eend,YY,YM,YD,EWeek)
	end;
sales_week(_,Y,M,D,_Week)->{Y,M,D}.

%% 开服天数的日期
sales_start_sid(start,Y,M,D,StartD,SDay)->
	case StartD==SDay of
		?true->{Y,M,D};
		_->
			Time=util:datetime2timestamp(Y,M,D,0,0,0),
			Time2=Time-24*3600,
			{{YY,YM,YD},_}=util:seconds2localtime(Time2),
			sales_start_sid(start,YY,YM,YD,StartD,SDay-1)
	end;
%% 结束天数的日期
sales_start_sid(eend,Y,M,D,EndD,EDay)->
	case EndD==EDay of
		?true->{Y,M,D};
		_->
			Time=util:datetime2timestamp(Y,M,D,0,0,0),
			Time2=Time+24*3600,
			{{YY,YM,YD},_}=util:seconds2localtime(Time2),
			sales_start_sid(eend,YY,YM,YD,EndD,EDay+1)
	end;
sales_start_sid(_,Y,M,D,_Day,_StartDay)->{Y,M,D}.

%% 
%% 请求促销活动状态
%% return : BinMsg :: binary()
sales_ask(#player{uid=Uid,io=Io,lv=Lv}=Player) ->
	#io{sid=Sid,cid=Cid}=Io,
	Sales=role_api_dict:sales_get(),
	StartList=sales_start(Sid), 
	StartList2=sales_filtrate(Uid,StartList),
	Fun=fun({StarrTime,EndTime,DSalesTotal},{Acc,SIdSteps})->
				IdStepAll=data_sales_sub:get_ids(),
				#d_sales_total{id=Tid,type=Type}=DSalesTotal,
				case sales_ask_type(Uid,Tid,Type) of
					?true->
						case Tid of
							?CONST_SALES_ID_PAY_ONCE->
								IdSteps=[Step||{Id,Step}<-IdStepAll,Id=:=?CONST_SALES_ID_PAY_ONCE],
								{YIdSteps,SIdSteps2}=sales_ask_type_first(Uid,Cid,Tid,Type,IdSteps);
							?CONST_SALES_ID_PAY_SINGLE->
								IdSteps=[Step||{Id,Step}<-IdStepAll,Id=:=?CONST_SALES_ID_PAY_SINGLE],
								{YIdSteps,SIdSteps2}=sales_ask_type_pay_once(Uid,Cid,Tid,Type,IdSteps);
							?CONST_SALES_PAY_TOTAL->
								IdSteps=[Step||{Id,Step}<-IdStepAll,Id=:=?CONST_SALES_PAY_TOTAL],
								{YIdSteps,SIdSteps2}=sales_ask_type_pay_sun(Uid,Cid,Tid,Type,IdSteps);
							?CONST_SALES_PAY_TOTAL_TIME->
								IdSteps=[Step||{Id,Step}<-IdStepAll,Id=:=?CONST_SALES_PAY_TOTAL_TIME],
								{YIdSteps,SIdSteps2}=sales_ask_type_moth_sun(Uid,Cid,Tid,Type,StarrTime,EndTime,IdSteps);
							?CONST_SALES_REACH_LV->
								IdSteps=[Step||{Id,Step}<-IdStepAll,Id=:=?CONST_SALES_REACH_LV],
								{YIdSteps,SIdSteps2}=sales_ask_type_level(Uid,Cid,Tid,Type,Lv,IdSteps);
							?CONST_SALES_KILL_ALMA->
								IdSteps=[Step||{Id,Step}<-IdStepAll,Id=:=?CONST_SALES_KILL_ALMA],
								{YIdSteps,SIdSteps2}=sales_ask_type_adg(Uid,Cid,Tid,Type,IdSteps);
							?CONST_SALES_KILL_DEVILS->
								IdSteps=[Step||{Id,Step}<-IdStepAll,Id=:=?CONST_SALES_KILL_DEVILS],
								{YIdSteps,SIdSteps2}=sales_ask_type_adg(Uid,Cid,Tid,Type,IdSteps);
							?CONST_SALES_FIGHT_GAS->
								IdSteps=[Step||{Id,Step}<-IdStepAll,Id=:=?CONST_SALES_FIGHT_GAS],
								{YIdSteps,SIdSteps2}=sales_ask_type_adg(Uid,Cid,Tid,Type,IdSteps);
							?CONST_SALES_COLLECT_TREASURES->
								IdSteps=[Step||{Id,Step}<-IdStepAll,Id=:=?CONST_SALES_COLLECT_TREASURES],
								{YIdSteps,SIdSteps2}=sales_ask_type_treasures(Uid,Cid,Tid,Type,IdSteps);
							?CONST_SALES_ARENA_RANKING->
								IdSteps=[Step||{Id,Step}<-IdStepAll,Id=:=?CONST_SALES_ARENA_RANKING],
								{YIdSteps,SIdSteps2}=sales_ask_type_arena(Uid,Cid,Tid,Type,IdSteps);
							_->
								{YIdSteps,SIdSteps2}={[],[]}
						end,
						Acc2=[{Tid,StarrTime,EndTime,YIdSteps}|Acc],
						SIdSteps3=[{Tid,SIdSteps2}|SIdSteps],
						{Acc2,SIdSteps3};
					_->
						{Acc,SIdSteps}
				end
		end,
	{StartListData,SalesGetS}=lists:foldl(Fun,{[],[]},StartList2),
	Sales2=Sales#sales{value=SalesGetS},
	role_api_dict:sales_set(Sales2),
	{Player,StartListData,Sales2#sales.rece}. 

%% 查看平台是否有奖励
sales_cid(Cid,Cids)->
	case [NCid||NCid<-Cids,Cid=:=NCid] of
		[]->
			?true;
		_->
			?false
	end.
			
%% `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` 
%% `oid`,`uid`,`pay`,`time` 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%查看是否有相同类型的活动%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sales_ask_type(Uid,Tid,Type)->
	case mysql_api:select("SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count`  FROM `sales_ask_use` WHERE `type` =" ++ util:to_list(Type) ++
							  " AND `uid` =" ++ util:to_list(Uid)) of
		{?ok,[]}-> ?true;
		{?ok,Data}->
			sales_ask_type_id(Tid,Data);
		_->
			?false
	end.

sales_ask_type_id(_Tid,[])->?true;
sales_ask_type_id(Tid,[[_Uid,Id,_Type,_Arg,_TypeStep,_Times,_Count]|Data])->
	case Tid=:=Id of
		?true->sales_ask_type_id(Tid,Data);
		_->?false
	end;
sales_ask_type_id(_Tid,_)->?true.

%%%%%%%%%%%%%%%%%%%%活动 单笔充值 ?CONST_SALES_ID_PAY_ONCE是否有领取查询%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sales_ask_type_pay_once(Uid,Cid,Tid,Type,IdSteps)->
	case mysql_api:select("SELECT `oid`,`uid`,`pay`,`time` FROM `logs_pay` WHERE `uid` =" ++ util:to_list(Uid)) of
		{?ok,[]}->{[],[]};
		{?ok,OidList}->
			case mysql_api:select("SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++
									  " and `id` = " ++ util:to_list(Tid)) of
				{?ok,UseOids}->
					sales_ask_type_pay_once2(OidList,Cid,Tid,Type,IdSteps,UseOids,[],[]);
				_->
					{[],[]}
			end;
		_->
			{[],[]}
	end.
		
%% 查找是否有可领取的订单   
sales_ask_type_pay_once2([],_Cid,_Tid,_Type,_,_UseOids,Acc,SAcc)->{Acc,SAcc};
sales_ask_type_pay_once2([[Oid,Uid,Pay,_Time]|OidList],Cid,Tid,Type,IdSteps,UseOids,Acc,SAcc)->
	case sales_ask_type_pay_once3(Pay,Cid,IdSteps) of
		?null->
			sales_ask_type_pay_once2(OidList,Cid,Tid,Type,IdSteps,UseOids,Acc,SAcc);
		{IdStep,_MCount}->  %% 判断订单是都已经领取过奖励
			case sales_ask_type_pay2(Oid,UseOids) of
				?true->
					Acc2 =[IdStep|Acc],
					SAcc2=[{Uid,Tid,Type,Oid,IdStep,1}|SAcc],
					sales_ask_type_pay_once2(OidList,Cid,Tid,Type,IdSteps,UseOids,Acc2,SAcc2);
				_->
					sales_ask_type_pay_once2(OidList,Cid,Tid,Type,IdSteps,UseOids,Acc,SAcc)
			end
	end.
	
%% 产看订单是都达到活动要求
sales_ask_type_pay_once3(_,_Cid,[])->?null;
sales_ask_type_pay_once3(Pay,Cid,[IdStep|IdSteps])->
	case data_sales_sub:get(IdStep) of
		DSalesSub when is_record(DSalesSub,d_sales_sub)->
			case sales_cid(Cid,DSalesSub#d_sales_sub.cid) of
				?true->
					{MIN,MAX}=DSalesSub#d_sales_sub.value,
					if
						MAX=:=0 -> 
							?IF(Pay>=MIN,{IdStep,DSalesSub#d_sales_sub.times},sales_ask_type_pay_once3(Pay,Cid,IdSteps));
						?true->
							?IF((Pay>=MIN andalso Pay=<MAX),{IdStep,DSalesSub#d_sales_sub.times},sales_ask_type_pay_once3(Pay,Cid,IdSteps))
					end;
				_->
					sales_ask_type_pay_once3(Pay,Cid,IdSteps)
			end;
		_->
			sales_ask_type_pay_once3(Pay,Cid,IdSteps)
	end.


%% 查看订单是否领取
sales_ask_type_pay2(_Oid,[])->?true;
sales_ask_type_pay2(Oid,[[_Uid,_Id,_Type,Arg,_TypeStep,_Times,_Count]|UseOids])->
	case Oid==Arg of
		?true->?false;
		_->sales_ask_type_pay2(Oid,UseOids)
	end;
sales_ask_type_pay2(_Oid,_)->?false.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%活动 单笔充值 ?CONST_SALES_ID_PAY_ONCE是否有领取查询%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_pay_once_f(Uid,Tid,Type,IdSteps,StarrTime,EndTime)->
%% 	case mysql_api:select("SELECT `oid`,`uid`,`pay`,`time` FROM `logs_pay` WHERE `uid` =" ++ util:to_list(Uid)) of
%% 		{?ok,[]}->{[],[]};
%% 		{?ok,OidList}->
%% 			case mysql_api:select("SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++
%% 							      " and `id` = " ++ util:to_list(Tid)) of
%% 				{?ok,UseOids}->
%% %% 					UseOids2=[list_to_tuple(UseOid)||UseOid<-UseOids],
%% 					sales_ask_type_pay_once_f2(OidList,Tid,Type,IdSteps,UseOids,StarrTime,EndTime,[],[]);
%% 				_->
%% 					{[],[]}
%% 			end;
%% 		_->
%% 			{[],[]}
%% 	end.
%% 		
%% %% 查找是否有可领取的订单   
%% sales_ask_type_pay_once_f2([],_Tid,_Type,_,_UseOids,_StarrTime,_EndTime,Acc,SAcc)->{Acc,SAcc};
%% sales_ask_type_pay_once_f2([[Oid,Uid,Pay,Time]|OidList],Tid,Type,IdSteps,UseOids,StarrTime,EndTime,Acc,SAcc)->
%% 	if
%% 		Time>=StarrTime andalso Time=<EndTime ->
%% 			case sales_ask_type_pay_once_f3(Pay,IdSteps) of
%% 				?null->
%% 					sales_ask_type_pay_once_f2(OidList,Tid,Type,IdSteps,UseOids,StarrTime,EndTime,Acc,SAcc);
%% 				{IdStep,_MCount}->  %% 判断订单是都已经领取过奖励
%% 					case sales_ask_type_pay2(Oid,UseOids) of
%% 						?true->
%% 							Acc2=[IdStep|Acc],
%% 							SAcc2=[{Uid,Tid,Type,Oid,IdStep,1}|SAcc],
%% 							sales_ask_type_pay_once_f2(OidList,Tid,Type,IdSteps,UseOids,StarrTime,EndTime,Acc2,SAcc2);
%% 						_->
%% 							sales_ask_type_pay_once_f2(OidList,Tid,Type,IdSteps,UseOids,StarrTime,EndTime,Acc,SAcc)
%% 					end
%% 			end;
%% 		?true->
%% 			sales_ask_type_pay_once_f2(OidList,Tid,Type,IdSteps,UseOids,StarrTime,EndTime,Acc,SAcc)
%% 	end.
%% 	
%% %% 产看订单是都达到活动要求
%% sales_ask_type_pay_once_f3(_,[])->?null;
%% sales_ask_type_pay_once_f3(Pay,[IdStep|IdSteps])->
%% 	case data_sales_sub:get(IdStep) of
%% 		DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 			{MIN,MAX}=DSalesSub#d_sales_sub.value,
%% 			if
%% 				MAX=:=0 -> 
%% 					?IF(Pay>=MIN,{IdStep,DSalesSub#d_sales_sub.times},sales_ask_type_pay_once3(Pay,IdSteps));
%% 				?true->
%% 					?IF((Pay>=MIN andalso Pay=<MAX),{IdStep,DSalesSub#d_sales_sub.times},sales_ask_type_pay_once3(Pay,IdSteps))
%% 			end;
%% 		_->
%% 			sales_ask_type_pay_once_f3(Pay,IdSteps)
%% 	end.

%%%%%%%%%%%%%%%%%%%%活动固定时间累计 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sales_ask_type_moth_sun(Uid,Cid,Tid,Type,StarrTime,EndTime,IdSteps)->
	case mysql_api:select("SELECT `oid`,`uid`,`pay`,`time` FROM `logs_pay` WHERE `uid` =" ++ util:to_list(Uid)) of
		{?ok,[]}->{[],[]};
		{?ok,OidList}->
			OidPay=[Pay||[_Oid,_Uid,Pay,Time]<-OidList,(Time>=StarrTime andalso Time=<EndTime) orelse (Time>=StarrTime andalso EndTime==0)],
			PaySum=lists:sum(OidPay),
			sales_ask_type_moth_sun2(Uid,Cid,PaySum,Tid,Type,IdSteps);
		_->
			{[],[]}
	end.
	
sales_ask_type_moth_sun2(Uid,Cid,PaySum,Tid,Type,IdSteps)->
	IdSteps2=sales_ask_type_pay_sun3(Cid,PaySum,IdSteps,[]),
	case mysql_api:select("SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
							  " AND `type` = " ++ util:to_list(Type)) of
		{?ok,[]}->
			Fun1=fun({IdStep,_MCount},{Acc,SAcc})->
						Acc2=[IdStep|Acc],
						SAcc2=[{Uid,Tid,Type,0,IdStep,1}|SAcc],
						{Acc2,SAcc2}
				end,
			lists:foldl(Fun1,{[],[]},IdSteps2);
		{?ok,PaySunDate}->
			case [TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate] of
				[]->
					Fun2=fun({IdStep,_MCount},{Acc,SAcc})->
								Acc2=[IdStep|Acc],
								SAcc2=[{Uid,Tid,Type,0,IdStep,1}|SAcc],
								{Acc2,SAcc2}
						end,
					lists:foldl(Fun2,{[],[]},IdSteps2);
				PaySun2->
					IdStep2=lists:max(PaySun2),
					Fun3=fun({IdStep,_MCount},{Acc,SAcc})->
								case IdStep>IdStep2 of
									?true->
										Acc2=[IdStep|Acc],
										SAcc2=[{Uid,Tid,Type,0,IdStep,1}|SAcc],
										{Acc2,SAcc2};
									_->
										{Acc,SAcc}
								end
						end,
					lists:foldl(Fun3,{[],[]},IdSteps2)
			end;
		_->
			{[],[]}
	end.
			

%%%%%%%%%%%%%%%%%%%%活动每日累计充值 ?CONST_SALES_ID_PAY_SUM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sales_ask_type_pay_sun(Uid,Cid,Tid,Type,IdSteps)->
	case mysql_api:select("SELECT `oid`,`uid`,`pay`,`time` FROM `logs_pay` WHERE `uid` =" ++ util:to_list(Uid)) of
		{?ok,[]}->{[],[]};
		{?ok,OidList}->
			OidList2=pay_sun_time(OidList),
			sales_ask_type_pay_sun2(Uid,Cid,OidList2,Tid,Type,IdSteps);
		_->
			{[],[]}
	end.

sales_ask_type_pay_sun2(Uid,Cid,OidList,Tid,Type,IdSteps)->
	PaySum=lists:sum([Pay||[_Oid,_Uid,Pay,_Time]<-OidList]),
	IdSteps2=sales_ask_type_pay_sun3(Cid,PaySum,IdSteps,[]),
	case mysql_api:select("SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
							  " AND `type` = " ++ util:to_list(Type)) of
		{?ok,[]}->
			Fun1=fun({IdStep,_MCount},{Acc,SAcc})->
						Acc2=[IdStep|Acc],
						SAcc2=[{Uid,Tid,Type,0,IdStep,1}|SAcc],
						{Acc2,SAcc2}
				end,
			lists:foldl(Fun1,{[],[]},IdSteps2);
		{?ok,PaySunDate}->
			case pay_sun_time(PaySunDate) of
				[]->
					Fun2=fun({IdStep,_MCount},{Acc,SAcc})->
								Acc2=[IdStep|Acc],
								SAcc2=[{Uid,Tid,Type,0,IdStep,1}|SAcc],
								{Acc2,SAcc2}
						end,
					lists:foldl(Fun2,{[],[]},IdSteps2);
				PaySun2->
					IdStep2=lists:max(PaySun2),
					Fun3=fun({IdStep,_MCount},{Acc,SAcc})->
								case IdStep>IdStep2 of
									?true->
										Acc2=[IdStep|Acc],
										SAcc2=[{Uid,Tid,Type,0,IdStep,1}|SAcc],
										{Acc2,SAcc2};
									_->
										{Acc,SAcc}
								end
						end,
					lists:foldl(Fun3,{[],[]},IdSteps2)
			end;
		_->
			{[],[]}
	end.
	    

sales_ask_type_pay_sun3(_Cid,_PaySum,[],Acc)->Acc;
sales_ask_type_pay_sun3(Cid,PaySum,[IdStep|IdSteps],Acc)->
	case data_sales_sub:get(IdStep) of
		DSalesSub when is_record(DSalesSub,d_sales_sub)->
			case sales_cid(Cid,DSalesSub#d_sales_sub.cid) of
				?true->
					Value=DSalesSub#d_sales_sub.value,
					case PaySum>=Value of
						?true->
							Acc2=[{IdStep,DSalesSub#d_sales_sub.times}|Acc];
						_->
							Acc2=Acc
					end,
					sales_ask_type_pay_sun3(Cid,PaySum,IdSteps,Acc2);
				_->
					sales_ask_type_pay_sun3(Cid,PaySum,IdSteps,Acc)
			end;
		_->
			sales_ask_type_pay_sun3(Cid,PaySum,IdSteps,Acc)
	end.
	

%% 查看是否同一天
pay_sun_time(OidList)->
	{ToDate,_}=util:localtime(),
	Fun=fun([Oid,Uid,Pay,Time],Acc)->
				{Date,_}=util:seconds2localtime(Time),
				case Date=:=ToDate of
					?true->
						[[Oid,Uid,Pay,Time]|Acc];
					_->
						Acc
				end;
		   ([_Uid,_Id,_Type,_Arg,TypeStep,Times,_Count],Acc)->
				{Date,_}=util:seconds2localtime(Times),
				case Date=:=ToDate of
					?true->
						[TypeStep|Acc];
					_->
						Acc
				end;
		   (_,Acc)->Acc
		end,
	lists:foldl(Fun,[],OidList).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 活动VIP ?CONST_SALES_ID_VIP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_vip(Sid,Uid,Vip,Tid,Type,IdSteps)->
%% 	Fun=fun(IdStep,Acc)->
%% 				case data_sales_sub:get(IdStep) of
%% 					DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 						Value=DSalesSub#d_sales_sub.value,
%% 						case Vip>=Value of
%% 							?true->
%% 								[IdStep|Acc];
%% 							_->
%% 								Acc
%% 						end;
%% 					_->Acc
%% 				end
%% 		end,
%% 	IdSteps2=lists:foldl(Fun,[],IdSteps),
%% 	case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
%% 							  " AND `type` = " ++ util:to_list(Type)) of
%% 		{?ok,[]}->
%% 			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
%% 			{IdSteps2,SIdSteps2};
%% 		{?ok,PaySunDate}->
%% 			PaySun2=[TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate],
%% 			IdStep2=?IF(PaySun2==[],[],lists:max(PaySun2)),
%% 			IdSteps3=[PIdStep||PIdStep<-IdSteps2,PIdStep>IdStep2],
%% 			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps3],
%% 			{IdSteps3,SIdSteps2};
%% 		_->
%% 			{[],[]}
%% 	end.
%% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 活动 登录 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_login(Sid,Uid,Tid,Type,IdSteps)->
%% 	case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
%% 							  " AND `type` = " ++ util:to_list(Type)) of
%% 		{?ok,[]}->
%% 			IdSteps2=[lists:min(IdSteps)],
%% 			SIdSteps2=[{Uid,Tid,Type,0,lists:min(IdSteps),1}],
%% 			{IdSteps2,SIdSteps2};
%% 		{?ok,PaySunDate}->
%% 			PaySun2=[{TypeStep,Times}||[_Uid,_Id,_Type,_Arg,TypeStep,Times,_Count]<-PaySunDate],
%% 			{TypeStep2,Times2}=?IF(PaySun2==[],lists:min(IdSteps),lists:max(PaySun2)),
%% 			Times3=util:seconds(),
%% 			case util:is_same_date(Times2,Times3) of
%% 				?true->
%% 					{[],[]};
%% 				_->
%% 					IdSteps2=[PIdStep||PIdStep<-IdSteps,PIdStep=:=TypeStep2+1],
%% 					SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
%% 					{IdSteps2,SIdSteps2}
%% 			end;
%% 		_->
%% 			{[],[]}
%% 	end.
%% 
%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%节日登录奖励 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_login_f(Sid,Uid,Tid,Type,IdSteps,StarrTime,_EndTime)->
%% 	{{Y,M,D},_}=util:localtime(),
%% 	IdStepsTuple=list_to_tuple(lists:sort(IdSteps)),
%% 	Ttime=util:datetime2timestamp(Y,M,D,0,0,0),
%% 	N=round((Ttime-StarrTime)/(3600*24)+1),
%% 	case size(IdStepsTuple)>= N of
%% 		?true->
%% 			IdStep=element(N,IdStepsTuple),
%% 			case data_sales_sub:get(IdStep) of
%% 				DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 					case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
%% 							  " AND `type_step` = " ++ util:to_list(IdStep)) of 
%% 						{?ok,[]}->
%% 							SIdSteps2=[{Uid,Tid,Type,0,IdStep,1}],
%% 							{[IdStep],SIdSteps2};
%% 						_->{[],[]}
%% 					end;
%% 				_->
%% 					{[],[]}
%% 			end;
%% 		_->{[],[]}
%% 	end.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 活动召唤伙伴 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_partner(Sid,Uid,Partners,Tid,Type,IdSteps)->
%% 	Fun=fun(IdStep,Acc)->
%% 				case data_sales_sub:get(IdStep) of
%% 					DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 						{ParId,Count}=DSalesSub#d_sales_sub.value,
%% 						case inn_api:check_partner(Partners,ParId,Count) of
%% 							?true->
%% 								[IdStep|Acc];
%% 							_->
%% 								Acc
%% 						end;
%% 					_->Acc
%% 				end
%% 		end,
%% 	IdSteps2=lists:foldl(Fun,[],IdSteps),
%% 	case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
%% 							  " AND `type` = " ++ util:to_list(Type)) of 
%% 		{?ok,[]}->
%% 			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
%% 			{IdSteps2,SIdSteps2};
%% 		{?ok,PaySunDate}->
%% 			PaySun2=[TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate],
%% 			sales_ask_type_tongyong(Uid,Tid,Type,0,IdSteps2,PaySun2,[],[]);
%% 		_->{[],[]}
%% 	end.
%% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 活动坐骑 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_feed_mount(Sid,Uid,Mount,Tid,Type,IdSteps)->
%% 	Fun=fun(IdStep,Acc)->
%% 				case data_sales_sub:get(IdStep) of
%% 					DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 						[ReId,ReLv]=DSalesSub#d_sales_sub.value,
%% 						case mount_api:check_mount(Mount,ReId,ReLv) of
%% 							?true->
%% 								[IdStep|Acc];
%% 							_->
%% 								Acc
%% 						end;
%% 					_->Acc
%% 				end
%% 		end,
%% 	IdSteps2=lists:foldl(Fun,[],IdSteps),
%% 	case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
%% 							  " AND `type` = " ++ util:to_list(Type)) of 
%% 		{?ok,[]}->
%% 			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
%% 			{IdSteps2,SIdSteps2};
%% 		{?ok,PaySunDate}->
%% 			PaySun2=[TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate],
%% 			IdStep2=?IF(PaySun2==[],[],lists:max(PaySun2)),
%% 			IdSteps3=[PIdStep||PIdStep<-IdSteps2,PIdStep>IdStep2],
%% 			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps3],
%% 			{IdSteps3,SIdSteps2};
%% 		_->{[],[]}
%% 	end.	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 活动 首充 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sales_ask_type_first(Uid,_Cid,Tid,Type,IdSteps)->
	case mysql_api:select("SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++
							  " and `type` = " ++ util:to_list(Type)) of
		{?ok,[]}->
			case mysql_api:select("SELECT `oid`,`uid`,`pay`,`time` FROM `logs_pay` WHERE `uid` =" ++ util:to_list(Uid)) of
				{?ok,[]}->{[],[]};
				{?ok,[[_Oid,_Uid,_Pay,_Time]|_]}->
					SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps],
					{IdSteps,SIdSteps2};
				_->
					{[],[]}
			end;
		_->{[],[]}
	end.

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 收集套装活动 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_suit_equip(Sid,Uid,EQs,Tid,Type,IdSteps)->
%% 		Fun=fun(IdStep,Acc)->
%% 				case data_sales_sub:get(IdStep) of
%% 					DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 						case sales_ask_type_suit_equip2(DSalesSub#d_sales_sub.value,EQs) of
%% 							?true->[IdStep|Acc];
%% 							_->Acc
%% 						end;
%% 					_->Acc
%% 				end
%% 		end,
%% 	IdSteps2=lists:foldl(Fun,[],IdSteps),
%% 	case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count`  FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
%% 							  " AND `type` = " ++ util:to_list(Type)) of 
%% 		{?ok,[]}->
%% 			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
%% 			{IdSteps2,SIdSteps2};
%% 		{?ok,PaySunDate}->
%% 			PaySun2=[TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate],
%% 			sales_ask_type_tongyong(Uid,Tid,Type,0,IdSteps2,PaySun2,[],[]);
%% 		_->{[],[]}
%% 	end.	
%% 
%% sales_ask_type_suit_equip2([],_EQs)->?null;
%% sales_ask_type_suit_equip2([TEQ|TEQs],EQs)->
%% 	case sales_ask_type_suit_equip3(TEQ,EQs) of
%% 		?true->?true;
%% 		_->sales_ask_type_suit_equip2(TEQs,EQs)
%% 	end.
%% 
%% sales_ask_type_suit_equip3([],_)->?true;
%% sales_ask_type_suit_equip3([EQ|TEQ],EQs)->
%% 	case sales_ask_type_suit_equip4(EQ,EQs) of
%% 		?true->
%% 			sales_ask_type_suit_equip3(TEQ,EQs);
%% 		_->?false
%% 	end.
%% 
%% sales_ask_type_suit_equip4(_,[])->?false;
%% sales_ask_type_suit_equip4(EQ,[PEQ|EQs])->
%% 	case EQ==PEQ of
%% 		?true->?true;
%% 		_->sales_ask_type_suit_equip4(EQ,EQs)
%% 	end.
%% 			
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 玩家冲级活动 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sales_ask_type_level(Uid,Cid,Tid,Type,Lv,IdSteps)->
	Fun=fun(IdStep,Acc)->
				case data_sales_sub:get(IdStep) of
					DSalesSub when is_record(DSalesSub,d_sales_sub)->
						case sales_cid(Cid,DSalesSub#d_sales_sub.cid) of
							?true->
								case Lv>=DSalesSub#d_sales_sub.value of
									?true->
										[IdStep|Acc];
									_->
										Acc
								end;
							_->
								Acc
						end;
					_->Acc
				end
		end,
	IdSteps2=lists:foldl(Fun,[],IdSteps),
	case mysql_api:select("SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
							  " AND `type` = " ++ util:to_list(Type)) of 
		{?ok,[]}->
			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
			{IdSteps2,SIdSteps2};
		{?ok,PaySunDate}->
			PaySun2=[TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate],
			sales_ask_type_tongyong(Uid,Tid,Type,0,IdSteps2,PaySun2,[],[]);
		_->{[],[]}
	end.	

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 斗气活动 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sales_ask_type_adg(Uid,Cid,Tid,Type,IdSteps)->
	IdStepsValue=sales_ask_type_value(Cid, IdSteps),
	ValueS=[Value||{_IdStep,Value}<-IdStepsValue],
	UValueS=case Tid of
				?CONST_SALES_KILL_ALMA->
					hero_api:check_pass(ValueS);
				?CONST_SALES_KILL_DEVILS->
					fiend_api:check_pass(ValueS);
				?CONST_SALES_FIGHT_GAS->
					douqi_api:is_have(ValueS);
				_->[]
			end,
	case UValueS of
		[]->
			{[],[]};
		UDouqi->
			IdSteps2=[IdStep||{IdStep,Value2}<-IdStepsValue,lists:member(Value2,UDouqi)],
			case mysql_api:select("SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
							  " AND `type` = " ++ util:to_list(Type)) of 
				{?ok,[]}->
					SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
					{IdSteps2,SIdSteps2};
				{?ok,PaySunDate}->
					PaySun2=[TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate],
					sales_ask_type_tongyong(Uid,Tid,Type,0,IdSteps2,PaySun2,[],[]);
				_->
					{[],[]}
			end
	end.
			
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 珍宝收集活动 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sales_ask_type_treasures(Uid,Cid,Tid,Type,IdSteps)->
	Fun=fun(IdStep,Acc)->
				case data_sales_sub:get(IdStep) of
					DSalesSub when is_record(DSalesSub,d_sales_sub)->
						case sales_cid(Cid,DSalesSub#d_sales_sub.cid) of
							?true->
								case treasure_api:check_goods_in(DSalesSub#d_sales_sub.value) of
									?true->
										[IdStep|Acc];
									_->
										Acc
								end;
							_->
								Acc
						end;
					_->Acc
				end
		end,
	IdSteps2=lists:foldl(Fun,[],IdSteps),
	case mysql_api:select("SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
							  " AND `type` = " ++ util:to_list(Type)) of 
		{?ok,[]}->
			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
			{IdSteps2,SIdSteps2};
		{?ok,PaySunDate}->
			PaySun2=[TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate],
			sales_ask_type_tongyong(Uid,Tid,Type,0,IdSteps2,PaySun2,[],[]);
		_->{[],[]}
	end.	
	
%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 精英副本活动 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_alma(Uid,Cid,Tid,Type,IdSteps)->
	
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 三界杀首杀活动 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_circle_first(Sid,Uid,Tid,Type,IdSteps)->
%% 	CircleData=ets:tab2list(?ETS_CIRCLE),
%% 	Circles=sales_ask_type_circle(CircleData,Uid,[]),
%% 	IdSteps2=sales_ask_type_circle2(Circles,IdSteps,[]),
%% 	case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `id` =" ++ util:to_list(Tid) ++ 
%% 							  " AND `type` = " ++ util:to_list(Type)) of
%% 		{?ok,[]}->
%% 			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
%% 			{IdSteps2,SIdSteps2};
%% 		{?ok,PaySunDate}->
%% 			PaySun2=[TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate],
%% 			sales_ask_type_tongyong(Uid,Tid,Type,0,IdSteps2,PaySun2,[],[]);
%% 		_->{[],[]}
%% 	end.
%% 			
%% sales_ask_type_circle([],_,Acc)->Acc;
%% sales_ask_type_circle([{CircleId,[_,_,_,_,_,CUid,_,_,_]}|CircleData],Uid,Acc)->
%% 	case CUid=:=Uid of
%% 		?true->
%% 			Acc2=[CircleId|Acc],
%% 			sales_ask_type_circle(CircleData,Uid,Acc2);
%% 		_->
%% 			sales_ask_type_circle(CircleData,Uid,Acc)
%% 	end.
%% 
%% sales_ask_type_circle2([],_,Acc)->Acc;
%% sales_ask_type_circle2([CircleId|Circles],IdSteps,Acc)->
%% 	case sales_ask_type_circle3(CircleId,IdSteps) of
%% 		?null->
%% 			sales_ask_type_circle2(Circles,IdSteps,Acc);
%% 		IdStep->
%% 			sales_ask_type_circle2(Circles,IdSteps,[IdStep|Acc])
%% 	end.
%% 
%% sales_ask_type_circle3(_,[])->?null;
%% sales_ask_type_circle3(CircleId,[IdStep|IdSteps])->
%% 	case data_sales_sub:get(IdStep) of
%% 		DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 			case CircleId==DSalesSub#d_sales_sub.value of
%% 				?true->IdStep;
%% 				_->sales_ask_type_circle3(CircleId,IdSteps)
%% 			end
%% 	end.
%% 		
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 精英副本通关 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_jy_copy(Sid,Uid,Tid,Type,IdSteps)->
%% 	Mapids=copy_api:get_all_jy_pass(Sid,Uid),
%% 	Fun=fun(IdStep,Acc)->
%% 				case data_sales_sub:get(IdStep) of
%% 					DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 						case sales_ask_type_jy_copy2(Mapids,DSalesSub#d_sales_sub.value) of
%% 							?true->[IdStep|Acc];
%% 							_->Acc
%% 						end;
%% 					_->Acc
%% 				end
%% 		end,
%% 	IdSteps2=lists:foldl(Fun,[],IdSteps),
%% 	case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count`  FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
%% 							  " AND `type` = " ++ util:to_list(Type)) of
%% 		{?ok,[]}->
%% 			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
%% 			{IdSteps2,SIdSteps2};
%% 		{?ok,PaySunDate}->
%% 			PaySun2=[TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate],
%% 			sales_ask_type_tongyong(Uid,Tid,Type,0,IdSteps2,PaySun2,[],[]);
%% 		_->{[],[]}
%% 	end.
%% 
%% sales_ask_type_jy_copy2([],_)->?null;
%% sales_ask_type_jy_copy2([Mapid|Mapids],PMapid)->
%% 	case Mapid==PMapid of
%% 		?true->?true;
%% 		_->sales_ask_type_jy_copy2(Mapids,PMapid)
%% 	end.
%% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 帮派等级活动 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_clan_level(Sid,Uid,Clan,Tid,Type,IdSteps)->
%% 	ClanLv=clan_api:get_clan_lv(Clan),
%% 	Fun=fun(IdStep,Acc)->
%% 				case data_sales_sub:get(IdStep) of
%% 					DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 						case ClanLv>=DSalesSub#d_sales_sub.value of
%% 							?true->
%% 								[IdStep|Acc];
%% 							_->
%% 								Acc
%% 						end;
%% 					_->Acc
%% 				end
%% 		end,
%% 	IdSteps2=lists:foldl(Fun,[],IdSteps),
%% 	case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `id` =" ++ util:to_list(Tid) ++ 
%% 							  " AND `type` = " ++ util:to_list(Type) ++ " AND `arg` = " ++ util:to_list(Clan)) of
%% 		{?ok,PaySunDate}->
%% 			case length(PaySunDate) >= 30 of 
%% 				?true->{[],[]};
%% 				_->
%% 					case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
%% 											  " AND `type` = " ++ util:to_list(Type)) of 
%% 						{?ok,[]}->
%% 							SIdSteps2=[{Uid,Tid,Type,Clan,FIdStep,1}||FIdStep<-IdSteps2],
%% 							{IdSteps2,SIdSteps2};
%% 						{?ok,PaySunDate}->
%% 							PaySun2=[TypeStep||[_Uid,_Id,_Type,_Arg,TypeStep,_Times,_Count]<-PaySunDate],
%% 							sales_ask_type_tongyong(Uid,Tid,Type,Clan,IdSteps2,PaySun2,[],[]); 
%% 						_->{[],[]}
%% 					end
%% 			end;
%% 		_->{[],[]}
%% 	end.
%% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 竞技场排名活动 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sales_ask_type_arena(Uid,Cid,Tid,Type,IdSteps)->
	case sales_ask_type_arena_use(Cid,Uid,IdSteps) of
		[]->{[],[]};
		{Rank,IdSteps2}->
			SIdSteps2=[{Uid,Tid,Type,Rank,FIdStep,1}||FIdStep<-IdSteps2],
			{IdSteps2,SIdSteps2}
	end.

sales_ask_type_arena_use(Cid,Uid,IdSteps)->
	case mysql_api:select("SELECT `rank` FROM `sales_arena` WHERE `uid` =" ++ util:to_list(Uid)) of 
		{?ok,[]}->[];
		{?ok,[Ranks|_]}->
			[Rank|_]=Ranks,
			Fun=fun(IdStep,Acc)->
						case data_sales_sub:get(IdStep) of
							DSalesSub when is_record(DSalesSub,d_sales_sub)->
								case sales_cid(Cid,DSalesSub#d_sales_sub.cid) of
									?true->
										{MinRank,MaxRank}=DSalesSub#d_sales_sub.value,
										if
											Rank>=MinRank andalso Rank=<MaxRank ->
												[IdStep|Acc];
											?true->
												Acc
										end;
									_->
										Acc
								end;
							_->Acc
						end
				end,
			IdSteps2=lists:foldl(Fun,[],IdSteps),
			{Rank,IdSteps2}
	end.
%% 			
%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%仙侣奇缘活动%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_taskrand_f(_Sid,_Uid,_Tid,_Type,[],_)->{[],[]};
%% sales_ask_type_taskrand_f(Sid,Uid,Tid,Type,[IdStep|_],TaskRand)->
%% 	case task_api:is_rand_complete(TaskRand) of 
%% 		?true->
%% 			case data_sales_sub:get(IdStep) of
%% 				DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 					case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `id` =" ++ util:to_list(Tid) ++ 
%% 											  " AND `type_step` = " ++ util:to_list(IdStep) ++ 
%% 											  " AND `uid` = " ++ util:to_list(Uid)) of 
%% 						{?ok,[]}->
%% 							SIdSteps2=[{Uid,Tid,Type,0,IdStep,1}],
%% 							{[IdStep],SIdSteps2};
%% 						{?ok,PaySunDate}->
%% 							{Date,_}=util:localtime(),
%% 							case sales_ask_type_taskrand_f2(PaySunDate,Date) of
%% 								?true-> 
%% 									SIdSteps2=[{Uid,Tid,Type,0,IdStep,1}],
%% 									{[IdStep],SIdSteps2};
%% 								_->
%% 									{[],[]}
%% 							end;
%% 						_->{[],[]}
%% 					end;
%% 				_->{[],[]}
%% 			end;
%% 		_->
%% 			{[],[]}
%% 	end.
%% 
%% sales_ask_type_taskrand_f2([],_)->?true;
%% sales_ask_type_taskrand_f2([[_Uid,_Id,_Type,_Arg,_TypeStep,Times,_Count]|PaySunDate],Date)->
%% 	case util:seconds2localtime(Times) of
%% 		{Date,_}->?false;
%% 		_->sales_ask_type_taskrand_f2(PaySunDate,Date)
%% 	end.
%% 	
%% 
%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%次数活动%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_count_f(Sid,Uid,Tid,Type,IdSteps,Count)->
%% 	Fun=fun(IdStep,Acc)->
%% 				case data_sales_sub:get(IdStep) of
%% 					DSalesSub when is_record(DSalesSub,d_sales_sub)->
%% 						case Count>=DSalesSub#d_sales_sub.value of
%% 							?true->
%% 								[IdStep|Acc];
%% 							_->
%% 								Acc
%% 						end;
%% 					_->Acc
%% 				end
%% 		end,
%% 	IdSteps2=lists:foldl(Fun,[],IdSteps),
%% 	case mysql_api:select(Sid, "SELECT `uid`,`id`,`type`,`arg`,`type_step`,`times`,`count` FROM `sales_ask_use` WHERE `uid` =" ++ util:to_list(Uid) ++ 
%% 							  " AND `type` = " ++ util:to_list(Type)) of
%% 		{?ok,[]}->
%% 			SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
%% 			{IdSteps2,SIdSteps2};
%% 		{?ok,PaySunDate}->
%% 			case pay_sun_time(PaySunDate) of
%% 				[]->
%% 					SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps2],
%% 					{IdSteps2,SIdSteps2};
%% 				PaySun2->
%% 					IdStep2=lists:max(PaySun2),
%% 					IdSteps3=[PIdStep||PIdStep<-IdSteps2,PIdStep>IdStep2],
%% 					SIdSteps2=[{Uid,Tid,Type,0,FIdStep,1}||FIdStep<-IdSteps3],
%% 					{IdSteps3,SIdSteps2}
%% 			end;
%% 		_->
%% 			{[],[]}
%% 	end.
%% 
%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%龙宫寻宝次数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_dragon_f(Sid,Uid,Tid,Type,IdSteps,Dragon)->{[],[]}.
%% 
%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%坐骑培养次数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_mount_f(Sid,Uid,Tid,Type,IdSteps,Mount)->ok.
%% 
%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%招财次数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_weagod_f(Sid,Uid,Tid,Type,IdSteps,Weagod)->ok.
%% 
%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%钓鱼次数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sales_ask_type_fishing_f(Sid,Uid,Tid,Type,IdSteps,Fishing)->ok.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%通用函数 查找没领取%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sales_ask_type_tongyong(_,_,_,_,[],_,NIdSteps,NSIdSteps)->{NIdSteps,NSIdSteps};
sales_ask_type_tongyong(Uid,Tid,Type,Arg,[IdStep|IdSteps],PaySun,NIdSteps,NSIdSteps)->
	case sales_ask_type_tongyong2(IdStep,PaySun) of
		?true->
			NIdSteps2=[IdStep|NIdSteps],
			NSIdSteps2=[{Uid,Tid,Type,Arg,IdStep,1}|NSIdSteps],
			sales_ask_type_tongyong(Uid,Tid,Type,Arg,IdSteps,PaySun,NIdSteps2,NSIdSteps2);
		_->
			sales_ask_type_tongyong(Uid,Tid,Type,Arg,IdSteps,PaySun,NIdSteps,NSIdSteps)
	end.

sales_ask_type_tongyong2(_,[])->?true;
sales_ask_type_tongyong2(IdStep,[PayIdStep|PaySun])->
	case IdStep=:=PayIdStep of
		?true->?false;
		_->sales_ask_type_tongyong2(IdStep,PaySun)
	end.

sales_ask_type_value(Cid,IdSteps)->
	Fun=fun(IdStep,Acc)->
				case data_sales_sub:get(IdStep) of
					DSalesSub when is_record(DSalesSub,d_sales_sub)->
						case sales_cid(Cid,DSalesSub#d_sales_sub.cid) of
							?true->
								[{IdStep,DSalesSub#d_sales_sub.value}|Acc];
							_->
								Acc
						end;
					_->
						Acc
				end
		end,
	lists:foldl(Fun,[],IdSteps).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 请求领取奖励
sales_get(#player{socket=Socket,io=Io} = Player,Id,IdStep) ->
	Sales=role_api_dict:sales_get(),
	#sales{value=Values0,rece=Rece}=Sales,
	Rece2=?IF(Rece==?undefined,[],Rece),
	case lists:keytake(Id,1,Values0) of
		{value,{_,IdSteps},Values} -> 
			case lists:keytake(IdStep,5,IdSteps) of
				{value,IdStepdata,IdSteps2}->
%% 					case sales_get2(Player,103,[IdStepdata],<<>>,[]) of
					case sales_get2(Player,Io#io.cid,[IdStepdata],<<>>,[]) of
						{?ok,Player2,Acc,UseAcc}->
							{_Uid,_Id,_Type,_Arg,ReceIdStep,_Count}=IdStepdata,
							Sales2=Sales#sales{value=[{Id,IdSteps2}|Values],rece=[ReceIdStep|Rece2]},
							role_api_dict:sales_set(Sales2),
							case sales_notice2(Values) of
								?true->
									BinMsg=msg_notice(),
									app_msg:send(Socket,BinMsg);
								_->
									?skip
							end,
							Fun=fun({CUid,CId,CType,CArg,CIdStep,CTime,CCount})-> 
										mysql_api:insert(sales_ask_use,[{uid,CUid},{id,CId},{type,CType},{arg,CArg},{type_step,CIdStep},{times,CTime},{count,CCount}])
								end,
							lists:map(Fun,UseAcc),
							{?ok,Player2,Acc};
						{?error,Error}->
							{?error,Error}
					end;
				_->
					{?error, ?ERROR_BADARG}
			end;
		?false ->
			{?error, ?ERROR_BADARG}
	end.

sales_get2(Player,_Cid,[],Acc,UseAcc)->{?ok,Player,Acc,UseAcc};
sales_get2(Player,Cid,[{Uid,Id,Type,Arg,IdStep,Count}|IdSteps],Acc,UseAcc)->
	case data_sales_sub:get(IdStep) of
		DSalesSub when is_record(DSalesSub,d_sales_sub)->
			case sales_cid(Cid,DSalesSub#d_sales_sub.cid) of
				?true->
					Bag=role_api_dict:bag_get(),
					LogSrc=[sales_get,[],<<"精彩活动奖励">>],
					case bag_api:goods_set(LogSrc,Player,Bag,DSalesSub#d_sales_sub.virtue) of
						{?ok,Player2,Bag2,GoodBin,Bin}->
							?IF(Id==?CONST_SALES_ARENA_RANKING,mysql_api:delete(sales_arena," uid = "++ util:to_list(Uid)),?skip),
							Time=util:seconds(),
							UseAcc2=[{Uid,Id,Type,Arg,IdStep,Time,Count}|UseAcc],
							role_api_dict:bag_set(Bag2),
							sales_get2(Player2,Cid,IdSteps,<<Acc/binary,GoodBin/binary,Bin/binary>>,UseAcc2);
						{?error,Error}->
							{?error,Error}
					end;
				_->
					sales_get2(Player,Cid,IdSteps,Acc,UseAcc)
			end;
		_->
			sales_get2(Player,Cid,IdSteps,Acc,UseAcc)
	end.

% 领取成功 [24920]
msg_succeed(GoodsList)->
	Acc 		= app_msg:encode([{?int16u,length(GoodsList)}]),
    BinData 	= lists:foldl(fun(Goods, Acc0) ->
									  BinData = bag_api:msg_goods(Goods),
									  <<Acc0/binary, BinData/binary>>
							  end, Acc, GoodsList),
    app_msg:msg(?P_CARD_SUCCEED, BinData). 


% 促销活动状态返回 [24932]
msg_sales_data(StartListData)->
	Count=length(StartListData),
    Rs= app_msg:encode([{?int16u,Count}]),
	Fun=fun({Id,StartTime,EndTime,IdSteps},Acc)->
				Acc2=msg_id_date(Id,StartTime,EndTime,IdSteps),
				<<Acc/binary,Acc2/binary>>
		end,
	RsList=lists:foldl(Fun,Rs,StartListData),
    app_msg:msg(?P_CARD_SALES_DATA, RsList).

% 以领取的活动Id [24970]
msg_rece(Rece)->
	Acc=app_msg:encode([{?int16u,length(Rece)}]),
	Fun=fun(Idstep,Acc0) when is_integer(Idstep)->
				Rs=app_msg:encode([{?int16u,Idstep}]),	
				<<Acc0/binary,Rs/binary>>;
		   (_,Acc0)->
				Acc0
		end,
	RsList=lists:foldl(Fun,Acc,Rece),
	app_msg:msg(?P_CARD_RECE, RsList).
	

% 促销活动信息 [24933]
msg_id_date(Id,StartTime,ExitTime,IdSteps)->
	Fun=fun(IdStep,Acc)->
				[IdStep|[PIdStep||PIdStep<-Acc,PIdStep=/=IdStep]]
		end,
	IdSteps2=lists:foldl(Fun,[],IdSteps),
	Count=length(IdSteps2),
    Rs=app_msg:encode([{?int16u,Id},{?int32u,StartTime},
							 {?int32u,ExitTime},{?int16u,Count}]),
	Fun2=fun(IdStep2,Acc2)->
				Acc3=app_msg:encode([{?int16u,IdStep2}]),
				<<Acc2/binary,Acc3/binary>>
		 end,
	lists:foldl(Fun2,Rs,IdSteps2). 


% 领取成功 [24950]
msg_get_ok()->
    app_msg:msg(?P_CARD_GET_OK,<<>>).


% 领取通知 [24960]
msg_notice()->
    app_msg:msg(?P_CARD_NOTICE,<<>>).
