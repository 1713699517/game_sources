
require "common/RequestMessage"

-- (手动) -- [39555]请求文牒 -- 取经之路 

REQ_PILROAD_PLATE_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PILROAD_PLATE_ASK
	self:init()
end)
