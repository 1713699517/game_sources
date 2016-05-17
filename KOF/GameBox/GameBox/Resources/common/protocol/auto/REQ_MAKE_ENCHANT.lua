
require "common/RequestMessage"

-- [2590]装备附魔 -- 物品/打造/强化 

REQ_MAKE_ENCHANT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_ENCHANT
	self:init(1 ,{ 2600,700 })
end)

function REQ_MAKE_ENCHANT.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1背包2装备栏}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt8Unsigned(self.idx)  -- {物品idx}
	writer:writeInt8Unsigned(self.arg)  -- {1:金元附魔 0:普通附魔}
end

function REQ_MAKE_ENCHANT.setArguments(self,type,id,idx,arg)
	self.type = type  -- {1背包2装备栏}
	self.id = id  -- {主将0|武将ID}
	self.idx = idx  -- {物品idx}
	self.arg = arg  -- {1:金元附魔 0:普通附魔}
end

-- {1背包2装备栏}
function REQ_MAKE_ENCHANT.setType(self, type)
	self.type = type
end
function REQ_MAKE_ENCHANT.getType(self)
	return self.type
end

-- {主将0|武将ID}
function REQ_MAKE_ENCHANT.setId(self, id)
	self.id = id
end
function REQ_MAKE_ENCHANT.getId(self)
	return self.id
end

-- {物品idx}
function REQ_MAKE_ENCHANT.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAKE_ENCHANT.getIdx(self)
	return self.idx
end

-- {1:金元附魔 0:普通附魔}
function REQ_MAKE_ENCHANT.setArg(self, arg)
	self.arg = arg
end
function REQ_MAKE_ENCHANT.getArg(self)
	return self.arg
end
