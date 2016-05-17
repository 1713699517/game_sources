
require "common/AcknowledgementMessage"

-- [42542]兑换所需金元 -- 收集卡片 

ACK_COLLECT_CARD_COST_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COLLECT_CARD_COST_BACK
	self:init()
end)

function ACK_COLLECT_CARD_COST_BACK.deserialize(self, reader)
	self.cost = reader:readInt32Unsigned() -- {兑换所需金元}
end

-- {兑换所需金元}
function ACK_COLLECT_CARD_COST_BACK.getCost(self)
	return self.cost
end
