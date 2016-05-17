
require "common/RequestMessage"

-- (手动) -- [22890]宠物祭炼 -- 宠物 

REQ_PET_REFINE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_REFINE
	self:init()
end)

function REQ_PET_REFINE.serialize(self, writer)
	writer:writeInt8Unsigned(self.luck_num)  -- {祭炼符数量}
end

function REQ_PET_REFINE.setArguments(self,luck_num)
	self.luck_num = luck_num  -- {祭炼符数量}
end

-- {祭炼符数量}
function REQ_PET_REFINE.setLuckNum(self, luck_num)
	self.luck_num = luck_num
end
function REQ_PET_REFINE.getLuckNum(self)
	return self.luck_num
end
