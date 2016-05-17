-module(data_world_boss_rank).
-include("../include/comm.hrl").

-export([get/1]).

% ;
% BOSS排名奖励
get(1)->
	[{give,40291,3,0,0,0,0,0}];
get(2)->
	[{give,40291,2,0,0,0,0,0}];
get(3)->
	[{give,40291,1,0,0,0,0,0}];
get(4)->
	[{give,40281,2,0,0,0,0,0}];
get(5)->
	[{give,40281,1,0,0,0,0,0}];
get(_)->?null.
