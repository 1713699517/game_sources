-module(data_wrestle_rank).
-include("../include/comm.hrl").

-export([get/1]).

% ;
% 格斗之王王者争霸奖励
get(1)->
	[{give,43161,8,0,0,0,0,0},{give,43221,5,0,0,0,0,0}];
get(2)->
	[{give,43161,5,0,0,0,0,0},{give,43221,3,0,0,0,0,0}];
get(_)->?null.
