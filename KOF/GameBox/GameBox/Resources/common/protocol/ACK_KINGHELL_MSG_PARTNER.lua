
require "common/AcknowledgementMessage"

-- [44660]挑战伙伴信息块 -- 阎王殿 

ACK_KINGHELL_MSG_PARTNER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_MSG_PARTNER
	self:init()
end)

-- {伙伴id}
function ACK_KINGHELL_MSG_PARTNER.getPartnerId(self)
	return self.partner_id
end

-- {类型(1:主角 2:伙伴)}
function ACK_KINGHELL_MSG_PARTNER.getType(self)
	return self.type
end

-- {是否出战}
function ACK_KINGHELL_MSG_PARTNER.getChoice(self)
	return self.choice
end
