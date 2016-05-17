%% Author: acer
%% Created: 2012-12-17
%% Description: TODO: Add description to logs_api
-module(logs_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

%%
%% Exported Functions
%%
-export([decode_logs/1,
		 encode_logs/1,
		 
		 login/1,
		 insert/2,
		 
		 event_notice/4,	% 获得|失去物品通知
		 event_notice/3,	% 获得|失去物品列表通知
		 task_notice/2,		% 与任务有关的动作通知
		 lv_notice/2,		% 与等级有关的动作通知
		 action_notice/4,	% 动作通知[玩家可能不在线时，需保存的日志信息]

		 buff_notice/2,		% 得到|失去 Buff通知
		 attr_change/2,		% 属性改变通知
		 
		 msg_event/3,
		 msg_notices/3
		]).

encode_logs(Logs) ->
	Logs.

decode_logs(Logs) ->
	Logs.

% 登陆后检查是否有日志信息
login(#player{uid=Uid,socket=Socket}=Player) ->
	case ets:lookup(?ETS_M_LOGS, Uid) of
		[#logs{uid=Uid,bin=BinLogs}|_] -> 
			app_msg:send(Socket, BinLogs),
			ets:delete(?ETS_M_LOGS, Uid);
		_ ->
			?skip
	end,
	Player.

%% 玩家不在线 存日志
%% reg：{Uid, BinMsg}
%% retrun: ?ok
insert(Uid, BinMsg) when is_binary(BinMsg) ->
	case ets:lookup(?ETS_M_LOGS, Uid) of
		[#logs{uid=Uid,bin=BinLogs}=Logs|_] ->
			ets:insert(?ETS_M_LOGS, Logs#logs{bin= <<BinLogs/binary,BinMsg/binary>>});
		_ ->
			ets:insert(?ETS_M_LOGS, #logs{uid=Uid,bin=BinMsg})
	end;
insert(_Uid, BinMsg) ->
	?MSG_ECHO("---------Error-BinMsg:~w~n",[BinMsg]),
	?ok.

%% 属性改变通知
%% reg:		{Player,NewPlayer}	|
%%			{Mount,NewMount} 	| 
%%			{Partners,NewPartners} | 
%%			{Attr,NewAttr}
%% retrun	BinMsg 
attr_change(Player,NewPlayer) when is_record(Player, player)->
	attr_change(Player#player.attr,NewPlayer#player.attr);
attr_change(Mount,NewMount) when is_record(Mount, mount) ->
	Bin1=attr_change(Mount#mount.mount_attr,NewMount#mount.mount_attr),
	Bin2=attr_change(Mount#mount.prop_attr,NewMount#mount.prop_attr),
	<<Bin1/binary,Bin2/binary>>;
attr_change(Partner,NewPartner) when is_record(Partner, partner) ->
	attr_change(Partner#partner.attr,NewPartner#partner.attr);
attr_change(Attr,NewAttr) when is_record(Attr, attr) ->
	attr_change_acc(Attr,NewAttr);
attr_change(_,_) -> <<>> .

%% attr_change_acc(Attr,NewAttr) ->
%% 	#attr{anima=Anima,				bonus=Bonus,			crit=Crit,				crit_harm=CritHarm,
%% 		  crit_res=CritRes,			dark=Dark,				dark_def=DarkDef,		defend_down=DefendDown,
%% 		  god=God,					god_def=GodDef,			hp=Hp,					hp_gro=HpGro,
%% 		  imm_dizz=ImmDizz,			light=Light,			light_def=LightDef,		magic=Magic,
%% 		  magic_gro=MagicGro,		reduction=Reduction,	skill_att=SkillAtt,		skill_def=SkillDef,
%% 		  sp=Sp,					sp_up=SpUp,				strong=Strong,			strong_att=StrongAtt,
%% 		  strong_def=StrongDef,		strong_gro=StrongGro}	= Attr,
%% 	#attr{anima=Anima2,				bonus=Bonus2,			crit=Crit2,				crit_harm=CritHarm2,
%% 		  crit_res=CritRes2,		dark=Dark2,				dark_def=DarkDef2,		defend_down=DefendDown2,
%% 		  god=God2,					god_def=GodDef2,		hp=Hp2,					hp_gro=HpGro2,
%% 		  imm_dizz=ImmDizz2,		light=Light2,			light_def=LightDef2,	magic=Magic2,
%% 		  magic_gro=MagicGro2,		reduction=Reduction2,	skill_att=SkillAtt2,	skill_def=SkillDef2,
%% 		  sp=Sp2,					sp_up=SpUp2,			strong=Strong2,			strong_att=StrongAtt2,
%% 		  strong_def=StrongDef2,	strong_gro=StrongGro2}	= NewAttr,
%% 	List=[{Anima,			Anima2,			?CONST_ATTR_ANIMA		},
%% 		  {Bonus,			Bonus2,			?CONST_ATTR_BONUS		},
%% 		  {Crit,			Crit2,			?CONST_ATTR_CRIT		},
%% 		  {CritHarm,		CritHarm2,		?CONST_ATTR_CRIT_HARM	},
%% 		  {CritRes,			CritRes2,		?CONST_ATTR_RES_CRIT	},
%% 		  {Dark,			Dark2,			?CONST_ATTR_DARK		},
%% 		  {DarkDef,			DarkDef2,		?CONST_ATTR_DARK_DEF	},
%% 		  {DefendDown,		DefendDown2,	?CONST_ATTR_DEFEND_DOWN	},
%% 		  {God,				God2,			?CONST_ATTR_GOD			},
%% 		  {GodDef,			GodDef2,		?CONST_ATTR_GOD_DEF		},
%% 		  {Hp,				Hp2,			?CONST_ATTR_HP			},
%% 		  {HpGro,			HpGro2,			?CONST_ATTR_HP_GRO		},
%% 		  {ImmDizz,			ImmDizz2,		?CONST_ATTR_IMM_DIZZ	},
%% 		  {Light,			Light2,			?CONST_ATTR_LIGHT		},
%% 		  {LightDef,		LightDef2,		?CONST_ATTR_LIGHT_DEF	},
%% 		  {Magic,			Magic2,			?CONST_ATTR_MAGIC		},
%% 		  {MagicGro,		MagicGro2,		?CONST_ATTR_MAGIC_GRO	},
%% 		  {Reduction,		Reduction2,		?CONST_ATTR_REDUCTION	},
%% 		  {SkillAtt,		SkillAtt2,		?CONST_ATTR_SKILL_ATT	},
%% 		  {SkillDef,		SkillDef2,		?CONST_ATTR_SKILL_DEF	},
%% 		  {Sp,				Sp2,			?CONST_ATTR_SP			},
%% 		  {SpUp,			SpUp2,			?CONST_ATTR_SP_UP		},
%% 		  {Strong,			Strong2,		?CONST_ATTR_STRONG		},
%% 		  {StrongAtt,		StrongAtt2,		?CONST_ATTR_STRONG_ATT	},
%% 		  {StrongDef,		StrongDef2,		?CONST_ATTR_STRONG_DEF	},
%% 		  {StrongGro,		StrongGro2,		?CONST_ATTR_STRONG_GRO	}],
%% 	d_value(List).
%% 
%% d_value(List) ->
%% 	d_value([],[],List).
%% 
%% d_value(TList,FList,[]) -> 
%% 	Bin1=?IF(TList=:=[],<<>>,msg_notices(?CONST_LOGS_TYPE_ATTR, ?CONST_LOGS_ADD, TList)),
%% 	Bin2=?IF(FList=:=[],<<>>,msg_notices(?CONST_LOGS_TYPE_ATTR, ?CONST_LOGS_DEL, FList)),
%% 	<<Bin1/binary,Bin2/binary>>;
%% d_value(TList,FList,[{Att,Att2,Const}|List]) ->
%% 	Value=Att2-Att,
%% 	if  
%% 	 	Value > 0 -> TList2=[{Const,Value}|TList],FList2=FList;
%% 		Value < 0 -> TList2=TList,FList2=[{Const,abs(Value)}|FList];
%% 		Value == 0 -> TList2=TList,FList2=FList
%% 	end,
%% 	d_value(TList2,FList2,List).

attr_change_acc(Attr,NewAttr) ->
	attr_change_acc(Attr, NewAttr, [], [], 1).
attr_change_acc(_AttrOld,AttrNew,TList,FList,N) when N > erlang:size(AttrNew) -> 
	Bin1=?IF(TList=:=[],<<>>,msg_notices(?CONST_LOGS_TYPE_ATTR, ?CONST_LOGS_ADD, TList)),
	Bin2=?IF(FList=:=[],<<>>,msg_notices(?CONST_LOGS_TYPE_ATTR, ?CONST_LOGS_DEL, FList)),
	<<Bin1/binary,Bin2/binary>>;
attr_change_acc(AttrOld,AttrNew,TList,FList,N)->
	AttrO=erlang:element(N, AttrOld),
	AttrN=erlang:element(N, AttrNew),
	if 
		AttrO =:= AttrN ->
			attr_change_acc(AttrOld,AttrNew,TList,FList,N+1);
		AttrO > AttrN ->
			FList2= [{erlang:element(N, ?ATTR_ARG), AttrO-AttrN}|FList],
			attr_change_acc(AttrOld,AttrNew,TList,FList2,N+1);
		AttrO < AttrN ->
			TList2= [{erlang:element(N, ?ATTR_ARG), AttrN-AttrO}|TList],
			attr_change_acc(AttrOld,AttrNew,TList2,FList,N+1)
	end.

% 得到|失去 Buff通知
%% reg:{State		:: State常量：获得CONST_LOGS_ADD|失去CONST_LOGS_DEL
%%		BuffList	:: [{ID(BUFF类型常量), Value :: 数量}]
%% retrun : BinMsg
buff_notice(State,BuffList) -> 
	?IF(BuffList=:=[],<<>>,msg_notices(?CONST_LOGS_TYPE_BUFF, State, BuffList)).

% 获得|失去物品通知
%% reg:{Type  :: 类型常量(虚拟货币、物品) :: ?CONST_LOGS_TYPE_XXX
%%		State :: State常量：获得|失去  :: ?CONST_LOGS_XXX
%%		Id	  :: ID(虚拟货币类型常量 or 物品ID ) :: ?CONST_CURRENCY_XXX
%%		Value :: 数量}
%% reg:{Type,State,Id,Value}
%% retrun : BinMsg
event_notice(Type,States,Id,Value) ->
	?IF(Value==0,<<>>,msg_notices(Type,States,[{Id,Value}])).

% 获得|失去物品列表通知
%% reg:{Type  		:: 类型常量(虚拟货币、物品)  :: ?CONST_LOGS_TYPE_XXX
%%		State 		:: State常量：获得|失去  :: ?CONST_LOGS_XXX
%% 		GoodsList	:: [{Id, Value}|_],
%%		Id	  		:: ID(虚拟货币类型常量 or 物品ID)  :: ?CONST_CURRENCY_XXX
%%		Value 		:: 数量}
%% reg:{Type,State, GoodsList}
%% retrun : BinMsg
event_notice(Type, States, GoodsList) ->
	?IF(GoodsList==[],<<>>,msg_notices(Type,States,GoodsList)). 

 
% 动作通知 [玩家可能不在线时，需保存的日志信息]
%% reg:	   Uid:: 接收日志的玩家UID
%% 			Id:: 事件ID [见日志常量:CONST_LOGS_XXX]
%% 	 StrModule:: 字符串列表	[{Name,Name_color},{帮派名，0}]	--无填[]
%% 	 IntModule:: 整形数字列表 [Lv,Num,...]					--无填[]
%% retrun: ok
%% 例： 你的苦工$被大坏蛋$拐跑了，快去抓回来啊！
%% logs_api:action_notice(Uid,?CONST_LOGS_2011,[{(苦工$=)MTName,MNameColor},{(大坏蛋$=)CName,CNameColor}],[]),
action_notice(Uid,Id,StrModule,IntModule) -> 
	BinMsg=msg_event(Id,StrModule,IntModule),
	case role_api:is_online(Uid) of
		?true -> 
			app_msg:send(Uid, BinMsg);
		?false ->
			?IF(Id > ?CONST_LOGS_END_ID, insert(Uid, BinMsg), ?ok)
	end.

% 与等级有关的日志通知 
lv_notice(Uid,Lv) ->
	case Lv of
		15 -> 
			?IF(check_goods([40086]) == ?true, action_notice(Uid,?CONST_LOGS_1001,[],[]),?ok);
		25 -> 
			?IF(check_goods([40096]) == ?true, action_notice(Uid,?CONST_LOGS_1003,[],[]),?ok);
		30 -> 
			?IF(check_goods([40101]) == ?true, action_notice(Uid,?CONST_LOGS_1004,[],[]),?ok);
		40 ->
			?IF(check_goods([40111]) == ?true, action_notice(Uid,?CONST_LOGS_1005,[],[]),?ok);
		50 -> 
			?IF(check_goods([40121]) == ?true, action_notice(Uid,?CONST_LOGS_1006,[],[]),?ok);
		_ -> 
			?ok
	end.
% 与任务有关的日志通知
task_notice(Uid,TaskID) ->
	case TaskID of
		101710 -> 
			?IF(check_goods([40091]) == ?true, action_notice(Uid,?CONST_LOGS_1002,[],[]),?ok),
			action_notice(Uid,?CONST_LOGS_1106,[],[]);
		_ -> 
			?ok
	end.

%% 检查是否有指定的物品
%%　reg : [GoodsId|_] = GoodsIdList
%% retrun : ?true | ?false
check_goods(GoodsIdList) ->
	case bag_api:get_goods_count(GoodsIdList) of
		[{_, Count}] when is_integer(Count) ->
			Count >= 1;
		[{_, _}|_] = List ->
			length(GoodsIdList) == length([Count||{_,Count} <- List, Count >= 1]);
		_ -> 
			?false
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%Msgxxxxxxxxxxxxxxxxxxxx%%%%%%%%%%%%%%%%%%%%%
% 获得|失去通知 [22760]
msg_notices(Type,States,Mess)->
	RsList = app_msg:encode([{?int8u,Type},{?int16u,length(Mess)}]),
	F = fun({Id,Value}, Acc) ->
				Bin = app_msg:encode([{?int8u,States},{?int32u,Id},{?int32u,Value}]),
				<<Acc/binary,Bin/binary>>
		end,
	BiList=lists:foldl(F, RsList, Mess),
	app_msg:msg(?P_GAME_LOGS_NOTICES, BiList).

% 事件通知 [22780]
msg_event(Id,StrModule,IntModule)->
	Rs1 = app_msg:encode([{?int16u,Id},{?int16u,length(StrModule)}]),
	F1=fun({Type1,Colour},Acc1) ->
			   Bin1=app_msg:encode([{?string,Type1},{?int16u,Colour}]),
			   <<Acc1/binary,Bin1/binary>>
	   end,
	BiList1=lists:foldl(F1, Rs1, StrModule),
	
	Rs2 = app_msg:encode([{?int16u,length(IntModule)}]),  
	F2=fun(Type2,Acc2) ->
			   Bin2=app_msg:encode([{?int32u,Type2}]),
			   <<Acc2/binary,Bin2/binary>>
	   end,
	BiList2=lists:foldl(F2, Rs2, IntModule),
	BinList= <<BiList1/binary,BiList2/binary>>,
	app_msg:msg(?P_GAME_LOGS_EVENT, BinList).
