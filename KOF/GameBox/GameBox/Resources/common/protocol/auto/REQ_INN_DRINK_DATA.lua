
require "common/RequestMessage"

-- (手动) -- [31210]请求酒留仙 -- 客栈 

REQ_INN_DRINK_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_DRINK_DATA
	self:init()
end)
