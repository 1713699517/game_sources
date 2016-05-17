
require "common/RequestMessage"

-- [50210]请求剩余次数 -- 风林山火 

REQ_FLSH_TIMES_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FLSH_TIMES_REQUEST
	self:init(0 ,{ 50200,700 })
end)
