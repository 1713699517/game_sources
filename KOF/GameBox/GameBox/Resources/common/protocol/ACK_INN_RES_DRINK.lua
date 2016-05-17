
require "common/AcknowledgementMessage"

-- [31240]返回结果 -- 客栈 

ACK_INN_RES_DRINK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_RES_DRINK
	self:init()
end)

-- {数量(循环)}
function ACK_INN_RES_DRINK.getCount(self)
	return self.count
end

-- {31242}
function ACK_INN_RES_DRINK.getDevoteBox(self)
	return self.devote_box
end
