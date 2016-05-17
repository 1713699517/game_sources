
require "common/RequestMessage"

-- (手动) -- [22910]宠物重命名 -- 宠物 

REQ_PET_CHANGE_NAME = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_CHANGE_NAME
	self:init()
end)

function REQ_PET_CHANGE_NAME.serialize(self, writer)
	writer:writeInt8Unsigned(self.idx)  -- {宠物栏索引}
	writer:writeString(self.name)  -- {宠物名}
end

function REQ_PET_CHANGE_NAME.setArguments(self,idx,name)
	self.idx = idx  -- {宠物栏索引}
	self.name = name  -- {宠物名}
end

-- {宠物栏索引}
function REQ_PET_CHANGE_NAME.setIdx(self, idx)
	self.idx = idx
end
function REQ_PET_CHANGE_NAME.getIdx(self)
	return self.idx
end

-- {宠物名}
function REQ_PET_CHANGE_NAME.setName(self, name)
	self.name = name
end
function REQ_PET_CHANGE_NAME.getName(self)
	return self.name
end
