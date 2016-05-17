
require "common/AcknowledgementMessage"

-- [39535]黑店购买记录返回 -- 英雄副本 

ACK_HERO_HISTORY_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_HISTORY_BACK
	self:init()
end)

function ACK_HERO_HISTORY_BACK.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	self.msgxxxhis = reader:readXXXGroup() -- {购买记录信息块(39540)}
end

-- {数量}
function ACK_HERO_HISTORY_BACK.getCount(self)
	return self.count
end

-- {购买记录信息块(39540)}
function ACK_HERO_HISTORY_BACK.getMsgxxxhis(self)
	return self.msgxxxhis
end
