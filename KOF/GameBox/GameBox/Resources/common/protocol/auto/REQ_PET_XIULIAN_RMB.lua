
require "common/RequestMessage"

-- (手动) -- [22870]修炼还需要的钻石数 -- 宠物 

REQ_PET_XIULIAN_RMB = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_XIULIAN_RMB
	self:init()
end)

function REQ_PET_XIULIAN_RMB.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1，修炼；2，高级修炼}
end

function REQ_PET_XIULIAN_RMB.setArguments(self,type)
	self.type = type  -- {1，修炼；2，高级修炼}
end

-- {1，修炼；2，高级修炼}
function REQ_PET_XIULIAN_RMB.setType(self, type)
	self.type = type
end
function REQ_PET_XIULIAN_RMB.getType(self)
	return self.type
end
