
require "common/AcknowledgementMessage"

-- [46050]转盘日志返回 -- 幸运大转盘 

ACK_WHEEL_LOG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WHEEL_LOG
	self:init()
end)

-- {数量}
function ACK_WHEEL_LOG.getCount(self)
	return self.count
end

-- {数据块2334}
function ACK_WHEEL_LOG.getMsgXxx(self)
	return self.msg_xxx
end
