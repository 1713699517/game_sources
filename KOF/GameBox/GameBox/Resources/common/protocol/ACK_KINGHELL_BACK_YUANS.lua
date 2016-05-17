
require "common/AcknowledgementMessage"

-- [44730]阎王元神返回 -- 阎王殿 

ACK_KINGHELL_BACK_YUANS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_BACK_YUANS
	self:init()
end)

-- {阎王数量}
function ACK_KINGHELL_BACK_YUANS.getCount(self)
	return self.count
end

-- {元神信息块(44735)}
function ACK_KINGHELL_BACK_YUANS.getMsgYuans(self)
	return self.msg_yuans
end
