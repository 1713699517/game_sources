
require "common/RequestMessage"

-- [2580]法宝拆分 -- 物品/打造/强化 

REQ_MAKE_MAGIC_PART = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_MAGIC_PART
	self:init(0, nil)
end)

function REQ_MAKE_MAGIC_PART.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1背包2装备栏}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt16Unsigned(self.idx)  -- {idx}
end

function REQ_MAKE_MAGIC_PART.setArguments(self,type,id,idx)
	self.type = type  -- {1背包2装备栏}
	self.id = id  -- {主将0|武将ID}
	self.idx = idx  -- {idx}
end

-- {1背包2装备栏}
function REQ_MAKE_MAGIC_PART.setType(self, type)
	self.type = type
end
function REQ_MAKE_MAGIC_PART.getType(self)
	return self.type
end

-- {主将0|武将ID}
function REQ_MAKE_MAGIC_PART.setId(self, id)
	self.id = id
end
function REQ_MAKE_MAGIC_PART.getId(self)
	return self.id
end

-- {idx}
function REQ_MAKE_MAGIC_PART.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAKE_MAGIC_PART.getIdx(self)
	return self.idx
end
