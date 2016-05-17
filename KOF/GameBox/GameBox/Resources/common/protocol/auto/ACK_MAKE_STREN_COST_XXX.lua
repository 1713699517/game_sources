
require "common/AcknowledgementMessage"

-- [2518]强化消耗材料信息块 -- 物品/打造/强化 

ACK_MAKE_STREN_COST_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_STREN_COST_XXX
	self:init()
end)

function ACK_MAKE_STREN_COST_XXX.deserialize(self, reader)
	self.type = reader:readInt16Unsigned() -- {属性类型}
	self.type_value = reader:readInt16Unsigned() -- {属性值}
end

-- {属性类型}
function ACK_MAKE_STREN_COST_XXX.getType(self)
	return self.type
end

-- {属性值}
function ACK_MAKE_STREN_COST_XXX.getTypeValue(self)
	return self.type_value
end
