%% Author: dreamxyp
%% Created: 2012-3-15
%% Description: TODO: Add description to stat_api
-module(stat_api).

%%
%% Include files
%%
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([logs_cost/6,
		 logs_user/14,
		 %%副本相关记录
		 logs_copy/5,
		 logs_hosting/5,
		 
		 %%帮派相关记录
		 logs_clan/5,
		 logs_wang/5,
		 
		 %%
		 logs_douqi/4,
		 logs_skill/6,
		 logs_partner_skill/5,
         logs_arena_rank/4,
		 
		 logs_inn/2,
		 logs_inn_lv/4,
		 
		 logs_magic/6,
		 logs_magic_step/5,
		 logs_sign/2,
		 logs_shoot/5,
		 logs_weagod/5,
		 logs_clan_skill/4,
		 
		 logs_lv/3,
		 logs_gold/6,
		 logs_task/5,
		 logs_treasure/4,
		 logs_vip/4,
		 logs_fun/3,
		 logs_devote/6,
		 logs_exp/6,
		 logs_renown/5,
		 logs_energy/5,
		 logs_rmbbind/7,
		 logs_goods/4, 
		 logs_goods/5, 
		 logs_goods/6,
		 logs_boss/2,
		 logs_rmb/7]).

-export([online/0,
		 gamedata/0,
		 register/0]).

%% 日志统计 - 角色创建日志
%%  Uid  		int  	     玩家Uid
%%  BossId      int       BOSS ID
logs_user(Uid,Uuid,Cid,Sid,Os0,Versions0,Source0,SourceSub0,Uname0,Pro,Sex,Country,RegTime,RegIp)->
	Os			= mysql_api:escape(Os0),
	Versions	= mysql_api:escape(Versions0),
	Source		= mysql_api:escape(Source0),
	SourceSub	= mysql_api:escape(SourceSub0),
	Uname		= mysql_api:escape(Uname0),
	Query  = <<"INSERT INTO `logs_user` (`uid`,`uuid`,`cid`,`sid`,`os`,`versions`,`source`,`source_sub`,`uname`,`pro`,`sex`,`country`,`reg_time`,`reg_ip`) VALUES ('",
			   ?B(Uid),"',  '",?B(Uuid),"',  '",?B(Cid),"',  '",?B(Sid),"',  '",?B(Os),"',  '",?B(Versions),"',  '",?B(Source),"',  '",?B(SourceSub),"',  '",?B(Uname),"',  '",
			   ?B(Pro),"',  '",?B(Sex), "',  '",?B(Country),"',  '",?B(RegTime),"',  '",?B(RegIp),"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 日志统计 - BOSS记录(最后一击)
%%  Uid  		int  	     玩家Uid
%%  BossId      int       BOSS ID
logs_boss(Uid,BossId)->
	Time 		= util:seconds(),
	Query  = <<"INSERT INTO `logs_boss` (`time`, `uid`, `boss_id`) VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(BossId))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 物品
logs_goods(Uid, Type, LogSrc, GoodsList) ->
	case GoodsList of
		[] ->
			?skip;
		_ ->
			case LogSrc of
				[_Func, _Item, <<"">>] ->% have no remark src, skip
					?skip;
				[Func, _Item, Remark] ->
					GoodsList2=[bag_api:goods(YGoods)||YGoods<-GoodsList],
					[logs_goods(Uid,Type,Func,Goods,Remark)||Goods<-GoodsList2]
