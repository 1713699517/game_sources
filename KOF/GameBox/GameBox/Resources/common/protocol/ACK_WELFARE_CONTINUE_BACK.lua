
require "common/AcknowledgementMessage"

-- [22220]连续登陆数据返回 -- 福利 

ACK_WELFARE_CONTINUE_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WELFARE_CONTINUE_BACK
	self:init()
end)

-- {连续登陆天数}
function ACK_WELFARE_CONTINUE_BACK.getDay(self)
	return self.day
end

-- {已领的奖励数量}
function ACK_WELFARE_CONTINUE_BACK.getCount(self)
	return self.count
end

-- {奖励条件值}
function ACK_WELFARE_CONTINUE_BACK.getCondition(self)
	return self.condition
end
