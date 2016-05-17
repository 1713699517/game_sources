
require "common/RequestMessage"

-- [55960]重置挂机 -- 拳皇生涯 

REQ_FIGHTERS_UP_RESET = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FIGHTERS_UP_RESET
	self:init(0, nil)
end)
