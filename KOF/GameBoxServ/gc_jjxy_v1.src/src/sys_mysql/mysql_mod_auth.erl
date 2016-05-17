%% Author: lenovo
%% Created: 2010-5-10
%% Description: TODO: Add description to yp_mysql_auth
-module(mysql_mod_auth).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl").
-include("../include/drive.mysql.hrl").
%%--------------------------------------------------------------------
%% External exports (should only be used by the 'yp_mysql_conn' module)
%%--------------------------------------------------------------------
-export([
		 auth/1,
		 do_old_auth/7,
		 do_new_auth/8
		]).
auth(MysqlSideState)-> 
	Socket	= MysqlSideState#mysql_side.socket,
	case mysql_mod:do_recv(Socket,<<>>,?undefined, ?undefined) of 
		{?ok,Packet,Data2,InitSeqNum} ->
			{Version, Salt1, Salt2, Caps} = greeting(Packet),
			AuthRes = case Caps band ?MYSQL_CONNECTION_SECURE of
						  ?MYSQL_CONNECTION_SECURE ->
							  do_new_auth(Socket,Data2,Version, InitSeqNum + 1, MysqlSideState#mysql_side.username, MysqlSideState#mysql_side.password,Salt1, Salt2);
						  _ ->
							  do_old_auth(Socket,Data2,Version, InitSeqNum + 1, MysqlSideState#mysql_side.username, MysqlSideState#mysql_side.password,Salt1)
					  end,
			case AuthRes of
				{?ok, <<0:8, _Rest/binary>>, _Data3,_RecvNum} -> 
		    		{?ok,	MysqlSideState#mysql_side{ver=Version} };
					% init_mysql_pro(State,Sock,PidSrv,Version,Ref);
				{?ok, <<255:8, Code:16/little, Message/binary>>,_Data3, _RecvNum} ->
		    		?MSG_ERROR("init error ~p: ~p",    [Code, binary_to_list(Message)]),
					{?error, binary_to_list(Message)    }; 
				{?ok, RecvPacket,_Data3, _RecvNum} ->
					?MSG_ERROR("init unknown ?error ~p",[binary_to_list(RecvPacket)]),
		    		{?error, binary_to_list(RecvPacket) };
				{?error, Reason} ->
					?MSG_ERROR("init failed receiving data : ~p", [Reason]),
					{?error, Reason}
			end;
		{?error, Reason} ->
			{?error, Reason}
    end.
%%--------------------------------------------------------------------
%% Function: do_old_auth(Sock, RecvPid, SeqNum, User, Password, Salt1,
%%                       LogFun)
%%           Sock     = term(), gen_tcp socket
%%           RecvPid  = pid(), receiver process pid
%%           SeqNum   = integer(), first sequence number we should use
%%           User     = string(), MySQL username
%%           Password = string(), MySQL password
%%           Salt1    = string(), salt 1 from server greeting
%%           LogFun   = ?undefined | function() of arity 3
%% Descrip.: Perform old-style MySQL authentication.
%% Returns : result of yp_mysql_conn:do_recv/3
%%--------------------------------------------------------------------
do_old_auth(Socket,Data,Version, SeqNum, User, Password, Salt1) ->
    Auth    = password_old(Password, Salt1),
    Packet2 = make_auth_old(User, Auth),
    mysql_mod:do_send(Socket, Packet2, SeqNum),
    mysql_mod:do_recv(Socket,Data,Version, SeqNum).

%%--------------------------------------------------------------------
%% Function: do_new_auth(Sock, RecvPid, SeqNum, User, Password, Salt1,
%%                       Salt2, LogFun)
%%           Sock     = term(), gen_tcp socket
%%           RecvPid  = pid(), receiver process pid
%%           SeqNum   = integer(), first sequence number we should use
%%           User     = string(), MySQL username
%%           Password = string(), MySQL password
%%           Salt1    = string(), salt 1 from server greeting
%%           Salt2    = string(), salt 2 from server greeting
%%           LogFun   = ?undefined | function() of arity 3
%% Descrip.: Perform MySQL authentication.
%% Returns : result of yp_mysql_conn:do_recv/3
%%--------------------------------------------------------------------
do_new_auth(Socket,Data,Version, SeqNum, User, Password, Salt1, Salt2) ->
    Auth 	= password_new(Password, Salt1 ++ Salt2),
    Packet2 = make_auth_new(User, Auth, ?null),
    mysql_mod:do_send(Socket, Packet2, SeqNum),
    case mysql_mod:do_recv(Socket,Data,Version, SeqNum) of
		{?ok, Packet3, Data2, SeqNum2} ->
			case Packet3 of
				<<254:8>> ->
					AuthOld = password_old(Password, Salt1),
					mysql_mod:do_send(Socket, <<AuthOld/binary, 0:8>>, SeqNum2 + 1),
					mysql_mod:do_recv(Socket,Data2,Version, SeqNum2 + 1);
				_ ->
					{?ok, Packet3, Data2, SeqNum2}
			end;
		{?error, Reason} ->
			{?error, Reason}
    end.

%%====================================================================
%% Internal functions
%%====================================================================
%% 
%% do_recv(Sock,<<Length:24/little, Num:8, D/binary>>,Version,SeqNum) when Length =< size(D) ->
%% 	{Packet, Rest} = split_binary(D, Length),
%% 	if
%% 		is_integer(SeqNum) andalso (SeqNum+1) == Num ->
%% 			{?ok,Packet,Rest,Num};
%% 		is_integer(SeqNum) ->
%% 			do_recv(Sock,Rest,Version,SeqNum); 
%% 		?true ->
%% 			{?ok,Packet,Rest,Num}
%% 	end;	
%% do_recv(Sock,Data,Version,SeqNum) ->
%% 	receive
%% 		{tcp, Sock, InData} ->
%% 			% NewData = <<Data/binary,InData/binary>>,
%% 			do_recv(Sock,<<Data/binary,InData/binary>>,Version,SeqNum);
%% 		{tcp_error, Sock, Reason} ->
%% 			?MSG_MYSQL("mysql_recv: Socket ~p closed : ~p",[Sock, Reason],0),
%% 	    	gen_tcp:close(Sock),
%% 			{?error, tcp_error};
%% 		{tcp_closed, Sock} ->
%% 	    	?MSG_MYSQL("mysql_recv: Socket ~p closed", [Sock],0),
%% 	    	gen_tcp:close(Sock),
%% 			{?error, tcp_closed};
%% 		close ->
%% 			?MSG_MYSQL("socket closed",[],0),
%% 			gen_tcp:close(Sock),
%% 			{?error, closed};
%%  		Unknown ->
%%  	    	?MSG_MYSQL("received unknown signal, Unknown: ~p", [Unknown],0),
%%  			do_recv(Sock,Data,Version,SeqNum)
%% 	end.
%% 
%% do_send(Sock, Packet, Num) ->
%% %% 	?MSG_MYSQL("yp_mysql_auth send packet Num:~p Packet:~p",[Num, Packet]),
%%     Data = <<(size(Packet)):24/little, Num:8, Packet/binary>>,
%% 	gen_tcp:send(Sock, Data).

password_old(Password, Salt) ->
    {P1, P2} = hash(Password),
    {S1, S2} = hash(Salt),
    Seed1 = P1 bxor S1,
    Seed2 = P2 bxor S2,
    List = rnd(9, Seed1, Seed2),
    {L, [Extra]} = lists:split(8, List),
    list_to_binary(lists:map(fun (E) ->
									  E bxor (Extra - 64)
							 end, L)).

password_new(Password, Salt) ->
    Stage1 	= crypto:sha(Password),
    Stage2 	= crypto:sha(Stage1),
	%% 
	Salt1	= crypto:sha_update(crypto:sha_init(), Salt),
	Salt2	= crypto:sha_update(Salt1,Stage2),
	%% 
    Res 	= crypto:sha_final(Salt2),
    bxor_binary(Res, Stage1).

%% part of do_old_auth/4, which is part of yp_mysql_init/4
make_auth_old(User, Password) ->
    Caps = ?MYSQL_LONG_PASSWORD bor ?MYSQL_LONG_FLAG bor ?MYSQL_TRANSACTIONS,
    Maxsize = 0,
    UserB = list_to_binary(User),
    PasswordB = Password,
    <<Caps:16/little, Maxsize:24/little, UserB/binary, 0:8,
    PasswordB/binary>>.

%% part of do_new_auth/4, which is part of yp_mysql_init/4
make_auth_new(User, Password, Database) ->
    DBCaps = case Database of
				 ?null -> 0;
				 _ 	   -> ?MYSQL_CONNECT_WITH_DB
			 end,
    Caps = ?MYSQL_LONG_PASSWORD bor ?MYSQL_LONG_FLAG bor ?MYSQL_TRANSACTIONS bor
		   ?MYSQL_PROTOCOL_41 bor ?MYSQL_CONNECTION_SECURE bor
		   ?MYSQL_CLIENT_MULTI_STATEMENTS bor ?MYSQL_CLIENT_MULTI_RESULTS bor DBCaps,
    Maxsize   = ?MYSQL_MAX_PACKET_SIZE,
    UserB 	  = list_to_binary(User),
    PasswordL = size(Password),
    DatabaseB = case Database of
					?null -> <<>>;
					_     -> list_to_binary(Database)
				end,
    <<Caps:32/little, Maxsize:32/little, 8:8, 0:23/integer-unit:8,
      UserB/binary, 0:8, PasswordL:8, Password/binary, DatabaseB/binary>>.

hash(S) ->
    hash(S, 1345345333, 305419889, 7).

hash([C | S], N1, N2, Add) ->
    N1_1 = N1 bxor (((N1 band 63) + Add) * C + N1 * 256),
    N2_1 = N2 + ((N2 * 256) bxor N1_1),
    Add_1 = Add + C,
    hash(S, N1_1, N2_1, Add_1);
hash([], N1, N2, _Add) ->
    Mask = (1 bsl 31) - 1,
    {N1 band Mask , N2 band Mask}.

rnd(N, Seed1, Seed2) ->
    Mod = (1 bsl 30) - 1,
    rnd(N, [], Seed1 rem Mod, Seed2 rem Mod).

rnd(0, List, _, _) ->
    lists:reverse(List);
rnd(N, List, Seed1, Seed2) ->
    Mod 	= (1 bsl 30) - 1,
    NSeed1 	= (Seed1 * 3 + Seed2) rem Mod,
    NSeed2 	= (NSeed1 + Seed2 + 33) rem Mod,
    Float 	= (float(NSeed1) / float(Mod))*31,
    Val 	= trunc(Float)+64,
    rnd(N - 1, [Val | List], NSeed1, NSeed2).



dualmap(_F, [], []) ->
    [];
dualmap(F, [E1 | R1], [E2 | R2]) ->
    [F(E1, E2) | dualmap(F, R1, R2)].

bxor_binary(B1, B2) ->
    list_to_binary(dualmap(fun (E1, E2) ->
									E1 bxor E2
						   end, binary_to_list(B1), binary_to_list(B2))).


%% part of yp_mysql_init/4
greeting(Packet) ->
    <<_Protocol:8, Rest/binary>> 	= Packet,
    {Version, Rest2} 				= asciz(Rest),
    <<_TreadID:32/little, Rest3/binary>> 	= Rest2,
    {Salt, Rest4} 							= asciz(Rest3),
    <<Caps:16/little, Rest5/binary>> 				= Rest4,
    <<_ServerChar:16/binary-unit:8, Rest6/binary>> 	= Rest5,
    {Salt2, _Rest7} = asciz(Rest6),
%% 	?MSG_MYSQL("greeting version ~p (protocol ~p) salt ~p caps ~p serverchar ~p salt2 ~p",[Version, Protocol, Salt, Caps, ServerChar, Salt2]),
    {normalize_version(Version), Salt, Salt2, Caps}.

%% part of greeting/2
asciz(Data) when is_binary(Data) ->
    asciz_binary(Data, []); 
asciz(Data) when is_list(Data) ->
    {String, [0 | Rest]} = lists:splitwith(fun (C) ->
													C /= 0
										   end, Data),
    {String, Rest}.


normalize_version([$4,$.,$0|_T]) ->
    % ?MSG_MYSQL("switching to MySQL 4.0.x protocol.",[],0),
    ?MYSQL_4_0;
normalize_version([$4,$.,$1|_T]) -> 
    ?MYSQL_4_1;
normalize_version([$5|_T]) ->
    %% MySQL version 5.x protocol is compliant with MySQL 4.1.x:
    ?MYSQL_4_1; 
normalize_version(_Other) ->
    %?MSG_MYSQL("MySQL version not supported: MySQL Erlang module might not work correctly.",[],0),
    %% ?error, but trying the oldest protocol anyway:
    ?MYSQL_4_0.

%% @doc Find the first zero-byte in Data and add everything before it
%%   to Acc, as a string.
%%
%% @spec asciz_binary(Data::binary(), Acc::list()) ->
%%   {NewList::list(), Rest::binary()} 
asciz_binary(<<>>, Acc) ->
    {lists:reverse(Acc), <<>>};
asciz_binary(<<0:8, Rest/binary>>, Acc) ->
    {lists:reverse(Acc), Rest};
asciz_binary(<<C:8, Rest/binary>>, Acc) ->
    asciz_binary(Rest, [C | Acc]).







