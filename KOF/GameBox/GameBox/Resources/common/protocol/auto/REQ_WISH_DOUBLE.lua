
require "common/RequestMessage"

-- [10050]双倍信息 -- 祝福 

REQ_WISH_DOUBLE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WISH_DOUBLE
	self:init(0, nil)
end)
