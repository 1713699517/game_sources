
require "common/RequestMessage"

-- [8580]请求保存邮件 -- 邮件 


REQ_MAIL_SAVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAIL_SAVE
	self:init()
end)

function REQ_MAIL_SAVE.serialize(self, writer)
	writer:writeInt16Unsigned(self.count)
	writer:writeXXXGroup(self.mailids)
end

function REQ_MAIL_SAVE.setArguments(self,count,mailids)
	self.count = count
	self.mailids = mailids
end

function REQ_MAIL_SAVE.getcount(self, value)
	return self.count
end

function REQ_MAIL_SAVE.getmailids(self, value)
	return self.mailids
end
