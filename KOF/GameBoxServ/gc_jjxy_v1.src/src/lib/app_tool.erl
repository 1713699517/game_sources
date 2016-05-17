-module(app_tool).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../include/comm.hrl"). 


-export([l/1,
		 ly/1, 
		 ly_ets/2, ly_ets/3, ly_ets/4, 
		 ly_dic/2, ly_dic/3, ly_dic/4,	
		 echo/2,   
		 error/4,  error_fileop/0,   error_filewrite/5,
		 % mysql/5,  sid_slow/0
		 sid/0,
		 super_id/0,   
		 ping/1,
		 node_hostname/0,  
		 node_tag/0,
		 node_super/0,
		 node_game_serv/0,
		 node_game_serv/2,  
		 node_master/0,
		 node_test/0,
		 node_security/0]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 加载 yrl文件
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ly(FileName)->
	case ly2(FileName) of 
		{?ok, 	Data}   -> Data;
        {?error, Why} 	-> exit(Why)
    end.
ly2(FileName)->
	case filelib:is_file(FileName) of
		?true -> 
			case file:consult(FileName) of
				%{?ok, [Data]} -> {?ok, Data};
				{?ok, Data}   -> {?ok, Data};
				{?error, Why} -> {?error, {FileName, Why}}
			end;
		?false ->
			{?error, "Could not find file:"++util:to_list(FileName)}
	end. 

ly_ets(Ets,FileName)->
	ly_ets(Ets,FileName,	fun(_Data)->ok end).
ly_ets(Ets,FileName,Fun) ->
	ly_ets(Ets,FileName,Fun,fun( Data)->Data end).
ly_ets(Ets,FileName,none,DataFun) ->
	ly_ets(Ets,FileName,	fun(_Data)->ok end,DataFun);
ly_ets(Ets,FileName,Fun,DataFun)->
	Datas = ly(FileName),
	util:map3(fun(Data)->
					   Fun(Data),
					   ets:insert(Ets,DataFun(Data))
			   end, Datas).

ly_dic(Pid,FileName)->
	ly_dic(Pid,FileName,	fun(_Data)->?ok end).
ly_dic(Pid,FileName,Fun) ->
	ly_dic(Pid,FileName,Fun,fun( Data)->Data end).
ly_dic(Pid,FileName,?null,DataFun) ->
	ly_dic(Pid,FileName,	fun(_Data)->?ok end,DataFun);
ly_dic(Pid,FileName,Fun,DataFun)->
	Datas = ly(FileName),
	util:map3(fun(Data)->
					   Fun(Data),
					   data_pro:dset(Pid, element(1, Data) , DataFun(Data))
			   end, Datas).



%% 加载beam
l(Dir)->
	% {?ok,Dir} 		= file:get_cwd(),
	{?ok,FileList} 	= file:list_dir(Dir),
	lists:foreach(fun(FileBaseName)->
					  FileName = Dir++"/"++FileBaseName,
					  %io:format("FileName:~p~n",[FileName]),
					  case filelib:is_file(FileName) of
						  ?true ->
							  case filename:extension(FileBaseName) of
								  ".beam" ->
									  ModName = filename:rootname(FileBaseName),
									  ModName2= util:list_to_atom(ModName),  
									  ?MSG_PRINT("c:l(~p)",[ModName2]),
									  c:l(ModName2);
								  _ ->
									  ?ok
							  end;
						  _ ->
							  ?ok
					  end
			  end, FileList),
	?ok.

%% 得到服务器SID
sid()->
	case db:config(sid) of
		0   ->  node_tag();
		Sid ->  Sid
	end.

%% 读取跨服节点ID(为0时不支持跨服)
super_id()->
	db:config(super_id).


%% 节点ping通
ping(Node)->
	case net_adm:ping(Node) of
		?pong -> ?true;
		_ 	  -> ?false
	end.

%% 返回现在服务器的 NodeTag
node_tag() ->
	NodeStr 	= atom_to_list(node()),
	IndexBegin	= string:str(NodeStr,"_s"),
	IndexEnd	= string:str(NodeStr,"@"),
	%?MSG_ECHO("IndexBegin:~p IndexEnd:~p",[IndexBegin,IndexEnd]),
	if
		IndexBegin > 0 ->
			IndexBegin2 = IndexBegin+2,
			SidStr		= string:substr(NodeStr, IndexBegin2, IndexEnd-IndexBegin2),
			try 
				list_to_integer(SidStr)
			catch 
				_:_-> "s"++SidStr
			end;
		?true ->
			IndexBegin2	= string:str(NodeStr,"_")+1,
			string:substr(NodeStr, IndexBegin2, IndexEnd-IndexBegin2)
	end.

%% 返回主机名 如:"@yipingair"
node_hostname() ->
	[_,HostName] = string:tokens(atom_to_list(node()), "@"),
	"@" ++ HostName.

%% 返回Master主机名 如: jjxy_master@yipingair
node_master() ->
	HostName	= node_hostname(),
	NodeName	= util:list_to_atom("jjxy_master"++HostName),
	NodeName.

%% 安全沙箱节点名
node_security() ->
	HostName	= node_hostname(),
	util:list_to_atom("jjxy_security"++HostName).

%% 压力测试节点名
node_test()->
	HostName	= node_hostname(),
	util:list_to_atom("jjxy_test"++HostName).

%% 游戏服节点名称
node_game_serv()->
	Sid			= sid(),
	HostName	= node_hostname(),
	node_game_serv(Sid,HostName).
node_game_serv(Sid,HostName)->
	util:list_to_atom("jjxy_s"++util:to_list(Sid)++HostName).


%% 跨服 所在节点
node_super()->
	case db:config(super_node) of
		?null -> 
			% ?MSG_ECHO("SuperNodeName:~p",[?null]),
			0;
		0     ->
			Sid 	= db:config(sid),
			SuperId	= db:config(super_id),
			if
				0 == Sid andalso 0 == SuperId -> 
					ets:insert(?ETS_S_CONFIG,{super_node,?null});
				0 == Sid ->  %% sid 为跨服节点
					SuperNodeName  = node(),
					ets:insert(?ETS_S_CONFIG,{super_node,SuperNodeName}),
					SuperNodeName;
				?true ->
					if
						0 == SuperId ->
							SuperNodeName = ?null;
						?true ->
							Url	 = db:config_node_super_callback(),
							% ?MSG_ECHO("Url:~p",[Url]),
							Url2 = Url ++"?super_id="++util:to_list(SuperId)++"&t=s",
							% ?MSG_ECHO("Url2:~p",[Url2]),
							case util:request_get(Url2, []) of
								{?ok,{_,_,Rs}} ->
									case util:to_binary(Rs) of
										<<60,_N/binary>> ->
											% ?MSG_ERROR("_Error:~p",[<<60,_N/binary>>]),
											SuperNodeName = 0;
										Rs2 ->
											case util:bitstring_to_term(Rs2) of
												{?ok,s,SuperNodeName} -> ?skip;
												_Error ->
 													% ?MSG_ERROR("_Error:~p",[_Error]),
													SuperNodeName = 0
											end
									end;
								_Error ->
 									% ?MSG_ERROR("_Error:~p",[_Error]),
									SuperNodeName = 0
							end
					end,
					ets:insert(?ETS_S_CONFIG,{super_node,SuperNodeName}),
					SuperNodeName
			end;
		SuperNodeName ->
			% ?MSG_ECHO("SuperNodeName:~p",[SuperNodeName]),
			SuperNodeName
	end.
	

%% 错误
error(S,D,MODULE,LINE) ->
	case ?DEBUG_LEVEL_ERROR of 
		-1 -> ?ok;
		_  ->
			H   = error_fileop(),
			error_filewrite(S,D,MODULE,LINE,H),
			file:close(H),
			?ok
	end.
error_fileop() ->
	NodeTag	 = app_tool:node_tag(),
	FileName = ?DIR_LOGS_ROOT++"error."++util:to_list(NodeTag)++".txt",
	{?ok,H}  = file:open(FileName,[write,append]),
	H.
error_filewrite(S,D,MODULE,LINE,H) ->
	S2 	= "~n*****~nDATE:~p Pid:~p Error ~p:~p ~n"++S++"~n*****~n",
	D2 	= [erlang:localtime(),self(),MODULE,LINE|D],
	io:format(H,S2,D2),
	echo(S2,D2).

%% 调试
%% mysql(S,D,Lv,MODULE,LINE) ->
%% 	if
%% 		Lv > -1 andalso Lv =< ?DEBUG_LEVEL_MYSQL ->
%% 			S2 = "MYSQL Lv:~p ~p:~p ~n"++S++"~n", 
%% 			D2 = [Lv,MODULE,LINE|D],
%% 			echo(S2,D2),
%% 			% gen_server:cast(app_logs_srv , {mysql,S2,D2}),
%% 			?ok;
%% 		?true ->
%% 			?ok 
%% 	end.
%% 日志记录函数
%% log(T, F, _A, _Mod, _Line) ->
%%     {ok, Fl} = file:open("logs/error_log.txt", [write, append]),
%%     _Format = list_to_binary("#" ++ T ++" ~s[~w:~w] " ++ F ++ "\r\n~n"),
%%     {{Y, M, D},{H, I, S}} = erlang:localtime(),
%%     _Date = list_to_binary([integer_to_list(Y),"-", integer_to_list(M), "-", integer_to_list(D), " ", integer_to_list(H), ":", integer_to_list(I), ":", integer_to_list(S)]),
%%     file:close(Fl).   

%% 日志
echo(S,D)-> 
	io:format(S++"~n",D).
			