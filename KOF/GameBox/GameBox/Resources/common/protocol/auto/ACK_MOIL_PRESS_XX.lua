
require "common/AcknowledgementMessage"

-- [35081]压榨分红 -- 苦工 

ACK_MOIL_PRESS_XX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_PRESS_XX
	self:init()
end)

function ACK_MOIL_PRESS_XX.deserialize(self, reader)
	self.name = reader:readString() -- {玩家姓名}
	self.exp = reader:readInt32Unsigned() -- {获得经验}
end

-- {玩家姓名}
function ACK_MOIL_PRESS_XX.getName(self)
	return self.name
end

-- {获得经验}
function ACK_MOIL_PRESS_XX.getExp(self)
	return self.exp
end
