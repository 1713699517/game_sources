
require "common/RequestMessage"

-- [8501]发送的邮件ID -- 邮件 


REQ_MAIL_ID_SEND = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAIL_ID_SEND
	self:init()
end)

function REQ_MAIL_ID_SEND.serialize(self, writer)
	writer:writeInt32Unsigned(self.mail_id)
end

function REQ_MAIL_ID_SEND.setArguments(self,mail_id)
	self.mail_id = mail_id
end

function REQ_MAIL_ID_SEND.getmailId(self, value)
	return self.mail_id
end
