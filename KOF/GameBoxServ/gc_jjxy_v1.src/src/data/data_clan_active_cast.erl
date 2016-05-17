-module(data_clan_active_cast).
-include("../include/comm.hrl").

-export([get/1]).

% get(成长类型,等级);
% 帮派活动花费配置表;
% type_act_1:: {Type,Vip,[{Curr,Value}],[{GetTN,Value},{GetYQSExp,Value}]};
% type_act_1:：{类型，Vip等级，[{消费的钱类型，数量}]，[{得到体能，数量},{摇钱树经验，数量}]}
get(1001)->
	[
	{1,[{1,20000}],[{14,10},{18,50}]},
	{2,[{2,20}],[{14,200},{18,500}]},
	{3,[{2,100}],[{14,1000},{18,5000}]}
	];
get(_)->?null.
