
require "common/AcknowledgementMessage"

-- [22950]幻化成功返回 -- 宠物 

ACK_PET_HUANHUA_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_HUANHUA_REPLY
	self:init()
end)

function ACK_PET_HUANHUA_REPLY.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {1为成幻化2为失败}
end

-- {1为成幻化2为失败}
function ACK_PET_HUANHUA_REPLY.getType(self)
	return self.type
end
