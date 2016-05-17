
require "common/RequestMessage"

-- [7845]加速挂机 -- 副本 

REQ_COPY_UP_SPEED = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_UP_SPEED
	self:init(1 ,{ 7850,7860,700 })
end)
