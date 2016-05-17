
require "common/AcknowledgementMessage"

-- (手动) -- [7740]第一次通关副本 -- 副本 

ACK_COPY_FIRST_OVER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_FIRST_OVER
	self:init()
end)

function ACK_COPY_FIRST_OVER.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
end

-- {副本ID}
function ACK_COPY_FIRST_OVER.getCopyId(self)
	return self.copy_id
end
