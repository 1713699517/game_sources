
require "common/AcknowledgementMessage"

-- [24934]促销活动开启阶段 -- 新手卡 

ACK_CARD_ID_SUB = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CARD_ID_SUB
	self:init()
end)

function ACK_CARD_ID_SUB.deserialize(self, reader)
	self.id_sub = reader:readInt16Unsigned() -- {可领取阶段ID}
end

-- {可领取阶段ID}
function ACK_CARD_ID_SUB.getIdSub(self)
	return self.id_sub
end
