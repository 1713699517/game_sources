-module(data_player_grow).
-include("../include/comm.hrl").

-export([get/1,grow/3]).

grow(Attr,Lv,Rate)->
	Table = ?DATA_PLAYER_GROW:get(Attr),
	?DATA_PLAYER_GROW_TABLE:get(Table,Lv,Rate).
% get(成长类型);
% 角色成长数据
get(44)->2;
get(46)->1;
get(48)->1;
get(_)->0.
