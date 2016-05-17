%% Author: dreamxyp
%% Created: 2012-4-5
%% Description: TODO: Add description to gm_master_api
-module(gm_api).

%%
%% Include files
%%
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([
		 % 系统功能
		 set_map_xy/1,
		 user_out/2,
		 online/0,

		 % 放邮件|通知
		 send_mail/6,
		 send_mail_all/5,
		 send_notice/7,
		 send_notice_del/1,
		 
		 % 发放物资
		 give_pay/3, 		 
		 give_pay_cb/2,
		 give_exp/2,
		 give_exp_cb/2,
		 give_gold/3,
		 give_gold_cb/2,
		 give_goods/2,
		 give_goods_cb/2,
		 give_point/2,
		 give_point_cb/2,
		 give_rmb/2,
		 give_rmb_cb/2,
		 
		 % 活动控制
		 clear_mysql/0,
		 set_active/5,
		 temp_active/5,
		 get_acty_lists/0,
		 get_acty_date/1,
		 
		 sales_time_read/0,
		 sales_time_setup/3,
		 
		 % 功能开放
		 get_funs_state/0,
		 set_funs_state/1,
		 open_sys/2,
		 open_sys_cb/2,
		 
		 %% 玩家数据
		 user_info/2,
		 user_info_cb/2,
		 
		 %% 设定陪玩
		 set_title/4,
		 inside_rmb/3
		]). 

%% 后台调用		修改	ets表内功能开关状态
set_funs_state(AllFuns) ->
	is_funs_api:set_funs_state(AllFuns).

%% 后台调用		查询	ets表内功能开关状态
get_funs_state() ->
	AllFuns  = is_funs_api:get_funs_state(),
	AllFuns2 = [{obj,[{id,		Id},
					  {type,	Type}
					 ]} 
				|| {Id,Type} <- AllFuns],
	json:encode(AllFuns2).

%% 设置玩家称号
set_title(Uid, Id, STime, ETime) when is_integer(STime) ->
	title_api:new_title(Uid, Id, STime, ETime);
set_title(Uid, Id, [SY,SM,SD,SH,SI,SS], [ET,EM,ED,EH,EI,ES]) ->
	STime1 = util:datetime2timestamp(SY,SM,SD,SH,SI,SS),
	ETime1 = util:datetime2timestamp(ET,EM,ED,EH,EI,ES),
	title_api:new_title(Uid, Id, STime1, ETime1);
set_title(Uid, Id, STime, ETime) when is_list(STime) ->
	STime1 = util:datetime2timestamp(STime),
	ETime1 = util:datetime2timestamp(ETime),
	title_api:new_title(Uid, Id, STime1, ETime1);
set_title(_,_,_,_) ->
	?false.


% 得到当前在线玩家
online()->
	Online = ets:info(?ETS_ONLINE, size),
	{?ok,Online}.

%% 拉被卡住的玩家回新手村
set_map_xy(Uid) ->
	scene_api:set_map_xy(Uid).

% 踢出服务器
user_out(Uid,OutCode) ->
	Mpid 	= role_api:mpid(Uid),
	BinMsg	= role_api:msg_disconnect(OutCode,<<>>), 
	app_msg:send(Mpid, BinMsg),
	util:pid_send(Mpid,?exit), %% 退出 
	?ok.
%% 每周二固定给表中玩家(内部)发放固定绑定金元
inside_rmb(Uid, Sid, BindRmb) ->
	role_api:inside_rmb_one(Uid, Sid, BindRmb).


% 发送邮件
%% 实物: Goods = [{give,43001,5,0,0,0,0,0},{give,42001,10,0,0,0,0,0}] 可放包裹，
%% 虚物: VGoods = [{?CONST_CURRENCY_XXX,100}]
send_mail(_RecvSid,RecvUids,Title,Content,Goods,VGoods)-> 
	?MSG_ECHO("==============================================~w~n",[{RecvUids,Title,Content,Goods,VGoods}]),
	mail_api:send_mail_uids(RecvUids, Title, Content, Goods, VGoods).
% 群发
send_mail_all(_RecvSid,Title,Content,Goods,VGoods)->
	mail_api:send_mail_all(Title, Content, Goods, VGoods).


%% 发送公告
send_notice(NoticeId, MsgType,Interval, BeginTime, EndTime,ShowTime, Content)->
	% ?MSG_ECHO("NoticeId:~p",[NoticeId]),
	notice_api:update(NoticeId, MsgType, Interval, BeginTime, EndTime,ShowTime, Content).
%% 删除公告
send_notice_del(NoticeId)->
	notice_api:delete(NoticeId).


%% 充值
give_pay(Uid,Rmb,BindRmb)-> 
	util:pid_send(Uid, ?MODULE, give_pay_cb, [Rmb,BindRmb]),
	?ok.

