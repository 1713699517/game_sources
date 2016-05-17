
require "common/AcknowledgementMessage"

-- [8563]删除邮件信息块 -- 邮件 

ACK_MAIL_IDLIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAIL_IDLIST
	self:init()
end)

function ACK_MAIL_IDLIST.deserialize(self, reader)
	self.idlist = reader:readInt32Unsigned() -- {删除邮件信息块}
end

-- {删除邮件信息块}
function ACK_MAIL_IDLIST.getIdlist(self)
	return self.idlist
end
