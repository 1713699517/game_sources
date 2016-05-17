
require "common/RequestMessage"

-- [32040]批量招财 -- 财神 

REQ_WEAGOD_PL_MONEY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_PL_MONEY
	self:init(1 ,{ 700,32060 })
end)
