
require "common/AcknowledgementMessage"

-- [30640]奖励数据块 -- 活动面板 

ACK_ACTIVITY_REWARDS_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_REWARDS_DATA
	self:init()
end)

function ACK_ACTIVITY_REWARDS_DATA.deserialize(self, reader)
	self.id = reader:readInt8Unsigned() -- {礼包编号}
end

-- {礼包编号}
function ACK_ACTIVITY_REWARDS_DATA.getId(self)
	return self.id
end
