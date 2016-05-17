
require "common/RequestMessage"

-- [32030]招财 -- 财神 

REQ_WEAGOD_GET_MONEY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_GET_MONEY
	self:init(1 ,{ 700,32060 })
end)
