
require "common/AcknowledgementMessage"

-- [39535]黑店购买记录返回 -- 取经之路 

ACK_PILROAD_HISTORY_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_HISTORY_BACK
	self:init()
end)

-- {数量}
function ACK_PILROAD_HISTORY_BACK.getCount(self)
	return self.count
end

-- {购买记录信息块(39540)}
function ACK_PILROAD_HISTORY_BACK.getMsgxxxhis(self)
	return self.msgxxxhis
end
