
require "common/AcknowledgementMessage"

-- [53240]开通新手特权成功 -- 新手特权 

ACK_PRIVILEGE_OPEN_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PRIVILEGE_OPEN_REPLY
	self:init()
end)
