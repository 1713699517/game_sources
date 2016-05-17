%% Author: Administrator
%% Created: 2012-11-14
%% Description: TODO: Add description to honor_api
-module(pet_api).

%%
%% Include files
%%
-include("../include/comm.hrl"). 

%%
%% Exported Functions
%%
-export([decode_pet/1,
		 encode_pet/1,
		 init/0,
		 init/1,
		 
 		 call/1,
		 need_rmb/1,
		 xiuliang/2,
		 huanhua/0,
		 huanhua/1,
		 is_five/2,
		 get_exp/5,
		 request/1,
		 pet_skill/0,
		 pet_att/1,
		 player_att_refresh/2,
		 level_up/3,
		 pet_skin/1,
		 test/0,
		 
		 msg_need_rmb_reply/1,
		 msg_call_ok/0,
		 msg_hh_reply_msg/3,
		 msg_huanhua_reply/1,
		 msg_skills/1,
		 msg_skins/1,
		 msg_xiulian_ok/0,
		 need_rmb2/1,
		 msg_reverse/8,
		 rmb_exp/2]).


test() ->
	{Y,M,D} 	 = util:date(),
	BeginTime0   = util:datetime2timestamp(Y, M, D, 0, 0, 0),
	BeginTime	 = util:to_binary(BeginTime0),
	?ok.


encode_pet(Pet) ->
	Pet.

decode_pet(Pet) when is_record(Pet, pet)->
	Pet;

decode_pet(_Pet) ->
	init().

%% 初始化宠物信息
init(Player) -> 
	Pet= init(),
	role_api_dict:pet_set(Pet),
	%% ?MSG_ECHO("--------------------~w~n",[is_record(Pet, pet)]),
	{Player,Pet}.

init() ->
	{SkillId,SkinId}= case data_pet_skill:get(1) of
				 #d_pet_skill{skill= Skill, unreal_skin =USkin} ->
					 {Skill,USkin};
				 _ ->
					 {0,0}
			 end,
	case data_pet:get(1) of
		#d_pet{lv=Lv,pet_id= Id,gold_exp= GoldExp,gold_ten_opp= GoldOpp,gold_time= GoldTime, good_exp= GoodExp,good_ten_opp= GoodOpp,good_time=GoodTime,hp=Hp,next_exp=NextExp,
			   skill_att=SkillAtt,skill_def=SkillDef,strong_att=StrongAtt,strong_def=StrongDef,unreal_skin=Skins} ->
			#pet{id= Id,gold_exp= GoldExp,lv=Lv,gold_ten_opp=GoldOpp,gold_time=GoldTime,good_ten_opp=GoodOpp,good_exp=GoodExp,next_exp=NextExp, skill_id= SkillId, skills=[SkillId],
				 good_time=GoodTime,ext=0,hp=Hp,exp=0,skill_att=SkillAtt,skill_def=SkillDef,unreal_skin=Skins,strong_def=StrongDef,strong_att=StrongAtt,skin_id=SkinId};
		_ ->
			%% ?MSG_ECHO("aaaaaaaaaa~n",[]),
			#pet{}
	end.

request(Player) ->
	Pet= role_api_dict:pet_get(),
	#pet{lv = Lv,skin_id= SkinId, skill_id=SkillId,skills= Skills,unreal_skin= Skins, exp= Exp}= Pet,
	Skins2= lists:reverse(Skins),
	Player2= player_att_refresh(Pet, Player),
	Fun1 = fun(Skill,{CountAcc1,BinAcc1}) ->
				  SkillBinAcc= msg_skills(Skill),
				  {CountAcc1+1,<<SkillBinAcc/binary,BinAcc1/binary>>}
		  end,
	{Count1,SkillBin}= lists:foldl(Fun1, {0,<<>>}, Skills),	
	CountBin1= app_msg:encode([{?int8u,Count1}]),
	
	Fun2 = fun(Skin,{CountAcc2,BinAcc2}) ->
				   %% ?MSG_ECHO("------------------~w~n",[ Skin]),
				  SkinBinAcc= msg_skins(Skin),
				  {CountAcc2+1,<<SkinBinAcc/binary,BinAcc2/binary>>}
		  end,
	{Count2,SkinBin}= lists:foldl(Fun2, {0,<<>>}, Skins2),
	CountBin2= app_msg:encode([{?int8u,Count2}]),
	BinMsg= msg_reverse(Lv, SkinId, SkillId, Exp, CountBin1, SkillBin, CountBin2,SkinBin),
	{?ok,Player2, BinMsg}.