%% 更新mysql表货币数据至player
give_pay_cb(#player{uid = Uid,money=Money} = Player, [0,0]) ->
	%% 调用vip接口更新vip等级数据
	case role_api:currency_refresh(Uid, Money) of 
		Money  -> %% 没变化
			%?MSG_ECHO("~p",[Money]),
			Player#player{money=Money};
		Money2 ->
			BinMsg 		 = role_api:msg_currency(Money2#money.gold, Money2#money.rmb, Money2#money.rmb_bind),
			app_msg:send(Player#player.socket, BinMsg),
			Player2 	 = vip_api:buy_rmb(Player#player{money = Money2},Money2#money.rmb_total),
			%% 回调任务
			%?MSG_ECHO("~p",[Money2]),
			Player3		 = task_api:pay(Player2, Money2#money.rmb_total),
			Player3
	end;
give_pay_cb(#player{money=Money,uid=Uid} = Player, [Rmb,BindRmb]) ->
	%% 调用vip接口更新vip等级数据
	Money1 = Money#money{rmb_bind = Money#money.rmb_bind+BindRmb,
						 rmb      = Money#money.rmb+Rmb,
						 rmb_total= Money#money.rmb_total+Rmb},
	case Money1 of
		Money  -> %% 没变化
			?MSG_ECHO("~p",[Money]),
			Player#player{money=Money};
		Money1 ->
			Money2  = role_db:money(Uid, Money1),
			BinMsg 	= role_api:msg_currency(Money2#money.gold, Money2#money.rmb, Money2#money.rmb_bind),
			BinMsg2 = system_api:msg_error(?ERROR_PAY_OK),
			app_msg:send(Player#player.socket, <<BinMsg/binary,BinMsg2/binary>>),
			%% 小于 0 时 更新一下mysql 
			if
				Rmb < 0 andalso Money2#money.rmb < Money#money.rmb ->
					role_api:currency_update(Uid, [{rmb_bind,Money2#money.rmb_bind},{rmb,Money2#money.rmb},{rmb_total,Money2#money.rmb_total}]);
				?true -> 
					?skip
			end,
			%% ?IF(Rmb < 0 andalso Money2#money.rmb < Money#money.rmb, role_api:update_money(Sid, Uid, [{rmb_bind,Money2#money.bind_rmb},{rmb,Money2#money.rmb},{rmb_total,Money2#money.total_rmb}]) , ?skip),
			Player2 	 = vip_api:buy_rmb(Player#player{money = Money2},Money2#money.rmb_total),
			%% 回调任务
			?MSG_ECHO("~p",[Money2]),
			Player3		 = task_api:pay(Player2, Money2#money.rmb_total),
			card_api:sales_notice(Player3), 
			Player4		 = role_api:pay_frist(Player3,Rmb),
			Player4
	end.

% 添加元宝
give_rmb(Uid,Rmb)-> 
	?MSG_ECHO("=============",[]),
	case role_api:is_online(Uid) of
		?true ->
			util:pid_send(Uid, ?MODULE, give_rmb_cb, Rmb);
		_ ->
			ets:delete(?ETS_OFFLINE, Uid),	
			Sql = "select rmb from user where uid=" ++ util:to_list(Uid),
			case mysql_api:select(Sql) of
				{?ok, [Rmb0]} ->
					NewRmb = Rmb0 + trunc(abs(Rmb)),
					mysql_api:update(user, [{rmb, NewRmb}]),
					?ok;
				_ ->
					?false
			end
	end. 
% 添加元宝  回调
give_rmb_cb(Player, Rmb)->
	{Player2, BinMsg} = role_api:currency_add([give_rmb,[],<<"">>],Player, [{?CONST_CURRENCY_RMB, trunc(abs(Rmb))}]),
	app_msg:send(Player2#player.socket, BinMsg),
	Player2.

% 添加绑定元宝
give_point(Uid,BindRmb)->
	case role_api:is_online(Uid) of
		?true ->
			util:pid_send(Uid, ?MODULE, give_point_cb, BindRmb);
		_ ->
			ets:delete(?ETS_OFFLINE, Uid),	
			Sql = "select rmb_bind from user where uid=" ++ util:to_list(Uid),
			case mysql_api:select(Sql) of
				{?ok, [BindRmb0]} ->
					NewBindRmb = BindRmb0 + trunc(abs(BindRmb)),
					mysql_api:update(user, [{rmb_bind, NewBindRmb}]),
					?ok;
				_ ->
					?false
			end
	end. 
% 添加绑定元宝  回调
give_point_cb(Player, BindRmb)->
	{Player2, BinMsg} = role_api:currency_add([give_point_cb,[],<<"">>],Player, [{?CONST_CURRENCY_RMB_BIND, trunc(abs(BindRmb))}]),
	app_msg:send(Player2#player.socket, BinMsg),
	Player2.


%% GM加经验
give_exp(Uid,Exp)->
	case role_api:is_online(Uid) of
		?true ->
			util:pid_send(Uid, ?MODULE, give_exp_cb, Exp);
		_ ->
			ets:delete(?ETS_OFFLINE, Uid),	
			Sql = "select exp from user where uid=" ++ util:to_list(Uid),
			case mysql_api:select(Sql) of
				{?ok, [Exp0]} ->
					NewExp = Exp0 + trunc(abs(Exp)),
					mysql_api:update(user, [{exp, NewExp}]),
					?ok;
				_ ->
					?false
			end
	end.
give_exp_cb(Player,Exp)->
	{Player2, BinMsg} = role_api:currency_add([give_exp_cb,[],<<"">>],Player, [{?CONST_CURRENCY_EXP, trunc(abs(Exp))}]),
	app_msg:send(Player2#player.socket, BinMsg),
	Player2.
	

% 增加金币
% Type = ?CONST_CURRENCY_GOLD | ?CONST_CURRENCY_GOLD_BIND
give_gold(Uid,Gold,_IsBind)->
	case role_api:is_online(Uid) of
		?true ->
			util:pid_send(Uid, ?MODULE, give_gold_cb, Gold);
		_ ->
			ets:delete(?ETS_OFFLINE, Uid),	
			Sql = "select gold from user where uid=" ++ util:to_list(Uid),
			case mysql_api:select(Sql) of
				{?ok, [Gold0]} ->
					NewGold = Gold0 + trunc(abs(Gold)),
					mysql_api:update(user, [{gold, NewGold}]),
					?ok;
				_ ->
					?false
			end
	end.
% 回调加金币
give_gold_cb(Player, Gold) ->
	{Player2, BinMsg} = role_api:currency_add([give_gold_cb,[],<<"">>],Player, [{?CONST_CURRENCY_GOLD, trunc(abs(Gold))}]),
	app_msg:send(Player2#player.socket, BinMsg),
	Player2.


%% 给指定玩家发放物品
%% 返回值：成功|?ok  失败|{?error,ErrorCode}
give_goods(Uid,GoodsGive)->	
	case bag_api:goods(GoodsGive) of
		#goods{} = Goods ->
			case role_api:is_online(Uid) of
				?true ->
					util:pid_send(Uid, ?MODULE, give_goods_cb, Goods);
				_ ->
					?false
			end;
		_ ->
			?false
	end.

% 回调获得物品
give_goods_cb(Player,Goods) ->
	case bag_api:goods_set([give_goods_cb,[],<<"后台给予">>], Player, [Goods]) of
		{?ok, Player2,GoodsBin,BinMsg} ->
			app_msg:send(Player2#player.socket, <<GoodsBin/binary,BinMsg/binary>>),
			Player2;
		{?error, _ErrorCode} ->
			Player
	end.

  
%% 开放系统
open_sys(Uid, TaskId) ->
	util:pid_send(Uid, ?MODULE, open_sys_cb, TaskId).

%% 开放系统---回调函数
open_sys_cb(Player, TaskId) ->
	role_api:sys_task(Player, TaskId),
	Player.


%% 精彩活动 开放/关闭 
sales_time_setup(SalesId,IsHave,Times)->
	card_api:sales_time_setup(SalesId,IsHave,Times).
%% 精彩活动 读取
sales_time_read()->
	Sales     = card_api:sales_time_read(),
	Sales2    = [{obj,[{id,		SalesTotal#d_sales_total.id},
					   {is_have,SalesTotal#d_sales_total.is_have},
					   {valid,	SalesTotal#d_sales_total.valid},
					   {s_id,	SalesTotal#d_sales_total.s_id},
					   {time,	sales_time_read_time(SalesTotal#d_sales_total.time,[])}]} || SalesTotal <- Sales,is_record(SalesTotal,d_sales_total)],
%% 	?MSG_ERROR("============== ~w~n",[json:encode(Sales2)]),
 	json:encode(Sales2).
%% 
sales_time_read_time([],Rs)->Rs;
sales_time_read_time([{StartM,StartD,StartH,StartI,StartS,EndM,EndD,EndH,EndI,EndS}|Times],Rs)->
	T = [StartM,StartD,StartH,StartI,StartS,EndM,EndD,EndH,EndI,EndS],
	sales_time_read_time(Times,[T|Rs]);
sales_time_read_time([{open,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS}|Times],Rs)->
	T = [<<"open">>,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS],
	sales_time_read_time(Times,[T|Rs]);
sales_time_read_time([{week,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS}|Times],Rs)->
	T = [<<"week">>,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS],
	sales_time_read_time(Times,[T|Rs]);
sales_time_read_time([{month,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS}|Times],Rs)->
	T = [<<"month">>,StartD,StartH,StartI,StartS,EndD,EndH,EndI,EndS],
	sales_time_read_time(Times,[T|Rs]).

%% 清除所有的活动数据,重新读配置表
clear_mysql() ->
	active_api:clear_mysql().

%%　设置活动状态 -- 新增|修改		活动ID,活动类型,   日期限制,      星期限制,    时间限制{时,分,秒,状态,参数}, 人物等级,?一直显示,?开启时主界面弹出入口图标
%%　active_api:set_active({4009,4,[{{2013,7,1},{2013,8,1}}],[6,7],[{17,53,59,3,30},{17,54,59,3,10},{17,55,59,2,1},{17,58,59,1,30},{17,57,59,0,0}],30,1,1}).
set_active(ActiveId,Show,Dates,Weeks,Times) ->
	active_api:set_active({ActiveId,3,Dates,Weeks,Times,1,Show,1}).

%%　设置活动状态 -- 临时加开		活动ID,活动类型,   日期限制,      星期限制,    时间限制{时,分,秒,状态,参数}, 人物等级,?一直显示,?开启时主界面弹出入口图标
%%　active_api:temp_active({4009,4,[{{2013,7,1},{2013,8,1}}],[6,7],[{17,53,59,3,30},{17,54,59,3,10},{17,55,59,2,1},{17,58,59,1,30},{17,57,59,0,0}],30,1,1}).
temp_active(ActiveId,Show,Dates,Weeks,Times) ->
	active_api:temp_active({ActiveId,3,Dates,Weeks,Times,1,Show,1}).


%% 活动面板数据
%% [{3003,3,[], [7], [{15,30,0,3,30}, {15,59,0,3,1}, {15,59,0,2,1}, {16,0,0,1,30}, {16,30,0,0,0}],  40,1,1},
%%  {3002,3,[], [6], [{15,0,0,4,1}, {15,30,0,4,0}, {15,59,0,3,1}, {15,59,0,2,1}, 16,0,0,1,60}, {17,0,0,0,0}], 40,1,1},
%%  {3001,3,[], [], [{14,30,0,3,30}, {14,59,0,3,1}, {14,59,0,2,1}, {15,0,0,1,30}, {15,30,0,0,0}], 20,1,1}]
get_acty_lists() ->
	AllActive = active_mod:get_allactive(),
	AllActive2 = [{obj,[{id,		Id},
						{type,		Type},
						{ymd,		[[SY,SM,SD,EY,EM,ED]||{{SY,SM,SD},{EY,EM,ED}} <- Ymd]},
						{week,		Week},
						{time,		[[H,I,S,State,Arg]||{H,I,S,State,Arg} <- Time]}
					   ]} 
				  || {Id,Type,Ymd,Week,Time,_Lv,_Show,_IsHave} <- AllActive],
	json:encode(AllActive2).

%% 指定活动数据
get_acty_date(ID) ->
	AllActive = active_mod:get_allactive(),
	case lists:keyfind(ID, 1, AllActive) of
		{ID,Type,Ymd,Week,Time,_Lv,_Show,_IsHave} ->
			Active = [{obj,
					   [{id,		ID},
						{type,		Type},
						{ymd,		[[SY,SM,SD,EY,EM,ED]||{{SY,SM,SD},{EY,EM,ED}} <- Ymd]},
						{week,		Week},
						{time,		[[H,I,S,State,Arg]||{H,I,S,State,Arg} <- Time]}
					   ]}],
			json:encode(Active);
		_ ->
			json:encode({obj, []})
	end.


%% Call 玩家数据
progress_callback(Mpid, Mod, Fun, Arg) ->
	Ref	= make_ref(),
	case util:pid_send(Mpid, Mod, Fun, {self(),Ref,Arg}) of
		?true 	->
			receive  {Ref, Data} -> {?ok,Data}
			after ?CONST_OUTTIME_PID -> ?null
			end;
		?false 	->
			?null 
	end.

% 得到玩家，现在数据
user_info(_Sid,Uid)->
	case role_api:mpid(Uid) of
		MPid when is_pid(MPid) ->
			case progress_callback(MPid, ?MODULE, user_info_cb, ?null) of
				{?ok,Info}  -> Info;
				_null -> ?false
			end;
		?undefined ->
			case role_api_dict:player_get(Uid) of
				{?ok,Player} ->
					user_info_acc(Player,?false);
				_ ->
					?false
			end
	end.
user_info_cb(Player,{From, Ref, _null})->
	Info = user_info_acc(Player,?true),
	util:pid_send(From, {Ref, Info}),
	Player.

%%　玩家在线
user_info_acc(Player, ?true) -> 
	Bag			= role_api_dict:bag_get(),
	Douqi		= role_api_dict:douqi_get(),
	Equip		= role_api_dict:equip_get(),
	Inn			= role_api_dict:inn_get(),
	Energy      = role_api_dict:energy_get(),
	InfoData	= user_info_data(Player, [Bag, Douqi,Equip,Inn,Energy]),
	Info2 		= {obj,InfoData},
	json:encode(Info2);

%% 玩家离线
user_info_acc(#player{uid=Uid}=Player,?false) -> 
	{?ok, Bag}	 = role_api_dict:bag_get(Uid),
	{?ok, Douqi} = role_api_dict:douqi_get(Uid),
	{?ok, Equip} = role_api_dict:equip_get(Uid),
	{?ok, Inn}	 = role_api_dict:inn_get(Uid),
	{?ok, Energy} = role_api_dict:energy_get(Uid),
	InfoData	= user_info_data(Player, [Bag, Douqi,Equip,Inn,Energy]),
	Info2 		= {obj,InfoData},
	json:encode(Info2).

user_info_data(Player, [Bag, Douqi,Equip,Inn,Energy]) ->
	[
	 {bag,		bag_data(Bag)},
	 {player,	player_data(Player)},
	 {douqi, 	douqi_data(Douqi)},
	 {equip,	equip_data(Equip,Inn)},
	 {clan,		clan_data(Player#player.uid)},
	 {energy,	energy_data(Energy)}
	 ].

%%　背包数据
bag_data(Bag) ->
	F = fun(#goods{id = ID, goods_id = Gid, name_color = Gcolor,count=Count,exts=Exts}, Acc) ->
				N= ?IF(erlang:is_record(Exts, g_eq),Exts#g_eq.streng,0),
				[{obj, [{id,ID},{goods_id,Gid},{gcolor,Gcolor},{count,Count},{streng,N}]}|Acc]
		end,
	lists:foldl(F, [], (Bag#bag.list)).
%% 人物数据
player_data(Player) ->
	#player{uname=Name,uname_color=NameColor,lv=Lv,pro=Pro,attr=Attr,info=Info,money = Money} = Player,   
	#attr{anima=Anima,		bonus=Bonus,			crit=Crit,				crit_harm=CritHarm,		crit_res=CtirRes,
		  dark=Dark,		dark_def=DarkDef,		defend_down=DefDown,	god=God,				god_def=GodDef,
		  hp=Hp,			hp_gro=HpGro,			imm_dizz=ImmDizz,		light=Light,			light_def=LightDef,
		  magic=Magic,		magic_gro=MagicGro, 	reduction=Reduction,	skill_att=SkillAttr,	skill_def=SkillDef,
		  sp=Sp,			sp_up=SpUp,		    	strong=Strong,			strong_att=StrongArr,	strong_def=StrongDef,
		  strong_gro=StrongGro} = Attr,
	#money{gold = Gold,rmb = Rmb} = Money,
	#info{renown = Renown,power = Power} = Info,
	[{obj, [{name,Name},		{name_color,NameColor},		{exp,Info#info.exp_total},	{lv,Lv}, 				{pro, Pro},
			{gold,Gold},        {rmb,Rmb},                  {renown,Renown},            {power,Power},
			{anima, Anima},		{bonus, Bonus},				{crit, Crit},				{crit_harm, CritHarm},	{crit_res, CtirRes},
			{dark, Dark},		{dark_def, DarkDef},		{defend_down, DefDown},		{god, God},				{god_def, GodDef},
			{hp, Hp},			{hp_gro, HpGro},			{imm_dizz, ImmDizz},		{light, Light},			{light_def, LightDef},
			{magic, Magic},		{magic_gro, MagicGro},		{reduction, Reduction},		{skill_att, SkillAttr},	{skill_def, SkillDef},
			{sp, Sp},			{sp_up, SpUp},				{strong, Strong},			{strong_att, StrongArr},{strong_def, StrongDef},
			{strong_gro, StrongGro}]}].
%%　斗气数据
douqi_data(Douqi) ->	
 	#douqi{gold_times= GoldTimes, rmb_times = RmbTimes,adam_war = AdamWar,
		   sto_equip = StoEquip, sto_temp = StoTemp} = Douqi,
	Fun = fun(#dq_data{role_id=RoleId,lan_id=LanId,dq_type=DqTpye,dq_lv=DqLv,dq_exp=DqExp},Acc) ->
			[{obj, [{role_id,RoleId},{lan_id,LanId},{dq_type,DqTpye},{dq_lv,DqLv},{dq_exp,DqExp}]}|Acc];
		   (_, Acc) ->
				Acc
		end,
	DouqiBase = [{obj,[{gold_times, GoldTimes},{rmb_times, RmbTimes},{adam_war, AdamWar}]}],
	lists:foldl(Fun, DouqiBase, StoEquip++StoTemp).

%% 装备
equip_data(Equip,Inn)->
	RoleEquip=equip_term(Equip),
	PS=equip_inn(Inn#inn.partners,[]),
	P=equip_slots(PS,partner),
	?IF(Inn#inn.partners==[],[{obj,[{role,RoleEquip},{partner,0}]}],[{obj,[{role,RoleEquip},{partner,P}]}]).

equip_term(Equip)->
	Fun=fun(#goods{goods_id=GoodsId,exts=Exts},Acc)->
				case is_record(Exts,g_eq) of
					?true->
						Ids=[Id||{_,Id,_}<-Exts#g_eq.slots,Id=/=0],
						Slots=equip_slots(Ids,slots),
						[{obj,[{goods_id,GoodsId},{streng,Exts#g_eq.streng},{slots,Slots},{enchant,Exts#g_eq.enchant}]}|Acc];
					_->
						[{obj,[{goods_id,GoodsId},{streng,0},{slots,0},{enchant,0}]}|Acc]
				end
		end,
	lists:foldl(Fun,[],Equip).

equip_slots(Ids,Flag)->
	Fun=fun(Id,{Acc,N,L})->
				String=util:term_to_string(Acc)++util:term_to_string(N),
				Term=util:string_to_term(String),
				{Acc,N+1,[{Term,Id}|L]}
		end,
	{_,_,Slots2}=lists:foldl(Fun,{Flag,1,[]},Ids),
	[{obj,Slots2}].

equip_inn([],Acc)->Acc;
equip_inn([Partner|Partners],Acc)->
	#partner{partner_id=PartnerId,equip=Equip}=Partner,
	Pequip=equip_term(Equip),
	Pequip2=[{obj,[{partner_id,PartnerId},{equip,Pequip}]}],
	equip_inn(Partners,[Pequip2|Acc]).

clan_data(Uid) ->
	case clan_mod:get_clan_mem(Uid) of
		#clan_mem{devote_sum=DevoteSum,post=Post,clan_id=ClanId} ->
			case clan_mod:get_clan4id(ClanId) of
				#clan_public{clan_name=ClanName} ->
					?ok;
				_ ->
					ClanName = <<"">>
			end,
			[{obj,[{devote_sum,DevoteSum},{post,Post},{clan_name,ClanName},{clan_id,ClanId}]}];
		_ ->
			[{obj,[{devote_sum,0},{post,0},{clan_name,<<"">>},{clan_id,0}]}]
	end.

energy_data(Energy) ->
	#energy{energy_value = EnergyValue,buff_value = BuffValue} = Energy,
	[{obj,[{energyvalue,EnergyValue + BuffValue}]}].


%% 	#inn{partners = Partners} = Inn,
%% 	#arena{moil=Moil} = Arena,
%% 	Pilroad =
%% 		case Info#info.pilroad of
%% 			PilR when is_record(PilR, pilroad) ->
%% 				PilR;
%% 			_ ->
%% 				BlackShop=#black_shop{re_time=0,re_goods=[],re_count=0},
%% 				#pilroad{chap_id= 1,use_id= 0,black_shop=BlackShop}
%% 		end,
%% 	Qkweagod	=vip_api:check_fun(Info#info.vip, #d_vip.fun_qkweagod),
%% 	ArenaRank	=arena_api:arena_get_rank(Uid),
%% 	{_,Kgexp,_}	=moil_api:moil_captrue(Moil, Info#info.lv),
%% 	Devote = case db:clan_mem_select(Uid) of
%% 				 #clan_mem{devote_sum = Ds} -> Ds;
%% 				 						_ 	-> 0
%% 			 end,
%% 	EnergyMax = energy_api:max_energy(Info),
%% 	{_, EnergyCount} = energy_api:buy_value(Player),
%% 	{_CircleC1, CircleC2} = circle_api:circle_sum(Player#player.circle, Info#info.vip),
%% 	
%% 	FunF1=fun(#goods{goods_id = Gid, name_color = Gcolor,exts=Exts}, Acc) ->
%% 				  case Exts of
%% 					  Geq when erlang:is_record(Geq, g_eq) ->
%% 						  [{obj, [{goods_id,Gid},{gcolor,Gcolor},{streng,Geq#g_eq.streng}]}|Acc];
%% 					  _ ->
%% 						  [{obj, [{goods_id,Gid},{gcolor,Gcolor},{streng,0}]}|Acc]
%% 				  end
%% 		  end,
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 以上准备，以下正式字段 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%% 	FriendL = [],
%% 	L_Equip = lists:foldl(FunF1, [], PlyEquip),
%% 	L_Bag = lists:foldl(fun(#goods{id = ID, goods_id = Gid, name_color = Gcolor,count=Count,exts=Exts}, Acc) ->
%% 								N= ?IF(erlang:is_record(Exts, g_eq),Exts#g_eq.streng,0),
%% 								  [{obj, [{id,ID},{goods_id,Gid},{gcolor,Gcolor},{count,Count},{streng,N}]}|Acc]
%% 						  end, [], (Player#player.bag)#bag.list),
%% 	L_Partner=lists:foldl(fun(#partner{partner_id=PartnerID, exp=PartnerExp, hp = PartnerHp, state = PartnerState, lv = PartnerLv,
%% 									   position = PartnerPosition, skill = PartnerSkill, attr = PartnerAttr, equip = PartnerEquip},Acc)->
%% 								  L_Partner1=[{partner_id,PartnerID},{exp,PartnerExp},{hp,PartnerHp},{lv,PartnerLv},{state,PartnerState},
%% 											  {position,PartnerPosition},{skill,PartnerSkill},
%% 											  {strong_att,PartnerAttr#attr.strong_att},{strong_def,PartnerAttr#attr.strong_def},
%% 											  {magic_att,PartnerAttr#attr.magic_att},{magic_def,PartnerAttr#attr.magic_def},
%% 											  {att_speed,PartnerAttr#attr.att_speed},{res_crit,PartnerAttr#attr.res_crit},
%% 											  {crit,PartnerAttr#attr.crit},{dod,PartnerAttr#attr.dod},{hit,PartnerAttr#attr.hit},
%% 											  {parry,PartnerAttr#attr.parry},{wreck,PartnerAttr#attr.wreck}],
%% 								  L_Partner2=get_pinfen(PartnerID,PartnerEquip),
%% 								  L_Partner3=L_Partner1++L_Partner2 ++ [{partnerequip,lists:foldl(FunF1, [], PartnerEquip)}],
%% 								  [{obj,L_Partner3}|Acc]
%% 						  end,[],Partners),
%% 	L_Player=[{obj, [{name,Info#info.name},{name_color,Info#info.name_color},{exp,Save#save.exp},{hp,Save#save.hp},{lv,Info#info.lv},
%% 					 {pro,Info#info.pro},
%% 					 {strong_att,PlyAttr#attr.strong_att},{strong_def,PlyAttr#attr.strong_def},
%% 					 {magic_att,PlyAttr#attr.magic_att},{magic_def,PlyAttr#attr.magic_def},
%% 					 {att_speed,PlyAttr#attr.att_speed},{res_crit,PlyAttr#attr.res_crit},
%% 					 {crit,PlyAttr#attr.crit},{dod,PlyAttr#attr.dod},{hit,PlyAttr#attr.hit},
%% 					 {parry,PlyAttr#attr.parry},{wreck,PlyAttr#attr.wreck}]++get_pinfen(0,PlyEquip)}],
%% 	L_Com = [
%% 			  {clan_name,Info#info.clan_name},
%% 			  {task_rand_lack,?CONST_TASK_RAND_MAX_ACCEPT - TaskRand#task_rand.count},
%% 			  {energy_current, Energy#energy.energy_value},
%% 			  {energy_max,EnergyMax},
%% 			  {task_rand_last,TaskRand#task_rand.seconds},
%% 			  {skill,Info#info.skill_id},
%% 			  {devote,Devote},
%% 			  {energy_count, EnergyCount},
%% 			  {energy_buy, Energy#energy.num},
%% 			  {task_rand_count,TaskRand#task_rand.count},  
%% 			  {arena_count, arena_api:arena_war_count(Arena)},
%% 			  {mount_lv, (Player#player.mount)#mount.lv},
%% 			  {mount_exp, (Player#player.mount)#mount.exp},
%% 			  {clan_id, Info#info.clan},
%% 			  {clan_boss, (Player#player.clan_boss)#clan_boss.call_count},
%% 			  {soul_blue, Save#save.blue_soul},
%% 			  {soul_orange, Save#save.orange_soul},
%% 			  {soul_golden, Save#save.golden_soul},
%% 			  {soul_violet, Save#save.violet_soul},
%% 			  {soul_red, Save#save.red_soul},
%% 			  {bag_count, (Player#player.bag)#bag.max},
%% 			  {moil_count, length(((Player#player.arena)#arena.moil)#moil.moil_data)},
%% 			  {circle_chap,(Player#player.circle)#circle.chap},
%% 			  {circle_id,(Player#player.circle)#circle.id},
%% 			  {circle_reset, CircleC2},
%% %% 			  {target_serial,(Player#player.target)#target.serial},
%% 			  {sign_last, ?IF(Info#info.vip >= 3, (Player#player.sign)#sign.date2, (Player#player.sign)#sign.date1)},
%% 			  {arena, ArenaRank},
%% 			  {renexp, Renown#renown.exp},
%% 			  {renlv, Renown#renown.renown_lv},
%% 			  {renpaydate, Renown#renown.date1},
%% 			  {matrix, Matrix#matrix.star_tried},
%% 			  {energydate2, Energy#energy.date2},
%% 			  {energyvalue, Energy#energy.energy_value},
%% 			  {alweatimes, Weagod#weagod.alweatimes},
%% 			  {alcentimes, Weagod#weagod.alcentimes},
%% 			  {cenfri, length(Weagod#weagod.cenfri)},
%% 			  {weagoddate, list_to_integer(Weagod#weagod.date)},
%% 			  {qkweagod, Qkweagod},
%% 			  {kgexp, Kgexp}, % 苦工可提取的经验
%% 			  {blackshop, (Pilroad#pilroad.black_shop)#black_shop.re_time}
%% 			 
%% %% 			  {pt,[{obj,[{v1,V1},{v2,V2}]},
%% %% 				   {obj,[{v1,V1},{v2,V2}]}
%% %% 				  ]
%% %% 			  }
%% 			 ],
%% 	Info2 = {obj,L_Com ++ [{plyequip,L_Equip},{friend,FriendL},{equip,L_Equip},{bag,L_Bag},{partner,L_Partner},{player,L_Player}]},
%% 	json:encode(Info2); 
%% 
%% user_info(_Player) ->
%% 	?MSG_ERROR("_Player:~p",[_Player]),
%% 	?false.
%% % 获取装备评分数据
%% get_pinfen(ID, Equip) ->
%% 	case role_api:get_score(ID, Equip) of
%% 		{ScoreEq,ScorePear,ScoreJew,ScoreMag} ->
%% 			[{powerful,ScoreEq},{pearl_score,ScorePear},{score_jew,ScoreJew},{score_mag,ScoreMag}];
%% 		_ ->
%% 			[{powerful,0},{pearl_score,0},{score_jew,0},{score_mag,0}]
%% 	end.
%% %% 后台查看玩家数据
%% player_data(_Sid) ->
%% 	Fields	= [uuid,uname,name_color,pro,sex,country,lv,vip,gold,rmb,rmb_bind,rmb_total],
%% 	case mysql_api:select(Fields,user,[]) of 
%% 		{?ok, [_|_] = L} ->
%% 			L;
%% 		_ ->
%% 			[]
%% 	end.
%% 	
%% player_data(_Sid, Uid) ->
%% 	case role_api_dict:player_get(Uid) of
%% 		{?ok, #player{} = Player} ->
%% 			{?ok, Player};
%% 		_ ->
%% 			?false
%% 	end.
%% 
%% 
%% 
%% active_integral(Time) ->?MSG_ECHO("xxxTime : ~p~n", [Time]),
%% 	activity_api:ctrl_acty_date(?CONST_ACTIVITY_INTEGRAL_COST, Time).
%% 	
%% set_integral(Flag0) ->
%% 	Flag = ?IF(Flag0 == ?CONST_TRUE, Flag0, ?CONST_FALSE),
%% 	activity_api:ctrl_set_flag(?CONST_ACTIVITY_INTEGRAL_COST, Flag).
%% 
%% 
%% get_acty_date(ID) ->
%% 	Ids = data_acty_date:get_ids(),
%% 	case lists:member(ID, Ids) of
%% 		?true ->
%% 			#d_acty_date{time = Time} = data_acty_date:get(ID),
%% 			{Flag, Time2} = activity_api:ctrl_get(ID),
%% 			TimeData = Time ++ Time2,
%% 			L = lists:foldl(fun({Ys,Ms,Ds,Hs,Is,Ss,Ye,Me,De,He,Ie,Se},Acc) ->
%% 									SecondsS = util:datetime2timestamp(Ys, Ms, Ds, Hs, Is, Ss),
%% 									SecondsE = util:datetime2timestamp(Ye, Me, De, He, Ie, Se),
%% 									[{obj, [{seconds_s, SecondsS}, {seconds_e, SecondsE}]}|Acc];
%% 							   (_, Acc) ->
%% 									Acc
%% 							end, [], TimeData),
%% 			json:encode([{obj, [{flag, Flag}]}|L]);
%% 		?false ->
%% 			json:encode({obj, []})
%% 	end.
%% 	
%% 
%% get_integral() ->
%% 	get_acty_date(?CONST_ACTIVITY_INTEGRAL_COST).












