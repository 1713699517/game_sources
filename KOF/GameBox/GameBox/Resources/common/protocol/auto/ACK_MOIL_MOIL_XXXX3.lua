
require "common/AcknowledgementMessage"

-- [35064]苦工具体信息 -- 苦工 

ACK_MOIL_MOIL_XXXX3 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_MOIL_XXXX3
	self:init()
end)

function ACK_MOIL_MOIL_XXXX3.deserialize(self, reader)
	self.expn = reader:readInt32Unsigned() -- {可提取经验}
	self.time = reader:readInt32Unsigned() -- {剩余干活时间}
end

-- {可提取经验}
function ACK_MOIL_MOIL_XXXX3.getExpn(self)
	return self.expn
end

-- {剩余干活时间}
function ACK_MOIL_MOIL_XXXX3.getTime(self)
	return self.time
end
