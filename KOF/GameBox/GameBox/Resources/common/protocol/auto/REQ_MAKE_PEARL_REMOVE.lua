
require "common/RequestMessage"

-- [2570]拆除灵珠 -- 物品/打造/强化 

REQ_MAKE_PEARL_REMOVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_PEARL_REMOVE
	self:init(0, nil)
end)

function REQ_MAKE_PEARL_REMOVE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1背包2装备栏}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt16Unsigned(self.idx)  -- {物品的idx}
	writer:writeInt32Unsigned(self.pearlid)  -- {灵珠ID}
end

function REQ_MAKE_PEARL_REMOVE.setArguments(self,type,id,idx,pearlid)
	self.type = type  -- {1背包2装备栏}
	self.id = id  -- {主将0|武将ID}
	self.idx = idx  -- {物品的idx}
	self.pearlid = pearlid  -- {灵珠ID}
end

-- {1背包2装备栏}
function REQ_MAKE_PEARL_REMOVE.setType(self, type)
	self.type = type
end
function REQ_MAKE_PEARL_REMOVE.getType(self)
	return self.type
end

-- {主将0|武将ID}
function REQ_MAKE_PEARL_REMOVE.setId(self, id)
	self.id = id
end
function REQ_MAKE_PEARL_REMOVE.getId(self)
	return self.id
end

-- {物品的idx}
function REQ_MAKE_PEARL_REMOVE.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAKE_PEARL_REMOVE.getIdx(self)
	return self.idx
end

-- {灵珠ID}
function REQ_MAKE_PEARL_REMOVE.setPearlid(self, pearlid)
	self.pearlid = pearlid
end
function REQ_MAKE_PEARL_REMOVE.getPearlid(self)
	return self.pearlid
end
