
require "common/RequestMessage"

-- [55890]停止挂机 -- 拳皇生涯 

REQ_FIGHTERS_UP_STOP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FIGHTERS_UP_STOP
	self:init(0, nil)
end)
