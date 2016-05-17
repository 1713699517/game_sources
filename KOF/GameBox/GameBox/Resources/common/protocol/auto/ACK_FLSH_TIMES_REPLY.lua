
require "common/AcknowledgementMessage"

-- [50220]剩余次数返回 -- 风林山火 

ACK_FLSH_TIMES_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FLSH_TIMES_REPLY
	self:init()
end)

function ACK_FLSH_TIMES_REPLY.deserialize(self, reader)
	self.times = reader:readInt16Unsigned() -- {剩余次数}
	self.is_get = reader:readInt8Unsigned() -- {是否领取(0:没领取|1:已领取)}
end

-- {剩余次数}
function ACK_FLSH_TIMES_REPLY.getTimes(self)
	return self.times
end

-- {是否领取(0:没领取|1:已领取)}
function ACK_FLSH_TIMES_REPLY.getIsGet(self)
	return self.is_get
end
