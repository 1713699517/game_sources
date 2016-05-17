
require "common/AcknowledgementMessage"

-- [34501]店铺物品信息块 -- 商城 

ACK_SHOP_XXX1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOP_XXX1
	self:init()
end)

-- {物品数据索引}
function ACK_SHOP_XXX1.getIdx(self)
	return self.idx
end

-- {信息块2001}
function ACK_SHOP_XXX1.getMsgXxx(self)
	return self.msg_xxx
end

-- {价格类型}
function ACK_SHOP_XXX1.getType(self)
	return self.type
end

-- {物品原价}
function ACK_SHOP_XXX1.getOPrice(self)
	return self.o_price
end

-- {物品现价}
function ACK_SHOP_XXX1.getSPrice(self)
	return self.s_price
end

-- {剩余总数量}
function ACK_SHOP_XXX1.getTotalRemaiderNum(self)
	return self.total_remaider_num
end
