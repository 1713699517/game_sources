
require "common/AcknowledgementMessage"

-- [55870]挂机返回 -- 拳皇生涯 

ACK_FIGHTERS_UP_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIGHTERS_UP_REPLY
	self:init()
end)

function ACK_FIGHTERS_UP_REPLY.deserialize(self, reader)
	self.chap_id = reader:readInt16Unsigned() -- {挂到这个章节}
	self.copy_id = reader:readInt16Unsigned() -- {挂机这个副本}
end

-- {挂到这个章节}
function ACK_FIGHTERS_UP_REPLY.getChapId(self)
	return self.chap_id
end

-- {挂机这个副本}
function ACK_FIGHTERS_UP_REPLY.getCopyId(self)
	return self.copy_id
end
