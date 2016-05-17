
require "common/AcknowledgementMessage"

-- [35022]互动保护剩余时间 -- 苦工 

ACK_MOIL_PROTECT_TIME = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_PROTECT_TIME
	self:init()
end)

function ACK_MOIL_PROTECT_TIME.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {苦工Uid}
	self.time = reader:readInt32Unsigned() -- {保护剩余秒数}
end

-- {苦工Uid}
function ACK_MOIL_PROTECT_TIME.getUid(self)
	return self.uid
end

-- {保护剩余秒数}
function ACK_MOIL_PROTECT_TIME.getTime(self)
	return self.time
end
