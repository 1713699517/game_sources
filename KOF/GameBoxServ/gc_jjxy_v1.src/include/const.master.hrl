

-define(HTTP_CODE_200, 			 200).
-define(HTTP_CODE_400, 			 400).
-define(HTTP_CODE_403, 			 403).
-define(HTTP_CODE_500, 			 500).


-define(HTTP_TIMEOUT, 		 	 600).

-define(HTTP_METHOD_ALLOWED, 	 [{gc_server,game_start},
								  {gc_server,game_stop},
								  {gc_server,game_stop_node},
								  {gc_server,game_out}]).

-define(HTTP_MODULE_ALLOWED, 	 [gm_api]).

-define(HTTP_LISTEN_OPTIONS, 	 [{active, 	false},
								   binary,
								  {backlog, 256},
								  % {ip, 		{127,0,0,1} },
								  {packet, 	http_bin},
								  {raw,		6,		9,	<<1:32/native>>}, % defer accept
								  % {delay_send,true},
								  % {nodelay,	true},
								  {reuseaddr,	true}]).



