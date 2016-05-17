
require "common/AcknowledgementMessage"

-- [2301]商店物品信息块 -- 物品/背包 

ACK_GOODS_SHOP_XXX1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_SHOP_XXX1
	self:init()
end)

function ACK_GOODS_SHOP_XXX1.deserialize(self, reader)
	self.id = reader:readInt32Unsigned() -- {物品id}
	self.price = reader:readInt32Unsigned() -- {价格}
end

-- {物品id}
function ACK_GOODS_SHOP_XXX1.getId(self)
	return self.id
end

-- {价格}
function ACK_GOODS_SHOP_XXX1.getPrice(self)
	return self.price
end
