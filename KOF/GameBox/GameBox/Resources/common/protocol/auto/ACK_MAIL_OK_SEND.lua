
require "common/AcknowledgementMessage"

-- [8532]发送邮件成功 -- 邮件 

ACK_MAIL_OK_SEND = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAIL_OK_SEND
	self:init()
end)
