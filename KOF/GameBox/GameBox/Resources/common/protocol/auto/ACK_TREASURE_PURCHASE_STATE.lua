
require "common/AcknowledgementMessage"

-- [47300]购买成功与否 -- 珍宝阁系统 

ACK_TREASURE_PURCHASE_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TREASURE_PURCHASE_STATE
	self:init()
end)

function ACK_TREASURE_PURCHASE_STATE.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {1：成功  0：失败}
end

-- {1：成功  0：失败}
function ACK_TREASURE_PURCHASE_STATE.getState(self)
	return self.state
end
