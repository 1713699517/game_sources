%% Author: acer
%% Created: 2012-12-06
%% Description: TODO: Add description to vip_api.
-module(vip_api).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 
%%
%% API exports
-export([
		
		 login/1,
		 end_try_cb/2,
		 end_try_vip_cb/1,

		 check_fun/2,			%% 检查vip功能权限    Pos :: #d_vip.fun_XXX 

		 request_viplv/1, 
		 buy_rmb/2,
		 try_vip/3,
		 
		 msg_lv_my/2,
		 msg_vip_lv/2
		]).


%% 玩家(冲值/登录)(更新Vip数据)
%% reg:		{Player,SumRmb} | {Vip,SumRmb}  
%% retun:	Player2			| Vip2
buy_rmb(Player, SumRmb) when is_record(Player#player.vip, vip) ->
	#player{vip=Vip,socket=Socket,uid=Uid,uname=Name,uname_color=NameColor,lv=Lv,pro= Pro}=Player,
	#vip{lv=VipLv,lv_real=LvReal,indate=Indate}=Vip,
	case buy_rmb_acc(0, SumRmb) of
		LvReal ->
			Vip2= Vip#vip{sum_rmb=SumRmb,lv=erlang:max(VipLv, LvReal)},
			Player#player{vip=Vip2};
		LvReal2 ->
			stat_api:logs_vip(Uid,VipLv,lists:max([VipLv,LvReal2]),LvReal2),
			BinCast = broadcast_api:msg_broadcast_vip_lv({Uid,Name,Lv,NameColor,Pro}, LvReal2),
			?IF(check_fun(LvReal2, #d_vip.energy_max) > check_fun(VipLv, #d_vip.energy_max),
				begin 
					AddEnergyMax = check_fun(LvReal2, #d_vip.energy_max) - check_fun(VipLv, #d_vip.energy_max),
					energy_api:add_energy_max(AddEnergyMax) 
				end,
				?ok),
			chat_api:send_to_all(BinCast),
			case Indate of
				0 ->
					Vip2= #vip{lv_real=LvReal2,lv=LvReal2,sum_rmb=SumRmb},
					Player2= ref_vip_fun(Player#player{vip=Vip2}),
					BinMsg=msg_lv_my(Vip2#vip.lv,SumRmb),
					app_msg:send(Socket, BinMsg),
					scene_api:change_vip(Player2,LvReal2),
					Player2;
				_ ->
					if LvReal2>=VipLv ->
						   Vip2= #vip{lv_real=LvReal2,lv=LvReal2,indate=0,sum_rmb=SumRmb},
						   Player2= ref_vip_fun(Player#player{vip=Vip2}),
						   BinMsg=msg_lv_my(Vip2#vip.lv,SumRmb),
						   app_msg:send(Socket, BinMsg),
						   scene_api:change_vip(Player2,LvReal2),
						   Player2;
					   ?true ->
						   Vip2= Vip#vip{lv_real=LvReal2,sum_rmb=SumRmb},
						   Player#player{vip=Vip2}
					end
			end
	end;
buy_rmb(Player, SumRmb) when is_record(Player, player) ->
	Vip2= #vip{lv=0,lv_real=0,indate=0,sum_rmb=0},
	buy_rmb(Player#player{vip=Vip2}, SumRmb);
buy_rmb(Vip, SumRmb) when is_record(Vip, vip) ->
	VipLv = buy_rmb_acc(0, SumRmb),
	Vip#vip{lv_real=VipLv,lv=erlang:max(Vip#vip.lv, Vip#vip.lv_real)};
buy_rmb(Vip, SumRmb) ->
	?MSG_ERROR(" buy_rmb(Vip, SumRmb): ~w~n ",[{Vip, SumRmb}]),
	Vip.
	

buy_rmb_acc(VipLv, SumRmb) ->
	case data_vip:get(VipLv + 1) of
		Dvip when is_record(Dvip,d_vip) ->
			if SumRmb >= Dvip#d_vip.vip_up ->
				   VipLv2=VipLv + 1,
				   buy_rmb_acc(VipLv2, SumRmb);
			   ?true ->
				   VipLv
			end;
		_ ->
			VipLv
	end.


%% 检查vip功能权限 
%% VipLv:: (Player#player.vip)#vip.lv
%% Pos  :: #d_vip.energy_max
%%　return: Times :: 查找次数返回Vip功能额外增加的Times; 查询功能 返回 0=未开启 or 1=开启;
check_fun(VipLv, Pos) ->  
	case VipLv of
		0 -> 0;
		N when is_integer(N) ->
			case data_vip:get(N) of 
				DVip when is_record(DVip,d_vip) ->
					erlang:element(Pos, DVip);
				_ -> 0
			end;
		_ -> 0
	end.

%%　刷新Vip
%% vip_api:check_fun(1,#d_vip.energy_max).功能
ref_vip_fun(#player{vip=Vip, lv=Lv, socket=Socket}=Player) ->
	task_daily_api:vip_lvup_cb(Player),
	energy_api:vip_energy_cd(Player),
	BagCeng=check_fun(Vip#vip.lv, #d_vip.bag_max),
	bag_api:bag_max(Socket,BagCeng),
	BinMsg = weagod_api:vip_up(Lv, Vip),
	app_msg:send(Socket, BinMsg),
	Player.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%%　登陆检查
login(#player{vip=Vip}=Player) ->
	if Vip#vip.lv =/= Vip#vip.lv_real ->
		   end_try_cb(Player, ?null); 
	   ?true ->
		   Player
	end.

%% 体验Vip
%% reg:{Player,TryVipLv,TryTime}
%% retrun:NewPlayer
try_vip(#player{vip=Vip,mpid=Mpid}=Player,TryVipLv,TryTime) ->
	if Vip#vip.lv >= TryVipLv ->
		   {?error,?ERROR_VIP_NOW_BIG};
	   ?true ->
		   case TryTime of
			   0 ->
				   ?skip;
			   TryTime when is_integer(TryTime) ->
				   Time=TryTime - util:seconds(),
				   timer:apply_after(Time*1000, ?MODULE, end_try_vip_cb, [Mpid]) 
		   end,
		   Vip2=Vip#vip{indate=TryTime,lv=TryVipLv},
		   PlayerN=Player#player{vip=Vip2},
		   Player2=ref_vip_fun(PlayerN),
		   BinMsg=msg_lv_my(Vip2#vip.lv, Vip2#vip.sum_rmb),
		   {?ok,Player2,BinMsg}
	end.

end_try_vip_cb(MPid)->
	util:pid_send(MPid,?MODULE,end_try_cb, ?null).
		   
end_try_cb(#player{vip=Vip,uid=Uid,socket=Socket,mpid=MPid}=Player,_) ->
	Now = util:seconds(),
	if Now >= Vip#vip.indate ->
		   Vip2		= Vip#vip{indate=0,lv=Vip#vip.lv_real},
		   Player2	= ref_vip_fun(Player#player{vip=Vip2}),
		   logs_api:action_notice(Uid, ?CONST_LOGS_2021, [], []),
		   BinMsg	= msg_lv_my(Vip2#vip.lv_real ,Vip2#vip.sum_rmb),
		   app_msg:send(Socket, BinMsg),
		   Player2;
	   ?true ->
		   timer:apply_after( (Vip#vip.indate- Now)*1000, ?MODULE, end_try_vip_cb, [MPid]),
		   Player
	end.

%% 请求Vip等级
%% reg :	Player#player.vip
%% retrun:	{VipLv, SumRmb} {当前vip等级,已冲值总元宝数} 
request_viplv(Vip) -> 
	?IF(is_record(Vip, vip),
		{erlang:max(Vip#vip.lv, Vip#vip.lv_real),Vip#vip.sum_rmb},
		{0,0}).

%%%%%%%%%%%%%%%%%%%%%%%%%%msgXXXXXX%%%%%%%%%%%%%%%%%
% 请求vip回复 [1311]
msg_lv_my(Lv,VipUp)->
    RsList = app_msg:encode([{?int8u,Lv},
        {?int32,VipUp}]),
    app_msg:msg(?P_ROLE_LV_MY, RsList).

% 玩家VIP等级 [1313]
msg_vip_lv(Uid,VipLv)->
    RsList = app_msg:encode([{?int32u,Uid},{?int8u,VipLv}]),
    app_msg:msg(?P_ROLE_VIP_LV, RsList).

