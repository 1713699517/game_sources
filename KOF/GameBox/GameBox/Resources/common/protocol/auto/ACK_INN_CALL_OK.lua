
require "common/AcknowledgementMessage"

-- (手动) -- [31160]招募伙伴成功 -- 客栈 

ACK_INN_CALL_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_CALL_OK
	self:init()
end)
