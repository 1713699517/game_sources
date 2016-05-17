%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :Mod Api (gamecore.cn) dreamxyp@gmail.com
%%%
%%% Created : 2012-9-8
%%% -------------------------------------------------------------------
-module(notice_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%% --------------------------------------------------------------------
%% API exports
-export([delete/1,
		 interval/0,
		 update/7,init/0]).


%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化
init() ->
	Notices = init_mysql(),
	ets_save(Notices).

%% 初始化
init_mysql()->
	NowTime = util:seconds(),	
	% ?MSG_ECHO("MYSQL:~p",[" SELECT `id`,`interval`,`begin_time`,`end_time`,`content` FROM  `gchy_cp_notice` where `end_time` > "++util:to_list(NowTime)]),
	case mysql_api:select_execute(" SELECT `id`,`type`,`interval`,`begin_time`,`end_time`,`show_time`,`content` FROM  `cp_notice` where `end_time` > "++util:to_list(NowTime) ) of
		{?ok, List} ->
			% ?MSG_ECHO("List:~p",[List]),
			util:map(fun([NoticeId,MsgType,Interval,BeginTime,EndTime,ShowTime,Content])-> 
							  record_notice(NoticeId,MsgType,Interval*60,BeginTime,EndTime,ShowTime,Content)  
					  end, List); 
		_ ->
			[]
	end.


% 心跳
interval()->
	Notices = ets_read(),
	interval(Notices).
interval(Notice)->
	% ?MSG_ECHO("Notice:~p",[Notice]), 
	NowTime = util:seconds(),
	% MsgType = 0, % 类型 默认为0
	interval(Notice,[],<<>>,NowTime).
interval([],NoticeRs,BinMsg,_NowTime) -> 	
	% ?MSG_ECHO("~p",[BinMsg]),
	chat_api:send_to_all(BinMsg), %% 全服公告
	ets_save(NoticeRs);
	% NoticeRs;
interval([NoticeData|Notice],NoticeRs,BinMsg,NowTime) -> 
	% ?MSG_ECHO("NowTime:~p-NoticeData#notice.touch:~p > NoticeData#notice.interval:~p - 10",[NowTime,NoticeData#notice.touch ,NoticeData#notice.interval]),
	if
		NoticeData#notice.begin_time =< NowTime 
		  andalso NoticeData#notice.end_time >= NowTime
		  andalso NowTime-NoticeData#notice.touch > NoticeData#notice.interval - 10 ->
			BinMsg2     = system_api:msg_notice(NoticeData#notice.show_time, NoticeData#notice.type, NoticeData#notice.content),
			BinMsg3     = <<BinMsg2/binary,BinMsg/binary>>,
			NoticeData2 = NoticeData#notice{touch=NowTime},
			interval(Notice,[NoticeData2|NoticeRs],BinMsg3,NowTime);
		NoticeData#notice.end_time < NowTime ->
			interval(Notice,NoticeRs,BinMsg,NowTime);
		?true ->
			interval(Notice,[NoticeData|NoticeRs],BinMsg,NowTime)
	end.


% 发布/更新
update(NoticeId,MsgType,Interval,BeginTime,EndTime,ShowTime,Content)->
	NoticeData = record_notice(NoticeId,MsgType,Interval, BeginTime, EndTime,ShowTime, Content),
	Notices	   = ets_read(),
	Notices2   = update(Notices, NoticeData, []),
	interval(Notices2).
% 发布/更新
update([],NoticeData,NoticeRs)-> 
	[NoticeData|NoticeRs];
update([NoticeData2|Notice],NoticeData,NoticeRs) when NoticeData2#notice.id == NoticeData#notice.id ->
	NoticeRs2 = NoticeRs++Notice,
	[NoticeData|NoticeRs2];
update([NoticeData2|Notice],NoticeData,NoticeRs) ->
	NoticeRs2 = [NoticeData2|NoticeRs],
	update(Notice,NoticeData,NoticeRs2).


record_notice(NoticeId,MsgType,Interval,BeginTime,EndTime,ShowTime,Content)->
	Content2 = util:to_binary(Content),
	#notice{
			 id			= NoticeId, 	% 公告ID
			 type		= MsgType,		% 显示区域  见常量：CONST_BROAD_AREA_＊
			 touch		= 0, 			% 上次触发时间
			 interval	= Interval, 	% 推送公告间隔时间(秒)
			 begin_time	= BeginTime, 	% 开始时间
			 end_time	= EndTime, 		% 结束时间
			 show_time	= ShowTime,		% 显示时长
			 content	= Content2  	% 内容
			}.

% 删除
delete(DelNoticeId)->
	ets_delete(DelNoticeId),
	% Notice3    = notice_mod:delete(Notice,DelNoticeId,[]),
	?ok.


ets_read()->
	ets:tab2list(?ETS_M_NOTICE).

ets_save(Notices)->
	ets:delete_all_objects(?ETS_M_NOTICE),
	ets:insert(?ETS_M_NOTICE,Notices).

ets_delete(DelNoticeId)->
	ets:delete(?ETS_M_NOTICE,DelNoticeId).
	
	
	