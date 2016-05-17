
require "common/RequestMessage"

-- (手动) -- [39515]购买黑店物品 -- 取经之路 

REQ_PILROAD_SHOP_BUY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PILROAD_SHOP_BUY
	self:init()
end)

function REQ_PILROAD_SHOP_BUY.serialize(self, writer)
	writer:writeInt32Unsigned(self.goods_id)  -- {物品Id}
	writer:writeInt16Unsigned(self.count)  -- {物品数量}
end

function REQ_PILROAD_SHOP_BUY.setArguments(self,goods_id,count)
	self.goods_id = goods_id  -- {物品Id}
	self.count = count  -- {物品数量}
end

-- {物品Id}
function REQ_PILROAD_SHOP_BUY.setGoodsId(self, goods_id)
	self.goods_id = goods_id
end
function REQ_PILROAD_SHOP_BUY.getGoodsId(self)
	return self.goods_id
end

-- {物品数量}
function REQ_PILROAD_SHOP_BUY.setCount(self, count)
	self.count = count
end
function REQ_PILROAD_SHOP_BUY.getCount(self)
	return self.count
end
