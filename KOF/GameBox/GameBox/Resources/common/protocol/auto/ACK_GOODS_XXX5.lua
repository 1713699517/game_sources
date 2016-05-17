
require "common/AcknowledgementMessage"

-- [2005]插槽属性块 -- 物品/背包 

ACK_GOODS_XXX5 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_XXX5
	self:init()
end)

function ACK_GOODS_XXX5.deserialize(self, reader)
	self.slot_attr_type = reader:readInt8Unsigned() -- {插槽属性类型}
	self.slot_attr_value = reader:readInt32Unsigned() -- {插槽属性值}
end

-- {插槽属性类型}
function ACK_GOODS_XXX5.getSlotAttrType(self)
	return self.slot_attr_type
end

-- {插槽属性值}
function ACK_GOODS_XXX5.getSlotAttrValue(self)
	return self.slot_attr_value
end
