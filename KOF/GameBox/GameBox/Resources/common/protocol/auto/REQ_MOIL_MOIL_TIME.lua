
require "common/RequestMessage"

-- [35090]打工时间到 -- 苦工 

REQ_MOIL_MOIL_TIME = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_MOIL_TIME
	self:init(0, nil)
end)
