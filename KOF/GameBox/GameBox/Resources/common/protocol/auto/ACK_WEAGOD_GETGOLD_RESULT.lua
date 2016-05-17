
require "common/AcknowledgementMessage"

-- (手动) -- [32060]招财返回 -- 财神 

ACK_WEAGOD_GETGOLD_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_GETGOLD_RESULT
	self:init()
end)

function ACK_WEAGOD_GETGOLD_RESULT.deserialize(self, reader)
	self.gold = reader:readInt32Unsigned() -- {招到的银元}
end

-- {招到的银元}
function ACK_WEAGOD_GETGOLD_RESULT.getGold(self)
	return self.gold
end
