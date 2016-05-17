
require "common/RequestMessage"

-- [8540]请求读取邮件 -- 邮件 

REQ_MAIL_READ = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAIL_READ
	self:init(1 ,{ 8542,700 })
end)

function REQ_MAIL_READ.serialize(self, writer)
	writer:writeInt32Unsigned(self.mail_id)  -- {要读取的邮件id}
end

function REQ_MAIL_READ.setArguments(self,mail_id)
	self.mail_id = mail_id  -- {要读取的邮件id}
end

-- {要读取的邮件id}
function REQ_MAIL_READ.setMailId(self, mail_id)
	self.mail_id = mail_id
end
function REQ_MAIL_READ.getMailId(self)
	return self.mail_id
end
