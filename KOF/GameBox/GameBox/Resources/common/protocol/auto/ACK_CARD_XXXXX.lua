
require "common/AcknowledgementMessage"

-- [24980]以领取的活动 -- 新手卡 

ACK_CARD_XXXXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CARD_XXXXX
	self:init()
end)

function ACK_CARD_XXXXX.deserialize(self, reader)
	self.idstep = reader:readInt16Unsigned() -- {活动阶段ID}
end

-- {活动阶段ID}
function ACK_CARD_XXXXX.getIdstep(self)
	return self.idstep
end
