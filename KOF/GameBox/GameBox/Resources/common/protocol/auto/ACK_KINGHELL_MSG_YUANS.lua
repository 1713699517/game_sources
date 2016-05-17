
require "common/AcknowledgementMessage"

-- [44735]元神信息块 -- 阎王殿 

ACK_KINGHELL_MSG_YUANS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_MSG_YUANS
	self:init()
end)

function ACK_KINGHELL_MSG_YUANS.deserialize(self, reader)
	self.king_id = reader:readInt16Unsigned() -- {阎王id}
	self.num = reader:readInt16Unsigned() -- {元神数量}
end

-- {阎王id}
function ACK_KINGHELL_MSG_YUANS.getKingId(self)
	return self.king_id
end

-- {元神数量}
function ACK_KINGHELL_MSG_YUANS.getNum(self)
	return self.num
end
