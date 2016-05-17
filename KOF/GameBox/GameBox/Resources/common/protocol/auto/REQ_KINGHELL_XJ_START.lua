
require "common/RequestMessage"

-- [44690]点亮心经境界 -- 阎王殿 

REQ_KINGHELL_XJ_START = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_KINGHELL_XJ_START
	self:init(0, nil)
end)

function REQ_KINGHELL_XJ_START.serialize(self, writer)
	writer:writeInt32Unsigned(self.partnerid)  -- {伙伴Id}
	writer:writeInt16Unsigned(self.king_id)  -- {心经Id}
	writer:writeInt16Unsigned(self.lv)  -- {点亮的等级}
end

function REQ_KINGHELL_XJ_START.setArguments(self,partnerid,king_id,lv)
	self.partnerid = partnerid  -- {伙伴Id}
	self.king_id = king_id  -- {心经Id}
	self.lv = lv  -- {点亮的等级}
end

-- {伙伴Id}
function REQ_KINGHELL_XJ_START.setPartnerid(self, partnerid)
	self.partnerid = partnerid
end
function REQ_KINGHELL_XJ_START.getPartnerid(self)
	return self.partnerid
end

-- {心经Id}
function REQ_KINGHELL_XJ_START.setKingId(self, king_id)
	self.king_id = king_id
end
function REQ_KINGHELL_XJ_START.getKingId(self)
	return self.king_id
end

-- {点亮的等级}
function REQ_KINGHELL_XJ_START.setLv(self, lv)
	self.lv = lv
end
function REQ_KINGHELL_XJ_START.getLv(self)
	return self.lv
end
