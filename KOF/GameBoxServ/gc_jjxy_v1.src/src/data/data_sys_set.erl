-module(data_sys_set).
-include("../include/comm.hrl").

-export([get/0]).

% get();
% 系统设置开关;
% 
get()->
	[{101,1},{102,1},{103,0},{104,0},{105,1},{106,1},{107,0},{108,0},{109,1}].