%% 					Fun = fun(#goods{flag = Flag} = Goods) when Flag#g_flag.logs == ?CONST_TRUE ->
%% 								  logs_goods(Uid,Type,Func,Goods,Remark); 
%% 							 (_) ->
%% 								  ?MSG_ECHO("========bu xuyao cun  riz zhi",[]),
%% 								  ?skip
%% 						  end,
%% 					lists:foreach(Fun, GoodsList)
			end
	end.

%% 日志统计 - 物品
%%  Uid  	int  	  玩家Uid
%%  Type 	list|atom 类型 状态 ?CONST_FALSE 扣除  ?CONST_TRUE 获得
%%  Module 	list|atom 类型 模块名 mod_xxx 的 xxx (如模块mod_clan 这里就传clan)
%%  Method  list|atom 子类型(如打造 里的 每个子类)
%%  Goods   #goods{}  物品
%%  Remark  list|atom 描述 默认为空[]
logs_goods(Uid,Type,Method,Goods,Remark) when is_record(Goods, goods) ->
	Give		= bag_api:goods_to_give(Goods),
	if
		is_record(Goods#goods.flag, g_flag) ->
			IsLog		= (Goods#goods.flag)#g_flag.logs,
			logs_goods(IsLog,Uid,Type,Method,Give,Remark);
		?true ->
			?ok
	end.
logs_goods(?CONST_TRUE,Uid,Type,Method,Give,Remark) when is_record(Give, give) ->
	Time 		= util:seconds(),
	Method2  	= mysql_api:escape(Method),
	Remark2  	= mysql_api:escape(Remark),
	Query  = <<"INSERT INTO `logs_goods` (`time`, `type`, `uid`, `method`,",
			   " `goods_id`, `goods_count`, `goods_streng`, `goods_bind`, `goods_name_color`,",
			   " `goods_expiry_type`, `goods_expiry`, `remark`) VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Type))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Method2))/binary,"',  '",
			   (util:to_binary(Give#give.goods_id))/binary,"',  '",
			   (util:to_binary(Give#give.count))/binary,"',  '",
			   (util:to_binary(Give#give.streng))/binary,"',  '",
			   (util:to_binary(Give#give.bind))/binary,"',  '",
			   (util:to_binary(Give#give.name_color))/binary,"',  '",
			   (util:to_binary(Give#give.expiry_type))/binary,"',  '",
			   (util:to_binary(Give#give.expiry))/binary,"',  '",
			   (util:to_binary(Remark2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok;
logs_goods(_CONST_FALSE,_Uid,_Type,_Method,_Give,_Remark) -> ?ok.


%% 日志统计 - 任务
%%  Sid  	int  	     服务器SId
%%  Uid  	int  	     玩家Uid
%%  TaskId  int  	     任务ID
%%	TaskType int			 主线|日常
%%	TimeAccept int		 接受时间
%%  State  	int  	     状态  ?CONST_FALSE 接受  ?CONST_TRUE 完成
logs_task(Uid,TaskId,TaskType,TimeAccept,State)->
	TaskId2 = TaskId div 10,
	Time = util:seconds(),
	Query  = <<"REPLACE INTO `logs_task` (`uid` ,`task_id` ,`task_type`,`time_accept`,`time_finish` ,`state`)VALUES ('",
			   (util:to_binary(Uid))/binary,"',  '",  
			   (util:to_binary(TaskId2))/binary,"',  '",
			   (util:to_binary(TaskType))/binary,"',  '",
			   (util:to_binary(TimeAccept))/binary,"',  '",
			   (util:to_binary(Time))/binary,"',  '", 
			   (util:to_binary(State))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 珍宝阁
%%  Uid  	int  	     玩家Uid
%%  UpCen  	int  	     上一层
%%  Cen  	int  	     当前层
logs_treasure(Uid,UpCen,Cen,GoodsId)->
	Time = util:seconds(),
	Query  = <<"REPLACE INTO `logs_treasure` (`time`,`uid` ,`cen_up` ,`goods_id`,`cen`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",  
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(UpCen))/binary,"',  '",
			   (util:to_binary(GoodsId))/binary,"','",
			   (util:to_binary(Cen))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - Vip
%%  Uid  	int  	     玩家Uid
%%  UpLv  	int  	     上一级
%%  VipLv  	int  	     当前级
%%  RealVip int  	     真实VIP
logs_vip(Uid,UpLv,VipLv,RealVip)->
	Time        = util:seconds(),
	Query  = <<"REPLACE INTO `logs_vip` (`time`,`uid` ,`lv_up` ,`real_vip`,`lv`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",  
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(UpLv))/binary,"',  '",
			   (util:to_binary(RealVip))/binary,"','",
			   (util:to_binary(VipLv))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.
 
%% 日志统计 - 神器
%%  Uid  		int  	     玩家Uid
%%  MagicId  	int  	     神器ID
%%  PstrenLv  	int  	     强化前等级
%%  StrenLv		int			 强化后等级
%%  State		int			 ?CONST_TRUE成功 ?CONST_FALSE失败
%%  IsGoods		int			 ?CONST_TRUE使用道具 ?CONST_FALSE未使用道具
logs_magic(Uid,MagicId,PstrenLv,StrenLv,State,IsGoods)->
	Time = util:seconds(),
	Query  = <<"REPLACE INTO `logs_magic` (`time`,`uid`,`magic_id` ,`strenlv_up` ,`strenlv`,`state`,`goods`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",  
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(MagicId))/binary,"',  '",
			   (util:to_binary(PstrenLv))/binary,"',  '",
			   (util:to_binary(StrenLv))/binary,"',  '",
			   (util:to_binary(State))/binary,"',  '", 
			   (util:to_binary(IsGoods))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 神器等阶
%%  Uid  		int  	     玩家Uid
%%  PMagicId  	int  	     进阶前神器
%%  MagicId  	int  	     进阶后神器
%%  PStepLv		int			 进阶前神器等级
%%  StepLv		int			 进阶后神器等级
logs_magic_step(Uid,PMagicId,MagicId,PStepLv,StepLv)->
	Time = util:seconds(),
	Query  = <<"REPLACE INTO `logs_magic_step` (`time`,`uid`,`p_magic_id` ,`magic_id` ,`p_steplv`,`steplv`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",  
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(PMagicId))/binary,"',  '",
			   (util:to_binary(MagicId))/binary,"',  '",
			   (util:to_binary(PStepLv))/binary,"',  '",
			   (util:to_binary(StepLv))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 副本通关记录
%%  Uid  		int  	     玩家Uid
%%  CopyId  		int  	     副本ID
%%  CopyTime  	int  	     进入副本时间
%%  State		int 			 状态 ?CONST_FALSE 进入  ?CONST_TRUE 完成
logs_copy(Uid,CopyId,CopyTime,State,Type)->
	?MSG_ECHO("-------------------~w~n",[{Uid,CopyId,CopyTime,State,Type}]),
	Time = util:seconds(),
	Query  = <<"REPLACE INTO `logs_copy` (`uid` ,`copy_id` ,`time_add` ,`time_finish`,`state`,`type`) VALUES ('",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(CopyId))/binary,"',  '", 
			   (util:to_binary(CopyTime))/binary,"',  '", 
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(State))/binary,"',  '",
			   (util:to_binary(Type))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 副本挂机
%%  Uid  		int  	     玩家Uid
%%  CopyId  		int  	     副本ID
%% 	Count 		int			 副本挂机次数
%%  CopyTime  	int  	     开始挂机时间
%%  State		int 			 状态 ?CONST_FALSE 停止  ?CONST_TRUE 开始
logs_hosting(Uid,CopyId,Count,CopyTime,State)->
	Time = util:seconds(),
	Query  = <<"REPLACE INTO `logs_hosting` (`uid` ,`copy_id` ,`count`,`time_begin` ,`state`,`time_end`)VALUES ('",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(CopyId))/binary,"',  '", 
			   (util:to_binary(Count))/binary,"',  '", 
			   (util:to_binary(CopyTime))/binary,"',  '", 
			   (util:to_binary(State))/binary,"',  '", 
			   (util:to_binary(Time))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.



%% 日志统计 - 功能统计
%%  Uid  	int  	     玩家Uid
%%  FunTag  int  	     功能标识
%%  SubTag  int  	     子标识
logs_fun(Uid,Fun,FunSub)->
	Time 		= util:seconds(),
	Fun2  		= mysql_api:escape(Fun),
	FunSub2  	= mysql_api:escape(FunSub),
	Query  = <<"INSERT INTO `logs_funs` (`uid` ,`funs_id` ,`sub_id`,`time`)VALUES ('",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Fun2))/binary,"',  '",
			   (util:to_binary(FunSub2))/binary,"',  '",
			   (util:to_binary(Time))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 日志统计 - 升级
%%  Sid  	int  	     服务器SId
%%  Uid  	int  	     玩家Uid
%%  LastLv  int		     从 LastLv 升级到 TargetLv
logs_lv(_Uid,LastLv,TargetLv) when LastLv >= TargetLv -> ?ok; %% 等级一样   或小于
logs_lv( Uid,LastLv,TargetLv)->
	Time 		= util:seconds(),
	Query  = <<"INSERT INTO `logs_lv` (`uid` ,`last_lv` ,`target_lv`,`time`)VALUES ('",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(LastLv))/binary,"',  '",
			   (util:to_binary(TargetLv))/binary,"',  '",
			   (util:to_binary(Time))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.





%% 日志统计 - 金币
%%  Uid  	int  	  玩家Uid
%%  Type 	list|atom 类型 模块名 mod_xxx 的 xxx (如模块mod_clan 这里就传clan)
%%  TypeSub list|atom 子类型(如打造 里的 每个子类)
%%  Amount  int       金额  消费为负数  生产 为正数
%%  Balance int       余额
%%  Remark  list|atom 描述 默认为空[]
logs_gold(Uid,Lv,TypeSub,Amount,Balance,Remark)->
	Time = util:seconds(),
	TypeSub2  	= mysql_api:escape(TypeSub), 
	Remark2  	= mysql_api:escape(Remark),
	Query  = <<"INSERT INTO `logs_gold` (`time` ,`uid` ,`lv`,`method`,`amount`,`balance`,`remark`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Lv))/binary,"',  '",
			   (util:to_binary(TypeSub2))/binary,"',  '",
			   (util:to_binary(Amount))/binary,"',  '",
			   (util:to_binary(Balance))/binary,"',  '",
			   (util:to_binary(Remark2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query), 
	?ok.


%% 日志统计 - 社团贡献记录(日志)
%%  Cid  	int  	  帮派ID
%%  Uid  	int  	  玩家Uid
%%  Module 	list|atom 类型 模块名 mod_xxx 的 xxx (如模块mod_clan 这里就传clan)
%%  Method  list|atom 子类型(如打造 里的 每个子类)
%%  Amount  int       帮贡  消费为负数  生产 为正数
%%  Balance int       剩余帮贡
%%  Remark  list|atom 描述 默认为空[]
logs_devote(Uid,Cid,Method,Amount,Balance,Remark)->
	Time 		= util:seconds(),
	Method2  	= mysql_api:escape(Method),
	Remark2  	= mysql_api:escape(Remark),
	Query  = <<"INSERT INTO `logs_devote` (`time`, `clan_id`, `uid`, `method`, `amount`, `balance`, `remark`) VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Cid))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Method2))/binary,"',  '",
			   (util:to_binary(Amount))/binary,"',  '",
			   (util:to_binary(Balance))/binary,"',  '",
			   (util:to_binary(Remark2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 日志统计 - 社团技能(日志)
%%  Cid  	int  	  帮派ID
%%  Uid  	int  	  玩家Uid
%%  Method  list|atom 子类型(如打造 里的 每个子类)
%%  Type  int         学习方式
%%  Remark  list|atom 描述 默认为空[]
logs_clan_skill(Uid, Cid, Method, Type) ->
  	Time 		= util:seconds(),
	Method2  	= mysql_api:escape(Method),
	Query  = <<"INSERT INTO `logs_clan_skill` (`time`, `clan_id`, `uid`, `method`,  `type`) VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Cid))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Method2))/binary,"',  '",
			   (util:to_binary(Type))/binary, "');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

  
%% 日志统计 - 社团加入退出记录(日志)
%%  Cid  	 int  	  帮派ID
%%  Uid  	 int  	  玩家Uid
%%  ClanName string	  帮派名字
%%  Module 	 list|atom 类型 模块名 mod_xxx 的 xxx (如模块mod_clan 这里就传clan)
%%  Method   list|atom 子类型(如打造 里的 每个子类)
%%  State    int 		  描述 ?CONST_TRUE(加入) ?CONST_FALSE(退出)
logs_clan(Uid,Cid,ClanName,State,Method)->
	Time 		= util:seconds(),
	Method2  	= mysql_api:escape(Method),
	Query       = <<"INSERT INTO `logs_clan` (`time`, `cid`, `uid`, `clan_name`, `method`, `state`) VALUES ('",
					(util:to_binary(Time))/binary,"',  '",
					(util:to_binary(Cid))/binary,"',  '",
					(util:to_binary(Uid))/binary,"',  '",
					(util:to_binary(ClanName))/binary,"',  '",
					(util:to_binary(State))/binary,"',  '",
					(util:to_binary(Method2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 社团更换社长记录(日志)
%%  Cid  	 int  	  帮派ID
%%  Uid  	 int  	  前任社长Uid
%%  WangUid  int      现任社长Uid
%%  ClanName string	  帮派名字
%%  Module 	 list|atom 类型 模块名 mod_xxx 的 xxx (如模块mod_clan 这里就传clan)
%%  Method   list|atom 子类型(如打造 里的 每个子类)
logs_wang(Cid,ClanName,Uid,WangUid,Method)->
	Time 		= util:seconds(),
	Method2  	= mysql_api:escape(Method),
	Query       = <<"INSERT INTO `logs_wang` (`time`, `cid`, `clan_name`,`uid`,`wang_uid`, `method`) VALUES ('",
					(util:to_binary(Time))/binary,"',  '",
					(util:to_binary(Cid))/binary,"',  '",
					(util:to_binary(ClanName))/binary,"',  '",
					(util:to_binary(Uid))/binary,"',  '",
					(util:to_binary(WangUid))/binary,"',  '",
					(util:to_binary(Method2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 斗气获得/吞噬记录(日志)
%%  Uid  	 int  	  玩家Uid
%%  DouQiId  int      斗气Id
%%  State	 int		 ?CONST_TRUE 获得斗气 ?CONST_FALSE 吞噬斗气
logs_douqi(Uid,DouQiId,DouQiType,State)->
	Time 		= util:seconds(),
	Query       = <<"INSERT INTO `logs_douqi` (`time`,`uid`,`state`,`douqi_id`,`douqi_type`) VALUES ('",
					(util:to_binary(Time))/binary,	"',  '",
					(util:to_binary(Uid))/binary,	"',  '",
					(util:to_binary(State))/binary,	"',  '",
					(util:to_binary(DouQiId))/binary,	"',  '",
					(util:to_binary(DouQiType))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 技能升级记录(日志)
%% Uid		int		玩家UID
%% SkillId	int		技能ID
%% PLv		int		升级前等级
%% Lv		int		升级后等级
logs_skill(Uid,SkillId,PLv,Lv,Gold,Power)->
	Time 		= util:seconds(),
	?MSG_ECHO("=============~w~n",[{Uid,SkillId,PLv,Lv,Gold,Power}]),
	Query       = <<"INSERT INTO `logs_skill` (`time`,`uid`,`skill_id`,`lv_up`,`lv`,`gold`,`power`) VALUES ('",
					(util:to_binary(Time))/binary,	"',  '",
					(util:to_binary(Uid))/binary,	"',  '",
					(util:to_binary(SkillId))/binary,	"',  '",
					(util:to_binary(PLv))/binary,	"',  '",
					(util:to_binary(Lv))/binary,	"',  '",
					(util:to_binary(Gold))/binary,	"',  '",
					(util:to_binary(Power))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 日志统计 - 技能升级记录(日志)
%% Uid		int		玩家UID
%% partner	int		玩家UID
%% SkillId	int		技能ID
%% PLv		int		升级前等级
%% Lv		int		升级后等级
logs_partner_skill(Uid,PartnerId,SkillId,PLv,Lv)->
	Time 		= util:seconds(),
	?MSG_ECHO("===============~w~n",[{Uid,PartnerId,SkillId,PLv,Lv}]),
	Query       = <<"INSERT INTO `logs_partner_skill` (`time`,`uid`,`partner_id`,`skill_id`,`lv_up`,`lv`) VALUES ('",
					(util:to_binary(Time))/binary,	"',  '",
					(util:to_binary(Uid))/binary,	"',  '",
					(util:to_binary(PartnerId))/binary,	"',  '",
					(util:to_binary(SkillId))/binary,	"',  '",
					(util:to_binary(PLv))/binary,	"',  '",
					(util:to_binary(Lv))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 逐鹿台挑战记录(日志)
%% Uid		int		玩家UID
%% PRank		int		挑战前排名
%% Rank		int		挑战后排名
%% SCount	int		剩余次数
logs_arena_rank(Uid,PRank,Rank,SCount)->
	Time 		= util:seconds(),
	Query       = <<"INSERT INTO `logs_arena_rank` (`time`,`uid`,`rank_up`,`rank`,`count`) VALUES ('",
					(util:to_binary(Time))/binary,	"',  '",
					(util:to_binary(Uid))/binary,	"',  '",
					(util:to_binary(PRank))/binary,	"',  '",
					(util:to_binary(Rank))/binary,	"',  '",
					(util:to_binary(SCount))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 酒吧记录(日志)
%% Uid		int		玩家UID
%% Partner	int		伙伴ID
logs_inn(Uid,Partner)->
	Time 		= util:seconds(),
	Query       = <<"INSERT INTO `logs_inn` (`time`,`uid`,`partner`) VALUES ('",
					(util:to_binary(Time))/binary,	"',  '",
					(util:to_binary(Uid))/binary,	"',  '",
					(util:to_binary(Partner))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 伙伴升级记录(日志)
%% Uid		int		玩家UID
%% Partner	int		伙伴ID
%% PLv		int		伙伴升级前等级
%% Lv		int		伙伴升级后等级
logs_inn_lv(Uid,Partner,PLv,Lv)->
	Time 		= util:seconds(),
	Query       = <<"INSERT INTO `logs_inn_lv` (`time`,`uid`,`partner`,`lv_up`,`lv`) VALUES ('",
					(util:to_binary(Time))/binary,	"',  '",
					(util:to_binary(Uid))/binary,	"',  '",
					(util:to_binary(Partner))/binary,	"',  '",
					(util:to_binary(PLv))/binary,	"',  '",
					(util:to_binary(Lv))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 体力记录(日志)
%%  Uid  	int  	  玩家Uid
%%  Module 	list|atom 类型 模块名 mod_xxx 的 xxx (如模块mod_clan 这里就传clan)
%%  Method  list|atom 子类型(如打造 里的 每个子类)
%%  Amount  int       精力  消费为负数  生产 为正数
%%  Balance int       剩余精力
%%  Remark  list|atom 描述 默认为空[]
logs_energy(Uid,Method,Amount,Balance,Remark)->
	Time 		= util:seconds(),
	Method2  	= mysql_api:escape(Method),
	Remark2  	= mysql_api:escape(Remark),
	Query  = <<"INSERT INTO `logs_energy` (`time`, `uid`, `method`, `amount`, `balance`, `remark`) VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Method2))/binary,"',  '",
			   (util:to_binary(Amount))/binary,"',  '",
			   (util:to_binary(Balance))/binary,"',  '",
			   (util:to_binary(Remark2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 日志统计 - 经验记录(日志)
%%  Uid  	int  	     玩家Uid
%%  Module 	list|atom 类型 模块名 mod_xxx 的 xxx (如模块mod_clan 这里就传clan)
%%  Method  list|atom 子类型(如打造 里的 每个子类)
%%  Amount  int       经验  消费为负数  生产 为正数
%%  Balance int       经验总数
%%  Remark  list|atom 描述 默认为空[]
logs_exp(Uid,RoleLv,Method,Amount,Balance,Remark)->
	Time 		= util:seconds(),
	Method2  	= mysql_api:escape(Method),
	Remark2  	= mysql_api:escape(Remark),
	Query  = <<"INSERT INTO `logs_exp` (`time`, `uid`,`role_lv`, `method`, `amount`, `balance`, `remark`) VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(RoleLv))/binary,"',  '",
			   (util:to_binary(Method2))/binary,"',  '",
			   (util:to_binary(Amount))/binary,"',  '",
			   (util:to_binary(Balance))/binary,"',  '",
			   (util:to_binary(Remark2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% 日志统计 - 声望记录(日志)
%%  Uid  	int  	     玩家Uid
%%  Module 	list|atom 类型 模块名 mod_xxx 的 xxx (如模块mod_clan 这里就传clan)
%%  Method  list|atom 子类型(如打造 里的 每个子类)
%%  Amount  int       声望  消费为负数  生产 为正数
%%  Balance int       剩余声望
%%  Remark  list|atom 描述 默认为空[]
logs_renown(Uid,Method,Amount,Balance,Remark)->
	Time 		= util:seconds(),
	Method2  	= mysql_api:escape(Method),
	Remark2  	= mysql_api:escape(Remark),
	Query  = <<"INSERT INTO `logs_renown` (`time`, `uid`, `method`, `amount`, `balance`, `remark`) VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Method2))/binary,"',  '",
			   (util:to_binary(Amount))/binary,"',  '",
			   (util:to_binary(Balance))/binary,"',  '",
			   (util:to_binary(Remark2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 日志统计 - 绑定钻石
%%  Uid  	int  	     玩家Uid
%%  Type 	list|atom 类型 模块名 mod_xxx 的 xxx 如:模块mod_clan 这里就传clan
%%  TypeSub list|atom 子类型(如打造 里的 每个子类)
%%  Item 	list|atom 具体项目 如:商城可以为 goods_id
%%  Amount  int       金额  消费为负数  生产 为正数
%%  Balance int       余额
%%  Remark  list|atom 描述 默认为空[]  如:商城可以为购买数量等描述
logs_rmbbind(Uid,Lv,TypeSub,Item,Amount,Balance,Remark)->
	Time 		= util:seconds(),
	TypeSub2  	= mysql_api:escape(TypeSub),
	Item2  		= mysql_api:escape(Item),
	Remark2  	= mysql_api:escape(Remark),
	Query  = <<"INSERT INTO `logs_rmbbind` (`time` ,`uid` ,`lv`,`method`,`item`,`amount`,`balance`,`remark`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Lv))/binary,"',  '",
			   (util:to_binary(TypeSub2))/binary,"',  '",
			   (util:to_binary(Item2))/binary,"',  '",
			   (util:to_binary(Amount))/binary,"',  '",
			   (util:to_binary(Balance))/binary,"',  '",
			   (util:to_binary(Remark2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 日志统计 - 钻石 
%%  Uid  	int  	     玩家Uid
%%  Type 	list|atom 类型 模块名 mod_xxx 的 xxx 如:模块mod_clan 这里就传clan
%%  TypeSub list|atom 子类型(如打造 里的 每个子类)
%%  Item 	list|atom 具体项目 如:商城可以为 goods_id
%%  Amount  int       金额  消费为负数  生产 为正数
%%  Balance int       余额
%%  Remark  list|atom 描述 默认为空[]  如:商城可以为购买数量等描述
logs_rmb(Uid,Lv,TypeSub,Item,Amount,Balance,Remark)->
	Time   		= util:seconds(),
	TypeSub2  	= mysql_api:escape(TypeSub),
	Item2  		= mysql_api:escape(Item),
	Remark2  	= mysql_api:escape(Remark),
	Query  = <<"INSERT INTO `logs_rmb` (`time` ,`uid` ,`lv`,`method`,`item`,`amount`,`balance`,`remark`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Lv))/binary,"',  '",
			   (util:to_binary(TypeSub2))/binary,"',  '",
			   (util:to_binary(Item2))/binary,"',  '",
			   (util:to_binary(Amount))/binary,"',  '",
			   (util:to_binary(Balance))/binary,"',  '",
			   (util:to_binary(Remark2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 日志统计 - 积分 
%%  Uid  	int  	     玩家Uid
%%  Type 	list|atom 类型 模块名 mod_xxx 的 xxx 如:模块mod_clan 这里就传clan
%%  TypeSub list|atom 子类型(如打造 里的 每个子类)
%%  Item 	list|atom 具体项目 如:商城可以为 goods_id
%%  Amount  int       金额  消费为负数  生产 为正数
%%  Balance int       余额
%%  Remark  list|atom 描述 默认为空[]  如:商城可以为购买数量等描述
logs_integral(Uid,Lv,TypeSub,Item,Amount,Balance,Remark)->
	Time   		= util:seconds(),
	TypeSub2  	= mysql_api:escape(TypeSub),
	Item2  		= mysql_api:escape(Item),
	Remark2  	= mysql_api:escape(Remark),
	Query  = <<"INSERT INTO `logs_integral` (`time` ,`uid` ,`lv`,`method`,`item`,`amount`,`balance`,`remark`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Lv))/binary,"',  '",
			   (util:to_binary(TypeSub2))/binary,"',  '",
			   (util:to_binary(Item2))/binary,"',  '",
			   (util:to_binary(Amount))/binary,"',  '",
			   (util:to_binary(Balance))/binary,"',  '",
			   (util:to_binary(Remark2))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 统计货币消费
logs_cost(Uid,Lv, Type, Amount, Balance, [Line, Item, Remark]) ->
	case Type of
		?CONST_CURRENCY_GOLD -> 
			logs_gold(Uid,Lv,Line,Amount,Balance,Remark); 
		?CONST_CURRENCY_RMB_BIND ->
			logs_rmbbind(Uid,Lv,Line,Item,Amount,Balance,Remark);
		?CONST_CURRENCY_RMB ->
			logs_rmb(Uid,Lv,Line,Item,Amount,Balance,Remark);
		?CONST_CURRENCY_PAY_POINT ->
			logs_integral(Uid,Lv,Line,Item,Amount,Balance,Remark);
		_ ->
			?skip
	end;
logs_cost( _Uid,_Lv,_Type, _Amount, _Balance, _) ->
	?ok.

%% 招财日志（当次招财获得美刀、剩余招财次数、时间）
%% 日志统计 - 招财
%%  Uid  	int  	  玩家Uid
%%  Type  	int  	  招财类型（1：单次招财；2：批量招财；3：自动招财）
%%  Money   int       招财获得的美刀数
%%  Rmb     int       招财花费的钻石数
%%  Times   int       剩余招财次数
logs_weagod(Uid,Type, Money, Rmb, Times) ->
	Time 		= util:seconds(),
	?MSG_ECHO("-------------------~w~n",[{Time,Uid,Type, Money, Rmb, Times}]),
	Query  = <<"INSERT INTO `logs_weagod` (`time` ,`uid` ,`type` ,`money` ,`rmb` ,`times`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Type))/binary,"',  '",
			   (util:to_binary(Money))/binary,"',  '",
			   (util:to_binary(Rmb))/binary,"',  '",
			   (util:to_binary(Times))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 日志统计 - 连续签到天数
%%  Uid  	int  	  玩家Uid
%%  Num     int       连续签到的天数
logs_sign(Uid,Num) ->
	Time   		= util:seconds(),
	Query  = <<"INSERT INTO `logs_sign` (`time` ,`uid` ,`num`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Num))/binary,"');">>,
	mysql_api:fetch_cast_logs(Query),
	?ok.

%% logs_sign_rewards(_Uid,_Rewards) ->
%% 	
%% 	?ok.

%% 日志统计 - 射箭
%%  Uid  	int  	  玩家Uid
%%  Pftime  int       射箭之前剩余免费次数
%%  Ftime   int       剩余免费次数
%%  Pptime  int       射箭之前剩余付费次数
%%  Ptime   int       剩余付费次数     
logs_shoot(Uid,Pftime,Ftime,Pptime,Ptime) ->
	Time 		= util:seconds(),
	Query  = <<"INSERT INTO `logs_shoot` (`time` ,`uid` ,`pftime` ,`ftime` ,`pptime` ,`ptime`)VALUES ('",
			   (util:to_binary(Time))/binary,"',  '",
			   (util:to_binary(Uid))/binary,"',  '",
			   (util:to_binary(Pftime))/binary,"',  '",
			   (util:to_binary(Ftime))/binary,"',  '",
			   (util:to_binary(Pptime))/binary,"',  '",
			   (util:to_binary(Ptime))/binary,"');">>,
	?MSG_ECHO("------------------~w~n",[Query]),
	mysql_api:fetch_cast_logs(Query),
	?ok.


%% 在线人数  每5分钟 统计一次
online()->
	{?ok,Online} = gm_api:online(), 
	YmdHi5   	 = util:date_YmdHi5(),
	Seconds0	 = util:to_binary(util:seconds()- 5* 60),
	Time         = util:to_binary(util:seconds()),
	Sid			 = app_tool:sid(),
 	IpNum		 = mysql_stat( mysql_api:select(<<"SELECT count(DISTINCT login_ip) FROM  `user` where login_last > ",Seconds0/binary>>) ),
	Query  = <<"INSERT INTO `stat_online` (`YmdHi` ,`sid` ,`online_num` ,`ip_num`,`time`)VALUES ('",
				(util:to_binary(YmdHi5))/binary,"',  '",(util:to_binary(Sid))/binary,"',  '",
				(util:to_binary(Online))/binary,"',  '",(util:to_binary(IpNum))/binary,"',  '",(util:to_binary(Time))/binary,"');">>,
%%  ?MSG_ECHO("Query:~p~n",[Query]),
	mysql_api:fetch_cast(Query), 
	?ok.

%% MYSQl 兼容
mysql_stat({?ok,[[null]|_]}) -> util:to_binary(0);
mysql_stat({?ok,[[Cc]|_]}) when is_float(Cc)   -> util:to_binary(round(Cc));
mysql_stat({?ok,[[Cc]|_]}) when is_integer(Cc) -> util:to_binary(Cc);
mysql_stat(Cc) when is_float(Cc)   -> util:to_binary(round(Cc));
mysql_stat(Cc) when is_integer(Cc) -> util:to_binary(Cc);
mysql_stat(_) -> util:to_binary(0).
	
	
	

%% 每小时注册/创建量  每10分钟一次
register() ->
	Ymd			 = util:to_binary(util:date_Ymd()),
	YmdH		 = util:to_binary(util:date_YmdH()), 
	Sid			 = app_tool:sid(),
	Sid0		 = util:to_binary(Sid),
	Cid0		 = util:to_binary(0),
	
	%% 
	TotalAccount = mysql_stat( mysql_api:select(<<"SELECT count(DISTINCT uuid) FROM  `user` ">>) ),
	TotalHero	 = mysql_stat( mysql_api:select(<<"SELECT count(uid)           FROM  `user` ">>) ),
	%% 
	{{Y,M,D},{H,_I,_S}} 	  = util:localtime(),
	BeginTime0 				  = util:datetime2timestamp(Y, M, D, H, 0, 0),
	BeginTime				  = util:to_binary(BeginTime0),
	%% 
	OldAccount	 = mysql_stat( mysql_api:select(<<"SELECT count(DISTINCT uuid) FROM  `user` where `reg_time` < ",BeginTime/binary>>)  ),
	OldHero		 = mysql_stat( mysql_api:select(<<"SELECT count(uid)           FROM  `user` where `reg_time` < ",BeginTime/binary>>)  ),
	%%
	mysql_stat( mysql_api:select(<<"SELECT count(uid)           FROM  `user` where `os` like ios, `reg_time` < ",BeginTime/binary>>)  ),
 	case mysql_api:select(<<"SELECT MAX(  `online_num` ) , MIN(  `online_num` ) , AVG(  `online_num` )  FROM  `stat_online` WHERE  `YmdHi` >=  '",YmdH/binary,"00' ;">>) of
		{?ok,[[OnLineMax0,OnLineMin0,OnLineAvg0]|_]} ->
			OnLineMax 			  	  = mysql_stat(OnLineMax0),
			OnLineMin 			  	  = mysql_stat(OnLineMin0),
			OnLineAvg 			  	  = mysql_stat(OnLineAvg0);
		_ ->
			OnLineMax				  = <<"0">>,
			OnLineMin				  = <<"0">>,
			OnLineAvg				  = <<"0">>
	end,
	%%
	case mysql_api:select(<<"SELECT count(uid) as cc FROM  `user` group by `country` order by `country` asc;">>) of
		{?ok,[[_Country_00],[Country_10],[Country_20],[Country_30]|_]} ->
			% Country_0 			  	  = util:to_binary(Country_00),
			Country_1 			  	  = util:to_binary(Country_10),
			Country_2 			  	  = util:to_binary(Country_20),
			Country_3 			  	  = util:to_binary(Country_30);
		_ ->
			Country_1				  = <<"0">>,
			Country_2				  = <<"0">>,
			Country_3				  = <<"0">>
	end,	
	Query  = <<"REPLACE INTO `stat_register` (`Ymd`,`YmdH`,`sid`,`cid`,`total_account`,`total_role`,`new_account`,`new_role`,`online_max`,`online_min`,`online_average`,`country_1`,`country_2`,`country_3`)  ",
			   "VALUES  ('",Ymd/binary,"','",YmdH/binary,"','",Sid0/binary,"','",Cid0/binary,"','",TotalAccount/binary,"','",TotalHero/binary,
			   "',(",TotalAccount/binary," - ",OldAccount/binary,"),(",TotalHero/binary," - ",OldHero/binary,"),'",
			   OnLineMax/binary,"','",OnLineMin/binary,"','",OnLineAvg/binary,"','",
			   Country_1/binary,"','",Country_2/binary,"','",Country_3/binary,"') ">>,
%% 	?MSG_ECHO("-~p~n",[Query]),
	mysql_api:fetch_cast(Query),
	?ok.


%% 每天游戏数据汇总  每小时一次
gamedata()->
	{Y,M,D} 	 = util:date(),
	Ymd    		 = util:to_binary(util:date_Ymd()),
	%% 
	BeginTime0   = util:datetime2timestamp(Y, M, D, 0, 0, 0),
	BeginTime	 = util:to_binary(BeginTime0),
	%%
	BeginTime1	 = util:to_binary(BeginTime0 - 86400),
	BeginTime2	 = util:to_binary(BeginTime0 - 86400 * 2 ),
	BeginTime3	 = util:to_binary(BeginTime0 - 86400 * 3 ),
	BeginTime4	 = util:to_binary(BeginTime0 - 86400 * 4 ),
	BeginTime5	 = util:to_binary(BeginTime0 - 86400 * 5 ),
	BeginTime6	 = util:to_binary(BeginTime0 - 86400 * 6 ),
	BeginTime7	 = util:to_binary(BeginTime0 - 86400 * 7 ),
%% 	BeginTime15	 = util:to_binary(BeginTime0 - 86400 * 15 ),
%% 	BeginTime30	 = util:to_binary(BeginTime0 - 86400 * 30 ),
%% 	BeginTime31	 = util:to_binary(BeginTime0 - 86400 * 31 ),
	%% 
	Ymd1		 = util:to_binary(util:date_Ymd(BeginTime1)),
	Ymd2		 = util:to_binary(util:date_Ymd(BeginTime2)),
	Ymd3		 = util:to_binary(util:date_Ymd(BeginTime3)),
	Ymd4		 = util:to_binary(util:date_Ymd(BeginTime4)),
	Ymd5		 = util:to_binary(util:date_Ymd(BeginTime5)),
	Ymd6		 = util:to_binary(util:date_Ymd(BeginTime6)),
	Ymd7		 = util:to_binary(util:date_Ymd(BeginTime7)),
%% 	Ymd15		 = util:to_binary(util:date_Ymd(BeginTime15)),
%% 	Ymd30		 = util:to_binary(util:date_Ymd(BeginTime30)),
%% 	Ymd31		 = util:to_binary(util:date_Ymd(BeginTime31)),
	%%
	SumAccount   = mysql_stat( mysql_api:select(<<"SELECT count(DISTINCT uuid) FROM  `user` ">>) ),
	SumRole      = mysql_stat( mysql_api:select(<<"SELECT count(uid)           FROM  `user` ">>) ),
	
	OldAccount	 = mysql_stat( mysql_api:select(<<"SELECT count(DISTINCT  uuid) FROM  `user` where reg_time < ",BeginTime/binary>>)   ),
	OldRole      = mysql_stat( mysql_api:select(<<"SELECT count(uid)            FROM  `user` where reg_time < ",BeginTime/binary>>)   ),
	
	NewAccount	 = <<" ( ",SumAccount/binary,	" - ",OldAccount/binary," ) ">>,
	NewRole		 = <<" ( ",SumRole/binary,		" - ",OldRole/binary,	" ) ">>,

	SQLAccount	 = <<" SELECT count(DISTINCT  uuid) FROM `user` where `login_last` > ",BeginTime/binary>>,
	SQLRole	 	 = <<" SELECT count(uid) 		   FROM `user` where `login_last` > ",BeginTime/binary>>,
	
	LoginAccount		= mysql_stat( mysql_api:select(SQLAccount)  ),
	LoginRole 	 		= mysql_stat( mysql_api:select(SQLRole)     ),
	
	case mysql_api:select(<<"SELECT MAX(  `online_num` ) , MIN(  `online_num` ) , AVG(  `online_num` )  FROM  `stat_online` WHERE  `YmdHi` > '",Ymd/binary,"0000' ;">>) of
		{?ok,[[OnlineMax0,OnlineMin0,OnlineAvg0]|_]} ->
			OnlineMax 	= mysql_stat(OnlineMax0),
			OnlineMin 	= mysql_stat(OnlineMin0),
			OnlineAvg   = mysql_stat(OnlineAvg0);
		_ ->
			OnlineMax	= <<"0">>,
			OnlineMin   = <<"0">>,
			OnlineAvg	= <<"0">>
	end,
	
	Online_30			= mysql_stat( mysql_api:select_execute_logs(<<" SELECT count(`uid`) from (SELECT uid ,sum(`online`) as cc  FROM `logs_online` where `time` > ",BeginTime/binary,"  group by uid) as `logs_online2` where `cc` >= 1800  ">>)  ),
	Online_30_New		= mysql_stat( mysql_api:select_execute_logs(<<" SELECT count(`uid`) FROM `logs_user` WHERE `reg_time` > ",BeginTime/binary," and `uid` in ( SELECT `uid` from (SELECT uid ,sum(`online`) as cc  FROM `logs_online` where `time` > ",BeginTime/binary,"  group by uid) as `logs_online2` where `cc` >= 1800  )">>)  ),
	

	PayCountTotal		= mysql_stat( mysql_api:select(<<" SELECT count(DISTINCT  uid) FROM `logs_pay` ;">> )  ),
	PayCountOld			= mysql_stat( mysql_api:select(<<" SELECT count(DISTINCT  uid) FROM `logs_pay` where `time` < ",BeginTime/binary>> )  ),
	PayCount			= mysql_stat( mysql_api:select(<<" SELECT count(DISTINCT  uid) FROM `logs_pay` where `time` > ",BeginTime/binary>> )  ),
	PayCountNew			= <<" ( ",PayCountTotal/binary," - ",PayCountOld/binary," ) ">>,
	PayCountReg			= mysql_stat( mysql_api:select(<<" SELECT count(`uid`) FROM `user` WHERE `reg_time` > ",BeginTime/binary," and `uid` in ( SELECT DISTINCT `uid` FROM  `logs_pay` WHERE  `time` > ",BeginTime/binary," ) ">> )  ),
	PayCCDay			= mysql_stat( mysql_api:select(<<" SELECT count(`oid`) FROM `logs_pay` where `time` > ",BeginTime/binary>> )  ),
	PaySumDay			= mysql_stat( mysql_api:select(<<" SELECT sum(`pay`) FROM `logs_pay` where `time` > ",BeginTime/binary>> )  ),
	PayCC				= mysql_stat( mysql_api:select(<<" SELECT count(`oid`) FROM `logs_pay` ">>)  ),
	PaySum				= mysql_stat( mysql_api:select(<<" SELECT sum(`pay`) FROM `logs_pay` ">>)  ),
	if
		PayCount == <<"0">> ->
			Arp			= <<"0">>; 
		?true ->
			Arp			= <<" ( ",PaySumDay/binary," / ",PayCount/binary," ) ">>
	end,
	if
		SumRole == <<"0">> ->
			ArpAvg		= <<"0">>;
		?true ->
			ArpAvg		= <<" ( ",PaySum/binary," / ",SumRole/binary," ) ">>
	end,

	
	Query            = <<"REPLACE INTO `stat_gamedata` ( `Ymd`,     `online_max`,		   `online_min`,		`online_avg`,		
	`pay_count_total`,		  `pay_count`,		 `pay_count_new`,	    `pay_count_reg`,	    `pay_cc_day`,	
	`pay_sum_day`,		 `pay_cc`,		  `pay_sum`,		`arp`,		 `arp_avg`,	
	`online_30`,	      `online_30_new`,		`sum_account`,		  `sum_role`,		 `new_account`,		
	`new_role`,		  `login_account`,		  `login_role`)  ",  "VALUES  (",
	Ymd/binary,","  ,OnlineMax/binary,",",OnlineMin/binary,",",OnlineAvg/binary,",",
	PayCountTotal/binary,",",PayCount/binary,",",PayCountNew/binary,",",PayCountReg/binary,",",PayCCDay/binary,",",
	PaySumDay/binary,",",PayCC/binary,",",PaySum/binary,",",Arp/binary,",",ArpAvg/binary,",",
	Online_30/binary,",",Online_30_New/binary,",",SumAccount/binary,",",SumRole/binary,",",NewAccount/binary,",",
	NewRole/binary,",",LoginAccount/binary,",",LoginRole/binary," ); ">>,
	
%% 	?MSG_ECHO("----~p~n",[Query]),

	Account1			= mysql_stat( mysql_api:select(<<SQLAccount/binary," and reg_time > ",BeginTime1/binary," and reg_time <= ",BeginTime/binary>>)  ),
	Role1				= mysql_stat( mysql_api:select(<<SQLRole/binary,   " and reg_time > ",BeginTime1/binary," and reg_time <= ",BeginTime/binary>>)  ),
	
	Account2			= mysql_stat( mysql_api:select(<<SQLAccount/binary," and reg_time > ",BeginTime2/binary," and reg_time <= ",BeginTime1/binary>>)  ),
	Role2				= mysql_stat( mysql_api:select(<<SQLRole/binary,   " and reg_time > ",BeginTime2/binary," and reg_time <= ",BeginTime1/binary>>)  ),
	
	Account3			= mysql_stat( mysql_api:select(<<SQLAccount/binary," and reg_time > ",BeginTime3/binary," and reg_time <= ",BeginTime2/binary>>)  ),
	Role3				= mysql_stat( mysql_api:select(<<SQLRole/binary,   " and reg_time > ",BeginTime3/binary," and reg_time <= ",BeginTime2/binary>>)  ),
	
	Account4			= mysql_stat( mysql_api:select(<<SQLAccount/binary," and reg_time > ",BeginTime4/binary," and reg_time <= ",BeginTime3/binary>>)  ),
	Role4				= mysql_stat( mysql_api:select(<<SQLRole/binary,   " and reg_time > ",BeginTime4/binary," and reg_time <= ",BeginTime3/binary>>)  ),
	
	Account5			= mysql_stat( mysql_api:select(<<SQLAccount/binary," and reg_time > ",BeginTime5/binary," and reg_time <= ",BeginTime4/binary>>)  ),
	Role5				= mysql_stat( mysql_api:select(<<SQLRole/binary,   " and reg_time > ",BeginTime5/binary," and reg_time <= ",BeginTime4/binary>>)  ),
	
	Account6			= mysql_stat( mysql_api:select(<<SQLAccount/binary," and reg_time > ",BeginTime6/binary," and reg_time <= ",BeginTime5/binary>>)  ),
	Role6				= mysql_stat( mysql_api:select(<<SQLRole/binary,   " and reg_time > ",BeginTime6/binary," and reg_time <= ",BeginTime5/binary>>)  ),
	
	Account7			= mysql_stat( mysql_api:select(<<SQLAccount/binary," and reg_time > ",BeginTime7/binary," and reg_time <= ",BeginTime6/binary>>)  ),
	Role7				= mysql_stat( mysql_api:select(<<SQLRole/binary,   " and reg_time > ",BeginTime7/binary," and reg_time <= ",BeginTime6/binary>>)  ),
	
	Account_3_1			= Account1,
	Role_3_1			= Role1,
	
	Account_3_2			= mysql_stat( mysql_api:select(<<" SELECT count(DISTINCT  uuid) FROM `user` where `login_last` > ",BeginTime1/binary," and reg_time > ",BeginTime2/binary," and reg_time <= ",BeginTime1/binary>>)  ),
	Role_3_2			= mysql_stat( mysql_api:select(<<" SELECT count(uid) 		     FROM `user` where `login_last` > ",BeginTime1/binary," and reg_time > ",BeginTime2/binary," and reg_time <= ",BeginTime1/binary>>)  ),
	
	Account_3_3  		= mysql_stat( mysql_api:select(<<" SELECT count(DISTINCT  uuid) FROM `user` where `login_last` > ",BeginTime2/binary," and reg_time > ",BeginTime3/binary," and reg_time <= ",BeginTime2/binary>>)  ),
	Role_3_3			= mysql_stat( mysql_api:select(<<" SELECT count(uid) 		    FROM `user` where `login_last` > ",BeginTime2/binary," and reg_time > ",BeginTime3/binary," and reg_time <= ",BeginTime2/binary>>)  ),
	
	%% 
	Account_7_1			= Account_3_1,
	Role_7_1			= Role_3_1,
	
	Account_7_2			= Account_3_2,
	Role_7_2			= Role_3_2,
	
	Account_7_3			= Account_3_3,
	Role_7_3			= Role_3_3,
	
	Account_7_4			= mysql_stat( mysql_api:select(<<" SELECT count(DISTINCT  uuid) FROM `user` where `login_last` > ",BeginTime3/binary," and reg_time > ",BeginTime4/binary," and reg_time <= ",BeginTime3/binary>>)  ),
	Role_7_4			= mysql_stat( mysql_api:select(<<" SELECT count(uid) 		     FROM `user` where `login_last` > ",BeginTime3/binary," and reg_time > ",BeginTime4/binary," and reg_time <= ",BeginTime3/binary>>)  ),
	
	Account_7_5			= mysql_stat( mysql_api:select(<<" SELECT count(DISTINCT  uuid) FROM `user` where `login_last` > ",BeginTime4/binary," and reg_time > ",BeginTime5/binary," and reg_time <= ",BeginTime4/binary>>)  ),
	Role_7_5			= mysql_stat( mysql_api:select(<<" SELECT count(uid) 		     FROM `user` where `login_last` > ",BeginTime4/binary," and reg_time > ",BeginTime5/binary," and reg_time <= ",BeginTime4/binary>>)  ),
	
	Account_7_6			= mysql_stat( mysql_api:select(<<" SELECT count(DISTINCT  uuid) FROM `user` where `login_last` > ",BeginTime5/binary," and reg_time > ",BeginTime6/binary," and reg_time <= ",BeginTime5/binary>>)  ),
	Role_7_6			= mysql_stat( mysql_api:select(<<" SELECT count(uid) 		     FROM `user` where `login_last` > ",BeginTime5/binary," and reg_time > ",BeginTime6/binary," and reg_time <= ",BeginTime5/binary>>)  ),
	
	Account_7_7			= mysql_stat( mysql_api:select(<<" SELECT count(DISTINCT  uuid) FROM `user` where `login_last` > ",BeginTime6/binary," and reg_time > ",BeginTime7/binary," and reg_time <= ",BeginTime6/binary>>)  ),
	Role_7_7			= mysql_stat( mysql_api:select(<<" SELECT count(uid) 		     FROM `user` where `login_last` > ",BeginTime6/binary," and reg_time > ",BeginTime7/binary," and reg_time <= ",BeginTime6/binary>>)  ),

	if
		Account1 == <<"0">> andalso Role1  == <<"0">> andalso Account_3_1 == <<"0">> andalso Role_3_1  == <<"0">>  andalso Account_7_1  == <<"0">> andalso Role_7_1 == <<"0">> -> 
			Query1		= <<>>;
		?true ->
			Query1 		= <<"UPDATE `stat_gamedata` SET `account1` =  ",Account1/binary,", role1 = ",Role1/binary,", account_3 = ",Account_3_1/binary,", role_3 = ",Role_3_1/binary,", account_7 = ",Account_7_1/binary,", role_7 = ",Role_7_1/binary," WHERE `Ymd` = ",Ymd1/binary," ;">>
	end,
	if
		Account2 == <<"0">> andalso Role2  == <<"0">> andalso Account_3_2 == <<"0">> andalso Role_3_2  == <<"0">>  andalso Account_7_2  == <<"0">> andalso Role_7_2 == <<"0">> -> 
			Query2		= <<>>;
		?true ->
			Query2 		= <<"UPDATE `stat_gamedata` SET `account2` =  ",Account2/binary,", role2 = ",Role2/binary,", account_3 = ",Account_3_2/binary,", role_3 = ",Role_3_2/binary,", account_7 = ",Account_7_2/binary,", role_7 = ",Role_7_2/binary," WHERE `Ymd` = ",Ymd2/binary," ;">>
	end,
	if
		Account3 == <<"0">> andalso Role3  == <<"0">> andalso Account_3_3 == <<"0">> andalso Role_3_3  == <<"0">>  andalso Account_7_3  == <<"0">> andalso Role_7_3 == <<"0">> -> 
			Query3		= <<>>;
		?true ->
			Query3 		= <<"UPDATE `stat_gamedata` SET `account3` =  ",Account3/binary,", role3 = ",Role3/binary,", account_3 = ",Account_3_3/binary,", role_3 = ",Role_3_3/binary,", account_7 = ",Account_7_3/binary,", role_7 = ",Role_7_3/binary," WHERE `Ymd` = ",Ymd3/binary," ;">>
	end,
	if
		Account4 == <<"0">> andalso Role4  == <<"0">> andalso Account_7_4  == <<"0">> andalso Role_7_4 == <<"0">> -> 
			Query4		= <<>>;
		?true ->
			Query4 		= <<"UPDATE `stat_gamedata` SET `account4` =  ",Account4/binary,", role4 = ",Role4/binary,",account_7 = ",Account_7_4/binary,", role_7 = ",Role_7_4/binary," WHERE `Ymd` = ",Ymd4/binary," ;">>
	end,
	if
		Account5 == <<"0">> andalso Role5  == <<"0">> andalso Account_7_5  == <<"0">> andalso Role_7_5 == <<"0">> -> 
			Query5		= <<>>;
		?true ->
			Query5 		= <<"UPDATE `stat_gamedata` SET `account5` =  ",Account5/binary,", role5 = ",Role5/binary,",account_7 = ",Account_7_5/binary,", role_7 = ",Role_7_5/binary," WHERE `Ymd` = ",Ymd5/binary," ;">>
	end,
	if
		Account6 == <<"0">> andalso Role6  == <<"0">> andalso Account_7_6  == <<"0">> andalso Role_7_6 == <<"0">> -> 
			Query6		= <<>>;
		?true ->
			Query6 		= <<"UPDATE `stat_gamedata` SET `account6` =  ",Account6/binary,", role6 = ",Role6/binary,",account_7 = ",Account_7_6/binary,", role_7 = ",Role_7_6/binary," WHERE `Ymd` = ",Ymd6/binary," ;">>
	end,
	if
		Account7 == <<"0">> andalso Role7  == <<"0">> andalso Account_7_7  == <<"0">> andalso Role_7_7 == <<"0">> -> 
			Query7		= <<>>;
		?true ->
			Query7 		= <<"UPDATE `stat_gamedata` SET `account7` =  ",Account7/binary,", role7 = ",Role7/binary,",account_7 = ",Account_7_7/binary,", role_7 = ",Role_7_7/binary," WHERE `Ymd` = ",Ymd7/binary," ;">>
	end,
	mysql_api:fetch_cast(<<Query/binary,Query1/binary,Query2/binary,Query3/binary,Query4/binary,Query5/binary,Query6/binary,Query7/binary>>),
	?ok.
	
	
	

