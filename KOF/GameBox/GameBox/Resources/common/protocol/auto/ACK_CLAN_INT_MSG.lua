
require "common/AcknowledgementMessage"

-- [33028]int数据块 -- 社团 

ACK_CLAN_INT_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_INT_MSG
	self:init()
end)

function ACK_CLAN_INT_MSG.deserialize(self, reader)
	self.value = reader:readInt32Unsigned() -- {数值}
end

-- {数值}
function ACK_CLAN_INT_MSG.getValue(self)
	return self.value
end
