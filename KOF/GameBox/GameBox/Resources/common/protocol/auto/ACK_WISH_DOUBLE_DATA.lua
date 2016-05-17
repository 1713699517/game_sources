
require "common/AcknowledgementMessage"

-- [10052]双倍信息返回 -- 祝福 

ACK_WISH_DOUBLE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WISH_DOUBLE_DATA
	self:init()
end)

function ACK_WISH_DOUBLE_DATA.deserialize(self, reader)
	self.cost_type = reader:readInt16Unsigned() -- {花费类型}
	self.cost_value = reader:readInt16Unsigned() -- {花费值}
	self.exp = reader:readInt32Unsigned() -- {可领取经验}
end

-- {花费类型}
function ACK_WISH_DOUBLE_DATA.getCostType(self)
	return self.cost_type
end

-- {花费值}
function ACK_WISH_DOUBLE_DATA.getCostValue(self)
	return self.cost_value
end

-- {可领取经验}
function ACK_WISH_DOUBLE_DATA.getExp(self)
	return self.exp
end
