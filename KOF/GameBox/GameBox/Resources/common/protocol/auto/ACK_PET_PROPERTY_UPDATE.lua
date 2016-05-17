
require "common/AcknowledgementMessage"

-- (手动) -- [22920]宠物单个属性更新 -- 宠物 

ACK_PET_PROPERTY_UPDATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_PROPERTY_UPDATE
	self:init()
end)

function ACK_PET_PROPERTY_UPDATE.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {详见常量:CONST_PET_ATTR_*}
	self.value = reader:readInt32Unsigned() -- {新值}
end

-- {详见常量:CONST_PET_ATTR_*}
function ACK_PET_PROPERTY_UPDATE.getType(self)
	return self.type
end

-- {新值}
function ACK_PET_PROPERTY_UPDATE.getValue(self)
	return self.value
end
