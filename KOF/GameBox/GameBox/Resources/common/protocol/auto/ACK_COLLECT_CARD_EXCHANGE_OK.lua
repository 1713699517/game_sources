
require "common/AcknowledgementMessage"

-- [42532]兑换成功 -- 收集卡片 

ACK_COLLECT_CARD_EXCHANGE_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COLLECT_CARD_EXCHANGE_OK
	self:init()
end)
