
require "common/AcknowledgementMessage"

-- [39570]属性加成返回 -- 取经之路 

ACK_PILROAD_ATTR_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_ATTR_BACK
	self:init()
end)

-- {attr数量}
function ACK_PILROAD_ATTR_BACK.getCount(self)
	return self.count
end

-- {attr信息块(39575)}
function ACK_PILROAD_ATTR_BACK.getAttrData(self)
	return self.attr_data
end
