
require "common/AcknowledgementMessage"

-- [39580]取经之路组队完成 -- 取经之路 

ACK_PILROAD_OVER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_OVER
	self:init()
end)

-- {数量}
function ACK_PILROAD_OVER.getCount(self)
	return self.count
end

-- {通关信息块(39585)}
function ACK_PILROAD_OVER.getData(self)
	return self.data
end
