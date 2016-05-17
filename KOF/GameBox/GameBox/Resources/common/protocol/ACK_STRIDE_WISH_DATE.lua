
require "common/AcknowledgementMessage"

-- [43570]返回许愿日志 -- 跨服战 

ACK_STRIDE_WISH_DATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_WISH_DATE
	self:init()
end)

-- {数量}
function ACK_STRIDE_WISH_DATE.getCount(self)
	return self.count
end

-- {信息块(43571)}
function ACK_STRIDE_WISH_DATE.getData(self)
	return self.data
end
