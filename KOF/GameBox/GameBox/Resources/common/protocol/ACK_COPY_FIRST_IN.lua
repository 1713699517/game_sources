
require "common/AcknowledgementMessage"

-- (手动) -- [7730]第一次进入副本 -- 副本 

ACK_COPY_FIRST_IN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_FIRST_IN
	self:init()
end)

function ACK_COPY_FIRST_IN.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
end

-- {副本ID}
function ACK_COPY_FIRST_IN.getCopyId(self)
	return self.copy_id
end
