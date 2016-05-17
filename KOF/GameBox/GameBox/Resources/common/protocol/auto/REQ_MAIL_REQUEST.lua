
require "common/RequestMessage"

-- [8510]请求邮件列表 -- 邮件 

REQ_MAIL_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAIL_REQUEST
	self:init(1 ,{ 8512,700 })
end)

function REQ_MAIL_REQUEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {邮箱类型(收件箱:0|发件箱:1|保存箱:2)}
end

function REQ_MAIL_REQUEST.setArguments(self,type)
	self.type = type  -- {邮箱类型(收件箱:0|发件箱:1|保存箱:2)}
end

-- {邮箱类型(收件箱:0|发件箱:1|保存箱:2)}
function REQ_MAIL_REQUEST.setType(self, type)
	self.type = type
end
function REQ_MAIL_REQUEST.getType(self)
	return self.type
end
