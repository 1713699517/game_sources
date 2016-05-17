
require "common/AcknowledgementMessage"

-- [42522]卡片套装和奖励数据返回 -- 收集卡片 

ACK_COLLECT_CARD_DATA_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COLLECT_CARD_DATA_BACK
	self:init()
end)

-- {套装数据数量}
function ACK_COLLECT_CARD_DATA_BACK.getCount(self)
	return self.count
end

-- {数据信息块42524}
function ACK_COLLECT_CARD_DATA_BACK.getMsgXxx(self)
	return self.msg_xxx
end
