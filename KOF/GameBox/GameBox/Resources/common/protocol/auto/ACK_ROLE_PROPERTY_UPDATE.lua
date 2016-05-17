
require "common/AcknowledgementMessage"

-- [1130]玩家单个属性更新 -- 角色 

ACK_ROLE_PROPERTY_UPDATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_PROPERTY_UPDATE
	self:init()
end)

function ACK_ROLE_PROPERTY_UPDATE.deserialize(self, reader)
	self.id = reader:readInt32Unsigned() -- {0:玩家|伙伴ID}
	self.type = reader:readInt8Unsigned() -- {详见:通用常量--玩家属性}
	self.value = reader:readInt32Unsigned() -- {新值}
end

-- {0:玩家|伙伴ID}
function ACK_ROLE_PROPERTY_UPDATE.getId(self)
	return self.id
end

-- {详见:通用常量--玩家属性}
function ACK_ROLE_PROPERTY_UPDATE.getType(self)
	return self.type
end

-- {新值}
function ACK_ROLE_PROPERTY_UPDATE.getValue(self)
	return self.value
end
