
require "common/AcknowledgementMessage"

-- [44735]元神信息块 -- 阎王殿 

ACK_KINGHELL_MSG_YUANS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_MSG_YUANS
	self:init()
end)

-- {阎王id}
function ACK_KINGHELL_MSG_YUANS.getKingId(self)
	return self.king_id
end

-- {元神数量}
function ACK_KINGHELL_MSG_YUANS.getNum(self)
	return self.num
end
