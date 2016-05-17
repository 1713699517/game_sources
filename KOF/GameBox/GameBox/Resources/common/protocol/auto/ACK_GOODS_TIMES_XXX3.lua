
require "common/AcknowledgementMessage"

-- [2335]元宵活动物品信息块 -- 物品/背包 

ACK_GOODS_TIMES_XXX3 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_TIMES_XXX3
	self:init()
end)

function ACK_GOODS_TIMES_XXX3.deserialize(self, reader)
	self.goods_id = reader:readInt16Unsigned() -- {}
	self.count = reader:readInt16Unsigned() -- {}
end

-- {}
function ACK_GOODS_TIMES_XXX3.getGoodsId(self)
	return self.goods_id
end

-- {}
function ACK_GOODS_TIMES_XXX3.getCount(self)
	return self.count
end
