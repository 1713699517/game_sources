
require "common/RequestMessage"

-- [23960]领取每日奖励 -- 逐鹿台 

REQ_ARENA_DAY_REWARD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARENA_DAY_REWARD
	self:init(1 ,{ 23970,700 })
end)
