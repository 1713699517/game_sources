
require "common/AcknowledgementMessage"

-- [30540]日常活动次数返回 -- 活动面板 

ACK_ACTIVITY_DAILY_COUNT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_DAILY_COUNT
	self:init()
end)

-- {数量}
function ACK_ACTIVITY_DAILY_COUNT.getCount(self)
	return self.count
end

-- {活动信息块(30560)}
function ACK_ACTIVITY_DAILY_COUNT.getMsg(self)
	return self.msg
end
