
require "common/AcknowledgementMessage"

-- [24960]领取通知 -- 新手卡 

ACK_CARD_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CARD_NOTICE
	self:init()
end)
