
require "common/AcknowledgementMessage"

-- [55850]购买挑战次数成功 -- 拳皇生涯 

ACK_FIGHTERS_BUY_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIGHTERS_BUY_OK
	self:init()
end)

function ACK_FIGHTERS_BUY_OK.deserialize(self, reader)
	self.times = reader:readInt16Unsigned() -- {当前剩余挑战次数}
end

-- {当前剩余挑战次数}
function ACK_FIGHTERS_BUY_OK.getTimes(self)
	return self.times
end
