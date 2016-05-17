
require "common/RequestMessage"

-- (手动) -- [22990]宠物加体力 -- 宠物 

REQ_PET_PLUS_SP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_PLUS_SP
	self:init()
end)

function REQ_PET_PLUS_SP.serialize(self, writer)
	writer:writeInt8Unsigned(self.pet_idx)  -- {宠物栏索引}
	writer:writeInt16Unsigned(self.bad_idx)  -- {背包索引}
end

function REQ_PET_PLUS_SP.setArguments(self,pet_idx,bad_idx)
	self.pet_idx = pet_idx  -- {宠物栏索引}
	self.bad_idx = bad_idx  -- {背包索引}
end

-- {宠物栏索引}
function REQ_PET_PLUS_SP.setPetIdx(self, pet_idx)
	self.pet_idx = pet_idx
end
function REQ_PET_PLUS_SP.getPetIdx(self)
	return self.pet_idx
end

-- {背包索引}
function REQ_PET_PLUS_SP.setBadIdx(self, bad_idx)
	self.bad_idx = bad_idx
end
function REQ_PET_PLUS_SP.getBadIdx(self)
	return self.bad_idx
end
