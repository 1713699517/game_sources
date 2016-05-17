
require "common/AcknowledgementMessage"

-- (手动) -- [7680]NPC返回副本ID -- 副本 

ACK_COPY_RETURN_ID = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_RETURN_ID
	self:init()
end)

function ACK_COPY_RETURN_ID.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
end

-- {副本ID}
function ACK_COPY_RETURN_ID.getCopyId(self)
	return self.copy_id
end
