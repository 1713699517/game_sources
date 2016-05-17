
require "common/RequestMessage"

-- (手动) -- [22960]宠物加寿命 -- 宠物 

REQ_PET_PLUS_LIFE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_PLUS_LIFE
	self:init()
end)

function REQ_PET_PLUS_LIFE.serialize(self, writer)
	writer:writeInt8Unsigned(self.pet_idx)  -- {宠物栏索引}
	writer:writeInt16Unsigned(self.bad_idx)  -- {背包索引}
end

function REQ_PET_PLUS_LIFE.setArguments(self,pet_idx,bad_idx)
	self.pet_idx = pet_idx  -- {宠物栏索引}
	self.bad_idx = bad_idx  -- {背包索引}
end

-- {宠物栏索引}
function REQ_PET_PLUS_LIFE.setPetIdx(self, pet_idx)
	self.pet_idx = pet_idx
end
function REQ_PET_PLUS_LIFE.getPetIdx(self)
	return self.pet_idx
end

-- {背包索引}
function REQ_PET_PLUS_LIFE.setBadIdx(self, bad_idx)
	self.bad_idx = bad_idx
end
function REQ_PET_PLUS_LIFE.getBadIdx(self)
	return self.bad_idx
end
