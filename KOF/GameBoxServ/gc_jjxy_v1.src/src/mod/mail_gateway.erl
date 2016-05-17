%% Author: acer
%% Created: 2012-11-14
%% Description: TODO: Add description to mail_gateway.
-module(mail_gateway).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
%%
%% Exported Functions
%%
-export([gateway/3]).

%%
%% API Functions
%%
%T 请求邮件列表
gateway(?P_MAIL_REQUEST, Player, Bin) ->
	{Type} = app_msg:decode({?int8u},Bin),
	mail_api:get_mails(Player,Type),
	{?ok,Player};

%% 发送邮件
gateway(?P_MAIL_SEND, Player, Bin) ->
	{RecvUid,RecvName,Title,Content} = app_msg:decode({?int32u,?string,?string,?stringl},Bin),
	case mail_api:send(Player, {RecvUid,RecvName,Title,Content}) of
		{?ok,BinMsg} ->
			app_msg:send(Player#player.socket, BinMsg);
		{?error,ErrorCode} ->
			ErrMsg=system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, ErrMsg)
	end,	
	{?ok,Player};

%% 读取邮件
gateway(?P_MAIL_READ, Player, Bin) ->
	{MailId} = app_msg:decode({?int32u},Bin),
	mail_api:read(Player, MailId),
	{?ok,Player};

%% 提取邮件附件
gateway(?P_MAIL_PICK, Player, <<Count:16,Bin/binary>>) ->
	Fun=fun(_,{<<MailId:32,AccBin/binary>>, MailIdList2}) ->
				{AccBin,[MailId|MailIdList2]}
		end, 
	{_,MailIdList} = lists:foldl(Fun, {Bin, []}, lists:duplicate(Count, 0)),
	{?ok,Player2,BinMsg}=mail_api:pick_list(Player, MailIdList),
	app_msg:send(Player2#player.socket, BinMsg),
	{?ok, Player2};

%% 删除邮件
gateway(?P_MAIL_DEL, Player, <<Count:16,Bin/binary>>) ->
	{_,MailIdList} = lists:foldl(fun(_,{<<MailId:32,AccBin/binary>>, MailIdList2}) ->
										 {AccBin,[MailId | MailIdList2]}
								 end, {Bin, []}, lists:duplicate(Count, 0)),
	DMailList = mail_api:del(Player, MailIdList),
	BinMsg = mail_api:msg_ok_del(DMailList),
	app_msg:send(Player#player.socket, BinMsg),
	{?ok,Player};
	

%% 请求保存邮件
gateway(?P_MAIL_SAVE, Player,<<Count:16,Bin/binary>>) ->
	{_,MailIdList} = lists:foldl(fun(_,{<<MailId:32,AccBin/binary>>, MailIdList2}) ->
										 {AccBin,[MailId | MailIdList2]}
								 end, {Bin, []}, lists:duplicate(Count, 0)),
	case mail_api:save(Player, MailIdList) of
		?ok ->
			MailList = mail_mod:lookup(Player#player.uid, ?CONST_MAIL_TYPE_GET),
			BinMsg = mail_api:msg_ok_request(?CONST_MAIL_TYPE_GET,MailList),
			app_msg:send(Player#player.socket, BinMsg),
			{?ok, Player};
		{?error,ErrorCode} ->
			BinErr = system_api:msg_error(ErrorCode),
			app_msg:send(Player#player.socket, BinErr),
			{?ok,Player}
	end;

%% 错误匹配 ------------
gateway(ProtocolCode,Player,Binary)-> % 错误匹配
	?ERROR_GATEWAY(ProtocolCode, Player, Binary),
	{?ok, Player}.