
require "common/RequestMessage"

-- [8530]请求发送邮件 -- 邮件 

REQ_MAIL_SEND = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAIL_SEND
	self:init(1 ,{ 8532,700 })
end)

function REQ_MAIL_SEND.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {玩家uid(无则发0)}
	writer:writeString(self.recv_name)  -- {收件人姓名}
	writer:writeString(self.title)  -- {邮件标题}
	writer:writeUTF(self.content)  -- {邮件内容}
end

function REQ_MAIL_SEND.setArguments(self,uid,recv_name,title,content)
	self.uid = uid  -- {玩家uid(无则发0)}
	self.recv_name = recv_name  -- {收件人姓名}
	self.title = title  -- {邮件标题}
	self.content = content  -- {邮件内容}
end

-- {玩家uid(无则发0)}
function REQ_MAIL_SEND.setUid(self, uid)
	self.uid = uid
end
function REQ_MAIL_SEND.getUid(self)
	return self.uid
end

-- {收件人姓名}
function REQ_MAIL_SEND.setRecvName(self, recv_name)
	self.recv_name = recv_name
end
function REQ_MAIL_SEND.getRecvName(self)
	return self.recv_name
end

-- {邮件标题}
function REQ_MAIL_SEND.setTitle(self, title)
	self.title = title
end
function REQ_MAIL_SEND.getTitle(self)
	return self.title
end

-- {邮件内容}
function REQ_MAIL_SEND.setContent(self, content)
	self.content = content
end
function REQ_MAIL_SEND.getContent(self)
	return self.content
end
