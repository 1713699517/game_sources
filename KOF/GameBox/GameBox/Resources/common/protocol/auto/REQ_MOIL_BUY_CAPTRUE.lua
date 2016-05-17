
require "common/RequestMessage"

-- [35120]购买抓捕次数 -- 苦工 

REQ_MOIL_BUY_CAPTRUE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_BUY_CAPTRUE
	self:init(0, nil)
end)
