%% Author: mirahs
%% Created: 2011-12-17
%% Description: TODO: Add description to copy_api
-module(copy_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions  
%%
-export([
		 decode_chapcopy/1,
		 encode_chapcopy/1,
		 decode_upcopy/1, 
		 encode_upcopy/1,
		 init_chapcopy/1,
		 init_chapcopy/0,
		 init_upcopy/1,
		 
		 copy_over_id/1,
		 copy_over_chap/1,
		 copy_over_all/0,
		 check_over/1,
		 
		 interval/0,
		 login/0,
		 up_login/1,
		 refresh/2,
		 logout/1,
		 relink/1,
		 lv_copy_id/1,
		 check_team/2,
		 check_add_copy/6,
		 get_copy_up_reward/2,
		 
		 up_start_cb/1,
		 up_add_cb/2,
		 up_start/4,
		 up_speed/1,
		 up_stop/1,
		 chap_reward/2,
		 
		 copy_start/4,
		 copy_start_first/3,
		 start_clan/2,
		 start/4,
		 start_acc_cb1/2,
		 start_acc_cb2/2,
		 start_team_cb/2,
		 
		 timing/2,
		 switch/1, 
		 switch_cb/2,
		 monster_list/1,
		 exit_copy/1,
		 exit/2,
		 notice_over/5,
		 move/3,
		 
		 check_copy_data/1,
		 reset_copy_state/1,
		 
		 require_info/1,
		 times_max_day/1,
		 
		 %chap_info/4,
		 chap_info_new/1,
		 chap_info_new/2,
		 chap_reward_req/2,
		 
		 msg_chap_data/3,
		 msg_chap_data_new/3,
		 msg_enter_scene_info/3,
		 msg_time_update/1,
		 msg_scene_time/1,
		 msg_scene_over/0,
		 msg_over/11,
		 msg_fail/0,
		 msg_relive/1,
		 msg_up_over/2,
		 msg_up_result/7,
		 msg_chap_reward_rep/1,
		 msg_exit_ok/0
		]).

%%
%% API Functions
%%
encode_chapcopy(ChapCopy) ->
	ChapCopy.

%% decode_chapcopy(ChapCopy) ->
%% 	case is_record(ChapCopy,chapcopy) of
%% 		?true ->
%% 			ChapCopy;
%% 		_ ->
%% 			init_chapcopy()
%% 	end.

decode_chapcopy(ChapCopy) when is_record(ChapCopy,chapcopy) ->
	ChapCopy;
decode_chapcopy({chapcopy,Date,ChapId,UseIds,Copys}) ->
	#chapcopy{date=Date,chap_id=ChapId,use_id=UseIds,copys=Copys};
decode_chapcopy(_ChapCopy) ->
	init_chapcopy().

encode_upcopy(UpCopy) ->
	UpCopy.

decode_upcopy(UpCopy) ->
	case is_record(UpCopy,upcopy) of
		?true ->
			UpCopy;
		_ ->
			init_upcopy()
	end.

init_chapcopy(Player) ->
	ChapCopy = init_chapcopy(),
	{Player,ChapCopy}.

init_chapcopy() ->
	[ChapId|_] = data_copy_chap:gets_normal(),
	#chapcopy{chap_id=ChapId}.

init_upcopy(Player) ->
	UpCopy = init_upcopy(),
	{Player,UpCopy}.

init_upcopy() ->
	#upcopy{}.

copy_over_id(CopyId) ->
	case data_scene_copy:get(CopyId) of
		?null ->
			?skip;
		Dscene ->
			case Dscene#d_copy.copy_type of
				?CONST_COPY_TYPE_NORMAL ->
					ChapCopy = role_api_dict:copy_get(),
					#chapcopy{copys=CopySave} = ChapCopy,
					case CopySave of
						[] ->
							Save = over_copy_id_normal(Dscene),
							role_api_dict:copy_set(ChapCopy#chapcopy{copys=[Save]});
						_ ->
							case lists:keytake(CopyId, #copysave.id, CopySave) of
								{value,Copys,Tmp} ->
									NewSave = [Copys#copysave{is_pass=?CONST_TRUE}|Tmp],
									role_api_dict:copy_set(ChapCopy#chapcopy{copys=NewSave});
								_ ->
									Save = over_copy_id_normal(Dscene),
									NewSave = [Save|CopySave],
									role_api_dict:copy_set(ChapCopy#chapcopy{copys=NewSave})
							end
					end;
				?CONST_COPY_TYPE_HERO ->
					ChapHero = role_api_dict:hero_get(),
					#hero{copys=CopySave} = ChapHero,
					case CopySave of
						[] ->
							Save = over_copy_id_hero(Dscene),
							role_api_dict:hero_set(ChapHero#hero{copys=[Save],default=?false});
						_ ->
							case lists:keytake(CopyId, #herosave.id, CopySave) of
								{value,Copys,Tmp} ->
									NewSave = [Copys#herosave{is_pass=?CONST_TRUE}|Tmp],
									role_api_dict:copy_set(ChapHero#hero{copys=NewSave});
								_ ->
									Save = over_copy_id_hero(Dscene),
									NewSave = [Save|CopySave],
									role_api_dict:hero_set(ChapHero#hero{copys=NewSave})
							end
					end;
				?CONST_COPY_TYPE_FIEND ->
					ChapFiend = role_api_dict:fiend_get(),
					#fiend{copys=CopySave} = ChapFiend,
					case CopySave of
						[] ->
							Save = over_copy_id_fiend(Dscene),
							role_api_dict:fiend_set(ChapFiend#fiend{copys=[Save]});
						_ ->
							case lists:keytake(CopyId, #fiendsave.id, CopySave) of
								{value,Copys,Tmp} ->
									NewSave = [Copys#fiendsave{is_pass=?CONST_TRUE}|Tmp],
									role_api_dict:fiend_set(ChapFiend#fiend{copys=NewSave});
								_ ->
									Save = over_copy_id_fiend(Dscene),
									NewSave = [Save|CopySave],
									role_api_dict:fiend_set(ChapFiend#fiend{copys=NewSave})
							end
					end;
				?CONST_COPY_TYPE_FIGHTERS ->
					ChapFighters = role_api_dict:fighters_get(),
					#fighters{copys=CopySave} = ChapFighters,
					case CopySave of
						[] ->
							Save = over_copy_id_fighters(Dscene),
							role_api_dict:fighters_set(ChapFighters#fighters{copys=[Save]});
						_ ->
							case lists:keytake(CopyId, #figsave.id, CopySave) of
								{value,Copys,Tmp} ->
									NewSave = [Copys#figsave{is_pass=?CONST_TRUE}|Tmp],
									role_api_dict:fighters_set(ChapFighters#fighters{copys=NewSave});
								_ ->
									Save = over_copy_id_fighters(Dscene),
									NewSave = [Save|CopySave],
									role_api_dict:fighters_set(ChapFighters#fighters{copys=NewSave})
							end
					end;
				_ ->
					?skip
			end
	end.

over_copy_id_normal(#d_copy{copy_id=Id,key_id=KeyId,belong_id=BelongId}) ->
	SumTimes= times_max_day(KeyId),
	NewSave = #copysave{id=Id,keyid=KeyId,belongid=BelongId,sumtimes=SumTimes,is_pass=?CONST_TRUE},
	NewSave.

over_copy_id_hero(#d_copy{copy_id=Id,key_id=KeyId,belong_id=BelongId}) ->
	NewSave = #herosave{id=Id,keyid=KeyId,belongid=BelongId,is_pass=?CONST_TRUE},
	NewSave.

over_copy_id_fiend(#d_copy{copy_id=Id,key_id=KeyId,belong_id=BelongId}) ->
	NewSave = #fiendsave{id=Id,keyid=KeyId,belongid=BelongId,is_pass=?CONST_TRUE},
	NewSave.

over_copy_id_fighters(#d_copy{copy_id=Id,key_id=KeyId,belong_id=BelongId}) ->
	NewSave = #figsave{id=Id,keyid=KeyId,belongid=BelongId,is_pass=?CONST_TRUE},
	NewSave.

copy_over_chap(ChapId) ->
	case data_copy_chap:get(?CONST_COPY_TYPE_NORMAL, ChapId) of
		#d_copy_chap{copy_id=Ids} ->
			copy_over_chap_acc(Ids);
		_ ->
			case data_copy_chap:get(?CONST_COPY_TYPE_HERO, ChapId) of
				#d_copy_chap{copy_id=Ids} ->
					copy_over_chap_acc(Ids);
				_ ->
					case data_copy_chap:get(?CONST_COPY_TYPE_FIEND, ChapId) of
						#d_copy_chap{copy_id=Ids} ->
							copy_over_chap_acc(Ids);
						_ ->
							case data_copy_chap:get(?CONST_COPY_TYPE_FIGHTERS, ChapId) of
								#d_copy_chap{copy_id=Ids} ->
									copy_over_chap_acc(Ids);
								_ ->
									?skip
							end
					end
			end
	end.

copy_over_all() ->
	Ids = data_scene_copy:ids(),
	copy_over_chap_acc(Ids).

copy_over_chap_acc([]) ->
	?skip;
copy_over_chap_acc([Id|Ids]) ->
	copy_over_id(Id),
	copy_over_chap_acc(Ids).

check_over(CopyId) ->
	%?MSG_ECHO("-----------------~w~n",[CopyId]),
	case data_scene_copy:get(CopyId) of
		#d_copy{copy_type=CopyType} ->
			%?MSG_ECHO("-----------------~w~n",[{CopyId,CopyType}]),
			check_over(CopyType,CopyId);
		_ ->
			?false
	end.

check_over(?CONST_COPY_TYPE_NORMAL,CopyId) ->
	%?MSG_ECHO("-----------------~w~n",[CopyId]),
	#chapcopy{copys=Copys} = role_api_dict:copy_get(),
	case lists:keyfind(CopyId, #copysave.id, Copys) of
		#copysave{} ->
			%?MSG_ECHO("-----------------~w~n",[CopyId]),
			?true;
		_ ->
			%?MSG_ECHO("-----------------~w~n",[CopyId]),
			?false
	end;
check_over(?CONST_COPY_TYPE_HERO,CopyId) ->
	%?MSG_ECHO("-----------------~w~n",[CopyId]),
	#hero{copys=Copys} = role_api_dict:hero_get(),
	case lists:keyfind(CopyId, #herosave.id, Copys) of
		#herosave{} ->
			%?MSG_ECHO("-----------------~w~n",[CopyId]),
			?true;
		_ ->
			%?MSG_ECHO("-----------------~w~n",[CopyId]),
			?false
	end;
check_over(?CONST_COPY_TYPE_FIEND,CopyId) ->
	%?MSG_ECHO("-----------------~w~n",[CopyId]),
	#fiend{copys=Copys} = role_api_dict:fiend_get(),
	case lists:keyfind(CopyId, #fiendsave.id, Copys) of
		#fiendsave{} ->
			%?MSG_ECHO("-----------------~w~n",[CopyId]),
			?true;
		_ ->
			%?MSG_ECHO("-----------------~w~n",[CopyId]),
			?false
	end;
check_over(?CONST_COPY_TYPE_FIGHTERS,CopyId) ->
	%?MSG_ECHO("-----------------~w~n",[CopyId]),
	#fighters{copys=Copys} = role_api_dict:fighters_get(),
	case lists:keyfind(CopyId, #figsave.id, Copys) of
		#figsave{} ->
			%?MSG_ECHO("-----------------~w~n",[CopyId]),
			?true;
		_ ->
			%?MSG_ECHO("-----------------~w~n",[CopyId]),
			?false
	end;
check_over(_,CopyId) ->
	?MSG_ERROR("----------~w~n",[CopyId]),
	?false.

%% 定时调用
interval() ->
%%  ?MSG_ECHO("copy interval......~n", []),
	CopyWorker = copy_sup:which_children(),
	interval(CopyWorker).

interval([{?undefined,Pid,worker,[copy_srv]}|CopyWorker]) ->
	copy_srv:interval_cast(Pid),
	interval(CopyWorker);
interval([]) ->
	?ok.

login() ->
	Date = util:date(),
	ChapCopy = role_api_dict:copy_get(),
	case ChapCopy#chapcopy.date of
		Date ->
			?skip;
		_ ->		
			NewSave = login(ChapCopy#chapcopy.copys),
			role_api_dict:copy_set(ChapCopy#chapcopy{copys=NewSave})
	end.

login(Saves) ->
	Fun = fun(Save,Acc) ->
				  [Save#copysave{times=0}|Acc]
		  end,
	lists:foldl(Fun, [], Saves).

refresh(CopyId,MapType) ->
	Date = util:date(),
	ChapCopy = role_api_dict:copy_get(),
	case ChapCopy#chapcopy.date of
		Date ->
			?skip;
		_ ->
			NewSave = refresh_check(ChapCopy#chapcopy.copys,CopyId,MapType),
			role_api_dict:copy_set(ChapCopy#chapcopy{copys=NewSave})
	end.

refresh_check(Save,CopyId,?CONST_MAP_TYPE_COPY_NORMAL) ->
	Fun = fun(F=#copysave{id=Fid},Acc) ->
				  if Fid =:= CopyId ->
						 [F|Acc];
					 ?true ->
						 [F#copysave{times=0}|Acc]
				  end
		  end,
	lists:foldl(Fun, [], Save);
refresh_check(Save,_CopyId,_MapType) ->
	login(Save).

up_login(#player{socket=Socket,mpid=Mpid}=Player) ->
	%?MSG_ECHO("------------------~n",[]),
	UpCopy = role_api_dict:upcopy_get(),
	#upcopy{cdtime=CdTime,use_all=UseAll,etime=Etime,id=CopyId,type=CopyType,btime=Btime,power=Power,nowtimes=NowTimes,
			uphistory=UpHistory,sumtimes=SumTimes,energy=Energy,stop=Stop,exp=Exp,gold=Gold,reward=Rewards} = UpCopy,
	case Stop of
		?true ->
			%?MSG_ECHO("------------------~n",[]),
			Player;
		_ ->
			Time	= util:seconds(),				% 当前时间
			UseTime = Time - Btime,					% 已挂机时间
			HaveTimes	= UseTime div CdTime,		% 已挂机次数
			WorkTime = UseTime rem CdTime,			% 已调用的时间(已过的时间)
			FreeTime = CdTime - WorkTime,			% 下次调用的时间	{2,3,5,1,59}
			%?MSG_ECHO("==========================~w~n",[{Btime,Time,Etime,CdTime}]),
			%?MSG_ECHO("================~w~n",[{HaveTimes,NowTimes,SumTimes,WorkTime,FreeTime}]),%{2,3,5,1,59}
			if HaveTimes =:= NowTimes ->
				   %?MSG_ECHO("================~w~n",[{HaveTimes,NowTimes,SumTimes,WorkTime,FreeTime}]),
				   SumFreeTime = Etime - Time,
				   BinMsg = msg_up_login_result(CopyId,NowTimes,SumTimes,SumFreeTime,UseAll,UpHistory),
				   app_msg:send(Socket, BinMsg),
				   timer:apply_after(FreeTime * 1000, ?MODULE, up_start_cb, [Mpid]),
				   Player;
			   HaveTimes >= SumTimes ->
				   %?MSG_ECHO("================~w~n",[{HaveTimes,NowTimes,SumTimes,WorkTime,FreeTime}]),
				   UpTimes = SumTimes - NowTimes,
				   %?MSG_ECHO("================~w~n",[UpTimes]),
				   Goods = copy_mod:get_goods(Rewards),
				   NewPlayer = up_fast_vip(Player,UpCopy,CopyId,CopyType,Exp,Gold,Power,Goods,Energy,NowTimes + 1,UpTimes),
				   UpCopy1 = role_api_dict:upcopy_get(),
				   BinMsg = msg_up_login_result(CopyId,SumTimes,SumTimes,0,UseAll,UpCopy1#upcopy.uphistory),
				   app_msg:send(Socket, BinMsg),
				   NewUpCopy = #upcopy{},
				   role_api_dict:upcopy_set(NewUpCopy),
				   NewPlayer;
			   HaveTimes > NowTimes ->
				   OffTimes = HaveTimes - NowTimes,
				   %?MSG_ECHO("================~w~n",[OffTimes]),
				   SumFreeTime = Etime - Time,
				   Goods = copy_mod:get_goods(Rewards),
				   NewPlayer = up_fast_vip(Player,UpCopy,CopyId,CopyType,Exp,Gold,Power,Goods,Energy,NowTimes + 1,OffTimes),
				   UpCopy1 = role_api_dict:upcopy_get(),
				   BinMsg = msg_up_login_result(CopyId,HaveTimes,SumTimes,SumFreeTime,UseAll,UpCopy1#upcopy.uphistory),
				   app_msg:send(Socket, BinMsg),
				   NewUpCopy = UpCopy1#upcopy{nowtimes=HaveTimes},
				   role_api_dict:upcopy_set(NewUpCopy),
				   timer:apply_after(FreeTime*1000, ?MODULE, up_start_cb, [Mpid]),
				   NewPlayer
			end
	end.

logout(Player) ->
	Player2 = logout_up_reward(Player),
	Player2.

relink(#player{socket=Socket,info=Info}=Player) ->
	case lists:member(Info#info.map_type, ?COPY_MAP_TYPES) of
		?true ->
			PlayerS = player_s_relink(Player),
			BinMsg = scene_api:msg_enter_ok(PlayerS, Info#info.map_id, ?CONST_MAP_ENTER_NULL),
			app_msg:send(Socket, BinMsg),
			Player;
		_ ->
			scene_api:enter_login(Player)
	end.

player_s_relink(Player) ->
	case scene_mod:get_player(Player#player.uid) of
		#player_s{} = PlayerS ->
			PlayerS;
		_ ->
			scene_mod:record_player_s(Player)
	end.

logout_up_reward(Player) ->
	UpCopy = role_api_dict:upcopy_get(),
	#upcopy{stop=Stop,up_speed=UpSpeed,nowtimes=NowTimes,sumtimes=SumTimes} = UpCopy,
	case Stop of
		?true ->
			Player;
		_ ->
			case UpSpeed of
				?false ->
					Player;
				_ ->
					Times = SumTimes - NowTimes,
					case Times > 0 of
						?true ->
							logout_up_reward(Player,Times);
						_ ->
							Player
					end
			end
	end.

logout_up_reward(Player,Times) ->
	UpCopy = role_api_dict:upcopy_get(),
	#upcopy{id=CopyId,type=CopyType,exp=Exp,gold=Gold,power=Power,reward=Rewards,energy=Energy} = UpCopy,
	Player2 = logout_up_speed(Player,CopyId,CopyType,Exp,Gold,Power,Rewards,Energy,Times),
	NewUpCopy = #upcopy{},
	role_api_dict:upcopy_set(NewUpCopy),
	Player2.
	
logout_up_speed(Player,_CopyId,_CopyType,_Exp,_Gold,_Power,_Rewards,_Energy,0) ->
	Player;
logout_up_speed(#player{socket=Socket}=Player,CopyId,CopyType,Exp,Gold,Power,Rewards,CopyEnergy,SumTimes) ->
	Goods = copy_mod:get_goods(Rewards),
	up_del_times(CopyType,CopyId),
	Player2	= role_api:exp_add(Player, Exp,up_fast_vip,<<"副本快速挂机奖励:",(util:to_binary(CopyId))/binary>>),
	{Player3,Bin1} = role_api:currency_add([up_fast_vip,[],<<"副本快速挂机奖励">>],Player2,[{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_ADV_SKILL,Power}]),
	Bag = role_api_dict:bag_get(),
	case bag_api:goods_set([up_fast_vip,[],<<"副本快速挂机奖励">>],Player3,Bag,Goods) of
		{?ok,Player4,Bag2,GoodsBin,LogBin} ->
			role_api_dict:bag_set(Bag2),
			case energy_api:energy_use([up_fast_vip,CopyEnergy,<<"副本快速挂机消耗">>], Player4, CopyEnergy) of
				{?ok,EnergyPlayer,EnergyBin} ->
					app_msg:send(Socket, <<Bin1/binary,GoodsBin/binary,LogBin/binary,EnergyBin/binary>>),
					logout_up_speed(EnergyPlayer,CopyId,CopyType,Exp,Gold,Power,Rewards,CopyEnergy,SumTimes-1);
				{?error,_ErrorCode} ->
					app_msg:send(Socket, <<Bin1/binary,GoodsBin/binary,LogBin/binary>>),
					logout_up_speed(Player4,CopyId,CopyType,Exp,Gold,Power,Rewards,CopyEnergy,SumTimes-1)
			end;
		{?error,_ErrorCode} ->
			logout_up_speed(Player3,CopyId,CopyType,Exp,Gold,Power,Rewards,CopyEnergy,SumTimes-1)
	end.

lv_copy_id(Lv) ->
	Ids = data_keycopy:get_ids(),
	lv_copy_id(Ids,Lv).

lv_copy_id([Id|Ids],Lv) ->
	case data_keycopy:get(Id) of
		#d_keycopy{start_lv=Slv,end_lv=Elv,copy_id=CopyId} ->
			if Lv >= Slv andalso Lv =< Elv ->
				   CopyId;
			   ?true ->
				   lv_copy_id(Ids,Lv)
			end;
		_ ->
			lv_copy_id(Ids,Lv)
	end;
lv_copy_id([],_Lv) ->
	4010.

%% 检查副本数据
check_copy_data(CopyId) ->
	case data_scene_copy:get(CopyId) of
		#d_copy{scene=Scenes,key_id=KeyId,copy_type=CopyType,use_energy=UseEnergy} ->
			case Scenes of
				[] ->
					{?error,?ERROR_COPY_NO_SCENE_DATA};
				_ ->
					SceneList = [data_scene:scene(SceneId) || SceneId <- Scenes],
					case lists:member(?null, SceneList) of
						?false ->
							{?ok,KeyId,CopyType,UseEnergy};
						_ ->
							{?error,?ERROR_COPY_NO_SCENE_DATA}
					end
			end;
		_ ->
			{?error,?ERROR_COPY_NOT_COPY_DATA}
	end.

%% 重新进入副本检测并设置状态
reset_copy_state(#info{map_type=MapType}=Info) ->
	case  MapType of
		?CONST_MAP_TYPE_COPY_NORMAL ->
			Info#info{map_type=?CONST_MAP_TYPE_CITY};
		_ ->
			Info
	end.

copy_start(#player{socket=Socket,uid=Uid,team_id=TeamId}=Player,CopyId,CopyType,UseEnergy) ->
	case check_start_copy(Uid,CopyId,CopyType,TeamId) of
		?ok ->
			case start(Player,CopyId,CopyType,UseEnergy) of
				{?ok,Player2} ->
					Player2;
				{?error, ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg),
					Player
			end;
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			Player
	end.

copy_start_first(#player{uid=Uid,info=Info}=Player,CopyId,CopyType) ->
	scene_api:exit_scene(Player),
	copy_start_first_attr(Player),
	Pid = copy_sup:start_child_copy_srv(CopyId,?CONST_FALSE),
	PlayerS = [scene_api:ext_record_player_s(Player)],
	{CopyId, X, Y, MapId, Pid, MapType} = copy_srv:start_call(Pid,PlayerS),
	stat_api:logs_copy(Uid,CopyId,util:seconds(),?CONST_FALSE,CopyType),
	#info{pos_x=LastX,pos_y=LastY,map_id=LastMapId} = Info,
	Info2 = Info#info{pos_x = X,pos_y = Y,map_id = MapId,copy_id=CopyId,
					  pos_x_last = LastX,pos_y_last = LastY,map_last = LastMapId,map_type = MapType},
	Player#player{spid=Pid,info=Info2}.

copy_start_first_attr(#player{lv=Lv,pro=Pro}=Player) ->
	case Lv =< 1 of
		?true ->
			case data_player_initial:get(Pro) of
				#d_player_initial{attr=Attr} ->
					role_api:role_copy_attr(Player, Attr);
				_ ->
					?MSG_ERROR("=======NO PLAYER INITIAL DATA~n",[])
			end;
		_ ->
			?skip
	end.

check_start_copy(Uid,CopyId,CopyType,TeamId) ->
	case CopyType of
		?CONST_COPY_TYPE_NORMAL ->
			check_in_copy(CopyId);
		?CONST_COPY_TYPE_HERO ->
			hero_api:check_in_hero(CopyId);
		?CONST_COPY_TYPE_FIEND ->
			fiend_api:check_in_fiend(CopyId);
		?CONST_COPY_TYPE_FIGHTERS ->
			fighters_api:check_in_fighters(TeamId);
		?CONST_COPY_TYPE_CLAN ->
			case clan_active_api:enter_copy(Uid) of
				{?ok,CopyId} ->
					?ok;
				{?ok,ClanCopyId} ->
					?MSG_ERROR("ClanCopyId error ~w~n",[{ClanCopyId,CopyId}]),
					{?error,?ERROR_UNKNOWN};
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		_ ->
			{?error,?ERROR_UNKNOWN}
	end.

%% 进入副本检查
check_in_copy(CopyId) ->
	#chapcopy{copys=Save} = role_api_dict:copy_get(),
	case lists:keyfind(CopyId, #copysave.id, Save) of
		#copysave{times=Times,sumtimes=SumTimes} ->
			if Times < SumTimes orelse SumTimes =:= 0 ->
				   ?ok;
			   ?true ->
				   {?error, ?ERROR_COPY_COUNT_FULL}
			end;
		_ ->
			{?error, ?ERROR_COPY_NOT_COPY}
	end.

%% 进入帮派副本
start_clan(Player,CopyId) ->
	case Player#player.team_id of
		0 ->
			case data_scene_copy:get(CopyId) of
				#d_copy{copy_type=CopyType} ->
					case start(Player,CopyId,CopyType,0) of
						{?ok,Player2} ->
							Player2;
						_ ->
							Player
					end;
				_ ->
					Player
			end;
		_ ->
			Player
	end.

%% 进入副本
start(#player{mpid=SelfMpid,uid=Uid,info=Info,team_id=TeamId}=Player,CopyId,CopyType,UseEnergy) ->
	case TeamId of
		0 ->
			scene_api:exit_scene(Player),
			Pid = copy_sup:start_child_copy_srv(CopyId,?CONST_FALSE),
			PlayerS = [scene_api:ext_record_player_s(Player)],
			{CopyId, X, Y, MapId, Pid, MapType} = copy_srv:start_call(Pid,PlayerS),
			stat_api:logs_copy(Uid,CopyId,util:seconds(),?CONST_FALSE,CopyType),
			?IF(CopyType =:= ?CONST_COPY_TYPE_FIGHTERS, fighters_api:wartimes_add(Uid), ?skip),
			#info{pos_x=LastX,pos_y=LastY,map_id=LastMapId} = Info,
			Info2 = Info#info{pos_x = X,pos_y = Y,map_id = MapId,copy_id=CopyId,
								pos_x_last = LastX,pos_y_last = LastY,map_last = LastMapId,map_type	= MapType},
			{?ok,Player#player{spid=Pid,info=Info2}};
		_ ->
			case check_team(TeamId,SelfMpid) of
				{?ok,[]} ->
					{?error,?ERROR_COPY_PEOPLE_LACK};
				{?ok,MemPids} ->
					MemNum = length(MemPids),
					put(copy_team,{[],CopyId,CopyType,MemPids}),
					Fun = fun(Mpid) ->
								  util:pid_send(Mpid, ?MODULE, start_acc_cb1, {SelfMpid,MemNum,UseEnergy})
						  end,
					lists:foreach(Fun, MemPids),
					{?ok,Player}
			end
	end.

start_acc_cb1(#player{socket=Socket}=Player,{LeaderMpid,MemNum,UseEnergy}) ->
	{NewPlayer,Msg} =
		case bag_api:check_bag() of
			?false ->
				case energy_api:check_energy_copy(Player, UseEnergy) of
					?ok ->
						{Player,scene_api:ext_record_player_s(Player)};
					{?error,Player2,BinMsg} ->
						app_msg:send(Socket, BinMsg),
						{Player2,?null}
				end;
			_ ->
				{Player,?null}
		end,
	util:pid_send(LeaderMpid, ?MODULE, start_acc_cb2, {Msg,MemNum}),
	NewPlayer.

start_acc_cb2(#player{socket=Socket}=Player,{Msg,Num}) ->
	{Mems,CopyId,CopyType,MemPids} = get(copy_team),
	NewMems = [Msg|Mems],
	if length(NewMems) >= Num ->
		   case lists:member(?null, NewMems) of
			   ?false ->
				   Players = scene_api:ext_record_player_s(Player),
				   start_team(Player,CopyId,CopyType,MemPids,[Players|NewMems]);
			   _ ->
				   BinMsg = system_api:msg_error(?ERROR_COPY_MEMBER_LACK),
				   app_msg:send(Socket, BinMsg),
				   Player
		   end;
	   ?true ->
		   put(copy_team,{NewMems,CopyId,CopyType,MemPids}),
		   Player
	end.

start_team(#player{uid=Uid,team_id=TeamId,info=Info}=Player,CopyId,CopyType,MemPids,PlayerSList) ->
	scene_api:exit_scene(Player),
	Pid = copy_sup:start_child_copy_srv(CopyId,?CONST_TRUE),
	{CopyId, X, Y, MapId, Pid, MapType} = copy_srv:start_call(Pid,PlayerSList),
	stat_api:logs_copy(Uid,CopyId,util:seconds(),?CONST_FALSE,CopyType),
	team_api:team_set(TeamId, [{map,MapId},{spid,Pid},{state,?CONST_TEAM_STATE_WARING},{copy_id,CopyId},{copy_type,CopyType}]),
	F = fun(Mpid) ->
				util:pid_send(Mpid, ?MODULE, start_team_cb, {CopyId, CopyType,X, Y, MapId, Pid, MapType})
		end,
	lists:foreach(F, MemPids),
	#info{pos_x=LastX,pos_y=LastY,map_id=LastMapId} = Info,
	Info2	= Info#info{pos_x = X, pos_y = Y, map_id = MapId,copy_id=CopyId,
						pos_x_last = LastX,pos_y_last = LastY,map_last = LastMapId,map_type	= MapType},
	Player#player{spid=Pid,info=Info2}.

start_team_cb(#player{uid=Uid,info=Info}=Player,{CopyId, CopyType,X, Y, MapId, Pid, MapType}) ->
	scene_api:exit_scene(Player),
	stat_api:logs_copy(Uid,CopyId,util:seconds(),?CONST_FALSE,CopyType),
	#info{pos_x=LastX,pos_y=LastY,map_id=LastMapId} = Info,
	Info2	= Info#info{pos_x = X, pos_y = Y, map_id = MapId,copy_id=CopyId,
						pos_x_last = LastX,pos_y_last = LastY,map_last = LastMapId,map_type	= MapType},
	Player#player{spid=Pid,info=Info2}.

check_team(TeamId,SelfMpid) ->
	case team_api:mem_mpids(TeamId) of
		[SelfMpid|PidList] ->
			{?ok, PidList};
		_ ->
			{?ok,[]}
	end.

timing(#player{spid=Spid,uid=Uid,team_id=TeamId,team_leader=TeamLeader},Type) ->
	if TeamId =:= 0 orelse Uid =:= TeamLeader ->
		   copy_srv:timing_cast(Spid,Type);
	   ?true ->
		   ?skip
	end.

%% 副本切换场景
switch(#player{socket=Socket,mpid=SelfMpid,team_id=TeamId,spid=Spid,info=Info}=Player) ->
	case lists:member(Info#info.map_type, ?COPY_MAP_TYPES) of
		?true ->
			case check_team(TeamId,SelfMpid) of
				{?ok, MemberMPidList} ->
					case copy_srv:switch_in_call(Spid) of
						{X, Y, MapId, Pid, MapType} ->
							team_api:team_set(TeamId, [{map,MapId},{spid,Pid}]),
							F = fun(MPid) ->
										util:pid_send(MPid, ?MODULE, switch_cb, {X, Y, MapId, Pid, MapType})
								end,
							lists:foreach(F, MemberMPidList),	
							Info2 = Info#info{pos_x=X, pos_y=Y, map_id=MapId, map_type=MapType},
							Player#player{spid=Pid,info=Info2};
						{?error, ErrorCode} ->
							BinMsg	= system_api:msg_error(ErrorCode),
							app_msg:send(Socket, BinMsg),
							Player
					end;
				{?error,ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg),
					Player
			end;
		_ ->
			BinMsg = system_api:msg_error(?ERROR_COPY_NOT_IN),
			app_msg:send(Socket, BinMsg),
			Player
	end.

switch_cb(#player{info=Info}=Player, {X, Y, MapId, SPid, MapType}) ->
	Info2 = Info#info{pos_x=X, pos_y=Y, map_id=MapId, map_type=MapType},
	Player#player{spid=SPid,info=Info2}.

%% 请求场景怪物数据
monster_list(#player{uid=Uid, spid=SPid})->
	copy_srv:monster_list_cast(SPid, Uid).

%% 玩家退出游戏退出副本
exit(Pid, Uid) ->
	copy_srv:exit_cast(Pid, Uid).

%% 通知副本完成
notice_over(Uid,Spid,HitTimes,CaromTimes,MonsHp) ->
	copy_srv:notice_over_cast(Spid, Uid, HitTimes,CaromTimes,MonsHp).

%% 正常退出副本
exit_copy(#player{socket=Socket,spid=Pid,uid=Uid,info=Info}=Player) ->
	exit_copy_first(Player),
	PlayerTeam = team_api:exit_team(Player),
	#info{map_last=MapId,pos_x_last=X,pos_y_last=Y} = Info,
	case data_scene:scene(MapId) of
		#d_scene{scene_type=SceneType,lv=MapLv} ->
			case scene_api:enter(PlayerTeam, MapId, MapLv, X, Y, SceneType, 0) of
				{?ok, Player2} ->
					copy_srv:exit_cast(Pid, Uid),
					BinMsg = copy_api:msg_exit_ok(),
					app_msg:send(Socket, BinMsg),
					Player2;
				{?error, ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, BinMsg),
					PlayerTeam
			end;
		_ ->
			BinMsg = system_api:msg_error(?ERROR_UNKNOWN),
			app_msg:send(Socket, BinMsg),
			PlayerTeam
	end.

exit_copy_first(#player{info=Info}=Player) ->
	case Info#info.copy_id of
		?CONST_COPY_FIRST_COPY ->
			role_api:role_copy_attr(Player, ?null);
		_ ->
			?skip
	end.

%% 玩家在副本移动数据
move(#player{uid=Uid, mpid=MPid, spid=SPid},MoveData,BinData)->
    copy_srv:move_cast(SPid, Uid, MPid, MoveData, BinData).

% 达到等级,上个副本完成,前置任务为0或当前任务是前置任务或前置任务已完成
check_add_copy(Dlv,PreId,TaskId,Lv,CopyType,Copys) ->
	%?MSG_ECHO("------------~w~n",[{Dlv,PreId,TaskId,Lv}]),
	case Lv >= Dlv of
		?true ->
			case PreId of
				0 ->
					?true;
				_ ->
					case check_add_copy(CopyType,PreId,Copys) of
						?true ->
							%?MSG_ECHO("------------~w~n",[{Dlv,PreId,TaskId,Lv}]),
							case TaskId of
								0 ->
									%?MSG_ECHO("------------~w~n",[{Dlv,PreId,TaskId,Lv}]),
									?true;
								_ ->
									%?MSG_ECHO("------------~w~n",[{Dlv,PreId,TaskId,Lv}]),
									task_api:is_complete(round(TaskId*10))
							end;
						_ ->
							%?MSG_ECHO("------------~w~n",[{Dlv,PreId,TaskId,Lv}]),
							?false
					end
			end;
		_ ->
			?false
	end.

check_add_copy(?CONST_COPY_TYPE_NORMAL,PreId,Copys) ->
	case lists:keyfind(PreId, #copysave.id, Copys) of
		#copysave{is_pass=?CONST_TRUE} ->
			?true;
		_ ->
			?false
	end;
check_add_copy(?CONST_COPY_TYPE_HERO,PreId,Copys) ->
	case lists:keyfind(PreId, #herosave.id, Copys) of
		#herosave{is_pass=?CONST_TRUE} ->
			?true;
		_ ->
			?false
	end;
check_add_copy(?CONST_COPY_TYPE_FIEND,PreId,Copys) ->
	case lists:keyfind(PreId, #fiendsave.id, Copys) of
		#fiendsave{is_pass=?CONST_TRUE} ->
			?true;
		_ ->
			?false
	end;
check_add_copy(?CONST_COPY_TYPE_FIGHTERS,PreId,Copys) ->
	case lists:keyfind(PreId, #figsave.id, Copys) of
		#figsave{is_pass=?CONST_TRUE} ->
			?true;
		_ ->
			?false
	end.

up_start_cb(Mpid) ->
	% ?MSG_ECHO("---------------------~n",[]),
	util:pid_send(Mpid, ?MODULE, up_add_cb, ?null).

up_add_cb(#player{socket=Socket,uid=Uid,mpid=Mpid}=Player,_) ->
	UpCopy = role_api_dict:upcopy_get(),
	#upcopy{id=CopyId,type=CopyType,up_over_type=UpOverType,cdtime=CdTime,nowtimes=NowTimes,sumtimes=SumTimes,energy=Energy,stop=Stop,power=Power,exp=Exp,gold=Gold,reward=Reward} = UpCopy,
	% ?MSG_ECHO("=================================~w~n",[{NowTimes,SumTimes}]),
	case Stop of
		?true ->
			% ?MSG_ECHO("=================================~w~n",[{NowTimes,SumTimes}]),
			NewUpCopy = #upcopy{},
			role_api_dict:upcopy_set(NewUpCopy),
			Player;
		_ ->
			% ?MSG_ECHO("=================================~w~n",[{NowTimes,SumTimes}]),
			NewTimes = NowTimes + 1,
			Goods = copy_mod:get_goods(Reward),
			NewPlayer = up_copy_add(Player,CopyId,CopyType,Exp,Gold,Power,Goods,Energy),
			if NewTimes >= SumTimes ->
				   % ?MSG_ECHO("=================================~w~n",[{NowTimes,SumTimes}]),
				   stat_api:logs_hosting(Uid, CopyId, SumTimes, util:seconds(),?CONST_FALSE),
				   Bin1 = msg_up_result(CopyId,NewTimes,SumTimes,Exp,Gold,Power,Goods),
				   Bin2 = 
					   case UpOverType of
						   ?CONST_COPY_UPTYPE_SPEED ->
							   <<>>;
						   _ ->
							   msg_up_over(CopyId,UpOverType)
					   end,
				   app_msg:send(Socket, <<Bin1/binary,Bin2/binary>>),
				   NewUpCopy = #upcopy{},
				   role_api_dict:upcopy_set(NewUpCopy);
			   ?true ->
				   %?MSG_ECHO("=================================~w~n",[{NowTimes,SumTimes}]),
				   case bag_api:check_bag() of
					   ?true ->
						   %?MSG_ECHO("=================================~w~n",[{NowTimes,SumTimes}]),
						   stat_api:logs_hosting(Uid, CopyId, SumTimes, util:seconds(),?CONST_FALSE),
						   Bin1 = msg_up_result(CopyId,NewTimes,SumTimes,Exp,Gold,Power,Goods),
						   Bin2 = msg_up_over(CopyId,?CONST_COPY_UPTYPE_BAG_FULL),
						   app_msg:send(Socket, <<Bin1/binary,Bin2/binary>>),
						   NewUpCopy = #upcopy{},
						   role_api_dict:upcopy_set(NewUpCopy);
					   ?false ->
						   %?MSG_ECHO("=================================~w~n",[{NowTimes,SumTimes}]),
						   BinMsg = msg_up_result(CopyId,NewTimes,SumTimes,Exp,Gold,Power,Goods),
						   app_msg:send(Socket, BinMsg),
						   NewUpCopy1 = UpCopy#upcopy{nowtimes=NewTimes},
						   NewUpCopy = upcopy_add_history(NewUpCopy1,NewTimes,SumTimes,Exp,Gold,Power,Goods),
						   {?ok,Tref} = timer:apply_after(CdTime*1000, ?MODULE, up_start_cb, [Mpid]),
						   role_api_dict:upcopy_set(NewUpCopy#upcopy{tref=Tref})
				   end
			end,
			up_over_cast(Mpid,CopyId,1),
			NewPlayer
	end.

up_fast_vip(Player,UpCopy,_CopyId,_CopyType,_Exp,_Gold,_Power,_Rewards,_Energy,_NowTimes,0) ->
	role_api_dict:upcopy_set(UpCopy),
	Player;
up_fast_vip(Player,UpCopy,CopyId,CopyType,Exp,Gold,Power,Goods,CopyEnergy,NowTimes,SumTimes) ->
	NewUpCopy = upcopy_add_history(UpCopy,NowTimes,SumTimes,Exp,Gold,Power,Goods),
	NewPlayer = up_copy_add(Player,CopyId,CopyType,Exp,Gold,Power,Goods,CopyEnergy),
	up_fast_vip(NewPlayer,NewUpCopy,CopyId,CopyType,Exp,Gold,Power,Goods,CopyEnergy,NowTimes + 1,SumTimes - 1).

up_copy_add(#player{uid=Uid,socket=Socket}=Player,CopyId,CopyType,Exp,Gold,Power,Goods,CopyEnergy) ->
	up_del_times(CopyType,CopyId),
	up_active(CopyType,Uid),
	{Player3,Bin1} = role_api:currency_add([up_fast_vip,[],<<"副本挂机奖励">>],Player,[{?CONST_CURRENCY_EXP,Exp},{?CONST_CURRENCY_GOLD,Gold},{?CONST_CURRENCY_ADV_SKILL,Power}],?false),
	app_msg:send(Socket, Bin1),
	Bag = role_api_dict:bag_get(),
	case bag_api:goods_set([up_fast_vip,[],<<"副本挂机奖励">>],Player3,Bag,Goods) of
		{?ok,Player4,Bag2,GoodsBin,_LogBin} ->
			role_api_dict:bag_set(Bag2),
			case energy_api:energy_use([up_copy_add,CopyEnergy,<<"副本挂机消耗">>], Player4, CopyEnergy) of
				{?ok,EnergyPlayer,EnergyBin} ->
					app_msg:send(Socket, <<GoodsBin/binary,EnergyBin/binary>>),
					EnergyPlayer;
				{?error,ErrorCode} ->
					BinMsg = system_api:msg_error(ErrorCode),
					app_msg:send(Socket, <<GoodsBin/binary,BinMsg/binary>>),
					Player4
			end;
		{?error,ErrorCode} ->
			BinMsg	= system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			Player3
	end.

up_del_times(?CONST_COPY_TYPE_NORMAL,_CopyId) ->
	?skip;
up_del_times(?CONST_COPY_TYPE_HERO,_CopyId) ->
	Hero = role_api_dict:hero_get(),
	Times= Hero#hero.times - 1,
	MyTimes = ?IF(Times >=0, Times, 0),
	role_api_dict:hero_set(Hero#hero{times=MyTimes});
up_del_times(?CONST_COPY_TYPE_FIEND,CopyId) ->
	Fiend = role_api_dict:fiend_get(),
	case lists:keytake(CopyId, #fiendsave.id, Fiend#fiend.copys) of
		{value,CopyS,Tmp} ->
			Times = CopyS#fiendsave.times + 1,
			NewSave = [CopyS#fiendsave{times=Times}|Tmp],
			role_api_dict:fiend_set(Fiend#fiend{copys=NewSave});
		_ ->
			?skip
	end.

up_active(?CONST_COPY_TYPE_HERO,Uid) ->
	active_api:check_link(Uid,103);
up_active(?CONST_COPY_TYPE_FIEND,Uid) ->
	active_api:check_link(Uid,102);
up_active(_CopyType,_Uid) ->
	?skip.

up_start(#player{socket=Socket,uid=Uid,mpid=Mpid,vip=Vip}=Player,CopyId,UseAll,Num) ->
	OldUpCopy = role_api_dict:upcopy_get(),
	case OldUpCopy#upcopy.stop of
		?true ->
			case up_check_data(CopyId) of
				{?ok,CopyType,Energy,FastVip,CdTime} ->
					% ?MSG_ECHO("----------------~w~n",[{Vip#vip.lv,CopyType,Energy,FastVip,CdTime}]),
					case up_check_energy_times(CopyId,CopyType,Energy,UseAll,Num) of
						{?ok,MyNum} ->
							% ?MSG_ECHO("----------------~w~n",[MyNum]),
							{Exp,Gold,Power,Reward} = get_copy_up_reward(CopyId,Vip),
							{UpSpeed,NewCdTime,OverType} = ?IF(Vip#vip.lv >= FastVip, {?true,?CONST_COPY_UP_TIME,?CONST_COPY_UPTYPE_VIP}, {?false,CdTime,?CONST_COPY_UPTYPE_NORMAL}),
							% ?MSG_ECHO("---------------~w~n",[MyNum]),
							Btime = util:seconds(),
							Etime = Btime + CdTime * MyNum,
							BinMsg = msg_up_result(CopyId,0,MyNum,0,0,0,[]),
							app_msg:send(Socket, BinMsg),
							stat_api:logs_hosting(Uid, CopyId, MyNum, Btime,?CONST_TRUE),
							{?ok, Tref} = timer:apply_after(NewCdTime*1000, ?MODULE, up_start_cb, [Mpid]),
							UpCopy = #upcopy{id=CopyId,type=CopyType,up_over_type=OverType,use_all=UseAll,
											 up_speed=UpSpeed,btime=Btime,etime=Etime,cdtime=NewCdTime,exp=Exp,
											 gold=Gold,energy=Energy,nowtimes=0,sumtimes=MyNum,power=Power,
											 reward=Reward,stop=?false,fast_vip=FastVip,tref=Tref},
							role_api_dict:upcopy_set(UpCopy),
							{?ok,Player};
						{?error,ErrorCode} ->
							{?error,ErrorCode}
					end;
				{?error,ErrorCode} ->
					{?error,ErrorCode}
			end;
		_ ->
			{?ok,Player}
	end.

upcopy_add_history(#upcopy{uphistory=History1}=UpCopy,Now,Sum,Exp,Gold,Power,Goods) ->
	History2 = History1 ++ [{Now,Sum,Exp,Gold,Power,Goods}],
	ListLen = length(History2),
	History =
		case ListLen > 10 of
			?true ->
				{_,MyHistory} = lists:split(ListLen - 10, History2),
				MyHistory;
			_ ->
				History2
		end,
	UpCopy#upcopy{uphistory=History}.

get_copy_up_reward(CopyId,Vip) ->
	Eva =
		case Vip#vip.lv > 0 of
			?true ->
				?CONST_COPY_EVA_A;
			_ ->
				?CONST_COPY_EVA_B
		end,
	case data_copy_reward:get(CopyId) of
		Dreward when is_record(Dreward,d_copy_reward) ->
			get_copy_egg_up(Dreward,Eva);
		_ ->
			{0,0,0,[]}
	end.

get_copy_egg_up(#d_copy_reward{a_exp=Aexp,a_money=Agold,a_goods=Agoods,a_power=Apower,b_exp=Bexp,
							b_money=Bgold,b_goods=Bgoods,b_power=Bpower,c_exp=Cexp,c_money=Cgold,
							c_goods=Cgoods,c_power=Cpower},Eva) ->
	case Eva of
		?CONST_COPY_EVA_A ->
			{Aexp,Agold,Apower,Agoods};
		?CONST_COPY_EVA_B ->
			{Bexp,Bgold,Bpower,Bgoods};
		?CONST_COPY_EVA_C ->
			{Cexp,Cgold,Cpower,Cgoods};
		_ ->
			{0,0,0,[]}
	end.

up_check_data(CopyId) ->
	case data_scene_copy:get(CopyId) of
		#d_copy{copy_type=?CONST_COPY_TYPE_NORMAL,use_energy=Energy,fast_vip=FastVip} ->
			%?MSG_ECHO("----------------~w~n",[CopyId]),
			#chapcopy{copys=Save} = role_api_dict:copy_get(),
			case lists:keyfind(CopyId,#copysave.id,Save) of
				#copysave{is_pass=?CONST_TRUE} ->
					%?MSG_ECHO("----------------~w~n",[CopyId]),
					{?ok,?CONST_COPY_TYPE_NORMAL,Energy,FastVip,?CONST_COPY_NORMAL_CD};
				#copysave{} ->
					%?MSG_ECHO("----------------~w~n",[CopyId]),
					{?error,?ERROR_COPY_COPY_NOPASS};
				_ ->
					%?MSG_ECHO("----------------~w~n",[CopyId]),
					{?error,?ERROR_COPY_NOT_COPY}
			end;
		#d_copy{copy_type=?CONST_COPY_TYPE_HERO,use_energy=Energy,fast_vip=FastVip} ->
			?MSG_ECHO("----------------~w~n",[CopyId]),
			#hero{copys=Save} = role_api_dict:hero_get(),
			case lists:keyfind(CopyId,#herosave.id,Save) of
				#herosave{is_pass=?CONST_TRUE} ->
					%?MSG_ECHO("----------------~w~n",[CopyId]),
					{?ok,?CONST_COPY_TYPE_HERO,Energy,FastVip,?CONST_COPY_HERO_CD};
				#herosave{} ->
					%?MSG_ECHO("----------------~w~n",[CopyId]),
					{?error,?ERROR_COPY_COPY_NOPASS};
				_ ->
					%?MSG_ECHO("----------------~w~n",[CopyId]),
					{?error,?ERROR_COPY_NOT_COPY}
			end;
		#d_copy{copy_type=?CONST_COPY_TYPE_FIEND,use_energy=Energy,fast_vip=FastVip} ->
			%?MSG_ECHO("----------------~w~n",[CopyId]),
			#fiend{copys=Save} = role_api_dict:fiend_get(),
			case lists:keyfind(CopyId,#fiendsave.id,Save) of
				#fiendsave{is_pass=?CONST_TRUE} ->
					%?MSG_ECHO("----------------~w~n",[CopyId]),
					{?ok,?CONST_COPY_TYPE_FIEND,Energy,FastVip,?CONST_COPY_FIEND_CD};
				#fiendsave{} ->
					%?MSG_ECHO("----------------~w~n",[CopyId]),
					{?error,?ERROR_COPY_COPY_NOPASS};
				_ ->
					%?MSG_ECHO("----------------~w~n",[CopyId]),
					{?error,?ERROR_COPY_NOT_COPY}
			end;
		_ ->
			%?MSG_ECHO("----------------~w~n",[CopyId]),
			{?error,?ERROR_COPY_NOT_COPY_DATA}
	end.

up_check_energy_times(CopyId,CopyType,Energy,UseAll,Num) ->
	%?MSG_ECHO("----------------~w~n",[{Energy,UseAll,Num}]),
	EnergyValue = energy_api:get_energy_value(),
	%?MSG_ECHO("---------------~w~n",[EnergyValue]),
	case EnergyValue div Energy of
		MyNum when MyNum > 0 ->
			%?MSG_ECHO("---------------~w~n",[MyNum]),
			check_energy_times(CopyType,CopyId,UseAll,Num,MyNum);
		_ ->
			{?error,?ERROR_COPY_LESS_ENERGY}
	end.

check_energy_times(?CONST_COPY_TYPE_NORMAL,_CopyId,UseAll,Num,MyNum) ->
	case UseAll of
		?CONST_TRUE ->
			{?ok,MyNum};
		_ ->
			case MyNum >= Num of
				?true ->
					{?ok,Num};
				_ ->
					{?error,?ERROR_COPY_LESS_ENERGY}
			end
	end;
check_energy_times(?CONST_COPY_TYPE_HERO,_CopyId,UseAll,Num,MyNum) ->
	Hero = role_api_dict:hero_get(),
	case Hero#hero.times of
		Times when Times > 0 ->
			case UseAll of
				?CONST_TRUE ->
					case MyNum >= Times of
						?true ->
							{?ok,Times};
						_ ->
							{?error,?ERROR_COPY_LESS_ENERGY}
					end;
				_ ->
					case MyNum >= Num of
						?true ->
							{?ok,Num};
						_ ->
							{?error,?ERROR_COPY_LESS_ENERGY}
					end
			end;
		_ ->
			{?error,?ERROR_COPY_NO_UPCOPY_TIMES}
	end;
check_energy_times(?CONST_COPY_TYPE_FIEND,CopyId,UseAll,Num,MyNum) ->
	#fiend{copys=CopySave} = role_api_dict:fiend_get(),
	case lists:keyfind(CopyId, #fiendsave.id, CopySave) of
		#fiendsave{times=Times,times_day=TimesDay} ->
			case TimesDay - Times of
				MyTimes when MyTimes > 0 ->
					case UseAll of
						?CONST_TRUE ->
							case MyNum >= MyTimes of
								?true ->
									{?ok,MyTimes};
								_ ->
									{?error,?ERROR_COPY_LESS_ENERGY}
							end;
						_ ->
							case MyNum >= Num of
								?true ->
									{?ok,Num};
								_ ->
									{?error,?ERROR_COPY_LESS_ENERGY}
							end
					end;
				_ ->
					{?error,?ERROR_COPY_NO_UPCOPY_TIMES}
			end;
		_ ->
			{?error,?ERROR_COPY_NO_UPCOPY_TIMES}
	end.

up_speed(#player{socket=Socket,mpid=Mpid}=Player) ->
	UpCopy = role_api_dict:upcopy_get(),
	#upcopy{id=CopyId,etime=Etime,stop=Stop} = UpCopy,
	case Stop of
		?true ->
			Player;
		_ ->
			NowTime = util:seconds(),
			FreeTime1 = Etime - NowTime,
			FreeTime = ?IF(FreeTime1 >= 0,FreeTime1,0),
			case FreeTime of
				0 ->
					Player;
				_ ->
					Times1 = FreeTime div 60,
					Times = ?IF(FreeTime rem 60 =:= 0, Times1, Times1 + 1),
					case role_api:currency_cut([up_speed,[],<<"加速挂机">>],Player,[{?CONST_CURRENCY_RMB, Times*?CONST_COPY_SPEED_RMB}]) of
						{?ok,Player2,_Bin1} ->
							NewCdTime = ?CONST_COPY_UP_TIME,
							timer:cancel(UpCopy#upcopy.tref),
							{?ok,Tref} = timer:apply_after(NewCdTime*1000, ?MODULE, up_start_cb, [Mpid]),
							NewUpCopy = UpCopy#upcopy{up_over_type=?CONST_COPY_UPTYPE_SPEED,up_speed=?true,
													  cdtime=NewCdTime,tref=Tref},
							role_api_dict:upcopy_set(NewUpCopy),
							Bin2 = msg_up_over(CopyId,?CONST_COPY_UPTYPE_SPEED),
							app_msg:send(Socket, Bin2),
							Player2;
						{?error,ErrorCode} ->
							BinMsg = system_api:msg_error(ErrorCode),
							app_msg:send(Socket, BinMsg),
							Player
					end
			end
	end.

up_stop(Uid) ->
	#upcopy{id=CopyId,nowtimes=NowTimes} = role_api_dict:upcopy_get(),
	NowTime	  = util:seconds(),
	stat_api:logs_hosting(Uid, CopyId, NowTimes, NowTime,?CONST_FALSE),
	NewUpCopy = #upcopy{},
	role_api_dict:upcopy_set(NewUpCopy).

up_over_cast(_Mpid,_CopyId,0) ->
	?skip;
up_over_cast(Mpid,CopyId,Num) ->
	task_daily_api:check_cast(Mpid,?CONST_TASK_DAILY_REFRESH_COPY, CopyId), 
	task_api:check_cast(Mpid,?CONST_TASK_TARGET_COPY, CopyId),
	up_over_cast(Mpid,CopyId,Num-1).
	

%% 副本需求查询(只有这个才是CopyId,其它都是KeyID)
require_info(CopyId) ->
	case data_scene_copy:get(CopyId) of
		#d_copy{lv=Lv,lv_max=LvMax} ->
			{Lv,LvMax};
		_ ->
			{0,0}
	end.

%% 每天进入次数
times_max_day(KeyId) ->
	case data_scene_copy:get(KeyId) of
		#d_copy{times_max_day=TimesMaxDay} ->
			TimesMaxDay;
		_ ->
			0
	end.

%% 请求章节信息
%% chap_info(Lv,ChapId,Chaps,ChapCopy) ->
%% 	NewChapCopy	=check_new_copy(ChapCopy,Chaps),
%% 	NowChap	= ?IF(ChapId =:= 0,ChapCopy#chapcopy.chap_id,ChapId),
%% 	?MSG_ECHO("---------------~w~n",[{NowChap,Chaps}]),
%% 	#d_copy_chap{next_chap_id=Next,copy_id=Copys} = data_copy_chap:get(?CONST_COPY_TYPE_NORMAL, NowChap),
%% 	NextChap= next_chap_status(NewChapCopy#chapcopy.use_id,NowChap,Next,Chaps),
%% 	{ResultS,NewSave} = get_battle_status(NowChap,Lv,Copys,NewChapCopy#chapcopy.copys),
%% 	{NowChap,NextChap,ResultS,NewChapCopy#chapcopy{chap_id=NowChap,copys=NewSave}}.

%% 请求章节信息(无指定章节)
chap_info_new(Lv) ->
	ChapCopy1 = role_api_dict:copy_get(),
	Dchaps	= data_copy_chap:gets_normal(),
	ChapCopy=check_new_copy(ChapCopy1,Dchaps),
	ChapId	= chap_info_chap(ChapCopy),
	case chap_info_nowchap(ChapCopy,ChapId,Lv) of
		{?ok,NowChap} ->
			chap_info_new(ChapCopy,Lv,NowChap,Dchaps);
		{?error,ErrorCode} ->
			{?error,ErrorCode}
	end.

%% 请求章节信息(指定章节)
chap_info_new(NowChap,Lv) ->
	ChapCopy1 = role_api_dict:copy_get(),
	Dchaps	= data_copy_chap:gets_normal(),
	ChapCopy=check_new_copy(ChapCopy1,Dchaps),
	case lists:member(NowChap, Dchaps) of
		?true ->
			chap_info_new(ChapCopy,Lv,NowChap,Dchaps);
		_ ->
			{?error,?ERROR_HERO_NO_CHAP}
	end.

chap_info_new(ChapCopy,Lv,NowChap,Dchaps) ->
	case data_copy_chap:get(?CONST_COPY_TYPE_NORMAL, NowChap) of
		#d_copy_chap{next_chap_id=Next,copy_id=Copys} ->
			NextStatus= next_chap_status(ChapCopy#chapcopy.use_id,NowChap,Next,Dchaps,Lv),
			{ResultS,NewSave} = get_battle_status(NowChap,Lv,Copys,ChapCopy#chapcopy.copys),
			NewChapCopy = ChapCopy#chapcopy{chap_id=NowChap,copys=NewSave},
			role_api_dict:copy_set(NewChapCopy),
			BinMsg = msg_chap_data_new(NowChap,NextStatus,ResultS),
			BinReward = chap_reward_req(NowChap,ChapCopy#chapcopy.chap_reward),
			{?ok,<<BinMsg/binary,BinReward/binary>>};
		_ ->
			?MSG_ERROR("=====Normal Copy Chap ~w No Data~n",[NowChap]),
			{?error,?ERROR_UNKNOWN}
	end.

chap_reward_req(ChapId, Chaps) ->
	case lists:member(ChapId, Chaps) of
		?true ->
			msg_chap_reward_rep(?CONST_TRUE);
		?false ->
			msg_chap_reward_rep(?CONST_FALSE)
	end.

chap_info_chap(#chapcopy{use_id=[],chap_id=ChapId}) ->
	ChapId;
chap_info_chap(#chapcopy{use_id=UseIds1}) ->
	UseIds = lists:sort(UseIds1),
	lists:last(UseIds).

chap_info_nowchap(#chapcopy{copys=Copys},ChapId,Lv) ->
	case data_copy_chap:get(?CONST_COPY_TYPE_NORMAL,ChapId) of
		#d_copy_chap{next_chap_id=0} ->
			{?ok,ChapId};
		#d_copy_chap{copy_id=Ids,next_chap_id=NextChapId} ->
			case chap_info_check_chap_pass(Copys,Ids) of
				?true ->
					case data_copy_chap:get(?CONST_COPY_TYPE_NORMAL,NextChapId) of
						#d_copy_chap{chap_lv=ChapLv} when Lv >= ChapLv ->
							{?ok,NextChapId};
						_ ->
							{?ok,ChapId}
					end;
				_ ->
					{?ok,ChapId}
			end;
		_ ->
			?MSG_ERROR("=====Normal Copy Chap ~w No Data~n",[ChapId]),
			{?error,?ERROR_UNKNOWN}
	end.

chap_info_check_chap_pass(_Copys, []) ->
	?true;
chap_info_check_chap_pass(Copys,[Id|Ids]) ->
	case lists:keyfind(Id, #copysave.id, Copys) of
		#copysave{is_pass=?CONST_TRUE} ->
			chap_info_check_chap_pass(Copys,Ids);
		_ ->
			?false
	end.

%% 找出全部通过的章节
check_new_copy(#chapcopy{copys=CopySave}=ChapCopy,Chaps) ->
	case CopySave of
		[] ->
			ChapCopy;
		_ ->
			Fun =  fun(ChapId,Acc) ->
						   case data_copy_chap:get(?CONST_COPY_TYPE_NORMAL, ChapId) of
							   #d_copy_chap{copy_id=Ids} ->
								   Fun1	= fun(Id,Acc1) ->
												  case lists:keyfind(Id, #copysave.id,CopySave) of
													  #copysave{is_pass=?CONST_TRUE} ->
														  [Id | Acc1];
													  _ ->
														  Acc1
												  end
										  end,
								   NewIds = lists:foldl(Fun1, [], Ids),
								   case length(NewIds) >= length(Ids) of
									   ?true ->
										   [ChapId | Acc];
									   _ ->
										   Acc
								   end;
							   _ ->
								   Acc
						   end
				   end,
			Use	= lists:foldl(Fun, [], Chaps),
			ChapCopy#chapcopy{use_id=Use}
	end.

%% 检查下一个章节是否能够进入
next_chap_status(UseChap,NowChap,Next,Chaps,Lv) ->
	case lists:member(NowChap, UseChap) andalso lists:member(Next, Chaps) of
		?true ->
			case data_copy_chap:get(?CONST_COPY_TYPE_NORMAL, Next) of
				#d_copy_chap{chap_lv=NextChapLv} when Lv >= NextChapLv ->
					?CONST_TRUE;
				_ ->
					?CONST_FALSE
			end;
		_ ->
			?CONST_FALSE
	end.

%% 得到当前章节能够进入的副本
get_battle_status(ChapId,Lv,Ids,Save) ->
	ChapCopys= [HeroS || HeroS <- Save,HeroS#copysave.belongid =:= ChapId],
	MyChap = chap_copys(ChapCopys, Ids, Lv, ChapId),
	FunS = fun(HeroTmpS=#copysave{id=HeroId},AccS) ->
				   case lists:keytake(HeroId,#copysave.id,AccS) of
					   {value,_,Tmpxx} ->
						   [HeroTmpS | Tmpxx];
					   _ ->
						   [HeroTmpS | AccS]
				   end;
			  (_,AccS) ->
				   AccS
		   end,  
	NewSave	= lists:foldl(FunS, Save, MyChap),
	{MyChap,NewSave}.

chap_copys(Copys,Ids,Lv,ChapId) ->
	Fun = fun(Id,CopysAcc) ->
				  case data_scene_copy:get(Id) of
					  #d_copy{copy_id=Id,key_id=KeyId,task_id=TaskId,pre_copy_id=PreId,lv=Dlv,belong_id=BelongId} ->
						  case BelongId of
							  ChapId ->
								  SumTimes= times_max_day(KeyId),
								  case lists:keytake(Id,#copysave.id,CopysAcc) of
									  {value,FunCopys,TmpCopys} ->
										  [FunCopys#copysave{sumtimes=SumTimes}|TmpCopys];
									  _ ->
										  case check_add_copy(Dlv,PreId,TaskId,Lv,?CONST_COPY_TYPE_NORMAL,CopysAcc) of
											  ?true ->
												  NewSave = #copysave{id=Id,keyid=KeyId,belongid=ChapId,sumtimes=SumTimes},
												  [NewSave|CopysAcc];
											  _ ->
												  CopysAcc
										  end	 
								  end;
							  _ ->
								  CopysAcc
						  end;
					  _ ->
						  CopysAcc
				  end
		  end,
	lists:foldl(Fun, Copys, Ids).

chap_reward(#player{socket=Socket} = Player,ChapId) ->
	case chap_reward_acc(Player,ChapId) of
		{?ok,Player2,BinMsg} ->
			app_msg:send(Socket, BinMsg),
			Player2;
		{?error,ErrorCode} ->
			BinMsg = system_api:msg_error(ErrorCode),
			app_msg:send(Socket, BinMsg),
			Player
	end.

chap_reward_acc(Player,ChapId) ->
	ChapCopy = role_api_dict:copy_get(),
	case lists:member(ChapId, ChapCopy#chapcopy.chap_reward) of
		?true ->
			{?error,?ERROR_COPY_ALREWARD_CHAP};
		?false ->
			case data_copy_chap:get(?CONST_COPY_TYPE_NORMAL, ChapId) of
				#d_copy_chap{copy_id=Ids,chap_reward=Goods} ->
					case chap_reward_check(ChapCopy#chapcopy.copys, Ids) of
						?true ->
							Bag = role_api_dict:bag_get(),
							case bag_api:goods_set([chap_reward_acc,[],<<"副本章节奖励">>],Player,Bag,Goods) of
								{?ok,Player1,Bag1,GoodsBin,BinTmp} ->
									role_api_dict:bag_set(Bag1),
									NewChapCopy = ChapCopy#chapcopy{chap_reward=[ChapId|ChapCopy#chapcopy.chap_reward]},
									role_api_dict:copy_set(NewChapCopy),
									BinReward = msg_chap_reward_rep(?CONST_TRUE),
									{?ok, Player1,<<GoodsBin/binary,BinTmp/binary,BinReward/binary>>};
								{?error,ErrorCode} ->
									{?error,ErrorCode}
							end;
						?false ->
							{?error,?ERROR_COPY_CHAP_INALLS}
					end;
				_ ->
					{?error,?ERROR_COPY_NOT_COPY_DATA}
			end
	end.

chap_reward_check(_Copys, []) ->
	?true;
chap_reward_check(Copys,[Id|Ids]) ->
	case lists:keyfind(Id, #copysave.id, Copys) of
		#copysave{evaluation=Eva} when Eva >= ?CONST_COPY_EVA_A ->
			chap_reward_check(Copys,Ids);
		_ ->
			?false
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%msg XXXXXXXXXXXX%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 章节信息
msg_chap_data(Chap,NextChap,MyChap) ->
	Fun = fun(#copysave{id=CopyId,is_pass=IsPass},AccBin) ->
				  MsgList	= app_msg:encode([{?int16u,CopyId},{?int8u,IsPass}]),
				  <<AccBin/binary,MsgList/binary>>
		  end,
	MsgList	= lists:foldl(Fun, app_msg:encode([{?int16u,Chap},{?int8u,NextChap},{?int16u,length(MyChap)}]), MyChap),
	app_msg:msg(?P_COPY_CHAP_DATA, MsgList).

msg_chap_data_new(Chap,NextChap,MyChap) ->
	Fun = fun(#copysave{id=CopyId,is_pass=IsPass,evaluation=Eva},AccBin) ->
				  MsgList	= app_msg:encode([{?int16u,CopyId},{?int8u,IsPass},{?int8u,Eva}]),
				  <<AccBin/binary,MsgList/binary>>
		  end,
	MsgList	= lists:foldl(Fun, app_msg:encode([{?int16u,Chap},{?int8u,NextChap},{?int16u,length(MyChap)}]), MyChap),
	app_msg:msg(?P_COPY_CHAP_DATA_NEW, MsgList).

% 进入副本场景返回信息
msg_enter_scene_info(CopyId,Gate,SceneIdx)->
    RsList = app_msg:encode([{?int16u,CopyId},{?int8u,Gate},{?int8u,SceneIdx}]),
    app_msg:msg(?P_COPY_ENTER_SCENE_INFO, RsList).

% 时间同步
msg_time_update(Time)->
    RsList = app_msg:encode([{?int32u,Time}]),
    app_msg:msg(?P_COPY_TIME_UPDATE, RsList).

msg_scene_time(Time) ->
	RsList = app_msg:encode([{?int32u,Time}]),
    app_msg:msg(?P_COPY_SCENE_TIME, RsList).

% 场景目标完成
msg_scene_over()->
    app_msg:msg(?P_COPY_SCENE_OVER,<<>>).

% 副本完成
msg_over(CopyId,CopyType,HitsScore,TimeScore,CaromScore,KillScore,Eva,Exp,Gold,Power,Goods) ->
	%?MSG_ECHO("--------------------~n",[]),
	Bin1 = app_msg:encode([{?int16u,CopyId},{?int8u,CopyType},{?int16u,HitsScore},{?int16u,TimeScore},{?int16u,CaromScore},
						   {?int16u,KillScore},{?int8u,Eva},{?int32u,Exp},{?int32u,Gold},{?int32u,Power}]),
	Bin2 = msg_goods(Goods),
    app_msg:msg(?P_COPY_OVER,<<Bin1/binary,Bin2/binary>>).

msg_goods(Goods) ->
	%?MSG_ECHO("--------------------~w~n",[Goods]),
	Fun = fun({GoodsId,GoodsCount},AccBin) ->
				  GoodsBin = app_msg:encode([{?int16u,GoodsId},{?int16u,GoodsCount}]),
				  <<AccBin/binary,GoodsBin/binary>>
		  end,
	lists:foldl(Fun, app_msg:encode([{?int16u,length(Goods)}]), Goods).

msg_fail() ->
	app_msg:msg(?P_COPY_FAIL,<<>>).

msg_relive(Rmb) ->
	BinData = app_msg:encode([{?int32u,Rmb}]),
	app_msg:msg(?P_SCENE_RELIVE, BinData).

% 退出副本成功
msg_exit_ok()->
    app_msg:msg(?P_COPY_EXIT_OK,<<>>).

msg_up_result(CopyId,NowTimes,SumTimes,Exp,Gold,Power,Goods) ->
	%?MSG_ECHO("-----------------~w~n",[Goods]),
	Bin1 = app_msg:encode([{?int16u,CopyId},{?int16u,NowTimes},{?int16u,SumTimes},{?int32u,Exp},
						   {?int32u,Gold},{?int32u,Power},{?int16u,length(Goods)}]),
	Fun = fun({GoodsId,Count},AccBin) ->
				  Fbin = app_msg:encode([{?int16u,GoodsId},{?int16u,Count}]),
				  <<AccBin/binary,Fbin/binary>>
		  end,
	Bin2 = lists:foldl(Fun, <<>>, Goods),
	app_msg:msg(?P_COPY_UP_RESULT, <<Bin1/binary,Bin2/binary>>).

msg_up_login_result(CopyId,NowTimes,SumTimes,Time,UseAll,UpHistory) ->
	Bin1 = app_msg:encode([{?int16u,CopyId},{?int16u,NowTimes},{?int16u,SumTimes},{?int32u,Time},
							  {?int8u,UseAll},{?int16u,length(UpHistory)}]),
	Bin2 = msg_up_login_his(CopyId,UpHistory),
	app_msg:msg(?P_COPY_LOGIN_NOTICE, <<Bin1/binary,Bin2/binary>>).

msg_up_login_his(CopyId,UpHistory) ->
	Fun = fun({Now,Sum,Exp,Gold,Power,Goods},AccBin) ->
			Bin1 = app_msg:encode([{?int16u,CopyId},{?int16u,Now},{?int16u,Sum},{?int32u,Exp},
								   {?int32u,Gold},{?int32u,Power},{?int16u,length(Goods)}]),
			Fun1 = fun({GoodsId,Count},AccBin1) ->
						  Fbin = app_msg:encode([{?int16u,GoodsId},{?int16u,Count}]),
						  <<AccBin1/binary,Fbin/binary>>
				  end,
			Bin2 = lists:foldl(Fun1, <<>>, Goods),
			<<AccBin/binary,Bin1/binary,Bin2/binary>>
		  end,
	lists:foldl(Fun, <<>>, UpHistory).

msg_up_over(CopyId,Type) ->
	BinData = app_msg:encode([{?int16u,CopyId},{?int8u,Type}]),
	app_msg:msg(?P_COPY_UP_OVER, BinData).

msg_chap_reward_rep(Result) ->
	BinData = app_msg:encode([{?int8u,Result}]),
	app_msg:msg(?P_COPY_CHAP_RE_REP, BinData).