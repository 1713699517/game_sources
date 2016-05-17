
require "common/RequestMessage"

-- [43530]报名 -- 跨服战 

REQ_STRIDE_REPORT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_REPORT
	self:init(0, nil)
end)
