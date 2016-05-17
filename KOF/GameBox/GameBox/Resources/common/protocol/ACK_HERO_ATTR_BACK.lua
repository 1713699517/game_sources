
require "common/AcknowledgementMessage"

-- [39570]属性加成返回 -- 英雄副本 

ACK_HERO_ATTR_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_ATTR_BACK
	self:init()
end)

function ACK_HERO_ATTR_BACK.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {attr数量}
	self.attr_data = reader:readXXXGroup() -- {attr信息块(39575)}
end

-- {attr数量}
function ACK_HERO_ATTR_BACK.getCount(self)
	return self.count
end

-- {attr信息块(39575)}
function ACK_HERO_ATTR_BACK.getAttrData(self)
	return self.attr_data
end
