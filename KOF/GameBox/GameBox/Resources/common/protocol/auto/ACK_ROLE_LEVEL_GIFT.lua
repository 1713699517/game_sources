
require "common/AcknowledgementMessage"

-- [1341]等级礼包 -- 角色 

ACK_ROLE_LEVEL_GIFT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_LEVEL_GIFT
	self:init()
end)

function ACK_ROLE_LEVEL_GIFT.deserialize(self, reader)
	self.leveled = reader:readInt8Unsigned() -- {等级}
end

-- {等级}
function ACK_ROLE_LEVEL_GIFT.getLeveled(self)
	return self.leveled
end
