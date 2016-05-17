
require "common/AcknowledgementMessage"

-- [2006]基础信息块 -- 物品/背包 

ACK_GOODS_ATTR_BASE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_ATTR_BASE
	self:init()
end)

function ACK_GOODS_ATTR_BASE.deserialize(self, reader)
	self.attr_base_type = reader:readInt16Unsigned() -- {基础属性类型}
	self.attr_base_value = reader:readInt32Unsigned() -- {基础属性数值}
end

-- {基础属性类型}
function ACK_GOODS_ATTR_BASE.getAttrBaseType(self)
	return self.attr_base_type
end

-- {基础属性数值}
function ACK_GOODS_ATTR_BASE.getAttrBaseValue(self)
	return self.attr_base_value
end
