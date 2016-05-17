
require "common/RequestMessage"

-- (手动) -- [22940]宠物进阶 -- 宠物 

REQ_PET_STEPS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_STEPS
	self:init()
end)

function REQ_PET_STEPS.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {进阶类型（3种）}
end

function REQ_PET_STEPS.setArguments(self,type)
	self.type = type  -- {进阶类型（3种）}
end

-- {进阶类型（3种）}
function REQ_PET_STEPS.setType(self, type)
	self.type = type
end
function REQ_PET_STEPS.getType(self)
	return self.type
end
