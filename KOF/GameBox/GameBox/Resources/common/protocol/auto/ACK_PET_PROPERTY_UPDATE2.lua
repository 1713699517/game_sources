
require "common/AcknowledgementMessage"

-- (手动) -- [22930]宠物单个属性更新[字符串] -- 宠物 

ACK_PET_PROPERTY_UPDATE2 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_PROPERTY_UPDATE2
	self:init()
end)

function ACK_PET_PROPERTY_UPDATE2.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {详见常量:CONST_PET_ATTR_*}
	self.value = reader:readString() -- {新值}
end

-- {详见常量:CONST_PET_ATTR_*}
function ACK_PET_PROPERTY_UPDATE2.getType(self)
	return self.type
end

-- {新值}
function ACK_PET_PROPERTY_UPDATE2.getValue(self)
	return self.value
end
