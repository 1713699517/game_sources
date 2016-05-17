
require "common/AcknowledgementMessage"

-- [44695]点亮心经成功 -- 阎王殿 

ACK_KINGHELL_XJ_UPDATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_XJ_UPDATE
	self:init()
end)

function ACK_KINGHELL_XJ_UPDATE.deserialize(self, reader)
	self.partnerid = reader:readInt32Unsigned() -- {伙伴id}
	self.king_id = reader:readInt16Unsigned() -- {心经id}
	self.lv = reader:readInt16Unsigned() -- {心经等级}
end

-- {伙伴id}
function ACK_KINGHELL_XJ_UPDATE.getPartnerid(self)
	return self.partnerid
end

-- {心经id}
function ACK_KINGHELL_XJ_UPDATE.getKingId(self)
	return self.king_id
end

-- {心经等级}
function ACK_KINGHELL_XJ_UPDATE.getLv(self)
	return self.lv
end
