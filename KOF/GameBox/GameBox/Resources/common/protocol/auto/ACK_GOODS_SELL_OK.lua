
require "common/AcknowledgementMessage"

-- [2262]出售成功 -- 物品/背包 

ACK_GOODS_SELL_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_SELL_OK
	self:init()
end)
