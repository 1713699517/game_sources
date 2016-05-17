
require "common/AcknowledgementMessage"

-- [24933]促销活动信息 -- 新手卡 

ACK_CARD_ID_DATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CARD_ID_DATE
	self:init()
end)

-- {活动ID}
function ACK_CARD_ID_DATE.getId(self)
	return self.id
end

-- {活动开始时间}
function ACK_CARD_ID_DATE.getStartTime(self)
	return self.start_time
end

-- {活动结束时间}
function ACK_CARD_ID_DATE.getExitTime(self)
	return self.exit_time
end

-- {数量}
function ACK_CARD_ID_DATE.getCount(self)
	return self.count
end

-- {活动阶段信息块(24934)}
function ACK_CARD_ID_DATE.getSubDate(self)
	return self.sub_date
end
