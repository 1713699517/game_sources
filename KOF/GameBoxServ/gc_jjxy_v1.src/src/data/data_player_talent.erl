-module(data_player_talent).
-include("../include/comm.hrl").

-export([get/1]).

% get(天赋);
% 天赋影响数据;
% 天赋：1 => '力量天赋' , 2 => '灵力天赋'，3 => '敏捷天赋'，4 =>'暴击天赋'，5 =>'闪避天赋'，6 =>'格挡天赋'，7 =>'',8 =>'';
% 天赋作用：[{影响属性1，影响百分比1}，{影响属性2，影响百分比2}……]
get(1)->[{50,1000},{51,1000}];
get(2)->[{52,1000},{53,1000}];
get(3)->[{56,1500}];
get(4)->[{44,1000}];
get(5)->[{51,2500},{53,2500}];
get(_)->[].
