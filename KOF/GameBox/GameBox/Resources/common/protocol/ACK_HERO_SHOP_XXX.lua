
require "common/AcknowledgementMessage"

-- [39510]黑店物品信息块 -- 英雄副本 

ACK_HERO_SHOP_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_SHOP_XXX
	self:init()
end)

function ACK_HERO_SHOP_XXX.deserialize(self, reader)
	self.is_buy = reader:readInt8Unsigned() -- {是否购买过(1：已购买过 | 0：没购买过)}
	self.price_type = reader:readInt8Unsigned() -- {价格类型}
	self.price = reader:readInt32Unsigned() -- {价格}
	self.msg_good = reader:readXXXGroup() -- {物品信息块(2001)}
end

-- {是否购买过(1：已购买过 | 0：没购买过)}
function ACK_HERO_SHOP_XXX.getIsBuy(self)
	return self.is_buy
end

-- {价格类型}
function ACK_HERO_SHOP_XXX.getPriceType(self)
	return self.price_type
end

-- {价格}
function ACK_HERO_SHOP_XXX.getPrice(self)
	return self.price
end

-- {物品信息块(2001)}
function ACK_HERO_SHOP_XXX.getMsgGood(self)
	return self.msg_good
end
