
require "common/RequestMessage"

-- [32010]请求招财面板 -- 财神 

REQ_WEAGOD_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_REQUEST
	self:init(1 ,{ 32020,700 })
end)
