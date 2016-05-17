
require "common/AcknowledgementMessage"

-- (手动) -- [24840]评价信息返回 -- 排行榜 

ACK_TOP_EVALUATE_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TOP_EVALUATE_BACK
	self:init()
end)

function ACK_TOP_EVALUATE_BACK.deserialize(self, reader)
	self.worship = reader:readInt32Unsigned() -- {被崇拜次数}
	self.disdain = reader:readInt32Unsigned() -- {被鄙视次数}
end

-- {被崇拜次数}
function ACK_TOP_EVALUATE_BACK.getWorship(self)
	return self.worship
end

-- {被鄙视次数}
function ACK_TOP_EVALUATE_BACK.getDisdain(self)
	return self.disdain
end
