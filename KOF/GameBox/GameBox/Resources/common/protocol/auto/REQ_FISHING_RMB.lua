
require "common/RequestMessage"

-- [18050]rmb收鱼 -- 活动-钓鱼达人 

REQ_FISHING_RMB = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FISHING_RMB
	self:init(0, nil)
end)
