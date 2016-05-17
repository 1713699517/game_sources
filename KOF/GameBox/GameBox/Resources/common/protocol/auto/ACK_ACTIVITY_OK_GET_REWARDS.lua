
require "common/AcknowledgementMessage"

-- [30660]领奖状态返回 -- 活动面板 

ACK_ACTIVITY_OK_GET_REWARDS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_OK_GET_REWARDS
	self:init()
end)

function ACK_ACTIVITY_OK_GET_REWARDS.deserialize(self, reader)
	self.id = reader:readInt8Unsigned() -- {奖励编号}
end

-- {奖励编号}
function ACK_ACTIVITY_OK_GET_REWARDS.getId(self)
	return self.id
end
