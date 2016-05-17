-module(data_wrestle_final).
-include("../include/comm.hrl").

-export([get/1]).

% ;
% 格斗之王决赛奖励
get(1)->
	[{give,43101,8,0,0,0,0,0},{give,43141,5,0,0,0,0,0}];
get(2)->
	[{give,43101,5,0,0,0,0,0},{give,43141,3,0,0,0,0,0}];
get(3)->
	[{give,43101,3,0,0,0,0,0},{give,43141,2,0,0,0,0,0}];
get(4)->
	[{give,43101,1,0,0,0,0,0},{give,43141,1,0,0,0,0,0}];
get(_)->?null.
