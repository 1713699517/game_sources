
require "common/AcknowledgementMessage"

-- (手动) -- [39520]购买黑店物品成功 -- 英雄副本 

ACK_HERO_SHOP_BUY_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_SHOP_BUY_OK
	self:init()
end)

function ACK_HERO_SHOP_BUY_OK.deserialize(self, reader)
	self.goods_id = reader:readInt32Unsigned() -- {物品Id}
end

-- {物品Id}
function ACK_HERO_SHOP_BUY_OK.getGoodsId(self)
	return self.goods_id
end
