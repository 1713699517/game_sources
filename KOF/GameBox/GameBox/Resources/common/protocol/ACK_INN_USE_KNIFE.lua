
require "common/AcknowledgementMessage"

-- [31186]能使用的刀 -- 客栈 

ACK_INN_USE_KNIFE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_USE_KNIFE
	self:init()
end)

-- {回合}
function ACK_INN_USE_KNIFE.getRond(self)
	return self.rond
end

-- {数量}
function ACK_INN_USE_KNIFE.getCount(self)
	return self.count
end

-- {31187}
function ACK_INN_USE_KNIFE.getKnife(self)
	return self.knife
end
