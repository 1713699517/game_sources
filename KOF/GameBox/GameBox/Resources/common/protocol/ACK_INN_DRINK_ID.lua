
require "common/AcknowledgementMessage"

-- [31220]返回大仙id -- 客栈 

ACK_INN_DRINK_ID = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_DRINK_ID
	self:init()
end)

-- {数量}
function ACK_INN_DRINK_ID.getCount(self)
	return self.count
end

-- {大仙id}
function ACK_INN_DRINK_ID.getDrinkId(self)
	return self.drink_id
end
