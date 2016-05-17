
require "common/AcknowledgementMessage"

-- [39060]购买次数返回 -- 英雄副本 

ACK_HERO_BACK_TIMES = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_BACK_TIMES
	self:init()
end)

function ACK_HERO_BACK_TIMES.deserialize(self, reader)
	self.times = reader:readInt16Unsigned() -- {英雄副本的剩余次数}
end

-- {英雄副本的剩余次数}
function ACK_HERO_BACK_TIMES.getTimes(self)
	return self.times
end
