
require "common/AcknowledgementMessage"

-- [22980]宠物栏开格成功 -- 宠物 

ACK_PET_CTN_ENLARGE_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_CTN_ENLARGE_OK
	self:init()
end)

function ACK_PET_CTN_ENLARGE_OK.deserialize(self, reader)
	self.usable = reader:readInt8Unsigned() -- {可用宠物栏数}
end

-- {可用宠物栏数}
function ACK_PET_CTN_ENLARGE_OK.getUsable(self)
	return self.usable
end
