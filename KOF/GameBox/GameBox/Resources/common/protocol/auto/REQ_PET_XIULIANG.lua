
require "common/RequestMessage"

-- (手动) -- [22880]式神修炼 -- 宠物 

REQ_PET_XIULIANG = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_XIULIANG
	self:init()
end)

function REQ_PET_XIULIANG.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1，修炼；2，高级修炼}
	writer:writeInt16Unsigned(self.id)  -- {式神id}
end

function REQ_PET_XIULIANG.setArguments(self,type,id)
	self.type = type  -- {1，修炼；2，高级修炼}
	self.id = id  -- {式神id}
end

-- {1，修炼；2，高级修炼}
function REQ_PET_XIULIANG.setType(self, type)
	self.type = type
end
function REQ_PET_XIULIANG.getType(self)
	return self.type
end

-- {式神id}
function REQ_PET_XIULIANG.setId(self, id)
	self.id = id
end
function REQ_PET_XIULIANG.getId(self)
	return self.id
end
