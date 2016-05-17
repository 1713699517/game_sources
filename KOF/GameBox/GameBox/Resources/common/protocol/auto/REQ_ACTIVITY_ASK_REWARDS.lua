
require "common/RequestMessage"

-- [30650]请求领取奖励 -- 活动面板 

REQ_ACTIVITY_ASK_REWARDS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ACTIVITY_ASK_REWARDS
	self:init(1 ,{ 30660,700 })
end)

function REQ_ACTIVITY_ASK_REWARDS.serialize(self, writer)
	writer:writeInt8Unsigned(self.id)  -- {奖励编号}
end

function REQ_ACTIVITY_ASK_REWARDS.setArguments(self,id)
	self.id = id  -- {奖励编号}
end

-- {奖励编号}
function REQ_ACTIVITY_ASK_REWARDS.setId(self, id)
	self.id = id
end
function REQ_ACTIVITY_ASK_REWARDS.getId(self)
	return self.id
end
