
require "common/AcknowledgementMessage"

-- [22875]修炼需要钻石返回 -- 宠物 

ACK_PET_NEED_RMB_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_NEED_RMB_REPLY
	self:init()
end)

function ACK_PET_NEED_RMB_REPLY.deserialize(self, reader)
	self.rmb = reader:readInt16Unsigned() -- {钻石数}
end

-- {钻石数}
function ACK_PET_NEED_RMB_REPLY.getRmb(self)
	return self.rmb
end
