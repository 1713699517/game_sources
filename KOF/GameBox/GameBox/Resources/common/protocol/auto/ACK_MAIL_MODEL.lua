
require "common/AcknowledgementMessage"

-- [8513]邮件模块 -- 邮件 

ACK_MAIL_MODEL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAIL_MODEL
	self:init()
end)

function ACK_MAIL_MODEL.deserialize(self, reader)
	self.mail_id = reader:readInt32Unsigned() -- {邮件ID}
	self.mtype = reader:readInt8Unsigned() -- {邮件类型(系统:0|私人:1)}
	self.name = reader:readString() -- {名字}
	self.title = reader:readString() -- {标题}
	self.date = reader:readInt32Unsigned() -- {发送日期}
	self.state = reader:readInt8Unsigned() -- {邮件状态(未读:0|已读:1)}
	self.pick = reader:readInt8Unsigned() -- {附件是否提取(无附件:0|未提取:1|已提取:2)}
end

-- {邮件ID}
function ACK_MAIL_MODEL.getMailId(self)
	return self.mail_id
end

-- {邮件类型(系统:0|私人:1)}
function ACK_MAIL_MODEL.getMtype(self)
	return self.mtype
end

-- {名字}
function ACK_MAIL_MODEL.getName(self)
	return self.name
end

-- {标题}
function ACK_MAIL_MODEL.getTitle(self)
	return self.title
end

-- {发送日期}
function ACK_MAIL_MODEL.getDate(self)
	return self.date
end

-- {邮件状态(未读:0|已读:1)}
function ACK_MAIL_MODEL.getState(self)
	return self.state
end

-- {附件是否提取(无附件:0|未提取:1|已提取:2)}
function ACK_MAIL_MODEL.getPick(self)
	return self.pick
end
