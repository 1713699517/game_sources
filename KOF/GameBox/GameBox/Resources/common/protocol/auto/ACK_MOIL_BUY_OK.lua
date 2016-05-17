
require "common/AcknowledgementMessage"

-- [35130]返回消耗信息 -- 苦工 

ACK_MOIL_BUY_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_BUY_OK
	self:init()
end)
