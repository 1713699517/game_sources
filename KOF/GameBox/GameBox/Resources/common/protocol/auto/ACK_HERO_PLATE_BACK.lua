
require "common/AcknowledgementMessage"

-- (手动) -- [39560]文牒返回 -- 英雄副本 

ACK_HERO_PLATE_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_PLATE_BACK
	self:init()
end)

function ACK_HERO_PLATE_BACK.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {文牒数量}
	self.max = reader:readInt16Unsigned() -- {文牒上限}
end

-- {文牒数量}
function ACK_HERO_PLATE_BACK.getCount(self)
	return self.count
end

-- {文牒上限}
function ACK_HERO_PLATE_BACK.getMax(self)
	return self.max
end
