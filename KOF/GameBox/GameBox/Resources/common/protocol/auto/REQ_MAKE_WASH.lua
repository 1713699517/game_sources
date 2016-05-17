
require "common/RequestMessage"

-- [2530]装备洗练 -- 物品/打造/强化 

REQ_MAKE_WASH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_WASH
	self:init(0, nil)
end)

function REQ_MAKE_WASH.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1背包2装备栏}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt16Unsigned(self.idx)  -- {物品的idx}
	writer:writeInt8Unsigned(self.arg)  -- {洗练方式(常量定义)}
end

function REQ_MAKE_WASH.setArguments(self,type,id,idx,arg)
	self.type = type  -- {1背包2装备栏}
	self.id = id  -- {主将0|武将ID}
	self.idx = idx  -- {物品的idx}
	self.arg = arg  -- {洗练方式(常量定义)}
end

-- {1背包2装备栏}
function REQ_MAKE_WASH.setType(self, type)
	self.type = type
end
function REQ_MAKE_WASH.getType(self)
	return self.type
end

-- {主将0|武将ID}
function REQ_MAKE_WASH.setId(self, id)
	self.id = id
end
function REQ_MAKE_WASH.getId(self)
	return self.id
end

-- {物品的idx}
function REQ_MAKE_WASH.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAKE_WASH.getIdx(self)
	return self.idx
end

-- {洗练方式(常量定义)}
function REQ_MAKE_WASH.setArg(self, arg)
	self.arg = arg
end
function REQ_MAKE_WASH.getArg(self)
	return self.arg
end
