%% Author: acer
%% Created: 2012-11-12
%% Description: TODO: Add description to energy_api.
-module(energy_api).


-include("../include/comm.hrl"). 

-export([
		 encode_energy/1,
		 decode_energy/1,
		 
		 init/1,
		 init_energy/0,
		 login/1,
		 
		 add_energy_max/1,
		 
		 interval/0,
		 interval_cb/1,
		 energy_timadd_cb/2,
		 buffer/1, 
		 buffer_interval/0,
		 buffer_interval_cb/2,
		 
		 request/1,    %% 前端精力值请求
		 ask_buy/1,    
		 buy/1,
		 vip_energy_cd/1,    %%  vip精力回调

         energy_add/3,          %% 增加精力{Value,Player}
         energy_use/3,           %% 消耗精力
		 check_energy_copy/2,     %%  检查副本是否可以进入
         get_energy_value/0
      
		]).

encode_energy(Energy) ->
	Energy.

decode_energy(Energy) when is_record(Energy,energy) -> 
	Energy;
decode_energy({energy,Energy_value,Buff_value,Buy_base,Today_buy_num,Last_date,Start_date,_})->
	#energy{
			energy_value = Energy_value,
			buff_value = Buff_value,
			buy_base = Buy_base,
			today_buy_num = Today_buy_num,
			last_date = Last_date,
			start_date = Start_date
		   };
decode_energy(_) ->
	init_energy().

%% 初始化精力
init(Player) ->
	DictEnergy = init_energy(),
	{Player,DictEnergy}. 

%% 初始化记录
init_energy() ->
	Now = util:seconds(),
	#energy{energy_value = ?CONST_ENERGY_BEGIN,
			buy_base = 0,
			buff_value = ?CONST_ENERGY_EXTRA,
			last_date = Now,
			start_date = 0,
			today_buy_num = 0,
			buff_time = {0,0}
		   }.

