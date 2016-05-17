
require "common/AcknowledgementMessage"

-- [31181]各种精魄数量 -- 客栈 

ACK_INN_SOUL_COUNT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_SOUL_COUNT
	self:init()
end)

-- {类型数量}
function ACK_INN_SOUL_COUNT.getCount(self)
	return self.count
end

-- {31110}
function ACK_INN_SOUL_COUNT.getSoul(self)
	return self.soul
end
