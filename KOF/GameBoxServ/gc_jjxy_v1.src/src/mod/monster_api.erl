%% Author: Kevin
%% Created: 2012-9-11
%% Description: TODO: Add description to lib_mask
-module(monster_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
%%
%% Exported Functions
%%
-export([make/2]).

%%
%% API Functions
%%

%% ConfigID,SceneId
make(0,_SceneId) -> 0;
make(1,SceneId)  -> 
	MonsterIDs = data_scene_monster:scene(SceneId),
	case odds_list(MonsterIDs) of
		0 ->
			0;
		MonsterID ->
			make(MonsterID,SceneId)
	end;
make(ConfigID,SceneId) when ConfigID < 100  ->
	case util:rand_odds(ConfigID*?CONST_PERCENT_FAST,?CONST_PERCENT) of
		?true ->
			MonsterIDs = data_scene_monster:scene(SceneId),
			case odds_list(MonsterIDs) of
				0 ->
					0;
				MonsterID ->
					make(MonsterID,SceneId)
			end;
		?false -> 0
	end;
make(MonsterID,_SceneId)  -> 
	case data_scene_monster:get(MonsterID) of
		Monster when is_record(Monster,d_monster) ->
			MonsterMid = idx_api:monster_mid(),
			{MonsterMid,MonsterID,(Monster#d_monster.attr)#attr.hp,Monster#d_monster.ai_id,Monster#d_monster.monster_type,
			 Monster#d_monster.delay,Monster#d_monster.steps};
		_ ->
			?MSG_ECHO("------no monster------~w~n",[MonsterID]),
			0
	end.

odds_list([]) ->
	0;
odds_list(MonsterIds) ->
	Count = length(MonsterIds),
	Idx = util:uniform(Count),
	lists:nth(Idx,MonsterIds).