%% 登陆初始化精力值
%% retrun:Player
login(#player{uid = Uid,vip = Vip,socket = Socket}) ->
	Energy = role_api_dict:energy_get(),
	?MSG_ECHO("===========~w~n",[Energy]),
	#energy{energy_value = Value0} = Energy,
	{?ok,Energy2,Bin4} = buff_check(Energy),
	?MSG_ECHO("===========~w~n",[Energy2]),
	Max = max_energy(Vip#vip.lv),
	Energy3 = login_add(Energy2,Max),
	role_api_dict:energy_set(Energy3),
	#energy{energy_value = Value,buff_value = BValue} = Energy3,
    Bin = msg_energy_ok(Value, Max),
	Bin2 = msg_buff_energy(BValue),	
	Add = Value - Value0,     
	stat_api:logs_energy( Uid,login, Add, Value, <<"登陆初始化每半小时自增5点">>),                 %% 精力日志记录统计
	Bin3 = logs_api:event_notice(?CONST_LOGS_TYPE_CURRENCY, ?CONST_LOGS_ADD, ?CONST_CURRENCY_ENERGY, Add), % 漂字
	app_msg:send(Socket, <<Bin/binary,Bin2/binary,Bin3/binary,Bin4/binary>>).


%% 增加最大值
add_energy_max(AddEnergyMax) ->
	Energy = role_api_dict:energy_get(),
	role_api_dict:energy_set(Energy#energy{energy_value=Energy#energy.energy_value + AddEnergyMax}).


%% 1处理请求当前精力值
request(#player{vip = Vip})  ->
	Energy = role_api_dict:energy_get(),
	#energy{energy_value = EnergyValue, buff_value = BuffValue} = Energy,
	Max = max_energy(Vip#vip.lv),
	Bin = msg_energy_ok(EnergyValue, Max),
	Bin2 = msg_buff_energy(BuffValue),
	<<Bin/binary,Bin2/binary>>.
	
%% 2处理请求购买精力
ask_buy(#player{vip = #vip{lv = VipLv}}) ->
	Energy = role_api_dict:energy_get(),
	Now = util:seconds(),
	EnergyBuys = vip_api:check_fun(VipLv, #d_vip.energy_buys),
	SumNum = Energy#energy.buy_base + EnergyBuys,
	case util:is_same_date(Energy#energy.start_date, Now) of
		?true ->
			TodayBuyNum = Energy#energy.today_buy_num,
			Num = TodayBuyNum + 1,
			Rmb = get_rmb(Num),
			if Num > SumNum ->
				   system_api:msg_error(?ERROR_ENERGY_MAX_TIME);
			   ?true ->
				   msg_ok_ask_buye(?CONST_ENERGY_REQUEST_TYPE, Num, SumNum, Rmb)
			end;
		_ ->
			Energy2 = Energy#energy{today_buy_num = 0},
			role_api_dict:energy_set(Energy2),
			TodayBuyNum = Energy2#energy.today_buy_num,
			Num = TodayBuyNum + 1,
			Rmb = get_rmb(Num),
			msg_ok_ask_buye(?CONST_ENERGY_REQUEST_TYPE, Num, SumNum, Rmb)
	end.

% 3购买精力
buy(Player) ->
	Energy = role_api_dict:energy_get(),
	#vip{lv = VipLv} = Player#player.vip,
	case VipLv of
		0 ->
			{?error,?ERROR_VIP_LV_LACK};		
		VipLv when VipLv > 0 ->
			TimEnergy = vip_api:check_fun(VipLv, #d_vip.energy_buys),
			Now = util:seconds(),
			case  TimEnergy > Energy#energy.today_buy_num of 
				?true ->
					case util:is_same_date(Energy#energy.start_date, Now) of
						?true ->
							#d_energy_buy{use_rmb = UseRmb,add_energy =  AddEnergy} = data_energy_buy:get(Energy#energy.today_buy_num + 1), 
							case buy_energy_cut(Player,UseRmb,AddEnergy) of
								{?ok, Player2, Bin} ->
									{?ok, Player2, Bin};
								{?error, ErrorCode} ->
									{?error, ErrorCode}
							end;
						_ ->
							Energy2 = Energy#energy{today_buy_num = 0},
							role_api_dict:energy_set(Energy2),
							#d_energy_buy{use_rmb = UseRmb,add_energy =  AddEnergy} = data_energy_buy:get(Energy2#energy.today_buy_num + 1), 
							case buy_energy_cut(Player,UseRmb,AddEnergy) of
								{?ok, Player2, Bin} ->
									{?ok, Player2, Bin};
								{?error, ErrorCode} ->
									{?error, ErrorCode}
							end
					end;
				_ ->
					{?error,?ERROR_ENERGY_MAX_TIME}
			end			
	end.

%% vip升级精力回调
vip_energy_cd(#player{uid = Uid, vip = Vip,socket = Socket})->
	EnergyMax =max_energy(Vip#vip.lv),
	Energy = role_api_dict:energy_get(),
	#energy{energy_value = Value} = Energy,
	case Energy#energy.energy_value < EnergyMax of
		?true ->
			case ets:lookup(?ETS_ENERGY, Uid) of
				[] ->
					NowTime = util:seconds(),
					ets:insert(?ETS_ENERGY,{Uid,NowTime});
				_ ->
					?ok
			end;
		_ ->
			?skip
	end,
	BinMsg = msg_energy_ok(Value,EnergyMax),
	app_msg:send(Socket, BinMsg).

%% 增加精力值(使用道具或购买获得)
energy_add(LogSrc,#player{uid = Uid,vip = Vip,socket = Socket},EnergyValue) ->
	Energy = role_api_dict:energy_get(),
	?MSG_ECHO("================~w~n",[{Energy,EnergyValue}]),
	Max = max_energy(Vip#vip.lv),
	EnergyValue2 = Energy#energy.energy_value + EnergyValue,
	Energy2 = Energy#energy{energy_value = EnergyValue2},
	role_api_dict:energy_set(Energy2),
	?MSG_ECHO("================~w~n",[{Energy2}]),
	[Method,UseValue,Remark] = LogSrc,
	stat_api:logs_energy(Uid,Method,UseValue, EnergyValue2, Remark),
	BinMsg = msg_energy_ok(Energy2#energy.energy_value,Max),
	app_msg:send(Socket, BinMsg),
	EnergyValue2.

%% 消耗精力
energy_use(LogSrc,#player{uid = Uid,vip=Vip} = Player,UseValue) ->
	Energy = role_api_dict:energy_get(),
	Max = max_energy(Vip#vip.lv),
	#energy{energy_value = NowValue,buff_value = BuffValue} = Energy,
	case BuffValue - UseValue of
		NBufV when NBufV>=0 ->
			[Method,UseValue,Remark] = LogSrc,
			Energy2 = Energy#energy{buff_value = NBufV},
			#energy{energy_value = Value} = Energy2,
			role_api_dict:energy_set(Energy2),
			Lvalue = Value + NBufV,
			stat_api:logs_energy(Uid,Method, -UseValue,Lvalue, Remark),
			Bin = msg_energy_ok(Value,Max),
			Bin2 = msg_buff_energy(NBufV),
			{?ok,Player,<<Bin/binary,Bin2/binary>>};
		NBufV -> 
			case NowValue + NBufV of
				NNowV when NNowV >= 0 ->
					case NNowV < Max  of
						?true ->
							ets:insert(?ETS_ENERGY, {Uid,util:seconds()});
						_ ->
							?skip
					end,
					[Method,UseValue,Remark] = LogSrc,
					Energy2 = Energy#energy{buff_value = 0,energy_value = NNowV},
					stat_api:logs_energy(Uid,Method, -UseValue, NNowV, Remark),
					role_api_dict:energy_set(Energy2),
					Bin = msg_energy_ok(Energy2#energy.energy_value,Max),
					Bin2 = msg_buff_energy(?CONST_ENERGY_ZERO),
					{?ok,Player,<<Bin/binary,Bin2/binary>>};
				_ ->
					TodayBuyNum = Energy#energy.today_buy_num,
			        Num = TodayBuyNum + 1,
			        Rmb = get_rmb(Num),
					EnergyBuys = vip_api:check_fun(Vip, #d_vip.energy_buys),
	                SumNum = Energy#energy.buy_base + EnergyBuys,
					Bin = msg_ok_ask_buye(?CONST_ENERGY_RETRUN_TYPE, Num, SumNum, Rmb),
					{?ok,Player,Bin}
			end
	end.

%% 精力定时检查ets表,半小时加5：?CONST_ENERGY_ADD
interval() ->
	EnergyList = ets:tab2list(?ETS_ENERGY),
	NowTime = util:seconds(),
	[interval_cb(Uid)||{Uid, DataTime}<-EnergyList,abs(NowTime - DataTime) >= 1800].	
	
interval_cb(Uid) ->	
	case role_api:is_online2(Uid) of
		?true ->
			util:pid_send(Uid, ?MODULE, energy_timadd_cb, ?CONST_ENERGY_ADD);
		?false ->
	        ets:delete(?ETS_ENERGY, Uid)
	end.
	
%% 精力定时回调
energy_timadd_cb(#player{vip = Vip,uid = Uid} = Player, EnergyValue) ->
	EnergyValue2 = energy_add([energy_timadd_cb, EnergyValue, <<"huidiao:+energy">>],Player,EnergyValue),
	EnergyMax = max_energy(Vip#vip.lv),
	case EnergyValue2 >= EnergyMax of
		?true ->
			ets:delete(?ETS_ENERGY, Uid);			
		?false ->
			Energy = role_api_dict:energy_get(),
			#energy{last_date = DataTime} = Energy,
			Energy2 = Energy#energy{last_date = DataTime + 1800},
			role_api_dict:energy_set(Energy2),
			ets:update_element(?ETS_ENERGY, Uid, [{2,DataTime + 1800}])
		end,
    Player.	
	
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%local function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 检查是否可以领取buff
buff_check(#energy{buff_time = {Time,H0},state = State} = Energy) ->
	Now = util:seconds(),
	{H,_,_} = util:time(),
	case util:is_same_date(Now, Time) of
		?true ->
			if 
				H0 >= 18 ->
					 BinMsg  = msg_buff(?CONST_FUNC_OPEN_ENERGY_TIME,State),
	                 {?ok,Energy,BinMsg};
				H0 >= 12 ->
					if 
						H >= 18 ->
							BinMsg  = msg_buff(?CONST_FUNC_OPEN_ENERGY_TIME,0),
			                Energy2 = Energy#energy{state = 0},
			                {?ok,Energy2,BinMsg};
					   ?true ->
					        BinMsg  = msg_buff(?CONST_FUNC_OPEN_ENERGY_TIME,State),
	                        {?ok,Energy,BinMsg}
					end;
				?true ->
					 BinMsg  = msg_buff(?CONST_FUNC_OPEN_ENERGY_TIME,State),
	                 {?ok,Energy,BinMsg}
			end;
		_->
			BinMsg  = msg_buff(?CONST_FUNC_OPEN_ENERGY_TIME,0),
			Energy2 = Energy#energy{state = 0},
			{?ok,Energy2,BinMsg}
	end.


buffer_interval() ->
	OnlineList = ets:tab2list(?ETS_ONLINE),
	[util:pid_send(Uid, ?MODULE, buffer_interval_cb, ?null) ||#player{uid = Uid} <- OnlineList].

buffer_interval_cb(#player{socket = Socket} = Player,_)->
	case role_api_dict:energy_get() of
		#energy{state = 1} = Energy->
			BinMsg  = msg_buff(?CONST_FUNC_OPEN_ENERGY_TIME,0),
			Energy2 = Energy#energy{state = 0},
			role_api_dict:energy_set(Energy2),
			app_msg:send(Socket, BinMsg);
		_ ->
			?skip
	end,
	Player.

%% 前端请求
buffer(Player)->
	Now = util:seconds(),
	{H,_,_} = util:time(),
	case role_api_dict:energy_get() of
		#energy{state = 0} ->
			case bag_api:goods_set([buffer, [], <<"领取buffer">>], Player, [{?CONST_ENERGY_GET_GOODS,1}]) of
						{?ok,Player2,SetBin,LogBin} ->
							Energy  = role_api_dict:energy_get(),
							Energy2 = Energy#energy{state = 1,buff_time = {Now,H}},
							role_api_dict:energy_set(Energy2),
							BinMsg  = msg_buff(?CONST_FUNC_OPEN_ENERGY_TIME,1),
							{?ok,Player2,<<SetBin/binary,LogBin/binary,BinMsg/binary>>};
						{?error,ErrorCode} ->
							{?error,ErrorCode}
					end;
		_ ->
			{?error,?ERROR_ENERGY_BUFF}
	end.
	
	
%% 精力可以增加上限，登陆时检查
login_add(#energy{energy_value = EnergyValue,last_date = LastDate} = Energy,EnergyMax) ->
	Now = util:seconds(),
	case  EnergyValue =< EnergyMax of   %% 当前精力值是否达上限
		?true ->
			Add = abs(Now - LastDate) div ?CONST_ENERGY_DELAY,  % Add = 精力可增加量
            AddValue = EnergyValue + Add * ?CONST_ENERGY_ADD,
			case AddValue < EnergyMax of
				?true ->
					Energy#energy{energy_value = AddValue,last_date = Now};
				_ ->
					Energy#energy{energy_value = EnergyMax,last_date = Now}
			end;
		_ ->
			Energy
	end.

%% 精力花费的元宝
get_rmb(Buy_num) ->
	case data_energy_buy:get(Buy_num) of
		DBuy when is_record(DBuy, d_energy_buy) ->
			DBuy#d_energy_buy.use_rmb;
		_ ->
			Buy_num2 = lists:last(data_energy_buy:get_ids()),
			(data_energy_buy:get(Buy_num2))#d_energy_buy.use_rmb
	end.

%% 获取最大精力值
max_energy(VipLv) ->
	R = vip_api:check_fun(VipLv, #d_vip.energy_max) + ?CONST_ENERGY_BEGIN,
	R.
	
% 购买精力,扣减金钱
buy_energy_cut(Player,UseRmb,Value) ->
	case role_api:currency_cut([buy,[],<<"购买精力">>],Player,[{?CONST_CURRENCY_RMB, UseRmb}]) of
		{?ok, Player2, Bin3} ->
			{Player3,Bin2} = role_api:currency_add([buy,[],<<"购买精力">>],Player2, [{?CONST_CURRENCY_ENERGY, Value}]),
			Bin = msg_ok_buy_energy(),
			Energy2 = role_api_dict:energy_get(),
			Energy3 = Energy2#energy{today_buy_num = Energy2#energy.today_buy_num + 1,buy_base = Energy2#energy.buy_base,start_date = util:seconds()},
			role_api_dict:energy_set(Energy3),
			{?ok, Player3, <<Bin/binary,Bin2/binary,Bin3/binary>>};
		{?error, ErrorCode} ->
			{?error, ErrorCode}
	end.


%% 检查是否可以进入副本
check_energy_copy(Player,CheckEnergy) -> 
	Energy = role_api_dict:energy_get(),
	case Energy#energy.energy_value + Energy#energy.buff_value >= CheckEnergy of
		?true ->
		   ?ok;
	    _ ->
		   case buy_value(Player) of
			   {Player2,Num,SumNum} ->
				   BinMsg = msg_ok_ask_buye(?CONST_ENERGY_RETRUN_TYPE, Num, SumNum, get_rmb(Num));
			   _ ->
				   Player2 = Player,
				   BinMsg = system_api:msg_error(?ERROR_ENERGY_LACK)
		   end,
		   {?error,Player2,BinMsg}
	end.

%% 返回当前体力
get_energy_value() ->
	Energy = role_api_dict:energy_get(),
	Energy#energy.energy_value + Energy#energy.buff_value.


%% 剩余购买精力次数
buy_value(Player) ->
	#vip{lv = VipLv} = Player#player.vip,
	Energy = role_api_dict:energy_get(),
	{Num,SumNum} =
		case VipLv of
			0 ->
				{1,Energy#energy.buy_base};
			VipLv when VipLv > 0 ->
                EnergyBuys = vip_api:check_fun(VipLv, #d_vip.energy_buys),
				TodayBuyNum = Energy#energy.today_buy_num,
				TodayBuyNum2 = TodayBuyNum + 1,
				{TodayBuyNum2, EnergyBuys}
		end,
	{Player,abs(SumNum - Num + 1),SumNum}.

%%%%%%%%%%%%%%%%%%%%%%%%%% msg %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 请求精力值成功 [1261]
msg_energy_ok(Sum,Max)->
    RsList = app_msg:encode([{?int16u,Sum},{?int16u,Max}]),
    app_msg:msg(?P_ROLE_ENERGY_OK, RsList).

% 额外赠送精力 [1262]
msg_buff_energy(BuffValue)->
    RsList = app_msg:encode([{?int32u,BuffValue}]),
    app_msg:msg(?P_ROLE_BUFF_ENERGY, RsList).

% 请求购买面板成功 [1264]
msg_ok_ask_buye(Type,Num,Sumnum,Rmb)->
    RsList = app_msg:encode([{?int8u,Type},{?int8u,Num},{?int8u,Sumnum},{?int16u,Rmb}]),
    app_msg:msg(?P_ROLE_OK_ASK_BUYE, RsList).

% 购买精力成功 [1267]
msg_ok_buy_energy()->
    app_msg:msg(?P_ROLE_OK_BUY_ENERGY,<<>>).

% 通知加buff [1370]
msg_buff(Id,State)->
    RsList = app_msg:encode([{?int16u,Id},
        {?int8u,State}]),
    app_msg:msg(?P_ROLE_BUFF, RsList).

