
require "common/AcknowledgementMessage"

-- [2536]附加属性数据块2 -- 物品/打造/强化 

ACK_MAKE_PLUS_MSG_XXX2 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_PLUS_MSG_XXX2
	self:init()
end)

-- {属性类型}
function ACK_MAKE_PLUS_MSG_XXX2.getType(self)
	return self. type
end

-- {属性颜色}
function ACK_MAKE_PLUS_MSG_XXX2.getColor	(self)
	return self.color	
end

-- {属性值}
function ACK_MAKE_PLUS_MSG_XXX2.getValue(self)
	return self.value
end

-- {最大属性值}
function ACK_MAKE_PLUS_MSG_XXX2.getMax(self)
	return self.max
end
