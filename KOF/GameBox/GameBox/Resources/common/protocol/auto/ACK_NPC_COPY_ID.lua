
require "common/AcknowledgementMessage"

-- [26007]返回NPC副本ID -- NPC 

ACK_NPC_COPY_ID = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_NPC_COPY_ID
	self:init()
end)

function ACK_NPC_COPY_ID.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
end

-- {副本ID}
function ACK_NPC_COPY_ID.getCopyId(self)
	return self.copy_id
end
