
require "common/AcknowledgementMessage"

-- [45630]各种倒计时 -- 活动-阵营战 

ACK_CAMPWAR_D_TIME = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_D_TIME
	self:init()
end)

function ACK_CAMPWAR_D_TIME.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {类型：}
	self.value = reader:readInt16Unsigned() -- {数值}
end

-- {类型：}
function ACK_CAMPWAR_D_TIME.getType(self)
	return self.type
end

-- {数值}
function ACK_CAMPWAR_D_TIME.getValue(self)
	return self.value
end
