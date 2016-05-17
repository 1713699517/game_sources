%% Author  : tanwer
%% Created: 2013-7-30
%% Description: TODO: Add description to douqi_api
-module(douqi_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


%%
%% Exported Functions
%%


-export([
		 encode_douqi/1,
		 decode_douqi/1,
		 init_douqi/1,
		 init/0,
		 
		 login/1,
		 
		 douqi_add/1,
		 is_have/1,
		 
		 %------------------------------------测试
		 start_fun/2,
		 start_fun_cb/2,
		 douqi_add/2,
		 douqi_add_cb/2,
		 %------------------------------------测试

		 fun_limit/0,
		 adam_war_add/2,
		 adam_war_cut/2,
		 clear_storage/1,
		 insert_new_gas/3,
		 get_lan_all/1,		 
		 get_dqlan_num/1,
		 
		 
		 ask_grasp_douqi/1,
		 ask_equip_douqi/1,
		 ask_start_grasp/2,
		 eat_storage/2,
		 ask_pickup/1,
		 ask_split/3,
		 ask_use_douqi/5,
		 
		 
		 msg_ok_douqi_role/2,
		 msg_ok_dq_split/3,
		 msg_ok_get_dq/1,
		 msg_ok_grasp_data/4,
		 msg_ok_use_douqi/5,
		 msg_role_data/2,
		 msg_storage_data/2,
		 msg_eat_state/1
		
		]).


encode_douqi(DouQi) -> DouQi.
decode_douqi(DouQi) ->
	?IF(is_record(DouQi,douqi),DouQi,init()).

init_douqi(Player) ->
	DouQi=
		case role_api_dict:douqi_get() of
			DQ when is_record(DQ, douqi) ->
				?IF(DQ#douqi.date=:=util:date(), 
					DQ, 
					DQ#douqi{date=util:date(),rmb_times=0,gold_times=0});
			_ ->
				init()
		end,
	{Player, DouQi}. 


init() ->
	#douqi{date=util:seconds(),grasp_lv=?CONST_DOUQI_MIN_GRASP_LV,start_limit=?CONST_TRUE,is_first=1}.

login(Player) ->
	#douqi{sto_equip=StoEquip} = check_douqi(),
	RoleList =[0|inn_api:inn_use_list()],
	Fun = fun(RoleId, Acc) ->
				  UseDqList = get_lan_one(RoleId, StoEquip),
				  NewAttrList = get_attr_dq(UseDqList),
				  DouqiAttr = role_api:attr_one_add(#attr{}, NewAttrList),
				  case RoleId of
					  0 -> %% 主角装备
						  role_api:attr_update_player(Acc, douqi, DouqiAttr);
					  _ -> %% 伙伴装备
						  Inn=role_api_dict:inn_get(),
						  #inn{partners=Partners}=Inn,
						  case lists:keytake(RoleId, #partner.partner_id, Partners) of
							  {value, Partner, TupleList2} ->
								  Partner2=inn_api:attr_update_partner(Acc#player.socket, Partner, douqi, DouqiAttr),
								  role_api_dict:inn_set(Inn#inn{partners=[Partner2|TupleList2]}),
								  Acc;
							  _ ->
								  Acc
						  end
				  end
		  end,
	lists:foldl(Fun, Player, RoleList).


%%　功能开启
%%　return: ?ok
start_fun(Uid, State) ->
	case role_api:is_online(Uid) of
		?true ->
			util:pid_send(Uid, ?MODULE, start_fun_cb, State);
		_ ->
			?false
	end.
start_fun_cb(Player, State) ->	
	DouQi=role_api_dict:douqi_get(),
	role_api_dict:douqi_set(DouQi#douqi{start_limit = State}),
	Player.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Api
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
fun_limit() ->
	DouQi=role_api_dict:douqi_get(),
	role_api_dict:douqi_set(DouQi#douqi{start_limit=1}).


%% 增加斗魂接口
adam_war_add(VipLv,Value) ->
	DouQi=role_api_dict:douqi_get(),
	#douqi{adam_war=AdamWar,grasp_lv=GraspLv}=DouQi,
	AdamWar2=AdamWar + abs(Value),
	{RmbTimes,AllTimes}=douqi_api:grasp_rmb_times(VipLv),
	role_api_dict:douqi_set(DouQi#douqi{adam_war=AdamWar2,rmb_times=RmbTimes}),
	BinMsg=douqi_api:msg_ok_grasp_data(GraspLv, RmbTimes, AllTimes, AdamWar2),
	{?ok,BinMsg}.

%% 扣减斗魂接口	
adam_war_cut(VipLv,Value) ->
	DouQi=role_api_dict:douqi_get(),
	#douqi{adam_war=AdamWar,grasp_lv=GraspLv}=DouQi,
	case AdamWar - Value of
		AdamWar2 when AdamWar2>=0 ->
			{RmbTimes,AllTimes}=douqi_api:grasp_rmb_times(VipLv),
			role_api_dict:douqi_set(DouQi#douqi{adam_war=AdamWar2,rmb_times=RmbTimes}),
			BinMsg=douqi_api:msg_ok_grasp_data(GraspLv, RmbTimes, AllTimes, AdamWar2),
			{?ok,BinMsg};
		_ ->
			{?error,?ERROR_DOUQI_ADAM_WAR_LOW}
	end.

%%　后台增加斗气
douqi_add(Uid,Dqlist) ->
	util:pid_send(Uid, ?MODULE, douqi_add_cb, Dqlist).
douqi_add_cb(Player, Dqlist) ->
	case douqi_add(Dqlist) of
		?ok ->
			?ok;
		{?error, ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, BinMsg)
	end,
	Player.

%% 增加斗气接口
%% ?ok|| {?error, ErrorCode}
douqi_add(Dqlist) when is_list(Dqlist) ->
	NewSum = lists:sum([C|| {_ID,_LV,C} <- Dqlist]),
	DouQi = role_api_dict:douqi_get(),
	#douqi{sto_equip=StoEquip0} = DouQi,
	case ?CONST_DOUQI_BAG - length([Equ||Equ <- StoEquip0,Equ#dq_data.lan_id >=?CONST_DOUQI_BAG_START ]) of
		N when N < NewSum ->
			{?error,?ERROR_DOUQI_STORAGE_FULL};
		_ ->
			Fun = fun({_DqId, _Lv, 0}, Acc0) ->
						  Acc0;
					 ({DqId, Lv, Count}, Acc0) ->
						  case data_fight_gas_total:get({DqId,Lv}) of
							  #d_fight_gas_total{next_lv_exp=NextExp,color=Color,type=Type} ->
								  NewGas=#dq_data{dq_exp=NextExp-1,dq_id=idx_api:douqi_id(),dq_lv=Lv,dq_type=DqId,
												  equip_type=Type,dq_color=Color},
								  lists:foldl(fun(_, AccCount) -> 
													  douqi_api:insert_new_gas(AccCount, NewGas, ?CONST_DOUQI_BAG_START)
											  end, Acc0, lists:seq(1, Count));
							  _ ->
								  Acc0
						  end;
					 (Err, Acc0)-> 
						  ?MSG_ERROR("error_bag_data_come Dqlist: ~w~n",[Err]),
						  Acc0
				  end,
			StoEquip = lists:foldl(Fun, StoEquip0, Dqlist),
			role_api_dict:douqi_set(DouQi#douqi{sto_equip=StoEquip}),
			?ok
	end;
douqi_add({_DqId, _Lv, 0}) ->
	?ok;
douqi_add({DqId,Lv,Count}) ->
	douqi_add([{DqId,Lv,Count}]);
douqi_add(_Dqlist) ->
	{?error,?ERROR_BADARG}.


%% 检查是否有指定的斗气
%%　rag : [DqId,...] || DqId
%% retrun : [DqId,...] || []
is_have(DqList) when is_list(DqList) ->
	#douqi{sto_equip=StoEquip,sto_temp=StoTemp} = role_api_dict:douqi_get(),
	AllDouQiList = lists:append(StoEquip, StoTemp),
	F = fun(Id,Acc) ->
				case lists:keyfind(Id, #dq_data.dq_type, AllDouQiList) of
					#dq_data{dq_type=Id} ->
						[Id|Acc];
					_ ->
						Acc
				end
		end,
	lists:foldl(F, [], DqList);
is_have(DqId) when is_integer(DqId) -> 
	is_have([DqId]);
is_have(DqId) -> 
	?MSG_ERROR("error_arg is_have(DqId) : DqId = ~w~n",[DqId]), 
	[].
	


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %% local_fun
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 请求领悟斗气界面 
%%　{?error,ErrorCode} | {?ok,BinMSg}
ask_grasp_douqi(VipLv) ->
	DouQi=check_douqi(),
	#douqi{adam_war=AdamWar,grasp_lv=GraspLv,rmb_times=RmbTimes,start_limit=StartLimit,sto_temp=StoTemp}=DouQi,
	case StartLimit of
		?CONST_TRUE ->
			AllTimes=vip_api:check_fun(VipLv, #d_vip.douqi_times),
			BinMsg1=msg_ok_grasp_data(GraspLv,RmbTimes,AllTimes,AdamWar),
			BinMsg2=msg_storage_data(?CONST_DOUQI_STORAGE_TYPE_TEMP, StoTemp),
			{?ok, <<BinMsg1/binary,BinMsg2/binary>>};
		?CONST_FALSE -> 
			{?error,?ERROR_DOUQI_NOT_START}
	end.

%% 请求装备斗气界面
%%　{?error,ErrorCode} | {?ok,BinMSg}
ask_equip_douqi(Lv) ->
	DouQi=check_douqi(),
	#douqi{start_limit=StartLimit,sto_equip=StoEquip}=DouQi,
	case StartLimit of
		?CONST_TRUE ->
			RoleMsg = get_lan_all(StoEquip),
			LanCount = get_dqlan_num(Lv),
			StoEquip2 = [Dq|| Dq <- StoEquip,Dq#dq_data.lan_id > ?CONST_DOUQI_LAN_END],
			BinMsg1 = msg_ok_douqi_role(LanCount, RoleMsg),
			BinMsg2 = msg_storage_data(?CONST_DOUQI_STORAGE_TYPE_EQUIP, StoEquip2),
			{ok, <<BinMsg1/binary,BinMsg2/binary>>};
		?CONST_FALSE ->
			{?error,?ERROR_DOUQI_NOT_START}
	end.

%%　请求开始领悟	
%%　{?error,ErrorCode} | {?ok,Player2}
ask_start_grasp(#player{vip=Vip}=Player,Type) ->
	DouQi=role_api_dict:douqi_get(),
	#douqi{start_limit=Limit,sto_temp=StoTemp}=DouQi, 
	if Limit =:= ?CONST_TRUE ->
		   case ?CONST_DOUQI_STORAGE_NUM - length(StoTemp) of
			   N when N>0 ->
				   case Type of
					   ?CONST_DOUQI_GRASP_TYPE_RMB -> %% 钻石领悟
						   case Vip#vip.lv >= ?CONST_DOUQI_VIP_LIMIT of
							   ?true ->
								   rmb_grasp(Player,DouQi);
							   _ ->
								   {?error,?ERROR_VIP_LV_LACK}
						   end;
					   ?CONST_DOUQI_GRASP_TYPE_MORE -> %%　美金一键领悟
						   case Vip#vip.lv >= ?CONST_DOUQI_ONEKEY_VIP of
							   ?true ->
								   gold_grasp(Player, DouQi, N);
							   _ ->
								   {?error,?ERROR_DOUQI_VIP_LIMIT}
						   end;
					   _ -> %%　美金领悟
						   gold_grasp(Player,DouQi)
				   end;
			   _ ->
				   {?error,?ERROR_DOUQI_STORAGE_FULL}
		   end;
	   ?true ->
		   {?error,?ERROR_DOUQI_NOT_START}
	end.

%% 请求一键吞噬
%%　{?error,ErrorCode} | {?ok,BinMSg}
eat_storage(Uid,?CONST_DOUQI_STORAGE_TYPE_EQUIP) -> 
	DouQi=role_api_dict:douqi_get(),
	#douqi{sto_equip=StoEquip}=DouQi,
	Fun=fun(DQ,{Acc0,OAcc0}) -> 
				#dq_data{lan_id=LanId,is_lock=IsLock}=DQ,
				if IsLock =:= 1 ->
					   {Acc0,[DQ|OAcc0]};
				   LanId =< ?CONST_DOUQI_LAN_END ->
					   {Acc0,[DQ|OAcc0]};
				   ?true ->
					   {[DQ|Acc0],OAcc0}
				end
		end, 
	{StoEquip2,Other}=lists:foldl(Fun, {[],[]}, StoEquip),
	{EatDqList,OtherDqList,MaxDq} = group_storage(StoEquip2),
	case EatDqList of
		[] ->
			{?error,?ERROR_DOUQI_NO_EAT_DOUQI};
		_ ->
			{StoEquip3,Bin}=eat_storage(OtherDqList,EatDqList,MaxDq),
			lists:map(fun(#dq_data{dq_id=LdqId,dq_type=LdqType,dq_color=Color}) 
						   when Color >= ?CONST_COLOR_VIOLET -> 
							  case lists:keyfind(LdqId, #dq_data.dq_id, StoEquip3) of
								  #dq_data{} -> ?ok;
								  _ -> stat_api:logs_douqi(Uid, LdqId, LdqType, ?CONST_FALSE)
							  end;
						 (_) -> ?ok 
					  end, StoEquip2),
			NewStoEquip=util:lists_merge(StoEquip3, Other),
			role_api_dict:douqi_set(DouQi#douqi{sto_equip=NewStoEquip}),
			BinMsg=msg_storage_data(?CONST_DOUQI_STORAGE_TYPE_EQUIP, StoEquip3),
			{?ok, <<BinMsg/binary,Bin/binary>>}
	end;
eat_storage(Uid, ?CONST_DOUQI_STORAGE_TYPE_TEMP) ->
	DouQi=role_api_dict:douqi_get(),
	#douqi{sto_temp=StoTemp}=DouQi,
	{EatDqList,OtherDqList,MaxDq} = group_storage(StoTemp),
	case EatDqList of
		[] ->
			{?error,?ERROR_DOUQI_NO_EAT_DOUQI};
		_ ->
			{StoTemp2,Bin}=eat_storage(OtherDqList,EatDqList,MaxDq),
			lists:map(fun(#dq_data{dq_id=LdqId,dq_type=LdqType}) 
						   when LdqType>= ?CONST_COLOR_VIOLET -> 
							  case lists:keyfind(LdqId, #dq_data.dq_id, StoTemp2) of
								  #dq_data{} -> ?ok;
								  _ -> stat_api:logs_douqi(Uid, LdqId, LdqType, ?CONST_FALSE)
							  end;
						 (_) -> ?ok 
					  end, StoTemp),
			role_api_dict:douqi_set(DouQi#douqi{sto_temp=StoTemp2}),
			BinMsg=msg_storage_data(?CONST_DOUQI_STORAGE_TYPE_TEMP, StoTemp2),
			{?ok,<<BinMsg/binary,Bin/binary>>}
	end;
eat_storage(_,Type) -> 
	?MSG_ECHO("====TypeType===~w~n",[Type]),
	{?error,?ERROR_BADARG}.

%% 请求拾取斗气
ask_pickup(0) ->  % 一键拾取
	DouQi=role_api_dict:douqi_get(),
	#douqi{sto_temp=StoTemp,sto_equip=StoEquip}=DouQi,
	case ?CONST_DOUQI_BAG - length([Equ||Equ <- StoEquip,Equ#dq_data.lan_id >=?CONST_DOUQI_BAG_START ]) of
		N when N =< 0 ->
			{?error,?ERROR_DOUQI_STORAGE_FULL};
		N ->
			Fun = fun
%% 					 (#dq_data{dq_color = ?CONST_COLOR_WHITE},{StoAcc,GetAcc}) ->
%% 						  {StoAcc,GetAcc};  % 白色斗气不拾取
					 (Dq,{StoAcc,GetAcc}) ->
						  if length(GetAcc) >= N ->
								 {StoAcc,GetAcc};
							 ?true ->
								 StoAcc2 = insert_new_gas(StoAcc, Dq, ?CONST_DOUQI_BAG_START),
								 GetAcc2 = [Dq#dq_data.lan_id|GetAcc],
								 {StoAcc2,GetAcc2}
						  end
				  end, 
			{StoEquip2,GetLanId}=lists:foldl(Fun, {StoEquip,[]}, StoTemp),
			StoTemp2=[DQ ||DQ <-StoTemp, ?IF(lists:member(DQ#dq_data.lan_id, GetLanId)=:= ?true,?false,?true)],
			role_api_dict:douqi_set(DouQi#douqi{sto_temp=StoTemp2,sto_equip=StoEquip2}),
			BinMsg=msg_ok_get_dq(GetLanId),
			{?ok,BinMsg}
	end;
ask_pickup(LanId) ->  %% 拾取一个
	DouQi=role_api_dict:douqi_get(),
	#douqi{sto_temp=StoTemp,sto_equip=StoEquip}=DouQi,
	case ?CONST_DOUQI_BAG - length([Equ||Equ <- StoEquip,Equ#dq_data.lan_id >=?CONST_DOUQI_BAG_START ]) of
		N when N =< 0 ->
			{?error,?ERROR_DOUQI_STORAGE_FULL};
		_N ->
			case lists:keytake(LanId, #dq_data.lan_id, StoTemp) of
%% 		 		{value, #dq_data{dq_color = ?CONST_COLOR_WHITE}, _Other} ->
%% 		 			{?error,?ERROR_DOUQI_CANT_PICK};
				{value, DQ, Other} ->
					StoEquip2=insert_new_gas(StoEquip, DQ, ?CONST_DOUQI_BAG_START),
					role_api_dict:douqi_set(DouQi#douqi{sto_temp=Other,sto_equip=StoEquip2}),
					BinMsg=msg_ok_get_dq([LanId]),
					{?ok,BinMsg};
				_ ->
					{?error,?ERROR_DOUQI_NO_DOUQI}
			end
	end.

%% 请求分解斗气
ask_split(Uid, Role, LanId) ->	
	List=[{1,0},{2,0},{3,0},{4,30},{5,50},{6,60},{7,70}],
	DouQi=role_api_dict:douqi_get(),
	#douqi{sto_temp=StoTemp,sto_equip=StoEquip0,adam_war=AdamWar}=DouQi,
	StoEquip = [Dq0 || Dq0 <- StoEquip0, Dq0#dq_data.role_id==Role],
	case lists:keytake(LanId, #dq_data.lan_id, StoEquip) of
		{value, #dq_data{dq_color=DqColor,dq_type=DQType,lan_id=LanId,dq_id=DqID}=DqSplit, _Other} ->
			case DqColor >= ?CONST_DOUQI_SPLIT_COLOR of
				?true ->
					{DqColor,Rand}=lists:keyfind(DqColor, 1, List),
					GetAdams=util:rand(DqColor-?CONST_DOUQI_SPLIT_COLOR+1, Rand),
					stat_api:logs_douqi(Uid, DqID, DQType, ?CONST_FALSE),
					BinLog1 = logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_ADD, [{?CONST_CURRENCY_DOUHUN, GetAdams}]),
					BinLog2 = logs_api:event_notice(?CONST_LOGS_TYPE_DOUQI, ?CONST_LOGS_DEL, DQType, 1),
					role_api_dict:douqi_set(DouQi#douqi{sto_equip=StoEquip0--[DqSplit],adam_war=AdamWar+GetAdams}),
					BinMsg=msg_ok_dq_split(Role, LanId, GetAdams),
					{?ok,<<BinMsg/binary,BinLog2/binary,BinLog1/binary>>};
				_ ->
					{?error, ?ERROR_DOUQI_NOT_SPLIT}
			end;
		_ ->
			case lists:keytake(LanId, #dq_data.lan_id, StoTemp) of
				{value, #dq_data{dq_color=DqColor,dq_type=DQType,dq_id=DqID}, Other} ->
					case DqColor >= ?CONST_DOUQI_SPLIT_COLOR of
						?true ->
							{DqColor,Rand}=lists:keyfind(DqColor, 1, List),
							GetAdams= util:rand(DqColor-?CONST_DOUQI_SPLIT_COLOR+1, Rand) * 10,
							role_api_dict:douqi_set(DouQi#douqi{sto_temp=Other,adam_war=AdamWar+GetAdams}),
							stat_api:logs_douqi(Uid, DqID, DQType, ?CONST_FALSE),
							BinLog1 = logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_ADD, [{?CONST_CURRENCY_DOUHUN, GetAdams}]),
							BinLog2 = logs_api:event_notice(?CONST_LOGS_TYPE_DOUQI, ?CONST_LOGS_DEL, DQType, 1),
							BinMsg=msg_ok_dq_split(Role, LanId, GetAdams),
							{?ok,<<BinMsg/binary,BinLog2/binary,BinLog1/binary>>};
						_ ->
							{?error, ?ERROR_DOUQI_NOT_SPLIT}
					end;
				_ ->
					{?error,?ERROR_DOUQI_NO_DOUQI}
			end
	end.
	

%% 请求移动斗气位置
%% Type		::操作类型 0移动| 1吞噬 |2装备
%% RoleId	::伙伴ID | 0 自己，仓库，包裹
%% DqId		::斗气唯一ID
%% LanidStart	::起始位置（斗气栏编号1-8 斗气仓库编号9-29，背包编号30-56
%% LanidEnd		::目标位置（斗气栏编号1-8 斗气仓库编号9-29，背包编号30-56

%%　装备| 取下  未指定目标栏位置
ask_use_douqi(Player,RoleId,DqId,LanidEnd,StoEquip) when LanidEnd =:= 0 ->
	case lists:keytake(DqId, #dq_data.dq_id, StoEquip) of
		{value, #dq_data{lan_id=LanidEnd}=DqS, _StoEquip2} -> {?ok,Player,DqS};
		{value, #dq_data{lan_id=LanidS}=DqS, StoEquip2} ->
			case LanidS >= ?CONST_DOUQI_BAG_START of
				?true ->
					EquipLan=[DQ0||DQ0 <- StoEquip,DQ0#dq_data.lan_id < ?CONST_DOUQI_BAG_START],
					LanEnd=lists:foldl(fun(Eq,Acc) -> 
											   ?IF(Eq#dq_data.lan_id=:=Acc,Acc+1,Acc)
									   end, ?CONST_DOUQI_LAN_START, lists:keysort(#dq_data.lan_id, EquipLan)),
					equip(Player,DqS,0,RoleId,LanEnd,StoEquip2);
				_ ->
					BagLan=[DQ0||DQ0 <- StoEquip,DQ0#dq_data.lan_id >= ?CONST_DOUQI_BAG_START],
					case length(BagLan) of
						N when N >= ?CONST_DOUQI_BAG ->
							{?error,?ERROR_DOUQI_STORAGE_FULL};
						_ ->
							LanEnd=lists:foldl(fun(Eq,Acc) -> 
													   ?IF(Eq#dq_data.lan_id=:=Acc,Acc+1,Acc)
											   end, ?CONST_DOUQI_BAG_START, lists:keysort(#dq_data.lan_id, BagLan)),
							AttrCut=get_attr_dq(DqS),
							case attr_add(Player, RoleId, [], AttrCut) of
								#player{}=Player2 ->
									NewDq=DqS#dq_data{lan_id=LanEnd,role_id=0},
									{?ok,Player2,NewDq,[NewDq|StoEquip2]};
								{?error,ErrorCode} ->
									{?error,ErrorCode}
							end
					end
			end;
		_ ->
			{?error,?ERROR_DOUQI_NO_DOUQI}
	end;
%%　装备| 取下| 移动  指定目标栏位置
ask_use_douqi(Player,RoleId,DqId,LanidEnd,StoEquip) when LanidEnd =< ?CONST_DOUQI_BAG_END ->
	case lists:keytake(DqId, #dq_data.dq_id, StoEquip) of
		{value, #dq_data{lan_id=LanidEnd}=DqS, _StoEquip2} -> {?ok,Player,DqS};
		{value, #dq_data{lan_id=LanidS}=DqS, StoEquip2} ->
			case lists:keytake(LanidEnd, #dq_data.lan_id, StoEquip2) of
				{value, #dq_data{lan_id=LanidEnd}=DqE, StoEquip3} ->
					case move_a2b(Player#player.uid,DqE, DqS,LanidEnd) of
						{?error,ErrorCode} ->
							{?error,ErrorCode};
						NewDq ->
							if
								LanidEnd >= ?CONST_DOUQI_BAG_START andalso LanidS >= ?CONST_DOUQI_BAG_START ->
									{?ok,Player,NewDq,[NewDq|StoEquip3]};
								LanidEnd >= ?CONST_DOUQI_BAG_START andalso LanidS < ?CONST_DOUQI_BAG_START ->
									AttrCut=get_attr_dq(DqS),
									case attr_add(Player, RoleId, [], AttrCut) of
										#player{}=Player2 ->
											NewDq2=NewDq#dq_data{role_id=0},
											{?ok,Player2,NewDq2,[NewDq2|StoEquip3]};
										{?error,ErrorCode} ->
											{?error,ErrorCode}
									end;
								LanidEnd < ?CONST_DOUQI_BAG_START andalso LanidS >= ?CONST_DOUQI_BAG_START ->
									equip(Player,DqS,DqE,RoleId,LanidEnd,StoEquip3);
								?true ->
%% 									case attr_change_update(Player, RoleId, [NewDq|StoEquip3]) of
%% 									#player{}=Player2 ->
%% 											{?ok,Player2,NewDq,[NewDq|StoEquip3]};
%% 									{?error,ErrorCode} ->
%% 											{?error,ErrorCode}
%% 									end
									AttrCut=get_attr_dq([DqE,DqS]),
									AttrAdd=get_attr_dq(NewDq),
									case attr_add(Player, RoleId, AttrAdd, AttrCut) of
										#player{}=Player2 ->
											{?ok,Player2,NewDq,[NewDq|StoEquip3]};
										{?error,ErrorCode} ->
											{?error,ErrorCode}
									end
							end
					end;
				_ ->
					if LanidS < ?CONST_DOUQI_BAG_START andalso LanidEnd < ?CONST_DOUQI_BAG_START ->
						   NewDq=DqS#dq_data{lan_id=LanidEnd},
						   {?ok,Player, NewDq, [NewDq|StoEquip2]};
					   LanidS >= ?CONST_DOUQI_BAG_START andalso LanidEnd >= ?CONST_DOUQI_BAG_START ->
						   NewDq=DqS#dq_data{lan_id=LanidEnd},
						   {?ok,Player, NewDq, [NewDq|StoEquip2]};
					   LanidS < ?CONST_DOUQI_BAG_START ->
						   AttrCut=get_attr_dq(DqS),
						   case attr_add(Player, RoleId, [], AttrCut) of
							   #player{}=Player2 ->
								   NewDq2=DqS#dq_data{role_id=0,lan_id=LanidEnd},
								   {?ok,Player2,NewDq2,[NewDq2|StoEquip2]};
							   {?error,ErrorCode} ->
								   {?error,ErrorCode}
						   end;
					   ?true ->
						   equip(Player,DqS,0,RoleId,LanidEnd,StoEquip2)
					end
			end;
		_ ->
			{?error,?ERROR_DOUQI_NO_DOUQI}
	end;
%%　在领悟背包内移动
ask_use_douqi(Player,_RoleId,DqId,LanidEnd,_StoEquip) ->
	DouQi=role_api_dict:douqi_get(),
	#douqi{sto_temp=StoTemp}=DouQi,
	case lists:keytake(DqId, #dq_data.dq_id, StoTemp) of
		{value, #dq_data{lan_id=LanidEnd}=DqS, _StoTemp2} -> {?ok,Player,DqS};
		{value, DqS, StoTemp2} ->
			case lists:keytake(LanidEnd, #dq_data.lan_id, StoTemp2) of
				{value, #dq_data{lan_id=LanidEnd}=DqE, StoTemp3} ->
					case move_a2b(Player#player.uid,DqE, DqS,LanidEnd) of
						{?error,ErrorCode} ->
							{?error,ErrorCode};
						NewDq ->
							role_api_dict:douqi_set(DouQi#douqi{sto_temp=[NewDq|StoTemp3]}),
							{?ok,Player,NewDq}
					end;
				_ ->
					NewDq=DqS#dq_data{lan_id=LanidEnd},
					role_api_dict:douqi_set(DouQi#douqi{sto_temp=[NewDq|StoTemp2]}),
					{?ok,Player,NewDq}
			end;
		_ ->
			{?error,?ERROR_DOUQI_NO_DOUQI}
	end.

%% 装备斗气
equip(Player,DqS,DqE,RoleId,LanidEnd,Storage0) ->
	equip(Player,DqS,DqE,RoleId,LanidEnd,Storage0,?null).

equip(Player,DqS,DqE,RoleId,LanidEnd,Storage0, A) ->
	case DqE of
		0 ->
			#dq_data{dq_type=DqType,dq_lv=DqLv,equip_type=EqType}=DqS,
			case is_equip(Player#player.lv, DqType, DqLv) of
				?false ->
					{?error, ?ERROR_DOUQI_UNUSER};
				{?true, Attr} ->
					RoleDQList	= get_lan_one(RoleId, Storage0),
					RoleLv = ?IF(RoleId==0, Player#player.lv, inn_api:partner_lv(RoleId)),
					OpenNum 	= get_dqlan_num(RoleLv),
					case length(RoleDQList) of
						N when N >= OpenNum ->
							{?error,?ERROR_DOUQI_FULL_EQUIP};
						_ ->
							case [T||#dq_data{equip_type=T} <- RoleDQList,T=:=EqType] of
								[] ->
									NewDqS=DqS#dq_data{role_id=RoleId,lan_id=LanidEnd},
									case attr_add(Player, RoleId, Attr, []) of
										#player{}=Player2 ->
											Player3=?IF(A==?null,Player2, attr_add(Player2, RoleId, [], get_attr_dq(A))),
											{?ok,Player3,NewDqS, [NewDqS|Storage0]};
										{?error,ErrorCode} ->
											{?error,ErrorCode}
									end;
								_ ->
									{?error, ?ERROR_DOUQI_HAVE_OTHER}
							end
					end
			end;
		_ ->
			case move_a2b(Player#player.uid,DqE,DqS,LanidEnd) of
				{?error,ErrorCode} ->
					{?error,ErrorCode};
				#dq_data{dq_id=NewDqId}=NewDq0 ->
					NewDq=NewDq0#dq_data{role_id=RoleId},
					if NewDqId =:= DqE#dq_data.dq_id ->
						   AttrCut=get_attr_dq(DqE),
						   AttrAdd=get_attr_dq(NewDq),
						   Player2= attr_add(Player, RoleId, AttrAdd, AttrCut),
						   {?ok,Player2,NewDq, [NewDq|Storage0]};
					   ?true ->
						   equip(Player,NewDq,0,RoleId,LanidEnd,Storage0,DqE)
					end
			end
	end.


%%　吞噬斗气		
%%　Dq2 | {Error,ErrorCode}
move_a2b(Uid,#dq_data{dq_exp=DqExpA,dq_type=DqTypeA}=DqA,DqB,LanId) ->
	case DqB of
		#dq_data{dq_exp=DqExpB,dq_type=DqTypeB,dq_id=DqIdB} ->
			{MaxExpA,MaxLvA,ColorA}=get_max_exp(DqTypeA),
			{_MaxExpB,_MaxLvB,ColorB}=get_max_exp(DqTypeB),
			if ColorB>ColorA ->
				   move_a2b(Uid,DqB,DqA,LanId);
			   ColorB=:=ColorA ->
				   if DqExpB>DqExpA ->
						  move_a2b(Uid,DqB,DqA,LanId);
					  ?true ->
						  if MaxExpA=<DqExpA ->
								 {?error,?ERROR_DOUQI_FULL_EXP};
							 ?true ->
								 ?IF(DqTypeB>=?CONST_COLOR_VIOLET,stat_api:logs_douqi(Uid, DqIdB, DqTypeB, ?CONST_FALSE),?ok),
								 if DqExpA+DqExpB >=MaxExpA ->
										DqA#dq_data{dq_exp=MaxExpA,dq_lv=MaxLvA,lan_id=LanId};
									?true ->
										{Lv, _Type, _Color}=up_data_lv(DqTypeA, DqExpA+DqExpB),
										DqA#dq_data{dq_exp=DqExpA+DqExpB,dq_lv=Lv,lan_id=LanId}
								 end
						  end
				   end;
			   ?true ->
				   if MaxExpA=<DqExpA ->
						  {?error,?ERROR_DOUQI_FULL_EXP};
					  ?true ->
						  ?IF(DqTypeB>=?CONST_COLOR_VIOLET,stat_api:logs_douqi(Uid, DqIdB, DqTypeB, ?CONST_FALSE),?ok),
						  if DqExpA+DqExpB >=MaxExpA ->
								 DqA#dq_data{dq_exp=MaxExpA,dq_lv=MaxLvA,lan_id=LanId};
							 ?true ->
								 {Lv, _Type, _Color}=up_data_lv(DqTypeA, DqExpA+DqExpB),
								 DqA#dq_data{dq_exp=DqExpA+DqExpB,dq_lv=Lv,lan_id=LanId}
						  end
				   end
			end;
		[] ->
			DqA#dq_data{lan_id=LanId}
	end.

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %% fun_in 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 取斗气最大等级 MaxLv
get_max_lv(DqType,DqLv) ->
	case data_fight_gas_total:get({DqType,DqLv+1}) of
		#d_fight_gas_total{} ->
			get_max_lv(DqType,DqLv+1);
		_ ->
			DqLv
	end.

%% 取斗气最大经验 {MaxExp,MaxLv,Color}=get_max_exp(DqType),
get_max_exp(DqType) ->
	MaxLv=get_max_lv(DqType,1),
	#d_fight_gas_total{next_lv_exp=MaxExp,color=Color}=data_fight_gas_total:get({DqType,MaxLv}),
	{MaxExp,MaxLv,Color}.

%%　斗气是否可装备
%%　?false | {?true, Attr}
is_equip(_RoleLv,DqType,DqLv) ->
	case data_fight_gas_total:get({DqType,DqLv}) of
		#d_fight_gas_total{type=IsEquip,lv=_LvLimit,
						   attr_type_one=AttType1,attr_one=Attr1,
						   attr_type_two=AttType2,attr_two=Attr2,
						   attr_type_three=AttrType3,attr_three=Attr3} when IsEquip=/=0 ->
			{?true,[{AttType1,Attr1},{AttType2,Attr2},{AttrType3,Attr3}]};
		_ ->
			?false
	end.

%%　取出斗气的属性
get_attr_dq(DqList) when is_list(DqList) ->
	F = fun(Dq,Acc) -> 
				AttrList = get_attr_dq(Dq),
				lists:append(AttrList, Acc)
		end,
	lists:foldl(F, [], DqList);
get_attr_dq(#dq_data{dq_type=DqTypeS,dq_lv=DqLvS}) ->
	Dtotal=data_fight_gas_total:get({DqTypeS,DqLvS}),
	#d_fight_gas_total{attr_type_one=AttType1,attr_one=Attr1,attr_type_two=AttType2,attr_two=Attr2,
					   attr_type_three=AttrType3,attr_three=Attr3} = Dtotal,
	[{AttType1,Attr1},{AttType2,Attr2},{AttrType3,Attr3}].

%%　增加斗气属性　　
attr_add(#player{socket=Socket}=Player,RoleId,AttrListAdd,AttrListCut) ->
	case RoleId of
		0 ->
			AttrG=role_api_dict:attr_group_get(),
			#attr_group{douqi=Douqi0}=AttrG,
			Douqi=?IF(Douqi0==?null,#attr{},Douqi0),
			Douqi2=role_api:attr_one_add(Douqi, AttrListAdd),
			Douqi3=role_api:attr_one_cut(Douqi2, AttrListCut),
			role_api:attr_update_player(Player, douqi, Douqi3);
		_ -> %% 伙伴装备
			Inn=role_api_dict:inn_get(),
			#inn{partners=Partners}=Inn,
			case lists:keytake(RoleId, #partner.partner_id, Partners) of
				{value, #partner{attr_group=AttrGr}=Partner, TupleList2} ->
					#attr_group{douqi=Douqi0}=AttrGr,
					Douqi=?IF(Douqi0==?null,#attr{},Douqi0),
					Douqi2=role_api:attr_one_add(Douqi, AttrListAdd),
					Douqi3=role_api:attr_one_cut(Douqi2, AttrListCut),
					Partner2=inn_api:attr_update_partner(Socket,Partner,douqi,Douqi3),
					role_api_dict:inn_set(Inn#inn{partners=[Partner2|TupleList2]}),
					Player;
				_ ->
					{?error,?ERROR_DOUQI_ROLE_ERROR}
			end
	end.

%% %%　更新斗气属性
%% attr_change_update(#player{socket=Socket}=Player, RoleId, StoEquip) ->
%% 	UseDqList = get_lan_one(RoleId, StoEquip),
%% 	NewAttr = get_attr_dq(UseDqList),
%% 	case RoleId of
%% 		0 ->
%% 			role_api:attr_update_player(Player, douqi, NewAttr);
%% 		_ -> %% 伙伴装备
%% 			Inn=role_api_dict:inn_get(),
%% 			#inn{partners=Partners}=Inn,
%% 			case lists:keytake(RoleId, #partner.partner_id, Partners) of
%% 				{value, Partner, TupleList2} ->
%% 					Partner2=inn_api:attr_update_partner(Socket,Partner,douqi,NewAttr),
%% 					role_api_dict:inn_set(Inn#inn{partners=[Partner2|TupleList2]}),
%% 					Player;
%% 				_ ->
%% 					{?error,?ERROR_DOUQI_ROLE_ERROR}
%% 			end
%% 	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% local_mod
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%　取玩家的斗气记录
check_douqi() ->
	DouQi = role_api_dict:douqi_get(),
	#douqi{date=Date}=DouQi,
	Now=util:date(),
	DouQi2=?IF(Date=:=Now,DouQi,
			   DouQi#douqi{date=Now, rmb_times=0, gold_times=0,
						   free_times=?CONST_DOUQI_FREE_TIMES}),
	role_api_dict:douqi_set(DouQi2),
	DouQi2.

%% 取玩家开启的斗气栏个数  N=get_dqlan_num(Lv)
get_dqlan_num(Lv) ->
	LanList=data_fight_gas_open:get_ids(),
	get_dqlan_num(Lv,LanList,0).
get_dqlan_num(_Lv,[],N) -> N;
get_dqlan_num(Lv,[Lan|LanList],N) ->
	case data_fight_gas_open:get(Lan) of
		#d_fight_gas_open{open_lv=OpenLv} when OpenLv=< Lv ->
			get_dqlan_num(Lv,LanList,N+1);
		_ -> 
			get_dqlan_num(Lv,LanList,N)
	end.

%% 取所有已装备的斗气  
get_lan_all(StoEquip) ->
	PrList=inn_api:inn_use_list(), % 取上阵伙伴Id列表
	lists:foldl(fun(Id,Acc)->
						DqList=get_lan_one(Id, StoEquip),
						[{Id,DqList}|Acc]
				end, [], [0|PrList]).

%% 取指定伙伴的已装备的斗气
get_lan_one(RoleId, StoEquip) ->
	[Dq || #dq_data{role_id=Id,lan_id=LanId}=Dq <- StoEquip, 
		   Id=:=RoleId, 
		   LanId=< ?CONST_DOUQI_LAN_END].

%%　斗气升级
%%　return : {Lv, Type, Color}
up_data_lv(DqType,Exp) ->
	up_data_lv(DqType,1,Exp).
up_data_lv(DqType,Lv,Exp) ->
	case data_fight_gas_total:get({DqType,Lv}) of
		#d_fight_gas_total{next_lv_exp=UpExp,type=Type,color=Color} ->
			if Exp >= UpExp ->
				   up_data_lv(DqType,Lv+1,Exp);
			   ?true ->
				   {Lv, Type, Color}
			end;
		_ ->
			Lv2=?IF(Lv-1=<1,1,Lv-1),
			#d_fight_gas_total{type=Type,color=Color}=
								  data_fight_gas_total:get({DqType,Lv2}),
			{Lv2, Type, Color}
	end.

%% 钻石领悟
rmb_grasp(#player{vip=Vip, uid=Uid}=Player,DouQi) ->
	#douqi{sto_temp=StoTemp,rmb_times=RmbTimes,adam_war=AdamWar,grasp_lv=GraspLv,is_first=IsFirst}=DouQi,
	AllTimes=vip_api:check_fun(Vip#vip.lv, #d_vip.douqi_times),
	if AllTimes - RmbTimes =< 0 -> 
			{?error,?ERROR_DOUQI_NO_TIMES};
		?true ->
			GType = 
				case IsFirst of
					1 ->
						?CONST_DOUQI_RMB_GRASP_LV+1;
					_ -> 
						?CONST_DOUQI_RMB_GRASP_LV
				end,
			case get_grasp(Player,GType,?CONST_CURRENCY_RMB) of
				{?error, ErrorCode} ->
					{?error, ErrorCode};
				{?ok, Player2, CurrBin, NewGas, _NextOdds} ->
					task_daily_api:check_cast(Uid,?CONST_TASK_DAILY_DOUQI,0),
					StoTemp2=insert_new_gas(StoTemp,NewGas, ?CONST_DOUQI_STORAGE_START),
					role_api_dict:douqi_set(DouQi#douqi{rmb_times=RmbTimes+1,sto_temp=StoTemp2,is_first=0}),
					Bin = logs_api:event_notice(?CONST_LOGS_TYPE_DOUQI, ?CONST_LOGS_ADD, NewGas#dq_data.dq_type, 1),
					Bin1= msg_ok_grasp_data(GraspLv, RmbTimes+1, AllTimes, AdamWar),
					Bin2= msg_storage_data(?CONST_DOUQI_STORAGE_TYPE_TEMP, StoTemp2),
					{?ok,Player2, <<CurrBin/binary,Bin/binary,Bin1/binary,Bin2/binary>>}
			end
	end.

%% 美金一键领悟 *** 新
gold_grasp(#player{vip=Vip}=Player, DouQi, N) ->
	AllTimes=vip_api:check_fun(Vip#vip.lv, #d_vip.douqi_times),
%% 	put(douqi_money_cast,Player#player.money#money.gold),
	gold_grasp(Player, DouQi, N, AllTimes, [], <<>>).
	
gold_grasp(#player{money=Money}=Player, DouQi, 0, _AllTimes, Acc, Bin0) ->
	role_api_dict:douqi_set(DouQi),
	Bin 	= msg_more_grasp(lists:reverse(Acc)),
	BinMsg  = role_api:msg_currency(Money),
%% 	Money0	= get(douqi_money_cast),
%% 	BinCurr	= logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_DEL, ?CONST_CURRENCY_GOLD, Money0-Money#money.gold),
	{?ok,Player,<<Bin0/binary,Bin/binary,BinMsg/binary>>};  % ,BinCurr/binary>>};
gold_grasp(Player, DouQi, N, AllTimes, Acc, Bin0) ->
	#douqi{sto_temp=StoTemp,grasp_lv=GraspLv,gold_times=GoldTimes}=DouQi,
	case get_grasp(Player,GraspLv,?CONST_CURRENCY_GOLD) of
		{?error, ErrorCode} ->
			Bin=system_api:msg_error(ErrorCode),
			gold_grasp(Player, DouQi, 0, AllTimes, Acc, <<Bin0/binary,Bin/binary>>);
		{?ok, Player2, _CurrBin, NewGas,NextOdds} ->
			{NewGas2,StoTemp2}=insert_new_gas2(StoTemp,NewGas, ?CONST_DOUQI_STORAGE_START),
			GraspLv2= case util:rand(1, ?CONST_PERCENT) of
						  Odds when Odds =< NextOdds ->
							  ?IF(GraspLv<?CONST_DOUQI_MAX_GRASP_LV,GraspLv+1,GraspLv);
						  _ -> 
							  ?CONST_DOUQI_MIN_GRASP_LV
					  end,
			DouQi2 = DouQi#douqi{gold_times=GoldTimes+1,sto_temp=StoTemp2,grasp_lv=GraspLv2},
			task_daily_api:check_cast(Player#player.uid,?CONST_TASK_DAILY_DOUQI,0),
			gold_grasp(Player2, DouQi2, N-1, AllTimes, [{GraspLv2,NewGas2}|Acc], Bin0)
	end.



%%　美金领悟
gold_grasp(#player{vip=Vip, uid=Uid}=Player,DouQi) ->
	#douqi{sto_temp=StoTemp,rmb_times=RmbTimes,adam_war=AdamWar,grasp_lv=GraspLv,gold_times=GoldTimes}=DouQi,
	AllTimes=vip_api:check_fun(Vip#vip.lv, #d_vip.douqi_times),
	case get_grasp(Player,GraspLv,?CONST_CURRENCY_GOLD) of
		{?error, ErrorCode} ->
			{?error, ErrorCode};
		{?ok, Player2, CurrBin, NewGas,NextOdds} ->
			StoTemp2=insert_new_gas(StoTemp,NewGas, ?CONST_DOUQI_STORAGE_START),
			GraspLv2= case util:rand(1, ?CONST_PERCENT) of
						  Odds when Odds =< NextOdds ->
							  ?IF(GraspLv<?CONST_DOUQI_MAX_GRASP_LV,GraspLv+1,GraspLv);
						  _ -> 
							  ?CONST_DOUQI_MIN_GRASP_LV
					  end,
			role_api_dict:douqi_set(DouQi#douqi{gold_times=GoldTimes+1,sto_temp=StoTemp2,grasp_lv=GraspLv2}),
			task_daily_api:check_cast(Uid,?CONST_TASK_DAILY_DOUQI,0),
			Bin = logs_api:event_notice(?CONST_LOGS_TYPE_DOUQI, ?CONST_LOGS_ADD, NewGas#dq_data.dq_type, 1),
			Bin1= msg_ok_grasp_data(GraspLv2, RmbTimes, AllTimes, AdamWar),
			Bin2= msg_storage_data(?CONST_DOUQI_STORAGE_TYPE_TEMP, StoTemp2),
			{?ok,Player2,<<CurrBin/binary,Bin/binary,Bin1/binary,Bin2/binary>>}
	end.


%　领悟斗气 {?ok, Player2, Bin,NewGas,NextOdds}:: NextOdds=下次领悟类型概率                                                                                                                                                                                                                                                                                                          
get_grasp(#player{uid=Uid,lv=Lv,uname=Name,uname_color=NameColor,pro= Pro} = Player,GraspLv,PayType) ->
	case data_fight_gas_grasp:get(GraspLv) of
		?null -> 
			get_grasp(Player,?CONST_DOUQI_MIN_GRASP_LV,PayType);
		#d_fight_gas_grasp{price=Price,appear_odds=AppearOdds,click_next_odds=NextOdds} ->
			LogSrc=[rmb_grasp,[],<<"领悟斗气花费">>],
			case role_api:currency_cut(LogSrc, Player, [{PayType, Price}]) of
				{?ok, Player2, CurrBin} -> 
					active_api:check_link(Player#player.uid, ?CONST_ACTIVITY_LINK_107),
					[{DqType,DqExp}] = util:odds_list_count_repeat(AppearOdds, 1),
					{DqLv, Type, Color}=up_data_lv(DqType, DqExp),
					DqId=idx_api:douqi_id(),
					NewGas=#dq_data{dq_exp=DqExp,dq_id=DqId,dq_lv=DqLv,dq_type=DqType,equip_type=Type,dq_color=Color},
					case Color >= ?CONST_DOUQI_SPLIT_COLOR of
						?true ->
							card_api:sales_notice(Player),
							stat_api:logs_douqi(Uid,DqId,DqType,?CONST_TRUE),
							BinCast = broadcast_api:msg_broadcast_douqi({Uid,Name,Lv,NameColor,Pro}, DqType),
							chat_api:send_to_all(BinCast);
						_ ->
							?ok
					end,
					{?ok, Player2, CurrBin, NewGas,NextOdds};
				{?error, ErrorCode} ->
					{?error, ErrorCode}
			end
	end.

% 新增斗气插入仓库 ?CONST_DOUQI_STORAGE_START
% retrun : StoTemp2
insert_new_gas(StoTemp,NewGas,Start) ->
	StoTemp2=lists:keysort(#dq_data.lan_id, StoTemp),
	insert_new_gas(StoTemp2,[],NewGas,Start).

insert_new_gas([H|StoTemp],List,NewGas,N) when H#dq_data.lan_id < N ->
	insert_new_gas(StoTemp,[H|List],NewGas,N);
insert_new_gas([H|StoTemp],List,NewGas,N) when H#dq_data.lan_id =:= N ->
	insert_new_gas(StoTemp,[H|List],NewGas,N+1);
insert_new_gas(StoTemp,List,NewGas,N) ->
	NewGas2=NewGas#dq_data{lan_id=N},
	util:lists_merge([NewGas2|StoTemp],List).

% 新增斗气插入仓库 ?CONST_DOUQI_STORAGE_START
% retrun : {NewGas2,StoTemp2}
insert_new_gas2(StoTemp,NewGas,Start) ->
	StoTemp2=lists:keysort(#dq_data.lan_id, StoTemp),
	insert_new_gas2(StoTemp2,[],NewGas,Start).

insert_new_gas2([H|StoTemp],List,NewGas,N) when H#dq_data.lan_id < N ->
	insert_new_gas2(StoTemp,[H|List],NewGas,N);
insert_new_gas2([H|StoTemp],List,NewGas,N) when H#dq_data.lan_id =:= N ->
	insert_new_gas2(StoTemp,[H|List],NewGas,N+1);
insert_new_gas2(StoTemp,List,NewGas,N) ->
	NewGas2=NewGas#dq_data{lan_id=N},
	{NewGas2,util:lists_merge([NewGas2|StoTemp],List)}.


%% 整理仓库
clear_storage(Storage) ->
	Fun=fun(#dq_data{dq_type=DqType}=DQ,Acc) -> 
				case lists:keytake(DqType, 1, Acc) of
					{value, {DqType,DqList}, TupleList2} ->
						[{DqType,[DQ|DqList]}|TupleList2];
					_ ->
						[{DqType,[DQ]}|Acc]
				end
		end,
	Storage2= lists:foldl(Fun, [], Storage),
	Storage3=lists:keysort(1, Storage2),
	lists:foldl(fun({_T,Dqs},StorAcc) ->
						Dqs2=lists:keysort(#dq_data.dq_exp,Dqs),
						StorAcc++Dqs2
				end, [], Storage3).

%% 吞噬斗气 {StoTemp2,Bin}
eat_storage(OtherDqList,EatDqList,OldDq) ->
	EatDqList2=clear_storage(EatDqList),
	eat_storage(OtherDqList,EatDqList2,OldDq,[]).
eat_storage(OtherDqList,EatDqList,OldDq,EatState) ->
	#dq_data{dq_type=DqType,dq_exp=OldExp0,dq_id=OldId0,lan_id=OldLanId0} =OldDq,
	EatExpAll=lists:sum([EatDqExp||#dq_data{dq_exp=EatDqExp,dq_id=EatId} <-EatDqList,OldId0=/=EatId]),
	{MaxExp,MaxLv,_Color}=get_max_exp(DqType),
	if OldExp0+EatExpAll > MaxExp ->
		   F=fun(EatDq,{Acc,OldDqAcc, []}) ->
					 #dq_data{dq_exp=EatExp,lan_id=EatLanId}=EatDq,
					 #dq_data{dq_lv=OldDqLv,dq_exp=OldExp}=OldDqAcc,
					 if OldDqLv =:= MaxLv ->
							{[EatDq|Acc], OldDqAcc, []};
						?true ->
							if OldExp+EatExpAll > MaxExp ->
								   OldDqAcc2=OldDqAcc#dq_data{dq_exp=MaxExp,dq_lv=MaxLv},
								   {Acc, OldDqAcc2, []};
							   ?true ->
								   {DqLv, _Type, _Color}=up_data_lv(DqType,OldExp+EatExp),
								   OldDqAcc2=OldDqAcc#dq_data{dq_exp=OldExp+EatExp,dq_lv=DqLv},
								   {Acc, OldDqAcc2, [EatLanId]}
							end
					 end;
				(EatDq,{Acc, OldDqAcc, EidsAcc}) ->
					 #dq_data{dq_exp=EatExp,lan_id=EatLanId}=EatDq,
					 #dq_data{dq_lv=OldDqLv,dq_exp=OldExp}=OldDqAcc,
					 if OldDqLv =:= MaxLv ->
							{[EatDq|Acc], OldDqAcc, EidsAcc};
						?true ->
							if OldExp+EatExpAll > MaxExp ->
								   OldDqAcc2=OldDqAcc#dq_data{dq_exp=MaxExp,dq_lv=MaxLv},
								   {Acc, OldDqAcc2, [EatLanId|EidsAcc]};
							   ?true ->
								   {DqLv, _Type, _Color} = up_data_lv(DqType,OldExp+EatExp),
								   OldDqAcc2 = OldDqAcc#dq_data{dq_exp=OldExp+EatExp,dq_lv=DqLv},
								   {Acc, OldDqAcc2, [EatLanId|EidsAcc]}
							end
					 end
			 end,
		   {NewEatDqList, NewDq, EatData}=lists:foldl(F, {[], OldDq, []}, EatDqList),
		   EatStorageNewdq = case get(eat_storage_newdq) of [#dq_data{}|_]=E -> E;  _ ->  [] end,
		   put(eat_storage_newdq,[NewDq|EatStorageNewdq]),
		   {NewEatDqList2,_,NewMaxDq} = group_storage(NewEatDqList),
		   eat_storage([NewDq|OtherDqList],NewEatDqList2,NewMaxDq,[{OldLanId0,EatData}|EatState]);
	   ?true ->
		   {DqLv, _Type, _Color} = up_data_lv(DqType,OldExp0+EatExpAll),
		   OldDq2=OldDq#dq_data{dq_exp=OldExp0+EatExpAll,dq_lv=DqLv},
		   LanIdList=[LanId||#dq_data{lan_id=LanId,dq_id=EatId} <-EatDqList,OldId0=/=EatId],
		   BinMsg = msg_eat_state([{OldLanId0,LanIdList}|EatState]),
		   EatStorageNewdq = case get(eat_storage_newdq) of [#dq_data{}|_]=E -> [OldDq2|E]; _ -> [OldDq2] end,
		   BinLog = logs_api:event_notice(?CONST_LOGS_TYPE_DOUQI, ?CONST_LOGS_ADD, group_logs(EatStorageNewdq)),
		   {[OldDq2|OtherDqList], <<BinMsg/binary,BinLog/binary>>}
	end.

group_logs(Lists) ->
	F = fun(#dq_data{dq_type=DqType},Acc) -> 
				case lists:keytake(DqType, 1, Acc) of
					{value, {DqType,Value}, TupleList2} ->
						[{DqType,Value+1}|TupleList2];
					_ ->
						[{DqType, 1}|Acc]
				end;
		   (_, Acc) ->
				Acc
		end, 
	lists:foldl(F, [], Lists).
	

%% 将仓库分组  被吃	   不可吃		吃货	
%%	{EatDqList,OtherDqList,MaxDq}
group_storage(Storage) ->
	Fun=fun(DqDat,{Eat,Other,MaxDq}) ->
			  #dq_data{dq_exp=DqExp,dq_lv=DqLv,dq_type=DqType,lan_id=LanId,is_lock=IsLock}=DqDat,
			  {_MaxExp,MaxLv,Color}=get_max_exp(DqType),
			  MaxLv=get_max_lv(DqType,DqLv),
			  if 
				  IsLock =:= 1 ->
					   {Eat,[DqDat|Other],MaxDq};
				  DqLv >= MaxLv ->
					  #d_fight_gas_total{type=IsEquip}=data_fight_gas_total:get({DqType,DqLv}),
					  if IsEquip =:= 0 ->
							 {[DqDat|Eat],Other,MaxDq};
						 ?true ->
							 {Eat,[DqDat|Other],MaxDq}
					  end;
				  MaxDq =:= ?null ->
					  {Eat,Other,DqDat};
				  Color > MaxDq#dq_data.dq_color ->
					  {[MaxDq|Eat],Other,DqDat};
				  Color =:= MaxDq#dq_data.dq_color ->
					  if DqExp > MaxDq#dq_data.dq_exp ->
							 {[MaxDq|Eat],Other,DqDat};
						 DqExp == MaxDq#dq_data.dq_exp andalso LanId< MaxDq#dq_data.lan_id -> 
							 {[MaxDq|Eat],Other,DqDat};
						 ?true ->
							 {[DqDat|Eat],Other,MaxDq}
					  end;
				  ?true ->
					  {[DqDat|Eat],Other,MaxDq}
			  end
	  end, 
	lists:foldl(Fun, {[],[],?null}, Storage).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% msg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 仓库数据 [48201]
msg_storage_data(Type,DouqiMsg)->
	Rs	= app_msg:encode([{?int8u,Type},{?int16u,length(DouqiMsg)}]),
	Fun	= fun(#dq_data{dq_id=DqId,dq_exp=DqExp,dq_lv=DqLv,dq_type=DqType,is_lock=IsLock,lan_id=LanId},Acc)-> 
				  Bin = app_msg:encode([{?int8u,LanId},{?int32u,DqId},{?int16u,DqType},
										{?int8u,DqLv},{?int32u,DqExp},{?int8u,IsLock}]),
				  <<Acc/binary,Bin/binary>>
		  end,
	RsList	= lists:foldl(Fun, Rs, DouqiMsg),
	app_msg:msg(?P_SYS_DOUQI_STORAGE_DATA, RsList).
% 领悟界面信息返回 [48220]
msg_ok_grasp_data(TypeGrasp,OkTimes,AllTimes,AdamWar)->
    RsList = app_msg:encode([{?int8u,TypeGrasp},
        {?int16u,OkTimes},{?int16u,AllTimes},
        {?int32u,AdamWar}]),
    app_msg:msg(?P_SYS_DOUQI_OK_GRASP_DATA, RsList).

% 装备界面信息返回 [48240]
msg_ok_douqi_role(LanCount,RoleMsg)->
	Rs	= app_msg:encode([{?int8u,LanCount},{?int16u,length(RoleMsg)}]),
	Fun	= fun({RoleId,DouqiMsg},Acc)-> 
				  Bin=msg_role_data(RoleId,DouqiMsg),
				  <<Acc/binary,Bin/binary>>
		  end,
	RsList	= lists:foldl(Fun, Rs, RoleMsg),
    app_msg:msg(?P_SYS_DOUQI_OK_DOUQI_ROLE, RsList).
% 伙伴数据信息块 [48245]
msg_role_data(RoleId,DouqiMsg)->
	Rs	= app_msg:encode([{?int16u,RoleId},{?int16u,length(DouqiMsg)}]),
	Fun	= fun(#dq_data{dq_id=DqId,dq_exp=DqExp,dq_lv=DqLv,dq_type=DqType,is_lock=IsLock,lan_id=LanId},Acc)-> 
				  Bin=app_msg:encode([{?int8u,LanId},{?int32u,DqId},{?int16u,DqType},
									  {?int8u,DqLv},{?int32u,DqExp},{?int8u,IsLock}]),
				  <<Acc/binary,Bin/binary>>
		  end,
	lists:foldl(Fun, Rs, DouqiMsg).

% 拾取成功 [48310]
msg_ok_get_dq(LanMsg)->
	Rs  = app_msg:encode([{?int16u,length(LanMsg)}]),
	Fun	= fun(LanId, Acc)-> 
				  Bin=app_msg:encode([{?int8u,LanId}]),
				  <<Acc/binary,Bin/binary>>
		  end,
	RsList	= lists:foldl(Fun, Rs, LanMsg),
	app_msg:msg(?P_SYS_DOUQI_OK_GET_DQ, RsList).

% 分解斗气成功 [48330]
msg_ok_dq_split(RoleId,LanId,GetAdams)->
    RsList = app_msg:encode([{?int16u,RoleId},{?int8u,LanId},{?int32u,GetAdams}]),
    app_msg:msg(?P_SYS_DOUQI_OK_DQ_SPLIT, RsList).

% 移动斗气成功 [48390]
msg_ok_use_douqi(RoleId,DqId,LanidStart,LanidEnd,DqMsg)->
	Rs = app_msg:encode([{?int16u,RoleId},
						 {?int32u,DqId},{?int8u,LanidStart},
						 {?int8u,LanidEnd},{?int16u,length(DqMsg)}]),
	Fun	= fun(Dq,Acc)-> 
				  #dq_data{dq_id=DqId0,dq_exp=DqExp,dq_lv=DqLv,dq_type=DqType,is_lock=IsLock,lan_id=LanId}=Dq,
				  Bin=app_msg:encode([{?int8u,LanId},{?int32u,DqId0},{?int16u,DqType},
									  {?int8u,DqLv},{?int32u,DqExp},{?int8u,IsLock}]),
				  <<Acc/binary,Bin/binary>>
		  end,
	RsList	= lists:foldl(Fun, Rs, DqMsg),
	app_msg:msg(?P_SYS_DOUQI_OK_USE_DOUQI, RsList).

% 吞噬结果 [48285]
msg_eat_state(EatData)->
	Rs	= app_msg:encode([{?int16u,length(EatData)}]),
	Fun	= fun({LanId,IdData},Acc)-> 
				  Bin=msg_eat_data(LanId,IdData),
				  <<Acc/binary,Bin/binary>>
		  end,
	RsList	= lists:foldl(Fun, Rs, EatData),
	app_msg:msg(?P_SYS_DOUQI_EAT_STATE, RsList).

% 吞噬结果信息块 [48290]
msg_eat_data(LanId,IdData)->
	Rs	= app_msg:encode([{?int8u,LanId},{?int16u,length(IdData)}]),
	Fun	= fun(Id,Acc)-> 
				  Bin=app_msg:encode([{?int8u,Id}]),
				  <<Acc/binary,Bin/binary>>
		  end,
	lists:foldl(Fun, Rs, IdData).

% 一键领悟数据返回 [48223]
msg_more_grasp(MsgMore)->
	Rs	= app_msg:encode([{?int16u,length(MsgMore)}]),
	Fun	= fun({TypeGrasp,NewDq},Acc)-> 
				  #dq_data{lan_id=LanId,dq_id=DqId,dq_type=DqType,
						   dq_lv=DqLv,dq_exp=DqExp,is_lock=IsLock} = NewDq,
				  Bin=app_msg:encode([{?int16u,TypeGrasp},
									  {?int8u,LanId},{?int32u,DqId},
									  {?int16u,DqType},{?int8u,DqLv},
									  {?int32u,DqExp},{?int8u,IsLock}]),
				  <<Acc/binary,Bin/binary>>
		  end,
	RsList	= lists:foldl(Fun, Rs, MsgMore),
	app_msg:msg(?P_SYS_DOUQI_MORE_GRASP, RsList).


