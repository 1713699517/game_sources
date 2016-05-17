%% @author dreamxyp
%% @doc @todo Add description to idx_api.


-module(idx_api).

-include("../include/comm.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([
		 init_not_mysql/0,
		 init_use_mysql/0,
		 
		 mail_id/0,
		 team_id/0,
		 clan_id/0,
		 douqi_id/0,
		 goods_mid/0,
		 monster_mid/0,
		 wrestle_id/0
		]).


%% 最开始的初始化(不用MYSQL数据库)
init_not_mysql() ->
	idx:reg(monster,		1), 
	idx:reg(team,			1),
	idx:reg(douqi,		1),
    idx:reg(wrestle, 0),
	?ok.

%% 正常初始化(需要MYSQL服务启动)
init_use_mysql() ->
	Sid=app_tool:sid(),
	idx:reg_mysql(sys_mail,				1, 						mail_id),
	idx:reg_global(goods, 				1, 						?GLOBAL_GOODS_MAX_INDEX),
	idx:reg_mysql_sid(clan_public,		Sid*?CONST_PERCENT+1, 	clan_id),
	?ok.



%% 怪物 自增长ID 
monster_mid()->
	ets:update_counter(?ETS_S_INDEX, monster, 1).

%% 物品 自增长唯一ID
goods_mid() ->
	ets:update_counter(?ETS_S_INDEX, goods, 1).
	
%% 发送邮件的唯一ID
mail_id() ->
	ets:update_counter(?ETS_S_INDEX, sys_mail, 1).

%% 发送邮件的唯一ID
douqi_id() ->
	ets:update_counter(?ETS_S_INDEX, douqi, 1).

%% 队伍唯一ID
team_id() ->
	ets:update_counter(?ETS_S_INDEX, team, 1).

wrestle_id() ->
	ets:update_counter(?ETS_S_INDEX, wrestle, 1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ------------------------------ 合服可能会导致自增长值冲突的idx,需做以下特殊处理 》》》注意：单服最大个数 = 10000
%% clan累加器
%%　retrun: Int || false
clan_id()->
	?IF(chack_idx(clan_public),
		ets:update_counter(?ETS_S_INDEX, clan_public, 1),
		?false).

%% 检查自增长值是否有效
chack_idx(Post) ->
	Sid=app_tool:sid(),
	case ets:lookup(?ETS_S_INDEX, Post) of
		[{Post,Int}|_] when is_integer(Int) ->
			?IF(Int >= (Sid+1)*?CONST_PERCENT, ?false, ?true);
		_ ->
			ets:insert(?ETS_S_INDEX, {Post,Sid*?CONST_PERCENT+1}),
			?true
	end.




