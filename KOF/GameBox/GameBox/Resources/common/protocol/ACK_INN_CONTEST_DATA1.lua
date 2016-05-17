
require "common/AcknowledgementMessage"

-- [31280]返回斗法伙伴信息 -- 客栈 

ACK_INN_CONTEST_DATA1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_CONTEST_DATA1
	self:init()
end)

-- {伙伴数量}
function ACK_INN_CONTEST_DATA1.getCount(self)
	return self.count
end

-- {信息块(31110)}
function ACK_INN_CONTEST_DATA1.getData(self)
	return self.data
end
