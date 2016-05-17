%% Author  : Kevin
%% Created: 2012-9-5
%% Description: TODO: Add description to role_mod
-module(top_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


%%
%% Exported Functions
%%

-export([
		 top_updata_handle/3,
		 top_lv_updata/1,
		 top_create_updata/1,
		 top_arena_updata/1,
		 top_arena_updata_cb/2,
		 top_power_updata/1,
%% 		 top_rank/1,
		 top_self_rank/2,
		 
		 msg_date/3]).



%%
%% Local Functions
%%

top_create_updata(Player=#player{info=Info})->
	InnPowerful=inn_api:inn_powerful(),
	Power=Info#info.powerful+InnPowerful,
	top_srv:top(?CONST_TOP_TYPE_LV,Player,Power),
	top_srv:top(?CONST_TOP_TYPE_POWER,Player,Power).

top_lv_updata(Player=#player{info=Info})->
	InnPowerful=inn_api:inn_powerful(),
	Power=Info#info.powerful+InnPowerful,
	top_srv:top(?CONST_TOP_TYPE_LV,Player,Power).

top_power_updata(Player=#player{info=Info})->
	InnPowerful=inn_api:inn_powerful(),
	Power=Info#info.powerful+InnPowerful,
	top_srv:top(?CONST_TOP_TYPE_POWER,Player,Power).

top_arena_updata(Ranks)->
	Fun=fun({Uid,Rank})->
				case role_api:mpid(Uid) of
					Mpid when is_pid(Mpid)->
						util:pid_send(Mpid,?MODULE,top_arena_updata_cb,Rank);
					_->
						case ets:lookup(?ETS_OFFLINE_SUB,{Uid,player}) of
							[{_PlayerKey,_,Player}|_] when is_record(Player,player)->
								top_arena_updata_cb(Player,Rank);
							_->
								?skip
						end
				end
		end,
	lists:map(Fun,Ranks).

top_arena_updata_cb(Player,Rank)->
	top_srv:top(?CONST_TOP_TYPE_ARENA,Player,Rank),
	Player.

top_updata_handle(?CONST_TOP_TYPE_LV,#player{uid=Uid,uname=Name,uname_color=NameColor,lv=Lv},Power)->
	ClanId=clan_api:clan_id_get(Uid),
	ClanName=clan_api:clan_name_get(Uid),
	case ets:lookup(?ETS_TOP_NGC,Uid) of
		[TopNgc|_]->
			TopNgc2=TopNgc#top_ngc{uid = Uid, name = Name, name_color = NameColor,clan_id = ClanId, clan_name = ClanName, lv = Lv},
			ets:insert(?ETS_TOP_NGC,TopNgc2);
		_->
			TopNgc2=#top_ngc{uid = Uid, name = Name, name_color = NameColor,clan_id = ClanId, clan_name = ClanName, lv = Lv},
			ets:insert(?ETS_TOP_NGC,TopNgc2)
	end,
	mysql_api:replace(top_ngc,[{uid,Uid},{name,Name},{name_color,NameColor},{rank,TopNgc2#top_ngc.rank},
							   {clan_id,ClanId},{clan_name,ClanName},{lv,Lv},{powerful,Power}]);

top_updata_handle(?CONST_TOP_TYPE_POWER,#player{uid=Uid,lv=Lv,uname=Name,uname_color=NameColor},Power)->
	ClanId=clan_api:clan_id_get(Uid),
	ClanName=clan_api:clan_name_get(Uid),
	case ets:lookup(?ETS_TOP_NGC,Uid) of
		[TopNgc|_]->
			TopNgc2=TopNgc#top_ngc{uid = Uid, name = Name, name_color = NameColor,clan_id = ClanId, clan_name = ClanName,powerful=Power},
			ets:insert(?ETS_TOP_NGC,TopNgc2),
			mysql_api:replace(top_ngc,[{uid,Uid},{name,Name},{name_color,NameColor},{rank,TopNgc2#top_ngc.rank},
							   {clan_id,ClanId},{clan_name,ClanName},{lv,Lv},{powerful,Power}]);
		_->
			?skip
	end;

top_updata_handle(?CONST_TOP_TYPE_ARENA,#player{uid=Uid,lv=Lv,uname=Name,uname_color=NameColor},Rank)->
	ClanId=clan_api:clan_id_get(Uid),
	ClanName=clan_api:clan_name_get(Uid),
	case ets:lookup(?ETS_TOP_NGC,Uid) of
		[TopNgc|_]->
			TopNgc2=TopNgc#top_ngc{uid = Uid, name = Name, name_color = NameColor,clan_id = ClanId, clan_name = ClanName,rank=Rank},
			ets:insert(?ETS_TOP_NGC,TopNgc2),
			mysql_api:update(top_ngc,[{lv,Lv},{clan_id,ClanId},{clan_name,ClanName},{rank,TopNgc2#top_ngc.rank}],"uid="++util:to_list(Uid));
		_->
			?skip
	end;

top_updata_handle(_,_,_)->
	?skip.

top_rank2([],_,_,Acc)->Acc;
top_rank2([TopNgc|List],Ranks,N,Acc)->
	case N=<Ranks of
		?true->
			Acc2=[TopNgc#top_ngc{rank=N}|Acc],
			top_rank2(List,Ranks,N+1,Acc2);
		_->
			top_rank2(List,Ranks,N,Acc)
	end.

	
top_rank(RankList)->
	Ranks=length(RankList),
	top_rank2(RankList,Ranks,1,[]).

top_self_rank(Type,Uid)->
	List=ets:tab2list(?ETS_TOP_NGC),
	L=lists:seq(1,500),
	case Type of
		?CONST_TOP_TYPE_ARENA->
			List2=lists:keysort(#top_ngc.rank,[Top||Top<-List,Top#top_ngc.rank>0]),
			Arena=role_api_dict:arena_get(),
			SelfRank=Arena#arena.ranking;
		?CONST_TOP_TYPE_LV->
			List11=lists:keysort(#top_ngc.uid,List),
			List2=lists:reverse(lists:keysort(#top_ngc.lv,List11)),
			SelfRank=top_self_rank2(L,List2,Uid);
		?CONST_TOP_TYPE_POWER->
			List11=lists:keysort(#top_ngc.uid,List),
			List2=lists:reverse(lists:keysort(#top_ngc.powerful,List11)),
			SelfRank=top_self_rank2(L,List2,Uid);
		_->
			List2=List,
			SelfRank=top_self_rank2(L,List2,Uid)
	end,
	RankList=lists:sublist(List2,?CONST_TOP_RANK_20),
	RankList20=top_rank(RankList),
	{SelfRank,RankList20}.

top_self_rank2(_,[],_Uid)->500+1;
top_self_rank2([],_List,_Uid)->500+1;
top_self_rank2([R|L],List,Uid)->
	case lists:nth(R,List) of
		#top_ngc{uid=TopUid}->
			?IF(TopUid==Uid,R,top_self_rank2(L,List,Uid));
		_->
			top_self_rank2(L,List,Uid)
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% msg_xxxx?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 排行榜信息 [24820]
msg_date(Type,SelfRank,List)->
	RsList = app_msg:encode([{?int8u,Type},{?int16u,SelfRank},{?int16u,length(List)}]),
	Fun=fun(TopNgc,Acc)->
				#top_ngc{rank=Rank,uid=Uid,name=Name,name_color=NameColor,clan_id=ClanId,
						 clan_name=ClanName,lv=Lv,powerful=Power}=TopNgc,
				Rs = app_msg:encode([{?int16u,Rank},
									 {?int32u,Uid},{?string,Name},
									 {?int8u,NameColor},{?int16u,ClanId},
									 {?string,ClanName},{?int16u,Lv},
									 {?int32u,Power}]),
				<<Acc/binary,Rs/binary>>
		end,
	RsList2=lists:foldl(Fun,RsList,List),
	app_msg:msg(?P_TOP_DATE, RsList2).
