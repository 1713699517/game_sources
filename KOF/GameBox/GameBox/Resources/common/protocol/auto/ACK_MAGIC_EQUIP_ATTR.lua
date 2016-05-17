
require "common/AcknowledgementMessage"

-- [52320]属性值 -- 神器 

ACK_MAGIC_EQUIP_ATTR = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAGIC_EQUIP_ATTR
	self:init()
end)

function ACK_MAGIC_EQUIP_ATTR.deserialize(self, reader)
	self.type = reader:readInt16Unsigned() -- {属性类型}
	self.type_value = reader:readInt16Unsigned() -- {属性值}
end

-- {属性类型}
function ACK_MAGIC_EQUIP_ATTR.getType(self)
	return self.type
end

-- {属性值}
function ACK_MAGIC_EQUIP_ATTR.getTypeValue(self)
	return self.type_value
end
