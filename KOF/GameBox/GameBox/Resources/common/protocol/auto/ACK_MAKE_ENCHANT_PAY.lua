
require "common/AcknowledgementMessage"

-- [2620]附魔消耗 -- 物品/打造/强化 

ACK_MAKE_ENCHANT_PAY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_ENCHANT_PAY
	self:init()
end)

function ACK_MAKE_ENCHANT_PAY.deserialize(self, reader)
	self.rmb = reader:readInt32Unsigned() -- {消耗人民币}
end

-- {消耗人民币}
function ACK_MAKE_ENCHANT_PAY.getRmb(self)
	return self.rmb
end
