%% Author: Administrator
%% Created: 2012-11-14
%% Description: TODO: Add description to honor_api
-module(pet_mod).

%%
%% Include files
%%
-include("../include/comm.hrl"). 

%%
%% Exported Functions
%%
-export([exp_add_acc/3,
		 level_up/2]).

%% 加经验
exp_add_acc(Pet, Exp,_PlayerLv) when Exp =< 0 -> 
	?MSG_ECHO("----------------------~w~n",[Exp]),
	{?ok,Pet};
exp_add_acc(Pet= #pet{lv= Lv,exp= ExpLv, next_exp= NextExp},Exp, PlayerLv)->
	ExpLack = abs(NextExp - ExpLv),
	NewExp  = Exp + ExpLv,
	case Exp >= ExpLack of  
		?true->
%% 			LvMax = ?CONST_PET_MAX_LV,
%% 			if
%% 				is_integer(LvMax),LvMax =/= 0,Lv >= LvMax ->
%% 					Pet#pet{exp=erlang:min(NewExp, NextExp)};
%% 				?true ->
%% 					?MSG_ECHO("----------------------~w~n",[Pet]),
					case level_up(Pet, PlayerLv) of
						{?ok, Pet2} ->
							exp_add_acc(Pet2, Exp - ExpLack, PlayerLv);
						{?error, Pet2} ->
							{?error, Pet2}
%% 					end
			end;				
		_ -> 
			{?ok,Pet#pet{exp=NewExp}}
	end.

level_up(Pet= #pet{lv= Lv},PetLv2,PlayerLv) ->
	case Lv >= PetLv2 of
		?true ->
			Pet;
		_ ->
			case Lv >= PlayerLv of
				?true ->
					Pet;
				_ ->
					Pet2= level_up(Pet,PlayerLv),
					level_up(Pet2,PetLv2,PlayerLv)
			end
	end.

%% 升级
level_up(Pet= #pet{lv= Lv,skills= Skills,next_exp= Exp2}, PlayerLv) ->
	Lv2= Lv+ 1,
	case Lv2 =< ?CONST_PET_MAX_LV of
		?true ->
			case Lv2 =< PlayerLv of
				?true ->
					case data_pet:get(Lv2) of
						#d_pet{hp=Hp,next_exp=NextExp,skill_att=SkillAtt,skill_def=SkillDef,strong_att=StrongAtt,strong_def=StrongDef,unreal_skin=Skins} ->
							Pet2= Pet#pet{lv=Lv2,next_exp=NextExp,hp=Hp,exp=0,skill_att=SkillAtt,skill_def=SkillDef,unreal_skin=Skins,strong_def=StrongDef,strong_att=StrongAtt},
							%% 					pet_api:player_att_refresh(Pet2),
							case data_pet_skill:get(Lv2) of
								#d_pet_skill{skill=SkillId} ->
									{?ok,Pet2#pet{skills=[SkillId|Skills]}};
								_ ->
									{?ok,Pet2}
							end;
						_->
							{?ok,Pet}
					end;
				_ ->
					{?error,?ERROR_PET_PLAYER_LV}
			end;
		_ ->
			{?error,?ERROR_PET_STEP_MAX}
	end.



	