need_rmb(Type) ->
	{_,_,BinMsg} = need_rmb2(Type),
	BinMsg.

need_rmb2(Type) ->
	GoodsId= ?CONST_PET_GOODS_ID,
	case Type =:= 2 of
		?true ->
			%% ?MSG_ECHO("------------------~w~n",[ Type]),
			Count1= bag_api:goods_id_count_get(GoodsId),
			Count= ?IF(Count1>=?CONST_PET_SENIOR_TIMES,0,?CONST_PET_SENIOR_TIMES- Count1),
			BinMsg= msg_need_rmb_reply(Count*?CONST_PET_RMB),
			%% ?MSG_ECHO("------------------~w~n",[ {Count,Count1}]),
			{[GoodsId,?CONST_PET_SENIOR_TIMES- Count],Count*?CONST_PET_RMB,BinMsg};
		_ ->
			%% ?MSG_ECHO("------------------~w~n",[Type]),
			Count1= bag_api:goods_id_count_get(GoodsId),
			Count= ?IF(Count1>=1,0,1- Count1),
			BinMsg= msg_need_rmb_reply(Count*?CONST_PET_RMB),
			%% ?MSG_ECHO("------------------~w~n",[ Count*?CONST_PET_RMB]),
			{[GoodsId,1- Count],Count*?CONST_PET_RMB,BinMsg}
	end.

is_five(Denominator,GoldTime) ->
	case util:rand_odds(Denominator, 10000) of
		?true ->
			GoldTime;
		_ ->
			1
	end.

get_exp(Exp,GoldExp,GoldTime,Denominator,0) ->
	%% ?MSG_ECHO("------------------------~w~n",[Exp]),
	Exp;
get_exp(Exp,GoldExp,GoldTime,Denominator,Times) ->
	Exp2= GoldExp*is_five(Denominator,GoldTime),
	%% ?MSG_ECHO("------------------------~w~n",[{Times, Exp2, Exp}]),
	get_exp(Exp+Exp2,GoldExp,GoldTime,Denominator,Times-1).

