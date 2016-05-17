
require "common/RequestMessage"

-- [22880]魔宠修炼 -- 宠物 

REQ_PET_XIULIAN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_XIULIAN
	self:init(1 ,{ 22885,700 })
end)

function REQ_PET_XIULIAN.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1，修炼；2，高级修炼}
end

function REQ_PET_XIULIAN.setArguments(self,type)
	self.type = type  -- {1，修炼；2，高级修炼}
end

-- {1，修炼；2，高级修炼}
function REQ_PET_XIULIAN.setType(self, type)
	self.type = type
end
function REQ_PET_XIULIAN.getType(self)
	return self.type
end
