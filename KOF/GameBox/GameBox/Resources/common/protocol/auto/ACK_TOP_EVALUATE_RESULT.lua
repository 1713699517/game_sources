
require "common/AcknowledgementMessage"

-- (手动) -- [24820]评价成功返回 -- 排行榜 

ACK_TOP_EVALUATE_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TOP_EVALUATE_RESULT
	self:init()
end)

function ACK_TOP_EVALUATE_RESULT.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {评价类型(0:鄙视 1:崇拜)}
end

-- {评价类型(0:鄙视 1:崇拜)}
function ACK_TOP_EVALUATE_RESULT.getType(self)
	return self.type
end
