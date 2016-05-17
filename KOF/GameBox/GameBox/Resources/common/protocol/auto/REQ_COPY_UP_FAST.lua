
require "common/RequestMessage"

-- (手动) -- [7845]加速挂机 -- 副本 

REQ_COPY_UP_FAST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_UP_FAST
	self:init()
end)
