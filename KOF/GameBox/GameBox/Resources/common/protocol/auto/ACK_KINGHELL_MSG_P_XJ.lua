
require "common/AcknowledgementMessage"

-- [44685]心经信息块 -- 阎王殿 

ACK_KINGHELL_MSG_P_XJ = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_MSG_P_XJ
	self:init()
end)

function ACK_KINGHELL_MSG_P_XJ.deserialize(self, reader)
	self.king_id = reader:readInt16Unsigned() -- {心经id}
	self.king_lv = reader:readInt16Unsigned() -- {心经境界}
end

-- {心经id}
function ACK_KINGHELL_MSG_P_XJ.getKingId(self)
	return self.king_id
end

-- {心经境界}
function ACK_KINGHELL_MSG_P_XJ.getKingLv(self)
	return self.king_lv
end
