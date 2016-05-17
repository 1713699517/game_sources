
require "common/RequestMessage"

-- [32050]自动招财 -- 财神 

REQ_WEAGOD_AUTO_GET = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_AUTO_GET
	self:init(0, nil)
end)
