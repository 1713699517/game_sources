
require "common/AcknowledgementMessage"

-- [42528]虚拟货币信息块 -- 收集卡片 

ACK_COLLECT_CARD_XXX3 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COLLECT_CARD_XXX3
	self:init()
end)

function ACK_COLLECT_CARD_XXX3.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {货币类型}
	self.value = reader:readInt32Unsigned() -- {货币值}
end

-- {货币类型}
function ACK_COLLECT_CARD_XXX3.getType(self)
	return self.type
end

-- {货币值}
function ACK_COLLECT_CARD_XXX3.getValue(self)
	return self.value
end
