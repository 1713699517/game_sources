
require "common/AcknowledgementMessage"

-- (手动) -- [7770]第一次杀怪 -- 副本 

ACK_COPY_FIRST_KILL_MONS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_FIRST_KILL_MONS
	self:init()
end)
