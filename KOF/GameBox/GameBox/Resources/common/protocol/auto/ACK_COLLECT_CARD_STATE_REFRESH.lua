
require "common/AcknowledgementMessage"

-- [42511]卡片活动状态有变化 -- 收集卡片 

ACK_COLLECT_CARD_STATE_REFRESH = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COLLECT_CARD_STATE_REFRESH
	self:init()
end)
