
require "common/RequestMessage"

-- [44740]请求首次和最佳记录 -- 阎王殿 

REQ_KINGHELL_ASK_FIRBEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_KINGHELL_ASK_FIRBEST
	self:init(0, nil)
end)

function REQ_KINGHELL_ASK_FIRBEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.mons_id)  -- {怪物id}
end

function REQ_KINGHELL_ASK_FIRBEST.setArguments(self,mons_id)
	self.mons_id = mons_id  -- {怪物id}
end

-- {怪物id}
function REQ_KINGHELL_ASK_FIRBEST.setMonsId(self, mons_id)
	self.mons_id = mons_id
end
function REQ_KINGHELL_ASK_FIRBEST.getMonsId(self)
	return self.mons_id
end
