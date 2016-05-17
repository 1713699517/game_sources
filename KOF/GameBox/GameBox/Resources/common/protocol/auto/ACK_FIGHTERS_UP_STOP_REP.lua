
require "common/AcknowledgementMessage"

-- [55895]停止挂机返回 -- 拳皇生涯 

ACK_FIGHTERS_UP_STOP_REP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIGHTERS_UP_STOP_REP
	self:init()
end)
