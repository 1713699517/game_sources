
require "common/AcknowledgementMessage"

-- [39580]取经之路组队完成 -- 英雄副本 

ACK_HERO_OVER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_OVER
	self:init()
end)

function ACK_HERO_OVER.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	self.data = reader:readXXXGroup() -- {通关信息块(39585)}
end

-- {数量}
function ACK_HERO_OVER.getCount(self)
	return self.count
end

-- {通关信息块(39585)}
function ACK_HERO_OVER.getData(self)
	return self.data
end
