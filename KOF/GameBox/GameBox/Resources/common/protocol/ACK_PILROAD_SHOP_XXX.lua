
require "common/AcknowledgementMessage"

-- [39510]黑店物品信息块 -- 取经之路 

ACK_PILROAD_SHOP_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_SHOP_XXX
	self:init()
end)

-- {是否购买过(1：已购买过 | 0：没购买过)}
function ACK_PILROAD_SHOP_XXX.getIsBuy(self)
	return self.is_buy
end

-- {价格类型}
function ACK_PILROAD_SHOP_XXX.getPriceType(self)
	return self.price_type
end

-- {价格}
function ACK_PILROAD_SHOP_XXX.getPrice(self)
	return self.price
end

-- {物品信息块(2001)}
function ACK_PILROAD_SHOP_XXX.getMsgGood(self)
	return self.msg_good
end
