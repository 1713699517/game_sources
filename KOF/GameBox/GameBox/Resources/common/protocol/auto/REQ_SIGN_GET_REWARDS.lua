
require "common/RequestMessage"

-- [40040]领取奖励 -- 签到 

REQ_SIGN_GET_REWARDS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SIGN_GET_REWARDS
	self:init(1 ,{ 40050,700 })
end)

function REQ_SIGN_GET_REWARDS.serialize(self, writer)
	writer:writeInt16Unsigned(self.day)  -- {领取第几天的奖励}
end

function REQ_SIGN_GET_REWARDS.setArguments(self,day)
	self.day = day  -- {领取第几天的奖励}
end

-- {领取第几天的奖励}
function REQ_SIGN_GET_REWARDS.setDay(self, day)
	self.day = day
end
function REQ_SIGN_GET_REWARDS.getDay(self)
	return self.day
end
