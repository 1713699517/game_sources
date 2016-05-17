
require "common/AcknowledgementMessage"

-- [55880]挂机完成 -- 拳皇生涯 

ACK_FIGHTERS_UP_OVER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIGHTERS_UP_OVER
	self:init()
end)
