
require "common/AcknowledgementMessage"

-- [44620]阎王列表返回 -- 阎王殿 

ACK_KINGHELL_BACK_KINGS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_BACK_KINGS
	self:init()
end)

-- {阎王数量}
function ACK_KINGHELL_BACK_KINGS.getCount(self)
	return self.count
end

-- {阎王信息块(44630)}
function ACK_KINGHELL_BACK_KINGS.getMsgKing(self)
	return self.msg_king
end
