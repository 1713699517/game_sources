
require "common/AcknowledgementMessage"

-- [42526]物品信息块 -- 收集卡片 

ACK_COLLECT_CARD_XXX2 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COLLECT_CARD_XXX2
	self:init()
end)

function ACK_COLLECT_CARD_XXX2.deserialize(self, reader)
	self.goods_id = reader:readInt16Unsigned() -- {物品ID}
	self.count = reader:readInt16Unsigned() -- {物品数量}
end

-- {物品ID}
function ACK_COLLECT_CARD_XXX2.getGoodsId(self)
	return self.goods_id
end

-- {物品数量}
function ACK_COLLECT_CARD_XXX2.getCount(self)
	return self.count
end
