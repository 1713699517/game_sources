
require "common/RequestMessage"

-- (手动) -- [55960]重置挂机 -- 拳皇生涯 

REQ_FIGHTERS_RESET_UP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FIGHTERS_RESET_UP
	self:init()
end)
