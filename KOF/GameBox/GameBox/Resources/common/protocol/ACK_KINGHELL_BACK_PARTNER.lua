
require "common/AcknowledgementMessage"

-- [44655]挑战伙伴返回 -- 阎王殿 

ACK_KINGHELL_BACK_PARTNER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_BACK_PARTNER
	self:init()
end)

-- {伙伴数量}
function ACK_KINGHELL_BACK_PARTNER.getCount(self)
	return self.count
end

-- {挑战伙伴信息块(44660)}
function ACK_KINGHELL_BACK_PARTNER.getMsgPartner(self)
	return self.msg_partner
end