xiuliang(Type, Player= #player{lv= Lv}) ->
	Bag= role_api_dict:bag_get(),
	Pet= role_api_dict:pet_get(),
	GoodsId = ?CONST_PET_GOODS_ID,
	{NeedRmb, GetExp, GoodsList} = rmb_exp(Type,Pet),
	case bag_api:goods_get([xiuliang,[],<<"宠物修炼">>], Player, Bag, GoodsList) of
		{?ok,Player, NewBag, Bin}->
			%% ?MSG_ECHO("------------------~w~n",[ GoodsList]),
			case role_api:currency_cut([ xiuliang, [], <<"宠物修炼">>], Player, [{?CONST_CURRENCY_RMB, NeedRmb}]) of
				{?ok,Player2,Bin2} ->
					case pet_mod:exp_add_acc(Pet, GetExp,Lv) of
						{?ok,NewPet} ->
							role_api_dict:bag_set(NewBag),
							role_api_dict:pet_set(NewPet),
							Bin3= msg_xiulian_ok(),
							{?ok,Player3,Bin4}= request(Player2),
							{?ok,Player3, <<Bin/binary, Bin2/binary, Bin3/binary, Bin4/binary>>};
						{?error,ErrorCode} ->	
							{?error,ErrorCode}
					end;
				{?error,ErrorCode}->
					{?error,ErrorCode}
			end;
		{?error,ErrorCode}->
			{?error,ErrorCode}
	end.

huanhua() ->
	Pet= role_api_dict:pet_get(),
	#pet{unreal_skin= Skins, skin_id= SkinId}= Pet,
	Skins2= lists:reverse(Skins),
	Fun2 = fun(Skin,{CountAcc2,BinAcc2}) ->
				   %% ?MSG_ECHO("------------------~w~n",[ Skin]),
				  SkinBinAcc= msg_skins(Skin),
				   %% ?MSG_ECHO("------------------~w~n",[ Skin]),
				   %% ?MSG_ECHO("------------------~w~n",[ SkinBinAcc]),
				  {CountAcc2+1,<<SkinBinAcc/binary,BinAcc2/binary>>}
		  end,
	{Count,SkinBin}= lists:foldl(Fun2, {0,<<>>}, Skins2),
	CountBin= app_msg:encode([{?int8u,Count}]),
	msg_hh_reply_msg(SkinId,CountBin,SkinBin).

huanhua(SkinId) ->
	Pet= role_api_dict:pet_get(),
	#pet{skin_id= SkinId1, unreal_skin= Skins}= Pet,
	%% ?MSG_ECHO("-----------------~w~n",[{SkinId,SkinId1,Skins}]),
	case SkinId =/= SkinId1 andalso lists:member(SkinId, Skins) of
		?true ->
			Pet2= Pet#pet{skin_id= SkinId},
			role_api_dict:pet_set(Pet2),
			%% ?MSG_ECHO("------------------~w~n",[ Skins]),
%% 			Bin1= huanhua(),
			msg_huanhua_reply(1);
%% 			<<Bin1/binary,Bin2/binary>>;
		_ ->
			%% ?MSG_ECHO("------------------~w~n",[ Skins]),
%% 			Bin1= huanhua(),
			msg_huanhua_reply(2)
%% 			<<Bin1/binary,Bin2/binary>>
	end.

rmb_exp(Type,#pet{gold_ten_opp = Opp, good_exp= GoodExp, gold_exp= GoldExp, gold_time= GoldTime}) ->
	GoodsId= ?CONST_PET_GOODS_ID,
	case Type =:= 1 of
		?true ->
			Count= bag_api:goods_id_count_get(GoodsId),
			Count1= ?IF(Count>=1, 0, 1),                             %% 使用钻石的个数
			Exp= ?IF(Count1==0,GoodExp,GoldExp*is_five(Opp, GoldTime)),
			%% ?MSG_ECHO("-----------------~w~n",[Exp]),
			GoodsList = case Count == 0 of 
							?true ->
								[];
							_ ->
								[{GoodsId, 1-Count1}]
						end,
			{Count1*?CONST_PET_RMB, Exp, GoodsList};
		_ ->
			Count = bag_api:goods_id_count_get(GoodsId),  
			Count1= ?IF(Count>=?CONST_PET_SENIOR_TIMES,0,?CONST_PET_SENIOR_TIMES- Count),  %% 使用钻石的个数
			GoodsList = case Count == 0 of 
							?true ->
								[];
							_ ->
								[{GoodsId, ?CONST_PET_SENIOR_TIMES - Count1}]
						end,
%% 			Exp= ?IF(Count1==0,GoodExp,GoldExp),
			Exp= get_exp(0, GoldExp, GoldTime, Opp, Count1),
			%% ?MSG_ECHO("-----------------~w~n",[Exp]),
			
			{?CONST_PET_RMB* Count1, GoodExp* (?CONST_PET_SENIOR_TIMES- Count1)+ Exp, GoodsList}
	end.

call(Id) ->
	Pet = role_api_dict:pet_get(),
	#pet{skill_id= SkillId, skills= Skills}= Pet,
	%% ?MSG_ECHO("-----------------~w~n",[{Id,SkillId,Skills}]),
	case Id=/=SkillId andalso lists:member(Id, Skills) of
		?true ->
			role_api_dict:pet_set(Pet#pet{skill_id=Id}),
			{?ok, msg_call_ok()};
		_ ->
			{?error,?ERROR_PET_CALL_ERROR}
	end.

player_att_refresh(Pet, Player)->
	PetAttr=pet_att(Pet),
	AttrGroup=role_api_dict:attr_group_get(),
	NewAttrGroup= AttrGroup#attr_group{pet=PetAttr},
	Player2= role_api:attr_update_player(Player, pet, PetAttr),
	%% ?MSG_ECHO("-----------------~w~n",[NewAttrGroup]),
	role_api_dict:attr_group_set(NewAttrGroup),
	Player2.

pet_att(Pet) ->
	#pet{hp=Hp,skill_att=SkillAtt,skill_def=SkillDef,strong_def=StrongDef,strong_att=StrongAtt}= Pet,
	#attr{hp=Hp,skill_att=SkillAtt,skill_def=SkillDef,strong_def=StrongDef,strong_att=StrongAtt}.

%% 获取宠物技能
pet_skill() ->
	#pet{skill_id=SkillId,lv= Lv}= role_api_dict:pet_get(),
	case SkillId == 0 of
		?true ->
			%% ?MSG_ECHO("=========== ~w~n",[{SkillId,Lv}]),
			{0,0};
		_ ->
			%% ?MSG_ECHO("=========== ~w~n",[{SkillId,Lv}]),
			{SkillId,Lv}
	end.

%% GM命令 提升魔宠等级
level_up(Pet= #pet{lv= Lv},PetLv2,#player{lv= PlayerLv}= Player) ->
	%% ?MSG_ECHO("=========== ~w~n",[Lv]),
	case Lv >= PetLv2 of
		?true ->
			%% ?MSG_ECHO("=========== ~w~n",[Lv]),
			Player;
		_ ->
			case Lv >= PlayerLv of
				?true ->
					%% ?MSG_ECHO("=========== ~w~n",[Lv]),
					Player;
				_ ->
					%% ?MSG_ECHO("=========== ~w~n",[Lv]),
					{_ok,Pet2}= pet_mod:level_up(Pet,PlayerLv),
					role_api_dict:pet_set(Pet2),
					Player2= player_att_refresh(Pet2, Player),
					%% ?MSG_ECHO("=========== ~w~n",[Lv]),
					level_up(Pet2,PetLv2,Player2)
			end
	end.


%% 获取宠物的皮肤id
pet_skin(Lv) ->
	case Lv >= ?CONST_PET_OPEN_LV of
		?true ->
			#pet{skin_id= SkinId}= role_api_dict:pet_get(),
			SkinId;
		_ ->
			0
	end.
			
% 返回宠物列表 [22820]
msg_reverse(Lv,SkinId,SkillId,Exp,CountBin1, SkillBin,CountBin2,SkinBin)->
	%% ?MSG_ECHO("-------------------------~w~n",[{Lv,SkinId,SkillId,Exp,CountBin1, SkillBin,CountBin2,SkinBin}]),
    RsList = app_msg:encode([{?int8u,Lv},{?int16u,SkinId},{?int16u,SkillId},{?int16u,Exp}]),
    app_msg:msg(?P_PET_REVERSE, <<RsList/binary,CountBin1/binary,SkillBin/binary,CountBin2/binary,SkinBin/binary>>).

% 技能信息块 [22825]
msg_skills(SkillId)->
    app_msg:encode([{?int16u,SkillId}]).

% 皮肤信息块 [22827]
msg_skins(SkinId)->
    app_msg:encode([{?int16u,SkinId}]).

% 修炼需要钻石返回 [22875]
msg_need_rmb_reply(Rmb)->
    RsList = app_msg:encode([{?int16u,Rmb}]),
    app_msg:msg(?P_PET_NEED_RMB_REPLY, RsList).

% 魔宠修炼成功返回 [22885]
msg_xiulian_ok()->
    app_msg:msg(?P_PET_XIULIAN_OK,<<>>).

% 幻化成功返回 [22950]
msg_huanhua_reply(Type)->
    RsList = app_msg:encode([{?int8u,Type}]),
    app_msg:msg(?P_PET_HUANHUA_REPLY, RsList).

% 召唤式神成功返回 [22860]
msg_call_ok()->
    app_msg:msg(?P_PET_CALL_OK,<<>>).

% 幻化界面返回 [23010]
msg_hh_reply_msg(SkinId,CountBin,SkinsBin)->
	SkinIdBin= app_msg:encode([{?int16u,SkinId}]),
    app_msg:msg(?P_PET_HH_REPLY_MSG, <<CountBin/binary,SkinIdBin/binary,SkinsBin/binary>>).

