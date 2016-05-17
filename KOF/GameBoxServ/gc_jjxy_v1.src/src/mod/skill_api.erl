%% Author: Kevin
%% Created: 2012-10-16
%% Description: TODO: Add description to pp_friend
-module(skill_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%% 
-export([		 
		 encode_skill_user/1,
		 decode_skill_user/1,
		 init/1,
		 skill_request/1,
		 skill_learn/3,
		 skill_equip/3,
		 check_skill_learn/4,
		 skill_learn_info/1,
		 skill_auto_study/1,    %%人物升级技能自动学习回调
		 skill_auto_study2/1,   %%人物等级升级内部回调
		 skill_harm_get/2,      %%技能伤害系数
         add_power/3,
         cut_power/3,
		 skillIds_equip/1,
		 
		%%%%%%%%%%%%%%%%伙伴升级%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
		 parent_lv/2,
		 parent_lv_learn/4
	    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         ]).

%%存数据接口
encode_skill_user(Skill_user) ->
	Skill_user.

decode_skill_user(Skill_user) ->
	case is_record(Skill_user,skill_user) of
		?true->
			Skill_user;
		_->
			#skill_user{}
	end.

%%
%% API Functions
%%

%% 初始化技能
%% reg:Player
%% return:{Player,Skill_user}
init(#player{pro = Pro0} = Player)->
	SkillDefault = (data_skill_start:get(Pro0))#d_skill_start.skill_default,
	?MSG_ECHO("============~w~n",[SkillDefault]),
	StudyTupleList = skillStudy(Player),
	?MSG_ECHO("============~w~n",[StudyTupleList]),
	Fun = fun({SkillId,SkillLv},{Pos,Acc})->
				Acc2 = [#skill{id = SkillId,lv = SkillLv,pos = Pos}|Acc],
				{Pos + 1,Acc2}
		end,
	{_,SkillEquipList} = lists:foldl(Fun,{1,[]}, SkillDefault),
	StudyTupleList2 = lists:foldl(fun(Item,Acc) -> ?IF(lists:member(Item,StudyTupleList),Acc,[Item|Acc]) end,StudyTupleList,SkillDefault),
	?MSG_ECHO("================~w~n",[StudyTupleList2]),
	Skill_user = #skill_user{study = StudyTupleList2, equip= SkillEquipList},
	{Player,Skill_user}.

%% 1处理技能列表
%% Player
%% {?ok,Player,Bin}
skill_request(#player{info = Info} = Player) ->
    Skill_user = role_api_dict:skill_user_get(),
	#skill_user{study = StudyTupleList,equip = EquipTupleList} = Skill_user,
	Bin = msg_list(Info#info.power), 
	Bin2 = msg_learn(StudyTupleList),
	Bin3 = skill_equip_read(EquipTupleList),
	{?ok,Player,<<Bin/binary,Bin2/binary,Bin3/binary>>}.
		  
%% 默认技能 + 已经学习技能
skillStudy(Player) ->
	ProStudyList = skill_auto_study2(Player),                                %% 该等级应该可以学习的技能，默认自动学习
	StudyTupleList2 = lists:foldl(fun(Skillid, Acc) ->
					[{Skillid, 1}|Acc]
				   end, [], ProStudyList),
    StudyTupleList2.

%% 读取装备技能信息
%% reg:EquipTupleList
%% return:Bin
skill_equip_read(EquipTupleList) ->
	EquipTupleList2 = lists:foldl(fun(EquipSkill,Acc)->
									 #skill{lv = Lv,pos = Pos,id = Id} = EquipSkill,
									 [{Pos,Id,Lv}|Acc]
							 end, [], EquipTupleList),
	Bin = lists:foldl(fun({EquipPos, SkillId, SkillLv},Acc) ->
							   BinEquipInfo = msg_equip_info(EquipPos,SkillId,SkillLv),
							   ?MSG_ECHO("===========~w~n",[BinEquipInfo]),
							   <<BinEquipInfo/binary,Acc/binary>>
					   end, <<>>, EquipTupleList2),
	Bin.

%% 2处理学习请求
%% reg:Player,SkillId,Lv0
%% return:{?ok,Player,bin}
%% skill_learn(#player{uid = Uid} = Player,SkillId,Lv0)->
%% 	case check_skill_learn(Player,SkillId,Lv0,?CONST_SKILL_PARTNER_SKILL) of 
%% 		{?ok,Player2,Bin,Gold,Power} ->     
%% 			SkillUser = role_api_dict:skill_user_get(),
%% 			#skill_user{study = Study,equip = EquipList} = SkillUser,
%% 			NewLv0 = Lv0 + 1,
%% 			stat_api:logs_skill(Uid,SkillId,Lv0,NewLv0,Gold,Power),
%% 			Bin2 = msg_info(SkillId,NewLv0),		 %% 学习技能信息
%% %% 			{SkillId,_Lv0} = lists:keyfind(SkillId,1,Study), 
%% 			Study2 = case lists:keytake(SkillId, 1, Study) of
%% 						 {value,{SkillId,_Lv0},StudyList} ->
%% 							 [{SkillId,NewLv0}|StudyList];
%% 						 _ ->
%% 							 Study
%% 					 end,
%% 			case update_skilllv(SkillId,EquipList,NewLv0) of 
%% 				{EquipSkill2,Bin3} ->
%% 					SkillUser2 = SkillUser#skill_user{study = Study2,equip = EquipSkill2},
%% 					role_api_dict:skill_user_set(SkillUser2),
%% 					logs_api:action_notice(Uid, ?CONST_LOGS_1116, [], []),
%% 					{?ok,Player2,<<Bin/binary,Bin2/binary,Bin3/binary>>};
%% 			    _ ->
%% 				   SkillUser2 = SkillUser#skill_user{study = Study2},
%% 				   role_api_dict:skill_user_set(SkillUser2),
%% 				   logs_api:action_notice(Uid, ?CONST_LOGS_1116, [], []),
%% 				   {?ok,Player2,<<Bin/binary,Bin2/binary>>}	
%% 			end;
%% 		{?error,ErrorCode} ->
%% 			{?error,ErrorCode}
%% 	end.

skill_learn(#player{uid = Uid} = Player,SkillId,Lv0)->
	SkillUser = role_api_dict:skill_user_get(),
	#skill_user{study = Study,equip = EquipList} = SkillUser,
	case lists:keytake(SkillId, 1, Study) of
		{value,{SkillId,_Lv0},StudyList0} ->
			?MSG_ECHO("===================~w~n",[Lv0]),
			StudyList = [{A,B}||{A,B}<-StudyList0,A =/= SkillId],
			case check_skill_learn(Player,SkillId,Lv0,?CONST_SKILL_PARTNER_SKILL) of 
				{?ok,Player2,Bin,Gold,Power} -> 				
					NewLv0 = Lv0 + 1,
					stat_api:logs_skill(Uid,SkillId,Lv0,NewLv0,Gold,Power),
					Bin2 = msg_info(SkillId,NewLv0),		 %% 学习技能信息
                    Study2 = [{SkillId,NewLv0}|StudyList],
					case update_skilllv(SkillId,EquipList,NewLv0) of 
						{EquipSkill2,Bin3} ->
							SkillUser2 = SkillUser#skill_user{study = Study2,equip = EquipSkill2},
							role_api_dict:skill_user_set(SkillUser2),
							logs_api:action_notice(Uid, ?CONST_LOGS_1116, [], []),
							{?ok,Player2,<<Bin/binary,Bin2/binary,Bin3/binary>>};
						_ ->
							SkillUser2 = SkillUser#skill_user{study = Study2},
							role_api_dict:skill_user_set(SkillUser2),
							logs_api:action_notice(Uid, ?CONST_LOGS_1116, [], []),
							{?ok,Player2,<<Bin/binary,Bin2/binary>>}	
					end;
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		_ ->
			{?error,?ERROR_SKILL_NOT_HAVE}
	end.

%% 检查技能是否可以升级
%% reg:Player,SkillId,Lv
%% return:{?ok,Player,Bin}||{?error,ErrorCode}
check_skill_learn(#player{money = Money,info = Info,lv = RoleLv} = Player,SkillId,Lv,PartnerLv)-> 
	case data_skill:lv(SkillId, Lv + 1) of
		#s_lv{use_up = Use_up,must = S_must} ->
			#s_use{exp = Exp,gold = Gold,power = Power,rmb = Rmb} = Use_up,
			#s_must{lv = _RoleLv} = S_must,
			#money{gold = Gold0,rmb = Rmb0} = Money,
			#info{exp = Exp0,power = Power0} = Info,
			case Gold0 >= Gold andalso Rmb0 >= Rmb of 
				?true ->
				  case Exp0 >= Exp of
					  ?true ->
                        case Power0 >= Power of
							?true ->
								case PartnerLv of
									?CONST_SKILL_PARTNER_SKILL ->
										case Lv < RoleLv of   %% andalso RoleLv0 =< Skill_id#skill.lv_max
											?true ->
												#skill{lv_max=LvMax}=data_skill:get(SkillId),
												case Lv < LvMax of
													?true ->
														case role_api:currency_cut([check_skill_learn,[Player,SkillId,Lv],<<"技能升级">>],Player, 
																				   [{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_EXP,Exp},
																					{?CONST_CURRENCY_ADV_SKILL,Power},{?CONST_CURRENCY_RMB_BIND,Rmb}],?false) of
															{?ok,Player2,Bin} ->
																{?ok,Player2,Bin,Gold,Power};
															{error, ErrorCode} ->
																{?error, ErrorCode}
														end;
													_ ->
														{?error,?ERROR_SKILL_NOT_LIMIT}
												end;
											_ ->
												{?error,?ERROR_SKILL_NOT_LV}
										end;
								    _ ->
										case PartnerLv > Lv of   %% andalso RoleLv0 =< Skill_id#skill.lv_max
											?true ->
												case role_api:currency_cut([check_skill_learn,[Player,SkillId,Lv],<<"技能升级">>],Player,
																		   [{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_EXP,Exp},
																			{?CONST_CURRENCY_ADV_SKILL,Power},{?CONST_CURRENCY_RMB_BIND,Rmb}],?false) of
													{?ok,Player2,Bin} ->
														{?ok,Player2,Bin};
													{error, ErrorCode} ->
														{?error, ErrorCode}
												end;
											_ ->
												{?error,?ERROR_SKILL_NOT_PARTENTLV}
										end
								end;
                            _ ->
								{?error,?ERROR_SKILL_POWER_NOT_ENOUGH}
							end;
					  _ ->
						  {?error,?ERROR_SKILL_POWER_NOT_ENOUGH}
				   end;
				_ ->
					{?error,?ERROR_SKILL_GOLD_NOT_ENGOUH}
			end;
		_ ->
			{?error,?ERROR_SKILL_RESET_OK}
	end.			

%% 更新该装备技能等级信息
%% reg:SkillId,EquipList,NewLv0
%% return:{[],Bin}||<<>>
update_skilllv(SkillId,EquipList,NewLv0) ->
	case lists:keytake(SkillId, #skill.id, EquipList) of
		{value,EquipSkill,EquipList2} ->
			?MSG_ECHO("===================~w~n",[{EquipSkill,EquipList2}]),
			EquipList3 = [Skill||Skill<-EquipList2,Skill#skill.id =/= SkillId],
			#skill{pos = Pos} = EquipSkill,
			Bin2 = msg_equip_info(Pos, SkillId, NewLv0),
			EquipSkill2 = EquipSkill#skill{lv = NewLv0},
			{[EquipSkill2|EquipList3],Bin2};
		_ ->
			<<>>
	end.

%% 4处理装备技能请求 
%% reg:Player,SkillId,SkillPos
%% return: {?ok,Player,Bin}
skill_equip(Player,SkillId,SkillPos)->
	SkillUser = role_api_dict:skill_user_get(),
	#skill_user{equip = Equip,study = Study} = SkillUser,
	case lists:keytake(SkillPos, #skill.pos, Equip) of
		{value,_Skill,EquipList}->
%% 			Bin2 = msg_equip_info(SkillPos,0,0),
			{EquipList2,Bin} = skill_equip(SkillId, SkillPos, EquipList, Study),
			SkillUser2 = SkillUser#skill_user{equip = EquipList2},
			role_api_dict:skill_user_set(SkillUser2),
			{?ok,Player,Bin};
		_->
			{EquipList2,Bin} = skill_equip(SkillId, SkillPos, Equip, Study),
			SkillUser2 = SkillUser#skill_user{equip = EquipList2},
			role_api_dict:skill_user_set(SkillUser2),
			{?ok,Player,Bin}
	end.

skill_equip(SkillId, SkillPos, EquipList,Study)->
	case lists:keytake(SkillId, #skill.id, EquipList) of   %%  该技能所在的位置，原来的位置清空，新位置装上
		{value, #skill{lv = SkillLv,pos = SkillPos2} = Skill, EquipList2} ->
			Skill2 = Skill#skill{pos = SkillPos},
			EquipList3 = [Skill2|EquipList2],
			Bin  = msg_equip_info(SkillPos,SkillId,SkillLv),
			Bin2 = msg_equip_info(SkillPos2,0,0),
			{EquipList3,<<Bin/binary,Bin2/binary>>};
		_->     %% 未装备的技能
			case lists:keyfind(SkillId, 1, Study) of   %%  从学习列表中取出
				{SkillId, SkillLv} ->
					Skill2 = #skill{pos = SkillPos,id = SkillId,lv = SkillLv},
					EquipList2 = [Skill2|EquipList],
					Bin = msg_equip_info(SkillPos, SkillId, SkillLv),
					{EquipList2,Bin};                  %% 进程字典+前端返回bin 
				_ ->
					{EquipList,<<>>}
			end
	end.
		
%% 该职业所对应的可以学习的技能
%% reg:Pro0
%% return:[]
skill_learn_info(Pro0)->
	SkillsList = data_skill:get_skills(),
    F = fun(SkillId,Acc)->
						#skill{pro=ProList}=data_skill:get(SkillId),
						case lists:member(Pro0, ProList) of
							?true ->
								[SkillId|Acc];
                            _ ->
                                Acc
                         end
		 end,
    lists:foldl(F, [], SkillsList).

%% 人物升级技能自动学习回调
%% reg: Player
%% return: null
skill_auto_study(#player{lv = Lv,pro = Pro,socket = Socket})->
	#d_skill_start{skill_learn = SkillList} = data_skill_start:get(Pro), 
	F = fun(SkillId, Acc) ->
				#skill{battle_remark = BattleRemark} = data_skill:get(SkillId),
				case Lv >= BattleRemark of
					?true ->
					Bin = msg_info(SkillId,1),
				    Skill_user = role_api_dict:skill_user_get(),
					#skill_user{study = Study} = Skill_user,
					case lists:member({SkillId, 1},Study) of
						?true ->
							Acc;
						?false ->
							Skill_user2 = Skill_user#skill_user{study = [{SkillId,1}|Study]},
							?MSG_ECHO("===================~w~n",[Skill_user2#skill_user.study]),
							role_api_dict:skill_user_set(Skill_user2),
							<<Bin/binary,Acc/binary>>
					end;
                    ?false ->
                     Acc
				end
		end,
	BinMsg = lists:foldl(F, <<>>, SkillList),
	app_msg:send(Socket, BinMsg).

%% 人物技能学习内部回调
%% Player
%% []
skill_auto_study2(#player{lv = Lv,pro = Pro})->
	#d_skill_start{skill_learn = SkillList} = data_skill_start:get(Pro), 
	F = fun(SkillId, Acc) ->
				#skill{battle_remark = BattleRemark} = data_skill:get(SkillId),
				case Lv >= BattleRemark of
					?true ->
					 [SkillId|Acc];
                    ?false ->
                     Acc
				end
		end,
	lists:foldl(F, [], SkillList).

%% 增加或者删除战功
%% reg:LogSrc,Player,PowerValue
%% return:{?ok,Player,Bin}
add_power(_LogSrc, #player{info = Info} = Player,PowerValue)->
%% 	?MSG_ECHO("PowerValue=============================================~w~n",[PowerValue]),
    Power2 = Info#info.power + PowerValue,
    Info2 = Info#info{power = Power2},
	Player2 = Player#player{info = Info2},
	Bin = msg_list(Power2),
%% 	?MSG_ECHO("Bin===========================================================~w~n",[Bin]),
	{?ok,Player2,Bin}.

%% 减掉战功
%% reg:logsrc Player PowerValue
%% return:{?ok,Player,Bin}
cut_power(_LogSrc, #player{info = Info} = Player,PowerValue)->
    Power2 = Info#info.power - PowerValue,
    Info2 = Info#info{power = Power2},
	Player2 = Player#player{info = Info2},
	Bin = msg_list(Power2),
	?MSG_ECHO("==============~w~n",[Power2]),
	{?ok,Player2,Bin}.

%% 返回装备技能列表
%% reg:Uid
%% return:[]
skillIds_equip(Uid) ->
	{?ok,Skill_user} = role_api_dict:skill_user_get(Uid),
    #skill_user{equip = EquipList} = Skill_user,
	[{Pos,Id,Lv}||#skill{id = Id,lv = Lv,pos = Pos} <- EquipList].

%% 返回技能
%% reg:SkillId,SkillLv
%% return: arg1 技能伤害
skill_harm_get(SkillId,SkillLv) ->
	case data_skill:lv(SkillId, SkillLv) of 
	      #s_lv{mc = SkillMc}  ->
	            SkillMc#s_mc.arg1;
		   _ ->
			    1
	end.

%% 伙伴技能等级查看
parent_lv(Uid,Parentid) ->
	R = inn_api:inn_partner_skill(Uid,Parentid),
%% 	?MSG_ECHO("Bin=~w~n",[R]),
	case R of 
		[] ->
%% 			{?error,?ERROR_SKILL_NOT_EXIT};
			{?ok,app_msg:msg(?P_SKILL_PARENTINFO, <<>>)};
		_ ->
			[_Lv,SkillLvList] = inn_api:inn_partner_skill(Uid,Parentid),
%% 			?MSG_ECHO("Bin==================================================~w~n",[SkillLvList]),
			Fun = fun({SkillId,SkillLv},Acc) ->
						  BinAcc = msg_parentinfo(Uid,Parentid,SkillId,SkillLv),
%% 						  ?MSG_ECHO("Bin=~w~n",[BinAcc]),
						  <<BinAcc/binary,Acc/binary>>
				  end,
			Bin = lists:foldl(Fun, <<>>, SkillLvList),
%% 			?MSG_ECHO("Bin============================================================~w~n",[Bin]),
			{?ok,Bin}
	end.

parent_lv_learn(#player{uid = Uid} = Player,Parentid,SkillId,Lv) ->	
%% 	?MSG_ECHO("Bin=~w~n",[Parentid]),
	R = inn_api:inn_partner_skill(0,Parentid),
	case R of 
		[] ->
			{?ok,Player,app_msg:msg(?P_SKILL_PARENTINFO, <<>>)};
		_ ->
%% 			?MSG_ECHO("Bin=~w~n",[R]),
			[PartnerLv,SkillLvList] = R,
%% 			?MSG_ECHO("Bin=~w~n",[PartnerLv]),
%% 			?MSG_ECHO("Bin=~w~n",[SkillLvList]),
			case lists:keytake(SkillId, 1, SkillLvList) of
				{value, {SkillId,Lv}, SkillLvList2} ->
					case check_skill_learn(Player,SkillId,Lv,PartnerLv) of 
						{?ok,Player2,Bin} ->
							Lv2 = Lv + 1,
							inn_api:inn_updata_skill(Parentid,[{SkillId,Lv2}|SkillLvList2]),
							?MSG_ECHO("====================~w~n",[R]),
							stat_api:logs_partner_skill(Uid, Parentid, SkillId, Lv, Lv2),
							Bin2 = msg_parentinfo(0,Parentid,SkillId,Lv2),
							{?ok,Player2,<<Bin2/binary,Bin/binary>>};
						{error, ErrorCode} ->
							{?error, ErrorCode}
					end;
				_ ->
					{?error,?ERROR_SKILL_SKILL_ID}
			end
	end.
	

%% 返回单个技能信息
%% skill_id_request(#player{money=Money0}=Player,SkillId)->
%% 	%%读取配置文件
%%     #skill_user{power=Power0,study=StudyList}=role_api_dict:skill_user_get(),
%% 	#money{gold=Gold0}=Money0,
%% 	?MSG_ECHO("===Pos0=~w~n===",[StudyList]),
%% 	case lists:keyfind(SkillId,1,StudyList) of
%% 		{SkillId,SkillLv} ->
%% 			#s_lv{use_up=Use_up}=data_skill:lv(SkillId,SkillLv+1),
%% 			?MSG_ECHO("===Pos0=~w~n===",[Use_up]),
%% 			#s_use{power=Power,gold=Gold}=Use_up,
%% 			if Gold0 > Gold andalso Power0 > Power ->
%% 				  ?MSG_ECHO("===Pos0=~w~n===",[]),
%% 			     BinMsg=msg_request_info(Gold,Power,1,1),
%% 				 {?ok,Player,BinMsg};
%% 			?true ->
%% 				?MSG_ECHO("===Pos0=~n===",[]),
%%                  BinMsg=msg_request_info(Gold,Power,0,0),
%% 				 {?ok,Player,BinMsg}
%% 			end;
%% 		?false ->
%% 			{?error,?ERROR_SKILL_LEARN}
%% 	end.	

%%单个技能位置信息
%% skill_pos_id(Player,Pos0)->
%% 	Skill_user=role_api_dict:skill_user_get(),
%% 	#skill_user{equip=Equip}=Skill_user,
%% 	case Equip of 
%% 		[#skill{id=SkillId,pos=Pos}] ->
%% 			case Pos0 == Pos of
%% 				?true ->
%% 					BinMsg=msg_skill_id(SkillId),
%% 					{?ok,Player,BinMsg};
%% 				?false ->
%% 					?MSG_ECHO("===Pos0=~n===",[]),
%% 					{?error,?ERROR_SKILL_SKILL_ID}
%% 			end;
%% 		_ ->
%% 			?MSG_ECHO("===Pos0=~n===",[]),
%% 			{?error,?ERROR_SKILL_SKILL_ID}
%% 	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% msg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 技能列表数据 [6520]
msg_list(Power)->
    RsList = app_msg:encode([{?int32u,Power}]),
    app_msg:msg(?P_SKILL_LIST, RsList).

%% 技能信息 [6530]
msg_info(SkillId,SkillLv)->
    RsList = app_msg:encode([{?int16u,SkillId},
        {?int16u,SkillLv}]),
    app_msg:msg(?P_SKILL_INFO, RsList).

% 装备技能信息 [6545]
msg_equip_info(EquipPos,SkillId,SkillLv)->
%% 	Now = util:localtime(),
%% 	?MSG_ERROR("6545654565456545  ~w~n",[{EquipPos,SkillId,SkillLv,Now}]),
    RsList = app_msg:encode([{?int16u,EquipPos},
        {?int32u,SkillId},{?int16u,SkillLv}]),
    app_msg:msg(?P_SKILL_EQUIP_INFO, RsList).

%% 打包学习的技能
msg_learn(StudyTupleList) ->
	lists:foldl(fun({SkillId,SkillLv},Acc) ->
							   BinInfo = msg_info(SkillId,SkillLv),
							   <<BinInfo/binary,Acc/binary>>
					   end, <<>>, StudyTupleList).	

% 伙伴技能信息 [6560]
msg_parentinfo(Uid,Parentid,SkillId,SkillLv)->
    RsList = app_msg:encode([{?int32u,Uid},{?int32u,Parentid},
        {?int32u,SkillId},{?int32u,SkillLv}]),
    app_msg:msg(?P_SKILL_PARENTINFO, RsList).

