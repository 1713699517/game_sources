
require "common/AcknowledgementMessage"

-- [34516]购买成功 -- 商城 

ACK_SHOP_BUY_SUCC = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOP_BUY_SUCC
	self:init()
end)
