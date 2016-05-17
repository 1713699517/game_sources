
require "common/AcknowledgementMessage"

-- [43535]报名成功 -- 跨服战 

ACK_STRIDE_REPROT_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_REPROT_OK
	self:init()
end)
