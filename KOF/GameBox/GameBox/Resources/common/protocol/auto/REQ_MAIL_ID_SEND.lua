
require "common/RequestMessage"

-- [8501]发送的邮件ID -- 邮件 

REQ_MAIL_ID_SEND = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAIL_ID_SEND
	self:init(0, nil)
end)

function REQ_MAIL_ID_SEND.serialize(self, writer)
	writer:writeInt32Unsigned(self.mail_id)  -- {邮件ID协议块}
end

function REQ_MAIL_ID_SEND.setArguments(self,mail_id)
	self.mail_id = mail_id  -- {邮件ID协议块}
end

-- {邮件ID协议块}
function REQ_MAIL_ID_SEND.setMailId(self, mail_id)
	self.mail_id = mail_id
end
function REQ_MAIL_ID_SEND.getMailId(self)
	return self.mail_id
end
