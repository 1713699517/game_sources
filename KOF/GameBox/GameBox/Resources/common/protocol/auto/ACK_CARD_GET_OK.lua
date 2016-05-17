
require "common/AcknowledgementMessage"

-- [24950]领取成功 -- 新手卡 

ACK_CARD_GET_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CARD_GET_OK
	self:init()
end)
