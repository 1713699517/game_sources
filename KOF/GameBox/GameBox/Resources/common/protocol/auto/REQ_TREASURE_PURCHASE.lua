
require "common/RequestMessage"

-- [47290]请求购买 -- 珍宝阁系统 

REQ_TREASURE_PURCHASE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_PURCHASE
	self:init(1 ,{ 47300,700 })
end)

function REQ_TREASURE_PURCHASE.serialize(self, writer)
	writer:writeInt32Unsigned(self.goods_id)  -- {物品id}
end

function REQ_TREASURE_PURCHASE.setArguments(self,goods_id)
	self.goods_id = goods_id  -- {物品id}
end

-- {物品id}
function REQ_TREASURE_PURCHASE.setGoodsId(self, goods_id)
	self.goods_id = goods_id
end
function REQ_TREASURE_PURCHASE.getGoodsId(self)
	return self.goods_id
end
