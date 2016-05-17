
require "common/RequestMessage"

-- (手动) -- [32030]自己上香 -- 财神 

REQ_WEAGOD_CENSE_MYSELF = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_CENSE_MYSELF
	self:init()
end)
