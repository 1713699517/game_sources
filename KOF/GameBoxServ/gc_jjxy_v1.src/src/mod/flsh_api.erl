%% Author  : mirahs
%% Created: 2012-6-20
%% Description: TODO: Add description to team_api
-module(flsh_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 

-export([
		 encode_flsh/1,
		 decode_flsh/1,
		 init/1,
		 init/0,
		 
		 login/1,
		 fresh/1,
		 
		 request_times/0,
		 
		 msg_times/2,
		 msg_pai_reply/2,
		 msg_reward_ok/3
		]).

%%
%% API Functions
%%
encode_flsh(FlshData) ->
	FlshData.

decode_flsh(FlshData) ->
	case is_record(FlshData,flsh) of
		?true ->
			FlshData;
		_ ->
			init()
	end.

%% 风林山火
init(Player) ->
	Flsh = init(),
	{Player,Flsh}.

init() ->
	Date = util:date(),
	Times= ?CONST_FLSH_GAME_TIMES,
	#flsh{date=Date,times=Times}.

login(Socket) ->
	Date = util:date(),
	?MSG_ECHO("---------------~w~n",[Date]),
	Flsh = role_api_dict:flsh_get(),
	?MSG_ECHO("---------------~w~n",[Flsh#flsh.date]),
	case Flsh#flsh.date of
		Date ->
			?skip;
		_ ->
			NewFlsh = #flsh{date=Date,times=?CONST_FLSH_GAME_TIMES,pai_data=?null,swi_times=0},
			BinMsg = msg_times(NewFlsh#flsh.times,NewFlsh#flsh.is_get),
			app_msg:send(Socket, BinMsg),
			role_api_dict:flsh_set(NewFlsh)
	end.

fresh(Socket) ->
	login(Socket).

request_times() ->
	#flsh{times=Times,is_get=IsGet} = role_api_dict:flsh_get(),
	BinMsg = msg_times(Times,IsGet),
	BinMsg.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MSG XXXXXXXXXXXXXXXXXXXXXXXXXXX%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
msg_times(Times,IsGet) ->
	BinData = app_msg:encode([{?int16u,Times},{?int8u,IsGet}]),
	app_msg:msg(?P_FLSH_TIMES_REPLY, BinData).

msg_pai_reply(SwiTimes,PaiData) ->
	MyPai = tuple_to_list(PaiData),
	Fun = fun(Num,{AccPos,AccBin}) ->
				  Fbin = app_msg:encode([{?int8u,AccPos},{?int8u,Num}]),
				  {AccPos+1,<<AccBin/binary,Fbin/binary>>}
		  end,
	{_,BinData} = lists:foldl(Fun, {1,<<>>}, MyPai),
	CountBin = app_msg:encode([{?int16u,SwiTimes},{?int16u,length(MyPai)}]),
	app_msg:msg(?P_FLSH_PAI_REPLY, <<CountBin/binary,BinData/binary>>).

msg_reward_ok(SzNum, SameNum, DzNum) ->
	BinData = app_msg:encode([{?int16u,SzNum},{?int16u,SameNum},{?int16u,DzNum}]),
	app_msg:msg(?P_FLSH_REWARD_OK, BinData).