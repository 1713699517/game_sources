
require "common/AcknowledgementMessage"

-- (手动) -- [39575]attr信息块 -- 英雄副本 

ACK_HERO_ATTR_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_ATTR_MSG
	self:init()
end)

function ACK_HERO_ATTR_MSG.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {attr加成类型}
	self.value = reader:readInt16Unsigned() -- {attr加成值}
end

-- {attr加成类型}
function ACK_HERO_ATTR_MSG.getType(self)
	return self.type
end

-- {attr加成值}
function ACK_HERO_ATTR_MSG.getValue(self)
	return self.value
end
