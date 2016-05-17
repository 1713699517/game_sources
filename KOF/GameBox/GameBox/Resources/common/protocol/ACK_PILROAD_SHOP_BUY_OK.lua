
require "common/AcknowledgementMessage"

-- (手动) -- [39520]购买黑店物品成功 -- 取经之路 

ACK_PILROAD_SHOP_BUY_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_SHOP_BUY_OK
	self:init()
end)

function ACK_PILROAD_SHOP_BUY_OK.deserialize(self, reader)
	self.goods_id = reader:readInt32Unsigned() -- {物品Id}
end

-- {物品Id}
function ACK_PILROAD_SHOP_BUY_OK.getGoodsId(self)
	return self.goods_id
end
