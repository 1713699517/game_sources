
require "common/AcknowledgementMessage"

-- [2333]次数物品数据块 -- 物品/背包 

ACK_GOODS_TIMES_XXX1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_TIMES_XXX1
	self:init()
end)

function ACK_GOODS_TIMES_XXX1.deserialize(self, reader)
	self.goods_id = reader:readInt32Unsigned() -- {物品ID}
	self.count = reader:readInt16Unsigned() -- {已使用次数}
	self.cost_type = reader:readInt8Unsigned() -- {消耗货币类型}
	self.cost_value = reader:readInt32Unsigned() -- {消耗货币值}
	self.idx = reader:readInt16Unsigned() -- {物品索引}
	self.sum = reader:readInt16Unsigned() -- {物品总数}
end

-- {物品ID}
function ACK_GOODS_TIMES_XXX1.getGoodsId(self)
	return self.goods_id
end

-- {已使用次数}
function ACK_GOODS_TIMES_XXX1.getCount(self)
	return self.count
end

-- {消耗货币类型}
function ACK_GOODS_TIMES_XXX1.getCostType(self)
	return self.cost_type
end

-- {消耗货币值}
function ACK_GOODS_TIMES_XXX1.getCostValue(self)
	return self.cost_value
end

-- {物品索引}
function ACK_GOODS_TIMES_XXX1.getIdx(self)
	return self.idx
end

-- {物品总数}
function ACK_GOODS_TIMES_XXX1.getSum(self)
	return self.sum
end
