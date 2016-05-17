
require "common/AcknowledgementMessage"

-- [23870]结果 -- 逐鹿台 

ACK_ARENA_RESULT2 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_RESULT2
	self:init()
end)

function ACK_ARENA_RESULT2.deserialize(self, reader)
	self.buy_count = reader:readInt16Unsigned() -- {购买次数}
end

-- {购买次数}
function ACK_ARENA_RESULT2.getBuyCount(self)
	return self.buy_count
end
