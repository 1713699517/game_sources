
require "common/AcknowledgementMessage"

-- (手动) -- [31160]招募成功 -- 客栈 

ACK_INN_RECRUIT_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_RECRUIT_OK
	self:init()
end)

function ACK_INN_RECRUIT_OK.deserialize(self, reader)
	self.partner_id = reader:readInt16Unsigned() -- {伙伴ID}
end

-- {伙伴ID}
function ACK_INN_RECRUIT_OK.getPartnerId(self)
	return self.partner_id
end
