
require "common/RequestMessage"

-- [2336]检查特定活动物品是否可使用 -- 物品/背包 

REQ_GOODS_ACTY_USE_CHECK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_ACTY_USE_CHECK
	self:init(1 ,{ 2338,700 })
end)

function REQ_GOODS_ACTY_USE_CHECK.serialize(self, writer)
	writer:writeInt32Unsigned(self.goods_id)  -- {物品ID}
end

function REQ_GOODS_ACTY_USE_CHECK.setArguments(self,goods_id)
	self.goods_id = goods_id  -- {物品ID}
end

-- {物品ID}
function REQ_GOODS_ACTY_USE_CHECK.setGoodsId(self, goods_id)
	self.goods_id = goods_id
end
function REQ_GOODS_ACTY_USE_CHECK.getGoodsId(self)
	return self.goods_id
end
