
require "common/RequestMessage"

-- [7870]停止挂机 -- 副本 

REQ_COPY_UP_STOP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_UP_STOP
	self:init(0, nil)
end)
