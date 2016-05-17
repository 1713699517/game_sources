-module(data_world_boss_relive).
-include("../include/comm.hrl").

-export([get/1]).

% ;
% BOSS复活使用元宝
get(1)-> 5;
get(2)-> 5;
get(3)-> 5;
get(4)-> 5;
get(5)-> 5;
get(6)-> 10;
get(7)-> 10;
get(8)-> 10;
get(9)-> 10;
get(10)-> 10;
get(11)-> 20;
get(12)-> 20;
get(13)-> 20;
get(14)-> 20;
get(15)-> 20;
get(16)-> 30;
get(17)-> 30;
get(18)-> 30;
get(19)-> 30;
get(20)-> 30;
get(21)-> 40;
get(22)-> 40;
get(23)-> 40;
get(24)-> 40;
get(25)-> 40;
get(26)-> 60;
get(27)-> 60;
get(28)-> 60;
get(29)-> 60;
get(30)-> 60;
get(0)-> 100;
get(_)->10.
