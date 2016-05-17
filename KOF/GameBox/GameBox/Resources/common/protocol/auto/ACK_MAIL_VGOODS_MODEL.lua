
require "common/AcknowledgementMessage"

-- [8543]虚拟物品协议块 -- 邮件 

ACK_MAIL_VGOODS_MODEL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAIL_VGOODS_MODEL
	self:init()
end)

function ACK_MAIL_VGOODS_MODEL.deserialize(self, reader)
	self.type1 = reader:readInt8Unsigned() -- {虚拟物品类型}
	self.count = reader:readInt32Unsigned() -- {数量}
end

-- {虚拟物品类型}
function ACK_MAIL_VGOODS_MODEL.getType1(self)
	return self.type1
end

-- {数量}
function ACK_MAIL_VGOODS_MODEL.getCount(self)
	return self.count
end
