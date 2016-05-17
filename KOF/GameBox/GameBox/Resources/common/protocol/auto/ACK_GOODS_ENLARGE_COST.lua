
require "common/AcknowledgementMessage"

-- [2227]扩充需要的道具数量 -- 物品/背包 

ACK_GOODS_ENLARGE_COST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_ENLARGE_COST
	self:init()
end)

function ACK_GOODS_ENLARGE_COST.deserialize(self, reader)
	self.goods_id = reader:readInt32Unsigned() -- {物品id}
	self.count = reader:readInt16Unsigned() -- {需要消耗道具数}
	self.enlargh_c = reader:readInt16Unsigned() -- {已扩充次数}
end

-- {物品id}
function ACK_GOODS_ENLARGE_COST.getGoodsId(self)
	return self.goods_id
end

-- {需要消耗道具数}
function ACK_GOODS_ENLARGE_COST.getCount(self)
	return self.count
end

-- {已扩充次数}
function ACK_GOODS_ENLARGE_COST.getEnlarghC(self)
	return self.enlargh_c
end
