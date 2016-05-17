%% Author  : Kevin
%% Created: 2012-9-5
%% Description: TODO: Add description to role_mod
-module(moil_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


%%
%% Exported Functions
%%

-export([ 
		 init/0, 
		 interval/0,
		 interval_cb/2,
		 moil/1,
		 moil/3,
		 moil_cb/2,
		 moil_2_cb/2,
%% 		 moil_list/1, 
		 
		 moil_enjoy/4,
		 moil_captrue_calls/3,
		 moil_captrue_res/4,
		 catch_moil_cb/2,
		 catch_landlord_cb/2,
%% 		 moil_captrue_calls_cb/2,
%% 		 moil_captrue_ok_data_cb/2,	 
%% 		 moil_captrue_ok_type_cb/2,
		 msg_protect_time/1,
		 moil_protect_cb/2,
		 moil_release_cb/2,
%% 		 moil_update_cb/2,
		 moil_active/4,
		 moil_press_start/1,
		 moil_press_enjoy/2,
		 moil_press/3,
		 moil_press_full/2,
%% 		 moil_time/3,
		 moil_protect_time/1,
		 moil_protect/3,
%% 		 moil_exp_cb/2,
		 moil_data_set/3,
		 moil_askhelp/1,
		 moil_other/2,
		 moil_captrue/2,
		 msg_buy_ok/0,
		 moil_release/1,
%% 		 moil_revenge_cb/2,
%% 		 moil_host_exp_cb/2,
		  
		 msg_moil_xxxx3/2,
		 msg_moil_data/9,
		 msg_player_data/2,
		 msg_press_data/2,
		 msg_press_rs/4,
		 msg_moil_rs2/1,
		 msg_release_rs/1]). 

%% 苦工抓捕 互动次数
moil_captrue(Moil,Lv)->
	CaptrueCount=Moil#moil.captrue_count,
	ActiveCount=Moil#moil.active_count,
	#d_moil_exp{exp_max=Exp}=data_moil_exp:get(Lv),
	ExpN=?IF(Moil#moil.expn>=Exp,0,Exp-Moil#moil.expn),
	{CaptrueCount,ExpN,ActiveCount}.
	
	
%% moil_list(PUid)->
%% 	PlayerList=ets:tab2list(?ETS_OFFLINE),
%% 	Fun=fun(Player,Acc) when is_record(Player,player) andalso
%% 								 Player#player.uid=/=PUid->
%% 				#player{sid=Sid,uid=Uid,info=Info,arena=Arena}=Player,
%% 				#info{name=Name,pro=Pro,sex=Sex,lv=Lv,clan_name=ClanName}=Info,
%% 				[{Sid,Uid,Name,Sex,Pro,Lv,ClanName,(Arena#arena.moil)#moil.type_id}|Acc]
%% 		end,
%% 	lists:foldl(Fun,[],PlayerList).

moil(PUid,Uid,Moil)->
	#moil{captrue_list=CaptrueList}=Moil,
	case lists:keyfind(Uid,2,CaptrueList) of
		?false->
			case role_api:mpid(Uid) of
				Mpid when is_pid(Mpid)->
					util:pid_send(Mpid,?MODULE,moil_cb,PUid);
				_->
					%% ets:lookup(ets_offline_sub,{1611,player})
					case ets:lookup(?ETS_OFFLINE_SUB,{Uid,player}) of
						[{_PlayerKey,_,Player}|_] when is_record(Player,player)->
%% 							case ets:lookup(?ETS_OFFLINE_SUB,{Uid,?PROC_USER_CLAN}) of
%% 								Clan when is_record(Clan,clan)->
									case ets:lookup(?ETS_OFFLINE_SUB,{Uid,?PROC_USER_ARENA}) of
										[{_,_,Arena}|_] when is_record(Arena,arena)->
											#player{uid=Uid,uname=Name,pro=Pro,sex=Sex,lv=Lv}=Player,
											ClanName= <<>>,
											#moil{type_id=TypeId}=Arena#arena.moil,
											Moildata={Uid,Name,Sex,Pro,Lv,ClanName,TypeId},
											util:pid_send(PUid,?MODULE,moil_2_cb,Moildata);
										_->
											?skip
									end;
%% 								_->
%% 									?skip
%% 							end;
						_->
							?skip
					end
			end;
		_->
			?skip
	end.

moil_cb(Player,PUid)->
	#player{uid=Uid,uname=Name,pro=Pro,sex=Sex,lv=Lv}=Player,
	ClanName= <<>>,
	Arena=role_api_dict:arena_get(),
	#moil{type_id=TypeId}=Arena#arena.moil,
	Moil={Uid,Name,Sex,Pro,Lv,ClanName,TypeId},
	util:pid_send(PUid,?MODULE,moil_2_cb,Moil),
	Player.

moil_2_cb(Player,{Uid,Name,Sex,Pro,Lv,ClanName,TypeId})-> 
	Arena=role_api_dict:arena_get(),
	#arena{moil=Moil}=Arena,
	#moil{captrue_list=CaptrueList}=Moil,
	case lists:keytake(Uid,1,CaptrueList) of
		{value,_,CaptrueList2}->
			CaptrueList3=[{Uid,Name,Sex,Pro,Lv,ClanName,TypeId}|CaptrueList2];
		_->
			CaptrueList3=[{Uid,Name,Sex,Pro,Lv,ClanName,TypeId}|CaptrueList]
	end,
	Moil2=Moil#moil{captrue_list=CaptrueList3},
	Arena2=Arena#arena{moil=Moil2},
	role_api_dict:arena_set(Arena2),
	Player.  
  
%% moil_revenge(Sid,Uid,Revenge)->
%% 	case role_api:get_pid(Uid) of
%% 		MPid when is_pid(MPid) ->
%% 			role_api:progress_send(MPid,?MODULE,moil_revenge_cb,Revenge);
%% 		_->
%% 			case role_api:player_data_offline(Sid,Uid) of
%% 				{?ok,Player} when is_record(Player,player)->
%% 					moil_revenge_cb(Player,Revenge) 
%% 			end
%% 	end.
%% moil_revenge_cb(Player=#player{arena=Arena},{RSid,RUid,RName,RSex,RPro,RLv,RClanId,RTypeId})->
%% 	Moil=Arena#arena.moil,
%% 	#moil{revenge_list=RevengeList}=Moil,
%% 	case lists:keyfind(RUid,2,RevengeList) of
%% 		?false->
%% 			RevengeList2=[{RSid,RUid,RName,RSex,RPro,RLv,RClanId,RTypeId}|RevengeList],
%% 			Moil2=Moil#moil{revenge_list=RevengeList2},
%% 			Arena2=Arena#arena{moil=Moil2},
%% 			Player2=Player#player{arena=Arena2},
%% 			role_api:db_save(Player2);
%% 		_->
%% 			Player
%% 	end.

moil(Uid)->
	case ets:lookup(?ETS_OFFLINE_SUB,{Uid,player}) of
		[{_PlayerKey,_,Player}] when is_record(Player,player)->
%% 			case ets:lookup(?ETS_OFFLINE_SUB,{Uid,?PROC_USER_CLAN}) of
%% 				Clan when is_record(Clan,clan)->
					case ets:lookup(?ETS_OFFLINE_SUB,{Uid,?PROC_USER_ARENA}) of
						[{_,_,Arena}|_] when is_record(Arena,arena)->
							#player{uid=Uid,uname=Name,pro=Pro,sex=Sex,lv=Lv}=Player,
							ClanName= <<>>,
							#moil{type_id=TypeId}=Arena#arena.moil,
							{Uid,Name,Sex,Pro,Lv,ClanName,TypeId};
						_->
							?skip
					end;
%% 				_->
%% 					?skip
%% 			end;
		_->
			?skip
	end.

%% 求救列表
moil_askhelp(Uid)->
%% 	UidList=lists:delete(Uid,clan_api:self_clan_mem(Uid)),	
	UidList=[],
	Fun=fun(PUid,Acc)->
				case moil(PUid) of
					?skip->
						Acc;
					MoilData->
						[MoilData|Acc]
				end
		end,
	lists:foldl(Fun,[],UidList).
  
%% 抓捕 复仇列表更新
moil_other(List,PLv)->
	List2=[Data||Data<-List,Data=/=?null],
	Fun=fun({Uid,_Name,_Sex,_Pro,_Lv,_ClanName,_TypeId},Acc)->
				case moil(Uid) of 
					?ok-> Acc;
					MoilData->
						[MoilData|Acc]
				end;
		   (_,Acc)->Acc
		end,
	List3=lists:foldl(Fun,[],List2),
	[{MUid,MName,MSex,MPro,MLv,MClanName,MTypeId}||
	 {MUid,MName,MSex,MPro,MLv,MClanName,MTypeId}<-List3,abs(PLv-MLv)=<10].




init()->
%% 	Time=util:seconds(),
	Moil_data=[],
	#moil{ 
		  type_id		   	= 3,						% 当前身份		
		  captrue_count		= ?CONST_MOIL_CAPTRUE_COUNT,% 抓捕次数
		  active_count		= ?CONST_MOIL_ACTIVE_COUNT,	% 互动次数
		  calls_count		= ?CONST_MOIL_CALLS_COUNT,	% 求救次数	
		  protest_count		= ?CONST_MOIL_PROTEST_COUNT,% 反抗次数
		  expn				= 0,						% 今日获得经验
		  landlord			= 0,						% {sid,uid,name}
		  protect_time      = [],						% 互动保护时间
		  buy_count			= ?CONST_MOIL_CATCH_MAX,	% 购买次数
		  moil_data			= Moil_data				    % [{服务器ID,玩家Uid,职业,性别,名字,剩余时间,开始时间,压榨次数}|_]
		 }.

interval()->
	List=ets:tab2list(?ETS_MOIL_WORKER),
	Time=util:seconds(),
	Fun=fun({Uid,STime,SLv})->
				case Time-STime >= 3600*24 of
					?true -> 
						case ets:lookup(?ETS_OFFLINE_SUB,{Uid,?PROC_USER_ARENA}) of
							[{Key,_,Arena}|_] when is_record(Arena,arena)->
								Moil=Arena#arena.moil, 
								moil_host_exp(Moil#moil.landlord,Uid,SLv),%% 发经验
								case role_api:mpid(Uid) of
									Pid when is_pid(Pid)->
										role_api:progress_send(Pid,?MODULE,interval_cb,?null);
									_->
										Moil=Arena#arena.moil,
										Moil2=Moil#moil{type_id=?CONST_MOIL_ID_FREEMAN,landlord=0},
										Arena2=Arena#arena{moil=Moil2},
										Time=util:seconds(),
										ets:insert(?ETS_OFFLINE_SUB,{Key,Time,Arena2})
								end,
								ets:delete(?ETS_MOIL_WORKER,Uid);
							_->
								ets:delete(?ETS_MOIL_WORKER,Uid)
						end;
					_->
						?ok
				end
		end,
	lists:map(Fun,List).
	
interval_cb(Player,_)->
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	Moil2=Moil#moil{type_id=?CONST_MOIL_ID_FREEMAN,landlord=0},
	Arena2=Arena#arena{moil=Moil2},
	role_api_dict:arena_set(Arena2),
	Player.
	
%% 给主人发经验
moil_host_exp({Uid,_Name,_},SUid,Lv)->
	case role_api:mpid(Uid) of
		Pid when is_pid(Pid)->
			role_api:progress_send(Pid,?MODULE,moil_host_exp_cb,{SUid,Lv});
		_->
			case ets:lookup(?ETS_OFFLINE_SUB,{Uid,player}) of
				[{PlayerKey,_,Player}|_] when is_record(Player,player)->
					Time=util:seconds(),
					case ets:lookup(?ETS_OFFLINE_SUB,{Uid,?PROC_USER_ARENA}) of
						[{Key,_,Arena}|_] when is_record(Arena,arena)->
							{Exp,Moil}=moil_time(Arena#arena.moil,SUid,Lv),
							Player2=role_api:exp_add(Player,Exp,moil_host_exp_cb,<<"苦工打工时间到获取经验">>),
							Arena2=Arena#arena{moil=Moil},
							ets:insert(?ETS_OFFLINE_SUB,{PlayerKey,Time,Player2}),
							ets:insert(?ETS_OFFLINE_SUB,{Key,Time,Arena2});
						_->
							?skip
					end;
				_->
					?skip
			end
	end;

moil_host_exp(_,_,_)-> ?skip.

moil_host_exp_cb(Player,{SUid,Lv})->
	Arena=role_api_dict:arena_get(),
	{Exp,Moil}=moil_time(Arena#arena.moil,SUid,Lv),
	Player2=role_api:exp_add(Player,Exp,moil_host_exp_cb,<<"苦工打工时间到获取经验">>),
	Arena2=Arena#arena{moil=Moil},
	role_api_dict:arena_set(Arena2),
	Player2.
	
%% 进入苦工
moil_enjoy(Socket,#arena{date=Date,moil=Moil},Lv,Data)->
	NDate=util:date_Ymd(),
	case Date =:= NDate of
		?true->
			moil_enjoy2(Socket,Moil,Lv,Data);
		_->
			Moil2=Moil#moil{ 		
							captrue_count		= ?CONST_MOIL_CAPTRUE_COUNT,% 抓捕次数
							active_count		= ?CONST_MOIL_ACTIVE_COUNT,	% 互动次数
							calls_count		    = ?CONST_MOIL_CALLS_COUNT,	% 求救次数	
							protest_count		= ?CONST_MOIL_PROTEST_COUNT,% 反抗次数
							expn				= 0,						% 今日获得经验
							buy_count			= ?CONST_MOIL_CATCH_MAX 	% 购买次数
						   },
			moil_enjoy2(Socket,Moil2,Lv,Data)
	end.

moil_enjoy2(Socket,Moil,Lv,Data)->
	#moil{type_id = TypeId,captrue_count = CaptrueCount, 
		  active_count = ActiveCount,calls_count = CallsCount, 
		  protest_count = ProtestCount,expn = Expn,landlord = Landlord}=Moil,
%% 	case data_moil_exp:get(Lv) of
%% 		#d_moil_exp{exp_max=ExpMax}->
%% 			Expn2=?IF(Expn>=ExpMax,ExpMax,Expn),
%% 			Exp	=ExpMax;
%% 		_->
%% 			Expn2=0,
%% 			Exp	=0
%% 	end,	
	Expn2=0,
	Exp	=0,
	BinMsg=msg_moil_data(TypeId,Landlord,CaptrueCount,ActiveCount,
						 CallsCount,ProtestCount,Expn2,Exp,Data),
	app_msg:send(Socket,BinMsg).

%% 抓捕苦工
moil_captrue_calls(_Player,?CONST_MOIL_FUNCTION_CATCH,ToId0)->
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	case Moil#moil.type_id of
		?CONST_MOIL_ID_MOIL->
			{?error,?ERROR_MOIL_MOIL_FULL};
		_->
			MLUid2=case Moil#moil.landlord of
					   {MLUid,_,_}->
						   MLUid;
					   _->
						   0
				   end,
			case MLUid2=:=ToId0 of
				?true->
					{?error,?ERROR_MOIL_NO_HOST}; %% 不能抓主人 
				_->
					case length(Moil#moil.moil_data) >= ?CONST_MOIL_MOIL_COUNT of
						?true->
							{?error,?ERROR_MOIL_MOIL_FULL}; %% 苦工已满
						?false->
							case Moil#moil.captrue_count > 0 of
								?true->
									case lists:keyfind(ToId0,2,Moil#moil.moil_data) of
										?false->
											PlayerWar=moil_host_siduid(ToId0), %% 找战斗对象
											{?true,PlayerWar};
										_->
											{?error,?ERROR_MOIL_USE_MOIL}
									end; 
								?false->
									{?error,?ERROR_MOIL_CAPTRUE}
							end
					end
			end
	end;


%% 苦工求救
moil_captrue_calls(#player{uid=Uid},?CONST_MOIL_FUNCTION_ASKHELP,ToId0)->
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	case Moil#moil.calls_count >0 of
		?true->
			case Moil#moil.landlord of
				{LUid,_LName,_LLv}->
					case ToId0=:=LUid of
						?true->{?error,?ERROR_MOIL_NO_HOST_RES}; 
						_->
							case moil_protect_calls(LUid,Uid) of 
								?true->
									PlayerWar=moil_host_siduid(LUid),
									PlayerWar2=moil_host_siduid(ToId0), %% 找战斗对象
									{?true,PlayerWar,PlayerWar2};
								_->{?error,?ERROR_MOIL_PROTECT_TIME}
							end
					end;
				?false->
					{?error,?ERROR_MOIL_RES}; % 求救次数不足
				_->{?error,?ERROR_MOIL_NO_HOST_RES}
			end
	end;

%% 苦工反抗
moil_captrue_calls(#player{uid=Uid},?CONST_MOIL_FUNCTION_REVOLT,_ToId0)->
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	case Moil#moil.protest_count >0 of
		?true->
			case Moil#moil.landlord of
				{LUid,_LName,_LLv}->
					case moil_protect_calls(LUid,Uid) of 
						?true->
							PlayerWar=moil_host_siduid(LUid),
							{?true,PlayerWar};
						_->{?error,?ERROR_MOIL_PROTECT_TIME}
					end;
				_->
					{?error,?ERROR_MOIL_NOT} % 没有主人
			end;
		_-> 
			{?error,?ERROR_MOIL_PROTEST_NOT} %% 反抗次数不足
	end;
		
moil_captrue_calls(Player,_,_ToId)->
	{?ok,Player}.

moil_protect_calls(LUid,ToId0)->
	LastTime=util:seconds(),
	case ets:lookup(?ETS_OFFLINE_SUB,{LUid,?PROC_USER_ARENA}) of
		[{_,_,LArena}|_] when is_record(LArena,arena)->
			LMoil=LArena#arena.moil,
			case moil_protect(LMoil#moil.protect_time,ToId0,LastTime) of 
				?true-> ?true;
				_->?false
			end;
		_->?false
	end.
				
moil_captrue_res(Player,TypeId,Uid,Res)->
	LastTime=util:seconds(),
	case Res of
		?CONST_FALSE->
%% 			MoilHearsay={LastTime,Uid,Name,LUid,LName,TypeId,Res},
%% 			_HearsayData=moil_data_set(Uid,LUid,MoilHearsay),
			{?ok,Player};
		_->
			case TypeId of
				?CONST_MOIL_FUNCTION_CATCH->
					moil_captrue_catch(Player,Uid);
				?CONST_MOIL_FUNCTION_REVOLT->
					moil_captrue_revolt(Player);
				?CONST_MOIL_FUNCTION_ASKHELP->
					moil_captrue_revolt(Player);
				_->{?ok,Player}
			end
	end.


%% 抓捕成功  需更新苦工主人信息
moil_captrue_catch(Player=#player{uid=Uuid,uname=Uname,lv=ULv},Uid)->
	Arena=role_api_dict:arena_get(),
	#arena{moil=Moil}=Arena,
	case role_api_dict:player_get(Uid) of
		MPlayer when is_record(MPlayer,player)->
			catch_moil(Uid,{Uuid,Uname,ULv}),
			#player{uname=MName,sex=MSex,pro=MPro,lv=MLv}=MPlayer,
			Time=util:seconds(),
			MoilData={Uid,MName,MSex,MPro,MLv,3600*24,Time},
			Moil2=Moil#moil{moil_data=[MoilData|Moil#moil.moil_data]},
			Arena2=Arena#arena{moil=Moil2},
			role_api_dict:arena_set(Arena2),
			{?ok,Player};
		_->
			{?ok,Player}
	end.
			
%% 反抗/求救成功 需更新主人信息
moil_captrue_revolt(Player=#player{uid=Uid})->
	Arena=role_api_dict:arena_get(),
	#arena{moil=Moil}=Arena,
	catch_landlord(Uid,Moil#moil.landlord),
	Moil2=Moil#moil{type_id=?CONST_MOIL_ID_FREEMAN,landlord=0,protect_time=[],moil_data=[]},
	Arena2=Arena#arena{moil=Moil2},
	role_api_dict:arena_set(Arena2),
	{?ok,Player}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 更新苦工的信息
catch_moil(Uid,Landlord)->
	case role_api:mpid(Uid) of
		Pid when is_pid(Pid)->
			util:pid_send(Pid,?MODULE,catch_moil_cb,{Uid,Landlord});
		_->
			Arena=role_api_dict:arena_get(Uid),
			catch_moil_cb2(Uid,Arena,Landlord)
	end.
			
catch_moil_cb(Player,{Uid,Landlord})->
	Arena=role_api_dict:arena_get(),
	catch_moil_cb2(Uid,Arena,Landlord),
	Player.

catch_moil_cb2(Uid,Arena,Landlord)->
	#arena{moil=Moil}=Arena,
	catch_landlord(Uid,Moil#moil.landlord),
	Moil2=Moil#moil{type_id=?CONST_MOIL_ID_MOIL,landlord=Landlord},
	Arena2=Arena#arena{moil=Moil2},
	role_api_dict:arena_set(Arena2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 更新主人的信息
catch_landlord(MUid,{Uid,_,_})->
	case role_api:mpid(Uid) of
		Pid when is_pid(Pid)->
			util:pid_send(Pid,?MODULE,catch_landlord_cb,MUid);
		_->
			Arena=role_api_dict:arena_get(Uid),
			catch_landlord_cb2(MUid,Arena)
	end. 

catch_landlord_cb(Player,MUid)->
	Arena=role_api_dict:arena_get(),
	catch_landlord_cb2(MUid,Arena),
	Player.

catch_landlord_cb2(MUid,Arena)->
	#arena{moil=Moil}=Arena,
	case lists:keytake(MUid,1,Moil#moil.moil_data) of
		{value,_,[]} ->
			Moil2=Moil#moil{type_id=?CONST_MOIL_ID_FREEMAN,moil_data=[]};
		{value,_,MoilData}->
			Moil2=Moil#moil{moil_data=MoilData};
		_->
			Moil2=Moil#moil.moil_data
	end,
	Arena2=Arena#arena{moil=Moil2},
	role_api_dict:arena_set(Arena2).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% moil_captrue_calls_cb(Player=#player{arena=Arena},{TSid,TUid,TName,TMoilDs2})->
%% 	Moil=Arena#arena.moil,
%% 	TTypeId=case TMoilDs2 of
%% 		[]->
%% 			?CONST_MOIL_ID_FREEMAN;
%% 		_->
%% 			?CONST_MOIL_ID_HOST
%% 	end,
%% 	Moil2=Moil#moil{type_id=TTypeId,landlord={TSid,TUid,TName},moil_data=TMoilDs2},
%% 	Arena2=Arena#arena{moil=Moil2},
%% 	Player#player{arena=Arena2}.
%% 	

%% %% 更新苦工
%% moil_updates(LSid,LUid,Uid)->
%% 	case role_api:get_pid(LUid) of
%% 		Pid when is_pid(Pid)->
%% 			role_api:progress_send(Pid,?MODULE,moil_update_cb,Uid);
%% 		_->
%% 			case role_api:player_data_offline(LSid,LUid) of
%% 				{?ok,Player} when is_record(Player,player)->
%% 					Player2=moil_update_player(Player,Uid),
%% 					role_api:db_save(Player2);
%% 				_->?skip
%% 			end
%% 	end.
%% 				
%% moil_update_cb(Player,TUid)->
%% 	moil_update_player(Player,TUid).
	
				
%% moil_update_player(Player=#player{arena=Arena},Uid)->
%% 	Moil=Arena#arena.moil,
%% 	ProtectTime=lists:keydelete(Uid,1,Moil#moil.protect_time),
%% 	{MoilData,PTypeId2,MExpn2}=case lists:keytake(Uid,2,Moil#moil.moil_data) of
%% 		{value,{_,_,_,_,_,MTlV,MSTime,MSTTime,_},[]}->
%% 			MExpn=moil_worket_exp(MTlV,MSTime,MSTTime),
%% 			PTypeId=moil_type_host(Moil#moil.type_id),
%% 			{[],PTypeId,MExpn};
%% 		{value,{_,_,_,_,_,MTlV,MSTime,MSTTime,_},MoilData0}->
%% 			MExpn=moil_worket_exp(MTlV,MSTime,MSTTime),
%% 			{MoilData0,Moil#moil.type_id,MExpn};
%% 		_->
%% 			{Moil#moil.moil_data,Moil#moil.type_id,0}
%% 	end,
%% %% 	{MoilData,PTypeId2}=case lists:keydelete(Uid,2,Moil#moil.moil_data) of
%% %% 				 []->
%% %% 					 PTypeId=moil_type_host(Moil#moil.type_id),
%% %% 					 {[],PTypeId};
%% %% 				  MoilData0->
%% %% 					  {MoilData0,Moil#moil.type_id}
%% %% 			  end,
%% 	Moil2=Moil#moil{type_id=PTypeId2,moil_data=MoilData,protect_time=ProtectTime},
%% 	Arena2=Arena#arena{moil=Moil2},
%% 	Player2=Player#player{arena=Arena2},
%% 	moil_exp_cb(Player2,MExpn2).

%% 互动 
moil_active(Player=#player{socket=Socket,uname=Name,uid=Uid},ActiveId,TSid,TUid)->
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	LastTime=util:seconds(),
	ProUid=?IF(TUid==0,Uid,TUid),
	case moil_protect(Moil#moil.protect_time,ProUid,LastTime) of
		?true-> 
			case Moil#moil.active_count > 0 of
				?true ->
					case {TSid,TUid}=:={0,0} of
						?true ->  
							{LUid,LName,_LLv}=?IF(Moil#moil.landlord=:=0,{0,<<>>,0},Moil#moil.landlord),
							case ets:lookup(?ETS_OFFLINE_SUB,{LUid,player}) of
								[{PlayerKey,_,#player{lv=LLv}=LPlayer}|_]->
									#d_moil_exp{active_exp=ActiveExp}=data_moil_exp:get(LLv),
									MoilHearsay={LastTime,Uid,Name,LUid,LName,?CONST_MOIL_FUNCTION_INTER,ActiveId,ActiveExp},
									_HearsayData=moil_data_set(Uid,LUid,MoilHearsay),
									case role_api:mpid(LUid) of
										Mpid when is_pid(Mpid)->
											role_api:progress_send(Mpid,?MODULE,moil_protect_cb,{Uid,?true});
										_->
											LPlayer2=moil_protect_cb(LPlayer,{Uid,?false}),
											Time=util:seconds(),
											ets:insert(?ETS_OFFLINE_SUB,{PlayerKey,Time,LPlayer2})
									end,
									ProtectTime=[{Uid,LastTime}|lists:keydelete(TUid,1,Moil#moil.protect_time)],
									Moil2=Moil#moil{active_count=Moil#moil.active_count-1,protect_time=ProtectTime},
									Arena2=Arena#arena{moil=Moil2},
									HBinMsg=msg_moil_rs({LastTime,Uid,Name,LUid,LName,?CONST_MOIL_FUNCTION_INTER,ActiveId,ActiveExp}),
%% 									moil_enjoy(Socket,Arena2,Info#info.lv,HearsayData),
%% 									BinMsg=msg_protect_time([{Uid,60*10}]),
									app_msg:send(Socket,HBinMsg),
									role_api_dict:arena_set(Arena2),
									Player2=role_api:exp_add(Player,ActiveExp,moil_active,<<"互动">>),
									{?ok,Player2};
								{?error,Error}->
									{?error,Error}
							end;
						_->
							case lists:keyfind(TUid,2,Moil#moil.moil_data) of
								?false->
									{?error,?ERROR_MOIL_NOT_MOIL}; %% 没有这个苦工
								_->
									case ets:lookup(?ETS_OFFLINE_SUB,{TUid,player}) of 
										[{_,_,#player{lv=TLv,uname=TName}}|_]->
											#d_moil_exp{active_exp=ActiveExp}=data_moil_exp:get(TLv),
											MoilHearsay={LastTime,Uid,Name,TUid,TName,?CONST_MOIL_FUNCTION_INTER,ActiveId,ActiveExp},
											_HearsayData=moil_data_set(Uid,TUid,MoilHearsay),
											ProtectTime=[{TUid,LastTime}|lists:keydelete(TUid,1,Moil#moil.protect_time)],
											Moil2=Moil#moil{active_count=Moil#moil.active_count-1,protect_time=ProtectTime},
											Arena2=Arena#arena{moil=Moil2},
											HBinMsg=msg_moil_rs({LastTime,Uid,Name,TUid,TName,?CONST_MOIL_FUNCTION_INTER,ActiveId,ActiveExp}),
%% 											moil_enjoy(Socket,Arena2,Info#info.lv,HearsayData),
%% 											BinMsg=msg_protect_time([{TUid,60*10}]),
											app_msg:send(Socket,HBinMsg),
											role_api_dict:arena_set(Arena2),
											Player2=role_api:exp_add(Player,ActiveExp,moil_active,<<"互动">>),
											{?ok,Player2};
										{?error,Error}->
											{?error,Error};
										_->
											{?error,?ERROR_MOIL_NOT_MOIL}
									end
							end
					end;
				?false->
					{?error,?ERROR_MOIL_ACTIVE} %% 互动次数不足
			end;
		_->
			{?error,?ERROR_MOIL_PROTECT_TIME} %% 互动时间不足
	end.
	

%% 判断苦工是否在互动保护时间
moil_protect(ProtectTime,TUid,LastTime)->
	case ProtectTime of
		[]->
			?true;
		MoilProtects ->
			case lists:keyfind(TUid,1,MoilProtects) of
				{_,MTime}->
					?MSG_ECHO("----------------------- ~w~n",[LastTime-MTime]),
					?IF(LastTime-MTime >= 60*10,?true,?false);
				_-> ?true
			end
	end.

%% 苦工互动刷新时间
moil_protect_cb(Player=#player{uid=Uid},{MUid,Flag})->
	case Flag of
		?true->
			Arena=role_api_dict:arena_get();
		_->
			{_,_,Arena}=ets:lookup(?ETS_OFFLINE_SUB,{Uid,?PROC_USER_ARENA})
	end,
	LastTime=util:seconds(),
	Moil=Arena#arena.moil,
	ProtectTime=[{MUid,LastTime}|lists:keydelete(MUid,1,Moil#moil.protect_time)],
	Moil2=Moil#moil{protect_time=ProtectTime},
	Arena2=Arena#arena{moil=Moil2},
	?IF(Flag==?true,role_api_dict:arena_set(Arena2),ets:insert(?ETS_OFFLINE_SUB,{{Uid,?PROC_USER_ARENA},Arena2})),
	Player.

%% 苦工剩余时间
moil_protect_time(ProtectTime)->
	Time=util:seconds(),
	Fun=fun({Uid,MTime},Acc)->
				if
					Time-MTime >= 60*10 ->
						Acc;
					?true->
						[{Uid,60*10-(Time-MTime)}|Acc]
				end
		end,
	lists:foldl(Fun,[],ProtectTime).

%% 请求压榨
moil_press_start(MoilData)->
	Fun=fun({Tuid,TPro,TSex,TName,TLv,_TStime,_TTime,_TPCount},Acc)->
				[{Tuid,TPro,TSex,TName,TLv}|Acc]
		end,
	lists:foldl(Fun,[],MoilData).

%% 压榨界面
moil_press_enjoy(MoilData,MoilUid)->
	case lists:keyfind(MoilUid,2,MoilData) of
		{_Tuid,_TPro,_TSex,_TName,TLv,TStime,TTime,_TPCount}->
			Time=util:seconds(),
			UseTime=Time-TTime,
			Exp=case data_moil_exp:get(TLv) of
					#d_moil_exp{moil_exp=MoilExp}->
						MoilExp/(3600*24);
					_->
						0 
				end,
			Expn=round(UseTime*Exp),
			Expn2=?IF(TStime=<0,0,Expn),
			LTime=?IF(TStime-UseTime=<0,0,TStime-UseTime),
			{Expn2,LTime};
		_->
			{0,0}
	end.

%% 压榨操作
%% 压榨
moil_press(Player=#player{lv=InfoLv,uname=InfoName},?CONST_MOIL_PRESS,TUid)->
	Arena=role_api_dict:arena_get(),
	case role_api:currency_cut([moil_press,[],<<"压榨消耗金元">>],Player,[{?CONST_CURRENCY_RMB,10}]) of
		{?ok,Player2,Bin}->
			Moil=Arena#arena.moil,
			case lists:keytake(TUid,2,Moil#moil.moil_data) of
				{value,{NUid,NPro,NSex,NName,NLv,NStime,NTime,NPCount},MoilDatas}->
					Time=util:seconds(),
					UseTime=Time-NTime,
					ExpMax=moil_max_exp(InfoLv),
					Exp=moil_s_exp(NLv),
					Stime=?IF(NStime-(UseTime+NPCount*60)=<0,0,NStime-UseTime),
					case Stime of
						0->?skip;
						_->
							ExpTime=?IF(Stime>=3600,3600,Stime),
							ExpN0=round(UseTime*Exp+Exp*ExpTime),
							ExpN=?IF(NStime=<0,0,ExpN0),
							ExpN2=moil_press_full_exp(InfoLv,Moil#moil.expn,round(ExpN)),
							PressList=[{InfoName,ExpN2}],
							Player3=role_api:exp_add(Player2,ExpN2,moil_press1,<<"压榨">>),
							{STIME,MoilDatas2}=?IF(NStime-UseTime=<0,{0,[{NUid,NPro,NSex,NName,NLv,0,NTime,NPCount}|MoilDatas]},
												   {Stime-ExpTime,[{NUid,NPro,NSex,NName,NLv,Stime-ExpTime,Time,NPCount+1}|MoilDatas]}),
							LastExp=?IF(Moil#moil.expn+ExpN2>=ExpMax,ExpMax,Moil#moil.expn+ExpN2),
							Moil2=Moil#moil{expn=LastExp,moil_data=MoilDatas2},
							Arena2=Arena#arena{moil=Moil2},
							role_api_dict:arena_set(Arena2),			
							{?ok,Player3,{STIME,PressList},Bin}
					end;
				?false->
					{?error,?ERROR_MOIL_NOT_MOIL} %%  没有这个苦工
			end;
		_->
			{?error,?ERROR_RMB_LACK} %% 金元不足
	end;

%% 提取 
moil_press(Player=#player{lv=InfoLv,uname=InfoName},?CONST_MOIL_PRESS_2,TUid)->
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	case lists:keytake(TUid,2,Moil#moil.moil_data) of
		{value,{NUid,NPro,NSex,NName,NLv,NStime,NTime,NPCount},MoilDatas}->
			Time=util:seconds(),
			UseTime=Time-NTime,
			ExpMax=moil_max_exp(InfoLv),
			Exp=moil_s_exp(NLv),
			ExpN0=round(UseTime*Exp),
			ExpN=?IF(NStime=<0,0,ExpN0),
			ExpN2=moil_press_full_exp(InfoLv,Moil#moil.expn,round(ExpN)),
			PressList=[{InfoName,ExpN2}],
			Player2=role_api:exp_add(Player,ExpN2,moil_press2,<<"提取">>),
			{STIME,MoilDatas2}=?IF(NStime-UseTime=<0,{0,[{NUid,NPro,NSex,NName,NLv,0,NTime,NPCount}|MoilDatas]},
								   {NStime-UseTime,[{NUid,NPro,NSex,NName,NLv,NStime-UseTime,Time,NPCount}|MoilDatas]}),
			LastExp=?IF(Moil#moil.expn+ExpN2>=ExpMax,ExpMax,Moil#moil.expn+ExpN2),
			Moil2=Moil#moil{expn=LastExp,moil_data=MoilDatas2},
			Arena2=Arena#arena{moil=Moil2},
			role_api_dict:arena_set(Arena2),
			{?ok,Player2,{STIME,PressList},<<>>};
		?false->
			{?error,?ERROR_MOIL_NOT_MOIL} %%  没有这个苦工
	end;

%% 抽干
moil_press(Player=#player{lv=InfoLv,uname=InfoName},?CONST_MOIL_PRESS_3,TUid)->
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	case lists:keytake(TUid,2,Moil#moil.moil_data) of
		{value,{NUid,NPro,NSex,NName,NLv,NStime,NTime,NPCount},MoilDatas}->
			Rmb=util:ceil(NStime/3600)*10,
			case role_api:currency_cut([moil_press,[],<<"压榨消耗金元">>],Player,[{?CONST_CURRENCY_RMB,Rmb}]) of
				{?ok,Player2,Bin}->
					Time=util:seconds(),
					UseTime=Time-NTime,
					ExpMax=moil_max_exp(InfoLv),
					Exp=moil_s_exp(NLv),
					Stime=?IF(NStime-UseTime=<0,0,NStime-UseTime),
					ExpN0=round(UseTime*Exp+Exp*Stime),
					ExpN=?IF(NStime=<0,0,ExpN0),
					ExpN2=moil_press_full_exp(InfoLv,Moil#moil.expn,round(ExpN)),
					PressList=[{InfoName,ExpN2}],
					Player3=role_api:exp_add(Player2,ExpN2,moil_press3,<<"抽干">>),
					MoilDatas2=[{NUid,NPro,NSex,NName,NLv,0,NTime,NPCount}|MoilDatas],
					LastExp=?IF(Moil#moil.expn+ExpN2>=ExpMax,ExpMax,Moil#moil.expn+ExpN2),
					Moil2=Moil#moil{expn=LastExp,moil_data=MoilDatas2},
					Arena2=Arena#arena{moil=Moil2},
					role_api_dict:arena_set(Arena2),
					{?ok,Player3,{0,PressList},Bin};
				_->
					{?error,?ERROR_RMB_LACK}
			end;
		?false->
			{?error,?ERROR_MOIL_NOT_MOIL} %%  没有这个苦工
	end;
moil_press(_,_Type,_TUid)->
	{?error,?ERROR_MOIL_NOT_MOIL}.



%% 计算苦工每秒获得经验
moil_s_exp(Lv)->
	case data_moil_exp:get(Lv) of 
		#d_moil_exp{moil_exp=MoilExp}->
			MoilExp/(3600*24);
		_->0
	end.

%% 查看当前等级苦工经验获取上限
moil_max_exp(Lv)->
	case data_moil_exp:get(Lv) of 
		#d_moil_exp{exp_max=ExpMax}->
			ExpMax;
		_->0
	end.

%% 查看经验是否已满
moil_press_full(Lv,Exp)->
	case data_moil_exp:get(Lv) of
		#d_moil_exp{exp_max=ExpMax}->
			Exp>=ExpMax;
		_->
			?false
	end.

moil_press_full_exp(Lv,Exp,Exp2)->
	case data_moil_exp:get(Lv) of
		#d_moil_exp{exp_max=ExpMax}->
			SExp=?IF(ExpMax-Exp=<0,1,ExpMax-Exp),
			?IF(SExp>=Exp2,Exp2,SExp);
		_->
			1
	end.

moil_worket_exp(Lv,MSTime,MSTTime)->
	Exp=case data_moil_exp:get(Lv) of
			#d_moil_exp{exp_max=MoilExp}->
				MoilExp/(3600*24);
			{?error,_Error}->
				0
		end,
	Time=util:seconds(),
	UseTime=Time-MSTTime,
	Stime=?IF(MSTime-UseTime=<0,MSTime,UseTime),
	round(Exp*Stime).
	
%% 工作时间到
moil_time(Moil=#moil{type_id=TypeId,protect_time=ProtectTime,moil_data=MoilData},Uid,Lv)->
	Exp=moil_exp(MoilData,Uid,Lv),
	MoilData2=lists:keydelete(Uid,2,MoilData),
	ProtectTime2=lists:keydelete(Uid,1,ProtectTime),
	TypeId2=case MoilData2 of
				[]-> ?CONST_MOIL_ID_FREEMAN;
				_->	 TypeId
			end,
	Moil2=Moil#moil{type_id=TypeId2,protect_time=ProtectTime2,moil_data=MoilData2},
	{Exp,Moil2}.

moil_exp(MoilData,Uid,Lv)->
	case lists:keytake(Uid,2,MoilData) of
		{value,{_NUid,_NPro,_NSex,_NName,_NLv,NStime,_NTime},_MoilData}->
			#d_moil_exp{moil_exp=MoilExp}=data_moil_exp:get(Lv),
			Exp=MoilExp/(3600*24),
			trunc(NStime*Exp);
		_->
			0
	end.
			
%% moil_exp(Sid,Uid,TUid,TLv)->
%% 	case role_api:player_data(Sid,Uid) of 
%% 		{?ok,Player} when is_record(Player,player)->
%% 			Info=Player#player.info,
%% 			Arena=Player#player.arena,
%% 			Moil=Arena#arena.moil,
%% 			case lists:keytake(TUid,2,Moil#moil.moil_data) of
%% 				{value,{_NSid,_NUid,_NPro,_NSex,_NName,_NLv,NStime,_NTime},_MoilData}->
%% 					#d_moil_exp{moil_exp=MoilExp}=data_moil_exp:get(TLv),
%% 					Exp=MoilExp/(3600*24),
%% 					ExpN=trunc(NStime*Exp),
%% 					case Moil#moil.landlord of
%% 						{LSid,LUid,_LName,_LLv}->
%% 							ExpN2=round(ExpN/2),
%% 							case role_api:get_pid(Uid) of
%% 								Pid when is_pid(Pid)->
%% 									role_api:progress_send(Pid,?MODULE,moil_exp_cb,{TUid,ExpN2});
%% 								_->
%% 									Player2=moil_exp_cb(Player,{TUid,ExpN2}),
%% 									role_api:db_save(Player2)
%% 							end,
%% 							moil_player(LSid,LUid,ExpN2,0,[{Info#info.name,ExpN2}]);
%% 						_->
%% 							case role_api:get_pid(Uid) of
%% 								Pid when is_pid(Pid)->
%% 									role_api:progress_send(Pid,?MODULE,moil_exp_cb,{TUid,ExpN});
%% 								_->
%% 									Player2=moil_exp_cb(Player,{TUid,ExpN}),
%% 									role_api:db_save(Player2)
%% 							end
%% 					end;
%% 				_->?ok
%% 			end;
%% 		_->?ok
%% 	end.
%% 
%% 									
%% moil_player(Sid,Uid,ExpN,Count,Acc) when Count=< 2->
%% 	case role_api:player_data(Sid,Uid) of 
%% 		{?ok,Player} when is_record(Player,player)->
%% 			Info=Player#player.info,
%% 			Arena=Player#player.arena,
%% 			Moil=Arena#arena.moil,
%% 			case Moil#moil.landlord of
%% 				{LSid,LUid,_LName,_LLv}->
%% 					ExpN2=round(ExpN/2),
%% 					case role_api:get_pid(Uid) of
%% 						Pid when is_pid(Pid)->
%% 							role_api:progress_send(Pid,?MODULE,moil_exp_cb,ExpN2);
%% 						_->
%% 							Player2=moil_exp_cb(Player,ExpN2),
%% 							role_api:db_save(Player2)
%% 					end,
%% 					moil_player(LSid,LUid,ExpN2,Count+1,[{Info#info.name,ExpN2}|Acc]);
%% 				_->
%% 					case role_api:get_pid(Uid) of
%% 						Pid when is_pid(Pid)->
%% 							role_api:progress_send(Pid,?MODULE,moil_exp_cb,ExpN);
%% 						_->
%% 							Player2=moil_exp_cb(Player,ExpN),
%% 							role_api:db_save(Player2)
%% 					end,
%% 					[{Info#info.name,ExpN}|Acc]
%% 			end;
%% 		_->
%% 			Acc
%% 	end;
%% 		
%% moil_player(_Sid,_Uid,_ExpN,_Count,Acc)->Acc.
  
  
%% moil_exp_cb(Player=#player{arena=Arena,info=Info},Arg)->
%% 	Moil=Arena#arena.moil,
%% 	case Arg of
%% 		{TUid,ExpN}->
%% 			ExpN2=moil_press_full_exp(Info#info.lv,Moil#moil.expn,round(ExpN/2)),
%% 			MoilData=lists:keydelete(TUid,2,Moil#moil.moil_data),
%% 			Moil2=Moil#moil{moil_data=MoilData,expn=Moil#moil.expn+ExpN2},
%% 			Arena2=Arena#arena{moil=Moil2},
%% 			Player2=Player#player{arena=Arena2},
%% 			Player3=role_api:exp_add(Player2,ExpN2,moil_exp_cb,<<"主人的主人">>);
%% 		ExpN->
%% 			ExpN2=moil_press_full_exp(Info#info.lv,Moil#moil.expn,ExpN),
%% 			Moil2=Moil#moil{expn=Moil#moil.expn+ExpN2},
%% 			Arena2=Arena#arena{moil=Moil2},
%% 			Player2=Player#player{arena=Arena2},
%% 			Player3=role_api:exp_add(Player2,round(ExpN2),moil_exp_cb,<<"主人的主人">>)
%% 	end,
%% 	Player3.

%% moil_api:moil_data_set(3,2,4,{1,2,3,4,5,6,7,8,9})
%% 把挑战信息存入数据库
moil_data_set(Uid,BUid,MoilHearsay) ->
	MoilHearsays=mysql_update_data_uid(Uid,MoilHearsay,[]),
	mysql_update_data_uid(BUid,MoilHearsay,[]),
	MoilHearsays.
 
mysql_update_data_uid(Uid,MoilHearsay,Acc) -> 
	case ets:lookup(?ETS_MOIL_DATA, Uid) of
		[] ->
			ets:insert(?ETS_MOIL_DATA, {Uid,[MoilHearsay|Acc]}),
			{_,Datas} = util:bin_for_db([MoilHearsay|Acc]),
			mysql_api:fetch("REPLACE INTO moil_data (uid,sid,datas) VALUES ("
						   ++util:to_list(Uid)++","++util:to_list(0)++","++util:to_list(Datas)++");"),
			[MoilHearsay|Acc];
		[{_uid,DataS}] ->
			DataS2 = [MoilHearsay|DataS],
			DataS3 = lists:sublist(DataS2, ?CONST_ARENA_NUM),
			ets:update_element(?ETS_MOIL_DATA, Uid, [{2,DataS3}]),
			{_,DataS4} =  util:bin_for_db(DataS3),
			mysql_api:fetch("REPLACE INTO moil_data (uid,sid,datas) VALUES ("
						   ++util:to_list(Uid)++","++util:to_list(0)++","++util:to_list(DataS4)++");"),
			DataS3
	end.


%% 释放苦工 更新苦工信息
moil_release(TUid)->
	case role_api:mpid(TUid) of
		Pid when is_pid(Pid)->
			role_api:progress_send(Pid,?MODULE,moil_release_cb,?null);
		_->
			case ets:lookup(?ETS_OFFLINE_SUB,{TUid,?PROC_USER_ARENA}) of
				[{Key,_,Arena}|_] when is_record(Arena,arena)->
					Moil=Arena#arena.moil,
					Moil2=Moil#moil{type_id=?CONST_MOIL_ID_FREEMAN,landlord=0},
					Arena2=Arena#arena{moil=Moil2},
					Time=util:seconds(),
					ets:insert(?ETS_OFFLINE_SUB,{Key,Time,Arena2});
				_->
					?skip
			end
	end.

moil_release_cb(Player,_)->
	Arena=role_api_dict:arena_get(),
	Moil=Arena#arena.moil,
	Moil2=Moil#moil{type_id=?CONST_MOIL_ID_FREEMAN,landlord=0},
	Arena2=Arena#arena{moil=Moil2},
	role_api_dict:arena_set(Arena2),
	Player.
	

	
%% 抓捕苦工 有主人返回主人Sid,Uid,没有返回原来的Sid,Uid
moil_host_siduid(TUid)->
	case ets:lookup(?ETS_OFFLINE,TUid) of
		[{_,_,Player,DictDate}|_]->
			ok;
		_->
			?skip
	end.
%% 	Moil=Arena#arena.moil,
%% 	case Moil#moil.landlord of
%% 		{LSid,LUid,_Name,_LLv}->
%% 			case role_api:player_data(LSid,LUid) of
%% 				{?ok,#player{arena=LArena}}->
%% 					{LSid,LUid,(LArena#arena.moil)#moil.protect_time};
%% 				_->
%% 					{LSid,LUid,[]}
%% 			end;
%% 		_->
%% 			{Sid,Uid,[]}
%% 	end.
			
%% 返回苦工的信息 {服务器ID,玩家Uid,职业,性别,名字,等级,剩余时间,开始时间,压榨次数}
%% moil_captrue_ok_data(CSid,CUid,CInfo,Player,ReveDate,{LMLSid2,LMLUid2})->
%% 	#info{name=CName,name_color=CNameColor,lv=CLv}=CInfo,
%% 	LastTime=util:seconds(),
%% 	#player{sid=Sid,uid=Uid,info=Info,arena=Arena}=Player,
%% 	#info{lv=Lv,pro=Pro,sex=Sex,name=Name}=Info,
%% 	Moil=Arena#arena.moil,
%% 	case Moil#moil.type_id of
%% 		?CONST_MOIL_ID_HOST->
%% 			case moil_captrue_ok_data2(Moil#moil.moil_data,{LMLSid2,LMLUid2}) of
%% 				{MTSid,MTUid,MTPro,MTSex,MTName,MTlV,MSTime,MSTTime,_}->
%% 					%% 			[{MTSid,MTUid,MTPro,MTSex,MTName,MTlV,MSTime,MSTTime,_}|_]=Moil#moil.moil_data,
%% 					MExpn=moil_worket_exp(MTlV,MSTime,MSTTime),
%% 					TMoilD={MTSid,MTUid,MTPro,MTSex,MTName,MTlV,24*3600,LastTime,0},
%% 					ets:insert(?ETS_MOIL_WORKER,{MTSid,MTUid,LastTime,MTlV}),
%% 					moil_captrue_updata(MTSid,MTUid,{CSid,CUid,CName,CLv}),
%% 					case role_api:get_pid(Uid) of
%% 						MPid when is_pid(MPid)->
%% 							role_api:progress_send(MPid,?MODULE,moil_captrue_ok_data_cb,{MTUid,MExpn,ReveDate});
%% 						_->
%% 							Player2=moil_captrue_ok_data_cb(Player,{MTUid,MExpn,ReveDate}),
%% 							role_api:db_save(Player2)
%% 					end,
%% 					MNameColor=role_api:get_name_color(MTSid,MTUid),
%% 					logs_api:action_notice(Uid,?CONST_LOGS_8006,[{MTName,MNameColor},{CName,CNameColor}],[]),
%% 					MoilHearsay={LastTime,CSid,CUid,CName,Sid,Uid,Name,?CONST_MOIL_FUNCTION_SNATCH,?CONST_TRUE},
%% 					HearsayData=moil_data_set(CSid,CUid,Uid,MoilHearsay),
%% 					{?false,TMoilD,HearsayData};
%% 				_->
%% 					TMoilD={Sid,Uid,Pro,Sex,Name,Lv,24*3600,LastTime,0},
%% 					ets:insert(?ETS_MOIL_WORKER,{Sid,Uid,LastTime,Lv}),
%% 					case role_api:get_pid(Uid) of
%% 						MPid when is_pid(MPid)->
%% 							role_api:progress_send(MPid,?MODULE,moil_captrue_ok_type_cb,{CSid,CUid,CName,CLv});
%% 						_->
%% 							Player2=moil_captrue_ok_type_cb(Player,{CSid,CUid,CName,CLv}),
%% 							role_api:db_save(Player2)
%% 					end,
%% 					logs_api:action_notice(Uid,?CONST_LOGS_2012,[{CName,CNameColor}],[]),
%% 					MoilHearsay={LastTime,CSid,CUid,CName,Sid,Uid,Name,?CONST_MOIL_FUNCTION_CATCH,?CONST_TRUE},
%% 					HearsayData=moil_data_set(CSid,CUid,Uid,MoilHearsay),
%% 					{?true,TMoilD,HearsayData} 
%% 			end;
%% 		_->
%% 			TMoilD={Sid,Uid,Pro,Sex,Name,Lv,24*3600,LastTime,0},
%% 			ets:insert(?ETS_MOIL_WORKER,{Sid,Uid,LastTime,Lv}),
%% 			case role_api:get_pid(Uid) of
%% 				MPid when is_pid(MPid)->
%% 					role_api:progress_send(MPid,?MODULE,moil_captrue_ok_type_cb,{CSid,CUid,CName,CLv});
%% 				_->
%% 					Player2=moil_captrue_ok_type_cb(Player,{CSid,CUid,CName,CLv}),
%% 					role_api:db_save(Player2)
%% 			end,
%% 			logs_api:action_notice(Uid,?CONST_LOGS_2012,[{CName,CNameColor}],[]),
%% 			MoilHearsay={LastTime,CSid,CUid,CName,Sid,Uid,Name,?CONST_MOIL_FUNCTION_CATCH,?CONST_TRUE},
%% 			HearsayData=moil_data_set(CSid,CUid,Uid,MoilHearsay),
%% 			{?true,TMoilD,HearsayData} 
%% 	end.
%% 
%% %% 
%% moil_captrue_ok_data2([],_)->?null;
%% moil_captrue_ok_data2([{MTSid,MTUid,MTPro,MTSex,MTName,MTlV,MSTime,MSTTime,MR}|MoilDatas],{MLSid,MLUid})->
%% 	case {MTSid,MTUid}=={MLSid,MLUid} of
%% 		?true->moil_captrue_ok_data2(MoilDatas,{MLSid,MLUid});
%% 		_->{MTSid,MTUid,MTPro,MTSex,MTName,MTlV,MSTime,MSTTime,MR}
%% 	end.
%% 	
%% 	
%% %% 更新被抓人的信息前提为主人的情况
%% moil_captrue_ok_data_cb(Player=#player{arena=Arena},{MTUid,MExpn,{RSid,RUid,RName,RSex,RPro,RLv,RClanName,RPTypeId}})->
%% 	Moil=Arena#arena.moil,
%% 	ProtectTime=lists:keydelete(MTUid,1,Moil#moil.protect_time),
%% 	MoilDatas=lists:keydelete(MTUid,2,Moil#moil.moil_data),
%% 	RevengeList=lists:keydelete(RUid,2,Moil#moil.moil_data),
%% 	TypeId=case MoilDatas of
%% 			   []->
%% 				   ?CONST_MOIL_ID_FREEMAN;
%% 			   _->
%% 				   Moil#moil.type_id
%% 		   end,
%% 	Moil2=Moil#moil{type_id=TypeId,moil_data=MoilDatas,protect_time=ProtectTime,
%% 					revenge_list=[{RSid,RUid,RName,RSex,RPro,RLv,RClanName,RPTypeId}|RevengeList]},
%% 	Arena2=Arena#arena{moil=Moil2},
%% 	Player2=Player#player{arena=Arena2},
%% 	moil_exp_cb(Player2,MExpn).
%% 	
%% %% 更新被抓人的信息
%% moil_captrue_ok_type_cb(Player=#player{uid=Uid,arena=Arena},{CSid,CUid,CName,CLv0})->
%% 	Moil=Arena#arena.moil,
%% 	TypeId=case Moil#moil.type_id of
%% 		?CONST_MOIL_ID_FREEMAN->
%% 			?CONST_MOIL_ID_MOIL;
%% 		?CONST_MOIL_ID_HOST->
%% 			?CONST_MOIL_ID_H_M;
%% 		_->
%% 			Moil#moil.type_id
%% 	end,
%% 	case Moil#moil.landlord of
%% 		{LSid,LUid,_,_}->
%% 			moil_updates(LSid,LUid,Uid);
%% 		_->
%% 			?skip
%% 	end,
%% 	CLv=?IF(role_api:get_lv(CSid,CUid)==0,CLv0,role_api:get_lv(CSid,CUid)),
%% 	Moil2=Moil#moil{type_id=TypeId,landlord={CSid,CUid,CName,CLv}},
%% 	Arena2=Arena#arena{moil=Moil2},
%% 	Player#player{arena=Arena2}.
%% 
%% %% 
%% moil_captrue_updata(Sid,Uid,{CSid,CUid,CName,CLv})->
%% 	case role_api:get_pid(Uid) of
%% 		MPid when is_pid(MPid)->
%% 			role_api:progress_send(MPid,?MODULE,moil_captrue_ok_type_cb,{CSid,CUid,CName,CLv});
%% 		_->
%% 			case role_api:player_data_offline(Sid, Uid) of
%% 				{?ok,Player} when is_record(Player,player)->
%% 				Player2=moil_captrue_ok_type_cb(Player,{CSid,CUid,CName,CLv}),
%% 				role_api:db_save(Player2);
%% 				_->?skip
%% 			end
%% 	end.

%%
%% Local Functions
%%

% 返回自己身份信息 [35020]
msg_moil_data(TypeId,Landlord,CaptrueCount,
    ActiveCount,CallsCount,ProtestCount,Expn,
    Exp,RsData)->
	{LUid,LName,LLv}=?IF(Landlord=:=0,{0,<<>>,0},Landlord),
	Rs = app_msg:encode([{?int8u,TypeId},{?int32u,LUid},
						 {?string,LName},{?int16u,LLv},{?int8u,CaptrueCount},
						 {?int8u,ActiveCount},{?int8u,CallsCount},
						 {?int8u,ProtestCount},{?int32u,Expn},{?int32u,Exp},
						 {?int16u,length(RsData)}]),
	Fun=fun({LastTime,Uid,Name,Buid,Bname,Type,Rss},Acc)->
				Rs2=msg_moil_rs2({LastTime,Uid,Name,Buid,Bname,Type,Rss}),
				<<Acc/binary,Rs2/binary>>; 
		   ({LastTime,Uid,Name,Buid,Bname,Type,Rss,Exp},Acc)->
				Rs2=msg_moil_rs2({LastTime,Uid,Name,Buid,Bname,Type,Rss,Exp}),
				<<Acc/binary,Rs2/binary>>
		end,
	RsList=lists:foldl(Fun,Rs,RsData),
    app_msg:msg(?P_MOIL_MOIL_DATA, RsList).

msg_moil_rs(Active)->
	RsList=msg_moil_rs2(Active),
	app_msg:msg(?P_MOIL_MOIL_RS, RsList).

% 苦工操作信息 [35021]
msg_moil_rs2(Active)->
	case Active of
		{LastTime,Uid,Name,Buid,Bname,Type,Res}->
			app_msg:encode([{?int32u,LastTime},{?int32u,Uid},
							{?string,Name},{?int32u,Buid},
							{?string,Bname},{?int8u,Type},
							{?int8u,Res}]);
		{LastTime,Uid,Name,Buid,Bname,Type,Res,Exp}->
			app_msg:encode([{?int32u,LastTime},{?int32u,Uid},
							{?string,Name},{?int32u,Buid},
							{?string,Bname},{?int8u,Type},
							{?int8u,Res},{?int32u,Exp}])
	end.

% 玩家信息列表(抓捕,求救) [35025]
msg_player_data(Type,List)->
	Fun=fun({Uid,Name,Sex,Pro,Lv,ClanName,TypeId},Acc)->
				?MSG_ECHO("=================== ~w~n",[{Uid,Name,Sex,Pro,Lv,ClanName,TypeId}]),
				Rs=app_msg:encode([
								   {?int32u,Uid},{?string,Name},
								   {?int8u,Sex},{?int8u,Pro},
								   {?int16u,Lv},{?string,ClanName},
								   {?int8u,TypeId}]),
				<<Acc/binary,Rs/binary>>
				end,
	RsList=lists:foldl(Fun,app_msg:encode([{?int8u,Type},{?int16u,length(List)}]),List),
    app_msg:msg(?P_MOIL_PLAYER_DATA, RsList).

% 可压榨苦工 [35061]
msg_press_data(Type,MoilData)->
	Fun=fun({Uid,Pro,Sex,Name,Lv},Acc)->
				Rs=app_msg:encode([{?int32u,Uid},
								   {?int8u,Pro},{?int8u,Sex},
								   {?string,Name},{?int16u,Lv}]),
				<<Acc/binary,Rs/binary>>
		end,
	RsList=lists:foldl(Fun,app_msg:encode([{?int8u,Type},{?int16u,length(MoilData)}]),MoilData),
    app_msg:msg(?P_MOIL_PRESS_DATA, RsList).

% 苦工具体信息 [35064]
msg_moil_xxxx3(Expn,Time)-> 
    RsList = app_msg:encode([{?int32u,Expn},
        {?int32u,Time}]),
    app_msg:msg(?P_MOIL_MOIL_XXXX3, RsList).

% 压榨结果 [35080]
msg_press_rs(Type,Time,TUid,PressList)->
	Rs=app_msg:encode([{?int8u,Type},{?int32u,Time},{?int32u,TUid},{?int16u,length(PressList)}]),
	Fun=fun({Name,Exp},Acc)->
				Rs2=app_msg:encode([{?string,Name},{?int32u,round(Exp)}]),
				<<Acc/binary,Rs2/binary>>
		end,
    RsList=lists:foldl(Fun,Rs,PressList),
    app_msg:msg(?P_MOIL_PRESS_RS, RsList).


% 结果 [35110]
msg_release_rs(Type)-> 
    RsList = app_msg:encode([{?int8u,Type}]),
    app_msg:msg(?P_MOIL_RELEASE_RS, RsList).

% 互动保护剩余时间 [35022]
msg_protect_time(UidTimes)->
	RsCount=app_msg:encode([{?int16u,length(UidTimes)}]),
	Fun=fun({Uid,Time},Acc)->
				Rs=app_msg:encode([{?int32u,Uid},{?int32u,Time}]),
				<<Acc/binary,Rs/binary>>
		end,
	RsList=lists:foldl(Fun,RsCount,UidTimes),
    app_msg:msg(?P_MOIL_PROTECT_COUNT, RsList).


% 返回消耗信息 [35130]
msg_buy_ok()->
    app_msg:msg(?P_MOIL_BUY_OK,<<>>).

