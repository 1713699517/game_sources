
require "common/AcknowledgementMessage"

-- [23890]返回结果 -- 逐鹿台 

ACK_ARENA_BUY_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_BUY_OK
	self:init()
end)

function ACK_ARENA_BUY_OK.deserialize(self, reader)
	self.scount = reader:readInt16Unsigned() -- {剩余次数}
end

-- {剩余次数}
function ACK_ARENA_BUY_OK.getScount(self)
	return self.scount
end
