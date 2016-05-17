
require "common/AcknowledgementMessage"

-- [2321]商店购买成功 -- 物品/背包 

ACK_GOODS_SHOP_BUY_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_SHOP_BUY_OK
	self:init()
end)
