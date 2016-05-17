
require "common/AcknowledgementMessage"

-- [43520]返回报名状态 -- 跨服战 

ACK_STRIDE_STATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_STATA
	self:init()
end)

function ACK_STRIDE_STATA.deserialize(self, reader)
	self.stata = reader:readInt8Unsigned() -- {1:已报名0:未报名}
	self.is_start = reader:readInt8Unsigned() -- {1:已开启 0:未开启}
end

-- {1:已报名0:未报名}
function ACK_STRIDE_STATA.getStata(self)
	return self.stata
end

-- {1:已开启 0:未开启}
function ACK_STRIDE_STATA.getIsStart(self)
	return self.is_start
end
