
require "common/AcknowledgementMessage"

-- [32070]财神成长记录返回 -- 财神 

ACK_WEAGOD_GROW_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_GROW_REPLY
	self:init()
end)

-- {成长记录数量}
function ACK_WEAGOD_GROW_REPLY.getCount(self)
	return self.count
end

-- {成长记录信息块(32075)}
function ACK_WEAGOD_GROW_REPLY.getData(self)
	return self.data
end
