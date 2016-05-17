
require "common/RequestMessage"

-- [2560]镶嵌宝石 -- 物品/打造/强化 

REQ_MAKE_PEARL_INSET = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_PEARL_INSET
	self:init(1 ,{ 2040,700,2561 })
end)

function REQ_MAKE_PEARL_INSET.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1背包2装备栏}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt16Unsigned(self.idx)  -- {物品的idx}
	writer:writeInt16Unsigned(self.pearl_type)  -- {宝石类型}
end

function REQ_MAKE_PEARL_INSET.setArguments(self,type,id,idx,pearl_type)
	self.type = type  -- {1背包2装备栏}
	self.id = id  -- {主将0|武将ID}
	self.idx = idx  -- {物品的idx}
	self.pearl_type = pearl_type  -- {宝石类型}
end

-- {1背包2装备栏}
function REQ_MAKE_PEARL_INSET.setType(self, type)
	self.type = type
end
function REQ_MAKE_PEARL_INSET.getType(self)
	return self.type
end

-- {主将0|武将ID}
function REQ_MAKE_PEARL_INSET.setId(self, id)
	self.id = id
end
function REQ_MAKE_PEARL_INSET.getId(self)
	return self.id
end

-- {物品的idx}
function REQ_MAKE_PEARL_INSET.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAKE_PEARL_INSET.getIdx(self)
	return self.idx
end

-- {宝石类型}
function REQ_MAKE_PEARL_INSET.setPearlType(self, pearl_type)
	self.pearl_type = pearl_type
end
function REQ_MAKE_PEARL_INSET.getPearlType(self)
	return self.pearl_type
end
