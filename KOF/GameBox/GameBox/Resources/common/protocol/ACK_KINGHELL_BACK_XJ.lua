
require "common/AcknowledgementMessage"

-- [44675]心经返回 -- 阎王殿 

ACK_KINGHELL_BACK_XJ = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_BACK_XJ
	self:init()
end)

-- {伙伴数量}
function ACK_KINGHELL_BACK_XJ.getCount(self)
	return self.count
end

-- {伙伴信息块(44680)}
function ACK_KINGHELL_BACK_XJ.getMsgXj(self)
	return self.msg_xj
end
