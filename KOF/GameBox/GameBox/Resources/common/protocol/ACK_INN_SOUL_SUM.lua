
require "common/AcknowledgementMessage"

-- [31110]返回相对应的精魄数量 -- 客栈 

ACK_INN_SOUL_SUM = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_SOUL_SUM
	self:init()
end)

-- {精魄颜色}
function ACK_INN_SOUL_SUM.getColor(self)
	return self.color
end

-- {精魄数量}
function ACK_INN_SOUL_SUM.getCount(self)
	return self.count
end
