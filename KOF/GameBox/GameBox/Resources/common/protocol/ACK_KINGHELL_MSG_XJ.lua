
require "common/AcknowledgementMessage"

-- [44680]伙伴心经信息块 -- 阎王殿 

ACK_KINGHELL_MSG_XJ = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_MSG_XJ
	self:init()
end)

-- {伙伴id}
function ACK_KINGHELL_MSG_XJ.getPartnerId(self)
	return self.partner_id
end

-- {心经数量}
function ACK_KINGHELL_MSG_XJ.getXjCount(self)
	return self.xj_count
end

-- {心经信息块(44685)}
function ACK_KINGHELL_MSG_XJ.getMsgPXj(self)
	return self.msg_p_xj
end
