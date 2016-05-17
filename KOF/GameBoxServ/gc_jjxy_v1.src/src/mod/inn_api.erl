%% Author  : Kevin
%% Created: 2012-9-5
%% Description: TODO: Add description to role_mod
-module(inn_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


%%
%% Exported Functions
%%

-export([encode_inn/1,
		 decode_inn/1,
		 
		 init/1,
		 updata_partner_init/1,
		 inn_list/2,
		 inn_use_list/0,
		 inn_call_partner/2,
		 inn_drop_out/1,
		 inn_enjoy/2,
		 inn_war/2,
		 inn_down_war/1,
		 exp_add_inn/4,
		 inn_war_id/0,
		 attr_update_partner/4,
		 exp_partner_ids/3,
		 inn_war_ids/0,
		 inn_partner_skill/2,
		 inn_powerful/0,
		 inn_powerful2/1,
		 inn_updata_skill/2,
		 partner_crad/2,
		 partner_lv/1,
		 
		 msg_list/2,
		 msg_res_partner/2
		]).

encode_inn(Inn) ->
	Inn.

decode_inn(Inn) ->
	Inn.


init(Player)->
	{Player,#inn{}}.


%%
%% Local Functions
%%

%% 更新伙伴初始化信息
updata_partner_init(Socket)->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn,
	Fun=fun(Partner,Acc)->
				case data_partner_init:get(Partner#partner.partner_id) of
					#d_partner{attr=Attr}->
						Partner2=attr_update_partner(Socket,Partner,lv,Attr),
						[Partner2|Acc];
					_->
						[Partner|Acc]
				end
		end,
	Partners2=lists:foldl(Fun,[],Partners),
	Inn2=Inn#inn{partners=Partners2},
	role_api_dict:inn_set(Inn2).


%%  取伙伴等级
partner_lv(PartnerId)->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn,
	case lists:keyfind(PartnerId,#partner.partner_id,Partners) of
		#partner{lv=Lv}->
			Lv;
		_->
			0
	end.
		
%% 伙伴战斗力
inn_powerful()->
	Inn=role_api_dict:inn_get(),
	inn_powerful2(Inn).

inn_powerful2(Inn)->
	#inn{partners=Partners}=Inn,
	lists:sum([Powerful||#partner{powerful=Powerful,state=State}<-Partners,State==?CONST_INN_STATA3]).

%% 出战伙伴ID
inn_war_id()->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn,
	[PartnerId||#partner{partner_id=PartnerId,state=State}<-Partners,State==?CONST_INN_STATA3].

%% 出战伙伴ID
inn_use_list()->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn,
	[PartnerId||#partner{partner_id=PartnerId,state=State}<-Partners,State==?CONST_INN_STATA3 orelse State==?CONST_INN_STATA0].

%% 伙伴列表 {?ok,List}
inn_list(Renown,Inn)->
	#inn{partners=Partners}=Inn,
	Fun=fun(Partner,Acc)->
				#partner{partner_id=PartnerId,state=State,lv=Lv}=Partner,
				[{PartnerId,State,Lv}|Acc]
		end,
	List=lists:foldl(Fun,[],Partners),
	msg_list(Renown,List).
			
%% 召唤伙伴 
inn_call_partner(Player=#player{uid=Uid,lv=InfoLv,info=Info},PartnerId)->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn,
	case lists:keytake(PartnerId,#partner.partner_id,Partners) of
		{value,_,_Partners2}->
			{?error,?ERROR_INN_NOT_SHINWAKAN};
		_->
			case data_partner_init:get(PartnerId) of
				#d_partner{call_lv=Lv,use_renown=UseRenown,pay=Pay}=DPartner->
					LogSrc=[inn_call_partner,[],<<"招募伙伴消耗美刀">>],
					case role_api:currency_cut(LogSrc, Player,[{?CONST_CURRENCY_GOLD,Pay}]) of
						{?ok,Player2,BinMoney}->
							if
								InfoLv>=Lv andalso 
									Info#info.renown>=UseRenown ->
									Partner=partner_init(DPartner,1),
									case is_partner(Partners, InfoLv, ?CONST_TRUE) of
										?true->
											Partner2=Partner#partner{state=?CONST_INN_STATA0};
										_->
											Partner2=Partner#partner{state=?CONST_INN_STATA2}
									end,
									BinMsg=msg_res_partner(?CONST_INN_OPERATION4,PartnerId),
									Inn2=Inn#inn{partners=[Partner2|Partners]},
									BinMsg2=inn_list(Info#info.renown,Inn2),
									role_api_dict:inn_set(Inn2),
									stat_api:logs_inn(Uid,PartnerId),
									{?ok,Player2,<<BinMoney/binary,BinMsg/binary,BinMsg2/binary>>};
								?true->
									{?error,?ERROR_KOF_TIPS_RENOWN_LACK} %% 您还不能招募
							end;
						{?error,Error}->
							{?error,Error}
					end;
				_->
					{?error,?ERROR_INN_NO_PARTNER}
			end
	end.

%% 伙伴卡获得伙伴
partner_crad(#player{uid=Uid,lv=InfoLv,info=Info,uname=Name,uname_color=NameColor,pro= Pro},PartnerId)->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn,
	case lists:keytake(PartnerId,#partner.partner_id,Partners) of 
		?false->
			case data_partner_init:get(PartnerId) of
				DPartner when is_record(DPartner,d_partner)->
					Partner=partner_init(DPartner,1),
					case is_partner(Partners, InfoLv, ?CONST_TRUE) of
						?true->
							Partner2=Partner#partner{state=?CONST_INN_STATA0};
						_->
							Partner2=Partner#partner{state=?CONST_INN_STATA2}
					end,
					PBinMsg=?IF(PartnerId==?CONST_INN_PARTNER_WU,broadcast_api:msg_broadcast_partner({Uid,Name,InfoLv,NameColor,Pro}),<<>>),
					chat_api:send_to_all(PBinMsg),
					BinMsg=msg_res_partner(?CONST_INN_OPERATION4,PartnerId), 
					Inn2=Inn#inn{partners=[Partner2|Partners]},
					BinMsg2=inn_list(Info#info.renown,Inn2),
					role_api_dict:inn_set(Inn2),
					stat_api:logs_inn(Uid,PartnerId),
					{?ok,<<BinMsg/binary,BinMsg2/binary>>};
				_->
					{?error,?ERROR_INN_NO_PARTNER}
			end;
		_->
			{?error,?ERROR_INN_NO_PARTNER}
	end.


%% 经验丹加经验
exp_partner_ids(Player=#player{uid=Uid,socket=Socket,lv=InfoLv},PartnerID,Exp)->
	Inn=role_api_dict:inn_get(),
	case lists:keytake(PartnerID,#partner.partner_id,Inn#inn.partners) of
		{value,Partner,Partners}->
			Partner2=exp_partner(Uid,Socket,Partner,Exp,InfoLv,exp_partner_ids,<<"伙伴经验丹">>,?CONST_TRUE),
			Partners2=[Partner2|Partners],
			Inn2=Inn#inn{partners=Partners2},
			role_api_dict:inn_set(Inn2),
			Player;
		_->
			{?error,?ERROR_INN_NO_PARTNER}
	end.
%% %% 查看需要多少经验丹
%% exp_common_par(Exp)->
	

%% 伙伴加经验
exp_add_inn(Player=#player{uid=Uid,socket=Socket,lv=InfoLv},Exp,LogMethod,LogRemark)->
	Inn=role_api_dict:inn_get(),
	Partners=[exp_partner(Uid,Socket,Partner,Exp,InfoLv,LogMethod,LogRemark,?CONST_FALSE)||Partner<-Inn#inn.partners,is_record(Partner,partner)],
	Inn2=Inn#inn{partners=Partners},
	role_api_dict:inn_set(Inn2),
	Player.
	
%% 伙伴加经验类型 经验丹/其它获得途径
exp_partner(Uid,Socket,Partner=#partner{state=State},Exp,LvMax,LogMethod,LogRemark,Arg)->
	case Arg of
		?CONST_TRUE->
			exp_partner2(Uid,Socket,Partner,Exp,LvMax,LogMethod,LogRemark);
		_->
			case State of
				?CONST_INN_STATA3->
					exp_partner2(Uid,Socket,Partner,Exp,LvMax,LogMethod,LogRemark);
				_->Partner
			end
	end.


%%伙伴加经验
exp_partner2(Uid,Socket,Partner=#partner{partner_id=PartnerId,lv=Lv,exp=ExpN},Exp,LvMax,LogMethod,LogRemark)->
%% 	stat_api:logs_exp(Uid, PartnerId,Lv, LogMethod, Exp, Exp + ExpN, <<"lv:",?B(Lv),"->",?B(LogRemark) >>),
	NextExp = ?DATA_PLAYER_UP_EXP:get(?CONST_PARTNER,Lv),
	ExpLack = abs(NextExp - ExpN),
	NewExp  = Exp + ExpN,
	BinMsg  = role_api:msg_property_update(PartnerId,?CONST_ATTR_EXP,erlang:min(NewExp, NextExp)),  
	case Exp >= ExpLack of  
		?true->
			if
				is_integer(LvMax),LvMax =/= 0,Lv >= LvMax ->
					app_msg:send(Socket, BinMsg),
					Partner#partner{exp=erlang:min(NewExp, NextExp)};
				?true ->
					Partner2 = level_up(Uid,Socket,Partner),
					exp_partner2(Uid,Socket,Partner2, Exp - ExpLack,LvMax,LogMethod,LogRemark)
			end;				
		?false-> 
			app_msg:send(Socket, BinMsg),
			Partner#partner{exp=NewExp}
	end.

%% 伙伴升级
level_up(Uid,Socket,Partner=#partner{partner_id=PartnerId,attr_group=AttrGroup,lv=Lv})->
	Partner2=Partner#partner{lv=Lv+1,exp=0},
	NxetExp2	=?DATA_PLAYER_UP_EXP:get(?CONST_PARTNER,Lv+1), 
	Bin =role_api:msg_property_update(PartnerId,?CONST_ATTR_LV,Lv+1),
	Bin2=role_api:msg_property_update(PartnerId,?CONST_ATTR_EXPN,NxetExp2),
	stat_api:logs_inn_lv(Uid,PartnerId,Lv,Lv+1),
	app_msg:send(Socket, <<Bin/binary,Bin2/binary>>),
	attr_update_partner(Socket,Partner2,lv,AttrGroup#attr_group.lv).

%% 伙伴初始化
partner_init(DPartner,Lv)->
	#d_partner{partner_id=PartnerId,pro=Pro,sex=Sex,country=Country,talent=Talent,
			   skill_ids=SkillIds,attack_type=AttackType,attr=LvAttr}=DPartner,
	Equip=bag_api:init_equip(Pro,Sex),
	EquipAttr=bag_api:equip_attr_calc(Equip),
	AttrGroup=#attr_group{lv=LvAttr,equip=EquipAttr},
	Attr=role_api:attr_all(AttrGroup,Lv,Talent),
	Powerful=role_api:powerful_calc(Attr),
	#partner{
			 equip			=	Equip,			%% 装备
			 partner_id		=	PartnerId,		%% 伙伴ID
			 hp				=   Attr#attr.hp,	%% 血量
			 lv				=   Lv,				%% 等级
			 pro				=	Pro,				%% 职业
			 sex				=	Sex,				%% 性别
			 country			=	Country,			%% 阵营
			 talent			=	Talent,			%% 天赋
			 skill			=	SkillIds,		%% 技能ID
			 attack_type		=	AttackType,		%% 攻击类型
			 attr_group		=	AttrGroup,		%% 附和属性 
			 attr			=	Attr,			%% 伙伴属性
			 powerful		=	Powerful			%%  战斗力
			}.

attr_update_partner(Socket,Partner=#partner{lv=Lv,attr=AttrOld,attr_group=AttrGroup,talent=Talent},lv,Attr)->
	AttrGroup2=AttrGroup#attr_group{lv=Attr},
	AttrNew=role_api:attr_all(AttrGroup2,Lv,Talent),
	attr_refresh_side(Socket,Partner,AttrGroup2,AttrOld,AttrNew,<<>>,?false);

attr_update_partner(Socket,Partner=#partner{lv=Lv,attr=AttrOld,attr_group=AttrGroup,talent=Talent},douqi,Attr)->
	AttrGroup2=AttrGroup#attr_group{douqi=Attr},
	AttrNew=role_api:attr_all(AttrGroup2,Lv,Talent),
	attr_refresh_side(Socket,Partner,AttrGroup2,AttrOld,AttrNew,<<>>);

%% 
%% attr_update_partner(Socket,Partner=#partner{lv=Lv,attr=AttrOld,attr_group=AttrGroup,talent=Talent},renown,Attr)->
%% 	AttrGroup2=AttrGroup#attr_group{renown=Attr},
%% 	AttrNew=role_api:attr_all(AttrGroup2,Lv,Talent),
%% 	attr_refresh_side(Socket,Partner,AttrGroup2,AttrOld,AttrNew,<<>>);
%% 
attr_update_partner(Socket,Partner=#partner{lv=Lv,attr=AttrOld,attr_group=AttrGroup,talent=Talent},equip,Attr)->
	AttrGroup2=AttrGroup#attr_group{equip=Attr},
	AttrNew=role_api:attr_all(AttrGroup2,Lv,Talent),
	attr_refresh_side(Socket,Partner,AttrGroup2,AttrOld,AttrNew,<<>>);

attr_update_partner(_Socket,Partner,_Type,_Attr)->
	Partner.

%% 
attr_refresh_side(Socket,Partner=#partner{partner_id=PartnerId},AttrGroup,AttrOld,AttrNew,BinMsg)->
	BinDiff		= role_api:msg_attr_diff(PartnerId,AttrOld, AttrNew),
	case <<BinDiff/binary,BinMsg/binary>> of
		<<>>   ->
			Partner#partner{attr_group=AttrGroup};
		BinMsg2 ->
			BinLogs=logs_api:attr_change(AttrOld,AttrNew),
			Powerful=role_api:powerful_calc(AttrNew),
			BinPowerful=role_api:msg_property_update(PartnerId,?CONST_ATTR_POWERFUL, Powerful),
			app_msg:send(Socket, <<BinMsg2/binary,BinPowerful/binary,BinLogs/binary>>),
			Partner#partner{hp=AttrNew#attr.hp,attr_group=AttrGroup,attr=AttrNew,powerful=Powerful}
	end.

attr_refresh_side(Socket,Partner=#partner{partner_id=PartnerId},AttrGroup,AttrOld,AttrNew,BinMsg,_)->
	BinDiff		= role_api:msg_attr_diff(PartnerId,AttrOld, AttrNew),
	case <<BinDiff/binary,BinMsg/binary>> of
		<<>>   ->
			Partner#partner{attr_group=AttrGroup};
		BinMsg2 ->
%% 			BinLogs=logs_api:attr_change(AttrOld,AttrNew),
			Powerful=role_api:powerful_calc(AttrNew),
			BinPowerful=role_api:msg_property_update(PartnerId,?CONST_ATTR_POWERFUL, Powerful),
			app_msg:send(Socket, <<BinMsg2/binary,BinPowerful/binary>>),
			Partner#partner{hp=AttrNew#attr.hp,attr_group=AttrGroup,attr=AttrNew,powerful=Powerful}
	end.

%% 伙伴离队
inn_drop_out(PartnerId)->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn,
	case lists:keytake(PartnerId,#partner.partner_id,Partners) of
		{value,Partner,Partners2}->
			Partner2=Partner#partner{state=?CONST_INN_STATA2},
			Inn2=Inn#inn{partners=[Partner2|Partners2]},
			role_api_dict:inn_set(Inn2),
			?ok;
		_->
			{?error,?ERROR_INN_NO_PARTNER}
	end.


%% 伙伴归队
inn_enjoy(PartnerId,InfoLv)->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn,
	case lists:keytake(PartnerId,#partner.partner_id,Partners) of
		{value,Partner,Partners2}->
			case is_partner(Partners2, InfoLv, ?CONST_TRUE) of
				?true->
					Partner2=Partner#partner{state=?CONST_INN_STATA0},
					Inn2=Inn#inn{partners=[Partner2|Partners2]},
					role_api_dict:inn_set(Inn2),
					?ok;
				_->
					{?error,?ERROR_KOF_TIPS_PARTNER_CARRY_LIMIT}
			end;
		_->
			{?error,?ERROR_KOF_TIPS_PARTNER_CARRY_LIMIT}
	end.

%% 伙伴出战
inn_war(PartnerId,InfoLv)->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn, 
	case lists:keytake(PartnerId,#partner.partner_id,Partners) of
		{value,Partner,Partners2}->
			case is_partner(Partners2, InfoLv, ?CONST_FALSE) of
				?true->
					Partner2=Partner#partner{state=?CONST_INN_STATA3},
					Partners3=[Partner2|Partners2],
					Inn2=Inn#inn{partners=Partners3},
					role_api_dict:inn_set(Inn2),
					{?ok,Partner2#partner.powerful};
				_->
					{?error,?ERROR_KOF_TIPS_PARTNER_PLAY_LIMIT}
			end;
		_->
			{?error,?ERROR_KOF_TIPS_PARTNER_PLAY_LIMIT}
	end.

%% 伙伴出战休息
inn_down_war(PartnerId)->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn, 
	case lists:keytake(PartnerId,#partner.partner_id,Partners) of
		{value,Partner,Partners2}->
			Partner2=Partner#partner{state=?CONST_INN_STATA0},
			Partners3=[Partner2|Partners2],
			Inn2=Inn#inn{partners=Partners3},
			role_api_dict:inn_set(Inn2),
			{?ok,Partner2#partner.powerful};
		_->
			{?error,?ERROR_INN_NO_PARTNER}
	end.

%% inn_api()

%% 查看携带人数 出战人数是否充足
is_partner(Partners,InfoLv,Flag)->
	case data_partner_lv:get(InfoLv) of
		[]->?false;
		[CallSum,WarSum]->
			case Flag of
				?CONST_TRUE->
					Count03=length([Partner||Partner=#partner{state=State}<-Partners,State==?CONST_INN_STATA0 
											 orelse State==?CONST_INN_STATA3]),
					?MSG_ECHO("====== ~w~n",[[CallSum,Count03]]),
					Count03 < CallSum;
				_->
					Count3=length([Partner||Partner<-Partners,Partner#partner.state==?CONST_INN_STATA3]),
					Count3 < WarSum
			end
	end.
		

%% 所有出战伙伴ID
inn_war_ids()->
	#inn{partners=Partners}=role_api_dict:inn_get(),
	[Partner||Partner<-Partners,Partner#partner.state==?CONST_INN_STATA3].
	
%% 获取伙伴技能列表
inn_partner_skill(Uid,PartnerId)->
	{_,Inn}=?IF(Uid==0,{?ok,role_api_dict:inn_get()},role_api_dict:inn_get(Uid)),
	#inn{partners=Partners}=Inn,
	case lists:keyfind(PartnerId,#partner.partner_id,Partners) of
		#partner{lv=Lv,skill=Skills}->
			[Lv,Skills];
		_->[]
	end.

%%更新伙伴技能列表
inn_updata_skill(PartnerId,Skills)->
	Inn=role_api_dict:inn_get(),
	#inn{partners=Partners}=Inn,
	case lists:keytake(PartnerId,#partner.partner_id,Partners) of
		{value,Partner,Partners2}->
			Partner2=Partner#partner{skill=Skills},
			Inn2=Inn#inn{partners=[Partner2|Partners2]},
			role_api_dict:inn_set(Inn2);
		_->[]
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% msg_xxxx?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 伙伴列表 [31120]
msg_list(Renown,List)->
	Rs=app_msg:encode([{?int32u,Renown},{?int16u,length(List)}]),
	Fun=fun({PartnerId,Stata,XLv},Acc)->
				Acc2=app_msg:encode([{?int16u,PartnerId},{?int8u,Stata},{?int8u,XLv}]),
				<<Acc/binary,Acc2/binary>>
		end,
    RsList=lists:foldl(Fun,Rs,List), 
    app_msg:msg(?P_INN_LIST, RsList).

% 离队/归队结果 [31270]
msg_res_partner(Type,PartnerId)->
    RsList = app_msg:encode([{?int8u,Type},
        {?int16u,PartnerId}]),
    app_msg:msg(?P_INN_RES_PARTNER, RsList).
