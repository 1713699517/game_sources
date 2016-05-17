
require "common/AcknowledgementMessage"

-- [32040]上香返回 -- 财神 

ACK_WEAGOD_CENSE_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_CENSE_RESULT
	self:init()
end)

-- {上香类型(1：自己上香|2：帮好友上香)}
function ACK_WEAGOD_CENSE_RESULT.getType(self)
	return self.type
end

-- {银元返回}
function ACK_WEAGOD_CENSE_RESULT.getGold(self)
	return self.gold
end

-- {财气返回}
function ACK_WEAGOD_CENSE_RESULT.getWealth(self)
	return self.wealth
end
