
require "common/AcknowledgementMessage"

-- (手动) -- [47240]一键制作请求 -- 藏宝阁系统 

ACK_TREASURE_KEY_MAKE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TREASURE_KEY_MAKE
	self:init()
end)

function ACK_TREASURE_KEY_MAKE.deserialize(self, reader)
	self.state = reader:readBoolean() -- {打造状态与否}
end

-- {打造状态与否}
function ACK_TREASURE_KEY_MAKE.getState(self)
	return self.state
end
