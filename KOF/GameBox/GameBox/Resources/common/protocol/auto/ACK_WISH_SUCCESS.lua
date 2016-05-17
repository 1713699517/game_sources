
require "common/AcknowledgementMessage"

-- [10010]祝福成功 -- 祝福 

ACK_WISH_SUCCESS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WISH_SUCCESS
	self:init()
end)

function ACK_WISH_SUCCESS.deserialize(self, reader)
	self.exp = reader:readInt32Unsigned() -- {经验}
end

-- {经验}
function ACK_WISH_SUCCESS.getExp(self)
	return self.exp
end
