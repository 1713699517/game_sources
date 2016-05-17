
require "common/AcknowledgementMessage"

-- [43555]战报日志 -- 跨服战 

ACK_STRIDE_WAR_LOGS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_WAR_LOGS
	self:init()
end)

-- {数量}
function ACK_STRIDE_WAR_LOGS.getCount(self)
	return self.count
end

-- {信息块(43556)}
function ACK_STRIDE_WAR_LOGS.getData(self)
	return self.data
end
