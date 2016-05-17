
require "common/AcknowledgementMessage"

-- [46022]转盘数据返回 -- 幸运大转盘 

ACK_WHEEL_DATA_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WHEEL_DATA_BACK
	self:init()
end)

-- {消耗类型}
function ACK_WHEEL_DATA_BACK.getCostType(self)
	return self.cost_type
end

-- {消耗货币}
function ACK_WHEEL_DATA_BACK.getCostValue(self)
	return self.cost_value
end

-- {数量}
function ACK_WHEEL_DATA_BACK.getCount(self)
	return self.count
end

-- {数据块46010}
function ACK_WHEEL_DATA_BACK.getMsg(self)
	return self.msg
end
